Shader "HughShaders/07BRDFShader"
{ 
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _BaseColor("Color", Color) = (1,1,1,1)
        _Smoothness("Smothness", Range(0,1)) = 0
        _Metalic("Metalic", Range(0,1)) = 0
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            //#include "UnityCG.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
                float2 texcoord1 : TEXCOORD1;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 4);
            };

            float4 _MainTex_ST;
            sampler2D _MainTex;

            float4 _BaseColor;
            float _Smoothness, _Metalic;

            v2f vert (appdata v)
            {
                v2f o;
                o.positionWS = TransformObjectToWorld(v.vertex.xyz);
                o.normalWS = TransformObjectToWorldNormal(v.vertex.xyz);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.positionWS);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.vertex = TransformWorldToHClip(o.positionWS);

                OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapsST, o.lightmapUV);
                OUTPUT_SH(o.normalWS.xyz, o.vertexSH);

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);

                InputData inputData = (InputData)0;
                inputData.positionWS = i.positionWS;
                inputData.normalWS = i.normalWS;
                inputData.viewDirectionWS = i.viewDir;
                inputData.bakedGI = SAMPLE_GI(i.lightmapUV, i.vertexSH, inputData.normalWS);

                SurfaceData surfaceData;
                surfaceData.albedo = _BaseColor;
                surfaceData.specular = 0;
                surfaceData.metallic = _Metalic;
                surfaceData.smoothness = _Smoothness;
                surfaceData.normalTS = 0;
                surfaceData.emission = 0;
                surfaceData.occlusion = 1;
                surfaceData.alpha = 0;
                surfaceData.clearCoatMask = 0;
                surfaceData.clearCoatSmoothness = 0;
                
                return UniversalFragmentPBR(inputData, surfaceData);
            }
            ENDHLSL
        }
    }
}
