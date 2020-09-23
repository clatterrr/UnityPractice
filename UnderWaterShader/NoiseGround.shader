Shader "clat/NoiseGround"
{
    Properties
    {
        _Tess("Tessellation",Range(0,16)) = 4
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("Albedo(RGB)",2D) = "white"{}
        _Glossiness("smoothness",Range(0,1)) = 0.5
        _Metallic("Metallic",Range(0,1)) = 0.0
        _NoiseScale("Noise Scale",float) = 1
        _NoiseFrequency("Noise frequency",float) = 1
        _NoiseOffset("Noise Offset",Vector) = (0,0,0,0)
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }


            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows tessellate:tess vertex:vert
            #pragma target 4.6

            #include "noiseSimplex.cginc"

            struct appdate
           {
                   float4 vertex : POSITION;
                   float3 normal : NORMAL;
                   float2 texcoord : TEXCOORD0;
            };

             struct Input
             {
                       float2 uv_MainTex;
             };
               
             sampler2D _MainTex;
             float _Tess;
             half _Glossiness;
             half _Metallic;
             fixed4 _Color;

             float _NoiseScale, _NoiseFrequency;
             float4 _NoiseOffset;



             float4 tess()
             {
                 return _Tess;
             }
             
             void vert(inout appdate v)
             {
                 float3 v0 = v.vertex.xyz;
                 float3 v1 = v0 + float3(0.01, 0, 0);
                 float3 v2 = v0 + float3(0, 0, 0.01);

                 float ns0 = _NoiseScale * snoise(float3(v0.x + _NoiseOffset.x, v0.y + _NoiseOffset.y, v0.z + _NoiseOffset.z) * _NoiseFrequency);
                 v0.xyz += ((ns0 + 1) / 2) * v.normal;

                 float ns1 = _NoiseScale * snoise(float3(v1.x + _NoiseOffset.x, v1.y + _NoiseOffset.y, v1.z + _NoiseOffset.z) * _NoiseFrequency);
                 v1.xyz += ((ns1 + 1) / 2) * v.normal;

                 float ns2 = _NoiseScale * snoise(float3(v2.x + _NoiseOffset.x, v2.y + _NoiseOffset.y, v2.z + _NoiseOffset.z) * _NoiseFrequency);
                 v2.xyz += ((ns2 + 1) / 2) * v.normal;

                 float vn = cross(v2 - v0, v1 - v0);
                 v.normal = normalize(vn);
                 v.vertex.xyz = v0;
             }

             void surf(Input IN, inout SurfaceOutputStandard o)
             {
                 fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                 o.Albedo = c.rgb;
                 o.Metallic = _Metallic;
                 o.Smoothness = _Glossiness;
             }
            ENDCG
        }
        FallBack "Diffuse"
    
}
