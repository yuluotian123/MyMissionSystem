Shader hash 003a3927-3080fc5f-79b0657c-0e62ad01

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[6] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb7[2] (PrecomputeValue_Buffer), immediateIndexed
      dcl_resource_structured g_PointLightCullingArray (t8), 48
      dcl_resource_structured gTileInfo (t9), 64
      dcl_uav_structured gFramebuffer (u0), 4
      dcl_input vThreadGroupID.xy
      dcl_input vThreadIDInGroup.xy
      dcl_temps 17
      dcl_tgsm_raw g0, 4
      dcl_tgsm_structured g1, 4, 2048
      dcl_thread_group 32, 30, 1
   0: ftou r0.x, g_TileScaleAndSize.z
   1: imad r0.x, vThreadGroupID.y, r0.x, vThreadGroupID.x
   2: imad r0.y, vThreadIDInGroup.y, l(32), vThreadIDInGroup.x
   3: bufinfo_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.z, g_PointLightCullingArray.yzxw
   4: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r0.w, r0.x, l(12), gTileInfo.xxxx
   5: if_z r0.y
   6:   store_raw g0.x, l(0), l(0)
   7: endif
   8: sync_g_t
   9: utof r1.xy, vThreadGroupID.xyxx
  10: add r1.xy, -r1.xyxx, g_TileScaleAndSize.xyxx
  11: mul r2.x, g_Proj[0].x, g_TileScaleAndSize.x
  12: mul r3.y, -g_Proj[1].y, g_TileScaleAndSize.y
  13: mov r2.yz, -r1.xxyx
  14: mov r2.w, l(0)
  15: add r1.xyz, -r2.xwyx, l(0.000000, 0.000000, -1.000000, 0.000000)
  16: mov r3.z, r2.z
  17: add r3.xw, -r3.yyyz, l(0.000000, 0.000000, 0.000000, -1.000000)
  18: dp2 r1.w, r1.xzxx, r1.xzxx
  19: sqrt r1.w, r1.w
  20: rcp r1.w, r1.w
  21: mul r4.xyz, r1.wwww, r1.xyzx
  22: dp2 r1.y, r2.xyxx, r2.xyxx
  23: sqrt r1.y, r1.y
  24: rcp r1.y, r1.y
  25: mul r5.xyz, r1.yyyy, r2.xwyx
  26: dp2 r1.z, r3.xwxx, r3.xwxx
  27: sqrt r1.z, r1.z
  28: rcp r1.z, r1.z
  29: mul r6.yz, r1.zzzz, r3.xxwx
  30: dp2 r1.z, r3.yzyy, r3.yzyy
  31: sqrt r1.z, r1.z
  32: rcp r1.z, r1.z
  33: mul r3.yz, r1.zzzz, r3.yyzy
  34: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r7.xyzw, r0.x, l(48), gTileInfo.xyzw
  35: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r2.yzw, r0.x, l(36), gTileInfo.xxyz
  36: div r1.z, r2.w, r7.w
  37: mul r1.z, r2.z, r1.z
  38: ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r8.xy, r0.x, l(28), gTileInfo.xyxx
  39: add r3.w, -r0.w, r8.x
  40: add r3.w, r3.w, l(0.000100)
  41: div r3.w, l(32.000000), r3.w
  42: mov r9.z, l(-1)
  43: mov r10.x, l(-1)
  44: mov r6.w, r0.y
  45: loop
  46:   uge r8.x, r6.w, r0.z
  47:   breakc_nz r8.x
  48:   ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r11.xyzw, r6.w, l(0), g_PointLightCullingArray.xyzw
  49:   dp3 r8.x, r11.xyzx, r11.xyzx
  50:   sqrt r8.z, r8.x
  51:   div r12.xyzw, r11.wxyz, r8.zzzz
  52:   mov_sat r12.x, r12.x
  53:   mad r8.w, -r12.x, r12.x, l(1.000000)
  54:   sqrt r8.w, r8.w
  55:   dp3 r9.w, r12.yzwy, r7.xyzx
  56:   mad r10.w, -r9.w, r9.w, l(1.000000)
  57:   sqrt r10.w, r10.w
  58:   lt r12.y, r8.z, r11.w
  59:   mul r12.x, r2.w, r12.x
  60:   mad r8.w, r7.w, r8.w, -r12.x
  61:   movc r8.w, r12.y, l(-1.000000), r8.w
  62:   mul r12.x, r2.w, r9.w
  63:   mad_sat r12.x, r10.w, r7.w, -r12.x
  64:   eq r12.y, r12.x, l(0)
  65:   mul r10.w, r2.w, r10.w
  66:   mad r10.w, r9.w, r7.w, r10.w
  67:   movc r10.w, r12.y, l(1.000000), r10.w
  68:   mul r12.x, r12.x, r12.x
  69:   mul r8.x, r8.x, r12.x
  70:   mad r8.x, r11.w, r11.w, -r8.x
  71:   sqrt r8.x, r8.x
  72:   lt r8.w, r9.w, r8.w
  73:   mad r9.w, r8.z, r10.w, r8.x
  74:   lt r9.w, r9.w, r2.y
  75:   or r8.w, r8.w, r9.w
  76:   mad r8.x, r8.z, r10.w, -r8.x
  77:   lt r8.x, r2.z, r8.x
  78:   or r8.x, r8.x, r8.w
  79:   if_nz r8.x
  80:     iadd r8.x, r6.w, l(960)
  81:     mov r6.w, r8.x
  82:     continue
  83:   endif
  84:   add r8.x, -r11.w, -r11.z
  85:   add r8.z, r11.w, -r11.z
  86:   add r8.xz, -r0.wwww, r8.xxzx
  87:   mul r8.xz, r3.wwww, r8.xxzx
  88:   round_ni r8.xz, r8.xxzx
  89:   min r8.xz, r8.xxzx, l(32.000000, 0.000000, 32.000000, 0.000000)
  90:   max r8.xz, r8.xxzx, l(0, 0, 0, 0)
  91:   ftou r8.xz, r8.xxzx
  92:   iadd r8.z, r8.x, -r8.z
  93:   iadd r8.z, r8.z, l(31)
  94:   ushr r8.z, l(-1), r8.z
  95:   ishl r8.x, r8.z, r8.x
  96:   and r8.x, r8.x, r8.y
  97:   if_z r8.x
  98:     iadd r8.x, r6.w, l(960)
  99:     mov r6.w, r8.x
 100:     continue
 101:   endif
 102:   ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r12.xyzw, r6.w, l(16), g_PointLightCullingArray.xyzw
 103:   lt r10.z, l(0), r12.w
 104:   lt r8.x, r12.w, l(0)
 105:   dp3 r8.z, -r12.xyzx, -r12.xyzx
 106:   rsq r8.z, r8.z
 107:   mul r13.xyz, r8.zzzz, -r12.xyzx
 108:   mad r14.xyz, r7.xyzx, r2.zzzz, -r11.xyzx
 109:   mad r8.z, -r12.x, r8.z, -r7.x
 110:   lt r8.w, l(0), r8.z
 111:   lt r8.z, r8.z, l(0)
 112:   iadd r8.z, -r8.w, r8.z
 113:   imax r8.z, -r8.z, r8.z
 114:   itof r8.z, r8.z
 115:   add r8.z, -r8.z, l(1.000000)
 116:   mad r13.w, r8.z, l(0.000000), r13.x
 117:   mul r15.xyz, r7.zxyz, r13.wyzw
 118:   mad r15.xyz, r13.zwyz, r7.xyzx, -r15.xyzx
 119:   mul r16.xyz, r7.zxyz, r15.xyzx
 120:   mad r15.xyz, r7.yzxy, r15.yzxy, -r16.xyzx
 121:   dp3 r8.z, r15.xyzx, r15.xyzx
 122:   rsq r8.z, r8.z
 123:   mul r15.xyz, r8.zzzz, r15.xyzx
 124:   mad r14.xyz, r15.xyzx, r1.zzzz, r14.xyzx
 125:   dp3 r8.z, r13.wyzw, -r11.xyzx
 126:   dp3 r8.w, r13.wyzw, r14.xyzx
 127:   ge r8.zw, r8.zzzw, l(0, 0, 0, 0)
 128:   or r9.x, r8.w, r8.z
 129:   mov r9.y, -r12.w
 130:   mov r10.y, r12.w
 131:   movc r8.xzw, r8.xxxx, r9.xxyz, r10.xxyz
 132:   if_nz r8.w
 133:     ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r13.xyzw, r6.w, l(32), g_PointLightCullingArray.xyzw
 134:     mad r9.xyw, r12.xyxz, r13.wwww, r13.xyxz
 135:     mad r8.w, r1.x, r1.w, -r12.x
 136:     lt r10.y, l(0), r8.w
 137:     lt r8.w, r8.w, l(0)
 138:     iadd r8.w, -r10.y, r8.w
 139:     imax r8.w, -r8.w, r8.w
 140:     itof r8.w, r8.w
 141:     add r8.w, -r8.w, l(1.000000)
 142:     mad r4.w, r8.w, l(0.000000), r4.x
 143:     mul r10.yzw, r4.wwyz, r12.zzxy
 144:     mad r10.yzw, r4.zzwy, r12.xxyz, -r10.yyzw
 145:     mul r14.xyz, r10.yzwy, r12.zxyz
 146:     mad r10.yzw, r12.yyzx, r10.zzwy, -r14.xxyz
 147:     dp3 r8.w, r10.yzwy, r10.yzwy
 148:     rsq r8.w, r8.w
 149:     mul r10.yz, r8.wwww, r10.yywy
 150:     mad r10.yz, r10.yyzy, r8.zzzz, r9.xxwx
 151:     dp2 r8.w, r4.wzww, r13.xzxx
 152:     ge r8.w, r8.w, l(0)
 153:     dp2 r4.w, r4.wzww, r10.yzyy
 154:     ge r4.w, r4.w, l(0)
 155:     or r4.w, r4.w, r8.w
 156:     and r4.w, r4.w, r8.x
 157:     mad r8.w, r2.x, r1.y, -r12.x
 158:     lt r10.y, l(0), r8.w
 159:     lt r8.w, r8.w, l(0)
 160:     iadd r8.w, -r10.y, r8.w
 161:     imax r8.w, -r8.w, r8.w
 162:     itof r8.w, r8.w
 163:     add r8.w, -r8.w, l(1.000000)
 164:     mad r5.w, r8.w, l(0.000000), r5.x
 165:     mul r10.yzw, r5.wwyz, r12.zzxy
 166:     mad r10.yzw, r5.zzwy, r12.xxyz, -r10.yyzw
 167:     mul r14.xyz, r10.yzwy, r12.zxyz
 168:     mad r10.yzw, r12.yyzx, r10.zzwy, -r14.xxyz
 169:     dp3 r8.w, r10.yzwy, r10.yzwy
 170:     rsq r8.w, r8.w
 171:     mul r10.yz, r8.wwww, r10.yywy
 172:     mad r10.yz, r10.yyzy, r8.zzzz, r9.xxwx
 173:     dp2 r8.w, r5.wzww, r13.xzxx
 174:     ge r8.w, r8.w, l(0)
 175:     dp2 r5.w, r5.wzww, r10.yzyy
 176:     ge r5.w, r5.w, l(0)
 177:     or r5.w, r5.w, r8.w
 178:     and r4.w, r4.w, r5.w
 179:     lt r5.w, l(0), -r12.x
 180:     lt r8.w, -r12.x, l(0)
 181:     iadd r5.w, -r5.w, r8.w
 182:     imax r5.w, -r5.w, r5.w
 183:     itof r5.w, r5.w
 184:     add r5.w, -r5.w, l(1.000000)
 185:     mul r6.x, r5.w, l(0.000000)
 186:     mul r10.yzw, r6.xxyz, r12.zzxy
 187:     mad r10.yzw, r6.zzxy, r12.xxyz, -r10.yyzw
 188:     mul r14.xyz, r10.yzwy, r12.zxyz
 189:     mad r10.yzw, r12.yyzx, r10.zzwy, -r14.xxyz
 190:     dp3 r5.w, r10.yzwy, r10.yzwy
 191:     rsq r5.w, r5.w
 192:     mul r10.yzw, r5.wwww, r10.yyzw
 193:     mad r10.yzw, r10.yyzw, r8.zzzz, r9.xxyw
 194:     dp3 r5.w, r6.xyzx, r13.xyzx
 195:     ge r5.w, r5.w, l(0)
 196:     dp3 r8.w, r6.xyzx, r10.yzwy
 197:     ge r8.w, r8.w, l(0)
 198:     or r5.w, r5.w, r8.w
 199:     and r4.w, r4.w, r5.w
 200:     mov r3.x, r6.x
 201:     mul r10.yzw, r3.xxyz, r12.zzxy
 202:     mad r10.yzw, r3.zzxy, r12.xxyz, -r10.yyzw
 203:     mul r14.xyz, r10.yzwy, r12.zxyz
 204:     mad r10.yzw, r12.yyzx, r10.zzwy, -r14.xxyz
 205:     dp3 r5.w, r10.yzwy, r10.yzwy
 206:     rsq r5.w, r5.w
 207:     mul r10.yzw, r5.wwww, r10.yyzw
 208:     mad r9.xyw, r10.yzyw, r8.zzzz, r9.xyxw
 209:     dp3 r5.w, r3.xyzx, r13.xyzx
 210:     ge r5.w, r5.w, l(0)
 211:     dp3 r3.x, r3.xyzx, r9.xywx
 212:     ge r3.x, r3.x, l(0)
 213:     or r3.x, r3.x, r5.w
 214:     and r3.x, r3.x, r4.w
 215:   else
 216:     dp2 r4.w, r4.xzxx, r11.xzxx
 217:     ge r4.w, r4.w, -r11.w
 218:     and r4.w, r4.w, r8.x
 219:     dp2 r5.w, r5.xzxx, r11.xzxx
 220:     ge r5.w, r5.w, -r11.w
 221:     and r4.w, r4.w, r5.w
 222:     dp2 r5.w, r6.yzyy, r11.yzyy
 223:     ge r5.w, r5.w, -r11.w
 224:     and r4.w, r4.w, r5.w
 225:     dp2 r5.w, r3.yzyy, r11.yzyy
 226:     ge r5.w, r5.w, -r11.w
 227:     and r3.x, r4.w, r5.w
 228:   endif
 229:   if_nz r3.x
 230:     imm_atomic_iadd r11.x, g0, l(0), l(1)
 231:     store_structured g1.x, r11.x, l(0), r6.w
 232:   endif
 233:   iadd r6.w, r6.w, l(960)
 234: endloop
 235: sync_g_t
 236: ld_raw r0.z, l(0), g0.xxxx
 237: ult r0.w, g_TileLimitNum.x, r0.z
 238: movc r0.z, r0.w, l(0), r0.z
 239: iadd r0.w, l(1), g_TileLimitNum.x
 240: mov r1.x, r0.y
 241: loop
 242:   uge r1.y, r1.x, r0.z
 243:   breakc_nz r1.y
 244:   imad r1.y, r0.x, r0.w, r1.x
 245:   ld_structured r1.z, r1.x, l(0), g1.xxxx
 246:   store_structured gFramebuffer.x, r1.y, l(0), r1.z
 247:   iadd r1.x, r1.x, l(960)
 248: endloop
 249: imad r0.x, r0.x, r0.w, r0.z
 250: store_structured gFramebuffer.x, r0.x, l(0), l(0x0000ffff)
 251: ret
