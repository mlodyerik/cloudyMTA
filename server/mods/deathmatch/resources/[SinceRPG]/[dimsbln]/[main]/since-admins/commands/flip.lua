addCommandHandler('flip', function(player, cmd)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś w pojeździe!') end

    local rx, ry, rz = getElementRotation(vehicle)
    setElementRotation(vehicle, 0, 0, rz)
    exports['since-notifications']:sendNotification(player, 'success', 'Obrócono pojazd!')
end)