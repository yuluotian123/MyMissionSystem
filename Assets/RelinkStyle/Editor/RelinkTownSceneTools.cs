using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace MyMission.Rendering.Editor
{
    public static class RelinkTownSceneTools
    {
        public const string ScenePath = "Assets/RelinkStyle/Generated/RelinkTown.unity";
        public const string PipelinePath = "Assets/RelinkStyle/Generated/RelinkTownPipeline.asset";
        public const string Art1 = "Assets/Resources/Art/Test/八方旅人1/建筑1/";
        public const string Art2 = "Assets/Resources/Art/Test/八方旅人2/";
        public static readonly string[] SourceFolders = {
            Art1 + "MbdMD_Co_T_Plain_L_A_Build_02", Art1 + "MbdMD_Co_T_River_L_A_WeaponShop",
            Art1 + "ObjMD_Arch_A", Art1 + "ObjMD_Church_A",
            Art2 + "建筑/EnvBdgMD_City_C_Outdoor_4W4D_A", Art2 + "建筑/EnvBdgMD_City_D_Outdoor_4W5D_2F",
            Art2 + "建筑/EnvBdgMD_Plain_A_Outdoor_Entrance_A",
            Art2 + "建筑组件/EnvObjMD_Stairs_A_Large",
            Art2 + "植物_八方旅人2/树灌木/EnvFldMD_Tree_A_Forest_LA",
            Art2 + "植物_八方旅人2/树灌木/EnvFldMD_Tree_E_MA_LOD0",
            Art2 + "植物_八方旅人2/树灌木/EnvFldMD_Tree_I_L",
            Art2 + "山石_八方旅人2/EnvFldMD_FoliageStone_A_MA"
        };
        [Serializable] class Entry { public string path; public Vector3 size; public string[] meshes, materials, textures; }
        [Serializable] class Inventory { public Entry[] entries; }
        public static void InventoryAssets()
        {
            try {
                Directory.CreateDirectory("Validation");
                var entries = new List<Entry>();
                foreach (string folder in SourceFolders)
                foreach (string path in Directory.GetFiles(folder, "*.FBX", SearchOption.TopDirectoryOnly)) {
                    var source = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                    if (source == null) continue;
                    var instance = Object.Instantiate(source);
                    var renderers = instance.GetComponentsInChildren<Renderer>();
                    var bounds = BoundsOf(instance);
                    var materials = renderers.SelectMany(r => r.sharedMaterials).Where(m=>m!=null).Distinct().ToArray();
                    entries.Add(new Entry { path=path.Replace('\\','/'), size=bounds.size,
                        meshes=renderers.Select(r=> r.name + " : " + r.bounds.size.ToString()).ToArray(),
                        materials=materials.Select(m=>m.name).ToArray(),
                        textures=materials.SelectMany(m=>m.GetTexturePropertyNames().Select(p=>m.GetTexture(p))).Where(t=>t!=null)
                            .Select(t=>AssetDatabase.GetAssetPath(t)).Distinct().ToArray() });
                    Object.DestroyImmediate(instance);
                }
                File.WriteAllText("Validation/asset-inventory.json", JsonUtility.ToJson(new Inventory {entries=entries.ToArray()}, true));
                EditorApplication.Exit(0);
            } catch (Exception e) { Debug.LogException(e); EditorApplication.Exit(1); }
        }
        static Bounds BoundsOf(GameObject root) {
            var renderers=root.GetComponentsInChildren<Renderer>();
            var b=renderers.Length>0?renderers[0].bounds:new Bounds(root.transform.position,Vector3.one);
            foreach(var r in renderers) b.Encapsulate(r.bounds);
            return b;
        }

        const string Output = "Assets/RelinkStyle/Generated/Town";
        static readonly Dictionary<string, Material> Converted = new Dictionary<string, Material>();

        [MenuItem("Tools/Relink SRP/6 - Build Octopath Town")]
        public static void BuildTown()
        {
            Directory.CreateDirectory(Output + "/Materials"); Directory.CreateDirectory(Output + "/Textures");
            Directory.CreateDirectory(Output + "/Meshes"); AssetDatabase.Refresh(); Converted.Clear();
            var pipeline=AssetDatabase.LoadAssetAtPath<RelinkRenderPipelineAsset>(PipelinePath);
            if(pipeline==null) { pipeline=ScriptableObject.CreateInstance<RelinkRenderPipelineAsset>(); AssetDatabase.CreateAsset(pipeline,PipelinePath); }
            pipeline.environmentShader=Shader.Find("Relink/Environment"); pipeline.compositeShader=Shader.Find("Hidden/Relink/Composite");
            pipeline.deferredShader=Shader.Find("Hidden/Relink/Deferred");
            pipeline.temporalShader=Shader.Find("Hidden/Relink/ScenePost");
            pipeline.tileLightingShader=AssetDatabase.LoadAssetAtPath<ComputeShader>("Assets/RelinkStyle/Shaders/RelinkTileLighting.compute");
            pipeline.threeCascadePCSS=true; pipeline.shadowDistance=300; pipeline.imageBasedLighting=true;
            pipeline.tileLocalLights=true; pipeline.localShadows=true; pipeline.temporalAA=true;
            pipeline.dualParaboloidPointShadows=true;
            pipeline.automaticExposure=true;pipeline.exposureKey=.85f;pipeline.exposureLimits=new Vector2(.5f,2.5f);
            pipeline.colorGrading=true;pipeline.depthColorLines=true;pipeline.motionBlur=true;pipeline.shutter=.18f;
            RelinkLightingBaker.BuildLighting(pipeline);
            pipeline.renderingPath=RelinkRenderingPath.EvidenceDeferred; pipeline.debugView=0;
            pipeline.exposure=.3f; pipeline.ambientIntensity=1.3f;pipeline.environmentIntensity=.85f;
            pipeline.ambientSky=new Color(.63f,.78f,.95f); pipeline.ambientGround=new Color(.45f,.43f,.35f);
            pipeline.shadowDistance=300; pipeline.shadowNormalBias=.025f; pipeline.shadowBias=1.1f;
            pipeline.fogDensity=.002f; pipeline.fogHeightFalloff=.045f; pipeline.fogColor=new Color(.61f,.77f,.88f);
            pipeline.bloomIntensity=.06f; pipeline.bloomThreshold=2.2f;
            EditorUtility.SetDirty(pipeline);
            Scene previous=SceneManager.GetActiveScene();
            var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Additive); SceneManager.SetActiveScene(scene);
            try {
                var sky=GetMaterial("Town sky","Relink/Painted Sky",Color.white);
                sky.SetColor("_Zenith",new Color(.13f,.43f,.73f)); sky.SetColor("_Horizon",new Color(.66f,.84f,.94f));
                sky.SetColor("_CloudColor",new Color(1.9f,1.85f,1.73f)); sky.SetFloat("_CloudCoverage",.5f);
                sky.SetTexture("_SkyCube",pipeline.environmentCube);sky.SetFloat("_UseSkyCube",1);
                RenderSettings.skybox=sky; RenderSettings.fog=false;
                var sun=new GameObject("Sun / captured directional BRDF").AddComponent<Light>(); sun.type=LightType.Directional;
                sun.color=new Color(1,.934f,.767f); sun.intensity=16; sun.shadows=LightShadows.Soft;
                sun.transform.rotation=Quaternion.Euler(48,-38,0); RenderSettings.sun=sun;
                RenderSettings.ambientMode=AmbientMode.Trilight;
                var camera=new GameObject("Main Camera / Market Street").AddComponent<Camera>(); camera.tag="MainCamera";
                camera.transform.position=new Vector3(1.7f,3.5f,-23);
                camera.transform.LookAt(new Vector3(0,5.5f,22)); camera.fieldOfView=53; camera.nearClipPlane=.15f;
                camera.farClipPlane=450; camera.allowHDR=true; camera.clearFlags=CameraClearFlags.Skybox;
                var bookmarks=new GameObject("Camera bookmarks");
                Bookmark(bookmarks,"Market Street",camera.transform.position,new Vector3(0,5.5f,22));
                Bookmark(bookmarks,"Terrace",new Vector3(-5.5f,10,-22),new Vector3(0,4,35));
                Bookmark(bookmarks,"Plaza",new Vector3(6,4,25),new Vector3(-1,5,50));
                camera.gameObject.AddComponent<RelinkTownNavigator>().viewpoints=bookmarks.GetComponentsInChildren<Transform>().Where(t=>t!=bookmarks.transform).ToArray();
                var stone=GetMaterial("Limestone paving","Relink/Environment",new Color(.95f,.93f,.88f));
                stone.SetTexture("_BaseMap",RelinkTownGroundTools.Paving(out var pavingNormal));stone.SetTexture("_BumpMap",pavingNormal);
                stone.SetTextureScale("_BaseMap",new Vector2(26,30));stone.SetFloat("_BumpScale",.65f);stone.SetFloat("_Smoothness",.08f);
                Box("Town foundation",new Vector3(0,-.6f,30),new Vector3(110,1.2f,130),stone);
                var wall=GetMaterial("Terrace limestone","Relink/Environment",new Color(.68f,.63f,.51f));
                Box("Raised west terrace",new Vector3(-18,.8f,18),new Vector3(20,1.6f,48),wall);
                var stairs=Place(Art2+"建筑组件/EnvObjMD_Stairs_A_Large/EnvObjMD_Stairs_A_Large.FBX","EnvObjMD_Stairs_A_Medium",
                    new Vector3(-7.6f,0,3),1.6f,90,"Octopath limestone terrace stairs");
                var stairsBounds=BoundsOf(stairs);stairs.transform.localScale=Vector3.Scale(stairs.transform.localScale,new Vector3(8/stairsBounds.size.z,1,1));
                Box("Street curb west",new Vector3(-5.7f,.11f,18),new Vector3(.4f,.22f,73),wall);
                Box("Street curb east",new Vector3(5.6f,.11f,20),new Vector3(.4f,.22f,80),wall);
                string city=Art2+"建筑/EnvBdgMD_City_C_Outdoor_4W4D_A/";
                string cityD=Art2+"建筑/EnvBdgMD_City_D_Outdoor_4W5D_2F/";
                var inn=Place(city+"EnvBdgMD_City_C_Outdoor_Pub_A.FBX",null,new Vector3(12,0,2),12,-90,"The Copper Griffin / tavern");
                Facade(inn,city);
                var terraceInn=Place(cityD+"EnvBdgMD_City_D_Outdoor_Inn_A.FBX",null,new Vector3(-14,1.6f,13),11,90,"Terrace inn");
                Facade(terraceInn,city);
                for(int i=0;i<6;i++) {
                    Place(Art1+"MbdMD_Co_T_Plain_L_A_Build_02/MbdMD_Co_T_Plain_L_A_Build_02.FBX",
                        "MbdMD_Co_T_Plain_L_A_Build_"+(i*5+2).ToString("00"),new Vector3(-13,1.6f,25+i*11),10.5f,90,"West timber house "+i);
                    var house=Place(i%2==0?city+"EnvBdgMD_City_C_Outdoor_5W4D_A.FBX":cityD+"EnvBdgMD_City_D_Outdoor_4W5D_2F.FBX",
                        null,new Vector3(12,0,20+i*11),10.4f,-90,"East merchant house "+i);
                    Facade(house,city);
                }
                Place(Art1+"MbdMD_Co_T_River_L_A_WeaponShop/MbdMD_Co_T_River_L_A_WeaponShop.FBX",
                    "MbdMD_Co_T_River_L_A_WeaponShop",new Vector3(-14,1.6f,-8),9.3f,90,"Smithy");
                Place(Art1+"ObjMD_Church_A/ObjMD_Church_A.FBX",null,new Vector3(0,0,83),28,90,"Far sanctuary");
                for(int i=0;i<8;i++) {
                    float x=i%2==0?-26:26;
                    Place(city+"EnvBdgMD_City_C_Outdoor_4W4D_A.FBX",null,new Vector3(x,i%2==0?1.6f:0,10+i*10),9.2f,i%2==0?90:-90,"Outer quarter "+i);
                }
                string tree=Art2+"植物_八方旅人2/树灌木/EnvFldMD_Tree_E_MA_LOD0/EnvFldMD_Tree_E_MA_LOD0_Painted.FBX";
                string conifer=Art2+"植物_八方旅人2/树灌木/EnvFldMD_Tree_I_L/EnvFldMD_Tree_I_M_Painted.FBX";
                for(int i=0;i<30;i++) {
                    float x=(i%2==0?-1:1)*(i<10?8.2f:22+(i%4)*3);
                    float z=i<10?-10+i/2*13: -12+(i-10)/2*11;
                    Place(i%3==0?conifer:tree,null,new Vector3(x,x<0?1.6f:0,z),i<10?10.8f:15+i%3,i*137.5f,"Wind foliage "+i);
                }
                var wood=GetMaterial("Market wood","Relink/Environment",new Color(.31f,.19f,.10f));
                var canvas=GetMaterial("Ochre awning","Relink/Environment",new Color(.87f,.63f,.26f));
                for(int i=0;i<3;i++) {
                    Vector3 p=new Vector3(6.5f,0,10+i*15);
                    Box("Market counter",p+new Vector3(0,.65f,0),new Vector3(1.5f,1.3f,3),wood);
                    var awning=Box("Canvas market canopy",p+new Vector3(0,3.2f,0),new Vector3(2.5f,.12f,3.5f),canvas);
                    awning.transform.rotation=Quaternion.Euler(0,0,-10);
                    foreach(float z in new[]{-1.4f,1.4f}) Box("Canopy post",p+new Vector3(-1,1.6f,z),new Vector3(.12f,3.2f,.12f),wood);
                }
                var moss=GetMaterial("Planter green","Relink/Environment",new Color(.29f,.46f,.14f));
                var grass=GetMaterial("Roadside grass","Relink/Environment",new Color(.32f,.47f,.16f));
                grass.SetFloat("_Cull",0);grass.SetFloat("_MaterialClass",2);grass.SetFloat("_Transmission",.25f);
                grass.SetFloat("_WindStrength",.055f);RelinkTownGroundTools.Grass(grass);
                for(int i=0;i<20;i++) {
                    float x=i%2==0?-6.4f:6.4f; float z=-7+i/2*9;
                    Box("Stone planter",new Vector3(x,.35f,z),new Vector3(1.2f,.7f,1.9f),wall);
                    Place(tree,null,new Vector3(x,.7f,z),1.8f,i*67,"Planter shrub "+i);
                }
                var rock=GetMaterial("Blue distant cliff","Relink/Environment",new Color(.45f,.54f,.58f));
                for(int i=0;i<12;i++) {
                    Place(Art2+"山石_八方旅人2/EnvFldMD_FoliageStone_A_MA/EnvFldMD_FoliageStone_A_MA.FBX",null,
                        new Vector3(-140+i*27,-10,160+i%4*15),55+i%4*12,i*73,"Distant weathered bluff "+i);
                }
                for(int i=0;i<2;i++) {
                    var volume=new GameObject("Local IBL region "+i).AddComponent<RelinkSceneVolume>();
                    volume.transform.position=new Vector3(0,5,10+i*45);volume.size=new Vector3(35,20,40);volume.blendDistance=8;
                    volume.reflectionCube=pipeline.environmentCube;volume.diffuseTint=i==0?new Color(1,.96f,.87f):new Color(.88f,.97f,1);
                }
                var valley=new GameObject("Blue valley regional fog").AddComponent<RelinkSceneVolume>();
                valley.transform.position=new Vector3(0,30,160);valley.size=new Vector3(330,100,140);valley.blendDistance=45;
                valley.regionalFog=true;valley.fogDensity=.003f;valley.fogColor=new Color(.5f,.7f,.84f);
                var fire=new GameObject("Smithy orange local shadow").AddComponent<Light>(); fire.type=LightType.Point;
                fire.transform.position=new Vector3(7,2,0); fire.range=11; fire.intensity=23; fire.color=new Color(1,.35f,.07f); fire.shadows=LightShadows.Soft;
                EditorSceneManager.SaveScene(scene,ScenePath);
            } finally { EditorSceneManager.CloseScene(scene,true); if(previous.IsValid()) SceneManager.SetActiveScene(previous); AssetDatabase.SaveAssets(); }
            Debug.Log("RELINK_TOWN_BUILT "+ScenePath);
        }
        [MenuItem("Tools/Relink SRP/7 - Open Octopath Town")]
        public static void OpenTown() {
            if(!File.Exists(ScenePath)) BuildTown();
            if(!EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo()) return;
            EditorSceneManager.OpenScene(ScenePath);
            RelinkDemoSceneSetup.ConfigureOpenDemo(true);
        }
        static void Bookmark(GameObject parent,string name,Vector3 position,Vector3 look) {
            var go=new GameObject(name); go.transform.SetParent(parent.transform); go.transform.position=position; go.transform.LookAt(look);
        }
        static void Facade(GameObject house,string city) {
            var bounds=BoundsOf(house);
            var entrance=Place(city+"EnvBdgMD_City_C_Outdoor_Entrance_A.FBX",null,
                new Vector3(bounds.center.x,bounds.min.y,bounds.min.z-.45f),2.7f,90,house.name+" / doorway");
            for(int side=-1;side<=1;side+=2) Place(city+"EnvBdgMD_City_C_Outdoor_Window_B.FBX",null,
                new Vector3(bounds.center.x+side*2.2f,bounds.min.y+3.1f,bounds.min.z-.08f),1.4f,90,house.name+" / window");
            entrance.transform.SetParent(house.transform,true);
            var door=GetMaterial("Dark timber doors","Relink/Environment",new Color(.19f,.14f,.10f));
            Box(house.name+" / timber door",entrance.transform.position+new Vector3(0,1.12f,-.06f),new Vector3(1.05f,2.15f,.08f),door).transform.SetParent(house.transform,true);
        }
        static GameObject Box(string name,Vector3 p,Vector3 size,Material material) {
            var go=GameObject.CreatePrimitive(PrimitiveType.Cube); go.name=name; go.transform.position=p; go.transform.localScale=size;
            go.GetComponent<Renderer>().sharedMaterial=material; Object.DestroyImmediate(go.GetComponent<Collider>()); return go;
        }
        static Material GetMaterial(string name,string shader,Color color) {
            string path=Output+"/Materials/"+name+".mat";
            var m=AssetDatabase.LoadAssetAtPath<Material>(path);
            if(m==null) { m=new Material(Shader.Find(shader)); AssetDatabase.CreateAsset(m,path); }
            m.SetColor("_BaseColor",color); m.SetFloat("_HatchStrength",0); m.SetFloat("_BandStrength",0); m.SetFloat("_Smoothness",.16f);
            EditorUtility.SetDirty(m); return m;
        }
        static GameObject Place(string path,string child,Vector3 position,float height,float yaw,string name) {
            var source=AssetDatabase.LoadAssetAtPath<GameObject>(path);
            if(source==null) throw new FileNotFoundException("Town source model missing",path);
            var instance=Object.Instantiate(source);
            if(child!=null) {
                var node=instance.GetComponentsInChildren<Renderer>().FirstOrDefault(r=>r.name==child);
                if(node==null) throw new InvalidOperationException("Missing model child "+child);
                var extracted=new GameObject(name); var renderer=extracted.AddComponent<MeshRenderer>();
                renderer.sharedMaterials=node.sharedMaterials;
                extracted.AddComponent<MeshFilter>().sharedMesh=node.GetComponent<MeshFilter>().sharedMesh;
                extracted.transform.rotation=node.transform.rotation; extracted.transform.localScale=node.transform.lossyScale;
                Object.DestroyImmediate(instance); instance=extracted;
            }
            instance.name=name; instance.transform.position=Vector3.zero;
            instance.transform.rotation=Quaternion.Euler(0,yaw,0)*instance.transform.rotation;
            var bounds=BoundsOf(instance); instance.transform.localScale*=height/Mathf.Max(bounds.size.y,.01f);
            bounds=BoundsOf(instance); instance.transform.position=position-new Vector3(bounds.center.x,bounds.min.y,bounds.center.z);
            foreach(var renderer in instance.GetComponentsInChildren<Renderer>()) {
                renderer.sharedMaterials=renderer.sharedMaterials.Select(m=>Convert(m,path)).ToArray();
                renderer.shadowCastingMode=ShadowCastingMode.TwoSided;
                if(renderer.GetComponent<RelinkMotionHistory>()==null) renderer.gameObject.AddComponent<RelinkMotionHistory>();
            }
            return instance;
        }
        static Material Convert(Material source,string modelPath) {
            if(source==null) return GetMaterial("Fallback plaster","Relink/Environment",Color.white);
            string key=modelPath+"/"+source.name;
            if(Converted.TryGetValue(key,out var result)) return result;
            var texture=source.mainTexture;
            if(texture==null) texture=source.GetTexturePropertyNames().Select(p=>source.GetTexture(p)).FirstOrDefault(t=>t!=null);
            bool leaf=texture!=null && texture.name.Contains("Leaf");
            string name=Path.GetFileNameWithoutExtension(modelPath)+"_"+source.name.Replace('#','_');
            result=GetMaterial(name,"Relink/Environment",Color.white);
            if(texture!=null) {
                result.SetTexture("_BaseMap",texture); result.SetTextureScale("_BaseMap",source.mainTextureScale);
                result.SetTextureOffset("_BaseMap",source.mainTextureOffset);
                string normal=AssetDatabase.GetAssetPath(texture).Replace("_cl.tga","_no.tga");
                if(File.Exists(normal)) {
                    string copy=Output+"/Textures/"+Path.GetFileName(normal);
                    if(!File.Exists(copy)) File.Copy(normal,copy);
                    AssetDatabase.ImportAsset(copy);
                    var importer=(TextureImporter)AssetImporter.GetAtPath(copy);
                    if(importer.textureType!=TextureImporterType.NormalMap || importer.sRGBTexture) {
                        importer.textureType=TextureImporterType.NormalMap; importer.sRGBTexture=false; importer.SaveAndReimport();
                    }
                    result.SetTexture("_BumpMap",AssetDatabase.LoadAssetAtPath<Texture2D>(copy)); result.SetFloat("_BumpScale",.65f);
                }
            }
            if(leaf) {
                result.SetFloat("_AlphaClip",1); result.SetFloat("_Cutoff",.35f); result.SetFloat("_Cull",0);
                result.SetFloat("_MaterialClass",2); result.SetFloat("_Transmission",.45f); result.SetFloat("_WindStrength",.08f);
                result.renderQueue=2450; result.SetOverrideTag("RenderType","TransparentCutout");
                result.SetColor("_BaseColor",new Color(.72f,1.13f,1.04f));
            }
            Converted[key]=result; EditorUtility.SetDirty(result); return result;
        }
        static int validationTicks;
        public static void ValidateTown() {
            try {
                PlayerSettings.colorSpace=ColorSpace.Linear;
                EditorSceneManager.SaveScene(SceneManager.GetActiveScene(),"Assets/TownValidationBootstrap.unity");
                BuildTown(); EditorSceneManager.OpenScene(ScenePath); RelinkDemoSceneSetup.ConfigureOpenDemo(true);
                validationTicks=0; EditorApplication.update+=ValidateTick;
            } catch(Exception e) { Debug.LogException(e); EditorApplication.Exit(1); }
        }
        public static void BuildBenchmarkPlayer() {
            try {
                PlayerSettings.colorSpace=ColorSpace.Linear; PlayerSettings.enableFrameTimingStats=true;
                EditorSceneManager.OpenScene(ScenePath);RelinkDemoSceneSetup.ConfigureOpenDemo(true);
                new GameObject("Disposable GPU benchmark").AddComponent<RelinkTownBenchmark>();
                const string scene="Assets/TownBenchmark.unity";EditorSceneManager.SaveScene(SceneManager.GetActiveScene(),scene);
                Directory.CreateDirectory("Player");
                var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions {scenes=new[]{scene},locationPathName="Player/RelinkTown.exe",target=BuildTarget.StandaloneWindows64,options=BuildOptions.Development});
                if(report.summary.result!=UnityEditor.Build.Reporting.BuildResult.Succeeded) throw new Exception("Town player build failed: "+report.summary.result);
                EditorApplication.Exit(0);
            } catch(Exception e) {Debug.LogException(e);EditorApplication.Exit(1);}
        }
        static void ValidateTick() {
            if(++validationTicks<25) return;
            EditorApplication.update-=ValidateTick;
            try {
                Directory.CreateDirectory("Validation");
                var camera=Camera.main; var pipeline=(RelinkRenderPipelineAsset)GraphicsSettings.defaultRenderPipeline;
                BakeInitialProbes(camera);
                for(int warmup=0;warmup<12;warmup++) Capture(camera,"Validation/warmup.png",1920,1080);
                Capture(camera,"Validation/Town-MarketStreet.png",1920,1080);
                foreach(var name in new[]{"Terrace","Plaza"}) {
                    var bookmark=GameObject.Find("Camera bookmarks/"+name).transform;
                    camera.transform.SetPositionAndRotation(bookmark.position,bookmark.rotation);
                    ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
                    Capture(camera,"Validation/Town-"+name+".png",1280,720);
                }
                var main=GameObject.Find("Camera bookmarks/Market Street").transform;
                camera.transform.SetPositionAndRotation(main.position,main.rotation);
                foreach(int view in new[]{5,6,7,8,9,10,11,13,14}) { pipeline.debugView=view; Capture(camera,"Validation/Town-View"+view+".png",1280,720); }
                pipeline.debugView=0;
                RelinkTownValidation.Run();
                var errors=new[]{pipeline.environmentShader,pipeline.compositeShader,pipeline.deferredShader,pipeline.temporalShader,Shader.Find("Relink/Painted Sky")}
                    .SelectMany(s=>ShaderUtil.GetShaderMessages(s)).Where(m=>m.severity.ToString()=="Error").Select(m=>m.message).ToArray();
                if(errors.Length>0) throw new Exception(string.Join("\n",errors));
                int renderers=Object.FindObjectsByType<Renderer>(FindObjectsSortMode.None).Length;
                File.WriteAllText("Validation/town-result.txt","PASS: Octopath town rendered through independent D3D11 SRP. Renderers="+renderers+" GPU="+SystemInfo.graphicsDeviceName+" Unity="+Application.unityVersion);
                AssetDatabase.SaveAssets(); EditorApplication.Exit(0);
            } catch(Exception e) { Debug.LogException(e); EditorApplication.Exit(1); }
        }
        public static void Capture(Camera camera,string path,int width,int height) {
            var target=new RenderTexture(width,height,24,RenderTextureFormat.ARGB32); target.Create();
            var pixels=new Texture2D(width,height,TextureFormat.RGB24,false);
            var old=RenderTexture.active;
            try {
                RenderPipeline.SubmitRenderRequest(camera,new RenderPipeline.StandardRequest {destination=target});
                RenderTexture.active=target; pixels.ReadPixels(new Rect(0,0,width,height),0,0); pixels.Apply();
                File.WriteAllBytes(path,pixels.EncodeToPNG());
            } finally { RenderTexture.active=old; target.Release(); Object.DestroyImmediate(target); Object.DestroyImmediate(pixels); }
        }
        static void BakeInitialProbes(Camera camera) {
            Capture(camera,"Validation/probe-bootstrap.png",320,180);
            RelinkLightingBaker.BakeSceneProbes();
            ((RelinkRenderPipeline)RenderPipelineManager.currentPipeline).ResetCameraHistory(camera);
        }
    }
}
