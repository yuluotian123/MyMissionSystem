using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    // IMGUI events work with both Unity input backends, without a package dependency.
    [RequireComponent(typeof(Camera)), AddComponentMenu("Rendering/Relink Town Navigator")]
    public sealed class RelinkTownNavigator : MonoBehaviour
    {
        public Transform[] viewpoints;
        public float moveSpeed=7,lookSpeed=.18f;
        readonly HashSet<KeyCode> held=new HashSet<KeyCode>();
        bool looking;
        void OnDisable() {held.Clear();looking=false;}
        void OnApplicationFocus(bool focused) {if(!focused){held.Clear();looking=false;}}
        void Update() {
            Vector3 direction=Vector3.zero;
            if(held.Contains(KeyCode.W)||held.Contains(KeyCode.UpArrow)) direction+=transform.forward;
            if(held.Contains(KeyCode.S)||held.Contains(KeyCode.DownArrow)) direction-=transform.forward;
            if(held.Contains(KeyCode.D)||held.Contains(KeyCode.RightArrow)) direction+=transform.right;
            if(held.Contains(KeyCode.A)||held.Contains(KeyCode.LeftArrow)) direction-=transform.right;
            if(held.Contains(KeyCode.E)) direction+=Vector3.up;
            if(held.Contains(KeyCode.Q)) direction-=Vector3.up;
            float boost=held.Contains(KeyCode.LeftShift)||held.Contains(KeyCode.RightShift)?3:1;
            transform.position+=direction.normalized*moveSpeed*boost*Time.unscaledDeltaTime;
        }
        public void GoTo(int index) {
            if(viewpoints==null||index<0||index>=viewpoints.Length||viewpoints[index]==null)return;
            transform.SetPositionAndRotation(viewpoints[index].position,viewpoints[index].rotation);
            if(RenderPipelineManager.currentPipeline is RelinkRenderPipeline pipeline) pipeline.ResetCameraHistory(GetComponent<Camera>());
        }
        void OnGUI() {
            if(Application.isBatchMode)return;
            Event e=Event.current;
            if(e.type==EventType.KeyDown) {
                held.Add(e.keyCode);
                if(e.keyCode>=KeyCode.Alpha1&&e.keyCode<=KeyCode.Alpha3)GoTo((int)e.keyCode-(int)KeyCode.Alpha1);
            }
            if(e.type==EventType.KeyUp)held.Remove(e.keyCode);
            if(e.type==EventType.MouseDown&&e.button==1)looking=true;
            if(e.type==EventType.MouseUp&&e.button==1)looking=false;
            if(e.type==EventType.MouseDrag&&looking) {
                Vector3 angles=transform.eulerAngles;float pitch=Mathf.DeltaAngle(0,angles.x);
                transform.rotation=Quaternion.Euler(Mathf.Clamp(pitch+e.delta.y*lookSpeed,-85,85),angles.y+e.delta.x*lookSpeed,0);
                e.Use();
            }
            GUILayout.BeginArea(new Rect(16,16,345,112),GUI.skin.box);
            GUILayout.Label("Relink SRP / Octopath Town");
            GUILayout.BeginHorizontal();
            if(viewpoints!=null)for(int i=0;i<viewpoints.Length;i++)if(GUILayout.Button((i+1)+" "+viewpoints[i].name))GoTo(i);
            GUILayout.EndHorizontal();
            GUILayout.Label("WASD move  |  Q/E height  |  Shift fast");
            GUILayout.Label("Right mouse drag to look  |  1/2/3 viewpoints");
            GUILayout.EndArea();
        }
    }
}
