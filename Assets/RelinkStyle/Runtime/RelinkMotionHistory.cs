using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    [ExecuteAlways, RequireComponent(typeof(Renderer)), AddComponentMenu("Rendering/Relink Motion History")]
    public sealed class RelinkMotionHistory : MonoBehaviour
    {
        internal static readonly List<RelinkMotionHistory> Active=new List<RelinkMotionHistory>();
        readonly Dictionary<int,Matrix4x4> matrices=new Dictionary<int,Matrix4x4>();
        Renderer target;
        MaterialPropertyBlock properties;
        void OnEnable() {
            target=GetComponent<Renderer>(); target.motionVectorGenerationMode=MotionVectorGenerationMode.Object;
            if(target is SkinnedMeshRenderer skin) skin.skinnedMotionVectors=true;
            properties=new MaterialPropertyBlock(); if(!Active.Contains(this)) Active.Add(this);
        }
        void OnDisable() {Active.Remove(this);matrices.Clear();}
        internal void Prepare(Camera camera,bool valid) {
            if(target==null) return;
            int id=camera.GetInstanceID(); var current=transform.localToWorldMatrix;
            var previous=valid && matrices.TryGetValue(id,out var value)?value:current;
            target.GetPropertyBlock(properties);properties.SetMatrix("_RelinkPreviousObjectToWorld",previous);
            properties.SetFloat("_RelinkCustomObjectHistory",1);target.SetPropertyBlock(properties);
        }
        internal void Commit(Camera camera) {matrices[camera.GetInstanceID()]=transform.localToWorldMatrix;}
        internal void Reset(Camera camera) {matrices.Remove(camera.GetInstanceID());}
    }
}
