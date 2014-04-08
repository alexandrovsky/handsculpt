Shader "Custom/test/MultipleLights" {
	Properties {
		_Color("Color", Color)  = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Spec", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", float) = 4.0
		_RimColor("RimColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower("Rim Power", Range(0.1, 10.0)) = 3.0
	}
	SubShader {
		Pass{
		Tags { "LightMode"="ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			
			
			
			uniform float4 _Color;
 			uniform float4 _SpecColor;
 			uniform float _Shininess;
 			uniform float4 _RimColor;
 			uniform float _RimPower;
 			
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
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float4 color : COLOR;
            };
 
            vertexOutput vert(vertexInput v)
            {
            	vertexOutput o;
            	o.posWorld = mul(_Object2World, v.vertex);
            	o.normalDir = normalize( mul(float4(v.normal,0.0), _World2Object).xyz );
            	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
               	o.color = v.color;
                
                return o;
            }
            
 
 			
            float4 frag(vertexOutput i) : COLOR
            {
                float3 normalDirection = i.normalDir;
            	float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz );
                float3 lightDirection;
                
                float atten = 0.75;
                
                
                if(_WorldSpaceLightPos0.w == 0.0){
                	lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                }else{
                	float3 fragmetToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
                	float distance = length(fragmetToLightSource);
                	atten = 1/distance;
                	lightDirection =  normalize(fragmetToLightSource);
                }
                
                
                //lightning:
                float3 diffuseReflection = atten * _LightColor0.xyz * (i.color + _Color.rgb) * max(0.0, dot(lightDirection, normalDirection) );
                float3 specularReflection = max(0.0, dot(lightDirection, normalDirection) ) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                
                //rim:
                float rim = 1 - saturate(dot(normalize(viewDirection), normalDirection));
                float3 rimLighting = atten * _LightColor0.xyz * _RimColor * saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);
                
                
                float3 lightFinal = rimLighting + diffuseReflection + 0.2 * specularReflection + UNITY_LIGHTMODEL_AMBIENT;
                
                return float4(lightFinal, 1.0);
            }
            	
			ENDCG
		}
		Pass{
		Tags { "LightMode"="ForwardAdd" }
			Blend One One
			CGPROGRAM
			#pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			
			
			
			uniform float4 _Color;
 			uniform float4 _SpecColor;
 			uniform float _Shininess;
 			uniform float4 _RimColor;
 			uniform float _RimPower;
 			
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
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float4 color : COLOR;
            };
 
            vertexOutput vert(vertexInput v)
            {
            	vertexOutput o;
            	o.posWorld = mul(_Object2World, v.vertex);
            	o.normalDir = normalize( mul(float4(v.normal,0.0), _World2Object).xyz );
            	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
               	o.color = v.color;
                
                return o;
            }
            
 
 			
            float4 frag(vertexOutput i) : COLOR
            {
                float3 normalDirection = i.normalDir;
            	float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz );
                float3 lightDirection;
                
                float atten = 0.75;
                
                
                if(_WorldSpaceLightPos0.w == 0.0){
                	lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                }else{
                	float3 fragmetToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
                	float distance = length(fragmetToLightSource);
                	atten = 1/distance;
                	lightDirection =  normalize(fragmetToLightSource);
                }
                
                
                //lightning:
                float3 diffuseReflection = atten * _LightColor0.xyz * (i.color + _Color.rgb) * max(0.0, dot(lightDirection, normalDirection) );
                float3 specularReflection = max(0.0, dot(lightDirection, normalDirection) ) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                
                //rim:
                float rim = 1 - saturate(dot(normalize(viewDirection), normalDirection));
                float3 rimLighting = atten * _LightColor0.xyz * _RimColor * saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);
                
                
                float3 lightFinal = rimLighting + diffuseReflection + 0.2 * specularReflection + UNITY_LIGHTMODEL_AMBIENT;
                
                return float4(lightFinal, 1.0);
            }
            	
			ENDCG
		}
	}

	FallBack "Specular"
}
