using System;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using UnityEditor.SceneManagement;

namespace MyMission.Rendering.Editor
{
    public static class RelinkLightingBaker
    {
        const string Root="Assets/RelinkStyle/Generated/Town/Textures/";
        public static void BuildLighting(RelinkRenderPipelineAsset profile) {
            Directory.CreateDirectory(Root); AssetDatabase.Refresh();
            profile.environmentCube=SkyCube(); profile.environmentBRDF=BRDF();
            profile.environmentDiffuseCube=DiffuseCube();
            profile.nearLUT=LUT(false); profile.farLUT=LUT(true); EditorUtility.SetDirty(profile);
        }
        static Vector3 FaceDirection(int face,float u,float v) {
            float x=2*u-1,y=2*v-1;
            switch(face) {
                case 0:return new Vector3(1,-y,-x).normalized;
                case 1:return new Vector3(-1,-y,x).normalized;
                case 2:return new Vector3(x,1,y).normalized;
                case 3:return new Vector3(x,-1,-y).normalized;
                case 4:return new Vector3(x,-y,1).normalized;
                default:return new Vector3(-x,-y,-1).normalized;
            }
        }
        static float Noise(Vector2 p) {
            float x=Mathf.Floor(p.x),y=Mathf.Floor(p.y),u=p.x-x,v=p.y-y; u=u*u*(3-2*u);v=v*v*(3-2*v);
            Func<float,float,float> hash=(a,b)=> {float f=Mathf.Sin(a*127.1f+b*311.7f)*43758.5453f; return f-Mathf.Floor(f);};
            return Mathf.Lerp(Mathf.Lerp(hash(x,y),hash(x+1,y),u),Mathf.Lerp(hash(x,y+1),hash(x+1,y+1),u),v);
        }
        static Color Sky(Vector3 direction) {
            if(direction.y<0) return new Color(.46f,.42f,.32f);
            var c=Color.Lerp(new Color(.62f,1.15f,1.8f),new Color(.09f,.58f,1.65f),Mathf.Pow(direction.y,.5f));
            var p=new Vector2(direction.x,direction.z)/Mathf.Max(direction.y+.32f,.12f)*3.2f;
            float clouds=Noise(p)*.6f+Noise(p*2.1f)*.28f+Noise(p*4.3f)*.12f;
            float shape=Mathf.SmoothStep(0,1,Mathf.Clamp01((clouds-.48f)/.15f))*Mathf.SmoothStep(0,1,direction.y/.1f);
            var cloud=Color.Lerp(new Color(1.3f,1.7f,2.25f),new Color(5,4.9f,4.7f),Mathf.Clamp01((clouds-.48f)/.25f));
            return Color.Lerp(c,cloud,shape);
        }
        static Vector3 GGX(Vector3 normal,float rough,float u,float v) {
            float alpha=Mathf.Max(.001f,rough*rough),phi=2*Mathf.PI*u;
            float cos=Mathf.Sqrt((1-v)/(1+(alpha*alpha-1)*v)),sin=Mathf.Sqrt(Mathf.Max(0,1-cos*cos));
            var t=Vector3.Cross(Mathf.Abs(normal.y)<.99f?Vector3.up:Vector3.right,normal).normalized;
            return t*(Mathf.Cos(phi)*sin)+Vector3.Cross(normal,t)*(Mathf.Sin(phi)*sin)+normal*cos;
        }
        static float RadicalInverse(uint value) {
            value=(value<<16)|(value>>16);value=((value&0x55555555u)<<1)|((value&0xAAAAAAAAu)>>1);
            value=((value&0x33333333u)<<2)|((value&0xCCCCCCCCu)>>2);value=((value&0x0F0F0F0Fu)<<4)|((value&0xF0F0F0F0u)>>4);
            value=((value&0x00FF00FFu)<<8)|((value&0xFF00FF00u)>>8); return value*2.3283064365386963e-10f;
        }
        public static Cubemap Convolve(Func<Vector3,Color> sample,int size,string name) {
            var cube=new Cubemap(size,TextureFormat.RGBAHalf,true) {name=name,filterMode=FilterMode.Trilinear,wrapMode=TextureWrapMode.Clamp};
            for(int mip=0;mip<cube.mipmapCount;mip++) for(int face=0;face<6;face++) {
                int n=Mathf.Max(1,size>>mip); var pixels=new Color[n*n]; float rough=(float)mip/(cube.mipmapCount-1);
                for(int y=0;y<n;y++) for(int x=0;x<n;x++) {
                    Vector3 normal=FaceDirection(face,(x+.5f)/n,(y+.5f)/n); Color sum=Color.clear;float total=0;
                    int count=mip==0?1:64;
                    for(uint i=0;i<count;i++) {
                        var h=mip==0?normal:GGX(normal,rough,(i+.5f)/count,RadicalInverse(i));
                        var l=(2*Vector3.Dot(normal,h)*h-normal).normalized;float weight=Mathf.Max(0,Vector3.Dot(normal,l));
                        sum+=sample(l)*weight;total+=weight;
                    }
                    pixels[y*n+x]=sum/Mathf.Max(total,.001f);
                }
                cube.SetPixels(pixels,(CubemapFace)face,mip);
            }
            cube.Apply(false,false); return cube;
        }
        static Cubemap SkyCube() {
            string path=Root+"Daylight GGX environment.asset"; var cube=AssetDatabase.LoadAssetAtPath<Cubemap>(path);
            if(cube!=null) return cube;
            cube=Convolve(Sky,128,"Daylight GGX environment"); AssetDatabase.CreateAsset(cube,path); return cube;
        }
        static Texture2D BRDF() {
            string path=Root+"Split sum BRDF.asset";var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(path); if(texture!=null) return texture;
            const int size=128,samples=128;
            texture=new Texture2D(size,size,TextureFormat.RGHalf,false,true) {name="Integrated GGX BRDF",wrapMode=TextureWrapMode.Clamp};
            for(int y=0;y<size;y++) for(int x=0;x<size;x++) {
                float nv=(x+.5f)/size,rough=(y+.5f)/size;var view=new Vector3(Mathf.Sqrt(1-nv*nv),0,nv); float a=0,b=0;
                for(uint i=0;i<samples;i++) {
                    var half=GGX(Vector3.forward,rough,(i+.5f)/samples,RadicalInverse(i));
                    var light=(2*Vector3.Dot(view,half)*half-view).normalized;float nl=Mathf.Max(light.z,0),nh=Mathf.Max(half.z,0),vh=Mathf.Max(Vector3.Dot(view,half),0);
                    if(nl<=0) continue;float k=rough*rough/2;
                    float geometry=nv/(nv*(1-k)+k)*nl/(nl*(1-k)+k),visibility=geometry*vh/Mathf.Max(nh*nv,.0001f);
                    float fresnel=Mathf.Pow(1-vh,5); a+=(1-fresnel)*visibility/samples;b+=fresnel*visibility/samples;
                }
                texture.SetPixel(x,y,new Color(a,b,0));
            }
            texture.Apply();AssetDatabase.CreateAsset(texture,path);return texture;
        }
        static Cubemap DiffuseCube() {
            string path=Root+"Cosine diffuse environment.asset";var cube=AssetDatabase.LoadAssetAtPath<Cubemap>(path);if(cube!=null)return cube;
            cube=ConvolveDiffuse(Sky,"Cosine diffuse environment");AssetDatabase.CreateAsset(cube,path);return cube;
        }
        static Cubemap ConvolveDiffuse(Func<Vector3,Color> sample,string name) {
            var cube=new Cubemap(32,TextureFormat.RGBAHalf,false) {name=name,filterMode=FilterMode.Bilinear};
            for(int face=0;face<6;face++) {
                var pixels=new Color[32*32];
                for(int y=0;y<32;y++)for(int x=0;x<32;x++) {
                    var normal=FaceDirection(face,(x+.5f)/32,(y+.5f)/32);var tangent=Vector3.Cross(Mathf.Abs(normal.y)<.99f?Vector3.up:Vector3.right,normal).normalized;
                    Color c=Color.clear;
                    for(uint i=0;i<128;i++) {
                        float u=(i+.5f)/128,v=RadicalInverse(i),r=Mathf.Sqrt(u),phi=2*Mathf.PI*v;
                        var direction=tangent*(r*Mathf.Cos(phi))+Vector3.Cross(normal,tangent)*(r*Mathf.Sin(phi))+normal*Mathf.Sqrt(1-u);
                        c+=sample(direction)/128;
                    }
                    pixels[y*32+x]=c;
                }
                cube.SetPixels(pixels,(CubemapFace)face);
            }
            cube.Apply();return cube;
        }
        static Color CubeSample(Cubemap cube,Vector3 d) {
            Vector3 a=new Vector3(Mathf.Abs(d.x),Mathf.Abs(d.y),Mathf.Abs(d.z)); int face;float u,v;
            if(a.x>=a.y && a.x>=a.z) {face=d.x>0?0:1;u=(d.x>0?-d.z:d.z)/a.x;v=-d.y/a.x;}
            else if(a.y>=a.z) {face=d.y>0?2:3;u=d.x/a.y;v=(d.y>0?d.z:-d.z)/a.y;}
            else {face=d.z>0?4:5;u=(d.z>0?d.x:-d.x)/a.z;v=-d.y/a.z;}
            int x=Mathf.Clamp((int)((u*.5f+.5f)*cube.width),0,cube.width-1),y=Mathf.Clamp((int)((v*.5f+.5f)*cube.width),0,cube.width-1);
            return cube.GetPixel((CubemapFace)face,x,y);
        }
        [MenuItem("Tools/Relink SRP/8 - Bake Town Reflection Probes")]
        public static void BakeSceneProbes() {
            if(!(GraphicsSettings.defaultRenderPipeline is RelinkRenderPipelineAsset profile)) throw new InvalidOperationException("Enable the town SRP before baking probes.");
            int oldDebug=profile.debugView;profile.debugView=1;
            var camera=new GameObject("Temporary Relink probe bake camera").AddComponent<Camera>();
            camera.enabled=false;camera.fieldOfView=90;camera.nearClipPlane=.1f;camera.farClipPlane=450;camera.clearFlags=CameraClearFlags.Skybox;
            var rt=new RenderTexture(64,64,24,RenderTextureFormat.ARGBHalf,RenderTextureReadWrite.Linear);rt.Create();
            var pixels=new Texture2D(64,64,TextureFormat.RGBAFloat,false,true);
            var previous=RenderTexture.active;
            Vector3[] directions={Vector3.right,Vector3.left,Vector3.up,Vector3.down,Vector3.forward,Vector3.back};
            Vector3[] up={Vector3.up,Vector3.up,Vector3.back,Vector3.forward,Vector3.up,Vector3.up};
            var volumes=UnityEngine.Object.FindObjectsByType<RelinkSceneVolume>(FindObjectsSortMode.None);
            var active=new bool[volumes.Length];
            for(int i=0;i<volumes.Length;i++) {active[i]=volumes[i].enabled;if(volumes[i].reflectionCube!=null)volumes[i].enabled=false;}
            try {
                int index=0;
                foreach(var volume in volumes) {
                    if(volume.reflectionCube==null)continue;
                    var raw=new Cubemap(64,TextureFormat.RGBAHalf,false);
                    camera.transform.position=volume.transform.position;
                    for(int face=0;face<6;face++) {
                        camera.transform.rotation=Quaternion.LookRotation(directions[face],up[face]);
                        ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
                        RenderPipeline.SubmitRenderRequest(camera,new RenderPipeline.StandardRequest {destination=rt});
                        RenderTexture.active=rt;pixels.ReadPixels(new Rect(0,0,64,64),0,0);pixels.Apply();var colors=pixels.GetPixels();var flipped=new Color[colors.Length];
                        for(int y=0;y<64;y++)for(int x=0;x<64;x++)flipped[y*64+x]=colors[(63-y)*64+x];
                        raw.SetPixels(flipped,(CubemapFace)face);
                    }
                    raw.Apply();var filtered=Convolve(direction=>CubeSample(raw,direction),64,"Town local reflection "+index);
                    string path=Root+"Town probe "+index+".asset";var existing=AssetDatabase.LoadAssetAtPath<Cubemap>(path);
                    if(existing==null) {AssetDatabase.CreateAsset(filtered,path);existing=filtered;}
                    else {EditorUtility.CopySerialized(filtered,existing);UnityEngine.Object.DestroyImmediate(filtered);EditorUtility.SetDirty(existing);}
                    volume.reflectionCube=existing;
                    var diffuse=ConvolveDiffuse(direction=>CubeSample(raw,direction),"Town local diffuse "+index);
                    string diffusePath=Root+"Town diffuse "+index+".asset";var savedDiffuse=AssetDatabase.LoadAssetAtPath<Cubemap>(diffusePath);
                    if(savedDiffuse==null) {AssetDatabase.CreateAsset(diffuse,diffusePath);savedDiffuse=diffuse;}
                    else {EditorUtility.CopySerialized(diffuse,savedDiffuse);UnityEngine.Object.DestroyImmediate(diffuse);EditorUtility.SetDirty(savedDiffuse);}
                    volume.diffuseCube=savedDiffuse;
                    EditorUtility.SetDirty(volume);UnityEngine.Object.DestroyImmediate(raw);index++;
                }
                for(int i=0;i<volumes.Length;i++)volumes[i].enabled=active[i];
                EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());EditorSceneManager.SaveScene(SceneManager.GetActiveScene());AssetDatabase.SaveAssets();
            } finally {for(int i=0;i<volumes.Length;i++)volumes[i].enabled=active[i];profile.debugView=oldDebug;RenderTexture.active=previous;rt.Release();UnityEngine.Object.DestroyImmediate(rt);UnityEngine.Object.DestroyImmediate(pixels);UnityEngine.Object.DestroyImmediate(camera.gameObject);}
        }
        static Texture3D LUT(bool far) {
            string path=Root+(far?"Far":"Near")+" 32 LUT.asset"; var texture=AssetDatabase.LoadAssetAtPath<Texture3D>(path);if(texture!=null)return texture;
            const int n=32; texture=new Texture3D(n,n,n,TextureFormat.RGBAHalf,false) {name=far?"Far 32 LUT":"Near 32 LUT",wrapMode=TextureWrapMode.Clamp,filterMode=FilterMode.Bilinear};
            var colors=new Color[n*n*n];
            for(int z=0;z<n;z++)for(int y=0;y<n;y++)for(int x=0;x<n;x++) {
                var c=new Color(Mathf.Pow(17,(float)x/(n-1))-1,Mathf.Pow(17,(float)y/(n-1))-1,Mathf.Pow(17,(float)z/(n-1))-1);
                float lum=c.r*.2126f+c.g*.7152f+c.b*.0722f;
                var tint=Color.Lerp(new Color(.93f,1.01f,1.1f),new Color(1.055f,1.01f,.965f),lum/(1+lum));
                c*=tint; var gray=new Color(lum,lum,lum);c=Color.LerpUnclamped(gray,c,far?.97f:1.08f);
                if(far)c*=new Color(.95f,1.02f,1.10f);
                c.a=1;colors[x+y*n+z*n*n]=c;
            }
            texture.SetPixels(colors);texture.Apply();AssetDatabase.CreateAsset(texture,path);return texture;
        }
    }
}
