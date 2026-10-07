#ifndef RELINK_SCENE_LIGHTING
#define RELINK_SCENE_LIGHTING
Texture2DArray<float> _RelinkSunShadowArray, _RelinkLocalShadowArray;
SamplerComparisonState sampler_RelinkSunShadowArray, sampler_RelinkLocalShadowArray;
float4x4 _RelinkSunArrayMatrices[3], _RelinkLocalMatrices[16];
float4 _RelinkCascadeDistances, _RelinkPCSS;
float _RelinkAdvancedShadows;
int _RelinkSampleFrame;
float2 Spiral(int i,int count,float rotation) {
    float angle=i*2.4+rotation;
    return float2(sin(angle),cos(angle))*sqrt((i+.5)/count);
}
float PCSS(float3 world,int layer,float rotation) {
    float4 clip=mul(_RelinkSunArrayMatrices[layer],float4(world,1));
    float3 coord=clip.xyz/clip.w;
    if(any(coord.xy<0)||any(coord.xy>1)||coord.z<=0||coord.z>=1) return 1;
    float scale=layer==0?1:layer==1?.08:.025;
    // 19735: 32 spiral blockers, relative depth squared *128, 24 comparison taps.
    float energy=0, blockers=0;
    float search=scale*.854167*_RelinkPCSS.y*_RelinkPCSS.z;
    [loop] for(int i=0;i<32;i++) {
        int2 p=int2(saturate(coord.xy+Spiral(i,32,rotation)*search)*(_RelinkPCSS.x-1));
        float sampleDepth=_RelinkSunShadowArray.Load(int4(p,layer,0));
        #if defined(UNITY_REVERSED_Z)
        bool blocker=coord.z<sampleDepth;
        #else
        bool blocker=coord.z>sampleDepth;
        #endif
        if(blocker) { energy+=min(pow((coord.z-sampleDepth)/max(sampleDepth,1e-5),2)*128,1); blockers++; }
    }
    float radius=1.5+24*scale*.854167*(blockers>0?energy/blockers:0)*_RelinkPCSS.z;
    float result=0;
    [loop] for(int j=0;j<24;j++) result+=_RelinkSunShadowArray.SampleCmpLevelZero(sampler_RelinkSunShadowArray,
        float3(saturate(coord.xy+Spiral(j,24,rotation)*radius/_RelinkPCSS.x),layer),coord.z);
    return result/24;
}
float SceneSunShadow(float3 world,float3 normal,float2 uv) {
    world+=normal*_RelinkShadowSettings.z;
    float d=distance(world,_RelinkCamera.xyz);
    int layer=d>_RelinkCascadeDistances.y-.5?2:d>_RelinkCascadeDistances.x-.5?1:0;
    float rotation=frac(sin(dot(uv*((_RelinkSampleFrame%100)+.01),float2(12.9898,78.233002)))*43758.546875)*6.283185;
    float result=PCSS(world,layer,rotation);
    float split=layer==1?_RelinkCascadeDistances.x:_RelinkCascadeDistances.y;
    if(layer>0 && d<split+.5) result=lerp(PCSS(world,layer-1,rotation),result,saturate(d-(split-.5)));
    result=lerp(result,1,saturate(d-(_RelinkCascadeDistances.z-.5)));
    return lerp(1,result,_RelinkShadowSettings.x);
}
TextureCube<float4> _RelinkEnvironmentCube, _RelinkLocalCube0, _RelinkLocalCube1;
TextureCube<float4> _RelinkDiffuseCube;
TextureCube<float4> _RelinkLocalDiffuse0,_RelinkLocalDiffuse1;
SamplerState sampler_RelinkLocalDiffuse0,sampler_RelinkLocalDiffuse1;
SamplerState sampler_RelinkDiffuseCube;
SamplerState sampler_RelinkEnvironmentCube, sampler_RelinkLocalCube0, sampler_RelinkLocalCube1;
Texture2D<float2> _RelinkEnvironmentBRDF;
SamplerState sampler_RelinkEnvironmentBRDF;
float4 _RelinkIBLSettings;
float4 _RelinkProbeMin[2],_RelinkProbeMax[2],_RelinkProbePosition[2],_RelinkProbeTint[2];
int _RelinkProbeCount;
float ProbeWeight(float3 p,int index) {
    float3 edge=min(p-_RelinkProbeMin[index].xyz,_RelinkProbeMax[index].xyz-p);
    return saturate(min(edge.x,min(edge.y,edge.z))/max(_RelinkProbeMin[index].w,.001));
}
float3 BoxProject(float3 position,float3 ray,int index) {
    float3 safe=sign(ray+1e-7)*max(abs(ray),1e-5);
    float3 t0=(_RelinkProbeMax[index].xyz-position)/safe;
    float3 t1=(_RelinkProbeMin[index].xyz-position)/safe;
    float3 t=max(t0,t1); float distanceToBox=min(t.x,min(t.y,t.z));
    return position+ray*distanceToBox-_RelinkProbePosition[index].xyz;
}
float3 SceneIBL(float3 world,float3 n,float3 view,float3 albedo,float metallic,float rough,float occlusion) {
    float3 reflection=reflect(-view,n); float mip=rough*_RelinkIBLSettings.y;
    float3 diffuse=_RelinkDiffuseCube.SampleLevel(sampler_RelinkDiffuseCube,n,0).rgb;
    float3 spec=_RelinkEnvironmentCube.SampleLevel(sampler_RelinkEnvironmentCube,reflection,mip).rgb;
    float remaining=1;float3 localDiffuse=0,localSpec=0;
    [loop] for(int i=0;i<_RelinkProbeCount;i++) {
        float weight=ProbeWeight(world,i)*remaining; float3 direction=BoxProject(world,reflection,i);
        float localMip=rough*_RelinkProbeMax[i].w;
        float3 local=i==0?_RelinkLocalCube0.SampleLevel(sampler_RelinkLocalCube0,direction,localMip).rgb
            :_RelinkLocalCube1.SampleLevel(sampler_RelinkLocalCube1,direction,localMip).rgb;
        float3 irradiance=i==0?_RelinkLocalDiffuse0.SampleLevel(sampler_RelinkLocalDiffuse0,n,0).rgb
            :_RelinkLocalDiffuse1.SampleLevel(sampler_RelinkLocalDiffuse1,n,0).rgb;
        localSpec+=local*_RelinkProbeTint[i].rgb*_RelinkProbeTint[i].a*weight;
        localDiffuse+=irradiance*_RelinkProbeTint[i].rgb*_RelinkProbeTint[i].a*weight;
        remaining-=weight;
    }
    spec=spec*remaining+localSpec;diffuse=diffuse*remaining+localDiffuse;
    float2 brdf=_RelinkEnvironmentBRDF.SampleLevel(sampler_RelinkEnvironmentBRDF,float2(saturate(dot(n,view)),rough),0);
    float3 specularMaterial=lerp(.04,albedo,metallic)*brdf.x+brdf.y;
    if(_RelinkIBLSettings.w>.5) specularMaterial=albedo*metallic*brdf.x+brdf.y*(1-pow(rough,4));
    return (diffuse*albedo*(1-metallic)+spec*specularMaterial)*occlusion*_RelinkIBLSettings.x;
}
float4 _RelinkRegionFogMin[4],_RelinkRegionFogMax[4],_RelinkRegionFogColor[4];
int _RelinkRegionFogCount;
float3 SceneFog(float3 color,float3 world) {
    float distanceToCamera=distance(world,_RelinkCamera.xyz);
    float dy=(world.y-_RelinkCamera.y)*_RelinkFog.z;
    // Analytic integral of exponential height density along the view segment.
    float average=abs(dy)<.001?1:(1-exp(clamp(-dy,-20,20)))/dy;
    float optical=distanceToCamera*_RelinkFog.x*exp(clamp(-(_RelinkCamera.y-_RelinkFog.y)*_RelinkFog.z,-10,5))*average;
    float3 fogColor=_RelinkFogColor.rgb;
    [loop] for(int i=0;i<_RelinkRegionFogCount;i++) {
        float3 edge=min(world-_RelinkRegionFogMin[i].xyz,_RelinkRegionFogMax[i].xyz-world);
        float weight=saturate(min(edge.x,min(edge.y,edge.z))/max(_RelinkRegionFogMin[i].w,.001));
        optical+=distanceToCamera*weight*_RelinkRegionFogColor[i].a;
        fogColor=lerp(fogColor,_RelinkRegionFogColor[i].rgb,weight);
    }
    return lerp(color,fogColor,saturate(1-exp(-max(0,optical))));
}
#endif
