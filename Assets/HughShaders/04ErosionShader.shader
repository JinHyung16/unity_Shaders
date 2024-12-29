Shader "HughShaders/04ErosionShader"
{ 
    Properties
    {
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("Operation", Float) = 0

        _MainTexture("Texture", 2D) = "white" {}
        _MaskTexture("Texture", 2D) = "white" {}
        _RevealValue("Reval", float) = 0
        _Feather("Feather", float) = 0

        _ErodeColor("Erode Color", Color) = (1,1,1,1)
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTexture;
            float4 _MainTexture_ST;

            sampler2D _MaskTexture;
            float4 _MaskTextrue_ST;

            float _RevealValue;
            float _Feather;

            float4 _ErodeColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTexture);
                o.uv.zw = TRANSFORM_TEX(v.uv, _MainTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTexture, i.uv.xy);
                fixed4 mask = tex2D(_MaskTexture, i.uv.zw);

                float revealAni = sin(_Time.y * 2) * 0.5 + 0.5;

                //float revealAmount = step(mask.r, _RevealValue);
                //float revealAmount = smoothstep(mask.r - _Feather, mask.r + _Feather, _RevealValue);
                float revealAmountTop = step(mask.r, revealAni + _Feather);
                float revealAmountBottom = step(mask.r, revealAni - _Feather);
                float revealDifference = revealAmountTop - revealAmountBottom;


                float3 finalCol = lerp(col.rgb, _ErodeColor, revealDifference);

                //return fixed4(revealDifference.xxx, 1);
                //return fixed4(finalCol.rgb, col.a * 1);
                return fixed4(finalCol.rgb, col.a * revealAmountTop);
                //return fixed4(finalCol.rgb, col.a * revealAmountBottom);
            }
            ENDCG
        }
    }
}
