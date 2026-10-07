using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Experimental.Rendering;
using Unity.Collections;

namespace MyMission.Rendering
{
    public sealed partial class RelinkRenderPipeline
    {
        static readonly int SunArray=Shader.PropertyToID("_RelinkSunShadowArray");
        static readonly int LocalArray=Shader.PropertyToID("_RelinkLocalShadowArray");
        static readonly int ParaboloidArray=Shader.PropertyToID("_RelinkParaboloidShadowArray");
        readonly Matrix4x4[] sunArrayMatrices=new Matrix4x4[3], localMatrices=new Matrix4x4[16];
        readonly int[] visibleLocalIndices=new int[32];
        readonly Vector4[] localShadowInfo=new Vector4[32];
        readonly Vector4[] probeMin=new Vector4[2],probeMax=new Vector4[2],probePosition=new Vector4[2],probeTint=new Vector4[2];
        readonly Vector4[] regionMin=new Vector4[4],regionMax=new Vector4[4],regionColor=new Vector4[4];
        int localLightCount;
        ComputeBuffer tileIndices;
        int tileBufferSize;

        Matrix4x4 ShadowTextureMatrix(Matrix4x4 view,Matrix4x4 projection) {
            var vp=projection*view;
            if(SystemInfo.usesReversedZBuffer) for(int i=0;i<4;i++) vp[2,i]=-vp[2,i];
            var scale=Matrix4x4.identity; scale.m00=scale.m11=scale.m22=.5f; scale.m03=scale.m13=scale.m23=.5f;
            return scale*vp;
        }
        void AllocateShadowArray(int id,int size,int layers) {
            var descriptor=new RenderTextureDescriptor(size,size) {graphicsFormat=GraphicsFormat.None,
                depthStencilFormat=GraphicsFormat.D16_UNorm,dimension=TextureDimension.Tex2DArray,volumeDepth=layers,
                shadowSamplingMode=ShadowSamplingMode.CompareDepths,msaaSamples=1};
            cmd.GetTemporaryRT(id,descriptor,FilterMode.Bilinear);
        }
        void RenderSceneShadows(ScriptableRenderContext context,CullingResults culling,int sun) {
            int size=Mathf.ClosestPowerOfTwo(Mathf.Clamp(settings.shadowAtlasSize,512,4096));
            AllocateShadowArray(SunArray,size,3);
            cmd.SetGlobalFloat("_RelinkAdvancedShadows",1); cmd.SetGlobalVector("_RelinkShadowSettings",Vector4.zero);
            for(int i=0;i<3;i++) {
                cmd.SetRenderTarget(new RenderTargetIdentifier(SunArray),0,CubemapFace.Unknown,i);
                cmd.ClearRenderTarget(true,false,Color.clear);
            }
            Flush(context);
            if(sun<0 || culling.visibleLights[sun].light.shadows==LightShadows.None || !culling.GetShadowCasterBounds(sun,out _)) return;
            var light=culling.visibleLights[sun].light;
            float far=Mathf.Min(settings.cascadeDistances.z,settings.shadowDistance);
            float mid=Mathf.Min(settings.cascadeDistances.y,far*.9f), near=Mathf.Min(settings.cascadeDistances.x,mid*.9f);
            var splits=new NativeArray<ShadowSplitData>(3,Allocator.Temp);
            var infos=new NativeArray<LightShadowCasterCullingInfo>(culling.visibleLights.Length,Allocator.Temp);
            var views=new Matrix4x4[3]; var projections=new Matrix4x4[3];
            cmd.BeginSample("Relink / three D16 sun layers");
            try {
                for(int i=0;i<3;i++) {
                    if(!culling.ComputeDirectionalShadowMatricesAndCullingPrimitives(sun,i,3,new Vector3(near/far,mid/far,0),size,
                        light.shadowNearPlane,out views[i],out projections[i],out var split)) return;
                    splits[i]=split; sunArrayMatrices[i]=ShadowTextureMatrix(views[i],projections[i]);
                }
                infos[sun]=new LightShadowCasterCullingInfo {splitRange=new RangeInt(0,3),projectionType=BatchCullingProjectionType.Orthographic};
                context.CullShadowCasters(culling,new ShadowCastersCullingInfos {splitBuffer=splits,perLightInfos=infos});
                for(int i=0;i<3;i++) {
                    cmd.SetRenderTarget(new RenderTargetIdentifier(SunArray),0,CubemapFace.Unknown,i); cmd.SetViewport(new Rect(0,0,size,size));
                    cmd.SetViewProjectionMatrices(views[i],projections[i]); cmd.SetGlobalDepthBias(0,settings.shadowBias); Flush(context);
                    var drawing=new ShadowDrawingSettings(culling,sun) {splitIndex=i};
                    cmd.DrawRendererList(context.CreateShadowRendererList(ref drawing)); cmd.SetGlobalDepthBias(0,0); Flush(context);
                }
                cmd.SetGlobalTexture(SunArray,SunArray); cmd.SetGlobalMatrixArray("_RelinkSunArrayMatrices",sunArrayMatrices);
                cmd.SetGlobalVector("_RelinkCascadeDistances",new Vector4(near,mid,far,0));
                // Param[1].x controls blocker search footprint; Unity scene uses metres.
                cmd.SetGlobalVector("_RelinkPCSS",new Vector4(size,.03125f,settings.shadowPenumbra,0));
                cmd.SetGlobalVector("_RelinkShadowSettings",new Vector4(light.shadowStrength,1f/size,settings.shadowNormalBias,far));
            } finally {splits.Dispose(); infos.Dispose(); cmd.EndSample("Relink / three D16 sun layers"); Flush(context); context.Submit();}
        }
        void RenderLocalShadows(ScriptableRenderContext context,CullingResults culling) {
            AllocateShadowArray(LocalArray,512,16);
            cmd.GetTemporaryRT(ParaboloidArray,new RenderTextureDescriptor(512,512) {graphicsFormat=GraphicsFormat.R16_SFloat,
                depthStencilFormat=GraphicsFormat.None,dimension=TextureDimension.Tex2DArray,volumeDepth=16,msaaSamples=1},FilterMode.Point);
            var views=new Matrix4x4[16]; var projections=new Matrix4x4[16];
            var splits=new NativeArray<ShadowSplitData>(16,Allocator.Temp);
            var infos=new NativeArray<LightShadowCasterCullingInfo>(culling.visibleLights.Length,Allocator.Temp);
            int used=0;
            for(int i=0;i<32;i++) localShadowInfo[i]=new Vector4(-1,0,0,0);
            try {
                for(int i=0;i<localLightCount;i++) {
                    int visible=visibleLocalIndices[i]; var light=culling.visibleLights[visible];
                    int count=light.lightType==LightType.Point?(settings.dualParaboloidPointShadows?2:6):1;
                    if(!settings.localShadows || light.light.shadows==LightShadows.None || used+count>16 || !culling.GetShadowCasterBounds(visible,out _)) continue;
                    int start=used; bool valid=true;
                    for(int face=0;face<count;face++) {
                        ShadowSplitData split;
                        if(count==2) {
                            // Native shadow-caster culling with a light-range sphere and one
                            // hemisphere plane. Projection is nonlinear in our vertex shader.
                            var position=light.light.transform.position;var direction=face==0?Vector3.forward:Vector3.back;
                            split=new ShadowSplitData {cullingSphere=new Vector4(position.x,position.y,position.z,light.range),
                                shadowCascadeBlendCullingFactor=1,cullingPlaneCount=1};
                            split.SetCullingPlane(0,new Plane(direction,position));
                            views[used]=Matrix4x4.identity;projections[used]=Matrix4x4.identity;
                        } else if(count==6) {
                            valid=culling.ComputePointShadowMatricesAndCullingPrimitives(visible,(CubemapFace)face,0,out views[used],out projections[used],out split);
                            // Unity point shadow views have opposite Y handedness.
                            for(int col=0;col<4;col++) views[used][1,col]=-views[used][1,col];
                        } else valid=culling.ComputeSpotShadowMatricesAndCullingPrimitives(visible,out views[used],out projections[used],out split);
                        if(!valid) break;
                        splits[used]=split; localMatrices[used]=ShadowTextureMatrix(views[used],projections[used]); used++;
                    }
                    if(!valid) {used=start; continue;}
                    infos[visible]=new LightShadowCasterCullingInfo {splitRange=new RangeInt(start,count),projectionType=BatchCullingProjectionType.Perspective};
                    localShadowInfo[i]=new Vector4(start,count,light.light.shadowStrength,light.light.shadowNearPlane);
                }
                if(used>0) context.CullShadowCasters(culling,new ShadowCastersCullingInfos {splitBuffer=splits,perLightInfos=infos});
                cmd.BeginSample("Relink / local shadow faces");
                for(int i=0;i<localLightCount;i++) {
                    int start=(int)localShadowInfo[i].x; if(start<0) continue;
                    for(int face=0;face<(int)localShadowInfo[i].y;face++) {
                        int layer=start+face;bool paraboloid=localShadowInfo[i].y==2;
                        if(paraboloid) {
                            cmd.SetRenderTarget(new RenderTargetIdentifier(ParaboloidArray,0,CubemapFace.Unknown,layer),
                                new RenderTargetIdentifier(LocalArray,0,CubemapFace.Unknown,layer));
                            var light=culling.visibleLights[visibleLocalIndices[i]].light;var position=light.transform.position;
                            cmd.SetGlobalVector("_RelinkParaboloidOrigin",new Vector4(position.x,position.y,position.z,light.range));
                            cmd.SetGlobalVector("_RelinkParaboloidPass",new Vector4(1,face,light.shadowNearPlane,settings.pointShadowHemisphereOverlap));
                        } else {cmd.SetRenderTarget(new RenderTargetIdentifier(LocalArray),0,CubemapFace.Unknown,layer);cmd.SetGlobalVector("_RelinkParaboloidPass",Vector4.zero);}
                        cmd.SetViewport(new Rect(0,0,512,512)); cmd.ClearRenderTarget(true,paraboloid,Color.white);
                        cmd.SetViewProjectionMatrices(views[layer],projections[layer]); cmd.SetGlobalDepthBias(0,settings.shadowBias); Flush(context);
                        var drawing=new ShadowDrawingSettings(culling,visibleLocalIndices[i]) {splitIndex=face};
                        cmd.DrawRendererList(context.CreateShadowRendererList(ref drawing)); cmd.SetGlobalDepthBias(0,0); Flush(context);
                    }
                }
                cmd.SetGlobalVector("_RelinkParaboloidPass",Vector4.zero);
                cmd.SetGlobalTexture(LocalArray,LocalArray); cmd.SetGlobalMatrixArray("_RelinkLocalMatrices",localMatrices);
                cmd.SetGlobalTexture(ParaboloidArray,ParaboloidArray);
                cmd.SetGlobalVectorArray("_RelinkLocalShadowInfo",localShadowInfo); cmd.EndSample("Relink / local shadow faces"); Flush(context); context.Submit();
            } finally {splits.Dispose(); infos.Dispose();}
        }
        void BindSceneLighting(Camera camera) {
            cmd.SetGlobalInt("_RelinkSampleFrame",Time.frameCount);
            bool ibl=settings.imageBasedLighting && settings.environmentCube!=null && settings.environmentBRDF!=null;
            cmd.SetGlobalVector("_RelinkIBLSettings",new Vector4(settings.environmentIntensity,
                ibl?settings.environmentCube.mipmapCount-1:0,ibl?1:0,settings.capturedIBLMaterialFormula?1:0));
            if(ibl) {cmd.SetGlobalTexture("_RelinkEnvironmentCube",settings.environmentCube); cmd.SetGlobalTexture("_RelinkEnvironmentBRDF",settings.environmentBRDF);}
            if(ibl) cmd.SetGlobalTexture("_RelinkDiffuseCube",settings.environmentDiffuseCube!=null?settings.environmentDiffuseCube:settings.environmentCube);
            int probes=0,regions=0;
            foreach(var volume in RelinkSceneVolume.Active) {
                if(volume==null || !volume.enabled || volume.gameObject.scene!=camera.gameObject.scene) continue;
                Vector3 center=volume.transform.position;
                // World-aligned boxes; avoid silently pretending rotated boxes are handled.
                Vector3 extent=Vector3.Scale(volume.size,volume.transform.lossyScale)*.5f;
                if(probes<2 && volume.reflectionCube!=null) {
                    probeMin[probes]=center-extent; probeMin[probes].w=volume.blendDistance; probeMax[probes]=center+extent;
                    probeMax[probes].w=volume.reflectionCube.mipmapCount-1;
                    probePosition[probes]=center; Color tint=volume.diffuseTint.linear; tint.a=volume.intensity; probeTint[probes]=tint;
                    cmd.SetGlobalTexture(probes==0?"_RelinkLocalCube0":"_RelinkLocalCube1",volume.reflectionCube);
                    cmd.SetGlobalTexture(probes==0?"_RelinkLocalDiffuse0":"_RelinkLocalDiffuse1",volume.diffuseCube!=null?volume.diffuseCube:settings.environmentDiffuseCube);
                    probes++;
                }
                if(volume.regionalFog && regions<4) {
                    regionMin[regions]=center-extent; regionMin[regions].w=volume.blendDistance; regionMax[regions]=center+extent;
                    Color color=volume.fogColor.linear; color.a=volume.fogDensity; regionColor[regions]=color; regions++;
                }
            }
            cmd.SetGlobalInt("_RelinkProbeCount",probes); cmd.SetGlobalVectorArray("_RelinkProbeMin",probeMin);
            cmd.SetGlobalVectorArray("_RelinkProbeMax",probeMax); cmd.SetGlobalVectorArray("_RelinkProbePosition",probePosition); cmd.SetGlobalVectorArray("_RelinkProbeTint",probeTint);
            cmd.SetGlobalInt("_RelinkRegionFogCount",regions); cmd.SetGlobalVectorArray("_RelinkRegionFogMin",regionMin);
            cmd.SetGlobalVectorArray("_RelinkRegionFogMax",regionMax); cmd.SetGlobalVectorArray("_RelinkRegionFogColor",regionColor);
        }
        void DispatchTileLights(ScriptableRenderContext context,int width,int height) {
            var compute=settings.tileLightingShader; if(compute==null || localLightCount==0) return;
            int tilesX=(width+15)/16,tilesY=(height+15)/16,size=tilesX*tilesY*33;
            if(tileIndices==null || tileBufferSize!=size) {tileIndices?.Release(); tileIndices=new ComputeBuffer(size,4); tileBufferSize=size;}
            int list=compute.FindKernel("BuildLightTiles"),light=compute.FindKernel("ShadeLocalLights");
            cmd.BeginSample("Relink / tile local light lists and compute shading");
            cmd.SetComputeIntParam(compute,"_TileCountX",tilesX); cmd.SetComputeIntParam(compute,"_SceneLightCount",localLightCount);
            cmd.SetComputeVectorArrayParam(compute,"_SceneLightPositions",lightPositions); cmd.SetComputeVectorArrayParam(compute,"_SceneLightColors",lightColors);
            cmd.SetComputeVectorArrayParam(compute,"_SceneLightDirections",lightDirections); cmd.SetComputeVectorArrayParam(compute,"_SceneLightSpots",lightSpots);
            cmd.SetComputeVectorArrayParam(compute,"_SceneLightShadow",localShadowInfo);
            cmd.SetComputeMatrixArrayParam(compute,"_SceneLocalMatrices",localMatrices);
            cmd.SetComputeIntParam(compute,"_UseLocalShadows",settings.localShadows?1:0);
            cmd.SetComputeIntParam(compute,"_DebugLocalShadow",settings.debugView==16?1:0);
            foreach(int kernel in new[]{list,light}) {
                cmd.SetComputeBufferParam(compute,kernel,"_LightTiles",tileIndices);
                cmd.SetComputeTextureParam(compute,kernel,"_SceneDepth",new RenderTargetIdentifier(DeferredDepth),0,RenderTextureSubElement.Depth);
            }
            cmd.DispatchCompute(compute,list,tilesX,tilesY,1);
            cmd.SetComputeTextureParam(compute,light,"_SceneBase",GBuffer[0]); cmd.SetComputeTextureParam(compute,light,"_SceneMask",GBuffer[1]);
            cmd.SetComputeTextureParam(compute,light,"_SceneNormal",GBuffer[2]); cmd.SetComputeTextureParam(compute,light,"_SceneLocalShadow",LocalArray);
            cmd.SetComputeTextureParam(compute,light,"_SceneParaboloidShadow",ParaboloidArray);
            cmd.SetComputeTextureParam(compute,light,"_SceneLightingOutput",ColorTarget);
            cmd.DispatchCompute(compute,light,(width+7)/8,(height+7)/8,1);
            cmd.EndSample("Relink / tile local light lists and compute shading"); Flush(context);
        }
        void DisposeSceneLighting() {tileIndices?.Release(); tileIndices=null;}
    }
}
