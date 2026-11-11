local voicePlayers = {}

local sw, sh = guiGetScreenSize()
local zoom = 1920/sw

local range = 30

local blur = exports['since-blur']
local avatars = exports['since-avatars']

local font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom)

local timers = {}

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

function onRender()
	if (not getElementData(localPlayer, "player:spawn")) then 
		return
	end

	local index = 0
	local sX, sY, sZ = getElementPosition(localPlayer)

	for player in pairs(voicePlayers) do
		local rX, rY, rZ = getElementPosition(player)
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ)
		setSoundVolume(player, 50 + ((range/2) - distance))

		local color = tocolor(255, 255, 255, 255)
		if (distance <= range) then
			local diamond = getElementData(player, 'player:diamond')
			local rank = getElementData(player,'player:admin') or 0
        	local rgb = exports['since-core']:getRankColor(rank, diamond)
			local name = RGBToHex(unpack(rgb))..''..getPlayerName(player):gsub("#%x%x%x%x%x%x","")
			local textWidth = dxGetTextWidth(name:gsub("#%x%x%x%x%x%x",""), 1, font)
			local recWidth = textWidth + 20/zoom
			local av = avatars:getPlayerAvatar(getElementData(player, 'player:sid'))
			local sY = (38/zoom) * index
		
			blur:dxDrawBlur(sw - recWidth - 15/zoom, 200/zoom + sY, recWidth, 35/zoom)
			dxDrawRectangle(sw - recWidth - 15/zoom, 200/zoom + sY, recWidth, 35/zoom, tocolor(rgb[1], rgb[2], rgb[3], 50))
			dxDrawRectangle(sw - recWidth - 15/zoom, 200/zoom + sY, recWidth, 35/zoom, tocolor(25, 36, 38, 125))
			dxDrawImage(sw - recWidth - 48	/zoom, 200/zoom + sY, 35/zoom, 35/zoom, av)
			dxDrawText(name, sw - recWidth - 5/zoom, 217/zoom + sY, nil, nil, tocolor(241, 245, 244, 200), 1, font, "left", "center", false, false, false, true)

			if(not isVoiceEnabled(player))then
				voicePlayers[player] = nil
			end
		end

		index = index + 1
	end
end

addEventHandler("onClientPlayerVoiceStart", root, function()
	if (getElementData(source, "player:mute")) then 
		cancelEvent()
		return 
	end

	if (not getElementData(source, "player:spawn")) then 
		cancelEvent() 
		return 
	end

	local localDimension = getElementDimension(localPlayer)
	local localInterior = getElementInterior(localPlayer)
	if(source == localPlayer)then
		if(table.size(voicePlayers) == 0)then
			addEventHandler("onClientRender", root, onRender)
		end

		voicePlayers[source] = true
	else
		local sourceDimension = getElementDimension(source)
		local sourceInterior = getElementInterior(source)
		if(tonumber(localDimension) ~= tonumber(sourceDimension) or tonumber(localInterior) ~= tonumber(sourceInterior))then
			cancelEvent()
			return
		end

		local sX, sY, sZ = getElementPosition(localPlayer)
		local rX, rY, rZ = getElementPosition(source)
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ)
		if(distance <= range)then
			local block = false
			if (block) then
				cancelEvent()
			else
				if (table.size(voicePlayers) == 0) then
					addEventHandler("onClientRender", root, onRender)
				end

				voicePlayers[source] = true
			end
		else
			cancelEvent()
		end
	end
end)

addEventHandler("onClientPlayerVoiceStop", root, function()
	voicePlayers[source] = nil

	if(table.size(voicePlayers) == 0)then
		removeEventHandler("onClientRender", root, onRender)
	end
end)

addEventHandler("onClientPlayerQuit", root,function()
	voicePlayers[source] = nil

	if(table.size(voicePlayers) == 0)then
		removeEventHandler("onClientRender", root, onRender)
	end
end)

function RGBToHex(red, green, blue, alpha)
	
	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end
getResourceName(getThisResource(), true, 532684366); if true then return end