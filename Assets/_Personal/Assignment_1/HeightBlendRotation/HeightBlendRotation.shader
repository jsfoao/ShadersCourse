Shader "Unlit/HeighBlendRotation"
{
    Properties
    {
        _TextureA("Texture A", 2D) = "black" {}
        _TextureB("Texture B", 2D) = "white" {}
        _Height("Height", Float) = 0
        _Feather("Feather", Range(0,20)) = 0.5
        _Blend("Blend", Range(0,1)) = 1
        
        _ColorFog("Fog Color", Color) = (0,0,0,0)
        _HeightFog("Fog Height", Float) = 0
        _BlendFog("Fog Blend", Range(0,1)) = 1
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
                float3 worldSpaceOrigin : TEXCOORD2;
            };
            
            sampler2D _TextureA;
            sampler2D _TextureB;
            float _Height;
            float _Feather;
            float _Blend;

            float4 _ColorFog;
            float _HeightFog;
            float _BlendFog;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.worldPos = mul(UNITY_MATRIX_M,float4((float3)v.vertex, 1));
                i.worldSpaceOrigin = mul(UNITY_MATRIX_M, float4(0,0,0,1)).xyz;
                i.uv0 = v.uv0;
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                float4 colorA = tex2D(_TextureA, i.uv0);
                float4 colorB = tex2D(_TextureB, i.uv0);
                float4 blendedColor = lerp(colorA, colorB, _Blend);
                
                float yDistance = i.worldPos.y - i.worldSpaceOrigin.y;
                float t = saturate((yDistance + _Height) * _Feather);
                float4 finalColor = lerp(colorA, blendedColor, t);

                float camDistance = distance(_WorldSpaceCameraPos, i.worldPos);
                _ColorFog = _ColorFog * clamp(camDistance, 0, 10);
                float4 blendedFog = lerp(finalColor, _ColorFog, _BlendFog);
                return lerp(blendedFog, finalColor , saturate(i.worldPos.y - _HeightFog));
            }
            ENDCG
        }
    }
}