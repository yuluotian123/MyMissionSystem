Shader hash 18c48c43-8c2e881d-087164dc-ec0c6b69

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[7] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb1[1] (ParamBuffer), immediateIndexed
      dcl_input v0.xyzw
      dcl_input v1.xy
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xyzw
   0: mad o0.xyzw, v0.xyzw, l(2.000000, 2.000000, 1.000000, 1.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
   1: mul o1.w, g_Proj[2].w, g_Camera.x
   2: mov o1.xy, v1.xyxx
   3: mov o1.z, g_Proj[2].z
   4: ret
