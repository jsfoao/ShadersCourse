Shader "Unlit/LightingTest"
{
    Properties
    {
        _Texture("Texture", 2D) = "black" {}
        _NormalMap("Normals", 2D) = "bump" {}
        _LightColor("Light Color", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(0,1)) = 1
    }
    
    SubShader
    {
        Tags 
        {
            "LightMode"="ForwardBase"
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
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
                float3 tangent : TEXCOORD3;
                float3 bitangent : TEXCOORD4;
            };
            
            sampler2D _Texture;
            sampler2D _NormalMap;
            float4 _LightColor;
            float _Gloss;
            
            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);

                // setting up tangent space
                i.normal = UnityObjectToWorldNormal(v.normal);
                i.tangent = UnityObjectToWorldDir(v.tangent.xyz);
                float flipSign = v.tangent.w * unity_WorldTransformParams.w;
                i.bitangent = cross(i.normal, i.tangent) * flipSign;
                
                i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex, 1)); // local to world
                i.uv = v.uv0;
                return i;
            }

            float Lambert(float3 n, float3 l)
            {
                return saturate(dot(n, l));
            }

            float BlinnPhong(float3 n, float3 l, float3 v, float specExp)
            {
                float3 h = normalize(l + v);
                return pow(max(0, dot(h,n)), specExp);
            }

            float4 ApplyLighting(float3 surfColor, float3 n, float3 worldPos, float gloss)
            {
                float3 lightDir = UnityWorldSpaceLightDir(worldPos);
                float3 lightColor = _LightColor;

                // diffuse lighting
                float3 diffuse = Lambert(n, lightDir) * lightColor;
                
                // specular lighting
                float3 v = normalize(_WorldSpaceCameraPos - worldPos); // direction to camera (view vector)
                float specExp = exp2(1 + gloss * 12);
                float specular = BlinnPhong(n,lightDir, v, specExp) * lightColor;
                return float4(surfColor * diffuse + specular,1);
            }
            
            float4 frag (Interpolators i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 surfaceColor = tex2D(_Texture, i.uv);
                float3 tsNormal = UnpackNormal(tex2D(_NormalMap, i.uv));

                float3x3 mtxWorldToTang = float3x3(i.tangent, i.bitangent, i.normal);
                float3x3 mtxTangToWorld = transpose(mtxWorldToTang);
                float3 n = mul(mtxTangToWorld, tsNormal);
                
                return ApplyLighting(surfaceColor, n, i.worldPos, _Gloss);
            }
            ENDCG
        }
    }
}