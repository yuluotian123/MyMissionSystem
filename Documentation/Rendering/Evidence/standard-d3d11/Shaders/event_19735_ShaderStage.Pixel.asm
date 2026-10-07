Shader hash bf208832-c52f16f5-16444b6f-4ddf3f8a

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[34] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb10[61] (ShadowView_Buffer), dynamicIndexed
      dcl_sampler g_Shadow_TexSampler (s3), mode_comparison
      dcl_sampler GatherSampler (s4), mode_default
      dcl_resource_texture2darray (float,float,float,float) g_Shadow_Tex (t3)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_input_ps linear v1.xy
      dcl_output o0.x
      dcl_temps 10
      dcl_indexableTemp x0[3], 4
      dcl_indexableTemp x1[3], 4
   0: ftoi r0.xy, v0.xyxx
   1: mov r0.zw, l(0, 0, 0, 0)
   2: ld_indexable(texture2d)(float,float,float,float) r0.x, r0.xyzw, g_ZBuffer.xyzw
   3: mad r1.x, v1.x, l(2.000000), g_ProjectionOffset.x
   4: mad r1.y, v1.y, l(-2.000000), g_ProjectionOffset.y
   5: div r2.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[0].x
   6: div r2.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[1].y
   7: add r0.yz, r1.xxyx, l(0.000000, -1.000000, 1.000000, 0.000000)
   8: mad r0.x, r0.x, g_CameraParam.y, g_CameraParam.x
   9: mul r0.yz, r0.xxxx, r0.yyzy
  10: mul r1.xy, r2.xyxx, r0.yzyy
  11: mov r1.z, -r0.x
  12: mov r1.w, l(1.000000)
  13: dp4 r0.x, r1.xyzw, g_ViewInverseMatrix[0].xyzw
  14: dp4 r0.y, r1.xyzw, g_ViewInverseMatrix[1].xyzw
  15: dp4 r0.z, r1.xyzw, g_ViewInverseMatrix[2].xyzw
  16: add r1.xyz, -r0.xyzx, g_CameraVec.xyzx
  17: dp3 r1.x, r1.xyzx, r1.xyzx
  18: sqrt r1.x, r1.x
  19: mov x0[0].x, l(1.000000)
  20: mov x0[1].x, l(0.080000)
  21: mov x0[2].x, l(0.025000)
  22: add r2.xyzw, g_ShadowSpritLength.xyzy, l(-0.500000, -0.500000, -0.500000, 0.500000)
  23: mov x1[0].x, r2.x
  24: mov x1[1].x, r2.y
  25: mov x1[2].x, r2.z
  26: lt r1.yz, r2.yyxy, r1.xxxx
  27: ge r1.w, r2.w, r1.x
  28: and r1.w, r1.w, r1.y
  29: add r2.x, g_ShadowSpritLength.x, l(0.500000)
  30: ge r2.x, r2.x, r1.x
  31: and r2.x, r1.z, r2.x
  32: or r1.w, r1.w, r2.x
  33: movc r1.y, r1.y, l(2), l(1)
  34: and r1.y, r1.y, r1.z
  35: ishl r1.z, r1.y, l(2)
  36: mov r0.w, l(1.000000)
  37: dp4 r2.x, r0.xyzw, cb10[r1.z + 3].xyzw
  38: mov r2.y, x0[r1.y + 0].x
  39: and r2.z, g_FrameCount[0].x, l(0x80000000)
  40: imax r2.w, g_FrameCount[0].x, -g_FrameCount[0].x
  41: udiv null, r2.w, r2.w, l(100)
  42: ineg r3.x, r2.w
  43: movc r2.z, r2.z, r3.x, r2.w
  44: itof r2.z, r2.z
  45: add r2.z, r2.z, l(0.010000)
  46: mul r2.zw, r2.zzzz, v1.xxxy
  47: dp2 r2.z, r2.zwzz, l(12.989800, 78.233002, 0.000000, 0.000000)
  48: sincos r2.z, null, r2.z
  49: mul r2.z, r2.z, l(43758.546875)
  50: frc r2.z, r2.z
  51: mul r2.z, r2.z, l(6.283185)
  52: ge r2.w, r2.x, l(0)
  53: if_nz r2.w
  54:   dp4 r3.x, r0.xyzw, cb10[r1.z + 1].xyzw
  55:   dp4 r3.y, r0.xyzw, cb10[r1.z + 2].xyzw
  56:   dp4 r2.w, r0.xyzw, cb10[r1.z + 4].xyzw
  57:   div r3.xy, r3.xyxx, r2.wwww
  58:   mad r3.xy, r3.xyxx, l(0.500000, -0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
  59:   mul r2.y, r2.y, l(0.854167)
  60:   mul r2.w, r2.y, g_ShadowMapConstants.Param[1].x
  61:   mul r2.w, r2.w, g_ShadowPenumbraScale.x
  62:   itof r3.z, r1.y
  63:   mov r4.xy, l(0, 0, 0, 0)
  64:   mov r3.w, l(0)
  65:   loop
  66:     ige r4.z, r3.w, l(8)
  67:     breakc_nz r4.z
  68:     ishl r4.z, r3.w, l(2)
  69:     itof r4.z, r4.z
  70:     mad r4.w, r4.z, l(2.400000), r2.z
  71:     imad r5.xyz, r3.wwww, l(4, 4, 4, 0), l(1, 2, 3, 0)
  72:     itof r5.xyz, r5.xyzx
  73:     mad r5.xyz, r5.xyzx, l(2.400000, 2.400000, 2.400000, 0.000000), r2.zzzz
  74:     sincos r6.x, null, r4.w
  75:     sincos r6.yzw, null, r5.xxyz
  76:     add r5.xyzw, r4.zzzz, l(0.500000, 1.500000, 2.500000, 3.500000)
  77:     mul r5.xyzw, r5.xyzw, l(0.031250, 0.031250, 0.031250, 0.031250)
  78:     sqrt r5.xyzw, r5.xyzw
  79:     mul r5.xyzw, r5.xyzw, r6.xyzw
  80:     mul r5.xyzw, r2.wwww, r5.xyzw
  81:     mul r5.xyzw, r5.xyzw, g_ShadowMapConstants.Param[0].yyyy
  82:     ftoi r5.xyzw, r5.xyzw
  83:     gather4_po(texture2darray)(float,float,float,float) r4.z, r3.xyzx, r5.xxxx, g_Shadow_Tex.yzxw, GatherSampler.x
  84:     gather4_po(texture2darray)(float,float,float,float) r4.w, r3.xyzx, r5.yyyy, g_Shadow_Tex.xzwy, GatherSampler.x
  85:     gather4_po(texture2darray)(float,float,float,float) r5.x, r3.xyzx, r5.zzzz, g_Shadow_Tex.zxyw, GatherSampler.x
  86:     gather4_po(texture2darray)(float,float,float,float) r5.y, r3.xyzx, r5.wwww, g_Shadow_Tex.xwyz, GatherSampler.x
  87:     lt r5.z, r2.x, r4.z
  88:     add r6.x, r4.x, l(1.000000)
  89:     add r5.w, r2.x, -r4.z
  90:     div r4.z, r5.w, r4.z
  91:     mul r4.z, r4.z, r4.z
  92:     mul r4.z, r4.z, l(128.000000)
  93:     min r4.z, r4.z, l(1.000000)
  94:     add r6.y, r4.z, r4.y
  95:     movc r5.zw, r5.zzzz, r6.xxxy, r4.xxxy
  96:     lt r4.z, r2.x, r4.w
  97:     add r6.x, r5.z, l(1.000000)
  98:     add r6.z, r2.x, -r4.w
  99:     div r4.w, r6.z, r4.w
 100:     mul r4.w, r4.w, r4.w
 101:     mul r4.w, r4.w, l(128.000000)
 102:     min r4.w, r4.w, l(1.000000)
 103:     add r6.y, r4.w, r5.w
 104:     movc r4.zw, r4.zzzz, r6.xxxy, r5.zzzw
 105:     lt r5.z, r2.x, r5.x
 106:     add r6.x, r4.z, l(1.000000)
 107:     add r5.w, r2.x, -r5.x
 108:     div r5.x, r5.w, r5.x
 109:     mul r5.x, r5.x, r5.x
 110:     mul r5.x, r5.x, l(128.000000)
 111:     min r5.x, r5.x, l(1.000000)
 112:     add r6.y, r4.w, r5.x
 113:     movc r4.zw, r5.zzzz, r6.xxxy, r4.zzzw
 114:     lt r5.x, r2.x, r5.y
 115:     add r6.x, r4.z, l(1.000000)
 116:     add r5.z, r2.x, -r5.y
 117:     div r5.y, r5.z, r5.y
 118:     mul r5.y, r5.y, r5.y
 119:     mul r5.y, r5.y, l(128.000000)
 120:     min r5.y, r5.y, l(1.000000)
 121:     add r6.y, r4.w, r5.y
 122:     movc r4.xy, r5.xxxx, r6.xyxx, r4.zwzz
 123:     iadd r3.w, r3.w, l(1)
 124:   endloop
 125:   div r2.w, r4.y, r4.x
 126:   ge r3.w, l(0), r4.x
 127:   mul r2.w, r2.w, g_ShadowPenumbraScale.x
 128:   movc r2.w, r3.w, l(0), r2.w
 129:   mul r2.y, r2.y, r2.w
 130:   mad r2.y, r2.y, l(24.000000), l(1.500000)
 131:   mov r4.z, r3.z
 132:   mov r5.z, r4.z
 133:   mov r2.w, l(0)
 134:   mov r3.z, l(0)
 135:   loop
 136:     ige r3.w, r3.z, l(6)
 137:     breakc_nz r3.w
 138:     ishl r3.w, r3.z, l(2)
 139:     itof r3.w, r3.w
 140:     mad r6.x, r3.w, l(2.400000), r2.z
 141:     imad r7.xyz, r3.zzzz, l(4, 4, 4, 0), l(1, 2, 3, 0)
 142:     itof r7.xyz, r7.xyzx
 143:     mad r6.yzw, r7.xxyz, l(0.000000, 2.400000, 2.400000, 2.400000), r2.zzzz
 144:     sincos r6.xyzw, r7.xyzw, r6.xyzw
 145:     add r8.xyzw, r3.wwww, l(0.500000, 1.500000, 2.500000, 3.500000)
 146:     mul r8.xyzw, r8.xyzw, l(0.041667, 0.041667, 0.041667, 0.041667)
 147:     sqrt r8.xyzw, r8.xyzw
 148:     mov r9.xz, r6.xxyx
 149:     mov r9.yw, r7.xxxy
 150:     mul r9.xyzw, r8.xxyy, r9.xyzw
 151:     mov r6.xz, r6.zzwz
 152:     mov r6.yw, r7.zzzw
 153:     mul r6.xyzw, r8.zzww, r6.xyzw
 154:     mul r7.xyzw, r2.yyyy, r9.xyzw
 155:     mad r4.xy, r7.xyxx, g_ShadowMapConstants.Param[0].zwzz, r3.xyxx
 156:     sample_c_lz(texture2darray)(float,float,float,float) r3.w, r4.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r2.x
 157:     mad r3.w, r3.w, l(0.041667), r2.w
 158:     mad r4.xy, r7.zwzz, g_ShadowMapConstants.Param[0].zwzz, r3.xyxx
 159:     sample_c_lz(texture2darray)(float,float,float,float) r4.x, r4.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r2.x
 160:     mad r3.w, r4.x, l(0.041667), r3.w
 161:     mul r6.xyzw, r2.yyyy, r6.xyzw
 162:     mad r5.xy, r6.xyxx, g_ShadowMapConstants.Param[0].zwzz, r3.xyxx
 163:     sample_c_lz(texture2darray)(float,float,float,float) r4.x, r5.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r2.x
 164:     mad r3.w, r4.x, l(0.041667), r3.w
 165:     mad r5.xy, r6.zwzz, g_ShadowMapConstants.Param[0].zwzz, r3.xyxx
 166:     sample_c_lz(texture2darray)(float,float,float,float) r4.x, r5.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r2.x
 167:     mad r2.w, r4.x, l(0.041667), r3.w
 168:     iadd r3.z, r3.z, l(1)
 169:   endloop
 170: else
 171:   mov r2.w, l(1.000000)
 172: endif
 173: mov r2.x, x1[r1.y + 0].x
 174: add_sat r2.x, r1.x, -r2.x
 175: add r2.y, -r2.w, l(1.000000)
 176: mad r2.x, r2.x, r2.y, r2.w
 177: if_nz r1.w
 178:   iadd r1.z, r1.z, l(-4)
 179:   dp4 r3.x, r0.xyzw, cb10[r1.z + 1].xyzw
 180:   dp4 r3.y, r0.xyzw, cb10[r1.z + 2].xyzw
 181:   dp4 r1.w, r0.xyzw, cb10[r1.z + 3].xyzw
 182:   dp4 r0.x, r0.xyzw, cb10[r1.z + 4].xyzw
 183:   div r0.xy, r3.xyxx, r0.xxxx
 184:   mad r0.xy, r0.xyxx, l(0.500000, -0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
 185:   iadd r0.w, r1.y, l(-1)
 186:   mov r1.y, x0[r0.w + 0].x
 187:   ge r1.z, r1.w, l(0)
 188:   if_nz r1.z
 189:     mul r1.y, r1.y, l(0.854167)
 190:     mul r1.z, r1.y, g_ShadowMapConstants.Param[1].x
 191:     mul r1.z, r1.z, g_ShadowPenumbraScale.x
 192:     itof r0.z, r0.w
 193:     mov r2.yw, l(0, 0, 0, 0)
 194:     mov r3.x, l(0)
 195:     loop
 196:       ige r3.y, r3.x, l(8)
 197:       breakc_nz r3.y
 198:       ishl r3.y, r3.x, l(2)
 199:       itof r3.y, r3.y
 200:       mad r3.z, r3.y, l(2.400000), r2.z
 201:       imad r4.xyz, r3.xxxx, l(4, 4, 4, 0), l(1, 2, 3, 0)
 202:       itof r4.xyz, r4.xyzx
 203:       mad r4.xyz, r4.xyzx, l(2.400000, 2.400000, 2.400000, 0.000000), r2.zzzz
 204:       sincos r5.x, null, r3.z
 205:       sincos r5.yzw, null, r4.xxyz
 206:       add r4.xyzw, r3.yyyy, l(0.500000, 1.500000, 2.500000, 3.500000)
 207:       mul r4.xyzw, r4.xyzw, l(0.031250, 0.031250, 0.031250, 0.031250)
 208:       sqrt r4.xyzw, r4.xyzw
 209:       mul r4.xyzw, r4.xyzw, r5.xyzw
 210:       mul r4.xyzw, r1.zzzz, r4.xyzw
 211:       mul r4.xyzw, r4.xyzw, g_ShadowMapConstants.Param[0].yyyy
 212:       ftoi r4.xyzw, r4.xyzw
 213:       gather4_po(texture2darray)(float,float,float,float) r3.y, r0.xyzx, r4.xxxx, g_Shadow_Tex.yxzw, GatherSampler.x
 214:       gather4_po(texture2darray)(float,float,float,float) r3.z, r0.xyzx, r4.yyyy, g_Shadow_Tex.xzyw, GatherSampler.x
 215:       gather4_po(texture2darray)(float,float,float,float) r3.w, r0.xyzx, r4.zzzz, g_Shadow_Tex.xywz, GatherSampler.x
 216:       gather4_po(texture2darray)(float,float,float,float) r4.x, r0.xyzx, r4.wwww, g_Shadow_Tex.wxyz, GatherSampler.x
 217:       lt r4.y, r1.w, r3.y
 218:       add r5.x, r2.y, l(1.000000)
 219:       add r4.zw, r1.wwww, -r3.yyyz
 220:       div r3.y, r4.z, r3.y
 221:       mul r3.y, r3.y, r3.y
 222:       mul r3.y, r3.y, l(128.000000)
 223:       min r3.y, r3.y, l(1.000000)
 224:       add r5.y, r2.w, r3.y
 225:       movc r4.yz, r4.yyyy, r5.xxyx, r2.yywy
 226:       lt r3.y, r1.w, r3.z
 227:       add r5.x, r4.y, l(1.000000)
 228:       div r3.z, r4.w, r3.z
 229:       mul r3.z, r3.z, r3.z
 230:       mul r3.z, r3.z, l(128.000000)
 231:       min r3.z, r3.z, l(1.000000)
 232:       add r5.y, r3.z, r4.z
 233:       movc r3.yz, r3.yyyy, r5.xxyx, r4.yyzy
 234:       lt r4.y, r1.w, r3.w
 235:       add r5.x, r3.y, l(1.000000)
 236:       add r4.z, r1.w, -r3.w
 237:       div r3.w, r4.z, r3.w
 238:       mul r3.w, r3.w, r3.w
 239:       mul r3.w, r3.w, l(128.000000)
 240:       min r3.w, r3.w, l(1.000000)
 241:       add r5.y, r3.w, r3.z
 242:       movc r3.yz, r4.yyyy, r5.xxyx, r3.yyzy
 243:       lt r3.w, r1.w, r4.x
 244:       add r5.x, r3.y, l(1.000000)
 245:       add r4.y, r1.w, -r4.x
 246:       div r4.x, r4.y, r4.x
 247:       mul r4.x, r4.x, r4.x
 248:       mul r4.x, r4.x, l(128.000000)
 249:       min r4.x, r4.x, l(1.000000)
 250:       add r5.y, r3.z, r4.x
 251:       movc r2.yw, r3.wwww, r5.xxxy, r3.yyyz
 252:       iadd r3.x, r3.x, l(1)
 253:     endloop
 254:     div r1.z, r2.w, r2.y
 255:     ge r2.y, l(0), r2.y
 256:     mul r1.z, r1.z, g_ShadowPenumbraScale.x
 257:     movc r1.z, r2.y, l(0), r1.z
 258:     mul r1.y, r1.y, r1.z
 259:     mad r1.y, r1.y, l(24.000000), l(1.500000)
 260:     mov r3.z, r0.z
 261:     mov r4.z, r3.z
 262:     mov r0.z, l(0)
 263:     mov r1.z, l(0)
 264:     loop
 265:       ige r2.y, r1.z, l(6)
 266:       breakc_nz r2.y
 267:       ishl r2.y, r1.z, l(2)
 268:       itof r2.y, r2.y
 269:       mad r5.x, r2.y, l(2.400000), r2.z
 270:       imad r6.xyz, r1.zzzz, l(4, 4, 4, 0), l(1, 2, 3, 0)
 271:       itof r6.xyz, r6.xyzx
 272:       mad r5.yzw, r6.xxyz, l(0.000000, 2.400000, 2.400000, 2.400000), r2.zzzz
 273:       sincos r5.xyzw, r6.xyzw, r5.xyzw
 274:       add r7.xyzw, r2.yyyy, l(0.500000, 1.500000, 2.500000, 3.500000)
 275:       mul r7.xyzw, r7.xyzw, l(0.041667, 0.041667, 0.041667, 0.041667)
 276:       sqrt r7.xyzw, r7.xyzw
 277:       mov r8.xz, r5.xxyx
 278:       mov r8.yw, r6.xxxy
 279:       mul r8.xyzw, r7.xxyy, r8.xyzw
 280:       mov r5.xz, r5.zzwz
 281:       mov r5.yw, r6.zzzw
 282:       mul r5.xyzw, r7.zzww, r5.xyzw
 283:       mul r6.xyzw, r1.yyyy, r8.xyzw
 284:       mad r3.xy, r6.xyxx, g_ShadowMapConstants.Param[0].zwzz, r0.xyxx
 285:       sample_c_lz(texture2darray)(float,float,float,float) r2.y, r3.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r1.w
 286:       mad r2.y, r2.y, l(0.041667), r0.z
 287:       mad r3.xy, r6.zwzz, g_ShadowMapConstants.Param[0].zwzz, r0.xyxx
 288:       sample_c_lz(texture2darray)(float,float,float,float) r2.w, r3.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r1.w
 289:       mad r2.y, r2.w, l(0.041667), r2.y
 290:       mul r5.xyzw, r1.yyyy, r5.xyzw
 291:       mad r4.xy, r5.xyxx, g_ShadowMapConstants.Param[0].zwzz, r0.xyxx
 292:       sample_c_lz(texture2darray)(float,float,float,float) r2.w, r4.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r1.w
 293:       mad r2.y, r2.w, l(0.041667), r2.y
 294:       mad r4.xy, r5.zwzz, g_ShadowMapConstants.Param[0].zwzz, r0.xyxx
 295:       sample_c_lz(texture2darray)(float,float,float,float) r2.w, r4.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r1.w
 296:       mad r0.z, r2.w, l(0.041667), r2.y
 297:       iadd r1.z, r1.z, l(1)
 298:     endloop
 299:   else
 300:     mov r0.z, l(1.000000)
 301:   endif
 302:   mov r0.x, x1[r0.w + 0].x
 303:   add_sat r0.x, -r0.x, r1.x
 304:   add r0.y, -r0.z, r2.x
 305:   mad o0.x, r0.x, r0.y, r0.z
 306: else
 307:   mov o0.x, r2.x
 308: endif
 309: ret
