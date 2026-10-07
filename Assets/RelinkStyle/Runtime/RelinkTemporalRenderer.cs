using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    public sealed partial class RelinkRenderPipeline
    {
        sealed class TemporalState {
            public RenderTexture hdr,ldr,depth,exposure;
            public int width,height,sequence;
            public Matrix4x4 view;
            public void Release() { foreach(var rt in new[]{hdr,ldr,depth,exposure}) if(rt!=null) {rt.Release(); DestroyTexture(rt);} }
        }
        readonly Dictionary<int,TemporalState> temporalStates=new Dictionary<int,TemporalState>();
        Material temporal;
        static readonly int PostA=Shader.PropertyToID("_RelinkPostA"), PostB=Shader.PropertyToID("_RelinkPostB");
        static readonly int ExposureNext=Shader.PropertyToID("_RelinkExposureNext");
        static readonly int[] BloomLevels={Shader.PropertyToID("_RelinkBloom0"),Shader.PropertyToID("_RelinkBloom1"),Shader.PropertyToID("_RelinkBloom2"),Shader.PropertyToID("_RelinkBloom3"),Shader.PropertyToID("_RelinkBloom4")};
        static void DestroyTexture(Object obj) {if(Application.isPlaying) Object.Destroy(obj); else Object.DestroyImmediate(obj);}
        static RenderTexture HistoryTexture(int w,int h,GraphicsFormat format,string name) {
            var texture=new RenderTexture(new RenderTextureDescriptor(w,h) {graphicsFormat=format,depthStencilFormat=GraphicsFormat.None,msaaSamples=1}) {
                name=name,filterMode=FilterMode.Bilinear,wrapMode=TextureWrapMode.Clamp,hideFlags=HideFlags.HideAndDontSave};
            texture.Create(); return texture;
        }
        TemporalState GetTemporalState(Camera camera,int w,int h) {
            int id=camera.GetInstanceID();
            if(temporalStates.TryGetValue(id,out var history) && (history.width!=w || history.height!=h)) {history.Release(); temporalStates.Remove(id); history=null;}
            if(history==null) {
                history=new TemporalState {width=w,height=h,hdr=HistoryTexture(w,h,GraphicsFormat.R16G16B16A16_SFloat,"Relink HDR history"),
                    ldr=HistoryTexture(w,h,GraphicsFormat.R16G16B16A16_SFloat,"Relink post history"),depth=HistoryTexture(w,h,GraphicsFormat.R32_SFloat,"Relink previous linear depth"),
                    exposure=HistoryTexture(1,1,GraphicsFormat.R32_SFloat,"Relink exposure history")};
                temporalStates.Add(id,history);
            }
            return history;
        }
        static float Halton(int index,int radix) {
            float result=0,fraction=1;
            while(index>0) {fraction/=radix;result+=fraction*(index%radix);index/=radix;} return result;
        }
        Matrix4x4 JitterProjection(Camera camera,Matrix4x4 projection,int width,int height) {
            if(!settings.temporalAA || settings.debugView!=0) return projection;
            var state=GetTemporalState(camera,width,height); int frame=state.sequence%8+1;
            float x=(Halton(frame,2)-.5f)*2/width,y=(Halton(frame,3)-.5f)*2/height;
            if(camera.orthographic) {projection.m03+=x;projection.m13+=y;}
            else {projection.m02+=x;projection.m12+=y;}
            return projection;
        }
        void ComposeScene(ScriptableRenderContext context,Camera camera,int width,int height,bool cameraValid) {
            if(temporal==null) temporal=new Material(settings.temporalShader) {hideFlags=HideFlags.HideAndDontSave};
            var state=GetTemporalState(camera,width,height); bool valid=cameraValid && state.sequence>0;
            cmd.SetGlobalTexture("_RelinkHDRHistory",state.hdr); cmd.SetGlobalTexture("_RelinkPostHistory",state.ldr);
            cmd.SetGlobalTexture("_RelinkPreviousDepth",state.depth); cmd.SetGlobalTexture("_RelinkExposureHistory",state.exposure);
            cmd.SetGlobalMatrix("_RelinkPreviousView",valid?state.view:camera.worldToCameraMatrix);
            cmd.SetGlobalVector("_RelinkTemporal",new Vector4(valid?1:0,settings.temporalAA?.98f:0,settings.temporalAA?.925f:0,settings.motionBlur?settings.shutter:0));
            cmd.SetGlobalVector("_RelinkExposureParams",new Vector4(settings.exposureLimits.x,settings.exposureLimits.y,
                1-Mathf.Exp(-Mathf.Clamp(Time.unscaledDeltaTime,.001f,.1f)*settings.exposureSpeed),settings.exposureKey));
            cmd.SetGlobalFloat("_RelinkAutoExposure",settings.automaticExposure?1:0);
            cmd.SetGlobalVector("_RelinkGrade",new Vector4(Mathf.Pow(2,settings.exposure),settings.saturation,settings.contrast,settings.bloomIntensity));
            cmd.SetGlobalVector("_RelinkScenePost",new Vector4(settings.colorGrading?1:0,settings.gradingDistances.x,settings.gradingDistances.y,settings.bloomThreshold));
            cmd.SetGlobalFloat("_RelinkLineActive",settings.depthColorLines?1:0);
            cmd.SetGlobalVector("_RelinkLine",new Vector4(settings.lineCoefficient,settings.lineCoefficientNear,settings.outlineStrength,settings.outlineWidth));
            cmd.SetGlobalColor("_RelinkLineTint",settings.lineTint.linear);
            cmd.SetGlobalFloat("_RelinkCapturedLineParameters",settings.capturedLineParameters?1:0);
            if(settings.nearLUT!=null) cmd.SetGlobalTexture("_RelinkNearLUT",settings.nearLUT);
            if(settings.farLUT!=null) cmd.SetGlobalTexture("_RelinkFarLUT",settings.farLUT);
            AllocateColor(PostA,width,height,GraphicsFormat.R16G16B16A16_SFloat,FilterMode.Bilinear);
            AllocateColor(PostB,width,height,GraphicsFormat.R16G16B16A16_SFloat,FilterMode.Bilinear);
            AllocateColor(ExposureNext,1,1,GraphicsFormat.R32_SFloat);
            cmd.BeginSample("Relink / regional dual 32 cubed LUT");
            cmd.Blit(ColorTarget,PostA,temporal,0); cmd.EndSample("Relink / regional dual 32 cubed LUT");
            cmd.BeginSample("Relink / HDR YCoCg temporal resolve");
            cmd.Blit(PostA,PostB,temporal,1); cmd.Blit(PostB,state.hdr); cmd.EndSample("Relink / HDR YCoCg temporal resolve");
            cmd.BeginSample("Relink / depth rejected motion blur"); cmd.Blit(PostB,PostA,temporal,2); cmd.EndSample("Relink / depth rejected motion blur");
            cmd.BeginSample("Relink / eleven sample luminance and exposure history");
            cmd.Blit(PostA,ExposureNext,temporal,3); cmd.SetGlobalTexture("_RelinkAdaptedExposure",ExposureNext);
            cmd.Blit(ExposureNext,state.exposure); cmd.EndSample("Relink / eleven sample luminance and exposure history");
            cmd.BeginSample("Relink / five bloom scales");
            for(int i=0;i<5;i++) {
                int w=Mathf.Max(1,width>>(i+1)),h=Mathf.Max(1,height>>(i+1));
                AllocateColor(BloomLevels[i],w,h,GraphicsFormat.R16G16B16A16_SFloat,FilterMode.Bilinear);
                cmd.Blit(i==0?PostA:BloomLevels[i-1],BloomLevels[i],temporal,i==0?4:5);
                int blur=Shader.PropertyToID("_RelinkSceneBloomTemp"); AllocateColor(blur,w,h,GraphicsFormat.R16G16B16A16_SFloat,FilterMode.Bilinear);
                cmd.SetGlobalVector("_RelinkBlurDirection",new Vector4(1,0,0,0)); cmd.Blit(BloomLevels[i],blur,composite,1);
                cmd.SetGlobalVector("_RelinkBlurDirection",new Vector4(0,1,0,0)); cmd.Blit(blur,BloomLevels[i],composite,1);
                cmd.ReleaseTemporaryRT(blur); cmd.SetGlobalTexture(BloomLevels[i],BloomLevels[i]);
            }
            cmd.EndSample("Relink / five bloom scales");
            cmd.BeginSample("Relink / captured film curve and color depth lines");
            cmd.Blit(PostA,PostB,temporal,6); cmd.Blit(PostB,PostA,temporal,7);
            cmd.EndSample("Relink / captured film curve and color depth lines");
            cmd.BeginSample("Relink / post line temporal resolve");
            cmd.Blit(PostA,PostB,temporal,8); cmd.Blit(PostB,state.ldr); cmd.Blit(PostB,BuiltinRenderTextureType.CameraTarget,temporal,10);
            cmd.Blit(ColorTarget,state.depth,temporal,9); cmd.EndSample("Relink / post line temporal resolve");
            cmd.ReleaseTemporaryRT(PostA);cmd.ReleaseTemporaryRT(PostB);cmd.ReleaseTemporaryRT(ExposureNext);
            foreach(int level in BloomLevels) cmd.ReleaseTemporaryRT(level);
            Flush(context); state.sequence++; state.view=camera.worldToCameraMatrix;
        }
        void DisposeTemporal() {foreach(var state in temporalStates.Values) state.Release();temporalStates.Clear(); if(temporal!=null) DestroyTexture(temporal);}
    }
}
