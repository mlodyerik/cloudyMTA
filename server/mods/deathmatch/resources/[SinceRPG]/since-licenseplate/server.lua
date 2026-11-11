addEvent('changeLicensePlate', true)
addEventHandler('changeLicensePlate', resourceRoot, function(vehicleID, plate)
    if not plate then
        return
    end

    if not vehicleID then
        return
    end

    if getPlayerMoney(client) < 45000 then
        return
    end

    takePlayerMoney(client, 45000)
    exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zmieniono tablicę rejestracyjną pojazdu ID: ' .. vehicleID .. ' na ' .. plate .. ' za $ 45 000.')

    exports['since-db']:query('UPDATE `since-vehicles` SET licenseplate = ? WHERE id = ?', plate, vehicleID)

    for i, vehicle in ipairs(getElementsByType('vehicle')) do
        if getElementData(vehicle, 'vehicle:id') == vehicleID then
            setVehiclePlateText(vehicle, plate)
            break
        end
    end
end)

addEvent('returnUserVehicles', true)
addEventHandler('returnUserVehicles', resourceRoot, function()
    if client then
        local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE owner = ?', getElementData(client, 'player:sid'))

        if #result > 0 then
            triggerClientEvent(client, 'returnUserVehicles', resourceRoot, result)
        end
    end
end)