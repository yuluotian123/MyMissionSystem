Shader "Relink/Painted Sky"
{
    Properties
    {
        _Zenith ("Zenith", Color) = (0.18,0.44,0.67,1)
        _Horizon ("Horizon", Color) = (0.7,0.84,0.88,1)
        _CloudColor ("Cloud light", Color) = (1,0.96,0.85,1)
        _CloudShade ("Cloud shade", Color) = (0.59,0.69,0.78,1)
        _CloudCoverage ("Cloud coverage", Range(0,1)) = 0.45
        _SkyCube ("Sky radiance cube", Cube) = "" {}
        [Toggle] _UseSkyCube ("Use sky cube",Float)=0
    }
    SubShader
    {
        Tags { "RenderPipeline"="RelinkPipeline" "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
        Cull Off ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            float4 _Zenith, _Horizon, _CloudColor, _CloudShade, _RelinkSunDirection;
            float _CloudCoverage;
            samplerCUBE _SkyCube;
            float _UseSkyCube;
            float _RelinkDeferredActive;
            float4x4 _RelinkGPUProjection, _RelinkView;
            struct Varying { float4 position : SV_POSITION; float3 direction : TEXCOORD0; };
            Varying vert(float4 vertex : POSITION)
            {
                Varying o;
                o.position = UnityObjectToClipPos(vertex);
                if (_RelinkDeferredActive > 0.5)
                    o.position = mul(_RelinkGPUProjection, float4(mul((float3x3)_RelinkView, vertex.xyz), 1));
                #if defined(UNITY_REVERSED_Z)
                    o.position.z = 0;
                #else
                    o.position.z = o.position.w;
                #endif
                o.direction = vertex.xyz;
                return o;
            }
            float hash(float2 p) { return frac(sin(dot(p, float2(127.1,311.7))) * 43758.5453); }
            float noise(float2 p)
            {
                float2 f = frac(p), q = floor(p); f = f * f * (3 - 2 * f);
                return lerp(lerp(hash(q),hash(q+float2(1,0)),f.x),lerp(hash(q+float2(0,1)),hash(q+1),f.x),f.y);
            }
            float4 frag(Varying i) : SV_Target
            {
                float3 direction = normalize(i.direction);
                if(_UseSkyCube>.5) return float4(texCUBE(_SkyCube,direction).rgb,1);
                float3 sky = lerp(_Horizon.rgb, _Zenith.rgb, pow(saturate(direction.y), 0.65));
                float2 uv = direction.xz / max(direction.y + 0.25, 0.05) * 2.5;
                float clouds = noise(uv) * 0.6 + noise(uv * 2.1) * 0.28 + noise(uv * 4.3) * 0.12;
                float threshold = 1 - _CloudCoverage;
                float shape = smoothstep(threshold - 0.06, threshold + 0.12, clouds) * smoothstep(0, 0.15, direction.y);
                float3 cloudColor = lerp(_CloudShade.rgb, _CloudColor.rgb, smoothstep(threshold, threshold + 0.25, clouds));
                sky = lerp(sky, cloudColor, shape);
                float sun = pow(saturate(dot(direction, normalize(_RelinkSunDirection.xyz))), 500);
                return float4(sky + sun * float3(2.5,2.1,1.4),1);
            }
            ENDCG
        }
    }
}
