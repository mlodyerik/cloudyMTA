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

local peds = {}

addEvent('givePlayerMoneyetransporter', true)
addEventHandler('givePlayerMoneyetransporter', resourceRoot, function(money, srp)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-etransporterJob zbyt szybkie wywołanie triggera') return end

    if money > 5000000 then triggeringBan(client, 'since-etransporterJob próba nadania dużej ilości gotówki za kurs') return end

    if srp and srp > 50 then triggeringBan(client, 'since-etransporterJob próba nadania dużej ilości srp za kurs') return end

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

addEvent('since-transporterJob', true)
addEventHandler('since-transporterJob', resourceRoot, function(state, info, name)
    if state == 'start' then
        if peds[client] and isElement(client) then
            destroyElement(peds[client])
            peds[client] = nil
        end

        local x,y,z = unpack(info)
        local ped = createPed(0, x,y,z)
        setElementData(ped, 'etransporter.ped', name)
        setElementFrozen(ped, true)
        setElementID(ped, 'etransporter-'..getElementData(client, 'player:sid'))
        setElementSyncer(ped, client)
        peds[client] = ped

        local veh = getPedOccupiedVehicle(client)
        for seat,plr in pairs(getVehicleOccupants(veh)) do
            if seat ~= 0 then
                removePlayerFromVehicle(plr)
            end
        end

    elseif state == 'unfreeze' then
        if peds[client] and isElement(peds[client]) then
            setElementFrozen(peds[client], false)
            setElementSyncer(peds[client], client)
            triggerClientEvent(client, 'since-transporterJob', resourceRoot, 'ped enter')
        end

    elseif state == 'destroy' then
        if peds[client] and isElement(client) then
            destroyElement(peds[client])
            peds[client] = nil
        end

    elseif state == 'ped sync' then
        if info and isElement(info) and getElementType(info) == 'ped' then
            setElementSyncer(info, client)
            if peds[client] == info then
                triggerClientEvent(client, 'since-transporterJob', resourceRoot, 'ped synced')
            end
        end

    elseif state == 'get in ped' then
        if info and getElementType(info) == 'ped' then
            warpPedIntoVehicle(info, getPedOccupiedVehicle(client), 1)
        end

    end
end)

addEventHandler('onVehicleStartEnter', root, function(plr)
    local player = getVehicleOccupant(source, 0)
    if player and isElement(player) then
        if getElementData(player, 'player:job') and getElementData(player, 'player:job') == 'etransporter' then
            cancelEvent()
        end
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if peds[source] and isElement(peds[source]) then
        destroyElement(peds[source])
        peds[source] = nil
    end
end)

addEventHandler("onPedVehicleEnter", resourceRoot, function(veh)
    if getElementType(source) == 'ped' then
        if getElementID(source) and string.find(getElementID(source), 'etransporter') then
            local plr = getVehicleOccupant(veh)
            if plr and isElement(plr) then
                triggerClientEvent(plr, 'since-transporterJob', resourceRoot, 'start')
            end
        end
    end
end)

addEventHandler("onPedVehicleExit", resourceRoot, function(veh)
    if getElementType(source) == 'ped' then
        if getElementID(source) and string.find(getElementID(source), 'etransporter') then
            local plr = getVehicleOccupant(veh)
            if plr and isElement(plr) then
                triggerClientEvent(plr, 'since-transporterJob', resourceRoot, 'end')
            end
        end
    end
end)