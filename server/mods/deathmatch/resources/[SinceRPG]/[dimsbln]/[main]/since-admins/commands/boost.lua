addCommandHandler('boost', function(player, cmd)
    if not getAdmin(player, 3) then return exports['since-notifications']:sendNotification(player, 'error','Nie posiadasz uprawnień do tej komendy!') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znajdujesz się w pojeździe!') end

    local vx, vy, vz = getElementVelocity(vehicle)
    setElementVelocity(vehicle, vx * 1.3, vy * 1.3, vz * 1.3)
    exports['since-notifications']:sendNotification(player, 'info','Pojazd został przyspieszony!')
end)