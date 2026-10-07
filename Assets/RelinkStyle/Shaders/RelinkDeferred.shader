Shader "Hidden/Relink/Deferred"
{
    SubShader
    {
        Tags { "RenderPipeline"="RelinkPipeline" }
        Cull Off ZTest Always ZWrite Off
        CGINCLUDE
        #pragma target 4.5
        #include "RelinkEnvironment.cginc"
        #include "RelinkSourceLighting.cginc"
        #include "RelinkLocalShadow.cginc"
        Texture2DArray<float> _RelinkParaboloidShadowArray;
        float4 _RelinkLocalShadowInfo[32];
        Texture2D<float4> _RelinkGBuffer0, _RelinkGBuffer1, _RelinkGBuffer2;
        Texture2D<float2> _RelinkGBuffer3;
        Texture2D<float> _RelinkDepthTexture, _RelinkScreenShadow;
        // D3D11's depth/stencil SRV places stencil in G. R8-only backends use R.
        Texture2D<uint2> _RelinkStencilTexture;
        Texture2D<float3> _RelinkIndirect, _RelinkLitColor;
        Texture2D<float3> _RelinkDirect;
        Texture2D<float4> _RelinkSubtractLight;
        SamplerState sampler_RelinkSubtractLight;
        float _RelinkClass5IgnoreShadow;
        float4x4 _RelinkInverseVP;
        float4 _RelinkClearColor;
        float _RelinkClearBackground;
        uint _RelinkClassMask;
        int _RelinkDeferredDebug;
        struct FullscreenVarying { float4 position : SV_POSITION; };
        FullscreenVarying FullscreenVertex(uint vertexID : SV_VertexID)
        {
            FullscreenVarying o;
            float2 uv = float2((vertexID << 1) & 2, vertexID & 2);
            o.position = float4(uv * 2 - 1, 0, 1);
            return o;
        }
        bool IsBackground(uint2 pixel)
        {
            float d = _RelinkDepthTexture.Load(int3(pixel, 0));
            #if defined(UNITY_REVERSED_Z)
                return d <= 0;
            #else
                return d >= 1;
            #endif
        }
        float3 WorldPosition(uint2 pixel)
        {
            float2 uv = (float2(pixel) + 0.5) * _RelinkScreen.xy;
            float2 xy = uv * 2 - 1;
            #if UNITY_UV_STARTS_AT_TOP
                xy.y = -xy.y;
            #endif
            float depth = _RelinkDepthTexture.Load(int3(pixel, 0));
            #if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES3)
                depth = depth * 2 - 1;
            #endif
            float4 world = mul(_RelinkInverseVP, float4(xy, depth, 1));
            return world.xyz / world.w;
        }
        uint Stencil(uint2 pixel)
        {
            uint2 value = _RelinkStencilTexture.Load(int3(pixel, 0));
            return value.x | value.y;
        }
        uint Classification(uint stencil) { return (stencil & 15) + ((stencil & 128) != 0 ? 9 : 0); }
        float3 ViewNormal(uint2 pixel) { return normalize(_RelinkGBuffer2.Load(int3(pixel, 0)).xyz * 2 - 1); }
        float3 WorldNormal(uint2 pixel) { return mul(transpose((float3x3)_RelinkView), ViewNormal(pixel)); }
        float4 DepthNormals(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            if (IsBackground(pixel)) return 0;
            return float4(_RelinkGBuffer2.Load(int3(pixel, 0)).rgb,
                -mul(_RelinkView, float4(WorldPosition(pixel), 1)).z);
        }
        float4 ScreenShadow(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            if (IsBackground(pixel)) return 1;
            return SunShadow(WorldPosition(pixel), WorldNormal(pixel)).xxxx;
        }
        float4 SunDirect(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            if (IsBackground(pixel)) return 0;
            uint category = Classification(Stencil(pixel));
            if (category >= 16 || (_RelinkClassMask & (1u << category)) == 0) return 0;
            float4 base = _RelinkGBuffer0.Load(int3(pixel, 0));
            float4 mask = _RelinkGBuffer1.Load(int3(pixel, 0));
            uint flags = uint(round(base.a * 255));
            float metallic = (flags & 64) != 0 ? 0 : mask.r;
            float3 world = WorldPosition(pixel);
            float3 n = ViewNormal(pixel);
            float3 v = normalize(-mul(_RelinkView, float4(world, 1)).xyz);
            float3 l = normalize(mul((float3x3)_RelinkView, _RelinkSunDirection.xyz));
            float shadow = _RelinkScreenShadow.Load(int3(pixel, 0));
            if (category == 5 && _RelinkClass5IgnoreShadow > 0.5) shadow = 1;
            float2 uv = (float2(pixel) + 0.5) * _RelinkScreen.xy;
            float3 radiance = max(_RelinkSunColor.rgb - _RelinkSubtractLight.SampleLevel(sampler_RelinkSubtractLight, uv, 0).rgb, 0);
            float3 result = RelinkSourceBRDF(base.rgb, metallic, mask.g, n, v, l, radiance) * shadow;
            return float4(result, (flags & 32) != 0 ? 1 : 0);
        }
        float4 IndirectFallback(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            if (IsBackground(pixel)) return 0;
            float3 albedo = _RelinkGBuffer0.Load(int3(pixel, 0)).rgb;
            float4 mask = _RelinkGBuffer1.Load(int3(pixel, 0));
            float3 ambient = lerp(_RelinkAmbientGround.rgb, _RelinkAmbientSky.rgb, WorldNormal(pixel).y * 0.5 + 0.5);
            if(_RelinkIBLSettings.z>.5) {
                float3 world=WorldPosition(pixel);
                uint flags=(uint)round(_RelinkGBuffer0.Load(int3(pixel,0)).a*255);
                float metal=(flags&64)!=0?0:mask.r;
                return float4(SceneIBL(world,WorldNormal(pixel),normalize(_RelinkCamera.xyz-world),albedo,metal,mask.g,mask.b),0);
            }
            return float4(albedo * ambient * mask.b * (1 - mask.r), 0);
        }
        float4 AddIndirect(FullscreenVarying i) : SV_Target { return float4(_RelinkIndirect.Load(int3(uint2(i.position.xy), 0)), 0); }
        float4 LocalLightsFallback(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            if (IsBackground(pixel)) return 0;
            float3 albedo = _RelinkGBuffer0.Load(int3(pixel, 0)).rgb;
            float4 mask = _RelinkGBuffer1.Load(int3(pixel, 0));
            float3 world = WorldPosition(pixel), n = WorldNormal(pixel), v = normalize(_RelinkCamera.xyz - world);
            float3 result = 0;
            [loop] for (int index = 0; index < _RelinkLightCount; index++)
            {
                float3 ray = _RelinkSceneLightPositions[index].xyz - world;
                float d2 = max(dot(ray, ray), 0.01);
                float3 l = ray * rsqrt(d2);
                float attenuation = saturate(1 - d2 * _RelinkSceneLightPositions[index].w);
                attenuation *= attenuation / max(d2, 1);
                float spot = saturate(dot(l, _RelinkSceneLightDirections[index].xyz) * _RelinkSceneLightSpots[index].x + _RelinkSceneLightSpots[index].y);
                result += RelinkSourceBRDF(albedo, mask.r, mask.g, n, v, l, _RelinkSceneLightColors[index].rgb * attenuation * spot * spot);
            }
            return float4(result, 0);
        }
        float4 AtmosphereFallback(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            float3 source = _RelinkLitColor.Load(int3(pixel, 0));
            if (IsBackground(pixel)) return float4(lerp(source, _RelinkClearColor.rgb, _RelinkClearBackground), 1);
            return float4(ApplyAtmosphere(source, WorldPosition(pixel)), 1);
        }
        float4 Diagnostic(FullscreenVarying i) : SV_Target
        {
            uint2 pixel = uint2(i.position.xy);
            if(_RelinkDeferredDebug==13) {
                float2 uv=(float2(pixel)+.5)*_RelinkScreen.xy;
                return float4(_RelinkSunShadowArray.Load(int4(int2(uv*(_RelinkPCSS.x-1)),0,0)).xxx,1);
            }
            if (IsBackground(pixel)) return float4(0, 0, 0, 1);
            if(_RelinkDeferredDebug==14) {
                float3 c=mul(_RelinkSunArrayMatrices[0],float4(WorldPosition(pixel),1)).xyz;
                return float4(c,1);
            }
            if(_RelinkDeferredDebug==15) {
                if(_RelinkLocalShadowInfo[0].y==2) {
                    int hemisphere;float3 p=RelinkParaboloidCoord(WorldPosition(pixel),_RelinkSceneLightPositions[0].xyz,_RelinkLocalShadowInfo[0].w,
                        rsqrt(_RelinkSceneLightPositions[0].w),hemisphere);
                    int layer=(int)_RelinkLocalShadowInfo[0].x+hemisphere;
                    return float4(p.z,RelinkParaboloidSample(_RelinkParaboloidShadowArray,p,layer),RelinkParaboloidVisibility(_RelinkParaboloidShadowArray,p,layer),1);
                }
                float4 c=mul(_RelinkLocalMatrices[4],float4(WorldPosition(pixel),1));float3 p=c.xyz/c.w;
                float sampleDepth=_RelinkLocalShadowArray.Load(int4(int2(p.xy*512),4,0));
                return float4(p.z,sampleDepth,_RelinkLocalShadowArray.SampleCmpLevelZero(sampler_RelinkLocalShadowArray,float3(p.xy,4),p.z+.0006),1);
            }
            if(_RelinkDeferredDebug==16) return float4(_RelinkLitColor.Load(int3(pixel,0)),1);
            if (_RelinkDeferredDebug == 5) return float4(_RelinkGBuffer0.Load(int3(pixel, 0)).rgb, 1);
            if (_RelinkDeferredDebug == 6) return float4(_RelinkGBuffer1.Load(int3(pixel, 0)).rgb, 1);
            if (_RelinkDeferredDebug == 7) return float4(_RelinkGBuffer3.Load(int3(pixel, 0)) * 20 + 0.5, 0.5, 1);
            if (_RelinkDeferredDebug == 8) return float4((float(Classification(Stencil(pixel))) / 24.0).xxx, 1);
            if (_RelinkDeferredDebug == 9) return float4(_RelinkDirect.Load(int3(pixel, 0)), 1);
            if (_RelinkDeferredDebug == 10) return float4(_RelinkScreenShadow.Load(int3(pixel, 0)).xxx, 1);
            if (_RelinkDeferredDebug == 11) return float4(_RelinkIndirect.Load(int3(pixel, 0)), 1);
            return float4(_RelinkGBuffer0.Load(int3(pixel, 0)).aaa, 1);
        }
        ENDCG
        Pass { Name "Depth normals adapter"
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment DepthNormals
            ENDCG
        }
        Pass { Name "Screen shadow adapter"
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment ScreenShadow
            ENDCG
        }
        Pass { Name "Captured directional lighting"
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment SunDirect
            ENDCG
        }
        Pass { Name "Hemisphere indirect fallback"
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment IndirectFallback
            ENDCG
        }
        Pass { Name "Add indirect" Blend One One
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment AddIndirect
            ENDCG
        }
        Pass { Name "Local lights fallback" Blend One One
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment LocalLightsFallback
            ENDCG
        }
        Pass { Name "Height fog fallback"
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment AtmosphereFallback
            ENDCG
        }
        Pass { Name "GBuffer diagnostics"
            CGPROGRAM
            #pragma vertex FullscreenVertex
            #pragma fragment Diagnostic
            ENDCG
        }
    }
    Fallback Off
}
