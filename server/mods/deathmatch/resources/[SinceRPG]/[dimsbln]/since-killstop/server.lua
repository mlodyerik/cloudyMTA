addEvent("getPlayers", true)
addEventHandler("getPlayers", resourceRoot, function(killer)
    local result = exports['since-db']:query('SELECT * FROM `since-killstop` ORDER BY `total` DESC LIMIT 9')

    triggerClientEvent(client, 'kills.top.result', resourceRoot, result)
end)


addEvent("getClientKilss", true)
addEventHandler("getClientKilss", resourceRoot, function(killer)
    local result = exports['since-db']:query('SELECT * FROM `since-killstop` WHERE `uid` = ?', getElementData(killer, 'player:sid'))

    triggerClientEvent(client, 'onClientKills', resourceRoot, result)
end)