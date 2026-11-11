addCommandHandler('warn', function(player, cmd, target, ...)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano powodu!') end

    local text = ''..getPlayerName(target)..' ('..getElementData(target, 'id')..') otrzymał ostrzeżenie od '..getPlayerName(player)..' ('..getElementData(player, 'id')..'). Powód: '..reason..''
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    exports['since-adminpanel']:addAdminStats(player, 'warns', 1)

    exports['since-db']:query('INSERT INTO `since-punishments` (`serial`, `reason`, `time`, `type`, `admin_name`, `admin_serial`) VALUES (?, ?, NOW(), "warn", ?, ?)', getPlayerSerial(target), reason, getPlayerName(player), getPlayerSerial(player))
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie ostrzeżono gracza!')
    
    triggerClientEvent(target, 'onClientShowWarn', resourceRoot, getPlayerName(player), reason)

    exports['since-logs']:sendDiscordLog('kary', getPlayerName(player), 'Ostrzeżenie dla `' .. getPlayerName(target) .. '`, Powód: `' .. reason .. '`')
end)