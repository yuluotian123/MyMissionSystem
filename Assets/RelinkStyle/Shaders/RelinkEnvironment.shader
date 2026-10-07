Shader "Relink/Environment"
{
    Properties
    {
        [MainTexture] _BaseMap ("Painted Albedo", 2D) = "white" {}
        [MainColor] _BaseColor ("Color", Color) = (1,1,1,1)
        [Normal] _BumpMap ("Normal", 2D) = "bump" {}
        _BumpScale ("Normal Strength", Range(0,2)) = 1
        _OcclusionMap ("Occlusion (G)", 2D) = "white" {}
        _OcclusionStrength ("Occlusion Strength", Range(0,1)) = 1
        _ShadowColor ("Colored Shade", Color) = (0.48,0.56,0.72,1)
        _DiffuseWrap ("Diffuse Wrap", Range(0,1)) = 0.2
        _BandStrength ("Illustrated Light Bands", Range(0,1)) = 0.25
        _BandSoftness ("Band Softness", Range(0.01,0.5)) = 0.22
        _Smoothness ("Smoothness", Range(0,1)) = 0.25
        _Metallic ("Metallic", Range(0,1)) = 0
        _MaskMap ("Deferred Mask (Metal / Rough / Indirect / Reserved)", 2D) = "white" {}
        [Toggle] _UseMaskMap ("Use Deferred Mask Map", Float) = 0
        [IntRange] _MaterialClass ("Stencil (Low 4 Bits Class / Bit 7 Offset)", Range(0,255)) = 1
        [IntRange] _MaterialFlags ("GBuffer Flags (32 Alpha / 64 Nonmetal)", Range(0,255)) = 0
        _SpecularStrength ("Specular Strength", Range(0,3)) = 0.5
        [HDR] _EmissionColor ("Emission", Color) = (0,0,0,1)
        _HatchMap ("Authored Hatching (White = none)", 2D) = "white" {}
        _HatchStrength ("Shadow Hatching", Range(0,1)) = 0.12
        [Toggle] _ProceduralHatching ("Procedural Hatching Preview", Float) = 0
        _HatchDensity ("Hatch Density", Range(5,200)) = 60
        _Transmission ("Foliage Transmission", Range(0,2)) = 0
        _TransmissionColor ("Transmission Tint", Color) = (1,0.9,0.5,1)
        _WindStrength ("Wind Strength (Vertex R)", Range(0,1)) = 0
        _WindSpeed ("Wind Speed", Range(0,5)) = 1.4
        _WindScale ("Wind Scale", Range(0.1,5)) = 1
        _GeometryOutlineWidth ("Optional Geometry Outline (pixels)", Range(0,5)) = 0
        _GeometryOutlineColor ("Geometry Outline Color", Color) = (0.08,0.10,0.16,1)
        [Toggle] _AlphaClip ("Alpha Clip", Float) = 0
        _Cutoff ("Cutoff", Range(0,1)) = 0.5
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2
        [HideInInspector] _SrcBlend ("Source Blend", Float) = 1
        [HideInInspector] _DstBlend ("Destination Blend", Float) = 0
        [HideInInspector] _ZWrite ("Depth Write", Float) = 1
    }
    SubShader
    {
        Tags { "RenderPipeline"="RelinkPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
        Cull [_Cull]
        Pass
        {
            Name "Optional geometry outline"
            Tags { "LightMode"="RelinkOutline" }
            Cull Front ZWrite Off Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex OutlineVertex
            #pragma fragment OutlineFragment
            #include "RelinkEnvironment.cginc"
            ENDCG
        }
        Pass
        {
            Name "GBuffer"
            Tags { "LightMode"="RelinkGBuffer" }
            ZWrite On
            Stencil { Ref [_MaterialClass] Comp Always Pass Replace WriteMask 255 }
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex EnvironmentVertex
            #pragma fragment GBufferFragment
            #pragma multi_compile_instancing
            #include "RelinkEnvironment.cginc"
            ENDCG
        }
        Pass
        {
            Name "Emission"
            Tags { "LightMode"="RelinkEmission" }
            ZWrite Off ZTest Equal Blend One One
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex EnvironmentVertex
            #pragma fragment EmissionFragment
            #pragma multi_compile_instancing
            #include "RelinkEnvironment.cginc"
            ENDCG
        }
        Pass
        {
            Name "Environment"
            Tags { "LightMode"="RelinkForward" }
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex EnvironmentVertex
            #pragma fragment EnvironmentFragment
            #pragma multi_compile_instancing
            #pragma multi_compile _ LIGHTMAP_ON
            #include "RelinkEnvironment.cginc"
            ENDCG
        }
        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode"="RelinkDepthNormals" }
            ZWrite On
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex EnvironmentVertex
            #pragma fragment DepthNormalsFragment
            #pragma multi_compile_instancing
            #include "RelinkEnvironment.cginc"
            ENDCG
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }
            ZWrite On
            ColorMask R
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex ShadowVertex
            #pragma fragment ShadowFragment
            #pragma multi_compile_instancing
            #include "RelinkEnvironment.cginc"
            ENDCG
        }
    }
    Fallback Off
}
