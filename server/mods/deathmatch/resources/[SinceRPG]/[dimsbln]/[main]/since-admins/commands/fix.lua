addCommandHandler('fix', function(player, cmd, cel)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    if not cel then
        local vehicle = getPedOccupiedVehicle(player)
        if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś w pojeździe!') end

        fixVehicle(vehicle)
        exports['since-notifications']:sendNotification(player, 'success', 'Naprawiono pojazd!')
    else
        local cel = exports['since-core']:findPlayer(player, cel)
        if not cel then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza o podanym ID!') end

        local vehicle = getPedOccupiedVehicle(cel)
        if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Gracz nie jest w pojeździe!') end

        fixVehicle(vehicle)
        exports['since-notifications']:sendNotification(player, 'success', 'Naprawiono pojazd gracza '..getPlayerName(cel)..'!')
        exports['since-notifications']:sendNotification(cel, 'success', 'Administrator '..getPlayerName(player)..' naprawia Twój pojazd.')
    end
end)

addCommandHandler('fix.all', function(player, cmd)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    for i, v in ipairs(getElementsByType('vehicle')) do
        fixVehicle(v)
    end

    for i, v in ipairs(getElementsByType('player')) do
        exports['since-notifications']:sendNotification(v, 'success', 'Administrator '..getPlayerName(player)..' naprawia każdy pojazd na mapie.')
    end
end)