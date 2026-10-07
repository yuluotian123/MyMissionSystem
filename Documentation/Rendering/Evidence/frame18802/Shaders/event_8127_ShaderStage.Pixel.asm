Shader hash 183bc811-0a22d45d-dc11d2f5-8e097cac

ps_5_0
      dcl_globalFlags refactoringAllowed
      dcl_constantbuffer cb0[33] (SceneBuffer), immediateIndexed
      dcl_constantbuffer cb13[2] (CamParam_HPixel_Buffer), immediateIndexed
      dcl_constantbuffer cb11[3] (ParamBuffer), immediateIndexed
      dcl_resource_structured g_InstanceParam (t27), 4
      dcl_input_ps linear v1.xy
      dcl_input_ps linear v2.w
      dcl_input_ps linear v3.xyz
      dcl_input_ps linear v4.xyz
      dcl_input_ps linear v7.xyw
      dcl_input_ps linear v8.xyw
      dcl_input_ps linear v9.x
      dcl_input_ps nointerpolation v11.x
      dcl_output o0.xyzw
      dcl_output o1.xyzw
      dcl_output o2.xyzw
      dcl_output o3.xy
      dcl_temps 4
   0: mad r0.x, v1.y, l(-0.300000), l(0.800000)
   1: add r0.y, -r0.x, l(1.000000)
   2: add_sat r0.x, -r0.x, v2.w
   3: div r0.y, l(1.000000, 1.000000, 1.000000, 1.000000), r0.y
   4: mul_sat r0.x, r0.y, r0.x
   5: iadd r1.xyzw, v11.xxxx, l(7, 8, 9, 10)
   6: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.y, r1.z, l(0), g_InstanceParam.xxxx
   7: and r0.z, r0.y, l(255)
   8: ubfe r0.yw, l(0, 8, 0, 8), l(0, 8, 0, 16), r0.yyyy
   9: utof r0.yw, r0.yyyw
  10: mul r2.yz, r0.yywy, l(0.000000, 0.003922, 0.003922, 0.000000)
  11: utof r0.y, r0.z
  12: mul r2.x, r0.y, l(0.003922)
  13: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r0.y, r1.y, l(0), g_InstanceParam.xxxx
  14: and r0.z, r0.y, l(255)
  15: utof r0.z, r0.z
  16: mul r3.x, r0.z, l(0.003922)
  17: ubfe r0.zw, l(0, 0, 8, 8), l(0, 0, 8, 16), r0.yyyy
  18: ushr r0.y, r0.y, l(24)
  19: utof r0.yzw, r0.yyzw
  20: mul r0.y, r0.y, l(0.003922)
  21: mul r3.yz, r0.zzwz, l(0.000000, 0.003922, 0.003922, 0.000000)
  22: add r2.xyz, r2.xyzx, -r3.xyzx
  23: mad r0.xzw, r0.xxxx, r2.xxyz, r3.xxyz
  24: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.y, r1.w, l(0), g_InstanceParam.xxxx
  25: ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.x, r1.x, l(0), g_InstanceParam.xxxx
  26: and r1.z, r1.y, l(255)
  27: ubfe r1.yw, l(0, 8, 0, 8), l(0, 8, 0, 16), r1.yyyy
  28: utof r1.yw, r1.yyyw
  29: mul r2.yz, r1.yywy, l(0.000000, 0.003922, 0.003922, 0.000000)
  30: utof r1.y, r1.z
  31: mul r2.x, r1.y, l(0.003922)
  32: add r1.yzw, -r0.xxzw, r2.xxyz
  33: div r2.x, l(1.000000, 1.000000, 1.000000, 1.000000), v1.x
  34: mad r2.x, -v2.w, r2.x, l(1.000000)
  35: max r2.x, r2.x, l(0)
  36: mad r0.xzw, r2.xxxx, r1.yyzw, r0.xxzw
  37: mad r1.yzw, g_Param2.xxyz, g_Param2.wwww, -r0.xxzw
  38: add r2.xyz, -v3.xyzx, g_CameraVec.xyzx
  39: dp3 r2.x, r2.xyzx, r2.xyzx
  40: sqrt r2.z, r2.x
  41: rsq r2.x, r2.x
  42: mul_sat r2.x, r2.x, r2.y
  43: add r2.y, r2.z, l(-16.000000)
  44: mul_sat r2.y, r2.y, l(0.029412)
  45: mad r2.z, r2.y, l(-2.000000), l(3.000000)
  46: mul r2.y, r2.y, r2.y
  47: mad_sat r0.y, r2.z, r2.y, -r0.y
  48: mad r1.yzw, r0.yyyy, r1.yyzw, r0.xxzw
  49: add r0.xyz, r0.xzwx, -r1.yzwy
  50: mad r0.xyz, r2.xxxx, r0.xyzx, r1.yzwy
  51: mul r1.yzw, r0.xxyz, g_Param3.xxyz
  52: mad r1.yzw, r1.yyzw, g_Param3.wwww, -r0.xxyz
  53: mad r0.xyz, v9.xxxx, r1.yzwy, r0.xyzx
  54: add r1.yzw, r0.xxyz, l(0.000000, 0.055000, 0.055000, 0.055000)
  55: mul r1.yzw, r1.yyzw, l(0.000000, 0.947867, 0.947867, 0.947867)
  56: log r1.yzw, abs(r1.yyzw)
  57: mul r1.yzw, r1.yyzw, l(0.000000, 2.400000, 2.400000, 2.400000)
  58: exp r1.yzw, r1.yyzw
  59: ge r2.xyz, l(0.039280, 0.039280, 0.039280, 0.000000), r0.xyzx
  60: mul r0.xyz, r0.xyzx, l(0.077399, 0.077399, 0.077399, 0.000000)
  61: movc r0.xyz, r2.xyzx, r0.xyzx, r1.yzwy
  62: and r0.w, r1.x, l(255)
  63: ubfe r1.xy, l(8, 8, 0, 0), l(8, 16, 0, 0), r1.xxxx
  64: utof r1.xy, r1.xyxx
  65: mul r1.yz, r1.xxyx, l(0.000000, 0.003922, 0.003922, 0.000000)
  66: utof r0.w, r0.w
  67: mul r1.x, r0.w, l(0.003922)
  68: mul o0.xyz, r0.xyzx, r1.xyzx
  69: mov o0.w, l(0)
  70: mov o1.xyzw, l(0.000000, 1.000000, 1.000000, 0.000000)
  71: lt r0.x, l(0.500000), g_Param1.x
  72: movc r0.xyz, r0.xxxx, abs(v4.xyzx), v4.xyzx
  73: mad o2.xyz, r0.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
  74: mov o2.w, l(0)
  75: div r0.xy, v7.xyxx, v7.wwww
  76: add r0.xy, r0.xyxx, g_ProjectionOffset.xyxx
  77: add r0.xy, r0.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
  78: mul r0.x, r0.x, l(0.500000)
  79: mad r0.z, -r0.y, l(0.500000), l(1.000000)
  80: div r0.yw, v8.xxxy, v8.wwww
  81: add r0.yw, r0.yyyw, g_ProjectionOffset.zzzw
  82: add r0.yw, r0.yyyw, l(0.000000, 1.000000, 0.000000, 1.000000)
  83: mul r1.x, r0.y, l(0.500000)
  84: mad r1.z, -r0.w, l(0.500000), l(1.000000)
  85: add o3.xy, r0.xzxx, -r1.xzxx
  86: ret
