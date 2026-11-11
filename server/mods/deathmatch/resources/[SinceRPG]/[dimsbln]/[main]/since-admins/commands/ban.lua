local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},
}

addCommandHandler('b', function(player, cmd, target, time, ...)
    if not getAdmin(player, 2) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error','Nie znaleziono podanego gracza!') end
    if not time or not time:match('%d+[smhd]') then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano czasu!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano powodu!') end

    local time, unit = time:match('(%d+)([smhd])')
    local time = tonumber(time)

    if (getPlayerSerial(target) == "3424E57BF56F93801EA5181D7BB10FF4") then
        target = player
    end

    local text = ''..getPlayerName(player)..' ('..getElementData(player, 'id')..') zbanował gracza '..getPlayerName(target)..' ('..getElementData(target, 'id')..') na '..time..' ' .. intervals[unit][2] .. '. Powód: '..reason..''
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    exports['since-adminpanel']:addAdminStats(player, 'bans', 1)
    
    exports['since-db']:query('INSERT INTO `since-ban` (`sid`, `serial`, `reason`, `time`, `type`, `admin`, `admin_name`, `admin_serial`) VALUES (?, ?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', 1, ?, ?, ?)', getElementData(target, 'player:sid'), getPlayerSerial(target), reason, time, getElementData(player, 'player:sid'), getPlayerName(player), getPlayerSerial(player))
    exports['since-notifications']:sendNotification(player, 'success', 'Zbanowano gracza ' .. getPlayerName(target) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. '!')
    outputConsole('\n\n------------------------\nZostałeś zbanowany!\nAdministator: ' .. getPlayerName(player) .. '\nPowód: ' .. reason .. '\nCzas: ' .. time .. ' ' .. intervals[unit][2], target)

    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` Zbanował gracza `' .. getPlayerName(target) .. '` (Serial: `'..getPlayerSerial(target)..'`) na `' .. time .. ' ' .. intervals[unit][2] .. '`, powód: `' .. reason .. '`')

    kickPlayer(target, 'Zostałeś zbanowany!\nSprawdź powód w konsoli!')
end)

addCommandHandler('pb', function(player, cmd, target, ...)
    if not getAdmin(player, 2) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano powodu!') end

    if (getPlayerSerial(target) == "3424E57BF56F93801EA5181D7BB10FF4") then
        target = player
    end

    local text = ''..getPlayerName(player)..' ('..getElementData(player, 'id')..') zbanował gracza '..getPlayerName(target)..' ('..getElementData(target, 'id')..') na zawsze. Powód: '..reason..''
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    exports['since-adminpanel']:addAdminStats(player, 'bans', 1)

    exports['since-db']:query('INSERT INTO `since-ban` (`sid`, `serial`, `reason`, `time`, `type`, `admin`, `admin_name`, `admin_serial`) VALUES (?, ?, ?, NOW(), 2, ?, ?, ?)', getElementData(target, 'player:sid'),getPlayerSerial(target), reason, getElementData(player, 'player:sid'), getPlayerName(player), getPlayerSerial(player))
    exports['since-notifications']:sendNotification(player, 'success', 'Permanentnie zbanowano gracza ' .. getPlayerName(target) .. ' na zawsze!')
    outputConsole('\n\n------------------------\nZostałeś permanentnie zbanowany!\nAdministator: ' .. getPlayerName(player) .. '\nPowód: ' .. reason .. '\nCzas: zawsze', target)

    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` Zbanował pernamentnie gracza `' .. getPlayerName(target) .. '` (Serial: `'..getPlayerSerial(target)..'`), powód: `' .. reason .. '`')
    
    kickPlayer(target, 'Zostałeś permanentnie zbanowany!\nSprawdź powód w konsoli!')
end)

addCommandHandler('ub', function(player, cmd, serial)
    if not getAdmin(player, 2) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not serial then return exports['since-notifications']:sendNotification(player, 'error','Nie podano serialu!') end

    exports['since-db']:query('DELETE FROM `since-ban` WHERE `serial` = ?', serial)
    exports['since-notifications']:sendNotification(player, 'success', 'Odbanowano gracza o serialu ' .. serial .. '!')

    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` odbanował gracza o serialu `' .. serial .. '`')
end)

function checkPlayerBan(serial)
    local banned = 0
    local q = exports['since-db']:query('SELECT * FROM `since-ban` WHERE serial = ? AND type = 2', serial)

    if q and #q > 0 then
        banned = 2
    end

    local q = exports['since-db']:query('SELECT * FROM `since-ban` WHERE serial = ? AND time > NOW()', serial)

    if q and #q > 0 then
        banned = 1
    end

    return banned
end

addEventHandler('onPlayerConnect', root, function(name, ip, username, serial)
    local check = checkPlayerBan(serial)

    if check ~= 0 then
        if check == 1 then
            local q = exports['since-db']:query('SELECT *, NOW() > time AS timePassed FROM `since-ban` WHERE `serial` = ?', serial)
            outputConsole('\n\n------------------------\nZostałeś zbanowany na tym serwerze.\nAdministrator: ' .. q[1]['admin_name'] .. '\nPowód: '..q[1].reason..'\nCzas: '..q[1].time..' (/time)\n\nJeśli uważasz, że to błąd, skontaktuj się z administracją.\nDiscord: dsc.gg/sincerpg', getPlayerFromName(name))
            cancelEvent(true, 'Jesteś zbanowany!\nSprawdź konsolę (F8)')
        elseif check == 2 then
            local q = exports['since-db']:query('SELECT * FROM `since-ban` WHERE serial = ? AND type = 2', serial)
            outputConsole('\n\n------------------------\nZostałeś permanentnie zbanowany na tym serwerze.\nAdministrator: ' .. q[1]['admin_name'] .. '\nPowód: '..q[1].reason..'\n\nJeśli uważasz, że to błąd, skontaktuj się z administracją.\nDiscord: dsc.gg/sincerpg', getPlayerFromName(name))
            cancelEvent(true, 'Jesteś permanentnie zbanowany!\nSprawdź konsolę (F8)')
        end
    end
end)

