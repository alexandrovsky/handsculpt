Shader "Custom/TestSurfaceShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "green" {}
		_BrushPos ("BrushPos", Vector) = (0,0,0,0)
		_BrushRadius ("BrushRadius", float) = 0.5
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

        struct Input {
            float2 uv_MainTex;
            float4 color: Color; // Vertex color
            float3 worldPos;
        };

 

        void surf (Input IN, inout SurfaceOutput o) {

            half4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb * IN.color.rgb; // vertex RGB
            o.Alpha = c.a * IN.color.a; // vertex Alpha
            
            float curDistance = distance(_BrushPos.xyz, IN.worldPos);
            if(curDistance < _BrushRadius){
            	o.Albedo = float4(0.0f, 0.0f, 1.0f, 1.0f);
            }
        }

		ENDCG
		
	} 
	FallBack "Diffuse"
}
