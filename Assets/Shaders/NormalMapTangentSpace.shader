Shader "Custom/NormalMapTangentSpace"{
    Properties{
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "Bump" {}
        _BumpScale ("Bump Scale", Float) = 1.0
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
    }
    SubShader{
        Pass{
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };
            v2f vert (a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // UNITY_MATRIX_MVP是内置矩阵。该步骤用来把一个坐标从模型空间转换到剪裁空间
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                TANGENT_SPACE_ROTATION;
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

                return o;
            }
            fixed4 frag(v2f i) : SV_Target 
            {
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);
                fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                fixed3 tangentNormal;
                tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

                //使用纹理去采样漫反射颜色
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                // 环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                /*
                 * 漫反射Diffuse = 直射光颜色 * max(0, cos(光源方向和法线方向夹角)) * 材质自身色彩
                 */
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir)) ; // 颜色融合用乘法
                // 视野方向
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                /*
                 * 高光反射Specular = 直射光 * pow(max(0, cos(反射光方向和视野方向的夹角)), 高光反射参数)
                 */
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(tangentNormal, halfDir), 0), _Gloss);

                // 最终颜色 = 漫反射 + 环境光 + 高光反射
                return fixed4(diffuse + ambient + specular, 1.0); // f.color是float3已经包含了三个数值
            }

            ENDCG
        }
    }
    Fallback "Specular"  
}
