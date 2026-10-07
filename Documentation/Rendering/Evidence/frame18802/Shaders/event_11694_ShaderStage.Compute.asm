Shader hash 1723a46a-defa8f10-b966cdce-562ab7d3

cs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[1] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb10[1] (TargetSize), immediateIndexed
      dcl_sampler g_TextureBRDFSampler (s15), mode_default
      dcl_resource_texture2d (float,float,float,float) g_ShadowTexture (t2)
      dcl_resource_structured g_rCubeBlendNum (t7), 4
      dcl_resource_structured g_rCubeIndex (t8), 4
      dcl_resource_structured _data (t11), 224
      dcl_resource_texture2d (float,float,float,float) g_TextureBRDF (t15)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer00 (t20)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer01 (t21)
      dcl_resource_texture2d (float,float,float,float) g_GeometryBuffer02 (t22)
      dcl_resource_texture2d (float,float,float,float) g_ZBuffer (t24)
      dcl_resource_texture2d (uint,uint,uint,uint) g_StencilBuffer (t25)
      dcl_uav_typed_texture2d (float,float,float,float) ResultDiffuse (u5)
      dcl_input vThreadGroupID.xy
      dcl_input vThreadID.xy
      dcl_temps 19
      dcl_thread_group 32, 30, 1
   0: ftoi r0.xy, _targetSize.xyxx
   1: ilt r0.xy, vThreadID.xyxx, r0.xyxx
   2: and r0.x, r0.y, r0.x
   3: if_z r0.x
   4:   ret
   5: endif
   6: utof r0.yz, vThreadID.xxyx
   7: div r1.xy, r0.yzyy, _targetSize.xyxx
   8: ftoi r2.xy, r0.yzyy
   9: mov r2.zw, l(0, 0, 0, 0)
  10: ld_indexable(texture2d)(float,float,float,float) r0.yzw, r2.xyww, g_GeometryBuffer02.wxyz
  11: ld_indexable(texture2d)(float,float,float,float) r1.z, r2.xyww, g_ZBuffer.yzxw
  12: ld_indexable(texture2d)(uint,uint,uint,uint) r1.w, r2.xyww, g_StencilBuffer.xzwy
  13: and r3.xy, r1.wwww, l(15, 128, 0, 0)
  14: movc r1.w, r3.y, l(9), l(0)
  15: iadd r1.w, r1.w, r3.x
  16: mad r0.yzw, r0.yyzw, l(0.000000, 2.000000, 2.000000, 2.000000), l(0.000000, -1.000000, -1.000000, -1.000000)
  17: dp3 r3.x, r0.yzwy, r0.yzwy
  18: rsq r3.x, r3.x
  19: mul r0.yzw, r0.yyzw, r3.xxxx
  20: mad r3.x, r1.x, l(2.000000), g_ProjectionOffset.x
  21: mad r3.y, r1.y, l(-2.000000), g_ProjectionOffset.y
  22: div r4.x, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[0].x
  23: div r4.y, l(1.000000, 1.000000, 1.000000, 1.000000), g_Proj[1].y
  24: add r3.xy, r3.xyxx, l(-1.000000, 1.000000, 0.000000, 0.000000)
  25: mad r1.z, r1.z, g_CameraParam.y, g_CameraParam.x
  26: mul r3.xy, r1.zzzz, r3.xyxx
  27: mul r3.xy, r4.xyxx, r3.xyxx
  28: mov r3.z, -r1.z
  29: mov r3.w, l(1.000000)
  30: dp4 r4.x, r3.xyzw, g_ViewInverseMatrix[0].xyzw
  31: dp4 r4.y, r3.xyzw, g_ViewInverseMatrix[1].xyzw
  32: dp4 r4.z, r3.xyzw, g_ViewInverseMatrix[2].xyzw
  33: dp3 r5.x, r0.yzwy, g_ViewInverseMatrix[0].xyzx
  34: dp3 r5.y, r0.yzwy, g_ViewInverseMatrix[1].xyzx
  35: dp3 r5.z, r0.yzwy, g_ViewInverseMatrix[2].xyzx
  36: ftou r0.y, _targetSize.z
  37: imad r0.y, vThreadGroupID.y, r0.y, vThreadGroupID.x
  38: sample_l(texture2d)(float,float,float,float) r0.z, r1.xyxx, g_ShadowTexture.yzxw, g_TextureBRDFSampler, l(0)
  39: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, r0.y, l(0), g_rCubeBlendNum.xxxx
  40: ishl r1.x, l(1), r1.w
  41: uge r1.y, r1.w, l(9)
  42: mov r4.w, l(1.000000)
  43: mov r5.w, l(1.000000)
  44: mov r6.xyz, l(0, 0, 0, 0)
  45: mov r7.xyz, l(0, 0, 0, 0)
  46: mov r1.zw, l(0.000000, 0.000000, 1.000000, nan)
  47: mov r3.w, l(0)
  48: loop
  49:   uge r6.w, r3.w, r0.w
  50:   breakc_nz r6.w
  51:   lt r6.w, r1.z, l(0.010000)
  52:   if_nz r6.w
  53:     mov r1.z, l(0)
  54:     break
  55:   else
  56:     mov r6.w, r1.z
  57:   endif
  58:   imad r7.w, r0.y, l(150), r3.w
  59:   ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r7.w, r7.w, l(0), g_rCubeIndex.xxxx
  60:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r8.xyzw, r7.w, l(64), _data.xyzw
  61:   ftou r8.y, r8.y
  62:   and r8.y, r1.x, r8.y
  63:   ine r8.y, r1.x, r8.y
  64:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r9.xyz, r7.w, l(48), _data.xyzx
  65:   add r9.xyz, -r3.xyzx, r9.xyzx
  66:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r9.w, r7.w, l(204), _data.xxxx
  67:   dp3 r9.x, r9.xyzx, r9.xyzx
  68:   mul r9.y, r9.w, r9.w
  69:   lt r9.x, r9.y, r9.x
  70:   movc r8.z, r1.y, r8.z, r8.w
  71:   mul r8.w, r8.x, r8.z
  72:   ge r8.w, l(0), r8.w
  73:   or r8.y, r8.y, r9.x
  74:   or r8.y, r8.w, r8.y
  75:   if_nz r8.y
  76:     iadd r8.y, r3.w, l(1)
  77:     mov r1.z, r6.w
  78:     mov r3.w, r8.y
  79:     continue
  80:   endif
  81:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r9.xyzw, r7.w, l(0), _data.xyzw
  82:   dp4 r9.x, r4.xyzw, r9.xyzw
  83:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r10.xyzw, r7.w, l(16), _data.xyzw
  84:   dp4 r9.y, r4.xyzw, r10.xyzw
  85:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r10.xyzw, r7.w, l(32), _data.xyzw
  86:   dp4 r9.z, r4.xyzw, r10.xyzw
  87:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r8.y, r7.w, l(172), _data.xxxx
  88:   lt r8.y, l(0.500000), r8.y
  89:   if_nz r8.y
  90:     mul r8.yw, r8.xxxx, l(0.000000, -0.500000, 0.000000, 0.500000)
  91:     ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r9.w, r7.w, l(188), _data.xxxx
  92:     add r10.x, -r9.w, l(1.000000)
  93:     mad r10.yzw, r8.yyyy, r10.xxxx, -r9.xxyz
  94:     div_sat r10.yzw, r10.yyzw, r9.wwww
  95:     mad r11.xyz, r10.yzwy, l(-2.000000, -2.000000, -2.000000, 0.000000), l(3.000000, 3.000000, 3.000000, 0.000000)
  96:     mul r10.yzw, r10.yyzw, r10.yyzw
  97:     mad r12.xyz, -r8.wwww, r10.xxxx, r9.xyzx
  98:     div_sat r12.xyz, r12.xyzx, r9.wwww
  99:     mad r13.xyz, r12.xyzx, l(-2.000000, -2.000000, -2.000000, 0.000000), l(3.000000, 3.000000, 3.000000, 0.000000)
 100:     mul r12.xyz, r12.xyzx, r12.xyzx
 101:     mul r12.xyz, r12.xyzx, r13.xyzx
 102:     mad r10.xyz, r11.xyzx, r10.yzwy, r12.xyzx
 103:     dp3 r8.y, r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 104:   else
 105:     ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r8.w, r7.w, l(188), _data.xxxx
 106:     add r8.w, -r8.w, l(1.000000)
 107:     min r8.w, r8.w, l(0.999900)
 108:     mad r10.xyz, r8.xxxx, l(-0.250000, -0.250000, -0.250000, 0.000000), -r9.xyzx
 109:     max r10.xyz, r10.xyzx, l(0, 0, 0, 0)
 110:     mad r9.xyz, -r8.xxxx, l(0.250000, 0.250000, 0.250000, 0.000000), r9.xyzx
 111:     max r9.xyz, r9.xyzx, l(0, 0, 0, 0)
 112:     add r9.xyz, r9.xyzx, r10.xyzx
 113:     dp3 r9.x, r9.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
 114:     min r9.x, r9.x, l(1.000000)
 115:     mad r9.x, -r8.w, r8.x, r9.x
 116:     max r9.x, r9.x, l(0)
 117:     add r8.w, -r8.w, l(1.000000)
 118:     div r8.y, r9.x, r8.w
 119:   endif
 120:   mul r8.x, r8.x, l(0.700000)
 121:   div r8.x, l(1.000000, 1.000000, 1.000000, 1.000000), r8.x
 122:   mul_sat r8.x, r8.x, r8.y
 123:   mad r8.y, r8.x, l(-2.000000), l(3.000000)
 124:   mul r8.x, r8.x, r8.x
 125:   mad r8.x, -r8.y, r8.x, l(1.000000)
 126:   mul r8.y, r8.z, r8.x
 127:   mul r8.y, r6.w, r8.y
 128:   lt r8.w, r8.y, l(0.010000)
 129:   if_nz r8.w
 130:     iadd r8.w, r3.w, l(1)
 131:     mov r1.z, r6.w
 132:     mov r3.w, r8.w
 133:     continue
 134:   endif
 135:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r9.xyzw, r7.w, l(208), _data.xyzw
 136:   lt r8.w, l(0.500000), r9.w
 137:   movc r8.w, r8.w, r0.z, l(1.000000)
 138:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r10.xyzw, r7.w, l(80), _data.xyzw
 139:   dp4 r10.x, r5.xyzw, r10.xyzw
 140:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r11.xyzw, r7.w, l(96), _data.xyzw
 141:   dp4 r10.y, r5.xyzw, r11.xyzw
 142:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r11.xyzw, r7.w, l(112), _data.xyzw
 143:   dp4 r10.z, r5.xyzw, r11.xyzw
 144:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r11.xyzw, r7.w, l(128), _data.xyzw
 145:   mul r11.xyz, r11.xyzx, l(0.282095, 0.282095, 0.282095, 0.000000)
 146:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r12.xyzw, r7.w, l(140), _data.xyzw
 147:   mul r12.yzw, r12.yyzw, l(0.000000, 0.651470, 0.651470, 0.651470)
 148:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r13.xyz, r7.w, l(160), _data.xyzx
 149:   mul r13.xyz, r13.xyzx, l(0.651470, 0.651470, 0.651470, 0.000000)
 150:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r14.xyz, r7.w, l(176), _data.xyzx
 151:   mul r14.xyz, r14.xyzx, l(0.651470, 0.651470, 0.651470, 0.000000)
 152:   ld_structured_indexable(structured_buffer, stride=224)(mixed,mixed,mixed,mixed) r15.xyz, r7.w, l(192), _data.xyzx
 153:   mul r16.xyz, r10.xyzx, r10.xyzx
 154:   lt r17.xyz, l(0, 0, 0, 0), r10.xyzx
 155:   lt r10.xyz, r10.xyzx, l(0, 0, 0, 0)
 156:   iadd r10.xyz, -r17.xyzx, r10.xyzx
 157:   itof r10.xyz, r10.xyzx
 158:   mad r17.xyz, -r15.xyzx, l(0.315392, 0.315392, 0.315392, 0.000000), r11.xyzx
 159:   mad r18.xyz, r9.xyzx, l(0.546274, 0.546274, 0.546274, 0.000000), r17.xyzx
 160:   mad r14.xyz, -r14.xyzx, r10.xxxx, r18.xyzx
 161:   mad r9.xyz, -r9.xyzx, l(0.546274, 0.546274, 0.546274, 0.000000), r17.xyzx
 162:   mad r9.xyz, -r12.yzwy, r10.yyyy, r9.xyzx
 163:   mul r9.xyz, r9.xyzx, r16.yyyy
 164:   mad r9.xyz, r16.xxxx, r14.xyzx, r9.xyzx
 165:   mad r10.xyw, r15.xyxz, l(0.630783, 0.630783, 0.000000, 0.630783), r11.xyxz
 166:   mad r10.xyz, r13.xyzx, r10.zzzz, r10.xywx
 167:   mad r9.xyz, r16.zzzz, r10.xyzx, r9.xyzx
 168:   mul r7.w, r8.w, r8.y
 169:   mad r6.xyz, r9.xyzx, r7.wwww, r6.xyzx
 170:   mul r7.w, r11.w, r7.w
 171:   mad r7.xyz, r9.xyzx, r7.wwww, r7.xyzx
 172:   mad r7.w, -r8.x, r8.z, l(1.000000)
 173:   mul r1.z, r6.w, r7.w
 174:   eq r6.w, r12.x, l(0)
 175:   and r1.w, r1.w, r6.w
 176:   iadd r3.w, r3.w, l(1)
 177: endloop
 178: if_nz r0.x
 179:   ld_indexable(texture2d)(float,float,float,float) r0.xyzw, r2.xyww, g_GeometryBuffer00.xyzw
 180:   ld_indexable(texture2d)(float,float,float,float) r2.xyz, r2.xyzw, g_GeometryBuffer01.xyzw
 181:   mul r0.w, r0.w, l(255.000000)
 182:   round_ne r0.w, r0.w
 183:   ftou r0.w, r0.w
 184:   mov r3.x, g_ViewInverseMatrix[0].w
 185:   mov r3.y, g_ViewInverseMatrix[1].w
 186:   mov r3.z, g_ViewInverseMatrix[2].w
 187:   add r3.xyz, -r4.xyzx, r3.xyzx
 188:   dp3 r1.x, r3.xyzx, r3.xyzx
 189:   rsq r1.x, r1.x
 190:   mul r3.xyz, r1.xxxx, r3.xyzx
 191:   and r0.w, r0.w, l(64)
 192:   movc r0.w, r0.w, l(0), r2.x
 193:   add r1.x, -r0.w, l(1.000000)
 194:   mul r1.x, r1.x, r2.z
 195:   mul r1.x, r1.x, l(0.318310)
 196:   mul r4.xyz, r0.xyzx, r1.xxxx
 197:   dp3_sat r1.x, r5.xyzx, r3.xyzx
 198:   mul r2.x, r2.y, r2.y
 199:   mul r2.x, r2.x, r2.x
 200:   add r1.y, -r2.y, l(1.000000)
 201:   sample_l(texture2d)(float,float,float,float) r1.xy, r1.xyxx, g_TextureBRDF.xyzw, g_TextureBRDFSampler, l(0)
 202:   mad r1.y, r2.x, -r1.y, r1.y
 203:   mul r0.w, r0.w, r1.x
 204:   mad r0.xyz, r0.xyzx, r0.wwww, r1.yyyy
 205:   mul r0.w, r2.z, l(0.318310)
 206:   mul r0.xyz, r0.wwww, r0.xyzx
 207:   mul r0.xyz, r0.xyzx, r7.xyzx
 208:   add r0.w, -r1.z, l(1.000000)
 209:   and r1.x, r1.w, l(16.000000)
 210:   add r1.w, r0.w, r1.x
 211:   mad r1.xyz, r6.xyzx, r4.xyzx, r0.xyzx
 212:   store_uav_typed ResultDiffuse.xyzw, vThreadID.xyyy, r1.xyzw
 213: endif
 214: ret
