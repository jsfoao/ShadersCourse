Shader "Unlit/TransparentTest"
{
    Properties
    {
        _Texture("Texture", 2D) = "black" {}
        _Color("Color", Color) = (1,1,1,1)
    }
    
    SubShader
    {
        Tags 
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"   // draw order in render pipeline
        }

        Pass
        {

            Cull Off    // don't cull front or back (double-sided rendering)
            ZWrite Off  // turn off writing to the depth buffer
            Blend SrcAlpha OneMinusSrcAlpha // alpha blending
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct MeshData
            {
                float3 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _Color;
            sampler2D _Texture;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv0;
                return i;
            }
            
            fixed4 frag (Interpolators i) : SV_Target
            {
                float4 baseColor = tex2D(_Texture, i.uv);
                return baseColor;
            }
            ENDCG
        }
    }
}