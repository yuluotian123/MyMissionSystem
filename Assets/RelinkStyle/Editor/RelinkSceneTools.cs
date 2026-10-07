using System;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace MyMission.Rendering.Editor
{
    public static class RelinkSceneTools
    {
        public const string Root = "Assets/RelinkStyle/Generated";
        public const string ScenePath = Root + "/RelinkEnvironment.unity";
        public const string PipelinePath = Root + "/RelinkScenePipeline.asset";
        private const string BackupPath = "ProjectSettings/RelinkPipelineBackup.json";
        [Serializable] private sealed class Backup { public string pipeline; public string qualityPipeline; public int quality; }

        [MenuItem("Tools/Relink SRP/1 - Build Environment Demo")]
        public static void BuildDemo()
        {
            Directory.CreateDirectory(Root + "/Materials");
            Directory.CreateDirectory(Root + "/Meshes");
            AssetDatabase.Refresh();
            var pipeline = AssetDatabase.LoadAssetAtPath<RelinkRenderPipelineAsset>(PipelinePath);
            if (pipeline == null)
            {
                pipeline = ScriptableObject.CreateInstance<RelinkRenderPipelineAsset>();
                AssetDatabase.CreateAsset(pipeline, PipelinePath);
            }
            pipeline.environmentShader = Shader.Find("Relink/Environment");
            pipeline.compositeShader = Shader.Find("Hidden/Relink/Composite");
            pipeline.deferredShader = Shader.Find("Hidden/Relink/Deferred");
            if (pipeline.environmentShader == null || pipeline.compositeShader == null || pipeline.deferredShader == null)
                throw new InvalidOperationException("Relink shaders have not imported yet.");
            EditorUtility.SetDirty(pipeline);
            var stone = Material("Limestone", new Color(0.74f, 0.67f, 0.53f));
            var pale = Material("Sunlit plaster", new Color(0.89f, 0.82f, 0.66f));
            var grass = Material("Meadow", new Color(0.4f, 0.56f, 0.25f));
            var leaf = Material("Foliage", new Color(0.32f, 0.49f, 0.2f));
            leaf.SetFloat("_Transmission", 0.65f);
            var bark = Material("Bark", new Color(0.29f, 0.23f, 0.17f));
            var blue = Material("Blue slate", new Color(0.2f, 0.37f, 0.47f));
            var distant = Material("Distant rock", new Color(0.38f, 0.48f, 0.54f));
            var gold = Material("Brass", new Color(0.78f, 0.52f, 0.21f));
            gold.SetFloat("_Metallic", 0.65f);
            gold.SetFloat("_Smoothness", 0.7f);
            var sky = AssetDatabase.LoadAssetAtPath<Material>(Root + "/Materials/Painted sky.mat");
            if (sky == null)
            {
                sky = new Material(Shader.Find("Relink/Painted Sky"));
                AssetDatabase.CreateAsset(sky, Root + "/Materials/Painted sky.mat");
            }
            var previous = SceneManager.GetActiveScene();
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Additive);
            SceneManager.SetActiveScene(scene);
            try
            {
                RenderSettings.skybox = sky;
                RenderSettings.ambientMode = AmbientMode.Trilight;
                RenderSettings.ambientSkyColor = new Color(0.28f, 0.4f, 0.5f);
                RenderSettings.ambientEquatorColor = new Color(0.18f, 0.21f, 0.22f);
                RenderSettings.ambientGroundColor = new Color(0.12f, 0.1f, 0.08f);
                RenderSettings.fog = false;
                var sun = new GameObject("Sun - warm afternoon").AddComponent<Light>();
                sun.type = LightType.Directional;
                sun.color = new Color(1, 0.9f, 0.73f);
                sun.intensity = 1.65f;
                sun.shadows = LightShadows.Soft;
                sun.transform.rotation = Quaternion.Euler(43, -32, 0);
                RenderSettings.sun = sun;
                var camera = new GameObject("Main Camera").AddComponent<Camera>();
                camera.tag = "MainCamera";
                camera.transform.position = new Vector3(17, 10, -22);
                camera.transform.LookAt(new Vector3(0, 3, 10));
                camera.fieldOfView = 52;
                camera.farClipPlane = 500;
                camera.nearClipPlane = 0.2f;
                camera.clearFlags = CameraClearFlags.Skybox;
                camera.allowHDR = true;
                Primitive("Meadow island", PrimitiveType.Cube, new Vector3(0, -1, 9), new Vector3(43, 2, 54), grass);
                Primitive("Courtyard", PrimitiveType.Cube, new Vector3(0, 0.06f, 8), new Vector3(12, 0.14f, 28), stone);
                for (int i = 0; i < 9; i++)
                {
                    Primitive("Walkway slab", PrimitiveType.Cube, new Vector3(0, 0.18f, -4 + i * 3), new Vector3(5.4f, 0.16f, 2.8f), pale);
                }
                for (int side = -1; side <= 1; side += 2)
                {
                    for (int i = 0; i < 4; i++)
                    {
                        Vector3 p = new Vector3(side * 6, 0, 2 + i * 5.5f);
                        Primitive("Column base", PrimitiveType.Cube, p + Vector3.up * 0.35f, new Vector3(1.6f, 0.7f, 1.6f), pale);
                        Primitive("Column shaft", PrimitiveType.Cylinder, p + Vector3.up * 3.1f, new Vector3(0.95f, 2.4f, 0.95f), stone);
                        Primitive("Column capital", PrimitiveType.Cube, p + Vector3.up * 5.7f, new Vector3(1.7f, 0.55f, 1.7f), pale);
                        Primitive("Colonnade lintel", PrimitiveType.Cube, p + new Vector3(0, 6.15f, 1.5f), new Vector3(1.25f, 0.45f, 5.6f), pale);
                    }
                }
                Primitive("Sanctuary", PrimitiveType.Cube, new Vector3(0, 3, 24), new Vector3(11, 6, 5), pale);
                Primitive("Sanctuary roof", PrimitiveType.Cube, new Vector3(0, 6.5f, 24), new Vector3(12.5f, 1, 6.5f), blue);
                Primitive("Entrance shade", PrimitiveType.Cube, new Vector3(0, 2.2f, 21.4f), new Vector3(3.1f, 4.4f, 0.2f), blue);
                Primitive("Entrance crest", PrimitiveType.Sphere, new Vector3(0, 5.3f, 21.2f), new Vector3(0.9f, 0.9f, 0.22f), gold);
                for (int i = 0; i < 16; i++)
                {
                    float x = (i % 2 == 0 ? -1 : 1) * (10 + (i % 3) * 3.4f);
                    float z = -3 + (i / 2) * 5;
                    Tree(new Vector3(x, 0, z), 0.85f + (i % 4) * 0.17f, bark, leaf);
                }
                for (int i = 0; i < 12; i++)
                {
                    var rock = Primitive("Floating distant island", PrimitiveType.Sphere,
                        new Vector3(-90 + i * 17, -8 + (i % 4) * 4, 75 + (i % 3) * 24),
                        new Vector3(18 + i % 3 * 8, 27 + i % 4 * 7, 20), distant);
                    rock.transform.rotation = Quaternion.Euler(i * 17, i * 39, 12);
                }
                var fill = new GameObject("Entrance bounce - point").AddComponent<Light>();
                fill.type = LightType.Point; fill.range = 12; fill.intensity = 9;
                fill.color = new Color(1, 0.68f, 0.3f); fill.transform.position = new Vector3(0, 3, 19);
                EditorSceneManager.SaveScene(scene, ScenePath);
            }
            finally
            {
                EditorSceneManager.CloseScene(scene, true);
                if (previous.IsValid()) SceneManager.SetActiveScene(previous);
                AssetDatabase.SaveAssets();
            }
            Debug.Log("Relink SRP: demo generated at " + ScenePath);
        }

        private static Material Material(string name, Color color)
        {
            string path = Root + "/Materials/" + name + ".mat";
            var material = AssetDatabase.LoadAssetAtPath<Material>(path);
            if (material != null) return material;
            material = new Material(Shader.Find("Relink/Environment")) { name = name };
            material.SetColor("_BaseColor", color);
            AssetDatabase.CreateAsset(material, path);
            return material;
        }

        private static GameObject Primitive(string name, PrimitiveType type, Vector3 position, Vector3 scale, Material material)
        {
            var go = GameObject.CreatePrimitive(type);
            go.name = name; go.transform.position = position; go.transform.localScale = scale;
            go.GetComponent<Renderer>().sharedMaterial = material;
            Object.DestroyImmediate(go.GetComponent<Collider>());
            return go;
        }

        private static void Tree(Vector3 position, float scale, Material bark, Material leaf)
        {
            var parent = new GameObject("Painted tree"); parent.transform.position = position;
            var trunk = Primitive("Trunk", PrimitiveType.Cylinder, position + Vector3.up * 2.5f * scale,
                new Vector3(0.55f, 2.5f, 0.55f) * scale, bark);
            trunk.transform.SetParent(parent.transform, true);
            for (int i = 0; i < 5; i++)
            {
                float angle = i * 2.4f;
                var crown = Primitive("Leaf volume", PrimitiveType.Sphere,
                    position + new Vector3(Mathf.Cos(angle) * 1.3f, 5 + i % 2, Mathf.Sin(angle) * 1.3f) * scale,
                    new Vector3(3.7f, 3.0f, 3.3f) * scale, leaf);
                crown.transform.SetParent(parent.transform, true);
            }
        }

        [MenuItem("Tools/Relink SRP/2 - Enable Pipeline")]
        public static void EnablePipeline()
        {
            var asset = AssetDatabase.LoadAssetAtPath<RelinkRenderPipelineAsset>(PipelinePath);
            if (asset == null) { BuildDemo(); asset = AssetDatabase.LoadAssetAtPath<RelinkRenderPipelineAsset>(PipelinePath); }
            if (!File.Exists(BackupPath))
            {
                var backup = new Backup
                {
                    pipeline = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(GraphicsSettings.defaultRenderPipeline)),
                    qualityPipeline = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(QualitySettings.renderPipeline)),
                    quality = QualitySettings.GetQualityLevel()
                };
                File.WriteAllText(BackupPath, JsonUtility.ToJson(backup, true));
            }
            GraphicsSettings.defaultRenderPipeline = asset;
            QualitySettings.renderPipeline = asset;
            Debug.Log("Relink SRP enabled for the current quality level. Previous pipeline saved to " + BackupPath);
        }

        [MenuItem("Tools/Relink SRP/3 - Open Environment Demo")]
        public static void OpenDemo()
        {
            if (!File.Exists(ScenePath)) BuildDemo();
            if (!EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo()) return;
            EnablePipeline();
            EditorSceneManager.OpenScene(ScenePath);
        }

        [MenuItem("Tools/Relink SRP/Restore Previous Pipeline")]
        public static void RestorePipeline()
        {
            if (!File.Exists(BackupPath)) { Debug.LogWarning("No saved Relink pipeline backup."); return; }
            var backup = JsonUtility.FromJson<Backup>(File.ReadAllText(BackupPath));
            GraphicsSettings.defaultRenderPipeline = AssetDatabase.LoadAssetAtPath<RenderPipelineAsset>(AssetDatabase.GUIDToAssetPath(backup.pipeline));
            int quality = QualitySettings.GetQualityLevel();
            QualitySettings.SetQualityLevel(backup.quality, false);
            QualitySettings.renderPipeline = AssetDatabase.LoadAssetAtPath<RenderPipelineAsset>(AssetDatabase.GUIDToAssetPath(backup.qualityPipeline));
            QualitySettings.SetQualityLevel(quality, false);
            File.Delete(BackupPath);
        }

        [MenuItem("Tools/Relink SRP/Create SRP Copy of Current Scene")]
        public static void ConvertSceneCopy()
        {
            Scene current = SceneManager.GetActiveScene();
            Directory.CreateDirectory(Root + "/ConvertedMaterials");
            AssetDatabase.Refresh();
            string path = AssetDatabase.GenerateUniqueAssetPath(Root + "/" + current.name + "_Relink.unity");
            if (!EditorSceneManager.SaveScene(current, path, true)) return;
            var copy = EditorSceneManager.OpenScene(path, OpenSceneMode.Additive);
            var converted = new Dictionary<Material, Material>();
            try
            {
                foreach (var root in copy.GetRootGameObjects())
                foreach (var renderer in root.GetComponentsInChildren<Renderer>(true))
                {
                    if (!(renderer is MeshRenderer) && !(renderer is SkinnedMeshRenderer)) continue;
                    var materials = renderer.sharedMaterials;
                    for (int i = 0; i < materials.Length; i++)
                    {
                        Material source = materials[i];
                        if (source == null || source.shader.name.StartsWith("Relink/")) continue;
                        if (!converted.TryGetValue(source, out var replacement))
                        {
                            replacement = ConvertMaterial(source);
                            AssetDatabase.CreateAsset(replacement, AssetDatabase.GenerateUniqueAssetPath(Root + "/ConvertedMaterials/" + source.name.Replace('/', '_') + ".mat"));
                            converted.Add(source, replacement);
                        }
                        materials[i] = replacement;
                    }
                    Undo.RecordObject(renderer, "Assign Relink scene materials");
                    renderer.sharedMaterials = materials;
                }
                SceneManager.SetActiveScene(copy);
                RenderSettings.skybox = AssetDatabase.LoadAssetAtPath<Material>(Root + "/Materials/Painted sky.mat");
                EditorSceneManager.SaveScene(copy);
            }
            finally
            {
                EditorSceneManager.CloseScene(copy, true);
                SceneManager.SetActiveScene(current);
                AssetDatabase.SaveAssets();
            }
            Debug.Log("Relink scene copy created: " + path + ". Mesh materials converted: " + converted.Count + ". Terrain, particles, sprites and custom shader effects need dedicated adapters.");
        }

        public static Material ConvertMaterial(Material source)
        {
            var result = new Material(Shader.Find("Relink/Environment")) { name = source.name + " Relink" };
            string textureName = source.HasProperty("_BaseMap") ? "_BaseMap" : "_MainTex";
            if (source.HasProperty(textureName))
            {
                result.SetTexture("_BaseMap", source.GetTexture(textureName));
                result.SetTextureScale("_BaseMap", source.GetTextureScale(textureName));
                result.SetTextureOffset("_BaseMap", source.GetTextureOffset(textureName));
            }
            string colorName = source.HasProperty("_BaseColor") ? "_BaseColor" : "_Color";
            if (source.HasProperty(colorName)) result.SetColor("_BaseColor", source.GetColor(colorName));
            foreach (string property in new[] { "_BumpMap", "_OcclusionMap" })
                if (source.HasProperty(property)) result.SetTexture(property, source.GetTexture(property));
            foreach (string property in new[] { "_BumpScale", "_OcclusionStrength", "_Smoothness", "_Metallic", "_AlphaClip", "_Cutoff", "_Cull" })
                if (source.HasProperty(property)) result.SetFloat(property, source.GetFloat(property));
            if (source.HasProperty("_EmissionColor") && source.IsKeywordEnabled("_EMISSION"))
                result.SetColor("_EmissionColor", source.GetColor("_EmissionColor"));
            bool cutout = source.IsKeywordEnabled("_ALPHATEST_ON") || source.GetTag("RenderType", false) == "TransparentCutout";
            if (cutout) { result.SetFloat("_AlphaClip", 1); result.renderQueue = (int)RenderQueue.AlphaTest; }
            bool transparent = source.renderQueue >= (int)RenderQueue.Transparent;
            if (transparent)
            {
                result.SetFloat("_SrcBlend", (float)BlendMode.SrcAlpha);
                result.SetFloat("_DstBlend", (float)BlendMode.OneMinusSrcAlpha);
                result.SetFloat("_ZWrite", 0);
                result.SetShaderPassEnabled("ShadowCaster", false);
                result.SetOverrideTag("RenderType", "Transparent");
                result.renderQueue = (int)RenderQueue.Transparent;
            }
            return result;
        }
    }
}
