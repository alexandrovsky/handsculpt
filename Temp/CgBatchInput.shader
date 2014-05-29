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
		
		CGPROGRAM
		#pragma surface surf Lambert alpha;
		//BlinnPhong

		sampler2D _MainTex;
		float4 _Brush1Pos;
 		float _Brush1Radius;

		float4 _Brush1ColorSelectedLow;
		float4 _Brush1ColorSelectedHigh;
		float4 _Brush1DirtyColor;
		
		int _Brush1ActivationFlag;
		float _Brush1ActivationState;
		
		
		float4 _Brush2Pos;
 		float _Brush2Radius;

		float4 _Brush2ColorSelectedLow;
		float4 _Brush2ColorSelectedHigh;
		float4 _Brush2DirtyColor;
		
		int _Brush2ActivationFlag;
		float _Brush2ActivationState;
		
        struct Input {
            float2 uv_MainTex;
            float4 color: Color; // Vertex color
            float3 worldPos;
        };

 

        void surf (Input IN, inout SurfaceOutput o) {

            half4 c = tex2D (_MainTex, IN.uv_MainTex);
//            o.Albedo = c.rgb * IN.color.rgb; // vertex RGB
//            o.Alpha = c.a * IN.color.a; // vertex Alpha
            
            float curDistance1 = distance(_Brush1Pos.xyz, IN.worldPos);
            float curDistance2 = distance(_Brush2Pos.xyz, IN.worldPos);
            if(curDistance1 < _Brush1Radius){
            
            	//o.Albedo.rgb = float3(_Brush1DirtyColor.x, _Brush1DirtyColor.y, _Brush1DirtyColor.z);
            	//o.Albedo.rgb = _Brush1DirtyColor.rgb; //float3(0.0f, 0.0f, 1.0f);
            
	            if(1 == _Brush1ActivationFlag){
	            	o.Albedo.rgb = _Brush1DirtyColor.rgb;
	            }else{
	            	half4 dirtyColor = lerp(_Brush1ColorSelectedLow, _Brush1ColorSelectedHigh, _Brush1ActivationState);
	            	o.Albedo.rgb = dirtyColor.rgb;
	            }
	            o.Alpha = 1.0;
			}else if(curDistance2 < _Brush2Radius){
				if(1 == _Brush1ActivationFlag){
	            	o.Albedo.rgb = _Brush2DirtyColor.rgb;
	            }else{
	            	half4 dirtyColor = lerp(_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, _Brush2ActivationState);
	            	o.Albedo.rgb = dirtyColor.rgb;
	            }
			
				o.Alpha = 1.0;
			}else{
            	//o.Albedo = IN.color.rgb;
            	o.Alpha = 0.0;
	        }
			//o.Alpha = IN.color.a;
        }

		ENDCG
		
	} 
	FallBack "Diffuse"
}
