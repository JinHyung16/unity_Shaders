Shader "HughShaders/03BlendShader"
{ 
    Properties
    {
        _MainTexture("Base Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("Operation", Float) = 0
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]

        //Blend One One
        //Blend SrcAlpha OneMinusSrcAlpha
        // blend formula
        // source = whatever this shader outputs
        // destination = whatever is in the Background

        // sorce * fsource + destination * fdestination
        // SrcAplha = fsource, fdestination = OneMinusSrcAlpha
        // fdestination = 1 - fsource

        // Additive
        // source * fsource + destination * fdestination

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
            };

            sampler2D _MainTexture;
            float4 _MainTexture_ST;

            float4 _Color;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uvs = i.uv;
                fixed4 textureColor = tex2D(_MainTexture, uvs);
                return textureColor;
                // return _Color;
            }
            ENDCG
        }
    }
}
