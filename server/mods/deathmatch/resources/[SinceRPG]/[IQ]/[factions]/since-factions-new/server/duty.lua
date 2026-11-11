function isPlayerInDuty(player)
    return getElementData(player, 'player:faction')
end

function startDuty(player, faction)
    if isPlayerInFaction(player, faction) then
        setElementData(player, 'player:faction', faction)
        setElementData(player, 'player:rank', getFactionRank(player, faction))
        setElementData(player, 'player:skinSave', getElementModel(player))
        startDutyTime(player)

        triggerClientEvent(player, 'onClientStartFaction', resourceRoot)
        return true
    else
        exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś zatrudniony w tej frakcji!')
        return false
    end
end

function stopDuty(player)
    if isPlayerInDuty(player) then
        setElementData(player, 'player:faction', nil)
        stopDutyTime(player)
        setElementModel(player, getElementData(player, 'player:skinSave'))
        setElementData(player, 'player:skinSave', nil)
        triggerClientEvent(player, 'onClientStopFaction', resourceRoot)
        
        return true
    else
        exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz aktywnej służby!')
        return false
    end
end