Shader hash 8a358041-e307ddbd-1bc03f84-85b26dab

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[32] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb6[16] (CutCharacterMaterialDataBuf), immediateIndexed
      dcl_constantbuffer cb5[1] (ParamBuffer), immediateIndexed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_AnimeMask (t0)
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
      dcl_temps 10
   0: iadd r0.xyzw, v3.xyzw, v6.xxxx
   1: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, r0.y, l(16), g_InstanceWorldTbl.xyzw
   2: mul r1.xyzw, r1.xyzw, v4.yyyy
   3: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.x, l(16), g_InstanceWorldTbl.xyzw
   4: mad r1.xyzw, r2.xyzw, v4.xxxx, r1.xyzw
   5: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.z, l(16), g_InstanceWorldTbl.xyzw
   6: mad r1.xyzw, r2.xyzw, v4.zzzz, r1.xyzw
   7: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.w, l(16), g_InstanceWorldTbl.xyzw
   8: mad r1.xyzw, r2.xyzw, v4.wwww, r1.xyzw
   9: mul r2.xyz, r1.xyzx, g_View[0].yyyy
  10: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, r0.y, l(0), g_InstanceWorldTbl.xyzw
  11: mul r3.xyzw, r3.xyzw, v4.yyyy
  12: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.x, l(0), g_InstanceWorldTbl.xyzw
  13: mad r3.xyzw, r4.xyzw, v4.xxxx, r3.xyzw
  14: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.z, l(0), g_InstanceWorldTbl.xyzw
  15: mad r3.xyzw, r4.xyzw, v4.zzzz, r3.xyzw
  16: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.w, l(0), g_InstanceWorldTbl.xyzw
  17: mad r3.xyzw, r4.xyzw, v4.wwww, r3.xyzw
  18: mad r2.xyz, r3.xyzx, g_View[0].xxxx, r2.xyzx
  19: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.y, l(32), g_InstanceWorldTbl.xyzw
  20: mul r4.xyzw, r4.xyzw, v4.yyyy
  21: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, r0.x, l(32), g_InstanceWorldTbl.xyzw
  22: mad r4.xyzw, r5.xyzw, v4.xxxx, r4.xyzw
  23: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, r0.z, l(32), g_InstanceWorldTbl.xyzw
  24: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, r0.w, l(32), g_InstanceWorldTbl.xyzw
  25: mad r4.xyzw, r5.xyzw, v4.zzzz, r4.xyzw
  26: mad r0.xyzw, r0.xyzw, v4.wwww, r4.xyzw
  27: mad r2.xyz, r0.xyzx, g_View[0].zzzz, r2.xyzx
  28: dp3 r4.x, v5.xyzx, r2.xyzx
  29: dp3 r2.x, v1.xyzx, r2.xyzx
  30: mul r5.xyz, r1.xyzx, g_View[1].yyyy
  31: mad r5.xyz, r3.xyzx, g_View[1].xxxx, r5.xyzx
  32: mad r5.xyz, r0.xyzx, g_View[1].zzzz, r5.xyzx
  33: dp3 r4.y, v5.xyzx, r5.xyzx
  34: dp3 r2.y, v1.xyzx, r5.xyzx
  35: mul r5.xyz, r1.xyzx, g_View[2].yyyy
  36: mad r5.xyz, r3.xyzx, g_View[2].xxxx, r5.xyzx
  37: mad r5.xyz, r0.xyzx, g_View[2].zzzz, r5.xyzx
  38: dp3 r4.z, v5.xyzx, r5.xyzx
  39: dp3 r2.z, v1.xyzx, r5.xyzx
  40: dp3 r5.x, r4.xyzx, r4.xyzx
  41: rsq r5.x, r5.x
  42: mul r5.xyz, r4.xyzx, r5.xxxx
  43: mul r5.w, r5.z, l(3.000000)
  44: mov r6.xyz, v0.xyzx
  45: mov r6.w, l(1.000000)
  46: dp4 r7.x, r6.xyzw, r3.xyzw
  47: dp4 r7.y, r6.xyzw, r1.xyzw
  48: mul r1.xyz, r1.xyzx, g_View[3].yyyy
  49: mad r1.xyz, r3.xyzx, g_View[3].xxxx, r1.xyzx
  50: mad r1.xyz, r0.xyzx, g_View[3].zzzz, r1.xyzx
  51: dp4 r7.z, r6.xyzw, r0.xyzw
  52: mov r7.w, l(1.000000)
  53: dp4 r0.w, r7.xyzw, g_View[3].xyzw
  54: dp4 r0.x, r7.xyzw, g_View[0].xyzw
  55: dp4 r0.y, r7.xyzw, g_View[1].xyzw
  56: dp4 r0.z, r7.xyzw, g_View[2].xyzw
  57: dp4 r1.w, r0.xyzw, g_Proj[2].xyzw
  58: div_sat r1.w, r1.w, charaMaterial_.interDistance_.x
  59: add r3.x, -charaMaterial_.outlineNearThickness_.x, charaMaterial_.outlineFarThickness_.x
  60: mad r1.w, r1.w, r3.x, charaMaterial_.outlineNearThickness_.x
  61: sample_l(texture2d)(float,float,float,float) r3.y, v2.xyxx, g_AnimeMask.yxzw, ModelSampler, l(0)
  62: mul r1.w, r1.w, r3.y
  63: dp2 r1.w, r1.wwww, g_OutLineThickness.xxxx
  64: mul r7.xyz, r1.wwww, r5.xywx
  65: mov r8.x, g_ViewInverseMatrix[0].w
  66: mov r8.y, g_ViewInverseMatrix[1].w
  67: mov r8.z, g_ViewInverseMatrix[2].w
  68: mov r8.w, l(1.000000)
  69: dp4 r9.x, r8.xyzw, g_View[0].xyzw
  70: dp4 r9.y, r8.xyzw, g_View[1].xyzw
  71: dp4 r9.z, r8.xyzw, g_View[2].xyzw
  72: add r8.xyz, -r0.xyzx, r9.xyzx
  73: dp3 r1.w, r8.xyzx, r8.xyzx
  74: rsq r1.w, r1.w
  75: mul r8.xyz, r1.wwww, r8.xyzx
  76: mad r8.xyz, -r8.xyzx, l(0.030000, 0.030000, 0.030000, 0.000000), r7.xyzx
  77: ine r1.w, g_EnableCamvecOffset.x, l(0)
  78: lt r3.z, l(0.500000), charaMaterial_.useOutlineOffset_.x
  79: or r1.w, r1.w, r3.z
  80: movc r7.xyz, r1.wwww, r8.xyzx, r7.xyzx
  81: add r0.xyz, r0.xyzx, r7.xyzx
  82: dp4 r7.x, r0.xyzw, g_ViewInverseMatrix[0].xyzw
  83: dp4 r7.y, r0.xyzw, g_ViewInverseMatrix[1].xyzw
  84: dp4 r7.z, r0.xyzw, g_ViewInverseMatrix[2].xyzw
  85: dp4 r7.w, r0.xyzw, g_ViewInverseMatrix[3].xyzw
  86: dp4 r0.x, r7.xyzw, g_View[0].xyzw
  87: dp4 r0.y, r7.xyzw, g_View[1].xyzw
  88: dp4 r0.z, r7.xyzw, g_View[2].xyzw
  89: dp4 r0.w, r7.xyzw, g_View[3].xyzw
  90: mov o1.xyzw, r7.xyzw
  91: dp4 r7.x, r0.xyzw, g_Proj[0].xyzw
  92: dp4 r7.y, r0.xyzw, g_Proj[1].xyzw
  93: dp4 r7.z, r0.xyzw, g_Proj[2].xyzw
  94: dp4 r7.w, r0.xyzw, g_Proj[3].xyzw
  95: mov o0.xyzw, r7.xyzw
  96: mov o5.xyzw, r7.xyzw
  97: dp3 r4.w, v5.xyzx, r1.xyzx
  98: dp3 r2.w, v1.xyzx, r1.xyzx
  99: dp4 r0.x, r2.xyzw, r2.xyzw
 100: rsq r0.x, r0.x
 101: mul r0.xyz, r0.xxxx, r2.xyzx
 102: dp4 r0.w, r4.xyzw, r4.xyzw
 103: rsq r0.w, r0.w
 104: mul r1.xyz, r0.wwww, r4.xyzx
 105: mov o2.xyz, r1.xyzx
 106: mov o2.w, v2.x
 107: mov o3.xyz, r0.xyzx
 108: mov o3.w, v2.y
 109: mul r2.xyz, r0.zxyz, r1.yzxy
 110: mad r0.xyz, r0.yzxy, r1.zxyz, -r2.xyzx
 111: mul o4.xyz, r0.xyzx, v1.wwww
 112: mov o4.w, l(0)
 113: iadd r0.xyzw, v3.xyzw, v6.yyyy
 114: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, r0.y, l(16), g_InstanceWorldTbl.xyzw
 115: mul r2.xyzw, r2.xyzw, v4.yyyy
 116: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.x, l(16), g_InstanceWorldTbl.xyzw
 117: mad r2.xyzw, r4.xyzw, v4.xxxx, r2.xyzw
 118: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.z, l(16), g_InstanceWorldTbl.xyzw
 119: mad r2.xyzw, r4.xyzw, v4.zzzz, r2.xyzw
 120: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, r0.w, l(16), g_InstanceWorldTbl.xyzw
 121: mad r2.xyzw, r4.xyzw, v4.wwww, r2.xyzw
 122: mul r4.xyzw, r2.xyzw, g_PrevView[3].yyyy
 123: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r7.xyzw, r0.y, l(0), g_InstanceWorldTbl.xyzw
 124: mul r7.xyzw, r7.xyzw, v4.yyyy
 125: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r8.xyzw, r0.x, l(0), g_InstanceWorldTbl.xyzw
 126: mad r7.xyzw, r8.xyzw, v4.xxxx, r7.xyzw
 127: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r8.xyzw, r0.z, l(0), g_InstanceWorldTbl.xyzw
 128: mad r7.xyzw, r8.xyzw, v4.zzzz, r7.xyzw
 129: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r8.xyzw, r0.w, l(0), g_InstanceWorldTbl.xyzw
 130: mad r7.xyzw, r8.xyzw, v4.wwww, r7.xyzw
 131: mad r4.xyzw, r7.xyzw, g_PrevView[3].xxxx, r4.xyzw
 132: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r8.xyzw, r0.y, l(32), g_InstanceWorldTbl.xyzw
 133: mul r8.xyzw, r8.xyzw, v4.yyyy
 134: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r9.xyzw, r0.x, l(32), g_InstanceWorldTbl.xyzw
 135: mad r8.xyzw, r9.xyzw, v4.xxxx, r8.xyzw
 136: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r9.xyzw, r0.z, l(32), g_InstanceWorldTbl.xyzw
 137: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, r0.w, l(32), g_InstanceWorldTbl.xyzw
 138: mad r8.xyzw, r9.xyzw, v4.zzzz, r8.xyzw
 139: mad r0.xyzw, r0.xyzw, v4.wwww, r8.xyzw
 140: mad r4.xyzw, r0.xyzw, g_PrevView[3].zzzz, r4.xyzw
 141: mad r4.xyzw, g_PrevView[3].wwww, l(0.000000, 0.000000, 0.000000, 1.000000), r4.xyzw
 142: dp4 r4.w, r6.xyzw, r4.xyzw
 143: mul r8.xyzw, r2.xyzw, g_PrevView[0].yyyy
 144: mad r8.xyzw, r7.xyzw, g_PrevView[0].xxxx, r8.xyzw
 145: mad r8.xyzw, r0.xyzw, g_PrevView[0].zzzz, r8.xyzw
 146: mad r8.xyzw, g_PrevView[0].wwww, l(0.000000, 0.000000, 0.000000, 1.000000), r8.xyzw
 147: dp4 r4.x, r6.xyzw, r8.xyzw
 148: mul r8.xyzw, r2.xyzw, g_PrevView[1].yyyy
 149: mul r2.xyzw, r2.xyzw, g_PrevView[2].yyyy
 150: mad r2.xyzw, r7.xyzw, g_PrevView[2].xxxx, r2.xyzw
 151: mad r7.xyzw, r7.xyzw, g_PrevView[1].xxxx, r8.xyzw
 152: mad r7.xyzw, r0.xyzw, g_PrevView[1].zzzz, r7.xyzw
 153: mad r0.xyzw, r0.xyzw, g_PrevView[2].zzzz, r2.xyzw
 154: mad r0.xyzw, g_PrevView[2].wwww, l(0.000000, 0.000000, 0.000000, 1.000000), r0.xyzw
 155: dp4 r4.z, r6.xyzw, r0.xyzw
 156: mad r0.xyzw, g_PrevView[1].wwww, l(0.000000, 0.000000, 0.000000, 1.000000), r7.xyzw
 157: dp4 r4.y, r6.xyzw, r0.xyzw
 158: dp4 r0.x, r4.xyzw, g_PrevProj[2].xyzw
 159: div_sat r0.x, r0.x, charaMaterial_.interDistance_.x
 160: mad r0.x, r0.x, r3.x, charaMaterial_.outlineNearThickness_.x
 161: mul r0.xyz, r0.xxxx, r5.xywx
 162: mul r0.xyz, r3.yyyy, r0.xyzx
 163: mul r0.xyz, r0.xyzx, g_OutLineThickness.xxxx
 164: add r0.xyz, r0.xyzx, r0.xyzx
 165: mov r2.x, g_PrevViewInverseMatrix[0].w
 166: mov r2.y, g_PrevViewInverseMatrix[1].w
 167: mov r2.z, g_PrevViewInverseMatrix[2].w
 168: mov r2.w, l(1.000000)
 169: dp4 r1.x, r2.xyzw, g_PrevView[0].xyzw
 170: dp4 r1.y, r2.xyzw, g_PrevView[1].xyzw
 171: dp4 r1.z, r2.xyzw, g_PrevView[2].xyzw
 172: add r1.xyz, -r4.xyzx, r1.xyzx
 173: dp3 r0.w, r1.xyzx, r1.xyzx
 174: rsq r0.w, r0.w
 175: mul r1.xyz, r0.wwww, r1.xyzx
 176: mad r1.xyz, -r1.xyzx, l(0.030000, 0.030000, 0.030000, 0.000000), r0.xyzx
 177: movc r0.xyz, r1.wwww, r1.xyzx, r0.xyzx
 178: add r4.xyz, r0.xyzx, r4.xyzx
 179: dp4 r0.x, r4.xyzw, g_PrevViewInverseMatrix[0].xyzw
 180: dp4 r0.y, r4.xyzw, g_PrevViewInverseMatrix[1].xyzw
 181: dp4 r0.z, r4.xyzw, g_PrevViewInverseMatrix[2].xyzw
 182: dp4 r0.w, r4.xyzw, g_PrevViewInverseMatrix[3].xyzw
 183: dp4 r1.x, r0.xyzw, g_PrevView[0].xyzw
 184: dp4 r1.y, r0.xyzw, g_PrevView[1].xyzw
 185: dp4 r1.z, r0.xyzw, g_PrevView[2].xyzw
 186: mov r1.w, l(1.000000)
 187: dp4 o6.x, r1.xyzw, g_PrevProj[0].xyzw
 188: dp4 o6.y, r1.xyzw, g_PrevProj[1].xyzw
 189: dp4 o6.z, r1.xyzw, g_PrevProj[2].xyzw
 190: dp4 o6.w, r1.xyzw, g_PrevProj[3].xyzw
 191: mov o7.x, v6.z
 192: ret
