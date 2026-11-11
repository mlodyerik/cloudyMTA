function isPlayerChoosedClass(player)
    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', getElementData(player, 'player:sid'))

    if (rows[1].class == '' or rows[1].class == nil) then
        return triggerClientEvent(player, 'since-classes:show', resourceRoot)
    end

    return rows[1].class
end

addEvent('since-classes:choose', true)
addEventHandler('since-classes:choose', resourceRoot, function (class)
    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', getElementData(client, 'player:sid'))

    if (rows[1].class == '' or rows[1].class == nil) then
        exports['since-db']:query('UPDATE `since-users` SET `class`=? WHERE `uid`=?', class, getElementData(client, 'player:sid'))

        triggerClientEvent(client, 'since-classes:hide', resourceRoot)
        exports['since-notifications']:sendNotification(client, 'success', 'Wybrałeś klasę '..class)
        setElementData(client, 'player:class', class)
    end
end)