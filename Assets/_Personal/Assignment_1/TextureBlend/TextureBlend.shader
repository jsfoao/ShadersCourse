Shader "Unlit/TextureBlend"
{
    Properties
    {
        _TextureA("Texture A", 2D) = "black" {}
        _TextureB("Texture B", 2D) = "white" {}
        _Blend("Blend", Range(0,1)) = 0.5
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
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXTCOORD0;
                float3 worldPos : TEXTCOORD1;
            };
            
            sampler2D _TextureA;
            sampler2D _TextureB;
            float _Blend;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.worldPos = mul( UNITY_MATRIX_M, float4( v.vertex, 1 ) );
                i.uv0 = v.uv0;
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                float4 colorA = tex2D(_TextureA, i.uv0);
                float4 colorB = tex2D(_TextureB, i.uv0);

                return lerp(colorA, colorB, _Blend);
            }
            ENDCG
        }
    }
}