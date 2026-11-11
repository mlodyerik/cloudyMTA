local zgloszenia = {}
local commands = {

	{'SARA', 'wezwij.sara'},
	{'SAPD', 'wezwij.sapd'},
	{'SAFD', 'wezwij.safd'},

}

function findZgloszenie(uid)
	for i, v in ipairs(zgloszenia) do 
		if v.uid == uid then 
			return i
		end
	end
end

function refresh()
	for i, v in ipairs(zgloszenia) do 
		local players = getElementsByType('player')

		for _, plr in ipairs(players) do 
			if getElementData(plr, 'player:faction') == v.faction then 
				triggerClientEvent(plr, 'createFactionMarker', resourceRoot, v.pos[1], v.pos[2], v.pos[3], v.uid)
			end
		end
	end
end
setTimer(refresh, 5000, 0)

addEvent('onFactionMarkerHit', true)
addEventHandler('onFactionMarkerHit', resourceRoot, function(markerID, markerUID)
	if not markerID then 
		return 
	end
	
	local players = getElementsByType('player')
	local faction = getElementData(client, 'player:faction')

	for i, v in ipairs(players) do
		if getElementData(v, 'player:faction') == faction then
			triggerClientEvent(v, 'destroyFactionMarker', resourceRoot, markerID, markerUID)
		end

		if getElementData(v, 'player:sid') == markerUID then 
			outputChatBox(' ', client, 155, 255, 155, true)
			outputChatBox('✓ #FFFFFFSłużby dotarły na miejsce twojego wezwania.', client, 55, 255, 55, true)
			outputChatBox(' ', client, 155, 255, 155, true)
		end
	end

	local player = findZgloszenie(markerUID)

	if player then 
		table.remove(zgloszenia, player)
	end

	outputChatBox(' ', client, 155, 255, 155, true)
	outputChatBox('✓ #FFFFFFDocierasz na miejsce wezwania.', client, 55, 255, 55, true)
	outputChatBox(' ', client, 155, 255, 155, true)
end)

function createMarkerForFaction(plr, faction, x, y, z)
	if not getElementData(plr, 'player:spawn') then 
		return 
	end

	if not x or not y or not z then 
		return 
	end

	if not faction then 
		return 
	end

	local players = getElementsByType('player')
	local uid = getElementData(plr, 'player:sid')

	for i, v in ipairs(players) do
		if getElementData(v, 'player:faction') == faction then
			triggerClientEvent(v, 'createFactionMarker', resourceRoot, x, y, z, uid)
		end
	end
end

function reportToFaction(plr, faction, ...)
	if not getElementData(plr, 'player:spawn') then 
		return 
	end

	local message = table.concat({...}, ' ')
	local message = message:gsub('#%x%x%x%x%x%x', '')

	if not message or message == '' or message == ' ' then 
		return outputChatBox('✘ #FFFFFFWprowadź treść zgłoszenia', plr, 255, 25, 25, true)
	end

	if findZgloszenie(getElementData(plr, 'player:sid')) then 
		return outputChatBox('✘ #FFFFFFJuż wysłałeś jedno wezwanie', plr, 255, 25, 25, true)
	end

	local x, y, z = getElementPosition(plr)
	local int = getElementInterior(plr)
	local dim = getElementDimension(plr)
	local location = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)

	if int ~= 0 or dim ~= 0 then 
		return outputChatBox('✘ #FFFFFFNie możesz zrobić tego w tym miejscu', plr, 255, 25, 25, true)
	end

	local players = getElementsByType('player')

	for i, v in ipairs(players) do 
		if getElementData(v, 'player:faction') == faction then 
			outputChatBox(' ', v, 255, 175, 0, true)
			outputChatBox('⚠ Wezwanie #FFFFFFGracz '..getPlayerName(plr):gsub('#%x%x%x%x%x%x', '')..' zgłasza: #b0b0b0'..message..'#ffffff - Lokalizacja: #b0b0b0'..location, v, 255, 175, 0, true)
			outputChatBox(' ', v, 255, 175, 0, true)
		end
	end

	outputChatBox(' ', plr, 155, 255, 155, true)
	outputChatBox('✓ #FFFFFFWysłano wezwanie do #4db2ff'..faction..'#ffffff o treści: #b0b0b0'..message..'.', plr, 55, 255, 55, true)
	outputChatBox(' ', plr, 155, 255, 155, true)

	createMarkerForFaction(plr, faction, x, y, z)

	table.insert(zgloszenia, {uid = getElementData(plr, 'player:sid'), nick = getPlayerName(plr):gsub('#%x%x%x%x%x%x', ''), pos = {x, y, z}, message = message, faction = faction})
end

addEventHandler('onPlayerQuit', root, function()
	local uid = getElementData(source, 'player:sid')
	local index = findZgloszenie(uid)

	if index then 
		table.remove(zgloszenia, index)
	end
end)

for i, v in ipairs(commands) do 
	addCommandHandler(v[2], function(plr, cmd, ...)
		reportToFaction(plr, v[1], ...)
	end)
end