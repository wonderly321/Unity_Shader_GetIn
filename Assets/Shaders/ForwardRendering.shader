Shader "Custom/ForwardRendering" { 
    Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		//首先定义第一个Pass:Base Pass。为此需要设立该pass的渲染路径标签
		Pass {
			// 该Pass中计算环境光和最重要的平行光（该平行光以逐像素方式处理）
			Tags { "LightMode"="ForwardBase" }
		    
			CGPROGRAM
			//不可缺少的编译指令
			#pragma multi_compile_fwdbase	//保证在Shaderb中使用光照衰减等光照变量可以被正确赋值
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};
            v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {				
				//环境光的计算只有一次，自发光也是
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//处理平行光，若场景中包含多个平行光，则Unity会选择最亮的平行光传递给Base Pass进行逐像素处理
				//其他平行光会按照逐顶点或者在Additional Pass中按逐像素方式处理
				//如果场景中没有平行光，则Base Pass会当成全黑的光源处理
				//对于Base Pass来说，其处理的逐像素光源一定是平行光
				fixed3 worldNormal = normalize(i.worldNormal);
				//使用_WorldSpaceLightPos0可以得到该平行光的方向
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//使用_LightColor0可以得到该平行光的颜色和强度
			 	fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));

			 	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
			 	fixed3 halfDir = normalize(worldLightDir + viewDir);
			 	fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                //由于平行光没有衰减，直接设定衰减值为1.0
				fixed atten = 1.0;
				
				return fixed4(ambient + (diffuse + specular) * atten, 1.0);
			}
			
			ENDCG
		}
        Pass {
			//Additional Pass 首先设定渲染路径标签,该Pass中处理的光源类型为平行光，点光源或是聚光灯光源。
			Tags { "LightMode"="ForwardAdd" }
			//使用blend开启和设置混合模式，以便additional pass中得到的光照结果可以和帧缓存之中的光照结果相叠加，不开启则意味着结果的覆盖
			Blend One One //Blend还有许多其他的混合系数，比如Blend SrcAlpha One
		
			CGPROGRAM
			
			// 使用必不可少的Additional Pass的编译指令
			#pragma multi_compile_fwdadd
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};
			
			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				fixed3 worldNormal = normalize(i.worldNormal);
				//方向需要不同光源类型区别对待
				#ifdef USING_DIRECTIONAL_LIGHT
					//平行光的方向由_WorldSpaceLightPos0直接得到
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				#else
					//点光源或是聚光灯则是用_WorldSpaceLightPos0减去世界空间下的顶点位置
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
				#endif
				
				// 颜色与强度仍使用_LightColor0来得到
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));
				
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
				//衰减也是区分不同光源来处理
				#ifdef USING_DIRECTIONAL_LIGHT
					fixed atten = 1.0;
				#else
					#if defined (POINT)
				        float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
				        //为避免计算量较大的公式定义计算，Unity提供纹理查找表（Lookup Table,LUT）以在片元着色器中得到光源的衰减
				        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				    #elif defined (SPOT)
				    	//比如聚光灯光源的计算，首先得到光源空间下的坐标lightCoord
				        float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
				        //然后使用该坐标对衰减纹理进行采样得到衰减值
				        fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				    #else
				        fixed atten = 1.0;
				    #endif
				#endif

				return fixed4((diffuse + specular) * atten, 1.0);
			}
			
			ENDCG
		}
	}
	FallBack "Specular"
}