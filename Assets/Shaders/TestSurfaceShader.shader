Shader "Custom/TestSurfaceShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "green" {}
	}
	SubShader {

	Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
    Blend SrcAlpha OneMinusSrcAlpha
    //Cull Off
    LOD 200

	
	Tags { "RenderType"="Opaque" }
	LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;

 

        struct Input {

            float2 uv_MainTex;

            float4 color: Color; // Vertex color

        };

 

        void surf (Input IN, inout SurfaceOutput o) {

            half4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo =  c.rgb * IN.color.rgb; // vertex RGB
            o.Alpha = c.a * IN.color.a; // vertex Alpha

        }

		ENDCG
		
	} 
	FallBack "Diffuse"
}
