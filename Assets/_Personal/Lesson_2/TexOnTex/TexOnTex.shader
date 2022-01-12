Shader "Unlit/TexOnTex"
{
    Properties
    {
        _TextureA("Texture A", 2D) = "black" {}
        _TextureB("Texture B", 2D) = "white" {}
        _Blend("Blend", Range(0,1)) = 1
        _FadeStart("Fade Start", Range(0,1)) = 1
        _FadeEnd("Fade End", Range(0,1)) = 0
    }
    
    SubShader
    {
        Tags 
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct MeshData
            {
                float3 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 localPos : TEXCOORD2;
                float3 normal : TEXCOORD3;
            };
            
            sampler2D _TextureA;
            sampler2D _TextureB;
            float _Blend;
            float _FadeStart;
            float _FadeEnd;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv0;
                i.localPos = v.vertex;
                i.normal = UnityObjectToWorldNormal(v.normal);
                return i;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                float4 baseColor = tex2D(_TextureA, i.uv);
                float4 topColor = tex2D(_TextureB, i.uv);
                float4 blendedColor = lerp(baseColor, topColor, _Blend);
                
                float t = InverseLerp(_FadeStart, _FadeEnd, i.normal.y);
                t = saturate(t);

                return lerp(baseColor, blendedColor, t);
            }
            ENDCG
        }
    }
}