Shader "Custom/SelectVertexColorShader" {
 
 	Properties {
    }
    Category {
        BindChannels { 
            Bind "Color", color 
            Bind "Vertex", vertex
            Bind "Normal", normal
            
        }
        
        SubShader {
        	Pass {
        	}
        }
    }
}