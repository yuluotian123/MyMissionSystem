Shader hash c0c089d1-4cfaad3d-70320b78-178d54dd

// Note: shader requires additional functionality:
//       Typed UAV Load Additional Formats
//
cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb12[1] (HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb10[61] (ShadowView_Buffer), immediateIndexed
      dcl_constantbuffer cb7[2] (PrecomputeValue_Buffer), immediateIndexed
      dcl_sampler g_PointLightShadowMapsSampler (s9), mode_default
      dcl_sampler g_SubtractLightTextureSampler (s12), mode_default
      dcl_sampler g_PointLightMaskMapsSampler (s13), mode_default
      dcl_sampler g_textureGgxDFVSampler (s15), mode_default
      dcl_resource_structured g_PointLightArray (t6), 160
      dcl_resource_structured g_PerTileLightIndex (t7), 4
      dcl_resource_texture2darray (float,float,float,float) g_PointLightShadowMaps (t9)
      dcl_resource_texture2d (float,float,float,float) g_SubtractLightTexture (t12)
      dcl_resource_texture2darray (float,float,float,float) g_PointLightMaskMaps (t13)
      dcl_resource_structured g_PointLightShadowMapArray (t14), 64
      dcl_resource_texture2d (float,float,float,float) g_textureGgxDFV (t15)
      dcl_resource_structured g_PointLightMaskMapViewArray (t16), 64
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer00 (t20)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer01 (t21)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer02 (t22)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_resource_texture2d (uint,uint,uint,uint) g_StencilBuffer (t25)
      dcl_uav_typed_texture2d (float,float,float,float) ResultDiffuse (u4)
      dcl_input vThreadID.xy
      dcl_temps 36
      dcl_thread_group 8, 8, 1
   0: ftou r0.xy, g_TargetUvParam.zwzz
   1: uge r0.xy, vThreadID.xyxx, r0.xyxx
   2: or r0.x, r0.y, r0.x
   3: if_nz r0.x
   4:   ret
   5: endif
   6: ushr r0.x, vThreadID.x, l(5)
   7: udiv r0.y, null, vThreadID.y, l(30)
   8: utof r0.xy, r0.xyxx
   9: mad r0.x, r0.y, g_TileScaleAndSize.z, r0.x
  10: ftou r0.x, r0.x
  11: iadd r0.y, l(1), g_TileLimitNum.x
  12: imul null, r0.z, r0.y, r0.x
  13: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.z, r0.z, l(0), g_PerTileLightIndex.xxxx
  14: ieq r0.w, r0.z, l(0x0000ffff)
  15: if_nz r0.w
  16:   ret
  17: endif
  18: utof r1.xy, vThreadID.xyxx
  19: div r1.zw, r1.xxxy, g_TargetUvParam.zzzw
  20: bufinfo_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r0.w, g_PointLightArray.yzwx
  21: ftoi r2.xy, r1.xyxx
  22: mov r2.zw, l(0, 0, 0, 0)
  23: ld_indexable(texture2d)(float,float,float,float) r3.xyzw, r2.xyww, g_GeometryBuffer00.xyzw
  24: ld_indexable(texture2d)(float,float,float,float) r1.xy, r2.xyww, g_GeometryBuffer01.xyzw
  25: ld_indexable(texture2d)(float,float,float,float) r4.xyz, r2.xyww, g_GeometryBuffer02.xyzw
  26: ld_indexable(texture2d)(float,float,float,float) r4.w, r2.xyww, g_ZBuffer.yzwx
  27: ld_indexable(texture2d)(uint,uint,uint,uint) r2.x, r2.xyzw, g_StencilBuffer.yxzw
  28: and r2.xy, r2.xxxx, l(15, 128, 0, 0)
  29: movc r2.y, r2.y, l(9), l(0)
  30: iadd r2.x, r2.y, r2.x
  31: mul r2.y, r3.w, l(255.000000)
  32: round_ne r2.y, r2.y
  33: ftou r2.y, r2.y
  34: mad r4.xyz, r4.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(-1.000000, -1.000000, -1.000000, 0.000000)
  35: dp3 r2.z, r4.xyzx, r4.xyzx
  36: rsq r2.z, r2.z
  37: mul r4.xyz, r2.zzzz, r4.xyzx
  38: mad r5.x, r1.z, l(2.000000), g_ProjectionOffset.x
  39: mad r5.y, r1.w, l(-2.000000), g_ProjectionOffset.y
  40: div r6.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[0].x
  41: div r6.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[1].y
  42: add r2.zw, r5.xxxy, l(0.000000, 0.000000, -1.000000, 1.000000)
  43: mad r3.w, r4.w, g_CameraParam.y, g_CameraParam.x
  44: mul r2.zw, r2.zzzw, r3.wwww
  45: mul r5.xy, r6.xyxx, r2.zwzz
  46: mov r5.z, -r3.w
  47: mov r5.w, l(1.000000)
  48: dp4 r6.x, r5.xyzw, g_ViewInverseMatrix[0].xyzw
  49: dp4 r6.y, r5.xyzw, g_ViewInverseMatrix[1].xyzw
  50: dp4 r6.z, r5.xyzw, g_ViewInverseMatrix[2].xyzw
  51: dp3 r2.z, -r5.xyzx, -r5.xyzx
  52: rsq r2.z, r2.z
  53: mul r7.xyz, r2.zzzz, -r5.xyzx
  54: and r2.y, r2.y, l(64)
  55: movc r1.x, r2.y, l(0), r1.x
  56: ishl r2.x, l(1), r2.x
  57: add r8.xyz, r3.xyzx, l(-0.040000, -0.040000, -0.040000, 0.000000)
  58: mad r8.xyz, r1.xxxx, r8.xyzx, l(0.040000, 0.040000, 0.040000, 0.000000)
  59: dp3 r2.y, -r7.xyzx, r4.xyzx
  60: add r2.y, r2.y, r2.y
  61: mad r7.xyz, r4.xyzx, -r2.yyyy, -r7.xyzx
  62: dp3 r2.y, r7.xyzx, r7.xyzx
  63: rsq r2.y, r2.y
  64: mul r7.xyz, r2.yyyy, r7.xyzx
  65: sample_l(texture2d)(float,float,float,float) r9.xyz, r1.zwzz, g_SubtractLightTexture.xyzw, g_SubtractLightTextureSampler, l(0)
  66: dp2 r1.z, r6.xyxx, l(12.989800, 78.233002, 0.000000, 0.000000)
  67: sincos r1.z, null, r1.z
  68: mul r1.z, r1.z, l(43758.546875)
  69: frc r1.z, r1.z
  70: add r10.xyzw, r1.zzzz, l(9.600000, 12.000000, 14.400001, 16.800001)
  71: sincos r10.x, r11.x, r10.x
  72: mov r11.y, r10.x
  73: mul r2.yw, r11.xxxy, l(0.000000, 0.530330, 0.000000, 0.530330)
  74: sincos r10.x, r11.x, r10.y
  75: mov r11.y, r10.x
  76: mul r10.xy, r11.xyxx, l(0.586302, 0.586302, 0.000000, 0.000000)
  77: sincos r11.x, r12.x, r10.z
  78: mov r12.y, r11.x
  79: mul r11.xy, r12.xyxx, l(0.637377, 0.637377, 0.000000, 0.000000)
  80: sincos r12.x, r13.x, r10.w
  81: mov r13.y, r12.x
  82: mul r10.zw, r13.xxxy, l(0.000000, 0.000000, 0.684653, 0.684653)
  83: add r12.xyzw, r1.zzzz, l(19.200001, 21.600000, 24.000000, 26.400002)
  84: sincos r12.x, r13.x, r12.x
  85: mov r13.y, r12.x
  86: mul r11.zw, r13.xxxy, l(0.000000, 0.000000, 0.728869, 0.728869)
  87: sincos r12.x, r13.x, r12.y
  88: mov r13.y, r12.x
  89: mul r12.xy, r13.xyxx, l(0.770552, 0.770552, 0.000000, 0.000000)
  90: sincos r13.x, r14.x, r12.z
  91: mov r14.y, r13.x
  92: mul r13.xy, r14.xyxx, l(0.810093, 0.810093, 0.000000, 0.000000)
  93: sincos r14.x, r15.x, r12.w
  94: mov r15.y, r14.x
  95: mul r12.zw, r15.xxxy, l(0.000000, 0.000000, 0.847791, 0.847791)
  96: add r14.xyzw, r1.zzzz, l(28.800001, 31.200001, 33.600002, 36.000000)
  97: sincos r14.x, r15.x, r14.x
  98: mov r15.y, r14.x
  99: mul r13.zw, r15.xxxy, l(0.000000, 0.000000, 0.883883, 0.883883)
 100: sincos r14.x, r15.x, r14.y
 101: mov r15.y, r14.x
 102: mul r14.xy, r15.xyxx, l(0.918559, 0.918559, 0.000000, 0.000000)
 103: sincos r15.x, r16.x, r14.z
 104: mov r16.y, r15.x
 105: mul r15.xy, r16.xyxx, l(0.951972, 0.951972, 0.000000, 0.000000)
 106: sincos r16.x, r17.x, r14.w
 107: mov r17.y, r16.x
 108: mul r14.zw, r17.xxxy, l(0.000000, 0.000000, 0.984251, 0.984251)
 109: add r16.xyzw, r1.zzzz, l(38.400002, 40.800003, 43.200001, 45.600002)
 110: sincos r16.x, r17.x, r16.x
 111: mov r17.y, r16.x
 112: mul r1.zw, r17.xxxy, l(0.000000, 0.000000, 1.015505, 1.015505)
 113: sincos r16.x, r17.x, r16.y
 114: mov r17.y, r16.x
 115: mul r15.zw, r17.xxxy, l(0.000000, 0.000000, 1.045825, 1.045825)
 116: sincos r16.x, r17.x, r16.z
 117: mov r17.y, r16.x
 118: mul r16.xy, r17.xyxx, l(1.075291, 1.075291, 0.000000, 0.000000)
 119: sincos r17.x, r18.x, r16.w
 120: mov r18.y, r17.x
 121: mul r16.zw, r18.xxxy, l(0.000000, 0.000000, 1.103970, 1.103970)
 122: add r17.xyz, -r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 123: add r1.x, -r1.x, l(1.000000)
 124: mov r6.w, l(1.000000)
 125: mov r18.xyz, r6.xyzx
 126: mov r18.w, l(1.000000)
 127: mov r19.xyz, l(0, 0, 0, 0)
 128: mov r20.xyz, l(0, 0, 0, 0)
 129: mov r3.w, l(0)
 130: mov r4.w, r0.z
 131: loop
 132:   ieq r5.w, r4.w, l(0x0000ffff)
 133:   breakc_nz r5.w
 134:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r21.xyzw, r4.w, l(96), g_PointLightArray.xyzw
 135:   ftou r5.w, r21.w
 136:   and r5.w, r2.x, r5.w
 137:   ine r5.w, r2.x, r5.w
 138:   if_nz r5.w
 139:     iadd r5.w, r3.w, l(1)
 140:     imad r7.w, r0.x, r0.y, r5.w
 141:     ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r7.w, r7.w, l(0), g_PerTileLightIndex.xxxx
 142:     ult r8.w, r0.w, r5.w
 143:     movc r7.w, r8.w, l(0x0000ffff), r7.w
 144:     mov r3.w, r5.w
 145:     mov r4.w, r7.w
 146:     continue
 147:   endif
 148:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r22.xyzw, r4.w, l(0), g_PointLightArray.xyzw
 149:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r23.xyzw, r4.w, l(16), g_PointLightArray.xyzw
 150:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r24.xyzw, r4.w, l(32), g_PointLightArray.xyzw
 151:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r25.xyz, r4.w, l(112), g_PointLightArray.xyzx
 152:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r26.xyzw, r4.w, l(128), g_PointLightArray.xyzw
 153:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r27.xyz, r4.w, l(144), g_PointLightArray.xyzx
 154:   add r28.xyz, -r5.xyzx, r23.xyzx
 155:   dp3 r5.w, r28.xyzx, r28.xyzx
 156:   ftou r7.w, r25.x
 157:   and r7.w, r7.w, l(1)
 158:   ftoi r25.xw, r27.xxxy
 159:   ige r27.yw, r25.xxxw, l(0, 0, 0, 0)
 160:   and r8.w, r27.w, r27.y
 161:   if_nz r8.w
 162:     ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r29.xyzw, r25.w, l(0), g_PointLightMaskMapViewArray.xyzw
 163:     ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r30.xyzw, r25.w, l(16), g_PointLightMaskMapViewArray.xyzw
 164:     ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r31.xyzw, r25.w, l(32), g_PointLightMaskMapViewArray.xyzw
 165:     dp4 r29.x, r6.xyzw, r29.xyzw
 166:     dp4 r29.y, r6.xyzw, r30.xyzw
 167:     dp4 r29.z, r6.xyzw, r31.xyzw
 168:     dp3 r8.w, r29.xyzx, r29.xyzx
 169:     sqrt r8.w, r8.w
 170:     div r29.xyz, r29.xyzx, r8.wwww
 171:     ge r8.w, r29.z, l(0)
 172:     movc r25.xw, r8.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 173:     mul r8.w, r29.x, r25.x
 174:     add r27.yw, abs(r29.zzzz), l(0.000000, 1.000000, 0.000000, 1.000000)
 175:     div r8.w, r8.w, r27.y
 176:     add r8.w, r25.x, r8.w
 177:     add r30.x, r8.w, r25.w
 178:     div r8.w, r29.y, r27.w
 179:     mad r8.w, r8.w, l(0.500000), l(0.500000)
 180:     mov r30.y, -r8.w
 181:     add r25.xw, r30.xxxy, l(-0.500000, 0.000000, 0.000000, 0.500000)
 182:     div r25.xw, r25.xxxw, r27.zzzz
 183:     add_sat r29.xy, r25.xwxx, l(0.500000, 0.500000, 0.000000, 0.000000)
 184:     round_z r29.z, r27.x
 185:     sample_l(texture2darray)(float,float,float,float) r8.w, r29.xyzx, g_PointLightMaskMaps.yzwx, g_PointLightMaskMapsSampler, l(0)
 186:   else
 187:     mov r8.w, l(1.000000)
 188:   endif
 189:   and r25.xw, r26.wwww, l(2, 0, 0, 4)
 190:   mul r9.w, r22.w, r22.w
 191:   mul r9.w, r5.w, r9.w
 192:   mad r9.w, -r9.w, r9.w, l(1.000000)
 193:   max r9.w, r9.w, l(0)
 194:   mul r9.w, r9.w, r9.w
 195:   mul r17.w, r26.x, r26.x
 196:   mul r17.w, r9.w, r17.w
 197:   mul r27.xy, r9.wwww, l(3.392920, 339.292023, 0.000000, 0.000000)
 198:   sincos r26.x, r27.x, r27.x
 199:   mul r9.w, r26.x, r27.x
 200:   movc r9.w, r25.x, r9.w, l(1.000000)
 201:   mul r9.w, r9.w, r17.w
 202:   sincos r17.w, null, r27.y
 203:   mul r17.w, r17.w, l(0.200000)
 204:   movc r17.w, r25.w, r17.w, l(1.000000)
 205:   mul r9.w, r9.w, r17.w
 206:   lt r17.w, l(0), r26.y
 207:   if_nz r17.w
 208:     and r17.w, r26.w, l(1)
 209:     add r22.xyz, -r6.xyzx, r22.xyzx
 210:     dp3 r19.w, r22.xyzx, r22.xyzx
 211:     sqrt r19.w, r19.w
 212:     add r19.w, -r26.y, r19.w
 213:     rcp r20.w, r26.z
 214:     mul r20.w, r19.w, r20.w
 215:     mul r20.w, r20.w, l(10.000000)
 216:     round_pi_sat r21.w, r19.w
 217:     mul r20.w, r20.w, r20.w
 218:     lt r22.x, l(0), r19.w
 219:     lt r19.w, r19.w, l(0)
 220:     iadd r19.w, -r22.x, r19.w
 221:     itof r19.w, r19.w
 222:     mul_sat r19.w, r19.w, r20.w
 223:     add r19.w, -r21.w, r19.w
 224:     movc r17.w, r17.w, r19.w, l(0)
 225:     add r17.w, r17.w, r21.w
 226:     mul r9.w, r9.w, r17.w
 227:   endif
 228:   ge r17.w, r21.x, l(0)
 229:   if_nz r17.w
 230:     rcp r17.w, r22.w
 231:     ftou r21.yw, r21.yyyx
 232:     ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r22.xyzw, r21.w, l(0), g_PointLightShadowMapArray.xyzw
 233:     ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r26.xyzw, r21.w, l(16), g_PointLightShadowMapArray.xyzw
 234:     ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r27.xyzw, r21.w, l(32), g_PointLightShadowMapArray.xyzw
 235:     dp4 r22.x, r18.xyzw, r22.xyzw
 236:     dp4 r22.y, r18.xyzw, r26.xyzw
 237:     dp4 r22.z, r18.xyzw, r27.xyzw
 238:     dp3 r19.w, r22.xyzx, r22.xyzx
 239:     sqrt r19.w, r19.w
 240:     div r22.xyz, r22.xyzx, r19.wwww
 241:     add r19.w, -r24.w, r19.w
 242:     add r17.w, -r24.w, r17.w
 243:     div r17.w, r19.w, r17.w
 244:     mul r26.xyz, r22.zxyz, l(1.000000, 0.000000, 0.000000, 0.000000)
 245:     mad r26.xyz, r22.yzxy, l(0.000000, 0.000000, 1.000000, 0.000000), -r26.xyzx
 246:     dp2 r19.w, r26.xzxx, r26.xzxx
 247:     rsq r19.w, r19.w
 248:     mul r26.xyz, r19.wwww, r26.xyzx
 249:     mul r27.xyz, r22.zxyz, r26.yzxy
 250:     mad r27.xyz, r22.yzxy, r26.zxyz, -r27.xyzx
 251:     mul r26.xyz, r26.xyzx, g_ShadowMapConstants.Param[1].yyyy
 252:     mul r27.xyz, r27.xyzx, g_ShadowMapConstants.Param[1].yyyy
 253:     mad r29.xyz, r26.xyzx, r2.yyyy, r22.xyzx
 254:     mad r29.xyz, r27.xyzx, r2.wwww, r29.xyzx
 255:     ge r19.w, r29.z, l(0)
 256:     movc r20.w, r19.w, r21.w, r21.y
 257:     movc r25.xw, r19.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 258:     mul r19.w, r29.x, r25.x
 259:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 260:     div r19.w, r19.w, r29.x
 261:     add r19.w, r25.x, r19.w
 262:     add r30.x, r19.w, r25.w
 263:     div r19.w, r29.y, r29.z
 264:     mad r19.w, r19.w, l(0.500000), l(0.500000)
 265:     add r30.y, -r19.w, l(1.000000)
 266:     itof r30.z, r20.w
 267:     sample_l(texture2darray)(float,float,float,float) r19.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 268:     add r19.w, r21.z, r19.w
 269:     lt r19.w, r19.w, r17.w
 270:     movc r19.w, r19.w, l(0), l(1.000000)
 271:     mad r29.xyz, r26.xyzx, r10.xxxx, r22.xyzx
 272:     mad r29.xyz, r27.xyzx, r10.yyyy, r29.xyzx
 273:     ge r20.w, r29.z, l(0)
 274:     movc r22.w, r20.w, r21.w, r21.y
 275:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 276:     mul r20.w, r29.x, r25.x
 277:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 278:     div r20.w, r20.w, r29.x
 279:     add r20.w, r25.x, r20.w
 280:     add r30.x, r20.w, r25.w
 281:     div r20.w, r29.y, r29.z
 282:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 283:     add r30.y, -r20.w, l(1.000000)
 284:     itof r30.z, r22.w
 285:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 286:     add r20.w, r21.z, r20.w
 287:     lt r20.w, r20.w, r17.w
 288:     movc r20.w, r20.w, l(0), l(1.000000)
 289:     add r19.w, r19.w, r20.w
 290:     mad r29.xyz, r26.xyzx, r11.xxxx, r22.xyzx
 291:     mad r29.xyz, r27.xyzx, r11.yyyy, r29.xyzx
 292:     ge r20.w, r29.z, l(0)
 293:     movc r22.w, r20.w, r21.w, r21.y
 294:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 295:     mul r20.w, r29.x, r25.x
 296:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 297:     div r20.w, r20.w, r29.x
 298:     add r20.w, r25.x, r20.w
 299:     add r30.x, r20.w, r25.w
 300:     div r20.w, r29.y, r29.z
 301:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 302:     add r30.y, -r20.w, l(1.000000)
 303:     itof r30.z, r22.w
 304:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 305:     add r20.w, r21.z, r20.w
 306:     lt r20.w, r20.w, r17.w
 307:     movc r20.w, r20.w, l(0), l(1.000000)
 308:     add r19.w, r19.w, r20.w
 309:     mad r29.xyz, r26.xyzx, r10.zzzz, r22.xyzx
 310:     mad r29.xyz, r27.xyzx, r10.wwww, r29.xyzx
 311:     ge r20.w, r29.z, l(0)
 312:     movc r22.w, r20.w, r21.w, r21.y
 313:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 314:     mul r20.w, r29.x, r25.x
 315:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 316:     div r20.w, r20.w, r29.x
 317:     add r20.w, r25.x, r20.w
 318:     add r30.x, r20.w, r25.w
 319:     div r20.w, r29.y, r29.z
 320:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 321:     add r30.y, -r20.w, l(1.000000)
 322:     itof r30.z, r22.w
 323:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 324:     add r20.w, r21.z, r20.w
 325:     lt r20.w, r20.w, r17.w
 326:     movc r20.w, r20.w, l(0), l(1.000000)
 327:     add r19.w, r19.w, r20.w
 328:     mad r29.xyz, r26.xyzx, r11.zzzz, r22.xyzx
 329:     mad r29.xyz, r27.xyzx, r11.wwww, r29.xyzx
 330:     ge r20.w, r29.z, l(0)
 331:     movc r22.w, r20.w, r21.w, r21.y
 332:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 333:     mul r20.w, r29.x, r25.x
 334:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 335:     div r20.w, r20.w, r29.x
 336:     add r20.w, r25.x, r20.w
 337:     add r30.x, r20.w, r25.w
 338:     div r20.w, r29.y, r29.z
 339:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 340:     add r30.y, -r20.w, l(1.000000)
 341:     itof r30.z, r22.w
 342:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 343:     add r20.w, r21.z, r20.w
 344:     lt r20.w, r20.w, r17.w
 345:     movc r20.w, r20.w, l(0), l(1.000000)
 346:     add r19.w, r19.w, r20.w
 347:     mad r29.xyz, r26.xyzx, r12.xxxx, r22.xyzx
 348:     mad r29.xyz, r27.xyzx, r12.yyyy, r29.xyzx
 349:     ge r20.w, r29.z, l(0)
 350:     movc r22.w, r20.w, r21.w, r21.y
 351:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 352:     mul r20.w, r29.x, r25.x
 353:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 354:     div r20.w, r20.w, r29.x
 355:     add r20.w, r25.x, r20.w
 356:     add r30.x, r20.w, r25.w
 357:     div r20.w, r29.y, r29.z
 358:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 359:     add r30.y, -r20.w, l(1.000000)
 360:     itof r30.z, r22.w
 361:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 362:     add r20.w, r21.z, r20.w
 363:     lt r20.w, r20.w, r17.w
 364:     movc r20.w, r20.w, l(0), l(1.000000)
 365:     add r19.w, r19.w, r20.w
 366:     mad r29.xyz, r26.xyzx, r13.xxxx, r22.xyzx
 367:     mad r29.xyz, r27.xyzx, r13.yyyy, r29.xyzx
 368:     ge r20.w, r29.z, l(0)
 369:     movc r22.w, r20.w, r21.w, r21.y
 370:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 371:     mul r20.w, r29.x, r25.x
 372:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 373:     div r20.w, r20.w, r29.x
 374:     add r20.w, r25.x, r20.w
 375:     add r30.x, r20.w, r25.w
 376:     div r20.w, r29.y, r29.z
 377:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 378:     add r30.y, -r20.w, l(1.000000)
 379:     itof r30.z, r22.w
 380:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 381:     add r20.w, r21.z, r20.w
 382:     lt r20.w, r20.w, r17.w
 383:     movc r20.w, r20.w, l(0), l(1.000000)
 384:     add r19.w, r19.w, r20.w
 385:     mad r29.xyz, r26.xyzx, r12.zzzz, r22.xyzx
 386:     mad r29.xyz, r27.xyzx, r12.wwww, r29.xyzx
 387:     ge r20.w, r29.z, l(0)
 388:     movc r22.w, r20.w, r21.w, r21.y
 389:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 390:     mul r20.w, r29.x, r25.x
 391:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 392:     div r20.w, r20.w, r29.x
 393:     add r20.w, r25.x, r20.w
 394:     add r30.x, r20.w, r25.w
 395:     div r20.w, r29.y, r29.z
 396:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 397:     add r30.y, -r20.w, l(1.000000)
 398:     itof r30.z, r22.w
 399:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 400:     add r20.w, r21.z, r20.w
 401:     lt r20.w, r20.w, r17.w
 402:     movc r20.w, r20.w, l(0), l(1.000000)
 403:     add r19.w, r19.w, r20.w
 404:     mad r29.xyz, r26.xyzx, r13.zzzz, r22.xyzx
 405:     mad r29.xyz, r27.xyzx, r13.wwww, r29.xyzx
 406:     ge r20.w, r29.z, l(0)
 407:     movc r22.w, r20.w, r21.w, r21.y
 408:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 409:     mul r20.w, r29.x, r25.x
 410:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 411:     div r20.w, r20.w, r29.x
 412:     add r20.w, r25.x, r20.w
 413:     add r30.x, r20.w, r25.w
 414:     div r20.w, r29.y, r29.z
 415:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 416:     add r30.y, -r20.w, l(1.000000)
 417:     itof r30.z, r22.w
 418:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 419:     add r20.w, r21.z, r20.w
 420:     lt r20.w, r20.w, r17.w
 421:     movc r20.w, r20.w, l(0), l(1.000000)
 422:     add r19.w, r19.w, r20.w
 423:     mad r29.xyz, r26.xyzx, r14.xxxx, r22.xyzx
 424:     mad r29.xyz, r27.xyzx, r14.yyyy, r29.xyzx
 425:     ge r20.w, r29.z, l(0)
 426:     movc r22.w, r20.w, r21.w, r21.y
 427:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 428:     mul r20.w, r29.x, r25.x
 429:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 430:     div r20.w, r20.w, r29.x
 431:     add r20.w, r25.x, r20.w
 432:     add r30.x, r20.w, r25.w
 433:     div r20.w, r29.y, r29.z
 434:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 435:     add r30.y, -r20.w, l(1.000000)
 436:     itof r30.z, r22.w
 437:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 438:     add r20.w, r21.z, r20.w
 439:     lt r20.w, r20.w, r17.w
 440:     movc r20.w, r20.w, l(0), l(1.000000)
 441:     add r19.w, r19.w, r20.w
 442:     mad r29.xyz, r26.xyzx, r15.xxxx, r22.xyzx
 443:     mad r29.xyz, r27.xyzx, r15.yyyy, r29.xyzx
 444:     ge r20.w, r29.z, l(0)
 445:     movc r22.w, r20.w, r21.w, r21.y
 446:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 447:     mul r20.w, r29.x, r25.x
 448:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 449:     div r20.w, r20.w, r29.x
 450:     add r20.w, r25.x, r20.w
 451:     add r30.x, r20.w, r25.w
 452:     div r20.w, r29.y, r29.z
 453:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 454:     add r30.y, -r20.w, l(1.000000)
 455:     itof r30.z, r22.w
 456:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 457:     add r20.w, r21.z, r20.w
 458:     lt r20.w, r20.w, r17.w
 459:     movc r20.w, r20.w, l(0), l(1.000000)
 460:     add r19.w, r19.w, r20.w
 461:     mad r29.xyz, r26.xyzx, r14.zzzz, r22.xyzx
 462:     mad r29.xyz, r27.xyzx, r14.wwww, r29.xyzx
 463:     ge r20.w, r29.z, l(0)
 464:     movc r22.w, r20.w, r21.w, r21.y
 465:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 466:     mul r20.w, r29.x, r25.x
 467:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 468:     div r20.w, r20.w, r29.x
 469:     add r20.w, r25.x, r20.w
 470:     add r30.x, r20.w, r25.w
 471:     div r20.w, r29.y, r29.z
 472:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 473:     add r30.y, -r20.w, l(1.000000)
 474:     itof r30.z, r22.w
 475:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 476:     add r20.w, r21.z, r20.w
 477:     lt r20.w, r20.w, r17.w
 478:     movc r20.w, r20.w, l(0), l(1.000000)
 479:     add r19.w, r19.w, r20.w
 480:     mad r29.xyz, r26.xyzx, r1.zzzz, r22.xyzx
 481:     mad r29.xyz, r27.xyzx, r1.wwww, r29.xyzx
 482:     ge r20.w, r29.z, l(0)
 483:     movc r22.w, r20.w, r21.w, r21.y
 484:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 485:     mul r20.w, r29.x, r25.x
 486:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 487:     div r20.w, r20.w, r29.x
 488:     add r20.w, r25.x, r20.w
 489:     add r30.x, r20.w, r25.w
 490:     div r20.w, r29.y, r29.z
 491:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 492:     add r30.y, -r20.w, l(1.000000)
 493:     itof r30.z, r22.w
 494:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 495:     add r20.w, r21.z, r20.w
 496:     lt r20.w, r20.w, r17.w
 497:     movc r20.w, r20.w, l(0), l(1.000000)
 498:     add r19.w, r19.w, r20.w
 499:     mad r29.xyz, r26.xyzx, r15.zzzz, r22.xyzx
 500:     mad r29.xyz, r27.xyzx, r15.wwww, r29.xyzx
 501:     ge r20.w, r29.z, l(0)
 502:     movc r22.w, r20.w, r21.w, r21.y
 503:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 504:     mul r20.w, r29.x, r25.x
 505:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 506:     div r20.w, r20.w, r29.x
 507:     add r20.w, r25.x, r20.w
 508:     add r30.x, r20.w, r25.w
 509:     div r20.w, r29.y, r29.z
 510:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 511:     add r30.y, -r20.w, l(1.000000)
 512:     itof r30.z, r22.w
 513:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 514:     add r20.w, r21.z, r20.w
 515:     lt r20.w, r20.w, r17.w
 516:     movc r20.w, r20.w, l(0), l(1.000000)
 517:     add r19.w, r19.w, r20.w
 518:     mad r29.xyz, r26.xyzx, r16.xxxx, r22.xyzx
 519:     mad r29.xyz, r27.xyzx, r16.yyyy, r29.xyzx
 520:     ge r20.w, r29.z, l(0)
 521:     movc r22.w, r20.w, r21.w, r21.y
 522:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 523:     mul r20.w, r29.x, r25.x
 524:     add r29.xz, abs(r29.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 525:     div r20.w, r20.w, r29.x
 526:     add r20.w, r25.x, r20.w
 527:     add r30.x, r20.w, r25.w
 528:     div r20.w, r29.y, r29.z
 529:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 530:     add r30.y, -r20.w, l(1.000000)
 531:     itof r30.z, r22.w
 532:     sample_l(texture2darray)(float,float,float,float) r20.w, r30.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 533:     add r20.w, r21.z, r20.w
 534:     lt r20.w, r20.w, r17.w
 535:     movc r20.w, r20.w, l(0), l(1.000000)
 536:     add r19.w, r19.w, r20.w
 537:     mad r22.xyz, r26.xyzx, r16.zzzz, r22.xyzx
 538:     mad r22.xyz, r27.xyzx, r16.wwww, r22.xyzx
 539:     ge r20.w, r22.z, l(0)
 540:     movc r21.y, r20.w, r21.w, r21.y
 541:     movc r25.xw, r20.wwww, l(0.500000, 0.000000, 0.000000, -0.000000), l(-0.500000, 0.000000, 0.000000, 1.000000)
 542:     mul r20.w, r22.x, r25.x
 543:     add r22.xz, abs(r22.zzzz), l(1.000000, 0.000000, 1.000000, 0.000000)
 544:     div r20.w, r20.w, r22.x
 545:     add r20.w, r25.x, r20.w
 546:     add r26.x, r20.w, r25.w
 547:     div r20.w, r22.y, r22.z
 548:     mad r20.w, r20.w, l(0.500000), l(0.500000)
 549:     add r26.y, -r20.w, l(1.000000)
 550:     itof r26.z, r21.y
 551:     sample_l(texture2darray)(float,float,float,float) r20.w, r26.xyzx, g_PointLightShadowMaps.yzwx, g_PointLightShadowMapsSampler, l(0)
 552:     add r20.w, r21.z, r20.w
 553:     lt r17.w, r20.w, r17.w
 554:     movc r17.w, r17.w, l(0), l(1.000000)
 555:     add r17.w, r17.w, r19.w
 556:     mul r17.w, r17.w, l(0.062500)
 557:   else
 558:     mov r17.w, l(1.000000)
 559:   endif
 560:   if_nz r7.w
 561:     lt r7.w, r21.x, l(0)
 562:     if_nz r7.w
 563:       iadd r7.w, r3.w, l(1)
 564:       imad r19.w, r0.x, r0.y, r7.w
 565:       ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r19.w, r19.w, l(0), g_PerTileLightIndex.xxxx
 566:       ult r20.w, r0.w, r7.w
 567:       movc r19.w, r20.w, l(0x0000ffff), r19.w
 568:       mov r3.w, r7.w
 569:       mov r4.w, r19.w
 570:       continue
 571:     endif
 572:     add r7.w, -r17.w, l(1.000000)
 573:     mul r7.w, r9.w, r7.w
 574:     mad r21.xyz, r7.wwww, -r19.xyzx, r19.xyzx
 575:     mad r22.xyz, r7.wwww, -r20.xyzx, r20.xyzx
 576:     iadd r7.w, r3.w, l(1)
 577:     imad r19.w, r0.x, r0.y, r7.w
 578:     ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r19.w, r19.w, l(0), g_PerTileLightIndex.xxxx
 579:     ult r20.w, r0.w, r7.w
 580:     movc r19.w, r20.w, l(0x0000ffff), r19.w
 581:     mov r3.w, r7.w
 582:     mov r4.w, r19.w
 583:     mov r19.xyz, r21.xyzx
 584:     mov r20.xyz, r22.xyzx
 585:     continue
 586:   endif
 587:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r21.xyz, r4.w, l(48), g_PointLightArray.xyzx
 588:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r22.xyzw, r4.w, l(64), g_PointLightArray.xyzw
 589:   ld_structured_indexable(structured_buffer, stride=160)(mixed,mixed,mixed,mixed) r26.xyzw, r4.w, l(80), g_PointLightArray.xywz
 590:   rsq r7.w, r5.w
 591:   mul r27.xyz, r7.wwww, r28.xyzx
 592:   add r24.xyz, -r9.xyzx, r24.xyzx
 593:   max r24.xyz, r24.xyzx, l(0, 0, 0, 0)
 594:   ftou r7.w, r22.w
 595:   dp3 r19.w, -r21.xyzx, r27.xyzx
 596:   mad_sat r19.w, r19.w, r26.x, r26.y
 597:   mul r8.w, r8.w, r19.w
 598:   mul r8.w, r17.w, r8.w
 599:   ieq r25.xw, r7.wwww, l(0, 0, 0, 5)
 600:   or r17.w, r25.w, r25.x
 601:   if_nz r17.w
 602:     sqrt r17.w, r5.w
 603:     mul r17.w, r17.w, l(3.000000)
 604:     div r17.w, r24.w, r17.w
 605:     add_sat r29.z, r1.y, r17.w
 606:     mad r30.xyz, -r5.xyzx, r2.zzzz, r27.xyzx
 607:     dp3 r17.w, r30.xyzx, r30.xyzx
 608:     rsq r17.w, r17.w
 609:     mul r30.xyz, r17.wwww, r30.xyzx
 610:     dp3_sat r17.w, r4.xyzx, r27.xyzx
 611:     dp3_sat r29.x, r27.xyzx, r30.xyzx
 612:     dp3_sat r19.w, r4.xyzx, r30.xyzx
 613:     mul r19.w, r19.w, r19.w
 614:     mul r29.y, r19.w, r19.w
 615:     sample_l(texture2d)(float,float,float,float) r19.w, r29.yzyy, g_textureGgxDFV.yzwx, g_textureGgxDFVSampler, l(0)
 616:     sample_l(texture2d)(float,float,float,float) r25.xw, r29.xzxx, g_textureGgxDFV.yxwz, g_textureGgxDFVSampler, l(0)
 617:     mul r29.xyz, r17.xyzx, r25.wwww
 618:     mad r29.xyz, r8.xyzx, r25.xxxx, r29.xyzx
 619:     mul r19.w, r17.w, r19.w
 620:     mul r29.xyz, r29.xyzx, r19.wwww
 621:     max r19.w, r5.w, l(0.010000)
 622:     rcp r19.w, r19.w
 623:     mul r17.w, r17.w, r19.w
 624:     mul r17.w, r17.w, r26.w
 625:   else
 626:     ieq r19.w, r7.w, l(1)
 627:     if_nz r19.w
 628:       dp3 r19.w, r28.xyzx, r7.xyzx
 629:       mad r30.xyz, r19.wwww, r7.xyzx, -r28.xyzx
 630:       dp3 r19.w, r30.xyzx, r30.xyzx
 631:       sqrt r19.w, r19.w
 632:       div_sat r19.w, r24.w, r19.w
 633:       mad r30.xyz, r30.xyzx, r19.wwww, r28.xyzx
 634:       dp3 r19.w, r30.xyzx, r30.xyzx
 635:       sqrt r20.w, r19.w
 636:       rsq r19.w, r19.w
 637:       mul r30.xyz, r19.wwww, r30.xyzx
 638:       mul r19.w, r20.w, l(3.000000)
 639:       div r19.w, r24.w, r19.w
 640:       add_sat r31.z, r1.y, r19.w
 641:       mad r32.xyz, -r5.xyzx, r2.zzzz, r30.xyzx
 642:       dp3 r19.w, r32.xyzx, r32.xyzx
 643:       rsq r19.w, r19.w
 644:       mul r32.xyz, r19.wwww, r32.xyzx
 645:       dp3_sat r19.w, r4.xyzx, r30.xyzx
 646:       dp3_sat r31.x, r30.xyzx, r32.xyzx
 647:       dp3_sat r20.w, r4.xyzx, r32.xyzx
 648:       mul r20.w, r20.w, r20.w
 649:       mul r31.y, r20.w, r20.w
 650:       sample_l(texture2d)(float,float,float,float) r20.w, r31.yzyy, g_textureGgxDFV.yzwx, g_textureGgxDFVSampler, l(0)
 651:       sample_l(texture2d)(float,float,float,float) r25.xw, r31.xzxx, g_textureGgxDFV.yxwz, g_textureGgxDFVSampler, l(0)
 652:       mul r30.xyz, r17.xyzx, r25.wwww
 653:       mad r30.xyz, r8.xyzx, r25.xxxx, r30.xyzx
 654:       mul r19.w, r19.w, r20.w
 655:       mul r29.xyz, r30.xyzx, r19.wwww
 656:       mul r19.w, r24.w, r24.w
 657:       dp3 r20.w, r4.xyzx, r27.xyzx
 658:       max r20.w, r20.w, l(-0.999000)
 659:       min r20.w, r20.w, l(0.999000)
 660:       div r19.w, r19.w, r5.w
 661:       min r19.w, r19.w, l(0.999900)
 662:       mul r21.w, r20.w, r20.w
 663:       mad r22.w, -r20.w, r20.w, l(1.000000)
 664:       sqrt r22.w, r22.w
 665:       lt r21.w, r19.w, r21.w
 666:       mul r25.x, r19.w, l(3.141593)
 667:       max r25.w, r20.w, l(0)
 668:       mul r25.x, r25.w, r25.x
 669:       div r25.w, l(1.000000, 1.000000, 1.000000, 1.000000), r19.w
 670:       add r25.w, r25.w, l(-1.000000)
 671:       sqrt r25.w, r25.w
 672:       div r27.w, r20.w, r22.w
 673:       mul r27.w, -r25.w, r27.w
 674:       mad r28.w, -r27.w, r27.w, l(1.000000)
 675:       sqrt r28.w, r28.w
 676:       mul r22.w, r22.w, r28.w
 677:       add r28.w, -abs(r27.w), l(1.000000)
 678:       sqrt r28.w, r28.w
 679:       mad r29.w, abs(r27.w), l(-0.018729), l(0.074261)
 680:       mad r29.w, r29.w, abs(r27.w), l(-0.212114)
 681:       mad r29.w, r29.w, abs(r27.w), l(1.570729)
 682:       mul r30.x, r28.w, r29.w
 683:       mad r30.x, r30.x, l(-2.000000), l(3.141593)
 684:       lt r27.w, r27.w, -r27.w
 685:       and r27.w, r27.w, r30.x
 686:       mad r27.w, r29.w, r28.w, r27.w
 687:       mul r28.w, r22.w, r25.w
 688:       mad r20.w, r20.w, r27.w, -r28.w
 689:       div r22.w, r22.w, r25.w
 690:       min r25.w, r22.w, l(1.000000)
 691:       max r27.w, r22.w, l(1.000000)
 692:       div r27.w, l(1.000000, 1.000000, 1.000000, 1.000000), r27.w
 693:       mul r25.w, r25.w, r27.w
 694:       mul r27.w, r25.w, r25.w
 695:       mad r28.w, r27.w, l(0.020835), l(-0.085133)
 696:       mad r28.w, r27.w, r28.w, l(0.180141)
 697:       mad r28.w, r27.w, r28.w, l(-0.330299)
 698:       mad r27.w, r27.w, r28.w, l(0.999866)
 699:       mul r28.w, r25.w, r27.w
 700:       lt r22.w, l(1.000000), r22.w
 701:       mad r28.w, r28.w, l(-2.000000), l(1.570796)
 702:       and r22.w, r22.w, r28.w
 703:       mad r22.w, r25.w, r27.w, r22.w
 704:       mad r19.w, r20.w, r19.w, r22.w
 705:       movc r19.w, r21.w, r25.x, r19.w
 706:       max r19.w, r19.w, l(0)
 707:       mul r17.w, r19.w, r26.w
 708:     else
 709:       ieq r19.w, r7.w, l(2)
 710:       if_nz r19.w
 711:         dp3 r19.w, -r21.xyzx, r7.xyzx
 712:         dp3 r20.w, r28.xyzx, -r21.xyzx
 713:         ge r21.w, r20.w, l(0)
 714:         ge r22.w, l(0.000001), abs(r19.w)
 715:         ieq r21.w, r21.w, l(-1)
 716:         movc r21.w, r22.w, l(0), r21.w
 717:         if_nz r21.w
 718:           div r19.w, r20.w, r19.w
 719:           mad r30.xyz, r7.xyzx, r19.wwww, r5.xyzx
 720:           add r30.xyz, -r23.xyzx, r30.xyzx
 721:           dp3 r19.w, r30.xyzx, r30.xyzx
 722:           sqrt r19.w, r19.w
 723:           div_sat r19.w, r24.w, r19.w
 724:           mul r30.xyz, r19.wwww, r30.xyzx
 725:           mul r31.xyz, r21.xyzx, l(-5.000000, -5.000000, -5.000000, 0.000000)
 726:           dp3_sat r19.w, r7.xyzx, r31.xyzx
 727:           mad r30.xyz, r19.wwww, r30.xyzx, r28.xyzx
 728:           dp3 r19.w, r30.xyzx, r30.xyzx
 729:           sqrt r20.w, r19.w
 730:           rsq r19.w, r19.w
 731:           mul r30.xyz, r19.wwww, r30.xyzx
 732:           mul r19.w, r20.w, l(3.000000)
 733:           div r19.w, r24.w, r19.w
 734:           add_sat r31.z, r1.y, r19.w
 735:           mad r32.xyz, -r5.xyzx, r2.zzzz, r30.xyzx
 736:           dp3 r19.w, r32.xyzx, r32.xyzx
 737:           rsq r19.w, r19.w
 738:           mul r32.xyz, r19.wwww, r32.xyzx
 739:           dp3_sat r19.w, r4.xyzx, r30.xyzx
 740:           dp3_sat r31.x, r30.xyzx, r32.xyzx
 741:           dp3_sat r20.w, r4.xyzx, r32.xyzx
 742:           mul r20.w, r20.w, r20.w
 743:           mul r31.y, r20.w, r20.w
 744:           sample_l(texture2d)(float,float,float,float) r20.w, r31.yzyy, g_textureGgxDFV.yzwx, g_textureGgxDFVSampler, l(0)
 745:           sample_l(texture2d)(float,float,float,float) r25.xw, r31.xzxx, g_textureGgxDFV.yxwz, g_textureGgxDFVSampler, l(0)
 746:           mul r30.xyz, r17.xyzx, r25.wwww
 747:           mad r30.xyz, r8.xyzx, r25.xxxx, r30.xyzx
 748:           mul r19.w, r19.w, r20.w
 749:           mul r29.xyz, r30.xyzx, r19.wwww
 750:           mul r19.w, r24.w, r24.w
 751:           dp3 r20.w, r4.xyzx, r27.xyzx
 752:           max r20.w, r20.w, l(-0.999000)
 753:           min r20.w, r20.w, l(0.999000)
 754:           max r5.w, r5.w, r19.w
 755:           mad r5.w, r24.w, r24.w, r5.w
 756:           div r5.w, r19.w, r5.w
 757:           mul r19.w, r20.w, r20.w
 758:           mad r21.w, -r20.w, r20.w, l(1.000000)
 759:           sqrt r21.w, r21.w
 760:           lt r19.w, r5.w, r19.w
 761:           mul r22.w, r5.w, l(3.141593)
 762:           max r24.w, r20.w, l(0)
 763:           mul r22.w, r22.w, r24.w
 764:           div r24.w, l(1.000000, 1.000000, 1.000000, 1.000000), r5.w
 765:           add r24.w, r24.w, l(-1.000000)
 766:           sqrt r24.w, r24.w
 767:           div r25.x, r20.w, r21.w
 768:           mul r25.x, -r24.w, r25.x
 769:           mad r25.w, -r25.x, r25.x, l(1.000000)
 770:           sqrt r25.w, r25.w
 771:           mul r21.w, r21.w, r25.w
 772:           add r25.w, -abs(r25.x), l(1.000000)
 773:           sqrt r25.w, r25.w
 774:           mad r27.w, abs(r25.x), l(-0.018729), l(0.074261)
 775:           mad r27.w, r27.w, abs(r25.x), l(-0.212114)
 776:           mad r27.w, r27.w, abs(r25.x), l(1.570729)
 777:           mul r28.w, r25.w, r27.w
 778:           mad r28.w, r28.w, l(-2.000000), l(3.141593)
 779:           lt r25.x, r25.x, -r25.x
 780:           and r25.x, r25.x, r28.w
 781:           mad r25.x, r27.w, r25.w, r25.x
 782:           mul r25.w, r21.w, r24.w
 783:           mad r20.w, r20.w, r25.x, -r25.w
 784:           div r21.w, r21.w, r24.w
 785:           min r24.w, r21.w, l(1.000000)
 786:           max r25.x, r21.w, l(1.000000)
 787:           div r25.x, l(1.000000, 1.000000, 1.000000, 1.000000), r25.x
 788:           mul r24.w, r24.w, r25.x
 789:           mul r25.x, r24.w, r24.w
 790:           mad r25.w, r25.x, l(0.020835), l(-0.085133)
 791:           mad r25.w, r25.x, r25.w, l(0.180141)
 792:           mad r25.w, r25.x, r25.w, l(-0.330299)
 793:           mad r25.x, r25.x, r25.w, l(0.999866)
 794:           mul r25.w, r24.w, r25.x
 795:           lt r21.w, l(1.000000), r21.w
 796:           mad r25.w, r25.w, l(-2.000000), l(1.570796)
 797:           and r21.w, r21.w, r25.w
 798:           mad r21.w, r24.w, r25.x, r21.w
 799:           mad r5.w, r20.w, r5.w, r21.w
 800:           movc r5.w, r19.w, r22.w, r5.w
 801:           max r5.w, r5.w, l(0)
 802:           dp3_sat r19.w, r21.xyzx, -r27.xyzx
 803:           mul r5.w, r5.w, r19.w
 804:           mul r17.w, r5.w, r26.w
 805:         else
 806:           mov r29.xyz, l(0, 0, 0, 0)
 807:           mov r17.w, l(0)
 808:         endif
 809:       else
 810:         ieq r5.w, r7.w, l(3)
 811:         if_nz r5.w
 812:           dp3 r5.w, -r21.xyzx, r7.xyzx
 813:           dp3 r7.w, r28.xyzx, -r21.xyzx
 814:           ge r19.w, r7.w, l(0)
 815:           ge r20.w, l(0.000001), abs(r5.w)
 816:           ieq r19.w, r19.w, l(-1)
 817:           movc r19.w, r20.w, l(0), r19.w
 818:           if_nz r19.w
 819:             mov r26.xy, r22.xyxx
 820:             mul r30.xyz, r21.zxyz, r26.yzxy
 821:             mad r30.xyz, r21.yzxy, r26.zxyz, -r30.xyzx
 822:             div r5.w, r7.w, r5.w
 823:             mad r31.xyz, r7.xyzx, r5.wwww, r5.xyzx
 824:             add r31.xyz, -r23.xyzx, r31.xyzx
 825:             dp3 r5.w, r31.xyzx, r26.xyzx
 826:             max r5.w, -r22.z, r5.w
 827:             min r5.w, r22.z, r5.w
 828:             dp3 r7.w, r31.xyzx, r30.xyzx
 829:             max r7.w, -r23.w, r7.w
 830:             min r7.w, r23.w, r7.w
 831:             mad r31.xyz, r26.xyzx, r5.wwww, r28.xyzx
 832:             mad r31.xyz, r30.xyzx, r7.wwww, r31.xyzx
 833:             mul r32.xyz, r21.xyzx, l(-5.000000, -5.000000, -5.000000, 0.000000)
 834:             dp3_sat r5.w, r7.xyzx, r32.xyzx
 835:             add r31.xyz, -r28.xyzx, r31.xyzx
 836:             mad r28.xyz, r5.wwww, r31.xyzx, r28.xyzx
 837:             add r5.w, r23.w, r22.z
 838:             mul r5.w, r5.w, l(0.500000)
 839:             dp3 r7.w, r28.xyzx, r28.xyzx
 840:             sqrt r19.w, r7.w
 841:             rsq r7.w, r7.w
 842:             mul r28.xyz, r7.wwww, r28.xyzx
 843:             mul r7.w, r19.w, l(3.000000)
 844:             div r5.w, r5.w, r7.w
 845:             add_sat r31.z, r1.y, r5.w
 846:             mad r32.xyz, -r5.xyzx, r2.zzzz, r28.xyzx
 847:             dp3 r5.w, r32.xyzx, r32.xyzx
 848:             rsq r5.w, r5.w
 849:             mul r32.xyz, r5.wwww, r32.xyzx
 850:             dp3_sat r5.w, r4.xyzx, r28.xyzx
 851:             dp3_sat r31.x, r28.xyzx, r32.xyzx
 852:             dp3_sat r7.w, r4.xyzx, r32.xyzx
 853:             mul r7.w, r7.w, r7.w
 854:             mul r31.y, r7.w, r7.w
 855:             sample_l(texture2d)(float,float,float,float) r7.w, r31.yzyy, g_textureGgxDFV.yzwx, g_textureGgxDFVSampler, l(0)
 856:             sample_l(texture2d)(float,float,float,float) r25.xw, r31.xzxx, g_textureGgxDFV.yxwz, g_textureGgxDFVSampler, l(0)
 857:             mul r28.xyz, r17.xyzx, r25.wwww
 858:             mad r28.xyz, r8.xyzx, r25.xxxx, r28.xyzx
 859:             mul r5.w, r5.w, r7.w
 860:             mul r29.xyz, r28.xyzx, r5.wwww
 861:             add r28.xyz, r5.xyzx, -r23.xyzx
 862:             dp3 r5.w, r28.xyzx, r21.xyzx
 863:             lt r5.w, l(0.100000), r5.w
 864:             if_nz r5.w
 865:               mad r28.xyz, r26.xyzx, r22.zzzz, r23.xyzx
 866:               mad r31.xyz, r30.xyzx, r23.wwww, r28.xyzx
 867:               mad r28.xyz, r30.xyzx, -r23.wwww, r28.xyzx
 868:               mad r26.xyz, r26.xyzx, -r22.zzzz, r23.xyzx
 869:               mad r32.xyz, r30.xyzx, -r23.wwww, r26.xyzx
 870:               mad r26.xyz, r30.xyzx, r23.wwww, r26.xyzx
 871:               add r30.xyz, -r5.xyzx, r31.xyzx
 872:               add r28.xyz, -r5.xyzx, r28.xyzx
 873:               add r31.xyz, -r5.xyzx, r32.xyzx
 874:               add r26.xyz, -r5.xyzx, r26.xyzx
 875:               mul r32.xyz, r28.yzxy, r30.zxyz
 876:               mad r32.xyz, r30.yzxy, r28.zxyz, -r32.xyzx
 877:               dp3 r5.w, r32.xyzx, r32.xyzx
 878:               rsq r5.w, r5.w
 879:               mul r32.xyz, r5.wwww, r32.xyzx
 880:               mul r33.xyz, r28.zxyz, r31.yzxy
 881:               mad r33.xyz, r28.yzxy, r31.zxyz, -r33.xyzx
 882:               dp3 r5.w, r33.xyzx, r33.xyzx
 883:               rsq r5.w, r5.w
 884:               mul r33.xyz, r5.wwww, r33.xyzx
 885:               mul r34.xyz, r26.yzxy, r31.zxyz
 886:               mad r34.xyz, r31.yzxy, r26.zxyz, -r34.xyzx
 887:               dp3 r5.w, r34.xyzx, r34.xyzx
 888:               rsq r5.w, r5.w
 889:               mul r34.xyz, r5.wwww, r34.xyzx
 890:               mul r35.xyz, r30.yzxy, r26.zxyz
 891:               mad r35.xyz, r26.yzxy, r30.zxyz, -r35.xyzx
 892:               dp3 r5.w, r35.xyzx, r35.xyzx
 893:               rsq r5.w, r5.w
 894:               mul r35.xyz, r5.wwww, r35.xyzx
 895:               dp3 r5.w, -r32.xyzx, r33.xyzx
 896:               max r5.w, r5.w, l(-1.000000)
 897:               min r5.w, r5.w, l(1.000000)
 898:               add r7.w, -abs(r5.w), l(1.000000)
 899:               sqrt r7.w, r7.w
 900:               mad r19.w, abs(r5.w), l(-0.018729), l(0.074261)
 901:               mad r19.w, r19.w, abs(r5.w), l(-0.212114)
 902:               mad r19.w, r19.w, abs(r5.w), l(1.570729)
 903:               mul r20.w, r7.w, r19.w
 904:               mad r20.w, r20.w, l(-2.000000), l(3.141593)
 905:               lt r5.w, r5.w, -r5.w
 906:               and r5.w, r5.w, r20.w
 907:               mad r5.w, r19.w, r7.w, r5.w
 908:               dp3 r7.w, -r33.xyzx, r34.xyzx
 909:               max r7.w, r7.w, l(-1.000000)
 910:               min r7.w, r7.w, l(1.000000)
 911:               add r19.w, -abs(r7.w), l(1.000000)
 912:               sqrt r19.w, r19.w
 913:               mad r20.w, abs(r7.w), l(-0.018729), l(0.074261)
 914:               mad r20.w, r20.w, abs(r7.w), l(-0.212114)
 915:               mad r20.w, r20.w, abs(r7.w), l(1.570729)
 916:               mul r21.w, r19.w, r20.w
 917:               mad r21.w, r21.w, l(-2.000000), l(3.141593)
 918:               lt r7.w, r7.w, -r7.w
 919:               and r7.w, r7.w, r21.w
 920:               mad r7.w, r20.w, r19.w, r7.w
 921:               dp3 r19.w, -r34.xyzx, r35.xyzx
 922:               max r19.w, r19.w, l(-1.000000)
 923:               min r19.w, r19.w, l(1.000000)
 924:               add r20.w, -abs(r19.w), l(1.000000)
 925:               sqrt r20.w, r20.w
 926:               mad r21.w, abs(r19.w), l(-0.018729), l(0.074261)
 927:               mad r21.w, r21.w, abs(r19.w), l(-0.212114)
 928:               mad r21.w, r21.w, abs(r19.w), l(1.570729)
 929:               mul r22.z, r20.w, r21.w
 930:               mad r22.z, r22.z, l(-2.000000), l(3.141593)
 931:               lt r19.w, r19.w, -r19.w
 932:               and r19.w, r19.w, r22.z
 933:               mad r19.w, r21.w, r20.w, r19.w
 934:               dp3 r20.w, -r35.xyzx, r32.xyzx
 935:               max r20.w, r20.w, l(-1.000000)
 936:               min r20.w, r20.w, l(1.000000)
 937:               add r21.w, -abs(r20.w), l(1.000000)
 938:               sqrt r21.w, r21.w
 939:               mad r22.z, abs(r20.w), l(-0.018729), l(0.074261)
 940:               mad r22.z, r22.z, abs(r20.w), l(-0.212114)
 941:               mad r22.z, r22.z, abs(r20.w), l(1.570729)
 942:               mul r22.w, r21.w, r22.z
 943:               mad r22.w, r22.w, l(-2.000000), l(3.141593)
 944:               lt r20.w, r20.w, -r20.w
 945:               and r20.w, r20.w, r22.w
 946:               mad r20.w, r22.z, r21.w, r20.w
 947:               add r5.w, r5.w, r7.w
 948:               add r5.w, r19.w, r5.w
 949:               add r5.w, r20.w, r5.w
 950:               add r5.w, r5.w, l(-6.283185)
 951:               mul r5.w, r5.w, l(0.200000)
 952:               dp3 r7.w, r30.xyzx, r30.xyzx
 953:               rsq r7.w, r7.w
 954:               mul r30.xyz, r7.wwww, r30.xyzx
 955:               dp3_sat r7.w, r30.xyzx, r4.xyzx
 956:               dp3 r19.w, r28.xyzx, r28.xyzx
 957:               rsq r19.w, r19.w
 958:               mul r28.xyz, r19.wwww, r28.xyzx
 959:               dp3_sat r19.w, r28.xyzx, r4.xyzx
 960:               add r7.w, r7.w, r19.w
 961:               dp3 r19.w, r31.xyzx, r31.xyzx
 962:               rsq r19.w, r19.w
 963:               mul r28.xyz, r19.wwww, r31.xyzx
 964:               dp3_sat r19.w, r28.xyzx, r4.xyzx
 965:               add r7.w, r7.w, r19.w
 966:               dp3 r19.w, r26.xyzx, r26.xyzx
 967:               rsq r19.w, r19.w
 968:               mul r26.xyz, r19.wwww, r26.xyzx
 969:               dp3_sat r19.w, r26.xyzx, r4.xyzx
 970:               add r7.w, r7.w, r19.w
 971:               dp3_sat r19.w, r27.xyzx, r4.xyzx
 972:               add r7.w, r7.w, r19.w
 973:               mul r5.w, r5.w, r7.w
 974:             else
 975:               mov r5.w, l(0)
 976:             endif
 977:             mul r17.w, r5.w, r26.w
 978:           else
 979:             mov r29.xyz, l(0, 0, 0, 0)
 980:             mov r17.w, l(0)
 981:           endif
 982:         else
 983:           mad r26.xyz, r21.xyzx, r22.yyyy, r23.xyzx
 984:           mad r21.xyz, -r21.xyzx, r22.yyyy, r23.xyzx
 985:           add r5.w, r22.y, r22.y
 986:           add r23.xyz, -r5.xyzx, r26.xyzx
 987:           add r27.xyz, -r5.xyzx, r21.xyzx
 988:           add r27.xyz, -r23.xyzx, r27.xyzx
 989:           dp3 r7.w, r7.xyzx, r27.xyzx
 990:           mad r28.xyz, r7.wwww, r7.xyzx, -r27.xyzx
 991:           dp3 r19.w, r23.xyzx, r28.xyzx
 992:           mul r7.w, r7.w, r7.w
 993:           mad r5.w, r5.w, r5.w, -r7.w
 994:           div_sat r5.w, r19.w, r5.w
 995:           mad r23.xyz, r27.xyzx, r5.wwww, r23.xyzx
 996:           dp3 r5.w, r23.xyzx, r7.xyzx
 997:           mad r27.xyz, r5.wwww, r7.xyzx, -r23.xyzx
 998:           dp3 r5.w, r27.xyzx, r27.xyzx
 999:           sqrt r5.w, r5.w
1000:           div_sat r5.w, r22.x, r5.w
1001:           mad r23.xyz, r27.xyzx, r5.wwww, r23.xyzx
1002:           add r27.xyz, -r26.xyzx, r21.xyzx
1003:           add r28.xyz, r5.xyzx, -r26.xyzx
1004:           dp3 r5.w, r28.xyzx, r27.xyzx
1005:           dp3 r7.w, r27.xyzx, r27.xyzx
1006:           div_sat r5.w, r5.w, r7.w
1007:           mad r28.xyz, r5.wwww, r27.xyzx, r26.xyzx
1008:           dp3 r5.w, r23.xyzx, r23.xyzx
1009:           sqrt r19.w, r5.w
1010:           rsq r5.w, r5.w
1011:           mul r23.xyz, r5.wwww, r23.xyzx
1012:           mul r5.w, r19.w, l(3.000000)
1013:           div r5.w, r22.x, r5.w
1014:           add_sat r30.z, r1.y, r5.w
1015:           mad r31.xyz, -r5.xyzx, r2.zzzz, r23.xyzx
1016:           dp3 r5.w, r31.xyzx, r31.xyzx
1017:           rsq r5.w, r5.w
1018:           mul r31.xyz, r5.wwww, r31.xyzx
1019:           dp3_sat r5.w, r4.xyzx, r23.xyzx
1020:           dp3_sat r30.x, r23.xyzx, r31.xyzx
1021:           dp3_sat r19.w, r4.xyzx, r31.xyzx
1022:           mul r19.w, r19.w, r19.w
1023:           mul r30.y, r19.w, r19.w
1024:           sample_l(texture2d)(float,float,float,float) r19.w, r30.yzyy, g_textureGgxDFV.yzwx, g_textureGgxDFVSampler, l(0)
1025:           sample_l(texture2d)(float,float,float,float) r22.zw, r30.xzxx, g_textureGgxDFV.xwyz, g_textureGgxDFVSampler, l(0)
1026:           mul r23.xyz, r17.xyzx, r22.wwww
1027:           mad r23.xyz, r8.xyzx, r22.zzzz, r23.xyzx
1028:           mul r5.w, r5.w, r19.w
1029:           mul r29.xyz, r23.xyzx, r5.wwww
1030:           add r21.xyz, r21.xyzx, r26.xyzx
1031:           rsq r5.w, r7.w
1032:           mul r23.xyz, r5.wwww, r27.xyzx
1033:           add r26.xyz, -r5.xyzx, r28.xyzx
1034:           mul r27.xyz, r23.zxyz, r26.yzxy
1035:           mad r27.xyz, r23.yzxy, r26.zxyz, -r27.xyzx
1036:           dp3 r5.w, r27.xyzx, r27.xyzx
1037:           rsq r5.w, r5.w
1038:           mul r27.xyz, r5.wwww, r27.xyzx
1039:           mul r22.yzw, r22.yyyy, r23.xxyz
1040:           mad r23.xyz, r21.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), -r22.yzwy
1041:           mad r28.xyz, r22.xxxx, r27.xyzx, r23.xyzx
1042:           mad r23.xyz, -r22.xxxx, r27.xyzx, r23.xyzx
1043:           mad r22.yzw, r21.xxyz, l(0.000000, 0.500000, 0.500000, 0.500000), r22.yyzw
1044:           mad r30.xyz, -r22.xxxx, r27.xyzx, r22.yzwy
1045:           mad r22.yzw, r22.xxxx, r27.xxyz, r22.yyzw
1046:           add r27.xyz, -r5.xyzx, r28.xyzx
1047:           add r23.xyz, -r5.xyzx, r23.xyzx
1048:           add r28.xyz, -r5.xyzx, r30.xyzx
1049:           add r22.yzw, -r5.xxyz, r22.yyzw
1050:           mul r30.xyz, r23.yzxy, r27.zxyz
1051:           mad r30.xyz, r27.yzxy, r23.zxyz, -r30.xyzx
1052:           dp3 r5.w, r30.xyzx, r30.xyzx
1053:           rsq r5.w, r5.w
1054:           mul r30.xyz, r5.wwww, r30.xyzx
1055:           mul r31.xyz, r23.zxyz, r28.yzxy
1056:           mad r31.xyz, r23.yzxy, r28.zxyz, -r31.xyzx
1057:           dp3 r5.w, r31.xyzx, r31.xyzx
1058:           rsq r5.w, r5.w
1059:           mul r31.xyz, r5.wwww, r31.xyzx
1060:           mul r32.xyz, r22.zwyz, r28.zxyz
1061:           mad r32.xyz, r28.yzxy, r22.wyzw, -r32.xyzx
1062:           dp3 r5.w, r32.xyzx, r32.xyzx
1063:           rsq r5.w, r5.w
1064:           mul r32.xyz, r5.wwww, r32.xyzx
1065:           mul r33.xyz, r27.yzxy, r22.wyzw
1066:           mad r33.xyz, r22.zwyz, r27.zxyz, -r33.xyzx
1067:           dp3 r5.w, r33.xyzx, r33.xyzx
1068:           rsq r5.w, r5.w
1069:           mul r33.xyz, r5.wwww, r33.xyzx
1070:           dp3 r5.w, -r30.xyzx, r31.xyzx
1071:           max r5.w, r5.w, l(-1.000000)
1072:           min r5.w, r5.w, l(1.000000)
1073:           add r7.w, -abs(r5.w), l(1.000000)
1074:           sqrt r7.w, r7.w
1075:           mad r19.w, abs(r5.w), l(-0.018729), l(0.074261)
1076:           mad r19.w, r19.w, abs(r5.w), l(-0.212114)
1077:           mad r19.w, r19.w, abs(r5.w), l(1.570729)
1078:           mul r20.w, r7.w, r19.w
1079:           mad r20.w, r20.w, l(-2.000000), l(3.141593)
1080:           lt r5.w, r5.w, -r5.w
1081:           and r5.w, r5.w, r20.w
1082:           mad r5.w, r19.w, r7.w, r5.w
1083:           dp3 r7.w, -r31.xyzx, r32.xyzx
1084:           max r7.w, r7.w, l(-1.000000)
1085:           min r7.w, r7.w, l(1.000000)
1086:           add r19.w, -abs(r7.w), l(1.000000)
1087:           sqrt r19.w, r19.w
1088:           mad r20.w, abs(r7.w), l(-0.018729), l(0.074261)
1089:           mad r20.w, r20.w, abs(r7.w), l(-0.212114)
1090:           mad r20.w, r20.w, abs(r7.w), l(1.570729)
1091:           mul r21.w, r19.w, r20.w
1092:           mad r21.w, r21.w, l(-2.000000), l(3.141593)
1093:           lt r7.w, r7.w, -r7.w
1094:           and r7.w, r7.w, r21.w
1095:           mad r7.w, r20.w, r19.w, r7.w
1096:           dp3 r19.w, -r32.xyzx, r33.xyzx
1097:           max r19.w, r19.w, l(-1.000000)
1098:           min r19.w, r19.w, l(1.000000)
1099:           add r20.w, -abs(r19.w), l(1.000000)
1100:           sqrt r20.w, r20.w
1101:           mad r21.w, abs(r19.w), l(-0.018729), l(0.074261)
1102:           mad r21.w, r21.w, abs(r19.w), l(-0.212114)
1103:           mad r21.w, r21.w, abs(r19.w), l(1.570729)
1104:           mul r23.w, r20.w, r21.w
1105:           mad r23.w, r23.w, l(-2.000000), l(3.141593)
1106:           lt r19.w, r19.w, -r19.w
1107:           and r19.w, r19.w, r23.w
1108:           mad r19.w, r21.w, r20.w, r19.w
1109:           dp3 r20.w, -r33.xyzx, r30.xyzx
1110:           max r20.w, r20.w, l(-1.000000)
1111:           min r20.w, r20.w, l(1.000000)
1112:           add r21.w, -abs(r20.w), l(1.000000)
1113:           sqrt r21.w, r21.w
1114:           mad r23.w, abs(r20.w), l(-0.018729), l(0.074261)
1115:           mad r23.w, r23.w, abs(r20.w), l(-0.212114)
1116:           mad r23.w, r23.w, abs(r20.w), l(1.570729)
1117:           mul r24.w, r21.w, r23.w
1118:           mad r24.w, r24.w, l(-2.000000), l(3.141593)
1119:           lt r20.w, r20.w, -r20.w
1120:           and r20.w, r20.w, r24.w
1121:           mad r20.w, r23.w, r21.w, r20.w
1122:           add r5.w, r5.w, r7.w
1123:           add r5.w, r19.w, r5.w
1124:           add r5.w, r20.w, r5.w
1125:           add r5.w, r5.w, l(-6.283185)
1126:           mul r5.w, r5.w, l(0.200000)
1127:           dp3 r7.w, r27.xyzx, r27.xyzx
1128:           rsq r7.w, r7.w
1129:           mul r27.xyz, r7.wwww, r27.xyzx
1130:           dp3_sat r7.w, r27.xyzx, r4.xyzx
1131:           dp3 r19.w, r23.xyzx, r23.xyzx
1132:           rsq r19.w, r19.w
1133:           mul r23.xyz, r19.wwww, r23.xyzx
1134:           dp3_sat r19.w, r23.xyzx, r4.xyzx
1135:           add r7.w, r7.w, r19.w
1136:           dp3 r19.w, r28.xyzx, r28.xyzx
1137:           rsq r19.w, r19.w
1138:           mul r23.xyz, r19.wwww, r28.xyzx
1139:           dp3_sat r19.w, r23.xyzx, r4.xyzx
1140:           add r7.w, r7.w, r19.w
1141:           dp3 r19.w, r22.yzwy, r22.yzwy
1142:           rsq r19.w, r19.w
1143:           mul r22.yzw, r19.wwww, r22.yyzw
1144:           dp3_sat r19.w, r22.yzwy, r4.xyzx
1145:           add r7.w, r7.w, r19.w
1146:           mad r21.xyz, r21.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), -r5.xyzx
1147:           dp3 r19.w, r21.xyzx, r21.xyzx
1148:           rsq r19.w, r19.w
1149:           mul r21.xyz, r19.wwww, r21.xyzx
1150:           dp3_sat r19.w, r21.xyzx, r4.xyzx
1151:           add r7.w, r7.w, r19.w
1152:           dp3 r19.w, r26.xyzx, r26.xyzx
1153:           rsq r20.w, r19.w
1154:           mul r21.xyz, r20.wwww, r26.xyzx
1155:           max r19.w, r19.w, l(0.001000)
1156:           dp3_sat r20.w, r21.xyzx, r4.xyzx
1157:           mul r20.w, r20.w, l(3.141593)
1158:           mul r21.x, r22.x, r22.x
1159:           div r19.w, r21.x, r19.w
1160:           mul r19.w, r19.w, r20.w
1161:           mad r5.w, r5.w, r7.w, r19.w
1162:           mul r17.w, r5.w, r26.w
1163:         endif
1164:       endif
1165:     endif
1166:   endif
1167:   mul r21.xyz, r3.xyzx, r24.xyzx
1168:   mul r5.w, r1.x, r8.w
1169:   mul r5.w, r17.w, r5.w
1170:   mul r5.w, r9.w, r5.w
1171:   mul r5.w, r25.y, r5.w
1172:   mad r19.xyz, r21.xyzx, r5.wwww, r19.xyzx
1173:   mul r21.xyz, r24.xyzx, r29.xyzx
1174:   mul r5.w, r8.w, r17.w
1175:   mul r5.w, r9.w, r5.w
1176:   mul r5.w, r25.z, r5.w
1177:   mad r20.xyz, r21.xyzx, r5.wwww, r20.xyzx
1178:   iadd r3.w, r3.w, l(1)
1179:   imad r5.w, r0.x, r0.y, r3.w
1180:   ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r5.w, r5.w, l(0), g_PerTileLightIndex.xxxx
1181:   ult r7.w, r0.w, r3.w
1182:   movc r4.w, r7.w, l(0x0000ffff), r5.w
1183: endloop
1184: mov r0.xyzw, r19.xyzx
1185: mov r1.xyzw, r20.xyzx
1186: add r0.xyzw, r0.xyzw, r1.xyzw
1187: ld_uav_typed(texture2d)(float,float,float,float) r1.xyz, vThreadID.xyyy, ResultDiffuse.xyzw
1188: add r0.xyzw, r0.xyzw, r1.xyzx
1189: store_uav_typed ResultDiffuse.xyzw, vThreadID.xyyy, r0.xyzw
1190: ret
