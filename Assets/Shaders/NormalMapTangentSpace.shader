Shader "Custom/NormalMapTangentSpace"{
    Properties{
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
        
        //增加法线纹理属性，以及用于控制凹凸程度的属性，“bump”是Unity内置的法线纹理，_BumpScale为0时，表示法线纹理不会对光照产生影响
        _BumpMap ("Normal Map", 2D) = "Bump" {}
        _BumpScale ("Bump Scale", Float) = 1.0     
    }
    SubShader{
        Pass{
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;          
            fixed4 _Specular;
            float _Gloss;   
            
            //在CG代码块中声明和上述属性类型匹配的变量
            //为得到该纹理的属性(平铺和偏移系数)，定义_MainTex_ST和_BumpMap_ST变量
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                //使用TANGENT语义描述float4类型的tangent变量，以告诉Unity把顶点的切线方向填充到tangent变量
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
                //同理，添加两个变量存储变换后的光照和视角方向
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };
            v2f vert (a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                //由于使用了两张纹理故xy分量存储_MainTex的纹理坐标，而zw分量存储_BumpMap的纹理坐标
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                
                //Unity提供的内置函数，用来得到旋转变换矩阵
                TANGENT_SPACE_ROTATION;
                
                //用Unity内置函数得到模型空间下的光照和视角方向，再利用变换矩阵rotation把它们从模型空间变换到切线空间
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target 
            {
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);
                
                //利用tex2D对法线纹理进行采样
                fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                //然后映射逆运算得到实际的法线分量
                fixed3 tangentNormal;
                tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *= _BumpScale;
                //z分量由xy推导而得
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

                //使用纹理去采样漫反射颜色
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                // 环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                // 漫反射 
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir)) ;
                // 视野方向
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                // 高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(tangentNormal, halfDir), 0), _Gloss);
                // 最终颜色 = 漫反射 + 环境光 + 高光反射
                return fixed4(diffuse + ambient + specular, 1.0); 
            }

            ENDCG
        }
    }
    Fallback "Specular"  
}