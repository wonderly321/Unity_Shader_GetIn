// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/DiffuseVertexLevel"{//逐顶点漫反射
    Properties{
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1) //可在编辑器面板定义材质自身色彩
    }
    SubShader{
        Pass{
            Tags { "LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Diffuse;
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f{
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };
            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //漫反射颜色 = 直射光颜色 * max(0, cos(光源方向和法线方向夹角)) * 材质自身颜色
                //其中 max(0, cos(光源方向和法线方向夹角))部分可以改用半兰伯特光照模型以增强背光面的光照效果
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                o.color = ambient + diffuse;
                return o;
            }
            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }           
            ENDCG
        }
    }
    Fallback "Diffuse"
}
