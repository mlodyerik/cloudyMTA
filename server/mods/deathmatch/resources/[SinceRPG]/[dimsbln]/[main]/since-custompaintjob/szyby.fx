float Time : TIME;
float alpha = 1;

float4 GetColor()
{
    return float4( 0, 0, 0, alpha );
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique tec0
{
    pass P0
    {
        MaterialAmbient = GetColor();
        MaterialDiffuse = GetColor();
        MaterialEmissive = GetColor();
        MaterialSpecular = GetColor();

        AmbientMaterialSource = Material;
        DiffuseMaterialSource = Material;
        EmissiveMaterialSource = Material;
        SpecularMaterialSource = Material;

        ColorOp[0] = SELECTARG1;
        ColorArg1[0] = Diffuse;

        AlphaOp[0] = SELECTARG1;
        AlphaArg1[0] = Diffuse;

        Lighting = true;
		DepthBias = -0.0000;
		AlphaBlendEnable = TRUE;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
    }
}


