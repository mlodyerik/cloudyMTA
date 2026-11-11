texture Tex0;

float4x4 World;
float4x4 View;
float4x4 Projection;
float4x4 WorldViewProjection;

//---------------------------------------------------------------------
//-- Sampler for the main texture (needed for pixel shaders)
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (Tex0);
};

//---------------------------------------------------------------------
//-- Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION;
    float2 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
//-- Structure of data sent to the pixel shader (from the vertex shader)
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

//----------------------------------------------------------------------------- 
//-- VertexShaderExample 
//----------------------------------------------------------------------------- 
PSInput VertexShaderExample(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = mul(float4(VS.Position, 1), WorldViewProjection);

    // PS.TexCoord.x = PS.Position.x * 0.5f + 0.5f;
    // PS.TexCoord.y = -PS.Position.y * 0.5f + 0.5f;

    // make sure that the texture is on full screen without infinity scaling
    PS.TexCoord.x = (PS.Position.x / PS.Position.w) * 0.5f + 0.5f;
    PS.TexCoord.y = (-PS.Position.y / PS.Position.w) * 0.5f + 0.5f;

    return PS;
}

//----------------------------------------------------------------------------- 
//-- PixelShaderExample 
//----------------------------------------------------------------------------- 
float4 PixelShaderExample(PSInput PS) : COLOR0
{
    // Grab the pixel from the texture using screen-space texture coordinates
    float4 finalColor = tex2D(Sampler0, PS.TexCoord);

    return finalColor;
}

//----------------------------------------------------------------------------- 
//-- Techniques 
//----------------------------------------------------------------------------- 
technique SpaceTextureProjection
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderExample();
        PixelShader  = compile ps_2_0 PixelShaderExample();
    }
}
