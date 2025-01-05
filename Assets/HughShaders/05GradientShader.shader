Shader "HughShaders/05GradientShader"
{ 
    Properties
    {
        _GradientColorOne("Gradient Color One", Color) = (1,1,1,1)
        _GradientColorTwo("Gradient Color Two", Color) = (1,1,1,1)
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD1;
            };

            
            fixed4 _GradientColorOne;
            fixed4 _GradientColorTwo;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                //o.color = float4(v.uv, 0, 1);
                o.color = lerp(_GradientColorOne, _GradientColorTwo, v.uv.x);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // uv.xxx == zero -> one about x-axis
                // uv.yyy == zero -> one about y-axis 
                //fixed4 col = lerp(_GradientColorOne, _GradientColorTwo, i.uv.x);

                return i.color;
            }
            ENDCG
        }
    }
}
