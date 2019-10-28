// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MotionBlurWithDepthTexture"
{
    Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlurSize ("Blur Size", Float) = 1.0
	}
    SubShader {
		CGINCLUDE
		
		#include "UnityCG.cginc"
		
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;//主纹理纹素大小，利用其对深度纹理的采样化坐标进行平台差异化处理
		sampler2D _CameraDepthTexture; //Unity传递的的深度纹理
		float4x4 _CurrentViewProjectionInverseMatrix; 
		float4x4 _PreviousViewProjectionMatrix;
		half _BlurSize;
		
		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv_depth : TEXCOORD1; //专门用于深度纹理采样的纹理坐标变量
		};
		
		v2f vert(appdata_img v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			
			o.uv = v.texcoord;
			o.uv_depth = v.texcoord;
			
			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				o.uv_depth.y = 1 - o.uv_depth.y; //处理图像翻转问题
			#endif
					 
			return o;
		}
		
		fixed4 frag(v2f i) : SV_Target {
			// 世界空间下的深度值.
			float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth);
			// 要构建的坐标H
			float4 H = float4(i.uv.x * 2 - 1, i.uv.y * 2 - 1, d * 2 - 1, 1);
			// 把深度值映射到NDC
			float4 D = mul(_CurrentViewProjectionInverseMatrix, H);
			// 得到世界空间下的D
			float4 worldPos = D / D.w;
			
			// 当前坐标位置
			float4 currentPos = H;
			// 前一帧的视角和投影矩阵对它进行变换
			float4 previousPos = mul(_PreviousViewProjectionMatrix, worldPos);
			// Convert to nonhomogeneous points [-1,1] by dividing by w.
			previousPos /= previousPos.w;
			
			// 计算前一帧和当前帧在屏幕空间下的位置差
			float2 velocity = (currentPos.xy - previousPos.xy)/2.0f;
			
			float2 uv = i.uv;
			float4 c = tex2D(_MainTex, uv);
			uv += velocity * _BlurSize;//blursize 控制采样距离
			for (int it = 1; it < 3; it++, uv += velocity * _BlurSize) {
				float4 currentColor = tex2D(_MainTex, uv);
				c += currentColor;
			}
			c /= 3;
			
			return fixed4(c.rgb, 1.0);
		}
		
		ENDCG
		
		Pass {      
			ZTest Always Cull Off ZWrite Off
			    	
			CGPROGRAM  
			
			#pragma vertex vert  
			#pragma fragment frag  
			  
			ENDCG  
		}
	} 
	FallBack Off
}
