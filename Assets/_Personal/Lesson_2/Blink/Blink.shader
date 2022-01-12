Shader "Unlit/Blink"
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
                float3 vertex : POSITION;
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
                // float t = round(frac(_Speed * _Time.y));                       // x - floor(x), sawtooth wave
                float t = sin(_Speed * _Time.y * UNITY_PI * 2) * 0.5 + 0.5;       // sine wave, harmonic oscillation
                return lerp(_ColorA, _ColorB, t);
            }
            ENDCG
        }
    }
}