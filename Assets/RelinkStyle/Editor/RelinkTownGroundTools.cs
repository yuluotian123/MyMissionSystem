using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using Object=UnityEngine.Object;

namespace MyMission.Rendering.Editor
{
    // Town art adaptation, not a claim about the game's texture production.
    public static class RelinkTownGroundTools
    {
        const string Root="Assets/RelinkStyle/Generated/Town/";
        public static Texture2D Paving(out Texture2D normal) {
            const string version="Weathered limestone flagstone v2";
            const int n=768,cells=6;
            string path=Root+"Textures/Cobblestone.asset",normalPath=Root+"Textures/Flagstone normal.asset";
            var texture=AssetDatabase.LoadAssetAtPath<Texture2D>(path);
            normal=AssetDatabase.LoadAssetAtPath<Texture2D>(normalPath);
            if(texture!=null && texture.name==version && normal!=null)return texture;
            if(texture==null) {texture=new Texture2D(n,n,TextureFormat.RGBA32,true,false);AssetDatabase.CreateAsset(texture,path);}
            else texture.Reinitialize(n,n,TextureFormat.RGBA32,true);
            if(normal==null) {normal=new Texture2D(n,n,TextureFormat.RGBA32,true,true);AssetDatabase.CreateAsset(normal,normalPath);}
            var random=new System.Random(731);
            var seeds=new Vector2[cells*cells];var shades=new Color[seeds.Length];
            for(int y=0;y<cells;y++)for(int x=0;x<cells;x++) {
                int i=y*cells+x;seeds[i]=new Vector2(x+.18f+(float)random.NextDouble()*.64f,y+.18f+(float)random.NextDouble()*.64f);
                float shade=.82f+(float)random.NextDouble()*.3f;
                shades[i]=Color.Lerp(new Color(.71f,.70f,.65f),new Color(.8f,.72f,.62f),(float)random.NextDouble())*shade;
            }
            var heights=new float[n*n];var pixels=new Color[n*n];var normals=new Color[n*n];
            for(int y=0;y<n;y++)for(int x=0;x<n;x++) {
                var p=new Vector2((x+.5f)*cells/n,(y+.5f)*cells/n);
                int cx=(int)p.x,cy=(int)p.y,nearest=0;float d1=100,d2=100;Vector2 s1=Vector2.zero,s2=Vector2.zero;
                for(int dy=-2;dy<=2;dy++)for(int dx=-2;dx<=2;dx++) {
                    int sx=cx+dx,sy=cy+dy,wx=(sx+cells)%cells,wy=(sy+cells)%cells,i=wy*cells+wx;
                    var seed=seeds[i]+new Vector2(sx-wx,sy-wy);float d=(p-seed).sqrMagnitude;
                    if(d<d1) {d2=d1;s2=s1;d1=d;s1=seed;nearest=i;}else if(d<d2) {d2=d;s2=seed;}
                }
                float gap=(d2-d1)/Mathf.Max(.01f,2*(s2-s1).magnitude);
                // Periodic micro variation; seeds/edges also wrap across the texture seam.
                float grain=Mathf.Sin((float)(x*.171+y*.127))*Mathf.Sin((float)(x*.047-y*.213));
                float mottling=Mathf.Sin(p.x*2*Mathf.PI)*Mathf.Cos(p.y*4*Mathf.PI);
                float bevel=Mathf.SmoothStep(0,1,Mathf.InverseLerp(.014f,.08f,gap));
                float moss=Mathf.Clamp01(.4f+Mathf.Sin(p.x*4*Mathf.PI)*Mathf.Cos(p.y*2*Mathf.PI));
                var joint=Color.Lerp(new Color(.33f,.32f,.28f),new Color(.31f,.37f,.23f),moss*.55f);
                pixels[y*n+x]=Color.Lerp(joint,shades[nearest]*(1+grain*.025f+mottling*.055f),Mathf.SmoothStep(0,1,Mathf.InverseLerp(.008f,.028f,gap)));
                heights[y*n+x]=bevel*(.035f+nearest%5*.003f)+grain*.0003f+mottling*.0015f;
            }
            float metresPerTexel=4.3f/n;
            for(int y=0;y<n;y++)for(int x=0;x<n;x++) {
                float dx=(heights[y*n+(x+1)%n]-heights[y*n+(x+n-1)%n])/(2*metresPerTexel);
                float dy=(heights[((y+1)%n)*n+x]-heights[((y+n-1)%n)*n+x])/(2*metresPerTexel);
                var v=new Vector3(-dx,-dy,1).normalized;normals[y*n+x]=new Color(v.x*.5f+.5f,v.y*.5f+.5f,v.z*.5f+.5f,1);
            }
            texture.name=version;texture.wrapMode=TextureWrapMode.Repeat;texture.anisoLevel=8;texture.SetPixels(pixels);texture.Apply();
            normal.name="Flagstone bevel normal";normal.wrapMode=TextureWrapMode.Repeat;normal.anisoLevel=8;normal.SetPixels(normals);normal.Apply();
            EditorUtility.SetDirty(texture);EditorUtility.SetDirty(normal);return texture;
        }
        public static void Grass(Material material) {
            var random=new System.Random(5913);
            for(int section=0;section<3;section++) {
                var vertices=new List<Vector3>();var normals=new List<Vector3>();var colors=new List<Color>();var uv=new List<Vector2>();var indices=new List<int>();
                for(int clump=0;clump<70;clump++) {
                    float side=clump%2==0?-1:1;
                    var center=new Vector3(side*(6.8f+(float)random.NextDouble()*1.3f),.025f,-16+section*31+(float)random.NextDouble()*31);
                    for(int blade=0;blade<7;blade++) {
                        float angle=(float)random.NextDouble()*Mathf.PI*2,height=.13f+(float)random.NextDouble()*.3f,width=.035f+(float)random.NextDouble()*.035f;
                        var across=new Vector3(Mathf.Cos(angle),0,Mathf.Sin(angle))*width;
                        var lean=new Vector3(-across.z,0,across.x)*2;
                        var root=center+new Vector3((float)random.NextDouble()*.4f-.2f,0,(float)random.NextDouble()*.4f-.2f);
                        int index=vertices.Count;
                        vertices.Add(root-across);vertices.Add(root+across);vertices.Add(root+Vector3.up*height*.55f+lean-across*.55f);
                        vertices.Add(root+Vector3.up*height*.55f+lean+across*.55f);vertices.Add(root+Vector3.up*height+lean*2);
                        var normal=Vector3.Cross(Vector3.up,across).normalized;
                        for(int v=0;v<5;v++) {normals.Add(normal);colors.Add(new Color(v<2?0:v<4?.5f:1,1,1,1));uv.Add(new Vector2(v%2,v<2?0:v<4?.5f:1));}
                        foreach(int v in new[]{0,2,1,1,2,3,2,4,3})indices.Add(index+v);
                    }
                }
                var mesh=new Mesh {name="Roadside grass section "+section};mesh.SetVertices(vertices);mesh.SetNormals(normals);mesh.SetColors(colors);mesh.SetUVs(0,uv);mesh.SetTriangles(indices,0);mesh.RecalculateBounds();
                string path=Root+"Meshes/Roadside grass "+section+".asset";
                var stored=AssetDatabase.LoadAssetAtPath<Mesh>(path);
                if(stored==null)AssetDatabase.CreateAsset(mesh,path);else {EditorUtility.CopySerialized(mesh,stored);Object.DestroyImmediate(mesh);mesh=stored;}
                var go=new GameObject("Roadside grass "+section);go.AddComponent<MeshFilter>().sharedMesh=mesh;
                var renderer=go.AddComponent<MeshRenderer>();renderer.sharedMaterial=material;renderer.shadowCastingMode=ShadowCastingMode.TwoSided;
                go.AddComponent<RelinkMotionHistory>();
            }
        }
    }
}
