Shader hash 230f6e82-27f29c70-9f5181e1-9831ca40

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[7] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb2[31] (ColorCorrectBuffer), dynamicIndexed
      dcl_sampler g_TextureSceneColorHDRSampler (s0), mode_default
      dcl_sampler g_LinearClamp (s1), mode_default
      dcl_sampler g_TextureAdaptLumminanceSampler (s2), mode_default
      dcl_resource_texture2d (float,float,float,float) g_TextureSceneColorHDR (t0)
      dcl_resource_texture2d (float,float,float,float) g_TextureAdaptLumminance (t2)
      dcl_resource_texture2d (float,float,float,float) g_DepthTexture (t3)
      dcl_resource_texture3d (float,float,float,float) g_NearLUT (t4)
      dcl_resource_texture3d (float,float,float,float) g_FarLUT (t5)
      dcl_resource_texture2d (uint,uint,uint,uint) g_StencilBuffer (t25)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_temps 13
   0: sample_indexable(texture2d)(float,float,float,float) r0.xyz, v1.xyxx, g_TextureSceneColorHDR.xyzw, g_TextureSceneColorHDRSampler
   1: ftoi r1.xy, v0.xyxx
   2: mov r1.zw, l(0, 0, 0, 0)
   3: ld_indexable(texture2d)(float,float,float,float) r0.w, r1.xyww, g_DepthTexture.yzwx
   4: add r0.w, r0.w, g_Proj[2].z
   5: div r0.w, g_Proj[2].w, r0.w
   6: add r0.w, r0.w, -g_CameraParam.x
   7: div r2.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_CameraParam.y
   8: mul r0.w, r0.w, r2.x
   9: mad r2.x, r0.w, g_CameraParam.y, g_CameraParam.x
  10: lt r2.y, g_ColorCorrectFlg.y, l(0.500000)
  11: lt r0.w, l(0.990000), r0.w
  12: and r0.w, r0.w, r2.y
  13: lt r2.y, g_ColorCorrectRange.y, r2.x
  14: lt r2.z, r2.x, g_ColorCorrectRange.z
  15: and r2.y, r2.z, r2.y
  16: or r0.w, r0.w, r2.y
  17: if_nz r0.w
  18:   mov o0.xyz, r0.xyzx
  19:   mov o0.w, l(1.000000)
  20:   ret
  21: endif
  22: sample_indexable(texture2d)(float,float,float,float) r0.w, l(0.500000, 0.500000, 0.000000, 0.000000), g_TextureAdaptLumminance.yzwx, g_TextureAdaptLumminanceSampler
  23: ld_indexable(texture2d)(uint,uint,uint,uint) r1.x, r1.xyzw, g_StencilBuffer.yxzw
  24: and r1.xy, r1.xxxx, l(15, 128, 0, 0)
  25: movc r1.y, r1.y, l(9), l(0)
  26: iadd r1.x, r1.y, r1.x
  27: ge r1.y, g_ColorCorrectRange.y, r2.x
  28: if_nz r1.y
  29:   mul r1.yzw, r0.xxyz, l(0.000000, 0.010000, 0.010000, 0.010000)
  30:   log r1.yzw, abs(r1.yyzw)
  31:   mul r1.yzw, r1.yyzw, l(0.000000, 0.159302, 0.159302, 0.159302)
  32:   exp r1.yzw, r1.yyzw
  33:   mad r2.yzw, r1.yyzw, l(0.000000, 18.851563, 18.851563, 18.851563), l(0.000000, 0.835938, 0.835938, 0.835938)
  34:   mad r1.yzw, r1.yyzw, l(0.000000, 18.687500, 18.687500, 18.687500), l(0.000000, 1.000000, 1.000000, 1.000000)
  35:   div r1.yzw, r2.yyzw, r1.yyzw
  36:   log r1.yzw, r1.yyzw
  37:   mul r1.yzw, r1.yyzw, l(0.000000, 78.843750, 78.843750, 78.843750)
  38:   exp r1.yzw, r1.yyzw
  39:   dp3 r2.y, r1.yzwy, l(0.262700, 0.678000, 0.059300, 0.000000)
  40:   lt r2.y, r2.y, l(1.000000)
  41:   if_nz r2.y
  42:     sample_l(texture3d)(float,float,float,float) r1.yzw, r1.yzwy, g_NearLUT.wxyz, g_LinearClamp, l(0)
  43:   else
  44:     lt r2.y, r0.y, r0.z
  45:     mov r3.xy, r0.zyzz
  46:     mov r3.zw, l(0.000000, 0.000000, -1.000000, 0.666667)
  47:     mov r4.xy, r3.yxyy
  48:     mov r4.zw, l(0.000000, 0.000000, 0.000000, -0.333333)
  49:     movc r3.xyzw, r2.yyyy, r3.xyzw, r4.xyzw
  50:     lt r2.y, r0.x, r3.x
  51:     mov r4.xyz, r3.xywx
  52:     mov r4.w, r0.x
  53:     mov r3.xyw, r4.wywx
  54:     movc r3.xyzw, r2.yyyy, r4.xyzw, r3.xyzw
  55:     min r2.y, r3.y, r3.w
  56:     add r2.y, -r2.y, r3.x
  57:     add r2.z, -r3.y, r3.w
  58:     mad r2.w, r2.y, l(6.000000), l(0.000000)
  59:     rcp r2.w, r2.w
  60:     mad r2.z, r2.z, r2.w, r3.z
  61:     add r2.w, r3.x, l(0.000000)
  62:     div r2.y, r2.y, r2.w
  63:     add r2.z, abs(r2.z), g_ColorCorrectParamNear.y
  64:     frc r2.z, r2.z
  65:     add_sat r2.y, r2.y, g_ColorCorrectParamNear.z
  66:     mul r2.w, r3.x, g_ColorCorrectParamNear.w
  67:     add r3.xyz, r2.zzzz, l(1.000000, 0.666667, 0.333333, 0.000000)
  68:     frc r3.xyz, r3.xyzx
  69:     mad r3.xyz, r3.xyzx, l(6.000000, 6.000000, 6.000000, 0.000000), l(-3.000000, -3.000000, -3.000000, 0.000000)
  70:     add_sat r3.xyz, abs(r3.xyzx), l(-1.000000, -1.000000, -1.000000, 0.000000)
  71:     add r3.xyz, r3.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  72:     mad r3.xyz, r2.yyyy, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  73:     mad r2.yzw, r2.wwww, r3.xxyz, l(0.000000, 0.000100, 0.000100, 0.000100)
  74:     log r2.yzw, r2.yyzw
  75:     sqrt r3.x, r0.w
  76:     add r3.x, r3.x, l(-0.500000)
  77:     add r2.yzw, r2.yyzw, -r3.xxxx
  78:     add r3.y, l(1.000000), -g_ColorCorrectParamNear.x
  79:     mad r3.x, r3.y, l(0.500000), r3.x
  80:     mad r2.yzw, g_ColorCorrectParamNear.xxxx, r2.yyzw, r3.xxxx
  81:     exp r2.yzw, r2.yyzw
  82:     lt r3.x, l(0.500000), g_ColorCorrectFlg.x
  83:     if_nz r3.x
  84:       mov r4.xyz, l(0, 0, 0, 0)
  85:       mov r3.xyzw, l(0, 0, 0, 1)
  86:       loop
  87:         ige r4.w, r3.w, l(3)
  88:         breakc_nz r4.w
  89:         ishl r4.w, r3.w, l(2)
  90:         iadd r4.w, r4.w, l(-4)
  91:         add r5.xyz, r2.yzwy, -cb2[r4.w + 1].xyzx
  92:         add r6.xyz, -cb2[r4.w + 1].xyzx, cb2[r4.w + 5].xyzx
  93:         div r5.xyz, r5.xyzx, r6.xyzx
  94:         add r6.xyz, -r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  95:         mul r7.xyz, r6.xyzx, r6.xyzx
  96:         mul r7.xyz, r6.xyzx, r7.xyzx
  97:         mul r8.xyz, r6.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
  98:         mul r6.xyz, r6.xyzx, r8.xyzx
  99:         mul r6.xyz, r5.xyzx, r6.xyzx
 100:         mul r9.xyz, r5.xyzx, r5.xyzx
 101:         mul r8.xyz, r8.xyzx, r9.xyzx
 102:         mul r9.xyz, r5.xyzx, r9.xyzx
 103:         add r10.xyz, cb2[r4.w + 2].xyzx, cb2[r4.w + 4].xyzx
 104:         add r11.xyz, cb2[r4.w + 6].xyzx, cb2[r4.w + 7].xyzx
 105:         mul r6.xyz, r6.xyzx, r10.xyzx
 106:         mad r6.xyz, cb2[r4.w + 2].xyzx, r7.xyzx, r6.xyzx
 107:         mad r6.xyz, r11.xyzx, r8.xyzx, r6.xyzx
 108:         mad r6.xyz, cb2[r4.w + 6].xyzx, r9.xyzx, r6.xyzx
 109:         ge r7.xyz, r5.xyzx, l(0, 0, 0, 0)
 110:         ge r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 111:         and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 112:         movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), r7.xyzx
 113:         mad r3.xyz, r6.xyzx, r5.xyzx, r3.xyzx
 114:         add r4.xyz, r4.xyzx, r5.xyzx
 115:         iadd r3.w, r3.w, l(1)
 116:       endloop
 117:       ge r4.xyz, l(0, 0, 0, 0), r4.xyzx
 118:       movc r4.xyz, r4.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 119:       ge r5.xyz, g_KeyNear[0].xyzx, r2.yzwy
 120:       and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 121:       mul r5.xyz, r5.xyzx, g_KeyNear[1].xyzx
 122:       ge r6.xyz, r2.yzwy, g_KeyNear[8].xyzx
 123:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 124:       max r7.xyz, r2.yzwy, g_KeyNear[9].xyzx
 125:       mad r3.xyz, r4.xyzx, r3.xyzx, r5.xyzx
 126:       mad r3.xyz, r6.xyzx, r7.xyzx, r3.xyzx
 127:       max r3.xyz, r3.xyzx, l(0, 0, 0, 0)
 128:       mov r4.xyz, l(0, 0, 0, 0)
 129:       mov r5.xyz, l(0, 0, 0, 0)
 130:       mov r3.w, l(1)
 131:       loop
 132:         ige r4.w, r3.w, l(3)
 133:         breakc_nz r4.w
 134:         ishl r4.w, r3.w, l(2)
 135:         iadd r4.w, r4.w, l(-4)
 136:         add r6.xyz, r3.xyzx, -cb2[r4.w + 1].wwww
 137:         add r5.w, -cb2[r4.w + 1].w, cb2[r4.w + 5].w
 138:         div r6.xyz, r6.xyzx, r5.wwww
 139:         add r7.xyz, -r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 140:         mul r8.xyz, r7.xyzx, r7.xyzx
 141:         mul r8.xyz, r7.xyzx, r8.xyzx
 142:         mul r9.xyz, r7.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 143:         mul r7.xyz, r7.xyzx, r9.xyzx
 144:         mul r7.xyz, r6.xyzx, r7.xyzx
 145:         mul r10.xyz, r6.xyzx, r6.xyzx
 146:         mul r9.xyz, r9.xyzx, r10.xyzx
 147:         mul r10.xyz, r6.xyzx, r10.xyzx
 148:         add r5.w, cb2[r4.w + 2].w, cb2[r4.w + 4].w
 149:         add r6.w, cb2[r4.w + 6].w, cb2[r4.w + 7].w
 150:         mul r7.xyz, r7.xyzx, r5.wwww
 151:         mad r7.xyz, cb2[r4.w + 2].wwww, r8.xyzx, r7.xyzx
 152:         mad r7.xyz, r6.wwww, r9.xyzx, r7.xyzx
 153:         mad r7.xyz, cb2[r4.w + 6].wwww, r10.xyzx, r7.xyzx
 154:         ge r8.xyz, r6.xyzx, l(0, 0, 0, 0)
 155:         ge r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 156:         and r8.xyz, r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 157:         movc r6.xyz, r6.xyzx, l(0, 0, 0, 0), r8.xyzx
 158:         mad r4.xyz, r7.xyzx, r6.xyzx, r4.xyzx
 159:         add r5.xyz, r5.xyzx, r6.xyzx
 160:         iadd r3.w, r3.w, l(1)
 161:       endloop
 162:       ge r5.xyz, l(0, 0, 0, 0), r5.xyzx
 163:       movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 164:       ge r6.xyz, g_KeyNear[0].wwww, r3.xyzx
 165:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 166:       mul r6.xyz, r6.xyzx, g_KeyNear[1].wwww
 167:       ge r7.xyz, r3.xyzx, g_KeyNear[8].wwww
 168:       and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 169:       max r3.xyz, r3.xyzx, g_KeyNear[9].wwww
 170:       mad r4.xyz, r5.xyzx, r4.xyzx, r6.xyzx
 171:       mad r3.xyz, r7.xyzx, r3.xyzx, r4.xyzx
 172:       max r1.yzw, r3.xxyz, l(0, 0, 0, 0)
 173:     else
 174:       mul r2.yzw, r0.wwww, r2.yyzw
 175:       mad r3.xyz, r2.yzwy, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.050000, 0.050000, 0.050000, 0.000000)
 176:       mad r3.xyz, r2.yzwy, r3.xyzx, l(0.004000, 0.004000, 0.004000, 0.000000)
 177:       mad r4.xyz, r2.yzwy, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
 178:       mad r2.yzw, r2.yyzw, r4.xxyz, l(0.000000, 0.060000, 0.060000, 0.060000)
 179:       div r2.yzw, r3.xxyz, r2.yyzw
 180:       add r2.yzw, r2.yyzw, l(0.000000, -0.066667, -0.066667, -0.066667)
 181:       mul r3.xyz, r2.yzwy, l(1.379064, 1.379064, 1.379064, 0.000000)
 182:       ge r4.xyz, l(0.002270, 0.002270, 0.002270, 0.000000), r2.yzwy
 183:       mul r2.yzw, r2.yyzw, l(0.000000, 17.817511, 17.817511, 17.817511)
 184:       log r3.xyz, abs(r3.xyzx)
 185:       mul r3.xyz, r3.xyzx, l(0.416667, 0.416667, 0.416667, 0.000000)
 186:       exp r3.xyz, r3.xyzx
 187:       mad r3.xyz, r3.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
 188:       movc r2.yzw, r4.xxyz, r2.yyzw, r3.xxyz
 189:       mov r4.xyz, l(0, 0, 0, 0)
 190:       mov r3.xyzw, l(0, 0, 0, 1)
 191:       loop
 192:         ige r4.w, r3.w, l(3)
 193:         breakc_nz r4.w
 194:         ishl r4.w, r3.w, l(2)
 195:         iadd r4.w, r4.w, l(-4)
 196:         add r5.xyz, r2.yzwy, -cb2[r4.w + 1].xyzx
 197:         add r6.xyz, -cb2[r4.w + 1].xyzx, cb2[r4.w + 5].xyzx
 198:         div r5.xyz, r5.xyzx, r6.xyzx
 199:         add r6.xyz, -r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 200:         mul r7.xyz, r6.xyzx, r6.xyzx
 201:         mul r7.xyz, r6.xyzx, r7.xyzx
 202:         mul r8.xyz, r6.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 203:         mul r6.xyz, r6.xyzx, r8.xyzx
 204:         mul r6.xyz, r5.xyzx, r6.xyzx
 205:         mul r9.xyz, r5.xyzx, r5.xyzx
 206:         mul r8.xyz, r8.xyzx, r9.xyzx
 207:         mul r9.xyz, r5.xyzx, r9.xyzx
 208:         add r10.xyz, cb2[r4.w + 2].xyzx, cb2[r4.w + 4].xyzx
 209:         add r11.xyz, cb2[r4.w + 6].xyzx, cb2[r4.w + 7].xyzx
 210:         mul r6.xyz, r6.xyzx, r10.xyzx
 211:         mad r6.xyz, cb2[r4.w + 2].xyzx, r7.xyzx, r6.xyzx
 212:         mad r6.xyz, r11.xyzx, r8.xyzx, r6.xyzx
 213:         mad r6.xyz, cb2[r4.w + 6].xyzx, r9.xyzx, r6.xyzx
 214:         ge r7.xyz, r5.xyzx, l(0, 0, 0, 0)
 215:         ge r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 216:         and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 217:         movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), r7.xyzx
 218:         mad r3.xyz, r6.xyzx, r5.xyzx, r3.xyzx
 219:         add r4.xyz, r4.xyzx, r5.xyzx
 220:         iadd r3.w, r3.w, l(1)
 221:       endloop
 222:       ge r4.xyz, l(0, 0, 0, 0), r4.xyzx
 223:       movc r4.xyz, r4.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 224:       ge r5.xyz, g_KeyNear[0].xyzx, r2.yzwy
 225:       and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 226:       mul r5.xyz, r5.xyzx, g_KeyNear[1].xyzx
 227:       ge r6.xyz, r2.yzwy, g_KeyNear[8].xyzx
 228:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 229:       max r2.yzw, r2.yyzw, g_KeyNear[9].xxyz
 230:       mad r3.xyz, r4.xyzx, r3.xyzx, r5.xyzx
 231:       mad r2.yzw, r6.xxyz, r2.yyzw, r3.xxyz
 232:       max r2.yzw, r2.yyzw, l(0, 0, 0, 0)
 233:       mov r4.xyz, l(0, 0, 0, 0)
 234:       mov r3.xyzw, l(0, 0, 0, 1)
 235:       loop
 236:         ige r4.w, r3.w, l(3)
 237:         breakc_nz r4.w
 238:         ishl r4.w, r3.w, l(2)
 239:         iadd r4.w, r4.w, l(-4)
 240:         add r5.xyz, r2.yzwy, -cb2[r4.w + 1].wwww
 241:         add r5.w, -cb2[r4.w + 1].w, cb2[r4.w + 5].w
 242:         div r5.xyz, r5.xyzx, r5.wwww
 243:         add r6.xyz, -r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 244:         mul r7.xyz, r6.xyzx, r6.xyzx
 245:         mul r7.xyz, r6.xyzx, r7.xyzx
 246:         mul r8.xyz, r6.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 247:         mul r6.xyz, r6.xyzx, r8.xyzx
 248:         mul r6.xyz, r5.xyzx, r6.xyzx
 249:         mul r9.xyz, r5.xyzx, r5.xyzx
 250:         mul r8.xyz, r8.xyzx, r9.xyzx
 251:         mul r9.xyz, r5.xyzx, r9.xyzx
 252:         add r5.w, cb2[r4.w + 2].w, cb2[r4.w + 4].w
 253:         add r6.w, cb2[r4.w + 6].w, cb2[r4.w + 7].w
 254:         mul r6.xyz, r6.xyzx, r5.wwww
 255:         mad r6.xyz, cb2[r4.w + 2].wwww, r7.xyzx, r6.xyzx
 256:         mad r6.xyz, r6.wwww, r8.xyzx, r6.xyzx
 257:         mad r6.xyz, cb2[r4.w + 6].wwww, r9.xyzx, r6.xyzx
 258:         ge r7.xyz, r5.xyzx, l(0, 0, 0, 0)
 259:         ge r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 260:         and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 261:         movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), r7.xyzx
 262:         mad r3.xyz, r6.xyzx, r5.xyzx, r3.xyzx
 263:         add r4.xyz, r4.xyzx, r5.xyzx
 264:         iadd r3.w, r3.w, l(1)
 265:       endloop
 266:       ge r4.xyz, l(0, 0, 0, 0), r4.xyzx
 267:       movc r4.xyz, r4.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 268:       ge r5.xyz, g_KeyNear[0].wwww, r2.yzwy
 269:       and r5.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 270:       mul r5.xyz, r5.xyzx, g_KeyNear[1].wwww
 271:       ge r6.xyz, r2.yzwy, g_KeyNear[8].wwww
 272:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 273:       max r2.yzw, r2.yyzw, g_KeyNear[9].wwww
 274:       mad r3.xyz, r4.xyzx, r3.xyzx, r5.xyzx
 275:       mad r2.yzw, r6.xxyz, r2.yyzw, r3.xxyz
 276:       max r2.yzw, r2.yyzw, l(0, 0, 0, 0)
 277:       ge r3.xyz, l(0.039280, 0.039280, 0.039280, 0.000000), r2.yzwy
 278:       mul r4.xyz, r2.yzwy, l(0.077399, 0.077399, 0.077399, 0.000000)
 279:       add r2.yzw, r2.yyzw, l(0.000000, 0.055000, 0.055000, 0.055000)
 280:       mul r2.yzw, r2.yyzw, l(0.000000, 0.947867, 0.947867, 0.947867)
 281:       log r2.yzw, r2.yyzw
 282:       mul r2.yzw, r2.yyzw, l(0.000000, 2.400000, 2.400000, 2.400000)
 283:       exp r2.yzw, r2.yyzw
 284:       movc r2.yzw, r3.xxyz, r4.xxyz, r2.yyzw
 285:       mad r3.xyz, r2.yzwy, l(0.108769, 0.108769, 0.108769, 0.000000), l(-0.005000, -0.005000, -0.005000, 0.000000)
 286:       mad r4.xyz, r2.yzwy, l(0.032631, 0.032631, 0.032631, 0.000000), l(-0.042000, -0.042000, -0.042000, 0.000000)
 287:       mul r2.yzw, r2.yyzw, r4.xxyz
 288:       mul r2.yzw, r2.yyzw, l(0.000000, 0.052209, 0.052209, 0.052209)
 289:       mad r2.yzw, r3.xxyz, r3.xxyz, -r2.yyzw
 290:       sqrt r2.yzw, r2.yyzw
 291:       add r2.yzw, -r3.xxyz, -r2.yyzw
 292:       add r3.xyz, r4.xyzx, r4.xyzx
 293:       div r2.yzw, r2.yyzw, r3.xxyz
 294:       div r1.yzw, r2.yyzw, r0.wwww
 295:     endif
 296:   endif
 297:   add r2.y, -g_ColorCorrectRange.x, g_ColorCorrectRange.y
 298:   add r2.z, r2.x, -g_ColorCorrectRange.x
 299:   div r2.y, l(1.000000, 1.000000, 1.000000, 1.000000), r2.y
 300:   mul_sat r2.y, r2.y, r2.z
 301:   mad r2.z, r2.y, l(-2.000000), l(3.000000)
 302:   mul r2.y, r2.y, r2.y
 303:   mad r2.y, -r2.z, r2.y, l(1.000000)
 304: else
 305:   mul r3.xyz, r0.xyzx, l(0.010000, 0.010000, 0.010000, 0.000000)
 306:   log r3.xyz, abs(r3.xyzx)
 307:   mul r3.xyz, r3.xyzx, l(0.159302, 0.159302, 0.159302, 0.000000)
 308:   exp r3.xyz, r3.xyzx
 309:   mad r4.xyz, r3.xyzx, l(18.851563, 18.851563, 18.851563, 0.000000), l(0.835938, 0.835938, 0.835938, 0.000000)
 310:   mad r3.xyz, r3.xyzx, l(18.687500, 18.687500, 18.687500, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 311:   div r3.xyz, r4.xyzx, r3.xyzx
 312:   log r3.xyz, r3.xyzx
 313:   mul r3.xyz, r3.xyzx, l(78.843750, 78.843750, 78.843750, 0.000000)
 314:   exp r3.xyz, r3.xyzx
 315:   dp3 r2.z, r3.xyzx, l(0.262700, 0.678000, 0.059300, 0.000000)
 316:   lt r2.z, r2.z, l(1.000000)
 317:   if_nz r2.z
 318:     sample_l(texture3d)(float,float,float,float) r1.yzw, r3.xyzx, g_FarLUT.wxyz, g_LinearClamp, l(0)
 319:   else
 320:     lt r2.z, r0.y, r0.z
 321:     mov r3.xy, r0.zyzz
 322:     mov r3.zw, l(0.000000, 0.000000, -1.000000, 0.666667)
 323:     mov r4.xy, r3.yxyy
 324:     mov r4.zw, l(0.000000, 0.000000, 0.000000, -0.333333)
 325:     movc r3.xyzw, r2.zzzz, r3.xyzw, r4.xyzw
 326:     lt r2.z, r0.x, r3.x
 327:     mov r4.xyz, r3.xywx
 328:     mov r4.w, r0.x
 329:     mov r3.xyw, r4.wywx
 330:     movc r3.xyzw, r2.zzzz, r4.xyzw, r3.xyzw
 331:     min r2.z, r3.y, r3.w
 332:     add r2.z, -r2.z, r3.x
 333:     add r2.w, -r3.y, r3.w
 334:     mad r3.y, r2.z, l(6.000000), l(0.000000)
 335:     rcp r3.y, r3.y
 336:     mad r2.w, r2.w, r3.y, r3.z
 337:     add r3.y, r3.x, l(0.000000)
 338:     div r2.z, r2.z, r3.y
 339:     add r2.w, abs(r2.w), g_ColorCorrectParamFar.y
 340:     frc r2.w, r2.w
 341:     add_sat r2.z, r2.z, g_ColorCorrectParamFar.z
 342:     mul r3.x, r3.x, g_ColorCorrectParamFar.w
 343:     add r3.yzw, r2.wwww, l(0.000000, 1.000000, 0.666667, 0.333333)
 344:     frc r3.yzw, r3.yyzw
 345:     mad r3.yzw, r3.yyzw, l(0.000000, 6.000000, 6.000000, 6.000000), l(0.000000, -3.000000, -3.000000, -3.000000)
 346:     add_sat r3.yzw, abs(r3.yyzw), l(0.000000, -1.000000, -1.000000, -1.000000)
 347:     add r3.yzw, r3.yyzw, l(0.000000, -1.000000, -1.000000, -1.000000)
 348:     mad r3.yzw, r2.zzzz, r3.yyzw, l(0.000000, 1.000000, 1.000000, 1.000000)
 349:     mad r3.xyz, r3.xxxx, r3.yzwy, l(0.000100, 0.000100, 0.000100, 0.000000)
 350:     log r3.xyz, r3.xyzx
 351:     sqrt r2.z, r0.w
 352:     add r2.z, r2.z, l(-0.500000)
 353:     add r3.xyz, -r2.zzzz, r3.xyzx
 354:     add r2.w, l(1.000000), -g_ColorCorrectParamFar.x
 355:     mad r2.z, r2.w, l(0.500000), r2.z
 356:     mad r3.xyz, g_ColorCorrectParamFar.xxxx, r3.xyzx, r2.zzzz
 357:     exp r3.xyz, r3.xyzx
 358:     lt r2.z, l(0.500000), g_ColorCorrectFlg.x
 359:     if_nz r2.z
 360:       mov r4.xyz, l(0, 0, 0, 0)
 361:       mov r5.xyz, l(0, 0, 0, 0)
 362:       mov r2.z, l(1)
 363:       loop
 364:         ige r2.w, r2.z, l(3)
 365:         breakc_nz r2.w
 366:         ishl r2.w, r2.z, l(2)
 367:         iadd r2.w, r2.w, l(-4)
 368:         add r6.xyz, r3.xyzx, -cb2[r2.w + 14].xyzx
 369:         add r7.xyz, -cb2[r2.w + 14].xyzx, cb2[r2.w + 18].xyzx
 370:         div r6.xyz, r6.xyzx, r7.xyzx
 371:         add r7.xyz, -r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 372:         mul r8.xyz, r7.xyzx, r7.xyzx
 373:         mul r8.xyz, r7.xyzx, r8.xyzx
 374:         mul r9.xyz, r7.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 375:         mul r7.xyz, r7.xyzx, r9.xyzx
 376:         mul r7.xyz, r6.xyzx, r7.xyzx
 377:         mul r10.xyz, r6.xyzx, r6.xyzx
 378:         mul r9.xyz, r9.xyzx, r10.xyzx
 379:         mul r10.xyz, r6.xyzx, r10.xyzx
 380:         add r11.xyz, cb2[r2.w + 15].xyzx, cb2[r2.w + 17].xyzx
 381:         add r12.xyz, cb2[r2.w + 19].xyzx, cb2[r2.w + 20].xyzx
 382:         mul r7.xyz, r7.xyzx, r11.xyzx
 383:         mad r7.xyz, cb2[r2.w + 15].xyzx, r8.xyzx, r7.xyzx
 384:         mad r7.xyz, r12.xyzx, r9.xyzx, r7.xyzx
 385:         mad r7.xyz, cb2[r2.w + 19].xyzx, r10.xyzx, r7.xyzx
 386:         ge r8.xyz, r6.xyzx, l(0, 0, 0, 0)
 387:         ge r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 388:         and r8.xyz, r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 389:         movc r6.xyz, r6.xyzx, l(0, 0, 0, 0), r8.xyzx
 390:         mad r4.xyz, r7.xyzx, r6.xyzx, r4.xyzx
 391:         add r5.xyz, r5.xyzx, r6.xyzx
 392:         iadd r2.z, r2.z, l(1)
 393:       endloop
 394:       ge r5.xyz, l(0, 0, 0, 0), r5.xyzx
 395:       movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 396:       ge r6.xyz, g_KeyFar[0].xyzx, r3.xyzx
 397:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 398:       mul r6.xyz, r6.xyzx, g_KeyFar[1].xyzx
 399:       ge r7.xyz, r3.xyzx, g_KeyFar[8].xyzx
 400:       and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 401:       max r8.xyz, r3.xyzx, g_KeyFar[9].xyzx
 402:       mad r4.xyz, r5.xyzx, r4.xyzx, r6.xyzx
 403:       mad r4.xyz, r7.xyzx, r8.xyzx, r4.xyzx
 404:       max r4.xyz, r4.xyzx, l(0, 0, 0, 0)
 405:       mov r5.xyz, l(0, 0, 0, 0)
 406:       mov r6.xyz, l(0, 0, 0, 0)
 407:       mov r2.z, l(1)
 408:       loop
 409:         ige r2.w, r2.z, l(3)
 410:         breakc_nz r2.w
 411:         ishl r2.w, r2.z, l(2)
 412:         iadd r2.w, r2.w, l(-4)
 413:         add r7.xyz, r4.xyzx, -cb2[r2.w + 14].wwww
 414:         add r3.w, -cb2[r2.w + 14].w, cb2[r2.w + 18].w
 415:         div r7.xyz, r7.xyzx, r3.wwww
 416:         add r8.xyz, -r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 417:         mul r9.xyz, r8.xyzx, r8.xyzx
 418:         mul r9.xyz, r8.xyzx, r9.xyzx
 419:         mul r10.xyz, r8.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 420:         mul r8.xyz, r8.xyzx, r10.xyzx
 421:         mul r8.xyz, r7.xyzx, r8.xyzx
 422:         mul r11.xyz, r7.xyzx, r7.xyzx
 423:         mul r10.xyz, r10.xyzx, r11.xyzx
 424:         mul r11.xyz, r7.xyzx, r11.xyzx
 425:         add r3.w, cb2[r2.w + 15].w, cb2[r2.w + 17].w
 426:         add r4.w, cb2[r2.w + 19].w, cb2[r2.w + 20].w
 427:         mul r8.xyz, r8.xyzx, r3.wwww
 428:         mad r8.xyz, cb2[r2.w + 15].wwww, r9.xyzx, r8.xyzx
 429:         mad r8.xyz, r4.wwww, r10.xyzx, r8.xyzx
 430:         mad r8.xyz, cb2[r2.w + 19].wwww, r11.xyzx, r8.xyzx
 431:         ge r9.xyz, r7.xyzx, l(0, 0, 0, 0)
 432:         ge r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 433:         and r9.xyz, r9.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 434:         movc r7.xyz, r7.xyzx, l(0, 0, 0, 0), r9.xyzx
 435:         mad r5.xyz, r8.xyzx, r7.xyzx, r5.xyzx
 436:         add r6.xyz, r6.xyzx, r7.xyzx
 437:         iadd r2.z, r2.z, l(1)
 438:       endloop
 439:       ge r6.xyz, l(0, 0, 0, 0), r6.xyzx
 440:       movc r6.xyz, r6.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 441:       ge r7.xyz, g_KeyFar[0].wwww, r4.xyzx
 442:       and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 443:       mul r7.xyz, r7.xyzx, g_KeyFar[1].wwww
 444:       ge r8.xyz, r4.xyzx, g_KeyFar[8].wwww
 445:       and r8.xyz, r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 446:       max r4.xyz, r4.xyzx, g_KeyFar[9].wwww
 447:       mad r5.xyz, r6.xyzx, r5.xyzx, r7.xyzx
 448:       mad r4.xyz, r8.xyzx, r4.xyzx, r5.xyzx
 449:       max r1.yzw, r4.xxyz, l(0, 0, 0, 0)
 450:     else
 451:       mul r3.xyz, r0.wwww, r3.xyzx
 452:       mad r4.xyz, r3.xyzx, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.050000, 0.050000, 0.050000, 0.000000)
 453:       mad r4.xyz, r3.xyzx, r4.xyzx, l(0.004000, 0.004000, 0.004000, 0.000000)
 454:       mad r5.xyz, r3.xyzx, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
 455:       mad r3.xyz, r3.xyzx, r5.xyzx, l(0.060000, 0.060000, 0.060000, 0.000000)
 456:       div r3.xyz, r4.xyzx, r3.xyzx
 457:       add r3.xyz, r3.xyzx, l(-0.066667, -0.066667, -0.066667, 0.000000)
 458:       mul r4.xyz, r3.xyzx, l(1.379064, 1.379064, 1.379064, 0.000000)
 459:       ge r5.xyz, l(0.002270, 0.002270, 0.002270, 0.000000), r3.xyzx
 460:       mul r3.xyz, r3.xyzx, l(17.817511, 17.817511, 17.817511, 0.000000)
 461:       log r4.xyz, abs(r4.xyzx)
 462:       mul r4.xyz, r4.xyzx, l(0.416667, 0.416667, 0.416667, 0.000000)
 463:       exp r4.xyz, r4.xyzx
 464:       mad r4.xyz, r4.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
 465:       movc r3.xyz, r5.xyzx, r3.xyzx, r4.xyzx
 466:       mov r4.xyz, l(0, 0, 0, 0)
 467:       mov r5.xyz, l(0, 0, 0, 0)
 468:       mov r2.z, l(1)
 469:       loop
 470:         ige r2.w, r2.z, l(3)
 471:         breakc_nz r2.w
 472:         ishl r2.w, r2.z, l(2)
 473:         iadd r2.w, r2.w, l(-4)
 474:         add r6.xyz, r3.xyzx, -cb2[r2.w + 14].xyzx
 475:         add r7.xyz, -cb2[r2.w + 14].xyzx, cb2[r2.w + 18].xyzx
 476:         div r6.xyz, r6.xyzx, r7.xyzx
 477:         add r7.xyz, -r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 478:         mul r8.xyz, r7.xyzx, r7.xyzx
 479:         mul r8.xyz, r7.xyzx, r8.xyzx
 480:         mul r9.xyz, r7.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 481:         mul r7.xyz, r7.xyzx, r9.xyzx
 482:         mul r7.xyz, r6.xyzx, r7.xyzx
 483:         mul r10.xyz, r6.xyzx, r6.xyzx
 484:         mul r9.xyz, r9.xyzx, r10.xyzx
 485:         mul r10.xyz, r6.xyzx, r10.xyzx
 486:         add r11.xyz, cb2[r2.w + 15].xyzx, cb2[r2.w + 17].xyzx
 487:         add r12.xyz, cb2[r2.w + 19].xyzx, cb2[r2.w + 20].xyzx
 488:         mul r7.xyz, r7.xyzx, r11.xyzx
 489:         mad r7.xyz, cb2[r2.w + 15].xyzx, r8.xyzx, r7.xyzx
 490:         mad r7.xyz, r12.xyzx, r9.xyzx, r7.xyzx
 491:         mad r7.xyz, cb2[r2.w + 19].xyzx, r10.xyzx, r7.xyzx
 492:         ge r8.xyz, r6.xyzx, l(0, 0, 0, 0)
 493:         ge r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 494:         and r8.xyz, r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 495:         movc r6.xyz, r6.xyzx, l(0, 0, 0, 0), r8.xyzx
 496:         mad r4.xyz, r7.xyzx, r6.xyzx, r4.xyzx
 497:         add r5.xyz, r5.xyzx, r6.xyzx
 498:         iadd r2.z, r2.z, l(1)
 499:       endloop
 500:       ge r5.xyz, l(0, 0, 0, 0), r5.xyzx
 501:       movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 502:       ge r6.xyz, g_KeyFar[0].xyzx, r3.xyzx
 503:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 504:       mul r6.xyz, r6.xyzx, g_KeyFar[1].xyzx
 505:       ge r7.xyz, r3.xyzx, g_KeyFar[8].xyzx
 506:       and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 507:       max r3.xyz, r3.xyzx, g_KeyFar[9].xyzx
 508:       mad r4.xyz, r5.xyzx, r4.xyzx, r6.xyzx
 509:       mad r3.xyz, r7.xyzx, r3.xyzx, r4.xyzx
 510:       max r3.xyz, r3.xyzx, l(0, 0, 0, 0)
 511:       mov r4.xyz, l(0, 0, 0, 0)
 512:       mov r5.xyz, l(0, 0, 0, 0)
 513:       mov r2.z, l(1)
 514:       loop
 515:         ige r2.w, r2.z, l(3)
 516:         breakc_nz r2.w
 517:         ishl r2.w, r2.z, l(2)
 518:         iadd r2.w, r2.w, l(-4)
 519:         add r6.xyz, r3.xyzx, -cb2[r2.w + 14].wwww
 520:         add r3.w, -cb2[r2.w + 14].w, cb2[r2.w + 18].w
 521:         div r6.xyz, r6.xyzx, r3.wwww
 522:         add r7.xyz, -r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 523:         mul r8.xyz, r7.xyzx, r7.xyzx
 524:         mul r8.xyz, r7.xyzx, r8.xyzx
 525:         mul r9.xyz, r7.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
 526:         mul r7.xyz, r7.xyzx, r9.xyzx
 527:         mul r7.xyz, r6.xyzx, r7.xyzx
 528:         mul r10.xyz, r6.xyzx, r6.xyzx
 529:         mul r9.xyz, r9.xyzx, r10.xyzx
 530:         mul r10.xyz, r6.xyzx, r10.xyzx
 531:         add r3.w, cb2[r2.w + 15].w, cb2[r2.w + 17].w
 532:         add r4.w, cb2[r2.w + 19].w, cb2[r2.w + 20].w
 533:         mul r7.xyz, r7.xyzx, r3.wwww
 534:         mad r7.xyz, cb2[r2.w + 15].wwww, r8.xyzx, r7.xyzx
 535:         mad r7.xyz, r4.wwww, r9.xyzx, r7.xyzx
 536:         mad r7.xyz, cb2[r2.w + 19].wwww, r10.xyzx, r7.xyzx
 537:         ge r8.xyz, r6.xyzx, l(0, 0, 0, 0)
 538:         ge r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 539:         and r8.xyz, r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 540:         movc r6.xyz, r6.xyzx, l(0, 0, 0, 0), r8.xyzx
 541:         mad r4.xyz, r7.xyzx, r6.xyzx, r4.xyzx
 542:         add r5.xyz, r5.xyzx, r6.xyzx
 543:         iadd r2.z, r2.z, l(1)
 544:       endloop
 545:       ge r5.xyz, l(0, 0, 0, 0), r5.xyzx
 546:       movc r5.xyz, r5.xyzx, l(0, 0, 0, 0), l(1.000000, 1.000000, 1.000000, 0.000000)
 547:       ge r6.xyz, g_KeyFar[0].wwww, r3.xyzx
 548:       and r6.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 549:       mul r6.xyz, r6.xyzx, g_KeyFar[1].wwww
 550:       ge r7.xyz, r3.xyzx, g_KeyFar[8].wwww
 551:       and r7.xyz, r7.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 552:       max r3.xyz, r3.xyzx, g_KeyFar[9].wwww
 553:       mad r4.xyz, r5.xyzx, r4.xyzx, r6.xyzx
 554:       mad r3.xyz, r7.xyzx, r3.xyzx, r4.xyzx
 555:       max r3.xyz, r3.xyzx, l(0, 0, 0, 0)
 556:       ge r4.xyz, l(0.039280, 0.039280, 0.039280, 0.000000), r3.xyzx
 557:       mul r5.xyz, r3.xyzx, l(0.077399, 0.077399, 0.077399, 0.000000)
 558:       add r3.xyz, r3.xyzx, l(0.055000, 0.055000, 0.055000, 0.000000)
 559:       mul r3.xyz, r3.xyzx, l(0.947867, 0.947867, 0.947867, 0.000000)
 560:       log r3.xyz, r3.xyzx
 561:       mul r3.xyz, r3.xyzx, l(2.400000, 2.400000, 2.400000, 0.000000)
 562:       exp r3.xyz, r3.xyzx
 563:       movc r3.xyz, r4.xyzx, r5.xyzx, r3.xyzx
 564:       mad r4.xyz, r3.xyzx, l(0.108769, 0.108769, 0.108769, 0.000000), l(-0.005000, -0.005000, -0.005000, 0.000000)
 565:       mad r5.xyz, r3.xyzx, l(0.032631, 0.032631, 0.032631, 0.000000), l(-0.042000, -0.042000, -0.042000, 0.000000)
 566:       mul r3.xyz, r3.xyzx, r5.xyzx
 567:       mul r3.xyz, r3.xyzx, l(0.052209, 0.052209, 0.052209, 0.000000)
 568:       mad r3.xyz, r4.xyzx, r4.xyzx, -r3.xyzx
 569:       sqrt r3.xyz, r3.xyzx
 570:       add r3.xyz, -r4.xyzx, -r3.xyzx
 571:       add r4.xyz, r5.xyzx, r5.xyzx
 572:       div r3.xyz, r3.xyzx, r4.xyzx
 573:       div r1.yzw, r3.xxyz, r0.wwww
 574:     endif
 575:   endif
 576:   add r2.z, -g_ColorCorrectRange.z, g_ColorCorrectRange.w
 577:   add r2.w, r2.x, -g_ColorCorrectRange.z
 578:   div r2.z, l(1.000000, 1.000000, 1.000000, 1.000000), r2.z
 579:   mul_sat r2.z, r2.z, r2.w
 580:   mad r2.w, r2.z, l(-2.000000), l(3.000000)
 581:   mul r2.z, r2.z, r2.z
 582:   mul r2.y, r2.z, r2.w
 583: endif
 584: add r1.yzw, -r0.xxyz, r1.yyzw
 585: mad r0.xyz, r2.yyyy, r1.yzwy, r0.xyzx
 586: lt r1.y, l(0.500000), g_ColorCorrectFlg.z
 587: uge r1.x, r1.x, l(9)
 588: and r1.x, r1.x, r1.y
 589: if_nz r1.x
 590:   ge r1.x, g_CharaColorCorrectRange.y, r2.x
 591:   if_nz r1.x
 592:     lt r1.x, r0.y, r0.z
 593:     mov r3.xy, r0.zyzz
 594:     mov r3.zw, l(0.000000, 0.000000, -1.000000, 0.666667)
 595:     mov r4.xy, r3.yxyy
 596:     mov r4.zw, l(0.000000, 0.000000, 0.000000, -0.333333)
 597:     movc r1.xyzw, r1.xxxx, r3.xyzw, r4.xyzw
 598:     lt r2.y, r0.x, r1.x
 599:     mov r3.xyz, r1.xywx
 600:     mov r3.w, r0.x
 601:     mov r1.xyw, r3.wywx
 602:     movc r1.xyzw, r2.yyyy, r3.xyzw, r1.xyzw
 603:     min r2.y, r1.y, r1.w
 604:     add r2.y, r1.x, -r2.y
 605:     add r1.y, -r1.y, r1.w
 606:     mad r1.w, r2.y, l(6.000000), l(0.000000)
 607:     rcp r1.w, r1.w
 608:     mad r1.y, r1.y, r1.w, r1.z
 609:     add r1.z, r1.x, l(0.000000)
 610:     div r1.z, r2.y, r1.z
 611:     add r1.y, abs(r1.y), g_CharaColorCorrectNearParam.y
 612:     frc r1.y, r1.y
 613:     add_sat r1.z, r1.z, g_CharaColorCorrectNearParam.z
 614:     mul r1.x, r1.x, g_CharaColorCorrectNearParam.w
 615:     add r2.yzw, r1.yyyy, l(0.000000, 1.000000, 0.666667, 0.333333)
 616:     frc r2.yzw, r2.yyzw
 617:     mad r2.yzw, r2.yyzw, l(0.000000, 6.000000, 6.000000, 6.000000), l(0.000000, -3.000000, -3.000000, -3.000000)
 618:     add_sat r2.yzw, abs(r2.yyzw), l(0.000000, -1.000000, -1.000000, -1.000000)
 619:     add r2.yzw, r2.yyzw, l(0.000000, -1.000000, -1.000000, -1.000000)
 620:     mad r1.yzw, r1.zzzz, r2.yyzw, l(0.000000, 1.000000, 1.000000, 1.000000)
 621:     mad r1.xyz, r1.xxxx, r1.yzwy, l(0.000100, 0.000100, 0.000100, 0.000000)
 622:     log r1.xyz, r1.xyzx
 623:     sqrt r1.w, r0.w
 624:     add r1.w, r1.w, l(-0.500000)
 625:     add r1.xyz, -r1.wwww, r1.xyzx
 626:     add r2.y, l(1.000000), -g_CharaColorCorrectNearParam.x
 627:     mad r1.w, r2.y, l(0.500000), r1.w
 628:     mad r1.xyz, g_CharaColorCorrectNearParam.xxxx, r1.xyzx, r1.wwww
 629:     exp r1.xyz, r1.xyzx
 630:     add r1.w, -g_CharaColorCorrectRange.x, g_CharaColorCorrectRange.y
 631:     add r2.y, r2.x, -g_CharaColorCorrectRange.x
 632:     div r1.w, l(1.000000, 1.000000, 1.000000, 1.000000), r1.w
 633:     mul_sat r1.w, r1.w, r2.y
 634:     mad r2.y, r1.w, l(-2.000000), l(3.000000)
 635:     mul r1.w, r1.w, r1.w
 636:     mad r1.w, -r2.y, r1.w, l(1.000000)
 637:   else
 638:     lt r2.y, r0.y, r0.z
 639:     mov r3.xy, r0.zyzz
 640:     mov r3.zw, l(0.000000, 0.000000, -1.000000, 0.666667)
 641:     mov r4.xy, r3.yxyy
 642:     mov r4.zw, l(0.000000, 0.000000, 0.000000, -0.333333)
 643:     movc r3.xyzw, r2.yyyy, r3.xyzw, r4.xyzw
 644:     lt r2.y, r0.x, r3.x
 645:     mov r4.xyz, r3.xywx
 646:     mov r4.w, r0.x
 647:     mov r3.xyw, r4.wywx
 648:     movc r3.xyzw, r2.yyyy, r4.xyzw, r3.xyzw
 649:     min r2.y, r3.y, r3.w
 650:     add r2.y, -r2.y, r3.x
 651:     add r2.z, -r3.y, r3.w
 652:     mad r2.w, r2.y, l(6.000000), l(0.000000)
 653:     rcp r2.w, r2.w
 654:     mad r2.z, r2.z, r2.w, r3.z
 655:     add r2.w, r3.x, l(0.000000)
 656:     div r2.y, r2.y, r2.w
 657:     add r2.z, abs(r2.z), g_CharaColorCorrectFarParam.y
 658:     frc r2.z, r2.z
 659:     add_sat r2.y, r2.y, g_CharaColorCorrectFarParam.z
 660:     mul r2.w, r3.x, g_CharaColorCorrectFarParam.w
 661:     add r3.xyz, r2.zzzz, l(1.000000, 0.666667, 0.333333, 0.000000)
 662:     frc r3.xyz, r3.xyzx
 663:     mad r3.xyz, r3.xyzx, l(6.000000, 6.000000, 6.000000, 0.000000), l(-3.000000, -3.000000, -3.000000, 0.000000)
 664:     add_sat r3.xyz, abs(r3.xyzx), l(-1.000000, -1.000000, -1.000000, 0.000000)
 665:     add r3.xyz, r3.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 666:     mad r3.xyz, r2.yyyy, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 667:     mad r2.yzw, r2.wwww, r3.xxyz, l(0.000000, 0.000100, 0.000100, 0.000100)
 668:     log r2.yzw, r2.yyzw
 669:     sqrt r0.w, r0.w
 670:     add r0.w, r0.w, l(-0.500000)
 671:     add r2.yzw, -r0.wwww, r2.yyzw
 672:     add r3.x, l(1.000000), -g_CharaColorCorrectFarParam.x
 673:     mad r0.w, r3.x, l(0.500000), r0.w
 674:     mad r2.yzw, g_CharaColorCorrectFarParam.xxxx, r2.yyzw, r0.wwww
 675:     exp r1.xyz, r2.yzwy
 676:     add r0.w, -g_CharaColorCorrectRange.z, g_CharaColorCorrectRange.w
 677:     add r2.x, r2.x, -g_CharaColorCorrectRange.z
 678:     div r0.w, l(1.000000, 1.000000, 1.000000, 1.000000), r0.w
 679:     mul_sat r0.w, r0.w, r2.x
 680:     mad r2.x, r0.w, l(-2.000000), l(3.000000)
 681:     mul r0.w, r0.w, r0.w
 682:     mul r1.w, r0.w, r2.x
 683:   endif
 684:   add r1.xyz, -r0.xyzx, r1.xyzx
 685:   mad r0.xyz, r1.wwww, r1.xyzx, r0.xyzx
 686: endif
 687: mov o0.xyz, r0.xyzx
 688: mov o0.w, l(1.000000)
 689: ret
