Shader "Hidden/Relink/Composite"
{
    Properties { [HideInInspector] _MainTex ("Source", 2D) = "white" {} }
    SubShader
    {
        Cull Off ZTest Always ZWrite Off
        CGINCLUDE
        #include "UnityCG.cginc"
        #include "RelinkSourceLighting.cginc"
        float _RelinkDeferredActive;
        sampler2D _MainTex, _RelinkBloom, _RelinkDepthNormals;
        float4 _MainTex_TexelSize, _RelinkGrade, _RelinkPost, _RelinkBlurDirection, _RelinkOutlineColor;
        float4 Prefilter(v2f_img i) : SV_Target
        {
            float3 c = tex2D(_MainTex, i.uv).rgb;
            float brightness = max(c.r, max(c.g, c.b));
            c *= max(0, brightness - _RelinkPost.x) / max(brightness, 0.0001);
            return float4(c, 1);
        }
        float4 Blur(v2f_img i) : SV_Target
        {
            float2 stepUV = _MainTex_TexelSize.xy * _RelinkBlurDirection.xy;
            float3 c = tex2D(_MainTex, i.uv).rgb * 0.227027;
            c += tex2D(_MainTex, i.uv + stepUV * 1.384615).rgb * 0.316216;
            c += tex2D(_MainTex, i.uv - stepUV * 1.384615).rgb * 0.316216;
            c += tex2D(_MainTex, i.uv + stepUV * 3.230769).rgb * 0.070270;
            c += tex2D(_MainTex, i.uv - stepUV * 3.230769).rgb * 0.070270;
            return float4(c, 1);
        }
        float Difference(float4 a, float4 b)
        {
            // Background has depth 0. Suppress normal edges there, retain geometry silhouettes.
            float depthEdge = abs(a.a - b.a) / max(min(a.a, b.a), 0.5);
            float normalEdge = length(a.rgb - b.rgb) * step(0.001, min(a.a, b.a));
            return max(smoothstep(0.015, 0.065, depthEdge), smoothstep(0.25, 0.55, normalEdge));
        }
        float4 Composite(v2f_img i) : SV_Target
        {
            float3 source = tex2D(_MainTex, i.uv).rgb;
            float4 center = tex2D(_RelinkDepthNormals, i.uv);
            float2 stepUV = abs(_MainTex_TexelSize.xy) * _RelinkPost.z;
            float edge = 0;
            edge = max(edge, Difference(center, tex2D(_RelinkDepthNormals, i.uv + float2(stepUV.x, 0))));
            edge = max(edge, Difference(center, tex2D(_RelinkDepthNormals, i.uv - float2(stepUV.x, 0))));
            edge = max(edge, Difference(center, tex2D(_RelinkDepthNormals, i.uv + float2(0, stepUV.y))));
            edge = max(edge, Difference(center, tex2D(_RelinkDepthNormals, i.uv - float2(0, stepUV.y))));
            if (_RelinkPost.w > 0.5 && _RelinkPost.w < 1.5) return float4(source, 1);
            if (_RelinkPost.w > 1.5 && _RelinkPost.w < 2.5) return float4(center.rgb, 1);
            if (_RelinkPost.w > 2.5 && _RelinkPost.w < 3.5) return float4((center.a / 100).xxx, 1);
            if (_RelinkPost.w > 3.5) return float4(edge.xxx, 1);
            if (_RelinkDeferredActive > 0.5)
            {
                // Event 31660: expose -> filmic -> additive bloom -> clamp.
                // Linear output: Unity's sRGB target performs the single transfer encoding.
                return float4(saturate(RelinkSourceFilmic(max(source, 0) * _RelinkGrade.x)
                    + tex2D(_RelinkBloom, i.uv).rgb * _RelinkGrade.w), 1);
            }
            float3 c = (source + tex2D(_RelinkBloom, i.uv).rgb * _RelinkGrade.w) * _RelinkGrade.x;
            c = lerp(c, c * _RelinkOutlineColor.rgb, edge * _RelinkPost.y);
            // Fitted filmic curve, adjustable independently from lighting.
            c = saturate((c * (2.51 * c + 0.03)) / (c * (2.43 * c + 0.59) + 0.14));
            float luminance = dot(c, float3(0.2126, 0.7152, 0.0722));
            c = lerp(luminance.xxx, c, _RelinkGrade.y);
            c = (c - 0.18) * _RelinkGrade.z + 0.18;
            return float4(saturate(c), 1);
        }
        ENDCG
        Pass
        {
            Name "Bloom threshold"
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Prefilter
            ENDCG
        }
        Pass
        {
            Name "Bloom blur"
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Blur
            ENDCG
        }
        Pass
        {
            Name "Illustration composite"
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment Composite
            ENDCG
        }
    }
}
