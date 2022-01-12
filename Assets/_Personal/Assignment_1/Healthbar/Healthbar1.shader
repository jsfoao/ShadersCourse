Shader "Unlit/Healthbar1"
{
    Properties
    {
        _MaxColor("Max Health Color", Color) = (0,1,0,1)
        _MinColor("Min Health Color", Color) = (1,0,0,1)
        _BgColor("BG Color", Color) = (0,0,0,1)
        _Health ("Health", Range(0,1)) = 0.5
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
            };

            float4 _MaxColor;
            float4 _MinColor;
            float4 _BgColor;
            float _Health;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv0 = v.uv0;
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                float3 healthbarColor = lerp(_MinColor, _MaxColor, _Health);
                float healthbarMask = _Health > i.uv0.x;

                float3 outColor = lerp(_BgColor, healthbarColor, healthbarMask);
                return float4(outColor,0);
            }
            ENDCG
        }
    }
}