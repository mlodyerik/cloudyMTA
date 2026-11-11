addEvent('AC:banPlayer', true)
addEventHandler('AC:banPlayer', resourceRoot, function(reason, text)
    banPlayer(client, true, false, true, root, reason)

    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)
end)

addEventHandler('onPlayerConnect', root, function(nick, ip, username, serial, versionNumber)
    local player = getPlayerFromName(nick)

    triggerClientEvent(player, 'saveSerialToJSON', resourceRoot)
end)