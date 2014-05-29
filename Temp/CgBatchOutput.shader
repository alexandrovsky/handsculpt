//http://answers.unity3d.com/questions/229829/shader-based-on-surface-distance-from-center-.html

Shader "Custom/TestSurfaceShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "green" {}
		_Brush1Pos ("Brush1Pos", Vector) = (0,0,0,0)
		_Brush1ColorSelectedLow ("Brush1ColorSelectedLow", Color) = (0,0,0,0)
		_Brush1ColorSelectedHigh ("Brush1ColorSelectedHigh", Color) = (0,0,0,0)
		_Brush1DirtyColor ("Brush1DirtyColor", Color) = (0,0,0,0)
		
		_Brush1Radius ("Brush1Radius", float) = 0.5
		_Brush1ActivationFlag ("Brush1ActivationFlag", int) = 0
		_Brush1ActivationState ("Brush1ActivationState", float) = 0.0 // the range between [0,1] 0 : Clear; 1 : Activated
		
		//
		_Brush2Pos ("Brush2Pos", Vector) = (0,0,0,0)
		_Brush2ColorSelectedLow ("Brush2ColorSelectedLow", Color) = (0,0,0,0)
		_Brush2ColorSelectedHigh ("Brush2ColorSelectedHigh", Color) = (0,0,0,0)
		_Brush2DirtyColor ("Brush2DirtyColor", Color) = (0,0,0,0)
		
		_Brush2Radius ("Brush2Radius", float) = 0.5
		_Brush2ActivationFlag ("Brush2ActivationFlag", int) = 0
		_Brush2ActivationState ("Brush2ActivationState", float) = 0.0
		
	}
	SubShader {

	//transparency:
	//Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
    //Blend SrcAlpha OneMinusSrcAlpha
    //Cull Off
    //LOD 200

	
	//Tags { "RenderType"="Opaque" }
	Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	LOD 200
		
			
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 12
//   opengl - ALU: 8 to 65
//   d3d9 - ALU: 8 to 65
//   d3d11 - ALU: 9 to 46, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 9 to 46, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 5 [_Object2World]
Vector 16 [unity_Scale]
"!!ARBvp1.0
# 29 ALU
PARAM c[17] = { { 1 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[16].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[14];
DP4 R3.y, R1, c[13];
DP4 R3.x, R1, c[12];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[15];
ADD R2.xyz, R2, R3;
ADD result.texcoord[2].xyz, R2, R1;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Matrix 4 [_Object2World]
Vector 15 [unity_Scale]
"vs_2_0
; 29 ALU
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c15.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c16.x
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c13
dp4 r3.y, r1, c12
dp4 r3.x, r1, c11
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c14
add r2.xyz, r2, r3
add oT2.xyz, r2, r1
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityLighting" 0
BindCB "UnityPerDraw" 1
// 26 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedenghbmgekpcdoihkbhogancpohcnbghbabaaaaaafaafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
mmadaaaaeaaaabaapdaaaaaafjaaaaaeegiocaaaaaaaaaaacnaaaaaafjaaaaae
egiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaabaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
abaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaaaaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaaaaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaaaaaaaaaciaaaaaa
egaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaaaaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaaaaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaaaaaaaaaclaaaaaaegaobaaa
acaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaaaaaaaaacmaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 c_16;
  c_16.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_16.w = tmpvar_3;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 c_16;
  c_16.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_16.w = tmpvar_3;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Matrix 4 [_Object2World]
Vector 15 [unity_Scale]
"agal_vs
c16 1.0 0.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaapaaaappabaaaaaa mul r1.xyz, a1, c15.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaabacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c4
aaaaaaaaaaaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.w
aaaaaaaaaaaaaeacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacbaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c16.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r0, c10
bdaaaaaaacaaacacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r0, c9
bdaaaaaaacaaabacaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r0, c8
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
bdaaaaaaadaaaeacabaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r3.z, r1, c13
bdaaaaaaadaaacacabaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r3.y, r1, c12
bdaaaaaaadaaabacabaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 r3.x, r1, c11
adaaaaaaaeaaacacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r4.y, r0.x, r0.x
acaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaffacaaaaaa sub r0.y, r4.y, r0.y
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r0.x
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityLighting" 0
BindCB "UnityPerDraw" 1
// 26 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefieceddgknbcnjniambnjkdaafkknhhiijehdgabaaaaaalmahaaaaaeaaaaaa
daaaaaaajiacaaaagmagaaaadeahaaaaebgpgodjgaacaaaagaacaaaaaaacpopp
aiacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaacgaa
ahaaabaaaaaaaaaaabaaaaaaaeaaaiaaaaaaaaaaabaaamaaaeaaamaaaaaaaaaa
abaabeaaabaabaaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafbbaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjaafaaaaadaaaaahiaaaaaffjaanaaoekaaeaaaaaeaaaaahiaamaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaahoaapaaoekaaaaappjaaaaaoeiaafaaaaadaaaaahiaacaaoejabaaappka
afaaaaadabaaahiaaaaaffiaanaaoekaaeaaaaaeaaaaaliaamaakekaaaaaaaia
abaakeiaaeaaaaaeaaaaahiaaoaaoekaaaaakkiaaaaapeiaabaaaaacaaaaaiia
bbaaaakaajaaaaadabaaabiaabaaoekaaaaaoeiaajaaaaadabaaaciaacaaoeka
aaaaoeiaajaaaaadabaaaeiaadaaoekaaaaaoeiaafaaaaadacaaapiaaaaacjia
aaaakeiaajaaaaadadaaabiaaeaaoekaacaaoeiaajaaaaadadaaaciaafaaoeka
acaaoeiaajaaaaadadaaaeiaagaaoekaacaaoeiaacaaaaadabaaahiaabaaoeia
adaaoeiaafaaaaadaaaaaiiaaaaaffiaaaaaffiaaeaaaaaeaaaaaiiaaaaaaaia
aaaaaaiaaaaappibabaaaaacabaaahoaaaaaoeiaaeaaaaaeacaaahoaahaaoeka
aaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffjaajaaoekaaeaaaaaeaaaaapia
aiaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaakaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaalaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcmmadaaaa
eaaaabaapdaaaaaafjaaaaaeegiocaaaaaaaaaaacnaaaaaafjaaaaaeegiocaaa
abaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaabaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaabaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaaaaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaaaaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaaaaaaaaaciaaaaaaegaobaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaaaaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaaaaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaaaaaaaaaclaaaaaaegaobaaaacaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaaaaaaaaacmaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
#line 469
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 461
    o.worldPos = (_Object2World * v.vertex).xyz;
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 465
    o.vlight = shlight;
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
#line 469
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 469
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 473
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 477
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 481
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 485
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
"!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 8 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
"vs_2_0
; 8 ALU
dcl_position0 v0
dcl_texcoord1 v2
mad oT1.xy, v2, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 18 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 10 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgkldpjicamaoejjangeiggjificlghfkabaaaaaadmadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnaabaaaaeaaaabaaheaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  c_1.xyz = (tmpvar_2 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c_1.xyz = (tmpvar_2 * ((8.0 * tmpvar_16.w) * tmpvar_16.xyz));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
"agal_vs
[bc]
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaabaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v1.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 18 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 10 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedocjedojgegkplhjnflopibmhjlnognnnabaaaaaaiaaeaaaaaeaaaaaa
daaaaaaahaabaaaaeiadaaaabaaeaaaaebgpgodjdiabaaaadiabaaaaaaacpopp
omaaaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaaeaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeiaaeaaapja
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahoa
ajaaoekaaaaappjaaaaaoeiaaeaaaaaeabaaadoaaeaaoejaabaaoekaabaaooka
afaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
afaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcnaabaaaaeaaaabaaheaaaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaa
apaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 456
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 460
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 465
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 456
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 468
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 470
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 474
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 478
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 482
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 5 [_Object2World]
Vector 9 [unity_LightmapST]
"!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 8 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
"vs_2_0
; 8 ALU
dcl_position0 v0
dcl_texcoord1 v2
mad oT1.xy, v2, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 18 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 10 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgkldpjicamaoejjangeiggjificlghfkabaaaaaadmadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcnaabaaaaeaaaabaaheaaaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  mediump vec3 lm_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_2 * lm_16);
  c_1.xyz = tmpvar_18;
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  mediump vec3 lm_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_16.w) * tmpvar_16.xyz);
  lm_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_2 * lm_17);
  c_1.xyz = tmpvar_19;
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_LightmapST]
"agal_vs
[bc]
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaabaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v1.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 18 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 10 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedocjedojgegkplhjnflopibmhjlnognnnabaaaaaaiaaeaaaaaeaaaaaa
daaaaaaahaabaaaaeiadaaaabaaeaaaaebgpgodjdiabaaaadiabaaaaaaacpopp
omaaaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaaeaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeiaaeaaapja
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahoa
ajaaoekaaaaappjaaaaaoeiaaeaaaaaeabaaadoaaeaaoejaabaaoekaabaaooka
afaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
afaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcnaabaaaaeaaaabaaheaaaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaa
apaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaa
laaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 456
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 469
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 460
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 465
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 456
uniform highp vec4 unity_LightmapST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 469
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 469
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 473
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 477
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 481
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    #line 485
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
"!!ARBvp1.0
# 34 ALU
PARAM c[18] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[17].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[12];
DP4 R2.y, R1.wxyz, c[11];
DP4 R2.x, R1.wxyz, c[10];
DP4 R1.z, R0, c[15];
DP4 R1.y, R0, c[14];
DP4 R1.x, R0, c[13];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R1.w;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
"vs_2_0
; 34 ALU
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c17.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c18.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c12
dp4 r2.y, r1.wxyz, c11
dp4 r2.x, r1.wxyz, c10
dp4 r1.z, r0, c15
dp4 r1.y, r0, c14
dp4 r1.x, r0, c13
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.y
mul r1.y, r1, c8.x
add oT2.xyz, r3, r2
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r1.w
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 31 instructions, 5 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlikknbdenappfbmkpngdbmkolkddbdgiabaaaaaabaagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcheaeaaaaeaaaabaa
bnabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaa
abaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaa
abaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaa
abaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaabaaaaaa
cjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaabaaaaaa
ckaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaabaaaaaa
claaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
bkaabaiaebaaaaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaa
cmaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  lowp vec4 c_22;
  c_22.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * tmpvar_16) * 2.0));
  c_22.w = tmpvar_3;
  c_1.w = c_22.w;
  c_1.xyz = (c_22.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_3 = shlight_1;
  highp vec4 o_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_23.xy = (tmpvar_25 + tmpvar_24.w);
  o_23.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = o_23;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 c_16;
  c_16.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x) * 2.0));
  c_16.w = tmpvar_3;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 4 [_Object2World]
Vector 16 [unity_Scale]
Vector 17 [unity_NPOTScale]
"agal_vs
c18 1.0 0.5 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r0.xyz, a1, c16.w
bcaaaaaaadaaaiacaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r0.xyzz, c5
bcaaaaaaacaaaiacaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r0.xyzz, c6
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r1.w, r0.xyzz, c4
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
aaaaaaaaabaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.w
aaaaaaaaabaaaeacbcaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.z, c18.x
adaaaaaaaaaaapacabaaaafdacaaaaaaabaaaaneacaaaaaa mul r0, r1.wxyy, r1.xyyw
bdaaaaaaacaaaeacabaaaajdacaaaaaaalaaaaoeabaaaaaa dp4 r2.z, r1.wxyz, c11
bdaaaaaaacaaacacabaaaajdacaaaaaaakaaaaoeabaaaaaa dp4 r2.y, r1.wxyz, c10
bdaaaaaaacaaabacabaaaajdacaaaaaaajaaaaoeabaaaaaa dp4 r2.x, r1.wxyz, c9
bdaaaaaaabaaaeacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r1.z, r0, c14
bdaaaaaaabaaacacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r1.y, r0, c13
bdaaaaaaabaaabacaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r1.x, r0, c12
adaaaaaaadaaabacadaaaappacaaaaaaadaaaappacaaaaaa mul r3.x, r3.w, r3.w
adaaaaaaaeaaabacabaaaappacaaaaaaabaaaappacaaaaaa mul r4.x, r1.w, r1.w
acaaaaaaaaaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa sub r0.x, r4.x, r3.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaaaaacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.x, c15
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaadaaahacaaaaaapeacaaaaaabcaaaaffabaaaaaa mul r3.xyz, r0.xyww, c18.y
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacadaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r3.y, c8.x
aaaaaaaaabaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.x
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkacaaaaaa add r1.xy, r1.xyyy, r3.z
adaaaaaaadaaadaeabaaaafeacaaaaaabbaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c17
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r1.w
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 31 instructions, 5 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedobmfpgmngbpgcefmhjlnfccolfdakldeabaaaaaaneaiaaaaaeaaaaaa
daaaaaaapaacaaaagmahaaaadeaiaaaaebgpgodjliacaaaaliacaaaaaaacpopp
feacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaafaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaaeaaanaaaaaaaaaaacaabeaaabaabbaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbcaaapkaaaaaiadpaaaaaadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaaoaaoeka
aeaaaaaeaaaaahiaanaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaahiaacaaoejabbaappkaafaaaaadabaaahiaaaaaffiaaoaaoekaaeaaaaae
aaaaaliaanaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahiaapaaoekaaaaakkia
aaaapeiaabaaaaacaaaaaiiabcaaaakaajaaaaadabaaabiaacaaoekaaaaaoeia
ajaaaaadabaaaciaadaaoekaaaaaoeiaajaaaaadabaaaeiaaeaaoekaaaaaoeia
afaaaaadacaaapiaaaaacjiaaaaakeiaajaaaaadadaaabiaafaaoekaacaaoeia
ajaaaaadadaaaciaagaaoekaacaaoeiaajaaaaadadaaaeiaahaaoekaacaaoeia
acaaaaadabaaahiaabaaoeiaadaaoeiaafaaaaadaaaaaiiaaaaaffiaaaaaffia
aeaaaaaeaaaaaiiaaaaaaaiaaaaaaaiaaaaappibabaaaaacabaaahoaaaaaoeia
aeaaaaaeacaaahoaaiaaoekaaaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffja
akaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
alaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaappjaaaaaoeia
afaaaaadabaaabiaaaaaffiaabaaaakaafaaaaadabaaaiiaabaaaaiabcaaffka
afaaaaadabaaafiaaaaapeiabcaaffkaacaaaaadadaaadoaabaakkiaabaaomia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacadaaamoaaaaaoeiappppaaaafdeieefcheaeaaaaeaaaabaabnabaaaa
fjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaa
fgafbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaa
abaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaa
abaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaa
cgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaa
chaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaa
ciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaa
egakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaabaaaaaacjaaaaaa
egaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaabaaaaaackaaaaaa
egaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaabaaaaaaclaaaaaa
egaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
aeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
aeaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 479
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 470
    o.worldPos = (_Object2World * v.vertex).xyz;
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 474
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 479
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 479
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 483
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 487
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 491
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 495
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
"!!ARBvp1.0
# 13 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
"vs_2_0
; 13 ALU
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c8.x
mad oT2.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT2.zw, r0
mad oT1.xy, v2, c10, c10.zwzw
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 320 // 320 used size, 19 vars
Vector 304 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedncnangeegapadklodnmclgjkhjelillbabaaaaaapmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
hiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD2.z / xlv_TEXCOORD2.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  c_1.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((tmpvar_16 * 2.0))));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  c_1.xyz = (tmpvar_2 * max (min (tmpvar_18, ((tmpvar_16.x * 2.0) * tmpvar_17.xyz)), (tmpvar_18 * tmpvar_16.x)));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Matrix 4 [_Object2World]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
"agal_vs
c11 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaalaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c11.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
adaaaaaaacaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v2.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaacaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, r0.wwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaabaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v1.xy, r0.xyyy, c10.zwzw
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 320 // 320 used size, 19 vars
Vector 304 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedecohadiebgonogpeicflaicbbmoopncaabaaaaaalaafaaaaaeaaaaaa
daaaaaaaoaabaaaagaaeaaaaciafaaaaebgpgodjkiabaaaakiabaaaaaaacpopp
faabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaabdaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaaeaaahaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafalaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeia
aeaaapjaafaaaaadaaaaahiaaaaaffjaaiaaoekaaeaaaaaeaaaaahiaahaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaahoaakaaoekaaaaappjaaaaaoeiaaeaaaaaeabaaadoaaeaaoejaabaaoeka
abaaookaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaagaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaaka
afaaaaadabaaaiiaabaaaaiaalaaaakaafaaaaadabaaafiaaaaapeiaalaaaaka
acaaaaadacaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacacaaamoaaaaaoeiappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaa
bdaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 469
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 473
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 478
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 481
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 485
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 489
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 493
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
"!!ARBvp1.0
# 13 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
"vs_2_0
; 13 ALU
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c8.x
mad oT2.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT2.zw, r0
mad oT1.xy, v2, c10, c10.zwzw
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 320 // 320 used size, 19 vars
Vector 304 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedncnangeegapadklodnmclgjkhjelillbabaaaaaapmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
hiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaabdaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD2.z / xlv_TEXCOORD2.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  mediump vec3 lm_22;
  lowp vec3 tmpvar_23;
  tmpvar_23 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_22 = tmpvar_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = vec3((tmpvar_16 * 2.0));
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_2 * min (lm_22, tmpvar_24));
  c_1.xyz = tmpvar_25;
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  mediump vec3 lm_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_17.w) * tmpvar_17.xyz);
  lm_18 = tmpvar_19;
  lowp vec3 arg1_20;
  arg1_20 = ((tmpvar_16.x * 2.0) * tmpvar_17.xyz);
  mediump vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_2 * max (min (lm_18, arg1_20), (lm_18 * tmpvar_16.x)));
  c_1.xyz = tmpvar_21;
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Matrix 4 [_Object2World]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
"agal_vs
c11 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaalaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c11.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
adaaaaaaacaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v2.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaacaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, r0.wwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaabaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v1.xy, r0.xyyy, c10.zwzw
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 320 // 320 used size, 19 vars
Vector 304 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedecohadiebgonogpeicflaicbbmoopncaabaaaaaalaafaaaaaeaaaaaa
daaaaaaaoaabaaaagaaeaaaaciafaaaaebgpgodjkiabaaaakiabaaaaaaacpopp
faabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaabdaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaaeaaahaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafalaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeia
aeaaapjaafaaaaadaaaaahiaaaaaffjaaiaaoekaaeaaaaaeaaaaahiaahaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaahoaakaaoekaaaaappjaaaaaoeiaaeaaaaaeabaaadoaaeaaoejaabaaoeka
abaaookaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaaeaaaaapiaadaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaagaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaaka
afaaaaadabaaaiiaabaaaaiaalaaaakaafaaaaadabaaafiaaaaapeiaalaaaaka
acaaaaadacaaadoaabaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacacaaamoaaaaaoeiappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabeaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaabdaaaaaaogikcaaaaaaaaaaa
bdaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 469
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 473
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 479
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 481
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 485
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 489
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 493
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    #line 497
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 5 [_Object2World]
Vector 24 [unity_Scale]
"!!ARBvp1.0
# 59 ALU
PARAM c[25] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[24].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[10];
DP3 R4.z, R3, c[6];
DP3 R3.z, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[9];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.y, R4.z;
MOV R5.z, R3;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[11];
MAD R2, R1, R1, R2;
MAD R0, R3.z, R1, R0;
MUL R1, R2, c[12];
ADD R1, R1, c[0].x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[19];
DP4 R2.y, R5, c[18];
DP4 R2.x, R5, c[17];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[14];
MAD R1.xyz, R0.x, c[13], R1;
MAD R0.xyz, R0.z, c[15], R1;
MAD R1.xyz, R0.w, c[16], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[22];
DP4 R5.z, R0, c[21];
DP4 R5.y, R0, c[20];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[23];
ADD R2.xyz, R2, R5.yzww;
ADD R0.xyz, R2, R0;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[2].xyz, R0, R1;
MOV result.texcoord[0].xyz, R3.wxyw;
MOV result.texcoord[1].z, R3;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 59 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 4 [_Object2World]
Vector 23 [unity_Scale]
"vs_2_0
; 59 ALU
def c24, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r3.xyz, v1, c23.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c9
dp3 r4.z, r3, c5
dp3 r3.z, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c8
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.y, r4.z
mov r5.z, r3
mov r5.w, c24.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c10
mad r2, r1, r1, r2
mad r0, r3.z, r1, r0
mul r1, r2, c11
add r1, r1, c24.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c18
dp4 r2.y, r5, c17
dp4 r2.x, r5, c16
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c24.y
mul r0, r0, r1
mul r1.xyz, r0.y, c13
mad r1.xyz, r0.x, c12, r1
mad r0.xyz, r0.z, c14, r1
mad r1.xyz, r0.w, c15, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c21
dp4 r5.z, r0, c20
dp4 r5.y, r0, c19
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c22
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add oT2.xyz, r0, r1
mov oT0.xyz, r3.wxyw
mov oT1.z, r3
mov oT1.y, r4.z
mov oT1.x, r5
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityLighting" 0
BindCB "UnityPerDraw" 1
// 47 instructions, 6 temp regs, 0 temp arrays:
// ALU 43 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedklgmaopnebihkdddmgajbjoklmkhcallabaaaaaabmaiaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
jiagaaaaeaaaabaakgabaaaafjaaaaaeegiocaaaaaaaaaaacnaaaaaafjaaaaae
egiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacagaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaabaaaaaa
beaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaabaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaaaaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaaaaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaaaaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaah
pcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaa
aeaaaaaaegiocaaaaaaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaa
aeaaaaaaegiocaaaaaaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaa
aeaaaaaaegiocaaaaaaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaaaaaaaaa
bkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
aaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaabaaaaaaegaobaaaadaaaaaa
diaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaaj
pcaabaaaafaaaaaaagaabaiaebaaaaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
aaaaaaajpcaabaaaaaaaaaaakgakbaiaebaaaaaaaaaaaaaaegiocaaaaaaaaaaa
aeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaabaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaa
afaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
aaaaaaaakgakbaaaabaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaabaaaaaa
egaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaa
aaaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
adaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaadaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaaaaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 c_16;
  c_16.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_16.w = tmpvar_3;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 c_16;
  c_16.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_16.w = tmpvar_3;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 4 [_Object2World]
Vector 23 [unity_Scale]
"agal_vs
c24 1.0 0.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaabhaaaappabaaaaaa mul r3.xyz, a1, c23.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaajaaaaoeabaaaaaa add r2, r2.z, c9
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaadaaaeacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.z, r3.xyzz, c6
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaaiaaaaoeabaaaaaa add r1, r1.w, c8
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaeacadaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.z
aaaaaaaaafaaaiacbiaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c24.x
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaakaaaaoeabaaaaaa add r1, r1.x, c10
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaakkacaaaaaaabaaaaoeacaaaaaa mul r6, r3.z, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaalaaaaoeabaaaaaa mul r1, r2, c11
abaaaaaaabaaapacabaaaaoeacaaaaaabiaaaaaaabaaaaaa add r1, r1, c24.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.z, r5, c18
bdaaaaaaacaaacacafaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r2.y, r5, c17
bdaaaaaaacaaabacafaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r2.x, r5, c16
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabiaaaaffabaaaaaa max r0, r0, c24.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaanaaaaoeabaaaaaa mul r1.xyz, r0.y, c13
adaaaaaaagaaahacaaaaaaaaacaaaaaaamaaaaoeabaaaaaa mul r6.xyz, r0.x, c12
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaaoaaaaoeabaaaaaa mul r0.xyz, r0.z, c14
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.w, c15
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r0, r5.xyzz, r5.yzzx
adaaaaaaabaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r1.w, r4.z, r4.z
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.w, r0, c21
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r5.z, r0, c20
bdaaaaaaafaaacacaaaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r5.y, r0, c19
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r6.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabgaaaaoeabaaaaaa mul r0.xyz, r1.w, c22
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaapjacaaaaaa add r2.xyz, r2.xyzz, r5.yzww
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
abaaaaaaacaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaahaeadaaaafdacaaaaaaaaaaaaaaaaaaaaaa mov v0.xyz, r3.wxyy
aaaaaaaaabaaaeaeadaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r3.z
aaaaaaaaabaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r4.z
aaaaaaaaabaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r5.x
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityLighting" 0
BindCB "UnityPerDraw" 1
// 47 instructions, 6 temp regs, 0 temp arrays:
// ALU 43 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedngpbnlfocmfgpiandjiachceojknenfbabaaaaaaemamaaaaaeaaaaaa
daaaaaaafmaeaaaapmakaaaamealaaaaebgpgodjceaeaaaaceaeaaaaaaacpopp
maadaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaacaa
aiaaabaaaaaaaaaaaaaacgaaahaaajaaaaaaaaaaabaaaaaaaeaabaaaaaaaaaaa
abaaamaaaeaabeaaaaaaaaaaabaabeaaabaabiaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbjaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjabfaaoeka
aeaaaaaeaaaaahiabeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiabgaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaahiabhaaoekaaaaappjaaaaaoeiaacaaaaad
abaaapiaaaaaffibacaaoekaafaaaaadacaaapiaabaaoeiaabaaoeiaacaaaaad
adaaapiaaaaaaaibabaaoekaaeaaaaaeacaaapiaadaaoeiaadaaoeiaacaaoeia
acaaaaadaeaaapiaaaaakkibadaaoekaabaaaaacaaaaahoaaaaaoeiaaeaaaaae
aaaaapiaaeaaoeiaaeaaoeiaacaaoeiaahaaaaacacaaabiaaaaaaaiaahaaaaac
acaaaciaaaaaffiaahaaaaacacaaaeiaaaaakkiaahaaaaacacaaaiiaaaaappia
abaaaaacafaaabiabjaaaakaaeaaaaaeaaaaapiaaaaaoeiaaeaaoekaafaaaaia
afaaaaadafaaahiaacaaoejabiaappkaafaaaaadagaaahiaafaaffiabfaaoeka
aeaaaaaeafaaaliabeaakekaafaaaaiaagaakeiaaeaaaaaeafaaahiabgaaoeka
afaakkiaafaapeiaafaaaaadabaaapiaabaaoeiaafaaffiaaeaaaaaeabaaapia
adaaoeiaafaaaaiaabaaoeiaaeaaaaaeabaaapiaaeaaoeiaafaakkiaabaaoeia
afaaaaadabaaapiaacaaoeiaabaaoeiaalaaaaadabaaapiaabaaoeiabjaaffka
agaaaaacacaaabiaaaaaaaiaagaaaaacacaaaciaaaaaffiaagaaaaacacaaaeia
aaaakkiaagaaaaacacaaaiiaaaaappiaafaaaaadaaaaapiaabaaoeiaacaaoeia
afaaaaadabaaahiaaaaaffiaagaaoekaaeaaaaaeabaaahiaafaaoekaaaaaaaia
abaaoeiaaeaaaaaeaaaaahiaahaaoekaaaaakkiaabaaoeiaaeaaaaaeaaaaahia
aiaaoekaaaaappiaaaaaoeiaabaaaaacafaaaiiabjaaaakaajaaaaadabaaabia
ajaaoekaafaaoeiaajaaaaadabaaaciaakaaoekaafaaoeiaajaaaaadabaaaeia
alaaoekaafaaoeiaafaaaaadacaaapiaafaacjiaafaakeiaajaaaaadadaaabia
amaaoekaacaaoeiaajaaaaadadaaaciaanaaoekaacaaoeiaajaaaaadadaaaeia
aoaaoekaacaaoeiaacaaaaadabaaahiaabaaoeiaadaaoeiaafaaaaadaaaaaiia
afaaffiaafaaffiaaeaaaaaeaaaaaiiaafaaaaiaafaaaaiaaaaappibabaaaaac
abaaahoaafaaoeiaaeaaaaaeabaaahiaapaaoekaaaaappiaabaaoeiaacaaaaad
acaaahoaaaaaoeiaabaaoeiaafaaaaadaaaaapiaaaaaffjabbaaoekaaeaaaaae
aaaaapiabaaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabcaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiabdaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
jiagaaaaeaaaabaakgabaaaafjaaaaaeegiocaaaaaaaaaaacnaaaaaafjaaaaae
egiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacagaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaaacaaaaaapgipcaaaabaaaaaa
beaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaaabaaaaaaamaaaaaaagaabaaa
abaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaa
aoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaaaaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaaaaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaaaaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaah
pcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaa
aeaaaaaaegiocaaaaaaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaa
aeaaaaaaegiocaaaaaaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaa
aeaaaaaaegiocaaaaaaaaaaaclaaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaadiaaaaahicaabaaaaaaaaaaa
bkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
aaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaaabaaaaaaegaobaaaadaaaaaa
diaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaaj
pcaabaaaafaaaaaaagaabaiaebaaaaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
aaaaaaajpcaabaaaaaaaaaaakgakbaiaebaaaaaaaaaaaaaaegiocaaaaaaaaaaa
aeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaabaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaa
afaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
aaaaaaaakgakbaaaabaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaabaaaaaa
egaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaaegiocaaa
aaaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
adaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
deaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaadaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaaaaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaah
hccabaaaadaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 461
    o.worldPos = (_Object2World * v.vertex).xyz;
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 465
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 469
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 471
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 473
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 477
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 481
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    #line 485
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_ProjectionParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 5 [_Object2World]
Vector 25 [unity_Scale]
"!!ARBvp1.0
# 65 ALU
PARAM c[26] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[11];
DP3 R4.z, R3, c[6];
DP3 R3.z, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[10];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.y, R4.z;
MOV R5.z, R3;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[12];
MAD R2, R1, R1, R2;
MAD R0, R3.z, R1, R0;
MUL R1, R2, c[13];
ADD R1, R1, c[0].x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[20];
DP4 R2.y, R5, c[19];
DP4 R2.x, R5, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[23];
DP4 R5.z, R0, c[22];
DP4 R5.y, R0, c[21];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R5.yzww;
ADD R5.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[2].xyz, R5.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[3].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[0].xyz, R3.wxyw;
MOV result.texcoord[1].z, R3;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
END
# 65 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 4 [_Object2World]
Vector 25 [unity_Scale]
"vs_2_0
; 65 ALU
def c26, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
mul r3.xyz, v1, c25.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c11
dp3 r4.z, r3, c5
dp3 r3.z, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c10
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.y, r4.z
mov r5.z, r3
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c12
mad r2, r1, r1, r2
mad r0, r3.z, r1, r0
mul r1, r2, c13
add r1, r1, c26.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c20
dp4 r2.y, r5, c19
dp4 r2.x, r5, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c23
dp4 r5.z, r0, c22
dp4 r5.y, r0, c21
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c26.z
add oT2.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mov r3.x, r4.w
mov r3.y, r4
mad oT3.xy, r2.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT0.xyz, r3.wxyw
mov oT1.z, r3
mov oT1.y, r4.z
mov oT1.x, r5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 52 instructions, 7 temp regs, 0 temp arrays:
// ALU 46 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkdhobgbpcinpmffjmbgidphgklmjcdeeabaaaaaanmaiaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefceaahaaaaeaaaabaa
naabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaacaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
acaaaaaadiaaaaahpcaabaaaaeaaaaaajgacbaaaacaaaaaaegakbaaaacaaaaaa
bbaaaaaibcaabaaaafaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaaeaaaaaa
bbaaaaaiccaabaaaafaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaaeaaaaaa
bbaaaaaiecaabaaaafaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaaeaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaafaaaaaadiaaaaah
icaabaaaabaaaaaabkaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaadkaabaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaabaaaaaa
egiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaacaaaaaa
egaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
aeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaabaaaaaaegiocaaa
abaaaaaaacaaaaaaaaaaaaajpcaabaaaabaaaaaakgakbaiaebaaaaaaabaaaaaa
egiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaacaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaafaaaaaaeeaaaaaf
pcaabaaaacaaaaaaegaobaaaaeaaaaaadcaaaaanpcaabaaaaeaaaaaaegaobaaa
aeaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaaeaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaacaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
aeaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaa
agaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaabaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaahhccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  lowp vec4 c_22;
  c_22.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * tmpvar_16) * 2.0));
  c_22.w = tmpvar_3;
  c_1.w = c_22.w;
  c_1.xyz = (c_22.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_3 = tmpvar_29;
  highp vec4 o_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (tmpvar_31.y * _ProjectionParams.x);
  o_30.xy = (tmpvar_32 + tmpvar_31.w);
  o_30.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = o_30;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp vec4 c_16;
  c_16.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x) * 2.0));
  c_16.w = tmpvar_3;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 4 [_Object2World]
Vector 24 [unity_Scale]
Vector 25 [unity_NPOTScale]
"agal_vs
c26 1.0 0.0 0.5 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaabiaaaappabaaaaaa mul r3.xyz, a1, c24.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaakaaaaoeabaaaaaa add r2, r2.z, c10
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaadaaaeacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.z, r3.xyzz, c6
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaajaaaaoeabaaaaaa add r1, r1.w, c9
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaeacadaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.z
aaaaaaaaafaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c26.x
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaalaaaaoeabaaaaaa add r1, r1.x, c11
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaakkacaaaaaaabaaaaoeacaaaaaa mul r6, r3.z, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaamaaaaoeabaaaaaa mul r1, r2, c12
abaaaaaaabaaapacabaaaaoeacaaaaaabkaaaaaaabaaaaaa add r1, r1, c26.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.z, r5, c19
bdaaaaaaacaaacacafaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.y, r5, c18
bdaaaaaaacaaabacafaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r2.x, r5, c17
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabkaaaaffabaaaaaa max r0, r0, c26.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
adaaaaaaagaaahacaaaaaaaaacaaaaaaanaaaaoeabaaaaaa mul r6.xyz, r0.x, c13
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaapaaaaoeabaaaaaa mul r0.xyz, r0.z, c15
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.w, c16
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r0, r5.xyzz, r5.yzzx
adaaaaaaabaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r1.w, r4.z, r4.z
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.w, r0, c22
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.z, r0, c21
bdaaaaaaafaaacacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r5.y, r0, c20
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r6.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabhaaaaoeabaaaaaa mul r0.xyz, r1.w, c23
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaapjacaaaaaa add r2.xyz, r2.xyzz, r5.yzww
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaafaaaoacaaaaaandacaaaaaabkaaaakkabaaaaaa mul r5.yzw, r0.wxyw, c26.z
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacafaaaakkacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r5.z, c8.x
aaaaaaaaabaaabacafaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r5.y
abaaaaaaabaaadacabaaaafeacaaaaaaafaaaappacaaaaaa add r1.xy, r1.xyyy, r5.w
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
adaaaaaaadaaadaeabaaaafeacaaaaaabjaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c25
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
aaaaaaaaaaaaahaeadaaaafdacaaaaaaaaaaaaaaaaaaaaaa mov v0.xyz, r3.wxyy
aaaaaaaaabaaaeaeadaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r3.z
aaaaaaaaabaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r4.z
aaaaaaaaabaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r5.x
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 52 instructions, 7 temp regs, 0 temp arrays:
// ALU 46 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedcodhockdiefhaooldhjokggkfpjjpaemabaaaaaageanaaaaaeaaaaaa
daaaaaaaleaeaaaapmalaaaameamaaaaebgpgodjhmaeaaaahmaeaaaaaaacpopp
amaeaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaafaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaaaaaeaabbaaaaaaaaaaacaaamaaaeaabfaaaaaaaaaaacaabeaaabaabjaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbkaaapkaaaaaiadpaaaaaaaaaaaaaadp
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaad
aaaaahiaaaaaffjabgaaoekaaeaaaaaeaaaaahiabfaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaahiabhaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiabiaaoeka
aaaappjaaaaaoeiaacaaaaadabaaapiaaaaaffibadaaoekaafaaaaadacaaapia
abaaoeiaabaaoeiaacaaaaadadaaapiaaaaaaaibacaaoekaaeaaaaaeacaaapia
adaaoeiaadaaoeiaacaaoeiaacaaaaadaeaaapiaaaaakkibaeaaoekaabaaaaac
aaaaahoaaaaaoeiaaeaaaaaeaaaaapiaaeaaoeiaaeaaoeiaacaaoeiaahaaaaac
acaaabiaaaaaaaiaahaaaaacacaaaciaaaaaffiaahaaaaacacaaaeiaaaaakkia
ahaaaaacacaaaiiaaaaappiaabaaaaacafaaabiabkaaaakaaeaaaaaeaaaaapia
aaaaoeiaafaaoekaafaaaaiaafaaaaadafaaahiaacaaoejabjaappkaafaaaaad
agaaahiaafaaffiabgaaoekaaeaaaaaeafaaaliabfaakekaafaaaaiaagaakeia
aeaaaaaeafaaahiabhaaoekaafaakkiaafaapeiaafaaaaadabaaapiaabaaoeia
afaaffiaaeaaaaaeabaaapiaadaaoeiaafaaaaiaabaaoeiaaeaaaaaeabaaapia
aeaaoeiaafaakkiaabaaoeiaafaaaaadabaaapiaacaaoeiaabaaoeiaalaaaaad
abaaapiaabaaoeiabkaaffkaagaaaaacacaaabiaaaaaaaiaagaaaaacacaaacia
aaaaffiaagaaaaacacaaaeiaaaaakkiaagaaaaacacaaaiiaaaaappiaafaaaaad
aaaaapiaabaaoeiaacaaoeiaafaaaaadabaaahiaaaaaffiaahaaoekaaeaaaaae
abaaahiaagaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkia
abaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaappiaaaaaoeiaabaaaaacafaaaiia
bkaaaakaajaaaaadabaaabiaakaaoekaafaaoeiaajaaaaadabaaaciaalaaoeka
afaaoeiaajaaaaadabaaaeiaamaaoekaafaaoeiaafaaaaadacaaapiaafaacjia
afaakeiaajaaaaadadaaabiaanaaoekaacaaoeiaajaaaaadadaaaciaaoaaoeka
acaaoeiaajaaaaadadaaaeiaapaaoekaacaaoeiaacaaaaadabaaahiaabaaoeia
adaaoeiaafaaaaadaaaaaiiaafaaffiaafaaffiaaeaaaaaeaaaaaiiaafaaaaia
afaaaaiaaaaappibabaaaaacabaaahoaafaaoeiaaeaaaaaeabaaahiabaaaoeka
aaaappiaabaaoeiaacaaaaadacaaahoaaaaaoeiaabaaoeiaafaaaaadaaaaapia
aaaaffjabcaaoekaaeaaaaaeaaaaapiabbaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiabdaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabeaaoekaaaaappja
aaaaoeiaafaaaaadabaaabiaaaaaffiaabaaaakaafaaaaadabaaaiiaabaaaaia
bkaakkkaafaaaaadabaaafiaaaaapeiabkaakkkaacaaaaadadaaadoaabaakkia
abaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiaabaaaaacadaaamoaaaaaoeiappppaaaafdeieefceaahaaaaeaaaabaa
naabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaa
abaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaacaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaacaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaacaaaaaaegaibaaaadaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
acaaaaaadiaaaaahpcaabaaaaeaaaaaajgacbaaaacaaaaaaegakbaaaacaaaaaa
bbaaaaaibcaabaaaafaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaaeaaaaaa
bbaaaaaiccaabaaaafaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaaeaaaaaa
bbaaaaaiecaabaaaafaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaaeaaaaaa
aaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaafaaaaaadiaaaaah
icaabaaaabaaaaaabkaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakicaabaaa
abaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaadkaabaiaebaaaaaaabaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaabaaaaaa
egiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaacaaaaaa
egaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaa
aeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaabaaaaaaegiocaaa
abaaaaaaacaaaaaaaaaaaaajpcaabaaaabaaaaaakgakbaiaebaaaaaaabaaaaaa
egiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaacaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaafaaaaaaeeaaaaaf
pcaabaaaacaaaaaaegaobaaaaeaaaaaadcaaaaanpcaabaaaaeaaaaaaegaobaaa
aeaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpaoaaaaakpcaabaaaaeaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadp
aaaaiadpegaobaaaaeaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaacaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
aeaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaa
egiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaa
agaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaabaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaahhccabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 470
    o.worldPos = (_Object2World * v.vertex).xyz;
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 474
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 479
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 481
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 483
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 487
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 491
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 495
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float shadow_16;
  lowp float tmpvar_17;
  tmpvar_17 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_18;
  tmpvar_18 = (_LightShadowData.x + (tmpvar_17 * (1.0 - _LightShadowData.x)));
  shadow_16 = tmpvar_18;
  lowp vec4 c_19;
  c_19.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * shadow_16) * 2.0));
  c_19.w = tmpvar_3;
  c_1.w = c_19.w;
  c_1.xyz = (c_19.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 479
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 470
    o.worldPos = (_Object2World * v.vertex).xyz;
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 474
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 479
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 479
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 483
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 487
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 491
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 495
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float shadow_16;
  lowp float tmpvar_17;
  tmpvar_17 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD2.xyz);
  highp float tmpvar_18;
  tmpvar_18 = (_LightShadowData.x + (tmpvar_17 * (1.0 - _LightShadowData.x)));
  shadow_16 = tmpvar_18;
  c_1.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((shadow_16 * 2.0))));
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 469
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 473
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 478
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 481
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 485
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 489
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 493
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float shadow_16;
  lowp float tmpvar_17;
  tmpvar_17 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD2.xyz);
  highp float tmpvar_18;
  tmpvar_18 = (_LightShadowData.x + (tmpvar_17 * (1.0 - _LightShadowData.x)));
  shadow_16 = tmpvar_18;
  mediump vec3 lm_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_19 = tmpvar_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = vec3((shadow_16 * 2.0));
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 * min (lm_19, tmpvar_21));
  c_1.xyz = tmpvar_22;
  c_1.w = tmpvar_3;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 469
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 473
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 465
uniform highp vec4 unity_LightmapST;
#line 477
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 479
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 481
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 485
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 489
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 493
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    #line 497
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal_8;
  normal_8 = tmpvar_6;
  highp float vC_9;
  mediump vec3 x3_10;
  mediump vec3 x2_11;
  mediump vec3 x1_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal_8);
  x1_12.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal_8);
  x1_12.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal_8);
  x1_12.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal_8.xyzz * normal_8.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2_11.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2_11.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2_11.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal_8.x * normal_8.x) - (normal_8.y * normal_8.y));
  vC_9 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC_9);
  x3_10 = tmpvar_21;
  tmpvar_7 = ((x1_12 + x2_11) + x3_10);
  shlight_1 = tmpvar_7;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_5.x) + (tmpvar_24 * tmpvar_5.y)) + (tmpvar_25 * tmpvar_5.z)) * inversesqrt(tmpvar_26))) * (1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0)))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_27.x) + (unity_LightColor[1].xyz * tmpvar_27.y)) + (unity_LightColor[2].xyz * tmpvar_27.z)) + (unity_LightColor[3].xyz * tmpvar_27.w)));
  tmpvar_3 = tmpvar_28;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  tmpvar_2 = vec3(0.0, 0.0, 0.0);
  tmpvar_3 = 0.0;
  highp float tmpvar_4;
  highp vec3 p_5;
  p_5 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_4 = sqrt(dot (p_5, p_5));
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  if ((tmpvar_4 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_8;
      tmpvar_8 = _Brush1DirtyColor.xyz;
      tmpvar_2 = tmpvar_8;
    } else {
      mediump vec4 dirtyColor_9;
      highp vec4 tmpvar_10;
      tmpvar_10 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_9 = tmpvar_10;
      mediump vec3 tmpvar_11;
      tmpvar_11 = dirtyColor_9.xyz;
      tmpvar_2 = tmpvar_11;
    };
    tmpvar_3 = 1.0;
  } else {
    if ((tmpvar_6 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_12;
        tmpvar_12 = _Brush2DirtyColor.xyz;
        tmpvar_2 = tmpvar_12;
      } else {
        mediump vec4 dirtyColor_1_13;
        highp vec4 tmpvar_14;
        tmpvar_14 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_13 = tmpvar_14;
        mediump vec3 tmpvar_15;
        tmpvar_15 = dirtyColor_1_13.xyz;
        tmpvar_2 = tmpvar_15;
      };
      tmpvar_3 = 1.0;
    } else {
      tmpvar_3 = 0.0;
    };
  };
  lowp float shadow_16;
  lowp float tmpvar_17;
  tmpvar_17 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_18;
  tmpvar_18 = (_LightShadowData.x + (tmpvar_17 * (1.0 - _LightShadowData.x)));
  shadow_16 = tmpvar_18;
  lowp vec4 c_19;
  c_19.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * shadow_16) * 2.0));
  c_19.w = tmpvar_3;
  c_1.w = c_19.w;
  c_1.xyz = (c_19.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 466
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 470
    o.worldPos = (_Object2World * v.vertex).xyz;
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    #line 474
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 479
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 414
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 457
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 401
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 405
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 409
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 413
uniform highp float _Brush2ActivationState;
#line 421
#line 466
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 421
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 425
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 430
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 434
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 441
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 447
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 454
            o.Alpha = 0.0;
        }
    }
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 481
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 483
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 487
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 491
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 495
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 44 to 50, TEX: 0 to 2
//   d3d9 - ALU: 46 to 51, TEX: 1 to 2
//   d3d11 - ALU: 17 to 23, TEX: 0 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 17 to 23, TEX: 0 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Brush1Pos]
Float 3 [_Brush1Radius]
Vector 4 [_Brush1ColorSelectedLow]
Vector 5 [_Brush1ColorSelectedHigh]
Vector 6 [_Brush1DirtyColor]
Float 7 [_Brush1ActivationFlag]
Float 8 [_Brush1ActivationState]
Vector 9 [_Brush2Pos]
Float 10 [_Brush2Radius]
Vector 11 [_Brush2ColorSelectedLow]
Vector 12 [_Brush2ColorSelectedHigh]
Vector 13 [_Brush2DirtyColor]
Float 14 [_Brush2ActivationState]
"!!ARBfp1.0
# 46 ALU, 0 TEX
PARAM c[16] = { program.local[0..14],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
ADD R0.xyz, fragment.texcoord[0], -c[9];
DP3 R1.w, R0, R0;
MOV R0.xyz, c[4];
MOV R0.w, c[15].x;
ADD R0.w, R0, -c[7].x;
ABS R2.x, R0.w;
ADD R1.xyz, fragment.texcoord[0], -c[2];
DP3 R0.w, R1, R1;
CMP R2.z, -R2.x, c[15].y, c[15].x;
ABS R1.x, R2.z;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
ADD R0.xyz, -R0, c[5];
CMP R2.y, -R1.x, c[15], c[15].x;
MUL R1.xyz, R0, c[8].x;
SLT R0.w, R0, c[3].x;
ADD R1.xyz, R1, c[4];
MUL R2.x, R0.w, R2.y;
MUL R0.y, R0.w, R2.z;
MOV R0.x, c[15].y;
CMP R0.xyz, -R0.y, c[6], R0.x;
CMP R0.xyz, -R2.x, R1, R0;
RSQ R1.x, R1.w;
RCP R1.x, R1.x;
SLT R1.w, R1.x, c[10].x;
ABS R0.w, R0;
CMP R0.w, -R0, c[15].y, c[15].x;
MUL R2.x, R1.w, R0.w;
MUL R2.z, R2.x, R2;
MOV R1.xyz, c[11];
ADD R1.xyz, -R1, c[12];
MUL R1.xyz, R1, c[14].x;
ABS R1.w, R1;
CMP R1.w, -R1, c[15].y, c[15].x;
MUL R0.w, R0, R1;
MUL R2.x, R2, R2.y;
ADD R1.xyz, R1, c[11];
CMP R0.xyz, -R2.z, c[13], R0;
CMP R0.xyz, -R2.x, R1, R0;
MUL R1.xyz, R0, c[1];
DP3 R2.x, fragment.texcoord[1], c[0];
MAX R2.x, R2, c[15].y;
MUL R1.xyz, R2.x, R1;
MUL R0.xyz, R0, fragment.texcoord[2];
MAD result.color.xyz, R1, c[15].z, R0;
CMP result.color.w, -R0, c[15].y, c[15].x;
END
# 46 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Brush1Pos]
Float 3 [_Brush1Radius]
Vector 4 [_Brush1ColorSelectedLow]
Vector 5 [_Brush1ColorSelectedHigh]
Vector 6 [_Brush1DirtyColor]
Float 7 [_Brush1ActivationFlag]
Float 8 [_Brush1ActivationState]
Vector 9 [_Brush2Pos]
Float 10 [_Brush2Radius]
Vector 11 [_Brush2ColorSelectedLow]
Vector 12 [_Brush2ColorSelectedHigh]
Vector 13 [_Brush2DirtyColor]
Float 14 [_Brush2ActivationState]
"ps_2_0
; 49 ALU
def c15, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
add r0.xyz, t0, -c2
dp3 r1.x, r0, r0
mov r0.x, c7
rsq r1.x, r1.x
add r0.x, c15.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c3
abs r0.x, r0
cmp r2.x, r1, c15, c15.y
cmp r0.x, -r0, c15.y, c15
mul_pp r1.x, r2, r0
mov_pp r4.xyz, c6
cmp_pp r5.xyz, -r1.x, c15.x, r4
add r3.xyz, t0, -c9
dp3 r1.x, r3, r3
rsq r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c5
add r4.xyz, -c4, r4
mul r4.xyz, r4, c8.x
rcp r3.x, r3.x
add r3.x, r3, -c10
add r6.xyz, r4, c4
cmp_pp r1.x, -r1, c15.y, c15
mul_pp r4.x, r2, r1
cmp_pp r5.xyz, -r4.x, r5, r6
mov r6.xyz, c12
abs_pp r2.x, r2
add r6.xyz, -c11, r6
mul r6.xyz, r6, c14.x
cmp_pp r2.x, -r2, c15.y, c15
cmp r3.x, r3, c15, c15.y
mul_pp r4.x, r2, r3
mul_pp r0.x, r4, r0
cmp_pp r5.xyz, -r0.x, r5, c13
mul_pp r0.x, r4, r1
add r6.xyz, r6, c11
cmp_pp r4.xyz, -r0.x, r5, r6
abs_pp r0.x, r3
dp3_pp r1.x, t1, c0
cmp_pp r0.x, -r0, c15.y, c15
mul_pp r0.x, r2, r0
cmp_pp r0.w, -r0.x, c15.y, c15.x
mul_pp r5.xyz, r4, c1
max_pp r1.x, r1, c15
mul_pp r1.xyz, r1.x, r5
mul_pp r2.xyz, r4, t2
mad_pp r0.xyz, r1, c15.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 240 // 232 used size, 17 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
// 27 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 1 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhjojpeiifpmdofifnlnipgabgkdbpjfnabaaaaaaiiaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcjiadaaaaeaaaaaaaogaaaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
akaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaalaaaaaa
agijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaa
aoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaacaaaaaaibcaabaaa
abaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaajgahbaaaaaaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaia
ebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaahccaabaaaabaaaaaa
jgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaa
abaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaa
aeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaa
egiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaa
aiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaacaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaa
fgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
abaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 240 // 232 used size, 17 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
// 27 instructions, 3 temp regs, 0 temp arrays:
// ALU 18 float, 1 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedaiieedddghpimlboifjkmblflmokfklnabaaaaaadeahaaaaaeaaaaaa
daaaaaaaniacaaaahiagaaaaaaahaaaaebgpgodjkaacaaaakaacaaaaaaacpppp
eaacaaaagaaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaaaaagaaaaaaaabaa
abaaaaaaaaaaaaaaaaaaadaaafaaabaaaaaaaaaaaaaaaiaaabaaagaaacaaaaaa
aaaaajaaagaaahaaaaaaaaaaabaaaaaaabaaanaaaaaaaaaaaaacppppfbaaaaaf
aoaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlaacaaaaadaaaaahia
aaaaoelbabaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabia
aaaaaaiaagaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaacaaaakb
acaaaaadabaaahiaaaaaoelbahaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeia
ahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaacia
aaaaffiaaiaaaakbabaaaaacabaaahiaajaaoekaacaaaaadacaaahiaabaaoeib
akaaoekaaeaaaaaeabaachiaamaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiia
aoaaaakaacaaaaadabaaaiiaabaappiaagaaaakbafaaaaadabaaaiiaabaappia
abaappiafiaaaaaeabaachiaabaappibalaaoekaabaaoeiafiaaaaaeacaachia
aaaaffiaaoaaffkaabaaoeiafiaaaaaeacaaciiaaaaaffiaaoaaffkaaoaaaaka
abaaaaacabaaahiaadaaoekaacaaaaadaaaaaoiaabaablibaeaablkaaeaaaaae
aaaacoiaagaaffkaaaaaoeiaabaabliafiaaaaaeabaachiaabaappibafaaoeka
aaaabliaabaaaaacabaaciiaaoaaaakafiaaaaaeaaaacpiaaaaaaaiaacaaoeia
abaaoeiaafaaaaadabaachiaaaaaoeiaaaaaoekaafaaaaadacaachiaaaaaoeia
acaaoelaaiaaaaadabaaciiaabaaoelaanaaoekaalaaaaadacaaciiaabaappia
aoaaffkaacaaaaadabaaciiaacaappiaacaappiaaeaaaaaeaaaachiaabaaoeia
abaappiaacaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcjiadaaaa
eaaaaaaaogaaaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ajaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaa
agijcaiaebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaal
ocaabaaaaaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaa
aaaaaaaaalaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaa
abeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaanaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpabaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaajocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaa
adaaaaaabaaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaa
elaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaa
bkaabaaaabaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaa
egiccaiaebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaal
hcaabaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaafaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpdhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaaiicaabaaa
aaaaaaaaegbcbaaaacaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheoiaaaaaaa
aeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
heaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [unity_Lightmap] 2D
"!!ARBfp1.0
# 44 ALU, 1 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[0], 2D;
ADD R1.xyz, fragment.texcoord[0], -c[7];
DP3 R1.x, R1, R1;
RSQ R1.w, R1.x;
MOV R2.x, c[13];
ADD R2.w, R2.x, -c[5].x;
ADD R2.xyz, fragment.texcoord[0], -c[0];
DP3 R2.x, R2, R2;
ABS R2.w, R2;
CMP R3.y, -R2.w, c[13], c[13].x;
ABS R2.y, R3;
MOV R1.xyz, c[2];
RSQ R2.x, R2.x;
RCP R2.x, R2.x;
ADD R1.xyz, -R1, c[3];
SLT R2.w, R2.x, c[1].x;
CMP R3.x, -R2.y, c[13].y, c[13];
MUL R2.xyz, R1, c[6].x;
MUL R3.z, R2.w, R3.x;
MUL R1.y, R2.w, R3;
MOV R1.x, c[13].y;
CMP R1.xyz, -R1.y, c[4], R1.x;
ADD R2.xyz, R2, c[2];
CMP R2.xyz, -R3.z, R2, R1;
RCP R1.y, R1.w;
ABS R1.x, R2.w;
SLT R2.w, R1.y, c[8].x;
CMP R1.w, -R1.x, c[13].y, c[13].x;
MUL R3.z, R1.w, R2.w;
MOV R1.xyz, c[9];
MUL R3.y, R3.z, R3;
ADD R1.xyz, -R1, c[10];
MUL R1.xyz, R1, c[12].x;
MUL R0.xyz, R0.w, R0;
CMP R2.xyz, -R3.y, c[11], R2;
MUL R3.x, R3.z, R3;
ADD R1.xyz, R1, c[9];
CMP R1.xyz, -R3.x, R1, R2;
MUL R1.xyz, R0, R1;
ABS R2.x, R2.w;
CMP R0.w, -R2.x, c[13].y, c[13].x;
MUL R0.x, R1.w, R0.w;
MUL result.color.xyz, R1, c[13].z;
CMP result.color.w, -R0.x, c[13].y, c[13].x;
END
# 44 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [unity_Lightmap] 2D
"ps_2_0
; 46 ALU, 1 TEX
dcl_2d s0
def c13, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xyz
dcl t1.xy
texld r5, t1, s0
add r0.xyz, t0, -c0
dp3 r1.x, r0, r0
mov r0.x, c5
rsq r1.x, r1.x
add r0.x, c13.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c1
abs r0.x, r0
cmp r2.x, r1, c13, c13.y
cmp r0.x, -r0, c13.y, c13
mul_pp r1.x, r2, r0
mov_pp r3.xyz, c4
cmp_pp r6.xyz, -r1.x, c13.x, r3
mov r1.xyz, c3
add r4.xyz, -c2, r1
add r3.xyz, t0, -c7
dp3 r3.x, r3, r3
abs_pp r1.x, r0
mul r4.xyz, r4, c6.x
rsq r3.x, r3.x
rcp r3.x, r3.x
add r3.x, r3, -c8
cmp_pp r1.x, -r1, c13.y, c13
add r7.xyz, r4, c2
mul_pp r4.x, r2, r1
cmp_pp r6.xyz, -r4.x, r6, r7
mov r7.xyz, c10
abs_pp r2.x, r2
add r7.xyz, -c9, r7
mul r7.xyz, r7, c12.x
cmp r3.x, r3, c13, c13.y
cmp_pp r2.x, -r2, c13.y, c13
mul_pp r4.x, r3, r2
mul_pp r0.x, r4, r0
cmp_pp r6.xyz, -r0.x, r6, c11
mul_pp r0.x, r4, r1
add r7.xyz, r7, c9
cmp_pp r1.xyz, -r0.x, r6, r7
abs_pp r0.x, r3
mul_pp r3.xyz, r5.w, r5
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r1.xyz, r3, r1
mul_pp r0.x, r0, r2
mul_pp r1.xyz, r1, c13.z
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [unity_Lightmap] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 15 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedphmleepnnkkigidemgmplchnhjcfonenabaaaaaadaaeaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfiadaaaaeaaaaaaangaaaaaa
fjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaa
aaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaa
fgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaa
caaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaa
jgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaah
pcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaa
abaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaah
ccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaa
abaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaa
aaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaa
fgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaaj
pcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [unity_Lightmap] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 15 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedjmkgnpmgnfkcikgagkijoafcnkobeillabaaaaaakeagaaaaaeaaaaaa
daaaaaaakaacaaaaaaagaaaahaagaaaaebgpgodjgiacaaaagiacaaaaaaacpppp
bmacaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaaaaaaajaaagaaagaa
aaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaebaaaaaaaa
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaadlabpaaaaacaaaaaaja
aaaiapkaecaaaaadaaaacpiaabaaoelaaaaioekaacaaaaadabaaahiaaaaaoelb
aaaaoekaaiaaaaadabaaabiaabaaoeiaabaaoeiaahaaaaacabaaabiaabaaaaia
agaaaaacabaaabiaabaaaaiaacaaaaadabaaabiaabaaaaiaabaaaakbacaaaaad
acaaahiaaaaaoelbagaaoekaaiaaaaadabaaaciaacaaoeiaacaaoeiaahaaaaac
abaaaciaabaaffiaagaaaaacabaaaciaabaaffiaacaaaaadabaaaciaabaaffia
ahaaaakbabaaaaacacaaahiaaiaaoekaacaaaaadadaaahiaacaaoeibajaaoeka
aeaaaaaeacaachiaalaaffkaadaaoeiaacaaoeiaabaaaaacacaaaiiaamaaaaka
acaaaaadacaaaiiaacaappiaafaaaakbafaaaaadacaaaiiaacaappiaacaappia
fiaaaaaeacaachiaacaappibakaaoekaacaaoeiafiaaaaaeadaachiaabaaffia
amaaffkaacaaoeiafiaaaaaeadaaciiaabaaffiaamaaffkaamaaaakaabaaaaac
acaaahiaacaaoekaacaaaaadabaaaoiaacaablibadaablkaaeaaaaaeabaacoia
afaaffkaabaaoeiaacaabliafiaaaaaeacaachiaacaappibaeaaoekaabaablia
abaaaaacacaaciiaamaaaakafiaaaaaeabaacpiaabaaaaiaadaaoeiaacaaoeia
afaaaaadaaaaciiaaaaappiaamaakkkaafaaaaadaaaachiaaaaaoeiaaaaappia
afaaaaadabaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaabaaoeiappppaaaa
fdeieefcfiadaaaaeaaaaaaangaaaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaajaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaak
ocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaa
amaaaaaadcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaa
aaaaaaaaagijcaaaaaaaaaaaalaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaa
aaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaa
abaaaaaaegiccaaaaaaaaaaaanaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaa
acaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaacaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaa
agijcaaaaaaaaaaaadaaaaaabaaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaa
jgahbaaaabaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaai
ccaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaak
hcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaa
acaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaa
egaobaaaacaaaaaaegaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaab
ejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [unity_Lightmap] 2D
"!!ARBfp1.0
# 44 ALU, 1 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[0], 2D;
ADD R1.xyz, fragment.texcoord[0], -c[7];
DP3 R1.x, R1, R1;
RSQ R1.w, R1.x;
MOV R2.x, c[13];
ADD R2.w, R2.x, -c[5].x;
ADD R2.xyz, fragment.texcoord[0], -c[0];
DP3 R2.x, R2, R2;
ABS R2.w, R2;
CMP R3.y, -R2.w, c[13], c[13].x;
ABS R2.y, R3;
MOV R1.xyz, c[2];
RSQ R2.x, R2.x;
RCP R2.x, R2.x;
ADD R1.xyz, -R1, c[3];
SLT R2.w, R2.x, c[1].x;
CMP R3.x, -R2.y, c[13].y, c[13];
MUL R2.xyz, R1, c[6].x;
MUL R3.z, R2.w, R3.x;
MUL R1.y, R2.w, R3;
MOV R1.x, c[13].y;
CMP R1.xyz, -R1.y, c[4], R1.x;
ADD R2.xyz, R2, c[2];
CMP R2.xyz, -R3.z, R2, R1;
RCP R1.y, R1.w;
ABS R1.x, R2.w;
SLT R2.w, R1.y, c[8].x;
CMP R1.w, -R1.x, c[13].y, c[13].x;
MUL R3.z, R1.w, R2.w;
MOV R1.xyz, c[9];
MUL R3.y, R3.z, R3;
ADD R1.xyz, -R1, c[10];
MUL R1.xyz, R1, c[12].x;
MUL R0.xyz, R0.w, R0;
CMP R2.xyz, -R3.y, c[11], R2;
MUL R3.x, R3.z, R3;
ADD R1.xyz, R1, c[9];
CMP R1.xyz, -R3.x, R1, R2;
MUL R1.xyz, R0, R1;
ABS R2.x, R2.w;
CMP R0.w, -R2.x, c[13].y, c[13].x;
MUL R0.x, R1.w, R0.w;
MUL result.color.xyz, R1, c[13].z;
CMP result.color.w, -R0.x, c[13].y, c[13].x;
END
# 44 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [unity_Lightmap] 2D
"ps_2_0
; 46 ALU, 1 TEX
dcl_2d s0
def c13, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xyz
dcl t1.xy
texld r5, t1, s0
add r0.xyz, t0, -c0
dp3 r1.x, r0, r0
mov r0.x, c5
rsq r1.x, r1.x
add r0.x, c13.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c1
abs r0.x, r0
cmp r2.x, r1, c13, c13.y
cmp r0.x, -r0, c13.y, c13
mul_pp r1.x, r2, r0
mov_pp r3.xyz, c4
cmp_pp r6.xyz, -r1.x, c13.x, r3
mov r1.xyz, c3
add r4.xyz, -c2, r1
add r3.xyz, t0, -c7
dp3 r3.x, r3, r3
abs_pp r1.x, r0
mul r4.xyz, r4, c6.x
rsq r3.x, r3.x
rcp r3.x, r3.x
add r3.x, r3, -c8
cmp_pp r1.x, -r1, c13.y, c13
add r7.xyz, r4, c2
mul_pp r4.x, r2, r1
cmp_pp r6.xyz, -r4.x, r6, r7
mov r7.xyz, c10
abs_pp r2.x, r2
add r7.xyz, -c9, r7
mul r7.xyz, r7, c12.x
cmp r3.x, r3, c13, c13.y
cmp_pp r2.x, -r2, c13.y, c13
mul_pp r4.x, r3, r2
mul_pp r0.x, r4, r0
cmp_pp r6.xyz, -r0.x, r6, c11
mul_pp r0.x, r4, r1
add r7.xyz, r7, c9
cmp_pp r1.xyz, -r0.x, r6, r7
abs_pp r0.x, r3
mul_pp r3.xyz, r5.w, r5
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r1.xyz, r3, r1
mul_pp r0.x, r0, r2
mul_pp r1.xyz, r1, c13.z
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [unity_Lightmap] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 15 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedphmleepnnkkigidemgmplchnhjcfonenabaaaaaadaaeaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfiadaaaaeaaaaaaangaaaaaa
fjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaa
aaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaa
fgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaa
caaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaa
jgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaah
pcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaa
abaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaah
ccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaa
abaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaa
aaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaa
fgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaaj
pcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [unity_Lightmap] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 15 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedhklliblbamjgandgfkbcbcebbfjicpanabaaaaaakeagaaaaaeaaaaaa
daaaaaaakaacaaaaaaagaaaahaagaaaaebgpgodjgiacaaaagiacaaaaaaacpppp
bmacaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaaaaaaajaaagaaagaa
aaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaebaaaaaaaa
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaadlabpaaaaacaaaaaaja
aaaiapkaecaaaaadaaaacpiaabaaoelaaaaioekaacaaaaadabaaahiaaaaaoelb
aaaaoekaaiaaaaadabaaabiaabaaoeiaabaaoeiaahaaaaacabaaabiaabaaaaia
agaaaaacabaaabiaabaaaaiaacaaaaadabaaabiaabaaaaiaabaaaakbacaaaaad
acaaahiaaaaaoelbagaaoekaaiaaaaadabaaaciaacaaoeiaacaaoeiaahaaaaac
abaaaciaabaaffiaagaaaaacabaaaciaabaaffiaacaaaaadabaaaciaabaaffia
ahaaaakbabaaaaacacaaahiaaiaaoekaacaaaaadadaaahiaacaaoeibajaaoeka
aeaaaaaeacaachiaalaaffkaadaaoeiaacaaoeiaabaaaaacacaaaiiaamaaaaka
acaaaaadacaaaiiaacaappiaafaaaakbafaaaaadacaaaiiaacaappiaacaappia
fiaaaaaeacaachiaacaappibakaaoekaacaaoeiafiaaaaaeadaachiaabaaffia
amaaffkaacaaoeiafiaaaaaeadaaciiaabaaffiaamaaffkaamaaaakaabaaaaac
acaaahiaacaaoekaacaaaaadabaaaoiaacaablibadaablkaaeaaaaaeabaacoia
afaaffkaabaaoeiaacaabliafiaaaaaeacaachiaacaappibaeaaoekaabaablia
abaaaaacacaaaiiaamaaaakafiaaaaaeabaacpiaabaaaaiaadaaoeiaacaaoeia
afaaaaadaaaaciiaaaaappiaamaakkkaafaaaaadaaaachiaaaaaoeiaaaaappia
afaaaaadabaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaabaaoeiappppaaaa
fdeieefcfiadaaaaeaaaaaaangaaaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaajaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaak
ocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaa
amaaaaaadcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaa
aaaaaaaaagijcaaaaaaaaaaaalaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaa
aaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaa
abaaaaaaegiccaaaaaaaaaaaanaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaa
acaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaacaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaa
agijcaaaaaaaaaaaadaaaaaabaaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaa
jgahbaaaabaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaai
ccaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaak
hcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaa
agaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaa
acaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaa
egaobaaaacaaaaaaegaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaab
ejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Brush1Pos]
Float 3 [_Brush1Radius]
Vector 4 [_Brush1ColorSelectedLow]
Vector 5 [_Brush1ColorSelectedHigh]
Vector 6 [_Brush1DirtyColor]
Float 7 [_Brush1ActivationFlag]
Float 8 [_Brush1ActivationState]
Vector 9 [_Brush2Pos]
Float 10 [_Brush2Radius]
Vector 11 [_Brush2ColorSelectedLow]
Vector 12 [_Brush2ColorSelectedHigh]
Vector 13 [_Brush2DirtyColor]
Float 14 [_Brush2ActivationState]
SetTexture 0 [_ShadowMapTexture] 2D
"!!ARBfp1.0
# 48 ALU, 1 TEX
PARAM c[16] = { program.local[0..14],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TXP R2.x, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, fragment.texcoord[0], -c[9];
DP3 R1.w, R0, R0;
MOV R0.xyz, c[4];
MOV R0.w, c[15].x;
ADD R0.w, R0, -c[7].x;
ABS R2.y, R0.w;
ADD R1.xyz, fragment.texcoord[0], -c[2];
DP3 R0.w, R1, R1;
CMP R2.w, -R2.y, c[15].y, c[15].x;
ABS R1.x, R2.w;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
ADD R0.xyz, -R0, c[5];
CMP R2.z, -R1.x, c[15].y, c[15].x;
MUL R1.xyz, R0, c[8].x;
SLT R0.w, R0, c[3].x;
ADD R1.xyz, R1, c[4];
MUL R2.y, R0.w, R2.z;
MUL R0.y, R0.w, R2.w;
MOV R0.x, c[15].y;
CMP R0.xyz, -R0.y, c[6], R0.x;
CMP R0.xyz, -R2.y, R1, R0;
RSQ R1.x, R1.w;
RCP R1.x, R1.x;
SLT R1.w, R1.x, c[10].x;
ABS R0.w, R0;
CMP R0.w, -R0, c[15].y, c[15].x;
MUL R2.y, R1.w, R0.w;
MUL R2.w, R2.y, R2;
MOV R1.xyz, c[11];
ADD R1.xyz, -R1, c[12];
MUL R1.xyz, R1, c[14].x;
ABS R1.w, R1;
CMP R1.w, -R1, c[15].y, c[15].x;
MUL R0.w, R0, R1;
MUL R2.y, R2, R2.z;
ADD R1.xyz, R1, c[11];
CMP R0.xyz, -R2.w, c[13], R0;
CMP R0.xyz, -R2.y, R1, R0;
MUL R1.xyz, R0, c[1];
DP3 R2.y, fragment.texcoord[1], c[0];
MAX R2.y, R2, c[15];
MUL R2.x, R2.y, R2;
MUL R1.xyz, R2.x, R1;
MUL R0.xyz, R0, fragment.texcoord[2];
MAD result.color.xyz, R1, c[15].z, R0;
CMP result.color.w, -R0, c[15].y, c[15].x;
END
# 48 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Brush1Pos]
Float 3 [_Brush1Radius]
Vector 4 [_Brush1ColorSelectedLow]
Vector 5 [_Brush1ColorSelectedHigh]
Vector 6 [_Brush1DirtyColor]
Float 7 [_Brush1ActivationFlag]
Float 8 [_Brush1ActivationState]
Vector 9 [_Brush2Pos]
Float 10 [_Brush2Radius]
Vector 11 [_Brush2ColorSelectedLow]
Vector 12 [_Brush2ColorSelectedHigh]
Vector 13 [_Brush2DirtyColor]
Float 14 [_Brush2ActivationState]
SetTexture 0 [_ShadowMapTexture] 2D
"ps_2_0
; 50 ALU, 1 TEX
dcl_2d s0
def c15, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3
texldp r7, t3, s0
add r0.xyz, t0, -c2
dp3 r1.x, r0, r0
mov r0.x, c7
rsq r1.x, r1.x
add r0.x, c15.y, -r0
rcp r1.x, r1.x
abs r0.x, r0
add r1.x, r1, -c3
cmp r0.x, -r0, c15.y, c15
cmp r1.x, r1, c15, c15.y
mul_pp r2.x, r1, r0
mov_pp r4.xyz, c6
cmp_pp r5.xyz, -r2.x, c15.x, r4
add r3.xyz, t0, -c9
dp3 r2.x, r3, r3
rsq r3.x, r2.x
abs_pp r2.x, r0
mov r4.xyz, c5
add r4.xyz, -c4, r4
mul r4.xyz, r4, c8.x
rcp r3.x, r3.x
add r3.x, r3, -c10
add r6.xyz, r4, c4
cmp_pp r2.x, -r2, c15.y, c15
mul_pp r4.x, r1, r2
cmp_pp r5.xyz, -r4.x, r5, r6
mov r6.xyz, c12
abs_pp r1.x, r1
add r6.xyz, -c11, r6
mul r6.xyz, r6, c14.x
cmp_pp r1.x, -r1, c15.y, c15
cmp r3.x, r3, c15, c15.y
mul_pp r4.x, r1, r3
mul_pp r0.x, r4, r0
cmp_pp r5.xyz, -r0.x, r5, c13
mul_pp r0.x, r4, r2
add r6.xyz, r6, c11
cmp_pp r4.xyz, -r0.x, r5, r6
dp3_pp r2.x, t1, c0
abs_pp r0.x, r3
cmp_pp r0.x, -r0, c15.y, c15
mul_pp r0.x, r1, r0
cmp_pp r0.w, -r0.x, c15.y, c15.x
mul_pp r5.xyz, r4, c1
max_pp r2.x, r2, c15
mul_pp r2.x, r2, r7
mul_pp r2.xyz, r2.x, r5
mul_pp r1.xyz, r4, t2
mad_pp r0.xyz, r2, c15.z, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_ShadowMapTexture] 2D 0
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 19 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgnnfobemflpcfdghgppliofedifjihfaabaaaaaaaiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaaaeaaaaeaaaaaaaaaabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaapaaaaaa
agijcaaaaaaaaaaabaaaaaaadcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaa
bcaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaapaaaaaacaaaaaaibcaabaaa
abaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaajgahbaaaaaaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaia
ebaaaaaaabaaaaaaagijcaaaaaaaaaaaahaaaaaabaaaaaahccaabaaaabaaaaaa
jgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaa
abaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaa
aiaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaa
egiccaaaaaaaaaaaakaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaa
amaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaaegacbaaaacaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaa
fgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegbcbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaa
aeaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
abaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaaagaabaaaacaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_ShadowMapTexture] 2D 0
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 19 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedjhbklinkinfjbhgelpglbbajoeddmbgiabaaaaaabaaiaaaaaeaaaaaa
daaaaaaadeadaaaadmahaaaanmahaaaaebgpgodjpmacaaaapmacaaaaaaacpppp
jiacaaaageaaaaaaafaaciaaaaaageaaaaaageaaabaaceaaaaaageaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaafaaabaaaaaaaaaaaaaaamaaabaaagaa
acaaaaaaaaaaanaaagaaahaaaaaaaaaaabaaaaaaabaaanaaaaaaaaaaaaacpppp
fbaaaaafaoaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaahlabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaac
aaaaaaiaadaaaplabpaaaaacaaaaaajaaaaiapkaacaaaaadaaaaahiaaaaaoelb
abaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaia
agaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaacaaaakbacaaaaad
abaaahiaaaaaoelbahaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeiaahaaaaac
aaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffia
aiaaaakbabaaaaacabaaahiaajaaoekaacaaaaadacaaahiaabaaoeibakaaoeka
aeaaaaaeabaachiaamaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiiaaoaaaaka
acaaaaadabaaaiiaabaappiaagaaaakbafaaaaadabaaaiiaabaappiaabaappia
fiaaaaaeabaachiaabaappibalaaoekaabaaoeiafiaaaaaeacaachiaaaaaffia
aoaaffkaabaaoeiafiaaaaaeacaaciiaaaaaffiaaoaaffkaaoaaaakaabaaaaac
abaaahiaadaaoekaacaaaaadaaaaaoiaabaablibaeaablkaaeaaaaaeaaaacoia
agaaffkaaaaaoeiaabaabliafiaaaaaeabaachiaabaappibafaaoekaaaaablia
abaaaaacabaaciiaaoaaaakafiaaaaaeaaaacpiaaaaaaaiaacaaoeiaabaaoeia
afaaaaadabaachiaaaaaoeiaaaaaoekaagaaaaacabaaaiiaadaapplaafaaaaad
acaaadiaabaappiaadaaoelaecaaaaadacaacpiaacaaoeiaaaaioekaaiaaaaad
abaaciiaabaaoelaanaaoekaafaaaaadacaacbiaacaaaaiaabaappiafiaaaaae
abaaciiaabaappiaacaaaaiaaoaaffkaacaaaaadabaaciiaabaappiaabaappia
afaaaaadacaachiaaaaaoeiaacaaoelaaeaaaaaeaaaachiaabaaoeiaabaappia
acaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcaaaeaaaaeaaaaaaa
aaabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
gcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaa
aaaaaaaaanaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaakocaabaaa
aaaaaaaaagijcaiaebaaaaaaaaaaaaaaapaaaaaaagijcaaaaaaaaaaabaaaaaaa
dcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaabcaaaaaafgaobaaaaaaaaaaa
agijcaaaaaaaaaaaapaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaa
amaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaa
egiccaaaaaaaaaaabbaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaa
abeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaa
acaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaa
aaaaaaaaahaaaaaabaaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaa
abaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaa
abaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaakhcaabaaa
acaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaaakaaaaaa
dcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaaacaaaaaa
egiccaaaaaaaaaaaajaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaa
egiccaaaaaaaaaaaalaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaa
abeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaa
acaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egbcbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaabaaaaaai
icaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaapaaaaahicaabaaa
aaaaaaaapgapbaaaaaaaaaaaagaabaaaacaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheo
jiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 50 ALU, 2 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0, 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[1], 2D;
TXP R3.x, fragment.texcoord[2], texture[0], 2D;
ADD R1.xyz, fragment.texcoord[0], -c[7];
DP3 R1.x, R1, R1;
RSQ R1.w, R1.x;
MOV R2.x, c[13];
ADD R2.w, R2.x, -c[5].x;
ADD R2.xyz, fragment.texcoord[0], -c[0];
DP3 R2.x, R2, R2;
ABS R2.w, R2;
CMP R3.z, -R2.w, c[13].y, c[13].x;
ABS R2.y, R3.z;
MOV R1.xyz, c[2];
RSQ R2.x, R2.x;
RCP R2.x, R2.x;
ADD R1.xyz, -R1, c[3];
SLT R2.w, R2.x, c[1].x;
CMP R3.y, -R2, c[13], c[13].x;
MUL R2.xyz, R1, c[6].x;
MUL R3.w, R2, R3.y;
MUL R1.y, R2.w, R3.z;
MOV R1.x, c[13].y;
CMP R1.xyz, -R1.y, c[4], R1.x;
ADD R2.xyz, R2, c[2];
CMP R2.xyz, -R3.w, R2, R1;
RCP R1.y, R1.w;
ABS R1.x, R2.w;
SLT R2.w, R1.y, c[8].x;
CMP R1.w, -R1.x, c[13].y, c[13].x;
MUL R3.w, R1, R2;
MOV R1.xyz, c[9];
MUL R3.z, R3.w, R3;
ADD R1.xyz, -R1, c[10];
MUL R1.xyz, R1, c[12].x;
CMP R2.xyz, -R3.z, c[11], R2;
MUL R3.y, R3.w, R3;
ADD R1.xyz, R1, c[9];
CMP R1.xyz, -R3.y, R1, R2;
MUL R2.xyz, R0, R3.x;
MUL R0.xyz, R0.w, R0;
ABS R0.w, R2;
CMP R0.w, -R0, c[13].y, c[13].x;
MUL R0.w, R1, R0;
MUL R0.xyz, R0, c[13].z;
MUL R2.xyz, R2, c[13].w;
MIN R2.xyz, R0, R2;
MUL R0.xyz, R0, R3.x;
MAX R0.xyz, R2, R0;
MUL result.color.xyz, R1, R0;
CMP result.color.w, -R0, c[13].y, c[13].x;
END
# 50 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 51 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c13, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xyz
dcl t1.xy
dcl t2
texldp r1, t2, s0
texld r0, t1, s1
mul_pp r2.xyz, r0.w, r0
mul_pp r0.xyz, r0, r1.x
mul_pp r2.xyz, r2, c13.z
mul_pp r0.xyz, r0, c13.w
mov r8.xyz, c3
add r8.xyz, -c2, r8
mul r8.xyz, r8, c6.x
mul_pp r1.xyz, r2, r1.x
min_pp r0.xyz, r2, r0
max_pp r6.xyz, r0, r1
add r1.xyz, t0, -c7
dp3 r1.x, r1, r1
mov r2.x, c5
add r4.x, c13.y, -r2
add r0.xyz, t0, -c0
dp3 r0.x, r0, r0
rsq r0.x, r0.x
rsq r1.x, r1.x
rcp r0.x, r0.x
add r0.x, r0, -c1
cmp r3.x, r0, c13, c13.y
abs_pp r0.x, r3
rcp r1.x, r1.x
add r1.x, r1, -c8
abs r4.x, r4
cmp r4.x, -r4, c13.y, c13
mul_pp r5.x, r3, r4
mov_pp r7.xyz, c4
cmp_pp r7.xyz, -r5.x, c13.x, r7
abs_pp r5.x, r4
cmp_pp r5.x, -r5, c13.y, c13
cmp r1.x, r1, c13, c13.y
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r2.x, r1, r0
abs_pp r1.x, r1
cmp_pp r1.x, -r1, c13.y, c13
mul_pp r0.x, r1, r0
mul_pp r3.x, r3, r5
add r8.xyz, r8, c2
cmp_pp r7.xyz, -r3.x, r7, r8
mul_pp r3.x, r2, r4
mov r4.xyz, c10
add r4.xyz, -c9, r4
mul r4.xyz, r4, c12.x
cmp_pp r3.xyz, -r3.x, r7, c11
mul_pp r2.x, r2, r5
add r4.xyz, r4, c9
cmp_pp r2.xyz, -r2.x, r3, r4
mul_pp r1.xyz, r2, r6
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 320 // 296 used size, 19 vars
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 32 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhanbijdgklgpmgihnkedgmjhlcccddhhabaaaaaadmafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcemaeaaaaeaaaaaaabdabaaaafjaaaaaeegiocaaa
aaaaaaaabdaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaadhcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadlcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaoaaaaahdcaabaaa
aaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
anaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
elaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaakhcaabaaaabaaaaaa
egiccaiaebaaaaaaaaaaaaaaapaaaaaaegiccaaaaaaaaaaabaaaaaaadcaaaaal
hcaabaaaabaaaaaafgifcaaaaaaaaaaabcaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaapaaaaaacaaaaaaiicaabaaaabaaaaaaakiacaaaaaaaaaaaamaaaaaa
abeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaapgapbaaaabaaaaaaegiccaaa
aaaaaaaabbaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpabaaaaahpcaabaaaacaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
elaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaakhcaabaaaabaaaaaa
egiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaal
hcaabaaaabaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaajaaaaaadhaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegiccaaa
aaaaaaaaalaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaiadpdhaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaa
egaobaaaacaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 320 // 296 used size, 19 vars
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 32 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecediloaopoehbkddkcckebkfgghnlblkihpabaaaaaaeiaiaaaaaeaaaaaa
daaaaaaadiadaaaaimahaaaabeaiaaaaebgpgodjaaadaaaaaaadaaaaaaacpppp
laacaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaaaaaaaaa
abababaaaaaaahaaafaaaaaaaaaaaaaaaaaaamaaabaaafaaacaaaaaaaaaaanaa
agaaagaaaaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaeb
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaadlabpaaaaac
aaaaaaiaacaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
agaaaaacaaaaaiiaacaapplaafaaaaadaaaaadiaaaaappiaacaaoelaecaaaaad
aaaacpiaaaaaoeiaaaaioekaecaaaaadabaacpiaabaaoelaabaioekaacaaaaad
aaaacciaaaaaaaiaaaaaaaiaafaaaaadaaaacoiaabaabliaaaaaffiaafaaaaad
abaaciiaabaappiaamaakkkaafaaaaadabaachiaabaaoeiaabaappiaakaaaaad
acaachiaaaaabliaabaaoeiaafaaaaadaaaachiaaaaaaaiaabaaoeiaalaaaaad
abaachiaacaaoeiaaaaaoeiaacaaaaadaaaaahiaaaaaoelbaaaaoekaaiaaaaad
abaaaiiaaaaaoeiaaaaaoeiaahaaaaacabaaaiiaabaappiaagaaaaacabaaaiia
abaappiaacaaaaadabaaaiiaabaappiaabaaaakbacaaaaadaaaaahiaaaaaoelb
agaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaia
agaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaahaaaakbabaaaaac
acaaahiaaiaaoekaacaaaaadaaaaaoiaacaablibajaablkaaeaaaaaeaaaacoia
alaaffkaaaaaoeiaacaabliaabaaaaacacaaabiaamaaaakaacaaaaadacaaabia
acaaaaiaafaaaakbafaaaaadacaaabiaacaaaaiaacaaaaiafiaaaaaeaaaacoia
acaaaaibakaablkaaaaaoeiafiaaaaaeadaachiaaaaaaaiaamaaffkaaaaablia
fiaaaaaeadaaciiaaaaaaaiaamaaffkaamaaaakaabaaaaacaaaaahiaacaaoeka
acaaaaadacaaaoiaaaaablibadaablkaaeaaaaaeaaaachiaafaaffkaacaablia
aaaaoeiafiaaaaaeaaaachiaacaaaaibaeaaoekaaaaaoeiaabaaaaacaaaaciia
amaaaakafiaaaaaeaaaacpiaabaappiaadaaoeiaaaaaoeiaafaaaaadaaaachia
abaaoeiaaaaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcemaeaaaa
eaaaaaaabdabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaa
abaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaddaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadeaaaaahhcaabaaaaaaaaaaa
jgahbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaapaaaaaa
egiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
bcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaaiicaabaaa
abaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
acaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaa
egiccaaaaaaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
amaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakhcaabaaa
abaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaacaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaabaaaaaadoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 50 ALU, 2 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0, 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[1], 2D;
TXP R3.x, fragment.texcoord[2], texture[0], 2D;
ADD R1.xyz, fragment.texcoord[0], -c[7];
DP3 R1.x, R1, R1;
RSQ R1.w, R1.x;
MOV R2.x, c[13];
ADD R2.w, R2.x, -c[5].x;
ADD R2.xyz, fragment.texcoord[0], -c[0];
DP3 R2.x, R2, R2;
ABS R2.w, R2;
CMP R3.z, -R2.w, c[13].y, c[13].x;
ABS R2.y, R3.z;
MOV R1.xyz, c[2];
RSQ R2.x, R2.x;
RCP R2.x, R2.x;
ADD R1.xyz, -R1, c[3];
SLT R2.w, R2.x, c[1].x;
CMP R3.y, -R2, c[13], c[13].x;
MUL R2.xyz, R1, c[6].x;
MUL R3.w, R2, R3.y;
MUL R1.y, R2.w, R3.z;
MOV R1.x, c[13].y;
CMP R1.xyz, -R1.y, c[4], R1.x;
ADD R2.xyz, R2, c[2];
CMP R2.xyz, -R3.w, R2, R1;
RCP R1.y, R1.w;
ABS R1.x, R2.w;
SLT R2.w, R1.y, c[8].x;
CMP R1.w, -R1.x, c[13].y, c[13].x;
MUL R3.w, R1, R2;
MOV R1.xyz, c[9];
MUL R3.z, R3.w, R3;
ADD R1.xyz, -R1, c[10];
MUL R1.xyz, R1, c[12].x;
CMP R2.xyz, -R3.z, c[11], R2;
MUL R3.y, R3.w, R3;
ADD R1.xyz, R1, c[9];
CMP R1.xyz, -R3.y, R1, R2;
MUL R2.xyz, R0, R3.x;
MUL R0.xyz, R0.w, R0;
ABS R0.w, R2;
CMP R0.w, -R0, c[13].y, c[13].x;
MUL R0.w, R1, R0;
MUL R0.xyz, R0, c[13].z;
MUL R2.xyz, R2, c[13].w;
MIN R2.xyz, R0, R2;
MUL R0.xyz, R0, R3.x;
MAX R0.xyz, R2, R0;
MUL result.color.xyz, R1, R0;
CMP result.color.w, -R0, c[13].y, c[13].x;
END
# 50 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 51 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c13, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xyz
dcl t1.xy
dcl t2
texldp r1, t2, s0
texld r0, t1, s1
mul_pp r2.xyz, r0.w, r0
mul_pp r0.xyz, r0, r1.x
mul_pp r2.xyz, r2, c13.z
mul_pp r0.xyz, r0, c13.w
mov r8.xyz, c3
add r8.xyz, -c2, r8
mul r8.xyz, r8, c6.x
mul_pp r1.xyz, r2, r1.x
min_pp r0.xyz, r2, r0
max_pp r6.xyz, r0, r1
add r1.xyz, t0, -c7
dp3 r1.x, r1, r1
mov r2.x, c5
add r4.x, c13.y, -r2
add r0.xyz, t0, -c0
dp3 r0.x, r0, r0
rsq r0.x, r0.x
rsq r1.x, r1.x
rcp r0.x, r0.x
add r0.x, r0, -c1
cmp r3.x, r0, c13, c13.y
abs_pp r0.x, r3
rcp r1.x, r1.x
add r1.x, r1, -c8
abs r4.x, r4
cmp r4.x, -r4, c13.y, c13
mul_pp r5.x, r3, r4
mov_pp r7.xyz, c4
cmp_pp r7.xyz, -r5.x, c13.x, r7
abs_pp r5.x, r4
cmp_pp r5.x, -r5, c13.y, c13
cmp r1.x, r1, c13, c13.y
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r2.x, r1, r0
abs_pp r1.x, r1
cmp_pp r1.x, -r1, c13.y, c13
mul_pp r0.x, r1, r0
mul_pp r3.x, r3, r5
add r8.xyz, r8, c2
cmp_pp r7.xyz, -r3.x, r7, r8
mul_pp r3.x, r2, r4
mov r4.xyz, c10
add r4.xyz, -c9, r4
mul r4.xyz, r4, c12.x
cmp_pp r3.xyz, -r3.x, r7, c11
mul_pp r2.x, r2, r5
add r4.xyz, r4, c9
cmp_pp r2.xyz, -r2.x, r3, r4
mul_pp r1.xyz, r2, r6
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 320 // 296 used size, 19 vars
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 32 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhanbijdgklgpmgihnkedgmjhlcccddhhabaaaaaadmafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcemaeaaaaeaaaaaaabdabaaaafjaaaaaeegiocaaa
aaaaaaaabdaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaadhcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadlcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaoaaaaahdcaabaaa
aaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
anaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
elaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaakhcaabaaaabaaaaaa
egiccaiaebaaaaaaaaaaaaaaapaaaaaaegiccaaaaaaaaaaabaaaaaaadcaaaaal
hcaabaaaabaaaaaafgifcaaaaaaaaaaabcaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaapaaaaaacaaaaaaiicaabaaaabaaaaaaakiacaaaaaaaaaaaamaaaaaa
abeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaapgapbaaaabaaaaaaegiccaaa
aaaaaaaabbaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpabaaaaahpcaabaaaacaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
elaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaakhcaabaaaabaaaaaa
egiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaal
hcaabaaaabaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaajaaaaaadhaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegiccaaa
aaaaaaaaalaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaiadpdhaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaa
egaobaaaacaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 320 // 296 used size, 19 vars
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 32 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedhomckpbkdmaliojmmfmmllhiihdjjdbgabaaaaaaeiaiaaaaaeaaaaaa
daaaaaaadiadaaaaimahaaaabeaiaaaaebgpgodjaaadaaaaaaadaaaaaaacpppp
laacaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaaaaaaaaa
abababaaaaaaahaaafaaaaaaaaaaaaaaaaaaamaaabaaafaaacaaaaaaaaaaanaa
agaaagaaaaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaeb
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaadlabpaaaaac
aaaaaaiaacaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
agaaaaacaaaaaiiaacaapplaafaaaaadaaaaadiaaaaappiaacaaoelaecaaaaad
aaaacpiaaaaaoeiaaaaioekaecaaaaadabaacpiaabaaoelaabaioekaacaaaaad
aaaacciaaaaaaaiaaaaaaaiaafaaaaadaaaacoiaabaabliaaaaaffiaafaaaaad
abaaciiaabaappiaamaakkkaafaaaaadabaachiaabaaoeiaabaappiaakaaaaad
acaachiaaaaabliaabaaoeiaafaaaaadaaaachiaaaaaaaiaabaaoeiaalaaaaad
abaachiaacaaoeiaaaaaoeiaacaaaaadaaaaahiaaaaaoelbaaaaoekaaiaaaaad
abaaaiiaaaaaoeiaaaaaoeiaahaaaaacabaaaiiaabaappiaagaaaaacabaaaiia
abaappiaacaaaaadabaaaiiaabaappiaabaaaakbacaaaaadaaaaahiaaaaaoelb
agaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaia
agaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaahaaaakbabaaaaac
acaaahiaaiaaoekaacaaaaadaaaaaoiaacaablibajaablkaaeaaaaaeaaaacoia
alaaffkaaaaaoeiaacaabliaabaaaaacacaaabiaamaaaakaacaaaaadacaaabia
acaaaaiaafaaaakbafaaaaadacaaabiaacaaaaiaacaaaaiafiaaaaaeaaaacoia
acaaaaibakaablkaaaaaoeiafiaaaaaeadaachiaaaaaaaiaamaaffkaaaaablia
fiaaaaaeadaaciiaaaaaaaiaamaaffkaamaaaakaabaaaaacaaaaahiaacaaoeka
acaaaaadacaaaoiaaaaablibadaablkaaeaaaaaeaaaachiaafaaffkaacaablia
aaaaoeiafiaaaaaeaaaachiaacaaaaibaeaaoekaaaaaoeiaabaaaaacaaaaaiia
amaaaakafiaaaaaeaaaacpiaabaappiaadaaoeiaaaaaoeiaafaaaaadaaaachia
abaaoeiaaaaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcemaeaaaa
eaaaaaaabdabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaa
abaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaddaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadeaaaaahhcaabaaaaaaaaaaa
jgahbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaapaaaaaa
egiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
bcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaaiicaabaaa
abaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
acaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaa
egiccaaaaaaaaaaaakaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
amaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakhcaabaaa
abaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaacaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaabaaaaaadoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 12 to 19
//   d3d9 - ALU: 12 to 19
//   d3d11 - ALU: 12 to 21, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 12 to 21, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 18 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
MOV R0.xyz, R1;
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
MUL R0.xyz, vertex.normal, c[14].w;
MOV result.texcoord[0].xyz, R1;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
ADD result.texcoord[2].xyz, -R1, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mov r0.xyz, r1
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
mul r0.xyz, v1, c13.w
mov oT0.xyz, r1
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
add oT2.xyz, -r1, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedeggeiohekgjdnpbhllpmhenfjmiailaiabaaaaaagaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcmeadaaaaeaaaabaa
pbaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_19;
  c_19.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_18)).w) * 2.0));
  c_19.w = tmpvar_4;
  c_1.xyz = c_19.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_19;
  c_19.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_18)).w) * 2.0));
  c_19.w = tmpvar_4;
  c_1.xyz = c_19.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecediloninpilfeddoldbimnaaipomchdapoabaaaaaakeahaaaaaeaaaaaa
daaaaaaahaacaaaadmagaaaaaeahaaaaebgpgodjdiacaaaadiacaaaaaaacpopp
neabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaadaa
aeaaabaaaaaaaaaaabaaaaaaabaaafaaaaaaaaaaacaaaaaaaeaaagaaaaaaaaaa
acaaamaaaeaaakaaaaaaaaaaacaabeaaabaaaoaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahia
acaaoejaaoaappkaafaaaaadabaaahiaaaaaffiaalaaoekaaeaaaaaeaaaaalia
akaakekaaaaaaaiaabaakeiaaeaaaaaeabaaahoaamaaoekaaaaakkiaaaaapeia
afaaaaadaaaaahiaaaaaffjaalaaoekaaeaaaaaeaaaaahiaakaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahia
anaaoekaaaaappjaaaaaoeiaacaaaaadacaaahoaaaaaoeibafaaoekaabaaaaac
aaaaahoaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaahiaaaaaffia
acaaoekaaeaaaaaeabaaahiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahia
adaaoekaaaaakkiaabaaoeiaaeaaaaaeadaaahoaaeaaoekaaaaappiaaaaaoeia
afaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
ajaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcmeadaaaaeaaaabaapbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 408
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 451
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
#line 397
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
#line 401
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
#line 405
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 415
#line 460
#line 472
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 460
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 464
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 468
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 408
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 451
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
#line 397
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
#line 401
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
#line 405
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 415
#line 460
#line 472
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 415
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 419
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 424
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 428
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 435
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 441
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 448
            o.Alpha = 0.0;
        }
    }
}
#line 472
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 476
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 480
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 484
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, (texture( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.0));
    c.w = 0.0;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 10 [unity_Scale]
"!!ARBvp1.0
# 12 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
MOV result.texcoord[2].xyz, c[9];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 12 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 9 [unity_Scale]
"vs_2_0
; 12 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c9.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
mov oT2.xyz, c8
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityLighting" 0
BindCB "UnityPerDraw" 1
// 14 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedifmmdicljbajcfelooiojgpdbkjlicepabaaaaaanmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
fiacaaaaeaaaabaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafjaaaaae
egiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaabaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
abaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaghccabaaaadaaaaaaegiccaaaaaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_17;
  c_17.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * 2.0));
  c_17.w = tmpvar_4;
  c_1.xyz = c_17.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_17;
  c_17.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * 2.0));
  c_17.w = tmpvar_4;
  c_1.xyz = c_17.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityLighting" 0
BindCB "UnityPerDraw" 1
// 14 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedppiejcnccahnjgfbdenhjjkjpbbiallcabaaaaaagmafaaaaaeaaaaaa
daaaaaaalmabaaaabmaeaaaaoeaeaaaaebgpgodjieabaaaaieabaaaaaaacpopp
cmabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaaaaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaaeaaagaaaaaaaaaa
abaabeaaabaaakaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaahoaajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaahia
acaaoejaakaappkaafaaaaadabaaahiaaaaaffiaahaaoekaaeaaaaaeaaaaalia
agaakekaaaaaaaiaabaakeiaaeaaaaaeabaaahoaaiaaoekaaaaakkiaaaaapeia
afaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
afaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaabaaaaacacaaahoaabaaoekappppaaaafdeieefc
fiacaaaaeaaaabaajgaaaaaafjaaaaaeegiocaaaaaaaaaaaabaaaaaafjaaaaae
egiocaaaabaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
abaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaabaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaabaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
abaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaabaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaghccabaaaadaaaaaaegiccaaaaaaaaaaaaaaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 461
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 466
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 468
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 470
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 474
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 478
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingLambert( o, lightDir, 1.0);
    #line 482
    c.w = 0.0;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 19 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
MOV R0.xyz, R1;
DP4 result.texcoord[3].w, R0, c[12];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
MUL R0.xyz, vertex.normal, c[14].w;
MOV result.texcoord[0].xyz, R1;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
ADD result.texcoord[2].xyz, -R1, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_normal0 v1
dp4 r0.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mov r0.xyz, r1
dp4 oT3.w, r0, c11
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
mul r0.xyz, v1, c13.w
mov oT0.xyz, r1
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
add oT2.xyz, -r1, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedheppiiemelniihmhmobnmkjeakadceefabaaaaaagaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcmeadaaaaeaaaabaa
pbaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaa
aeaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaaeaaaaaa
egiocaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_17;
  highp vec2 P_18;
  P_18 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5);
  highp float tmpvar_19;
  tmpvar_19 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp float atten_20;
  atten_20 = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, P_18).w) * texture2D (_LightTextureB0, vec2(tmpvar_19)).w);
  lowp vec4 c_21;
  c_21.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * atten_20) * 2.0));
  c_21.w = tmpvar_4;
  c_1.xyz = c_21.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_17;
  highp vec2 P_18;
  P_18 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5);
  highp float tmpvar_19;
  tmpvar_19 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp float atten_20;
  atten_20 = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, P_18).w) * texture2D (_LightTextureB0, vec2(tmpvar_19)).w);
  lowp vec4 c_21;
  c_21.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * atten_20) * 2.0));
  c_21.w = tmpvar_4;
  c_1.xyz = c_21.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedbllmdjgnfcjbopmfhdgpgiemehgkfiababaaaaaakeahaaaaaeaaaaaa
daaaaaaahaacaaaadmagaaaaaeahaaaaebgpgodjdiacaaaadiacaaaaaaacpopp
neabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaadaa
aeaaabaaaaaaaaaaabaaaaaaabaaafaaaaaaaaaaacaaaaaaaeaaagaaaaaaaaaa
acaaamaaaeaaakaaaaaaaaaaacaabeaaabaaaoaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahia
acaaoejaaoaappkaafaaaaadabaaahiaaaaaffiaalaaoekaaeaaaaaeaaaaalia
akaakekaaaaaaaiaabaakeiaaeaaaaaeabaaahoaamaaoekaaaaakkiaaaaapeia
afaaaaadaaaaahiaaaaaffjaalaaoekaaeaaaaaeaaaaahiaakaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahia
anaaoekaaaaappjaaaaaoeiaacaaaaadacaaahoaaaaaoeibafaaoekaabaaaaac
aaaaahoaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaapiaaaaaffia
acaaoekaaeaaaaaeabaaapiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeabaaapia
adaaoekaaaaakkiaabaaoeiaaeaaaaaeadaaapoaaeaaoekaaaaappiaabaaoeia
afaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
ajaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcmeadaaaaeaaaabaapbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaaeaaaaaaegiocaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 417
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 460
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
#line 406
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
#line 410
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
#line 414
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 424
#line 469
#line 481
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 469
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 473
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 477
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec4(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 417
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 460
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
#line 406
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
#line 410
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
#line 414
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 424
#line 469
#line 481
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 398
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 394
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.5)).w;
}
#line 424
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 428
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 433
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 437
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 444
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 450
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 457
            o.Alpha = 0.0;
        }
    }
}
#line 481
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 485
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 489
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 493
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.0)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.0));
    c.w = 0.0;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 18 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
MOV R0.xyz, R1;
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
MUL R0.xyz, vertex.normal, c[14].w;
MOV result.texcoord[0].xyz, R1;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
ADD result.texcoord[2].xyz, -R1, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mov r0.xyz, r1
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
mul r0.xyz, v1, c13.w
mov oT0.xyz, r1
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
add oT2.xyz, -r1, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedeggeiohekgjdnpbhllpmhenfjmiailaiabaaaaaagaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcmeadaaaaeaaaabaa
pbaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaa
adaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
lcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaa
abaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaa
aaaaaaaaegadbaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaa
aeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaa
egiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_19;
  c_19.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_18)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.0));
  c_19.w = tmpvar_4;
  c_1.xyz = c_19.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_19;
  c_19.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_18)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.0));
  c_19.w = tmpvar_4;
  c_1.xyz = c_19.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 23 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecediloninpilfeddoldbimnaaipomchdapoabaaaaaakeahaaaaaeaaaaaa
daaaaaaahaacaaaadmagaaaaaeahaaaaebgpgodjdiacaaaadiacaaaaaaacpopp
neabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaadaa
aeaaabaaaaaaaaaaabaaaaaaabaaafaaaaaaaaaaacaaaaaaaeaaagaaaaaaaaaa
acaaamaaaeaaakaaaaaaaaaaacaabeaaabaaaoaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahia
acaaoejaaoaappkaafaaaaadabaaahiaaaaaffiaalaaoekaaeaaaaaeaaaaalia
akaakekaaaaaaaiaabaakeiaaeaaaaaeabaaahoaamaaoekaaaaakkiaaaaapeia
afaaaaadaaaaahiaaaaaffjaalaaoekaaeaaaaaeaaaaahiaakaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahia
anaaoekaaaaappjaaaaaoeiaacaaaaadacaaahoaaaaaoeibafaaoekaabaaaaac
aaaaahoaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaahiaaaaaffia
acaaoekaaeaaaaaeabaaahiaabaaoekaaaaaaaiaabaaoeiaaeaaaaaeaaaaahia
adaaoekaaaaakkiaabaaoeiaaeaaaaaeadaaahoaaeaaoekaaaaappiaaaaaoeia
afaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
ajaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcmeadaaaaeaaaabaapbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaadaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 452
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
#line 397
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
#line 401
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
#line 405
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 416
#line 461
#line 473
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 461
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 465
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 469
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 452
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
#line 397
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
#line 401
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
#line 405
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 416
#line 461
#line 473
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 416
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 420
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 425
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 429
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 436
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 442
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 449
            o.Alpha = 0.0;
        }
    }
}
#line 473
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 477
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 481
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 485
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, ((texture( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * texture( _LightTexture0, IN._LightCoord).w) * 1.0));
    c.w = 0.0;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
"!!ARBvp1.0
# 17 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
MOV R0.xyz, R1;
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
MUL R0.xyz, vertex.normal, c[14].w;
MOV result.texcoord[0].xyz, R1;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
MOV result.texcoord[2].xyz, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
mov r0.xyz, r1
dp4 r0.w, v0, c7
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
mul r0.xyz, v1, c13.w
mov oT0.xyz, r1
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
mov oT2.xyz, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkimgndiefljboidhlmdjljeplodphjkiabaaaaaaeaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckeadaaaaeaaaabaa
ojaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaaddccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaacaaaaaa
beaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaacaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaadaaaaaa
egiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaa
aeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakdccabaaaaeaaaaaa
egiacaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaabaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_17;
  c_17.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_17.w = tmpvar_4;
  c_1.xyz = c_17.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  tmpvar_3 = vec3(0.0, 0.0, 0.0);
  tmpvar_4 = 0.0;
  highp float tmpvar_5;
  highp vec3 p_6;
  p_6 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_5 = sqrt(dot (p_6, p_6));
  highp float tmpvar_7;
  highp vec3 p_8;
  p_8 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_7 = sqrt(dot (p_8, p_8));
  if ((tmpvar_5 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_9;
      tmpvar_9 = _Brush1DirtyColor.xyz;
      tmpvar_3 = tmpvar_9;
    } else {
      mediump vec4 dirtyColor_10;
      highp vec4 tmpvar_11;
      tmpvar_11 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_10 = tmpvar_11;
      mediump vec3 tmpvar_12;
      tmpvar_12 = dirtyColor_10.xyz;
      tmpvar_3 = tmpvar_12;
    };
    tmpvar_4 = 1.0;
  } else {
    if ((tmpvar_7 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_13;
        tmpvar_13 = _Brush2DirtyColor.xyz;
        tmpvar_3 = tmpvar_13;
      } else {
        mediump vec4 dirtyColor_1_14;
        highp vec4 tmpvar_15;
        tmpvar_15 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_14 = tmpvar_15;
        mediump vec3 tmpvar_16;
        tmpvar_16 = dirtyColor_1_14.xyz;
        tmpvar_3 = tmpvar_16;
      };
      tmpvar_4 = 1.0;
    } else {
      tmpvar_4 = 0.0;
    };
  };
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_17;
  c_17.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_17.w = tmpvar_4;
  c_1.xyz = c_17.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "$Globals" 304 // 112 used size, 18 vars
Matrix 48 [_LightMatrix0] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedkbneicjgffcbjfbcjjjmhnjdfpcdficfabaaaaaaheahaaaaaeaaaaaa
daaaaaaagaacaaaaamagaaaaneagaaaaebgpgodjciacaaaaciacaaaaaaacpopp
meabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaadaa
aeaaabaaaaaaaaaaabaaaaaaabaaafaaaaaaaaaaacaaaaaaaeaaagaaaaaaaaaa
acaaamaaaeaaakaaaaaaaaaaacaabeaaabaaaoaaaaaaaaaaaaaaaaaaaaacpopp
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahia
aaaaffjaalaaoekaaeaaaaaeaaaaahiaakaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahoaanaaoekaaaaappja
aaaaoeiaafaaaaadaaaaahiaacaaoejaaoaappkaafaaaaadabaaahiaaaaaffia
alaaoekaaeaaaaaeaaaaaliaakaakekaaaaaaaiaabaakeiaaeaaaaaeabaaahoa
amaaoekaaaaakkiaaaaapeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaae
aaaaapiaakaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaadia
aaaaffiaacaaoekaaeaaaaaeaaaaadiaabaaoekaaaaaaaiaabaaoeiaaeaaaaae
aaaaadiaadaaoekaaaaakkiaaaaaoeiaaeaaaaaeadaaadoaaeaaoekaaaaappia
aaaaoeiaafaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaajaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacacaaahoaafaaoekappppaaaa
fdeieefckeadaaaaeaaaabaaojaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaa
acaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaa
acaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaa
acaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaa
dgaaaaaghccabaaaadaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaa
aaaaaaaaegiacaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaa
dcaaaaakdccabaaaaeaaaaaaegiacaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egaabaaaaaaaaaaadoaaaaabejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 408
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 451
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
#line 397
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
#line 401
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
#line 405
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 415
#line 460
#line 472
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 460
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 464
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 468
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xy;
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec2(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 408
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 451
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
#line 397
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
#line 401
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
#line 405
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
uniform highp float _Brush2ActivationState;
#line 415
#line 460
#line 472
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 415
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 419
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 424
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 428
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 435
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 441
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 448
            o.Alpha = 0.0;
        }
    }
}
#line 472
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 476
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 480
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 484
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingLambert( o, lightDir, (texture( _LightTexture0, IN._LightCoord).w * 1.0));
    c.w = 0.0;
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 43 to 54, TEX: 0 to 2
//   d3d9 - ALU: 46 to 56, TEX: 1 to 2
//   d3d11 - ALU: 19 to 29, TEX: 0 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 19 to 29, TEX: 0 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTexture0] 2D
"!!ARBfp1.0
# 48 ALU, 1 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV result.color.w, c[14].y;
TEX R0.w, R0.x, texture[0], 2D;
ADD R0.xyz, fragment.texcoord[0], -c[1];
DP3 R0.x, R0, R0;
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
SLT R2.w, R0.x, c[2].x;
ADD R0.xyz, fragment.texcoord[0], -c[8];
DP3 R0.y, R0, R0;
MOV R0.x, c[14];
ABS R1.x, R2.w;
ADD R0.z, R0.x, -c[6].x;
RSQ R0.y, R0.y;
RCP R0.x, R0.y;
ABS R0.y, R0.z;
CMP R2.y, -R0, c[14], c[14].x;
CMP R1.x, -R1, c[14].y, c[14];
SLT R0.x, R0, c[9];
MUL R1.w, R1.x, R0.x;
ABS R1.x, R2.y;
CMP R2.x, -R1, c[14].y, c[14];
MOV R0.xyz, c[3];
ADD R0.xyz, -R0, c[4];
MUL R1.xyz, R0, c[7].x;
ADD R1.xyz, R1, c[3];
MUL R2.z, R2.w, R2.x;
MUL R0.y, R2.w, R2;
MOV R0.x, c[14].y;
CMP R0.xyz, -R0.y, c[5], R0.x;
CMP R0.xyz, -R2.z, R1, R0;
MUL R1.x, R1.w, R2.y;
CMP R0.xyz, -R1.x, c[12], R0;
MUL R1.w, R1, R2.x;
MOV R1.xyz, c[10];
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
ADD R1.xyz, -R1, c[11];
RSQ R2.x, R2.x;
MUL R1.xyz, R1, c[13].x;
ADD R1.xyz, R1, c[10];
CMP R0.xyz, -R1.w, R1, R0;
MUL R2.xyz, R2.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R2;
MAX R1.x, R1, c[14].y;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[14].z;
END
# 48 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTexture0] 2D
"ps_2_0
; 51 ALU, 1 TEX
dcl_2d s0
def c14, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
add r1.xyz, t0, -c8
dp3 r2.x, r1, r1
dp3 r0.x, t3, t3
mov r0.xy, r0.x
rsq r2.x, r2.x
rcp r2.x, r2.x
add r3.x, r2, -c9
mov r2.x, c6
add r2.x, c14.y, -r2
abs r2.x, r2
mov r5.xyz, c4
add r5.xyz, -c3, r5
mul r5.xyz, r5, c7.x
cmp r2.x, -r2, c14.y, c14
cmp r3.x, r3, c14, c14.y
mov_pp r4.xyz, c5
add r5.xyz, r5, c3
mov_pp r0.w, c14.x
texld r6, r0, s0
add r0.xyz, t0, -c1
dp3 r0.x, r0, r0
rsq r0.x, r0.x
rcp r0.x, r0.x
add r0.x, r0, -c2
cmp r1.x, r0, c14, c14.y
abs_pp r0.x, r1
cmp_pp r0.x, -r0, c14.y, c14
mul_pp r0.x, r0, r3
mul_pp r3.x, r1, r2
cmp_pp r4.xyz, -r3.x, c14.x, r4
abs_pp r3.x, r2
cmp_pp r3.x, -r3, c14.y, c14
mul_pp r1.x, r1, r3
cmp_pp r5.xyz, -r1.x, r4, r5
mul_pp r1.x, r0, r2
mul_pp r0.x, r0, r3
cmp_pp r2.xyz, -r1.x, r5, c12
mov r4.xyz, c11
add r1.xyz, -c10, r4
mul r3.xyz, r1, c13.x
dp3_pp r1.x, t2, t2
add r3.xyz, r3, c10
rsq_pp r1.x, r1.x
cmp_pp r0.xyz, -r0.x, r2, r3
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t1, r1
mul_pp r0.xyz, r0, c0
max_pp r1.x, r1, c14
mul_pp r1.x, r1, r6
mul_pp r0.xyz, r1.x, r0
mul_pp r0.xyz, r0, c14.z
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTexture0] 2D 0
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedapgpikdakljokfkejlkfjkcojiaemcbpabaaaaaapeaeaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcomadaaaaeaaaaaaaplaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaajocaabaaaaaaaaaaa
agbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaabaaaaaahccaabaaa
aaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaa
apaaaaaaegiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaa
aaaaaaaabcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaai
ecaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaak
hcaabaaaabaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaa
abaaaaaaabaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaa
aaaaaaaaakaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakocaabaaaaaaaaaaa
kgakbaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaaacaaaaaadhaaaaaj
hcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
aaaaaaaaegbcbaaaadaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "POINT" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTexture0] 2D 0
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedbjgdjbiifpjlepfabdghbgdjdoccbkbnabaaaaaamiahaaaaaeaaaaaa
daaaaaaaaaadaaaapeagaaaajeahaaaaebgpgodjmiacaaaamiacaaaaaaacpppp
haacaaaafiaaaaaaaeaaciaaaaaafiaaaaaafiaaabaaceaaaaaafiaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaafaaabaaaaaaaaaaaaaaamaaabaaagaa
acaaaaaaaaaaanaaagaaahaaaaaaaaaaaaacppppfbaaaaafanaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaia
abaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaiaadaaahlabpaaaaac
aaaaaajaaaaiapkaacaaaaadaaaaahiaaaaaoelbabaaoekaaiaaaaadaaaaabia
aaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaiaagaaaaacaaaaabiaaaaaaaia
acaaaaadaaaaabiaaaaaaaiaacaaaakbacaaaaadabaaahiaaaaaoelbahaaoeka
aiaaaaadaaaaaciaabaaoeiaabaaoeiaahaaaaacaaaaaciaaaaaffiaagaaaaac
aaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffiaaiaaaakbabaaaaacabaaahia
ajaaoekaacaaaaadacaaahiaabaaoeibakaaoekaaeaaaaaeabaachiaamaaffka
acaaoeiaabaaoeiaabaaaaacabaaaiiaanaaaakaacaaaaadabaaaiiaabaappia
agaaaakbafaaaaadabaaaiiaabaappiaabaappiafiaaaaaeabaachiaabaappib
alaaoekaabaaoeiafiaaaaaeaaaacoiaaaaaffiaanaaffkaabaabliaabaaaaac
abaaahiaadaaoekaacaaaaadacaaahiaabaaoeibaeaaoekaaeaaaaaeabaachia
agaaffkaacaaoeiaabaaoeiafiaaaaaeabaachiaabaappibafaaoekaabaaoeia
fiaaaaaeaaaachiaaaaaaaiaaaaabliaabaaoeiaafaaaaadaaaachiaaaaaoeia
aaaaoekaaiaaaaadabaaadiaadaaoelaadaaoelaecaaaaadabaacpiaabaaoeia
aaaioekaceaaaaacacaachiaacaaoelaaiaaaaadaaaaciiaabaaoelaacaaoeia
afaaaaadabaacbiaabaaaaiaaaaappiafiaaaaaeaaaaciiaaaaappiaabaaaaia
anaaffkaacaaaaadaaaaciiaaaaappiaaaaappiaafaaaaadaaaachiaaaaappia
aaaaoeiaabaaaaacaaaaaiiaanaaffkaabaaaaacaaaicpiaaaaaoeiappppaaaa
fdeieefcomadaaaaeaaaaaaaplaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaajocaabaaaaaaaaaaa
agbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaabaaaaaahccaabaaa
aaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaa
apaaaaaaegiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaa
aaaaaaaabcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaai
ecaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaak
hcaabaaaabaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaa
abaaaaaaabaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaa
aaaaaaaaakaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakocaabaaaaaaaaaaa
kgakbaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaaacaaaaaadhaaaaaj
hcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
aaaaaaaaegbcbaaaadaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaa
efaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaaagaabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
"!!ARBfp1.0
# 43 ALU, 0 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
ADD R0.xyz, fragment.texcoord[0], -c[1];
DP3 R0.x, R0, R0;
ADD R1.xyz, fragment.texcoord[0], -c[8];
DP3 R0.z, R1, R1;
MOV R0.y, c[14].x;
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
SLT R2.z, R0.x, c[2].x;
ABS R0.x, R2.z;
ADD R0.w, R0.y, -c[6].x;
RSQ R0.z, R0.z;
RCP R0.y, R0.z;
ABS R0.z, R0.w;
CMP R2.x, -R0.z, c[14].y, c[14];
ABS R0.w, R2.x;
CMP R0.w, -R0, c[14].y, c[14].x;
MUL R2.y, R2.z, R0.w;
CMP R0.x, -R0, c[14].y, c[14];
SLT R0.y, R0, c[9].x;
MUL R1.w, R0.x, R0.y;
MOV R0.xyz, c[3];
ADD R0.xyz, -R0, c[4];
MUL R1.xyz, R0, c[7].x;
MUL R0.y, R2.z, R2.x;
MOV R0.x, c[14].y;
ADD R1.xyz, R1, c[3];
CMP R0.xyz, -R0.y, c[5], R0.x;
CMP R0.xyz, -R2.y, R1, R0;
MUL R2.x, R1.w, R2;
CMP R0.xyz, -R2.x, c[12], R0;
MOV R1.xyz, c[10];
ADD R1.xyz, -R1, c[11];
MUL R1.xyz, R1, c[13].x;
MUL R0.w, R1, R0;
ADD R1.xyz, R1, c[10];
CMP R0.xyz, -R0.w, R1, R0;
MOV R2.xyz, fragment.texcoord[2];
DP3 R0.w, fragment.texcoord[1], R2;
MUL R0.xyz, R0, c[0];
MAX R0.w, R0, c[14].y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[14].z;
MOV result.color.w, c[14].y;
END
# 43 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
"ps_2_0
; 46 ALU
def c14, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
add r0.xyz, t0, -c8
dp3 r1.x, r0, r0
add r0.xyz, t0, -c1
dp3 r2.x, r0, r0
mov r0.x, c6
rsq r2.x, r2.x
add r0.x, c14.y, -r0
rcp r2.x, r2.x
abs r0.x, r0
add r2.x, r2, -c2
cmp r0.x, -r0, c14.y, c14
cmp r2.x, r2, c14, c14.y
mul_pp r3.x, r2, r0
mov_pp r4.xyz, c5
cmp_pp r5.xyz, -r3.x, c14.x, r4
rsq r1.x, r1.x
rcp r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c4
add r4.xyz, -c3, r4
mul r4.xyz, r4, c7.x
add r3.x, r3, -c9
cmp_pp r1.x, -r1, c14.y, c14
add r6.xyz, r4, c3
mul_pp r4.x, r2, r1
abs_pp r2.x, r2
cmp r3.x, r3, c14, c14.y
cmp_pp r2.x, -r2, c14.y, c14
mul_pp r2.x, r2, r3
mov r3.xyz, c11
add r3.xyz, -c10, r3
mul_pp r0.x, r2, r0
cmp_pp r4.xyz, -r4.x, r5, r6
cmp_pp r4.xyz, -r0.x, r4, c12
mul_pp r0.x, r2, r1
mul r3.xyz, r3, c13.x
add r1.xyz, r3, c10
cmp_pp r1.xyz, -r0.x, r4, r1
mov_pp r2.xyz, t2
dp3_pp r0.x, t1, r2
mul_pp r1.xyz, r1, c0
max_pp r0.x, r0, c14
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c14.z
mov_pp r0.w, c14.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 240 // 232 used size, 17 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
// 24 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 1 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedabfdoccjcckceaoppfinijffgigbghccabaaaaaaciaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcdiadaaaaeaaaaaaamoaaaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
adaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaajocaabaaaaaaaaaaa
agbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaabaaaaaahccaabaaa
aaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaakaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaa
alaaaaaaegiccaaaaaaaaaaaamaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaa
aaaaaaaaaoaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaacaaaaaai
ecaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaak
hcaabaaaabaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaaegacbaaa
abaaaaaaabaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakocaabaaaaaaaaaaa
kgakbaaaaaaaaaaaagijcaaaaaaaaaaaahaaaaaaagajbaaaacaaaaaadhaaaaaj
hcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaadaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 240 // 232 used size, 17 vars
Vector 16 [_LightColor0] 4
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
// 24 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 1 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedgdodpihjghmakkilfnkhgfahjfgmlhcaabaaaaaakmagaaaaaeaaaaaa
daaaaaaalaacaaaapaafaaaahiagaaaaebgpgodjhiacaaaahiacaaaaaaacpppp
ceacaaaafeaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaaaaafeaaaaaaabaa
abaaaaaaaaaaaaaaaaaaadaaafaaabaaaaaaaaaaaaaaaiaaabaaagaaacaaaaaa
aaaaajaaagaaahaaaaaaaaaaaaacppppfbaaaaafanaaapkaaaaaiadpaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaachla
bpaaaaacaaaaaaiaacaachlaacaaaaadaaaaahiaaaaaoelbabaaoekaaiaaaaad
aaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaiaagaaaaacaaaaabia
aaaaaaiaacaaaaadaaaaabiaaaaaaaiaacaaaakbacaaaaadabaaahiaaaaaoelb
ahaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeiaahaaaaacaaaaaciaaaaaffia
agaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffiaaiaaaakbabaaaaac
abaaahiaajaaoekaacaaaaadacaaahiaabaaoeibakaaoekaaeaaaaaeabaachia
amaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiiaanaaaakaacaaaaadabaaaiia
abaappiaagaaaakbafaaaaadabaaaiiaabaappiaabaappiafiaaaaaeabaachia
abaappibalaaoekaabaaoeiafiaaaaaeaaaacoiaaaaaffiaanaaffkaabaablia
abaaaaacabaaahiaadaaoekaacaaaaadacaaahiaabaaoeibaeaaoekaaeaaaaae
abaachiaagaaffkaacaaoeiaabaaoeiafiaaaaaeabaachiaabaappibafaaoeka
abaaoeiafiaaaaaeaaaachiaaaaaaaiaaaaabliaabaaoeiaafaaaaadaaaachia
aaaaoeiaaaaaoekaabaaaaacabaaahiaabaaoelaaiaaaaadaaaaciiaabaaoeia
acaaoelaalaaaaadabaacbiaaaaappiaanaaffkaacaaaaadaaaaciiaabaaaaia
abaaaaiaafaaaaadaaaachiaaaaappiaaaaaoeiaabaaaaacaaaaaiiaanaaffka
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcdiadaaaaeaaaaaaamoaaaaaa
fjaaaaaeegiocaaaaaaaaaaaapaaaaaagcbaaaadhcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaadaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaaj
ocaabaaaaaaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaa
baaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaalaaaaaaegiccaaaaaaaaaaaamaaaaaadcaaaaalhcaabaaa
abaaaaaafgifcaaaaaaaaaaaaoaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
alaaaaaacaaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaa
abaaaaaadhaaaaakhcaabaaaabaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaa
anaaaaaaegacbaaaabaaaaaaabaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaa
egacbaaaabaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaa
afaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaa
aaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaak
ocaabaaaaaaaaaaakgakbaaaaaaaaaaaagijcaaaaaaaaaaaahaaaaaaagajbaaa
acaaaaaadhaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaa
adaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaa
giaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTexture0] 2D
SetTexture 1 [_LightTextureB0] 2D
"!!ARBfp1.0
# 54 ALU, 2 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
RCP R0.x, fragment.texcoord[3].w;
MAD R0.zw, fragment.texcoord[3].xyxy, R0.x, c[14].z;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV R2.y, c[14];
MOV result.color.w, c[14].y;
TEX R1.w, R0.zwzw, texture[0], 2D;
TEX R0.w, R0.x, texture[1], 2D;
ADD R0.xyz, fragment.texcoord[0], -c[1];
DP3 R0.x, R0, R0;
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
SLT R2.x, R0, c[2];
ADD R0.xyz, fragment.texcoord[0], -c[8];
DP3 R0.x, R0, R0;
ABS R1.x, R2;
RSQ R0.y, R0.x;
MOV R0.z, c[14].x;
ADD R0.x, R0.z, -c[6];
ABS R0.x, R0;
RCP R0.y, R0.y;
CMP R1.z, -R0.x, c[14].y, c[14].x;
CMP R1.x, -R1, c[14].y, c[14];
SLT R0.y, R0, c[9].x;
MUL R1.y, R1.x, R0;
ABS R1.x, R1.z;
CMP R1.x, -R1, c[14].y, c[14];
MUL R2.w, R2.x, R1.x;
MUL R2.x, R2, R1.z;
MOV R0.xyz, c[3];
ADD R0.xyz, -R0, c[4];
MUL R0.xyz, R0, c[7].x;
CMP R2.xyz, -R2.x, c[5], R2.y;
ADD R0.xyz, R0, c[3];
CMP R0.xyz, -R2.w, R0, R2;
MUL R1.z, R1.y, R1;
MOV R2.xyz, c[10];
CMP R0.xyz, -R1.z, c[12], R0;
ADD R2.xyz, -R2, c[11];
MUL R2.w, R1.y, R1.x;
MUL R1.xyz, R2, c[13].x;
ADD R1.xyz, R1, c[10];
CMP R0.xyz, -R2.w, R1, R0;
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.x, R2.x;
MUL R1.xyz, R2.x, fragment.texcoord[2];
DP3 R1.y, fragment.texcoord[1], R1;
SLT R1.x, c[14].y, fragment.texcoord[3].z;
MUL R1.x, R1, R1.w;
MUL R0.w, R1.x, R0;
MAX R1.x, R1.y, c[14].y;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[14].w;
END
# 54 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTexture0] 2D
SetTexture 1 [_LightTextureB0] 2D
"ps_2_0
; 56 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c14, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3
dp3 r1.x, t3, t3
mov r1.xy, r1.x
rcp r0.x, t3.w
mad r0.xy, t3, r0.x, c14.z
add r3.xyz, t0, -c8
mov_pp r4.xyz, c5
texld r6, r1, s1
texld r0, r0, s0
add r0.xyz, t0, -c1
dp3 r1.x, r0, r0
mov r0.x, c6
rsq r1.x, r1.x
add r0.x, c14.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c2
abs r0.x, r0
cmp r2.x, r1, c14, c14.y
cmp r0.x, -r0, c14.y, c14
mul_pp r1.x, r2, r0
cmp_pp r5.xyz, -r1.x, c14.x, r4
dp3 r1.x, r3, r3
rsq r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c4
add r4.xyz, -c3, r4
mul r4.xyz, r4, c7.x
rcp r3.x, r3.x
add r3.x, r3, -c9
cmp_pp r1.x, -r1, c14.y, c14
add r7.xyz, r4, c3
mul_pp r4.x, r2, r1
cmp_pp r4.xyz, -r4.x, r5, r7
abs_pp r2.x, r2
cmp r3.x, r3, c14, c14.y
cmp_pp r2.x, -r2, c14.y, c14
mul_pp r2.x, r2, r3
mul_pp r0.x, r2, r0
cmp_pp r4.xyz, -r0.x, r4, c12
mov r5.xyz, c11
add r3.xyz, -c10, r5
mul r3.xyz, r3, c13.x
mul_pp r0.x, r2, r1
add r3.xyz, r3, c10
cmp_pp r0.xyz, -r0.x, r4, r3
mul_pp r2.xyz, r0, c0
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
cmp r0.x, -t3.z, c14, c14.y
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t1, r1
mul_pp r0.x, r0, r6
max_pp r1.x, r1, c14
mul_pp r0.x, r1, r0
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c14.w
mov_pp r0.w, c14.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_LightTextureB0] 2D 1
// 36 instructions, 3 temp regs, 0 temp arrays:
// ALU 26 float, 1 int, 2 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfhandbmdmojpjabmnadkkjfihilnpdbaabaaaaaaoiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcoaaeaaaaeaaaaaaadiabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaajocaabaaaaaaaaaaaagbjbaia
ebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaabaaaaaahccaabaaaaaaaaaaa
jgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaapaaaaaa
egiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
bcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaaiecaabaaa
aaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaaabaaaaaa
abaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaak
hcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaa
akaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakocaabaaaaaaaaaaakgakbaaa
aaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaaacaaaaaadhaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaaaeaaaaaa
abaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaa
agaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaapaaaaahicaabaaa
aaaaaaaaagaabaaaabaaaaaapgapbaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_LightTextureB0] 2D 1
// 36 instructions, 3 temp regs, 0 temp arrays:
// ALU 26 float, 1 int, 2 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecednokcnlofmilnphfdjihmiaefhciceaddabaaaaaabmajaaaaaeaaaaaa
daaaaaaagaadaaaaeiaiaaaaoiaiaaaaebgpgodjciadaaaaciadaaaaaaacpppp
mmacaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaaaaaaaaa
abababaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaafaaabaaaaaaaaaaaaaaamaa
abaaagaaacaaaaaaaaaaanaaagaaahaaaaaaaaaaaaacppppfbaaaaafanaaapka
aaaaiadpaaaaaaaaaaaaaadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaac
aaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaiaadaaapla
bpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaacaaaaadaaaaahia
aaaaoelbabaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabia
aaaaaaiaagaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaacaaaakb
acaaaaadabaaahiaaaaaoelbahaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeia
ahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaacia
aaaaffiaaiaaaakbabaaaaacabaaahiaajaaoekaacaaaaadacaaahiaabaaoeib
akaaoekaaeaaaaaeabaachiaamaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiia
anaaaakaacaaaaadabaaaiiaabaappiaagaaaakbafaaaaadabaaaiiaabaappia
abaappiafiaaaaaeabaachiaabaappibalaaoekaabaaoeiafiaaaaaeaaaacoia
aaaaffiaanaaffkaabaabliaabaaaaacabaaahiaadaaoekaacaaaaadacaaahia
abaaoeibaeaaoekaaeaaaaaeabaachiaagaaffkaacaaoeiaabaaoeiafiaaaaae
abaachiaabaappibafaaoekaabaaoeiafiaaaaaeaaaachiaaaaaaaiaaaaablia
abaaoeiaafaaaaadaaaachiaaaaaoeiaaaaaoekaagaaaaacaaaaaiiaadaappla
aeaaaaaeabaaadiaadaaoelaaaaappiaanaakkkaaiaaaaadacaaadiaadaaoela
adaaoelaecaaaaadabaacpiaabaaoeiaaaaioekaecaaaaadacaacpiaacaaoeia
abaioekaafaaaaadaaaaciiaabaappiaacaaaaiafiaaaaaeaaaaciiaadaakklb
anaaffkaaaaappiaceaaaaacabaachiaacaaoelaaiaaaaadabaacbiaabaaoela
abaaoeiaalaaaaadacaacbiaabaaaaiaanaaffkaafaaaaadaaaaciiaaaaappia
acaaaaiaacaaaaadaaaaciiaaaaappiaaaaappiaafaaaaadaaaachiaaaaappia
aaaaoeiaabaaaaacaaaaaiiaanaaffkaabaaaaacaaaicpiaaaaaoeiappppaaaa
fdeieefcoaaeaaaaeaaaaaaadiabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaajocaabaaaaaaaaaaaagbjbaia
ebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaabaaaaaahccaabaaaaaaaaaaa
jgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaapaaaaaa
egiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
bcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaaiecaabaaa
aaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaaabaaaaaa
abaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaak
hcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaa
akaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakocaabaaaaaaaaaaakgakbaaa
aaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaaacaaaaaadhaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaaeaaaaaapgbpbaaaaeaaaaaaaaaaaaakdcaabaaa
abaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaaaeaaaaaa
abaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaah
icaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaa
abaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaa
agaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
bcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaapaaaaahicaabaaa
aaaaaaaaagaabaaaabaaaaaapgapbaaaaaaaaaaadiaaaaahhccabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTextureB0] 2D
SetTexture 1 [_LightTexture0] CUBE
"!!ARBfp1.0
# 50 ALU, 2 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[3], texture[1], CUBE;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV R2.y, c[14];
MOV result.color.w, c[14].y;
TEX R1.w, R0.x, texture[0], 2D;
ADD R0.xyz, fragment.texcoord[0], -c[1];
DP3 R0.x, R0, R0;
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
SLT R2.x, R0, c[2];
ADD R0.xyz, fragment.texcoord[0], -c[8];
DP3 R0.x, R0, R0;
ABS R1.x, R2;
RSQ R0.y, R0.x;
MOV R0.z, c[14].x;
ADD R0.x, R0.z, -c[6];
ABS R0.x, R0;
RCP R0.y, R0.y;
CMP R1.z, -R0.x, c[14].y, c[14].x;
CMP R1.x, -R1, c[14].y, c[14];
SLT R0.y, R0, c[9].x;
MUL R1.y, R1.x, R0;
ABS R1.x, R1.z;
CMP R1.x, -R1, c[14].y, c[14];
MUL R2.w, R2.x, R1.x;
MUL R2.x, R2, R1.z;
MOV R0.xyz, c[3];
ADD R0.xyz, -R0, c[4];
MUL R0.xyz, R0, c[7].x;
CMP R2.xyz, -R2.x, c[5], R2.y;
ADD R0.xyz, R0, c[3];
CMP R0.xyz, -R2.w, R0, R2;
MUL R1.z, R1.y, R1;
MOV R2.xyz, c[10];
CMP R0.xyz, -R1.z, c[12], R0;
ADD R2.xyz, -R2, c[11];
MUL R2.w, R1.y, R1.x;
MUL R1.xyz, R2, c[13].x;
ADD R1.xyz, R1, c[10];
CMP R0.xyz, -R2.w, R1, R0;
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.x, R2.x;
MUL R1.xyz, R2.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1, R0;
MAX R1.x, R1, c[14].y;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[14].z;
END
# 50 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTextureB0] 2D
SetTexture 1 [_LightTexture0] CUBE
"ps_2_0
; 52 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c14, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dp3 r0.x, t3, t3
mov r1.xy, r0.x
add r3.xyz, t0, -c8
mov_pp r4.xyz, c5
texld r6, r1, s0
texld r0, t3, s1
add r0.xyz, t0, -c1
dp3 r1.x, r0, r0
mov r0.x, c6
rsq r1.x, r1.x
add r0.x, c14.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c2
abs r0.x, r0
cmp r2.x, r1, c14, c14.y
cmp r0.x, -r0, c14.y, c14
mul_pp r1.x, r2, r0
cmp_pp r5.xyz, -r1.x, c14.x, r4
dp3 r1.x, r3, r3
rsq r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c4
add r4.xyz, -c3, r4
mul r4.xyz, r4, c7.x
rcp r3.x, r3.x
add r3.x, r3, -c9
cmp_pp r1.x, -r1, c14.y, c14
add r7.xyz, r4, c3
mul_pp r4.x, r2, r1
cmp_pp r4.xyz, -r4.x, r5, r7
abs_pp r2.x, r2
cmp r3.x, r3, c14, c14.y
cmp_pp r2.x, -r2, c14.y, c14
mul_pp r2.x, r2, r3
mul_pp r0.x, r2, r0
cmp_pp r4.xyz, -r0.x, r4, c12
mov r5.xyz, c11
add r3.xyz, -c10, r5
mul r3.xyz, r3, c13.x
mul_pp r0.x, r2, r1
add r3.xyz, r3, c10
cmp_pp r1.xyz, -r0.x, r4, r3
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t1, r0
mul r2.x, r6, r0.w
max_pp r0.x, r0, c14
mul_pp r1.xyz, r1, c0
mul_pp r0.x, r0, r2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c14.z
mov_pp r0.w, c14.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTextureB0] 2D 1
SetTexture 1 [_LightTexture0] CUBE 0
// 31 instructions, 3 temp regs, 0 temp arrays:
// ALU 22 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbnmfjmpmanjcjmniegjnfaoobmapjppkabaaaaaafaafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefceiaeaaaaeaaaaaaabcabaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaajocaabaaaaaaaaaaaagbjbaia
ebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaabaaaaaahccaabaaaaaaaaaaa
jgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaapaaaaaa
egiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
bcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaaiecaabaaa
aaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
abaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaaabaaaaaa
abaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaak
hcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaa
akaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakocaabaaaaaaaaaaakgakbaaa
aaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaaacaaaaaadhaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egbcbaaaadaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
abaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaefaaaaaj
pcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbcbaaaaeaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaadkaabaaaacaaaaaa
apaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaaagaabaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTextureB0] 2D 1
SetTexture 1 [_LightTexture0] CUBE 0
// 31 instructions, 3 temp regs, 0 temp arrays:
// ALU 22 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedcpdikbdgkbiaakdcjepbmeilomajnkjaabaaaaaafaaiaaaaaeaaaaaa
daaaaaaacmadaaaahmahaaaabmaiaaaaebgpgodjpeacaaaapeacaaaaaaacpppp
jiacaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaabaaaaaa
aaababaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaafaaabaaaaaaaaaaaaaaamaa
abaaagaaacaaaaaaaaaaanaaagaaahaaaaaaaaaaaaacppppfbaaaaafanaaapka
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaac
aaaaaaiaabaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaiaadaaahla
bpaaaaacaaaaaajiaaaiapkabpaaaaacaaaaaajaabaiapkaacaaaaadaaaaahia
aaaaoelbabaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabia
aaaaaaiaagaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaacaaaakb
acaaaaadabaaahiaaaaaoelbahaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeia
ahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaacia
aaaaffiaaiaaaakbabaaaaacabaaahiaajaaoekaacaaaaadacaaahiaabaaoeib
akaaoekaaeaaaaaeabaachiaamaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiia
anaaaakaacaaaaadabaaaiiaabaappiaagaaaakbafaaaaadabaaaiiaabaappia
abaappiafiaaaaaeabaachiaabaappibalaaoekaabaaoeiafiaaaaaeaaaacoia
aaaaffiaanaaffkaabaabliaabaaaaacabaaahiaadaaoekaacaaaaadacaaahia
abaaoeibaeaaoekaaeaaaaaeabaachiaagaaffkaacaaoeiaabaaoeiafiaaaaae
abaachiaabaappibafaaoekaabaaoeiafiaaaaaeaaaachiaaaaaaaiaaaaablia
abaaoeiaafaaaaadaaaachiaaaaaoeiaaaaaoekaaiaaaaadabaaadiaadaaoela
adaaoelaecaaaaadabaaapiaabaaoeiaabaioekaecaaaaadacaaapiaadaaoela
aaaioekaafaaaaadaaaaciiaabaaaaiaacaappiaceaaaaacabaachiaacaaoela
aiaaaaadabaacbiaabaaoelaabaaoeiaalaaaaadacaacbiaabaaaaiaanaaffka
afaaaaadaaaaciiaaaaappiaacaaaaiaacaaaaadaaaaciiaaaaappiaaaaappia
afaaaaadaaaachiaaaaappiaaaaaoeiaabaaaaacaaaaaiiaanaaffkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefceiaeaaaaeaaaaaaabcabaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafidaaaaeaahabaaaabaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaaj
ocaabaaaaaaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaa
baaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaapaaaaaaegiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaa
abaaaaaafgifcaaaaaaaaaaabcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
apaaaaaacaaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaa
abaaaaaadhaaaaakhcaabaaaabaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaa
bbaaaaaaegacbaaaabaaaaaaabaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaa
egacbaaaabaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaa
ajaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaa
aaaaaaaaamaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaak
ocaabaaaaaaaaaaakgakbaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaa
acaaaaaadhaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaa
adaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegbcbaaaadaaaaaabaaaaaahicaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaaeaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaadkaabaaaacaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaa
agaabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheo
jiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTexture0] 2D
"!!ARBfp1.0
# 45 ALU, 1 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, fragment.texcoord[0], -c[1];
DP3 R0.x, R0, R0;
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
SLT R2.w, R0.x, c[2].x;
ADD R0.xyz, fragment.texcoord[0], -c[8];
DP3 R0.y, R0, R0;
MOV R0.x, c[14];
ABS R1.x, R2.w;
ADD R0.z, R0.x, -c[6].x;
RSQ R0.y, R0.y;
RCP R0.x, R0.y;
ABS R0.y, R0.z;
CMP R2.y, -R0, c[14], c[14].x;
CMP R1.x, -R1, c[14].y, c[14];
SLT R0.x, R0, c[9];
MUL R1.w, R1.x, R0.x;
ABS R1.x, R2.y;
CMP R2.x, -R1, c[14].y, c[14];
MOV R0.xyz, c[3];
ADD R0.xyz, -R0, c[4];
MUL R1.xyz, R0, c[7].x;
MUL R0.y, R2.w, R2;
MUL R2.y, R1.w, R2;
MOV R0.x, c[14].y;
MUL R2.z, R2.w, R2.x;
ADD R1.xyz, R1, c[3];
CMP R0.xyz, -R0.y, c[5], R0.x;
CMP R0.xyz, -R2.z, R1, R0;
MOV R1.xyz, c[10];
ADD R1.xyz, -R1, c[11];
MUL R1.xyz, R1, c[13].x;
CMP R0.xyz, -R2.y, c[12], R0;
MUL R1.w, R1, R2.x;
ADD R1.xyz, R1, c[10];
CMP R0.xyz, -R1.w, R1, R0;
MOV R2.xyz, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R2;
MAX R1.x, R1, c[14].y;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[14].z;
MOV result.color.w, c[14].y;
END
# 45 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Brush1Pos]
Float 2 [_Brush1Radius]
Vector 3 [_Brush1ColorSelectedLow]
Vector 4 [_Brush1ColorSelectedHigh]
Vector 5 [_Brush1DirtyColor]
Float 6 [_Brush1ActivationFlag]
Float 7 [_Brush1ActivationState]
Vector 8 [_Brush2Pos]
Float 9 [_Brush2Radius]
Vector 10 [_Brush2ColorSelectedLow]
Vector 11 [_Brush2ColorSelectedHigh]
Vector 12 [_Brush2DirtyColor]
Float 13 [_Brush2ActivationState]
SetTexture 0 [_LightTexture0] 2D
"ps_2_0
; 47 ALU, 1 TEX
dcl_2d s0
def c14, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r0, t3, s0
add r0.xyz, t0, -c1
dp3 r1.x, r0, r0
mov r0.x, c6
rsq r1.x, r1.x
add r0.x, c14.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c2
abs r0.x, r0
cmp r2.x, r1, c14, c14.y
cmp r0.x, -r0, c14.y, c14
mul_pp r1.x, r2, r0
mov_pp r4.xyz, c5
cmp_pp r5.xyz, -r1.x, c14.x, r4
add r3.xyz, t0, -c8
dp3 r1.x, r3, r3
rsq r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c4
add r4.xyz, -c3, r4
mul r4.xyz, r4, c7.x
rcp r3.x, r3.x
add r3.x, r3, -c9
cmp_pp r1.x, -r1, c14.y, c14
add r6.xyz, r4, c3
mul_pp r4.x, r2, r1
cmp_pp r4.xyz, -r4.x, r5, r6
abs_pp r2.x, r2
cmp r3.x, r3, c14, c14.y
cmp_pp r2.x, -r2, c14.y, c14
mul_pp r2.x, r2, r3
mul_pp r0.x, r2, r0
cmp_pp r4.xyz, -r0.x, r4, c12
mov r5.xyz, c11
add r3.xyz, -c10, r5
mul r3.xyz, r3, c13.x
mul_pp r0.x, r2, r1
add r3.xyz, r3, c10
cmp_pp r1.xyz, -r0.x, r4, r3
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
max_pp r0.x, r0, c14
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1, c0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c14.z
mov_pp r0.w, c14.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTexture0] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecediehikeepblepdadpjmbmdeihobelgoioabaaaaaaimaeaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcieadaaaaeaaaaaaaobaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaaaaaaaajocaabaaaaaaaaaaa
agbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaabaaaaaahccaabaaa
aaaaaaaajgahbaaaaaaaaaaajgahbaaaaaaaaaaaelaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadbaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaaoaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaa
apaaaaaaegiccaaaaaaaaaaabaaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaa
aaaaaaaabcaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaapaaaaaacaaaaaai
ecaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaabaaaaaadhaaaaak
hcaabaaaabaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaabbaaaaaaegacbaaa
abaaaaaaabaaaaahhcaabaaaabaaaaaafgafbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaajaaaaaaegiccaaa
aaaaaaaaakaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaamaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaajaaaaaadhaaaaakocaabaaaaaaaaaaa
kgakbaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaaagajbaaaacaaaaaadhaaaaaj
hcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaadaaaaaadeaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaaeaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaapaaaaah
icaabaaaaaaaaaaapgapbaaaaaaaaaaapgapbaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 304 // 296 used size, 18 vars
Vector 16 [_LightColor0] 4
Vector 112 [_Brush1Pos] 4
Float 128 [_Brush1Radius]
Vector 144 [_Brush1ColorSelectedLow] 4
Vector 160 [_Brush1ColorSelectedHigh] 4
Vector 176 [_Brush1DirtyColor] 4
ScalarInt 192 [_Brush1ActivationFlag]
Float 196 [_Brush1ActivationState]
Vector 208 [_Brush2Pos] 4
Float 224 [_Brush2Radius]
Vector 240 [_Brush2ColorSelectedLow] 4
Vector 256 [_Brush2ColorSelectedHigh] 4
Vector 272 [_Brush2DirtyColor] 4
Float 292 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightTexture0] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedigjdepjgeiljlfonccbpalmhopdfjmdlabaaaaaafaahaaaaaeaaaaaa
daaaaaaapaacaaaahmagaaaabmahaaaaebgpgodjliacaaaaliacaaaaaaacpppp
gaacaaaafiaaaaaaaeaaciaaaaaafiaaaaaafiaaabaaceaaaaaafiaaaaaaaaaa
aaaaabaaabaaaaaaaaaaaaaaaaaaahaaafaaabaaaaaaaaaaaaaaamaaabaaagaa
acaaaaaaaaaaanaaagaaahaaaaaaaaaaaaacppppfbaaaaafanaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaia
abaachlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaiaadaaadlabpaaaaac
aaaaaajaaaaiapkaecaaaaadaaaacpiaadaaoelaaaaioekaacaaaaadaaaaahia
aaaaoelbabaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabia
aaaaaaiaagaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaacaaaakb
acaaaaadabaaahiaaaaaoelbahaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeia
ahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaacia
aaaaffiaaiaaaakbabaaaaacabaaahiaajaaoekaacaaaaadacaaahiaabaaoeib
akaaoekaaeaaaaaeabaachiaamaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiia
anaaaakaacaaaaadabaaaiiaabaappiaagaaaakbafaaaaadabaaaiiaabaappia
abaappiafiaaaaaeabaachiaabaappibalaaoekaabaaoeiafiaaaaaeabaachia
aaaaffiaanaaffkaabaaoeiaabaaaaacacaaahiaadaaoekaacaaaaadadaaahia
acaaoeibaeaaoekaaeaaaaaeacaachiaagaaffkaadaaoeiaacaaoeiafiaaaaae
acaachiaabaappibafaaoekaacaaoeiafiaaaaaeaaaachiaaaaaaaiaabaaoeia
acaaoeiaafaaaaadaaaachiaaaaaoeiaaaaaoekaabaaaaacabaaahiaabaaoela
aiaaaaadabaacbiaabaaoeiaacaaoelaafaaaaadaaaaciiaaaaappiaabaaaaia
fiaaaaaeaaaaciiaabaaaaiaaaaappiaanaaffkaacaaaaadaaaaciiaaaaappia
aaaappiaafaaaaadaaaachiaaaaappiaaaaaoeiaabaaaaacaaaaaiiaanaaffka
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcieadaaaaeaaaaaaaobaaaaaa
fjaaaaaeegiocaaaaaaaaaaabdaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaaaaaaaaajocaabaaaaaaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaa
aaaaaaaaanaaaaaabaaaaaahccaabaaaaaaaaaaajgahbaaaaaaaaaaajgahbaaa
aaaaaaaaelaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadbaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaaaaaaaakhcaabaaa
abaaaaaaegiccaiaebaaaaaaaaaaaaaaapaaaaaaegiccaaaaaaaaaaabaaaaaaa
dcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaabcaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaapaaaaaacaaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaa
amaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaaabaaaaaakgakbaaaaaaaaaaa
egiccaaaaaaaaaaabbaaaaaaegacbaaaabaaaaaaabaaaaahhcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaia
ebaaaaaaaaaaaaaaajaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaalhcaabaaa
acaaaaaafgifcaaaaaaaaaaaamaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
ajaaaaaadhaaaaakocaabaaaaaaaaaaakgakbaaaaaaaaaaaagijcaaaaaaaaaaa
alaaaaaaagajbaaaacaaaaaadhaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaa
jgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegbcbaaaadaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaa
pgapbaaaabaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheo
jiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 8 to 8
//   d3d9 - ALU: 8 to 8
//   d3d11 - ALU: 8 to 8, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 8 to 8, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
"!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
"vs_2_0
; 8 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 2 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgoflhcgfinoonoplgmdiabihpafgdafabaaaaaaneacaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciaabaaaaeaaaabaagaaaaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 2 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedfpmclfcoogjdlpcnlpgnljpcdonknacmabaaaaaaaaaeaaaaaeaaaaaa
daaaaaaafiabaaaaoaacaaaakiadaaaaebgpgodjcaabaaaacaabaaaaaaacpopp
neaaaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaamaaadaaafaaaaaaaaaaaaaabeaaabaaaiaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
afaaaaadaaaaahiaacaaoejaaiaappkaafaaaaadabaaahiaaaaaffiaagaaoeka
aeaaaaaeaaaaaliaafaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahoaahaaoeka
aaaakkiaaaaapeiaafaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapia
abaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefciaabaaaa
eaaaabaagaaaaaaafjaaaaaeegiocaaaaaaaaaaabfaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadhccabaaaabaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaaaaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaaaaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaaaaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaaaaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 455
#line 455
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 459
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 455
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 462
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 464
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 468
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 472
    surf( surfIN, o);
    lowp vec4 res;
    res.xyz = ((o.Normal * 0.5) + 0.5);
    res.w = o.Specular;
    #line 476
    return res;
}
in lowp vec3 xlv_TEXCOORD0;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 0 to 0
//   d3d9 - ALU: 3 to 3
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
"!!ARBfp1.0
# 2 ALU, 0 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[2].y, c[2].y;
MOV result.color.w, c[2].x;
END
# 2 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
"ps_2_0
; 3 ALU
def c0, 0.50000000, 0.00000000, 0, 0
dcl t0.xyz
mad_pp r0.xyz, t0, c0.x, c0.x
mov_pp r0.w, c0.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
// 3 instructions, 0 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhbdiiogganilkmhhpogjlnaalcliljppabaaaaaadeabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcheaaaaaa
eaaaaaaabnaaaaaagcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
dcaaaaaphccabaaaaaaaaaaaegbcbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { }
// 3 instructions, 0 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedbcfagkfmhchaonghfjackccpkbjompokabaaaaaalmabaaaaaeaaaaaa
daaaaaaaleaaaaaadaabaaaaiiabaaaaebgpgodjhmaaaaaahmaaaaaaaaacpppp
fiaaaaaaceaaaaaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaacpppp
fbaaaaafaaaaapkaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaachlaaeaaaaaeaaaachiaaaaaoelaaaaaaakaaaaaaakaabaaaaacaaaaciia
aaaaffkaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcheaaaaaaeaaaaaaa
bnaaaaaagcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaadcaaaaap
hccabaaaaaaaaaaaegbcbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheofaaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 13 to 30
//   d3d9 - ALU: 13 to 30
//   d3d11 - ALU: 12 to 26, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 12 to 26, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
"!!ARBvp1.0
# 30 ALU
PARAM c[18] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
"vs_2_0
; 30 ALU
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c18.x
mul r0.y, r0, c8.x
add oT2.xyz, r3, r2
mad oT1.xy, r0.z, c9.zwzw, r0
mov oPos, r1
mov oT1.zw, r1
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedikalfiefcopefkfhclkimohbnefdmolfabaaaaaaniafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
feaeaaaaeaaaabaabfabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
icaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaa
abaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaa
abaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaa
abaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
aaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaa
cmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_19.w;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_20;
  lowp vec4 c_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_4 * light_3.xyz);
  c_21.xyz = tmpvar_22;
  c_21.w = tmpvar_5;
  c_2 = c_21;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_19.w;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_20;
  lowp vec4 c_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_4 * light_3.xyz);
  c_21.xyz = tmpvar_22;
  c_21.w = tmpvar_5;
  c_2 = c_21;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedfggadbbnhdcnegnkejojndpihnninoheabaaaaaajaaiaaaaaeaaaaaa
daaaaaaaoeacaaaaeaahaaaaaiaiaaaaebgpgodjkmacaaaakmacaaaaaaacpopp
eiacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaafaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaaeaaanaaaaaaaaaaacaabeaaabaabbaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbcaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaaoaaoeka
aeaaaaaeaaaaahiaanaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaabaaaakaafaaaaadabaaaiia
abaaaaiabcaaaakaafaaaaadabaaafiaaaaapeiabcaaaakaacaaaaadabaaadoa
abaakkiaabaaomiaafaaaaadabaaahiaacaaoejabbaappkaafaaaaadacaaahia
abaaffiaaoaaoekaaeaaaaaeabaaaliaanaakekaabaaaaiaacaakeiaaeaaaaae
abaaahiaapaaoekaabaakkiaabaapeiaabaaaaacabaaaiiabcaaffkaajaaaaad
acaaabiaacaaoekaabaaoeiaajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaad
acaaaeiaaeaaoekaabaaoeiaafaaaaadadaaapiaabaacjiaabaakeiaajaaaaad
aeaaabiaafaaoekaadaaoeiaajaaaaadaeaaaciaagaaoekaadaaoeiaajaaaaad
aeaaaeiaahaaoekaadaaoeiaacaaaaadacaaahiaacaaoeiaaeaaoeiaafaaaaad
abaaaciaabaaffiaabaaffiaaeaaaaaeabaaabiaabaaaaiaabaaaaiaabaaffib
aeaaaaaeacaaahoaaiaaoekaabaaaaiaacaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoaaaaaoeia
ppppaaaafdeieefcfeaeaaaaeaaaabaabfabaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 469
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 461
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    #line 465
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 469
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 469
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 473
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 477
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    #line 481
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    light.xyz += IN.vlight;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    #line 485
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
"!!ARBvp1.0
# 20 ALU
PARAM c[16] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MOV result.position, R0;
MUL R1.y, R1, c[13].x;
MOV result.texcoord[1].zw, R0;
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
DP4 R0.z, vertex.position, c[11];
ADD result.texcoord[1].xy, R1, R1.z;
ADD R1.xyz, R0, -c[14];
MOV result.texcoord[0].xyz, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
MUL result.texcoord[3].xyz, R1, c[14].w;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
"vs_2_0
; 20 ALU
def c16, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord1 v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c16.x
mov oPos, r0
mul r1.y, r1, c12.x
mov oT1.zw, r0
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.z, v0, c10
mad oT1.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, -c14
mov oT0.xyz, r0
mov r0.x, c14.w
add r0.y, c16, -r0.x
dp4 r0.x, v0, c2
mul oT3.xyz, r1, c14.w
mad oT2.xy, v1, c15, c15.zwzw
mul oT3.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedbdmjhncljkjaiihbiflaflcohikkakadabaaaaaageafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcmiadaaaaeaaaabaa
pcaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaa
baaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaaeaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaa
adaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaa
apaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaa
afaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaa
agaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadp
diaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_7 = vec3(0.0, 0.0, 0.0);
  tmpvar_8 = 0.0;
  highp float tmpvar_9;
  highp vec3 p_10;
  p_10 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_9 = sqrt(dot (p_10, p_10));
  highp float tmpvar_11;
  highp vec3 p_12;
  p_12 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_11 = sqrt(dot (p_12, p_12));
  if ((tmpvar_9 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_13;
      tmpvar_13 = _Brush1DirtyColor.xyz;
      tmpvar_7 = tmpvar_13;
    } else {
      mediump vec4 dirtyColor_14;
      highp vec4 tmpvar_15;
      tmpvar_15 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_14 = tmpvar_15;
      mediump vec3 tmpvar_16;
      tmpvar_16 = dirtyColor_14.xyz;
      tmpvar_7 = tmpvar_16;
    };
    tmpvar_8 = 1.0;
  } else {
    if ((tmpvar_11 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_17;
        tmpvar_17 = _Brush2DirtyColor.xyz;
        tmpvar_7 = tmpvar_17;
      } else {
        mediump vec4 dirtyColor_1_18;
        highp vec4 tmpvar_19;
        tmpvar_19 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_18 = tmpvar_19;
        mediump vec3 tmpvar_20;
        tmpvar_20 = dirtyColor_1_18.xyz;
        tmpvar_7 = tmpvar_20;
      };
      tmpvar_8 = 1.0;
    } else {
      tmpvar_8 = 0.0;
    };
  };
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_22.w;
  highp float tmpvar_23;
  tmpvar_23 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull_4 = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect_3 = tmpvar_25;
  light_6.xyz = (tmpvar_22.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_7 * light_6.xyz);
  c_26.xyz = tmpvar_27;
  c_26.w = tmpvar_8;
  c_2 = c_26;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_7 = vec3(0.0, 0.0, 0.0);
  tmpvar_8 = 0.0;
  highp float tmpvar_9;
  highp vec3 p_10;
  p_10 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_9 = sqrt(dot (p_10, p_10));
  highp float tmpvar_11;
  highp vec3 p_12;
  p_12 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_11 = sqrt(dot (p_12, p_12));
  if ((tmpvar_9 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_13;
      tmpvar_13 = _Brush1DirtyColor.xyz;
      tmpvar_7 = tmpvar_13;
    } else {
      mediump vec4 dirtyColor_14;
      highp vec4 tmpvar_15;
      tmpvar_15 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_14 = tmpvar_15;
      mediump vec3 tmpvar_16;
      tmpvar_16 = dirtyColor_14.xyz;
      tmpvar_7 = tmpvar_16;
    };
    tmpvar_8 = 1.0;
  } else {
    if ((tmpvar_11 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_17;
        tmpvar_17 = _Brush2DirtyColor.xyz;
        tmpvar_7 = tmpvar_17;
      } else {
        mediump vec4 dirtyColor_1_18;
        highp vec4 tmpvar_19;
        tmpvar_19 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_18 = tmpvar_19;
        mediump vec3 tmpvar_20;
        tmpvar_20 = dirtyColor_1_18.xyz;
        tmpvar_7 = tmpvar_20;
      };
      tmpvar_8 = 1.0;
    } else {
      tmpvar_8 = 0.0;
    };
  };
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_22.w;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp float tmpvar_25;
  tmpvar_25 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_25;
  lowp vec3 tmpvar_26;
  tmpvar_26 = ((8.0 * tmpvar_23.w) * tmpvar_23.xyz);
  lmFull_4 = tmpvar_26;
  lowp vec3 tmpvar_27;
  tmpvar_27 = ((8.0 * tmpvar_24.w) * tmpvar_24.xyz);
  lmIndirect_3 = tmpvar_27;
  light_6.xyz = (tmpvar_22.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_7 * light_6.xyz);
  c_28.xyz = tmpvar_29;
  c_28.w = tmpvar_8;
  c_2 = c_28;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjpcmodaibmhidhhabbnipjgaphecnjopabaaaaaamiahaaaaaeaaaaaa
daaaaaaajaacaaaagaagaaaaciahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
peabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaapaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaabjaaabaaadaaaaaaaaaa
adaaaaaaaiaaaeaaaaaaaaaaadaaamaaaeaaamaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbaaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaapiaaaaaffjaafaaoeka
aeaaaaaeaaaaapiaaeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaacaaaakaafaaaaadabaaaiiaabaaaaiabaaaaakaafaaaaad
abaaafiaaaaapeiabaaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaae
acaaadoaaeaaoejaabaaoekaabaaookaafaaaaadabaaahiaaaaaffjaanaaoeka
aeaaaaaeabaaahiaamaaoekaaaaaaajaabaaoeiaaeaaaaaeabaaahiaaoaaoeka
aaaakkjaabaaoeiaaeaaaaaeabaaahiaapaaoekaaaaappjaabaaoeiaacaaaaad
acaaahiaabaaoeiaadaaoekbabaaaaacaaaaahoaabaaoeiaafaaaaadadaaahoa
acaaoeiaadaappkaafaaaaadabaaabiaaaaaffjaajaakkkaaeaaaaaeabaaabia
aiaakkkaaaaaaajaabaaaaiaaeaaaaaeabaaabiaakaakkkaaaaakkjaabaaaaia
aeaaaaaeabaaabiaalaakkkaaaaappjaabaaaaiaabaaaaacabaaaiiaadaappka
acaaaaadabaaaciaabaappibbaaaffkaafaaaaadadaaaioaabaaffiaabaaaaib
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacabaaamoaaaaaoeiappppaaaafdeieefcmiadaaaaeaaaabaapcaaaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaadiaaaaai
hccabaaaaeaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabjaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 458
uniform highp vec4 unity_LightmapST;
#line 470
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 474
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 459
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 462
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 466
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 458
uniform highp vec4 unity_LightmapST;
#line 470
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 474
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 475
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 478
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 482
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 486
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 490
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    #line 494
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
"!!ARBvp1.0
# 13 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
"vs_2_0
; 13 ALU
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord1 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c8.x
mad oT1.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mad oT2.xy, v1, c10, c10.zwzw
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkpijohdkdceieklbplifkonagbobonfeabaaaaaapmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
hiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  mediump vec3 lm_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_19 = tmpvar_20;
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = lm_19;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_21);
  light_3 = tmpvar_22;
  lowp vec4 c_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_4 * tmpvar_22.xyz);
  c_23.xyz = tmpvar_24;
  c_23.w = tmpvar_5;
  c_2 = c_23;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((8.0 * tmpvar_19.w) * tmpvar_19.xyz);
  lm_20 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = lm_20;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_22);
  light_3 = tmpvar_23;
  lowp vec4 c_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_4 * tmpvar_23.xyz);
  c_24.xyz = tmpvar_25;
  c_24.w = tmpvar_5;
  c_2 = c_24;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedoedhckabiafaannlcnfglbpdebofcfdlabaaaaaalaafaaaaaeaaaaaa
daaaaaaaoaabaaaagaaeaaaaciafaaaaebgpgodjkiabaaaakiabaaaaaaacpopp
faabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaapaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaaeaaahaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafalaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeia
aeaaapjaafaaaaadaaaaahiaaaaaffjaaiaaoekaaeaaaaaeaaaaahiaahaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaahoaakaaoekaaaaappjaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaeaaoeka
aeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaacaaaakaafaaaaadabaaaiiaabaaaaiaalaaaakaafaaaaad
abaaafiaaaaapeiaalaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaae
acaaadoaaeaaoejaabaaoekaabaaookaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoaaaaaoeiappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform highp vec4 unity_LightmapST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 469
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 458
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 461
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 465
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform highp vec4 unity_LightmapST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 469
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 472
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 474
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 478
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 482
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    #line 486
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false);
    light += lm;
    #line 490
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
"!!ARBvp1.0
# 30 ALU
PARAM c[18] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
"vs_2_0
; 30 ALU
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c18.x
mul r0.y, r0, c8.x
add oT2.xyz, r3, r2
mad oT1.xy, r0.z, c9.zwzw, r0
mov oPos, r1
mov oT1.zw, r1
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedikalfiefcopefkfhclkimohbnefdmolfabaaaaaaniafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
feaeaaaaeaaaabaabfabaaaafjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaf
icaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaa
abaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaa
abaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaa
abaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
aaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaa
claaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaa
cmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_19.w;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_20;
  lowp vec4 c_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_4 * light_3.xyz);
  c_21.xyz = tmpvar_22;
  c_21.w = tmpvar_5;
  c_2 = c_21;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_19.w;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_20;
  lowp vec4 c_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_4 * light_3.xyz);
  c_21.xyz = tmpvar_22;
  c_21.w = tmpvar_5;
  c_2 = c_21;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerCamera" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedfggadbbnhdcnegnkejojndpihnninoheabaaaaaajaaiaaaaaeaaaaaa
daaaaaaaoeacaaaaeaahaaaaaiaiaaaaebgpgodjkmacaaaakmacaaaaaaacpopp
eiacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaafaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaaeaaanaaaaaaaaaaacaabeaaabaabbaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbcaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffjaaoaaoeka
aeaaaaaeaaaaahiaanaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaabaaaakaafaaaaadabaaaiia
abaaaaiabcaaaakaafaaaaadabaaafiaaaaapeiabcaaaakaacaaaaadabaaadoa
abaakkiaabaaomiaafaaaaadabaaahiaacaaoejabbaappkaafaaaaadacaaahia
abaaffiaaoaaoekaaeaaaaaeabaaaliaanaakekaabaaaaiaacaakeiaaeaaaaae
abaaahiaapaaoekaabaakkiaabaapeiaabaaaaacabaaaiiabcaaffkaajaaaaad
acaaabiaacaaoekaabaaoeiaajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaad
acaaaeiaaeaaoekaabaaoeiaafaaaaadadaaapiaabaacjiaabaakeiaajaaaaad
aeaaabiaafaaoekaadaaoeiaajaaaaadaeaaaciaagaaoekaadaaoeiaajaaaaad
aeaaaeiaahaaoekaadaaoeiaacaaaaadacaaahiaacaaoeiaaeaaoeiaafaaaaad
abaaaciaabaaffiaabaaffiaaeaaaaaeabaaabiaabaaaaiaabaaaaiaabaaffib
aeaaaaaeacaaahoaaiaaoekaabaaaaiaacaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoaaaaaoeia
ppppaaaafdeieefcfeaeaaaaeaaaabaabfabaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaa
egiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaacaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 469
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 457
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 461
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    #line 465
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 469
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 469
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    #line 473
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 477
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    #line 481
    light = max( light, vec4( 0.001));
    light.xyz += IN.vlight;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
"!!ARBvp1.0
# 20 ALU
PARAM c[16] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..15] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MOV result.position, R0;
MUL R1.y, R1, c[13].x;
MOV result.texcoord[1].zw, R0;
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
DP4 R0.z, vertex.position, c[11];
ADD result.texcoord[1].xy, R1, R1.z;
ADD R1.xyz, R0, -c[14];
MOV result.texcoord[0].xyz, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
MUL result.texcoord[3].xyz, R1, c[14].w;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
"vs_2_0
; 20 ALU
def c16, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord1 v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c16.x
mov oPos, r0
mul r1.y, r1, c12.x
mov oT1.zw, r0
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
dp4 r0.z, v0, c10
mad oT1.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, -c14
mov oT0.xyz, r0
mov r0.x, c14.w
add r0.y, c16, -r0.x
dp4 r0.x, v0, c2
mul oT3.xyz, r1, c14.w
mad oT2.xy, v1, c15, c15.zwzw
mul oT3.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedbdmjhncljkjaiihbiflaflcohikkakadabaaaaaageafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcmiadaaaaeaaaabaa
pcaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaa
baaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaa
diaaaaaihccabaaaaeaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabjaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaa
adaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaa
apaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaa
afaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaa
agaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadp
diaaaaaiiccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_7 = vec3(0.0, 0.0, 0.0);
  tmpvar_8 = 0.0;
  highp float tmpvar_9;
  highp vec3 p_10;
  p_10 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_9 = sqrt(dot (p_10, p_10));
  highp float tmpvar_11;
  highp vec3 p_12;
  p_12 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_11 = sqrt(dot (p_12, p_12));
  if ((tmpvar_9 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_13;
      tmpvar_13 = _Brush1DirtyColor.xyz;
      tmpvar_7 = tmpvar_13;
    } else {
      mediump vec4 dirtyColor_14;
      highp vec4 tmpvar_15;
      tmpvar_15 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_14 = tmpvar_15;
      mediump vec3 tmpvar_16;
      tmpvar_16 = dirtyColor_14.xyz;
      tmpvar_7 = tmpvar_16;
    };
    tmpvar_8 = 1.0;
  } else {
    if ((tmpvar_11 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_17;
        tmpvar_17 = _Brush2DirtyColor.xyz;
        tmpvar_7 = tmpvar_17;
      } else {
        mediump vec4 dirtyColor_1_18;
        highp vec4 tmpvar_19;
        tmpvar_19 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_18 = tmpvar_19;
        mediump vec3 tmpvar_20;
        tmpvar_20 = dirtyColor_1_18.xyz;
        tmpvar_7 = tmpvar_20;
      };
      tmpvar_8 = 1.0;
    } else {
      tmpvar_8 = 0.0;
    };
  };
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_22.w;
  highp float tmpvar_23;
  tmpvar_23 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull_4 = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect_3 = tmpvar_25;
  light_6.xyz = (tmpvar_22.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_7 * light_6.xyz);
  c_26.xyz = tmpvar_27;
  c_26.w = tmpvar_8;
  c_2 = c_26;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_7 = vec3(0.0, 0.0, 0.0);
  tmpvar_8 = 0.0;
  highp float tmpvar_9;
  highp vec3 p_10;
  p_10 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_9 = sqrt(dot (p_10, p_10));
  highp float tmpvar_11;
  highp vec3 p_12;
  p_12 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_11 = sqrt(dot (p_12, p_12));
  if ((tmpvar_9 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_13;
      tmpvar_13 = _Brush1DirtyColor.xyz;
      tmpvar_7 = tmpvar_13;
    } else {
      mediump vec4 dirtyColor_14;
      highp vec4 tmpvar_15;
      tmpvar_15 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_14 = tmpvar_15;
      mediump vec3 tmpvar_16;
      tmpvar_16 = dirtyColor_14.xyz;
      tmpvar_7 = tmpvar_16;
    };
    tmpvar_8 = 1.0;
  } else {
    if ((tmpvar_11 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_17;
        tmpvar_17 = _Brush2DirtyColor.xyz;
        tmpvar_7 = tmpvar_17;
      } else {
        mediump vec4 dirtyColor_1_18;
        highp vec4 tmpvar_19;
        tmpvar_19 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_18 = tmpvar_19;
        mediump vec3 tmpvar_20;
        tmpvar_20 = dirtyColor_1_18.xyz;
        tmpvar_7 = tmpvar_20;
      };
      tmpvar_8 = 1.0;
    } else {
      tmpvar_8 = 0.0;
    };
  };
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_22.w;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp float tmpvar_25;
  tmpvar_25 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_25;
  lowp vec3 tmpvar_26;
  tmpvar_26 = ((8.0 * tmpvar_23.w) * tmpvar_23.xyz);
  lmFull_4 = tmpvar_26;
  lowp vec3 tmpvar_27;
  tmpvar_27 = ((8.0 * tmpvar_24.w) * tmpvar_24.xyz);
  lmIndirect_3 = tmpvar_27;
  light_6.xyz = (tmpvar_22.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_7 * light_6.xyz);
  c_28.xyz = tmpvar_29;
  c_28.w = tmpvar_8;
  c_2 = c_28;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjpcmodaibmhidhhabbnipjgaphecnjopabaaaaaamiahaaaaaeaaaaaa
daaaaaaajaacaaaagaagaaaaciahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
peabaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaapaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaabjaaabaaadaaaaaaaaaa
adaaaaaaaiaaaeaaaaaaaaaaadaaamaaaeaaamaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbaaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaeiaaeaaapjaafaaaaadaaaaapiaaaaaffjaafaaoeka
aeaaaaaeaaaaapiaaeaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaahaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaacaaaakaafaaaaadabaaaiiaabaaaaiabaaaaakaafaaaaad
abaaafiaaaaapeiabaaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaae
acaaadoaaeaaoejaabaaoekaabaaookaafaaaaadabaaahiaaaaaffjaanaaoeka
aeaaaaaeabaaahiaamaaoekaaaaaaajaabaaoeiaaeaaaaaeabaaahiaaoaaoeka
aaaakkjaabaaoeiaaeaaaaaeabaaahiaapaaoekaaaaappjaabaaoeiaacaaaaad
acaaahiaabaaoeiaadaaoekbabaaaaacaaaaahoaabaaoeiaafaaaaadadaaahoa
acaaoeiaadaappkaafaaaaadabaaabiaaaaaffjaajaakkkaaeaaaaaeabaaabia
aiaakkkaaaaaaajaabaaaaiaaeaaaaaeabaaabiaakaakkkaaaaakkjaabaaaaia
aeaaaaaeabaaabiaalaakkkaaaaappjaabaaaaiaabaaaaacabaaaiiaadaappka
acaaaaadabaaaciaabaappibbaaaffkaafaaaaadadaaaioaabaaffiaabaaaaib
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacabaaamoaaaaaoeiappppaaaafdeieefcmiadaaaaeaaaabaapcaaaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaa
fjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaadiaaaaai
hccabaaaaeaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabjaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaa
diaaaaaibcaabaaaaaaaaaaabkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaa
ckbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaahaaaaaadkbabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaadkiacaiaebaaaaaaacaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaai
iccabaaaaeaaaaaabkaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
imaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaimaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 458
uniform highp vec4 unity_LightmapST;
#line 470
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 474
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 459
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 462
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 466
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 458
uniform highp vec4 unity_LightmapST;
#line 470
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 474
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 475
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 478
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 482
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 486
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    #line 490
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    #line 494
    light.xyz += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
"!!ARBvp1.0
# 13 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [_Object2World]
Vector 10 [unity_LightmapST]
"vs_2_0
; 13 ALU
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord1 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c8.x
mad oT1.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mad oT2.xy, v1, c10, c10.zwzw
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkpijohdkdceieklbplifkonagbobonfeabaaaaaapmadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
hiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  mediump vec3 lm_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_19 = tmpvar_20;
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = lm_19;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_21);
  light_3 = tmpvar_22;
  lowp vec4 c_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_4 * tmpvar_22.xyz);
  c_23.xyz = tmpvar_24;
  c_23.w = tmpvar_5;
  c_2 = c_23;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (glstate_matrix_mvp * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex).xyz;
  xlv_TEXCOORD1 = o_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp float _Brush2ActivationState;
uniform highp vec4 _Brush2DirtyColor;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp float _Brush2Radius;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush1ActivationState;
uniform int _Brush1ActivationFlag;
uniform highp vec4 _Brush1DirtyColor;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1Pos;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_4 = vec3(0.0, 0.0, 0.0);
  tmpvar_5 = 0.0;
  highp float tmpvar_6;
  highp vec3 p_7;
  p_7 = (_Brush1Pos.xyz - xlv_TEXCOORD0);
  tmpvar_6 = sqrt(dot (p_7, p_7));
  highp float tmpvar_8;
  highp vec3 p_9;
  p_9 = (_Brush2Pos.xyz - xlv_TEXCOORD0);
  tmpvar_8 = sqrt(dot (p_9, p_9));
  if ((tmpvar_6 < _Brush1Radius)) {
    if ((1 == _Brush1ActivationFlag)) {
      highp vec3 tmpvar_10;
      tmpvar_10 = _Brush1DirtyColor.xyz;
      tmpvar_4 = tmpvar_10;
    } else {
      mediump vec4 dirtyColor_11;
      highp vec4 tmpvar_12;
      tmpvar_12 = mix (_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4(_Brush1ActivationState));
      dirtyColor_11 = tmpvar_12;
      mediump vec3 tmpvar_13;
      tmpvar_13 = dirtyColor_11.xyz;
      tmpvar_4 = tmpvar_13;
    };
    tmpvar_5 = 1.0;
  } else {
    if ((tmpvar_8 < _Brush2Radius)) {
      if ((1 == _Brush1ActivationFlag)) {
        highp vec3 tmpvar_14;
        tmpvar_14 = _Brush2DirtyColor.xyz;
        tmpvar_4 = tmpvar_14;
      } else {
        mediump vec4 dirtyColor_1_15;
        highp vec4 tmpvar_16;
        tmpvar_16 = mix (_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4(_Brush2ActivationState));
        dirtyColor_1_15 = tmpvar_16;
        mediump vec3 tmpvar_17;
        tmpvar_17 = dirtyColor_1_15.xyz;
        tmpvar_4 = tmpvar_17;
      };
      tmpvar_5 = 1.0;
    } else {
      tmpvar_5 = 0.0;
    };
  };
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_20;
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((8.0 * tmpvar_19.w) * tmpvar_19.xyz);
  lm_20 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = lm_20;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_22);
  light_3 = tmpvar_23;
  lowp vec4 c_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_4 * tmpvar_23.xyz);
  c_24.xyz = tmpvar_25;
  c_24.w = tmpvar_5;
  c_2 = c_24;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 288 // 256 used size, 20 vars
Vector 240 [unity_LightmapST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedoedhckabiafaannlcnfglbpdebofcfdlabaaaaaalaafaaaaaeaaaaaa
daaaaaaaoaabaaaagaaeaaaaciafaaaaebgpgodjkiabaaaakiabaaaaaaacpopp
faabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaapaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaaeaaahaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafalaaapkaaaaaaadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaeia
aeaaapjaafaaaaadaaaaahiaaaaaffjaaiaaoekaaeaaaaaeaaaaahiaahaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaajaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaahoaakaaoekaaaaappjaaaaaoeiaafaaaaadaaaaapiaaaaaffjaaeaaoeka
aeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaacaaaakaafaaaaadabaaaiiaabaaaaiaalaaaakaafaaaaad
abaaafiaaaaapeiaalaaaakaacaaaaadabaaadoaabaakkiaabaaomiaaeaaaaae
acaaadoaaeaaoejaabaaoekaabaaookaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacabaaamoaaaaaoeiappppaaaa
fdeieefchiacaaaaeaaaabaajoaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaa
fjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaabaaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaa
acaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaa
aeaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaahaiaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
heaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform highp vec4 unity_LightmapST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 469
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 458
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 461
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.worldPos = (_Object2World * v.vertex).xyz;
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    #line 465
    return o;
}

out highp vec3 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.worldPos);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 406
struct Input {
    highp vec2 uv_MainTex;
    highp vec4 color;
    highp vec3 worldPos;
};
#line 449
struct v2f_surf {
    highp vec4 pos;
    highp vec3 worldPos;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _Brush1Pos;
#line 393
uniform highp float _Brush1Radius;
uniform highp vec4 _Brush1ColorSelectedLow;
uniform highp vec4 _Brush1ColorSelectedHigh;
uniform highp vec4 _Brush1DirtyColor;
#line 397
uniform highp int _Brush1ActivationFlag;
uniform highp float _Brush1ActivationState;
uniform highp vec4 _Brush2Pos;
uniform highp float _Brush2Radius;
#line 401
uniform highp vec4 _Brush2ColorSelectedLow;
uniform highp vec4 _Brush2ColorSelectedHigh;
uniform highp vec4 _Brush2DirtyColor;
uniform highp int _Brush2ActivationFlag;
#line 405
uniform highp float _Brush2ActivationState;
#line 413
#line 457
uniform highp vec4 unity_LightmapST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 469
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c = texture( _MainTex, IN.uv_MainTex);
    highp float curDistance1 = distance( _Brush1Pos.xyz, IN.worldPos);
    #line 417
    highp float curDistance2 = distance( _Brush2Pos.xyz, IN.worldPos);
    if ((curDistance1 < _Brush1Radius)){
        if ((1 == _Brush1ActivationFlag)){
            #line 422
            o.Albedo.xyz = _Brush1DirtyColor.xyz;
        }
        else{
            #line 426
            mediump vec4 dirtyColor = mix( _Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, vec4( _Brush1ActivationState));
            o.Albedo.xyz = dirtyColor.xyz;
        }
        o.Alpha = 1.0;
    }
    else{
        if ((curDistance2 < _Brush2Radius)){
            #line 433
            if ((1 == _Brush1ActivationFlag)){
                o.Albedo.xyz = _Brush2DirtyColor.xyz;
            }
            else{
                #line 439
                mediump vec4 dirtyColor_1 = mix( _Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, vec4( _Brush2ActivationState));
                o.Albedo.xyz = dirtyColor_1.xyz;
            }
            o.Alpha = 1.0;
        }
        else{
            #line 446
            o.Alpha = 0.0;
        }
    }
}
#line 472
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 474
    Input surfIN;
    surfIN.worldPos = IN.worldPos;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 478
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 482
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 486
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false);
    light += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    #line 490
    return c;
}
in highp vec3 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldPos = vec3(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 43 to 57, TEX: 1 to 3
//   d3d9 - ALU: 45 to 57, TEX: 1 to 3
//   d3d11 - ALU: 17 to 26, TEX: 1 to 3, FLOW: 1 to 1
//   d3d11_9x - ALU: 17 to 26, TEX: 1 to 3, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
"!!ARBfp1.0
# 46 ALU, 1 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TXP R0.xyz, fragment.texcoord[1], texture[0], 2D;
ADD R1.xyz, fragment.texcoord[0], -c[0];
DP3 R0.w, R1, R1;
ADD R1.xyz, fragment.texcoord[0], -c[7];
DP3 R1.y, R1, R1;
MOV R1.x, c[13];
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
SLT R3.w, R0, c[1].x;
ABS R0.w, R3;
ADD R1.z, R1.x, -c[5].x;
RSQ R1.y, R1.y;
RCP R1.x, R1.y;
ABS R1.y, R1.z;
CMP R3.y, -R1, c[13], c[13].x;
SLT R1.w, R1.x, c[8].x;
ABS R2.x, R3.y;
CMP R3.x, -R2, c[13].y, c[13];
CMP R0.w, -R0, c[13].y, c[13].x;
MUL R2.w, R0, R1;
MOV R1.xyz, c[2];
ADD R1.xyz, -R1, c[3];
MUL R2.xyz, R1, c[6].x;
MUL R1.y, R3.w, R3;
MUL R3.y, R2.w, R3;
MOV R1.x, c[13].y;
ABS R1.w, R1;
CMP R1.w, -R1, c[13].y, c[13].x;
MUL R0.w, R0, R1;
CMP R1.xyz, -R1.y, c[4], R1.x;
MUL R3.z, R3.w, R3.x;
ADD R2.xyz, R2, c[2];
CMP R2.xyz, -R3.z, R2, R1;
MOV R1.xyz, c[9];
ADD R1.xyz, -R1, c[10];
MUL R1.xyz, R1, c[12].x;
CMP R2.xyz, -R3.y, c[11], R2;
MUL R2.w, R2, R3.x;
ADD R1.xyz, R1, c[9];
CMP R1.xyz, -R2.w, R1, R2;
LG2 R0.x, R0.x;
LG2 R0.z, R0.z;
LG2 R0.y, R0.y;
ADD R0.xyz, -R0, fragment.texcoord[2];
MUL result.color.xyz, R1, R0;
CMP result.color.w, -R0, c[13].y, c[13].x;
END
# 46 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
"ps_2_0
; 48 ALU, 1 TEX
dcl_2d s0
def c13, 0.00000000, 1.00000000, 0, 0
dcl t0.xyz
dcl t1
dcl t2.xyz
texldp r5, t1, s0
add r0.xyz, t0, -c0
dp3 r1.x, r0, r0
mov r0.x, c5
rsq r1.x, r1.x
add r0.x, c13.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c1
abs r0.x, r0
cmp r2.x, r1, c13, c13.y
cmp r0.x, -r0, c13.y, c13
mul_pp r1.x, r2, r0
mov_pp r4.xyz, c4
cmp_pp r6.xyz, -r1.x, c13.x, r4
add r3.xyz, t0, -c7
dp3 r1.x, r3, r3
rsq r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c3
add r4.xyz, -c2, r4
mul r4.xyz, r4, c6.x
rcp r3.x, r3.x
add r3.x, r3, -c8
add r7.xyz, r4, c2
cmp_pp r1.x, -r1, c13.y, c13
mul_pp r4.x, r2, r1
cmp_pp r6.xyz, -r4.x, r6, r7
abs_pp r2.x, r2
mov r7.xyz, c10
cmp r3.x, r3, c13, c13.y
cmp_pp r2.x, -r2, c13.y, c13
mul_pp r4.x, r3, r2
mul_pp r0.x, r4, r0
add r7.xyz, -c9, r7
cmp_pp r6.xyz, -r0.x, r6, c11
mul r0.xyz, r7, c12.x
add r7.xyz, r0, c9
mul_pp r0.x, r4, r1
cmp_pp r1.xyz, -r0.x, r6, r7
abs_pp r0.x, r3
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r0.x, r0, r2
log_pp r4.x, r5.x
log_pp r4.y, r5.y
log_pp r4.z, r5.z
add_pp r3.xyz, -r4, t2
mul_pp r1.xyz, r1, r3
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
// 26 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhagogednecikfhjffejfoeadjjmhoochabaaaaaagmaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefchmadaaaaeaaaaaaanpaaaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaia
ebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaa
aaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
alaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaa
abaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
anaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
abaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaaj
ocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaa
baaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaaf
ccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaa
abaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaia
ebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaa
acaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
afaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
dhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaa
abaaaaaaegacbaiaebaaaaaaabaaaaaaegbcbaaaadaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
// 26 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedcbbmjicpifngjplehoeoihihgpehadheabaaaaaabmahaaaaaeaaaaaa
daaaaaaanmacaaaagaagaaaaoiagaaaaebgpgodjkeacaaaakeacaaaaaaacpppp
fiacaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaaaaaaajaaagaaagaa
aaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaaia
acaaahlabpaaaaacaaaaaajaaaaiapkaacaaaaadaaaaahiaaaaaoelbaaaaoeka
aiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaiaagaaaaac
aaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaabaaaakbacaaaaadabaaahia
aaaaoelbagaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeiaahaaaaacaaaaacia
aaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffiaahaaaakb
abaaaaacabaaahiaaiaaoekaacaaaaadacaaahiaabaaoeibajaaoekaaeaaaaae
abaachiaalaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiiaamaaaakaacaaaaad
abaaaiiaabaappiaafaaaakbafaaaaadabaaaiiaabaappiaabaappiafiaaaaae
abaachiaabaappibakaaoekaabaaoeiafiaaaaaeacaachiaaaaaffiaamaaffka
abaaoeiafiaaaaaeacaaciiaaaaaffiaamaaffkaamaaaakaabaaaaacabaaahia
acaaoekaacaaaaadaaaaaoiaabaablibadaablkaaeaaaaaeaaaacoiaafaaffka
aaaaoeiaabaabliafiaaaaaeabaachiaabaappibaeaaoekaaaaabliaabaaaaac
abaaaiiaamaaaakafiaaaaaeaaaacpiaaaaaaaiaacaaoeiaabaaoeiaagaaaaac
abaaabiaabaapplaafaaaaadabaaadiaabaaaaiaabaaoelaecaaaaadabaacpia
abaaoeiaaaaioekaapaaaaacacaacbiaabaaaaiaapaaaaacacaacciaabaaffia
apaaaaacacaaceiaabaakkiaacaaaaadabaachiaacaaoeibacaaoelaafaaaaad
aaaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
hmadaaaaeaaaaaaanpaaaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
akaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaalaaaaaa
agijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaa
aoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaacaaaaaaibcaabaaa
abaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaajgahbaaaaaaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaia
ebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaahccaabaaaabaaaaaa
jgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaa
abaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaa
aeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaa
egiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaa
aiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakhcaabaaa
acaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaacaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaa
fgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaaaoaaaaahdcaabaaa
abaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaacpaaaaafhcaabaaa
abaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaiaebaaaaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
Vector 13 [unity_LightmapFade]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"!!ARBfp1.0
# 57 ALU, 3 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[2], texture[1], 2D;
TEX R0, fragment.texcoord[2], texture[2], 2D;
TXP R2.xyz, fragment.texcoord[1], texture[0], 2D;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[14].z;
MAD R3.xyz, R1, c[14].z, -R0;
ADD R1.xyz, fragment.texcoord[0], -c[0];
DP3 R0.w, R1, R1;
DP4 R1.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.w;
RSQ R0.w, R0.w;
RCP R1.x, R1.x;
MAD_SAT R1.x, R1, c[13].z, c[13].w;
MAD R0.xyz, R1.x, R3, R0;
RCP R0.w, R0.w;
SLT R3.z, R0.w, c[1].x;
ABS R0.w, R3.z;
LG2 R1.x, R2.x;
LG2 R1.y, R2.y;
LG2 R1.z, R2.z;
ADD R2.xyz, -R1, R0;
ADD R0.xyz, fragment.texcoord[0], -c[7];
DP3 R0.y, R0, R0;
MOV R0.x, c[14];
ADD R0.z, R0.x, -c[5].x;
RSQ R0.y, R0.y;
RCP R0.x, R0.y;
ABS R0.y, R0.z;
CMP R3.y, -R0, c[14], c[14].x;
SLT R1.w, R0.x, c[8].x;
CMP R0.w, -R0, c[14].y, c[14].x;
MUL R2.w, R0, R1;
ABS R1.x, R3.y;
CMP R3.x, -R1, c[14].y, c[14];
MOV R0.xyz, c[2];
ADD R0.xyz, -R0, c[3];
MUL R1.xyz, R0, c[6].x;
ABS R1.w, R1;
CMP R1.w, -R1, c[14].y, c[14].x;
MUL R0.w, R0, R1;
ADD R1.xyz, R1, c[2];
MUL R3.w, R3.z, R3.x;
MOV R0.x, c[14].y;
MUL R0.y, R3.z, R3;
CMP R0.xyz, -R0.y, c[4], R0.x;
CMP R0.xyz, -R3.w, R1, R0;
MUL R1.x, R2.w, R3.y;
CMP R1.xyz, -R1.x, c[11], R0;
MOV R0.xyz, c[9];
ADD R0.xyz, -R0, c[10];
MUL R0.xyz, R0, c[12].x;
MUL R2.w, R2, R3.x;
ADD R0.xyz, R0, c[9];
CMP R0.xyz, -R2.w, R0, R1;
MUL result.color.xyz, R0, R2;
CMP result.color.w, -R0, c[14].y, c[14].x;
END
# 57 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
Vector 13 [unity_LightmapFade]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"ps_2_0
; 57 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c14, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xyz
dcl t1
dcl t2.xy
dcl t3
texldp r1, t1, s0
texld r2, t2, s1
texld r0, t2, s2
mov r8.xyz, c3
add r8.xyz, -c2, r8
mul r8.xyz, r8, c6.x
mul_pp r3.xyz, r2.w, r2
mul_pp r2.xyz, r0.w, r0
mul_pp r2.xyz, r2, c14.z
dp4 r0.x, t3, t3
rsq r0.x, r0.x
rcp r0.x, r0.x
mad_pp r3.xyz, r3, c14.z, -r2
mad_sat r0.x, r0, c13.z, c13.w
mad_pp r0.xyz, r0.x, r3, r2
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
add_pp r6.xyz, -r1, r0
add r1.xyz, t0, -c7
dp3 r1.x, r1, r1
add r0.xyz, t0, -c0
dp3 r0.x, r0, r0
rsq r0.x, r0.x
rcp r0.x, r0.x
add r2.x, r0, -c1
cmp r3.x, r2, c14, c14.y
mov r2.x, c5
add r4.x, c14.y, -r2
rsq r1.x, r1.x
rcp r1.x, r1.x
add r0.x, r1, -c8
cmp r1.x, r0, c14, c14.y
abs_pp r0.x, r3
cmp_pp r0.x, -r0, c14.y, c14
mul_pp r2.x, r1, r0
abs r4.x, r4
cmp r4.x, -r4, c14.y, c14
abs_pp r1.x, r1
cmp_pp r1.x, -r1, c14.y, c14
mul_pp r0.x, r1, r0
mul_pp r5.x, r3, r4
mov_pp r7.xyz, c4
cmp_pp r7.xyz, -r5.x, c14.x, r7
abs_pp r5.x, r4
cmp_pp r5.x, -r5, c14.y, c14
mul_pp r3.x, r3, r5
add r8.xyz, r8, c2
cmp_pp r7.xyz, -r3.x, r7, r8
mul_pp r3.x, r2, r4
mov r4.xyz, c10
add r4.xyz, -c9, r4
mul r4.xyz, r4, c12.x
cmp_pp r3.xyz, -r3.x, r7, c11
mul_pp r2.x, r2, r5
add r4.xyz, r4, c9
cmp_pp r2.xyz, -r2.x, r3, r4
mul_pp r1.xyz, r2, r6
cmp_pp r1.w, -r0.x, c14.y, c14.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 288 // 272 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
Vector 256 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
SetTexture 2 [unity_LightmapInd] 2D 2
// 36 instructions, 3 temp regs, 0 temp arrays:
// ALU 24 float, 1 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbajekapkloonlccnabpokhgjopofdbcdabaaaaaaamagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaeafaaaaeaaaaaaaebabaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaabbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaa
agajbaaaabaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
adaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaacpaaaaaf
hcaabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaiaebaaaaaaabaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
akaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaalaaaaaa
egiccaaaaaaaaaaaamaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
aoaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaacaaaaaaiicaabaaa
abaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaa
acaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaa
egiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaabaaaaaafgifcaaaaaaaaaaa
aiaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakhcaabaaa
abaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaabaaaaaa
dgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaacaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
dkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 288 // 272 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
Vector 256 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
SetTexture 2 [unity_LightmapInd] 2D 2
// 36 instructions, 3 temp regs, 0 temp arrays:
// ALU 24 float, 1 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedbjidfjickppfdeebdfieehaanohdibpfabaaaaaakiajaaaaaeaaaaaa
daaaaaaamiadaaaaneaiaaaaheajaaaaebgpgodjjaadaaaajaadaaaaaaacpppp
daadaaaagaaaaaaaaeaadaaaaaaagaaaaaaagaaaadaaceaaaaaagaaaaaaaaaaa
abababaaacacacaaaaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaa
aaaaajaaagaaagaaaaaaaaaaaaaabaaaabaaamaaaaaaaaaaaaacppppfbaaaaaf
anaaapkaaaaaiadpaaaaaaaaaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaaiaacaaadlabpaaaaacaaaaaaia
adaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaac
aaaaaajaacaiapkaagaaaaacaaaaaiiaabaapplaafaaaaadaaaaadiaaaaappia
abaaoelaecaaaaadabaacpiaacaaoelaacaioekaecaaaaadacaacpiaacaaoela
abaioekaecaaaaadaaaacpiaaaaaoeiaaaaioekaajaaaaadaaaaaiiaadaaoela
adaaoelaahaaaaacaaaaaiiaaaaappiaagaaaaacaaaaaiiaaaaappiaaeaaaaae
aaaadiiaaaaappiaamaakkkaamaappkaafaaaaadabaaciiaabaappiaanaakkka
afaaaaadabaachiaabaaoeiaabaappiaafaaaaadabaaciiaacaappiaanaakkka
aeaaaaaeacaachiaabaappiaacaaoeiaabaaoeibaeaaaaaeabaachiaaaaappia
acaaoeiaabaaoeiaapaaaaacacaacbiaaaaaaaiaapaaaaacacaacciaaaaaffia
apaaaaacacaaceiaaaaakkiaacaaaaadaaaachiaabaaoeiaacaaoeibacaaaaad
abaaahiaaaaaoelbaaaaoekaaiaaaaadaaaaaiiaabaaoeiaabaaoeiaahaaaaac
aaaaaiiaaaaappiaagaaaaacaaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappia
abaaaakbacaaaaadabaaahiaaaaaoelbagaaoekaaiaaaaadabaaabiaabaaoeia
abaaoeiaahaaaaacabaaabiaabaaaaiaagaaaaacabaaabiaabaaaaiaacaaaaad
abaaabiaabaaaaiaahaaaakbabaaaaacacaaahiaaiaaoekaacaaaaadabaaaoia
acaablibajaablkaaeaaaaaeabaacoiaalaaffkaabaaoeiaacaabliaabaaaaac
acaaabiaanaaaakaacaaaaadacaaabiaacaaaaiaafaaaakbafaaaaadacaaabia
acaaaaiaacaaaaiafiaaaaaeabaacoiaacaaaaibakaablkaabaaoeiafiaaaaae
adaachiaabaaaaiaanaaffkaabaabliafiaaaaaeadaaciiaabaaaaiaanaaffka
anaaaakaabaaaaacabaaahiaacaaoekaacaaaaadacaaaoiaabaablibadaablka
aeaaaaaeabaachiaafaaffkaacaabliaabaaoeiafiaaaaaeabaachiaacaaaaib
aeaaoekaabaaoeiaabaaaaacabaaciiaanaaaakafiaaaaaeabaacpiaaaaappia
adaaoeiaabaaoeiaafaaaaadabaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpia
abaaoeiappppaaaafdeieefcaeafaaaaeaaaaaaaebabaaaafjaaaaaeegiocaaa
aaaaaaaabbaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
hcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
bbaaaaahbcaabaaaaaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaa
aaaaaaaackiacaaaaaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaa
diaaaaahccaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaah
ocaabaaaaaaaaaaaagajbaaaabaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaajgahbaiaebaaaaaaaaaaaaaa
dcaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaajgahbaaa
aaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaa
aaaaaaaaalaaaaaaegiccaaaaaaaaaaaamaaaaaadcaaaaalhcaabaaaabaaaaaa
fgifcaaaaaaaaaaaaoaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaa
caaaaaaiicaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaa
dhaaaaakhcaabaaaacaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaah
pcaabaaaacaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajhcaabaaa
abaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaa
aaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaabaaaaaa
fgifcaaaaaaaaaaaaiaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
dhaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaaj
pcaabaaaabaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaacaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaabejfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adadaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 48 ALU, 2 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TXP R1.xyz, fragment.texcoord[1], texture[0], 2D;
TEX R0, fragment.texcoord[2], texture[1], 2D;
ADD R2.xyz, fragment.texcoord[0], -c[7];
DP3 R1.w, R2, R2;
RSQ R2.w, R1.w;
MOV R2.xyz, c[2];
MOV R1.w, c[13].x;
ADD R1.w, R1, -c[5].x;
ABS R3.w, R1;
ADD R3.xyz, fragment.texcoord[0], -c[0];
DP3 R1.w, R3, R3;
CMP R4.x, -R3.w, c[13].y, c[13];
RSQ R1.w, R1.w;
RCP R3.x, R1.w;
ABS R3.y, R4.x;
ADD R2.xyz, -R2, c[3];
SLT R3.w, R3.x, c[1].x;
CMP R1.w, -R3.y, c[13].y, c[13].x;
MUL R3.xyz, R2, c[6].x;
MUL R4.y, R3.w, R1.w;
MUL R2.y, R3.w, R4.x;
MOV R2.x, c[13].y;
CMP R2.xyz, -R2.y, c[4], R2.x;
ADD R3.xyz, R3, c[2];
CMP R3.xyz, -R4.y, R3, R2;
RCP R2.y, R2.w;
ABS R2.x, R3.w;
SLT R3.w, R2.y, c[8].x;
CMP R2.w, -R2.x, c[13].y, c[13].x;
MUL R4.y, R2.w, R3.w;
MOV R2.xyz, c[9];
MUL R4.x, R4.y, R4;
ADD R2.xyz, -R2, c[10];
MUL R2.xyz, R2, c[12].x;
MUL R0.xyz, R0.w, R0;
MUL R1.w, R4.y, R1;
CMP R3.xyz, -R4.x, c[11], R3;
ADD R2.xyz, R2, c[9];
CMP R2.xyz, -R1.w, R2, R3;
ABS R1.w, R3;
CMP R0.w, -R1, c[13].y, c[13].x;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
MAD R1.xyz, R0, c[13].z, -R1;
MUL R0.x, R2.w, R0.w;
MUL result.color.xyz, R2, R1;
CMP result.color.w, -R0.x, c[13].y, c[13].x;
END
# 48 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c13, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xyz
dcl t1
dcl t2.xy
texldp r6, t1, s0
texld r5, t2, s1
add r0.xyz, t0, -c0
dp3 r1.x, r0, r0
mov r0.x, c5
rsq r1.x, r1.x
add r0.x, c13.y, -r0
rcp r1.x, r1.x
abs r0.x, r0
add r1.x, r1, -c1
cmp r0.x, -r0, c13.y, c13
cmp r1.x, r1, c13, c13.y
mul_pp r2.x, r1, r0
mov_pp r3.xyz, c4
cmp_pp r7.xyz, -r2.x, c13.x, r3
mov r2.xyz, c3
add r4.xyz, -c2, r2
mul r4.xyz, r4, c6.x
add r3.xyz, t0, -c7
dp3 r3.x, r3, r3
abs_pp r2.x, r0
rsq r3.x, r3.x
rcp r3.x, r3.x
add r3.x, r3, -c8
add r8.xyz, r4, c2
cmp_pp r2.x, -r2, c13.y, c13
mul_pp r4.x, r1, r2
cmp_pp r7.xyz, -r4.x, r7, r8
mov r8.xyz, c10
abs_pp r1.x, r1
add r8.xyz, -c9, r8
mul r8.xyz, r8, c12.x
cmp_pp r1.x, -r1, c13.y, c13
cmp r3.x, r3, c13, c13.y
mul_pp r4.x, r3, r1
mul_pp r0.x, r4, r0
cmp_pp r7.xyz, -r0.x, r7, c11
mul_pp r0.x, r4, r2
add r8.xyz, r8, c9
cmp_pp r2.xyz, -r0.x, r7, r8
abs_pp r0.x, r3
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r0.x, r0, r1
mul_pp r4.xyz, r5.w, r5
log_pp r5.x, r6.x
log_pp r5.y, r6.y
log_pp r5.z, r6.z
mad_pp r3.xyz, r4, c13.z, -r5
mul_pp r1.xyz, r2, r3
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 288 // 232 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmiighkfalblkfjkpchoiamhocggfkddgabaaaaaanaaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcoaadaaaaeaaaaaaapiaaaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaadhcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaa
aaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaa
fgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaa
caaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaa
jgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaah
pcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaa
abaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaah
ccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaa
abaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaa
aaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaa
fgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaaj
pcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
cpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaah
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaadkaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 288 // 232 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedcaobfpopcidhgjecpmeefheinjfafhogabaaaaaaleahaaaaaeaaaaaa
daaaaaaabaadaaaapiagaaaaiaahaaaaebgpgodjniacaaaaniacaaaaaaacpppp
iiacaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaaaaaaaaa
abababaaaaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaaaaaaajaa
agaaagaaaaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaeb
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaaplabpaaaaac
aaaaaaiaacaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
acaaaaadaaaaahiaaaaaoelbaaaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeia
ahaaaaacaaaaabiaaaaaaaiaagaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabia
aaaaaaiaabaaaakbacaaaaadabaaahiaaaaaoelbagaaoekaaiaaaaadaaaaacia
abaaoeiaabaaoeiaahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffia
acaaaaadaaaaaciaaaaaffiaahaaaakbabaaaaacabaaahiaaiaaoekaacaaaaad
acaaahiaabaaoeibajaaoekaaeaaaaaeabaachiaalaaffkaacaaoeiaabaaoeia
abaaaaacabaaaiiaamaaaakaacaaaaadabaaaiiaabaappiaafaaaakbafaaaaad
abaaaiiaabaappiaabaappiafiaaaaaeabaachiaabaappibakaaoekaabaaoeia
fiaaaaaeacaachiaaaaaffiaamaaffkaabaaoeiafiaaaaaeacaaciiaaaaaffia
amaaffkaamaaaakaabaaaaacabaaahiaacaaoekaacaaaaadaaaaaoiaabaablib
adaablkaaeaaaaaeaaaacoiaafaaffkaaaaaoeiaabaabliafiaaaaaeabaachia
abaappibaeaaoekaaaaabliaabaaaaacabaaaiiaamaaaakafiaaaaaeaaaacpia
aaaaaaiaacaaoeiaabaaoeiaagaaaaacabaaabiaabaapplaafaaaaadabaaadia
abaaaaiaabaaoelaecaaaaadabaacpiaabaaoeiaaaaioekaecaaaaadacaacpia
acaaoelaabaioekaapaaaaacadaacbiaabaaaaiaapaaaaacadaacciaabaaffia
apaaaaacadaaceiaabaakkiaafaaaaadacaaciiaacaappiaamaakkkaaeaaaaae
abaachiaacaappiaacaaoeiaadaaoeibafaaaaadaaaachiaaaaaoeiaabaaoeia
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcoaadaaaaeaaaaaaapiaaaaaa
fjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaa
ajaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
elaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaa
agijcaiaebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaal
ocaabaaaaaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaa
aaaaaaaaalaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaa
abeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaanaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpabaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaa
aaaaaaajocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaa
adaaaaaabaaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaa
elaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaa
bkaabaaaabaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaa
egiccaiaebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaal
hcaabaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaafaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaa
aaaaiadpdhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaa
egaobaaaaaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaa
acaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaaabaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
diaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaak
hcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaiaebaaaaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaabejfdeheoiaaaaaaa
aeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
heaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
"!!ARBfp1.0
# 43 ALU, 1 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TXP R0.xyz, fragment.texcoord[1], texture[0], 2D;
ADD R1.xyz, fragment.texcoord[0], -c[0];
DP3 R0.w, R1, R1;
ADD R1.xyz, fragment.texcoord[0], -c[7];
DP3 R1.y, R1, R1;
MOV R1.x, c[13];
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
SLT R3.w, R0, c[1].x;
ABS R0.w, R3;
ADD R1.z, R1.x, -c[5].x;
RSQ R1.y, R1.y;
RCP R1.x, R1.y;
ABS R1.y, R1.z;
CMP R3.y, -R1, c[13], c[13].x;
SLT R1.w, R1.x, c[8].x;
ABS R2.x, R3.y;
CMP R3.x, -R2, c[13].y, c[13];
CMP R0.w, -R0, c[13].y, c[13].x;
MUL R2.w, R0, R1;
MOV R1.xyz, c[2];
ADD R1.xyz, -R1, c[3];
MUL R2.xyz, R1, c[6].x;
MUL R1.y, R3.w, R3;
MUL R3.y, R2.w, R3;
MOV R1.x, c[13].y;
ABS R1.w, R1;
CMP R1.w, -R1, c[13].y, c[13].x;
MUL R0.w, R0, R1;
CMP R1.xyz, -R1.y, c[4], R1.x;
MUL R3.z, R3.w, R3.x;
ADD R2.xyz, R2, c[2];
CMP R2.xyz, -R3.z, R2, R1;
MOV R1.xyz, c[9];
ADD R1.xyz, -R1, c[10];
MUL R1.xyz, R1, c[12].x;
CMP R2.xyz, -R3.y, c[11], R2;
MUL R2.w, R2, R3.x;
ADD R1.xyz, R1, c[9];
CMP R1.xyz, -R2.w, R1, R2;
ADD R0.xyz, R0, fragment.texcoord[2];
MUL result.color.xyz, R1, R0;
CMP result.color.w, -R0, c[13].y, c[13].x;
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
"ps_2_0
; 45 ALU, 1 TEX
dcl_2d s0
def c13, 0.00000000, 1.00000000, 0, 0
dcl t0.xyz
dcl t1
dcl t2.xyz
texldp r5, t1, s0
add r0.xyz, t0, -c0
dp3 r1.x, r0, r0
mov r0.x, c5
rsq r1.x, r1.x
add r0.x, c13.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c1
abs r0.x, r0
cmp r2.x, r1, c13, c13.y
cmp r0.x, -r0, c13.y, c13
mul_pp r1.x, r2, r0
mov_pp r3.xyz, c4
cmp_pp r6.xyz, -r1.x, c13.x, r3
mov r1.xyz, c3
add r4.xyz, -c2, r1
add r3.xyz, t0, -c7
dp3 r3.x, r3, r3
abs_pp r1.x, r0
mul r4.xyz, r4, c6.x
rsq r3.x, r3.x
rcp r3.x, r3.x
add r3.x, r3, -c8
cmp_pp r1.x, -r1, c13.y, c13
add r7.xyz, r4, c2
mul_pp r4.x, r2, r1
cmp_pp r6.xyz, -r4.x, r6, r7
mov r7.xyz, c10
abs_pp r2.x, r2
add r7.xyz, -c9, r7
mul r7.xyz, r7, c12.x
cmp r3.x, r3, c13, c13.y
cmp_pp r2.x, -r2, c13.y, c13
mul_pp r4.x, r3, r2
mul_pp r0.x, r4, r0
cmp_pp r6.xyz, -r0.x, r6, c11
mul_pp r0.x, r4, r1
add r7.xyz, r7, c9
cmp_pp r1.xyz, -r0.x, r6, r7
abs_pp r0.x, r3
cmp_pp r0.x, -r0, c13.y, c13
add_pp r3.xyz, r5, t2
mul_pp r0.x, r0, r2
mul_pp r1.xyz, r1, r3
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 15 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjicngnfgmjaobcaonfbficfhjbiohppeabaaaaaafeaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcgeadaaaaeaaaaaaanjaaaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaia
ebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaa
aaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
alaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaa
abaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
anaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
abaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaaj
ocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaa
baaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaaf
ccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaa
abaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaia
ebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaa
acaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
afaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
dhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaadaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 256 // 232 used size, 18 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
// 25 instructions, 3 temp regs, 0 temp arrays:
// ALU 15 float, 1 int, 1 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefieceddkebodmoghlpdihlenpgeahhjhjglagdabaaaaaaoaagaaaaaeaaaaaa
daaaaaaaliacaaaaceagaaaakmagaaaaebgpgodjiaacaaaaiaacaaaaaaacpppp
deacaaaaemaaaaaaadaaciaaaaaaemaaaaaaemaaabaaceaaaaaaemaaaaaaaaaa
aaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaaaaaaajaaagaaagaa
aaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaaia
acaaahlabpaaaaacaaaaaajaaaaiapkaacaaaaadaaaaahiaaaaaoelbaaaaoeka
aiaaaaadaaaaabiaaaaaoeiaaaaaoeiaahaaaaacaaaaabiaaaaaaaiaagaaaaac
aaaaabiaaaaaaaiaacaaaaadaaaaabiaaaaaaaiaabaaaakbacaaaaadabaaahia
aaaaoelbagaaoekaaiaaaaadaaaaaciaabaaoeiaabaaoeiaahaaaaacaaaaacia
aaaaffiaagaaaaacaaaaaciaaaaaffiaacaaaaadaaaaaciaaaaaffiaahaaaakb
abaaaaacabaaahiaaiaaoekaacaaaaadacaaahiaabaaoeibajaaoekaaeaaaaae
abaachiaalaaffkaacaaoeiaabaaoeiaabaaaaacabaaaiiaamaaaakaacaaaaad
abaaaiiaabaappiaafaaaakbafaaaaadabaaaiiaabaappiaabaappiafiaaaaae
abaachiaabaappibakaaoekaabaaoeiafiaaaaaeacaachiaaaaaffiaamaaffka
abaaoeiafiaaaaaeacaaciiaaaaaffiaamaaffkaamaaaakaabaaaaacabaaahia
acaaoekaacaaaaadaaaaaoiaabaablibadaablkaaeaaaaaeaaaacoiaafaaffka
aaaaoeiaabaabliafiaaaaaeabaachiaabaappibaeaaoekaaaaabliaabaaaaac
abaaaiiaamaaaakafiaaaaaeaaaacpiaaaaaaaiaacaaoeiaabaaoeiaagaaaaac
abaaabiaabaapplaafaaaaadabaaadiaabaaaaiaabaaoelaecaaaaadabaacpia
abaaoeiaaaaioekaacaaaaadabaachiaabaaoeiaacaaoelaafaaaaadaaaachia
aaaaoeiaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcgeadaaaa
eaaaaaaanjaaaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaa
abaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
aaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaalaaaaaaagijcaaa
aaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaafgifcaaaaaaaaaaaaoaaaaaa
fgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaacaaaaaaibcaabaaaabaaaaaa
akiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaadhaaaaakhcaabaaaacaaaaaa
agaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaajgahbaaaaaaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaahpcaabaaaaaaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaaabaaaaaaagbjbaiaebaaaaaa
abaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaahccaabaaaabaaaaaajgahbaaa
abaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaa
dbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaaaaaaaaaaeaaaaaa
aaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaaaaaaaaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaafgifcaaaaaaaaaaaaiaaaaaa
egacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaadhaaaaakhcaabaaaacaaaaaa
agaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaajpcaabaaaaaaaaaaafgafbaaa
abaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaaaoaaaaahdcaabaaaabaaaaaa
egbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegbcbaaaadaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
doaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
Vector 13 [unity_LightmapFade]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"!!ARBfp1.0
# 54 ALU, 3 TEX
PARAM c[15] = { program.local[0..13],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R0, fragment.texcoord[2], texture[2], 2D;
TEX R1, fragment.texcoord[2], texture[1], 2D;
TXP R2.xyz, fragment.texcoord[1], texture[0], 2D;
MUL R0.xyz, R0.w, R0;
ADD R3.xyz, fragment.texcoord[0], -c[7];
DP3 R2.w, R3, R3;
RSQ R3.w, R2.w;
MOV R3.xyz, c[2];
ADD R4.xyz, -R3, c[3];
MOV R2.w, c[14].x;
ADD R2.w, R2, -c[5].x;
ABS R4.w, R2;
ADD R3.xyz, fragment.texcoord[0], -c[0];
DP3 R2.w, R3, R3;
CMP R5.x, -R4.w, c[14].y, c[14];
RSQ R2.w, R2.w;
RCP R3.x, R2.w;
SLT R4.w, R3.x, c[1].x;
ABS R3.y, R5.x;
CMP R2.w, -R3.y, c[14].y, c[14].x;
MUL R4.xyz, R4, c[6].x;
DP4 R0.w, fragment.texcoord[3], fragment.texcoord[3];
MUL R5.y, R4.w, R2.w;
MUL R3.y, R4.w, R5.x;
MOV R3.x, c[14].y;
CMP R3.xyz, -R3.y, c[4], R3.x;
ADD R4.xyz, R4, c[2];
CMP R4.xyz, -R5.y, R4, R3;
RCP R3.y, R3.w;
ABS R3.x, R4.w;
SLT R4.w, R3.y, c[8].x;
CMP R3.w, -R3.x, c[14].y, c[14].x;
MUL R5.y, R3.w, R4.w;
MOV R3.xyz, c[9];
MUL R5.x, R5.y, R5;
ADD R3.xyz, -R3, c[10];
MUL R3.xyz, R3, c[12].x;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0, c[14].z;
RSQ R0.w, R0.w;
RCP R1.w, R0.w;
ABS R0.w, R4;
MAD R1.xyz, R1, c[14].z, -R0;
MAD_SAT R1.w, R1, c[13].z, c[13];
MAD R0.xyz, R1.w, R1, R0;
ADD R1.xyz, R2, R0;
CMP R0.w, -R0, c[14].y, c[14].x;
MUL R0.x, R3.w, R0.w;
CMP R4.xyz, -R5.x, c[11], R4;
MUL R2.w, R5.y, R2;
ADD R3.xyz, R3, c[9];
CMP R3.xyz, -R2.w, R3, R4;
MUL result.color.xyz, R3, R1;
CMP result.color.w, -R0.x, c[14].y, c[14].x;
END
# 54 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
Vector 13 [unity_LightmapFade]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"ps_2_0
; 54 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c14, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xyz
dcl t1
dcl t2.xy
dcl t3
texldp r7, t1, s0
texld r5, t2, s2
texld r6, t2, s1
add r0.xyz, t0, -c0
dp3 r0.x, r0, r0
mov r1.x, c5
rsq r0.x, r0.x
add r1.x, c14.y, -r1
abs r1.x, r1
rcp r0.x, r0.x
add r0.x, r0, -c1
mul_pp r5.xyz, r5.w, r5
cmp r2.x, -r1, c14.y, c14
cmp r0.x, r0, c14, c14.y
mul_pp r1.x, r0, r2
mov_pp r4.xyz, c4
cmp_pp r8.xyz, -r1.x, c14.x, r4
add r3.xyz, t0, -c7
dp3 r1.x, r3, r3
mov r3.xyz, c3
add r4.xyz, -c2, r3
mul r4.xyz, r4, c6.x
abs_pp r3.x, r2
rsq r1.x, r1.x
rcp r1.x, r1.x
add r1.x, r1, -c8
add r9.xyz, r4, c2
cmp_pp r3.x, -r3, c14.y, c14
mul_pp r4.x, r0, r3
cmp_pp r8.xyz, -r4.x, r8, r9
abs_pp r0.x, r0
mov r9.xyz, c10
cmp_pp r0.x, -r0, c14.y, c14
cmp r1.x, r1, c14, c14.y
mul_pp r4.x, r1, r0
mul_pp r2.x, r4, r2
abs_pp r1.x, r1
cmp_pp r1.x, -r1, c14.y, c14
mul_pp r0.x, r1, r0
add r9.xyz, -c9, r9
cmp_pp r8.xyz, -r2.x, r8, c11
mul r2.xyz, r9, c12.x
add r9.xyz, r2, c9
mul_pp r2.x, r4, r3
cmp_pp r3.xyz, -r2.x, r8, r9
dp4 r2.x, t3, t3
rsq r2.x, r2.x
rcp r2.x, r2.x
mul_pp r5.xyz, r5, c14.z
mul_pp r4.xyz, r6.w, r6
mad_pp r4.xyz, r4, c14.z, -r5
mad_sat r2.x, r2, c13.z, c13.w
mad_pp r2.xyz, r2.x, r4, r5
add_pp r2.xyz, r7, r2
mul_pp r1.xyz, r3, r2
cmp_pp r1.w, -r0.x, c14.y, c14.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 288 // 272 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
Vector 256 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
SetTexture 2 [unity_LightmapInd] 2D 2
// 35 instructions, 3 temp regs, 0 temp arrays:
// ALU 23 float, 1 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbgmkckoockdhbmgkeodclhnibcceiafcabaaaaaapeafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcomaeaaaaeaaaaaaadlabaaaafjaaaaaeegiocaaaaaaaaaaabbaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaaabaaaaaa
gcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaadpcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaabbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaa
agajbaaaabaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
adaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaajgahbaaaaaaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaa
aaaaaaaaalaaaaaaegiccaaaaaaaaaaaamaaaaaadcaaaaalhcaabaaaabaaaaaa
fgifcaaaaaaaaaaaaoaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaa
caaaaaaiicaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaa
dhaaaaakhcaabaaaacaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaah
pcaabaaaacaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajhcaabaaa
abaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaiaebaaaaaa
aaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaabaaaaaa
fgifcaaaaaaaaaaaaiaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaafaaaaaa
dhaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpdhaaaaaj
pcaabaaaabaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaacaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 288 // 272 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
Vector 256 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
SetTexture 2 [unity_LightmapInd] 2D 2
// 35 instructions, 3 temp regs, 0 temp arrays:
// ALU 23 float, 1 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedbdijlanhfpoaenebninifjilmljabkhjabaaaaaagmajaaaaaeaaaaaa
daaaaaaakeadaaaajiaiaaaadiajaaaaebgpgodjgmadaaaagmadaaaaaaacpppp
amadaaaagaaaaaaaaeaadaaaaaaagaaaaaaagaaaadaaceaaaaaagaaaaaaaaaaa
abababaaacacacaaaaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaa
aaaaajaaagaaagaaaaaaaaaaaaaabaaaabaaamaaaaaaaaaaaaacppppfbaaaaaf
anaaapkaaaaaiadpaaaaaaaaaaaaaaebaaaaaaaabpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaaaplabpaaaaacaaaaaaiaacaaadlabpaaaaacaaaaaaia
adaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaac
aaaaaajaacaiapkaagaaaaacaaaaaiiaabaapplaafaaaaadaaaaadiaaaaappia
abaaoelaecaaaaadabaacpiaacaaoelaacaioekaecaaaaadacaacpiaacaaoela
abaioekaecaaaaadaaaacpiaaaaaoeiaaaaioekaajaaaaadaaaaaiiaadaaoela
adaaoelaahaaaaacaaaaaiiaaaaappiaagaaaaacaaaaaiiaaaaappiaaeaaaaae
aaaadiiaaaaappiaamaakkkaamaappkaafaaaaadabaaciiaabaappiaanaakkka
afaaaaadabaachiaabaaoeiaabaappiaafaaaaadabaaciiaacaappiaanaakkka
aeaaaaaeacaachiaabaappiaacaaoeiaabaaoeibaeaaaaaeabaachiaaaaappia
acaaoeiaabaaoeiaacaaaaadaaaachiaaaaaoeiaabaaoeiaacaaaaadabaaahia
aaaaoelbaaaaoekaaiaaaaadaaaaaiiaabaaoeiaabaaoeiaahaaaaacaaaaaiia
aaaappiaagaaaaacaaaaaiiaaaaappiaacaaaaadaaaaaiiaaaaappiaabaaaakb
acaaaaadabaaahiaaaaaoelbagaaoekaaiaaaaadabaaabiaabaaoeiaabaaoeia
ahaaaaacabaaabiaabaaaaiaagaaaaacabaaabiaabaaaaiaacaaaaadabaaabia
abaaaaiaahaaaakbabaaaaacacaaahiaaiaaoekaacaaaaadabaaaoiaacaablib
ajaablkaaeaaaaaeabaacoiaalaaffkaabaaoeiaacaabliaabaaaaacacaaabia
anaaaakaacaaaaadacaaabiaacaaaaiaafaaaakbafaaaaadacaaabiaacaaaaia
acaaaaiafiaaaaaeabaacoiaacaaaaibakaablkaabaaoeiafiaaaaaeadaachia
abaaaaiaanaaffkaabaabliafiaaaaaeadaaciiaabaaaaiaanaaffkaanaaaaka
abaaaaacabaaahiaacaaoekaacaaaaadacaaaoiaabaablibadaablkaaeaaaaae
abaachiaafaaffkaacaabliaabaaoeiafiaaaaaeabaachiaacaaaaibaeaaoeka
abaaoeiaabaaaaacabaaciiaanaaaakafiaaaaaeabaacpiaaaaappiaadaaoeia
abaaoeiaafaaaaadabaachiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaabaaoeia
ppppaaaafdeieefcomaeaaaaeaaaaaaadlabaaaafjaaaaaeegiocaaaaaaaaaaa
bbaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaadhcbabaaa
abaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaad
pcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaabbaaaaah
bcaabaaaaaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
ckiacaaaaaaaaaaabaaaaaaadkiacaaaaaaaaaaabaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaah
ccaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahocaabaaa
aaaaaaaaagajbaaaabaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaabaaaaaa
pgapbaaaabaaaaaaegacbaaaabaaaaaajgahbaiaebaaaaaaaaaaaaaadcaaaaaj
hcaabaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaajgahbaaaaaaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaalaaaaaaegiccaaaaaaaaaaaamaaaaaadcaaaaalhcaabaaa
abaaaaaafgifcaaaaaaaaaaaaoaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
alaaaaaacaaaaaaiicaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaa
abaaaaaadhaaaaakhcaabaaaacaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaa
anaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
abaaaaahpcaabaaaacaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaaj
hcaabaaaabaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaelaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadbaaaaaiicaabaaaaaaaaaaadkaabaaa
aaaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaabaaaaaaegiccaia
ebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaa
abaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
afaaaaaadhaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajpcaabaaaabaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaadadaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
# 45 ALU, 2 TEX
PARAM c[14] = { program.local[0..12],
		{ 1, 0, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[2], texture[1], 2D;
TXP R1.xyz, fragment.texcoord[1], texture[0], 2D;
MUL R0.xyz, R0.w, R0;
ADD R2.xyz, fragment.texcoord[0], -c[7];
DP3 R1.w, R2, R2;
RSQ R2.w, R1.w;
MOV R2.xyz, c[2];
MOV R1.w, c[13].x;
ADD R1.w, R1, -c[5].x;
ABS R3.w, R1;
ADD R3.xyz, fragment.texcoord[0], -c[0];
DP3 R1.w, R3, R3;
CMP R4.x, -R3.w, c[13].y, c[13];
RSQ R1.w, R1.w;
RCP R3.x, R1.w;
ABS R3.y, R4.x;
ADD R2.xyz, -R2, c[3];
SLT R3.w, R3.x, c[1].x;
CMP R1.w, -R3.y, c[13].y, c[13].x;
MUL R3.xyz, R2, c[6].x;
MUL R4.y, R3.w, R1.w;
MUL R2.y, R3.w, R4.x;
MOV R2.x, c[13].y;
CMP R2.xyz, -R2.y, c[4], R2.x;
ADD R3.xyz, R3, c[2];
CMP R3.xyz, -R4.y, R3, R2;
RCP R2.y, R2.w;
ABS R2.x, R3.w;
SLT R3.w, R2.y, c[8].x;
CMP R2.w, -R2.x, c[13].y, c[13].x;
MUL R4.y, R2.w, R3.w;
MOV R2.xyz, c[9];
MUL R4.x, R4.y, R4;
ADD R2.xyz, -R2, c[10];
MUL R2.xyz, R2, c[12].x;
MUL R1.w, R4.y, R1;
MAD R1.xyz, R0, c[13].z, R1;
CMP R3.xyz, -R4.x, c[11], R3;
ADD R2.xyz, R2, c[9];
CMP R2.xyz, -R1.w, R2, R3;
ABS R1.w, R3;
CMP R0.w, -R1, c[13].y, c[13].x;
MUL R0.x, R2.w, R0.w;
MUL result.color.xyz, R2, R1;
CMP result.color.w, -R0.x, c[13].y, c[13].x;
END
# 45 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Brush1Pos]
Float 1 [_Brush1Radius]
Vector 2 [_Brush1ColorSelectedLow]
Vector 3 [_Brush1ColorSelectedHigh]
Vector 4 [_Brush1DirtyColor]
Float 5 [_Brush1ActivationFlag]
Float 6 [_Brush1ActivationState]
Vector 7 [_Brush2Pos]
Float 8 [_Brush2Radius]
Vector 9 [_Brush2ColorSelectedLow]
Vector 10 [_Brush2ColorSelectedHigh]
Vector 11 [_Brush2DirtyColor]
Float 12 [_Brush2ActivationState]
SetTexture 0 [_LightBuffer] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 46 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c13, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xyz
dcl t1
dcl t2.xy
texldp r6, t1, s0
texld r5, t2, s1
add r0.xyz, t0, -c0
dp3 r1.x, r0, r0
mov r0.x, c5
rsq r1.x, r1.x
add r0.x, c13.y, -r0
rcp r1.x, r1.x
add r1.x, r1, -c1
abs r0.x, r0
cmp r2.x, r1, c13, c13.y
cmp r0.x, -r0, c13.y, c13
mul_pp r1.x, r2, r0
mov_pp r4.xyz, c4
cmp_pp r7.xyz, -r1.x, c13.x, r4
add r3.xyz, t0, -c7
dp3 r1.x, r3, r3
rsq r3.x, r1.x
abs_pp r1.x, r0
mov r4.xyz, c3
add r4.xyz, -c2, r4
mul r4.xyz, r4, c6.x
rcp r3.x, r3.x
add r3.x, r3, -c8
add r8.xyz, r4, c2
cmp_pp r1.x, -r1, c13.y, c13
mul_pp r4.x, r2, r1
cmp_pp r7.xyz, -r4.x, r7, r8
abs_pp r2.x, r2
mov r8.xyz, c10
cmp r3.x, r3, c13, c13.y
cmp_pp r2.x, -r2, c13.y, c13
mul_pp r4.x, r3, r2
mul_pp r0.x, r4, r0
add r8.xyz, -c9, r8
cmp_pp r7.xyz, -r0.x, r7, c11
mul r0.xyz, r8, c12.x
add r8.xyz, r0, c9
mul_pp r0.x, r4, r1
cmp_pp r1.xyz, -r0.x, r7, r8
abs_pp r0.x, r3
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r0.x, r0, r2
mul_pp r4.xyz, r5.w, r5
mad_pp r3.xyz, r4, c13.z, r6
mul_pp r1.xyz, r1, r3
cmp_pp r1.w, -r0.x, c13.y, c13.x
mov_pp oC0, r1
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 288 // 232 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 27 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedljcbebbmdapikdemiacbkcopjpdbockdabaaaaaaliaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcmiadaaaaeaaaaaaapcaaaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaadhcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaiaebaaaaaa
aaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaaaaaaaaaa
fgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaalaaaaaa
caaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaabaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaa
jgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpabaaaaah
pcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaajocaabaaa
abaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaabaaaaaah
ccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaafccaabaaa
abaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaaabaaaaaa
akiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaiaebaaaaaa
aaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaaacaaaaaa
fgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaafaaaaaa
dhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
egacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadpdhaaaaaj
pcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
dcaaaaajhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 288 // 232 used size, 20 vars
Vector 48 [_Brush1Pos] 4
Float 64 [_Brush1Radius]
Vector 80 [_Brush1ColorSelectedLow] 4
Vector 96 [_Brush1ColorSelectedHigh] 4
Vector 112 [_Brush1DirtyColor] 4
ScalarInt 128 [_Brush1ActivationFlag]
Float 132 [_Brush1ActivationState]
Vector 144 [_Brush2Pos] 4
Float 160 [_Brush2Radius]
Vector 176 [_Brush2ColorSelectedLow] 4
Vector 192 [_Brush2ColorSelectedHigh] 4
Vector 208 [_Brush2DirtyColor] 4
Float 228 [_Brush2ActivationState]
BindCB "$Globals" 0
SetTexture 0 [_LightBuffer] 2D 0
SetTexture 1 [unity_Lightmap] 2D 1
// 27 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 1 int, 1 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecediemnnjoleacmgkmldiogafogjfdmedoaabaaaaaahiahaaaaaeaaaaaa
daaaaaaaomacaaaalmagaaaaeeahaaaaebgpgodjleacaaaaleacaaaaaaacpppp
geacaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaaaaaaaaa
abababaaaaaaadaaafaaaaaaaaaaaaaaaaaaaiaaabaaafaaacaaaaaaaaaaajaa
agaaagaaaaaaaaaaaaacppppfbaaaaafamaaapkaaaaaiadpaaaaaaaaaaaaaaeb
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaaaplabpaaaaac
aaaaaaiaacaaadlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
acaaaaadaaaaahiaaaaaoelbaaaaoekaaiaaaaadaaaaabiaaaaaoeiaaaaaoeia
ahaaaaacaaaaabiaaaaaaaiaagaaaaacaaaaabiaaaaaaaiaacaaaaadaaaaabia
aaaaaaiaabaaaakbacaaaaadabaaahiaaaaaoelbagaaoekaaiaaaaadaaaaacia
abaaoeiaabaaoeiaahaaaaacaaaaaciaaaaaffiaagaaaaacaaaaaciaaaaaffia
acaaaaadaaaaaciaaaaaffiaahaaaakbabaaaaacabaaahiaaiaaoekaacaaaaad
acaaahiaabaaoeibajaaoekaaeaaaaaeabaachiaalaaffkaacaaoeiaabaaoeia
abaaaaacabaaaiiaamaaaakaacaaaaadabaaaiiaabaappiaafaaaakbafaaaaad
abaaaiiaabaappiaabaappiafiaaaaaeabaachiaabaappibakaaoekaabaaoeia
fiaaaaaeacaachiaaaaaffiaamaaffkaabaaoeiafiaaaaaeacaaciiaaaaaffia
amaaffkaamaaaakaabaaaaacabaaahiaacaaoekaacaaaaadaaaaaoiaabaablib
adaablkaaeaaaaaeaaaacoiaafaaffkaaaaaoeiaabaabliafiaaaaaeabaachia
abaappibaeaaoekaaaaabliaabaaaaacabaaaiiaamaaaakafiaaaaaeaaaacpia
aaaaaaiaacaaoeiaabaaoeiaagaaaaacabaaabiaabaapplaafaaaaadabaaadia
abaaaaiaabaaoelaecaaaaadabaacpiaabaaoeiaaaaioekaecaaaaadacaacpia
acaaoelaabaioekaafaaaaadabaaciiaacaappiaamaakkkaaeaaaaaeabaachia
abaappiaacaaoeiaabaaoeiaafaaaaadaaaachiaaaaaoeiaabaaoeiaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefcmiadaaaaeaaaaaaapcaaaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaagcbaaaadhcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaad
dcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaa
baaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaelaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadbaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaaaaaaaakocaabaaaaaaaaaaaagijcaia
ebaaaaaaaaaaaaaaalaaaaaaagijcaaaaaaaaaaaamaaaaaadcaaaaalocaabaaa
aaaaaaaafgifcaaaaaaaaaaaaoaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
alaaaaaacaaaaaaibcaabaaaabaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaa
abaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
anaaaaaajgahbaaaaaaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
abaaaaahpcaabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaacaaaaaaaaaaaaaj
ocaabaaaabaaaaaaagbjbaiaebaaaaaaabaaaaaaagijcaaaaaaaaaaaadaaaaaa
baaaaaahccaabaaaabaaaaaajgahbaaaabaaaaaajgahbaaaabaaaaaaelaaaaaf
ccaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaaiccaabaaaabaaaaaabkaabaaa
abaaaaaaakiacaaaaaaaaaaaaeaaaaaaaaaaaaakhcaabaaaacaaaaaaegiccaia
ebaaaaaaaaaaaaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaalhcaabaaa
acaaaaaafgifcaaaaaaaaaaaaiaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
afaaaaaadhaaaaakhcaabaaaacaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaiadp
dhaaaaajpcaabaaaaaaaaaaafgafbaaaabaaaaaaegaobaaaacaaaaaaegaobaaa
aaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaebdcaaaaajhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaabejfdeheo
iaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaaheaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaapalaaaaheaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

}
	}

#LINE 110

		
	} 
	FallBack "Diffuse"
}
