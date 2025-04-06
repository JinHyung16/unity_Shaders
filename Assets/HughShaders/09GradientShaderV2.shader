Shader "HughShaders/09GradientShaderV2"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _GradientColor("Gradient Color", Color) = (1, 0, 0, 0)
        [Toggle] _GradientDirection("Gradient Direction (0 = Vertical, 1 = Horizontal)", Float) = 0
        _SmoothstepMin("SmoothStep Min", Range(0.0, 1.0)) = 0
        _SmoothstepMax("SmoothStep Max", Range(0.0, 1.0)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Name "UVGradientAlphaPass"
            Tags { "LightMode"="UniversalForward" }

            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            float4 _GradientColor;
            float4 _BaseColor;

            float _SmoothstepMin;
            float _SmoothstepMax;
            float _GradientDirection;

            struct VertexInput
            {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct FragmentInput
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            FragmentInput vert(VertexInput v)
            {
                FragmentInput o;
                o.position = TransformObjectToHClip(v.position);
                o.uv = v.uv;
                return o;
            }

            float4 frag(FragmentInput i) : SV_Target
            {
                float uvValue = (_GradientDirection == 0) ? i.uv.y : i.uv.x;
                float weight = smoothstep(_SmoothstepMin, _SmoothstepMax, uvValue);
                return lerp(_BaseColor, _GradientColor, weight);
            }
            ENDHLSL
        }
    }
}
