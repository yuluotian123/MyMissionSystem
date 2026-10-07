Shader hash 79d9c6cc-72640869-eaf81263-23dd65ca

// Note: shader requires additional functionality:
//       64 UAV slots
//
ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_immediateConstantBuffer {
			{ 0, 0, 0, 0}, 
			{ 0.007813, 0, 0, 0}, 
			{ 0.015625, 0, 0, 0}, 
			{ 0.031250, 0, 0, 0}, 
			{ 0.062500, 0, 0, 0}, 
			{ 0.125000, 0, 0, 0}, 
			{ 0.250000, 0, 0, 0} }
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb3[2] (MeshBuffer1), immediateIndexed
      dcl_constantbuffer cb11[6] (ParamBuffer), immediateIndexed
      dcl_constantbuffer cb10[2] (PSParamComponentBuffer), immediateIndexed
      dcl_sampler g_CacheSampler (s6), mode_default
      dcl_resource_texture2darray (float,float,float,float) g_AlbedoCacheTexture (t0)
      dcl_resource_texture2darray (float,float,float,float) g_NormalCacheTexture (t1)
      dcl_resource_texture2darray (float,float,float,float) g_MaskCacheTexture (t2)
      dcl_resource_structured g_TileSetParamBlock (t5), 128
      dcl_resource_structured g_StreamTextureParamBlock (t6), 32
      dcl_resource_texture2d (float,float,float,float) g_PageTableTexture (t7)
      dcl_resource_texture2d (float,float,float,float) g_DepthMap (t8)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_uav_typed_texture2d (unorm,unorm,unorm,unorm) g_ResolveParam0 (u8)
      dcl_uav_typed_texture2d (unorm,unorm,unorm,unorm) g_ResolveParam1 (u9)
      dcl_uav_typed_texture2d (unorm,unorm,unorm,unorm) g_ResolveParam2 (u10)
      dcl_input_ps_siv linear noperspective v0.xyz, position
      dcl_input_ps linear v1.xyzw
      dcl_input_ps linear v2.xyz
      dcl_input_ps linear v3.xyz
      dcl_input_ps linear v4.xyz
      dcl_input_ps linear v5.xyz
      dcl_input_ps linear v6.xyw
      dcl_input_ps linear v7.xyw
      dcl_input_ps linear v8.x
      dcl_input_ps linear v9.xyzw
      dcl_input_ps nointerpolation v10.x
      dcl_input_ps_sgv nointerpolation v11.x, isfrontface
      dcl_output o0.xyzw
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.xy
      dcl_temps 38
   0: movc r0.xy, g_UV2Use.xxxx, v1.zwzz, v1.xyxx
   1: iadd r1.xyz, v10.xxxx, l(7, 8, 2, 0)
   2: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.z, r1.x, l(0), g_InstanceParam.xxxx
   3: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, r1.y, l(0), g_InstanceParam.xxxx
   4: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r1.xy, r0.w, l(32), g_TileSetParamBlock.xyxx
   5: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r2.xy, r0.w, l(48), g_TileSetParamBlock.xyxx
   6: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r3.xyzw, r0.w, l(4), g_TileSetParamBlock.xyzw
   7: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r4.xyzw, r0.w, l(60), g_TileSetParamBlock.xyzw
   8: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r5.y, r0.w, l(76), g_TileSetParamBlock.xxxx
   9: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r6.xyzw, r0.z, l(0), g_StreamTextureParamBlock.xyzw
  10: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r1.w, r0.z, l(16), g_StreamTextureParamBlock.xxxx
  11: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r0.z, r0.z, l(28), g_StreamTextureParamBlock.xxxx
  12: deriv_rtx_coarse r7.xyz, v1.xyxx
  13: mul r7.xyz, r6.zwzz, r7.xyzx
  14: deriv_rty_coarse r8.xyz, v1.xyxx
  15: mul r8.xyz, r6.zwzz, r8.xyzx
  16: frc r5.zw, v1.xxxy
  17: mad r9.xy, r5.zwzz, r6.zwzz, r6.xyxx
  18: mul r9.zw, r3.yyyz, r7.zzzy
  19: mul r10.xy, r3.yzyy, r8.zyzz
  20: dp2 r2.w, r9.zwzz, r9.zwzz
  21: dp2 r7.w, r10.xyxx, r10.xyxx
  22: max r8.w, r2.w, r7.w
  23: min r2.w, r2.w, r7.w
  24: log r7.w, r8.w
  25: mul r8.w, r7.w, l(0.500000)
  26: log r2.w, r2.w
  27: mad r2.w, -r2.w, l(0.500000), r8.w
  28: min r2.w, r3.x, r2.w
  29: mad r2.w, r7.w, l(0.500000), -r2.w
  30: add r2.w, r2.w, l(-0.500000)
  31: max r2.w, r2.w, l(0)
  32: min r2.w, r1.w, r2.w
  33: add r2.w, r2.w, l(0.500000)
  34: round_ni r2.w, r2.w
  35: mul r2.z, r2.y, r2.x
  36: mul r9.zw, r2.xxxz, r9.xxxy
  37: exp r7.w, -r2.w
  38: mul r9.zw, r7.wwww, r9.zzzw
  39: round_ni r9.zw, r9.zzzw
  40: mul r8.w, r2.w, l(0.250000)
  41: ge r10.x, r8.w, -r8.w
  42: frc r10.y, abs(r8.w)
  43: movc r10.x, r10.x, r10.y, -r10.y
  44: round_ni r8.w, r8.w
  45: mad r11.w, r4.x, l(4.000000), r8.w
  46: ftoi r12.xy, r9.zwzz
  47: ftoi r12.zw, r2.wwww
  48: ld_indexable(texture2d)(float,float,float,float) r4.x, r12.xyzw, g_PageTableTexture.xyzw
  49: and r8.w, r4.x, l(15)
  50: utof r8.w, r8.w
  51: add r8.w, r0.z, -r8.w
  52: lt r10.y, r1.w, r8.w
  53: if_nz r10.y
  54:   add r8.w, -r1.w, r8.w
  55:   max r8.w, r8.w, l(0)
  56:   min r8.w, r8.w, l(6.000000)
  57:   ftou r8.w, r8.w
  58:   add r10.y, l(1.000000), -icb[r8.w + 0].x
  59:   max r5.zw, r5.zzzw, icb[r8.w + 0].xxxx
  60:   min r5.zw, r10.yyyy, r5.zzzw
  61:   mad r9.xy, r5.zwzz, r6.zwzz, r6.xyxx
  62:   mul r5.zw, r2.xxxz, r9.xxxy
  63:   mul r5.zw, r7.wwww, r5.zzzw
  64:   round_ni r5.zw, r5.zzzw
  65:   mul r10.yz, r5.zzwz, l(0.000000, 0.003906, 0.031250, 0.000000)
  66:   ge r12.xy, r10.yzyy, -r10.yzyy
  67:   frc r12.zw, abs(r10.yyyz)
  68:   round_ni r10.yz, r10.yyzy
  69:   movc r11.xy, r12.xyxx, r12.zwzz, -r12.zwzz
  70:   mad r11.y, r11.y, l(256.000000), r10.y
  71:   mad r11.z, r10.x, l(256.000000), r10.z
  72:   mul r12.xyzw, r11.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
  73:   ftoi r13.xy, r5.zwzz
  74:   ftoi r13.zw, r2.wwww
  75:   ld_indexable(texture2d)(float,float,float,float) r4.x, r13.xyzw, g_PageTableTexture.xyzw
  76: else
  77:   mul r5.zw, r9.zzzw, l(0.000000, 0.000000, 0.003906, 0.031250)
  78:   ge r9.zw, r5.zzzw, -r5.zzzw
  79:   frc r10.yz, abs(r5.zzwz)
  80:   round_ni r5.zw, r5.zzzw
  81:   movc r11.xy, r9.zwzz, r10.yzyy, -r10.yzyy
  82:   mad r11.y, r11.y, l(256.000000), r5.z
  83:   mad r11.z, r10.x, l(256.000000), r5.w
  84:   mul r12.xyzw, r11.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
  85: endif
  86: add r5.zw, v1.xxxy, g_UvOffset.xxxy
  87: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r2.w, r0.w, l(60), g_TileSetParamBlock.xxxx
  88: deriv_rtx_coarse r10.xyz, r5.zwzz
  89: mul r10.xyz, r6.zwzz, r10.xyzx
  90: deriv_rty_coarse r11.xyz, r5.zwzz
  91: mul r11.xyz, r6.zwzz, r11.xyzx
  92: frc r5.zw, r5.zzzw
  93: mad r9.zw, r5.zzzw, r6.zzzw, r6.xxxy
  94: mul r13.xy, r3.yzyy, r10.zyzz
  95: mul r13.zw, r3.yyyz, r11.zzzy
  96: dp2 r7.w, r13.xyxx, r13.xyxx
  97: dp2 r8.w, r13.zwzz, r13.zwzz
  98: max r10.w, r7.w, r8.w
  99: min r7.w, r7.w, r8.w
 100: log r8.w, r10.w
 101: mul r10.w, r8.w, l(0.500000)
 102: log r7.w, r7.w
 103: mad r7.w, -r7.w, l(0.500000), r10.w
 104: min r7.w, r3.x, r7.w
 105: mad r7.w, r8.w, l(0.500000), -r7.w
 106: add r7.w, r7.w, l(-0.500000)
 107: max r7.w, r7.w, l(0)
 108: min r7.w, r1.w, r7.w
 109: add r7.w, r7.w, l(0.500000)
 110: round_ni r7.w, r7.w
 111: mul r13.xy, r2.xzxx, r9.zwzz
 112: exp r8.w, -r7.w
 113: mul r13.xy, r8.wwww, r13.xyxx
 114: round_ni r13.xy, r13.xyxx
 115: mul r10.w, r7.w, l(0.250000)
 116: ge r11.w, r10.w, -r10.w
 117: frc r13.z, abs(r10.w)
 118: movc r11.w, r11.w, r13.z, -r13.z
 119: round_ni r10.w, r10.w
 120: mad r14.w, r2.w, l(4.000000), r10.w
 121: ftoi r15.xy, r13.xyxx
 122: ftoi r15.zw, r7.wwww
 123: ld_indexable(texture2d)(float,float,float,float) r13.zw, r15.xyzw, g_PageTableTexture.zwyx
 124: and r10.w, r13.w, l(15)
 125: utof r10.w, r10.w
 126: add r10.w, r0.z, -r10.w
 127: lt r13.w, r1.w, r10.w
 128: if_nz r13.w
 129:   add r10.w, -r1.w, r10.w
 130:   max r10.w, r10.w, l(0)
 131:   min r10.w, r10.w, l(6.000000)
 132:   ftou r10.w, r10.w
 133:   add r13.w, l(1.000000), -icb[r10.w + 0].x
 134:   max r5.zw, r5.zzzw, icb[r10.w + 0].xxxx
 135:   min r5.zw, r13.wwww, r5.zzzw
 136:   mad r9.zw, r5.zzzw, r6.zzzw, r6.xxxy
 137:   mul r5.zw, r2.xxxz, r9.zzzw
 138:   mul r5.zw, r8.wwww, r5.zzzw
 139:   round_ni r5.zw, r5.zzzw
 140:   mul r15.xy, r5.zwzz, l(0.003906, 0.031250, 0.000000, 0.000000)
 141:   ge r15.zw, r15.xxxy, -r15.xxxy
 142:   frc r16.xy, abs(r15.xyxx)
 143:   round_ni r15.xy, r15.xyxx
 144:   movc r14.xy, r15.zwzz, r16.xyxx, -r16.xyxx
 145:   mad r14.y, r14.y, l(256.000000), r15.x
 146:   mad r14.z, r11.w, l(256.000000), r15.y
 147:   mul r15.xyzw, r14.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 148:   ftoi r16.xy, r5.zwzz
 149:   ftoi r16.zw, r7.wwww
 150:   ld_indexable(texture2d)(float,float,float,float) r13.z, r16.xyzw, g_PageTableTexture.zwyx
 151: else
 152:   mul r5.zw, r13.xxxy, l(0.000000, 0.000000, 0.003906, 0.031250)
 153:   ge r13.xy, r5.zwzz, -r5.zwzz
 154:   frc r16.xy, abs(r5.zwzz)
 155:   round_ni r5.zw, r5.zzzw
 156:   movc r14.xy, r13.xyxx, r16.xyxx, -r16.xyxx
 157:   mad r14.y, r14.y, l(256.000000), r5.z
 158:   mad r14.z, r11.w, l(256.000000), r5.w
 159:   mul r15.xyzw, r14.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 160: endif
 161: add r0.xy, r0.xyxx, g_UvOffset.xyxx
 162: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r14.xyzw, r0.w, l(96), g_TileSetParamBlock.xyzw
 163: deriv_rtx_coarse r13.xyw, r0.xyxx
 164: mul r13.xyw, r6.zwzz, r13.xyxw
 165: deriv_rty_coarse r16.xyz, r0.xyxx
 166: mul r16.xyz, r6.zwzz, r16.xyzx
 167: frc r0.xy, r0.xyxx
 168: mad r5.zw, r0.xxxy, r6.zzzw, r6.xxxy
 169: mul r17.xy, r3.yzyy, r13.wyww
 170: mul r3.yz, r3.yyzy, r16.zzyz
 171: dp2 r7.w, r17.xyxx, r17.xyxx
 172: dp2 r3.y, r3.yzyy, r3.yzyy
 173: max r3.z, r3.y, r7.w
 174: min r3.y, r3.y, r7.w
 175: log r3.z, r3.z
 176: mul r7.w, r3.z, l(0.500000)
 177: log r3.y, r3.y
 178: mad r3.y, -r3.y, l(0.500000), r7.w
 179: min r3.x, r3.x, r3.y
 180: mad r3.x, r3.z, l(0.500000), -r3.x
 181: add r3.x, r3.x, l(-0.500000)
 182: max r3.x, r3.x, l(0)
 183: min r3.x, r1.w, r3.x
 184: add r3.x, r3.x, l(0.500000)
 185: round_ni r3.x, r3.x
 186: mul r3.yz, r2.xxzx, r5.zzwz
 187: exp r7.w, -r3.x
 188: mul r3.yz, r3.yyzy, r7.wwww
 189: round_ni r3.yz, r3.yyzy
 190: mul r8.w, r3.x, l(0.250000)
 191: ge r10.w, r8.w, -r8.w
 192: frc r11.w, abs(r8.w)
 193: movc r10.w, r10.w, r11.w, -r11.w
 194: round_ni r8.w, r8.w
 195: mad r17.w, r2.w, l(4.000000), r8.w
 196: ftoi r18.xyzw, r3.yzxx
 197: ld_indexable(texture2d)(float,float,float,float) r18.xy, r18.xyzw, g_PageTableTexture.zxyw
 198: and r2.w, r18.y, l(15)
 199: utof r2.w, r2.w
 200: add r0.z, r0.z, -r2.w
 201: lt r2.w, r1.w, r0.z
 202: if_nz r2.w
 203:   add r0.z, -r1.w, r0.z
 204:   max r0.z, r0.z, l(0)
 205:   min r0.z, r0.z, l(6.000000)
 206:   ftou r0.z, r0.z
 207:   add r1.w, l(1.000000), -icb[r0.z + 0].x
 208:   max r0.xy, r0.xyxx, icb[r0.z + 0].xxxx
 209:   min r0.xy, r1.wwww, r0.xyxx
 210:   mad r5.zw, r0.xxxy, r6.zzzw, r6.xxxy
 211:   mul r0.xy, r2.xzxx, r5.zwzz
 212:   mul r0.xy, r7.wwww, r0.xyxx
 213:   round_ni r0.xy, r0.xyxx
 214:   mul r2.xz, r0.xxyx, l(0.003906, 0.000000, 0.031250, 0.000000)
 215:   ge r6.xy, r2.xzxx, -r2.xzxx
 216:   frc r6.zw, abs(r2.xxxz)
 217:   round_ni r2.xz, r2.xxzx
 218:   movc r17.xy, r6.xyxx, r6.zwzz, -r6.zwzz
 219:   mad r17.y, r17.y, l(256.000000), r2.x
 220:   mad r17.z, r10.w, l(256.000000), r2.z
 221:   mul r6.xyzw, r17.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 222:   ftoi r19.xy, r0.xyxx
 223:   ftoi r19.zw, r3.xxxx
 224:   ld_indexable(texture2d)(float,float,float,float) r18.x, r19.xyzw, g_PageTableTexture.zxyw
 225: else
 226:   mul r0.xy, r3.yzyy, l(0.003906, 0.031250, 0.000000, 0.000000)
 227:   ge r2.xz, r0.xxyx, -r0.xxyx
 228:   frc r3.xy, abs(r0.xyxx)
 229:   round_ni r0.xy, r0.xyxx
 230:   movc r17.xy, r2.xzxx, r3.xyxx, -r3.xyxx
 231:   mad r17.y, r17.y, l(256.000000), r0.x
 232:   mad r17.z, r10.w, l(256.000000), r0.y
 233:   mul r6.xyzw, r17.xyzw, l(1.003922, 0.003922, 0.003922, 0.003922)
 234: endif
 235: ftou r17.xy, v0.xyxx
 236: mov r17.zw, l(0, 0, 0, 0)
 237: ld_indexable(texture2d)(float,float,float,float) r0.x, r17.xyzw, g_DepthMap.xyzw
 238: add r0.y, v0.z, g_Proj[2].z
 239: div r0.y, g_Proj[2].w, r0.y
 240: add r0.y, r0.y, -g_CameraParam.x
 241: div r0.z, l(1.000000, 1.000000, 1.000000, 1.000000), g_CameraParam.y
 242: mul r0.y, r0.z, r0.y
 243: ge r0.x, r0.x, r0.y
 244: ftoi r17.xyzw, v0.xyyy
 245: and r0.yz, r17.xxwx, l(0, 7, 7, 0)
 246: ieq r0.yz, r0.yyzy, l(0, 0, 0, 0)
 247: and r0.y, r0.z, r0.y
 248: ushr r17.xyzw, r17.xyzw, l(3, 3, 3, 3)
 249: if_z r0.x
 250:   mov r0.z, l(0)
 251: else
 252:   mov r0.z, r0.y
 253: endif
 254: if_nz r0.z
 255:   store_uav_typed g_ResolveParam0.xyzw, r17.xwww, r12.xyzw
 256: endif
 257: if_z r0.x
 258:   mov r0.z, l(0)
 259: else
 260:   mov r0.z, r0.y
 261: endif
 262: if_nz r0.z
 263:   store_uav_typed g_ResolveParam1.xyzw, r17.xwww, r15.xyzw
 264: endif
 265: if_z r0.x
 266:   mov r0.y, l(0)
 267: endif
 268: if_nz r0.y
 269:   store_uav_typed g_ResolveParam2.xyzw, r17.xyzw, r6.xyzw
 270: endif
 271: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.x, r1.z, l(0), g_InstanceParam.xxxx
 272: and r0.y, r0.x, l(255)
 273: utof r0.y, r0.y
 274: mul r3.x, r0.y, l(0.003922)
 275: ubfe r0.xy, l(8, 8, 0, 0), l(8, 16, 0, 0), r0.xxxx
 276: utof r0.xy, r0.xyxx
 277: mul r3.yz, r0.xxyx, l(0.000000, 0.003922, 0.003922, 0.000000)
 278: div r0.xy, v6.xyxx, v6.wwww
 279: add r0.xy, r0.xyxx, g_ProjectionOffset.xyxx
 280: add r0.xy, r0.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
 281: mul r0.x, r0.x, l(0.500000)
 282: div r1.zw, v7.xxxy, v7.wwww
 283: add r1.zw, r1.zzzw, g_ProjectionOffset.zzzw
 284: add r1.zw, r1.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
 285: mul r2.x, r1.z, l(0.500000)
 286: ubfe r6.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r4.xxxx
 287: and r1.z, r4.x, l(15)
 288: utof r1.z, r1.z
 289: exp r12.xz, r1.zzzz
 290: mul r12.y, r2.y, r12.z
 291: mul r9.xy, r9.xyxx, r12.zyzz
 292: frc r9.xy, r9.xyxx
 293: utof r6.xyz, r6.xyzx
 294: mad r9.xy, r9.xyxx, r1.xyxx, r6.xyxx
 295: mov r5.x, r4.w
 296: mad r6.xy, r9.xyxx, r4.yzyy, r5.xyxx
 297: mul r12.xyz, r1.xyxx, r12.xyzx
 298: mul r4.xyz, r4.yzyy, r12.xyzx
 299: mul r4.xyz, r3.wwww, r4.xyzx
 300: mul r7.xyz, r4.xyzx, r7.xyzx
 301: mul r4.xyz, r4.xyzx, r8.xyzx
 302: sample_d(texture2darray)(float,float,float,float) r4.xyz, r6.xyzx, g_AlbedoCacheTexture.xyzw, g_CacheSampler, r7.xyzx, r4.xyzx
 303: ne r1.z, l(0, 0, 0, 0), g_CompParam1.w
 304: movc r6.xyzw, r1.zzzz, g_CompParam2.xyzw, l(1.000000, 0.972951, 0.700000, 2.000000)
 305: ubfe r7.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r18.xxxx
 306: and r1.z, r18.x, l(15)
 307: utof r1.z, r1.z
 308: exp r8.xz, r1.zzzz
 309: mul r8.y, r2.y, r8.z
 310: mul r5.xy, r5.zwzz, r8.zyzz
 311: frc r5.xy, r5.xyxx
 312: utof r7.xyz, r7.xyzx
 313: mad r5.xy, r5.xyxx, r1.xyxx, r7.xyxx
 314: mad r7.xy, r5.xyxx, r14.xyxx, r14.zwzz
 315: mul r5.xyz, r1.xyxx, r8.xyzx
 316: mul r5.xyz, r14.xyxx, r5.xyzx
 317: mul r5.xyz, r3.wwww, r5.xyzx
 318: mul r8.xyz, r5.xyzx, r13.xywx
 319: mul r5.xyz, r5.xyzx, r16.xyzx
 320: sample_d(texture2darray)(float,float,float,float) r5.xyz, r7.xyzx, g_MaskCacheTexture.xyzw, g_CacheSampler, r8.xyzx, r5.xyzx
 321: if_z g_UseNormalMap.x
 322:   mov r7.xyz, v3.xyzx
 323: else
 324:   ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r8.xyzw, r0.w, l(80), g_TileSetParamBlock.xyzw
 325:   ubfe r12.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r13.zzzz
 326:   and r0.w, r13.z, l(15)
 327:   utof r0.w, r0.w
 328:   exp r13.xz, r0.wwww
 329:   mul r13.y, r2.y, r13.z
 330:   mul r2.yw, r9.zzzw, r13.zzzy
 331:   frc r2.yw, r2.yyyw
 332:   utof r9.xyz, r12.xyzx
 333:   mad r2.yw, r2.yyyw, r1.xxxy, r9.xxxy
 334:   mad r9.xy, r2.ywyy, r8.xyxx, r8.zwzz
 335:   mul r1.xyz, r1.xyxx, r13.xyzx
 336:   mul r1.xyz, r8.xyxx, r1.xyzx
 337:   mul r1.xyz, r3.wwww, r1.xyzx
 338:   mul r8.xyz, r1.xyzx, r10.xyzx
 339:   mul r1.xyz, r1.xyzx, r11.xyzx
 340:   sample_d(texture2darray)(float,float,float,float) r1.xyz, r9.xyzx, g_NormalCacheTexture.xywz, g_CacheSampler, r8.xyzx, r1.xyzx
 341:   mul r1.x, r1.z, r1.x
 342:   mad r1.xy, r1.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
 343:   dp2 r0.w, r1.xyxx, r1.xyxx
 344:   min r0.w, r0.w, l(1.000000)
 345:   add r0.w, -r0.w, l(1.000000)
 346:   sqrt r0.w, r0.w
 347:   mul r8.xyz, -r1.yyyy, v5.xyzx
 348:   mad r1.xyz, r1.xxxx, v4.xyzx, r8.xyzx
 349:   mad r1.xyz, r0.wwww, v3.xyzx, r1.xyzx
 350:   dp3 r0.w, r1.xyzx, r1.xyzx
 351:   rsq r0.w, r0.w
 352:   mul r7.xyz, r0.wwww, r1.xyzx
 353: endif
 354: ieq r0.w, v11.x, l(0)
 355: ine r1.x, g_IsBackFaceReverseNormal.x, l(0)
 356: and r0.w, r0.w, r1.x
 357: if_nz r0.w
 358:   mov r7.xyz, -r7.xyzx
 359: endif
 360: movc r1.xyz, g_bAlbedoOverWrite.xxxx, g_AlbedoColor.xyzx, r4.xyzx
 361: movc o1.x, g_bMetalicOverWrite.x, l(0), r5.x
 362: if_nz g_UseNoise.x
 363:   rcp r0.w, g_NoiseScale.x
 364:   mul r4.xyz, r0.wwww, v2.xyzx
 365:   round_ni r8.xyz, r4.xyzx
 366:   mul r9.xyz, r8.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 367:   round_ni r9.xyz, r9.xyzx
 368:   mad r8.xyz, -r9.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r8.xyzx
 369:   frc r4.xyz, r4.xyzx
 370:   add r9.xyz, r4.xxxx, l(0.500000, -0.500000, -1.500000, 0.000000)
 371:   add r4.xyw, r4.yyyy, l(0.500000, -0.500000, 0.000000, -1.500000)
 372:   add r10.xyz, r4.zzzz, l(0.500000, -0.500000, -1.500000, 0.000000)
 373:   add r11.xyz, r8.xxxx, l(-1.000000, 0.000000, 1.000000, 0.000000)
 374:   mad r12.xyz, r11.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 375:   mul r11.xyz, r11.xyzx, r12.xyzx
 376:   mul r12.xyz, r11.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 377:   round_ni r12.xyz, r12.xyzx
 378:   mad r11.xyz, -r12.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r11.xyzx
 379:   add r8.xyw, r8.yyyy, r11.xyxz
 380:   add r11.xyz, r8.xywx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 381:   mad r12.xyz, r11.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 382:   mul r11.xyz, r11.xyzx, r12.xyzx
 383:   mul r12.xyz, r11.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 384:   round_ni r12.xyz, r12.xyzx
 385:   mad r11.xyz, -r12.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r11.xyzx
 386:   mad r12.xyz, r8.xywx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 387:   mul r12.xyz, r8.xywx, r12.xyzx
 388:   mul r13.xyz, r12.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 389:   round_ni r13.xyz, r13.xyzx
 390:   mad r12.xyz, -r13.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r12.xyzx
 391:   add r8.xyw, r8.xyxw, l(1.000000, 1.000000, 0.000000, 1.000000)
 392:   mad r13.xyz, r8.xywx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 393:   mul r8.xyw, r8.xyxw, r13.xyxz
 394:   mul r13.xyz, r8.xywx, l(0.003460, 0.003460, 0.003460, 0.000000)
 395:   round_ni r13.xyz, r13.xyzx
 396:   mad r8.xyw, -r13.xyxz, l(289.000000, 289.000000, 0.000000, 289.000000), r8.xyxw
 397:   add r11.xyz, r8.zzzz, r11.xyzx
 398:   add r13.xyz, r11.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 399:   mad r14.xyz, r13.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 400:   mul r13.xyz, r13.xyzx, r14.xyzx
 401:   mul r14.xyz, r13.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 402:   round_ni r14.xyz, r14.xyzx
 403:   mad r13.xyz, -r14.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r13.xyzx
 404:   mad r14.xyz, r11.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 405:   mul r14.xyz, r11.xyzx, r14.xyzx
 406:   mul r15.xyz, r14.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 407:   round_ni r15.xyz, r15.xyzx
 408:   mad r14.xyz, -r15.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r14.xyzx
 409:   add r11.xyz, r11.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 410:   mad r15.xyz, r11.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 411:   mul r11.xyz, r11.xyzx, r15.xyzx
 412:   mul r15.xyz, r11.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 413:   round_ni r15.xyz, r15.xyzx
 414:   mad r11.xyz, -r15.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r11.xyzx
 415:   add r12.xyz, r8.zzzz, r12.xyzx
 416:   add r15.xyz, r12.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 417:   mad r16.xyz, r15.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 418:   mul r15.xyz, r15.xyzx, r16.xyzx
 419:   mul r16.xyz, r15.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 420:   round_ni r16.xyz, r16.xyzx
 421:   mad r15.xyz, -r16.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r15.xyzx
 422:   mad r16.xyz, r12.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 423:   mul r16.xyz, r12.xyzx, r16.xyzx
 424:   mul r17.xyz, r16.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 425:   round_ni r17.xyz, r17.xyzx
 426:   mad r16.xyz, -r17.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r16.xyzx
 427:   add r12.xyz, r12.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 428:   mad r17.xyz, r12.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 429:   mul r12.xyz, r12.xyzx, r17.xyzx
 430:   mul r17.xyz, r12.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 431:   round_ni r17.xyz, r17.xyzx
 432:   mad r12.xyz, -r17.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r12.xyzx
 433:   add r8.xyz, r8.zzzz, r8.xywx
 434:   add r17.xyz, r8.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 435:   mad r18.xyz, r17.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 436:   mul r17.xyz, r17.xyzx, r18.xyzx
 437:   mul r18.xyz, r17.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 438:   round_ni r18.xyz, r18.xyzx
 439:   mad r17.xyz, -r18.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r17.xyzx
 440:   mad r18.xyz, r8.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 441:   mul r18.xyz, r8.xyzx, r18.xyzx
 442:   mul r19.xyz, r18.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 443:   round_ni r19.xyz, r19.xyzx
 444:   mad r18.xyz, -r19.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r18.xyzx
 445:   add r8.xyz, r8.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 446:   mad r19.xyz, r8.xyzx, l(34.000000, 34.000000, 34.000000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
 447:   mul r8.xyz, r8.xyzx, r19.xyzx
 448:   mul r19.xyz, r8.xyzx, l(0.003460, 0.003460, 0.003460, 0.000000)
 449:   round_ni r19.xyz, r19.xyzx
 450:   mad r8.xyz, -r19.xyzx, l(289.000000, 289.000000, 289.000000, 0.000000), r8.xyzx
 451:   mul r19.xyz, r13.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 452:   frc r20.xyz, r19.xyzx
 453:   add r20.xyz, r20.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 454:   round_ni r19.xyz, r19.xyzx
 455:   mul r21.xyz, r19.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 456:   round_ni r21.xyz, r21.xyzx
 457:   mad r19.xyz, -r21.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r19.xyzx
 458:   mad r19.xyz, r19.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 459:   mul r13.xyz, r13.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 460:   round_ni r13.xyz, r13.xyzx
 461:   mad r13.xyz, r13.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 462:   mul r21.xyz, r14.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 463:   frc r22.xyz, r21.xyzx
 464:   add r22.xyz, r22.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 465:   round_ni r21.xyz, r21.xyzx
 466:   mul r23.xyz, r21.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 467:   round_ni r23.xyz, r23.xyzx
 468:   mad r21.xyz, -r23.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r21.xyzx
 469:   mad r21.xyz, r21.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 470:   mul r14.xyz, r14.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 471:   round_ni r14.xyz, r14.xyzx
 472:   mad r14.xyz, r14.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 473:   mul r23.xyz, r11.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 474:   frc r24.xyz, r23.xyzx
 475:   add r24.xyz, r24.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 476:   round_ni r23.xyz, r23.xyzx
 477:   mul r25.xyz, r23.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 478:   round_ni r25.xyz, r25.xyzx
 479:   mad r23.xyz, -r25.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r23.xyzx
 480:   mad r23.xyz, r23.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 481:   mul r11.xyz, r11.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 482:   round_ni r11.xyz, r11.xyzx
 483:   mad r11.xyz, r11.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 484:   mul r25.xyz, r15.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 485:   frc r26.xyz, r25.xyzx
 486:   add r26.xyz, r26.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 487:   round_ni r25.xyz, r25.xyzx
 488:   mul r27.xyz, r25.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 489:   round_ni r27.xyz, r27.xyzx
 490:   mad r25.xyz, -r27.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r25.xyzx
 491:   mad r25.xyz, r25.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 492:   mul r15.xyz, r15.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 493:   round_ni r15.xyz, r15.xyzx
 494:   mad r15.xyz, r15.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 495:   mul r27.xyz, r16.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 496:   frc r28.xyz, r27.xyzx
 497:   add r28.xyz, r28.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 498:   round_ni r27.xyz, r27.xyzx
 499:   mul r29.xyz, r27.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 500:   round_ni r29.xyz, r29.xyzx
 501:   mad r27.xyz, -r29.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r27.xyzx
 502:   mad r27.xyz, r27.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 503:   mul r16.xyz, r16.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 504:   round_ni r16.xyz, r16.xyzx
 505:   mad r16.xyz, r16.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 506:   mul r29.xyz, r12.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 507:   frc r30.xyz, r29.xyzx
 508:   add r30.xyz, r30.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 509:   round_ni r29.xyz, r29.xyzx
 510:   mul r31.xyz, r29.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 511:   round_ni r31.xyz, r31.xyzx
 512:   mad r29.xyz, -r31.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r29.xyzx
 513:   mad r29.xyz, r29.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 514:   mul r12.xyz, r12.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 515:   round_ni r12.xyz, r12.xyzx
 516:   mad r12.xyz, r12.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 517:   mul r31.xyz, r17.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 518:   frc r32.xyz, r31.xyzx
 519:   add r32.xyz, r32.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 520:   round_ni r31.xyz, r31.xyzx
 521:   mul r33.xyz, r31.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 522:   round_ni r33.xyz, r33.xyzx
 523:   mad r31.xyz, -r33.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r31.xyzx
 524:   mad r31.xyz, r31.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 525:   mul r17.xyz, r17.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 526:   round_ni r17.xyz, r17.xyzx
 527:   mad r17.xyz, r17.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 528:   mul r33.xyz, r18.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 529:   frc r34.xyz, r33.xyzx
 530:   add r34.xyz, r34.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 531:   round_ni r33.xyz, r33.xyzx
 532:   mul r35.xyz, r33.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 533:   round_ni r35.xyz, r35.xyzx
 534:   mad r33.xyz, -r35.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r33.xyzx
 535:   mad r33.xyz, r33.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 536:   mul r18.xyz, r18.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 537:   round_ni r18.xyz, r18.xyzx
 538:   mad r18.xyz, r18.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 539:   mul r35.xyz, r8.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 540:   frc r36.xyz, r35.xyzx
 541:   add r36.xyz, r36.xyzx, l(-0.428571, -0.428571, -0.428571, 0.000000)
 542:   round_ni r35.xyz, r35.xyzx
 543:   mul r37.xyz, r35.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000)
 544:   round_ni r37.xyz, r37.xyzx
 545:   mad r35.xyz, -r37.xyzx, l(7.000000, 7.000000, 7.000000, 0.000000), r35.xyzx
 546:   mad r35.xyz, r35.xyzx, l(0.142857, 0.142857, 0.142857, 0.000000), l(-0.428571, -0.428571, -0.428571, 0.000000)
 547:   mul r8.xyz, r8.xyzx, l(0.020408, 0.020408, 0.020408, 0.000000)
 548:   round_ni r8.xyz, r8.xyzx
 549:   mad r8.xyz, r8.xyzx, l(0.166667, 0.166667, 0.166667, 0.000000), l(-0.416667, -0.416667, -0.416667, 0.000000)
 550:   mad r20.xyz, g_NoiseJitter.xxxx, r20.xyzx, r9.xyzx
 551:   mad r19.xyz, g_NoiseJitter.xxxx, r19.xyzx, r4.xxxx
 552:   mad r13.xyz, g_NoiseJitter.xxxx, r13.xyzx, r10.xxxx
 553:   mad r22.xyz, g_NoiseJitter.xxxx, r22.xyzx, r9.xyzx
 554:   mad r21.xyz, g_NoiseJitter.xxxx, r21.xyzx, r4.xxxx
 555:   mad r14.xyz, g_NoiseJitter.xxxx, r14.xyzx, r10.yyyy
 556:   mad r24.xyz, g_NoiseJitter.xxxx, r24.xyzx, r9.xyzx
 557:   mad r23.xyz, g_NoiseJitter.xxxx, r23.xyzx, r4.xxxx
 558:   mad r11.xyz, g_NoiseJitter.xxxx, r11.xyzx, r10.zzzz
 559:   mad r26.xyz, g_NoiseJitter.xxxx, r26.xyzx, r9.xyzx
 560:   mad r25.xyz, g_NoiseJitter.xxxx, r25.xyzx, r4.yyyy
 561:   mad r15.xyz, g_NoiseJitter.xxxx, r15.xyzx, r10.xxxx
 562:   mad r28.xyz, g_NoiseJitter.xxxx, r28.xyzx, r9.xyzx
 563:   mad r27.xyz, g_NoiseJitter.xxxx, r27.xyzx, r4.yyyy
 564:   mad r16.xyz, g_NoiseJitter.xxxx, r16.xyzx, r10.yyyy
 565:   mad r30.xyz, g_NoiseJitter.xxxx, r30.xyzx, r9.xyzx
 566:   mad r4.xyz, g_NoiseJitter.xxxx, r29.xyzx, r4.yyyy
 567:   mad r12.xyz, g_NoiseJitter.xxxx, r12.xyzx, r10.zzzz
 568:   mad r29.xyz, g_NoiseJitter.xxxx, r32.xyzx, r9.xyzx
 569:   mad r31.xyz, g_NoiseJitter.xxxx, r31.xyzx, r4.wwww
 570:   mad r17.xyz, g_NoiseJitter.xxxx, r17.xyzx, r10.xxxx
 571:   mad r32.xyz, g_NoiseJitter.xxxx, r34.xyzx, r9.xyzx
 572:   mad r33.xyz, g_NoiseJitter.xxxx, r33.xyzx, r4.wwww
 573:   mad r10.xyw, g_NoiseJitter.xxxx, r18.xyxz, r10.yyyy
 574:   mad r9.xyz, g_NoiseJitter.xxxx, r36.xyzx, r9.xyzx
 575:   mad r18.xyz, g_NoiseJitter.xxxx, r35.xyzx, r4.wwww
 576:   mad r8.xyz, g_NoiseJitter.xxxx, r8.xyzx, r10.zzzz
 577:   mul r19.xyz, r19.xyzx, r19.xyzx
 578:   mad r19.xyz, r20.xyzx, r20.xyzx, r19.xyzx
 579:   mad r13.xyz, r13.xyzx, r13.xyzx, r19.xyzx
 580:   mul r19.xyz, r21.xyzx, r21.xyzx
 581:   mad r19.xyz, r22.xyzx, r22.xyzx, r19.xyzx
 582:   mad r14.xyz, r14.xyzx, r14.xyzx, r19.xyzx
 583:   mul r19.xyz, r23.xyzx, r23.xyzx
 584:   mad r19.xyz, r24.xyzx, r24.xyzx, r19.xyzx
 585:   mad r11.xyz, r11.xyzx, r11.xyzx, r19.xyzx
 586:   mul r19.xyz, r25.xyzx, r25.xyzx
 587:   mad r19.xyz, r26.xyzx, r26.xyzx, r19.xyzx
 588:   mad r15.xyz, r15.xyzx, r15.xyzx, r19.xyzx
 589:   mul r19.xyz, r27.xyzx, r27.xyzx
 590:   mad r19.xyz, r28.xyzx, r28.xyzx, r19.xyzx
 591:   mad r16.xyz, r16.xyzx, r16.xyzx, r19.xyzx
 592:   mul r4.xyz, r4.xyzx, r4.xyzx
 593:   mad r4.xyz, r30.xyzx, r30.xyzx, r4.xyzx
 594:   mad r4.xyz, r12.xyzx, r12.xyzx, r4.xyzx
 595:   mul r12.xyz, r31.xyzx, r31.xyzx
 596:   mad r12.xyz, r29.xyzx, r29.xyzx, r12.xyzx
 597:   mad r12.xyz, r17.xyzx, r17.xyzx, r12.xyzx
 598:   mul r17.xyz, r33.xyzx, r33.xyzx
 599:   mad r17.xyz, r32.xyzx, r32.xyzx, r17.xyzx
 600:   mad r10.xyz, r10.xywx, r10.xywx, r17.xyzx
 601:   mul r17.xyz, r18.xyzx, r18.xyzx
 602:   mad r9.xyz, r9.xyzx, r9.xyzx, r17.xyzx
 603:   mad r8.xyz, r8.xyzx, r8.xyzx, r9.xyzx
 604:   min r9.xyz, r13.xyzx, r14.xyzx
 605:   min r9.xyz, r11.xyzx, r9.xyzx
 606:   min r11.xyz, r15.xyzx, r16.xyzx
 607:   min r4.xyz, r4.xyzx, r11.xyzx
 608:   min r10.xyz, r10.xyzx, r12.xyzx
 609:   min r8.xyz, r8.xyzx, r10.xyzx
 610:   min r4.xyz, r4.xyzx, r9.xyzx
 611:   min r4.xyz, r8.xyzx, r4.xyzx
 612:   min r0.w, r4.y, r4.x
 613:   min r0.w, r4.z, r0.w
 614:   log r0.w, r0.w
 615:   mul r0.w, r0.w, l(0.250000)
 616:   exp r0.w, r0.w
 617:   add r0.w, -r0.w, l(1.000000)
 618:   add r2.y, -g_NoiseSize.x, l(1.000000)
 619:   add r0.w, r0.w, -g_NoiseSize.x
 620:   div r2.y, l(1.000000, 1.000000, 1.000000, 1.000000), r2.y
 621:   mul_sat r0.w, r0.w, r2.y
 622:   mad r2.y, r0.w, l(-2.000000), l(3.000000)
 623:   mul r0.w, r0.w, r0.w
 624:   mul r0.w, r0.w, r2.y
 625:   mad r4.xyz, g_NoiseColor.xyzx, l(0.500000, 1.000000, 1.000000, 0.000000), l(-1.000000, -1.000000, -1.000000, 0.000000)
 626:   mad r4.xyz, r0.wwww, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 627:   mul r1.xyz, r1.xyzx, r4.xyzx
 628: endif
 629: mul r4.xyz, r6.xyzx, r1.xyzx
 630: mad r4.xyz, r4.xyzx, r6.wwww, -r1.xyzx
 631: mad r4.xyz, v8.xxxx, r4.xyzx, r1.xyzx
 632: movc r1.xyz, g_UseWaveColor.xxxx, r4.xyzx, r1.xyzx
 633: eq r0.w, v9.w, l(0)
 634: mul r1.xyz, r3.xyzx, r1.xyzx
 635: ftou r2.y, g_CameraVec.w
 636: udiv r2.y, null, r2.y, l(3)
 637: udiv null, r2.y, r2.y, l(3)
 638: movc r3.x, r2.y, l(0), v9.x
 639: ine r2.yw, r2.yyyy, l(0, 1, 0, 2)
 640: movc r3.yz, r2.yywy, l(0, 0, 0, 0), v9.yyzy
 641: movc o0.xyz, r0.wwww, r1.xyzx, r3.xyzx
 642: mad r2.z, -r1.w, l(0.500000), l(1.000000)
 643: mad r0.z, -r0.y, l(0.500000), l(1.000000)
 644: add o3.xy, r0.xzxx, -r2.xzxx
 645: mad o2.xyz, r7.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
 646: mov o0.w, l(0)
 647: mov o1.yz, r5.yyzy
 648: mov o1.w, l(0)
 649: mov o2.w, l(0)
 650: ret
