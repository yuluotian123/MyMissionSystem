Shader hash 6690c4cb-d9464df4-79d298d7-e2ebd463

// Note: shader requires additional functionality:
//       64 UAV slots
//
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
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb1[18] (ParamBuffer), immediateIndexed
      dcl_constantbuffer cb11[1] (DepthFadeBuffer), immediateIndexed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_sampler g_CacheSampler (s6), mode_default
      dcl_sampler g_NoiseTextureSampler (s12), mode_default
      dcl_resource_texture2darray (float,float,float,float) g_AlbedoCacheTexture (t0)
      dcl_resource_texture2darray (float,float,float,float) g_NormalCacheTexture (t1)
      dcl_resource_texture2darray (float,float,float,float) g_MaskCacheTexture (t2)
      dcl_resource_structured g_TileSetParamBlock (t5), 128
      dcl_resource_structured g_StreamTextureParamBlock (t6), 32
      dcl_resource_texture2d (float,float,float,float) g_PageTableTexture (t7)
      dcl_resource_texture2d (float,float,float,float) g_DepthMap (t8)
      dcl_resource_texture2d (float,float,float,float) g_DetailNormalMap (t9)
      dcl_resource_texture2d (float,float,float,float) g_NoiseTexture (t12)
      dcl_resource_texture2d (float,float,float,float) g_UberColorNoiseMap (t20)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_uav_typed_texture2d (unorm,unorm,unorm,unorm) g_ResolveParam0 (u8)
      dcl_uav_typed_texture2d (unorm,unorm,unorm,unorm) g_ResolveParam1 (u9)
      dcl_input_ps_siv linear noperspective v0.xyz, position
      dcl_input_ps linear v1.xyzw
      dcl_input_ps linear v2.xyzw
      dcl_input_ps linear v3.xyz
      dcl_input_ps linear v4.xyzw
      dcl_input_ps linear v5.xyz
      dcl_input_ps linear v6.xyz
      dcl_input_ps linear v7.xyw
      dcl_input_ps linear v8.xyw
      dcl_input_ps linear v9.xy
      dcl_input_ps linear v9.zw
      dcl_input_ps nointerpolation v10.x
      dcl_output o0.xyzw
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.xy
      dcl_temps 21
   0: div r0.xy, v7.xyxx, v7.wwww
   1: add r0.xy, r0.xyxx, g_ProjectionOffset.xyxx
   2: add r0.xy, r0.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
   3: div r1.xy, v8.xyxx, v8.wwww
   4: add r1.xy, r1.xyxx, g_ProjectionOffset.zwzz
   5: add r1.xy, r1.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
   6: mul r1.x, r1.x, l(0.500000)
   7: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, v10.x, l(0), g_InstanceParam.xxxx
   8: and r1.w, r0.w, l(255)
   9: utof r1.w, r1.w
  10: mul r2.x, r1.w, l(0.003922)
  11: ubfe r3.xy, l(8, 8, 0, 0), l(8, 16, 0, 0), r0.wwww
  12: utof r3.xy, r3.xyxx
  13: mul r2.yz, r3.xxyx, l(0.000000, 0.003922, 0.003922, 0.000000)
  14: mov r0.w, g_VertexColorIndex0.x
  15: dp4 r0.w, v1.xyzw, icb[r0.w + 0].xyzw
  16: mul r3.xy, cb1[12].zwzz, l(0.017453, 0.017453, 0.000000, 0.000000)
  17: sincos r3.x, r4.x, r3.x
  18: add r3.zw, v2.yyyx, l(0.000000, 0.000000, -0.500000, -0.500000)
  19: mul r4.yz, r3.xxxx, r3.zzwz
  20: mad r5.x, r3.w, r4.x, -r4.y
  21: mad r5.y, r3.z, r4.x, r4.z
  22: add r4.xy, r5.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  23: mul r4.xy, r4.xyxx, g_UVTile0.xyxx
  24: movc r4.xy, g_IsUseWorldUV0.xxxx, v9.xyxx, r4.xyxx
  25: iadd r5.xyz, v10.xxxx, l(10, 11, 12, 0)
  26: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.w, r5.x, l(0), g_InstanceParam.xxxx
  27: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.w, r5.y, l(0), g_InstanceParam.xxxx
  28: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r4.zw, r1.w, l(32), g_TileSetParamBlock.xxxy
  29: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r6.xy, r1.w, l(48), g_TileSetParamBlock.xyxx
  30: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r7.xyzw, r1.w, l(4), g_TileSetParamBlock.xyzw
  31: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r8.xyzw, r1.w, l(64), g_TileSetParamBlock.xyzw
  32: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r9.xyzw, r2.w, l(0), g_StreamTextureParamBlock.xyzw
  33: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r3.x, r2.w, l(16), g_StreamTextureParamBlock.xxxx
  34: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r2.w, r2.w, l(28), g_StreamTextureParamBlock.xxxx
  35: deriv_rtx_coarse r5.xyw, r4.xyxx
  36: mul r5.xyw, r5.xyxw, r9.zwzz
  37: deriv_rty_coarse r10.xyz, r4.xyxx
  38: mul r10.xyz, r9.zwzz, r10.xyzx
  39: frc r4.xy, r4.xyxx
  40: mad r11.xy, r4.xyxx, r9.zwzz, r9.xyxx
  41: mul r11.zw, r7.yyyz, r5.wwwy
  42: mul r12.xy, r7.yzyy, r10.zyzz
  43: dp2 r6.w, r11.zwzz, r11.zwzz
  44: dp2 r10.w, r12.xyxx, r12.xyxx
  45: max r11.z, r6.w, r10.w
  46: min r6.w, r6.w, r10.w
  47: log r10.w, r11.z
  48: mul r11.z, r10.w, l(0.500000)
  49: log r6.w, r6.w
  50: mad r6.w, -r6.w, l(0.500000), r11.z
  51: min r6.w, r7.x, r6.w
  52: mad r6.w, r10.w, l(0.500000), -r6.w
  53: add r6.w, r6.w, l(-0.500000)
  54: max r6.w, r6.w, l(0)
  55: min r6.w, r3.x, r6.w
  56: add r6.w, r6.w, l(0.500000)
  57: round_ni r6.w, r6.w
  58: mul r6.z, r6.y, r6.x
  59: mul r11.zw, r6.xxxz, r11.xxxy
  60: exp r10.w, -r6.w
  61: mul r11.zw, r10.wwww, r11.zzzw
  62: round_ni r11.zw, r11.zzzw
  63: ftoi r12.xy, r11.zwzz
  64: ftoi r12.zw, r6.wwww
  65: ld_indexable(texture2d)(float,float,float,float) r12.xyz, r12.xyzw, g_PageTableTexture.xyzw
  66: and r12.w, r12.x, l(15)
  67: utof r12.w, r12.w
  68: add r2.w, r2.w, -r12.w
  69: lt r12.w, r3.x, r2.w
  70: if_nz r12.w
  71:   add r13.x, -r3.x, r2.w
  72:   max r13.x, r13.x, l(0)
  73:   min r13.x, r13.x, l(6.000000)
  74:   ftou r13.x, r13.x
  75:   add r13.y, l(1.000000), -icb[r13.x + 3].x
  76:   max r13.xz, r4.xxyx, icb[r13.x + 3].xxxx
  77:   min r13.xy, r13.yyyy, r13.xzxx
  78:   mad r13.xy, r13.xyxx, r9.zwzz, r9.xyxx
  79:   mul r13.zw, r6.xxxz, r13.xxxy
  80:   mul r13.zw, r10.wwww, r13.zzzw
  81:   round_ni r13.zw, r13.zzzw
  82:   ftoi r14.xy, r13.zwzz
  83:   ftoi r14.zw, r6.wwww
  84:   ld_indexable(texture2d)(float,float,float,float) r12.x, r14.xyzw, g_PageTableTexture.xyzw
  85: else
  86:   mov r13.xy, r11.xyxx
  87: endif
  88: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r13.z, r1.w, l(60), g_TileSetParamBlock.xxxx
  89: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r14.xyzw, r1.w, l(80), g_TileSetParamBlock.xyzw
  90: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r15.xyzw, r1.w, l(96), g_TileSetParamBlock.xyzw
  91: mul r1.w, r6.w, l(0.250000)
  92: ge r13.w, r1.w, -r1.w
  93: frc r16.x, abs(r1.w)
  94: movc r13.w, r13.w, r16.x, -r16.x
  95: round_ni r1.w, r1.w
  96: mad r16.w, r13.z, l(4.000000), r1.w
  97: if_nz r12.w
  98:   add r1.w, -r3.x, r2.w
  99:   max r1.w, r1.w, l(0)
 100:   min r1.w, r1.w, l(6.000000)
 101:   ftou r1.w, r1.w
 102:   add r2.w, l(1.000000), -icb[r1.w + 3].x
 103:   max r4.xy, r4.xyxx, icb[r1.w + 3].xxxx
 104:   min r4.xy, r2.wwww, r4.xyxx
 105:   mad r11.xy, r4.xyxx, r9.zwzz, r9.xyxx
 106:   mul r4.xy, r6.xzxx, r11.xyxx
 107:   mul r4.xy, r10.wwww, r4.xyxx
 108:   round_ni r4.xy, r4.xyxx
 109:   mul r9.xy, r4.xyxx, l(0.003906, 0.031250, 0.000000, 0.000000)
 110:   ge r9.zw, r9.xxxy, -r9.xxxy
 111:   frc r17.xy, abs(r9.xyxx)
 112:   round_ni r9.xy, r9.xyxx
 113:   movc r16.xy, r9.zwzz, r17.xyxx, -r17.xyxx
 114:   mad r16.y, r16.y, l(256.000000), r9.x
 115:   mad r16.z, r13.w, l(256.000000), r9.y
 116:   mul r9.xyzw, r16.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 117:   ftoi r17.xy, r4.xyxx
 118:   ftoi r17.zw, r6.wwww
 119:   ld_indexable(texture2d)(float,float,float,float) r12.yz, r17.xyzw, g_PageTableTexture.xyzw
 120: else
 121:   mul r4.xy, r11.zwzz, l(0.003906, 0.031250, 0.000000, 0.000000)
 122:   ge r11.zw, r4.xxxy, -r4.xxxy
 123:   frc r17.xy, abs(r4.xyxx)
 124:   round_ni r4.xy, r4.xyxx
 125:   movc r16.xy, r11.zwzz, r17.xyxx, -r17.xyxx
 126:   mad r16.y, r16.y, l(256.000000), r4.x
 127:   mad r16.z, r13.w, l(256.000000), r4.y
 128:   mul r9.xyzw, r16.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 129: endif
 130: ubfe r16.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r12.xxxx
 131: and r1.w, r12.x, l(15)
 132: utof r1.w, r1.w
 133: exp r17.xz, r1.wwww
 134: mul r17.y, r6.y, r17.z
 135: mul r4.xy, r13.xyxx, r17.zyzz
 136: frc r4.xy, r4.xyxx
 137: utof r13.xyw, r16.xyxz
 138: mad r4.xy, r4.xyxx, r4.zwzz, r13.xyxx
 139: mad r13.xy, r4.xyxx, r8.xyxx, r8.zwzz
 140: mul r16.xyz, r4.zwzz, r17.xyzx
 141: mul r16.xyz, r8.xyxx, r16.xyzx
 142: mul r16.xyz, r7.wwww, r16.xyzx
 143: mul r17.xyz, r5.wyww, r16.zyzz
 144: mul r16.xyz, r10.zyzz, r16.xyzx
 145: sample_d(texture2darray)(float,float,float,float) r13.xyw, r13.xywx, g_AlbedoCacheTexture.xywz, g_CacheSampler, r17.xyzx, r16.xyzx
 146: ubfe r16.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r12.yyyy
 147: and r1.w, r12.y, l(15)
 148: utof r1.w, r1.w
 149: exp r17.xz, r1.wwww
 150: mul r17.y, r6.y, r17.z
 151: mul r4.xy, r11.xyxx, r17.zyzz
 152: frc r4.xy, r4.xyxx
 153: utof r12.xyw, r16.xyxz
 154: mad r4.xy, r4.xyxx, r4.zwzz, r12.xyxx
 155: mad r12.xy, r4.xyxx, r14.xyxx, r14.zwzz
 156: mul r16.xyz, r4.zwzz, r17.xyzx
 157: mul r16.xyz, r14.xyxx, r16.xyzx
 158: mul r16.xyz, r7.wwww, r16.xyzx
 159: mul r17.xyz, r5.wyww, r16.zyzz
 160: mul r16.xyz, r10.zyzz, r16.xyzx
 161: sample_d(texture2darray)(float,float,float,float) r12.xyw, r12.xywx, g_NormalCacheTexture.xyzw, g_CacheSampler, r17.xyzx, r16.xyzx
 162: mul r12.x, r12.w, r12.x
 163: mad r16.xy, r12.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
 164: dp2 r1.w, r16.xyxx, r16.xyxx
 165: min r1.w, r1.w, l(1.000000)
 166: add r1.w, -r1.w, l(1.000000)
 167: sqrt r1.w, r1.w
 168: ubfe r12.xyw, l(10, 10, 0, 7), l(14, 4, 0, 24), r12.zzzz
 169: and r2.w, r12.z, l(15)
 170: utof r2.w, r2.w
 171: exp r17.xz, r2.wwww
 172: mul r17.y, r6.y, r17.z
 173: mul r4.xy, r11.xyxx, r17.zyzz
 174: frc r4.xy, r4.xyxx
 175: utof r11.xyz, r12.xywx
 176: mad r4.xy, r4.xyxx, r4.zwzz, r11.xyxx
 177: mad r11.xy, r4.xyxx, r15.xyxx, r15.zwzz
 178: mul r12.xyz, r4.zwzz, r17.xyzx
 179: mul r12.xyz, r15.xyxx, r12.xyzx
 180: mul r12.xyz, r7.wwww, r12.xyzx
 181: mul r5.xyw, r5.xyxw, r12.xyxz
 182: mul r10.xyz, r10.xyzx, r12.xyzx
 183: sample_d(texture2darray)(float,float,float,float) r10.xyzw, r11.xyzx, g_MaskCacheTexture.xyzw, g_CacheSampler, r5.xywx, r10.xyzx
 184: movc r5.xyw, g_IsOverrideAlbedo0.xxxx, g_OverrideAlbedoColor0.xyxz, r13.xyxw
 185: movc r2.w, g_IsUseOverrideMetallic0.x, l(0), r10.x
 186: movc r3.x, g_IsUseOverrideRoughness0.x, g_OverrideRoughnessValue0.x, r10.y
 187: sincos r4.x, r10.x, r3.y
 188: mul r4.xy, r3.zwzz, r4.xxxx
 189: mad r11.x, r3.w, r10.x, -r4.x
 190: mad r11.y, r3.z, r10.x, r4.y
 191: add r3.yz, r11.xxyx, l(0.000000, 0.500000, 0.500000, 0.000000)
 192: mul r4.xy, g_UVScrollSpeed1.xyxx, g_CameraVec.wwww
 193: mad r3.yz, r3.yyzy, g_UVTile1.xxyx, r4.xxyx
 194: movc r3.yz, g_IsUseWorldUV1.xxxx, v9.zzwz, r3.yyzy
 195: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r3.w, r5.z, l(0), g_InstanceParam.xxxx
 196: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r11.xyzw, r3.w, l(0), g_StreamTextureParamBlock.xyzw
 197: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r4.x, r3.w, l(16), g_StreamTextureParamBlock.xxxx
 198: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r3.w, r3.w, l(28), g_StreamTextureParamBlock.xxxx
 199: deriv_rtx_coarse r12.xyz, r3.yzyy
 200: mul r12.xyz, r11.zwzz, r12.xyzx
 201: deriv_rty_coarse r13.xyw, r3.yzyy
 202: mul r13.xyw, r11.zwzz, r13.xyxw
 203: frc r3.yz, r3.yyzy
 204: mad r10.xy, r3.yzyy, r11.zwzz, r11.xyxx
 205: mul r17.xy, r7.yzyy, r12.zyzz
 206: mul r7.yz, r7.yyzy, r13.wwyw
 207: dp2 r4.y, r17.xyxx, r17.xyxx
 208: dp2 r5.z, r7.yzyy, r7.yzyy
 209: max r6.w, r4.y, r5.z
 210: min r4.y, r4.y, r5.z
 211: log r5.z, r6.w
 212: mul r6.w, r5.z, l(0.500000)
 213: log r4.y, r4.y
 214: mad r4.y, -r4.y, l(0.500000), r6.w
 215: min r4.y, r7.x, r4.y
 216: mad r4.y, r5.z, l(0.500000), -r4.y
 217: add r4.y, r4.y, l(-0.500000)
 218: max r4.y, r4.y, l(0)
 219: min r4.y, r4.x, r4.y
 220: add r4.y, r4.y, l(0.500000)
 221: round_ni r4.y, r4.y
 222: mul r7.xy, r6.xzxx, r10.xyxx
 223: exp r5.z, -r4.y
 224: mul r7.xy, r5.zzzz, r7.xyxx
 225: round_ni r7.xy, r7.xyxx
 226: ftoi r17.xy, r7.xyxx
 227: ftoi r17.zw, r4.yyyy
 228: ld_indexable(texture2d)(float,float,float,float) r17.xyz, r17.xyzw, g_PageTableTexture.xyzw
 229: and r6.w, r17.x, l(15)
 230: utof r6.w, r6.w
 231: add r3.w, r3.w, -r6.w
 232: lt r6.w, r4.x, r3.w
 233: if_nz r6.w
 234:   add r7.z, -r4.x, r3.w
 235:   max r7.z, r7.z, l(0)
 236:   min r7.z, r7.z, l(6.000000)
 237:   ftou r7.z, r7.z
 238:   add r12.w, l(1.000000), -icb[r7.z + 3].x
 239:   max r18.xy, r3.yzyy, icb[r7.z + 3].xxxx
 240:   min r18.xy, r12.wwww, r18.xyxx
 241:   mad r18.xy, r18.xyxx, r11.zwzz, r11.xyxx
 242:   mul r18.zw, r6.xxxz, r18.xxxy
 243:   mul r18.zw, r5.zzzz, r18.zzzw
 244:   round_ni r18.zw, r18.zzzw
 245:   ftoi r19.xy, r18.zwzz
 246:   ftoi r19.zw, r4.yyyy
 247:   ld_indexable(texture2d)(float,float,float,float) r17.x, r19.xyzw, g_PageTableTexture.xyzw
 248: else
 249:   mov r18.xy, r10.xyxx
 250: endif
 251: mul r7.z, r4.y, l(0.250000)
 252: ge r12.w, r7.z, -r7.z
 253: frc r16.w, abs(r7.z)
 254: movc r12.w, r12.w, r16.w, -r16.w
 255: round_ni r7.z, r7.z
 256: mad r19.w, r13.z, l(4.000000), r7.z
 257: if_nz r6.w
 258:   add r3.w, -r4.x, r3.w
 259:   max r3.w, r3.w, l(0)
 260:   min r3.w, r3.w, l(6.000000)
 261:   ftou r3.w, r3.w
 262:   add r4.x, l(1.000000), -icb[r3.w + 3].x
 263:   max r3.yz, r3.yyzy, icb[r3.w + 3].xxxx
 264:   min r3.yz, r4.xxxx, r3.yyzy
 265:   mad r10.xy, r3.yzyy, r11.zwzz, r11.xyxx
 266:   mul r3.yz, r6.xxzx, r10.xxyx
 267:   mul r3.yz, r5.zzzz, r3.yyzy
 268:   round_ni r3.yz, r3.yyzy
 269:   mul r6.xz, r3.yyzy, l(0.003906, 0.000000, 0.031250, 0.000000)
 270:   ge r11.xy, r6.xzxx, -r6.xzxx
 271:   frc r11.zw, abs(r6.xxxz)
 272:   round_ni r6.xz, r6.xxzx
 273:   movc r19.xy, r11.xyxx, r11.zwzz, -r11.zwzz
 274:   mad r19.y, r19.y, l(256.000000), r6.x
 275:   mad r19.z, r12.w, l(256.000000), r6.z
 276:   mul r11.xyzw, r19.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 277:   ftoi r20.xy, r3.yzyy
 278:   ftoi r20.zw, r4.yyyy
 279:   ld_indexable(texture2d)(float,float,float,float) r17.yz, r20.xyzw, g_PageTableTexture.xyzw
 280: else
 281:   mul r3.yz, r7.xxyx, l(0.000000, 0.003906, 0.031250, 0.000000)
 282:   ge r4.xy, r3.yzyy, -r3.yzyy
 283:   frc r6.xz, abs(r3.yyzy)
 284:   round_ni r3.yz, r3.yyzy
 285:   movc r19.xy, r4.xyxx, r6.xzxx, -r6.xzxx
 286:   mad r19.y, r19.y, l(256.000000), r3.y
 287:   mad r19.z, r12.w, l(256.000000), r3.z
 288:   mul r11.xyzw, r19.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 289: endif
 290: ubfe r3.yzw, l(0, 10, 10, 7), l(0, 14, 4, 24), r17.xxxx
 291: and r4.x, r17.x, l(15)
 292: utof r4.x, r4.x
 293: exp r7.xz, r4.xxxx
 294: mul r7.y, r6.y, r7.z
 295: mul r4.xy, r7.zyzz, r18.xyxx
 296: frc r4.xy, r4.xyxx
 297: utof r3.yzw, r3.yyzw
 298: mad r4.xy, r4.xyxx, r4.zwzz, r3.yzyy
 299: mad r3.yz, r4.xxyx, r8.xxyx, r8.zzwz
 300: mul r6.xzw, r4.zzwz, r7.xxyz
 301: mul r6.xzw, r8.xxyx, r6.xxzw
 302: mul r6.xzw, r7.wwww, r6.xxzw
 303: mul r7.xyz, r6.wzww, r12.zyzz
 304: mul r6.xzw, r6.xxzw, r13.wwyw
 305: sample_d(texture2darray)(float,float,float,float) r3.yzw, r3.yzwy, g_AlbedoCacheTexture.wxyz, g_CacheSampler, r7.xyzx, r6.xzwx
 306: ubfe r6.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r17.yyyy
 307: and r4.x, r17.y, l(15)
 308: utof r4.x, r4.x
 309: exp r7.xz, r4.xxxx
 310: mul r7.y, r6.y, r7.z
 311: mul r4.xy, r7.zyzz, r10.xyxx
 312: frc r4.xy, r4.xyxx
 313: utof r6.xzw, r6.xxzw
 314: mad r4.xy, r4.xyxx, r4.zwzz, r6.xzxx
 315: mad r6.xz, r4.xxyx, r14.xxyx, r14.zzwz
 316: mul r7.xyz, r4.zwzz, r7.xyzx
 317: mul r7.xyz, r14.xyxx, r7.xyzx
 318: mul r7.xyz, r7.wwww, r7.xyzx
 319: mul r8.xyz, r7.zyzz, r12.zyzz
 320: mul r7.xyz, r7.xyzx, r13.wyww
 321: sample_d(texture2darray)(float,float,float,float) r6.xzw, r6.xzwx, g_NormalCacheTexture.xzyw, g_CacheSampler, r8.xyzx, r7.xyzx
 322: mul r6.x, r6.w, r6.x
 323: mad r7.xy, r6.xzxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
 324: dp2 r4.x, r7.xyxx, r7.xyxx
 325: min r4.x, r4.x, l(1.000000)
 326: add r4.x, -r4.x, l(1.000000)
 327: sqrt r4.x, r4.x
 328: ubfe r6.xzw, l(10, 0, 10, 7), l(14, 0, 4, 24), r17.zzzz
 329: and r4.y, r17.z, l(15)
 330: utof r4.y, r4.y
 331: exp r8.xz, r4.yyyy
 332: mul r8.y, r6.y, r8.z
 333: mul r10.xy, r8.zyzz, r10.xyxx
 334: frc r10.xy, r10.xyxx
 335: utof r6.xyz, r6.xzwx
 336: mad r10.xy, r10.xyxx, r4.zwzz, r6.xyxx
 337: mad r6.xy, r10.xyxx, r15.xyxx, r15.zwzz
 338: mul r4.yzw, r4.zzwz, r8.xxyz
 339: mul r4.yzw, r15.xxyx, r4.yyzw
 340: mul r4.yzw, r7.wwww, r4.yyzw
 341: mul r8.xyz, r4.yzwy, r12.xyzx
 342: mul r4.yzw, r4.yyzw, r13.xxyw
 343: sample_d(texture2darray)(float,float,float,float) r6.xyzw, r6.xyzx, g_MaskCacheTexture.xyzw, g_CacheSampler, r8.xyzx, r4.yzwy
 344: movc r3.yzw, g_IsOverrideAlbedo1.xxxx, g_OverrideAlbedoColor1.xxyz, r3.yyzw
 345: movc r4.y, g_IsUseOverrideMetallic1.x, l(0), r6.x
 346: movc r4.z, g_IsUseOverrideRoughness1.x, g_OverrideRoughnessValue1.x, r6.y
 347: ftou r8.xy, v0.xyxx
 348: mov r8.zw, l(0, 0, 0, 0)
 349: ld_indexable(texture2d)(float,float,float,float) r4.w, r8.xyzw, g_DepthMap.yzwx
 350: add r5.z, v0.z, g_Proj[2].z
 351: div r5.z, g_Proj[2].w, r5.z
 352: add r5.z, r5.z, -g_CameraParam.x
 353: div r6.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_CameraParam.y
 354: mul r5.z, r5.z, r6.x
 355: ge r4.w, r4.w, r5.z
 356: ftoi r8.xy, v0.xyxx
 357: and r10.xy, r8.xyxx, l(7, 7, 0, 0)
 358: ieq r10.xy, r10.xyxx, l(0, 0, 0, 0)
 359: and r6.y, r10.y, r10.x
 360: ushr r12.xyzw, r8.xyyy, l(3, 3, 3, 3)
 361: if_z r4.w
 362:   mov r7.w, l(0)
 363: else
 364:   mov r7.w, r6.y
 365: endif
 366: if_nz r7.w
 367:   store_uav_typed g_ResolveParam0.xyzw, r12.xwww, r9.xyzw
 368: endif
 369: if_z r4.w
 370:   mov r6.y, l(0)
 371: endif
 372: if_nz r6.y
 373:   store_uav_typed g_ResolveParam1.xyzw, r12.xyzw, r11.xyzw
 374: endif
 375: mul r9.xyz, r16.yyyy, v6.xyzx
 376: mad r9.xyz, r16.xxxx, v5.xyzx, r9.xyzx
 377: add r9.xyz, r9.xyzx, v4.xyzx
 378: dp3 r4.w, r9.xyzx, r9.xyzx
 379: rsq r4.w, r4.w
 380: mul r9.xyz, r4.wwww, r9.xyzx
 381: dp3 r4.w, r9.xyzx, g_ViewInverseMatrix[1].xyzx
 382: mad r4.w, r4.w, l(0.500000), l(0.500000)
 383: add r6.y, -g_UpNormalAlpha_Power0.x, l(1.000000)
 384: add r4.w, r4.w, -g_UpNormalAlpha_Power0.x
 385: div r6.y, l(1.000000, 1.000000, 1.000000, 1.000000), r6.y
 386: mul_sat r4.w, r4.w, r6.y
 387: mad r6.y, r4.w, l(-2.000000), l(3.000000)
 388: mul r4.w, r4.w, r4.w
 389: mul r4.w, r4.w, r6.y
 390: log r4.w, r4.w
 391: mul r4.w, r4.w, g_UpNormalAlpha_Power0.x
 392: exp r4.w, r4.w
 393: movc r6.y, g_IsUpNormalAlpha0.x, l(1.000000), l(0)
 394: mul r4.w, r4.w, r6.y
 395: max r0.w, r0.w, r4.w
 396: log r4.w, abs(r10.z)
 397: mul r4.w, r4.w, g_BaldRate0.x
 398: exp r4.w, r4.w
 399: add r6.y, -r10.z, l(1.000000)
 400: movc r6.y, g_IsOcclusionAlpha0.x, r6.y, l(0)
 401: mad_sat r0.w, r0.w, r4.w, r6.y
 402: add r4.w, -r0.w, l(1.000000)
 403: mad r4.w, r10.w, r4.w, r4.w
 404: mad r0.w, r6.w, r0.w, r0.w
 405: max r6.y, r0.w, r4.w
 406: add r6.y, r6.y, -g_BlendRatePower0.x
 407: add r4.w, r4.w, -r6.y
 408: max r4.w, r4.w, l(0)
 409: add r0.w, r0.w, -r6.y
 410: max r0.w, r0.w, l(0)
 411: add r4.w, r0.w, r4.w
 412: rcp r4.w, r4.w
 413: mul r6.y, r0.w, r4.w
 414: add r3.yzw, -r5.xxyw, r3.yyzw
 415: mad r3.yzw, r6.yyyy, r3.yyzw, r5.xxyw
 416: add r4.y, -r2.w, r4.y
 417: mad o1.x, r6.y, r4.y, r2.w
 418: add r2.w, -r3.x, r4.z
 419: mad r2.w, r6.y, r2.w, r3.x
 420: add r3.x, -r10.z, r6.z
 421: mad r3.x, r6.y, r3.x, r10.z
 422: movc r4.y, g_UseForceNormal0.x, l(1.000000), l(0)
 423: mad r0.w, -r0.w, r4.w, g_NormalForce0.x
 424: mad r0.w, r4.y, r0.w, r6.y
 425: add r1.w, r1.w, l(0.000000)
 426: rcp r1.w, r1.w
 427: mov r16.z, -r16.y
 428: mul r4.yz, r1.wwww, r16.xxzx
 429: add r1.w, r4.x, l(0.000000)
 430: rcp r1.w, r1.w
 431: mov r7.z, -r7.y
 432: mad r4.xw, r7.xxxz, r1.wwww, -r4.yyyz
 433: mad r4.xy, r0.wwww, r4.xwxx, r4.yzyy
 434: mov r4.z, l(1.000000)
 435: dp3 r0.w, r4.xyzx, r4.xyzx
 436: rsq r0.w, r0.w
 437: mul r4.xyz, r0.wwww, r4.xyzx
 438: if_nz g_IsUseDetailNormal.x
 439:   mul r7.xyzw, v2.xyzw, g_DetailNormalTile.xyxy
 440:   movc r5.xy, g_IsDetailNormalUV1.xxxx, r7.xyxx, r7.zwzz
 441:   sample_indexable(texture2d)(float,float,float,float) r5.xy, r5.xyxx, g_DetailNormalMap.xyzw, ModelSampler
 442:   mov r4.w, l(-1.000000)
 443:   mad r7.xy, r5.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), r4.xwxx
 444:   mov r7.z, -r7.y
 445:   add r7.xy, r4.wyww, r7.xzxx
 446:   mov r7.z, r4.z
 447:   dp3 r0.w, r7.xyzx, r7.xyzx
 448:   rsq r0.w, r0.w
 449:   mad r5.xyw, r7.xyxz, r0.wwww, -r4.xyxz
 450:   mad r4.xyz, v1.zzzz, r5.xywx, r4.xyzx
 451: endif
 452: mov r0.w, g_WetVetexColorIndex.x
 453: dp4 r0.w, v1.xyzw, icb[r0.w + 0].xyzw
 454: add r5.xyw, r4.xyxz, l(-0.000000, -0.000000, 0.000000, -1.000000)
 455: mad r5.xyw, g_WetNormal.xxxx, r5.xyxw, l(0.000000, 0.000000, 0.000000, 1.000000)
 456: add r1.w, r3.x, l(-1.000000)
 457: mad r1.w, g_WetNormal.x, r1.w, l(1.000000)
 458: mad r6.yzw, r3.yyzw, g_WetAlbedo.xxxx, -r3.yyzw
 459: mad r6.yzw, r0.wwww, r6.yyzw, r3.yyzw
 460: add r5.xyw, -r4.xyxz, r5.xyxw
 461: mad r5.xyw, r0.wwww, r5.xyxw, r4.xyxz
 462: mad r4.w, r2.w, g_Wetroughness.x, -r2.w
 463: mad r4.w, r0.w, r4.w, r2.w
 464: add r1.w, -r3.x, r1.w
 465: mad r0.w, r0.w, r1.w, r3.x
 466: movc r3.yzw, g_IsWet.xxxx, r6.yyzw, r3.yyzw
 467: movc r4.xyz, g_IsWet.xxxx, r5.xywx, r4.xyzx
 468: movc o1.y, g_IsWet.x, r4.w, r2.w
 469: movc r0.w, g_IsWet.x, r0.w, r3.x
 470: mul r5.xyw, r4.yyyy, v6.xyxz
 471: mad r4.xyw, r4.xxxx, v5.xyxz, r5.xyxw
 472: mad r4.xyz, r4.zzzz, v4.xyzx, r4.xywx
 473: dp3 r1.w, r4.xyzx, r4.xyzx
 474: rsq r1.w, r1.w
 475: mul r4.xyz, r1.wwww, r4.xyzx
 476: if_nz g_UseColorNoise.x
 477:   sample_indexable(texture2d)(float,float,float,float) r5.xyw, v2.zwzz, g_UberColorNoiseMap.xywz, ModelSampler
 478:   mul r3.yzw, r3.yyzw, r5.xxyw
 479: endif
 480: mul r1.w, r0.w, v1.w
 481: movc o1.z, g_UseVertexOcclusion.x, r1.w, r0.w
 482: dp4 r0.w, v4.xyzw, v4.xyzw
 483: rsq r0.w, r0.w
 484: mul r7.xyzw, r0.wwww, v4.xyzw
 485: mul r5.xyw, r7.yyyy, g_View[1].xyxz
 486: mad r5.xyw, g_View[0].xyxz, r7.xxxx, r5.xyxw
 487: mad r5.xyw, g_View[2].xyxz, r7.zzzz, r5.xyxw
 488: mad r5.xyw, g_View[3].xyxz, r7.wwww, r5.xyxw
 489: add r6.yzw, -v3.xxyz, g_CameraVec.xxyz
 490: dp3 r0.w, r6.yzwy, r6.yzwy
 491: rsq r0.w, r0.w
 492: mul r6.yzw, r0.wwww, r6.yyzw
 493: dp3_sat r0.w, r5.xywx, r6.yzwy
 494: ge r1.w, g_DepthFadeParam.w, l(0)
 495: if_nz r1.w
 496:   add r1.w, l(1.000000), -g_DepthFadeParam.z
 497:   mul r5.xyw, v3.xyxz, g_DepthFadeParam.yyyy
 498:   round_ni r6.yzw, r5.xxyw
 499:   frc r5.xyw, r5.xyxw
 500:   mad r7.xyz, r5.xywx, l(-2.000000, -2.000000, -2.000000, 0.000000), l(3.000000, 3.000000, 3.000000, 0.000000)
 501:   mul r5.xyw, r5.xyxw, r5.xyxw
 502:   mul r2.w, r5.w, r7.z
 503:   mad r6.yz, -r6.wwww, l(0.000000, 38.000000, 23.000000, 0.000000), r6.yyzy
 504:   mad r5.xy, r7.xyxx, r5.xyxx, r6.yzyy
 505:   add r5.xy, r5.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
 506:   mul r5.xy, r5.xyxx, l(0.007813, 0.007813, 0.000000, 0.000000)
 507:   sample_l(texture2d)(float,float,float,float) r5.xy, r5.xyxx, g_NoiseTexture.xyzw, g_NoiseTextureSampler, l(0)
 508:   add r3.x, -r5.x, r5.y
 509:   mad r2.w, r2.w, r3.x, r5.x
 510:   mad r2.w, r2.w, l(2.000000), l(-1.000000)
 511:   mad r2.w, r2.w, l(0.500000), l(0.500000)
 512:   add r3.x, -r1.w, l(1.000000)
 513:   mad r1.w, r2.w, r3.x, r1.w
 514: else
 515:   mov r1.w, l(1.000000)
 516: endif
 517: add r2.w, abs(g_DepthFadeParam.w), g_DepthFadeParam.x
 518: mul r1.w, r1.w, r2.w
 519: mov r8.zw, l(0, 0, 0, 0)
 520: ld_indexable(texture2d)(float,float,float,float) r2.w, r8.xyzw, g_ZBuffer.yzwx
 521: add r2.w, r2.w, g_Proj[2].z
 522: div r2.w, g_Proj[2].w, r2.w
 523: add r2.w, r2.w, -g_CameraParam.x
 524: mad r2.w, r2.w, r6.x, -r5.z
 525: add r3.x, -g_CameraParam.x, g_CameraParam.y
 526: mul r2.w, r2.w, r3.x
 527: add r3.x, -r0.w, l(1.000000)
 528: sqrt r3.x, r3.x
 529: mad r4.w, r0.w, l(-0.018729), l(0.074261)
 530: mad r4.w, r4.w, r0.w, l(-0.212114)
 531: mad r0.w, r4.w, r0.w, l(1.570729)
 532: mul r0.w, r3.x, r0.w
 533: sincos r3.x, r5.x, r0.w
 534: div r0.w, r3.x, r5.x
 535: min r0.w, r0.w, l(1.000000)
 536: add r0.w, r0.w, l(1.000000)
 537: div r0.w, r2.w, r0.w
 538: mul r0.xw, r0.xxxw, l(0.500000, 0.000000, 0.000000, 0.000033)
 539: div r1.w, l(1.000000, 1.000000, 1.000000, 1.000000), r1.w
 540: mul_sat r0.w, r0.w, r1.w
 541: mad r1.w, r0.w, l(-2.000000), l(3.000000)
 542: mul r0.w, r0.w, r0.w
 543: mul r0.w, r0.w, r1.w
 544: min r0.w, r0.w, l(1.000000)
 545: mul o0.xyz, r2.xyzx, r3.yzwy
 546: mad r1.z, -r1.y, l(0.500000), l(1.000000)
 547: mad r0.z, -r0.y, l(0.500000), l(1.000000)
 548: add o3.xy, r0.xzxx, -r1.xzxx
 549: mad o2.xyz, r4.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
 550: mov o0.w, r0.w
 551: mov o1.w, r0.w
 552: mov o2.w, r0.w
 553: ret
