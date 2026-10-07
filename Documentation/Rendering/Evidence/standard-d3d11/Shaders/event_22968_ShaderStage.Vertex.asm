Shader hash 02b69607-49d6b321-bf13b299-2f557eb9

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[24] (SceneBuffer), immediateIndexed
      dcl_resource_structured g_InstanceWorldTbl (t28), 48
      dcl_input v0.xyz
      dcl_input v1.xyzw
      dcl_input v2.xy
      dcl_input v3.xyzw
      dcl_input v4.xyzw
      dcl_input v5.xyz
      dcl_input v6.xyz
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.xyzw
      dcl_output o4.xyzw
      dcl_output o5.xyzw
      dcl_output o6.xyzw
      dcl_output o7.x
      dcl_temps 7
   0: iadd r0.xyzw, v3.xyzw, v6.xxxx
   1: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, r0.y, l(0), g_InstanceWorldTbl.xyzw
   2: mul r1.xyzw, r1.xyzw, v4.yyyy
   3: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.x, l(0), g_InstanceWorldTbl.xyzw
   4: mad r1.xyzw, r2.xyzw, v4.xxxx, r1.xyzw
   5: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.z, l(0), g_InstanceWorldTbl.xyzw
   6: mad r1.xyzw, r2.xyzw, v4.zzzz, r1.xyzw
   7: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.w, l(0), g_InstanceWorldTbl.xyzw
   8: mad r1.xyzw, r2.xyzw, v4.wwww, r1.xyzw
   9: mov r2.xyz, v0.xyzx
  10: mov r2.w, l(1.000000)
  11: dp4 r3.x, r2.xyzw, r1.xyzw
  12: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.y, l(16), g_InstanceWorldTbl.xyzw
  13: mul r4.xyzw, r4.xyzw, v4.yyyy
  14: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, r0.x, l(16), g_InstanceWorldTbl.xyzw
  15: mad r4.xyzw, r5.xyzw, v4.xxxx, r4.xyzw
  16: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, r0.z, l(16), g_InstanceWorldTbl.xyzw
  17: mad r4.xyzw, r5.xyzw, v4.zzzz, r4.xyzw
  18: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, r0.w, l(16), g_InstanceWorldTbl.xyzw
  19: mad r4.xyzw, r5.xyzw, v4.wwww, r4.xyzw
  20: dp4 r3.y, r2.xyzw, r4.xyzw
  21: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, r0.y, l(32), g_InstanceWorldTbl.xyzw
  22: mul r5.xyzw, r5.xyzw, v4.yyyy
  23: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r6.xyzw, r0.x, l(32), g_InstanceWorldTbl.xyzw
  24: mad r5.xyzw, r6.xyzw, v4.xxxx, r5.xyzw
  25: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r6.xyzw, r0.z, l(32), g_InstanceWorldTbl.xyzw
  26: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, r0.w, l(32), g_InstanceWorldTbl.xyzw
  27: mad r5.xyzw, r6.xyzw, v4.zzzz, r5.xyzw
  28: mad r0.xyzw, r0.xyzw, v4.wwww, r5.xyzw
  29: dp4 r3.z, r2.xyzw, r0.xyzw
  30: mov r3.w, l(1.000000)
  31: dp4 r5.x, r3.xyzw, g_View[0].xyzw
  32: dp4 r5.y, r3.xyzw, g_View[1].xyzw
  33: dp4 r5.z, r3.xyzw, g_View[2].xyzw
  34: dp4 r5.w, r3.xyzw, g_View[3].xyzw
  35: mov o1.xyzw, r3.xyzw
  36: dp4 r3.x, r5.xyzw, g_Proj[0].xyzw
  37: dp4 r3.y, r5.xyzw, g_Proj[1].xyzw
  38: dp4 r3.z, r5.xyzw, g_Proj[2].xyzw
  39: dp4 r3.w, r5.xyzw, g_Proj[3].xyzw
  40: mov o0.xyzw, r3.xyzw
  41: mov o5.xyzw, r3.xyzw
  42: mul r3.xyz, r4.xyzx, g_View[3].yyyy
  43: mad r3.xyz, r1.xyzx, g_View[3].xxxx, r3.xyzx
  44: mad r3.xyz, r0.xyzx, g_View[3].zzzz, r3.xyzx
  45: dp3 r5.w, v5.xyzx, r3.xyzx
  46: dp3 r3.w, v1.xyzx, r3.xyzx
  47: mul r6.xyz, r4.xyzx, g_View[0].yyyy
  48: mad r6.xyz, r1.xyzx, g_View[0].xxxx, r6.xyzx
  49: mad r6.xyz, r0.xyzx, g_View[0].zzzz, r6.xyzx
  50: dp3 r5.x, v5.xyzx, r6.xyzx
  51: dp3 r3.x, v1.xyzx, r6.xyzx
  52: mul r6.xyz, r4.xyzx, g_View[1].yyyy
  53: mul r4.xyz, r4.xyzx, g_View[2].yyyy
  54: mad r4.xyz, r1.xyzx, g_View[2].xxxx, r4.xyzx
  55: mad r1.xyz, r1.xyzx, g_View[1].xxxx, r6.xyzx
  56: mad r1.xyz, r0.xyzx, g_View[1].zzzz, r1.xyzx
  57: mad r0.xyz, r0.xyzx, g_View[2].zzzz, r4.xyzx
  58: dp3 r5.y, v5.xyzx, r1.xyzx
  59: dp3 r3.y, v1.xyzx, r1.xyzx
  60: dp3 r5.z, v5.xyzx, r0.xyzx
  61: dp3 r3.z, v1.xyzx, r0.xyzx
  62: dp4 r0.x, r5.xyzw, r5.xyzw
  63: rsq r0.x, r0.x
  64: mul r0.xyz, r0.xxxx, r5.xyzx
  65: mov o2.xyz, r0.xyzx
  66: mov o2.w, v2.x
  67: dp4 r0.w, r3.xyzw, r3.xyzw
  68: rsq r0.w, r0.w
  69: mul r1.xyz, r0.wwww, r3.xyzx
  70: mov o3.xyz, r1.xyzx
  71: mov o3.w, v2.y
  72: mul r3.xyz, r0.yzxy, r1.zxyz
  73: mad r0.xyz, r1.yzxy, r0.zxyz, -r3.xyzx
  74: mul o4.xyz, r0.xyzx, v1.wwww
  75: mov o4.w, l(0)
  76: iadd r0.xyzw, v3.xyzw, v6.yyyy
  77: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, r0.y, l(0), g_InstanceWorldTbl.xyzw
  78: mul r1.xyzw, r1.xyzw, v4.yyyy
  79: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, r0.x, l(0), g_InstanceWorldTbl.xyzw
  80: mad r1.xyzw, r3.xyzw, v4.xxxx, r1.xyzw
  81: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, r0.z, l(0), g_InstanceWorldTbl.xyzw
  82: mad r1.xyzw, r3.xyzw, v4.zzzz, r1.xyzw
  83: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, r0.w, l(0), g_InstanceWorldTbl.xyzw
  84: mad r1.xyzw, r3.xyzw, v4.wwww, r1.xyzw
  85: dp4 r1.x, r2.xyzw, r1.xyzw
  86: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, r0.y, l(16), g_InstanceWorldTbl.xyzw
  87: mul r3.xyzw, r3.xyzw, v4.yyyy
  88: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.x, l(16), g_InstanceWorldTbl.xyzw
  89: mad r3.xyzw, r4.xyzw, v4.xxxx, r3.xyzw
  90: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.z, l(16), g_InstanceWorldTbl.xyzw
  91: mad r3.xyzw, r4.xyzw, v4.zzzz, r3.xyzw
  92: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.w, l(16), g_InstanceWorldTbl.xyzw
  93: mad r3.xyzw, r4.xyzw, v4.wwww, r3.xyzw
  94: dp4 r1.y, r2.xyzw, r3.xyzw
  95: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, r0.y, l(32), g_InstanceWorldTbl.xyzw
  96: mul r3.xyzw, r3.xyzw, v4.yyyy
  97: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.x, l(32), g_InstanceWorldTbl.xyzw
  98: mad r3.xyzw, r4.xyzw, v4.xxxx, r3.xyzw
  99: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.z, l(32), g_InstanceWorldTbl.xyzw
 100: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, r0.w, l(32), g_InstanceWorldTbl.xyzw
 101: mad r3.xyzw, r4.xyzw, v4.zzzz, r3.xyzw
 102: mad r0.xyzw, r0.xyzw, v4.wwww, r3.xyzw
 103: dp4 r1.z, r2.xyzw, r0.xyzw
 104: mov r1.w, l(1.000000)
 105: dp4 r0.x, r1.xyzw, g_PrevView[0].xyzw
 106: dp4 r0.y, r1.xyzw, g_PrevView[1].xyzw
 107: dp4 r0.z, r1.xyzw, g_PrevView[2].xyzw
 108: dp4 r0.w, r1.xyzw, g_PrevView[3].xyzw
 109: dp4 o6.x, r0.xyzw, g_PrevProj[0].xyzw
 110: dp4 o6.y, r0.xyzw, g_PrevProj[1].xyzw
 111: dp4 o6.z, r0.xyzw, g_PrevProj[2].xyzw
 112: dp4 o6.w, r0.xyzw, g_PrevProj[3].xyzw
 113: mov o7.x, v6.z
 114: ret
