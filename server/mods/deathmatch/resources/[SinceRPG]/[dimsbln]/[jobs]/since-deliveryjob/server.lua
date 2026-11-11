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

vehicles = {}

addEvent('startDeliveryJob', true)
addEventHandler('startDeliveryJob', resourceRoot, function(vehicleType)
    if vehicles[client] then
        if vehicles[player] then
            destroyElement(vehicles[player])
        end
        vehicles[client] = nil
    end
    if vehicleType == 1 then
        vehicles[client] = createVehicle(429, 1856.35, 2083.78, 10.72, 359.4, 360.0, 181.4)
        local baseModel, isCustom = exports["since-custommodels"]:checkModelID(80022, "vehicle")
        setElementModel(vehicles[client], baseModel)
        setElementData(vehicles[client], "baseID", baseModel)
        setElementData(vehicles[client], "vehicleID", 80022)

        setVehicleColor(vehicles[client], 255, 175, 0, 255, 175, 0)
        addVehicleUpgrade(vehicles[client], 1025)
        setVehicleHandling(vehicles[client], 'driveType', 'awd')
    else
        vehicles[client] = createVehicle(448, 1856.35, 2083.78, 10.52, 359.4, 360.0, 181.4)
    end

    setVehiclePlateText(vehicles[client], 'DELIVERY')

    setElementData(vehicles[client], 'vehicle:job', 'dostawca')
    setElementData(vehicles[client], 'vehicle:jobOwner', getElementData(client, 'player:sid'))
    setElementData(vehicles[client], 'element:ghost', true)

    setTimer(warpPedIntoVehicle, 100, 1, client, vehicles[client])
end)

addEvent('givePlayerMoneyFromDelivery', true)
addEventHandler('givePlayerMoneyFromDelivery', resourceRoot, function(money, srp)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-deliveryjob zbyt szybkie wywołanie triggera') return end

    if money > 5000000 then triggeringBan(client, 'since-deliveryjob próba nadania dużej ilości gotówki za kurs') return end

    if srp and srp > 100 then triggeringBan(client, 'since-deliveryjob próba nadania dużej ilości srp za kurs') return end

    givePlayerMoney(client, money)

    if srp and srp > 0 then
        setElementData(client, 'player:srp', getElementData(client, 'player:srp')+srp)
    end
end)

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

addEventHandler('onVehicleStartEnter', root, function(player, seat)
    if getElementData(source, 'vehicle:job') == 'dostawca' then 
        if getElementData(source, 'vehicle:jobOwner') ~= getElementData(player, 'player:sid') then 
            cancelEvent()
            exports['since-notifications']:sendNotification(player, 'error', 'Ten pojazd nie należy do Ciebie!')
        end
    else
        if getElementData(player, 'player:job') == 'dostawca' then
            cancelEvent()
            exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wsiąść do innego pojazdu podczas pracy!')
        end
    end
end)

function stopJob(player, fromServer)
    if getElementData(player, 'player:job') ~= 'dostawca' then 
        return
    end

    if isElement(vehicles[player]) then
        destroyElement(vehicles[player])
    end

    if player and isElement(player) and fromServer then
        triggerClientEvent(player, 'onJobFinish', root, 'dostawca')
    end

    setElementData(player, 'player:job', nil)
end

addEvent('stopDeliveryJob', true)
addEventHandler('stopDeliveryJob', root, function()
    stopJob(client)
end)

addEventHandler('onPlayerQuit', root, function()
    stopJob(source, true)
end)

addEventHandler('onPlayerWasted', root, function()
    stopJob(source, true)
end)