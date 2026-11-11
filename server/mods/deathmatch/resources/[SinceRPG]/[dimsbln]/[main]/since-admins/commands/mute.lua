local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},
}

addCommandHandler('wycisz', function(player, cmd, target, time, ...)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    if not time or not time:match('%d+[smhd]') then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano czasu!') end
    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano powodu!') end
    if getElementData(target, 'player:mute', true) then return exports['since-notifications']:sendNotification(player, 'error', 'Ten gracz jest już wyciszony!') end

    local time, unit = time:match('(%d+)([smhd])')
    local time = tonumber(time)

    setElementData(target, 'player:mute', true)

    exports['since-adminpanel']:addAdminStats(player, 'mutes', 1)

    local plrUID = getElementData(target, 'player:sid')
    local discordID = exports['since-discord']:getPlayerDiscordID(plrUID)

    if discordID then
        exports['since-discord']:botWrite({
            funcname = 'addRole',
            args = {
                guild = '1143611641393586356',
                id = discordID,
                rank = '1270748143033520224'
            }
        }); 
    end

    local text = ''..getPlayerName(player)..' ('..getElementData(player, 'id')..') wyciszył gracza '..getPlayerName(target)..' ('..getElementData(target, 'id')..') na '..time..' ' .. intervals[unit][2] .. '. Powód: '..reason..''
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    exports['since-db']:query('INSERT INTO `since-punishments` (`serial`, `reason`, `time`, `type`, `admin_name`, `admin_serial`) VALUES (?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', "mute", ?, ?)', getPlayerSerial(target), reason, time, getPlayerName(player), getPlayerSerial(player))
    exports['since-notifications']:sendNotification(player, 'success','Pomyślnie wyciszono gracza!')
    exports['since-notifications']:sendNotification(target, 'warning', 'Zostałeś wyciszony przez ' .. getPlayerName(player) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. ' za ' .. reason .. '!')

    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` Wyciszył gracza `'..getPlayerName(target)..'` (Serial: `'..getPlayerSerial(target)..'`) na `' .. time .. ' ' .. intervals[unit][2] .. '`, powód: `' .. reason .. '`')
end)

addCommandHandler('odcisz', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end
    target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end
    
    setElementData(target, 'player:mute', false)

    local plrUID = getElementData(target, 'player:sid')
    local discordID = exports['since-discord']:getPlayerDiscordID(plrUID)

    if discordID then
        exports['since-discord']:botWrite({
            funcname = 'removeRole',
            args = {
                guild = '1143611641393586356',
                id = discordID,
                rank = '1270748143033520224'
            }
        }); 
    end

    exports['since-db']:query('DELETE FROM `since-punishments` WHERE `serial` = ? AND `type` = "mute"', getPlayerSerial(target))
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie odciszono gracza!')
    exports['since-notifications']:sendNotification(target, 'success', 'Zostałeś odciszony przez ' .. getPlayerName(player) .. '!')

    exports['since-logs']:sendDiscordLog('kary', 'Administracja', '`'..getPlayerName(player)..'` odciszył gracza `' .. getPlayerName(target) .. '`')
end)