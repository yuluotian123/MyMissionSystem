#ifndef RELINK_SOURCE_LIGHTING_INCLUDED
#define RELINK_SOURCE_LIGHTING_INCLUDED

// standard_d3d11_frame10803, PS event 20304. This is not a generic GGX model.
// The captured directional variant has no dielectric F0 or Schlick Fresnel term.
float3 RelinkSourceBRDF(float3 albedo, float metallic, float roughness,
    float3 normal, float3 view, float3 light, float3 radiance)
{
    roughness = clamp(roughness, 0.04, 1.0);
    float nl = saturate(dot(normal, light));
    float3 h = normalize(view + light + 1e-8);
    float nh = saturate(dot(normal, h));
    float lh = saturate(dot(light, h));
    float r2 = roughness * roughness;
    float r4 = r2 * r2;
    float d = nh * nh * (r4 - 1.0) + 1.0;
    float denominator = 12.5663706144 * (roughness + 0.5) * (lh * d) * (lh * d);
    // Guard the singular grazing configuration; all nondegenerate inputs follow the bytecode.
    float specular = r4 / max(denominator, 1e-8);
    return albedo * radiance * nl * ((1.0 - metallic) * 0.3183098862 + metallic * specular);
}

float3 RelinkSourceFilmic(float3 x)
{
    return ((x * (0.15 * x + 0.05) + 0.004) / (x * (0.15 * x + 0.5) + 0.06)
        - 0.0666666667) * 1.379064;
}
#endif
