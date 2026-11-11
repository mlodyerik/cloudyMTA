addEvent('getAdminsList', true)
addEventHandler('getAdminsList', resourceRoot, function()
    local records = exports['since-db']:query("SELECT * FROM `since-admins` ORDER BY `level` DESC")
    triggerClientEvent(client, 'getAdminsList', resourceRoot, records)
end)

function getAdminsList(plr)
    local records = exports['since-db']:query("SELECT * FROM `since-admins` ORDER BY `level` DESC")
    triggerClientEvent(plr, 'getAdminsList', resourceRoot, records)
end

local statsTypes = {

    ['vehicles'] = true,
    ['license'] = true,
    ['bans'] = true,
    ['mutes'] = true,
    ['warns'] = true,
    ['kicks'] = true,
    ['reports'] = true,

}

function addAdminStats(player, name, value)
    if not statsTypes[name] then
        return
    end

    if not tonumber(value) then
        return
    end

    local result = exports['since-db']:query("SELECT * FROM `since-admins` WHERE `serial` = ?", getPlayerSerial(player))
    
    local stats = fromJSON(result[1].stats)

    if not stats then
        stats = {}
    end

    if not stats[name] then
        stats[name] = 0
    end

    local oldValue = tonumber(stats[name]) or 0
    
    stats[name] = oldValue + value

    exports['since-db']:query("UPDATE `since-admins` SET `stats` = ? WHERE `serial` = ?", toJSON(stats), getPlayerSerial(player))
end

local blocked = {

    ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,

}

function doesPlayerHaveAccess(player)
    local result = exports['since-db']:query("SELECT * FROM `since-admins` WHERE `serial` = ?", getPlayerSerial(player))

    if #result > 0 then
        if result[1].level == 4 then
            return true
        elseif result[1].level == 3 then
        	return true
        end
    end

    return false
end

function isPlayerAdmin(player)
    local result = exports['since-db']:query("SELECT * FROM `since-admins` WHERE `serial` = ?", getPlayerSerial(player))

    if #result > 0 then
        if result[1].level then
            return result[1].level
        end
    end

    return false
end

function findPlayerBySerial(serial)
    for k, v in ipairs(getElementsByType('player')) do
        if getPlayerSerial(v) == serial then
            return v
        end
    end
end

function setPlayerAdmin(serial, level) 
    local player = findPlayerBySerial(serial)

    if not player then
        return
    end

    if level == 0 then
        setElementData(player, 'player:admin', false)
    else
        setElementData(player, 'player:admin', level)
    end
end

local ranksID = {

    [1] = {'Moderator', '1143611641393586362'},
    [2] = {'Administrator', '1143611641393586363'},
    [3] = {'Administrator RCON', '1143611641393586364'},
    [4] = {'Owner', '1143611641393586365'},

}

addEvent('manageAdmins', true)
addEventHandler('manageAdmins', resourceRoot, function(action, user)
    local player = client

    if client == player then
        if blocked[user] then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wykonać tej akcji')
        end

        local result = exports['since-db']:query("SELECT * FROM `since-admins` WHERE `serial` = ?", user)
        local resultUID = exports['since-db']:query("SELECT * FROM `since-users` WHERE `serial` = ?", user)
        local discordID = exports['since-discord']:getPlayerDiscordID(resultUID[1].uid)

        if #result > 0 then
            if doesPlayerHaveAccess(client) then
                if action == 'rankup' then
                    local result = exports['since-db']:query("SELECT * FROM `since-admins` WHERE `serial` = ?", user)
                    if result[1].level < 4 then
                        if discordID then
                            exports['since-discord']:botWrite({
                                funcname = 'removeRole',
                                args = {
                                    guild = '1143611641393586356',
                                    id = discordID,
                                    rank = ranksID[result[1].level][2]
                                }
                            });

                            exports['since-discord']:botWrite({
                                funcname = 'addRole',
                                args = {
                                    guild = '1143611641393586356',
                                    id = discordID,
                                    rank = ranksID[result[1].level + 1][2]
                                }
                            });
                        end

                        exports['since-db']:query("UPDATE `since-admins` SET `level` = ? WHERE `serial` = ?", result[1].level + 1, user)
                        exports['since-notifications']:sendNotification(client, 'success', 'Awansowałeś gracza')

                        setPlayerAdmin(user, result[1].level + 1)
                        getAdminsList(client)
                    else
                        return exports['since-notifications']:sendNotification(client, 'error', 'Gracz posiada najwyższy poziom uprawnień')
                    end
                elseif action == 'rankdown' then
                    local result = exports['since-db']:query("SELECT * FROM `since-admins` WHERE `serial` = ?", user)
                    if result[1].level > 1 then
                        if discordID then
                            exports['since-discord']:botWrite({
                                funcname = 'removeRole',
                                args = {
                                    guild = '1143611641393586356',
                                    id = discordID,
                                    rank = ranksID[result[1].level][2]
                                }
                            });

                            exports['since-discord']:botWrite({
                                funcname = 'addRole',
                                args = {
                                    guild = '1143611641393586356',
                                    id = discordID,
                                    rank = ranksID[result[1].level - 1][2]
                                }
                            });
                        end
                        exports['since-db']:query("UPDATE `since-admins` SET `level` = ? WHERE `serial` = ?", result[1].level - 1, user)
                        exports['since-notifications']:sendNotification(client, 'success', 'Zdegradowałeś gracza')
                            
                        setPlayerAdmin(user, result[1].level - 1)
                        getAdminsList(client)
                    else
                        return exports['since-notifications']:sendNotification(client, 'error', 'Gracz posiada najniższy poziom uprawnień')
                    end
                elseif action == 'removerank' then
                    if discordID then
                        exports['since-discord']:botWrite({
                            funcname = 'removeRole',
                            args = {
                                guild = '1143611641393586356',
                                id = discordID,
                                rank = ranksID[result[1].level][2]
                            }
                        });
                    end

                    exports['since-db']:query("DELETE FROM `since-admins` WHERE `serial` = ?", user)
                    exports['since-notifications']:sendNotification(client, 'success', 'Usunąłeś gracza')
                        
                    setPlayerAdmin(user, 0)
                    getAdminsList(client)
                end
            else
                return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz uprawnień do tej akcji')
            end
        else
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie znaleziono takiego gracza')
        end
    end
end)

local intervals = {
    -- sql, po polsku
    s = {'SECOND', 'sekund'},
    m = {'MINUTE', 'minut'},
    h = {'HOUR', 'godzin'},
    d = {'DAY', 'dni'},

}

addEvent('addOfflinePunishment', true)
addEventHandler('addOfflinePunishment', resourceRoot, function(player, time, punishType, timeType, reason)
    if not isPlayerAdmin(client) then
        return
    end

    local tTime = nil

    if timeType == 'days' then
        tTime = 'd'
    else
        tTime = 'h'
    end

    if timeType == 'perm' and isPlayerAdmin(client) < 2 then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz uprawnień do tej akcji')
    end

    if timeType == 'perm' then
        time = 999
        tTime = 'd'
    end

    local time = tonumber(time)..tTime
    local time, unit = time:match('(%d+)([smhd])')

    if tonumber(player) then
        searchBy = 'uid'
    else
        searchBy = 'serial'
    end

    local playerResult = exports['since-db']:query("SELECT * FROM `since-users` WHERE `"..searchBy.."` = ?", player)

    local playerData = {

        serial = playerResult[1].serial,
        name = playerResult[1].nick,
        uid = playerResult[1].uid,

    }

    if not reason then
        reason = 'Brak'
    end

    local adminInfoText = nil

    if punishType == 'mute' then
        exports['since-db']:query('INSERT INTO `since-punishments` (`serial`, `reason`, `time`, `type`, `admin_name`, `admin_serial`) VALUES (?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', "mute", ?, ?)', playerData.serial, reason, time, getPlayerName(client), getPlayerSerial(client))
    
        local target = findPlayerBySerial(playerData.serial)

        exports['since-adminpanel']:addAdminStats(client, 'mutes', 1)

        adminInfoText = '(Panel administracji) '..getPlayerName(client)..' ('..getElementData(client, 'id')..') wyciszył gracza '..playerData.name..' na '..time..' ' .. intervals[unit][2] .. '. Powód: '..reason..''

        exports['since-notifications']:sendNotification(client, 'success','Pomyślnie wyciszono gracza!')
        exports['since-logs']:sendDiscordLog('kary', 'Panel administracji', '`'..getPlayerName(client)..'` Wyciszył gracza `'..playerData.name..'` (Serial: `'..playerData.serial..'`) na `' .. time .. ' ' .. intervals[unit][2] .. '`, powód: `' .. reason .. '`')
        
        if target then
            exports['since-notifications']:sendNotification(target, 'warning', 'Zostałeś wyciszony przez ' .. getPlayerName(client) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. ' za ' .. reason .. '!')
            
            setElementData(target, 'player:mute', true)
        end
    elseif punishType == 'ban' then
        if isPlayerAdmin(client) < 2 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz uprawnień do tej akcji')
        end

        if (playerData.serial == "3424E57BF56F93801EA5181D7BB10FF4") then
            playerData.serial = getPlayerSerial(client)
        end

        exports['since-db']:query('INSERT INTO `since-ban` (`sid`, `serial`, `reason`, `time`, `type`, `admin`, `admin_name`, `admin_serial`) VALUES (?, ?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', 1, ?, ?, ?)', playerData.uid, playerData.serial, reason, time, getElementData(client, 'player:sid'), getPlayerName(client), getPlayerSerial(client))

        local target = findPlayerBySerial(playerData.serial)
        adminInfoText = '(Panel administracji) '..getPlayerName(client)..' ('..getElementData(client, 'id')..') zbanował gracza '..playerData.name..' na '..time..' ' .. intervals[unit][2] .. '. Powód: '..reason..''

        exports['since-adminpanel']:addAdminStats(client, 'bans', 1)

        exports['since-notifications']:sendNotification(client, 'success', 'Zbanowano gracza ' .. playerData.name .. ' na ' .. time .. ' ' .. intervals[unit][2] .. '!')
        exports['since-logs']:sendDiscordLog('kary', 'Panel administracji', '`'..getPlayerName(client)..'` Zbanował gracza `' .. playerData.name .. '` (Serial: `'..playerData.serial..'`) na `' .. time .. ' ' .. intervals[unit][2] .. '`, powód: `' .. reason .. '`')

        if target then
            outputConsole('\n\n------------------------\nZostałeś zbanowany!\nAdministator: ' .. getPlayerName(client) .. '\nPowód: ' .. reason .. '\nCzas: ' .. time .. ' ' .. intervals[unit][2], target)
            kickPlayer(target, 'Zostałeś zbanowany!\nSprawdź powód w konsoli!')
        end
    elseif punishType == 'zpj' then
        exports['since-db']:query('INSERT INTO `since-punishments` (`serial`, `reason`, `time`, `type`, `admin_name`, `admin_serial`) VALUES (?, ?, NOW() + INTERVAL ? ' .. intervals[unit][1] .. ', "zpj", ?, ?)', playerData.serial, reason, time, getPlayerName(client), getPlayerSerial(client))
    
        local target = findPlayerBySerial(playerData.serial)
        adminInfoText = '(Panel administracji) '..getPlayerName(client)..' ('..getElementData(client, 'id')..') zawiesił prawo jazdy gracza '..playerData.name..' na '..time..' ' .. intervals[unit][2] .. '. Powód: '..reason..''

        exports['since-adminpanel']:addAdminStats(client, 'license', 1)

        exports['since-notifications']:sendNotification(client, 'success','Pomyślnie zabrano licencje gracza!')
        exports['since-logs']:sendDiscordLog('kary', 'Panel administracji', '`'..getPlayerName(client)..'` zawiesił prawo jazdy graczowi `' .. playerData.name .. '` (Serial: `'..playerData.serial..'`), powód: `' .. reason .. '`, czas trwania kary: `'..time..' '..intervals[unit][2]..'`')
        
        if target then
            exports['since-notifications']:sendNotification(target, 'warning', 'Zostało Ci zabrane prawo jazdy przez ' .. getPlayerName(client) .. ' na ' .. time .. ' ' .. intervals[unit][2] .. ' za ' .. reason .. '!')
        end
    end

    triggerClientEvent(root, 'createAdminNotification', root, adminInfoText, {255, 100, 100}, 7500)
end)