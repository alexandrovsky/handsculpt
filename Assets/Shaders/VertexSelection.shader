Shader "Myshaders/TransparentReflective" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
         _Cube ("Cubemap", CUBE) = "" {}
         
         
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
        Tags {"Queue"="transparent" "RenderType"="transparent" }
 
        Cull Off
 
        CGPROGRAM
        #pragma surface surf Lambert alpha
 
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
            float3 worldRefl;
            float4 _Color;
            float3 worldPos;
        };
        samplerCUBE _Cube;
        float4 _Color;
        void surf (Input IN, inout SurfaceOutput o) {
            
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
			}else if(curDistance2 < _Brush2Radius){
				if(1 == _Brush1ActivationFlag){
	            	o.Albedo.rgb = _Brush2DirtyColor.rgb;
	            }else{
	            	half4 dirtyColor = lerp(_Brush2ColorSelectedLow, _Brush2ColorSelectedHigh, _Brush2ActivationState);
	            	o.Albedo.rgb = dirtyColor.rgb;
	            }
			
			}else{
			
            	o.Albedo = _Color.rgb;
            	o.Emission = _Color.rgb; // texCUBE (_Cube, IN.worldRefl).rgb*_Color.rgb;
            	o.Alpha = _Color.a;
            
	        }
            
        }
        ENDCG
    } 
    FallBack "Transparent/Diffuse"
}
