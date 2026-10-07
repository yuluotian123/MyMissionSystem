Shader hash e43a10fb-a23f4175-b7e11448-0902ead7

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[24] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb1[1] (ParamBuffer), immediateIndexed
      dcl_resource_structured g_InstanceWorldTbl (t28), 48
      dcl_input v0.xyz
      dcl_input v1.xyzw
      dcl_input v2.xy
      dcl_input v3.xyzw
      dcl_input v4.xyz
      dcl_input v5.xyz
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.xyzw
      dcl_output o4.xyzw
      dcl_output o5.xyzw
      dcl_output o6.xyzw
      dcl_output o7.xyzw
      dcl_output o8.xyzw
      dcl_output o9.xy
      dcl_output o9.zw
      dcl_output o10.x
      dcl_temps 8
   0: mov r0.w, l(1.000000)
   1: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, v5.x, l(16), g_InstanceWorldTbl.xzyw
   2: mov r2.xyz, v0.xyzx
   3: mov r2.w, l(1.000000)
   4: dp4 r0.y, r2.xzyw, r1.xyzw
   5: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, v5.x, l(0), g_InstanceWorldTbl.yxzw
   6: dp4 r0.x, r2.yxzw, r3.xyzw
   7: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, v5.x, l(32), g_InstanceWorldTbl.xyzw
   8: dp4 r0.z, r2.xyzw, r4.xyzw
   9: dp4 r5.x, r0.xyzw, g_View[0].xyzw
  10: dp4 r5.y, r0.xyzw, g_View[1].xyzw
  11: dp4 r5.z, r0.xyzw, g_View[2].xyzw
  12: dp4 r5.w, r0.xyzw, g_View[3].xyzw
  13: mov o3.xyzw, r0.xyzw
  14: mul r0.xy, r0.xzxx, l(1.000000, -1.000000, 0.000000, 0.000000)
  15: dp4 r6.x, r5.xyzw, g_Proj[0].xyzw
  16: dp4 r6.y, r5.xyzw, g_Proj[1].xyzw
  17: dp4 r6.z, r5.xyzw, g_Proj[2].xyzw
  18: dp4 r6.w, r5.xyzw, g_Proj[3].xyzw
  19: mov o0.xyzw, r6.xyzw
  20: mov o7.xyzw, r6.xyzw
  21: mov o1.xyzw, v3.xyzw
  22: mov o2.xy, v2.xyxx
  23: mov o2.zw, l(0, 0, 0, 0)
  24: mov r5.x, r3.y
  25: mov r5.y, r1.x
  26: mov r5.z, r4.x
  27: dp3 r6.x, r5.xyzx, g_View[3].xyzx
  28: mov r1.x, r3.z
  29: mov r3.y, r1.z
  30: mov r3.z, r4.y
  31: mov r1.z, r4.z
  32: dp3 r6.y, r3.xyzx, g_View[3].xyzx
  33: dp3 r6.z, r1.xyzx, g_View[3].xyzx
  34: dp3 r4.w, v4.xyzx, r6.xyzx
  35: dp3 r6.w, v1.xyzx, r6.xyzx
  36: dp3 r7.x, r5.xyzx, g_View[0].xyzx
  37: dp3 r7.y, r3.xyzx, g_View[0].xyzx
  38: dp3 r7.z, r1.xyzx, g_View[0].xyzx
  39: dp3 r4.x, v4.xyzx, r7.xyzx
  40: dp3 r6.x, v1.xyzx, r7.xyzx
  41: dp3 r7.x, r5.xyzx, g_View[1].xyzx
  42: dp3 r5.x, r5.xyzx, g_View[2].xyzx
  43: dp3 r7.y, r3.xyzx, g_View[1].xyzx
  44: dp3 r5.y, r3.xyzx, g_View[2].xyzx
  45: dp3 r7.z, r1.xyzx, g_View[1].xyzx
  46: dp3 r5.z, r1.xyzx, g_View[2].xyzx
  47: dp3 r4.y, v4.xyzx, r7.xyzx
  48: dp3 r6.y, v1.xyzx, r7.xyzx
  49: dp3 r4.z, v4.xyzx, r5.xyzx
  50: dp3 r6.z, v1.xyzx, r5.xyzx
  51: dp4 r0.z, r4.xyzw, r4.xyzw
  52: rsq r0.z, r0.z
  53: mul r1.xyz, r0.zzzz, r4.xyzx
  54: mov o4.xyz, r1.xyzx
  55: mov o4.w, l(0)
  56: dp4 r0.z, r6.xyzw, r6.xyzw
  57: rsq r0.z, r0.z
  58: mul r3.xyz, r0.zzzz, r6.xyzx
  59: mov o5.xyz, r3.xyzx
  60: mov o5.w, v1.w
  61: mul r4.xyz, r1.yzxy, r3.zxyz
  62: mad r1.xyz, r3.yzxy, r1.zxyz, -r4.xyzx
  63: mul o6.xyz, r1.xyzx, v1.wwww
  64: mov o6.w, l(0)
  65: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, v5.y, l(0), g_InstanceWorldTbl.xyzw
  66: mov r3.x, r1.x
  67: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, v5.y, l(16), g_InstanceWorldTbl.xzyw
  68: mov r3.y, r4.x
  69: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, v5.y, l(32), g_InstanceWorldTbl.xywz
  70: mov r3.z, r5.x
  71: dp3 r6.x, r3.xyzx, g_PrevView[0].xyzx
  72: mov r7.x, r1.y
  73: mov r7.y, r4.z
  74: mov r7.z, r5.y
  75: dp3 r6.y, r7.xyzx, g_PrevView[0].xyzx
  76: mov r4.x, r1.z
  77: mov r5.x, r1.w
  78: mov r5.y, r4.w
  79: mov r4.z, r5.w
  80: dp3 r6.z, r4.xyzx, g_PrevView[0].xyzx
  81: mov r5.w, l(1.000000)
  82: dp4 r6.w, r5.xyzw, g_PrevView[0].xyzw
  83: dp4 r1.x, r2.xyzw, r6.xyzw
  84: dp3 r6.x, r3.xyzx, g_PrevView[1].xyzx
  85: dp3 r6.y, r7.xyzx, g_PrevView[1].xyzx
  86: dp3 r6.z, r4.xyzx, g_PrevView[1].xyzx
  87: dp4 r6.w, r5.xyzw, g_PrevView[1].xyzw
  88: dp4 r1.y, r2.xyzw, r6.xyzw
  89: dp4 r6.w, r5.xyzw, g_PrevView[2].xyzw
  90: dp4 r5.w, r5.xyzw, g_PrevView[3].xyzw
  91: dp3 r6.x, r3.xyzx, g_PrevView[2].xyzx
  92: dp3 r5.x, r3.xyzx, g_PrevView[3].xyzx
  93: dp3 r6.y, r7.xyzx, g_PrevView[2].xyzx
  94: dp3 r5.y, r7.xyzx, g_PrevView[3].xyzx
  95: dp3 r6.z, r4.xyzx, g_PrevView[2].xyzx
  96: dp3 r5.z, r4.xyzx, g_PrevView[3].xyzx
  97: dp4 r1.w, r2.xyzw, r5.xyzw
  98: dp4 r1.z, r2.xyzw, r6.xyzw
  99: dp4 o8.x, r1.xyzw, g_PrevProj[0].xyzw
 100: dp4 o8.y, r1.xyzw, g_PrevProj[1].xyzw
 101: dp4 o8.z, r1.xyzw, g_PrevProj[2].xyzw
 102: dp4 o8.w, r1.xyzw, g_PrevProj[3].xyzw
 103: mul r0.zw, r0.xxxy, g_WorldUVTile0.xxxy
 104: mul r0.xy, r0.xyxx, g_WorldUVTile1.xyxx
 105: mul o9.xyzw, r0.zwxy, l(0.250000, 0.250000, 0.250000, 0.250000)
 106: mov o10.x, v5.z
 107: ret
