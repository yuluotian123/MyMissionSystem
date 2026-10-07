Shader hash 6e428e12-af2c7695-fc2bf4a9-6287b656

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[14] (ColorCorrectionParam), dynamicIndexed
      dcl_sampler g_TextureAdaptLuminanceSampler (s1), mode_default
      dcl_resource_texture2d (float,float,float,float) g_TextureAdaptLuminance (t1)
      dcl_uav_typed_texture3d (float,float,float,float) g_ColorCorrectionLUT (u0)
      dcl_input vThreadID.xyz
      dcl_temps 11
      dcl_thread_group 16, 16, 1
   0: uge r0.xyz, vThreadID.xyzx, l(32, 32, 32, 0)
   1: or r0.x, r0.y, r0.x
   2: or r0.x, r0.z, r0.x
   3: if_nz r0.x
   4:   ret
   5: endif
   6: sample_l(texture2d)(float,float,float,float) r0.x, l(0.500000, 0.500000, 0.000000, 0.000000), g_TextureAdaptLuminance.xyzw, g_TextureAdaptLuminanceSampler, l(0)
   7: utof r0.yzw, vThreadID.xxyz
   8: mul r0.yzw, r0.yyzw, l(0.000000, 0.032258, 0.032258, 0.032258)
   9: log r0.yzw, r0.yyzw
  10: mul r0.yzw, r0.yyzw, l(0.000000, 0.012683, 0.012683, 0.012683)
  11: exp r0.yzw, r0.yyzw
  12: add r1.xyz, r0.yzwy, l(-0.835938, -0.835938, -0.835938, 0.000000)
  13: max r1.xyz, r1.xyzx, l(0, 0, 0, 0)
  14: mad r0.yzw, -r0.yyzw, l(0.000000, 18.687500, 18.687500, 18.687500), l(0.000000, 18.851563, 18.851563, 18.851563)
  15: div r0.yzw, r1.xxyz, r0.yyzw
  16: log r0.yzw, abs(r0.yyzw)
  17: mul r0.yzw, r0.yyzw, l(0.000000, 6.277395, 6.277395, 6.277395)
  18: exp r0.yzw, r0.yyzw
  19: mul r1.xyw, r0.zwzy, l(100.000000, 100.000000, 0.000000, 100.000000)
  20: lt r0.y, r1.x, r1.y
  21: mov r2.xy, r1.yxyy
  22: mov r2.zw, l(0.000000, 0.000000, -1.000000, 0.666667)
  23: mov r3.xy, r2.yxyy
  24: mov r3.zw, l(0.000000, 0.000000, 0.000000, -0.333333)
  25: movc r2.xyzw, r0.yyyy, r2.xyzw, r3.xyzw
  26: lt r0.y, r1.w, r2.x
  27: mov r1.xyz, r2.xywx
  28: mov r2.xyw, r1.wywx
  29: movc r1.xyzw, r0.yyyy, r1.xyzw, r2.xyzw
  30: min r0.y, r1.y, r1.w
  31: add r0.y, -r0.y, r1.x
  32: add r0.z, -r1.y, r1.w
  33: mad r0.w, r0.y, l(6.000000), l(0.000000)
  34: rcp r0.w, r0.w
  35: mad r0.z, r0.z, r0.w, r1.z
  36: add r0.w, r1.x, l(0.000000)
  37: div r0.y, r0.y, r0.w
  38: add r0.z, abs(r0.z), g_ColorCorrectParam.y
  39: frc r0.z, r0.z
  40: add_sat r0.y, r0.y, g_ColorCorrectParam.z
  41: mul r0.w, r1.x, g_ColorCorrectParam.w
  42: add r1.xyz, r0.zzzz, l(1.000000, 0.666667, 0.333333, 0.000000)
  43: frc r1.xyz, r1.xyzx
  44: mad r1.xyz, r1.xyzx, l(6.000000, 6.000000, 6.000000, 0.000000), l(-3.000000, -3.000000, -3.000000, 0.000000)
  45: add_sat r1.xyz, abs(r1.xyzx), l(-1.000000, -1.000000, -1.000000, 0.000000)
  46: add r1.xyz, r1.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  47: mad r1.xyz, r0.yyyy, r1.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  48: mad r0.yzw, r0.wwww, r1.xxyz, l(0.000000, 0.000100, 0.000100, 0.000100)
  49: log r0.yzw, r0.yyzw
  50: sqrt r1.x, r0.x
  51: add r1.x, r1.x, l(-0.500000)
  52: add r0.yzw, r0.yyzw, -r1.xxxx
  53: add r1.y, -g_ColorCorrectParam.x, l(1.000000)
  54: mad r1.x, r1.y, l(0.500000), r1.x
  55: mad r0.yzw, g_ColorCorrectParam.xxxx, r0.yyzw, r1.xxxx
  56: exp r0.yzw, r0.yyzw
  57: lt r1.x, l(0.500000), g_ColorCorrectFlag.x
  58: if_nz r1.x
  59:   mov r2.xyz, l(0, 0, 0, 0)
  60:   mov r1.xyzw, l(0, 0, 0, 1)
  61:   loop
  62:     ige r2.w, r1.w, l(3)
  63:     breakc_nz r2.w
  64:     ishl r2.w, r1.w, l(2)
  65:     iadd r2.w, r2.w, l(-4)
  66:     add r3.xyz, r0.yzwy, -cb0[r2.w + 0].xyzx
  67:     add r4.xyz, -cb0[r2.w + 0].xyzx, cb0[r2.w + 4].xyzx
  68:     div r3.xyz, r3.xyzx, r4.xyzx
  69:     add r4.xyz, -r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  70:     mul r5.xyz, r4.xyzx, r4.xyzx
  71:     mul r5.xyz, r4.xyzx, r5.xyzx
  72:     mul r6.xyz, r4.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
  73:     mul r4.xyz, r4.xyzx, r6.xyzx
  74:     mul r4.xyz, r3.xyzx, r4.xyzx
  75:     mul r7.xyz, r3.xyzx, r3.xyzx
  76:     mul r6.xyz, r6.xyzx, r7.xyzx
  77:     mul r7.xyz, r3.xyzx, r7.xyzx
  78:     add r8.xyz, cb0[r2.w + 1].xyzx, cb0[r2.w + 3].xyzx
  79:     add r9.xyz, cb0[r2.w + 5].xyzx, cb0[r2.w + 6].xyzx
  80:     mul r4.xyz, r4.xyzx, r8.xyzx
  81:     mad r4.xyz, cb0[r2.w + 1].xyzx, r5.xyzx, r4.xyzx
  82:     mad r4.xyz, r9.xyzx, r6.xyzx, r4.xyzx
  83:     mad r4.xyz, cb0[r2.w + 5].xyzx, r7.xyzx, r4.xyzx
  84:     ge r5.xyz, r3.xyzx, l(0, 0, 0, 0)
  85:     ge r3.xyz, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  86:     and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  87:     movc r3.xyz, r3.xyzx, l(0, 0, 0, 0), r5.xyzx
  88:     mad r1.xyz, r4.xyzx, r3.xyzx, r1.xyzx
  89:     add r2.xyz, r2.xyzx, r3.xyzx
  90:     iadd r1.w, r1.w, l(1)
  91:   endloop
  92:   ge r2.xyz, l(0, 0, 0, 0), r2.xyzx
  93:   movc r2.xyz, r2.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
  94:   ge r3.xyz, g_Key[0].xyzx, r0.yzwy
  95:   and r3.xyz, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  96:   mul r3.xyz, r3.xyzx, g_Key[1].xyzx
  97:   ge r4.xyz, r0.yzwy, g_Key[8].xyzx
  98:   and r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  99:   max r5.xyz, r0.yzwy, g_Key[9].xyzx
 100:   mad r1.xyz, r2.xyzx, r1.xyzx, r3.xyzx
 101:   mad r1.xyz, r4.xyzx, r5.xyzx, r1.xyzx
 102:   max r1.xyz, r1.xyzx, l(0, 0, 0, 0)
 103:   mov r2.xyz, l(0, 0, 0, 0)
 104:   mov r3.xyz, l(0, 0, 0, 0)
 105:   mov r1.w, l(1)
 106:   loop
 107:     ige r2.w, r1.w, l(3)
 108:     breakc_nz r2.w
 109:     ishl r2.w, r1.w, l(2)
 110:     iadd r2.w, r2.w, l(-4)
 111:     add r4.xyz, r1.xyzx, -cb0[r2.w + 0].wwww
 112:     add r3.w, -cb0[r2.w + 0].w, cb0[r2.w + 4].w
 113:     div r4.xyz, r4.xyzx, r3.wwww
 114:     add r5.xyz, -r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 115:     mul r6.xyz, r5.xyzx, r5.xyzx
 116:     mul r6.xyz, r5.xyzx, r6.xyzx
 117:     mul r7.xyz, r5.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 118:     mul r5.xyz, r5.xyzx, r7.xyzx
 119:     mul r5.xyz, r4.xyzx, r5.xyzx
 120:     mul r8.xyz, r4.xyzx, r4.xyzx
 121:     mul r7.xyz, r7.xyzx, r8.xyzx
 122:     mul r8.xyz, r4.xyzx, r8.xyzx
 123:     add r3.w, cb0[r2.w + 1].w, cb0[r2.w + 3].w
 124:     add r4.w, cb0[r2.w + 5].w, cb0[r2.w + 6].w
 125:     mul r5.xyz, r5.xyzx, r3.wwww
 126:     mad r5.xyz, cb0[r2.w + 1].wwww, r6.xyzx, r5.xyzx
 127:     mad r5.xyz, r4.wwww, r7.xyzx, r5.xyzx
 128:     mad r5.xyz, cb0[r2.w + 5].wwww, r8.xyzx, r5.xyzx
 129:     ge r6.xyz, r4.xyzx, l(0, 0, 0, 0)
 130:     ge r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 131:     and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 132:     movc r4.xyz, r4.xyzx, l(0, 0, 0, 0), r6.xyzx
 133:     mad r2.xyz, r5.xyzx, r4.xyzx, r2.xyzx
 134:     add r3.xyz, r3.xyzx, r4.xyzx
 135:     iadd r1.w, r1.w, l(1)
 136:   endloop
 137:   ge r3.xyz, l(0, 0, 0, 0), r3.xyzx
 138:   movc r3.xyz, r3.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 139:   ge r4.xyz, g_Key[0].wwww, r1.xyzx
 140:   and r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 141:   mul r4.xyz, r4.xyzx, g_Key[1].wwww
 142:   ge r5.xyz, r1.xyzx, g_Key[8].wwww
 143:   and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 144:   max r1.xyz, r1.xyzx, g_Key[9].wwww
 145:   mad r2.xyz, r3.xyzx, r2.xyzx, r4.xyzx
 146:   mad r1.xyz, r5.xyzx, r1.xyzx, r2.xyzx
 147:   max r1.xyz, r1.xyzx, l(0, 0, 0, 0)
 148: else
 149:   mul r0.yzw, r0.yyzw, r0.xxxx
 150:   mad r2.xyz, r0.yzwy, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.050000, 0.050000, 0.050000, 0.000000)
 151:   mad r2.xyz, r0.yzwy, r2.xyzx, l(0.004000, 0.004000, 0.004000, 0.000000)
 152:   mad r3.xyz, r0.yzwy, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
 153:   mad r0.yzw, r0.yyzw, r3.xxyz, l(0.000000, 0.060000, 0.060000, 0.060000)
 154:   div r0.yzw, r2.xxyz, r0.yyzw
 155:   add r0.yzw, r0.yyzw, l(0.000000, -0.066667, -0.066667, -0.066667)
 156:   mul r2.xyz, r0.yzwy, l(1.379064, 1.379064, 1.379064, 0.000000)
 157:   ge r3.xyz, l(0.002270, 0.002270, 0.002270, 0.000000), r0.yzwy
 158:   mul r0.yzw, r0.yyzw, l(0.000000, 17.817511, 17.817511, 17.817511)
 159:   log r2.xyz, abs(r2.xyzx)
 160:   mul r2.xyz, r2.xyzx, l(0.416667, 0.416667, 0.416667, 0.000000)
 161:   exp r2.xyz, r2.xyzx
 162:   mad r2.xyz, r2.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
 163:   movc r0.yzw, r3.xxyz, r0.yyzw, r2.xxyz
 164:   mov r3.xyz, l(0, 0, 0, 0)
 165:   mov r2.xyzw, l(0, 0, 0, 1)
 166:   loop
 167:     ige r3.w, r2.w, l(3)
 168:     breakc_nz r3.w
 169:     ishl r3.w, r2.w, l(2)
 170:     iadd r3.w, r3.w, l(-4)
 171:     add r4.xyz, r0.yzwy, -cb0[r3.w + 0].xyzx
 172:     add r5.xyz, -cb0[r3.w + 0].xyzx, cb0[r3.w + 4].xyzx
 173:     div r4.xyz, r4.xyzx, r5.xyzx
 174:     add r5.xyz, -r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 175:     mul r6.xyz, r5.xyzx, r5.xyzx
 176:     mul r6.xyz, r5.xyzx, r6.xyzx
 177:     mul r7.xyz, r5.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 178:     mul r5.xyz, r5.xyzx, r7.xyzx
 179:     mul r5.xyz, r4.xyzx, r5.xyzx
 180:     mul r8.xyz, r4.xyzx, r4.xyzx
 181:     mul r7.xyz, r7.xyzx, r8.xyzx
 182:     mul r8.xyz, r4.xyzx, r8.xyzx
 183:     add r9.xyz, cb0[r3.w + 1].xyzx, cb0[r3.w + 3].xyzx
 184:     add r10.xyz, cb0[r3.w + 5].xyzx, cb0[r3.w + 6].xyzx
 185:     mul r5.xyz, r5.xyzx, r9.xyzx
 186:     mad r5.xyz, cb0[r3.w + 1].xyzx, r6.xyzx, r5.xyzx
 187:     mad r5.xyz, r10.xyzx, r7.xyzx, r5.xyzx
 188:     mad r5.xyz, cb0[r3.w + 5].xyzx, r8.xyzx, r5.xyzx
 189:     ge r6.xyz, r4.xyzx, l(0, 0, 0, 0)
 190:     ge r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 191:     and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 192:     movc r4.xyz, r4.xyzx, l(0, 0, 0, 0), r6.xyzx
 193:     mad r2.xyz, r5.xyzx, r4.xyzx, r2.xyzx
 194:     add r3.xyz, r3.xyzx, r4.xyzx
 195:     iadd r2.w, r2.w, l(1)
 196:   endloop
 197:   ge r3.xyz, l(0, 0, 0, 0), r3.xyzx
 198:   movc r3.xyz, r3.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 199:   ge r4.xyz, g_Key[0].xyzx, r0.yzwy
 200:   and r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 201:   mul r4.xyz, r4.xyzx, g_Key[1].xyzx
 202:   ge r5.xyz, r0.yzwy, g_Key[8].xyzx
 203:   and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 204:   max r0.yzw, r0.yyzw, g_Key[9].xxyz
 205:   mad r2.xyz, r3.xyzx, r2.xyzx, r4.xyzx
 206:   mad r0.yzw, r5.xxyz, r0.yyzw, r2.xxyz
 207:   max r0.yzw, r0.yyzw, l(0, 0, 0, 0)
 208:   mov r3.xyz, l(0, 0, 0, 0)
 209:   mov r2.xyzw, l(0, 0, 0, 1)
 210:   loop
 211:     ige r3.w, r2.w, l(3)
 212:     breakc_nz r3.w
 213:     ishl r3.w, r2.w, l(2)
 214:     iadd r3.w, r3.w, l(-4)
 215:     add r4.xyz, r0.yzwy, -cb0[r3.w + 0].wwww
 216:     add r4.w, -cb0[r3.w + 0].w, cb0[r3.w + 4].w
 217:     div r4.xyz, r4.xyzx, r4.wwww
 218:     add r5.xyz, -r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 219:     mul r6.xyz, r5.xyzx, r5.xyzx
 220:     mul r6.xyz, r5.xyzx, r6.xyzx
 221:     mul r7.xyz, r5.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 222:     mul r5.xyz, r5.xyzx, r7.xyzx
 223:     mul r5.xyz, r4.xyzx, r5.xyzx
 224:     mul r8.xyz, r4.xyzx, r4.xyzx
 225:     mul r7.xyz, r7.xyzx, r8.xyzx
 226:     mul r8.xyz, r4.xyzx, r8.xyzx
 227:     add r4.w, cb0[r3.w + 1].w, cb0[r3.w + 3].w
 228:     add r5.w, cb0[r3.w + 5].w, cb0[r3.w + 6].w
 229:     mul r5.xyz, r5.xyzx, r4.wwww
 230:     mad r5.xyz, cb0[r3.w + 1].wwww, r6.xyzx, r5.xyzx
 231:     mad r5.xyz, r5.wwww, r7.xyzx, r5.xyzx
 232:     mad r5.xyz, cb0[r3.w + 5].wwww, r8.xyzx, r5.xyzx
 233:     ge r6.xyz, r4.xyzx, l(0, 0, 0, 0)
 234:     ge r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 235:     and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 236:     movc r4.xyz, r4.xyzx, l(0, 0, 0, 0), r6.xyzx
 237:     mad r2.xyz, r5.xyzx, r4.xyzx, r2.xyzx
 238:     add r3.xyz, r3.xyzx, r4.xyzx
 239:     iadd r2.w, r2.w, l(1)
 240:   endloop
 241:   ge r3.xyz, l(0, 0, 0, 0), r3.xyzx
 242:   movc r3.xyz, r3.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 243:   ge r4.xyz, g_Key[0].wwww, r0.yzwy
 244:   and r4.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 245:   mul r4.xyz, r4.xyzx, g_Key[1].wwww
 246:   ge r5.xyz, r0.yzwy, g_Key[8].wwww
 247:   and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 248:   max r0.yzw, r0.yyzw, g_Key[9].wwww
 249:   mad r2.xyz, r3.xyzx, r2.xyzx, r4.xyzx
 250:   mad r0.yzw, r5.xxyz, r0.yyzw, r2.xxyz
 251:   max r0.yzw, r0.yyzw, l(0, 0, 0, 0)
 252:   ge r2.xyz, l(0.039280, 0.039280, 0.039280, 0.000000), r0.yzwy
 253:   mul r3.xyz, r0.yzwy, l(0.077399, 0.077399, 0.077399, 0.000000)
 254:   add r0.yzw, r0.yyzw, l(0.000000, 0.055000, 0.055000, 0.055000)
 255:   mul r0.yzw, r0.yyzw, l(0.000000, 0.947867, 0.947867, 0.947867)
 256:   log r0.yzw, r0.yyzw
 257:   mul r0.yzw, r0.yyzw, l(0.000000, 2.400000, 2.400000, 2.400000)
 258:   exp r0.yzw, r0.yyzw
 259:   movc r0.yzw, r2.xxyz, r3.xxyz, r0.yyzw
 260:   mad r2.xyz, r0.yzwy, l(0.108769, 0.108769, 0.108769, 0.000000), l(-0.005000, -0.005000, -0.005000, 0.000000)
 261:   mad r3.xyz, r0.yzwy, l(0.032631, 0.032631, 0.032631, 0.000000), l(-0.042000, -0.042000, -0.042000, 0.000000)
 262:   mul r0.yzw, r0.yyzw, r3.xxyz
 263:   mul r0.yzw, r0.yyzw, l(0.000000, 0.052209, 0.052209, 0.052209)
 264:   mad r0.yzw, r2.xxyz, r2.xxyz, -r0.yyzw
 265:   sqrt r0.yzw, r0.yyzw
 266:   add r0.yzw, -r2.xxyz, -r0.yyzw
 267:   add r2.xyz, r3.xyzx, r3.xyzx
 268:   div r0.yzw, r0.yyzw, r2.xxyz
 269:   div r1.xyz, r0.yzwy, r0.xxxx
 270: endif
 271: mov r1.w, l(1.000000)
 272: store_uav_typed g_ColorCorrectionLUT.xyzw, vThreadID.xyzz, r1.xyzw
 273: ret
