addEvent('since-list:send', true)
addEventHandler('since-list:send', resourceRoot, function (text)
    local player = client

    local rows = exports['since-db']:query('SELECT * FROM `since-listy` WHERE uid=?', getElementData(player, 'player:sid'))

    if (#rows > 0) then
        exports['since-notifications']:sendNotification(player, 'error', 'Już wysłałeś list do świętego Mikołaja')

        return
    end

    exports['since-db']:query('INSERT INTO `since-listy` (uid, text) VALUES (?, ?)', getElementData(player, 'player:sid'), text)
    exports['since-notifications']:sendNotification(player, 'success', 'Wysłano list do świętego Mikołaja')

    exports['since-logs']:sendDiscordLog('listy', 'List do świętego Mikołaja', 'Gracz `'..getPlayerName(player)..'` wysłał list do świętego Mikołaja z treścią:\n`'..text..'`')
end)