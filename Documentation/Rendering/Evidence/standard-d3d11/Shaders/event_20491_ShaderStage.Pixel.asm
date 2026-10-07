Shader hash 09a74ad4-5d5c151b-1221c124-321cc906

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
      dcl_constantbuffer cb0[15] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb12[1] (HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb7[1] (CharacterShaderParam), immediateIndexed
      dcl_constantbuffer cb9[192] (CharacterDirectionalDataBuf), dynamicIndexed
      dcl_constantbuffer cb11[256] (CharacterPointLightDataBuf), dynamicIndexed
      dcl_constantbuffer cb6[20] (CutCharacterMaterialDataBuf), immediateIndexed
      dcl_constantbuffer cb8[2] (CutCharacterTargetIndicesBuf), immediateIndexed
      dcl_constantbuffer cb5[3] (ParamBuffer), immediateIndexed
      dcl_sampler PointClampSampler (s2), mode_default
      dcl_sampler g_CacheSampler (s6), mode_default
      dcl_sampler LocalIBLSampler (s10), mode_default
      dcl_sampler AmbientAreaLightSampler (s11), mode_default
      dcl_resource_texture2darray (float,float,float,float) g_AlbedoCacheTexture (t0)
      dcl_resource_texture2darray (float,float,float,float) g_MaskCacheTexture (t2)
      dcl_resource_texture2d (float,float,float,float) g_ShadowTexture (t3)
      dcl_resource_texture2d (float,float,float,float) g_DiffuseLocalIBL (t6)
      dcl_resource_texture2d (float,float,float,float) g_SpecularLocalIBL (t7)
      dcl_resource_structured g_TileSetParamBlock (t21), 128
      dcl_resource_structured g_StreamTextureParamBlock (t22), 32
      dcl_resource_texture2d (float,float,float,float) g_PageTableTexture (t23)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_resource_texture2d (float,float,float,float) g_DiffuseAmbientAreaLight (t29)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_input_ps linear v1.xyzw
      dcl_input_ps linear v2.xyzw
      dcl_input_ps linear v3.xyzw
      dcl_input_ps linear v4.xyz
      dcl_input_ps nointerpolation v7.x
      dcl_output o0.xyzw
      dcl_temps 22
   0: div r0.xy, v0.xyxx, g_TargetUvParam.zwzz
   1: add r1.xyz, -v1.xyzx, g_CameraVec.xyzx
   2: dp3 r0.z, r1.xyzx, r1.xyzx
   3: rsq r0.z, r0.z
   4: mul r1.xyz, r0.zzzz, r1.xyzx
   5: iadd r2.xyzw, v7.xxxx, l(2, 6, 8, 5)
   6: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.z, r2.y, l(0), g_InstanceParam.xxxx
   7: and r0.w, r0.z, l(0x0000ffff)
   8: ushr r0.z, r0.z, l(16)
   9: f16tof32 r3.xy, r0.wzww
  10: mov r4.x, v2.w
  11: mov r4.y, v3.w
  12: add r0.zw, -r3.xxxy, r4.xxxy
  13: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.w, r2.z, l(0), g_InstanceParam.xxxx
  14: and r2.y, r1.w, l(0x0000ffff)
  15: f16tof32 r3.x, r2.y
  16: ushr r1.w, r1.w, l(16)
  17: f16tof32 r3.y, r1.w
  18: add r2.yz, -r3.xxyx, r4.xxyx
  19: add r0.zw, r0.zzzw, l(0.000000, 0.000000, -0.500000, -0.500000)
  20: add r2.yz, r2.yyzy, l(0.000000, -0.500000, -0.500000, 0.000000)
  21: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.w, r2.x, l(0), g_InstanceParam.xxxx
  22: and r2.x, r1.w, l(0x0000ffff)
  23: f16tof32 r2.x, r2.x
  24: ushr r1.w, r1.w, l(16)
  25: f16tof32 r1.w, r1.w
  26: sincos r2.x, r3.x, r2.x
  27: sincos r5.x, r6.x, r1.w
  28: mov r7.x, -r2.x
  29: mov r7.y, r3.x
  30: mov r7.z, r2.x
  31: dp2 r3.x, r0.zwzz, r7.yzyy
  32: dp2 r3.y, r0.zwzz, r7.xyxx
  33: mov r7.x, -r5.x
  34: mov r7.y, r6.x
  35: mov r7.z, r5.x
  36: dp2 r5.x, r2.yzyy, r7.yzyy
  37: dp2 r5.y, r2.yzyy, r7.xyxx
  38: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.z, r2.w, l(0), g_InstanceParam.xxxx
  39: and r0.w, r0.z, l(0x0000ffff)
  40: ushr r0.z, r0.z, l(16)
  41: f16tof32 r0.zw, r0.zzzw
  42: rcp r2.xy, r0.wzww
  43: iadd r6.xyzw, v7.xxxx, l(7, 12, 13, 3)
  44: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.z, r6.x, l(0), g_InstanceParam.xxxx
  45: and r0.w, r0.z, l(0x0000ffff)
  46: ushr r0.z, r0.z, l(16)
  47: f16tof32 r0.zw, r0.zzzw
  48: rcp r7.xy, r0.wzww
  49: mad r0.zw, r3.xxxy, r2.xxxy, l(0.000000, 0.000000, 0.500000, 0.500000)
  50: mad r2.xy, r5.xyxx, r7.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  51: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.w, r6.y, l(0), g_InstanceParam.xxxx
  52: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.z, r6.z, l(0), g_InstanceParam.xxxx
  53: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r3.xy, r2.z, l(32), g_TileSetParamBlock.xyxx
  54: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r5.xy, r2.z, l(48), g_TileSetParamBlock.xyxx
  55: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r7.xyzw, r2.z, l(4), g_TileSetParamBlock.xyzw
  56: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r8.xyzw, r2.z, l(112), g_TileSetParamBlock.xyzw
  57: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r9.xyzw, r1.w, l(0), g_StreamTextureParamBlock.xyzw
  58: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r2.w, r1.w, l(16), g_StreamTextureParamBlock.xxxx
  59: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r1.w, r1.w, l(28), g_StreamTextureParamBlock.xxxx
  60: deriv_rtx_coarse r6.xyz, r0.zwzz
  61: mul r6.xyz, r6.xyzx, r9.zwzz
  62: deriv_rty_coarse r10.xyz, r0.zwzz
  63: mul r10.xyz, r9.zwzz, r10.xyzx
  64: frc r3.zw, r0.zzzw
  65: mad r4.zw, r3.zzzw, r9.zzzw, r9.xxxy
  66: mul r11.xy, r7.yzyy, r6.zyzz
  67: mul r11.zw, r7.yyyz, r10.zzzy
  68: dp2 r5.w, r11.xyxx, r11.xyxx
  69: dp2 r10.w, r11.zwzz, r11.zwzz
  70: max r11.x, r5.w, r10.w
  71: min r5.w, r5.w, r10.w
  72: log r10.w, r11.x
  73: mul r11.x, r10.w, l(0.500000)
  74: log r5.w, r5.w
  75: mad r5.w, -r5.w, l(0.500000), r11.x
  76: min r5.w, r7.x, r5.w
  77: mad r5.w, r10.w, l(0.500000), -r5.w
  78: add r5.w, r5.w, l(-0.500000)
  79: max r5.w, r5.w, l(0)
  80: min r5.w, r2.w, r5.w
  81: add r5.w, r5.w, l(0.500000)
  82: round_ni r5.w, r5.w
  83: mul r5.z, r5.y, r5.x
  84: mul r11.xy, r4.zwzz, r5.xzxx
  85: exp r10.w, -r5.w
  86: mul r11.xy, r10.wwww, r11.xyxx
  87: round_ni r11.xy, r11.xyxx
  88: ftoi r11.xy, r11.xyxx
  89: ftoi r11.zw, r5.wwww
  90: ld_indexable(texture2d)(float,float,float,float) r11.xy, r11.xyzw, g_PageTableTexture.wxyz
  91: and r11.y, r11.y, l(15)
  92: utof r11.y, r11.y
  93: add r11.y, r1.w, -r11.y
  94: lt r11.z, r2.w, r11.y
  95: if_nz r11.z
  96:   add r11.y, -r2.w, r11.y
  97:   max r11.y, r11.y, l(0)
  98:   min r11.y, r11.y, l(6.000000)
  99:   ftou r11.y, r11.y
 100:   add r11.z, l(1.000000), -icb[r11.y + 3].x
 101:   max r3.zw, r3.zzzw, icb[r11.y + 3].xxxx
 102:   min r3.zw, r11.zzzz, r3.zzzw
 103:   mad r4.zw, r3.zzzw, r9.zzzw, r9.xxxy
 104:   mul r3.zw, r5.xxxz, r4.zzzw
 105:   mul r3.zw, r10.wwww, r3.zzzw
 106:   round_ni r3.zw, r3.zzzw
 107:   ftoi r12.xy, r3.zwzz
 108:   ftoi r12.zw, r5.wwww
 109:   ld_indexable(texture2d)(float,float,float,float) r11.x, r12.xyzw, g_PageTableTexture.wxyz
 110: endif
 111: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r12.xyzw, r2.z, l(96), g_TileSetParamBlock.xyzw
 112: deriv_rtx_coarse r11.yzw, r2.xxyx
 113: mul r11.yzw, r9.zzwz, r11.yyzw
 114: deriv_rty_coarse r13.xyz, r2.xyxx
 115: mul r13.xyz, r9.zwzz, r13.xyzx
 116: frc r2.xy, r2.xyxx
 117: mad r3.zw, r2.xxxy, r9.zzzw, r9.xxxy
 118: mul r14.xy, r7.yzyy, r11.wzww
 119: mul r14.zw, r7.yyyz, r13.zzzy
 120: dp2 r5.w, r14.xyxx, r14.xyxx
 121: dp2 r10.w, r14.zwzz, r14.zwzz
 122: max r13.w, r5.w, r10.w
 123: min r5.w, r5.w, r10.w
 124: log r10.w, r13.w
 125: mul r13.w, r10.w, l(0.500000)
 126: log r5.w, r5.w
 127: mad r5.w, -r5.w, l(0.500000), r13.w
 128: min r5.w, r7.x, r5.w
 129: mad r5.w, r10.w, l(0.500000), -r5.w
 130: add r5.w, r5.w, l(-0.500000)
 131: max r5.w, r5.w, l(0)
 132: min r5.w, r2.w, r5.w
 133: add r5.w, r5.w, l(0.500000)
 134: round_ni r5.w, r5.w
 135: mul r14.xy, r5.xzxx, r3.zwzz
 136: exp r10.w, -r5.w
 137: mul r14.xy, r10.wwww, r14.xyxx
 138: round_ni r14.xy, r14.xyxx
 139: ftoi r14.xy, r14.xyxx
 140: ftoi r14.zw, r5.wwww
 141: ld_indexable(texture2d)(float,float,float,float) r14.xy, r14.xyzw, g_PageTableTexture.zxyw
 142: and r13.w, r14.y, l(15)
 143: utof r13.w, r13.w
 144: add r13.w, r1.w, -r13.w
 145: lt r14.y, r2.w, r13.w
 146: if_nz r14.y
 147:   add r13.w, -r2.w, r13.w
 148:   max r13.w, r13.w, l(0)
 149:   min r13.w, r13.w, l(6.000000)
 150:   ftou r13.w, r13.w
 151:   add r14.y, l(1.000000), -icb[r13.w + 3].x
 152:   max r2.xy, r2.xyxx, icb[r13.w + 3].xxxx
 153:   min r2.xy, r14.yyyy, r2.xyxx
 154:   mad r3.zw, r2.xxxy, r9.zzzw, r9.xxxy
 155:   mul r2.xy, r5.xzxx, r3.zwzz
 156:   mul r2.xy, r10.wwww, r2.xyxx
 157:   round_ni r2.xy, r2.xyxx
 158:   ftoi r15.xy, r2.xyxx
 159:   ftoi r15.zw, r5.wwww
 160:   ld_indexable(texture2d)(float,float,float,float) r14.x, r15.xyzw, g_PageTableTexture.zxyw
 161: endif
 162: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r15.xyzw, r2.z, l(64), g_TileSetParamBlock.xyzw
 163: deriv_rtx_coarse r14.yzw, r4.xxyx
 164: mul r14.yzw, r9.zzwz, r14.yyzw
 165: deriv_rty_coarse r16.xyz, r4.xyxx
 166: mul r16.xyz, r9.zwzz, r16.xyzx
 167: frc r2.xy, r4.xyxx
 168: mad r4.xy, r2.xyxx, r9.zwzz, r9.xyxx
 169: mul r17.xy, r7.yzyy, r14.wzww
 170: mul r17.zw, r7.yyyz, r16.zzzy
 171: dp2 r5.w, r17.xyxx, r17.xyxx
 172: dp2 r10.w, r17.zwzz, r17.zwzz
 173: max r13.w, r5.w, r10.w
 174: min r5.w, r5.w, r10.w
 175: log r10.w, r13.w
 176: mul r13.w, r10.w, l(0.500000)
 177: log r5.w, r5.w
 178: mad r5.w, -r5.w, l(0.500000), r13.w
 179: min r5.w, r7.x, r5.w
 180: mad r5.w, r10.w, l(0.500000), -r5.w
 181: add r5.w, r5.w, l(-0.500000)
 182: max r5.w, r5.w, l(0)
 183: min r5.w, r2.w, r5.w
 184: add r5.w, r5.w, l(0.500000)
 185: round_ni r5.w, r5.w
 186: mul r17.xy, r5.xzxx, r4.xyxx
 187: exp r10.w, -r5.w
 188: mul r17.xy, r10.wwww, r17.xyxx
 189: round_ni r17.xy, r17.xyxx
 190: ftoi r17.xy, r17.xyxx
 191: ftoi r17.zw, r5.wwww
 192: ld_indexable(texture2d)(float,float,float,float) r13.w, r17.xyzw, g_PageTableTexture.yzwx
 193: and r16.w, r13.w, l(15)
 194: utof r16.w, r16.w
 195: add r16.w, r1.w, -r16.w
 196: lt r17.x, r2.w, r16.w
 197: if_nz r17.x
 198:   add r16.w, -r2.w, r16.w
 199:   max r16.w, r16.w, l(0)
 200:   min r16.w, r16.w, l(6.000000)
 201:   ftou r16.w, r16.w
 202:   add r17.x, l(1.000000), -icb[r16.w + 3].x
 203:   max r2.xy, r2.xyxx, icb[r16.w + 3].xxxx
 204:   min r2.xy, r17.xxxx, r2.xyxx
 205:   mad r4.xy, r2.xyxx, r9.zwzz, r9.xyxx
 206:   mul r2.xy, r5.xzxx, r4.xyxx
 207:   mul r2.xy, r10.wwww, r2.xyxx
 208:   round_ni r2.xy, r2.xyxx
 209:   ftoi r17.xy, r2.xyxx
 210:   ftoi r17.zw, r5.wwww
 211:   ld_indexable(texture2d)(float,float,float,float) r13.w, r17.xyzw, g_PageTableTexture.yzwx
 212: endif
 213: ubfe r17.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r11.xxxx
 214: and r2.x, r11.x, l(15)
 215: utof r2.x, r2.x
 216: exp r18.xz, r2.xxxx
 217: mul r18.y, r5.y, r18.z
 218: mul r2.xy, r4.zwzz, r18.zyzz
 219: frc r2.xy, r2.xyxx
 220: utof r17.xyz, r17.xyzx
 221: mad r2.xy, r2.xyxx, r3.xyxx, r17.xyxx
 222: mad r17.xy, r2.xyxx, r8.xyxx, r8.zwzz
 223: mul r18.xyz, r3.xyxx, r18.xyzx
 224: mul r18.xyz, r8.xyxx, r18.xyzx
 225: mul r18.xyz, r7.wwww, r18.xyzx
 226: mul r6.xyz, r6.xyzx, r18.xyzx
 227: mul r10.xyz, r10.xyzx, r18.xyzx
 228: sample_d(texture2darray)(float,float,float,float) r2.xy, r17.xyzx, g_MaskCacheTexture.xyzw, g_CacheSampler, r6.xyzx, r10.xyzx
 229: dp3 r6.x, r1.xyzx, g_View[0].xyzx
 230: dp3 r6.y, r1.xyzx, g_View[1].xyzx
 231: dp3 r6.z, r1.xyzx, g_View[2].xyzx
 232: mul r1.x, r2.x, g_ParallaxBias.x
 233: dp3 r1.y, r6.xyzx, v3.xyzx
 234: dp3 r10.y, r6.xyzx, v4.xyzx
 235: dp3 r1.z, r6.xyzx, v2.xyzx
 236: mov r10.x, -r1.y
 237: div r1.yz, r10.xxyx, r1.zzzz
 238: mad r4.zw, -r1.yyyz, r1.xxxx, r0.zzzw
 239: dp3 r1.x, v2.xyzx, v2.xyzx
 240: rsq r1.x, r1.x
 241: mul r10.xyz, r1.xxxx, v2.xyzx
 242: dp3 r1.x, r6.xyzx, r6.xyzx
 243: rsq r1.x, r1.x
 244: mul r17.xyz, r1.xxxx, r6.xyzx
 245: dp3_sat r1.x, r10.xyzx, r17.xyzx
 246: mul r1.x, r1.x, l(3.500000)
 247: min r1.x, r1.x, l(1.000000)
 248: mul r1.x, r1.x, r2.x
 249: mul r1.x, r1.x, l(-0.030000)
 250: mad r0.zw, -r1.yyyz, r1.xxxx, r0.zzzw
 251: add r1.xy, r4.zwzz, l(-0.500000, -0.500000, 0.000000, 0.000000)
 252: mul r4.zw, r1.xxxy, cb5[1].yyyx
 253: mul r10.x, r4.z, l(11.000000)
 254: mad r10.z, r4.w, l(11.000000), l(0.180000)
 255: dp2 r1.z, r10.xzxx, r10.xzxx
 256: sqrt r1.z, r1.z
 257: min r1.z, r1.z, l(1.000000)
 258: add r1.z, -r1.z, l(2.000000)
 259: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.x, r6.w, l(0), g_InstanceParam.xxxx
 260: min r1.z, r1.z, r2.x
 261: mad r1.xy, r1.xyxx, r1.zzzz, l(0.500000, 0.500000, 0.000000, 0.000000)
 262: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r10.xyzw, r2.z, l(80), g_TileSetParamBlock.xyzw
 263: deriv_rtx_coarse r17.xyz, r1.xyxx
 264: mul r17.xyz, r9.zwzz, r17.xyzx
 265: deriv_rty_coarse r18.xyz, r1.xyxx
 266: mul r18.xyz, r9.zwzz, r18.xyzx
 267: frc r1.xy, r1.xyxx
 268: mad r2.xz, r1.xxyx, r9.zzwz, r9.xxyx
 269: mul r4.zw, r7.yyyz, r17.zzzy
 270: mul r19.xy, r7.yzyy, r18.zyzz
 271: dp2 r1.z, r4.zwzz, r4.zwzz
 272: dp2 r4.z, r19.xyxx, r19.xyxx
 273: max r4.w, r1.z, r4.z
 274: min r1.z, r1.z, r4.z
 275: log r4.z, r4.w
 276: mul r4.w, r4.z, l(0.500000)
 277: log r1.z, r1.z
 278: mad r1.z, -r1.z, l(0.500000), r4.w
 279: min r1.z, r7.x, r1.z
 280: mad r1.z, r4.z, l(0.500000), -r1.z
 281: add r1.z, r1.z, l(-0.500000)
 282: max r1.z, r1.z, l(0)
 283: min r1.z, r2.w, r1.z
 284: add r1.z, r1.z, l(0.500000)
 285: round_ni r1.z, r1.z
 286: mul r4.zw, r5.xxxz, r2.xxxz
 287: exp r5.w, -r1.z
 288: mul r4.zw, r4.zzzw, r5.wwww
 289: round_ni r4.zw, r4.zzzw
 290: ftoi r19.xy, r4.zwzz
 291: ftoi r19.zw, r1.zzzz
 292: ld_indexable(texture2d)(float,float,float,float) r4.zw, r19.xyzw, g_PageTableTexture.zwyx
 293: and r4.w, r4.w, l(15)
 294: utof r4.w, r4.w
 295: add r4.w, r1.w, -r4.w
 296: lt r6.w, r2.w, r4.w
 297: if_nz r6.w
 298:   add r4.w, -r2.w, r4.w
 299:   max r4.w, r4.w, l(0)
 300:   min r4.w, r4.w, l(6.000000)
 301:   ftou r4.w, r4.w
 302:   add r6.w, l(1.000000), -icb[r4.w + 3].x
 303:   max r1.xy, r1.xyxx, icb[r4.w + 3].xxxx
 304:   min r1.xy, r6.wwww, r1.xyxx
 305:   mad r2.xz, r1.xxyx, r9.zzwz, r9.xxyx
 306:   mul r1.xy, r5.xzxx, r2.xzxx
 307:   mul r1.xy, r5.wwww, r1.xyxx
 308:   round_ni r1.xy, r1.xyxx
 309:   ftoi r19.xy, r1.xyxx
 310:   ftoi r19.zw, r1.zzzz
 311:   ld_indexable(texture2d)(float,float,float,float) r4.z, r19.xyzw, g_PageTableTexture.zwyx
 312: endif
 313: deriv_rtx_coarse r1.xyz, r0.zwzz
 314: mul r1.xyz, r1.xyzx, r9.zwzz
 315: deriv_rty_coarse r19.xyz, r0.zwzz
 316: mul r19.xyz, r9.zwzz, r19.xyzx
 317: frc r0.zw, r0.zzzw
 318: mad r20.xy, r0.zwzz, r9.zwzz, r9.xyxx
 319: mul r20.zw, r7.yyyz, r1.zzzy
 320: mul r7.yz, r7.yyzy, r19.zzyz
 321: dp2 r4.w, r20.zwzz, r20.zwzz
 322: dp2 r5.w, r7.yzyy, r7.yzyy
 323: max r6.w, r4.w, r5.w
 324: min r4.w, r4.w, r5.w
 325: log r5.w, r6.w
 326: mul r6.w, r5.w, l(0.500000)
 327: log r4.w, r4.w
 328: mad r4.w, -r4.w, l(0.500000), r6.w
 329: min r4.w, r7.x, r4.w
 330: mad r4.w, r5.w, l(0.500000), -r4.w
 331: add r4.w, r4.w, l(-0.500000)
 332: max r4.w, r4.w, l(0)
 333: min r4.w, r2.w, r4.w
 334: add r4.w, r4.w, l(0.500000)
 335: round_ni r4.w, r4.w
 336: mul r7.xy, r5.xzxx, r20.xyxx
 337: exp r5.w, -r4.w
 338: mul r7.xy, r5.wwww, r7.xyxx
 339: round_ni r7.xy, r7.xyxx
 340: ftoi r21.xy, r7.xyxx
 341: ftoi r21.zw, r4.wwww
 342: ld_indexable(texture2d)(float,float,float,float) r7.xyz, r21.xyzw, g_PageTableTexture.yxwz
 343: and r6.w, r7.y, l(15)
 344: utof r6.w, r6.w
 345: add r1.w, r1.w, -r6.w
 346: lt r6.w, r2.w, r1.w
 347: if_nz r6.w
 348:   add r1.w, -r2.w, r1.w
 349:   max r1.w, r1.w, l(0)
 350:   min r1.w, r1.w, l(6.000000)
 351:   ftou r1.w, r1.w
 352:   add r2.w, l(1.000000), -icb[r1.w + 3].x
 353:   max r0.zw, r0.zzzw, icb[r1.w + 3].xxxx
 354:   min r0.zw, r2.wwww, r0.zzzw
 355:   mad r20.xy, r0.zwzz, r9.zwzz, r9.xyxx
 356:   mul r0.zw, r5.xxxz, r20.xxxy
 357:   mul r0.zw, r5.wwww, r0.zzzw
 358:   round_ni r0.zw, r0.zzzw
 359:   ftoi r9.xy, r0.zwzz
 360:   ftoi r9.zw, r4.wwww
 361:   ld_indexable(texture2d)(float,float,float,float) r7.xz, r9.xyzw, g_PageTableTexture.yxwz
 362: endif
 363: ubfe r5.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r13.wwww
 364: and r0.z, r13.w, l(15)
 365: utof r0.z, r0.z
 366: exp r9.xz, r0.zzzz
 367: mul r9.y, r5.y, r9.z
 368: mul r0.zw, r4.xxxy, r9.zzzy
 369: frc r0.zw, r0.zzzw
 370: utof r4.xyw, r5.xzxw
 371: mad r0.zw, r0.zzzw, r3.xxxy, r4.xxxy
 372: mad r4.xy, r0.zwzz, r15.xyxx, r15.zwzz
 373: mul r5.xzw, r3.xxyx, r9.xxyz
 374: mul r5.xzw, r15.xxyx, r5.xxzw
 375: mul r5.xzw, r7.wwww, r5.xxzw
 376: mul r9.xyz, r5.xzwx, r14.yzwy
 377: mul r5.xzw, r5.xxzw, r16.xxyz
 378: sample_d(texture2darray)(float,float,float,float) r4.xyw, r4.xywx, g_AlbedoCacheTexture.xywz, g_CacheSampler, r9.xyzx, r5.xzwx
 379: ubfe r5.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r4.zzzz
 380: and r0.z, r4.z, l(15)
 381: utof r0.z, r0.z
 382: exp r9.xz, r0.zzzz
 383: mul r9.y, r5.y, r9.z
 384: mul r0.zw, r2.xxxz, r9.zzzy
 385: frc r0.zw, r0.zzzw
 386: utof r2.xzw, r5.xxzw
 387: mad r0.zw, r0.zzzw, r3.xxxy, r2.xxxz
 388: mad r2.xz, r0.zzwz, r10.xxyx, r10.zzwz
 389: mul r5.xzw, r3.xxyx, r9.xxyz
 390: mul r5.xzw, r10.xxyx, r5.xxzw
 391: mul r5.xzw, r7.wwww, r5.xxzw
 392: mul r9.xyz, r5.xzwx, r17.xyzx
 393: mul r5.xzw, r5.xxzw, r18.xxyz
 394: sample_d(texture2darray)(float,float,float,float) r2.xzw, r2.xzwx, g_AlbedoCacheTexture.xwyz, g_CacheSampler, r9.xyzx, r5.xzwx
 395: ubfe r5.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r7.xxxx
 396: and r0.z, r7.x, l(15)
 397: utof r0.z, r0.z
 398: exp r9.xz, r0.zzzz
 399: mul r9.y, r5.y, r9.z
 400: mul r0.zw, r9.zzzy, r20.xxxy
 401: frc r0.zw, r0.zzzw
 402: utof r5.xzw, r5.xxzw
 403: mad r0.zw, r0.zzzw, r3.xxxy, r5.xxxz
 404: mad r5.xz, r0.zzwz, r10.xxyx, r10.zzwz
 405: mul r9.xyz, r3.xyxx, r9.xyzx
 406: mul r9.xyz, r10.xyxx, r9.xyzx
 407: mul r9.xyz, r7.wwww, r9.xyzx
 408: mul r10.xyz, r1.zyzz, r9.zyzz
 409: mul r9.xyz, r9.xyzx, r19.zyzz
 410: sample_d(texture2darray)(float,float,float,float) r0.z, r5.xzwx, g_AlbedoCacheTexture.xywz, g_CacheSampler, r10.xyzx, r9.xyzx
 411: add r2.xzw, -r4.xxyw, r2.xxzw
 412: mad r2.xzw, r0.zzzz, r2.xxzw, r4.xxyw
 413: if_nz g_UseMask1ForIrisEmissive.x
 414:   ubfe r4.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r7.zzzz
 415:   and r0.w, r7.z, l(15)
 416:   utof r0.w, r0.w
 417:   exp r7.xz, r0.wwww
 418:   mul r7.y, r5.y, r7.z
 419:   mul r5.xz, r7.zzyz, r20.xxyx
 420:   frc r5.xz, r5.xxzx
 421:   utof r4.xyz, r4.xyzx
 422:   mad r5.xz, r5.xxzx, r3.xxyx, r4.xxyx
 423:   mad r4.xy, r5.xzxx, r8.xyxx, r8.zwzz
 424:   mul r5.xzw, r3.xxyx, r7.xxyz
 425:   mul r5.xzw, r8.xxyx, r5.xxzw
 426:   mul r5.xzw, r7.wwww, r5.xxzw
 427:   mul r1.xyz, r1.xyzx, r5.xzwx
 428:   mul r5.xzw, r5.xxzw, r19.xxyz
 429:   sample_d(texture2darray)(float,float,float,float) r0.z, r4.xyzx, g_MaskCacheTexture.xyzw, g_CacheSampler, r1.xyzx, r5.xzwx
 430: endif
 431: add r1.xyz, g_VariationMulAlbedoColor.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 432: mad r1.xyz, r2.yyyy, r1.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 433: mul r1.xyz, r1.xyzx, r2.xzwx
 434: movc r1.xyz, g_VariationEnable.xxxx, r1.xyzx, r2.xzwx
 435: ubfe r2.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r14.xxxx
 436: and r0.w, r14.x, l(15)
 437: utof r0.w, r0.w
 438: exp r4.xz, r0.wwww
 439: mul r4.y, r5.y, r4.z
 440: mul r3.zw, r3.zzzw, r4.zzzy
 441: frc r3.zw, r3.zzzw
 442: utof r2.xyz, r2.xyzx
 443: mad r3.zw, r3.zzzw, r3.xxxy, r2.xxxy
 444: mad r2.xy, r3.zwzz, r12.xyxx, r12.zwzz
 445: mul r3.xyz, r3.xyxx, r4.xyzx
 446: mul r3.xyz, r12.xyxx, r3.xyzx
 447: mul r3.xyz, r7.wwww, r3.xyzx
 448: mul r4.xyz, r3.xyzx, r11.yzwy
 449: mul r3.xyz, r3.xyzx, r13.xyzx
 450: sample_d(texture2darray)(float,float,float,float) r2.xyzw, r2.xyzx, g_AlbedoCacheTexture.xyzw, g_CacheSampler, r4.xyzx, r3.xyzx
 451: lt r0.w, l(0.500000), charaMaterial_.useCutSceneLight_.x
 452: lt r1.w, l(0.500000), charaMaterial_.useEyeHighLightColor_.x
 453: and r0.w, r0.w, r1.w
 454: if_nz r0.w
 455:   mul r2.xyz, r2.xyzx, charaMaterial_.eyeHighLightColor_.xyzx
 456: endif
 457: mad r1.xyz, r2.xyzx, r2.wwww, r1.xyzx
 458: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, v7.x, l(0), g_InstanceParam.xxxx
 459: and r1.w, r0.w, l(255)
 460: utof r1.w, r1.w
 461: mul r2.x, r1.x, r1.w
 462: ubfe r1.xw, l(8, 0, 0, 8), l(8, 0, 0, 16), r0.wwww
 463: utof r1.xw, r1.xxxw
 464: mul r2.yz, r1.yyzy, r1.xxwx
 465: mul r1.xyz, r2.xyzx, l(0.003922, 0.003922, 0.003922, 0.000000)
 466: dp3 r2.x, v2.xyzx, g_ViewInverseMatrix[0].xyzx
 467: dp3 r2.z, v2.xyzx, g_ViewInverseMatrix[2].xyzx
 468: mov r2.y, l(0.200000)
 469: dp3 r0.w, r2.xyzx, r2.xyzx
 470: rsq r0.w, r0.w
 471: mul r2.xyz, r0.wwww, r2.xyzx
 472: dp3 r3.x, r2.xyzx, g_View[0].xyzx
 473: dp3 r3.y, r2.xyzx, g_View[1].xyzx
 474: dp3 r3.z, r2.xyzx, g_View[2].xyzx
 475: sample_indexable(texture2d)(float,float,float,float) r0.w, r0.xyxx, g_ShadowTexture.yzwx, PointClampSampler
 476: iadd r2.xy, v7.xxxx, l(1, 4, 0, 0)
 477: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.w, r2.x, l(0), g_InstanceParam.xxxx
 478: ieq r2.xzw, r1.wwww, l(1, 0, 2, 3)
 479: movc r1.w, r2.w, g_CharacterParam.w, l(1.000000)
 480: movc r1.w, r2.z, g_CharacterParam.z, r1.w
 481: movc r1.w, r2.x, g_CharacterParam.y, r1.w
 482: mul r2.x, r1.w, charaMaterial_.lightIntensity_.x
 483: max r0.w, r0.w, charaMaterial_.shadowMin_.x
 484: ne r2.z, l(0, 0, 0, 0), charaMaterial_.useCutSceneLight_.x
 485: max r2.w, r0.w, charaMaterial_.shadowOtherMin_.x
 486: movc r0.w, r2.z, r2.w, r0.w
 487: dp3_sat r2.z, r3.xyzx, charaMaterial_.directionalLightVec_.xyzx
 488: mul r4.xyz, r1.xyzx, charaMaterial_.lightColor_.xyzx
 489: mul r4.xyz, r2.xxxx, r4.xyzx
 490: mul r0.w, r0.w, r2.z
 491: mul r0.w, r0.w, l(0.318310)
 492: sample_indexable(texture2d)(float,float,float,float) r2.xzw, r0.xyxx, g_SpecularLocalIBL.xwyz, LocalIBLSampler
 493: mul r1.w, r1.w, charaMaterial_.iblOtherIntensity_.x
 494: mul r2.xzw, r1.wwww, r2.xxzw
 495: sample_indexable(texture2d)(float,float,float,float) r5.xyzw, r0.xyxx, g_DiffuseAmbientAreaLight.xyzw, AmbientAreaLightSampler
 496: ge r3.w, r5.w, l(16.000000)
 497: add r4.w, r5.w, l(-16.000000)
 498: movc r4.w, r3.w, r4.w, r5.w
 499: lt r5.w, r4.w, l(1.000000)
 500: if_nz r5.w
 501:   sample_indexable(texture2d)(float,float,float,float) r7.xyz, r0.xyxx, g_DiffuseLocalIBL.xyzw, LocalIBLSampler
 502:   mul r7.xyz, r1.wwww, r7.xyzx
 503:   frc r0.x, r4.w
 504:   add r0.x, -r0.x, l(1.000000)
 505:   mad r5.xyz, r7.xyzx, r0.xxxx, r5.xyzx
 506: else
 507:   mov r0.x, l(0)
 508: endif
 509: movc r0.x, r3.w, l(1.000000), r0.x
 510: mul r7.xyz, r0.xxxx, r2.xzwx
 511: mad r4.xyz, r4.xyzx, r0.wwww, r5.xyzx
 512: lt r0.y, l(0.500000), charaMaterial_.useCharacterLight_.x
 513: if_nz r0.y
 514:   dp4 r5.x, v1.xyzw, g_View[0].xyzw
 515:   dp4 r5.y, v1.xyzw, g_View[1].xyzw
 516:   dp4 r5.z, v1.xyzw, g_View[2].xyzw
 517:   mov r8.xyz, l(0, 0, 0, 0)
 518:   mov r0.y, l(0)
 519:   loop
 520:     ige r0.w, r0.y, l(4)
 521:     breakc_nz r0.w
 522:     dp4 r0.w, targetIndices_.directionalLightIndex.xyzw, icb[r0.y + 0].xyzw
 523:     ftoi r0.w, r0.w
 524:     ilt r1.w, r0.w, l(0)
 525:     ige r3.w, r0.w, l(64)
 526:     or r1.w, r1.w, r3.w
 527:     if_nz r1.w
 528:       iadd r1.w, r0.y, l(1)
 529:       mov r0.y, r1.w
 530:       continue
 531:     endif
 532:     imul null, r0.w, r0.w, l(3)
 533:     mul r1.w, cb9[r0.w + 0].w, cb9[r0.w + 1].w
 534:     dp3_sat r3.w, r3.xyzx, cb9[r0.w + 0].xyzx
 535:     mul r9.xyz, r1.xyzx, cb9[r0.w + 1].xyzx
 536:     mul r9.xyz, r1.wwww, r9.xyzx
 537:     mul r0.w, r3.w, l(0.318310)
 538:     mad r8.xyz, r9.xyzx, r0.wwww, r8.xyzx
 539:     iadd r0.y, r0.y, l(1)
 540:   endloop
 541:   dp3 r0.y, r3.xyzx, r3.xyzx
 542:   rsq r0.y, r0.y
 543:   mul r3.xyz, r0.yyyy, r3.xyzx
 544:   mov r9.xyz, l(0, 0, 0, 0)
 545:   mov r10.xyz, l(0, 0, 0, 0)
 546:   mov r0.y, l(0)
 547:   loop
 548:     ige r0.w, r0.y, l(4)
 549:     breakc_nz r0.w
 550:     dp4 r0.w, targetIndices_.pointLightIndex.xyzw, icb[r0.y + 0].xyzw
 551:     ftoi r0.w, r0.w
 552:     ilt r1.w, r0.w, l(0)
 553:     ige r3.w, r0.w, l(64)
 554:     or r1.w, r1.w, r3.w
 555:     if_nz r1.w
 556:       iadd r1.w, r0.y, l(1)
 557:       mov r0.y, r1.w
 558:       continue
 559:     endif
 560:     ishl r0.w, r0.w, l(2)
 561:     add r11.xyz, -r5.xyzx, cb11[r0.w + 0].xyzx
 562:     dp3 r1.w, r11.xyzx, r11.xyzx
 563:     rsq r3.w, r1.w
 564:     mul r12.xyz, r3.wwww, r11.xyzx
 565:     mul r4.w, cb11[r0.w + 0].w, cb11[r0.w + 0].w
 566:     mul r4.w, r1.w, r4.w
 567:     mad r4.w, -r4.w, r4.w, l(1.000000)
 568:     max r4.w, r4.w, l(0)
 569:     mul r4.w, r4.w, r4.w
 570:     mul r4.w, r4.w, cb11[r0.w + 2].w
 571:     mul r4.w, r4.w, cb11[r0.w + 2].w
 572:     dp3 r5.w, -cb11[r0.w + 2].xyzx, r12.xyzx
 573:     mad_sat r5.w, r5.w, cb11[r0.w + 3].x, cb11[r0.w + 3].y
 574:     sqrt r6.w, r1.w
 575:     mul r6.w, r6.w, l(3.000000)
 576:     div_sat r6.w, cb11[r0.w + 1].w, r6.w
 577:     mad r11.xyz, r11.xyzx, r3.wwww, r6.xyzx
 578:     dp3 r3.w, r11.xyzx, r11.xyzx
 579:     rsq r3.w, r3.w
 580:     mul r11.xyz, r3.wwww, r11.xyzx
 581:     mul r3.w, r6.w, r6.w
 582:     mul r7.w, r3.w, r3.w
 583:     dp3_sat r8.w, r12.xyzx, r11.xyzx
 584:     dp3_sat r9.w, r3.xyzx, r11.xyzx
 585:     dp3_sat r10.w, r3.xyzx, r12.xyzx
 586:     mul r9.w, r9.w, r9.w
 587:     mad r3.w, r3.w, r3.w, l(-1.000000)
 588:     mad r3.w, r9.w, r3.w, l(1.000000)
 589:     mul r3.w, r8.w, r3.w
 590:     mul r3.w, r3.w, r3.w
 591:     mul r3.w, r3.w, l(12.566371)
 592:     add r6.w, r6.w, l(0.500000)
 593:     mul r3.w, r3.w, r6.w
 594:     max r3.w, r3.w, l(0.000010)
 595:     div r3.w, r7.w, r3.w
 596:     mul r3.w, r10.w, r3.w
 597:     max r1.w, r1.w, l(0.010000)
 598:     rcp r1.w, r1.w
 599:     mul r1.w, r10.w, r1.w
 600:     mul r1.w, r1.w, cb11[r0.w + 3].z
 601:     mul r11.xyz, r1.xyzx, cb11[r0.w + 1].xyzx
 602:     mul r6.w, r1.w, r5.w
 603:     mul r6.w, r4.w, r6.w
 604:     mad r9.xyz, r11.xyzx, r6.wwww, r9.xyzx
 605:     mul r3.w, r3.w, r5.w
 606:     mul r1.w, r1.w, r3.w
 607:     mul r1.w, r4.w, r1.w
 608:     mad r10.xyz, cb11[r0.w + 1].xyzx, r1.wwww, r10.xyzx
 609:     iadd r0.y, r0.y, l(1)
 610:   endloop
 611:   add r1.xyz, r8.xyzx, r9.xyzx
 612:   add r4.xyz, r1.xyzx, r4.xyzx
 613:   mad r7.xyz, r2.xzwx, r0.xxxx, r10.xyzx
 614: endif
 615: mad r0.xyw, charaMaterial_.eyeEmissiveColor_.xyxz, r0.zzzz, l(1.000000, 1.000000, 0.000000, 1.000000)
 616: mad r0.xyz, r0.xywx, r0.zzzz, l(1.000000, 1.000000, 1.000000, 0.000000)
 617: mul r0.xyz, r0.xyzx, r0.xyzx
 618: mul r1.xyz, r0.xyzx, r0.xyzx
 619: mul r1.xyz, r1.xyzx, r1.xyzx
 620: mad r0.xyz, r0.xyzx, r1.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 621: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, r2.y, l(0), g_InstanceParam.xxxx
 622: mad r0.xyz, r0.xyzx, r0.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
 623: mad o0.xyz, r4.xyzx, r0.xyzx, r7.xyzx
 624: mov o0.w, l(1.000000)
 625: ret
