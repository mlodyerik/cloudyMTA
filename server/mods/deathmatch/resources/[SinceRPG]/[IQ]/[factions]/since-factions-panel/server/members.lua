function isPlayerHavePermission(player)
    local faction = getElementData(player, 'player:faction')

    if (not faction) then return false end

    local rank = getElementData(player, 'player:rank')

    if (not rank) then return false end

    local factionData = exports['since-factions-new']:getFactionData(faction)

    if (not factionData.ranks[rank]) then return false end

    local last2Ranks = {factionData.ranks[#factionData.ranks], factionData.ranks[#factionData.ranks - 1]}
    
    if (factionData.ranks[rank] ~= last2Ranks[1] and factionData.ranks[rank] ~= last2Ranks[2]) then
        return false
    end

    return true
end

local function getPlayerFactionByUID(uid)
    local rows = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid = ?', uid)

    if (not rows[1]) then return false end

    return rows[1]
end

addEvent('since-factions-panel:onPlayerDemote', true)
addEventHandler('since-factions-panel:onPlayerDemote', resourceRoot, function (targetUID)
    local player = client

    if (not isElement(player)) then return end

    if (not getElementData(player, 'player:faction')) then return end

    if (not isPlayerHavePermission(player)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej akcji.')
    end

    local target = getPlayerFactionByUID(targetUID)

    if (not target) then return end

    if (not canDemote(player, target)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz degradować tej osoby.')
    end
    
    if (target.rank == #exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction')).ranks) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz degradować tej osoby.')
    end

    demote(player, target)
    updateFactionData(player)

    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie zdegradowano gracza.')

    if (findPlayerByUID(target.uid)) then
        exports['since-notifications']:sendNotification(findPlayerByUID(target.uid), 'error', 'Zostałeś zdegradowany we frakcji.')

        if (getElementData(findPlayerByUID(target.uid), 'player:faction')) then
            setElementData(findPlayerByUID(target.uid), 'player:rank', target.rank - 1)
        end
    end
end)

addEvent('since-factions-panel:onPlayerPromote', true)
addEventHandler('since-factions-panel:onPlayerPromote', resourceRoot, function (targetUID)
    local player = client

    if (not isElement(player)) then return end

    if (not getElementData(player, 'player:faction')) then return end

    if (not isPlayerHavePermission(player)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej akcji.')
    end

    local target = getPlayerFactionByUID(targetUID)

    if (not target) then return end

    if (not canPromote(player, target)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz awansować tej osoby.')
    end

    promote(player, target)
    updateFactionData(player)

    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie awansowano gracza.')

    if (findPlayerByUID(target.uid)) then
        exports['since-notifications']:sendNotification(findPlayerByUID(target.uid), 'success', 'Zostałeś awansowany we frakcji.')

        if (getElementData(findPlayerByUID(target.uid), 'player:faction')) then
            setElementData(findPlayerByUID(target.uid), 'player:rank', target.rank + 1)
        end
    end
end)

addEvent('since-factions-panel:onPlayerKick', true)
addEventHandler('since-factions-panel:onPlayerKick', resourceRoot, function (targetUID)
    local player = client

    if (not isElement(player)) then return end

    if (not getElementData(player, 'player:faction')) then return end

    if (not isPlayerHavePermission(player)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej akcji.')
    end

    local target = getPlayerFactionByUID(targetUID)

    if (not target) then return end

    if (target.rank == #exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction')).ranks) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyrzucić tej osoby.')
    end

    exports['since-db']:query('DELETE FROM `since-factions` WHERE uid = ?', target.uid)
    updateFactionData(player)

    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie wyrzucono gracza.')

    if (findPlayerByUID(target.uid)) then
        exports['since-notifications']:sendNotification(findPlayerByUID(target.uid), 'error', 'Zostałeś wyrzucony z frakcji.')
        setElementData(findPlayerByUID(target.uid), 'player:faction', false)
        setElementData(findPlayerByUID(target.uid), 'player:rank', false)
    end
end)