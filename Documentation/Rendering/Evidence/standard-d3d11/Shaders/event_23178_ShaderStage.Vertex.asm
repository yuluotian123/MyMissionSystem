Shader hash 528be014-36f3f53d-78d9c9a5-ecea2708

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_input v0.xyzw
      dcl_input v1.xy
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xy
   0: mad o0.xyzw, v0.xyzw, l(2.000000, 2.000000, 1.000000, 1.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
   1: mov o1.xy, v1.xyxx
   2: ret
