local tick = {}

function reset(vehicle)
    if tick[vehicle] then
        if isTimer(tick[vehicle]) then
            killTimer(tick[vehicle])
        end
        tick[vehicle] = nil
    end
end

--[[
addEventHandler('onClientElementStreamIn', root, function()
    if getElementType(source) == 'vehicle' then
        if tick[source] then return end
        tick[source] = setTimer(reset, 1000, 1, source)
        local var = getElementData(source, 'vehicle:variant')
        if var then
            local actualVariant = {getVehicleVariant(source)}
            if actualVariant[1] ~= var[1] or actualVariant[2] ~= var[2] then
                setVehicleVariant(source, var[1] or 0, var[2] or 0)
            end
        end
    end
end)
]]

addEventHandler('onClientElementDataChange', root, function(key, oldValue)
    if getElementType(source) == 'vehicle' and key == 'vehicle:variant' then
        local var = getElementData(source, 'vehicle:variant')
        if var then
            local actualVariant = {getVehicleVariant(source)}
            if actualVariant[1] ~= var[1] or actualVariant[2] ~= var[2] then
                setVehicleVariant(source, var[1] or 0, var[2] or 0)
            end
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    for _, vehicle in ipairs(getElementsByType('vehicle', root, true)) do
        local var = getElementData(vehicle, 'vehicle:variant')
        if var then
            local actualVariant = {getVehicleVariant(vehicle)}
            if actualVariant[1] ~= var[1] or actualVariant[2] ~= var[2] then
                setVehicleVariant(vehicle, var[1] or 0, var[2] or 0)
            end
        end
    end
end)