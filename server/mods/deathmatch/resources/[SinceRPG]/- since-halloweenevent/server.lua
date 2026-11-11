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

local treshold = {}

addEvent("addPlayerEventPoints", true)
addEventHandler("addPlayerEventPoints", resourceRoot, function(value)
    if value and tonumber(value) then
        local playerData = getElementData(client, "player:data") or {}

        if not treshold[client] then
            treshold[client] = 0
        end

        treshold[client] = treshold[client] + 1

        if value > 30 then
            triggeringBan(client, 'since-halloweenevent próba nadania dużej ilości punktów eventowych')
            return
        end

        if treshold[client] > 5 then
            triggeringBan(client, 'since-halloweenevent zbyt szybkie wywołanie triggera')
            return
        end

        if not playerData.halloweenPoints then
            playerData.halloweenPoints = 0
        end

        playerData.halloweenPoints = playerData.halloweenPoints + value

        setElementData(client, "player:data", playerData)
    end
end)

setTimer(function()
    treshold = {}
end, 10000, 0)