Shader hash 175f4f75-2316407a-919c00b6-b5e4f323

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_sampler g_TextureAdaptLumminanceSampler (s2), mode_default
      dcl_sampler g_TextureBloomSampler (s3), mode_default
      dcl_sampler g_TextureSceneColorHDRSampler (s4), mode_default
      dcl_resource_texture2d (float,float,float,float) g_TextureAdaptLumminance (t2)
      dcl_resource_texture2d (float,float,float,float) g_TextureBloom (t3)
      dcl_resource_texture2d (float,float,float,float) g_TextureSceneColorHDR (t4)
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_temps 3
   0: sample_indexable(texture2d)(float,float,float,float) r0.xyz, v1.xyxx, g_TextureSceneColorHDR.xyzw, g_TextureSceneColorHDRSampler
   1: and r1.xyz, r0.xyzx, l(0x7f800000, 0x7f800000, 0x7f800000, 0)
   2: ieq r1.xyz, r1.xyzx, l(0x7f800000, 0x7f800000, 0x7f800000, 0)
   3: or r0.w, r1.y, r1.x
   4: or r0.w, r1.z, r0.w
   5: movc r0.xyz, r0.wwww, l(1000000.000000, 1000000.000000, 1000000.000000, 0.000000), r0.xyzx
   6: sample_indexable(texture2d)(float,float,float,float) r0.w, l(0.500000, 0.500000, 0.000000, 0.000000), g_TextureAdaptLumminance.yzwx, g_TextureAdaptLumminanceSampler
   7: mul r0.xyz, r0.xyzx, r0.wwww
   8: mad r1.xyz, r0.xyzx, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.050000, 0.050000, 0.050000, 0.000000)
   9: mad r1.xyz, r0.xyzx, r1.xyzx, l(0.004000, 0.004000, 0.004000, 0.000000)
  10: mad r2.xyz, r0.xyzx, l(0.150000, 0.150000, 0.150000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
  11: mad r0.xyz, r0.xyzx, r2.xyzx, l(0.060000, 0.060000, 0.060000, 0.000000)
  12: div r0.xyz, r1.xyzx, r0.xyzx
  13: add r0.xyz, r0.xyzx, l(-0.066667, -0.066667, -0.066667, 0.000000)
  14: sample_indexable(texture2d)(float,float,float,float) r1.xyz, v1.xyxx, g_TextureBloom.xyzw, g_TextureBloomSampler
  15: mad_sat r0.xyz, r0.xyzx, l(1.379064, 1.379064, 1.379064, 0.000000), r1.xyzx
  16: log r1.xyz, r0.xyzx
  17: mul r1.xyz, r1.xyzx, l(0.416667, 0.416667, 0.416667, 0.000000)
  18: exp r1.xyz, r1.xyzx
  19: mad r1.xyz, r1.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
  20: ge r2.xyz, l(0.003131, 0.003131, 0.003131, 0.000000), r0.xyzx
  21: mul r0.xyz, r0.xyzx, l(12.920000, 12.920000, 12.920000, 0.000000)
  22: movc o0.xyz, r2.xyzx, r0.xyzx, r1.xyzx
  23: mov o0.w, l(1.000000)
  24: ret
