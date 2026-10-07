Shader hash 738f0b2f-8bedc95a-c7d5cec5-919187b6

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[7] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb11[13] (ShaderParams), immediateIndexed
      dcl_resource_texture2d (float,float,float,float) SrcTexture (t0)
      dcl_resource_texture2d (float,float,float,float) DepthTexture (t2)
      dcl_resource_texture2d (uint,uint,uint,uint) g_StencilBuffer (t25)
      dcl_uav_typed_texture2d (unorm,unorm,unorm,unorm) OutputTexture (u0)
      dcl_input vThreadID.xy
      dcl_temps 6
      dcl_thread_group 16, 16, 1
   0: itof r0.xyzw, vThreadID.xyxy
   1: ge r1.xy, r0.zwzz, screenSize_.xyxx
   2: or r1.x, r1.y, r1.x
   3: if_nz r1.x
   4:   ret
   5: endif
   6: mov r1.xy, vThreadID.xyxx
   7: mov r1.zw, l(0, 0, 0, 0)
   8: ld_indexable(texture2d)(float,float,float,float) r2.xyz, r1.xyww, SrcTexture.xyzw
   9: ld_indexable(texture2d)(float,float,float,float) r3.x, r1.xyww, DepthTexture.xyzw
  10: add r3.x, r3.x, g_Proj[2].z
  11: div r3.x, g_Proj[2].w, r3.x
  12: add r3.x, r3.x, -g_CameraParam.x
  13: div r3.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_CameraParam.y
  14: mul r3.x, r3.y, r3.x
  15: lt r3.y, r3.x, l(0.990000)
  16: if_nz r3.y
  17:   mul r0.xyzw, r0.xyzw, screenSize_.zwzw
  18:   ld_indexable(texture2d)(uint,uint,uint,uint) r1.x, r1.xyzw, g_StencilBuffer.yxzw
  19:   and r1.xy, r1.xxxx, l(15, 128, 0, 0)
  20:   movc r1.y, r1.y, l(9), l(0)
  21:   iadd r1.x, r1.y, r1.x
  22:   mul r1.y, r3.x, farZ_.x
  23:   mad r1.z, r1.y, l(0.040000), depthLineThresholdOffset_.x
  24:   mad r1.z, -r1.z, depthLineThresholdScale_.x, l(1.000000)
  25:   add r1.w, -depthLineThresholdSmin_.x, depthLineThresholdSmax_.x
  26:   add r1.z, r1.z, -depthLineThresholdSmin_.x
  27:   div r1.w, l(1.000000, 1.000000, 1.000000, 1.000000), r1.w
  28:   mul_sat r1.z, r1.w, r1.z
  29:   mad r1.w, r1.z, l(-2.000000), l(3.000000)
  30:   mul r1.z, r1.z, r1.z
  31:   mul r1.z, r1.z, r1.w
  32:   mad r3.xy, r0.zwzz, l(2.000000, 2.000000, 0.000000, 0.000000), maskCenterPosition_.xyxx
  33:   add r3.xy, r3.xyxx, l(-1.000000, -1.000000, 0.000000, 0.000000)
  34:   mul r3.xy, r3.xyxx, maskRatio_.xyxx
  35:   dp2 r1.w, r3.xyxx, r3.xyxx
  36:   sqrt r1.w, r1.w
  37:   add r3.x, centerMaskSmax_.x, -centerMaskSmin_.x
  38:   add r1.w, r1.w, -centerMaskSmin_.x
  39:   div r3.x, l(1.000000, 1.000000, 1.000000, 1.000000), r3.x
  40:   mul_sat r1.w, r1.w, r3.x
  41:   mad r3.x, r1.w, l(-2.000000), l(3.000000)
  42:   mul r1.w, r1.w, r1.w
  43:   mul r1.w, r1.w, r3.x
  44:   mad_sat r1.w, -r1.w, centerEmiStrength_.x, l(1.000000)
  45:   max r3.x, pixelOffset_.x, l(-0.500000)
  46:   min r3.x, r3.x, l(0)
  47:   add r3.xyzw, r3.xxxx, l(0.000000, 1.000000, 0.000000, -1.000000)
  48:   mad r4.xyzw, r0.zwzw, screenSize_.xyxy, r3.yxwz
  49:   min r4.xy, r4.xyxx, screenSize_.xyxx
  50:   ftoi r5.xy, r4.xyxx
  51:   mov r5.zw, l(0, 0, 0, 0)
  52:   ld_indexable(texture2d)(float,float,float,float) r5.xyz, r5.xyzw, SrcTexture.xyzw
  53:   max r4.xy, r4.zwzz, l(0, 0, 0, 0)
  54:   ftoi r4.xy, r4.xyxx
  55:   mov r4.zw, l(0, 0, 0, 0)
  56:   ld_indexable(texture2d)(float,float,float,float) r4.xyz, r4.xyzw, SrcTexture.xyzw
  57:   mad r0.xyzw, r0.xyzw, screenSize_.xyxy, r3.xyzw
  58:   min r0.xy, r0.xyxx, screenSize_.xyxx
  59:   ftoi r3.xy, r0.xyxx
  60:   mov r3.zw, l(0, 0, 0, 0)
  61:   ld_indexable(texture2d)(float,float,float,float) r3.xyz, r3.xyzw, SrcTexture.xyzw
  62:   max r0.xy, r0.zwzz, l(0, 0, 0, 0)
  63:   ftoi r0.xy, r0.xyxx
  64:   mov r0.zw, l(0, 0, 0, 0)
  65:   ld_indexable(texture2d)(float,float,float,float) r0.xyz, r0.xyzw, SrcTexture.xyzw
  66:   add r4.xyz, -r4.xyzx, r5.xyzx
  67:   add r0.xyz, -r0.xyzx, r3.xyzx
  68:   dp3 r0.w, r4.xyzx, r4.xyzx
  69:   dp3 r0.x, r0.xyzx, r0.xyzx
  70:   add r0.x, r0.x, r0.w
  71:   add r0.y, -coefficient_.x, coefficientNear_.x
  72:   mad r0.y, r1.z, r0.y, coefficient_.x
  73:   add r0.y, r0.y, -coefficientAroundFrame_.x
  74:   mad r0.y, r1.w, r0.y, coefficientAroundFrame_.x
  75:   mul_sat r0.x, r0.y, r0.x
  76:   add r0.yzw, -color_.xxyz, l(0.000000, 1.000000, 1.000000, 1.000000)
  77:   mul r0.xyz, r0.xxxx, r0.yzwy
  78:   mad r0.w, r1.y, l(0.040000), depthOffset_.x
  79:   mul_sat r0.w, r0.w, depthRangeScale_.x
  80:   mul r0.xyz, -r0.xyzx, r0.wwww
  81:   ieq r3.xyzw, r1.xxxx, l(9, 10, 13, 11)
  82:   and r3.xyzw, r3.xyzw, l(1.000000, 1.000000, 1.000000, 1.000000)
  83:   add r0.w, r3.z, r3.y
  84:   add r0.w, r3.w, r0.w
  85:   ieq r1.x, r1.x, l(12)
  86:   and r1.x, r1.x, l(1.000000)
  87:   add r0.w, r0.w, r1.x
  88:   add r0.w, r3.x, r0.w
  89:   min r0.w, r0.w, l(1.000000)
  90:   add r0.w, -r0.w, l(1.000000)
  91:   mad r2.xyz, r0.wwww, r0.xyzx, r2.xyzx
  92: endif
  93: mov r2.w, l(1.000000)
  94: store_uav_typed OutputTexture.xyzw, vThreadID.xyyy, r2.xyzw
  95: ret
