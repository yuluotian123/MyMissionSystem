Shader hash 021ebf0d-25216a9f-10132ee3-750dbade

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb1[1] (ParamBuffer), immediateIndexed
      dcl_sampler g_Texture0Sampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_Texture0 (t0)
      dcl_input_ps linear v1.xyzw
      dcl_output o0.x
      dcl_temps 1
   0: sample_indexable(texture2d)(float,float,float,float) r0.x, v1.xyxx, g_Texture0.xyzw, g_Texture0Sampler
   1: add r0.x, r0.x, v1.z
   2: rcp r0.x, r0.x
   3: mad o0.x, v1.w, r0.x, -g_Camera.y
   4: ret
