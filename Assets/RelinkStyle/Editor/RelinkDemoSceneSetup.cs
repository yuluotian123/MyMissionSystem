using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace MyMission.Rendering.Editor
{
    /// <summary>Opening a generated demo must also select its SRP, including a Project-window double-click.</summary>
    [InitializeOnLoad]
    public static class RelinkDemoSceneSetup
    {
        private static bool pendingLiveCheck;

        static RelinkDemoSceneSetup()
        {
            if (Application.isBatchMode) return;
            EditorSceneManager.sceneOpened += OnSceneOpened;
            EditorApplication.delayCall += ConfigureAfterReload;
            RenderPipelineManager.endCameraRendering += OnCameraRendered;
        }

        private static bool IsDemo(Scene scene) => scene.IsValid() && scene.isLoaded
            && (scene.path == RelinkSceneTools.ScenePath || scene.path == RelinkReferenceSceneTools.ScenePath || scene.path == RelinkTownSceneTools.ScenePath);

        private static void OnSceneOpened(Scene scene, OpenSceneMode mode)
        {
            if (IsDemo(scene)) EditorApplication.delayCall += () => ConfigureOpenDemo(true);
        }

        private static void ConfigureAfterReload()
        {
            if (EditorApplication.isCompiling || EditorApplication.isUpdating)
            {
                EditorApplication.delayCall += ConfigureAfterReload;
                return;
            }
            ConfigureOpenDemo(false);
        }

        [MenuItem("Tools/Relink SRP/Show Current Demo Camera")]
        public static void ShowCamera() => ConfigureOpenDemo(true);

        public static bool ConfigureOpenDemo(bool showCamera)
        {
            Scene scene = SceneManager.GetActiveScene();
            if (!IsDemo(scene)) return false;
            string pipelinePath=scene.path==RelinkTownSceneTools.ScenePath?RelinkTownSceneTools.PipelinePath:RelinkSceneTools.PipelinePath;
            var asset = AssetDatabase.LoadAssetAtPath<RelinkRenderPipelineAsset>(pipelinePath);
            if (asset == null)
            {
                Debug.LogError("Relink demo pipeline asset is missing: " + RelinkSceneTools.PipelinePath);
                return false;
            }
            bool switched = GraphicsSettings.defaultRenderPipeline != asset || QualitySettings.renderPipeline != asset;
            bool changed = false;
            if (asset.environmentShader == null) { asset.environmentShader = Shader.Find("Relink/Environment"); changed = true; }
            if (asset.compositeShader == null) { asset.compositeShader = Shader.Find("Hidden/Relink/Composite"); changed = true; }
            if (asset.deferredShader == null) { asset.deferredShader = Shader.Find("Hidden/Relink/Deferred"); changed = true; }
            if ((showCamera || switched) && asset.renderingPath != RelinkRenderingPath.EvidenceDeferred)
            { asset.renderingPath = RelinkRenderingPath.EvidenceDeferred; changed = true; }
            if ((showCamera || switched) && asset.debugView != 0) { asset.debugView = 0; changed = true; }
            if (changed) { EditorUtility.SetDirty(asset); AssetDatabase.SaveAssetIfDirty(asset); }
            RelinkSceneTools.EnablePipeline(); // Includes the existing recoverable Graphics/Quality backup.
            GraphicsSettings.defaultRenderPipeline=asset;
            QualitySettings.renderPipeline=asset;

            Camera camera = scene.GetRootGameObjects().SelectMany(root => root.GetComponentsInChildren<Camera>(true))
                .FirstOrDefault(candidate => candidate.enabled && candidate.CompareTag("MainCamera"));
            if (!Application.isBatchMode)
            {
                pendingLiveCheck = true;
                if ((showCamera || switched) && camera != null)
                {
                    if (SceneView.lastActiveSceneView != null)
                    {
                        SceneView.lastActiveSceneView.sceneLighting = true;
                        SceneView.lastActiveSceneView.AlignViewToObject(camera.transform);
                    }
                    EditorApplication.ExecuteMenuItem("Window/General/Game");
                }
                UnityEditorInternal.InternalEditorUtility.RepaintAllViews();
            }
            Debug.Log("RELINK_DEMO_READY scene=" + scene.path + " pipeline=" + asset.name
                + " quality=" + QualitySettings.names[QualitySettings.GetQualityLevel()]
                + " camera=" + (camera != null ? camera.name : "missing") + " debug=" + asset.debugView);
            return camera != null;
        }

        private static void OnCameraRendered(ScriptableRenderContext context, Camera camera)
        {
            if (!pendingLiveCheck || camera.cameraType != CameraType.Game || !IsDemo(camera.gameObject.scene)
                || !(RenderPipelineManager.currentPipeline is RelinkRenderPipeline)) return;
            pendingLiveCheck = false;
            // Avoid a render request nested inside the normal camera callback.
            EditorApplication.delayCall += () => SaveLivePreview(camera);
        }

        [Serializable]
        private sealed class LiveStatus
        {
            public string project, scene, pipeline, graphicsAPI, gpu, preview, utc;
            public string renderingPath;
            public int debugView;
            public bool graphicsAndQualityMatch;
            public string[] shaderErrors;
        }

        private static void SaveLivePreview(Camera camera)
        {
            if (camera == null || !IsDemo(camera.gameObject.scene)
                || !(RenderPipelineManager.currentPipeline is RelinkRenderPipeline)) return;
            string directory = Path.Combine(Path.GetDirectoryName(Application.dataPath), "Temp", "RelinkDemoPreview");
            Directory.CreateDirectory(directory);
            var asset = (RelinkRenderPipelineAsset)GraphicsSettings.defaultRenderPipeline;
            var errors = new[] { asset.environmentShader, asset.compositeShader, asset.deferredShader, asset.temporalShader }
                .Where(shader => shader != null).SelectMany(shader => ShaderUtil.GetShaderMessages(shader))
                .Where(message => message.severity.ToString() == "Error").Select(message => message.message).ToArray();
            string path = Path.Combine(directory, Path.GetFileNameWithoutExtension(camera.gameObject.scene.path) + ".png");
            var target = new RenderTexture(1280, 720, 24, RenderTextureFormat.ARGB32);
            var texture = new Texture2D(1280, 720, TextureFormat.RGB24, false);
            RenderTexture oldActive = RenderTexture.active;
            try
            {
                target.Create();
                RenderPipeline.SubmitRenderRequest(camera, new RenderPipeline.StandardRequest { destination = target });
                RenderTexture.active = target;
                texture.ReadPixels(new Rect(0, 0, 1280, 720), 0, 0); texture.Apply();
                File.WriteAllBytes(path, texture.EncodeToPNG());
                var status = new LiveStatus { project = Path.GetDirectoryName(Application.dataPath),
                    scene = camera.gameObject.scene.path, pipeline = RenderPipelineManager.currentPipeline.GetType().FullName,
                    graphicsAPI = SystemInfo.graphicsDeviceType.ToString(), gpu = SystemInfo.graphicsDeviceName,
                    renderingPath = asset.renderingPath.ToString(), debugView = asset.debugView,
                    graphicsAndQualityMatch = QualitySettings.renderPipeline == asset, shaderErrors = errors,
                    preview = path, utc = DateTime.UtcNow.ToString("o") };
                File.WriteAllText(Path.Combine(directory, "status.json"), JsonUtility.ToJson(status, true));
                Debug.Log("RELINK_LIVE_PREVIEW " + path);
            }
            catch (Exception exception) { Debug.LogException(exception); }
            finally
            {
                RenderTexture.active = oldActive;
                target.Release(); Object.DestroyImmediate(target); Object.DestroyImmediate(texture);
            }
        }
    }
}
