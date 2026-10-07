Shader hash ad61b83b-0fbce534-a66fcf94-b9136663

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb9[12] (ParamBuffer), immediateIndexed
      dcl_sampler CubeSampler (s0), mode_default
      dcl_resource_texturecube (float,float,float,float) g_CubeTexture (t0)
      dcl_resource_texture2d (float,float,float,float) TextureEV (t6)
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_output o1.xyzw
      dcl_output o2.xy
      dcl_temps 5
   0: mad r0.xy, v1.xyxx, l(-1.000000, 1.000000, 0.000000, 0.000000), l(1.000000, 0.000000, 0.000000, 0.000000)
   1: mad r0.xy, r0.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
   2: div r1.x, r0.x, g_Proj[0].x
   3: div r1.y, r0.y, g_Proj[1].y
   4: add r0.x, g_CameraParam.y, g_CameraParam.x
   5: mov r1.z, l(1.000000)
   6: mul r0.xyz, r0.xxxx, r1.xyzx
   7: mov r0.w, l(1.000000)
   8: dp4 r1.x, r0.xyzw, g_ViewInverseMatrix[0].xyzw
   9: dp4 r1.y, r0.xyzw, g_ViewInverseMatrix[1].xyzw
  10: dp4 r1.z, r0.xyzw, g_ViewInverseMatrix[2].xyzw
  11: dp4 r1.w, r0.xyzw, g_ViewInverseMatrix[3].xyzw
  12: add r0.xyz, -r1.xyzx, g_CameraVec.xyzx
  13: dp3 r0.w, r0.xyzx, r0.xyzx
  14: rsq r0.w, r0.w
  15: mul r0.xyz, r0.wwww, r0.xyzx
  16: mov r0.w, l(1.000000)
  17: dp4 r2.x, r0.xyzw, g_Rotation[0].xyzw
  18: dp4 r2.y, r0.xyzw, g_Rotation[1].xyzw
  19: dp4 r0.x, r0.xyzw, g_Rotation[2].xyzw
  20: mov r2.z, -r0.x
  21: sample_indexable(texturecube)(float,float,float,float) r0.xyz, r2.xyzx, g_CubeTexture.xyzw, CubeSampler
  22: mul r0.xyz, r0.xyzx, g_Intensity.xyzx
  23: mov r0.w, l(1.000000)
  24: dp4 r2.x, r0.xyzw, g_colorMatrix[0].xyzw
  25: dp4 r2.y, r0.xyzw, g_colorMatrix[1].xyzw
  26: dp4 r2.z, r0.xyzw, g_colorMatrix[2].xyzw
  27: if_nz g_evCancel.x
  28:   ld_indexable(texture2d)(float,float,float,float) r0.x, l(0, 0, 0, 0), TextureEV.xyzw
  29:   add r0.x, r0.x, l(-0.500000)
  30:   add r0.x, r0.x, r0.x
  31:   mad r0.yzw, r2.xxyz, l(0.000000, 0.108769, 0.108769, 0.108769), l(0.000000, -0.005000, -0.005000, -0.005000)
  32:   mad r3.xyz, r2.xyzx, l(0.032631, 0.032631, 0.032631, 0.000000), l(-0.042000, -0.042000, -0.042000, 0.000000)
  33:   mul r4.xyz, r2.xyzx, r3.xyzx
  34:   mul r4.xyz, r4.xyzx, l(0.052209, 0.052209, 0.052209, 0.000000)
  35:   mad r4.xyz, r0.yzwy, r0.yzwy, -r4.xyzx
  36:   sqrt r4.xyz, r4.xyzx
  37:   add r0.yzw, -r0.yyzw, -r4.xxyz
  38:   add r3.xyz, r3.xyzx, r3.xyzx
  39:   div r0.yzw, r0.yyzw, r3.xxyz
  40:   div r2.xyz, r0.yzwy, r0.xxxx
  41: endif
  42: dp4 r0.x, r1.xyzw, g_ViewProjection[0].xyzw
  43: dp4 r0.y, r1.xyzw, g_ViewProjection[1].xyzw
  44: dp4 r0.z, r1.xyzw, g_ViewProjection[3].xyzw
  45: dp4 r3.x, r1.xyzw, g_PrevViewProjection[0].xyzw
  46: dp4 r3.y, r1.xyzw, g_PrevViewProjection[1].xyzw
  47: dp4 r0.w, r1.xyzw, g_PrevViewProjection[3].xyzw
  48: div r0.xy, r0.xyxx, r0.zzzz
  49: add r0.xy, r0.xyxx, g_ProjectionOffset.xyxx
  50: add r0.xy, r0.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
  51: mul r0.x, r0.x, l(0.500000)
  52: div r1.xy, r3.xyxx, r0.wwww
  53: add r1.xy, r1.xyxx, g_ProjectionOffset.zwzz
  54: add r1.xy, r1.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
  55: mul r1.x, r1.x, l(0.500000)
  56: mad r1.z, -r1.y, l(0.500000), l(1.000000)
  57: mad r0.z, -r0.y, l(0.500000), l(1.000000)
  58: add o2.xy, r0.xzxx, -r1.xzxx
  59: mov o0.xyz, r2.xyzx
  60: mov o0.w, l(1.000000)
  61: mov o1.xyzw, l(0, 0, 0, 0)
  62: ret
