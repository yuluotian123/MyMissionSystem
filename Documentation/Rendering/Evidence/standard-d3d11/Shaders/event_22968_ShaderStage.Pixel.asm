Shader hash 9a4154a5-bc809c33-ce4232d7-6115702d

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_immediateConstantBuffer {
			{ 1.000000, 0, 0, 0}, 
			{ 0, 1.000000, 0, 0}, 
			{ 0, 0, 1.000000, 0}, 
			{ 0, 0, 0, 1.000000}, 
			{ 0.007813, 0, 0, 0}, 
			{ 0.015625, 0, 0, 0}, 
			{ 0.031250, 0, 0, 0}, 
			{ 0.062500, 0, 0, 0}, 
			{ 0.125000, 0, 0, 0}, 
			{ 0.250000, 0, 0, 0} }
      dcl_constantbuffer cb0[34] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb12[1] (HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb7[1] (CharacterShaderParam), immediateIndexed
      dcl_constantbuffer cb9[192] (CharacterDirectionalDataBuf), dynamicIndexed
      dcl_constantbuffer cb11[256] (CharacterPointLightDataBuf), dynamicIndexed
      dcl_constantbuffer cb6[16] (CutCharacterMaterialDataBuf), immediateIndexed
      dcl_constantbuffer cb8[2] (CutCharacterTargetIndicesBuf), immediateIndexed
      dcl_constantbuffer cb5[3] (ParamBuffer), immediateIndexed
      dcl_sampler PointClampSampler (s2), mode_default
      dcl_sampler g_CacheSampler (s6), mode_default
      dcl_sampler LocalIBLSampler (s10), mode_default
      dcl_sampler AmbientAreaLightSampler (s11), mode_default
      dcl_resource_texture2darray (float,float,float,float) g_AlbedoCacheTexture (t0)
      dcl_resource_texture2darray (float,float,float,float) g_NormalCacheTexture (t1)
      dcl_resource_texture2darray (float,float,float,float) g_MaskCacheTexture (t2)
      dcl_resource_texture2d (float,float,float,float) g_ShadowTexture (t3)
      dcl_resource_texture2d (float,float,float,float) g_DiffuseLocalIBL (t6)
      dcl_resource_texture2d (float,float,float,float) g_SpecularLocalIBL (t7)
      dcl_resource_texture2d (float,float,float,float) g_BooleanMask (t8)
      dcl_resource_texture2d (float,float,float,float) g_DitherTex (t14)
      dcl_resource_structured g_TileSetParamBlock (t21), 128
      dcl_resource_structured g_StreamTextureParamBlock (t22), 32
      dcl_resource_texture2d (float,float,float,float) g_PageTableTexture (t23)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_resource_texture2d (float,float,float,float) g_DiffuseAmbientAreaLight (t29)
      dcl_input_ps_siv linear noperspective v0.xyz, position
      dcl_input_ps linear v1.xyzw
      dcl_input_ps linear v2.xyzw
      dcl_input_ps linear v3.xyzw
      dcl_input_ps linear v4.xyz
      dcl_input_ps nointerpolation v7.x
      dcl_output o0.xyzw
      dcl_temps 13
   0: iadd r0.xyz, v7.xxxx, l(2, 4, 5, 0)
   1: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.y, r0.y, l(0), g_InstanceParam.xxxx
   2: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.z, r0.z, l(0), g_InstanceParam.xxxx
   3: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r1.xy, r0.z, l(48), g_TileSetParamBlock.xyxx
   4: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r2.xyzw, r0.z, l(4), g_TileSetParamBlock.xyzw
   5: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r3.xyzw, r0.y, l(0), g_StreamTextureParamBlock.xyzw
   6: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r0.w, r0.y, l(16), g_StreamTextureParamBlock.xxxx
   7: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r0.y, r0.y, l(28), g_StreamTextureParamBlock.xxxx
   8: deriv_rtx_coarse r4.xz, v2.wwww
   9: deriv_rtx_coarse r4.y, v3.w
  10: mul r4.xyz, r3.zwzz, r4.xyzx
  11: deriv_rty_coarse r5.xz, v2.wwww
  12: deriv_rty_coarse r5.y, v3.w
  13: mul r5.xyz, r3.zwzz, r5.xyzx
  14: frc r6.x, v2.w
  15: frc r6.y, v3.w
  16: mad r6.zw, r6.xxxy, r3.zzzw, r3.xxxy
  17: mul r7.xy, r2.yzyy, r4.zyzz
  18: mul r2.yz, r2.yyzy, r5.zzyz
  19: dp2 r1.w, r7.xyxx, r7.xyxx
  20: dp2 r2.y, r2.yzyy, r2.yzyy
  21: max r2.z, r1.w, r2.y
  22: min r1.w, r1.w, r2.y
  23: log r2.y, r2.z
  24: mul r2.z, r2.y, l(0.500000)
  25: log r1.w, r1.w
  26: mad r1.w, -r1.w, l(0.500000), r2.z
  27: min r1.w, r2.x, r1.w
  28: mad r1.w, r2.y, l(0.500000), -r1.w
  29: add r1.w, r1.w, l(-0.500000)
  30: max r1.w, r1.w, l(0)
  31: min r1.w, r0.w, r1.w
  32: add r1.w, r1.w, l(0.500000)
  33: round_ni r1.w, r1.w
  34: mul r1.z, r1.y, r1.x
  35: mul r2.xy, r1.xzxx, r6.zwzz
  36: exp r2.z, -r1.w
  37: mul r2.xy, r2.zzzz, r2.xyxx
  38: round_ni r2.xy, r2.xyxx
  39: ftoi r7.xy, r2.xyxx
  40: ftoi r7.zw, r1.wwww
  41: ld_indexable(texture2d)(float,float,float,float) r7.xyz, r7.xyzw, g_PageTableTexture.xyzw
  42: and r2.x, r7.x, l(15)
  43: utof r2.x, r2.x
  44: add r0.y, r0.y, -r2.x
  45: lt r2.x, r0.w, r0.y
  46: if_nz r2.x
  47:   add r0.y, -r0.w, r0.y
  48:   max r0.y, r0.y, l(0)
  49:   min r0.y, r0.y, l(6.000000)
  50:   ftou r0.y, r0.y
  51:   add r0.w, l(1.000000), -icb[r0.y + 3].x
  52:   max r2.xy, r6.xyxx, icb[r0.y + 3].xxxx
  53:   min r0.yw, r0.wwww, r2.xxxy
  54:   mad r6.zw, r0.yyyw, r3.zzzw, r3.xxxy
  55:   mul r0.yw, r1.xxxz, r6.zzzw
  56:   mul r0.yw, r2.zzzz, r0.yyyw
  57:   round_ni r0.yw, r0.yyyw
  58:   ftoi r3.xy, r0.ywyy
  59:   ftoi r3.zw, r1.wwww
  60:   ld_indexable(texture2d)(float,float,float,float) r7.xyz, r3.xyzw, g_PageTableTexture.xyzw
  61: endif
  62: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.x, r0.x, l(0), g_InstanceParam.xxxx
  63: ne r0.x, l(0, 0, 0, 0), r0.x
  64: if_nz r0.x
  65:   ftoi r3.xy, v0.xyxx
  66:   mov r3.zw, l(0, 0, 0, 0)
  67:   ld_indexable(texture2d)(float,float,float,float) r0.x, r3.xyzw, g_BooleanMask.xyzw
  68:   lt r0.x, r0.x, v0.z
  69:   discard_nz r0.x
  70: endif
  71: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r0.xy, r0.z, l(32), g_TileSetParamBlock.xyxx
  72: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r3.xyzw, r0.z, l(64), g_TileSetParamBlock.xyzw
  73: ubfe r1.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r7.xxxx
  74: and r0.w, r7.x, l(15)
  75: utof r0.w, r0.w
  76: exp r2.xz, r0.wwww
  77: mul r2.y, r1.y, r2.z
  78: mul r6.xy, r2.zyzz, r6.zwzz
  79: frc r6.xy, r6.xyxx
  80: utof r1.xzw, r1.xxzw
  81: mad r6.xy, r6.xyxx, r0.xyxx, r1.xzxx
  82: mad r1.xz, r6.xxyx, r3.xxyx, r3.zzwz
  83: mul r2.xyz, r0.xyxx, r2.xyzx
  84: mul r2.xyz, r3.xyxx, r2.xyzx
  85: mul r2.xyz, r2.wwww, r2.xyzx
  86: mul r3.xyz, r2.zyzz, r4.zyzz
  87: mul r2.xyz, r2.xyzx, r5.zyzz
  88: sample_d(texture2darray)(float,float,float,float) r3.xyzw, r1.xzwx, g_AlbedoCacheTexture.xyzw, g_CacheSampler, r3.xyzx, r2.xyzx
  89: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, v7.x, l(0), g_InstanceParam.xxxx
  90: and r1.x, r0.w, l(255)
  91: utof r1.x, r1.x
  92: mul r8.x, r3.x, r1.x
  93: ubfe r1.xz, l(8, 0, 8, 0), l(8, 0, 16, 0), r0.wwww
  94: utof r1.xz, r1.xxzx
  95: mul r8.yz, r3.yyzy, r1.xxzx
  96: ushr r0.w, r0.w, l(24)
  97: utof r0.w, r0.w
  98: mul r8.w, r3.w, r0.w
  99: mul r3.xyzw, r8.xyzw, l(0.003922, 0.003922, 0.003922, 0.003922)
 100: ge r0.w, l(1.002150), r8.w
 101: ge r1.x, r8.w, l(253.995285)
 102: movc r1.x, r1.x, l(1.000000), r3.w
 103: mul r1.x, r1.x, charaMaterial_.ditherAlpha_.x
 104: mad r1.zw, g_ProjectionOffset.xxxy, l(0.000000, 0.000000, 64.000000, 64.000000), v0.xxxy
 105: ftoi r1.zw, r1.zzzw
 106: and r8.xy, r1.zwzz, l(63, 63, 0, 0)
 107: mov r8.zw, l(0, 0, 0, 0)
 108: ld_indexable(texture2d)(float,float,float,float) r1.zw, r8.xyzw, g_DitherTex.ywxz
 109: and r2.x, g_FrameCount[0].x, l(2)
 110: dp2 r1.z, r1.zwzz, icb[r2.x + 0].xzxx
 111: mul r1.x, r1.x, l(1.003922)
 112: movc r0.w, r0.w, l(0), r1.x
 113: ge r0.w, r1.z, r0.w
 114: discard_nz r0.w
 115: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r8.xyzw, r0.z, l(96), g_TileSetParamBlock.xyzw
 116: ubfe r1.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r7.zzzz
 117: and r0.w, r7.z, l(15)
 118: utof r0.w, r0.w
 119: exp r2.xz, r0.wwww
 120: mul r2.y, r1.y, r2.z
 121: mul r6.xy, r2.zyzz, r6.zwzz
 122: frc r6.xy, r6.xyxx
 123: utof r1.xzw, r1.xxzw
 124: mad r6.xy, r6.xyxx, r0.xyxx, r1.xzxx
 125: mad r1.xz, r6.xxyx, r8.xxyx, r8.zzwz
 126: mul r2.xyz, r0.xyxx, r2.xyzx
 127: mul r2.xyz, r8.xyxx, r2.xyzx
 128: mul r2.xyz, r2.wwww, r2.xyzx
 129: mul r7.xzw, r2.zzyz, r4.zzyz
 130: mul r2.xyz, r2.xyzx, r5.zyzz
 131: sample_d(texture2darray)(float,float,float,float) r1.xzw, r1.xzwx, g_MaskCacheTexture.xyzw, g_CacheSampler, r7.xzwx, r2.xyzx
 132: add r2.xyz, g_VariationMulAlbedoColor.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 133: mad r2.xyz, r1.wwww, r2.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 134: movc r2.xyz, g_VariationEnable.xxxx, r2.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 135: if_z g_EnableForwardLight.x
 136:   mul o0.xyz, r2.xyzx, r3.xyzx
 137:   mov o0.w, l(1.000000)
 138:   ret
 139: endif
 140: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r8.xyzw, r0.z, l(80), g_TileSetParamBlock.xyzw
 141: div r0.zw, v0.xxxy, g_TargetUvParam.zzzw
 142: ubfe r7.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r7.yyyy
 143: and r1.w, r7.y, l(15)
 144: utof r1.w, r1.w
 145: exp r9.xz, r1.wwww
 146: mul r9.y, r1.y, r9.z
 147: mul r1.yw, r6.zzzw, r9.zzzy
 148: frc r1.yw, r1.yyyw
 149: utof r6.xyz, r7.xzwx
 150: mad r1.yw, r1.yyyw, r0.xxxy, r6.xxxy
 151: mad r6.xy, r1.ywyy, r8.xyxx, r8.zwzz
 152: mul r7.xyz, r0.xyxx, r9.xyzx
 153: mul r7.xyz, r8.xyxx, r7.xyzx
 154: mul r7.xyz, r2.wwww, r7.xyzx
 155: mul r4.xyz, r4.xyzx, r7.xyzx
 156: mul r5.xyz, r5.xyzx, r7.xyzx
 157: sample_d(texture2darray)(float,float,float,float) r4.xyz, r6.xyzx, g_NormalCacheTexture.xywz, g_CacheSampler, r4.xyzx, r5.xyzx
 158: mul r4.x, r4.z, r4.x
 159: mad r0.xy, r4.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
 160: dp2 r1.y, r0.xyxx, r0.xyxx
 161: min r1.y, r1.y, l(1.000000)
 162: add r1.y, -r1.y, l(1.000000)
 163: sqrt r1.y, r1.y
 164: mul r4.xyz, -r0.yyyy, v4.xyzx
 165: mad r4.xyz, r0.xxxx, v3.xyzx, r4.xyzx
 166: mad r4.xyz, r1.yyyy, v2.xyzx, r4.xyzx
 167: dp3 r0.x, r4.xyzx, r4.xyzx
 168: rsq r0.x, r0.x
 169: mul r4.xyz, r0.xxxx, r4.xyzx
 170: dp3 r5.x, r4.xyzx, g_ViewInverseMatrix[0].xyzx
 171: dp3 r5.z, r4.xyzx, g_ViewInverseMatrix[2].xyzx
 172: mov r5.y, l(0.200000)
 173: dp3 r0.x, r5.xyzx, r5.xyzx
 174: rsq r0.x, r0.x
 175: mul r4.xyz, r0.xxxx, r5.xyzx
 176: dp3 r5.x, r4.xyzx, g_View[0].xyzx
 177: dp3 r5.y, r4.xyzx, g_View[1].xyzx
 178: dp3 r5.z, r4.xyzx, g_View[2].xyzx
 179: mul r2.xyz, r2.xyzx, r3.xyzx
 180: sample_indexable(texture2d)(float,float,float,float) r0.x, r0.zwzz, g_ShadowTexture.xyzw, PointClampSampler
 181: iadd r0.y, v7.x, l(1)
 182: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.y, r0.y, l(0), g_InstanceParam.xxxx
 183: ieq r3.xyz, r0.yyyy, l(1, 2, 3, 0)
 184: movc r0.y, r3.z, g_CharacterParam.w, l(1.000000)
 185: movc r0.y, r3.y, g_CharacterParam.z, r0.y
 186: movc r0.y, r3.x, g_CharacterParam.y, r0.y
 187: mul r1.y, r0.y, charaMaterial_.lightIntensity_.x
 188: max r1.w, r0.x, charaMaterial_.shadowMin_.x
 189: ne r2.w, l(0, 0, 0, 0), charaMaterial_.useCutSceneLight_.x
 190: max r3.x, r1.w, charaMaterial_.shadowOtherMin_.x
 191: movc r1.w, r2.w, r3.x, r1.w
 192: dp3_sat r2.w, r5.xyzx, charaMaterial_.directionalLightVec_.xyzx
 193: mul r3.xyz, r2.xyzx, charaMaterial_.lightColor_.xyzx
 194: mul r3.xyz, r1.yyyy, r3.xyzx
 195: mul r3.w, r1.w, r2.w
 196: mul r3.w, r3.w, l(0.318310)
 197: mul r3.xyz, r3.wwww, r3.xyzx
 198: sample_indexable(texture2d)(float,float,float,float) r4.xyz, r0.zwzz, g_SpecularLocalIBL.xyzw, LocalIBLSampler
 199: mul r0.y, r0.y, charaMaterial_.iblOtherIntensity_.x
 200: mul r4.xyz, r0.yyyy, r4.xyzx
 201: sample_indexable(texture2d)(float,float,float,float) r6.xyzw, r0.zwzz, g_DiffuseAmbientAreaLight.xyzw, AmbientAreaLightSampler
 202: ge r3.w, r6.w, l(16.000000)
 203: add r4.w, r6.w, l(-16.000000)
 204: movc r4.w, r3.w, r4.w, r6.w
 205: lt r5.w, r4.w, l(1.000000)
 206: if_nz r5.w
 207:   sample_indexable(texture2d)(float,float,float,float) r7.xyz, r0.zwzz, g_DiffuseLocalIBL.xyzw, LocalIBLSampler
 208:   mul r0.yzw, r0.yyyy, r7.xxyz
 209:   frc r4.w, r4.w
 210:   add r4.w, -r4.w, l(1.000000)
 211:   mad r6.xyz, r0.yzwy, r4.wwww, r6.xyzx
 212: else
 213:   mov r4.w, l(0)
 214: endif
 215: movc r0.y, r3.w, l(1.000000), r4.w
 216: mul r7.xyz, r0.yyyy, r4.xyzx
 217: mad r3.xyz, r3.xyzx, r1.zzzz, r6.xyzx
 218: lt r0.z, l(0.500000), charaMaterial_.useCutSceneLight_.x
 219: lt r0.w, l(0.500000), charaMaterial_.useAmbientLight_.x
 220: mul r2.w, r2.w, charaMaterial_.ambientIntensitySkin_.x
 221: mul r1.w, r1.w, r2.w
 222: mul r1.y, r1.y, r1.w
 223: mul r6.xyz, r1.yyyy, charaMaterial_.ambientColor_.xyzx
 224: mul r6.xyz, r6.xyzx, l(0.001000, 0.001000, 0.001000, 0.000000)
 225: and r6.xyz, r0.wwww, r6.xyzx
 226: add r6.xyz, r3.xyzx, r6.xyzx
 227: movc r3.xyz, r0.zzzz, r6.xyzx, r3.xyzx
 228: lt r0.z, l(0.500000), charaMaterial_.useCharacterLight_.x
 229: if_nz r0.z
 230:   add r6.xyz, -v1.xyzx, g_CameraVec.xyzx
 231:   dp3 r0.z, r6.xyzx, r6.xyzx
 232:   rsq r0.z, r0.z
 233:   mul r6.xyz, r0.zzzz, r6.xyzx
 234:   dp4 r8.x, v1.xyzw, g_View[0].xyzw
 235:   dp4 r8.y, v1.xyzw, g_View[1].xyzw
 236:   dp4 r8.z, v1.xyzw, g_View[2].xyzw
 237:   dp3 r9.x, r6.xyzx, g_View[0].xyzx
 238:   dp3 r9.y, r6.xyzx, g_View[1].xyzx
 239:   dp3 r9.z, r6.xyzx, g_View[2].xyzx
 240:   mov r6.xyz, l(0, 0, 0, 0)
 241:   mov r0.z, l(0)
 242:   loop
 243:     ige r0.w, r0.z, l(4)
 244:     breakc_nz r0.w
 245:     dp4 r0.w, targetIndices_.directionalLightIndex.xyzw, icb[r0.z + 0].xyzw
 246:     ftoi r0.w, r0.w
 247:     ilt r1.y, r0.w, l(0)
 248:     ige r1.w, r0.w, l(64)
 249:     or r1.y, r1.w, r1.y
 250:     if_nz r1.y
 251:       iadd r1.y, r0.z, l(1)
 252:       mov r0.z, r1.y
 253:       continue
 254:     endif
 255:     imul null, r0.w, r0.w, l(3)
 256:     mul r1.y, cb9[r0.w + 0].w, cb9[r0.w + 1].w
 257:     dp3_sat r1.w, r5.xyzx, cb9[r0.w + 0].xyzx
 258:     mul r10.xyz, r2.xyzx, cb9[r0.w + 1].xyzx
 259:     mul r10.xyz, r1.yyyy, r10.xyzx
 260:     mul r0.w, r1.w, l(0.318310)
 261:     mul r10.xyz, r0.wwww, r10.xyzx
 262:     mad r6.xyz, r10.xyzx, r1.zzzz, r6.xyzx
 263:     iadd r0.z, r0.z, l(1)
 264:   endloop
 265:   dp3 r0.z, r5.xyzx, r5.xyzx
 266:   rsq r0.z, r0.z
 267:   mul r1.yzw, r0.zzzz, r5.xxyz
 268:   mov r5.xyz, l(0, 0, 0, 0)
 269:   mov r10.xyz, l(0, 0, 0, 0)
 270:   mov r0.z, l(0)
 271:   loop
 272:     ige r0.w, r0.z, l(4)
 273:     breakc_nz r0.w
 274:     dp4 r0.w, targetIndices_.pointLightIndex.xyzw, icb[r0.z + 0].xyzw
 275:     ftoi r0.w, r0.w
 276:     ilt r2.w, r0.w, l(0)
 277:     ige r3.w, r0.w, l(64)
 278:     or r2.w, r2.w, r3.w
 279:     if_nz r2.w
 280:       iadd r2.w, r0.z, l(1)
 281:       mov r0.z, r2.w
 282:       continue
 283:     endif
 284:     ishl r0.w, r0.w, l(2)
 285:     add r11.xyz, -r8.xyzx, cb11[r0.w + 0].xyzx
 286:     dp3 r2.w, r11.xyzx, r11.xyzx
 287:     rsq r3.w, r2.w
 288:     mul r12.xyz, r3.wwww, r11.xyzx
 289:     mul r4.w, cb11[r0.w + 0].w, cb11[r0.w + 0].w
 290:     mul r4.w, r2.w, r4.w
 291:     mad r4.w, -r4.w, r4.w, l(1.000000)
 292:     max r4.w, r4.w, l(0)
 293:     mul r4.w, r4.w, r4.w
 294:     mul r4.w, r4.w, cb11[r0.w + 2].w
 295:     mul r4.w, r4.w, cb11[r0.w + 2].w
 296:     dp3 r5.w, -cb11[r0.w + 2].xyzx, r12.xyzx
 297:     mad_sat r5.w, r5.w, cb11[r0.w + 3].x, cb11[r0.w + 3].y
 298:     sqrt r6.w, r2.w
 299:     mul r6.w, r6.w, l(3.000000)
 300:     div_sat r6.w, cb11[r0.w + 1].w, r6.w
 301:     mad r11.xyz, r11.xyzx, r3.wwww, r9.xyzx
 302:     dp3 r3.w, r11.xyzx, r11.xyzx
 303:     rsq r3.w, r3.w
 304:     mul r11.xyz, r3.wwww, r11.xyzx
 305:     mul r3.w, r6.w, r6.w
 306:     mul r7.w, r3.w, r3.w
 307:     dp3_sat r8.w, r12.xyzx, r11.xyzx
 308:     dp3_sat r9.w, r1.yzwy, r11.xyzx
 309:     dp3_sat r10.w, r1.yzwy, r12.xyzx
 310:     mul r9.w, r9.w, r9.w
 311:     mad r3.w, r3.w, r3.w, l(-1.000000)
 312:     mad r3.w, r9.w, r3.w, l(1.000000)
 313:     mul r3.w, r8.w, r3.w
 314:     mul r3.w, r3.w, r3.w
 315:     mul r3.w, r3.w, l(12.566371)
 316:     add r6.w, r6.w, l(0.500000)
 317:     mul r3.w, r3.w, r6.w
 318:     max r3.w, r3.w, l(0.000010)
 319:     div r3.w, r7.w, r3.w
 320:     mul r3.w, r10.w, r3.w
 321:     max r2.w, r2.w, l(0.010000)
 322:     rcp r2.w, r2.w
 323:     mul r2.w, r10.w, r2.w
 324:     mul r2.w, r2.w, cb11[r0.w + 3].z
 325:     mul r11.xyz, r2.xyzx, cb11[r0.w + 1].xyzx
 326:     mul r6.w, r2.w, r5.w
 327:     mul r6.w, r4.w, r6.w
 328:     mad r5.xyz, r11.xyzx, r6.wwww, r5.xyzx
 329:     mul r3.w, r3.w, r5.w
 330:     mul r2.w, r2.w, r3.w
 331:     mul r2.w, r4.w, r2.w
 332:     mad r10.xyz, cb11[r0.w + 1].xyzx, r2.wwww, r10.xyzx
 333:     iadd r0.z, r0.z, l(1)
 334:   endloop
 335:   add r1.yzw, r5.xxyz, r6.xxyz
 336:   add r3.xyz, r1.yzwy, r3.xyzx
 337:   mad r7.xyz, r4.xyzx, r0.yyyy, r10.xyzx
 338: endif
 339: min r0.x, r0.x, l(0.400000)
 340: add r0.y, -r1.x, l(1.000000)
 341: mad_sat r0.x, r0.x, r0.y, r1.x
 342: mul r0.yzw, r0.xxxx, r3.xxyz
 343: mul r1.xyz, r0.xxxx, r7.xyzx
 344: movc r0.xyz, g_EnableHatching.xxxx, r0.yzwy, r3.xyzx
 345: movc r1.xyz, g_EnableHatching.xxxx, r1.xyzx, r7.xyzx
 346: add o0.xyz, r0.xyzx, r1.xyzx
 347: mov o0.w, l(1.000000)
 348: ret
