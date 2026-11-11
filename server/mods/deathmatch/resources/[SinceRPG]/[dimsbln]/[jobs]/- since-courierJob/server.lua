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

local packages = {}
local pojazdy = {}

addEvent("takePackKurier", true)
addEventHandler("takePackKurier", resourceRoot, function(dwie)
    if packages[client] and isElement(packages[client]) then
        destroyElement(packages[client])
        packages[client] = nil
    end

    packages[client] = createObject(1271, 0, 0, 0)
    setObjectScale(packages[client], 1)
    setElementCollisionsEnabled(packages[client], false)
    exports["since-pattach"]:attach(packages[client], client, 23, 0.05, -0.45, 0.5, 0, 140, 0)
end)

addEvent("removePackKurier", true)
addEventHandler("removePackKurier", resourceRoot, function(dwie)
    if packages[client] and isElement(packages[client]) then
        destroyElement(packages[client])
        packages[client] = nil
    end
end)

addEvent("kurierKasa", true)
addEventHandler("kurierKasa", resourceRoot, function(money, srp)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-courierJob zbyt szybkie wywołanie triggera') return end

    if money > 5000000 then triggeringBan(client, 'since-courierJob próba nadania dużej ilości gotówki za kurs') return end

    if srp and srp > 50 then triggeringBan(client, 'since-courierJob próba nadania dużej ilości srp za kurs') return end

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

addEvent("kurierSpawn", true)
addEventHandler("kurierSpawn", resourceRoot, function(x, y, z, rx, ry, rz, speed)
    if pojazdy[client] and isElement(pojazdy[client]) then
        destroyElement(pojazdy[client])
        pojazdy[client] = nil
    end

    pojazdy[client] = createVehicle(498, x, y, z, rx, ry, rz)
    setElementData(pojazdy[client], "element:ghost", true)
    setVehicleColor(pojazdy[client], 255,255,255,255,255,255,255,255,255,255,255,255)
    addVehicleUpgrade(pojazdy[client], 1025)
    warpPedIntoVehicle(client, pojazdy[client])
    setElementData(pojazdy[client], "kurier:owner", client)
    setElementData(pojazdy[client], "vehicle:fuel", 100)
    if speed then
        setVehicleHandling(pojazdy[client], "engineAcceleration", 6+speed*1.5)
        setVehicleHandling(pojazdy[client], "maxVelocity", 120+10*speed)
    end
end)

addEvent("jobEndKurier", true)
addEventHandler("jobEndKurier", resourceRoot, function()
    if packages[client] and isElement(packages[client]) then
        destroyElement(packages[client])
        packages[client] = nil
    end
    if pojazdy[client] and isElement(pojazdy[client]) then
        destroyElement(pojazdy[client])
        pojazdy[client] = nil
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(plr)
    local kurier = getElementData(source, "kurier:owner")
    if kurier and kurier ~= plr then cancelEvent() end
end)

addEvent("kurierOdNowa", true)
addEventHandler("kurierOdNowa", resourceRoot, function()
    if pojazdy[client] and isElement(pojazdy[client]) then
        destroyElement(pojazdy[client])
        pojazdy[client] = nil
    end
    
    removePedFromVehicle(client)
    setElementPosition(client, 93.79, -302.87, 1.58)
    setPedRotation(client, 180)
end)

addEvent("kurierTP", true)
addEventHandler("kurierTP", resourceRoot, function(plr, x, y, z)
    setElementPosition(plr, x, y, z)
end)

addEventHandler("onVehicleExit", resourceRoot, function(plr)
    local kurier = getElementData(source, "kurier:owner")
    if kurier and kurier == plr then
        setVehicleDoorOpenRatio(source, 4, 1, 1000)
        setVehicleDoorOpenRatio(source, 5, 1, 1000)
    end
end)

addEventHandler("onVehicleEnter", resourceRoot, function(plr)
    local kurier = getElementData(source, "kurier:owner")
    if kurier and kurier == plr then
        setVehicleDoorOpenRatio(source, 4, 0, 1000)
        setVehicleDoorOpenRatio(source, 5, 0, 1000)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if packages[source] and isElement(packages[source]) then
        destroyElement(packages[source])
        packages[source] = nil
    end
    if pojazdy[source] and isElement(pojazdy[source]) then
        destroyElement(pojazdy[source])
        pojazdy[source] = nil
    end
end)