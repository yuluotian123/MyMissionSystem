using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Rendering;
using Object=UnityEngine.Object;

namespace MyMission.Rendering
{
    // Opt-in, disposable Player validation. Runs across actual Unity frames so skin
    // buffers and wind time advance, unlike multiple render requests in one tick.
    public sealed class RelinkDynamicValidation : MonoBehaviour
    {
        readonly List<string> results=new List<string>();
        Camera camera;
        RenderTexture target;
        Texture2D pixels;
        RelinkRenderPipelineAsset profile;
        bool passed=true;
        [Serializable] class Report {public string unity,gpu,api,utc;public bool passed;public string[] checks;}
        void Check(bool condition,string message) {
            passed&=condition;results.Add((condition?"PASS: ":"FAIL: ")+message);
            Debug.Log(results[results.Count-1]);
        }
        Color Render() {
            RenderPipeline.SubmitRenderRequest(camera,new RenderPipeline.StandardRequest {destination=target});
            var previous=RenderTexture.active;RenderTexture.active=target;
            pixels.ReadPixels(new Rect(0,0,target.width,target.height),0,0);pixels.Apply();RenderTexture.active=previous;
            return pixels.GetPixel(target.width/2,target.height/2);
        }
        static float Error(Color a,Color b)=>Mathf.Max(Mathf.Abs(a.r-b.r),Mathf.Max(Mathf.Abs(a.g-b.g),Mathf.Abs(a.b-b.b)));
        static float Velocity(Color c)=>(c.r-.5f)/20;
        void Reset()=>((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
        public IEnumerator Run(string directory) {
            var roots=gameObject.scene.GetRootGameObjects();var enabledRoots=new bool[roots.Length];
            for(int i=0;i<roots.Length;i++) {enabledRoots[i]=roots[i].activeSelf;if(roots[i]!=gameObject)roots[i].SetActive(false);}
            var original=GraphicsSettings.defaultRenderPipeline;var quality=QualitySettings.renderPipeline;
            float captureDelta=Time.captureDeltaTime;Time.captureDeltaTime=1f/30;
            profile=Instantiate((RelinkRenderPipelineAsset)original);
            profile.debugView=7;profile.temporalAA=true;profile.motionBlur=false;profile.automaticExposure=false;
            profile.colorGrading=false;profile.depthColorLines=false;profile.indirectLighting=false;
            profile.fogDensity=0;profile.threeCascadePCSS=false;profile.localShadows=false;profile.tileLocalLights=false;
            profile.localLights=false;profile.bloomIntensity=0;profile.exposure=0;
            GraphicsSettings.defaultRenderPipeline=profile;QualitySettings.renderPipeline=profile;
            var testRoot=new GameObject("Disposable dynamic contracts");
            camera=new GameObject("Dynamic GPU camera").AddComponent<Camera>();camera.transform.SetParent(testRoot.transform);
            camera.enabled=false;camera.orthographic=true;camera.orthographicSize=1;camera.nearClipPlane=.1f;camera.farClipPlane=20;
            camera.clearFlags=CameraClearFlags.SolidColor;camera.backgroundColor=Color.black;
            target=new RenderTexture(64,64,24,RenderTextureFormat.ARGBHalf,RenderTextureReadWrite.Linear);target.Create();
            pixels=new Texture2D(64,64,TextureFormat.RGBAFloat,false,true);
            var material=new Material(profile.environmentShader);material.SetFloat("_HatchStrength",0);
            var quad=GameObject.CreatePrimitive(PrimitiveType.Quad);quad.transform.SetParent(testRoot.transform);quad.transform.position=new Vector3(0,0,3);
            quad.GetComponent<Renderer>().sharedMaterial=material;quad.AddComponent<RelinkMotionHistory>();
            var mesh=Instantiate(quad.GetComponent<MeshFilter>().sharedMesh);var colors=new Color[mesh.vertexCount];
            for(int i=0;i<colors.Length;i++)colors[i]=Color.white;mesh.colors=colors;quad.GetComponent<MeshFilter>().sharedMesh=mesh;
            try {
                // Uniform wind keeps the analytical UV displacement independent of interpolation.
                material.SetFloat("_WindStrength",.15f);material.SetFloat("_WindSpeed",7);material.SetFloat("_WindScale",0);
                Render();yield return null;
                float maxWindError=0,maxWindMagnitude=0;
                for(int i=0;i<12;i++) {
                    float previousTime=Time.time;Render();yield return null;
                    float expected=.15f*(Mathf.Sin(Time.time*7)-Mathf.Sin(previousTime*7))/2;
                    var value=Render();float velocity=Velocity(value);
                    maxWindError=Mathf.Max(maxWindError,Mathf.Abs(velocity-expected));maxWindMagnitude=Mathf.Max(maxWindMagnitude,Mathf.Abs(velocity));
                }
                Check(maxWindError<.0007f && maxWindMagnitude>.002f,"12-frame wind UV matches analytic displacement; maxError="+maxWindError+" maxVelocity="+maxWindMagnitude);
                Reset();var windReset=Render();Check(Mathf.Abs(Velocity(windReset))<.0002f,"wind history reset uses current deformation");
                material.SetFloat("_WindStrength",0);quad.SetActive(false);
                var skinObject=new GameObject("One-bone deformation oracle");skinObject.transform.SetParent(testRoot.transform);skinObject.transform.position=new Vector3(0,0,3);
                var bone=new GameObject("Moving bone").transform;bone.SetParent(skinObject.transform,false);
                var skinMesh=Instantiate(mesh);var weights=new BoneWeight[skinMesh.vertexCount];
                for(int i=0;i<weights.Length;i++)weights[i]=new BoneWeight {boneIndex0=0,weight0=1};
                skinMesh.boneWeights=weights;skinMesh.bindposes=new[]{bone.worldToLocalMatrix*skinObject.transform.localToWorldMatrix};
                var skin=skinObject.AddComponent<SkinnedMeshRenderer>();skin.sharedMesh=skinMesh;skin.sharedMaterial=material;
                skin.bones=new[]{bone};skin.rootBone=bone;skin.updateWhenOffscreen=true;skin.localBounds=new Bounds(Vector3.zero,Vector3.one*8);
                skinObject.AddComponent<RelinkMotionHistory>();
                Reset();Render();yield return null;Render();yield return null;
                bone.localPosition=new Vector3(.1f,0,0);
                var skinMoved=Render();float skinVelocity=Velocity(skinMoved);
                Check(Mathf.Abs(skinVelocity-.05f)<.003f,"bone deformation has current-minus-previous UV sign; expected=.05 actual="+skinVelocity);
                Reset();var skinReset=Render();Check(Mathf.Abs(Velocity(skinReset))<.0002f,"skin reset removes previous deformation");
                skinObject.SetActive(false);Destroy(skinMesh);quad.SetActive(true);
                profile.debugView=0;material.SetColor("_EmissionColor",new Color(.1f,.3f,1));
                Reset();var revealedReference=Render();yield return null;
                var blockerMaterial=new Material(material);blockerMaterial.SetColor("_EmissionColor",new Color(1,.1f,.1f));
                var blocker=GameObject.CreatePrimitive(PrimitiveType.Quad);blocker.transform.SetParent(testRoot.transform);blocker.transform.position=new Vector3(0,0,2);
                blocker.GetComponent<Renderer>().sharedMaterial=blockerMaterial;blocker.AddComponent<RelinkMotionHistory>();
                Reset();Color foreground=Color.black;
                for(int i=0;i<8;i++) {foreground=Render();yield return null;}
                blocker.transform.position=new Vector3(3,0,2);var revealed=Render();
                Check(foreground.r>foreground.b*1.5f && Error(revealed,revealedReference)<.012f,
                    "disocclusion rejects red foreground from HDR and post histories; maxError="+Error(revealed,revealedReference));
                float maxStableError=0;
                for(int i=0;i<16;i++) {yield return null;maxStableError=Mathf.Max(maxStableError,Error(Render(),revealedReference));}
                Check(maxStableError<.012f,"16-frame revealed surface stays stable; maxError="+maxStableError);
                Destroy(blockerMaterial);Destroy(blocker);
                profile.temporalAA=false;profile.automaticExposure=true;profile.exposureLimits=new Vector2(.05f,10);
                quad.transform.localScale=Vector3.one*4;profile.exposureKey=.2f;profile.exposureSpeed=4;
                material.SetColor("_EmissionColor",new Color(.1f,.1f,.1f));Reset();Render();yield return null;
                material.SetColor("_EmissionColor",new Color(3,3,3));var bright=Render();float last=bright.r,maxIncrease=0;
                for(int i=0;i<512;i++) {yield return null;float current=Render().r;maxIncrease=Mathf.Max(maxIncrease,current-last);last=current;}
                Check(last<bright.r-.08f && maxIncrease<.004f,"512-frame exposure adapts monotonically to a bright step; initial="+bright.r+" final="+last+" maxIncrease="+maxIncrease);
            } finally {
                GraphicsSettings.defaultRenderPipeline=original;QualitySettings.renderPipeline=quality;Time.captureDeltaTime=captureDelta;
                target.Release();Destroy(target);Destroy(pixels);Destroy(material);Destroy(mesh);Destroy(testRoot);Destroy(profile);
                for(int i=0;i<roots.Length;i++)if(roots[i]!=null)roots[i].SetActive(enabledRoots[i]);
            }
            var report=new Report {unity=Application.unityVersion,gpu=SystemInfo.graphicsDeviceName,api=SystemInfo.graphicsDeviceType.ToString(),utc=DateTime.UtcNow.ToString("o"),passed=passed,checks=results.ToArray()};
            Directory.CreateDirectory(directory);File.WriteAllText(Path.Combine(directory,"dynamic-contract.json"),JsonUtility.ToJson(report,true));
            Application.Quit(passed?0:1);
        }
    }
}
