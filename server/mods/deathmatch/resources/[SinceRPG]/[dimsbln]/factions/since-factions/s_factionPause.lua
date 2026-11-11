addCommandHandler('s2', function(player)
    if not getElementData(player, 'player:faction') then
        return
    end

    if not getElementData(player, 'player:factionPause') then
        setElementData(player, 'player:factionPause', true)
        stopDutyTimer(player)

        exports['since-notifications']:sendNotification(player, 'success', 'Rozpoczynasz przerwę, aby zakończyć wpisz /s3')
    else
        exports['since-notifications']:sendNotification(player, 'error', 'Jesteś na przerwie, aby zakończyć wpisz /s3')
    end
end)

addCommandHandler('s3', function(player)
    if not getElementData(player, 'player:faction') then
        return
    end
    
    if getElementData(player, 'player:factionPause') then
        setElementData(player, 'player:factionPause', false)
        startDutyTimer(player)

        exports['since-notifications']:sendNotification(player, 'success', 'Kończysz przerwę, aby rozpocząć ponownie wpisz /s2')
    else
        exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś na przerwie, aby rozpocząć przerwę wpisz /s2')
    end
end)