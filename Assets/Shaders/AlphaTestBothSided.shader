Shader "Custom/AlphaTestBothSided"
{
    Properties
    {
        _Color ("Main Tint", Color) = (1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5 
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
        Pass {
            Tags { "LightMode"="ForwardBase" }
            Cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Cutoff;
            struct a2v{
                float4 vertex : POSITION;    // 告诉Unity把模型空间下的顶点坐标填充给vertex属性
                float3 normal : NORMAL;      // 告诉Unity把模型空间下的法线方向填充给normal属性
                float4 texcoord : TEXCOORD0;
            };

            struct v2f{
                float4 pos : SV_POSITION; // 声明用来存储顶点在裁剪空间下的坐标
                float3 worldNormal : TEXCOORD0; 
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };
            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }
            // 计算每个像素点的颜色值
            fixed4 frag(v2f i) : SV_Target {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                
                fixed4 texColor = tex2D(_MainTex,i.uv);

                //Alpha test
                clip(texColor.a - _Cutoff);
                //使用纹理去采样漫反射颜色
                fixed3 albedo = texColor.rgb * _Color.rgb;
                // 环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                //漫反射
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir)) ; // 颜色融合用乘法
        
                // 最终颜色 = 漫反射 + 环境光 + 高光反射
                return fixed4(diffuse + ambient, 1.0); 
            }       
            ENDCG
        }
    }
    FallBack "Transparent/Cutout/VertexLit"
}
