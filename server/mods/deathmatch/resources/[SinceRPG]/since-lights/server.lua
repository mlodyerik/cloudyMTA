-- on vehicle exit toggle off lights

addEventHandler('onVehicleExit', root, function(player, seat)
    if (seat == 0) then
        setVehicleOverrideLights(source, 1)
        triggerClientEvent(player, 'toggleRGBLights', player, source)
    end
end)