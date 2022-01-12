Shader "Unlit/BasicShader3" // path (not the asset path)
{
    // input data to this shader (per-material)
    Properties{}
    SubShader
    {
        Tags 
        {
            "RenderType"="Opaque"
            "Queue"="Geometry" // render order
        }

        Pass
        {

            CGPROGRAM

            // what functions to use for what
            #pragma vertex vert
            #pragma fragment frag

            // bunch of unity utility functions
            #include "UnityCG.cginc"
            
            // per-vertex input data from the mesh
            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.worldNormal = UnityObjectToWorldNormal(v.normal);
                i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex));
                return i;
            }
            
            // fragment shader - foreach fragment/pixel
            fixed4 frag (Interpolators i) : SV_Target
            {
                return float4 (i.worldPos, 1);
            }
            ENDCG
        }
    }
}