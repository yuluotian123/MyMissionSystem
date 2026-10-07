Shader hash 5646936a-e178b6a8-ce7e7ba8-776ce05b

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_input_ps linear v2.xyz
      dcl_output o0.xyzw
      dcl_temps 1
   0: add r0.x, v2.z, v2.x
   1: lt r0.x, r0.x, l(0)
   2: discard_nz r0.x
   3: mov o0.x, v2.y
   4: mov o0.yzw, l(0.000000, 0.000000, 0.000000, 1.000000)
   5: ret
