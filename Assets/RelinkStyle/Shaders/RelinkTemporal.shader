Shader "Hidden/Relink/ScenePost"
{
    Properties { [HideInInspector] _MainTex("Source",2D)="white" {} }
    SubShader {
        Cull Off ZTest Always ZWrite Off
        CGINCLUDE
        #pragma target 4.5
        #include "UnityCG.cginc"
        #include "RelinkSourceLighting.cginc"
        sampler2D _MainTex,_RelinkHDRHistory,_RelinkPostHistory,_RelinkPreviousDepth;
        sampler2D _RelinkExposureHistory,_RelinkAdaptedExposure;
        sampler2D _RelinkBloom0,_RelinkBloom1,_RelinkBloom2,_RelinkBloom3,_RelinkBloom4;
        sampler3D _RelinkNearLUT,_RelinkFarLUT;
        Texture2D<float2> _RelinkGBuffer3;
        Texture2D<float> _RelinkDepthTexture;
        Texture2D<uint2> _RelinkStencilTexture;
        float4 _RelinkScreen,_RelinkTemporal,_RelinkExposureParams,_RelinkGrade,_RelinkScenePost,_RelinkLine,_RelinkLineTint;
        float _RelinkAutoExposure,_RelinkLineActive;
        float _RelinkCapturedLineParameters;
        float4x4 _RelinkInverseVP,_RelinkPreviousView,_RelinkPreviousVP;
        float4 _RelinkCamera;
        float4 _MainTex_TexelSize;
        float3 World(float2 uv) {
            float depth=_RelinkDepthTexture.Load(int3(uint2(uv*_RelinkScreen.zw),0));
            float4 world=mul(_RelinkInverseVP,float4(uv*float2(2,-2)+float2(-1,1),depth,1));
            return world.xyz/max(abs(world.w),1e-7)*sign(world.w+1e-8);
        }
        float Depth(float2 uv) {
            if(_RelinkDepthTexture.Load(int3(uint2(saturate(uv)*(_RelinkScreen.zw-1)),0))<=0) return 0;
            return distance(World(uv),_RelinkCamera.xyz);
        }
        uint Class(float2 uv) {uint2 s=_RelinkStencilTexture.Load(int3(uint2(uv*_RelinkScreen.zw),0));uint stencil=s.x|s.y; return (stencil&15)+((stencil&128)!=0?9:0);}
        float3 YCoCg(float3 c) {return float3(dot(c,float3(.25,.5,.25)),(c.r-c.b)*.5,(-c.r+2*c.g-c.b)*.25);}
        float3 RGB(float3 c) {return float3(c.x+c.y-c.z,c.x+c.z,c.x-c.y-c.z);}
        float2 Velocity(float2 uv) {
            uint2 pixel=uint2(uv*_RelinkScreen.zw);
            if(_RelinkDepthTexture.Load(int3(pixel,0))<=0) {
                float4 prev=mul(_RelinkPreviousVP,float4(World(uv),1));
                float2 history=prev.xy/max(abs(prev.w),1e-5)*sign(prev.w)*float2(.5,-.5)+.5;
                return uv-history;
            }
            // Dilate foreground motion into silhouettes by choosing the nearest 3x3 depth.
            float nearest=-1; float2 velocity=0;
            [unroll] for(int y=-1;y<=1;y++) [unroll] for(int x=-1;x<=1;x++) {
                int2 p=clamp(int2(pixel)+int2(x,y),0,int2(_RelinkScreen.zw)-1);
                float d=_RelinkDepthTexture.Load(int3(p,0));
                if(d>nearest) {nearest=d;velocity=_RelinkGBuffer3.Load(int3(p,0));}
            }
            return velocity;
        }
        float3 BoundHDR(float3 value,bool hdr) {return hdr?value/(1+value):value;}
        float3 Resolve(float2 uv,sampler2D history,float weight,bool hdr) {
            float3 current=tex2D(_MainTex,uv).rgb;
            if(_RelinkTemporal.x<.5 || weight<=0) return current;
            float2 velocity=Velocity(uv), previousUV=uv-velocity;
            if(any(previousUV<0) || any(previousUV>1)) return current;
            float expected=distance(World(uv),_RelinkCamera.xyz);
            // Depth history is radial distance. Previous view accounts for camera translation.
            float previousExpected=length(mul(_RelinkPreviousView,float4(World(uv),1)).xyz);
            float previousDepth=tex2D(_RelinkPreviousDepth,previousUV).r;
            if(expected>0 && abs(previousDepth-previousExpected)>max(.2,previousExpected*.02)) weight=0;
            float3 bounded=BoundHDR(current,hdr);
            if(hdr && dot(bounded,float3(.25,.5,.25))<.1) return current;
            float3 lower=1e10,upper=-1e10,mean=0,square=0;
            [unroll] for(int y=-1;y<=1;y++) [unroll] for(int x=-1;x<=1;x++) {
                float3 c=YCoCg(BoundHDR(tex2D(_MainTex,uv+float2(x,y)*_RelinkScreen.xy).rgb,hdr));
                lower=min(lower,c);upper=max(upper,c);mean+=c/9;square+=c*c/9;
            }
            float3 deviation=sqrt(max(square-mean*mean,0));
            lower=max(lower,mean-1.5*deviation);upper=min(upper,mean+1.5*deviation);
            float3 old=YCoCg(BoundHDR(tex2D(history,previousUV).rgb,hdr));
            old=clamp(old,lower,upper);
            weight*=saturate(1-length(velocity*_RelinkScreen.zw)/100);
            float3 result=max(0,lerp(bounded,RGB(old),weight));
            return hdr?result/max(1-result,.001):result;
        }
        float4 LUT(v2f_img i):SV_Target {
            float3 source=tex2D(_MainTex,i.uv).rgb;
            if(_RelinkScenePost.x<.5 || Class(i.uv)>=9) return float4(source,1);
            float3 coord=saturate(log2(max(source,0)+1)/log2(17.0)); coord=coord*(31.0/32)+.5/32;
            float d=Depth(i.uv), blend=smoothstep(_RelinkScenePost.y,_RelinkScenePost.z,d);
            float3 nearColor=tex3D(_RelinkNearLUT,coord).rgb,farColor=tex3D(_RelinkFarLUT,coord).rgb;
            return float4(lerp(nearColor,farColor,blend),1);
        }
        float4 HDRResolve(v2f_img i):SV_Target {return float4(Resolve(i.uv,_RelinkHDRHistory,_RelinkTemporal.y,true),1);}
        float4 PostResolve(v2f_img i):SV_Target {return float4(Resolve(i.uv,_RelinkPostHistory,_RelinkTemporal.z,false),1);}
        float4 MotionBlur(v2f_img i):SV_Target {
            float2 velocity=Velocity(i.uv)*_RelinkTemporal.w;float depth=Depth(i.uv);
            if(length(velocity*_RelinkScreen.zw)<1) return tex2D(_MainTex,i.uv);
            float3 result=0;float total=0;
            [unroll] for(int j=0;j<8;j++) {
                float2 uv=saturate(i.uv+velocity*((j+.5)/8-.5));float sampleDepth=Depth(uv);
                float accept=abs(sampleDepth-depth)<max(.25,depth*.02)?1:0;
                result+=tex2D(_MainTex,uv).rgb*accept;total+=accept;
            }
            return float4(total>0?result/total:tex2D(_MainTex,i.uv).rgb,1);
        }
        float4 Exposure(v2f_img i):SV_Target {
            if(_RelinkAutoExposure<.5) return 1;
            // Events 23131/23178: eleven samples, reciprocal mean luminance, clamped lerp history.
            float2 positions[11]={float2(.5,.5),float2(.2,.5),float2(.8,.5),float2(.5,.2),float2(.5,.8),
                float2(.35,.35),float2(.65,.35),float2(.35,.65),float2(.65,.65),float2(.1,.5),float2(.9,.5)};
            float sum=0;
            [unroll] for(int j=0;j<11;j++) sum+=dot(tex2D(_MainTex,positions[j]).rgb,float3(.298912,.586611,.114478));
            float target=clamp(_RelinkExposureParams.w/max(sum/11,1e-5),_RelinkExposureParams.x,_RelinkExposureParams.y);
            float previous=tex2D(_RelinkExposureHistory,float2(.5,.5)).r;
            float value=_RelinkTemporal.x>.5?lerp(previous,target,_RelinkExposureParams.z):target;
            return clamp(value,_RelinkExposureParams.x,_RelinkExposureParams.y);
        }
        float4 Bloom(v2f_img i):SV_Target {
            float exposure=tex2D(_RelinkAdaptedExposure,float2(.5,.5)).r*_RelinkGrade.x;
            float3 c=max(tex2D(_MainTex,i.uv).rgb-_RelinkScenePost.w,0);
            return float4(max(RelinkSourceFilmic(c*exposure),0),1);
        }
        float4 Copy(v2f_img i):SV_Target {return tex2D(_MainTex,i.uv);}
        float4 Film(v2f_img i):SV_Target {
            float3 source=tex2D(_MainTex,i.uv).rgb;
            float exposure=tex2D(_RelinkAdaptedExposure,float2(.5,.5)).r*_RelinkGrade.x;
            float3 bloom=tex2D(_RelinkBloom0,i.uv).rgb*.18+tex2D(_RelinkBloom1,i.uv).rgb*.24+
                tex2D(_RelinkBloom2,i.uv).rgb*.24+tex2D(_RelinkBloom3,i.uv).rgb*.2+tex2D(_RelinkBloom4,i.uv).rgb*.14;
            return float4(saturate(RelinkSourceFilmic(max(source,0)*exposure)+bloom*_RelinkGrade.w),1);
        }
        float4 Lines(v2f_img i):SV_Target {
            float3 source=tex2D(_MainTex,i.uv).rgb;float depth=Depth(i.uv);uint category=Class(i.uv);
            if(_RelinkLineActive<.5 || depth<=0 || depth>_RelinkCamera.w*.99 || (category>=9 && category<=13)) return float4(source,1);
            float2 offset=_RelinkScreen.xy*_RelinkLine.w;
            float3 dx=tex2D(_MainTex,saturate(i.uv+float2(offset.x,0))).rgb-tex2D(_MainTex,saturate(i.uv-float2(offset.x,0))).rgb;
            float3 dy=tex2D(_MainTex,saturate(i.uv+float2(0,offset.y))).rgb-tex2D(_MainTex,saturate(i.uv-float2(0,offset.y))).rgb;
            float nearFactor=smoothstep(0,1,1-depth*.04);
            float center=1-smoothstep(.4,1,length((i.uv*2-1)*float2(1,.7)))*.3;
            float coefficient=lerp(_RelinkLine.x,_RelinkLine.y,nearFactor)*lerp(1.2,1,center);
            float amount=saturate((dot(dx,dx)+dot(dy,dy))*coefficient)*saturate(depth*.04)*_RelinkLine.z;
            if(_RelinkCapturedLineParameters>.5) {
                // Captured game uses centimetres; Unity town is authored in metres.
                float gameDepth=depth*100;
                float t=saturate((1-(gameDepth*.04+.6)*5-.765)/(.755-.765));
                float nearWeight=t*t*(3-2*t);
                float radial=length((i.uv*2-1)*float2(.799728,-.166710));
                t=saturate(radial/.966375);float centerWeight=saturate(1-t*t*(3-2*t));
                coefficient=lerp(3,lerp(2,6,nearWeight),centerWeight);
                amount=saturate((dot(dx,dx)+dot(dy,dy))*coefficient)*saturate((gameDepth*.04-3)*3)*_RelinkLine.z;
                return float4(max(0,source-(1-float3(.943119,.908003,.895963))*amount),1);
            }
            // 31705 modifies color gradients under depth/class control, not normal edges.
            return float4(max(0,source-(1-_RelinkLineTint.rgb)*amount),1);
        }
        float4 StoreDepth(v2f_img i):SV_Target {return Depth(i.uv);}
        float4 Sharpen(v2f_img i):SV_Target {
            float3 c=tex2D(_MainTex,i.uv).rgb;
            float3 a=tex2D(_MainTex,i.uv+float2(_RelinkScreen.x,0)).rgb,b=tex2D(_MainTex,i.uv-float2(_RelinkScreen.x,0)).rgb;
            float3 d=tex2D(_MainTex,i.uv+float2(0,_RelinkScreen.y)).rgb,e=tex2D(_MainTex,i.uv-float2(0,_RelinkScreen.y)).rgb;
            return float4(clamp(c+(c-(a+b+d+e)*.25)*.25,min(c,min(min(a,b),min(d,e))),max(c,max(max(a,b),max(d,e)))),1);
        }
        ENDCG
        Pass { Name "Near and far 3D LUT" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment LUT
            ENDCG }
        Pass { Name "HDR TAA" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment HDRResolve
            ENDCG }
        Pass { Name "Motion blur" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment MotionBlur
            ENDCG }
        Pass { Name "Luminance and adaptation" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Exposure
            ENDCG }
        Pass { Name "Bloom threshold" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Bloom
            ENDCG }
        Pass { Name "Bloom downsample" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Copy
            ENDCG }
        Pass { Name "Captured film curve" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Film
            ENDCG }
        Pass { Name "Color depth lines" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Lines
            ENDCG }
        Pass { Name "Post TAA" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment PostResolve
            ENDCG }
        Pass { Name "History depth" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment StoreDepth
            ENDCG }
        Pass { Name "Presentation sharpen" CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Sharpen
            ENDCG }
    }
    Fallback Off
}
