--[[
    Author: EnoNeK
    For: cloudyMTA
]]

addEvent("enonek-custom_sultan:setHandling", true)
addEventHandler("enonek-custom_sultan:setHandling", resourceRoot, function(vehicle, handling)
    for i,v in pairs(handling) do
        setVehicleHandling(vehicle, i, v)
    end
end)