Shader "HughShaders/08VertexDisplacementShade"
{ 
    // Plane 3D Object로 보기
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;

                float xMod = tex2Dlod(_MainTex, float4(o.uv.xy, 0, 1));
                xMod *= 2 - 1;
                o.uv.x = sin(xMod * 10 - _Time.y);

                float3 vert = v.vertex;
                vert.z = o.uv.x * 10;
                o.uv.x = o.uv.x * 0.5 + 0.5;

                o.vertex = UnityObjectToClipPos(vert);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.uv.x,0,0,1);
            }
            ENDCG
        }
    }
}
