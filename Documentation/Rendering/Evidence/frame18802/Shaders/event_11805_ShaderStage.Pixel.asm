Shader hash 583325ca-8ed33b13-9ffbf1a5-ec576d2d

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_sampler g_DiffuseLocalIBLSampler (s6), mode_default
      dcl_sampler g_SpecularLocalIBLSampler (s7), mode_default
      dcl_sampler AmbientAreaLightSampler (s11), mode_default
      dcl_resource_texture2d (float,float,float,float) g_DiffuseLocalIBL (t6)
      dcl_resource_texture2d (float,float,float,float) g_SpecularLocalIBL (t7)
      dcl_resource_texture2d (float,float,float,float) g_DiffuseAmbientAreaLight (t29)
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_temps 3
   0: sample_indexable(texture2d)(float,float,float,float) r0.xyz, v1.xyxx, g_SpecularLocalIBL.xyzw, g_SpecularLocalIBLSampler
   1: sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v1.xyxx, g_DiffuseAmbientAreaLight.xyzw, AmbientAreaLightSampler
   2: ge r0.w, r1.w, l(16.000000)
   3: add r2.x, r1.w, l(-16.000000)
   4: movc r1.w, r0.w, r2.x, r1.w
   5: lt r2.x, r1.w, l(1.000000)
   6: if_nz r2.x
   7:   sample_indexable(texture2d)(float,float,float,float) r2.xyz, v1.xyxx, g_DiffuseLocalIBL.xyzw, g_DiffuseLocalIBLSampler
   8:   frc r1.w, r1.w
   9:   add r1.w, -r1.w, l(1.000000)
  10:   mad r1.xyz, r2.xyzx, r1.wwww, r1.xyzx
  11: else
  12:   mov r1.w, l(0)
  13: endif
  14: movc r0.w, r0.w, l(1.000000), r1.w
  15: mad o0.xyz, r0.xyzx, r0.wwww, r1.xyzx
  16: mov o0.w, l(1.000000)
  17: ret
