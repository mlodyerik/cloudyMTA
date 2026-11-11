addCommandHandler('k', function(player, cmd, target, ...)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error','Nie posiadasz uprawnień do tej komendy!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano powodu!') end

    local text = ''..getPlayerName(player)..' ('..getElementData(player, 'id')..') wyrzucił gracza '..getPlayerName(target)..' ('..getElementData(target, 'id')..'). Powód: '..reason..''
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    exports['since-adminpanel']:addAdminStats(player, 'kicks', 1)

    exports['since-db']:query('INSERT INTO `since-punishments` (`serial`, `reason`, `time`, `type`, `admin_name`, `admin_serial`) VALUES (?, ?, NOW(), "kick")', getPlayerSerial(target), reason, getPlayerName(player), getPlayerSerial(player))
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie wyrzucono gracza!')
    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` Wyrzucił gracza `' .. getPlayerName(target) .. '` (Serial: `'..getPlayerSerial(target)..'`), powód: `' .. reason .. '`')
    outputConsole('\n\n------------------------\nZostałeś wyrzucony z serwera przez '..getPlayerName(player)..'\nPowód: '..reason, target)
    kickPlayer(target, 'Zostałeś wyrzucony z serwera!\nSprawdź powód w konsoli!')
end)