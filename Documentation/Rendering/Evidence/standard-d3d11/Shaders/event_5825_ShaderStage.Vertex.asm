Shader hash 6fec9ffd-5862969e-1fdd440a-c5c6f173

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb5[5] (ParamBuffer), immediateIndexed
      dcl_resource_structured g_InstanceWorldTbl (t28), 48
      dcl_input v0.xyz
      dcl_input v1.xz
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.x
      dcl_temps 3
   0: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, v1.x, l(0), g_InstanceWorldTbl.xyzw
   1: mov r1.xyz, v0.xyzx
   2: mov r1.w, l(1.000000)
   3: dp4 r0.x, r1.xyzw, r0.xyzw
   4: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, v1.x, l(16), g_InstanceWorldTbl.xyzw
   5: dp4 r0.y, r1.xyzw, r2.xyzw
   6: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, v1.x, l(32), g_InstanceWorldTbl.xyzw
   7: dp4 r0.z, r1.xyzw, r2.xyzw
   8: mov r0.w, l(1.000000)
   9: dp4 r1.x, r0.xyzw, tmp_ShadowView[0].xyzw
  10: dp4 r1.y, r0.xyzw, tmp_ShadowView[1].xyzw
  11: dp4 r1.z, r0.xyzw, tmp_ShadowView[2].xyzw
  12: dp4 r0.x, r0.xyzw, tmp_ShadowView[3].xyzw
  13: div r0.xyz, r1.xyzx, r0.xxxx
  14: dp3 r0.w, r0.xyzx, r0.xyzx
  15: sqrt r0.w, r0.w
  16: div r0.xyz, r0.xyzx, r0.wwww
  17: add r0.w, r0.w, -tmp_ShadowViewParams.y
  18: add r1.x, r0.z, l(1.000000)
  19: div r1.xy, r0.xyxx, r1.xxxx
  20: mov o2.x, r0.z
  21: add r0.x, -tmp_ShadowViewParams.y, tmp_ShadowViewParams.z
  22: div r1.z, r0.w, r0.x
  23: mov r1.w, l(1.000000)
  24: mov o0.xyzw, r1.xyzw
  25: mov o1.xyzw, r1.xyzw
  26: mov o2.y, r1.z
  27: mov o2.z, tmp_ShadowViewParams.w
  28: mov o2.w, l(0)
  29: mov o3.x, v1.z
  30: ret
