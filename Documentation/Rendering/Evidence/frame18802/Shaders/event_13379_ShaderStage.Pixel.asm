Shader hash b31131bf-87f4b66b-32aff673-a4828727

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb1[1] (ParamBuffer), immediateIndexed
      dcl_sampler g_TextureSceneColorHDRSampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_TextureSceneColorHDR (t0)
      dcl_output o0.xyzw
      dcl_temps 1
   0: sample_indexable(texture2d)(float,float,float,float) r0.xyz, l(0.500000, 0.500000, 0.000000, 0.000000), g_TextureSceneColorHDR.xyzw, g_TextureSceneColorHDRSampler
   1: dp3 r0.x, r0.xyzx, l(0.298912, 0.586611, 0.114478, 0.000000)
   2: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.200000, 0.500000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
   3: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
   4: add r0.x, r0.y, r0.x
   5: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.800000, 0.500000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
   6: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
   7: add r0.x, r0.y, r0.x
   8: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.500000, 0.200000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
   9: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  10: add r0.x, r0.y, r0.x
  11: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.500000, 0.800000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  12: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  13: add r0.x, r0.y, r0.x
  14: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.350000, 0.350000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  15: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  16: add r0.x, r0.y, r0.x
  17: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.650000, 0.350000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  18: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  19: add r0.x, r0.y, r0.x
  20: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.350000, 0.650000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  21: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  22: add r0.x, r0.y, r0.x
  23: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.650000, 0.650000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  24: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  25: add r0.x, r0.y, r0.x
  26: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.100000, 0.500000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  27: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  28: add r0.x, r0.y, r0.x
  29: sample_indexable(texture2d)(float,float,float,float) r0.yzw, l(0.900000, 0.500000, 0.000000, 0.000000), g_TextureSceneColorHDR.wxyz, g_TextureSceneColorHDRSampler
  30: dp3 r0.y, r0.yzwy, l(0.298912, 0.586611, 0.114478, 0.000000)
  31: add r0.x, r0.y, r0.x
  32: mul r0.x, r0.x, l(0.090909)
  33: rcp r0.x, r0.x
  34: max r0.x, r0.x, g_Param.x
  35: min o0.xyzw, r0.xxxx, g_Param.yyyy
  36: ret
