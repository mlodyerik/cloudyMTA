

--[[
	Author: EnoNeK
	For: SinceRPG
--]]

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


local objects = {}

local function time()
	local time = getRealTime()
    local s = string.format("%02d", time.hour)..":"..string.format("%02d", time.minute)
    local s1 = string.format("%02d", time.monthday).."."..string.format("%02d", (time.month+1)).."."..(time.year)+1900
	return {time.yearday, s, s1}
	--local time = getRealTime();
	--return ""..(time.monthday).."-"..(time.month+1).."-"..(time.year+1900).." "..time.hour..":"..time.minute.."";
end

function insertObjectToTable(data, name)
	local x,y,z = getElementPosition(client)
	local ox,oy,oz = data[2], data[3], data[4]
	if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz) > 20) then
		triggeringBan(client, 'since-zabezpiczenia')
		return
	end
	local object = createObject(unpack(data))
	objects[object] = {client, name}
	--table.insert(objects, {name, object, client})
	--objects[object] = {object, name, client}
	--objects[client] = object
	triggerClientEvent(root, "setBreakable", resourceRoot, object)
	setElementFrozen(object, true)
	setElementData(object, "object:data", {owner=getPlayerName(client):gsub("#%x%x%x%x%x%x", ""), date=time()})
end
addEvent("fractions:object:createObject", true)
addEventHandler("fractions:object:createObject", resourceRoot, insertObjectToTable)

function deleteObjectTable(name)
	for i,v in pairs(objects) do
		if (v[1] == client and v[2] == name) then
			objects[i] = nil
			destroyElement(i)
		end
	end
end
addEvent("fractions:object:deleteObject", true)
addEventHandler("fractions:object:deleteObject", resourceRoot, deleteObjectTable)

function destroyObjects(player)
	triggerClientEvent(player, "enonek-zabezpieczenia:toggleUI", resourceRoot)
	for i,v in pairs(objects) do
		if (v[1] == player) then
			objects[i] = nil
			if (isElement(i)) then
				destroyElement(i)
			end
		end
	end
end

addEvent("enonek-fractionsobject:destroys", true)
addEventHandler("enonek-fractionsobject:destroys", resourceRoot, function(player)
	if (isElement(objects[source][1])) then
		triggerClientEvent(objects[source][1], "enonek-zabezpieczenia:minus", resourceRoot, objects[source][2])
	end
	objects[source] = nil
	destroyElement(source)
end)

addEventHandler("onPlayerQuit", root, function()
	if getElementData(source, "player:faction") then
		for i,v in pairs(objects) do
			if (v[1] == source) then
				objects[i] = nil
				if (isElement(i)) then
					destroyElement(i)
				end
			end
		end
	end
end)