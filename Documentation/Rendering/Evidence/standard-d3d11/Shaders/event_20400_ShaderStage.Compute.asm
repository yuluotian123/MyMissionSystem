Shader hash 9d7a8e08-bc3ef926-afe3dd0d-09cab562

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb9[1] (OptimizeData), immediateIndexed
      dcl_constantbuffer cb10[1] (TargetSize), immediateIndexed
      dcl_constantbuffer cb11[1400] (ParamBuffer), dynamicIndexed
      dcl_sampler _localIBLSpecularTexsSampler (s3), mode_default
      dcl_sampler _localIBLIrradianceTexsSampler (s4), mode_default
      dcl_sampler AALResultTexSampler (s10), mode_default
      dcl_sampler CubeSampler (s13), mode_default
      dcl_sampler g_TextureBRDFSampler (s15), mode_default
      dcl_resource_texturecubearray (float,float,float,float) _localIBLSpecularTexs (t3)
      dcl_resource_texturecubearray (float,float,float,float) _localIBLIrradianceTexs (t4)
      dcl_resource_structured g_rCubeBlendNum (t7), 4
      dcl_resource_structured g_rCubeIndex (t8), 4
      dcl_resource_texture2d (float,float,float,float) AALResultTex (t10)
      dcl_resource_texturecube (float,float,float,float) g_TextureIBLSpecular (t12)
      dcl_resource_texture2d (float,float,float,float) g_TextureBRDF (t15)
      dcl_resource_texturecube (float,float,float,float) g_TextureIBLDiffuse (t17)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer00 (t20)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer01 (t21)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer02 (t22)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_resource_texture2d (uint,uint,uint,uint) g_StencilBuffer (t25)
      dcl_uav_typed_texture2d (float,float,float,float) ResultDiffuse (u5)
      dcl_uav_typed_texture2d (float,float,float,float) ResultSpecular (u6)
      dcl_input vThreadGroupID.xy
      dcl_input vThreadID.xy
      dcl_temps 18
      dcl_thread_group 32, 30, 1
   0: ftoi r0.xy, _targetSize.xyxx
   1: ilt r0.xy, vThreadID.xyxx, r0.xyxx
   2: and r0.x, r0.y, r0.x
   3: if_z r0.x
   4:   ret
   5: endif
   6: utof r0.xyzw, vThreadID.xyxy
   7: div r0.xy, r0.xyxx, _targetSize.xyxx
   8: ftoi r1.xy, r0.zwzz
   9: mov r1.zw, l(0, 0, 0, 0)
  10: ld_indexable(texture2d)(float,float,float,float) r0.z, r1.xyww, g_ZBuffer.yzxw
  11: ld_indexable(texture2d)(uint,uint,uint,uint) r0.w, r1.xyww, g_StencilBuffer.xzwy
  12: and r2.xy, r0.wwww, l(15, 128, 0, 0)
  13: movc r0.w, r2.y, l(9), l(0)
  14: iadd r0.w, r0.w, r2.x
  15: lt r2.x, l(0.990000), r0.z
  16: sample_l(texture2d)(float,float,float,float) r2.y, r0.xyxx, AALResultTex.xwyz, AALResultTexSampler, l(0)
  17: lt r2.z, r2.y, l(2.000000)
  18: ge r2.y, r2.y, optimizeData_.x
  19: and r2.y, r2.y, r2.z
  20: ult r0.w, r0.w, l(9)
  21: and r2.y, r0.w, r2.y
  22: or r2.x, r2.x, r2.y
  23: if_nz r2.x
  24:   store_uav_typed ResultDiffuse.xyzw, vThreadID.xyyy, l(0.000000, 0.000000, 0.000000, 1.000000)
  25:   store_uav_typed ResultSpecular.xyzw, vThreadID.xyyy, l(0, 0, 0, 0)
  26:   ret
  27: endif
  28: ld_indexable(texture2d)(float,float,float,float) r2.xyzw, r1.xyww, g_GeometryBuffer00.xyzw
  29: ld_indexable(texture2d)(float,float,float,float) r3.xyz, r1.xyww, g_GeometryBuffer01.xyzw
  30: ld_indexable(texture2d)(float,float,float,float) r1.xyz, r1.xyzw, g_GeometryBuffer02.xyzw
  31: mul r1.w, r2.w, l(255.000000)
  32: round_ne r1.w, r1.w
  33: ftou r1.w, r1.w
  34: mad r1.xyz, r1.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(-1.000000, -1.000000, -1.000000, 0.000000)
  35: dp3 r2.w, r1.xyzx, r1.xyzx
  36: rsq r2.w, r2.w
  37: mul r1.xyz, r1.xyzx, r2.wwww
  38: mad r4.x, r0.x, l(2.000000), g_ProjectionOffset.x
  39: mad r4.y, r0.y, l(-2.000000), g_ProjectionOffset.y
  40: div r0.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[0].x
  41: div r0.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[1].y
  42: add r4.xy, r4.xyxx, l(-1.000000, 1.000000, 0.000000, 0.000000)
  43: mad r0.z, r0.z, g_CameraParam.y, g_CameraParam.x
  44: mul r4.xy, r0.zzzz, r4.xyxx
  45: mul r4.xy, r0.xyxx, r4.xyxx
  46: mov r4.z, -r0.z
  47: mov r4.w, l(1.000000)
  48: dp4 r5.x, r4.xyzw, g_ViewInverseMatrix[0].xyzw
  49: dp4 r5.y, r4.xyzw, g_ViewInverseMatrix[1].xyzw
  50: dp4 r5.z, r4.xyzw, g_ViewInverseMatrix[2].xyzw
  51: dp3 r0.x, r1.xyzx, g_ViewInverseMatrix[0].xyzx
  52: dp3 r0.y, r1.xyzx, g_ViewInverseMatrix[1].xyzx
  53: dp3 r0.z, r1.xyzx, g_ViewInverseMatrix[2].xyzx
  54: mov r1.x, g_ViewInverseMatrix[0].w
  55: mov r1.y, g_ViewInverseMatrix[1].w
  56: mov r1.z, g_ViewInverseMatrix[2].w
  57: add r1.xyz, -r5.xyzx, r1.xyzx
  58: dp3 r2.w, r1.xyzx, r1.xyzx
  59: rsq r2.w, r2.w
  60: mul r1.xyz, r1.xyzx, r2.wwww
  61: and r1.w, r1.w, l(64)
  62: movc r1.w, r1.w, l(0), r3.x
  63: ftou r2.w, _targetSize.z
  64: imad r2.w, vThreadGroupID.y, r2.w, vThreadGroupID.x
  65: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r3.x, r2.w, l(0), g_rCubeBlendNum.xxxx
  66: dp3_sat r4.x, r0.xyzx, r1.xyzx
  67: dp3 r3.w, -r1.xyzx, r0.xyzx
  68: add r3.w, r3.w, r3.w
  69: mad r1.xyz, r0.xyzx, -r3.wwww, -r1.xyzx
  70: dp3 r3.w, r1.xyzx, r1.xyzx
  71: rsq r3.w, r3.w
  72: mul r1.xyz, r1.xyzx, r3.wwww
  73: add r4.y, -r3.y, l(1.000000)
  74: sample_l(texture2d)(float,float,float,float) r4.xy, r4.xyxx, g_TextureBRDF.xyzw, g_TextureBRDFSampler, l(0)
  75: resinfo_indexable(texturecube)(float,float,float,float)_uint r3.w, l(0), g_TextureIBLSpecular.xyzw
  76: add r4.z, -r1.w, l(1.000000)
  77: utof r3.w, r3.w
  78: mul r3.w, r3.w, r3.y
  79: mul r6.xyz, r1.wwww, r2.xyzx
  80: mad r4.xyw, r6.xyxz, r4.xxxx, r4.yyyy
  81: resinfo_indexable(texturecubearray)(float,float,float,float)_uint r1.w, l(0), _localIBLSpecularTexs.xyzw
  82: utof r1.w, r1.w
  83: mov r5.w, l(1.000000)
  84: mov r6.xyz, l(0, 0, 0, 0)
  85: mov r7.xyz, l(0, 0, 0, 0)
  86: mov r8.xy, l(0.000000, 1.000000, 0.000000, 0.000000)
  87: loop
  88:   uge r8.z, r8.x, r3.x
  89:   breakc_nz r8.z
  90:   lt r8.z, r8.y, l(0.010000)
  91:   if_nz r8.z
  92:     mov r8.yz, l(0, 0, 0, 0)
  93:     break
  94:   else
  95:     mov r8.z, r8.y
  96:   endif
  97:   imad r8.w, r2.w, l(50), r8.x
  98:   ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r8.w, r8.w, l(0), g_rCubeIndex.xxxx
  99:   imul null, r9.x, r8.w, l(3)
 100:   dp4 r10.x, r5.xyzw, cb11[r9.x + 420].xyzw
 101:   imad r9.yz, r8.wwww, l(0, 3, 3, 0), l(0, 1, 2, 0)
 102:   dp4 r10.y, r5.xyzw, cb11[r9.y + 420].xyzw
 103:   dp4 r10.z, r5.xyzw, cb11[r9.z + 420].xyzw
 104:   lt r11.xyz, r10.xyzx, l(-0.480000, -0.480000, -0.480000, 0.000000)
 105:   add r12.xyz, r10.xyzx, l(0.480000, 0.480000, 0.480000, 0.000000)
 106:   mov r12.xyz, abs(r12.xyzx)
 107:   and r11.xyz, r11.xyzx, r12.xyzx
 108:   lt r12.xyz, l(0.480000, 0.480000, 0.480000, 0.000000), r10.xyzx
 109:   add r13.xyz, r10.xyzx, l(-0.480000, -0.480000, -0.480000, 0.000000)
 110:   mov r13.xyz, abs(r13.xyzx)
 111:   and r12.xyz, r12.xyzx, r13.xyzx
 112:   max r9.w, r11.y, r11.x
 113:   max r9.w, r11.z, r9.w
 114:   max r10.w, r12.y, r12.x
 115:   max r10.w, r12.z, r10.w
 116:   max r9.w, r9.w, r10.w
 117:   mul r10.w, l(0.250000), cb11[r8.w + 980].y
 118:   div r10.w, l(1.000000, 1.000000, 1.000000, 1.000000), r10.w
 119:   mul_sat r9.w, r9.w, r10.w
 120:   mad r10.w, r9.w, l(-2.000000), l(3.000000)
 121:   mul r9.w, r9.w, r9.w
 122:   mad r9.w, -r10.w, r9.w, l(1.000000)
 123:   mul r9.w, r9.w, cb11[r8.w + 1120].w
 124:   lt r10.w, r9.w, l(0.001000)
 125:   if_nz r10.w
 126:     iadd r10.w, r8.x, l(1)
 127:     mov r8.y, r8.z
 128:     mov r8.x, r10.w
 129:     continue
 130:   endif
 131:   ge r10.w, cb11[r8.w + 1260].w, l(0)
 132:   if_nz r10.w
 133:     mul r11.xyz, r0.yyyy, cb11[r9.y + 420].xyzx
 134:     mad r11.xyz, r0.xxxx, cb11[r9.x + 420].xyzx, r11.xyzx
 135:     mad r11.xyz, r0.zzzz, cb11[r9.z + 420].xyzx, r11.xyzx
 136:     mul r11.xyz, r11.xyzx, l(1.000000, 1.000000, -1.000000, 0.000000)
 137:     sample_l(texturecube)(float,float,float,float) r11.xyz, r11.xyzx, g_TextureIBLDiffuse.xyzw, CubeSampler, l(0)
 138:     mul r11.xyz, r2.xyzx, r11.xyzx
 139:     mul r11.xyz, r4.zzzz, r11.xyzx
 140:     mul r12.xyz, r1.yyyy, cb11[r9.y + 420].xyzx
 141:     mad r12.xyz, r1.xxxx, cb11[r9.x + 420].xyzx, r12.xyzx
 142:     mad r12.xyz, r1.zzzz, cb11[r9.z + 420].xyzx, r12.xyzx
 143:     mul r12.xyz, r12.xyzx, l(1.000000, 1.000000, -1.000000, 0.000000)
 144:     sample_l(texturecube)(float,float,float,float) r12.xyz, r12.xyzx, g_TextureIBLSpecular.xyzw, CubeSampler, r3.w
 145:     mul r12.xyz, r4.xywx, r12.xyzx
 146:     mul r11.xyz, r3.zzzz, r11.xyzx
 147:     mul r12.xyz, r3.zzzz, r12.xyzx
 148:     if_nz r0.w
 149:       mul r11.xyz, r11.xyzx, cb11[r8.w + 1120].xyzx
 150:       mul r13.xyz, cb11[r8.w + 1120].xyzx, cb11[r8.w + 1260].xyzx
 151:       mul r12.xyz, r12.xyzx, r13.xyzx
 152:     endif
 153:     mov r9.w, l(1.000000)
 154:   else
 155:     mul r13.xyz, r0.yyyy, cb11[r9.y + 420].xyzx
 156:     mad r13.xyz, r0.xxxx, cb11[r9.x + 420].xyzx, r13.xyzx
 157:     mad r13.xyz, r0.zzzz, cb11[r9.z + 420].xyzx, r13.xyzx
 158:     add r14.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 159:     div r15.xyz, r14.xyzx, r13.xyzx
 160:     add r10.xyz, -r10.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
 161:     div r13.xyz, r10.xyzx, r13.xyzx
 162:     max r13.xyz, r13.xyzx, r15.xyzx
 163:     min r10.w, abs(r13.z), abs(r13.y)
 164:     min r10.w, r10.w, abs(r13.x)
 165:     mad r13.xyz, r0.xyzx, r10.wwww, r5.xyzx
 166:     mov r15.x, -cb11[r9.x + 0].w
 167:     mov r15.y, -cb11[r9.y + 0].w
 168:     mov r15.z, -cb11[r9.z + 0].w
 169:     add r13.xyz, r13.xyzx, r15.xyzx
 170:     utof r16.w, cb11[r8.w + 980].x
 171:     mul r16.xyz, r13.xyzx, l(1.000000, 1.000000, -1.000000, 0.000000)
 172:     sample_l(texturecubearray)(float,float,float,float) r13.xyz, r16.xyzw, _localIBLIrradianceTexs.xyzw, _localIBLIrradianceTexsSampler, l(0)
 173:     mul r13.xyz, r2.xyzx, r13.xyzx
 174:     mul r13.xyz, r4.zzzz, r13.xyzx
 175:     mul r17.xyz, r1.yyyy, cb11[r9.y + 420].xyzx
 176:     mad r17.xyz, r1.xxxx, cb11[r9.x + 420].xyzx, r17.xyzx
 177:     mad r9.xyz, r1.zzzz, cb11[r9.z + 420].xyzx, r17.xyzx
 178:     div r14.xyz, r14.xyzx, r9.xyzx
 179:     div r9.xyz, r10.xyzx, r9.xyzx
 180:     max r9.xyz, r9.xyzx, r14.xyzx
 181:     min r9.y, abs(r9.z), abs(r9.y)
 182:     min r9.x, r9.y, abs(r9.x)
 183:     mad r9.xyz, r1.xyzx, r9.xxxx, r5.xyzx
 184:     add r9.xyz, r15.xyzx, r9.xyzx
 185:     mad r10.x, r3.y, r1.w, cb11[r8.w + 980].w
 186:     min r10.x, r1.w, r10.x
 187:     mul r16.xyz, r9.xyzx, l(1.000000, 1.000000, -1.000000, 0.000000)
 188:     sample_l(texturecubearray)(float,float,float,float) r9.xyz, r16.xyzw, _localIBLSpecularTexs.xyzw, _localIBLSpecularTexsSampler, r10.x
 189:     mul r9.xyz, r4.xywx, r9.xyzx
 190:     mul r10.xyz, r3.zzzz, r13.xyzx
 191:     mul r9.xyz, r3.zzzz, r9.xyzx
 192:     mul r11.xyz, r10.xyzx, cb11[r8.w + 1120].xyzx
 193:     mul r10.xyz, cb11[r8.w + 1120].xyzx, cb11[r8.w + 1260].xyzx
 194:     mul r12.xyz, r9.xyzx, r10.xyzx
 195:   endif
 196:   mul r9.xyz, r9.wwww, r11.xyzx
 197:   mad r6.xyz, r9.xyzx, r8.zzzz, r6.xyzx
 198:   mul r9.xyz, r9.wwww, r12.xyzx
 199:   mad r7.xyz, r9.xyzx, r8.zzzz, r7.xyzx
 200:   add r8.w, -r9.w, l(1.000000)
 201:   mul r8.y, r8.w, r8.z
 202:   iadd r8.x, r8.x, l(1)
 203: endloop
 204: add r6.w, -r8.y, l(1.000000)
 205: store_uav_typed ResultDiffuse.xyzw, vThreadID.xyyy, r6.xyzw
 206: mov r7.w, l(0)
 207: store_uav_typed ResultSpecular.xyzw, vThreadID.xyyy, r7.xyzw
 208: ret
