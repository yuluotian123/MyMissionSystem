Shader hash 22fa2779-eac005a4-8137bfb1-a52c9b35

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb12[1] (HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb10[2] (ParamBuffer), immediateIndexed
      dcl_resource_texture2d (float,float,float,float) ColorTexture (t0)
      dcl_resource_texture2d (float,float,float,float) DenoisedColorTexture (t1)
      dcl_resource_texture2d (float,float,float,float) TiledVelocityTexture (t4)
      dcl_resource_texture2d (float,float,float,float) DepthVelocityTexture (t5)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_output o0.xyzw
      dcl_temps 8
   0: ftoi r0.xy, v0.xyxx
   1: rcp r1.x, g_TargetUvParam.w
   2: ishr r2.xy, r0.xyxx, l(3, 3, 0, 0)
   3: mov r2.zw, l(0, 0, 0, 0)
   4: ld_indexable(texture2d)(float,float,float,float) r1.yz, r2.xyzw, TiledVelocityTexture.zxyw
   5: dp2 r1.w, r1.yzyy, r1.yzyy
   6: lt r2.x, l(0.000100), r1.w
   7: if_nz r2.x
   8:   mov r0.z, l(0)
   9:   ld_indexable(texture2d)(float,float,float,float) r2.xyzw, r0.xyzz, DenoisedColorTexture.xyzw
  10: else
  11:   mov r0.w, l(0)
  12:   ld_indexable(texture2d)(float,float,float,float) r2.xyzw, r0.xyww, ColorTexture.xyzw
  13: endif
  14: mul r1.x, r1.x, r1.x
  15: lt r1.x, r1.w, r1.x
  16: if_nz r1.x
  17:   mov o0.xyzw, r2.xyzw
  18:   ret
  19: endif
  20: div r3.xy, v0.xyxx, g_TargetUvParam.zwzz
  21: mov r0.zw, l(0, 0, 0, 0)
  22: ld_indexable(texture2d)(float,float,float,float) r0.xy, r0.xyzw, DepthVelocityTexture.xyzw
  23: mul r0.zw, r0.xxxy, l(0.000000, 0.000000, 1.000000, 0.015625)
  24: mul r0.w, r0.w, r0.w
  25: mad r0.y, r0.y, l(0.015625), l(0.000000)
  26: div r0.y, l(1.000000, 1.000000, 1.000000, 1.000000), r0.y
  27: mov_sat r0.y, r0.y
  28: mul r2.xyz, r0.yyyy, r2.xyzx
  29: lt r1.x, l(1.500000), samplingStride_.x
  30: movc r1.x, r1.x, l(0.300000), l(0.170000)
  31: mul r1.x, r1.x, blurSize_.x
  32: add r1.w, r1.w, l(0.000000)
  33: sqrt r1.w, r1.w
  34: dp2 r2.w, r3.xyxx, l(12.989800, 78.233002, 0.000000, 0.000000)
  35: sincos r2.w, null, r2.w
  36: mul r2.w, r2.w, l(43758.546875)
  37: frc r2.w, r2.w
  38: add r2.w, r2.w, l(-0.500000)
  39: mul r2.w, r1.w, r2.w
  40: mad r1.w, r1.w, l(96.000000), l(2.500000)
  41: min r1.w, r1.w, l(9.000000)
  42: ftoi r1.w, r1.w
  43: or r3.z, r1.w, l(1)
  44: ishr r1.w, r1.w, l(1)
  45: itof r3.w, r3.z
  46: div r3.w, l(1.000000, 1.000000, 1.000000, 1.000000), r3.w
  47: mul r4.x, r0.w, l(0.100000)
  48: div r4.x, l(1.000000, 1.000000, 1.000000, 1.000000), r4.x
  49: mov r5.zw, l(0, 0, 0, 0)
  50: mov r4.yzw, r2.xxyz
  51: mov r6.x, r0.y
  52: mov r6.y, l(0)
  53: loop
  54:   ige r6.z, r6.y, r3.z
  55:   breakc_nz r6.z
  56:   iadd r6.z, -r1.w, r6.y
  57:   if_z r6.z
  58:     iadd r6.w, r6.y, l(1)
  59:     mov r6.y, r6.w
  60:     continue
  61:   endif
  62:   itof r6.z, r6.z
  63:   mad r6.z, r2.w, l(4.000000), r6.z
  64:   mul r6.z, r3.w, r6.z
  65:   mul r6.z, r1.x, r6.z
  66:   mad r6.zw, r1.yyyz, r6.zzzz, r3.xxxy
  67:   mov_sat r7.xy, r6.zwzz
  68:   mul r7.xy, r7.xyxx, g_TargetUvParam.zwzz
  69:   ftoi r5.xy, r7.xyxx
  70:   ld_indexable(texture2d)(float,float,float,float) r7.xy, r5.xyww, DepthVelocityTexture.xyzw
  71:   mul r7.yz, r7.xxyx, l(0.000000, 1.000000, 0.015625, 0.000000)
  72:   mul r7.z, r7.z, r7.z
  73:   add r6.zw, r3.xxxy, -r6.zzzw
  74:   dp2 r6.z, r6.zwzz, r6.zwzz
  75:   mad r6.w, r7.x, l(1.000000), -r0.z
  76:   mad_sat r6.w, -r6.w, l(100.000000), l(1.000000)
  77:   div r7.x, r6.z, r7.z
  78:   add r7.x, -r7.x, l(1.000000)
  79:   mad r7.y, r0.x, l(1.000000), -r7.y
  80:   mad_sat r7.y, -r7.y, l(100.000000), l(1.000000)
  81:   add r7.w, r6.z, l(0.000500)
  82:   div r7.w, r7.w, r0.w
  83:   add r7.w, -r7.w, l(1.000000)
  84:   max r7.xw, r7.xxxw, l(0, 0, 0, 0)
  85:   mul r7.y, r7.w, r7.y
  86:   mad r6.w, r6.w, r7.x, r7.y
  87:   mul r7.x, r7.z, l(0.100000)
  88:   mad r7.y, -r7.z, l(0.950000), r6.z
  89:   div r7.x, l(1.000000, 1.000000, 1.000000, 1.000000), r7.x
  90:   mul_sat r7.x, r7.x, r7.y
  91:   mad r7.y, r7.x, l(-2.000000), l(3.000000)
  92:   mul r7.x, r7.x, r7.x
  93:   mad r7.x, -r7.y, r7.x, l(1.000000)
  94:   max r7.x, r7.x, l(0)
  95:   mad r6.z, -r0.w, l(0.950000), r6.z
  96:   mul_sat r6.z, r4.x, r6.z
  97:   mad r7.y, r6.z, l(-2.000000), l(3.000000)
  98:   mul r6.z, r6.z, r6.z
  99:   mad r6.z, -r7.y, r6.z, l(1.000000)
 100:   max r6.z, r6.z, l(0)
 101:   dp2 r6.z, r7.xxxx, r6.zzzz
 102:   add r6.z, r6.z, r6.w
 103:   min r6.z, r6.z, l(1.000000)
 104:   ld_indexable(texture2d)(float,float,float,float) r7.xyz, r5.xyzw, DenoisedColorTexture.xyzw
 105:   mad r4.yzw, r7.xxyz, r6.zzzz, r4.yyzw
 106:   add r6.x, r6.z, r6.x
 107:   iadd r6.y, r6.y, l(1)
 108: endloop
 109: div o0.xyz, r4.yzwy, r6.xxxx
 110: mov o0.w, l(1.000000)
 111: ret
