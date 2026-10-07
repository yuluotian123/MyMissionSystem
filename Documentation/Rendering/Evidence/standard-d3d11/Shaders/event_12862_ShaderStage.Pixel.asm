Shader hash 97fd24c0-eec1aa03-00b7fdf7-808ec87a

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_Texture0 (t0)
      dcl_input_ps linear v1.xy
      dcl_temps 1
   0: sample_indexable(texture2d)(float,float,float,float) r0.x, v1.xyxx, g_Texture0.wxyz, ModelSampler
   1: lt r0.x, r0.x, l(0.500000)
   2: discard_nz r0.x
   3: ret
