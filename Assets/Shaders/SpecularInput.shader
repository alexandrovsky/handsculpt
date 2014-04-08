Shader "Custom/SpecularInput" {
	Properties {
		_Color("Color", Color)  = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Spec", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", float) = 4.0
	}
	SubShader {
		Tags { "LightMode"="ForwardBase" }
		//Blend SrcAlpha OneMinusSrcAlpha
		
		
		Pass{
			CGPROGRAM
			#pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			
			
			
			uniform float4 _Color;
 			uniform float4 _SpecColor;
 			uniform float _Shininess;
 			
 			uniform float4 _LightColor0;
 			uniform float4 _LightColor1;
 			
 			
            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };
 
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
                //float3 normal : NORMAL;
            };
 
            vertexOutput vert(vertexInput v)
            {
            	vertexOutput o;
            	
            	float3 normalDirection = normalize( mul(float4(v.normal,0.0), _World2Object).xyz );
            	float3 viewDirection = normalize( float3(float4(_WorldSpaceCameraPos.xyz,1.0) - mul(_Object2World, v.vertex).xyz ) );
                float3 lightDirection;
                float atten = 0.75;
                
                lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                
                
                float3 diffuseReflection = atten * _LightColor0.xyz * (v.color.rgb * _Color.rgb) * max(0.0, dot(lightDirection, normalDirection) );
                
                float3 specularReflection = max(0.0, dot(lightDirection, normalDirection) ) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                float3 lightFinal = diffuseReflection + 0.2 * specularReflection + UNITY_LIGHTMODEL_AMBIENT;
                
                o.color =  float4(lightFinal, 1.0);
            	
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                
                
                return o;
            }
            
 
 			struct fragOutput
            {
                float4 color : COLOR;
            };
 
            fragOutput frag(vertexOutput i)
            {
                fragOutput output;
                output.color = i.color;
                return output;
            }
 
            
            
            	
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
