using System.Collections.Generic;
using UnityEngine;

namespace MyMission.Rendering
{
    [ExecuteAlways, AddComponentMenu("Rendering/Relink Scene Volume")]
    public sealed class RelinkSceneVolume : MonoBehaviour
    {
        internal static readonly List<RelinkSceneVolume> Active = new List<RelinkSceneVolume>();
        public Vector3 size = new Vector3(20,12,20);
        [Min(.01f)] public float blendDistance = 4;
        public Cubemap reflectionCube;
        public Cubemap diffuseCube;
        public Color diffuseTint = Color.white;
        [Min(0)] public float intensity = 1;
        public bool regionalFog;
        public Color fogColor = new Color(.6f,.74f,.83f);
        [Min(0)] public float fogDensity = .01f;
        void OnEnable() { if(!Active.Contains(this)) Active.Add(this); }
        void OnDisable() { Active.Remove(this); }
        void OnDrawGizmosSelected() {
            Gizmos.matrix=transform.localToWorldMatrix; Gizmos.color=new Color(.25f,.75f,1,.7f); Gizmos.DrawWireCube(Vector3.zero,size);
        }
    }
}
