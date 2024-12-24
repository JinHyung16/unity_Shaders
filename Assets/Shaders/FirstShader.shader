Shader "HughShader/FirstShader"
{
    Properties
    {
        _Color("Test Color", color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert // Runs on every vert
            #pragma fragment frag // Runs on every single pixel


            #include "UnityCG.cginc"

            struct appdata // Object Data or Mesh
            {
                float4 vertex : POSITION;
            };

            struct v2f // Vertex to frag, passa data from the vert shader to fragment
            {
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // Model Vier Projection
                return o;
            }

            fixed4 _Color;
            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = 1; // == fiex4(1,1,1,1) meaning white
                fixed4 col = _Color;
                return col;
            }
            ENDCG
        }
    }
}
