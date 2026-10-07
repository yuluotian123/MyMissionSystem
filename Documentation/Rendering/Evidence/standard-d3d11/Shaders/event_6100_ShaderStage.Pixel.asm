Shader hash 0229508d-a5623996-6364699d-d3a417c8

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_Texture0 (t0)
      dcl_input_ps linear v1.xy
      dcl_input_ps linear v3.xyz
      dcl_output o0.xyzw
      dcl_temps 1
   0: sample_indexable(texture2d)(float,float,float,float) r0.x, v1.xyxx, g_Texture0.wxyz, ModelSampler
   1: lt r0.x, r0.x, l(0.500000)
   2: discard_nz r0.x
   3: add r0.x, v3.z, v3.x
   4: lt r0.x, r0.x, l(0)
   5: discard_nz r0.x
   6: mov o0.x, v3.y
   7: mov o0.yzw, l(0.000000, 0.000000, 0.000000, 1.000000)
   8: ret
