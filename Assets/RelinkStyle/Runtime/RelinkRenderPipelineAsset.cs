using UnityEngine;
using UnityEngine.Rendering;

namespace MyMission.Rendering
{
    public enum RelinkRenderingPath { PrototypeForward, EvidenceDeferred }

    [CreateAssetMenu(menuName = "Rendering/Relink Scene Pipeline", fileName = "RelinkScenePipeline")]
    public sealed class RelinkRenderPipelineAsset : RenderPipelineAsset<RelinkRenderPipeline>
    {
        [Header("Shaders (serialized so player builds retain them)")]
        public Shader environmentShader;
        public Shader compositeShader;
        public Shader deferredShader;
        public RelinkRenderingPath renderingPath = RelinkRenderingPath.EvidenceDeferred;
        [Header("Deferred material classification")]
        [Range(0, 65535)] public int directionalLightClassMask = 65535;
        [Tooltip("Captured g_SubtractLightTexture input; black when unassigned. Screen UV texture.")]
        public Texture2D subtractLightTexture;
        public bool class5IgnoresDirectionalShadow;
        public bool indirectLighting = true;
        public bool localLights = true;
        [Header("Town rendering (independent SRP)")]
        public bool threeCascadePCSS;
        public Vector3 cascadeDistances = new Vector3(25,115,300);
        [Range(.001f,.3f)] public float shadowPenumbra = .05f;
        public bool tileLocalLights;
        public bool localShadows;
        [Tooltip("Point lights write two radial R16F hemispheres as observed in source event 5825.")]
        public bool dualParaboloidPointShadows;
        [Range(0,.1f),Tooltip("Hemisphere overlap for coarse source meshes; source captured value is .002.")]
        public float pointShadowHemisphereOverlap=.05f;
        public ComputeShader tileLightingShader;
        public bool imageBasedLighting;
        public bool capturedIBLMaterialFormula = true;
        public Cubemap environmentCube;
        public Cubemap environmentDiffuseCube;
        public Texture2D environmentBRDF;
        [Range(0,5)] public float environmentIntensity = 1;
        public Shader temporalShader;
        public bool temporalAA;
        public bool motionBlur;
        [Range(0,1)] public float shutter = .25f;
        public bool automaticExposure;
        public Vector2 exposureLimits = new Vector2(.5f,4);
        public float exposureKey = .6f;
        public float exposureSpeed = 1.5f;
        public bool colorGrading;
        public Texture3D nearLUT, farLUT;
        public Vector2 gradingDistances = new Vector2(30,120);
        public bool depthColorLines;
        public float lineCoefficient = .8f;
        public float lineCoefficientNear = .35f;
        public Color lineTint = new Color(.55f,.65f,.78f);
        public bool capturedLineParameters = true;
        public bool geometricOutlines;
        [Header("Sun shadows")]
        [Range(512, 4096)] public int shadowAtlasSize = 2048;
        [Range(10, 250)] public float shadowDistance = 100;
        [Range(0.01f, 0.8f)] public float cascadeSplit = 0.25f;
        [Range(0, 4)] public float shadowBias = 1.2f;
        [Range(0, 0.2f)] public float shadowNormalBias = 0.025f;
        [Header("Illustrated atmosphere")]
        public Color ambientSky = new Color(0.48f, 0.62f, 0.78f);
        public Color ambientGround = new Color(0.28f, 0.25f, 0.23f);
        [Range(0, 2)] public float ambientIntensity = 0.65f;
        public Color fogColor = new Color(0.64f, 0.78f, 0.85f);
        [Min(0)] public float fogDensity = 0.012f;
        public float fogBaseHeight = 0;
        [Min(0)] public float fogHeightFalloff = 0.08f;
        [Header("Composition")]
        [Range(-3, 3)] public float exposure = 0;
        [Range(0, 2)] public float saturation = 0.95f;
        [Range(0.5f, 1.5f)] public float contrast = 1.04f;
        [Range(0, 1)] public float bloomIntensity = 0.12f;
        [Min(0)] public float bloomThreshold = 1.1f;
        [Range(0, 1)] public float outlineStrength = 0.18f;
        public Color outlineColor = new Color(0.2f, 0.24f, 0.28f);
        [Range(0.5f, 3)] public float outlineWidth = 1;
        [Header("0 final / 1 HDR / 2 normals / 3 depth / 4 edges")]
        [Tooltip("Deferred: 5 albedo, 6 mask, 7 UV velocity, 8 stencil class, 9 sun direct, 10 shadow, 11 indirect, 12 flags")]
        [Range(0, 16)] public int debugView;
        public override Shader defaultShader => environmentShader;
        public override string renderPipelineShaderTag => "RelinkPipeline";
        protected override RenderPipeline CreatePipeline() => new RelinkRenderPipeline(this);
    }
}
