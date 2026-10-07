Shader hash ff16a61a-52769fbc-f9cbd307-5e045c2e

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb12[1] (HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb7[1] (PrecomputeValue_Buffer), immediateIndexed
      dcl_resource_texture2d (float,float,float,float) g_LinearZBuffer (t0)
      dcl_uav_structured gTileInfo (u1), 64
      dcl_input vThreadGroupID.xy
      dcl_input vThreadIDInGroup.xy
      dcl_input vThreadID.xy
      dcl_temps 11
      dcl_tgsm_raw g0, 4
      dcl_tgsm_raw g1, 4
      dcl_tgsm_raw g2, 4
      dcl_thread_group 32, 30, 1
   0: imad r0.x, vThreadIDInGroup.y, l(32), vThreadIDInGroup.x
   1: mov r1.xy, vThreadID.xyxx
   2: mov r1.zw, l(0, 0, 0, 0)
   3: ld_indexable(texture2d)(float,float,float,float) r0.y, r1.xyzw, g_LinearZBuffer.yxzw
   4: mad r0.y, r0.y, g_CameraParam.y, g_CameraParam.x
   5: if_z r0.x
   6:   store_raw g0.x, l(0), l(340282346638528870000000000000000000000.000000)
   7:   store_raw g1.x, l(0), l(0)
   8:   store_raw g2.x, l(0), l(0)
   9: endif
  10: sync_g_t
  11: atomic_umin g0, l(0), r0.y
  12: atomic_umax g1, l(0), r0.y
  13: sync_g_t
  14: ld_raw r1.x, l(0), g0.xxxx
  15: ld_raw r2.x, l(0), g1.xxxx
  16: mov r3.w, -r1.x
  17: add r0.z, r2.x, r3.w
  18: add r0.z, r0.z, l(0.000100)
  19: div r0.z, l(32.000000), r0.z
  20: add r0.y, r0.y, r3.w
  21: mul r0.y, r0.z, r0.y
  22: round_ni r0.y, r0.y
  23: min r0.y, r0.y, l(32.000000)
  24: max r0.y, r0.y, l(0)
  25: ftou r0.y, r0.y
  26: ishl r0.y, l(1), r0.y
  27: atomic_or g2, l(0), r0.y
  28: sync_g_t
  29: if_z r0.x
  30:   ftou r0.x, g_TileScaleAndSize.z
  31:   imad r0.x, vThreadGroupID.y, r0.x, vThreadGroupID.x
  32:   utof r0.yz, vThreadGroupID.xxyx
  33:   mul r0.yz, r0.yyzy, l(0.000000, 32.000000, 30.000000, 0.000000)
  34:   round_z r2.zw, g_TargetUvParam.zzzw
  35:   div r0.yz, r0.yyzy, r2.zzwz
  36:   iadd r4.xy, vThreadGroupID.xyxx, l(1, 1, 0, 0)
  37:   utof r4.xy, r4.xyxx
  38:   mul r4.xy, r4.xyxx, l(32.000000, 30.000000, 0.000000, 0.000000)
  39:   div r2.zw, r4.xxxy, r2.zzzw
  40:   div r4.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[0].x
  41:   div r4.z, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[1].y
  42:   mad r4.xw, r0.yyyz, l(2.000000, 0.000000, 0.000000, -2.000000), l(-1.000000, 0.000000, 0.000000, 1.000000)
  43:   add r4.xw, r4.xxxw, g_ProjectionOffset.xxxy
  44:   mul r5.xy, r1.xxxx, r4.xwxx
  45:   mul r3.yz, r4.yyzy, r5.xxyx
  46:   mad r5.xy, r2.zwzz, l(2.000000, -2.000000, 0.000000, 0.000000), l(-1.000000, 1.000000, 0.000000, 0.000000)
  47:   add r5.xy, r5.xyxx, g_ProjectionOffset.xyxx
  48:   mul r5.zw, r1.xxxx, r5.xxxy
  49:   mul r6.yz, r4.yyzy, r5.zzwz
  50:   dp3 r0.w, r3.yzwy, r3.yzwy
  51:   rsq r0.w, r0.w
  52:   mul r7.xyz, r0.wwww, r3.yzwy
  53:   mov r6.w, r3.w
  54:   dp3 r3.x, r6.yzwy, r6.yzwy
  55:   rsq r3.x, r3.x
  56:   mul r8.xyz, r3.xxxx, r6.yzwy
  57:   mad r9.xyz, r3.yzwy, r0.wwww, r8.xyzx
  58:   dp3 r0.w, r9.xyzx, r9.xyzx
  59:   rsq r0.w, r0.w
  60:   mul r9.xyz, r0.wwww, r9.xyzx
  61:   dp3 r0.w, r7.xyzx, r9.xyzx
  62:   dp3 r3.x, r8.xyzx, r9.xyzx
  63:   min r9.w, r0.w, r3.x
  64:   mad r0.w, -r9.w, r9.w, l(1.000000)
  65:   sqrt r7.z, r0.w
  66:   mul r4.xw, r2.xxxx, r4.xxxw
  67:   mul r8.yz, r4.yyzy, r4.xxwx
  68:   mov r8.w, -r2.x
  69:   mul r4.xw, r2.xxxx, r5.xxxy
  70:   mul r5.yz, r4.yyzy, r4.xxwx
  71:   dp3 r0.w, r8.yzwy, r9.xyzx
  72:   mov r5.w, r8.w
  73:   dp3 r3.x, r5.yzwy, r9.xyzx
  74:   max r7.y, r0.w, r3.x
  75:   dp3 r0.w, r3.yzwy, r9.xyzx
  76:   dp3 r3.x, r6.yzwy, r9.xyzx
  77:   min r7.x, r0.w, r3.x
  78:   store_structured gTileInfo.xyzw, r0.x, l(48), r9.xyzw
  79:   store_structured gTileInfo.xyz, r0.x, l(36), r7.xyzx
  80:   mad r7.y, r0.y, l(2.000000), l(-1.000000)
  81:   mad r7.z, r2.w, l(-2.000000), l(1.000000)
  82:   add r0.yw, r7.yyyz, g_ProjectionOffset.xxxy
  83:   mul r4.xw, r1.xxxx, r0.yyyw
  84:   mul r7.yz, r4.yyzy, r4.xxwx
  85:   mad r9.y, r2.z, l(2.000000), l(-1.000000)
  86:   mad r9.z, r0.z, l(-2.000000), l(1.000000)
  87:   add r2.zw, r9.yyyz, g_ProjectionOffset.xxxy
  88:   mul r4.xw, r1.xxxx, r2.zzzw
  89:   mul r9.yz, r4.yyzy, r4.xxwx
  90:   mul r0.yz, r2.xxxx, r0.yywy
  91:   mul r0.yz, r4.yyzy, r0.yyzy
  92:   mul r2.zw, r2.xxxx, r2.zzzw
  93:   mul r4.yz, r4.yyzy, r2.zzwz
  94:   mov r4.w, r5.w
  95:   min r10.xyz, r5.yzwy, r4.yzwy
  96:   mov r0.w, r4.w
  97:   min r10.xyz, r0.yzwy, r10.xyzx
  98:   min r10.xyz, r8.yzwy, r10.xyzx
  99:   min r10.xyz, r6.yzwy, r10.xyzx
 100:   mov r9.w, r6.w
 101:   min r10.xyz, r9.yzwy, r10.xyzx
 102:   mov r7.w, r9.w
 103:   min r10.xyz, r7.yzwy, r10.xyzx
 104:   min r10.xyz, r3.yzwy, r10.xyzx
 105:   max r4.xyz, r5.yzwy, r4.yzwy
 106:   max r0.yzw, r0.yyzw, r4.xxyz
 107:   max r0.yzw, r0.yyzw, r8.yyzw
 108:   max r0.yzw, r0.yyzw, r6.yyzw
 109:   max r0.yzw, r0.yyzw, r9.yyzw
 110:   max r0.yzw, r0.yyzw, r7.yyzw
 111:   max r0.yzw, r0.yyzw, r3.yyzw
 112:   add r3.xyz, r10.xyzx, r0.yzwy
 113:   mul r3.xyz, r3.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
 114:   add r0.yzw, -r10.xxyz, r0.yyzw
 115:   mul r1.yzw, r0.yyzw, l(0.000000, 0.500000, 0.500000, 0.500000)
 116:   store_structured gTileInfo.xyz, r0.x, l(0), r3.xyzx
 117:   store_structured gTileInfo.xyzw, r0.x, l(12), r1.xyzw
 118:   ld_raw r2.y, l(0), g2.xxxx
 119:   store_structured gTileInfo.xy, r0.x, l(28), r2.xyxx
 120: endif
 121: ret
