local config = {

    money = {

        normal = 150000,
        diamond = 300000,

    },

    reputation = {

        normal = {2, 10},
        diamond = {6, 25},

    }

}

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

function giveHourReward()
    local isDiamond = getElementData(client, 'player:diamond')
    local uid = getElementData(client, 'player:sid')
    if not uid then return end
    
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 10 then triggeringBan(client, 'since-hoursaward zbyt szybkie wywołanie triggera') return end

    exports['since-db']:query('UPDATE `since-users` SET `topHours` = `topHours` + ? WHERE uid = ?', 1, uid)
    exports['since-db']:query('UPDATE `since-users` SET `topEvent` = `topEvent` + ? WHERE uid = ?', 1, uid)

    if isDiamond then
        local money = config.money.diamond
        local reputation = math.random(config.reputation.diamond[1], config.reputation.diamond[2])

        givePlayerMoney(client, money)

        local actualReputation = getElementData(client, 'player:srp')
        setElementData(client, 'player:srp', actualReputation + reputation)

        outputChatBox(' ', client, 71, 163, 255, true)
        outputChatBox('[Diamond] #ffffffOtrzymujesz: #6cff52$ ' .. comma(money) .. '#ffffff oraz #fff717' .. reputation .. ' SRP#ffffff za przegraną godzinę na serwerze.', client, 71, 163, 255, true)
        outputChatBox(' ', client, 71, 163, 255, true)
    else
        local money = config.money.normal
        local reputation = math.random(config.reputation.normal[1], config.reputation.normal[2])
        
        givePlayerMoney(client, money)
        
        local actualReputation = getElementData(client, 'player:srp')
        setElementData(client, 'player:srp', actualReputation + reputation)

        outputChatBox(' ', client, 71, 163, 255, true)
        outputChatBox('[Premium] #ffffffOtrzymujesz: #6cff52$ ' .. comma(money) .. '#ffffff oraz #fff717' .. reputation .. ' SRP#ffffff za przegraną godzinę na serwerze.', client, 255, 179, 0, true)
        outputChatBox(' ', client, 71, 163, 255, true)
    end
end
addEvent('giveReward', true)
addEventHandler('giveReward', resourceRoot, giveHourReward)

setTimer(function()
    for i,v in pairs(checkList) do
        checkList[i] = nil
    end
end, 10000, 0)

addEventHandler('onPlayerQuit', root, function()
    if checkList[source] then
        checkList[source] = nil
    end
end)

function comma(number)
    local formatted = number
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end