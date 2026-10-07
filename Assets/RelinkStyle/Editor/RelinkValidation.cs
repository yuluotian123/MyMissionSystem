using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;

namespace MyMission.Rendering.Editor
{
    /// <summary>Run only in a disposable validation project using -executeMethod ...Run.</summary>
    public static class RelinkValidation
    {
        private static int frames;
        private static bool busy;
        public static void Run()
        {
            try
            {
                PlayerSettings.colorSpace = ColorSpace.Linear;
                EditorSceneManager.SaveScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene(), "Assets/ValidationBootstrap.unity");
                RelinkSceneTools.BuildDemo();
                RelinkReferenceSceneTools.Build();
                EditorSceneManager.OpenScene(RelinkSceneTools.ScenePath);
                ValidateDemoSetup();
                EditorApplication.update += Tick;
            }
            catch (Exception exception) { Debug.LogException(exception); EditorApplication.Exit(1); }
        }

        private static void ValidateDemoSetup()
        {
            var asset = AssetDatabase.LoadAssetAtPath<RelinkRenderPipelineAsset>(RelinkSceneTools.PipelinePath);
            // Reproduce a scene-file double-click with the wrong global pipeline and a stale debug mode.
            GraphicsSettings.defaultRenderPipeline = null;
            QualitySettings.renderPipeline = null;
            asset.renderingPath = RelinkRenderingPath.PrototypeForward;
            asset.debugView = 6;
            if (!RelinkDemoSceneSetup.ConfigureOpenDemo(true)
                || GraphicsSettings.defaultRenderPipeline != asset || QualitySettings.renderPipeline != asset
                || asset.renderingPath != RelinkRenderingPath.EvidenceDeferred || asset.debugView != 0)
                throw new Exception("Demo scene setup did not select the deferred SRP and final view.");
            Debug.Log("RELINK_DEMO_SETUP_PASS Graphics + Quality + deferred path + final view");
        }

        private static void Tick()
        {
            if (busy || ++frames < 20) return;
            busy = true;
            EditorApplication.update -= Tick;
            try
            {
                Directory.CreateDirectory("Validation");
                var camera = Camera.main;
                var pipeline = (RelinkRenderPipelineAsset)GraphicsSettings.defaultRenderPipeline;
                Debug.Log("RELINK_CAMERA " + camera.transform.position + " forward=" + camera.transform.forward
                    + " renderers=" + UnityEngine.Object.FindObjectsByType<MeshRenderer>(FindObjectsSortMode.None).Length);
                pipeline.debugView = 2; Capture(camera, "DiagnosticNormals", false);
                pipeline.debugView = 3; Capture(camera, "DiagnosticDepth", false);
                pipeline.debugView = 1; Capture(camera, "DiagnosticHDR", false);
                pipeline.debugView = 0;
                Color[] baseline = Capture(camera, "Environment");
                float shadowStrength = RenderSettings.sun.shadowStrength;
                RenderSettings.sun.shadowStrength = 0;
                RequireDifference(baseline, Capture(camera, "NoShadows"), "directional shadows", 0.00001f);
                RenderSettings.sun.shadowStrength = shadowStrength;
                float density = pipeline.fogDensity;
                pipeline.fogDensity = 0;
                RequireDifference(baseline, Capture(camera, "NoFog"), "atmospheric fog", 0.0001f);
                pipeline.fogDensity = density;
                float intensity = RenderSettings.sun.intensity;
                RenderSettings.sun.intensity = 0;
                RequireDifference(baseline, Capture(camera, "NoSun"), "sun lighting", 0.001f);
                RenderSettings.sun.intensity = intensity;
                pipeline.debugView = 2; Capture(camera, "Normals");
                pipeline.debugView = 3; Capture(camera, "Depth");
                pipeline.debugView = 0;
                if (pipeline.renderingPath == RelinkRenderingPath.EvidenceDeferred)
                {
                    foreach (int view in new[] { 5, 6, 7, 8, 9, 10, 11, 12 })
                    {
                        pipeline.debugView = view;
                        Capture(camera, "DeferredView" + view, false);
                    }
                    pipeline.debugView = 0;
                    RelinkDeferredValidation.Validate(pipeline);
                    EditorSceneManager.OpenScene(RelinkReferenceSceneTools.ScenePath);
                    Capture(Camera.main, "MaterialReference");
                    EditorSceneManager.OpenScene(RelinkSceneTools.ScenePath);
                    pipeline.renderingPath = RelinkRenderingPath.PrototypeForward;
                    try { Capture(Camera.main, "PrototypeForward"); }
                    finally { pipeline.renderingPath = RelinkRenderingPath.EvidenceDeferred; }
                }
                foreach (string name in new[] { "Relink/Environment", "Relink/Painted Sky", "Hidden/Relink/Composite", "Hidden/Relink/Deferred" })
                {
                    var shader = Shader.Find(name);
                    if (shader == null || !shader.isSupported) throw new Exception("Unsupported shader: " + name);
                    var errors = ShaderUtil.GetShaderMessages(shader).Where(m => m.severity.ToString() == "Error").ToArray();
                    if (errors.Length > 0) throw new Exception(name + ": " + string.Join("\n", errors.Select(e => e.message)));
                }
                AssetDatabase.SaveAssets();
                File.WriteAllText("Validation/result.txt", "PASS: shaders, image sanity, shadows, sun, fog, prototype regression; deferred numeric contract in contract.txt. GPU: " + SystemInfo.graphicsDeviceName);
                Debug.Log("RELINK_VALIDATION_PASS " + SystemInfo.graphicsDeviceName);
                EditorApplication.Exit(0);
            }
            catch (Exception exception)
            {
                File.WriteAllText("Validation/result.txt", exception.ToString());
                Debug.LogException(exception);
                EditorApplication.Exit(1);
            }
        }

        private static Color[] Capture(Camera camera, string name, bool requireVariance = true)
        {
            var target = new RenderTexture(1280, 720, 24, RenderTextureFormat.ARGB32);
            target.Create();
            RenderTexture oldActive = RenderTexture.active;
            RenderTexture oldTarget = camera.targetTexture;
            var texture = new Texture2D(1280, 720, TextureFormat.RGB24, false);
            try
            {
                camera.targetTexture = target;
                RenderPipeline.SubmitRenderRequest(camera, new RenderPipeline.StandardRequest { destination = target });
                RenderTexture.active = target;
                texture.ReadPixels(new Rect(0, 0, 1280, 720), 0, 0);
                texture.Apply();
                Color[] pixels = texture.GetPixels();
                int magenta = pixels.Count(c => c.r > 0.9f && c.b > 0.9f && c.g < 0.1f);
                if (magenta > pixels.Length / 100) throw new Exception("Shader-error pixels in " + name);
                float mean = pixels.Average(c => c.grayscale);
                float variance = pixels.Average(c => (c.grayscale - mean) * (c.grayscale - mean));
                File.WriteAllBytes("Validation/" + name + ".png", texture.EncodeToPNG());
                Debug.Log("RELINK_IMAGE " + name + " mean=" + mean + " variance=" + variance);
                if (requireVariance && variance < 0.0001f) throw new Exception("Blank render: " + name);
                return pixels;
            }
            finally
            {
                camera.targetTexture = oldTarget;
                RenderTexture.active = oldActive;
                UnityEngine.Object.DestroyImmediate(texture);
                target.Release();
                UnityEngine.Object.DestroyImmediate(target);
            }
        }

        private static void RequireDifference(Color[] a, Color[] b, string label, float threshold)
        {
            double difference = 0;
            for (int i = 0; i < a.Length; i++)
                difference += Math.Abs(a[i].r - b[i].r) + Math.Abs(a[i].g - b[i].g) + Math.Abs(a[i].b - b[i].b);
            difference /= a.Length * 3;
            Debug.Log("RELINK_CHECK " + label + " mean delta=" + difference);
            if (difference < threshold) throw new Exception("No visible effect from " + label);
        }
    }
}
