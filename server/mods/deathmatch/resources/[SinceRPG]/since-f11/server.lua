addEvent('switchGPS', true)
addEventHandler('switchGPS', resourceRoot, function(x, y)
    local vehicle = getPedOccupiedVehicle(client)

    if not vehicle then return end
    
    local vehicleController = getVehicleController(vehicle)

    if vehicleController == client or not vehicleController then
        return
    end

    triggerClientEvent(vehicleController, 'switchGPS', resourceRoot, client, x, y)
end)