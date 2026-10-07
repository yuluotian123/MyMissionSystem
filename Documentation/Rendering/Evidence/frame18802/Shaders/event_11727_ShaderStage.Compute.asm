Shader hash 47d39f05-184f2a3b-350a7abd-9e84d199

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[6] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb10[1] (TargetSize), immediateIndexed
      dcl_constantbuffer cb11[1400] (ParamBuffer), dynamicIndexed
      dcl_resource_structured gTileInfo (t9), 64
      dcl_uav_structured g_rwCubeBlendNum (u3), 4
      dcl_uav_structured g_rwCubeIndex (u4), 4
      dcl_input vThreadIDInGroupFlattened
      dcl_input vThreadGroupID.xy
      dcl_temps 6
      dcl_tgsm_raw g0, 4
      dcl_tgsm_structured g1, 4, 50
      dcl_thread_group 32, 1, 1
   0: ftou r0.x, _targetSize.z
   1: imad r0.x, vThreadGroupID.y, r0.x, vThreadGroupID.x
   2: bufinfo_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r0.y, gTileInfo.yxzw
   3: ult r0.y, r0.x, r0.y
   4: if_z vThreadIDInGroupFlattened.x
   5:   store_raw g0.x, l(0), l(0)
   6: endif
   7: if_nz r0.y
   8:   ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r1.xyzw, r0.x, l(0), gTileInfo.xyzw
   9:   ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r2.xyzw, r0.x, l(16), gTileInfo.xyzw
  10:   add r0.y, -r1.w, r2.w
  11:   add r0.y, r0.y, l(0.000100)
  12:   div r0.y, l(32.000000), r0.y
  13:   ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r0.z, r0.x, l(32), gTileInfo.xxxx
  14:   mul r3.xy, _targetSize.xyxx, l(0.015625, 0.016667, 0.000000, 0.000000)
  15:   utof r3.zw, vThreadGroupID.xxxy
  16:   mad r3.zw, _targetSize.xxxy, l(0.000000, 0.000000, 0.015625, 0.016667), -r3.zzzw
  17:   mul r4.y, r3.x, g_Proj[0].x
  18:   mul r4.x, r3.y, -g_Proj[1].y
  19:   mov r4.zw, -r3.zzzw
  20:   add r3.xyzw, -r4.yzxw, l(0.000000, -1.000000, 0.000000, -1.000000)
  21:   dp2 r0.w, r3.xyxx, r3.xyxx
  22:   sqrt r0.w, r0.w
  23:   rcp r0.w, r0.w
  24:   mul r3.xy, r0.wwww, r3.xyxx
  25:   dp2 r0.w, r4.yzyy, r4.yzyy
  26:   sqrt r0.w, r0.w
  27:   rcp r0.w, r0.w
  28:   mul r4.yz, r0.wwww, r4.yyzy
  29:   dp2 r0.w, r3.zwzz, r3.zwzz
  30:   sqrt r0.w, r0.w
  31:   rcp r0.w, r0.w
  32:   mul r3.zw, r0.wwww, r3.zzzw
  33:   dp2 r0.w, r4.xwxx, r4.xwxx
  34:   sqrt r0.w, r0.w
  35:   rcp r0.w, r0.w
  36:   mul r4.xw, r0.wwww, r4.xxxw
  37:   sync_g_t
  38:   ftou r0.w, _targetSize.w
  39:   mov r2.w, vThreadIDInGroupFlattened.x
  40:   loop
  41:     ult r5.x, r2.w, r0.w
  42:     ld_raw r5.y, l(0), g0.xxxx
  43:     ult r5.y, r5.y, l(50)
  44:     and r5.x, r5.y, r5.x
  45:     breakc_z r5.x
  46:     add r5.x, -cb11[r2.w + 840].z, -cb11[r2.w + 980].z
  47:     add r5.y, -cb11[r2.w + 840].z, cb11[r2.w + 980].z
  48:     add r5.xy, -r1.wwww, r5.xyxx
  49:     mul r5.xy, r0.yyyy, r5.xyxx
  50:     round_ni r5.xy, r5.xyxx
  51:     min r5.xy, r5.xyxx, l(32.000000, 32.000000, 0.000000, 0.000000)
  52:     max r5.xy, r5.xyxx, l(0, 0, 0, 0)
  53:     ftou r5.xy, r5.xyxx
  54:     iadd r5.y, r5.x, -r5.y
  55:     iadd r5.y, r5.y, l(31)
  56:     ushr r5.y, l(-1), r5.y
  57:     ishl r5.x, r5.y, r5.x
  58:     and r5.x, r0.z, r5.x
  59:     if_z r5.x
  60:       iadd r5.x, r2.w, l(32)
  61:       mov r2.w, r5.x
  62:       continue
  63:     endif
  64:     add r5.xyz, r1.xyzx, -cb11[r2.w + 840].xyzx
  65:     add r5.xyz, -r2.xyzx, abs(r5.xyzx)
  66:     max r5.xyz, r5.xyzx, l(0, 0, 0, 0)
  67:     dp3 r5.x, r5.xyzx, r5.xyzx
  68:     mul r5.y, cb11[r2.w + 980].z, cb11[r2.w + 980].z
  69:     lt r5.x, r5.y, r5.x
  70:     if_nz r5.x
  71:       iadd r5.x, r2.w, l(32)
  72:       mov r2.w, r5.x
  73:       continue
  74:     endif
  75:     dp2 r5.x, r3.xyxx, cb11[r2.w + 840].xzxx
  76:     dp2 r5.y, r4.yzyy, cb11[r2.w + 840].xzxx
  77:     ge r5.xy, r5.xyxx, -cb11[r2.w + 980].zzzz
  78:     and r5.x, r5.y, r5.x
  79:     dp2 r5.y, r3.zwzz, cb11[r2.w + 840].yzyy
  80:     ge r5.y, r5.y, -cb11[r2.w + 980].z
  81:     and r5.x, r5.y, r5.x
  82:     dp2 r5.y, r4.xwxx, cb11[r2.w + 840].yzyy
  83:     ge r5.y, r5.y, -cb11[r2.w + 980].z
  84:     and r5.x, r5.y, r5.x
  85:     if_nz r5.x
  86:       imm_atomic_iadd r5.x, g0, l(0), l(1)
  87:       ult r5.y, r5.x, l(50)
  88:       if_nz r5.y
  89:         store_structured g1.x, r5.x, l(0), r2.w
  90:       endif
  91:     endif
  92:     iadd r2.w, r2.w, l(32)
  93:   endloop
  94:   sync_g_t
  95:   if_z vThreadIDInGroupFlattened.x
  96:     ld_raw r0.y, l(0), g0.xxxx
  97:     ult r0.y, l(50), r0.y
  98:     if_nz r0.y
  99:       store_raw g0.x, l(0), l(50)
 100:     endif
 101:     ld_raw r0.y, l(0), g0.xxxx
 102:     mov r0.z, l(1)
 103:     loop
 104:       uge r0.w, r0.z, r0.y
 105:       breakc_nz r0.w
 106:       mov r0.w, r0.z
 107:       loop
 108:         uge r1.x, r0.w, l(1)
 109:         iadd r1.y, r0.w, l(-1)
 110:         ld_structured r1.z, r1.y, l(0), g1.xxxx
 111:         ld_structured r1.w, r0.w, l(0), g1.xxxx
 112:         lt r2.x, cb11[r1.w + 840].w, cb11[r1.z + 840].w
 113:         and r1.x, r1.x, r2.x
 114:         breakc_z r1.x
 115:         store_structured g1.x, r1.y, l(0), r1.w
 116:         store_structured g1.x, r0.w, l(0), r1.z
 117:         mov r0.w, r1.y
 118:       endloop
 119:       iadd r0.z, r0.z, l(1)
 120:     endloop
 121:     ld_raw r0.y, l(0), g0.xxxx
 122:     store_structured g_rwCubeBlendNum.x, r0.x, l(0), r0.y
 123:     mov r0.z, l(0)
 124:     loop
 125:       uge r0.w, r0.z, r0.y
 126:       breakc_nz r0.w
 127:       imad r0.w, r0.x, l(50), r0.z
 128:       ld_structured r1.x, r0.z, l(0), g1.xxxx
 129:       store_structured g_rwCubeIndex.x, r0.w, l(0), r1.x
 130:       iadd r0.z, r0.z, l(1)
 131:     endloop
 132:   endif
 133: endif
 134: ret
