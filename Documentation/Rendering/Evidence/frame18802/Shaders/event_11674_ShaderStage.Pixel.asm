Shader hash 487795b9-91adce8f-5455a2e9-597757b5

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb2[3] (LightCommonBuffer), immediateIndexed
      dcl_sampler g_ShadowTextureSampler (s2), mode_default
      dcl_sampler g_SubtractLightTextureSampler (s3), mode_default
      dcl_resource_texture2d (float,float,float,float) g_ShadowTexture (t2)
      dcl_resource_texture2d (float,float,float,float) g_SubtractLightTexture (t3)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer00 (t20)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer01 (t21)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer02 (t22)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_resource_texture2d (uint,uint,uint,uint) g_StencilBuffer (t25)
      dcl_input_ps_siv linear noperspective v0.xy, position
      dcl_input_ps linear v1.xy
      dcl_output o0.xyzw
      dcl_temps 6
   0: ftoi r0.xy, v0.xyxx
   1: mov r0.zw, l(0, 0, 0, 0)
   2: ld_indexable(texture2d)(float,float,float,float) r1.xyzw, r0.xyww, g_GeometryBuffer00.xyzw
   3: ld_indexable(texture2d)(uint,uint,uint,uint) r2.x, r0.xyww, g_StencilBuffer.yxzw
   4: and r2.xy, r2.xxxx, l(15, 128, 0, 0)
   5: movc r2.y, r2.y, l(9), l(0)
   6: iadd r2.x, r2.y, r2.x
   7: mul r1.w, r1.w, l(255.000000)
   8: round_ne r1.w, r1.w
   9: ftou r1.w, r1.w
  10: and r2.y, r1.w, l(32)
  11: movc r2.y, r2.y, l(1.000000), l(0)
  12: ishl r2.z, l(1), r2.x
  13: ftou r2.w, g_LightParam1.z
  14: and r2.w, r2.w, r2.z
  15: ine r2.z, r2.z, r2.w
  16: if_nz r2.z
  17:   mov o0.xyz, l(0, 0, 0, 0)
  18:   mov o0.w, r2.y
  19:   ret
  20: endif
  21: ld_indexable(texture2d)(float,float,float,float) r2.zw, r0.xyww, g_GeometryBuffer01.zwxy
  22: ld_indexable(texture2d)(float,float,float,float) r3.xyz, r0.xyww, g_GeometryBuffer02.xyzw
  23: ld_indexable(texture2d)(float,float,float,float) r0.x, r0.xyzw, g_ZBuffer.xyzw
  24: mad r0.yzw, r3.xxyz, l(0.000000, 2.000000, 2.000000, 2.000000), l(0.000000, -1.000000, -1.000000, -1.000000)
  25: dp3 r3.x, r0.yzwy, r0.yzwy
  26: rsq r3.x, r3.x
  27: mul r0.yzw, r0.yyzw, r3.xxxx
  28: mad r3.x, v1.x, l(2.000000), g_ProjectionOffset.x
  29: mad r3.y, v1.y, l(-2.000000), g_ProjectionOffset.y
  30: div r4.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[0].x
  31: div r4.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[1].y
  32: add r3.xy, r3.xyxx, l(-1.000000, 1.000000, 0.000000, 0.000000)
  33: mad r0.x, r0.x, g_CameraParam.y, g_CameraParam.x
  34: mul r3.xy, r0.xxxx, r3.xyxx
  35: mul r3.xy, r4.xyxx, r3.xyxx
  36: mov r3.z, -r0.x
  37: dp3 r0.x, -r3.xyzx, -r3.xyzx
  38: rsq r0.x, r0.x
  39: and r1.w, r1.w, l(64)
  40: movc r1.w, r1.w, l(0), r2.z
  41: max r2.z, r2.w, l(0.040000)
  42: min r2.z, r2.z, l(1.000000)
  43: sample_indexable(texture2d)(float,float,float,float) r2.w, v1.xyxx, g_ShadowTexture.yzwx, g_ShadowTextureSampler
  44: lt r3.w, l(0.500000), g_LightParam1.w
  45: ieq r2.x, r2.x, l(5)
  46: and r2.x, r2.x, r3.w
  47: movc r2.x, r2.x, l(1.000000), r2.w
  48: sample_l(texture2d)(float,float,float,float) r4.xyz, v1.xyxx, g_SubtractLightTexture.xyzw, g_SubtractLightTextureSampler, l(0)
  49: add r4.xyz, -r4.xyzx, g_lightColor.xyzx
  50: max r4.xyz, r4.xyzx, l(0, 0, 0, 0)
  51: dp3_sat r2.w, r0.yzwy, g_lightVec.xyzx
  52: add r3.w, -r1.w, l(1.000000)
  53: mul r3.w, r2.w, r3.w
  54: mul r5.xyz, r1.xyzx, r4.xyzx
  55: mul r3.w, r3.w, l(0.318310)
  56: mul r5.xyz, r3.wwww, r5.xyzx
  57: mad r3.xyz, -r3.xyzx, r0.xxxx, g_lightVec.xyzx
  58: dp3 r0.x, r3.xyzx, r3.xyzx
  59: rsq r0.x, r0.x
  60: mul r3.xyz, r0.xxxx, r3.xyzx
  61: mul r1.xyz, r1.wwww, r1.xyzx
  62: mul r1.xyz, r4.xyzx, r1.xyzx
  63: mul r0.x, r2.z, r2.z
  64: mul r1.w, r0.x, r0.x
  65: dp3_sat r3.w, g_lightVec.xyzx, r3.xyzx
  66: dp3_sat r0.y, r0.yzwy, r3.xyzx
  67: mul r0.y, r0.y, r0.y
  68: mad r0.x, r0.x, r0.x, l(-1.000000)
  69: mad r0.x, r0.y, r0.x, l(1.000000)
  70: mul r0.x, r3.w, r0.x
  71: mul r0.x, r0.x, r0.x
  72: mul r0.x, r0.x, l(12.566371)
  73: add r0.y, r2.z, l(0.500000)
  74: mul r0.x, r0.y, r0.x
  75: max r0.x, r0.x, l(0.000000)
  76: div r0.x, r1.w, r0.x
  77: mul r0.xyz, r0.xxxx, r1.xyzx
  78: mul r0.xyz, r2.wwww, r0.xyzx
  79: mul r0.xyz, r2.xxxx, r0.xyzx
  80: mad o0.xyz, r5.xyzx, r2.xxxx, r0.xyzx
  81: mov o0.w, r2.y
  82: ret
