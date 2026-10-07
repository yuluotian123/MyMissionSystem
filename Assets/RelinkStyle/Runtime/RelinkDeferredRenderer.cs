using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    public sealed partial class RelinkRenderPipeline
    {
        private Material deferred;
        private static readonly ShaderTagId GBufferTag = new ShaderTagId("RelinkGBuffer");
        private static readonly ShaderTagId EmissionTag = new ShaderTagId("RelinkEmission");
        private static readonly ShaderTagId OutlineTag = new ShaderTagId("RelinkOutline");
        private static readonly int[] GBuffer = {
            Shader.PropertyToID("_RelinkGBuffer0"), Shader.PropertyToID("_RelinkGBuffer1"),
            Shader.PropertyToID("_RelinkGBuffer2"), Shader.PropertyToID("_RelinkGBuffer3") };
        private static readonly GraphicsFormat[] GBufferFormats = {
            GraphicsFormat.R8G8B8A8_SRGB, GraphicsFormat.R8G8B8A8_UNorm,
            GraphicsFormat.A2B10G10R10_UNormPack32, GraphicsFormat.R16G16_SFloat };
        private static readonly int DeferredDepth = Shader.PropertyToID("_RelinkDeferredDepth");
        private static readonly int ScreenShadow = Shader.PropertyToID("_RelinkScreenShadow");
        private static readonly int DirectTarget = Shader.PropertyToID("_RelinkDirect");
        private static readonly int IndirectTarget = Shader.PropertyToID("_RelinkIndirect");
        private static readonly int AtmosphereTarget = Shader.PropertyToID("_RelinkAtmosphere");
        private readonly Dictionary<int, CameraHistory> cameraHistories = new Dictionary<int, CameraHistory>();
        private struct CameraHistory
        {
            public Matrix4x4 vp;
            public Matrix4x4 projection;
            public Vector3 position;
            public Vector3 forward;
            public int width, height, frame;
            public float time;
        }

        private void InitializeDeferred()
        {
            if (settings.deferredShader != null)
                deferred = new Material(settings.deferredShader) { hideFlags = HideFlags.HideAndDontSave };
        }

        public void ResetCameraHistory(Camera camera) {
            int id=camera.GetInstanceID(); cameraHistories.Remove(id);
            if(temporalStates.TryGetValue(id,out var state)) {state.Release();temporalStates.Remove(id);}
            foreach(var tracker in RelinkMotionHistory.Active) if(tracker!=null) tracker.Reset(camera);
        }

        private void AllocateColor(int id, int width, int height, GraphicsFormat format, FilterMode filter = FilterMode.Point)
        {
            var descriptor = new RenderTextureDescriptor(width, height)
            {
                graphicsFormat = format, depthStencilFormat = GraphicsFormat.None,
                msaaSamples = 1, useMipMap = false, autoGenerateMips = false,
                enableRandomWrite = id == ColorTarget && settings.tileLocalLights
            };
            cmd.GetTemporaryRT(id, descriptor, filter);
        }

        private void Fullscreen(ScriptableRenderContext context, int target, int pass, bool clear = true)
        {
            cmd.SetRenderTarget(target);
            if (clear) cmd.ClearRenderTarget(false, true, Color.clear);
            cmd.DrawProcedural(Matrix4x4.identity, deferred, pass, MeshTopology.Triangles, 3);
            Flush(context);
        }

        private void RenderDeferredCamera(ScriptableRenderContext context, Camera camera)
        {
            if (!camera.TryGetCullingParameters(out var parameters)) return;
            parameters.shadowDistance = Mathf.Min(settings.shadowDistance, camera.farClipPlane);
#if UNITY_EDITOR
            if (camera.cameraType == CameraType.SceneView) ScriptableRenderContext.EmitWorldGeometryForSceneView(camera);
#endif
            cmd.SetGlobalFloat("_RelinkDeferredActive", 0); // Shadow caster uses the shadow view/projection.
            CullingResults culling = context.Cull(ref parameters);
            int sun = SetupLights(culling);
            cmd.SetGlobalFloat("_RelinkAdvancedShadows",settings.threeCascadePCSS?1:0);
            if(settings.threeCascadePCSS) RenderSceneShadows(context,culling,sun);
            else RenderShadows(context, culling, sun);
            if(settings.tileLocalLights) RenderLocalShadows(context,culling);
            context.SetupCameraProperties(camera);
            int width = Mathf.Max(1, camera.pixelWidth), height = Mathf.Max(1, camera.pixelHeight);
            Matrix4x4 view = camera.worldToCameraMatrix;
            // Jitter is applied only to our GPU matrix; Camera.projectionMatrix stays current.
            Matrix4x4 baseProjection=camera.projectionMatrix;
            Matrix4x4 projection = GL.GetGPUProjectionMatrix(baseProjection, true);
            projection=JitterProjection(camera,projection,width,height);
            Matrix4x4 vp = projection * view;
            int cameraID = camera.GetInstanceID();
            bool historyValid = cameraHistories.TryGetValue(cameraID, out var history)
                && history.width == width && history.height == height
                && history.projection == baseProjection
                && Time.frameCount - history.frame <= 1
                && Vector3.Distance(history.position, camera.transform.position) < 3
                && Vector3.Dot(history.forward, camera.transform.forward) > 0.94f;
            cmd.SetGlobalFloat("_RelinkDeferredActive", 1);
            cmd.SetGlobalMatrix("_RelinkCurrentVP", vp);
            cmd.SetGlobalMatrix("_RelinkPreviousVP", historyValid ? history.vp : vp);
            cmd.SetGlobalMatrix("_RelinkInverseVP", vp.inverse);
            cmd.SetGlobalMatrix("_RelinkView", view);
            cmd.SetGlobalMatrix("_RelinkGPUProjection", projection);
            cmd.SetGlobalFloat("_RelinkHistoryValid", historyValid ? 1 : 0);
            cmd.SetGlobalFloat("_RelinkObjectMotion",settings.temporalAA?1:0);
            cmd.SetGlobalFloat("_RelinkPreviousTime",historyValid?history.time:Time.time);
            cmd.SetGlobalVector("_RelinkScreen", new Vector4(1f / width, 1f / height, width, height));
            cmd.SetGlobalInt("_RelinkClassMask", settings.directionalLightClassMask);
            cmd.SetGlobalTexture("_RelinkSubtractLight", settings.subtractLightTexture != null ? settings.subtractLightTexture : Texture2D.blackTexture);
            cmd.SetGlobalFloat("_RelinkClass5IgnoreShadow", settings.class5IgnoresDirectionalShadow ? 1 : 0);
            cmd.SetGlobalColor("_RelinkClearColor", camera.backgroundColor.linear);
            cmd.SetGlobalFloat("_RelinkClearBackground", camera.clearFlags == CameraClearFlags.Skybox ? 0 : 1);
            cmd.SetGlobalVector("_RelinkCamera", new Vector4(camera.transform.position.x, camera.transform.position.y,
                camera.transform.position.z, camera.farClipPlane));
            cmd.SetGlobalColor("_RelinkAmbientSky", settings.ambientSky.linear * settings.ambientIntensity);
            cmd.SetGlobalColor("_RelinkAmbientGround", settings.ambientGround.linear * settings.ambientIntensity);
            cmd.SetGlobalColor("_RelinkFogColor", settings.fogColor.linear);
            cmd.SetGlobalVector("_RelinkFog", new Vector4(settings.fogDensity, settings.fogBaseHeight, settings.fogHeightFalloff, 0));
            BindSceneLighting(camera);

            for (int i = 0; i < GBuffer.Length; i++) AllocateColor(GBuffer[i], width, height, GBufferFormats[i]);
            var depthDescriptor = new RenderTextureDescriptor(width, height)
            {
                graphicsFormat = GraphicsFormat.None, depthStencilFormat = GraphicsFormat.D32_SFloat_S8_UInt,
                stencilFormat = GraphicsFormat.R8_UInt, msaaSamples = 1
            };
            cmd.GetTemporaryRT(DeferredDepth, depthDescriptor, FilterMode.Point);
            AllocateColor(ColorTarget, width, height, GraphicsFormat.B10G11R11_UFloatPack32, FilterMode.Bilinear);
            AllocateColor(DirectTarget, width, height, GraphicsFormat.B10G11R11_UFloatPack32);
            AllocateColor(IndirectTarget, width, height, GraphicsFormat.B10G11R11_UFloatPack32);
            AllocateColor(ScreenShadow, width, height, GraphicsFormat.R16_SFloat);
            AllocateColor(NormalTarget, width, height, GraphicsFormat.R16G16B16A16_SFloat);
            AllocateColor(AtmosphereTarget, width, height, GraphicsFormat.B10G11R11_UFloatPack32);

            cmd.BeginSample("Relink / four GBuffer MRTs");
            var mrt = new RenderTargetIdentifier[GBuffer.Length];
            for (int i = 0; i < mrt.Length; i++) mrt[i] = new RenderTargetIdentifier(GBuffer[i]);
            cmd.SetRenderTarget(mrt, new RenderTargetIdentifier(DeferredDepth));
            cmd.SetViewport(new Rect(0, 0, width, height));
            cmd.ClearRenderTarget(true, true, Color.clear);
            Flush(context);
            foreach(var tracker in RelinkMotionHistory.Active) if(tracker!=null && tracker.gameObject.scene==camera.gameObject.scene) tracker.Prepare(camera,historyValid);
            Draw(context, camera, culling, GBufferTag, RenderQueueRange.opaque, SortingCriteria.CommonOpaque);
            foreach(var tracker in RelinkMotionHistory.Active) if(tracker!=null && tracker.gameObject.scene==camera.gameObject.scene) tracker.Commit(camera);
            cmd.EndSample("Relink / four GBuffer MRTs");
            // Unbind the depth/stencil attachment before exposing both read-only shader views.
            cmd.SetRenderTarget(NormalTarget);
            for (int i = 0; i < GBuffer.Length; i++) cmd.SetGlobalTexture(GBuffer[i], GBuffer[i]);
            cmd.SetGlobalTexture("_RelinkDepthTexture", new RenderTargetIdentifier(DeferredDepth), RenderTextureSubElement.Depth);
            cmd.SetGlobalTexture("_RelinkStencilTexture", new RenderTargetIdentifier(DeferredDepth), RenderTextureSubElement.Stencil);
            Fullscreen(context, NormalTarget, 0);
            cmd.BeginSample("Relink / screen shadow adapter");
            Fullscreen(context, ScreenShadow, 1);
            cmd.SetGlobalTexture("_RelinkScreenShadow", ScreenShadow);
            cmd.EndSample("Relink / screen shadow adapter");
            cmd.BeginSample("Relink / captured directional BRDF");
            Fullscreen(context, DirectTarget, 2);
            cmd.SetGlobalTexture("_RelinkDirect", DirectTarget);
            cmd.Blit(DirectTarget, ColorTarget);
            cmd.EndSample("Relink / captured directional BRDF");
            Fullscreen(context, IndirectTarget, 3); // Kept separate even when disabled, for diagnostics.
            cmd.SetGlobalTexture("_RelinkIndirect", IndirectTarget);
            if (settings.indirectLighting) Fullscreen(context, ColorTarget, 4, false);
            if (settings.localLights) {
                if(settings.tileLocalLights && settings.tileLightingShader!=null) DispatchTileLights(context,width,height);
                else Fullscreen(context, ColorTarget, 5, false);
            }
            cmd.SetRenderTarget(new RenderTargetIdentifier(ColorTarget), new RenderTargetIdentifier(DeferredDepth));
            Flush(context);
            Draw(context, camera, culling, EmissionTag, RenderQueueRange.opaque, SortingCriteria.CommonOpaque);
            if(settings.geometricOutlines) Draw(context,camera,culling,OutlineTag,RenderQueueRange.opaque,SortingCriteria.CommonOpaque);
            if (camera.clearFlags == CameraClearFlags.Skybox)
            {
                cmd.DrawRendererList(context.CreateSkyboxRendererList(camera));
                Flush(context);
            }
            // Fog opaque HDR at its reconstructed depth; transparencies fog at their own surface.
            cmd.SetGlobalTexture("_RelinkLitColor", ColorTarget);
            Fullscreen(context, AtmosphereTarget, 6);
            cmd.Blit(AtmosphereTarget, ColorTarget);
            cmd.SetRenderTarget(new RenderTargetIdentifier(ColorTarget), new RenderTargetIdentifier(DeferredDepth));
            cmd.BeginSample("Relink / transparent forward adapter");
            Draw(context, camera, culling, ForwardTag, RenderQueueRange.transparent, SortingCriteria.CommonTransparent);
            cmd.EndSample("Relink / transparent forward adapter");
            Flush(context);
#if UNITY_EDITOR
            if (UnityEditor.Handles.ShouldRenderGizmos() && settings.debugView == 0)
            {
                cmd.SetRenderTarget(new RenderTargetIdentifier(ColorTarget), new RenderTargetIdentifier(DeferredDepth));
                Flush(context);
                context.DrawGizmos(camera, GizmoSubset.PreImageEffects);
            }
#endif
            if (settings.debugView >= 5)
            {
                cmd.SetGlobalInt("_RelinkDeferredDebug", settings.debugView);
                cmd.SetRenderTarget(BuiltinRenderTextureType.CameraTarget);
                cmd.DrawProcedural(Matrix4x4.identity, deferred, 7, MeshTopology.Triangles, 3);
                Flush(context);
            }
            else if(settings.debugView==0 && settings.temporalShader!=null && (settings.temporalAA || settings.colorGrading || settings.automaticExposure || settings.depthColorLines || settings.motionBlur))
                ComposeScene(context,camera,width,height,historyValid);
            else Compose(context, camera, width, height);
#if UNITY_EDITOR
            if (UnityEditor.Handles.ShouldRenderGizmos() && settings.debugView == 0)
                context.DrawGizmos(camera, GizmoSubset.PostImageEffects);
#endif
            foreach (int target in GBuffer) cmd.ReleaseTemporaryRT(target);
            cmd.ReleaseTemporaryRT(DeferredDepth);
            cmd.ReleaseTemporaryRT(ScreenShadow);
            cmd.ReleaseTemporaryRT(DirectTarget);
            cmd.ReleaseTemporaryRT(IndirectTarget);
            cmd.ReleaseTemporaryRT(AtmosphereTarget);
            cmd.ReleaseTemporaryRT(ColorTarget);
            cmd.ReleaseTemporaryRT(NormalTarget);
            if(settings.threeCascadePCSS) cmd.ReleaseTemporaryRT(SunArray); else cmd.ReleaseTemporaryRT(ShadowTarget);
            if(settings.tileLocalLights) {cmd.ReleaseTemporaryRT(LocalArray);cmd.ReleaseTemporaryRT(ParaboloidArray);}
            Flush(context);
            context.Submit();
            cameraHistories[cameraID] = new CameraHistory { vp = vp, projection=baseProjection, width = width, height = height,
                position = camera.transform.position, forward = camera.transform.forward, frame = Time.frameCount, time=Time.time };
        }

        private void DisposeDeferred()
        {
            cameraHistories.Clear();
            if (deferred == null) return;
            if (Application.isPlaying) Object.Destroy(deferred);
            else Object.DestroyImmediate(deferred);
        }
    }
}
