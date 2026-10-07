Shader hash c02f523a-c99a9364-b87c7307-b9224480

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[6] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb12[1] (TileIndexBuffer), immediateIndexed
      dcl_constantbuffer cb10[1] (TargetSize), immediateIndexed
      dcl_resource_structured gTileInfo (t9), 64
      dcl_resource_structured _data (t11), 224
      dcl_uav_structured g_rwCubeBlendNum (u3), 4
      dcl_uav_structured g_rwCubeIndex (u4), 4
      dcl_input vThreadIDInGroupFlattened
      dcl_input vThreadGroupID.xy
      dcl_temps 7
      dcl_tgsm_raw g0, 4
      dcl_tgsm_structured g1, 4, 150
      dcl_thread_group 32, 1, 1
   0: ftou r0.x, _targetSize.z
   1: imad r0.x, vThreadGroupID.y, r0.x, vThreadGroupID.x
   2: if_z vThreadIDInGroupFlattened.x
   3:   store_raw g0.x, l(0), l(0)
   4: endif
   5: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r1.xyzw, r0.x, l(0), gTileInfo.xyzw
   6: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r2.xyzw, r0.x, l(16), gTileInfo.xyzw
   7: add r0.y, -r1.w, r2.w
   8: add r0.y, r0.y, l(0.000100)
   9: div r0.y, l(32.000000), r0.y
  10: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r0.z, r0.x, l(32), gTileInfo.xxxx
  11: mul r3.xy, _targetSize.xyxx, l(0.015625, 0.016667, 0.000000, 0.000000)
  12: utof r3.zw, vThreadGroupID.xxxy
  13: mad r3.zw, _targetSize.xxxy, l(0.000000, 0.000000, 0.015625, 0.016667), -r3.zzzw
  14: mul r4.y, r3.x, g_Proj[0].x
  15: mul r4.x, r3.y, -g_Proj[1].y
  16: mov r4.zw, -r3.zzzw
  17: add r3.xyzw, -r4.yzxw, l(0.000000, -1.000000, 0.000000, -1.000000)
  18: dp2 r0.w, r3.xyxx, r3.xyxx
  19: sqrt r0.w, r0.w
  20: rcp r0.w, r0.w
  21: mul r3.xy, r0.wwww, r3.xyxx
  22: dp2 r0.w, r4.yzyy, r4.yzyy
  23: sqrt r0.w, r0.w
  24: rcp r0.w, r0.w
  25: mul r4.yz, r0.wwww, r4.yyzy
  26: dp2 r0.w, r3.zwzz, r3.zwzz
  27: sqrt r0.w, r0.w
  28: rcp r0.w, r0.w
  29: mul r3.zw, r0.wwww, r3.zzzw
  30: dp2 r0.w, r4.xwxx, r4.xwxx
  31: sqrt r0.w, r0.w
  32: rcp r0.w, r0.w
  33: mul r4.xw, r0.wwww, r4.xxxw
  34: sync_g_t
  35: iadd r0.w, vThreadIDInGroupFlattened.x, g_AmbientAreaLightIndex.x
  36: mov r2.w, r0.w
  37: loop
  38:   ult r5.xy, r2.wwww, g_AmbientAreaLightIndex.yzyy
  39:   and r5.x, r5.y, r5.x
  40:   ld_raw r5.y, l(0), g0.xxxx
  41:   ult r5.y, r5.y, l(150)
  42:   and r5.x, r5.y, r5.x
  43:   breakc_z r5.x
  44:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r5.xyz, r2.w, l(48), _data.xyzx
  45:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r5.w, r2.w, l(204), _data.xxxx
  46:   add r6.x, -r5.w, -r5.z
  47:   add r6.y, r5.w, -r5.z
  48:   add r6.xy, -r1.wwww, r6.xyxx
  49:   mul r6.xy, r0.yyyy, r6.xyxx
  50:   round_ni r6.xy, r6.xyxx
  51:   min r6.xy, r6.xyxx, l(32.000000, 32.000000, 0.000000, 0.000000)
  52:   max r6.xy, r6.xyxx, l(0, 0, 0, 0)
  53:   ftou r6.xy, r6.xyxx
  54:   iadd r6.y, r6.x, -r6.y
  55:   iadd r6.y, r6.y, l(31)
  56:   ushr r6.y, l(-1), r6.y
  57:   ishl r6.x, r6.y, r6.x
  58:   and r6.x, r0.z, r6.x
  59:   if_z r6.x
  60:     iadd r6.x, r2.w, l(32)
  61:     mov r2.w, r6.x
  62:     continue
  63:   endif
  64:   add r6.xyz, r1.xyzx, -r5.xyzx
  65:   add r6.xyz, -r2.xyzx, abs(r6.xyzx)
  66:   max r6.xyz, r6.xyzx, l(0, 0, 0, 0)
  67:   dp3 r6.x, r6.xyzx, r6.xyzx
  68:   mul r6.y, r5.w, r5.w
  69:   lt r6.x, r6.y, r6.x
  70:   if_nz r6.x
  71:     iadd r6.x, r2.w, l(32)
  72:     mov r2.w, r6.x
  73:     continue
  74:   endif
  75:   dp2 r6.x, r3.xyxx, r5.xzxx
  76:   ge r6.x, r6.x, -r5.w
  77:   dp2 r5.x, r4.yzyy, r5.xzxx
  78:   ge r5.x, r5.x, -r5.w
  79:   and r5.x, r5.x, r6.x
  80:   dp2 r6.x, r3.zwzz, r5.yzyy
  81:   ge r6.x, r6.x, -r5.w
  82:   and r5.x, r5.x, r6.x
  83:   dp2 r5.y, r4.xwxx, r5.yzyy
  84:   ge r5.y, r5.y, -r5.w
  85:   and r5.x, r5.y, r5.x
  86:   if_nz r5.x
  87:     imm_atomic_iadd r5.x, g0, l(0), l(1)
  88:     ult r5.y, r5.x, l(150)
  89:     if_nz r5.y
  90:       store_structured g1.x, r5.x, l(0), r2.w
  91:     endif
  92:   endif
  93:   iadd r2.w, r2.w, l(32)
  94: endloop
  95: sync_g_t
  96: if_z vThreadIDInGroupFlattened.x
  97:   ld_raw r0.y, l(0), g0.xxxx
  98:   ult r0.y, l(150), r0.y
  99:   if_nz r0.y
 100:     store_raw g0.x, l(0), l(150)
 101:   endif
 102:   ld_raw r0.y, l(0), g0.xxxx
 103:   mov r0.z, l(1)
 104:   loop
 105:     uge r0.w, r0.z, r0.y
 106:     breakc_nz r0.w
 107:     mov r0.w, r0.z
 108:     loop
 109:       uge r1.x, r0.w, l(1)
 110:       iadd r1.y, r0.w, l(-1)
 111:       ld_structured r1.z, r1.y, l(0), g1.xxxx
 112:       ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r1.w, r1.z, l(60), _data.xxxx
 113:       ld_structured r2.x, r0.w, l(0), g1.xxxx
 114:       ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r2.y, r2.x, l(60), _data.xxxx
 115:       lt r1.w, r2.y, r1.w
 116:       and r1.x, r1.w, r1.x
 117:       breakc_z r1.x
 118:       store_structured g1.x, r1.y, l(0), r2.x
 119:       store_structured g1.x, r0.w, l(0), r1.z
 120:       mov r0.w, r1.y
 121:     endloop
 122:     iadd r0.z, r0.z, l(1)
 123:   endloop
 124:   ld_raw r0.y, l(0), g0.xxxx
 125:   ult r0.z, r0.y, l(150)
 126:   if_nz r0.z
 127:     store_structured g1.x, r0.y, l(0), l(151)
 128:   endif
 129:   ld_raw r0.y, l(0), g0.xxxx
 130:   store_structured g_rwCubeBlendNum.x, r0.x, l(0), r0.y
 131:   mov r0.z, l(0)
 132:   loop
 133:     uge r0.w, r0.z, r0.y
 134:     breakc_nz r0.w
 135:     imad r0.w, r0.x, l(150), r0.z
 136:     ld_structured r1.x, r0.z, l(0), g1.xxxx
 137:     store_structured g_rwCubeIndex.x, r0.w, l(0), r1.x
 138:     iadd r0.z, r0.z, l(1)
 139:   endloop
 140: endif
 141: ret
