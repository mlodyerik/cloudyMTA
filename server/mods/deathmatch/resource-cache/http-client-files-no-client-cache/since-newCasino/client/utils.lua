function Casino.CreateTextures(c)
    for i,v in pairs(c) do
        Casino.textures[i] = dxCreateTexture(v, 'argb', false, 'clamp')
    end
end