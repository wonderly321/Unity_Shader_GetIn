Shader "Custom/SingleTexture" {
    Properties{
        _Specular("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
        //除了已有属性之外，应添加一个名为_MainTex的纹理属性，2D是纹理属性的声明方式，“white”是内置纹理的名字，意为全白
        _MainTex("Main Tex", 2D) = "white"{}
        //wei控制物体的整体色调，还可声明_color属性
        _Color("Color Tint", Color) = (1, 1, 1, 1)
    }
    SubShader{
        Pass {
            //LightMode标签是Pass标签的一种，它用于定义该Pass在Unity的光照流水线的颜色
            Tags{"LightMode" = "ForwardBase"}

            //CGPROGRAM和ENDCG共同包裹最重要的顶点着色器和片元着色器的代码
            CGPROGRAM

            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment frag
 
            fixed4 _Color;
            sampler2D _MainTex;
            fixed4 _Specular;
            float _Gloss;
            //需要为纹理类型的属性声明一个float4类型的变量_MainTex_ST
            //p.s.:Unity中需要使用纹理名_ST的方式来声明某个纹理的属性。ST为缩放(scale)和平移(translation)的缩写
            float4 _MainTex_ST;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                //用TEXCORD0将模型的第一组纹理坐标存储到该变量中
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                //用uv存储纹理坐标,以便在片元着色器中使用该纹理坐标进行纹理采样
                float2 uv : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_WorldToObject, v.vertex).xyz;
                //_MainTex_ST.xy存储的是缩放值，_MainTex_ST.zw存储的是偏移值，这些值可以在材质面板的纹理属性中调节，分别作用于顶点纹理坐标上
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

                return o;
            }

            //通过 scale/bias 属性转换2D UV，其中第一个参数是顶点纹理坐标，第二个是纹理名
            #define TRANSFORM_TEX(tex, name)(tex.xy * name##_ST.xy + name##_ST.zw)


            // 计算每个像素点的颜色值
            fixed4 frag(v2f i) : SV_Target 
            {
                // 计算世界空间下的法线方向和光照方向
                fixed3 worldNormal = normalize(i.worldNormal); 
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                //使用CG的tex2D函数对纹理进行采样，第一个参数是需要被采样的纹理，第二个参数是一个float2类型的纹理坐标，用于返回计算得到的纹素值
                //采样结果* 颜色属性_Color作为材质反射率albedo
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

                // 环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                //漫反射
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir)) ;

                // 视野方向
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                //高光反射
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(worldNormal, halfDir), 0), _Gloss);

                // 最终颜色 = 漫反射 + 环境光 + 高光反射
                return fixed4(diffuse + ambient + specular, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Specular"
}