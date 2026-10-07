Shader hash 24caa804-b0abbc2a-e0a94e1c-741692e7

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_input v0.xyw
      dcl_input v1.xy
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xy
   0: mad o0.xyw, v0.xyxw, l(2.000000, 2.000000, 0.000000, 1.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
   1: mov o0.z, l(1.000000)
   2: mov o1.xy, v1.xyxx
   3: ret
