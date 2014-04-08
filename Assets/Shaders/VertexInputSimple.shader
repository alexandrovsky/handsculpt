// http://answers.unity3d.com/questions/189584/how-to-get-vertex-color-in-a-cg-shader.html

Shader "Custom/VertexInputSimple" {
    Properties {
    	_Color("Color", Color)  = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader 
    {
        //Tags { "LightMode" = "ForwardBase"}       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
 
 			uniform float4 _Color;
 			uniform float4 _LightColor0;
 			uniform float _RimPower
 			//unity 3
 			//uniform float4 _WorldSpaceLightPos0;
 			//uniform float4x4 _Object2World;
 			//uniform float4x4 _World2Object;
 			
            struct VertOut
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };
 
            struct VertIn
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };
 
            VertOut vert(VertIn input)
            {
                VertOut output;
                output.pos =  mul(UNITY_MATRIX_MVP,input.vertex);
                
                float3 normalDirection = normalize( mul(float4(input.normal,0.0), _World2Object).xyz );
                float3 lightDirection;
                float atten = 1.0;
                
                lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(lightDirection, normalDirection) );
                float3 lightFinal = diffuseReflection; // + 0.3 * UNITY_LIGHTMODEL_AMBIENT.xyz;
                output.color =  float4(normalize( (_Color + input.color.rgb) * lightFinal ), 1.0);
                return output;
            }
 
            struct FragOut
            {
                float4 color : COLOR;
            };
 
            FragOut frag(float4 color : COLOR)
            {
                FragOut output;
                output.color = color;
                return output;
            }
            ENDCG
 
        }
    }
    FallBack "Diffuse"
}