Shader hash 5df00b7d-7bce0e96-bb69738d-36b0538c

vs_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb11[7] (ParamBuffer), immediateIndexed
      dcl_constantbuffer cb3[7] (ParamComponentBuffer), immediateIndexed
      dcl_constantbuffer cb5[4] (ParamBuffer), immediateIndexed
      dcl_constantbuffer cb1[1] (VS_BaseParamBuffer), immediateIndexed
      dcl_sampler ModelSampler (s0), mode_default
      dcl_resource_texture2d (float,float,float,float) g_WindMaskTexture (t1)
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_resource_structured g_InstanceWorldTbl (t28), 48
      dcl_input v0.xyz
      dcl_input v1.xy
      dcl_input v2.x
      dcl_input v3.xyz
      dcl_input v4.xz
      dcl_output_siv o0.xyzw, position
      dcl_output o1.xy
      dcl_output o2.xyzw
      dcl_output o3.x
      dcl_temps 14
   0: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r0.xyzw, v4.x, l(0), g_InstanceWorldTbl.xyzw
   1: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r1.xyzw, v4.x, l(16), g_InstanceWorldTbl.xyzw
   2: ld_structured_indexable(structured_buffer, stride=48)(mixed,mixed,mixed,mixed) r2.xyzw, v4.x, l(32), g_InstanceWorldTbl.xyzw
   3: mov r3.xyz, v0.xyzx
   4: mov r3.w, l(1.000000)
   5: dp4 r0.x, r3.xyzw, r0.xyzw
   6: dp4 r0.z, r3.xyzw, r2.xyzw
   7: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.w, v4.z, l(0), g_InstanceParam.xxxx
   8: iadd r2.xyz, v4.zzzz, l(3, 4, 5, 0)
   9: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.x, r2.x, l(0), g_InstanceParam.xxxx
  10: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.y, r2.y, l(0), g_InstanceParam.xxxx
  11: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.z, r2.z, l(0), g_InstanceParam.xxxx
  12: mul r2.y, r2.z, r2.y
  13: add r2.x, -r2.x, l(0.785398)
  14: mad r2.zw, g_CompParam7.xxxx, l(0.000000, 0.000000, 0.017444, -0.017444), r2.xxxx
  15: sincos r4.x, r5.x, -r2.z
  16: mov r6.x, -r4.x
  17: mov r6.y, r5.x
  18: dp2 r5.x, l(-1.000000, -1.000000, 0.000000, 0.000000), r6.xyxx
  19: mov r6.z, r4.x
  20: dp2 r5.z, l(-1.000000, -1.000000, 0.000000, 0.000000), r6.yzyy
  21: sincos r4.x, r6.x, -r2.w
  22: mov r7.x, -r4.x
  23: mov r7.y, r6.x
  24: dp2 r6.x, l(-1.000000, -1.000000, 0.000000, 0.000000), r7.xyxx
  25: mov r7.z, r4.x
  26: dp2 r6.z, l(-1.000000, -1.000000, 0.000000, 0.000000), r7.yzyy
  27: add r2.zw, r2.zzzw, l(0.000000, 0.000000, 0.785000, 0.785000)
  28: eq r4.x, l(0), g_CompParam6.y
  29: if_nz r4.x
  30:   mul r4.xy, r5.xzxx, g_CompParam2.yyyy
  31:   mul r4.xy, r4.xyxx, g_CameraVec.wwww
  32:   mul r4.zw, r0.xxxz, l(0.000000, 0.000000, 0.048193, 0.048193)
  33:   mad r4.xy, r4.xyxx, l(0.300000, 0.300000, 0.000000, 0.000000), r4.zwzz
  34:   add r4.xy, r4.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
  35:   sincos r7.x, r8.x, r2.z
  36:   mov r9.x, -r7.x
  37:   mov r9.y, r8.x
  38:   dp2 r8.x, r4.yxyy, r9.xyxx
  39:   mov r9.z, r7.x
  40:   dp2 r8.y, r4.yxyy, r9.yzyy
  41:   add r4.xy, r8.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  42:   sample_l(texture2d)(float,float,float,float) r4.x, r4.xyxx, g_WindMaskTexture.yxzw, ModelSampler, l(0)
  43:   mad r4.yz, r0.xxzx, l(0.000000, 0.021786, 0.021786, 0.000000), l(0.000000, 1.050000, 0.450000, 0.000000)
  44:   mad r4.yz, g_CameraVec.wwww, l(0.000000, 0.100000, 0.050000, 0.000000), r4.yyzy
  45:   sample_l(texture2d)(float,float,float,float) r4.y, r4.yzyy, g_WindMaskTexture.xzyw, ModelSampler, l(0)
  46:   mul r4.x, r4.x, r4.y
  47:   mul r4.x, r4.x, l(10.000000)
  48:   mul r4.yz, r6.xxzx, g_CompParam2.yyyy
  49:   mul r4.yz, r4.yyzy, g_CameraVec.wwww
  50:   mul r7.xyzw, r0.xzxz, l(0.016461, 0.016461, 0.025000, 0.025000)
  51:   mad r4.yz, r4.yyzy, l(0.000000, 0.150000, 0.150000, 0.000000), r7.xxyx
  52:   add r4.yz, r4.yyzy, l(0.000000, -0.500000, -0.500000, 0.000000)
  53:   sincos r7.x, r8.x, r2.w
  54:   mov r9.x, -r7.x
  55:   mov r9.y, r8.x
  56:   dp2 r8.x, r4.zyzz, r9.xyxx
  57:   mov r9.z, r7.x
  58:   dp2 r8.y, r4.zyzz, r9.yzyy
  59:   add r4.yz, r8.xxyx, l(0.000000, 0.500000, 0.500000, 0.000000)
  60:   sample_l(texture2d)(float,float,float,float) r4.y, r4.yzyy, g_WindMaskTexture.xyzw, ModelSampler, l(0)
  61:   mad r4.zw, g_CameraVec.wwww, l(0.000000, 0.000000, 0.100000, 0.050000), r7.zzzw
  62:   add r4.zw, r4.zzzw, l(0.000000, 0.000000, 0.500000, 0.250000)
  63:   sample_l(texture2d)(float,float,float,float) r4.z, r4.zwzz, g_WindMaskTexture.xyzw, ModelSampler, l(0)
  64:   mul r4.y, r4.y, r4.z
  65:   mul r4.y, r4.y, l(10.000000)
  66:   mul r4.z, tmp_ShadowViewProj[3].w, g_CompParam2.x
  67:   mul r4.z, r2.y, r4.z
  68:   mul r4.xy, r4.zzzz, r4.xyxx
  69:   mul r4.xw, r5.xxxz, r4.xxxx
  70:   mul r4.yz, r6.xxzx, r4.yyyy
  71:   mul r4.yz, r4.yyzy, l(0.000000, -100.000000, -100.000000, 0.000000)
  72:   mad r4.xy, r4.xwxx, l(-100.000000, -100.000000, 0.000000, 0.000000), r4.yzyy
  73:   mad r4.zw, g_CameraVec.wwww, g_CompParam2.wwww, r0.xxxz
  74:   mul r4.zw, r4.zzzw, l(0.000000, 0.000000, -0.125000, -0.125000)
  75:   sample_l(texture2d)(float,float,float,float) r4.z, r4.zwzz, g_WindMaskTexture.yzxw, ModelSampler, l(0)
  76:   mul r4.w, r2.y, g_CompParam2.z
  77:   mul r4.z, r4.z, r4.w
  78:   mul r4.z, r4.z, l(10.560000)
  79:   log r4.z, abs(r4.z)
  80:   mul r4.z, r4.z, l(1.280000)
  81:   exp r4.z, r4.z
  82:   sincos r7.x, r8.x, -r2.x
  83:   mov r9.x, -r7.x
  84:   mov r9.y, r8.x
  85:   dp2 r8.x, r4.zzzz, r9.xyxx
  86:   mov r9.z, r7.x
  87:   dp2 r8.z, r4.zzzz, r9.yzyy
  88:   mad r4.xy, r8.xzxx, tmp_ShadowViewProj[3].zzzz, r4.xyxx
  89:   mul r4.xy, r4.xyxx, v3.zzzz
  90:   mul r4.xz, r4.xxyx, l(0.010000, 0.000000, 0.010000, 0.000000)
  91:   dp2 r4.w, r4.xzxx, r4.xzxx
  92:   sqrt r4.w, r4.w
  93:   add r4.w, r4.w, l(0.000000)
  94:   min r5.y, r4.w, abs(v0.y)
  95:   max r5.w, r4.w, abs(v0.y)
  96:   div r5.w, l(1.000000, 1.000000, 1.000000, 1.000000), r5.w
  97:   mul r5.y, r5.w, r5.y
  98:   mul r5.w, r5.y, r5.y
  99:   mad r6.y, r5.w, l(0.020835), l(-0.085133)
 100:   mad r6.y, r5.w, r6.y, l(0.180141)
 101:   mad r6.y, r5.w, r6.y, l(-0.330299)
 102:   mad r5.w, r5.w, r6.y, l(0.999866)
 103:   mul r6.y, r5.w, r5.y
 104:   lt r6.w, abs(v0.y), r4.w
 105:   mad r6.y, r6.y, l(-2.000000), l(1.570796)
 106:   and r6.y, r6.w, r6.y
 107:   mad r5.y, r5.y, r5.w, r6.y
 108:   lt r5.w, v0.y, -v0.y
 109:   and r5.w, r5.w, l(-3.141593)
 110:   add r5.y, r5.w, r5.y
 111:   min r5.w, r4.w, v0.y
 112:   max r4.w, r4.w, v0.y
 113:   lt r5.w, r5.w, -r5.w
 114:   ge r4.w, r4.w, -r4.w
 115:   and r4.w, r4.w, r5.w
 116:   movc r4.w, r4.w, -r5.y, r5.y
 117:   sincos null, r4.w, r4.w
 118:   mad r7.y, v0.y, r4.w, -v0.y
 119:   mul r7.xz, r4.wwww, r4.xxzx
 120:   mov r4.y, l(0)
 121:   movc r4.xyz, tmp_ShadowView[0].zzzz, r4.xzyx, r7.xzyx
 122: else
 123:   mad r5.yw, v2.xxxx, g_CompParam6.zzzz, r0.xxxz
 124:   mul r6.yw, r5.xxxz, l(0.000000, 0.300000, 0.000000, 0.300000)
 125:   mul r7.xy, r6.ywyy, g_CompParam3.yyyy
 126:   mul r7.zw, r5.yyyw, l(0.000000, 0.000000, 0.048193, 0.048193)
 127:   mad r7.xy, r7.xyxx, g_CameraVec.wwww, r7.zwzz
 128:   add r7.xy, r7.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
 129:   sincos r8.x, r9.x, r2.z
 130:   mov r10.x, -r8.x
 131:   mov r10.y, r9.x
 132:   dp2 r9.x, r7.yxyy, r10.xyxx
 133:   mov r10.z, r8.x
 134:   dp2 r9.y, r7.yxyy, r10.yzyy
 135:   add r7.xy, r9.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
 136:   sample_l(texture2d)(float,float,float,float) r2.z, r7.xyxx, g_WindMaskTexture.xzyw, ModelSampler, l(0)
 137:   mad r7.xy, r5.ywyy, l(0.021786, 0.021786, 0.000000, 0.000000), l(1.050000, 0.450000, 0.000000, 0.000000)
 138:   mad r7.xy, g_CameraVec.wwww, l(0.100000, 0.050000, 0.000000, 0.000000), r7.xyxx
 139:   sample_l(texture2d)(float,float,float,float) r7.x, r7.xyxx, g_WindMaskTexture.zxyw, ModelSampler, l(0)
 140:   mul r2.z, r2.z, r7.x
 141:   mul r2.z, r2.z, l(10.000000)
 142:   mul r8.xy, r6.xzxx, l(0.150000, 0.150000, 0.000000, 0.000000)
 143:   mul r8.zw, r8.xxxy, g_CompParam3.yyyy
 144:   mul r9.xyzw, r5.ywyw, l(0.016461, 0.016461, 0.025000, 0.025000)
 145:   mad r8.zw, r8.zzzw, g_CameraVec.wwww, r9.xxxy
 146:   add r8.zw, r8.zzzw, l(0.000000, 0.000000, -0.500000, -0.500000)
 147:   sincos r11.x, r12.x, r2.w
 148:   mov r13.x, -r11.x
 149:   mov r13.y, r12.x
 150:   dp2 r12.x, r8.wzww, r13.xyxx
 151:   mov r13.z, r11.x
 152:   dp2 r12.y, r8.wzww, r13.yzyy
 153:   add r8.zw, r12.xxxy, l(0.000000, 0.000000, 0.500000, 0.500000)
 154:   sample_l(texture2d)(float,float,float,float) r2.w, r8.zwzz, g_WindMaskTexture.xzwy, ModelSampler, l(0)
 155:   mad r8.zw, g_CameraVec.wwww, l(0.000000, 0.000000, 0.100000, 0.050000), r9.zzzw
 156:   add r8.zw, r8.zzzw, l(0.000000, 0.000000, 0.500000, 0.250000)
 157:   sample_l(texture2d)(float,float,float,float) r7.y, r8.zwzz, g_WindMaskTexture.xzyw, ModelSampler, l(0)
 158:   mul r2.w, r2.w, r7.y
 159:   mul r2.w, r2.w, l(10.000000)
 160:   mul r8.zw, r6.yyyw, g_CompParam4.yyyy
 161:   mad r8.zw, r8.zzzw, g_CameraVec.wwww, r7.zzzw
 162:   add r8.zw, r8.zzzw, l(0.000000, 0.000000, -0.500000, -0.500000)
 163:   dp2 r11.x, r8.wzww, r10.xyxx
 164:   dp2 r11.y, r8.wzww, r10.yzyy
 165:   add r8.zw, r11.xxxy, l(0.000000, 0.000000, 0.500000, 0.500000)
 166:   sample_l(texture2d)(float,float,float,float) r8.z, r8.zwzz, g_WindMaskTexture.xzyw, ModelSampler, l(0)
 167:   mul r8.z, r7.x, r8.z
 168:   mul r8.z, r8.z, l(10.000000)
 169:   mul r9.zw, r8.xxxy, g_CompParam4.yyyy
 170:   mad r9.zw, r9.zzzw, g_CameraVec.wwww, r9.xxxy
 171:   add r9.zw, r9.zzzw, l(0.000000, 0.000000, -0.500000, -0.500000)
 172:   dp2 r11.x, r9.wzww, r13.xyxx
 173:   dp2 r11.y, r9.wzww, r13.yzyy
 174:   add r9.zw, r11.xxxy, l(0.000000, 0.000000, 0.500000, 0.500000)
 175:   sample_l(texture2d)(float,float,float,float) r8.w, r9.zwzz, g_WindMaskTexture.xzwy, ModelSampler, l(0)
 176:   mul r8.w, r7.y, r8.w
 177:   mul r8.w, r8.w, l(10.000000)
 178:   mul r6.yw, r6.yyyw, g_CompParam5.yyyy
 179:   mad r6.yw, r6.yyyw, g_CameraVec.wwww, r7.zzzw
 180:   add r6.yw, r6.yyyw, l(0.000000, -0.500000, 0.000000, -0.500000)
 181:   dp2 r11.x, r6.wyww, r10.xyxx
 182:   dp2 r11.y, r6.wyww, r10.yzyy
 183:   add r6.yw, r11.xxxy, l(0.000000, 0.500000, 0.000000, 0.500000)
 184:   sample_l(texture2d)(float,float,float,float) r6.y, r6.ywyy, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 185:   mul r6.y, r6.y, r7.x
 186:   mul r6.y, r6.y, l(10.000000)
 187:   mul r7.xz, r8.xxyx, g_CompParam5.yyyy
 188:   mad r7.xz, r7.xxzx, g_CameraVec.wwww, r9.xxyx
 189:   add r7.xz, r7.xxzx, l(-0.500000, 0.000000, -0.500000, 0.000000)
 190:   dp2 r8.x, r7.zxzz, r13.xyxx
 191:   dp2 r8.y, r7.zxzz, r13.yzyy
 192:   add r7.xz, r8.xxyx, l(0.500000, 0.000000, 0.500000, 0.000000)
 193:   sample_l(texture2d)(float,float,float,float) r6.w, r7.xzxx, g_WindMaskTexture.xzwy, ModelSampler, l(0)
 194:   mul r6.w, r6.w, r7.y
 195:   mul r6.w, r6.w, l(10.000000)
 196:   mul r7.x, tmp_ShadowViewProj[3].w, g_CompParam2.x
 197:   mul r7.y, r7.x, g_CompParam3.x
 198:   mul r7.z, r7.x, g_CompParam4.x
 199:   mul r7.x, r7.x, g_CompParam5.x
 200:   mul r2.z, r2.z, r7.y
 201:   mul r8.xy, r5.xzxx, r2.zzzz
 202:   mul r2.z, r2.w, r7.y
 203:   mul r2.zw, r6.xxxz, r2.zzzz
 204:   mul r2.zw, r2.zzzw, l(0.000000, 0.000000, -100.000000, -100.000000)
 205:   mad r2.zw, r8.xxxy, l(0.000000, 0.000000, -100.000000, -100.000000), r2.zzzw
 206:   mul r7.y, r7.z, r8.z
 207:   mul r7.yw, r5.xxxz, r7.yyyy
 208:   mul r7.z, r7.z, r8.w
 209:   mul r8.xy, r6.xzxx, r7.zzzz
 210:   mul r8.xy, r8.xyxx, l(-100.000000, -100.000000, 0.000000, 0.000000)
 211:   mad r7.yz, r7.yywy, l(0.000000, -100.000000, -100.000000, 0.000000), r8.xxyx
 212:   mul r6.y, r6.y, r7.x
 213:   mul r5.xz, r5.xxzx, r6.yyyy
 214:   mul r6.y, r6.w, r7.x
 215:   mul r6.xy, r6.xzxx, r6.yyyy
 216:   mul r6.xy, r6.xyxx, l(-100.000000, -100.000000, 0.000000, 0.000000)
 217:   mad r5.xz, r5.xxzx, l(-100.000000, 0.000000, -100.000000, 0.000000), r6.xxyx
 218:   mul r6.x, tmp_ShadowView[2].x, g_CompParam3.w
 219:   mad r6.xy, g_CameraVec.wwww, r6.xxxx, r5.ywyy
 220:   mul r6.xy, r6.xyxx, l(-0.125000, -0.125000, 0.000000, 0.000000)
 221:   sample_l(texture2d)(float,float,float,float) r6.x, r6.xyxx, g_WindMaskTexture.xyzw, ModelSampler, l(0)
 222:   mul r6.y, tmp_ShadowView[1].w, g_CompParam3.z
 223:   mul r6.y, r2.y, r6.y
 224:   mul r6.x, r6.x, r6.y
 225:   mul r6.x, r6.x, l(10.560000)
 226:   log r6.x, abs(r6.x)
 227:   mul r6.x, r6.x, l(1.280000)
 228:   exp r6.x, r6.x
 229:   mad r6.yz, g_CameraVec.wwww, g_CompParam4.wwww, r5.yywy
 230:   mul r6.yz, r6.yyzy, l(0.000000, -0.125000, -0.125000, 0.000000)
 231:   sample_l(texture2d)(float,float,float,float) r6.y, r6.yzyy, g_WindMaskTexture.yxzw, ModelSampler, l(0)
 232:   mul r6.z, r2.y, g_CompParam4.z
 233:   mul r6.y, r6.y, r6.z
 234:   mul r6.y, r6.y, l(10.560000)
 235:   log r6.y, abs(r6.y)
 236:   mul r6.y, r6.y, l(1.280000)
 237:   exp r6.y, r6.y
 238:   mul r6.zw, tmp_ShadowView[2].zzzy, g_CompParam5.wwwz
 239:   mad r5.yw, g_CameraVec.wwww, r6.zzzz, r5.yyyw
 240:   mul r5.yw, r5.yyyw, l(0.000000, -0.125000, 0.000000, -0.125000)
 241:   sample_l(texture2d)(float,float,float,float) r5.y, r5.ywyy, g_WindMaskTexture.yxzw, ModelSampler, l(0)
 242:   mul r5.w, r2.y, r6.w
 243:   mul r5.y, r5.y, r5.w
 244:   mul r5.y, r5.y, l(10.560000)
 245:   log r5.y, abs(r5.y)
 246:   mul r5.y, r5.y, l(1.280000)
 247:   exp r5.y, r5.y
 248:   sincos r2.x, r7.x, -r2.x
 249:   mov r8.x, -r2.x
 250:   mov r8.y, r7.x
 251:   dp2 r9.x, r6.xxxx, r8.xyxx
 252:   mov r8.z, r2.x
 253:   dp2 r9.z, r6.xxxx, r8.yzyy
 254:   dp2 r6.x, r6.yyyy, r8.xyxx
 255:   dp2 r6.z, r6.yyyy, r8.yzyy
 256:   dp2 r10.x, r5.yyyy, r8.xyxx
 257:   dp2 r10.z, r5.yyyy, r8.yzyy
 258:   div r2.x, v0.y, r0.w
 259:   movc r2.x, tmp_ShadowView[0].w, l(1.000000), r2.x
 260:   mad r2.zw, r9.xxxz, tmp_ShadowViewProj[3].zzzz, r2.zzzw
 261:   mul r8.xyz, r2.xxxx, v3.xyzx
 262:   mul r2.xz, r2.zzwz, r8.xxxx
 263:   mad r5.yw, r6.xxxz, tmp_ShadowViewProj[3].zzzz, r7.yyyz
 264:   mul r5.yw, r8.yyyy, r5.yyyw
 265:   mul r5.yw, r5.yyyw, l(0.000000, 0.010000, 0.000000, 0.010000)
 266:   mad r2.xz, r2.xxzx, l(0.010000, 0.000000, 0.010000, 0.000000), r5.yywy
 267:   mad r5.xy, r10.xzxx, tmp_ShadowViewProj[3].zzzz, r5.xzxx
 268:   mul r5.xy, r8.zzzz, r5.xyxx
 269:   mad r5.xz, r5.xxyx, l(0.010000, 0.000000, 0.010000, 0.000000), r2.xxzx
 270:   dp2 r2.x, r5.xzxx, r5.xzxx
 271:   sqrt r2.x, r2.x
 272:   add r2.x, r2.x, l(0.000000)
 273:   min r2.z, r2.x, abs(v0.y)
 274:   max r2.w, r2.x, abs(v0.y)
 275:   div r2.w, l(1.000000, 1.000000, 1.000000, 1.000000), r2.w
 276:   mul r2.z, r2.w, r2.z
 277:   mul r2.w, r2.z, r2.z
 278:   mad r5.w, r2.w, l(0.020835), l(-0.085133)
 279:   mad r5.w, r2.w, r5.w, l(0.180141)
 280:   mad r5.w, r2.w, r5.w, l(-0.330299)
 281:   mad r2.w, r2.w, r5.w, l(0.999866)
 282:   mul r5.w, r2.w, r2.z
 283:   lt r6.x, abs(v0.y), r2.x
 284:   mad r5.w, r5.w, l(-2.000000), l(1.570796)
 285:   and r5.w, r6.x, r5.w
 286:   mad r2.z, r2.z, r2.w, r5.w
 287:   lt r2.w, v0.y, -v0.y
 288:   and r2.w, r2.w, l(-3.141593)
 289:   add r2.z, r2.w, r2.z
 290:   min r2.w, r2.x, v0.y
 291:   max r2.x, r2.x, v0.y
 292:   lt r2.w, r2.w, -r2.w
 293:   ge r2.x, r2.x, -r2.x
 294:   and r2.x, r2.x, r2.w
 295:   movc r2.x, r2.x, -r2.z, r2.z
 296:   sincos null, r2.x, r2.x
 297:   mad r6.y, v0.y, r2.x, -v0.y
 298:   mul r6.xz, r2.xxxx, r5.xxzx
 299:   mov r5.y, l(0)
 300:   movc r4.xyz, tmp_ShadowView[0].zzzz, r5.xzyx, r6.xzyx
 301: endif
 302: add r4.z, r4.z, l(-0.000000)
 303: dp3 r2.x, r4.xyzx, r4.xyzx
 304: sqrt r2.x, r2.x
 305: mul r2.y, r0.w, r2.y
 306: mul r2.y, r2.y, tmp_ShadowView[2].w
 307: div r0.w, v0.y, r0.w
 308: log r0.w, r0.w
 309: add_sat r0.w, r0.w, l(1.000000)
 310: mad r4.w, -r0.w, r2.y, r4.z
 311: dp3 r0.w, r4.xywx, r4.xywx
 312: rsq r0.w, r0.w
 313: mul r2.yzw, r0.wwww, r4.xxwy
 314: dp4 r0.y, r3.xyzw, r1.xyzw
 315: mad r0.xyz, r2.yzwy, r2.xxxx, r0.xyzx
 316: mov r0.w, l(1.000000)
 317: dp4 r1.x, r0.xyzw, cb5[0].xyzw
 318: dp4 r1.y, r0.xyzw, cb5[1].xyzw
 319: dp4 r1.z, r0.xyzw, cb5[2].xyzw
 320: dp4 r1.w, r0.xyzw, cb5[3].xyzw
 321: mul o1.xy, v1.xyxx, g_Tiling.xyxx
 322: mov o0.xyzw, r1.xyzw
 323: mov o2.xyzw, r1.xyzw
 324: mov o3.x, v4.z
 325: ret
