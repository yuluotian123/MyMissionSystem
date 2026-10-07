using System;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace MyMission.Rendering.Editor
{
    /// <summary>GPU integration checks against fixed texture bytes, projection and a CPU BRDF oracle.</summary>
    public static class RelinkDeferredValidation
    {
        private static readonly StringBuilder report = new StringBuilder();

        public static void Validate(RelinkRenderPipelineAsset pipeline)
        {
            Scene previous = SceneManager.GetActiveScene();
            Scene fixture = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Additive);
            SceneManager.SetActiveScene(fixture);
            var camera = new GameObject("Contract camera").AddComponent<Camera>();
            camera.transform.position = new Vector3(1000, 1000, 995);
            camera.orthographic = true;
            camera.orthographicSize = 1;
            camera.aspect = 1;
            camera.nearClipPlane = 0.1f;
            camera.farClipPlane = 20;
            camera.clearFlags = CameraClearFlags.SolidColor;
            var sun = new GameObject("Contract sun").AddComponent<Light>();
            sun.type = LightType.Directional;
            sun.intensity = 2;
            sun.color = Color.white;
            sun.shadows = LightShadows.None;
            RenderSettings.sun = sun;
            var quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
            quad.name = "Known albedo, mask and stencil";
            quad.transform.position = new Vector3(1000, 1000, 1000);
            var material = new Material(pipeline.environmentShader);
            material.SetFloat("_Cull", 0);
            material.SetFloat("_BumpScale", 0);
            material.SetFloat("_MaterialClass", 129); // Low class 1 plus bit-7 offset 9 = category 10.
            material.SetFloat("_UseMaskMap", 1);
            var albedo = new Texture2D(1, 1, TextureFormat.RGBA32, false, false);
            albedo.SetPixel(0, 0, new Color32(128, 64, 192, 255)); albedo.Apply();
            var mask = new Texture2D(1, 1, TextureFormat.RGBA32, false, true);
            mask.SetPixel(0, 0, new Color32(64, 153, 102, 0)); mask.Apply();
            material.SetTexture("_BaseMap", albedo);
            material.SetTexture("_MaskMap", mask);
            quad.GetComponent<Renderer>().sharedMaterial = material;
            float fog = pipeline.fogDensity, bloom = pipeline.bloomIntensity, exposure = pipeline.exposure;
            bool indirect = pipeline.indirectLighting, locals = pipeline.localLights;
            int classMask = pipeline.directionalLightClassMask;
            Texture2D previousSubtract = pipeline.subtractLightTexture;
            var subtract = new Texture2D(1, 1, TextureFormat.RGBAFloat, false, true);
            try
            {
                report.Clear();
                report.AppendLine("GPU: " + SystemInfo.graphicsDeviceName + " / " + SystemInfo.graphicsDeviceType);
                pipeline.fogDensity = pipeline.bloomIntensity = pipeline.exposure = 0;
                pipeline.indirectLighting = pipeline.localLights = false;
                pipeline.directionalLightClassMask = 1 << 10;
                pipeline.subtractLightTexture = null;
                Color expectedAlbedo = new Color(128 / 255f, 64 / 255f, 192 / 255f).linear;
                Check("sRGB albedo decoded once", Sample(camera, pipeline, 5), expectedAlbedo, 0.002f);
                Check("linear mask M/R/indirect", Sample(camera, pipeline, 6), new Color(64 / 255f, 153 / 255f, 102 / 255f), 0.002f);
                Check("view-space normal", Sample(camera, pipeline, 2), new Color(0.5f, 0.5f, 1), 0.003f);
                Check("linear depth at 5 units", Sample(camera, pipeline, 3), new Color(0.05f, 0.05f, 0.05f), 0.001f);
                Check("sampled hardware stencil category 10", Sample(camera, pipeline, 8), Color.white * (10f / 24), 0.0001f);
                Check("static camera UV velocity", Sample(camera, pipeline, 7), new Color(0.5f, 0.5f, 0.5f), 0.0001f);
                Color oracle = DirectionalOracle(camera, expectedAlbedo, 64 / 255.0, 153 / 255.0, 2);
                Check("captured directional BRDF (R11/G11/B10 precision)", Sample(camera, pipeline, 9), oracle, Mathf.Max(0.003f, oracle.b / 32));
                pipeline.directionalLightClassMask = 1 << 1;
                Check("stencil category light exclusion", Sample(camera, pipeline, 9), Color.black, 0.0001f);
                pipeline.directionalLightClassMask = 1 << 10;
                material.SetFloat("_MaterialFlags", 64);
                Color nonmetal = expectedAlbedo * (2 / Mathf.PI);
                Check("flag 64 forces nonmetal (B10 mantissa step)", Sample(camera, pipeline, 9), nonmetal, Mathf.Max(0.003f, nonmetal.b / 32));
                Check("flag byte survives sRGB alpha", Sample(camera, pipeline, 12), Color.white * (64 / 255f), 0.0001f);
                subtract.SetPixel(0, 0, new Color(0.5f, 1, 3, 0)); subtract.Apply();
                pipeline.subtractLightTexture = subtract;
                Color subtracted = new Color(expectedAlbedo.r * 1.5f / Mathf.PI, expectedAlbedo.g / Mathf.PI, 0);
                Check("subtract-light input and zero clamp", Sample(camera, pipeline, 9), subtracted, 0.003f);
                pipeline.subtractLightTexture = null;
                Color direct = Sample(camera, pipeline, 9);
                Color curve = new Color(Filmic(direct.r), Filmic(direct.g), Filmic(direct.b));
                Check("captured filmic without double sRGB", Sample(camera, pipeline, 0), curve, 0.003f);
                Sample(camera, pipeline, 7);
                camera.transform.position += new Vector3(0.1f, 0, 0);
                Check("camera translation velocity sign and scale", Sample(camera, pipeline, 7), new Color(-0.5f, 0.5f, 0.5f), 0.004f);
                Check("static camera after translation", Sample(camera, pipeline, 7), new Color(0.5f, 0.5f, 0.5f), 0.0001f);
                Check("resize invalidates velocity history", Sample(camera, pipeline, 7, 64), new Color(0.5f, 0.5f, 0.5f), 0.0001f);
                ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
                Check("explicit camera cut resets velocity history", Sample(camera, pipeline, 7, 64), new Color(0.5f, 0.5f, 0.5f), 0.0001f);
                // A discarded leaf must disappear from every MRT, depth and stencil together.
                material.SetFloat("_AlphaClip", 1); material.SetFloat("_Cutoff", 0.5f);
                albedo.SetPixel(0, 0, new Color32(128, 64, 192, 0)); albedo.Apply();
                Check("alpha cutout clears depth and classification", Sample(camera, pipeline, 8), Color.black, 0.0001f);
                report.AppendLine("PASS: 17 numeric GPU contract checks.");
                File.WriteAllText("Validation/contract.txt", report.ToString());
                Debug.Log("RELINK_DEFERRED_CONTRACT_PASS\n" + report);
            }
            catch
            {
                File.WriteAllText("Validation/contract.txt", report.ToString());
                throw;
            }
            finally
            {
                pipeline.fogDensity = fog; pipeline.bloomIntensity = bloom; pipeline.exposure = exposure;
                pipeline.indirectLighting = indirect; pipeline.localLights = locals;
                pipeline.directionalLightClassMask = classMask; pipeline.debugView = 0;
                pipeline.subtractLightTexture = previousSubtract;
                SceneManager.SetActiveScene(previous);
                EditorSceneManager.CloseScene(fixture, true);
                Object.DestroyImmediate(material); Object.DestroyImmediate(albedo); Object.DestroyImmediate(mask);
                Object.DestroyImmediate(subtract);
            }
        }

        private static Color Sample(Camera camera, RelinkRenderPipelineAsset pipeline, int view, int size = 32)
        {
            pipeline.debugView = view;
            var target = new RenderTexture(size, size, 0, RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
            target.Create();
            var texture = new Texture2D(size, size, TextureFormat.RGBAFloat, false, true);
            RenderTexture previous = RenderTexture.active;
            try
            {
                RenderPipeline.SubmitRenderRequest(camera, new RenderPipeline.StandardRequest { destination = target });
                RenderTexture.active = target;
                texture.ReadPixels(new Rect(0, 0, size, size), 0, 0); texture.Apply();
                return texture.GetPixel(size / 2, size / 2);
            }
            finally
            {
                RenderTexture.active = previous;
                Object.DestroyImmediate(texture); target.Release(); Object.DestroyImmediate(target);
            }
        }

        private static Color DirectionalOracle(Camera camera, Color albedo, double metal, double rough, double light)
        {
            // Pixel center is 1/32 units from the orthographic axis in X/Y, surface distance 5.
            var view = new Vector3(-1 / 32f, 1 / 32f, -5).normalized;
            var n = Vector3.back; var l = Vector3.back; var h = (view + l).normalized;
            double nh = Vector3.Dot(n, h), lh = Vector3.Dot(l, h);
            double r4 = Math.Pow(rough, 4), d = nh * nh * (r4 - 1) + 1;
            double spec = r4 / (4 * Math.PI * (rough + 0.5) * Math.Pow(lh * d, 2));
            return albedo * (float)(light * ((1 - metal) / Math.PI + metal * spec));
        }

        private static float Filmic(double x) => (float)Math.Max(0, Math.Min(1,
            ((x * (0.15 * x + 0.05) + 0.004) / (x * (0.15 * x + 0.5) + 0.06) - 1.0 / 15) * 1.379064));

        private static void Check(string name, Color actual, Color expected, float tolerance)
        {
            float error = Mathf.Max(Mathf.Abs(actual.r - expected.r), Mathf.Abs(actual.g - expected.g), Mathf.Abs(actual.b - expected.b));
            report.AppendLine(name + ": actual=" + actual + " expected=" + expected + " max error=" + error);
            if (float.IsNaN(error) || float.IsInfinity(error) || error > tolerance)
                throw new Exception("Deferred contract failed: " + name + " error=" + error);
        }
    }
}
