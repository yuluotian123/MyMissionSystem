using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace MyMission.Rendering.Editor
{
    public static class RelinkReferenceSceneTools
    {
        public const string ScenePath = RelinkSceneTools.Root + "/RelinkMaterialReference.unity";
        private const string MaterialRoot = RelinkSceneTools.Root + "/Reference";

        [MenuItem("Tools/Relink SRP/4 - Build Material Reference Scene")]
        public static void Build()
        {
            Directory.CreateDirectory(MaterialRoot);
            AssetDatabase.Refresh();
            Scene previous = SceneManager.GetActiveScene();
            Scene scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Additive);
            SceneManager.SetActiveScene(scene);
            try
            {
                var camera = new GameObject("Main Camera").AddComponent<Camera>();
                camera.tag = "MainCamera";
                camera.transform.position = new Vector3(8, 5.5f, -12);
                camera.transform.LookAt(new Vector3(0, 2.8f, 1));
                camera.fieldOfView = 48; camera.nearClipPlane = 0.1f; camera.farClipPlane = 100;
                camera.clearFlags = CameraClearFlags.SolidColor;
                camera.backgroundColor = new Color(0.14f, 0.18f, 0.23f);
                var sun = new GameObject("Reference directional light").AddComponent<Light>();
                sun.type = LightType.Directional; sun.intensity = 3; sun.color = new Color(1, 0.94f, 0.82f);
                sun.transform.rotation = Quaternion.Euler(28, -22, 0); sun.shadows = LightShadows.Soft;
                RenderSettings.sun = sun;
                float[] metal = { 0, 0.5f, 1, 1 };
                float[] rough = { 0.9f, 0.4f, 0.08f };
                int[] stencil = { 1, 2, 5, 129 };
                for (int row = 0; row < rough.Length; row++)
                for (int column = 0; column < metal.Length; column++)
                {
                    var material = GetMaterial("M" + column + "_R" + row, new Color(0.82f, 0.57f, 0.3f));
                    material.SetFloat("_Metallic", metal[column]);
                    material.SetFloat("_Smoothness", 1 - rough[row]);
                    material.SetFloat("_MaterialClass", stencil[column]);
                    material.SetFloat("_MaterialFlags", column == 3 ? 64 : 0);
                    EditorUtility.SetDirty(material);
                    var sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                    sphere.name = "Metal=" + metal[column] + " Rough=" + rough[row] + " Stencil=" + stencil[column]
                        + (column == 3 ? " Flag64 forces nonmetal" : "");
                    sphere.transform.position = new Vector3((column - 1.5f) * 2.2f, 1 + row * 2.1f, 1);
                    sphere.transform.localScale = Vector3.one * 1.7f;
                    sphere.GetComponent<Renderer>().sharedMaterial = material;
                }
                var floor = GameObject.CreatePrimitive(PrimitiveType.Cube);
                floor.name = "Shadow receiver";
                floor.transform.position = new Vector3(0, -0.2f, 2);
                floor.transform.localScale = new Vector3(14, 0.4f, 10);
                floor.GetComponent<Renderer>().sharedMaterial = GetMaterial("Receiver", new Color(0.45f, 0.48f, 0.5f));
                string texturePath = MaterialRoot + "/CutoutPattern.asset";
                var pattern = AssetDatabase.LoadAssetAtPath<Texture2D>(texturePath);
                if (pattern == null)
                {
                    pattern = new Texture2D(8, 8, TextureFormat.RGBA32, false);
                    pattern.name = "Cutout pattern"; pattern.filterMode = FilterMode.Point;
                    for (int y = 0; y < 8; y++) for (int x = 0; x < 8; x++)
                        pattern.SetPixel(x, y, new Color(0.55f, 0.8f, 0.3f, (x + y) % 2));
                    pattern.Apply(); AssetDatabase.CreateAsset(pattern, texturePath);
                }
                var cutout = GetMaterial("Cutout", Color.white);
                cutout.SetTexture("_BaseMap", pattern); cutout.SetFloat("_AlphaClip", 1);
                cutout.SetFloat("_Cull", 0); cutout.SetFloat("_MaterialClass", 3);
                EditorUtility.SetDirty(cutout);
                var leaf = GameObject.CreatePrimitive(PrimitiveType.Quad);
                leaf.name = "Two sided alpha cutout - same depth and shadow silhouette";
                leaf.transform.position = new Vector3(-5.3f, 2, -0.5f);
                leaf.transform.localScale = new Vector3(1.5f, 3, 1);
                leaf.GetComponent<Renderer>().sharedMaterial = cutout;
                EditorSceneManager.SaveScene(scene, ScenePath);
                AssetDatabase.SaveAssets();
            }
            finally
            {
                SceneManager.SetActiveScene(previous);
                EditorSceneManager.CloseScene(scene, true);
            }
            Debug.Log("Relink material reference scene: " + ScenePath);
        }

        [MenuItem("Tools/Relink SRP/5 - Open Material Reference Scene")]
        public static void Open()
        {
            if (!File.Exists(ScenePath)) Build();
            if (!EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo()) return;
            RelinkSceneTools.EnablePipeline();
            EditorSceneManager.OpenScene(ScenePath);
        }

        private static Material GetMaterial(string name, Color color)
        {
            string path = MaterialRoot + "/" + name + ".mat";
            var material = AssetDatabase.LoadAssetAtPath<Material>(path);
            if (material == null)
            {
                material = new Material(Shader.Find("Relink/Environment")) { name = name };
                AssetDatabase.CreateAsset(material, path);
            }
            material.SetColor("_BaseColor", color);
            return material;
        }
    }
}
