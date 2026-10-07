Shader hash d1d6e2b9-399e05c6-e0f91094-1e3d7300

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_sampler CurrentTextureSampler (s0), mode_default
      dcl_sampler HistoryTextureSampler (s1), mode_default
      dcl_resource_texture2d (float,float,float,float) CurrentTexture (t0)
      dcl_resource_texture2d (float,float,float,float) HistoryTexture (t1)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer03 (t23)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_temps 8
   0: sample_indexable(texture2d)(float,float,float,float) r0.xyzw, v1.xyxx, CurrentTexture.xyzw, CurrentTextureSampler
   1: add r1.xyz, r0.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
   2: div_sat r1.xyz, r0.xyzx, r1.xyzx
   3: dp3 r2.x, l(0.250000, 0.500000, 0.250000, 0.000000), r1.xyzx
   4: lt r1.w, r2.x, l(0.100000)
   5: if_nz r1.w
   6:   mov o0.xyzw, r0.xyzw
   7:   ret
   8: endif
   9: dp2 r2.y, l(0.500000, -0.500000, 0.000000, 0.000000), r1.xzxx
  10: dp3 r2.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r1.xyzx
  11: ftoi r1.xyzw, v0.xyxy
  12: round_z r0.xy, v0.xyxx
  13: ftoi r3.xy, r0.xyxx
  14: mov r3.zw, l(0, 0, 0, 0)
  15: ld_indexable(texture2d)(float,float,float,float) r0.xy, r3.xyzw, g_GeometryBuffer03.xyzw
  16: add r3.xy, -r0.xyxx, v1.xyxx
  17: sample_indexable(texture2d)(float,float,float,float) r3.xyz, r3.xyxx, HistoryTexture.xyzw, HistoryTextureSampler
  18: add r4.xyz, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  19: div_sat r3.xyz, r3.xyzx, r4.xyzx
  20: dp3 r4.x, l(0.250000, 0.500000, 0.250000, 0.000000), r3.xyzx
  21: dp2 r4.y, l(0.500000, -0.500000, 0.000000, 0.000000), r3.xzxx
  22: dp3 r4.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r3.xyzx
  23: eq r3.xyz, r4.xyzx, l(0, 0, 0, 0)
  24: and r0.z, r3.y, r3.x
  25: and r0.z, r3.z, r0.z
  26: movc r3.xyz, r0.zzzz, r2.xyzx, r4.xyzx
  27: iadd r4.xyzw, r1.zwzw, l(-1, 0, 0, -1)
  28: mov r5.xy, r4.zwzz
  29: mov r5.zw, l(0, 0, 0, 0)
  30: ld_indexable(texture2d)(float,float,float,float) r5.xyz, r5.xyzw, CurrentTexture.xyzw
  31: mov r4.zw, l(0, 0, 0, 0)
  32: ld_indexable(texture2d)(float,float,float,float) r4.xyz, r4.xyzw, CurrentTexture.xyzw
  33: iadd r1.xyzw, r1.zwxy, l(0, 1, 1, 0)
  34: mov r6.xy, r1.zwzz
  35: mov r6.zw, l(0, 0, 0, 0)
  36: ld_indexable(texture2d)(float,float,float,float) r6.xyz, r6.xyzw, CurrentTexture.xyzw
  37: mov r1.zw, l(0, 0, 0, 0)
  38: ld_indexable(texture2d)(float,float,float,float) r1.xyz, r1.xyzw, CurrentTexture.xyzw
  39: add r7.xyz, r5.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  40: div_sat r5.xyz, r5.xyzx, r7.xyzx
  41: add r7.xyz, r4.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  42: div_sat r4.xyz, r4.xyzx, r7.xyzx
  43: add r7.xyz, r6.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  44: div_sat r6.xyz, r6.xyzx, r7.xyzx
  45: add r7.xyz, r1.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  46: div_sat r1.xyz, r1.xyzx, r7.xyzx
  47: dp3 r7.x, l(0.250000, 0.500000, 0.250000, 0.000000), r5.xyzx
  48: dp2 r7.y, l(0.500000, -0.500000, 0.000000, 0.000000), r5.xzxx
  49: dp3 r7.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r5.xyzx
  50: dp3 r5.x, l(0.250000, 0.500000, 0.250000, 0.000000), r4.xyzx
  51: dp2 r5.y, l(0.500000, -0.500000, 0.000000, 0.000000), r4.xzxx
  52: dp3 r5.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r4.xyzx
  53: dp3 r4.x, l(0.250000, 0.500000, 0.250000, 0.000000), r6.xyzx
  54: dp2 r4.y, l(0.500000, -0.500000, 0.000000, 0.000000), r6.xzxx
  55: dp3 r4.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r6.xyzx
  56: dp3 r6.x, l(0.250000, 0.500000, 0.250000, 0.000000), r1.xyzx
  57: dp2 r6.y, l(0.500000, -0.500000, 0.000000, 0.000000), r1.xzxx
  58: dp3 r6.z, l(-0.250000, 0.500000, -0.250000, 0.000000), r1.xyzx
  59: add r1.xyz, r2.xyzx, r7.xyzx
  60: mul r7.xyz, r7.xyzx, r7.xyzx
  61: mad r7.xyz, r2.xyzx, r2.xyzx, r7.xyzx
  62: add r1.xyz, r5.xyzx, r1.xyzx
  63: mad r5.xyz, r5.xyzx, r5.xyzx, r7.xyzx
  64: add r1.xyz, r4.xyzx, r1.xyzx
  65: mad r4.xyz, r4.xyzx, r4.xyzx, r5.xyzx
  66: add r1.xyz, r6.xyzx, r1.xyzx
  67: mad r4.xyz, r6.xyzx, r6.xyzx, r4.xyzx
  68: mul r5.xyz, r1.xyzx, l(0.200000, 0.200000, 0.200000, 0.000000)
  69: dp2 r0.x, r0.xyxx, r0.xyxx
  70: sqrt r0.x, r0.x
  71: min r0.x, r0.x, l(1.000000)
  72: mad r0.x, r0.x, l(-0.850000), l(0.850000)
  73: mul r5.xyz, r5.xyzx, r5.xyzx
  74: mad r4.xyz, r4.xyzx, l(0.200000, 0.200000, 0.200000, 0.000000), -r5.xyzx
  75: max r4.xyz, r4.xyzx, l(0, 0, 0, 0)
  76: sqrt r4.xyz, r4.xyzx
  77: mul r0.xyz, r0.xxxx, r4.xyzx
  78: mad r4.xyz, r1.xyzx, l(0.200000, 0.200000, 0.200000, 0.000000), -r0.xyzx
  79: mad r0.xyz, r1.xyzx, l(0.200000, 0.200000, 0.200000, 0.000000), r0.xyzx
  80: max r1.xyz, r3.xyzx, r4.xyzx
  81: min r0.xyz, r0.xyzx, r1.xyzx
  82: add r0.xyz, -r2.xyzx, r0.xyzx
  83: mad r0.xyz, r0.xyzx, l(0.980000, 0.980000, 0.980000, 0.000000), r2.xyzx
  84: dp3_sat r1.x, l(1.000000, 1.000000, -1.000000, 0.000000), r0.xyzx
  85: dp2_sat r1.y, l(1.000000, 1.000000, 0.000000, 0.000000), r0.xzxx
  86: dp3_sat r1.z, l(1.000000, -1.000000, -1.000000, 0.000000), r0.xyzx
  87: add r0.xyz, -r1.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  88: max r0.xyz, r0.xyzx, l(0.000010, 0.000010, 0.000010, 0.000000)
  89: div o0.xyz, r1.xyzx, r0.xyzx
  90: mov o0.w, r0.w
  91: ret
