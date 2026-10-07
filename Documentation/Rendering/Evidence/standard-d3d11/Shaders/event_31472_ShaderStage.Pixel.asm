Shader hash 4f9bf8af-fdf3f40b-81c9a437-bf493526

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_resource_texture2d (float,float,float,float) VelocityTexture (t0)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_output o0.xyzw
      dcl_temps 4
   0: mov r0.zw, l(0, 0, 0, 0)
   1: ftoi r1.xy, v0.xyxx
   2: iadd r2.xyzw, r1.xyxy, l(-1, -1, 0, -1)
   3: mov r0.xy, r2.zwzz
   4: ld_indexable(texture2d)(float,float,float,float) r0.xy, r0.xyzw, VelocityTexture.xyzw
   5: dp2 r0.z, r0.xyxx, r0.xyxx
   6: mul r0.xy, r0.zzzz, r0.xyxx
   7: mov r2.zw, l(0, 0, 0, 0)
   8: ld_indexable(texture2d)(float,float,float,float) r2.xy, r2.xyzw, VelocityTexture.xyzw
   9: dp2 r0.w, r2.xyxx, r2.xyxx
  10: mad r0.xy, r2.xyxx, r0.wwww, r0.xyxx
  11: add r0.z, r0.z, r0.w
  12: mov r2.zw, l(0, 0, 0, 0)
  13: iadd r3.xyzw, r1.xyxy, l(-1, 0, 1, -1)
  14: mov r2.xy, r3.zwzz
  15: ld_indexable(texture2d)(float,float,float,float) r2.xy, r2.xyzw, VelocityTexture.xyzw
  16: dp2 r0.w, r2.xyxx, r2.xyxx
  17: mad r0.xy, r2.xyxx, r0.wwww, r0.xyxx
  18: add r0.z, r0.w, r0.z
  19: mov r3.zw, l(0, 0, 0, 0)
  20: ld_indexable(texture2d)(float,float,float,float) r2.xy, r3.xyzw, VelocityTexture.xyzw
  21: dp2 r0.w, r2.xyxx, r2.xyxx
  22: mad r0.xy, r2.xyxx, r0.wwww, r0.xyxx
  23: add r0.z, r0.w, r0.z
  24: mov r1.zw, l(0, 0, 0, 0)
  25: ld_indexable(texture2d)(float,float,float,float) r1.zw, r1.xyzw, VelocityTexture.zwxy
  26: dp2 r0.w, r1.zwzz, r1.zwzz
  27: mad r0.xy, r1.zwzz, r0.wwww, r0.xyxx
  28: add r0.z, r0.w, r0.z
  29: iadd r2.xyzw, r1.xyxy, l(-1, 1, 1, 0)
  30: iadd r1.xyzw, r1.xyxy, l(1, 1, 0, 1)
  31: mov r3.xy, r2.zwzz
  32: mov r3.zw, l(0, 0, 0, 0)
  33: ld_indexable(texture2d)(float,float,float,float) r3.xy, r3.xyzw, VelocityTexture.xyzw
  34: dp2 r0.w, r3.xyxx, r3.xyxx
  35: mad r0.xy, r3.xyxx, r0.wwww, r0.xyxx
  36: add r0.z, r0.w, r0.z
  37: mov r2.zw, l(0, 0, 0, 0)
  38: ld_indexable(texture2d)(float,float,float,float) r2.xy, r2.xyzw, VelocityTexture.xyzw
  39: dp2 r0.w, r2.xyxx, r2.xyxx
  40: mad r0.xy, r2.xyxx, r0.wwww, r0.xyxx
  41: add r0.z, r0.w, r0.z
  42: mov r2.xy, r1.zwzz
  43: mov r2.zw, l(0, 0, 0, 0)
  44: ld_indexable(texture2d)(float,float,float,float) r2.xy, r2.xyzw, VelocityTexture.xyzw
  45: dp2 r0.w, r2.xyxx, r2.xyxx
  46: mad r0.xy, r2.xyxx, r0.wwww, r0.xyxx
  47: add r0.z, r0.w, r0.z
  48: mov r1.zw, l(0, 0, 0, 0)
  49: ld_indexable(texture2d)(float,float,float,float) r1.xy, r1.xyzw, VelocityTexture.xyzw
  50: dp2 r0.w, r1.xyxx, r1.xyxx
  51: mad r0.xy, r1.xyxx, r0.wwww, r0.xyxx
  52: add r0.z, r0.w, r0.z
  53: add r0.z, r0.z, l(0.000000)
  54: div o0.xy, r0.xyxx, r0.zzzz
  55: mov o0.zw, l(0.000000, 0.000000, 0.000000, 1.000000)
  56: ret
