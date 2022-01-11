Shader "Unlit/WavyShader" { // path (not the asset path)
    Properties 
    {
        _WaveHeight("Wave height", Float) = 1
        _WaveLength("Wave length", Float) = 1
        _WaveSpeed("Wave speed", Float) = 1
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
            CGPROGRAM

            // what functions to use for what
            #pragma vertex vert
            #pragma fragment frag

            // bunch of unity utility functions and variables
            #include "UnityCG.cginc"

            // per-vertex input data from the mesh
            struct MeshData
            {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; // clip space vertex position
                float2 uv0 : TEXCOORD2;
            };

            // property variable declaration
            float _WaveHeight;
            float _WaveLength;
            float _WaveSpeed;

            // vertex shader - foreach( vertex )
            Interpolators vert ( MeshData v )
            {
                Interpolators i;

                // modify vertices
                v.vertex.z += cos((v.uv0.x + _Time.y * _WaveSpeed) * _WaveLength * UNITY_PI * 2) * _WaveHeight / 1000;
                
                // transforms from local space to clip space
                i.vertex = UnityObjectToClipPos(v.vertex);

                // pass coordinates to the fragment shader
                i.uv0 = v.uv0;
                return i;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return float4(i.uv0,0,1);
            }
            ENDCG
        }
    }
}