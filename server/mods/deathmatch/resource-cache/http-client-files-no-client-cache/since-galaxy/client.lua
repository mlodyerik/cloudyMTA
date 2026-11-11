local shaders = {}
local textures = {}

function applyGalaxyShader(vehicle)
    if not isElement(vehicle) then return end

    local upgrades = getElementData(vehicle, "vehicle:upgrades") or {}

    if (upgrades["galaxy"]) then
        local shader = dxCreateShader("data/fx/shader.fx")

        if (not textures[upgrades["galaxy"]]) then
            textures[upgrades["galaxy"]] = dxCreateTexture('data/images/'..upgrades["galaxy"]..'.png')
        end
        
        if (shader and textures[upgrades["galaxy"]]) then
            dxSetShaderValue(shader, "Tex0", textures[upgrades["galaxy"]])
            for _, textureName in ipairs({"vehiclegrunge256", "vehicle_detail", "vehicle_generic256", "#emapelegybody128", "#emapsultanbody256"}) do
                engineApplyShaderToWorldTexture(shader, textureName, vehicle)
            end

            shaders[vehicle] = shader
        end
    end
end

function removeGalaxyShader(vehicle)
    if (isElement(vehicle) and shaders[vehicle]) then
        for _, textureName in ipairs({"vehiclegrunge256", "vehicle_detail", "vehicle_generic256", "#emapelegybody128", "#emapsultanbody256"}) do
            engineRemoveShaderFromWorldTexture(shaders[vehicle], textureName, vehicle)
        end
        destroyElement(shaders[vehicle])
        shaders[vehicle] = nil
    end
end

addEventHandler('onClientElementStreamIn', root, function()
    if getElementType(source) == 'vehicle' then
        applyGalaxyShader(source)
    end
end)

addEventHandler('onClientElementStreamOut', root, function()
    if getElementType(source) == 'vehicle' then
        removeGalaxyShader(source)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    for _, vehicle in ipairs(getElementsByType('vehicle')) do
        applyGalaxyShader(vehicle)
    end
end)

addEventHandler('onClientElementDataChange', root, function(dataName)
    if (getElementType(source) == 'vehicle' and dataName == 'vehicle:upgrades') then
        removeGalaxyShader(source)
        applyGalaxyShader(source)
    end
end)