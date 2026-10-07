using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    /// <summary>Standalone SRP with evidence-based deferred and original prototype paths.</summary>
    public sealed partial class RelinkRenderPipeline : RenderPipeline
    {
        private readonly RelinkRenderPipelineAsset settings;
        private readonly Material composite;
        private readonly CommandBuffer cmd = new CommandBuffer { name = "Relink Scene SRP" };
        private readonly Matrix4x4[] shadowMatrices = new Matrix4x4[2];
        private readonly Matrix4x4[] shadowViews = new Matrix4x4[2];
        private readonly Matrix4x4[] shadowProjections = new Matrix4x4[2];
        private readonly Vector4[] cascadeSpheres = new Vector4[2];
        private readonly Vector4[] lightPositions = new Vector4[32];
        private readonly Vector4[] lightColors = new Vector4[32];
        private readonly Vector4[] lightDirections = new Vector4[32];
        private readonly Vector4[] lightSpots = new Vector4[32];
        private static readonly int ColorTarget = Shader.PropertyToID("_RelinkColor");
        private static readonly int NormalTarget = Shader.PropertyToID("_RelinkDepthNormals");
        private static readonly int ShadowTarget = Shader.PropertyToID("_RelinkShadowAtlas");
        private static readonly int BloomA = Shader.PropertyToID("_RelinkBloomA");
        private static readonly int BloomB = Shader.PropertyToID("_RelinkBloomB");
        private static readonly ShaderTagId ForwardTag = new ShaderTagId("RelinkForward");
        private static readonly ShaderTagId NormalTag = new ShaderTagId("RelinkDepthNormals");
        private readonly bool previousLinearLights;

        public RelinkRenderPipeline(RelinkRenderPipelineAsset settings)
        {
            this.settings = settings;
            if (settings.compositeShader != null)
                composite = new Material(settings.compositeShader) { hideFlags = HideFlags.HideAndDontSave };
            InitializeDeferred();
            previousLinearLights = GraphicsSettings.lightsUseLinearIntensity;
            GraphicsSettings.lightsUseLinearIntensity = true;
        }

        protected override void Render(ScriptableRenderContext context, List<Camera> cameras)
        {
            BeginContextRendering(context, cameras);
            foreach (Camera camera in cameras)
            {
                BeginCameraRendering(context, camera);
                RenderCamera(context, camera);
                EndCameraRendering(context, camera);
            }
            EndContextRendering(context, cameras);
        }

        protected override bool IsRenderRequestSupported<T>(Camera camera, T data) => data is StandardRequest;

        protected override void ProcessRenderRequests<T>(ScriptableRenderContext context, Camera camera, T data)
        {
            if (!(data is StandardRequest request) || request.destination == null) return;
            RenderTexture previous = camera.targetTexture;
            try
            {
                camera.targetTexture = request.destination;
                BeginCameraRendering(context, camera);
                RenderCamera(context, camera);
                EndCameraRendering(context, camera);
            }
            finally { camera.targetTexture = previous; }
        }

        private void Flush(ScriptableRenderContext context)
        {
            context.ExecuteCommandBuffer(cmd);
            cmd.Clear();
        }

        private void RenderCamera(ScriptableRenderContext context, Camera camera)
        {
            if (settings.renderingPath == RelinkRenderingPath.EvidenceDeferred)
            {
                if (deferred == null)
                    throw new System.InvalidOperationException("Assign Hidden/Relink/Deferred to the pipeline asset. Tools/Relink SRP/1 - Build Environment Demo assigns all required shaders.");
                RenderDeferredCamera(context, camera);
                return;
            }
            cmd.SetGlobalFloat("_RelinkDeferredActive", 0);
            cmd.SetGlobalFloat("_RelinkAdvancedShadows", 0);
            if (!camera.TryGetCullingParameters(out var parameters)) return;
            parameters.shadowDistance = Mathf.Min(settings.shadowDistance, camera.farClipPlane);
#if UNITY_EDITOR
            if (camera.cameraType == CameraType.SceneView) ScriptableRenderContext.EmitWorldGeometryForSceneView(camera);
#endif
            CullingResults culling = context.Cull(ref parameters);
            int sunIndex = SetupLights(culling);
            RenderShadows(context, culling, sunIndex);
            context.SetupCameraProperties(camera);
            int width = Mathf.Max(1, camera.pixelWidth), height = Mathf.Max(1, camera.pixelHeight);
            cmd.GetTemporaryRT(ColorTarget, width, height, 0, FilterMode.Bilinear, RenderTextureFormat.DefaultHDR);
            cmd.GetTemporaryRT(NormalTarget, width, height, 24, FilterMode.Point, RenderTextureFormat.ARGBHalf);
            cmd.SetGlobalVector("_RelinkCamera", new Vector4(camera.transform.position.x, camera.transform.position.y,
                camera.transform.position.z, camera.farClipPlane));
            cmd.SetGlobalColor("_RelinkAmbientSky", settings.ambientSky.linear * settings.ambientIntensity);
            cmd.SetGlobalColor("_RelinkAmbientGround", settings.ambientGround.linear * settings.ambientIntensity);
            cmd.SetGlobalColor("_RelinkFogColor", settings.fogColor.linear);
            cmd.SetGlobalVector("_RelinkFog", new Vector4(settings.fogDensity, settings.fogBaseHeight,
                settings.fogHeightFalloff, 0));
            cmd.BeginSample("Relink / depth and normals");
            cmd.SetRenderTarget(NormalTarget);
            cmd.ClearRenderTarget(true, true, Color.clear);
            Flush(context);
            Draw(context, camera, culling, NormalTag, RenderQueueRange.opaque, SortingCriteria.CommonOpaque);
            cmd.EndSample("Relink / depth and normals");
            cmd.BeginSample("Relink / opaque environment");
            cmd.SetRenderTarget(new RenderTargetIdentifier(ColorTarget), new RenderTargetIdentifier(NormalTarget));
            cmd.ClearRenderTarget(false, true, camera.backgroundColor.linear);
            Flush(context);
            Draw(context, camera, culling, ForwardTag, RenderQueueRange.opaque, SortingCriteria.CommonOpaque);
            cmd.EndSample("Relink / opaque environment");
            Flush(context);
            if (camera.clearFlags == CameraClearFlags.Skybox)
            {
                cmd.DrawRendererList(context.CreateSkyboxRendererList(camera));
                Flush(context);
            }
            cmd.BeginSample("Relink / transparent environment");
            Flush(context);
            Draw(context, camera, culling, ForwardTag, RenderQueueRange.transparent, SortingCriteria.CommonTransparent);
            cmd.EndSample("Relink / transparent environment");
#if UNITY_EDITOR
            Flush(context);
            if (UnityEditor.Handles.ShouldRenderGizmos()) context.DrawGizmos(camera, GizmoSubset.PreImageEffects);
#endif
            Compose(context, camera, width, height);
#if UNITY_EDITOR
            if (UnityEditor.Handles.ShouldRenderGizmos()) context.DrawGizmos(camera, GizmoSubset.PostImageEffects);
#endif
            cmd.ReleaseTemporaryRT(ColorTarget);
            cmd.ReleaseTemporaryRT(NormalTarget);
            cmd.ReleaseTemporaryRT(ShadowTarget);
            Flush(context);
            context.Submit();
        }

        private void Draw(ScriptableRenderContext context, Camera camera, CullingResults culling, ShaderTagId tag,
            RenderQueueRange range, SortingCriteria sorting)
        {
            var drawing = new DrawingSettings(tag, new SortingSettings(camera) { criteria = sorting })
            {
                enableInstancing = !(settings.temporalAA && tag==GBufferTag),
                perObjectData = PerObjectData.Lightmaps | PerObjectData.LightProbe | PerObjectData.ReflectionProbes | PerObjectData.MotionVectors
            };
            var filtering = new FilteringSettings(range, camera.cullingMask);
            var listParameters = new RendererListParams(culling, drawing, filtering);
            var list = context.CreateRendererList(ref listParameters);
            cmd.DrawRendererList(list);
            Flush(context);
        }

        private int SetupLights(CullingResults culling)
        {
            int sun = -1, count = 0;
            float brightest = -1;
            for (int i = 0; i < culling.visibleLights.Length; i++)
            {
                var light = culling.visibleLights[i];
                if (light.lightType != LightType.Directional) continue;
                float brightness = light.finalColor.maxColorComponent;
                if (light.light == RenderSettings.sun) { sun = i; break; }
                if (brightness > brightest) { brightest = brightness; sun = i; }
            }
            cmd.SetGlobalColor("_RelinkSunColor", sun >= 0 ? culling.visibleLights[sun].finalColor : Color.black);
            cmd.SetGlobalVector("_RelinkSunDirection", sun >= 0 ? -culling.visibleLights[sun].localToWorldMatrix.GetColumn(2) : new Vector4(0, 1, 0, 0));
            for (int i = 0; i < culling.visibleLights.Length && count < (settings.tileLocalLights ? 32 : 8); i++)
            {
                var light = culling.visibleLights[i];
                if (light.lightType != LightType.Point && light.lightType != LightType.Spot) continue;
                Vector4 position = light.localToWorldMatrix.GetColumn(3);
                position.w = 1f / Mathf.Max(light.range * light.range, 0.001f);
                lightPositions[count] = position;
                visibleLocalIndices[count] = i;
                lightColors[count] = light.finalColor;
                lightDirections[count] = -light.localToWorldMatrix.GetColumn(2);
                if (light.lightType == LightType.Spot)
                {
                    float outer = Mathf.Cos(light.spotAngle * Mathf.Deg2Rad * 0.5f);
                    float inner = Mathf.Cos(light.light.innerSpotAngle * Mathf.Deg2Rad * 0.5f);
                    float inv = 1f / Mathf.Max(inner - outer, 0.001f);
                    lightSpots[count] = new Vector4(inv, -outer * inv, 0, 0);
                }
                else lightSpots[count] = new Vector4(0, 1, 0, 0);
                count++;
            }
            cmd.SetGlobalInt("_RelinkLightCount", count);
            localLightCount = count;
            cmd.SetGlobalVectorArray("_RelinkSceneLightPositions", lightPositions);
            cmd.SetGlobalVectorArray("_RelinkSceneLightColors", lightColors);
            cmd.SetGlobalVectorArray("_RelinkSceneLightDirections", lightDirections);
            cmd.SetGlobalVectorArray("_RelinkSceneLightSpots", lightSpots);
            return sun;
        }

        private void RenderShadows(ScriptableRenderContext context, CullingResults culling, int sun)
        {
            int size = Mathf.ClosestPowerOfTwo(Mathf.Clamp(settings.shadowAtlasSize, 512, 4096));
            cmd.GetTemporaryRT(ShadowTarget, size, size, 32, FilterMode.Bilinear, RenderTextureFormat.Shadowmap);
            cmd.SetRenderTarget(ShadowTarget);
            cmd.ClearRenderTarget(true, false, Color.clear);
            cmd.SetGlobalVector("_RelinkShadowSettings", Vector4.zero);
            Flush(context);
            if (sun < 0) return;
            var light = culling.visibleLights[sun].light;
            if (light == null || light.shadows == LightShadows.None || light.shadowStrength <= 0
                || !culling.GetShadowCasterBounds(sun, out _)) return;
            int tile = size / 2;
            var splits = new NativeArray<ShadowSplitData>(2, Allocator.Temp);
            var perLight = new NativeArray<LightShadowCasterCullingInfo>(culling.visibleLights.Length, Allocator.Temp);
            cmd.BeginSample("Relink / two sun cascades");
            for (int cascade = 0; cascade < 2; cascade++)
            {
                if (!culling.ComputeDirectionalShadowMatricesAndCullingPrimitives(sun, cascade, 2,
                        new Vector3(settings.cascadeSplit, 0, 0), tile, light.shadowNearPlane,
                        out var view, out var projection, out var split))
                {
                    cmd.EndSample("Relink / two sun cascades");
                    Flush(context);
                    splits.Dispose();
                    perLight.Dispose();
                    return;
                }
                cascadeSpheres[cascade] = split.cullingSphere;
                cascadeSpheres[cascade].w *= cascadeSpheres[cascade].w;
                splits[cascade] = split;
                shadowViews[cascade] = view;
                shadowProjections[cascade] = projection;
                Matrix4x4 matrix = projection * view;
                if (SystemInfo.usesReversedZBuffer)
                    for (int j = 0; j < 4; j++) matrix[2, j] = -matrix[2, j];
                // Clip [-1,1] to atlas [0,1], with two tiles along the bottom row.
                var atlas = Matrix4x4.identity;
                atlas.m00 = atlas.m11 = 0.25f;
                atlas.m03 = 0.25f + cascade * 0.5f;
                atlas.m13 = 0.25f;
                atlas.m22 = atlas.m23 = 0.5f;
                shadowMatrices[cascade] = atlas * matrix;
            }
            perLight[sun] = new LightShadowCasterCullingInfo
            {
                splitRange = new RangeInt(0, 2),
                projectionType = BatchCullingProjectionType.Orthographic
            };
            context.CullShadowCasters(culling, new ShadowCastersCullingInfos { splitBuffer = splits, perLightInfos = perLight });
            splits.Dispose();
            perLight.Dispose();
            for (int cascade = 0; cascade < 2; cascade++)
            {
                cmd.SetViewport(new Rect(cascade * tile, 0, tile, tile));
                cmd.SetViewProjectionMatrices(shadowViews[cascade], shadowProjections[cascade]);
                cmd.SetGlobalDepthBias(0, settings.shadowBias);
                Flush(context);
                var drawing = new ShadowDrawingSettings(culling, sun) { splitIndex = cascade };
                cmd.DrawRendererList(context.CreateShadowRendererList(ref drawing));
                cmd.SetGlobalDepthBias(0, 0);
                Flush(context);
            }
            cmd.SetGlobalMatrixArray("_RelinkShadowMatrices", shadowMatrices);
            cmd.SetGlobalVectorArray("_RelinkCascadeSpheres", cascadeSpheres);
            cmd.SetGlobalVector("_RelinkShadowSettings", new Vector4(light.shadowStrength, 1f / size,
                settings.shadowNormalBias, settings.shadowDistance));
            cmd.EndSample("Relink / two sun cascades");
            Flush(context);
        }

        private void Compose(ScriptableRenderContext context, Camera camera, int width, int height)
        {
            if (composite == null)
            {
                cmd.Blit(ColorTarget, BuiltinRenderTextureType.CameraTarget);
                Flush(context);
                return;
            }
            cmd.BeginSample("Relink / bloom and illustration grade");
            cmd.GetTemporaryRT(BloomA, Mathf.Max(1, width / 4), Mathf.Max(1, height / 4), 0, FilterMode.Bilinear, RenderTextureFormat.DefaultHDR);
            cmd.GetTemporaryRT(BloomB, Mathf.Max(1, width / 4), Mathf.Max(1, height / 4), 0, FilterMode.Bilinear, RenderTextureFormat.DefaultHDR);
            cmd.SetGlobalVector("_RelinkGrade", new Vector4(Mathf.Pow(2, settings.exposure), settings.saturation,
                settings.contrast, settings.bloomIntensity));
            cmd.SetGlobalVector("_RelinkPost", new Vector4(settings.bloomThreshold, settings.outlineStrength,
                settings.outlineWidth, settings.debugView));
            cmd.SetGlobalColor("_RelinkOutlineColor", settings.outlineColor.linear);
            cmd.Blit(ColorTarget, BloomA, composite, 0);
            cmd.SetGlobalVector("_RelinkBlurDirection", new Vector4(1, 0, 0, 0));
            cmd.Blit(BloomA, BloomB, composite, 1);
            cmd.SetGlobalVector("_RelinkBlurDirection", new Vector4(0, 1, 0, 0));
            cmd.Blit(BloomB, BloomA, composite, 1);
            cmd.SetGlobalTexture("_RelinkBloom", BloomA);
            cmd.SetGlobalTexture("_RelinkDepthNormals", NormalTarget);
            cmd.Blit(ColorTarget, BuiltinRenderTextureType.CameraTarget, composite, 2);
            cmd.ReleaseTemporaryRT(BloomA);
            cmd.ReleaseTemporaryRT(BloomB);
            cmd.EndSample("Relink / bloom and illustration grade");
            Flush(context);
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
            cmd.Release();
            DisposeDeferred();
            DisposeSceneLighting();
            DisposeTemporal();
            if (composite != null)
            {
                if (Application.isPlaying) Object.Destroy(composite);
                else Object.DestroyImmediate(composite);
            }
            GraphicsSettings.lightsUseLinearIntensity = previousLinearLights;
        }
    }
}
