using System;
using System.Collections.Generic;
using System.IO;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using Object=UnityEngine.Object;

namespace MyMission.Rendering.Editor
{
    public static class RelinkTownValidation
    {
        static readonly List<string> Results=new List<string>();
        static void Check(bool valid,string message) {Results.Add((valid?"PASS: ":"FAIL: ")+message);if(!valid) throw new InvalidOperationException(message);}
        static Color RenderPixel(Camera camera,int width=32,int height=32) {
            var target=new RenderTexture(width,height,24,RenderTextureFormat.ARGBHalf,RenderTextureReadWrite.Linear);target.Create();
            var texture=new Texture2D(width,height,TextureFormat.RGBAFloat,false,true);var old=RenderTexture.active;
            try {
                RenderPipeline.SubmitRenderRequest(camera,new RenderPipeline.StandardRequest {destination=target});
                RenderTexture.active=target;texture.ReadPixels(new Rect(0,0,width,height),0,0);texture.Apply();return texture.GetPixel(width/2,height/2);
            }finally{RenderTexture.active=old;target.Release();Object.DestroyImmediate(target);Object.DestroyImmediate(texture);}
        }
        static float Magnitude(Color c)=>new Vector3(c.r,c.g,c.b).magnitude;
        public static void Run() {
            Results.Clear();var town=SceneManager.GetActiveScene();
            var roots=town.GetRootGameObjects();var active=new bool[roots.Length];
            for(int i=0;i<roots.Length;i++) {active[i]=roots[i].activeSelf;roots[i].SetActive(false);}
            var oldPipeline=GraphicsSettings.defaultRenderPipeline;var profile=Object.Instantiate((RelinkRenderPipelineAsset)oldPipeline);
            var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Additive);SceneManager.SetActiveScene(scene);
            var material=new Material(profile.environmentShader);
            try {
                profile.debugView=1;profile.temporalAA=false;profile.motionBlur=false;profile.automaticExposure=false;profile.colorGrading=false;profile.depthColorLines=false;
                profile.indirectLighting=false;profile.fogDensity=0;profile.threeCascadePCSS=false;profile.localShadows=false;profile.tileLocalLights=false;
                GraphicsSettings.defaultRenderPipeline=profile;QualitySettings.renderPipeline=profile;RenderSettings.skybox=null;
                var camera=new GameObject("GPU contract camera").AddComponent<Camera>();camera.enabled=false;camera.orthographic=true;camera.orthographicSize=1;
                camera.nearClipPlane=.1f;camera.farClipPlane=40;camera.clearFlags=CameraClearFlags.SolidColor;camera.backgroundColor=Color.black;
                var quad=GameObject.CreatePrimitive(PrimitiveType.Quad);quad.transform.position=new Vector3(0,0,3);
                quad.GetComponent<Renderer>().sharedMaterial=material;quad.AddComponent<RelinkMotionHistory>();
                material.SetColor("_BaseColor",new Color(.55f,.35f,.15f));material.SetFloat("_HatchStrength",0);material.SetFloat("_Smoothness",.4f);
                var point=new GameObject("GPU point").AddComponent<Light>();point.type=LightType.Point;point.range=10;point.intensity=8;
                point.transform.position=new Vector3(1,0,1);point.shadows=LightShadows.Soft;
                var fallback=RenderPixel(camera);profile.tileLocalLights=true;var tile=RenderPixel(camera);
                float delta=Magnitude(tile-fallback);
                Check(Magnitude(tile)>.01f && delta<.008f,"tile compute matches raster local-light oracle; error="+delta);
                profile.localShadows=true;profile.dualParaboloidPointShadows=false;
                var blocker=GameObject.CreatePrimitive(PrimitiveType.Cube);blocker.transform.position=new Vector3(.5f,0,2);
                blocker.transform.localScale=new Vector3(.45f,.6f,.2f);blocker.GetComponent<Renderer>().sharedMaterial=material;
                RenderPixel(camera);var shadowed=RenderPixel(camera);
                profile.debugView=15;var depths=RenderPixel(camera);profile.debugView=1;
                File.WriteAllText("Validation/local-shadow-debug.txt","Receiver/sample/compare="+depths.ToString("F8"));
                profile.debugView=16;var computeDepth=RenderPixel(camera);profile.debugView=1;
                File.AppendAllText("Validation/local-shadow-debug.txt","\nCompute receiver/sample/PCF="+computeDepth.ToString("F8"));
                Check(Magnitude(shadowed)<Magnitude(tile)*.5f,"six-face point shadow occludes the receiver; lit="+Magnitude(tile)+" shadowed="+Magnitude(shadowed));
                profile.dualParaboloidPointShadows=true;var radialShadow=RenderPixel(camera);
                profile.debugView=15;var radialData=RenderPixel(camera);profile.debugView=1;
                Check(radialData.r>radialData.g && radialData.g>0 && radialData.g<1 && Magnitude(radialShadow)<Magnitude(tile)*.5f,
                    "R16F front hemisphere stores nearer radial blocker; receiver/sample="+radialData.ToString("F6"));
                quad.transform.position=new Vector3(0,0,-1);camera.transform.position=new Vector3(0,0,-4);
                // Receiver lies behind the light in world Z, exercising the other hemisphere.
                point.transform.position=new Vector3(1,0,1);blocker.transform.position=new Vector3(.5f,0,0);
                RenderPixel(camera);profile.debugView=15;var backData=RenderPixel(camera);profile.debugView=1;
                Check(backData.r>backData.g && backData.g>0 && backData.g<1,"R16F back hemisphere stores nearer radial blocker; receiver/sample="+backData.ToString("F6"));
                quad.transform.position=new Vector3(0,0,3);camera.transform.position=Vector3.zero;point.transform.position=new Vector3(1,0,1);
                profile.debugView=15;point.transform.position=new Vector3(1,0,3.02f);blocker.transform.position=new Vector3(.5f,0,3.01f);
                blocker.transform.localScale=new Vector3(.2f,.6f,.45f);var seamBack=RenderPixel(camera);
                point.transform.position=new Vector3(1,0,2.98f);blocker.transform.position=new Vector3(.5f,0,2.99f);var seamFront=RenderPixel(camera);profile.debugView=1;
                Check(seamBack.b<.25f && seamFront.b<.25f && Mathf.Abs(seamBack.b-seamFront.b)<.1f,
                    "paraboloid hemisphere seam preserves occlusion; back/front="+seamBack.b+"/"+seamFront.b);
                point.transform.position=new Vector3(1,0,1);
                Object.DestroyImmediate(blocker);point.enabled=false;profile.localLights=false;profile.indirectLighting=true;profile.imageBasedLighting=true;
                material.SetFloat("_Metallic",1);material.SetFloat("_Smoothness",.9f);var shiny=RenderPixel(camera);
                material.SetFloat("_Smoothness",.1f);var rough=RenderPixel(camera);
                Check(Magnitude(shiny)>.01f && Magnitude(shiny-rough)>.003f,"metal receives mip-dependent specular IBL");
                profile.indirectLighting=false;profile.debugView=7;profile.temporalAA=true;
                ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
                RenderPixel(camera);var still=RenderPixel(camera);
                Check(Mathf.Abs(still.r-.5f)<.002f && Mathf.Abs(still.g-.5f)<.002f,"static rigid object velocity is zero");
                quad.transform.position+=new Vector3(.1f,0,0);var moved=RenderPixel(camera);
                float velocity=(moved.r-.5f)/20;
                Check(Mathf.Abs(velocity-.05f)<.003f,"rigid motion has current-minus-previous UV sign; velocity="+velocity);
                ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);var reset=RenderPixel(camera);
                Check(Mathf.Abs(reset.r-.5f)<.002f,"explicit history reset removes object motion");
                quad.transform.position+=new Vector3(.1f,0,0);var resized=RenderPixel(camera,48,24);
                Check(Mathf.Abs(resized.r-.5f)<.002f,"resolution change discards object and camera history");
                RenderPixel(camera);camera.transform.position=new Vector3(0,0,-10);var cut=RenderPixel(camera);
                Check(Mathf.Abs(cut.r-.5f)<.002f,"large camera cut discards previous velocity");
                camera.transform.position=Vector3.zero;quad.transform.position=new Vector3(0,0,3);
                profile.debugView=0;profile.temporalAA=true;profile.motionBlur=true;profile.bloomIntensity=0;
                profile.tileLocalLights=false;profile.localLights=false;profile.exposure=0;
                material.SetColor("_EmissionColor",new Color(.5f,.3f,.1f));
                ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
                var fresh=RenderPixel(camera);Color settled=fresh;
                for(int i=0;i<16;i++)settled=RenderPixel(camera);
                Check(Magnitude(fresh)>.01f && Magnitude(fresh-settled)<.012f,"static HDR/post temporal histories converge without brightness drift");
                var small=RenderPixel(camera,48,24);
                Check(Magnitude(small-fresh)<.012f,"resized temporal histories initialize from current HDR");
                camera.farClipPlane=200;camera.transform.position=new Vector3(0,0,-100);var jump=RenderPixel(camera);
                Check(Magnitude(jump-fresh)<.012f,"camera cut removes HDR/post ghost history; fresh="+fresh.ToString("F6")+" cut="+jump.ToString("F6"));
                var nearLut=SolidLut(Color.red);var farLut=SolidLut(Color.blue);
                try {
                    profile.colorGrading=true;profile.nearLUT=nearLut;profile.farLUT=farLut;
                    profile.gradingDistances=new Vector2(5,50);profile.temporalAA=false;profile.motionBlur=false;
                    camera.transform.position=Vector3.zero;var near=RenderPixel(camera);
                    camera.transform.position=new Vector3(0,0,-100);var far=RenderPixel(camera);
                    Check(near.r>near.b*3 && far.b>far.r*3,"dual 3D LUT selects near and far grading by reconstructed distance");
                }finally{Object.DestroyImmediate(nearLut);Object.DestroyImmediate(farLut);}
                profile.colorGrading=false;profile.debugView=11;profile.imageBasedLighting=true;
                material.SetFloat("_Metallic",0);material.SetFloat("_Smoothness",0);
                var volume=new GameObject("GPU regional probe").AddComponent<RelinkSceneVolume>();
                volume.transform.position=new Vector3(0,0,3);volume.size=Vector3.one*20;volume.blendDistance=2;
                volume.reflectionCube=profile.environmentCube;
                var redCube=SolidCube(Color.red);var blueCube=SolidCube(Color.blue);
                try {
                    volume.diffuseCube=redCube;var red=RenderPixel(camera);
                    volume.diffuseCube=blueCube;var blue=RenderPixel(camera);
                    Check(red.r>red.b*3 && blue.b>blue.r*3,"local irradiance cube replaces global diffuse IBL inside its region");
                    volume.transform.position+=new Vector3(9,0,0);var blendA=RenderPixel(camera);
                    volume.transform.position+=new Vector3(.02f,0,0);var blendB=RenderPixel(camera);
                    Check(Magnitude(blendA-blendB)<.02f && Magnitude(blendA-blue)>.01f,"local diffuse IBL fades continuously into global coverage at box boundary");
                    volume.reflectionCube=null;volume.regionalFog=true;volume.fogColor=Color.blue;volume.fogDensity=3;
                    volume.transform.position=new Vector3(0,0,3);profile.debugView=1;
                    var fogged=RenderPixel(camera);
                    Check(fogged.b>fogged.r*3,"regional fog modifies HDR before grading and film curve");
                }finally{Object.DestroyImmediate(volume.gameObject);Object.DestroyImmediate(redCube);Object.DestroyImmediate(blueCube);}
            }finally {
                File.WriteAllLines("Validation/advanced-contract.txt",Results);
                GraphicsSettings.defaultRenderPipeline=oldPipeline;QualitySettings.renderPipeline=oldPipeline;
                EditorSceneManager.CloseScene(scene,true);SceneManager.SetActiveScene(town);Object.DestroyImmediate(profile);Object.DestroyImmediate(material);
                for(int i=0;i<roots.Length;i++) roots[i].SetActive(active[i]);
            }
        }
        static Texture3D SolidLut(Color color) {
            var texture=new Texture3D(2,2,2,TextureFormat.RGBAHalf,false);var colors=new Color[8];
            for(int i=0;i<colors.Length;i++)colors[i]=color;texture.SetPixels(colors);texture.Apply();return texture;
        }
        static Cubemap SolidCube(Color color) {
            var cube=new Cubemap(2,TextureFormat.RGBAHalf,false);var colors=new Color[4];
            for(int i=0;i<colors.Length;i++)colors[i]=color;
            for(int face=0;face<6;face++)cube.SetPixels(colors,(CubemapFace)face);cube.Apply();return cube;
        }
    }
}
