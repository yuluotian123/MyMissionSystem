Shader hash ee0d11ca-8063c8e3-9ce5c5a3-d849e2a6

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb1[1] (ParamBuffer), immediateIndexed
      dcl_sampler g_TextureNowLumminaceSampler (s0), mode_default
      dcl_sampler g_TextureAdaptPrevSampler (s1), mode_default
      dcl_resource_texture2d (float,float,float,float) g_TextureNowLumminace (t0)
      dcl_resource_texture2d (float,float,float,float) g_TextureAdaptPrev (t1)
      dcl_output o0.xyzw
      dcl_temps 1
   0: sample_indexable(texture2d)(float,float,float,float) r0.x, l(0.500000, 0.500000, 0.000000, 0.000000), g_TextureNowLumminace.xyzw, g_TextureNowLumminaceSampler
   1: sample_indexable(texture2d)(float,float,float,float) r0.y, l(0.500000, 0.500000, 0.000000, 0.000000), g_TextureAdaptPrev.yxzw, g_TextureAdaptPrevSampler
   2: add r0.x, -r0.y, r0.x
   3: mad r0.x, r0.x, g_Param.z, r0.y
   4: max r0.x, r0.x, g_Param.x
   5: min o0.xyzw, r0.xxxx, g_Param.yyyy
   6: ret
