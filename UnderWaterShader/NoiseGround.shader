Shader "clat/NoiseGround"
{
    Properties
    {
        _Tess("Tessellation",Range(0,4)) = 4
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
                 float noise = _NoiseScale * snoise(float3(v.vertex.x + _NoiseOffset.x, v.vertex.y + _NoiseOffset.y, v.vertex.z + _NoiseOffset.z) * _NoiseFrequency);
                 v.vertex.y += noise;
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
