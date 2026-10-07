Shader hash 770c06a9-0d7dbe4b-f6d0dce2-ceebf532

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb12[1] (HPixel_Buffer), immediateIndexed
      dcl_sampler LinearClamp (s3), mode_default
      dcl_resource_texture2d (float,float,float,float) g_ColorTexture (t3)
      dcl_resource_texture2d (float,float,float,float) g_OldColorTexture (t4)
      dcl_resource_texture2d (float,float,float,float) g_ZTexture (t5)
      dcl_resource_texture2d (float,float,float,float) g_PrevZTexture (t6)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer03 (t23)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_output o1.xyzw
      dcl_temps 10
   0: gather4(-1,-1,0)(texture2d)(float,float,float,float) r0.xyzw, v1.xyxx, g_ZTexture.xyzw, LinearClamp.x
   1: gather4(0,-1,0)(texture2d)(float,float,float,float) r1.xz, v1.xyxx, g_ZTexture.zxyw, LinearClamp.x
   2: gather4(-1,0,0)(texture2d)(float,float,float,float) r2.xy, v1.xyxx, g_ZTexture.xyzw, LinearClamp.x
   3: gather4(texture2d)(float,float,float,float) r3.xyzw, v1.xyxx, g_ZTexture.xyzw, LinearClamp.x
   4: ge r1.w, l(1.000000), r0.w
   5: if_nz r1.w
   6:   mov r4.x, r0.w
   7: else
   8:   mov r4.x, l(1.000000)
   9: endif
  10: ge r0.w, r4.x, r0.z
  11: if_nz r0.w
  12:   mov r4.x, r0.z
  13:   mov r4.y, l(1)
  14: else
  15:   mov r4.y, l(0)
  16: endif
  17: lt r0.z, r4.x, r1.x
  18: movc r1.y, r0.z, l(3), l(2)
  19: movc r4.xy, r0.zzzz, r4.xyxx, r1.xyxx
  20: ge r0.z, r4.x, r0.x
  21: if_nz r0.z
  22:   mov r4.yz, l(0, 0, 1, 0)
  23:   mov r4.x, r0.x
  24: else
  25:   mov r4.z, l(0)
  26: endif
  27: ge r0.x, r4.x, r0.y
  28: if_nz r0.x
  29:   mov r4.yz, l(0, 1, 1, 0)
  30:   mov r4.x, r0.y
  31: endif
  32: lt r0.x, r4.x, r1.z
  33: movc r1.y, r0.x, l(3), l(2)
  34: mov r1.x, l(1)
  35: movc r0.xyz, r0.xxxx, r4.yzxy, r1.yxzy
  36: ge r0.w, r0.z, r2.x
  37: if_nz r0.w
  38:   mov r0.xy, l(0, 2, 0, 0)
  39:   mov r0.z, r2.x
  40: endif
  41: ge r0.w, r0.z, r2.y
  42: if_nz r0.w
  43:   mov r0.xy, l(1, 2, 0, 0)
  44:   mov r0.z, r2.y
  45: endif
  46: lt r0.z, r0.z, r3.y
  47: movc r1.x, r0.z, l(3), l(2)
  48: mov r1.yzw, l(0, 2, 0, 0)
  49: movc r0.xy, r0.zzzz, r0.xyxx, r1.xyxx
  50: iadd r0.xy, r0.xyxx, l(-1, -1, 0, 0)
  51: itof r0.xy, r0.xyxx
  52: add r0.xy, r0.xyxx, v0.xyxx
  53: ftoi r0.xy, r0.xyxx
  54: mov r0.zw, l(0, 0, 0, 0)
  55: ld_indexable(texture2d)(float,float,float,float) r0.xy, r0.xyzw, g_GeometryBuffer03.xyzw
  56: add r0.zw, -r0.xxxy, v1.xxxy
  57: ftoi r1.xy, v0.xyxx
  58: ld_indexable(texture2d)(float,float,float,float) r1.xyz, r1.xyzw, g_ColorTexture.xyzw
  59: div r2.xy, l(1.000000, 1.000000, 1.000000, 1.000000), g_TargetUvParam.zwzz
  60: mad r2.zw, r0.zzzw, g_TargetUvParam.zzzw, l(0.000000, 0.000000, -0.500000, -0.500000)
  61: round_ni r2.zw, r2.zzzw
  62: add r4.xyzw, r2.zwzw, l(0.500000, 0.500000, -0.500000, -0.500000)
  63: mad r5.xy, r0.zwzz, g_TargetUvParam.zwzz, -r4.xyxx
  64: mul r5.zw, r5.xxxy, r5.xxxy
  65: mul r6.xy, r5.zwzz, r5.xyxx
  66: add r6.zw, r5.wwwz, r5.wwwz
  67: mad r7.xy, -r5.yxyy, r5.wzww, r6.zwzz
  68: add r7.xy, -r5.yxyy, r7.xyxx
  69: mad r6.zw, r5.yyyx, r5.wwwz, -r6.zzzw
  70: add r6.zw, r6.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
  71: mad r6.xy, r5.xyxx, r5.xyxx, -r6.xyxx
  72: add r6.xy, r5.xyxx, r6.xyxx
  73: mad r5.xy, r5.xyxx, r5.zwzz, -r5.zwzz
  74: add r5.zw, r6.yyyx, r6.zzzw
  75: div r6.xy, r6.xyxx, r5.wzww
  76: add r4.xy, r4.xyxx, r6.xyxx
  77: mul r6.xy, r2.xyxx, r4.xyxx
  78: sample_indexable(texture2d)(float,float,float,float) r8.xyz, r6.xyxx, g_OldColorTexture.xyzw, LinearClamp
  79: mul r6.zw, r2.xxxy, r4.zzzw
  80: add r2.zw, r2.zzzw, l(0.000000, 0.000000, 2.500000, 2.500000)
  81: mul r2.xy, r2.zwzz, r2.xyxx
  82: sample_indexable(texture2d)(float,float,float,float) r4.xyz, r6.xwxx, g_OldColorTexture.xyzw, LinearClamp
  83: mul r7.xy, r7.xyxx, r5.wzww
  84: mov r4.w, l(1.000000)
  85: sample_indexable(texture2d)(float,float,float,float) r9.xyz, r6.zyzz, g_OldColorTexture.xyzw, LinearClamp
  86: mov r9.w, l(1.000000)
  87: mul r9.xyzw, r7.yyyy, r9.xyzw
  88: mad r4.xyzw, r4.xyzw, r7.xxxx, r9.xyzw
  89: mul r1.w, r5.z, r5.w
  90: mov r8.w, l(1.000000)
  91: mad r4.xyzw, r8.xyzw, r1.wwww, r4.xyzw
  92: mov r2.zw, r6.yyyx
  93: sample_indexable(texture2d)(float,float,float,float) r6.xyz, r2.xzxx, g_OldColorTexture.xyzw, LinearClamp
  94: mul r2.xz, r5.zzwz, r5.xxyx
  95: mov r6.w, l(1.000000)
  96: mad r4.xyzw, r6.xyzw, r2.xxxx, r4.xyzw
  97: sample_indexable(texture2d)(float,float,float,float) r5.xyz, r2.wyww, g_OldColorTexture.xyzw, LinearClamp
  98: mov r5.w, l(1.000000)
  99: mad r2.xyzw, r5.xyzw, r2.zzzz, r4.xyzw
 100: rcp r1.w, r2.w
 101: mul_sat r2.xyz, r1.wwww, r2.xyzx
 102: mov_sat r1.xyz, r1.xyzx
 103: dp3 r4.x, l(0.250000, 0.500000, 0.250000, 0.000000), r1.xyzx
 104: dp2 r4.y, l(0.500000, -0.500000, 0.000000, 0.000000), r1.xzxx
 105: dp3 r4.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r1.xyzx
 106: dp3 r1.x, l(0.250000, 0.500000, 0.250000, 0.000000), r2.xyzx
 107: dp2 r1.y, l(0.500000, -0.500000, 0.000000, 0.000000), r2.xzxx
 108: dp3 r1.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r2.xyzx
 109: sample_indexable(1,0,0)(texture2d)(float,float,float,float) r2.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 110: dp3 r5.x, l(0.250000, 0.500000, 0.250000, 0.000000), r2.xyzx
 111: dp2 r5.y, l(0.500000, -0.500000, 0.000000, 0.000000), r2.xzxx
 112: dp3 r5.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r2.xyzx
 113: add r2.xyz, r4.xyzx, r5.xyzx
 114: mul r5.xyz, r5.xyzx, r5.xyzx
 115: mad r5.xyz, r4.xyzx, r4.xyzx, r5.xyzx
 116: sample_indexable(0,-1,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 117: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 118: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 119: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 120: add r2.xyz, r2.xyzx, r7.xyzx
 121: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 122: sample_indexable(0,1,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 123: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 124: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 125: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 126: add r2.xyz, r2.xyzx, r7.xyzx
 127: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 128: sample_indexable(-1,0,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 129: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 130: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 131: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 132: add r2.xyz, r2.xyzx, r7.xyzx
 133: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 134: sample_indexable(-1,-1,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 135: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 136: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 137: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 138: add r2.xyz, r2.xyzx, r7.xyzx
 139: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 140: sample_indexable(-1,1,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 141: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 142: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 143: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 144: add r2.xyz, r2.xyzx, r7.xyzx
 145: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 146: sample_indexable(1,-1,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 147: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 148: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 149: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 150: add r2.xyz, r2.xyzx, r7.xyzx
 151: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 152: sample_indexable(1,1,0)(texture2d)(float,float,float,float) r6.xyz, v1.xyxx, g_ColorTexture.xyzw, LinearClamp
 153: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
 154: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
 155: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
 156: add r2.xyz, r2.xyzx, r7.xyzx
 157: mad r5.xyz, r7.xyzx, r7.xyzx, r5.xyzx
 158: mul r6.xyz, r2.xyzx, l(0.111111, 0.111111, 0.111111, 0.000000)
 159: dp2 r0.x, r0.xyxx, r0.xyxx
 160: sqrt r0.x, r0.x
 161: min r0.x, r0.x, l(1.000000)
 162: mad r0.y, r0.x, l(-0.850000), l(0.850000)
 163: mul r6.xyz, r6.xyzx, r6.xyzx
 164: mad r5.xyz, r5.xyzx, l(0.111111, 0.111111, 0.111111, 0.000000), -r6.xyzx
 165: max r5.xyz, r5.xyzx, l(0, 0, 0, 0)
 166: sqrt r5.xyz, r5.xyzx
 167: mul r5.xyz, r0.yyyy, r5.xyzx
 168: mad r6.xyz, r2.xyzx, l(0.111111, 0.111111, 0.111111, 0.000000), -r5.xyzx
 169: mad r2.xyz, r2.xyzx, l(0.111111, 0.111111, 0.111111, 0.000000), r5.xyzx
 170: max r1.xyz, r1.xyzx, r6.xyzx
 171: min r1.xyz, r2.xyzx, r1.xyzx
 172: mad r0.x, -r0.x, l(10.000000), l(1.000000)
 173: max r0.x, r0.x, l(0)
 174: min r2.xy, r3.ywyy, r3.xzxx
 175: min r0.y, r2.y, r2.x
 176: max r2.xy, r3.ywyy, r3.xzxx
 177: max r1.w, r2.y, r2.x
 178: add r1.w, -r0.y, r1.w
 179: lt r1.w, l(0.001000), abs(r1.w)
 180: gather4(texture2d)(float,float,float,float) r2.xyzw, r0.zwzz, g_PrevZTexture.xyzw, LinearClamp.x
 181: max r2.xy, r2.ywyy, r2.xzxx
 182: max r2.x, r2.y, r2.x
 183: add r2.x, r2.x, l(0.001000)
 184: ge r0.y, r2.x, r0.y
 185: or r0.y, r1.w, r0.y
 186: ge r2.xy, r0.zwzz, l(0, 0, 0, 0)
 187: and r1.w, r2.y, r2.x
 188: lt r0.zw, r0.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
 189: and r0.z, r0.w, r0.z
 190: and r0.z, r0.z, r1.w
 191: and r0.yz, r0.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
 192: mul r0.x, r0.y, r0.x
 193: mul r0.x, r0.z, r0.x
 194: mul r0.x, r0.x, l(0.925000)
 195: add r0.yzw, -r4.xxyz, r1.xxyz
 196: mad r0.xyz, r0.xxxx, r0.yzwy, r4.xyzx
 197: dp3 r1.x, l(1.000000, 1.000000, -1.000000, 0.000000), r0.xyzx
 198: dp2 r1.y, l(1.000000, 1.000000, 0.000000, 0.000000), r0.xzxx
 199: dp3 r1.z, l(1.000000, -1.000000, -1.000000, 0.000000), r0.xyzx
 200: mov r1.w, l(1.000000)
 201: mov o0.xyzw, r1.xyzw
 202: mov o1.xyzw, r1.xyzw
 203: ret
