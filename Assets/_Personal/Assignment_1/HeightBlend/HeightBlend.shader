Shader "Unlit/HeightBlend"
{
    Properties
    {
        _TextureA("Texture A", 2D) = "black" {}
        _TextureB("Texture B", 2D) = "white" {}
        _Height("Height", Float) = 0
        _Feather("Feather", Range(0,2)) = 0.5
        _Blend("Blend", Range(0,1)) = 1
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
                float2 uv0 : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 localPos : TEXCOORD2;
            };
            
            sampler2D _TextureA;
            sampler2D _TextureB;
            float _Height;
            float _Feather;
            float _Blend;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.worldPos = mul( UNITY_MATRIX_M, float4( (float3) v.vertex, 1 ) );
                i.localPos = v.vertex;
                i.uv0 = v.uv0;
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                float4 colorA = tex2D(_TextureA, i.uv0);
                float4 colorB = tex2D(_TextureB, i.uv0);
                float4 blendedColor = lerp(colorA, colorB, _Blend);
                
                float t = clamp((i.localPos.y + _Height) * _Feather, 0, 1);
                return lerp(colorA, blendedColor, t);
            }
            ENDCG
        }
    }
}