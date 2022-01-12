Shader "Unlit/TestShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
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
            
            float4 _Color;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}