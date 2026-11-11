#include "mta-helper.fx"

texture gTexture;
texture maskTexture;

sampler DefaultTextureSampler = sampler_state
{
    Texture = (gTexture0);
};

sampler TextureSampler = sampler_state
{
    Texture = (gTexture);
};

sampler MaskSampler = sampler_state
{
    Texture = (maskTexture);
};

struct VSInput
{
    float3 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float3 WorldPos : TEXCOORD0;
    float2 TexCoord : TEXCOORD1;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.Position = MTACalcScreenPosition(VS.Position);
    PS.Diffuse = VS.Diffuse;
    PS.TexCoord = VS.TexCoord;
    PS.WorldPos = MTACalcWorldPosition( VS.Position );
    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 finalColor = tex2D(TextureSampler, PS.TexCoord);
    float4 defaultColor = tex2D(DefaultTextureSampler, PS.TexCoord);
    float4 maskColor = tex2D(MaskSampler, float2((PS.WorldPos.x+3000)/6000, (-PS.WorldPos.y+3000)/6000));

    finalColor = ((finalColor * (1-maskColor.r)) + (defaultColor * (maskColor.r))) * PS.Diffuse;

    return finalColor;
}

technique complercated
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}