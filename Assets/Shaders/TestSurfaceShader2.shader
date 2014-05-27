Shader "Custom/TestSurfaceShader2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
	}
	SubShader {

	
	Tags { "RenderType"="Opaque" }
	//LOD 200
		
		CGPROGRAM
//		#pragma surface surf BlinnPhong
		#pragma surface surf SimpleSpecular

		sampler2D _MainTex;

 
 		half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
          half3 h = normalize (lightDir + viewDir);

          half diff = max (0, dot (s.Normal, lightDir));

          float nh = max (0, dot (s.Normal, h));
          float spec = pow (nh, 48.0);

          half4 c;
          c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * (atten * 2);
          c.a = s.Alpha;
          return c;
      }

        struct Input {

            float2 uv_MainTex;
            float4 color: Color; // Vertex color

        };

 

        void surf (Input IN, inout SurfaceOutput o) {

            half4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb * IN.color.rgb; // vertex RGB
            //o.Alpha = c.a * IN.color.a; // vertex Alpha

        }

		ENDCG
		
	} 
	FallBack "Diffuse"
}
