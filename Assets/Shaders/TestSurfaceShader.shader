Shader "Custom/TestSurfaceShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "green" {}
		_BrushPos ("BrushPos", Vector) = (0,0,0,0)
		_BrushColorSelectedLow ("BrushColorSelectedLow", Color) = (0,0,0,0)
		_BrushColorSelectedHigh ("BrushColorSelectedHigh", Color) = (0,0,0,0)
		_BrushDirtyColor ("BrushDirtyColor", Color) = (0,0,0,0)
		
		_BrushRadius ("BrushRadius", float) = 0.5
		_BrushActivationFlag ("BrushActivationFlag", int) = 0
		_BrushActivationState ("BrushActivationState", float) = 0.0 // the range between [0,1] 0 : Clear; 1 : Activated
	}
	SubShader {

	//transparency:
	//Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
    //Blend SrcAlpha OneMinusSrcAlpha
    //Cull Off
    //LOD 200

	
	Tags { "RenderType"="Opaque" }
	LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		//BlinnPhong

		sampler2D _MainTex;
		float4 _BrushPos;
 		float _BrushRadius;

		float4 _BrushColorSelectedLow;
		float4 _BrushColorSelectedHigh;
		float4 _BrushDirtyColor;
		
		int _BrushActivationFlag;
		float _BrushActivationState;
		
        struct Input {
            float2 uv_MainTex;
            float4 color: Color; // Vertex color
            float3 worldPos;
        };

 

        void surf (Input IN, inout SurfaceOutput o) {

            half4 c = tex2D (_MainTex, IN.uv_MainTex);
//            o.Albedo = c.rgb * IN.color.rgb; // vertex RGB
//            o.Alpha = c.a * IN.color.a; // vertex Alpha
            
            float curDistance = distance(_BrushPos.xyz, IN.worldPos);
            if(curDistance < _BrushRadius){
            
            	//o.Albedo.rgb = float3(_BrushDirtyColor.x, _BrushDirtyColor.y, _BrushDirtyColor.z);
            	//o.Albedo.rgb = _BrushDirtyColor.rgb; //float3(0.0f, 0.0f, 1.0f);
            
	            if(1 == _BrushActivationFlag){
	            	o.Albedo.rgb = _BrushDirtyColor.rgb;
	            }else{
	            	half4 dirtyColor = lerp(_BrushColorSelectedLow, _BrushColorSelectedHigh, _BrushActivationState);
	            	o.Albedo.rgb = dirtyColor.rgb;
	            }
			}else{
            	o.Albedo = IN.color.rgb;
	        }
			//o.Alpha = IN.color.a;
        }

		ENDCG
		
	} 
	FallBack "Diffuse"
}
