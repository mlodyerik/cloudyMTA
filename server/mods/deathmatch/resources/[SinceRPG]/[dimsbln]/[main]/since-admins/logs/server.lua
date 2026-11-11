local reportTimeout = {}
local syncer = createElement('admin:logs', 'admin:logs')
setElementData(syncer, 'logs', {})

local commandBlackList = {
    ['Zwieksz'] = true,
    ['Zmniejsz'] = true,
    ['v'] = true,
    ['d'] = true,
    ['pm'] = true,
    ['pw'] = true,
    ['re'] = true,
    ['admin'] = true,
    ['zaplac'] = true,
    ['dajkase'] = true,
    ['przelej'] = true,
    ['duty'] = true,
    ['restart'] = true,
    ['refreshall'] = true,
    ['stop'] = true,
    ['start'] = true,
    ['refresh'] = true,
}

function addLog(data)
    local logs = getElementData(syncer, 'logs')
    table.insert(logs, data)

    if #logs > 40 then
        table.remove(logs, 1)
    end

    setElementData(syncer, 'logs', logs)
end

function addChatLog(player, message)
    local rank = getElementData(player, 'player:admin')
    if string.len(message:gsub("#%x%x%x%x%x%x", "")) > 255 then return end
    addLog({
        type = 'chat',
        player = getElementData(player, 'player:sid'),
        textNoHex = '[CZAT] '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): ' .. message,
        text = {
            {tocolor(255, 155, 215), '[CZAT]#ffffff '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): '},
            {tocolor(225, 225, 225), '' .. message},
        },
        sendTime = getRealTime().timestamp
    })
end

function addGlobalChatLog(player, message, premiumType, premiumColor)
    local rank = getElementData(player, 'player:admin')
    if string.len(message:gsub("#%x%x%x%x%x%x", "")) > 255 then return end
    addLog({
        type = 'premium',
        player = getElementData(player, 'player:sid'),
        textNoHex = '['..premiumType..'] '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): ' .. message,
        text = {
            {premiumColor, '['..premiumType..']#ffffff '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): '},
            {tocolor(225, 225, 225), '' .. message},
        },
        sendTime = getRealTime().timestamp
    })
end

function addPrivateMessage(player, target, message)
    local rank = getElementData(player, 'player:admin')
    local rank2 = getElementData(target, 'player:admin')
    if string.len(message:gsub("#%x%x%x%x%x%x", "")) > 255 then return end
    addLog({
        type = 'private',
        player = getElementData(player, 'player:sid'),
        target = getElementData(target, 'player:sid'),
        textNoHex = '[PW] '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ') >> '..getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. '): ' .. message,
        text = {
            {tocolor(255, 175, 25), '[PW]#ffffff '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ') >> '..getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. '): '},
            {tocolor(225, 225, 225), '' .. message},
        },
        sendTime = getRealTime().timestamp
    })
end

function addRankLogin(player, rankName)
    local rank = getElementData(player, 'player:admin')
    addLog({
        type = 'rank',
        player = getElementData(player, 'player:sid'),
        textNoHex = '[DUTY] Gracz '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ') loguje się na służbę jako ' .. rankName,
        text = {
            {tocolor(255, 55, 155), '[DUTY]#ffffff Gracz '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ') loguje się na służbę jako '},
            {getRankColor(rank), '' .. rankName},
        },
        sendTime = getRealTime().timestamp
    })
end

function addMoneyTransferLog(player, target, money, isWPLN)
    local isWPLN = isWPLN and "wPLN" or "$"
    local rank = getElementData(player, 'player:admin')
    local rank2 = getElementData(target, 'player:admin')
    addLog({
        type = 'money',
        player = getElementData(player, 'player:sid'),
        target = getElementData(target, 'player:sid'),
        textNoHex = '[PRZELEW] '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ') >> '..getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. ') >> '.. isWPLN ..' ' .. comma_value(money),
        text = {
            {tocolor(46, 117, 111), '[PRZELEW]#ffffff '..getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ') >> '..getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. ') >>'},
            {tocolor(46, 117, 111), ' '..isWPLN..' ' .. comma_value(money)},
        },
        sendTime = getRealTime().timestamp
    })
end

function addCommandLog(player, command)
    if (command:find('say')) then return end
    local rank = getElementData(player, 'player:admin')
    addLog({
        type = 'command',
        player = getElementData(player, 'player:sid'),
        textNoHex = getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. '): /' .. command,
        text = {
            {getRankColor(rank), getPlayerName(player) .. ' (' .. getElementData(player, 'id') .. ')'},
            {0xFFFFFFFF, ': /' .. command},
        },
        sendTime = getRealTime().timestamp
    })
end

local serials = {
    ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,
    ['C217ED9FE6899B85C066837D5D16A4D1'] = true,
}

local cannels = {
    ['Antycheat'] = 'https://discord.com/api/webhooks/1184150164399726672/GARga1qgnFtIVpNO37sue3Xrx9b3HTed4dY-5uK-ywHa5QwX7FDiJJ-hNnRj44euNeXO',
}
  
function writeOnDiscord(cannel, text)
    if cannels[cannel] then
      sendOptions = {
        queueName = "antycheatWebhook",
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
          username = cannel,
          content = text:gsub("#%x%x%x%x%x%x",""),
        },
      }
      fetchRemote(cannels[cannel], sendOptions, function() end)
    end
end

function triggeringBan(player, info)
    local nick, serial, ip, versionNumber = getPlayerName(player), getPlayerSerial(player), getPlayerIP(player)
    writeOnDiscord('Antycheat', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)
    exports['since-logs']:sendDiscordLog('antycheat', 'AC', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)

    if serials[serial] then
      return
    end
    
    local text = ''..getPlayerName(player)..' ('..(getElementData(player, 'id') or 0)..') został zbanowany przez AntyCheat.'
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)
    
    banPlayer(player, true, false, true, root, 'Nie posiadasz dostępu do serwera.')

    if isElement(player) then
        kickPlayer(player, 'Nie posiadasz dostępu do serwera.')
    end
end

local checkList = {}

addEvent('admin:logConsole', true)
addEventHandler('admin:logConsole', resourceRoot, function(command)
    local cmd = split(command, ' ')[1]
    if commandBlackList[cmd] then return end
    if string.len(command) > 255 then return end
    if not checkList[client] then
        checkList[client] = 0
    end
    checkList[client] = checkList[client] + 1
    if checkList[client] >= 20 then triggeringBan(client, 'since-admins spam logów') return end
    addCommandLog(client, command)
end)

setTimer(function()
    for player, _ in pairs(checkList) do
        checkList[player] = nil
    end
end, 2000, 0)

addEventHandler('onPlayerQuit', root, function()
    if checkList[source] then
        checkList[source] = nil
    end
end)

function comma_value(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end