#ifndef RELINK_ENVIRONMENT_INCLUDED
#define RELINK_ENVIRONMENT_INCLUDED
#include "UnityCG.cginc"
#include "RelinkSourceLighting.cginc"

sampler2D _BaseMap, _BumpMap, _OcclusionMap, _HatchMap, _MaskMap;
float4x4 _RelinkCurrentVP, _RelinkPreviousVP, _RelinkView, _RelinkGPUProjection;
float _RelinkDeferredActive, _RelinkHistoryValid;
float4x4 unity_MatrixPreviousM;
float4 unity_MotionVectorsParams;
float _RelinkObjectMotion,_RelinkPreviousTime;
float4x4 _RelinkPreviousObjectToWorld;
float _RelinkCustomObjectHistory;
UNITY_DECLARE_SHADOWMAP(_RelinkShadowAtlas);
float4x4 _RelinkShadowMatrices[2];
float4 _RelinkCascadeSpheres[2], _RelinkShadowSettings;
float4 _RelinkSunColor, _RelinkSunDirection, _RelinkAmbientSky, _RelinkAmbientGround;
float4 _RelinkCamera, _RelinkFog, _RelinkFogColor;
float4 _RelinkScreen;
int _RelinkLightCount;
float4 _RelinkSceneLightPositions[32], _RelinkSceneLightColors[32], _RelinkSceneLightDirections[32], _RelinkSceneLightSpots[32];
#include "RelinkSceneLighting.cginc"

CBUFFER_START(UnityPerMaterial)
float4 _BaseMap_ST, _HatchMap_ST;
float4 _BaseColor, _ShadowColor, _EmissionColor, _TransmissionColor;
float _BumpScale, _OcclusionStrength, _Smoothness, _Metallic, _SpecularStrength;
float _DiffuseWrap, _BandStrength, _BandSoftness, _HatchStrength, _ProceduralHatching;
float _HatchDensity, _Transmission, _WindStrength, _WindSpeed, _WindScale;
float _AlphaClip, _Cutoff, _Cull, _SrcBlend, _DstBlend, _ZWrite;
float _UseMaskMap, _MaterialClass, _MaterialFlags;
float _GeometryOutlineWidth;
float4 _GeometryOutlineColor;
CBUFFER_END

struct Attributes
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv : TEXCOORD0;
    float2 lightmapUV : TEXCOORD1;
    float4 color : COLOR;
    float3 positionOld : TEXCOORD4;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
struct Varyings
{
    float4 position : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 world : TEXCOORD1;
    float3 normal : TEXCOORD2;
    float4 tangent : TEXCOORD3;
    float2 lightmapUV : TEXCOORD4;
    float2 rawUV : TEXCOORD5;
    float4 currentClip : TEXCOORD6;
    float4 previousClip : TEXCOORD7;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
float3 WindPosition(Attributes input)
{
    float3 world = mul(unity_ObjectToWorld, input.vertex).xyz;
    float phase = dot(world.xz, float2(0.7, 0.4)) * _WindScale + _Time.y * _WindSpeed;
    // Vertex red pins roots. With no vertex color, use Wind Strength = 0 on rigid meshes.
    world.xz += float2(sin(phase), cos(phase * 0.73)) * _WindStrength * input.color.r;
    return world;
}
Varyings EnvironmentVertex(Attributes input)
{
    Varyings output = (Varyings)0;
    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_TRANSFER_INSTANCE_ID(input, output);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
    output.world = WindPosition(input);
    output.position = mul(UNITY_MATRIX_VP, float4(output.world, 1));
    if (_RelinkDeferredActive > 0.5)
        output.position = mul(_RelinkCurrentVP, float4(output.world, 1));
    output.currentClip = output.position;
    output.previousClip = mul(_RelinkPreviousVP, float4(output.world, 1));
    if(_RelinkObjectMotion>.5 && _RelinkHistoryValid>.5) {
        float4 previousVertex=unity_MotionVectorsParams.x==1?float4(input.positionOld,1):input.vertex;
        float3 previousWorld=_RelinkCustomObjectHistory>.5?mul(_RelinkPreviousObjectToWorld,previousVertex).xyz:mul(unity_MatrixPreviousM,previousVertex).xyz;
        float phase=dot(previousWorld.xz,float2(.7,.4))*_WindScale+_RelinkPreviousTime*_WindSpeed;
        previousWorld.xz+=float2(sin(phase),cos(phase*.73))*_WindStrength*input.color.r;
        output.previousClip=mul(_RelinkPreviousVP,float4(previousWorld,1));
    }
    output.normal = UnityObjectToWorldNormal(input.normal);
    output.tangent = float4(UnityObjectToWorldDir(input.tangent.xyz), input.tangent.w * unity_WorldTransformParams.w);
    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.rawUV = input.uv;
    output.lightmapUV = input.lightmapUV * unity_LightmapST.xy + unity_LightmapST.zw;
    return output;
}
float4 SampleBase(float2 uv)
{
    float4 color = tex2D(_BaseMap, uv) * _BaseColor;
    clip(color.a - (_AlphaClip > 0.5 ? _Cutoff : -1));
    return color;
}
float3 SurfaceNormal(Varyings input, float facing)
{
    float3 n = normalize(input.normal) * (facing >= 0 ? 1 : -1);
    float3 t = normalize(input.tangent.xyz + 0.00001);
    float3 b = cross(n, t) * input.tangent.w;
    float3 map = UnpackNormal(tex2D(_BumpMap, input.uv));
    map.xy *= _BumpScale;
    return normalize(t * map.x + b * map.y + n * map.z);
}
float ShadowCascade(float3 world, int cascade)
{
    float3 coord = mul(_RelinkShadowMatrices[cascade], float4(world, 1)).xyz;
    float2 minimum = float2(cascade * 0.5, 0) + _RelinkShadowSettings.y * 1.5;
    float2 maximum = float2(cascade * 0.5 + 0.5, 0.5) - _RelinkShadowSettings.y * 1.5;
    if (coord.z <= 0 || coord.z >= 1) return 1;
    float sum = 0;
    [unroll] for (int y = -1; y <= 1; y++)
    [unroll] for (int x = -1; x <= 1; x++)
    {
        float2 uv = clamp(coord.xy + float2(x, y) * _RelinkShadowSettings.y, minimum, maximum);
        sum += UNITY_SAMPLE_SHADOW(_RelinkShadowAtlas, float3(uv, coord.z));
    }
    return sum / 9;
}
float SunShadow(float3 world, float3 normal)
{
    if (_RelinkShadowSettings.x <= 0) return 1;
    if(_RelinkAdvancedShadows>.5) {
        float4 clip=mul(_RelinkCurrentVP,float4(world,1));
        return SceneSunShadow(world,normal,clip.xy/clip.w*.5+.5);
    }
    float3 delta0 = world - _RelinkCascadeSpheres[0].xyz;
    float3 delta1 = world - _RelinkCascadeSpheres[1].xyz;
    float distance0 = dot(delta0, delta0) / max(_RelinkCascadeSpheres[0].w, 0.001);
    float distance1 = dot(delta1, delta1) / max(_RelinkCascadeSpheres[1].w, 0.001);
    if (distance1 > 1) return 1;
    world += normal * _RelinkShadowSettings.z;
    float value = ShadowCascade(world, distance0 < 1 ? 0 : 1);
    if (distance0 > 0.8 && distance0 < 1)
        value = lerp(value, ShadowCascade(world, 1), smoothstep(0.8, 1, distance0));
    float cameraDistance = distance(world, _RelinkCamera.xyz);
    float fade = 1 - smoothstep(_RelinkShadowSettings.w * 0.8, _RelinkShadowSettings.w, cameraDistance);
    return lerp(1, value, _RelinkShadowSettings.x * fade);
}
float3 DirectLighting(float3 albedo, float3 n, float3 view, float3 direction, float3 radiance, float shadow)
{
    if (_RelinkDeferredActive > 0.5)
        return RelinkSourceBRDF(albedo, _Metallic, 1 - _Smoothness, n, view, normalize(direction), radiance) * shadow;
    float ndl = dot(n, direction);
    float wrap = saturate((ndl + _DiffuseWrap) / (1 + _DiffuseWrap));
    float band = smoothstep(0.35 - _BandSoftness, 0.35 + _BandSoftness, wrap);
    float diffuse = lerp(wrap, band, _BandStrength) * shadow;
    float3 tint = lerp(_ShadowColor.rgb * 0.18, float3(1, 1, 1), diffuse);
    float3 halfDirection = normalize(view + direction + 0.00001);
    float specular = pow(saturate(dot(n, halfDirection)), exp2(2 + _Smoothness * 9)) * _SpecularStrength;
    float3 specColor = lerp(float3(0.12, 0.12, 0.12), albedo, _Metallic);
    float transmission = pow(saturate(dot(-direction, view)), 3) * saturate(-ndl + 0.25) * _Transmission;
    return radiance * (albedo * tint * (1 - _Metallic * 0.8)
        + specColor * specular * shadow * saturate(ndl)
        + albedo * _TransmissionColor.rgb * transmission * lerp(0.3, 1, shadow));
}
float3 ApplyAtmosphere(float3 color, float3 world)
{
    float distanceToCamera = distance(world, _RelinkCamera.xyz);
    return SceneFog(color,world);
}
float4 EnvironmentFragment(Varyings input, float facing : VFACE) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(input);
    float4 base = SampleBase(input.uv);
    float3 n = SurfaceNormal(input, facing);
    float3 view = normalize(_RelinkCamera.xyz - input.world);
    float ao = lerp(1, tex2D(_OcclusionMap, input.uv).g, _OcclusionStrength);
    float3 ambient = lerp(_RelinkAmbientGround.rgb, _RelinkAmbientSky.rgb, n.y * 0.5 + 0.5);
    #if defined(LIGHTMAP_ON)
        ambient += DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, input.lightmapUV));
    #else
        ambient += max(0, ShadeSH9(float4(n, 1))) * 0.25;
    #endif
    float shadow = SunShadow(input.world, n);
    float3 color = ambient * base.rgb * ao * (1 - _Metallic * 0.7);
    color += DirectLighting(base.rgb, n, view, _RelinkSunDirection.xyz, _RelinkSunColor.rgb, shadow);
    [loop] for (int i = 0; i < _RelinkLightCount; i++)
    {
        float3 ray = _RelinkSceneLightPositions[i].xyz - input.world;
        float d2 = max(dot(ray, ray), 0.01);
        float3 direction = ray * rsqrt(d2);
        float attenuation = saturate(1 - d2 * _RelinkSceneLightPositions[i].w);
        attenuation *= attenuation / max(d2, 1);
        float spot = saturate(dot(direction, _RelinkSceneLightDirections[i].xyz) * _RelinkSceneLightSpots[i].x + _RelinkSceneLightSpots[i].y);
        color += DirectLighting(base.rgb, n, view, direction, _RelinkSceneLightColors[i].rgb * attenuation * spot * spot, 1);
    }
    float shade = saturate(dot(n, _RelinkSunDirection.xyz)) * shadow;
    float ink = 1 - tex2D(_HatchMap, input.rawUV * _HatchMap_ST.xy + _HatchMap_ST.zw).r;
    float phase = dot(input.rawUV, float2(1, 0.43)) * _HatchDensity;
    float footprint = max(fwidth(phase), 0.001);
    float lines = (1 - smoothstep(0.08 - footprint, 0.08 + footprint, abs(frac(phase) - 0.5)))
        * (1 - smoothstep(0.3, 0.8, footprint));
    ink = max(ink, lines * _ProceduralHatching) * _HatchStrength * (1 - shade);
    color *= 1 - ink * 0.6;
    return float4(ApplyAtmosphere(color + _EmissionColor.rgb, input.world), base.a);
}
struct GBufferOutput
{
    float4 albedoFlags : SV_Target0;
    float4 material : SV_Target1;
    float4 normal : SV_Target2;
    float2 velocity : SV_Target3;
};
GBufferOutput GBufferFragment(Varyings input, float facing : VFACE)
{
    UNITY_SETUP_INSTANCE_ID(input);
    GBufferOutput output;
    float4 base = SampleBase(input.uv);
    float ao = lerp(1, tex2D(_OcclusionMap, input.uv).g, _OcclusionStrength);
    output.albedoFlags = float4(base.rgb, round(clamp(_MaterialFlags, 0, 255)) / 255.0);
    output.material = _UseMaskMap > 0.5 ? tex2D(_MaskMap, input.uv) : float4(_Metallic, 1 - _Smoothness, ao, 0);
    output.normal = float4(normalize(mul((float3x3)_RelinkView, SurfaceNormal(input, facing))) * 0.5 + 0.5, 0);
    float2 current = input.currentClip.xy / input.currentClip.w;
    float2 previous = input.previousClip.xy / input.previousClip.w;
    output.velocity = (current - previous) * 0.5 * _RelinkHistoryValid;
    #if UNITY_UV_STARTS_AT_TOP
        output.velocity.y = -output.velocity.y;
    #endif
    return output;
}
float4 EmissionFragment(Varyings input) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(input);
    float3 base=SampleBase(input.uv).rgb;
    float3 n=normalize(input.normal),v=normalize(_RelinkCamera.xyz-input.world);
    float transmission=saturate(dot(-n,_RelinkSunDirection.xyz))*(.25+.75*pow(saturate(dot(v,-_RelinkSunDirection.xyz)),2));
    return float4(_EmissionColor.rgb+base*_TransmissionColor.rgb*_RelinkSunColor.rgb*transmission*_Transmission*.12,0);
}
float4 DepthNormalsFragment(Varyings input, float facing : VFACE) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(input);
    SampleBase(input.uv);
    float3 normal = mul((float3x3)UNITY_MATRIX_V, SurfaceNormal(input, facing));
    return float4(normal * 0.5 + 0.5, -mul(UNITY_MATRIX_V, float4(input.world, 1)).z);
}
float4 _RelinkParaboloidPass,_RelinkParaboloidOrigin;
Varyings ShadowVertex(Attributes input)
{
    Varyings output=EnvironmentVertex(input);
    if(_RelinkParaboloidPass.x>.5) {
        float3 local=output.world-_RelinkParaboloidOrigin.xyz;
        if(_RelinkParaboloidPass.y>.5)local.xz=-local.xz;
        float radial=length(local);float3 direction=local/max(radial,1e-5);
        float z=(radial-_RelinkParaboloidPass.z)/max(_RelinkParaboloidOrigin.w-_RelinkParaboloidPass.z,.001);
        output.position=float4(direction.xy/max(direction.z+1,1e-5),z,1);
        #if defined(UNITY_REVERSED_Z)
        output.position.z=1-z;
        #endif
        // Same linear interpolation of normalized radial depth as source VS/PS 5825.
        output.previousClip=float4(direction.z,z,0,0);
    }
    return output;
}
float4 ShadowFragment(Varyings input) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(input);
    SampleBase(input.uv);
    if(_RelinkParaboloidPass.x>.5) {
        clip(input.previousClip.x+_RelinkParaboloidPass.w);clip(input.previousClip.y);clip(1-input.previousClip.y);
        return float4(input.previousClip.y,0,0,1);
    }
    return 0;
}
Varyings OutlineVertex(Attributes input)
{
    Varyings output=EnvironmentVertex(input);
    float3 n=normalize(mul((float3x3)_RelinkView,output.normal));
    float2 offset=mul((float3x3)_RelinkGPUProjection,n).xy;
    output.position.xy+=offset/max(length(offset),1e-5)*_GeometryOutlineWidth*2*_RelinkScreen.xy*output.position.w;
    return output;
}
float4 OutlineFragment(Varyings input):SV_Target
{
    clip(_GeometryOutlineWidth-.001);
    SampleBase(input.uv);
    return _GeometryOutlineColor;
}
#endif
