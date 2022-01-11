Shader "Unlit/BasicShader2" // path (not the asset path)
{
    // input data to this shader (per-material)
    Properties
    {
        _ColorA("ColorA", Color) = (1, 1, 1, 1)
        _ColorB("ColorB", Color) = (1, 1, 1, 1)
        _Bendiness("Bendiness", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags 
        {
            "RenderType"="Opaque"
            "Queue"="Geometry" // render order
        }

        Pass
        {
            // render setup
            // ZTest On
            // ZWrite On
            // Blend x y
            
            CGPROGRAM

            // what functions to use for what
            #pragma vertex vert
            #pragma fragment frag

            // bunch of unity utility functions
            #include "UnityCG.cginc"
            
            // per-vertex input data from the mesh
            struct MeshData
            {
                float4 vertex : POSITION; // vertex position
                float3 normal : NORMAL;
                float4 tangent : TANGENT; // xyz = tangent direction, w = flip sign -1 or 1;
                float4 color : COLOR;
                float2 uv0 : TEXCOORD0; // uv channel 0
                // float2 uv1 : TEXCOORD1; // uv channel 1
                // etc
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; // clip space position

                // arbitrary data we want to send:
                float2 uv : TEXCOORD0;
                // float4 name1 : TEXCOORD1;
                // float4 name2 : TEXTCOORD2;
            };

            // property value declaration
            float4 _ColorA;
            float4 _ColorB;
            float _Bendiness;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;

                // transforms from local space to clip space
                // usually using the matrix called UNITY_MATRIX_MVP
                // model-view-projection matrix (local to clip space)
                i.vertex = UnityObjectToClipPos(v.vertex);

                // pass coordinates to the fragment shader
                i.uv = v.uv0;
                return i;
            }

            // bool 0 1
            // int
            // float (32 bit float)
            // half (16 bit float)
            // fixed (lower precision), usually on -1 to 1 ranges
            // float4 -> half4 -> fixed4
            // float4x4 -> half4x4 (C#: Matrix4x4)
            
            // fragment shader - foreach fragment/pixel
            fixed4 frag (Interpolators i) : SV_Target
            {
                float2 coords = i.uv; // * 2 - float2(1, 1); // centering

                float bentValue = coords.x - coords.y * coords.y + coords.y;
                coords.x = lerp(coords.x, bentValue, _Bendiness);
                // float distToCenter = frac(length(coords) + _Time.y);
                float4 color = lerp(_ColorA, _ColorB, frac(coords.x * 8 + _Time.y));
                return color;
            }
            ENDCG
        }
    }
}