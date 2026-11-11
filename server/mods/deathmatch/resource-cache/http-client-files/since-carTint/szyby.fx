#include "mta-helper.fx"

float tint_level = 0;
float4 tint_color = float4(0, 0, 0, 1); // Default tint color is black

sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};
   
float4 colorize(float4 tex : TEXCOORD0, float4 Position : POSITION, float4 Diffuse : COLOR0) : COLOR0
{	
	float4 output = tex2D(Sampler0, tex);
	output *= Diffuse;
	if(output.a < 0.99) {
		output = lerp(output, tint_color, (tint_level-15)/100);
	}
	return output;
}
 
technique VehTint
{
    pass P0
    {
        PixelShader = compile ps_2_0 colorize();
    }
}