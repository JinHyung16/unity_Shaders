Shader "HughShaders/06BarShader"
{ 
    Properties
    {
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _Opp("Operation", Float) = 0

        _BarIntensity("Bar Intensity", Float) = 1
        _AnimationIntensity("Animation Intensity", Float) = 0
        
        _Rotator("Rotator", Range(0, 1)) = 1

        _ColorOne("Color One", Color) = (1,1,1,1)
        _ColorTwo("Color Two", Color) = (1,1,1,1)
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_Opp]

        Pass
        {
            Cull Front
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

            float _BarIntensity;
            float _AnimationIntensity;
            float _Rotator;

            float4 _ColorOne;
            float4 _ColorTwo;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float rotator = lerp(i.uv.x, i.uv.y, _Rotator);

                // Sin함수로 파동치듯
                // sin(x * barIntenstiy + a) + 0.5 * 0.5
                // * 0.5 + 0.5로 모든 값 양수로
                // a로 좌우 애니메이션
                float a = _AnimationIntensity * _Time.y;
                float barEffect = sin(rotator * _BarIntensity + a) * 0.5 + 0.5;

                float4 mixedColor = lerp(_ColorOne, _ColorTwo, rotator) * barEffect;
                
                return fixed4(mixedColor.rgb, barEffect * mixedColor.a);
                //return fixed4(mixedColor, 1);
            }
            ENDCG
        }

        Pass
        {
            Cull Back
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

            float _BarIntensity;
            float _AnimationIntensity;
            float _Rotator;

            float4 _ColorOne;
            float4 _ColorTwo;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float rotator = lerp(i.uv.x, i.uv.y, _Rotator);

                // Sin함수로 파동치듯
                // sin(x * barIntenstiy + a) + 0.5 * 0.5
                // * 0.5 + 0.5로 모든 값 양수로
                // a로 좌우 애니메이션
                float a = _AnimationIntensity * _Time.y;
                float barEffect = sin(rotator * _BarIntensity + a) * 0.5 + 0.5;

                float4 mixedColor = lerp(_ColorOne, _ColorTwo, rotator) * barEffect;
                
                return fixed4(mixedColor.rgb, barEffect * mixedColor.a);
                //return fixed4(mixedColor, 1);
            }
            ENDCG
        }
    }
}
