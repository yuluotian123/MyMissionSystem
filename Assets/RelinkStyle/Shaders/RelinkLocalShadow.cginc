#ifndef RELINK_LOCAL_SHADOW_INCLUDED
#define RELINK_LOCAL_SHADOW_INCLUDED
// Source 5825 / 23009: two hemispheres, stereographic xy and radial near/far.
// Unity D3D11 render-target sampling requires negative Y in the texture mapping.
float3 RelinkParaboloidCoord(float3 world,float3 origin,float near,float radius,out int hemisphere) {
    float3 ray=world-origin;float distanceToLight=length(ray);
    hemisphere=ray.z<0?1:0;
    if(hemisphere==1)ray.xz=-ray.xz;
    float3 direction=ray/max(distanceToLight,1e-5);
    return float3(direction.xy*float2(.5,-.5)/max(1+direction.z,1e-5)+.5,
        (distanceToLight-near)/max(radius-near,.001));
}
float RelinkParaboloidSample(Texture2DArray<float> shadowTexture,float3 coord,int layer) {
    return shadowTexture.Load(int4(clamp(int2(coord.xy*512),0,511),layer,0));
}
float RelinkParaboloidVisibility(Texture2DArray<float> shadowTexture,float3 coord,int layer) {
    if(coord.z<=0 || coord.z>=1)return 1;
    float result=0;
    // Sixteen radial comparisons. Kernel footprint is a Unity scene adaptation.
    [unroll] for(int y=0;y<4;y++)[unroll] for(int x=0;x<4;x++) {
        float2 uv=coord.xy+(float2(x,y)-1.5)/512;
        float depth=shadowTexture.Load(int4(clamp(int2(uv*512),0,511),layer,0));
        result+=(coord.z-.001<=depth)?1:0;
    }
    return result/16;
}
#endif
