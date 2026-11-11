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

local models = {}

addEvent("giveSrpMushroom", true)
addEventHandler("giveSrpMushroom", resourceRoot, function(srp)
    if srp and srp > 0 then

        if srp and srp > 50 then triggeringBan(client, 'since-mushroomerJob próba nadania dużej ilości srp za kurs') return end

        setElementData(client, 'player:srp', getElementData(client, 'player:srp')+srp)
    end
end)

addEvent('mushroomer', true)
addEventHandler('mushroomer', resourceRoot, function(action, data)
    if action == 'start' then
        if models[client] and isElement(models[client]) then
            destroyElement(models[client])
        end
        local object = createObject(2060, 0, 0, 0)
        setElementCollisionsEnabled(object, false)
        setElementDoubleSided(object, true)
        setObjectScale(object, 0.8)
        exports['since-pattach']:attach(object, client, 23, -0.03, 0.01, 0.62, 90, 180, -5)
        models[client] = object

    elseif action == 'destroy' then
        if models[client] and isElement(models[client]) then
            destroyElement(models[client])
            models[client] = nil
        end
        setPedAnimation(client)
        setElementFrozen(client, false)

    elseif action == 'pickupMushroom' then
        setElementFrozen(client, true)
        setPedAnimation(client, 'COP_AMBIENT', 'Copbrowse_nod', -1, true, false)
		exports['since-pattach']:detach(models[client])
        local x,y,z = getElementPosition(client)
        local rx,ry,rz = getElementRotation(client)
        local x,y,z = getPositionFromElementOffset(client,0.8,0.2,0)
        setElementPosition(models[client],x,y,z-1)
        setElementRotation(models[client],rx,ry,rz)

        setTimer(function(client, data)
            if not isElement(client) then return end
            setPedAnimation(client)
            setElementFrozen(client, false)
            exports['since-pattach']:attach(models[client], client, 23, -0.03, 0.01, 0.62, 90, 180, -5)
            triggerClientEvent(client, 'mushroomer', resourceRoot, 'pickupMushroom', data)
        end, 5000, 1, client, data)

    elseif action == 'sellMushrooms' then
        
        if not checkList[client] then
            checkList[client] = 0
        end
    
        checkList[client] = checkList[client] + 1
    
        if checkList[client] >= 5 then triggeringBan(client, 'since-mushroomerJob zbyt szybkie wywołanie triggera') return end

        if tonumber(data[2]) > 5000000 then triggeringBan(client, 'since-mushroomerJob próba nadania dużej ilości gotówki za kurs') return end

        exports['since-notifications']:sendNotification(client, 'success', 'Sprzedano grzyby w ilości x'..data[1]..' za $'..formatNumber(data[2]))
        givePlayerMoney(client, tonumber(data[2]))
        triggerClientEvent(client, 'mushroomer', resourceRoot, 'selled', data[2])

    end
end)

setTimer(function()
    for i,v in pairs(checkList) do
        checkList[i] = nil
    end
end, 10000, 0)

addEventHandler('onPlayerQuit', root, function()
    if models[source] and isElement(models[source]) then
        destroyElement(models[source])
        models[source] = nil
    end
    if checkList[source] then
        checkList[source] = nil
    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z                               -- Return the transformed point
end

function formatNumber(n)
    n = tostring(n)
    return n:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

--[[

addCommandHandler("gp2", function(plr, cmd)
    local x,y,z = getElementPosition(plr)
    local logs_file
    if not fileExists("gp.txt") then
        fileCreate("gp.txt")
        logs_file = fileOpen("gp.txt")
    else
        logs_file = fileOpen("gp.txt")
    end
    fileSetPos(logs_file, fileGetSize(logs_file))
    fileWrite(logs_file, '{'..string.format('%.2f', x)..', '..string.format('%.2f', y)..', '..string.format('%.2f', z)..'},\n')
    fileFlush(logs_file)
    fileClose(logs_file)
    outputChatBox('Zapisano gp',plr)
end)

]]