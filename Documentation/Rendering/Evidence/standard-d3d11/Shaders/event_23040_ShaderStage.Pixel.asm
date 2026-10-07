Shader hash 11ecdb81-d12e8033-4af7428d-49864ffe

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb5[5] (ShaderParams), dynamicIndexed
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer00 (t20)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_output o0.xyzw
      dcl_temps 4
   0: ftoi r0.xy, v0.xyxx
   1: mov r0.zw, l(0, 0, 0, 0)
   2: ld_indexable(texture2d)(float,float,float,float) r1.x, r0.xyww, g_GeometryBuffer00.wxyz
   3: ld_indexable(texture2d)(float,float,float,float) r0.x, r0.xyzw, g_ZBuffer.xyzw
   4: mul r0.y, r1.x, l(255.000000)
   5: round_ne r0.y, r0.y
   6: ftou r0.y, r0.y
   7: mul o0.xyz, g_Intensity.xxxx, g_Color.xyzx
   8: mov r0.zw, l(0, 0, 0, 0)
   9: mov r1.x, l(1)
  10: loop
  11:   ige r1.y, r1.x, l(3)
  12:   breakc_nz r1.y
  13:   iadd r1.yz, r1.xxxx, l(0, -1, 1, 0)
  14:   add r1.w, r0.x, -cb5[r1.y + 2].x
  15:   add r2.x, -cb5[r1.y + 2].x, cb5[r1.x + 2].x
  16:   div r1.w, r1.w, r2.x
  17:   add r2.x, -r1.w, l(1.000000)
  18:   mul r2.y, r2.x, r2.x
  19:   mul r2.y, r2.x, r2.y
  20:   mul r2.z, r2.x, l(3.000000)
  21:   mul r2.x, r2.x, r2.z
  22:   mul r2.w, r1.w, r1.w
  23:   mul r2.z, r2.z, r2.w
  24:   mul r2.xw, r1.wwww, r2.xxxw
  25:   add r3.x, cb5[r1.y + 2].w, cb5[r1.y + 2].y
  26:   add r3.y, cb5[r1.x + 2].z, cb5[r1.x + 2].y
  27:   mul r2.x, r2.x, r3.x
  28:   mad r1.y, cb5[r1.y + 2].y, r2.y, r2.x
  29:   mad r1.y, r3.y, r2.z, r1.y
  30:   mad r1.y, cb5[r1.x + 2].y, r2.w, r1.y
  31:   ge r2.xy, r1.wwww, l(0.000000, 1.000000, 0.000000, 0.000000)
  32:   and r1.w, r2.x, l(1.000000)
  33:   movc r1.w, r2.y, l(0), r1.w
  34:   mad r0.z, r1.y, r1.w, r0.z
  35:   add r0.w, r0.w, r1.w
  36:   mov r1.x, r1.z
  37: endloop
  38: ge r0.w, l(0), r0.w
  39: movc r0.w, r0.w, l(0), l(1.000000)
  40: ge r1.x, g_Key[0].x, r0.x
  41: and r1.x, r1.x, l(1.000000)
  42: mul r1.x, r1.x, g_Key[0].y
  43: ge r0.x, r0.x, g_Key[2].x
  44: and r0.xy, r0.xyxx, l(1.000000, 0.000000, 0.000000, 0.000000)
  45: mad r0.z, r0.w, r0.z, r1.x
  46: mad r0.x, r0.x, g_Key[2].y, r0.z
  47: mul_sat r0.x, r0.x, g_Color.w
  48: mul r0.z, r0.x, g_EmissiveIntensity.x
  49: movc o0.w, r0.y, r0.z, r0.x
  50: ret
