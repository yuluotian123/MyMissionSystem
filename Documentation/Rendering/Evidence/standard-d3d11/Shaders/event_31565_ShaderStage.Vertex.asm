Shader hash 777acbba-10b22ef4-d425af3e-a5577116

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_input_sgv v0.x, vertexid
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xy
      dcl_temps 1
   0: ushr r0.x, v0.x, l(1)
   1: utof r0.x, r0.x
   2: mad o0.x, r0.x, l(4.000000), l(-1.000000)
   3: add o1.x, r0.x, r0.x
   4: and r0.x, v0.x, l(1)
   5: utof r0.x, r0.x
   6: mad o0.y, r0.x, l(4.000000), l(-1.000000)
   7: mad o1.y, -r0.x, l(2.000000), l(1.000000)
   8: mov o0.zw, l(0.000000, 0.000000, 0.000000, 1.000000)
   9: ret
