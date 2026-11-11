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
local trailers = {}
local saver = {}

addEvent('givePlayerMoneytruck', true)
addEventHandler('givePlayerMoneytruck', resourceRoot, function(money, srp)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-truckJob zbyt szybkie wywołanie triggera') return end

    if money > 5000000 then triggeringBan(client, 'since-truckJob próba nadania dużej ilości gotówki za kurs') return end

    if srp and srp > 50 then triggeringBan(client, 'since-truckJob próba nadania dużej ilości srp za kurs') return end

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

addEvent("since-truckJob", true)
addEventHandler("since-truckJob", resourceRoot, function(state, data)
    if state == 'start' then
        if trailers[client] and isElement(trailers[client]) then
            destroyElement(trailers[client])
            trailers[client] = nil
        end
        local model, x,y,z,rx,ry,rz = data[1], unpack(data[2])
        local veh = createVehicle(model, x,y,z,rx,ry,rz)
        setVehicleVariant(veh, 0, 0)
        setElementFrozen(veh, true)
        setElementData(veh, 'element:ghost', true)
        setElementData(veh, 'trailer:owner', client)
        local truck = getPedOccupiedVehicle(client)
        setElementData(truck, 'element:ghost', true)
        vehicles[client] = truck
        trailers[client] = veh

        if saver[client] then saver[client] = nil end
        triggerClientEvent(client, 'since-truckJob', resourceRoot, 'started', {data[3], data[4], data[5]})

    elseif state == 'end' then
        if trailers[client] and isElement(trailers[client]) then
            destroyElement(trailers[client])
            trailers[client] = nil
        end
        if vehicles[client] then
            if isElement(vehicles[client]) then
                setElementData(vehicles[client], 'element:ghost', nil)
            end
            vehicles[client] = nil
        end

    end
end)

addEventHandler('onTrailerAttach', resourceRoot, function(veh)
    if source ~= trailers[getVehicleController(veh)] then
        return
    end
    local plr = getVehicleController(veh)
    if not plr then return end
    triggerClientEvent(plr, 'since-truckJob', resourceRoot, 'showPoints')
    setElementFrozen(source, false)
end)

addEventHandler('onTrailerDetach', resourceRoot, function(veh)
    if source ~= trailers[getVehicleController(veh)] then
        return
    end
    local plr = getVehicleController(veh)
    if not plr then return end
    triggerClientEvent(getVehicleController(veh), 'since-truckJob', resourceRoot, 'hidePoints')
end)

addEventHandler('onDestroyElement', resourceRoot, function()
    for i,v in pairs(trailers) do
        if v == source then
            trailers[i] = nil
            if vehicles[i] then
                if isElement(vehicles[i]) then
                    setElementData(vehicles[i], 'element:ghost', nil)
                end
                vehicles[i] = nil
            end
            break
        end
    end
end)

local exitCheck = {}
addEventHandler('onVehicleStartExit', root, function(ped, seat)
    if getElementType(ped) == 'player' and seat == 0 and getElementData(ped, 'player:job') == 'logistyka' then
        if exitCheck[ped] then
            if getTickCount() - exitCheck[ped] < 5000 then

            else
                exitCheck[ped] = getTickCount()
                exports['since-notifications']:sendNotification(ped, 'info', 'Aby zakończyć pracę naciśnij ponownie klawisz F')
                cancelEvent()
            end
        else
            exitCheck[ped] = getTickCount()
            exports['since-notifications']:sendNotification(ped, 'info', 'Aby zakończyć pracę naciśnij ponownie klawisz F')
            cancelEvent()
        end
    end
end)

addEvent('onVehicleExit', true)
addEventHandler('onVehicleExit', root, function(ped, seat)
    if seat == 0 and trailers[ped] and getElementData(ped, 'player:job') == 'logistyka' then
        if trailers[ped] and isElement(trailers[ped]) then
            destroyElement(trailers[ped])
            trailers[ped] = nil
        end
        if vehicles[ped] then
            if isElement(vehicles[source]) then
                setElementData(vehicles[source], 'element:ghost', nil)
            end
            vehicles[ped] = nil
        end
        if saver[ped] then saver[ped] = nil end
        triggerClientEvent(ped, 'since-truckJob', resourceRoot, 'end')
    end
end)

addEvent('onPlayerQuit', true)
addEventHandler('onPlayerQuit', root, function()
    if saver[source] then saver[source] = nil end
    if exitCheck[source] then exitCheck[source] = nil end
    if trailers[source] and isElement(trailers[source]) then
        destroyElement(trailers[source])
        trailers[source] = nil
    end
    if vehicles[source] then
        if isElement(vehicles[source]) then
            setElementData(vehicles[source], 'element:ghost', nil)
        end
        vehicles[source] = nil
    end
end)