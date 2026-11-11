addCommandHandler('inv', function(player, cmd)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    if getElementAlpha(player) == 255 then
        setElementAlpha(player, 0)
        setElementData(player, 'player:inv', true)
    else
        setElementAlpha(player, 255)
        setElementData(player, 'player:inv', nil)
    end
    exports['since-notifications']:sendNotification(player, 'success', 'Zmieniono widzialność!')
end)

addCommandHandler('invveh', function(player, cmd)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local veh = getPedOccupiedVehicle(player)

    if not veh then
        return
    end

    if getElementAlpha(veh) == 255 then
        setElementAlpha(veh, 0)
    else
        setElementAlpha(veh, 255)
    end

    exports['since-notifications']:sendNotification(player, 'success', 'Zmieniono widzialność pojazdu!')
end)