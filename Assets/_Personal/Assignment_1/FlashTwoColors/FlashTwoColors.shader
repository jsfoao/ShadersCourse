Shader "Unlit/FlashTwoColors"
{
    Properties
    {
        _ColorA("ColorA", Color) = (1, 1, 1, 1)
        _ColorB("ColorB", Color) = (1, 1, 1, 1)
        _Speed("Speed", Range(0.1,10)) = 1
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
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
            };
            
            float4 _ColorA;
            float4 _ColorB;
            float _Speed;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                if (frac(_Time.y * _Speed) > 0.5f)
                {
                    return _ColorA;
                }
                return _ColorB;
            }
            ENDCG
        }
    }
}