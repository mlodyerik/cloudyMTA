texture gOrigTexure0 : TEXTURE0;
texture gCustomTex0 : CUSTOMTEX0;

technique simple
{
    pass P0
    {
        Lighting = true;
        Texture[0] = gCustomTex0;
    }
}
