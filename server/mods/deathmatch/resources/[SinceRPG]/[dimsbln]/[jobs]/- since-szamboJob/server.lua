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

local vehicles = {}
local hoses = {}
local spawns = {
    {644.41, 1239.83, 12.14, 358.8, 360.0, 300.1},
    {636.64, 1253.68, 12.14, 358.8, 360.0, 299.3},
}
local studzienki = {}

function destroyVehicle(client)
    if vehicles[client] and isElement(vehicles[client]) then
        destroyElement(vehicles[client])
        vehicles[client] = nil
    end
end

addEvent("addMyHose", true)
addEventHandler("addMyHose", resourceRoot, function()
    if not vehicles[client] or not isElement(vehicles[client]) then return end

    hoses[client] = {
        vehicle = vehicles[client],
        points = {},
        studzienka = false,
    }

    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
end)

function updateStudzienki(client)
    local t = {}
    for k,v in pairs(studzienki) do
        if v and v > getTickCount() then
            t[k] = true
        end
    end
    triggerClientEvent((client or root), "updateStudzienkiBlips", (client or root), t)
end

setTimer(updateStudzienki, 10000, 0)

addEvent("attachToStudzienka", true)
addEventHandler("attachToStudzienka", resourceRoot, function(id)
    if not vehicles[client] or not isElement(vehicles[client]) or not hoses[client] then return end

    if not (studzienki[id] and studzienki[id] > getTickCount()) then
        if not isElementFrozen(vehicles[client]) then
            exports['since-notifications']:sendNotification(client, 'error', "Pojazd musi mieć zaciągnięty hamulec ręczny")
            triggerClientEvent(client, "failedAttachStudzienka", client)
        else
            hoses[client].studzienka = id
            setElementFrozen(vehicles[client], true)
            studzienki[id] = getTickCount()+ 5*60*1000
            triggerClientEvent(client, "successAttachStudzienka", client)
            triggerClientEvent(root, "play3DSoundSzambo", root, vehicles[client])
            updateStudzienki()
        end
    else
        triggerClientEvent(client, "failedAttachStudzienka", client)
    end

    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
end)

addEvent("stopSzambo", true)
addEventHandler("stopSzambo", resourceRoot, function(id)
    if not vehicles[client] or not isElement(vehicles[client]) or not hoses[client] then return end

    triggerClientEvent(root, "destroyHoseSound", root, client)
    hoses[client] = nil

    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
end)

addEvent("deleteMyHose", true)
addEventHandler("deleteMyHose", resourceRoot, function()
    if not vehicles[client] or not isElement(vehicles[client]) then return end
    hoses[client] = nil

    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
end)

addEvent("getHoses", true)
addEventHandler("getHoses", resourceRoot, function()
    for k,v in pairs(hoses) do
        triggerClientEvent(root, "updatePlayerHose", root, k, v)
    end
end)

addEvent("givePlayerMoney", true)
addEventHandler("givePlayerMoney", resourceRoot, function(value)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-szamboJob zbyt szybkie wywołanie triggera') return end

    if value > 5000000 then triggeringBan(client, 'since-szamboJob próba nadania dużej ilości gotówki za kurs') return end

    givePlayerMoney(client, value)
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


addEvent("addHosePoint", true)
addEventHandler("addHosePoint", resourceRoot, function(x, y, z)
    if not vehicles[client] or not isElement(vehicles[client]) or not hoses[client] then return end

    table.insert(hoses[client].points, {x, y, z})
    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
end)

addEvent("removeHosePoint", true)
addEventHandler("removeHosePoint", resourceRoot, function(id)
    if not vehicles[client] or not isElement(vehicles[client]) or not hoses[client] then return end
    if #hoses[client].points == 0 then return end
    
    for i = id, #hoses[client].points do
        hoses[client].points[i] = nil
    end
    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
end)

addEvent("startSzamboJob", true)
addEventHandler("startSzamboJob", resourceRoot, function()
    destroyVehicle(client)

    local spawn = spawns[math.random(1, #spawns)]
    vehicles[client] = createVehicle(573, spawn[1], spawn[2], spawn[3], spawn[4], spawn[5], spawn[6])
    setVehicleColor(vehicles[client], 255, 255, 255, 255, 255, 255)
    setElementData(vehicles[client], "element:ghost", true)
    setElementData(vehicles[client], "szambo:owner", client)

    if exports["since-jobs"]:getPlayerUpgradeLevel("szambiarz", 2) == 1 then
        setVehicleHandling(vehicles[client], "engineAcceleration", 9)
    end

    triggerClientEvent(client, "yourSzamboVehicle", client, vehicles[client])
    updateStudzienki(client)

    warpPedIntoVehicle(client, vehicles[client])
end)

addEvent("endSzamboJob", true)
addEventHandler("endSzamboJob", resourceRoot, function()
    destroyVehicle(client)

    hoses[client] = nil

    for k,v in pairs(studzienki) do
        if v == client then
            studzienki[k] = nil
        end
    end

    triggerClientEvent(root, "updatePlayerHose", root, client, hoses[client])
    triggerClientEvent(root, "destroyHoseSound", root, client)
end)

addEventHandler("onPlayerQuit", root, function()
    destroyVehicle(source)
    if hoses[source] then
        hoses[source] = nil
        triggerClientEvent(root, "updatePlayerHose", root, source, hoses[source])
    end

    for k,v in pairs(studzienki) do
        if v == source then
            studzienki[k] = nil
        end
    end

    triggerClientEvent(root, "destroyHoseSound", root, source)
end)