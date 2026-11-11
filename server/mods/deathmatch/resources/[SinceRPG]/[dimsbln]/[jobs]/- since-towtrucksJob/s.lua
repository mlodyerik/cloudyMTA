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

local positions = {
    {1106.84, 1926.20, 11.44, 0, 0, 90}, 
    {1091.48, 1917.18, 11.44, 0, 0, 0}, 
    {1082.57, 1917.31, 11.44, 0, 0, 0},
    {1076.60, 1917.07, 11.45, 0, 0, 0},
    {1067.74, 1917.20, 11.44, 0, 0, 0},
    {1060.43, 1917.06, 11.45, 0, 0, 0},
}

local vehicles = {}
local objects = {}

local vehicleModels = {
    {410, {0, -2.0, 0.5}},
    {411, {0, -2.0, 0.5}},
}

addEvent('givePlayerMoneyTowtruck', true)
addEventHandler('givePlayerMoneyTowtruck', resourceRoot, function(money, srp)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-towtrucksJob zbyt szybkie wywołanie triggera') return end

    if money > 5000000 then triggeringBan(client, 'since-towtrucksJob próba nadania dużej ilości gotówki za kurs') return end

    if srp and srp > 50 then triggeringBan(client, 'since-towtrucksJob próba nadania dużej ilości srp za kurs') return end

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

addEvent('since-lawety:s', true)
addEventHandler('since-lawety:s', resourceRoot, function(state)
    if state == 'start' then
        if vehicles[client] and isElement(vehicles[client]) then
            destroyElement(vehicles[client])
            vehicles[client] = nil
        end
        if objects[client] and isElement(objects[client]) then
            destroyElement(objects[client])
            objects[client] = nil
        end

        local x,y,z,rx,ry,rz = unpack(positions[math.random(#positions)])
        local veh = createVehicle(578, x, y, z, rx, ry, rz)
        setVehicleVariant(veh, 0, 0)
        setElementData(veh, 'element:ghost', true)
        setVehicleColor(veh, 255,255,255,255,255,255,255,255,255,255,255,255)
        warpPedIntoVehicle(client, veh)
        setVehicleEngineState(veh, true)
		setVehicleOverrideLights(veh, 2)
        setElementData(veh, 'laweta:owner', client)
        setElementData(veh, 'vehicle:fuel', 100)
        vehicles[client] = veh

    elseif state == 'pack' then        
        if objects[client] and isElement(objects[client]) then
            destroyElement(objects[client])
            objects[client] = nil
        end

        if math.random(1,2) == 1 then
            local rnd = math.random(#vehicleModels)
            local veh = createVehicle(vehicleModels[rnd][1], 0, 0, 1000)
            setVehicleColor(veh, 255,255,255,255,255,255,255,255,255,255,255,255)
            setVehicleVariant(veh,0,0)
            addVehicleUpgrade(veh, 1025)
            setElementCollisionsEnabled(veh, false)
            attachElements(veh, vehicles[client], unpack(vehicleModels[rnd][2]))
            objects[client] = veh
        else
            local object = createObject(2934, 0, 0, -15)
            setElementCollisionsEnabled(object, false)
            setObjectScale(object, 0.95)
            attachElements(object, vehicles[client], 0, -1.1, 1.15)
            objects[client] = object
        end

        triggerClientEvent(client, 'since-lawety:c', resourceRoot, 'packed')

    elseif state == 'endCourse' then

        if objects[client] and isElement(objects[client]) then
            destroyElement(objects[client])
            objects[client] = nil
        end
        
        triggerClientEvent(client, 'since-lawety:c', resourceRoot, 'unpacked')

    elseif state == 'end' then
        if vehicles[client] and isElement(vehicles[client]) then
            destroyElement(vehicles[client])
            vehicles[client] = nil
        end
        if objects[client] and isElement(objects[client]) then
            destroyElement(objects[client])
            objects[client] = nil
        end

    end
end)

local exitCheck = {}
addEventHandler('onVehicleStartExit', resourceRoot, function(ped, seat)
    if getElementType(ped) == 'player' and seat == 0 then
        if getElementData(ped, 'lawety:packing') then cancelEvent() return end
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
    if seat == 0 and vehicles[ped] == source then
        if vehicles[ped] and isElement(vehicles[ped]) then
            destroyElement(vehicles[ped])
            vehicles[ped] = nil
        end
        if objects[ped] and isElement(objects[ped]) then
            destroyElement(objects[ped])
            objects[ped] = nil
        end
        triggerClientEvent(ped, 'since-lawety:c', resourceRoot, 'end')
    end
end)

addEvent('onPlayerQuit', true)
addEventHandler('onPlayerQuit', root, function()
    if vehicles[source] and isElement(vehicles[source]) then
        destroyElement(vehicles[source])
        vehicles[source] = nil
    end
    if objects[source] and isElement(objects[source]) then
        destroyElement(objects[source])
        objects[source] = nil
    end
end)