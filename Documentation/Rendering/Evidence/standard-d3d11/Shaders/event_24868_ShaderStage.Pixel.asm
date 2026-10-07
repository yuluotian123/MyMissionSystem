Shader hash b48f5c5c-9a4e9c93-86e350df-8fc5dd45

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
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb10[13] (ShadowView_Buffer), immediateIndexed
      dcl_constantbuffer cb7[1] (CharacterShaderParam), immediateIndexed
      dcl_constantbuffer cb6[21] (CutCharacterMaterialDataBuf), immediateIndexed
      dcl_constantbuffer cb5[5] (ShaderParams), dynamicIndexed
      dcl_constantbuffer cb1[1] (ParamBuffer), immediateIndexed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_sampler g_Shadow_TexSampler (s3), mode_comparison
      dcl_sampler g_CacheSampler (s6), mode_default
      dcl_resource_texture2darray (float,float,float,float) g_AlbedoCacheTexture (t0)
      dcl_resource_texture2darray (float,float,float,float) g_Shadow_Tex (t3)
      dcl_resource_texture2d (float,float,float,float) g_PatternMap (t6)
      dcl_resource_texture2d (float,float,float,float) g_BooleanMask (t8)
      dcl_resource_texture2d (float,float,float,float) g_DitherTex (t14)
      dcl_resource_structured g_TileSetParamBlock (t21), 128
      dcl_resource_structured g_StreamTextureParamBlock (t22), 32
      dcl_resource_texture2d (float,float,float,float) g_PageTableTexture (t23)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_input_ps_siv linear noperspective v0.xyz, position
      dcl_input_ps linear v1.xyz
      dcl_input_ps linear v2.w
      dcl_input_ps linear v3.w
      dcl_input_ps linear v5.xyw
      dcl_input_ps linear v6.xyw
      dcl_input_ps nointerpolation v7.x
      dcl_output o0.xyzw
      dcl_output o1.xy
      dcl_temps 12
   0: iadd r0.x, v7.x, l(2)
   1: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.x, r0.x, l(0), g_InstanceParam.xxxx
   2: ne r0.x, l(0, 0, 0, 0), r0.x
   3: if_nz r0.x
   4:   ftoi r0.xy, v0.xyxx
   5:   mov r0.zw, l(0, 0, 0, 0)
   6:   ld_indexable(texture2d)(float,float,float,float) r0.x, r0.xyzw, g_BooleanMask.xyzw
   7:   lt r0.x, r0.x, v0.z
   8:   discard_nz r0.x
   9: endif
  10: iadd r0.xy, v7.xxxx, l(4, 5, 0, 0)
  11: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.x, r0.x, l(0), g_InstanceParam.xxxx
  12: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.y, r0.y, l(0), g_InstanceParam.xxxx
  13: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r1.xy, r0.y, l(48), g_TileSetParamBlock.xyxx
  14: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r2.xyzw, r0.y, l(4), g_TileSetParamBlock.xyzw
  15: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r3.xyzw, r0.x, l(0), g_StreamTextureParamBlock.xyzw
  16: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r0.z, r0.x, l(16), g_StreamTextureParamBlock.xxxx
  17: ld_structured_indexable(structured_buffer, stride=32)(mixed,mixed,mixed,mixed) r0.x, r0.x, l(28), g_StreamTextureParamBlock.xxxx
  18: deriv_rtx_coarse r4.xz, v2.wwww
  19: deriv_rtx_coarse r4.y, v3.w
  20: mul r4.xyz, r3.zwzz, r4.xyzx
  21: deriv_rty_coarse r5.xz, v2.wwww
  22: deriv_rty_coarse r5.y, v3.w
  23: mul r5.xyz, r3.zwzz, r5.xyzx
  24: frc r6.x, v2.w
  25: frc r6.y, v3.w
  26: mad r6.zw, r6.xxxy, r3.zzzw, r3.xxxy
  27: mul r7.xy, r2.yzyy, r4.zyzz
  28: mul r2.yz, r2.yyzy, r5.zzyz
  29: dp2 r0.w, r7.xyxx, r7.xyxx
  30: dp2 r1.w, r2.yzyy, r2.yzyy
  31: max r2.y, r0.w, r1.w
  32: min r0.w, r0.w, r1.w
  33: log r1.w, r2.y
  34: mul r2.y, r1.w, l(0.500000)
  35: log r0.w, r0.w
  36: mad r0.w, -r0.w, l(0.500000), r2.y
  37: min r0.w, r2.x, r0.w
  38: mad r0.w, r1.w, l(0.500000), -r0.w
  39: add r0.w, r0.w, l(-0.500000)
  40: max r0.w, r0.w, l(0)
  41: min r0.w, r0.z, r0.w
  42: add r0.w, r0.w, l(0.500000)
  43: round_ni r0.w, r0.w
  44: mul r1.z, r1.y, r1.x
  45: mul r2.xy, r1.xzxx, r6.zwzz
  46: exp r1.w, -r0.w
  47: mul r2.xy, r1.wwww, r2.xyxx
  48: round_ni r2.xy, r2.xyxx
  49: ftoi r7.xy, r2.xyxx
  50: ftoi r7.zw, r0.wwww
  51: ld_indexable(texture2d)(float,float,float,float) r2.x, r7.xyzw, g_PageTableTexture.xyzw
  52: and r2.y, r2.x, l(15)
  53: utof r2.y, r2.y
  54: add r0.x, r0.x, -r2.y
  55: lt r2.y, r0.z, r0.x
  56: if_nz r2.y
  57:   add r0.x, -r0.z, r0.x
  58:   max r0.x, r0.x, l(0)
  59:   min r0.x, r0.x, l(6.000000)
  60:   ftou r0.x, r0.x
  61:   add r0.z, l(1.000000), -icb[r0.x + 3].x
  62:   max r2.yz, r6.xxyx, icb[r0.x + 3].xxxx
  63:   min r0.xz, r0.zzzz, r2.yyzy
  64:   mad r6.zw, r0.xxxz, r3.zzzw, r3.xxxy
  65:   mul r0.xz, r1.xxzx, r6.zzwz
  66:   mul r0.xz, r1.wwww, r0.xxzx
  67:   round_ni r0.xz, r0.xxzx
  68:   ftoi r3.xy, r0.xzxx
  69:   ftoi r3.zw, r0.wwww
  70:   ld_indexable(texture2d)(float,float,float,float) r2.x, r3.xyzw, g_PageTableTexture.xyzw
  71: endif
  72: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.x, v7.x, l(0), g_InstanceParam.xxxx
  73: ushr r0.x, r0.x, l(24)
  74: utof r0.x, r0.x
  75: mul r0.x, r0.x, charaMaterial_.ditherAlpha_.x
  76: mad r0.zw, g_ProjectionOffset.xxxy, l(0.000000, 0.000000, 64.000000, 64.000000), v0.xxxy
  77: ftoi r0.zw, r0.zzzw
  78: and r3.xy, r0.zwzz, l(63, 63, 0, 0)
  79: mov r3.zw, l(0, 0, 0, 0)
  80: ld_indexable(texture2d)(float,float,float,float) r0.zw, r3.xyzw, g_DitherTex.ywxz
  81: and r1.x, g_FrameCount[0].x, l(2)
  82: dp2 r0.z, r0.zwzz, icb[r1.x + 0].xzxx
  83: mul r0.x, r0.x, l(0.003937)
  84: ge r0.x, r0.z, r0.x
  85: discard_nz r0.x
  86: div r0.xz, v5.xxyx, v5.wwww
  87: add r0.xz, r0.xxzx, g_ProjectionOffset.xxyx
  88: add r0.xz, r0.xxzx, l(1.000000, 0.000000, 1.000000, 0.000000)
  89: mul r1.x, r0.x, l(0.500000)
  90: div r0.xw, v6.xxxy, v6.wwww
  91: add r0.xw, r0.xxxw, g_ProjectionOffset.zzzw
  92: add r0.xw, r0.xxxw, l(1.000000, 0.000000, 0.000000, 1.000000)
  93: mul r3.x, r0.x, l(0.500000)
  94: mov r6.x, v2.w
  95: mov r6.y, v3.w
  96: mul r2.yz, r6.xxyx, l(0.000000, 3.000000, 3.000000, 0.000000)
  97: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r3.yw, r0.y, l(32), g_TileSetParamBlock.xxxy
  98: ld_structured_indexable(structured_buffer, stride=128)(mixed,mixed,mixed,mixed) r7.xyzw, r0.y, l(64), g_TileSetParamBlock.xyzw
  99: sample_indexable(texture2d)(float,float,float,float) r0.x, r2.yzyy, g_PatternMap.xyzw, ModelSampler
 100: add r8.xyz, -v1.xyzx, g_CameraVec.xyzx
 101: dp3 r0.y, r8.xyzx, r8.xyzx
 102: sqrt r0.y, r0.y
 103: add r1.w, g_ShadowSpritLength.y, l(-3.000000)
 104: lt r1.w, r1.w, r0.y
 105: if_nz r1.w
 106:   mov r8.xyz, v1.xyzx
 107:   mov r8.w, l(1.000000)
 108:   dp4 r6.x, r8.xyzw, g_ShadowViewProj[2][7].xyzw
 109:   dp4 r6.y, r8.xyzw, g_ShadowViewProj[2][8].xyzw
 110:   dp4 r9.w, r8.xyzw, g_ShadowViewProj[2][9].xyzw
 111:   dp4 r1.w, r8.xyzw, g_ShadowViewProj[2][10].xyzw
 112:   div r2.yz, r6.xxyx, r1.wwww
 113:   mad_sat r9.xy, r2.yzyy, l(0.500000, -0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
 114:   mov r9.z, l(2.000000)
 115: else
 116:   add r2.yz, g_ShadowSpritLength.xxxx, l(0.000000, -3.000000, 3.000000, 0.000000)
 117:   lt r1.w, r2.y, r0.y
 118:   mov r8.xyz, v1.xyzx
 119:   mov r8.w, l(1.000000)
 120:   dp4 r6.x, r8.xyzw, g_ShadowViewProj[1][3].xyzw
 121:   dp4 r6.y, r8.xyzw, g_ShadowViewProj[1][4].xyzw
 122:   dp4 r10.z, r8.xyzw, g_ShadowViewProj[1][5].xyzw
 123:   dp4 r2.y, r8.xyzw, g_ShadowViewProj[1][6].xyzw
 124:   div r6.xy, r6.xyxx, r2.yyyy
 125:   mad_sat r10.xy, r6.xyxx, l(0.500000, -0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
 126:   lt r0.y, r0.y, r2.z
 127:   dp4 r6.x, r8.xyzw, g_ShadowViewProj[0][0].xyzw
 128:   dp4 r6.y, r8.xyzw, g_ShadowViewProj[0][1].xyzw
 129:   dp4 r11.z, r8.xyzw, g_ShadowViewProj[0][2].xyzw
 130:   dp4 r2.y, r8.xyzw, g_ShadowViewProj[0][3].xyzw
 131:   div r2.yz, r6.xxyx, r2.yyyy
 132:   mad_sat r11.xy, r2.yzyy, l(0.500000, -0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
 133:   mov r11.w, l(0)
 134:   movc r8.xyzw, r0.yyyy, r11.xyzw, l(-1.000000, -1.000000, -1.000000, -1.000000)
 135:   mov r10.w, l(1.000000)
 136:   movc r9.xyzw, r1.wwww, r10.xywz, r8.xywz
 137: endif
 138: ge r0.y, r9.z, l(0)
 139: if_nz r0.y
 140:   sample_c_lz(texture2darray)(float,float,float,float) r0.y, r9.xyzx, g_Shadow_Tex.xxxx, g_Shadow_TexSampler, r9.w
 141: else
 142:   mov r0.y, l(1.000000)
 143: endif
 144: add r1.w, l(1.000000), -g_CharacterParam.x
 145: mad r0.y, r0.y, r1.w, g_CharacterParam.x
 146: add r0.x, r0.x, charaMaterial_.outlineAlphaCorrection_.x
 147: min o0.w, r0.x, l(1.000000)
 148: ubfe r8.xyz, l(10, 10, 7, 0), l(14, 4, 24, 0), r2.xxxx
 149: and r0.x, r2.x, l(15)
 150: utof r0.x, r0.x
 151: exp r2.xz, r0.xxxx
 152: mul r2.y, r1.y, r2.z
 153: mul r1.yw, r2.zzzy, r6.zzzw
 154: frc r1.yw, r1.yyyw
 155: utof r6.xyz, r8.xyzx
 156: mad r1.yw, r1.yyyw, r3.yyyw, r6.xxxy
 157: mad r6.xy, r1.ywyy, r7.xyxx, r7.zwzz
 158: mul r2.xyz, r3.ywyy, r2.xyzx
 159: mul r2.xyz, r7.xyxx, r2.xyzx
 160: mul r2.xyz, r2.wwww, r2.xyzx
 161: mul r4.xyz, r2.xyzx, r4.xyzx
 162: mul r2.xyz, r2.xyzx, r5.xyzx
 163: sample_d(texture2darray)(float,float,float,float) r2.xyz, r6.xyzx, g_AlbedoCacheTexture.xyzw, g_CacheSampler, r4.xyzx, r2.xyzx
 164: add r4.xyz, -r2.xyzx, g_OutLineColor.xyzx
 165: mad r2.xyz, g_OutLineColorBlend.xxxx, r4.xyzx, r2.xyzx
 166: mul r0.x, charaMaterial_.lightIntensity_.x, charaMaterial_.outlineLuminuss_.x
 167: mul r2.xyz, r0.xxxx, r2.xyzx
 168: max r0.x, r0.y, l(0.200000)
 169: mul r2.xyz, r0.xxxx, r2.xyzx
 170: add r0.x, v0.z, g_Proj[2].z
 171: div r0.x, g_Proj[2].w, r0.x
 172: add r0.x, r0.x, -g_CameraParam.x
 173: div r0.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_CameraParam.y
 174: mul r1.y, r0.y, r0.x
 175: mov r3.yw, l(0, 0, 0, 0)
 176: mov r1.w, l(1)
 177: loop
 178:   ige r2.w, r1.w, l(3)
 179:   breakc_nz r2.w
 180:   iadd r4.xy, r1.wwww, l(-1, 1, 0, 0)
 181:   mad r2.w, r0.x, r0.y, -cb5[r4.x + 2].x
 182:   add r4.z, -cb5[r4.x + 2].x, cb5[r1.w + 2].x
 183:   div r2.w, r2.w, r4.z
 184:   add r4.z, -r2.w, l(1.000000)
 185:   mul r4.w, r4.z, r4.z
 186:   mul r4.w, r4.z, r4.w
 187:   mul r5.x, r4.z, l(3.000000)
 188:   mul r4.z, r4.z, r5.x
 189:   mul r4.z, r2.w, r4.z
 190:   mul r5.y, r2.w, r2.w
 191:   mul r5.x, r5.x, r5.y
 192:   mul r5.y, r2.w, r5.y
 193:   add r5.z, cb5[r4.x + 2].w, cb5[r4.x + 2].y
 194:   add r5.w, cb5[r1.w + 2].z, cb5[r1.w + 2].y
 195:   mul r4.z, r4.z, r5.z
 196:   mad r4.x, cb5[r4.x + 2].y, r4.w, r4.z
 197:   mad r4.x, r5.w, r5.x, r4.x
 198:   mad r4.x, cb5[r1.w + 2].y, r5.y, r4.x
 199:   ge r4.zw, r2.wwww, l(0.000000, 0.000000, 0.000000, 1.000000)
 200:   and r2.w, r4.z, l(1.000000)
 201:   movc r2.w, r4.w, l(0), r2.w
 202:   mad r3.y, r4.x, r2.w, r3.y
 203:   add r3.w, r2.w, r3.w
 204:   mov r1.w, r4.y
 205: endloop
 206: ge r0.x, l(0), r3.w
 207: movc r0.x, r0.x, l(0), l(1.000000)
 208: ge r0.y, g_Key[0].x, r1.y
 209: and r0.y, r0.y, l(1.000000)
 210: mul r0.y, r0.y, g_Key[0].y
 211: ge r1.y, r1.y, g_Key[2].x
 212: and r1.y, r1.y, l(1.000000)
 213: mad r0.x, r0.x, r3.y, r0.y
 214: mad r0.x, r1.y, g_Key[2].y, r0.x
 215: mul_sat r0.x, r0.x, g_Color.w
 216: mad r4.xyz, g_Color.xyzx, g_Intensity.xxxx, -r2.xyzx
 217: mad o0.xyz, r0.xxxx, r4.xyzx, r2.xyzx
 218: mad r3.z, -r0.w, l(0.500000), l(1.000000)
 219: mad r1.z, -r0.z, l(0.500000), l(1.000000)
 220: add o1.xy, r1.xzxx, -r3.xzxx
 221: ret
