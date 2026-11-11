function show(player, faction)
    triggerClientEvent(player, 'since-factions-clothing:show', resourceRoot, faction)
end

function hide(player)
    triggerClientEvent(player, 'since-factions-clothing:hide', resourceRoot)
end

addEvent('since-factions-clothing:setSkin', true)
addEventHandler('since-factions-clothing:setSkin', resourceRoot, function (skin)
    local player = client

    if (not isElement(player)) then
        return
    end

    if (not getElementData(player, 'player:faction')) then
        return
    end

    setElementModel(player, skin)

    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie zmieniono skina.')
    hide(player)
end)