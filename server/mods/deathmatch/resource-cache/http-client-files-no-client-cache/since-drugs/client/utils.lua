function createTextures(textures)
    for i,v in pairs(textures) do
        drugs.textures[i] = dxCreateTexture(v, 'argb', false, 'clamp')
    end
end