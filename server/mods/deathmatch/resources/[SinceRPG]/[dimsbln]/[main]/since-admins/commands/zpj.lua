local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},
}

addCommandHandler('zpj', function(player, cmd, target, time, ...)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    if not time or not time:match('%d+[smhd]') then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano czasu!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano powodu!') end

    local time, unit = time:match('(%d+)([smhd])')
    local time = tonumber(time)

    local text = ''..getPlayerName(target)..' ('..getElementData(target, 'id')..') otrzymał zakaz prowadzenia pojazdów (kat. A, B, C) od '..getPlayerName(player)..' ('..getElementData(player, 'id')..') na ' .. time .. ' ' .. intervals[unit][2] .. '. Powód: '..reason..''
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    exports['since-adminpanel']:addAdminStats(player, 'license', 1)

    removePedFromVehicle(target)
    
    exports['since-db']:query('INSERT INTO `since-punishments` (`serial`, `reason`, `time`, `type`, `admin_name`, `admin_serial`) VALUES (?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', "zpj", ?, ?)', getPlayerSerial(target), reason, time, getPlayerName(player), getPlayerSerial(player))
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie zabrano prawo jazdy graczowi!')
    exports['since-notifications']:sendNotification(target, 'warning', 'Zostało Ci zabrane prawo jazdy przez ' .. getPlayerName(player) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. ' za ' .. reason .. '!')
    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` zawiesił prawo jazdy graczowi `' .. getPlayerName(target) .. '` (Serial: `'..getPlayerSerial(target)..'`), powód: `' .. reason .. '`, czas trwania kary: `'..time..' '..intervals[unit][2]..'`')
end)

addCommandHandler('opj', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end

    exports["since-db"]:query("UPDATE `since-punishments` SET active=0 WHERE serial=?", getPlayerSerial(target))
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie przywrócono prawo jazdy graczowi!')
    exports['since-notifications']:sendNotification(target, 'success', 'Twoje prawo jazdy zostało przywrócone przez ' .. getPlayerName(player) .. '!')
    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` zwrócił prawo jazdy graczowi `' .. getPlayerName(target) .. '`.')
end)