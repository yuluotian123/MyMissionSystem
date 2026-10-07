using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    // Included only in the disposable benchmark scene, never added to the user's town.
    public sealed class RelinkTownBenchmark : MonoBehaviour
    {
        [Serializable] class Measurement {public int width,height,samples;public double gpuMedianMs,gpuP95Ms,cpuMedianMs;public bool gpuTimingAvailable;}
        [Serializable] class Report {public string unity,gpu,api,utc;public bool frameTimingEnabled;public Measurement[] measurements;}
        readonly List<Measurement> measurements=new List<Measurement>();
        readonly List<double> gpuTimes=new List<double>(),cpuTimes=new List<double>();
        readonly FrameTiming[] timings=new FrameTiming[1];
        readonly int[] widths={1280,1920,2560},heights={720,1080,1440};
        int stage,frames;ulong lastTimestamp;
        string directory;
        RenderTexture frameTarget;
        void Start() {
            string[] args=Environment.GetCommandLineArgs();int index=Array.IndexOf(args,"-relink-output");
            directory=index>=0 && index+1<args.Length?args[index+1]:Path.Combine(Application.persistentDataPath,"RelinkBenchmark");
            Directory.CreateDirectory(directory);Application.runInBackground=true;QualitySettings.vSyncCount=0;Application.targetFrameRate=-1;
            if(Array.IndexOf(args,"-relink-dynamic-only")>=0) {
                enabled=false;var validation=gameObject.AddComponent<RelinkDynamicValidation>();
                validation.StartCoroutine(validation.Run(directory));return;
            }
            Screen.SetResolution(widths[0],heights[0],FullScreenMode.Windowed);
        }
        void Update() {
            if(frameTarget==null || frameTarget.width!=widths[stage]) {
                if(frameTarget!=null) {frameTarget.Release();Destroy(frameTarget);}
                frameTarget=new RenderTexture(widths[stage],heights[stage],24,RenderTextureFormat.ARGB32);frameTarget.Create();
            }
            RenderPipeline.SubmitRenderRequest(Camera.main,new RenderPipeline.StandardRequest {destination=frameTarget});
            frames++;FrameTimingManager.CaptureFrameTimings();
            if(frames>45 && FrameTimingManager.GetLatestTimings(1,timings)>0 && timings[0].frameStartTimestamp!=lastTimestamp) {
                lastTimestamp=timings[0].frameStartTimestamp;
                if(timings[0].gpuFrameTime>0)gpuTimes.Add(timings[0].gpuFrameTime);
                if(timings[0].cpuFrameTime>0)cpuTimes.Add(timings[0].cpuFrameTime);
            }
            if(frames<280)return;
            measurements.Add(new Measurement {width=Screen.width,height=Screen.height,samples=gpuTimes.Count,
                gpuMedianMs=Percentile(gpuTimes,.5),gpuP95Ms=Percentile(gpuTimes,.95),cpuMedianMs=Percentile(cpuTimes,.5),gpuTimingAvailable=gpuTimes.Count>0});
            Capture("Town-Player-"+Screen.width+"x"+Screen.height+".png");
            stage++;frames=0;gpuTimes.Clear();cpuTimes.Clear();
            if(stage<widths.Length) {Screen.SetResolution(widths[stage],heights[stage],FullScreenMode.Windowed);return;}
            var report=new Report {unity=Application.unityVersion,gpu=SystemInfo.graphicsDeviceName,api=SystemInfo.graphicsDeviceType.ToString(),utc=DateTime.UtcNow.ToString("o"),
                frameTimingEnabled=FrameTimingManager.IsFeatureEnabled(),measurements=measurements.ToArray()};
            File.WriteAllText(Path.Combine(directory,"performance.json"),JsonUtility.ToJson(report,true));Application.Quit(0);
        }
        static double Percentile(List<double> values,double fraction) {if(values.Count==0)return 0;values.Sort();return values[(int)((values.Count-1)*fraction)];}
        void Capture(string name) {
            var rt=new RenderTexture(Screen.width,Screen.height,24,RenderTextureFormat.ARGB32);rt.Create();
            var pixels=new Texture2D(rt.width,rt.height,TextureFormat.RGB24,false);var old=RenderTexture.active;
            bool capturing=RelinkRenderDocCapture.Begin(Path.Combine(directory,"Native-"+widths[stage]+"x"+heights[stage]));
            try {RenderPipeline.SubmitRenderRequest(Camera.main,new RenderPipeline.StandardRequest {destination=rt});
                RenderTexture.active=rt;pixels.ReadPixels(new Rect(0,0,rt.width,rt.height),0,0);pixels.Apply();
                File.WriteAllBytes(Path.Combine(directory,name),pixels.EncodeToPNG());}
            finally {if(capturing)RelinkRenderDocCapture.End();RenderTexture.active=old;rt.Release();Destroy(rt);Destroy(pixels);}
        }
    }
}
