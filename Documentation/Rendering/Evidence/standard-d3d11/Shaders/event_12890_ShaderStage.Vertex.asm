Shader hash 95beb4e7-fe011c51-a41b0fbe-ae72144b

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[24] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb2[2] (LightCommonBuffer), immediateIndexed
      dcl_constantbuffer cb11[7] (ParamBuffer), immediateIndexed
      dcl_constantbuffer cb3[7] (ParamComponentBuffer), immediateIndexed
      dcl_constantbuffer cb1[1] (VS_BaseParamBuffer), immediateIndexed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_WindMaskTexture (t1)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_resource_structured g_InstanceWorldTbl (t28), 48
      dcl_input v0.xyz
      dcl_input v1.xyzw
      dcl_input v2.xy
      dcl_input v3.xyz
      dcl_input v4.xyz
      dcl_input v5.xyz
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.xyzw
      dcl_output o4.xyzw
      dcl_output o5.xyzw
      dcl_output o6.xyzw
      dcl_output o7.xyzw
      dcl_output o8.xyzw
      dcl_output o9.xyzw
      dcl_output o10.x
      dcl_temps 20
   0: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, v5.x, l(0), g_InstanceWorldTbl.xyzw
   1: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, v5.x, l(16), g_InstanceWorldTbl.xyzw
   2: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, v5.x, l(32), g_InstanceWorldTbl.xyzw
   3: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r3.xyzw, v5.y, l(0), g_InstanceWorldTbl.xyzw
   4: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r4.xyzw, v5.y, l(16), g_InstanceWorldTbl.xyzw
   5: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r5.xyzw, v5.y, l(32), g_InstanceWorldTbl.xyzw
   6: mov r6.x, r3.x
   7: mov r6.y, r4.x
   8: mov r6.z, r5.x
   9: dp3 r7.x, r6.xyzx, g_PrevView[0].xyzx
  10: dp3 r8.x, r6.xyzx, g_PrevView[1].xyzx
  11: dp3 r9.x, r6.xyzx, g_PrevView[2].xyzx
  12: dp3 r6.x, r6.xyzx, g_PrevView[3].xyzx
  13: mov r10.x, r3.y
  14: mov r10.y, r4.y
  15: mov r10.z, r5.y
  16: dp3 r7.y, r10.xyzx, g_PrevView[0].xyzx
  17: dp3 r8.y, r10.xyzx, g_PrevView[1].xyzx
  18: dp3 r9.y, r10.xyzx, g_PrevView[2].xyzx
  19: dp3 r6.y, r10.xyzx, g_PrevView[3].xyzx
  20: mov r5.x, r3.z
  21: mov r5.y, r4.z
  22: dp3 r7.z, r5.xyzx, g_PrevView[0].xyzx
  23: dp3 r8.z, r5.xyzx, g_PrevView[1].xyzx
  24: dp3 r9.z, r5.xyzx, g_PrevView[2].xyzx
  25: dp3 r6.z, r5.xyzx, g_PrevView[3].xyzx
  26: mov r5.x, r3.w
  27: mov r5.y, r4.w
  28: mov r5.z, l(1.000000)
  29: dp4 r7.w, r5.xywz, g_PrevView[0].xyzw
  30: dp4 r8.w, r5.xywz, g_PrevView[1].xyzw
  31: dp4 r9.w, r5.xywz, g_PrevView[2].xyzw
  32: dp4 r6.w, r5.xywz, g_PrevView[3].xyzw
  33: mov r3.xyz, v0.xyzx
  34: mov r3.w, l(1.000000)
  35: dp4 r4.x, r3.xyzw, r0.xyzw
  36: dp4 r4.y, r3.xyzw, r1.xyzw
  37: dp4 r4.z, r3.xyzw, r2.xyzw
  38: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, v5.z, l(0), g_InstanceParam.xxxx
  39: iadd r5.xyzw, v5.zzzz, l(3, 4, 5, 1)
  40: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.w, r5.x, l(0), g_InstanceParam.xxxx
  41: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.w, r5.y, l(0), g_InstanceParam.xxxx
  42: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r4.w, r5.z, l(0), g_InstanceParam.xxxx
  43: mul r2.w, r2.w, r4.w
  44: add r1.w, -r1.w, l(0.785398)
  45: mad r5.xy, g_CompParam7.xxxx, l(0.017444, -0.017444, 0.000000, 0.000000), r1.wwww
  46: sincos r10.x, r11.x, -r5.x
  47: mov r12.x, -r10.x
  48: mov r12.y, r11.x
  49: dp2 r11.x, l(-1.000000, -1.000000, 0.000000, 0.000000), r12.xyxx
  50: mov r12.z, r10.x
  51: dp2 r11.z, l(-1.000000, -1.000000, 0.000000, 0.000000), r12.yzyy
  52: sincos r10.x, r12.x, -r5.y
  53: mov r13.x, -r10.x
  54: mov r13.y, r12.x
  55: dp2 r12.x, l(-1.000000, -1.000000, 0.000000, 0.000000), r13.xyxx
  56: mov r13.z, r10.x
  57: dp2 r12.z, l(-1.000000, -1.000000, 0.000000, 0.000000), r13.yzyy
  58: add r5.xy, r5.xyxx, l(0.785000, 0.785000, 0.000000, 0.000000)
  59: eq r4.w, l(0), g_CompParam6.y
  60: if_nz r4.w
  61:   mul r10.xy, r11.xzxx, g_CompParam2.yyyy
  62:   mul r10.xy, r10.xyxx, g_CameraVec.wwww
  63:   mul r10.zw, r4.xxxz, l(0.000000, 0.000000, 0.048193, 0.048193)
  64:   mad r10.xy, r10.xyxx, l(0.300000, 0.300000, 0.000000, 0.000000), r10.zwzz
  65:   add r10.xy, r10.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
  66:   sincos r13.x, r14.x, r5.x
  67:   mov r15.x, -r13.x
  68:   mov r15.y, r14.x
  69:   dp2 r14.x, r10.yxyy, r15.xyxx
  70:   mov r15.z, r13.x
  71:   dp2 r14.y, r10.yxyy, r15.yzyy
  72:   add r10.xy, r14.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  73:   sample_l(texture2d)(float,float,float,float) r4.w, r10.xyxx, g_WindMaskTexture.xzwy, ModelSampler, l(0)
  74:   mad r10.xy, r4.xzxx, l(0.021786, 0.021786, 0.000000, 0.000000), l(1.050000, 0.450000, 0.000000, 0.000000)
  75:   mad r10.xy, g_CameraVec.wwww, l(0.100000, 0.050000, 0.000000, 0.000000), r10.xyxx
  76:   sample_l(texture2d)(float,float,float,float) r5.z, r10.xyxx, g_WindMaskTexture.xyzw, ModelSampler, l(0)
  77:   mul r4.w, r4.w, r5.z
  78:   mul r5.z, r4.w, l(10.000000)
  79:   mul r10.xy, r12.xzxx, g_CompParam2.yyyy
  80:   mul r10.xy, r10.xyxx, g_CameraVec.wwww
  81:   mul r13.xyzw, r4.xzxz, l(0.016461, 0.016461, 0.025000, 0.025000)
  82:   mad r10.xy, r10.xyxx, l(0.150000, 0.150000, 0.000000, 0.000000), r13.xyxx
  83:   add r10.xy, r10.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
  84:   sincos r13.x, r14.x, r5.y
  85:   mov r15.x, -r13.x
  86:   mov r15.y, r14.x
  87:   dp2 r14.x, r10.yxyy, r15.xyxx
  88:   mov r15.z, r13.x
  89:   dp2 r14.y, r10.yxyy, r15.yzyy
  90:   add r10.xy, r14.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  91:   sample_l(texture2d)(float,float,float,float) r10.x, r10.xyxx, g_WindMaskTexture.yxzw, ModelSampler, l(0)
  92:   mad r10.yz, g_CameraVec.wwww, l(0.000000, 0.100000, 0.050000, 0.000000), r13.zzwz
  93:   add r10.yz, r10.yyzy, l(0.000000, 0.500000, 0.250000, 0.000000)
  94:   sample_l(texture2d)(float,float,float,float) r10.y, r10.yzyy, g_WindMaskTexture.xzyw, ModelSampler, l(0)
  95:   mul r10.x, r10.x, r10.y
  96:   mul r10.x, r10.x, l(10.000000)
  97:   mad r4.w, r4.w, l(10.000000), r10.x
  98:   mul r10.y, g_WeightWave.x, g_CompParam2.x
  99:   mul r10.y, r2.w, r10.y
 100:   mul r5.z, r5.z, r10.y
 101:   mul r10.zw, r11.xxxz, r5.zzzz
 102:   mul r5.z, r10.y, r10.x
 103:   mul r10.xy, r12.xzxx, r5.zzzz
 104:   mul r10.xy, r10.xyxx, l(-100.000000, -100.000000, 0.000000, 0.000000)
 105:   mad r10.xy, r10.zwzz, l(-100.000000, -100.000000, 0.000000, 0.000000), r10.xyxx
 106:   mad r10.zw, g_CameraVec.wwww, g_CompParam2.wwww, r4.xxxz
 107:   mul r10.zw, r10.zzzw, l(0.000000, 0.000000, -0.125000, -0.125000)
 108:   sample_l(texture2d)(float,float,float,float) r5.z, r10.zwzz, g_WindMaskTexture.yzxw, ModelSampler, l(0)
 109:   mul r10.z, r2.w, g_CompParam2.z
 110:   mul r5.z, r5.z, r10.z
 111:   mul r5.z, r5.z, l(10.560000)
 112:   log r5.z, abs(r5.z)
 113:   mul r5.z, r5.z, l(1.280000)
 114:   exp r5.z, r5.z
 115:   sincos r13.x, r14.x, -r1.w
 116:   mov r15.x, -r13.x
 117:   mov r15.y, r14.x
 118:   dp2 r14.x, r5.zzzz, r15.xyxx
 119:   mov r15.z, r13.x
 120:   dp2 r14.z, r5.zzzz, r15.yzyy
 121:   mad r10.xy, r14.xzxx, g_Weight.xxxx, r10.xyxx
 122:   mul r10.xy, r10.xyxx, v3.zzzz
 123:   mul r10.xz, r10.xxyx, l(0.010000, 0.000000, 0.010000, 0.000000)
 124:   dp2 r5.z, r10.xzxx, r10.xzxx
 125:   sqrt r5.z, r5.z
 126:   add r5.z, r5.z, l(0.000000)
 127:   min r10.w, r5.z, abs(v0.y)
 128:   max r11.y, r5.z, abs(v0.y)
 129:   div r11.y, l(1.000000, 1.000000, 1.000000, 1.000000), r11.y
 130:   mul r10.w, r10.w, r11.y
 131:   mul r11.y, r10.w, r10.w
 132:   mad r11.w, r11.y, l(0.020835), l(-0.085133)
 133:   mad r11.w, r11.y, r11.w, l(0.180141)
 134:   mad r11.w, r11.y, r11.w, l(-0.330299)
 135:   mad r11.y, r11.y, r11.w, l(0.999866)
 136:   mul r11.w, r10.w, r11.y
 137:   lt r12.y, abs(v0.y), r5.z
 138:   mad r11.w, r11.w, l(-2.000000), l(1.570796)
 139:   and r11.w, r12.y, r11.w
 140:   mad r10.w, r10.w, r11.y, r11.w
 141:   lt r11.y, v0.y, -v0.y
 142:   and r11.y, r11.y, l(-3.141593)
 143:   add r10.w, r10.w, r11.y
 144:   min r11.y, r5.z, v0.y
 145:   max r5.z, r5.z, v0.y
 146:   lt r11.y, r11.y, -r11.y
 147:   ge r5.z, r5.z, -r5.z
 148:   and r5.z, r5.z, r11.y
 149:   movc r5.z, r5.z, -r10.w, r10.w
 150:   sincos null, r5.z, r5.z
 151:   mad r13.y, v0.y, r5.z, -v0.y
 152:   mul r13.xz, r5.zzzz, r10.xxzx
 153:   mov r10.y, l(0)
 154:   movc r10.xyz, g_DisableSuppressExtend.xxxx, r10.xzyx, r13.xzyx
 155: else
 156:   mul r11.yw, r11.xxxz, l(0.000000, 0.300000, 0.000000, 0.300000)
 157:   mul r12.yw, r11.yyyw, g_CompParam3.yyyy
 158:   mul r13.xy, r4.xzxx, l(0.048193, 0.048193, 0.000000, 0.000000)
 159:   mad r12.yw, r12.yyyw, g_CameraVec.wwww, r13.xxxy
 160:   add r12.yw, r12.yyyw, l(0.000000, -0.500000, 0.000000, -0.500000)
 161:   sincos r5.x, r14.x, r5.x
 162:   mov r15.x, -r5.x
 163:   mov r15.y, r14.x
 164:   dp2 r14.x, r12.wyww, r15.xyxx
 165:   mov r15.z, r5.x
 166:   dp2 r14.y, r12.wyww, r15.yzyy
 167:   add r5.xz, r14.xxyx, l(0.500000, 0.000000, 0.500000, 0.000000)
 168:   sample_l(texture2d)(float,float,float,float) r5.x, r5.xzxx, g_WindMaskTexture.yxzw, ModelSampler, l(0)
 169:   mad r12.yw, r4.xxxz, l(0.000000, 0.021786, 0.000000, 0.021786), l(0.000000, 1.050000, 0.000000, 0.450000)
 170:   mad r12.yw, g_CameraVec.wwww, l(0.000000, 0.100000, 0.000000, 0.050000), r12.yyyw
 171:   sample_l(texture2d)(float,float,float,float) r5.z, r12.ywyy, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 172:   mul r5.x, r5.x, r5.z
 173:   mul r12.y, r5.x, l(10.000000)
 174:   mul r13.zw, r12.xxxz, l(0.000000, 0.000000, 0.150000, 0.150000)
 175:   mul r14.xy, r13.zwzz, g_CompParam3.yyyy
 176:   mul r16.xyzw, r4.xzxz, l(0.016461, 0.016461, 0.025000, 0.025000)
 177:   mad r14.xy, r14.xyxx, g_CameraVec.wwww, r16.xyxx
 178:   add r14.xy, r14.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
 179:   sincos r17.x, r18.x, r5.y
 180:   mov r19.x, -r17.x
 181:   mov r19.y, r18.x
 182:   dp2 r18.x, r14.yxyy, r19.xyxx
 183:   mov r19.z, r17.x
 184:   dp2 r18.y, r14.yxyy, r19.yzyy
 185:   add r14.xy, r18.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
 186:   sample_l(texture2d)(float,float,float,float) r5.y, r14.xyxx, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 187:   mad r14.xy, g_CameraVec.wwww, l(0.100000, 0.050000, 0.000000, 0.000000), r16.zwzz
 188:   add r14.xy, r14.xyxx, l(0.500000, 0.250000, 0.000000, 0.000000)
 189:   sample_l(texture2d)(float,float,float,float) r12.w, r14.xyxx, g_WindMaskTexture.xywz, ModelSampler, l(0)
 190:   mul r5.y, r5.y, r12.w
 191:   mul r14.xy, r11.ywyy, g_CompParam4.yyyy
 192:   mad r14.xy, r14.xyxx, g_CameraVec.wwww, r13.xyxx
 193:   add r14.xy, r14.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
 194:   dp2 r17.x, r14.yxyy, r15.xyxx
 195:   dp2 r17.y, r14.yxyy, r15.yzyy
 196:   add r14.xy, r17.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
 197:   sample_l(texture2d)(float,float,float,float) r14.x, r14.xyxx, g_WindMaskTexture.yxzw, ModelSampler, l(0)
 198:   mul r14.x, r5.z, r14.x
 199:   mul r14.x, r14.x, l(10.000000)
 200:   mul r14.yz, r13.zzwz, g_CompParam4.yyyy
 201:   mad r14.yz, r14.yyzy, g_CameraVec.wwww, r16.xxyx
 202:   add r14.yz, r14.yyzy, l(0.000000, -0.500000, -0.500000, 0.000000)
 203:   dp2 r17.x, r14.zyzz, r19.xyxx
 204:   dp2 r17.y, r14.zyzz, r19.yzyy
 205:   add r14.yz, r17.xxyx, l(0.000000, 0.500000, 0.500000, 0.000000)
 206:   sample_l(texture2d)(float,float,float,float) r14.y, r14.yzyy, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 207:   mul r14.y, r12.w, r14.y
 208:   mul r14.y, r14.y, l(10.000000)
 209:   mul r11.yw, r11.yyyw, g_CompParam5.yyyy
 210:   mad r11.yw, r11.yyyw, g_CameraVec.wwww, r13.xxxy
 211:   add r11.yw, r11.yyyw, l(0.000000, -0.500000, 0.000000, -0.500000)
 212:   dp2 r13.x, r11.wyww, r15.xyxx
 213:   dp2 r13.y, r11.wyww, r15.yzyy
 214:   add r11.yw, r13.xxxy, l(0.000000, 0.500000, 0.000000, 0.500000)
 215:   sample_l(texture2d)(float,float,float,float) r11.y, r11.ywyy, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 216:   mul r5.z, r5.z, r11.y
 217:   mul r5.yz, r5.yyzy, l(0.000000, 10.000000, 10.000000, 0.000000)
 218:   mul r11.yw, r13.zzzw, g_CompParam5.yyyy
 219:   mad r11.yw, r11.yyyw, g_CameraVec.wwww, r16.xxxy
 220:   add r11.yw, r11.yyyw, l(0.000000, -0.500000, 0.000000, -0.500000)
 221:   dp2 r13.x, r11.wyww, r19.xyxx
 222:   dp2 r13.y, r11.wyww, r19.yzyy
 223:   add r11.yw, r13.xxxy, l(0.000000, 0.500000, 0.000000, 0.500000)
 224:   sample_l(texture2d)(float,float,float,float) r11.y, r11.ywyy, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 225:   mul r11.y, r11.y, r12.w
 226:   mul r11.y, r11.y, l(10.000000)
 227:   mul r11.w, g_WeightWave.x, g_CompParam2.x
 228:   mul r12.w, r11.w, g_CompParam3.x
 229:   mul r13.x, r11.w, g_CompParam4.x
 230:   mul r11.w, r11.w, g_CompParam5.x
 231:   mul r12.y, r12.w, r12.y
 232:   mul r13.yz, r11.xxzx, r12.yyyy
 233:   mul r12.y, r5.y, r12.w
 234:   mul r12.yw, r12.xxxz, r12.yyyy
 235:   mul r12.yw, r12.yyyw, l(0.000000, -100.000000, 0.000000, -100.000000)
 236:   mad r12.yw, r13.yyyz, l(0.000000, -100.000000, 0.000000, -100.000000), r12.yyyw
 237:   mul r13.y, r13.x, r14.x
 238:   mul r13.yz, r11.xxzx, r13.yyyy
 239:   mul r13.x, r13.x, r14.y
 240:   mul r13.xw, r12.xxxz, r13.xxxx
 241:   mul r13.xw, r13.xxxw, l(-100.000000, 0.000000, 0.000000, -100.000000)
 242:   mad r13.xy, r13.yzyy, l(-100.000000, -100.000000, 0.000000, 0.000000), r13.xwxx
 243:   mul r5.z, r5.z, r11.w
 244:   mul r11.xz, r11.xxzx, r5.zzzz
 245:   mul r5.z, r11.w, r11.y
 246:   mul r11.yw, r12.xxxz, r5.zzzz
 247:   mul r11.yw, r11.yyyw, l(0.000000, -100.000000, 0.000000, -100.000000)
 248:   mad r11.xy, r11.xzxx, l(-100.000000, -100.000000, 0.000000, 0.000000), r11.ywyy
 249:   mul r5.z, g_IdlingSpeedR.x, g_CompParam3.w
 250:   mad r11.zw, g_CameraVec.wwww, r5.zzzz, r4.xxxz
 251:   mul r11.zw, r11.zzzw, l(0.000000, 0.000000, -0.125000, -0.125000)
 252:   sample_l(texture2d)(float,float,float,float) r5.z, r11.zwzz, g_WindMaskTexture.yzxw, ModelSampler, l(0)
 253:   mul r11.z, g_IdlingStrengthR.x, g_CompParam3.z
 254:   mul r11.z, r2.w, r11.z
 255:   mul r5.z, r5.z, r11.z
 256:   mul r5.z, r5.z, l(10.560000)
 257:   log r5.z, abs(r5.z)
 258:   mul r5.z, r5.z, l(1.280000)
 259:   exp r5.z, r5.z
 260:   mad r11.zw, g_CameraVec.wwww, g_CompParam4.wwww, r4.xxxz
 261:   mul r11.zw, r11.zzzw, l(0.000000, 0.000000, -0.125000, -0.125000)
 262:   sample_l(texture2d)(float,float,float,float) r11.z, r11.zwzz, g_WindMaskTexture.yzxw, ModelSampler, l(0)
 263:   mul r11.w, r2.w, g_CompParam4.z
 264:   mul r11.z, r11.z, r11.w
 265:   mul r11.z, r11.z, l(10.560000)
 266:   log r11.z, abs(r11.z)
 267:   mul r11.z, r11.z, l(1.280000)
 268:   exp r11.z, r11.z
 269:   mul r12.xz, cb11[6].zzyz, g_CompParam5.wwzw
 270:   mad r13.zw, g_CameraVec.wwww, r12.xxxx, r4.xxxz
 271:   mul r13.zw, r13.zzzw, l(0.000000, 0.000000, -0.125000, -0.125000)
 272:   sample_l(texture2d)(float,float,float,float) r11.w, r13.zwzz, g_WindMaskTexture.yzwx, ModelSampler, l(0)
 273:   mul r12.x, r2.w, r12.z
 274:   mul r11.w, r11.w, r12.x
 275:   mul r11.w, r11.w, l(10.560000)
 276:   log r11.w, abs(r11.w)
 277:   mul r11.w, r11.w, l(1.280000)
 278:   exp r11.w, r11.w
 279:   sincos r12.x, r14.x, -r1.w
 280:   mov r15.x, -r12.x
 281:   mov r15.y, r14.x
 282:   dp2 r14.x, r5.zzzz, r15.xyxx
 283:   mov r15.z, r12.x
 284:   dp2 r14.z, r5.zzzz, r15.yzyy
 285:   dp2 r12.x, r11.zzzz, r15.xyxx
 286:   dp2 r12.z, r11.zzzz, r15.yzyy
 287:   dp2 r16.x, r11.wwww, r15.xyxx
 288:   dp2 r16.z, r11.wwww, r15.yzyy
 289:   div r1.w, v0.y, r0.w
 290:   movc r1.w, g_HeightFalloffDisable.x, l(1.000000), r1.w
 291:   mad r11.zw, r14.xxxz, g_Weight.xxxx, r12.yyyw
 292:   mul r14.xyz, r1.wwww, v3.xyzx
 293:   mul r11.zw, r11.zzzw, r14.xxxx
 294:   mad r12.xy, r12.xzxx, g_Weight.xxxx, r13.xyxx
 295:   mul r12.xy, r14.yyyy, r12.xyxx
 296:   mul r12.xy, r12.xyxx, l(0.010000, 0.010000, 0.000000, 0.000000)
 297:   mad r11.zw, r11.zzzw, l(0.000000, 0.000000, 0.010000, 0.010000), r12.xxxy
 298:   mad r11.xy, r16.xzxx, g_Weight.xxxx, r11.xyxx
 299:   mul r11.xy, r14.zzzz, r11.xyxx
 300:   mad r11.xz, r11.xxyx, l(0.010000, 0.000000, 0.010000, 0.000000), r11.zzwz
 301:   mad r1.w, r5.x, l(10.000000), r5.y
 302:   mul r4.w, r14.x, r1.w
 303:   dp2 r1.w, r11.xzxx, r11.xzxx
 304:   sqrt r1.w, r1.w
 305:   add r1.w, r1.w, l(0.000000)
 306:   min r5.x, r1.w, abs(v0.y)
 307:   max r5.y, r1.w, abs(v0.y)
 308:   div r5.y, l(1.000000, 1.000000, 1.000000, 1.000000), r5.y
 309:   mul r5.x, r5.y, r5.x
 310:   mul r5.y, r5.x, r5.x
 311:   mad r5.z, r5.y, l(0.020835), l(-0.085133)
 312:   mad r5.z, r5.y, r5.z, l(0.180141)
 313:   mad r5.z, r5.y, r5.z, l(-0.330299)
 314:   mad r5.y, r5.y, r5.z, l(0.999866)
 315:   mul r5.z, r5.y, r5.x
 316:   lt r11.w, abs(v0.y), r1.w
 317:   mad r5.z, r5.z, l(-2.000000), l(1.570796)
 318:   and r5.z, r11.w, r5.z
 319:   mad r5.x, r5.x, r5.y, r5.z
 320:   lt r5.y, v0.y, -v0.y
 321:   and r5.y, r5.y, l(-3.141593)
 322:   add r5.x, r5.y, r5.x
 323:   min r5.y, r1.w, v0.y
 324:   max r1.w, r1.w, v0.y
 325:   lt r5.y, r5.y, -r5.y
 326:   ge r1.w, r1.w, -r1.w
 327:   and r1.w, r1.w, r5.y
 328:   movc r1.w, r1.w, -r5.x, r5.x
 329:   sincos null, r1.w, r1.w
 330:   mad r5.y, v0.y, r1.w, -v0.y
 331:   mul r5.xz, r1.wwww, r11.xxzx
 332:   mov r11.y, l(0)
 333:   movc r10.xyz, g_DisableSuppressExtend.xxxx, r11.xzyx, r5.xzyx
 334: endif
 335: add r10.z, r10.z, l(-0.000000)
 336: dp3 r1.w, r10.xyzx, r10.xyzx
 337: sqrt r1.w, r1.w
 338: mul r2.w, r0.w, r2.w
 339: mul r2.w, r2.w, g_SinkPower.x
 340: div r0.w, v0.y, r0.w
 341: log r0.w, r0.w
 342: add_sat r0.w, r0.w, l(1.000000)
 343: mad r10.w, -r0.w, r2.w, r10.z
 344: dp3 r0.w, r10.xywx, r10.xywx
 345: rsq r0.w, r0.w
 346: mul r5.xyz, r0.wwww, r10.xwyx
 347: mul r10.xyz, r1.wwww, r5.xyzx
 348: mad r11.xyz, r5.xyzx, r1.wwww, r4.xyzx
 349: mov r11.w, l(1.000000)
 350: dp4 r12.x, r11.xyzw, g_View[0].xyzw
 351: dp4 r12.y, r11.xyzw, g_View[1].xyzw
 352: dp4 r12.z, r11.xyzw, g_View[2].xyzw
 353: dp4 r12.w, r11.xyzw, g_View[3].xyzw
 354: dp4 r11.x, r12.xyzw, g_Proj[0].xyzw
 355: dp4 r11.y, r12.xyzw, g_Proj[1].xyzw
 356: dp4 r11.z, r12.xyzw, g_Proj[2].xyzw
 357: dp4 r11.w, r12.xyzw, g_Proj[3].xyzw
 358: dp4 r7.x, r3.xyzw, r7.xyzw
 359: dp4 r7.y, r3.xyzw, r8.xyzw
 360: dp4 r7.z, r3.xyzw, r9.xyzw
 361: dp4 r7.w, r3.xyzw, r6.xyzw
 362: dp3 r3.x, r10.xyzx, g_PrevView[0].xyzx
 363: dp3 r3.y, r10.xyzx, g_PrevView[1].xyzx
 364: dp3 r3.z, r10.xyzx, g_PrevView[2].xyzx
 365: dp3 r3.w, r10.xyzx, g_PrevView[3].xyzx
 366: add r3.xyzw, r3.xyzw, r7.xyzw
 367: dp4 o7.x, r3.xyzw, g_PrevProj[0].xyzw
 368: dp4 o7.y, r3.xyzw, g_PrevProj[1].xyzw
 369: dp4 o7.z, r3.xyzw, g_PrevProj[2].xyzw
 370: dp4 o7.w, r3.xyzw, g_PrevProj[3].xyzw
 371: mul o1.xy, v2.xyxx, g_Tiling.xyxx
 372: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, r5.w, l(0), g_InstanceParam.xxxx
 373: eq r1.w, r0.w, l(0)
 374: if_nz r1.w
 375:   mov r3.x, r0.x
 376:   mov r3.y, r1.x
 377:   mov r3.z, r2.x
 378:   dp3 r5.x, r3.xyzx, g_View[0].xyzx
 379:   dp3 r6.x, r3.xyzx, g_View[1].xyzx
 380:   dp3 r7.x, r3.xyzx, g_View[2].xyzx
 381:   dp3 r3.x, r3.xyzx, g_View[3].xyzx
 382:   mov r8.x, r0.y
 383:   mov r8.y, r1.y
 384:   mov r8.z, r2.y
 385:   dp3 r5.y, r8.xyzx, g_View[0].xyzx
 386:   dp3 r6.y, r8.xyzx, g_View[1].xyzx
 387:   dp3 r7.y, r8.xyzx, g_View[2].xyzx
 388:   dp3 r3.y, r8.xyzx, g_View[3].xyzx
 389:   mov r2.x, r0.z
 390:   mov r2.y, r1.z
 391:   dp3 r5.z, r2.xyzx, g_View[0].xyzx
 392:   dp3 r6.z, r2.xyzx, g_View[1].xyzx
 393:   dp3 r7.z, r2.xyzx, g_View[2].xyzx
 394:   dp3 r3.z, r2.xyzx, g_View[3].xyzx
 395:   dp3 r1.x, v4.xyzx, r5.xyzx
 396:   dp3 r1.y, v4.xyzx, r6.xyzx
 397:   dp3 r1.z, v4.xyzx, r7.xyzx
 398:   dp3 r1.w, v4.xyzx, r3.xyzx
 399:   dp4 r0.x, r1.xyzw, r1.xyzw
 400:   rsq r0.x, r0.x
 401:   mul r0.xyz, r0.xxxx, r1.xyzx
 402: else
 403:   eq r0.w, r0.w, l(1.000000)
 404:   mov r1.x, g_View[0].y
 405:   mov r1.y, g_View[1].y
 406:   mov r1.z, g_View[2].y
 407:   mov r1.w, g_View[3].y
 408:   dp4 r1.w, r1.xyzw, r1.xyzw
 409:   rsq r1.w, r1.w
 410:   mul r1.xyz, r1.wwww, r1.xyzx
 411:   movc r0.xyz, r0.wwww, g_lightVec.xyzx, r1.xyzx
 412:   mov r5.xyz, g_View[0].xyzx
 413:   mov r6.xyz, g_View[1].xyzx
 414:   mov r7.xyz, g_View[2].xyzx
 415:   mov r3.xyz, g_View[3].xyzx
 416: endif
 417: dp3 r1.x, v1.xyzx, r5.xyzx
 418: dp3 r1.y, v1.xyzx, r6.xyzx
 419: dp3 r1.z, v1.xyzx, r7.xyzx
 420: dp3 r1.w, v1.xyzx, r3.xyzx
 421: dp4 r0.w, r1.xyzw, r1.xyzw
 422: rsq r0.w, r0.w
 423: mul r1.xyz, r0.wwww, r1.xyzx
 424: mul r2.xyz, r0.yzxy, r1.zxyz
 425: mad r2.xyz, r1.yzxy, r0.zxyz, -r2.xyzx
 426: mul o5.xyz, r2.xyzx, v1.wwww
 427: mov o0.xyzw, r11.xyzw
 428: mov o1.zw, l(0, 0, 0, 0)
 429: mov o2.xyz, r4.xyzx
 430: mov o2.w, l(1.000000)
 431: mov o3.xyz, r0.xyzx
 432: mov o3.w, l(0)
 433: mov o4.w, v1.w
 434: mov o4.xyz, r1.xyzx
 435: mov o5.w, l(0)
 436: mov o6.xyzw, r11.xyzw
 437: mov o8.xyzw, r4.wwww
 438: mov o9.xyz, v3.xyzx
 439: mov o9.w, g_CompParam6.x
 440: mov o10.x, v5.z
 441: ret
