  

local SELF_VISIBLE = false -- Want to see your own message?
local TIME_VISIBLE = 8500 -- in miliseconds
local DISTANCE_VISIBLE = 15
local ROUND = true -- Rounded rectangle(true) or not(false)
local ANIMATION_DURATION = 2000

local messages = {} -- {text, player, lastTick, alpha, yPos}
local nowTick -- Tick count cache
local x, y, z -- Local player position cache

addEvent('onChatIncome', true)
addEventHandler('onChatIncome', root,
	function(message, messagetype)
		if source ~= localPlayer or SELF_VISIBLE then
			if getElementData(localPlayer, 'player:mute') then
				return
			end
			
			addBubble(message, source, getTickCount())
		end
	end
)

addEvent('onChatbubblesMessageIncome',true)
addEventHandler('onChatbubblesMessageIncome',root,function (msg,plr)
	addBubble(msg,plr,getTickCount())
end)

local font = exports['since-fonts']:getFont('Inter-Medium', 9)

function addBubble(text, player, tick)
	if (not messages[player]) then
		messages[player] = {}
	end

	local _texture = nil
	if ROUND then
		local width = dxGetTextWidth(text:gsub('#%x%x%x%x%x%x', ''), 1, font)
		_texture = dxCreateRoundedTexture(width+16, 20, 100)
	end

	table.insert(messages[player], {
		['text'] = exports['since-core']:replaceWords(text),
		['player'] = player,
		['tick'] = tick,
		['alpha'] = 0,
		['texture'] = _texture
	})
end

addEventHandler('onClientRender', root, function()
	nowTick = getTickCount()
	x, y, z = getElementPosition(localPlayer)

	for player, playerMessages in pairs(messages) do
		if (isElement(player)) then
			for index, message in ipairs(playerMessages) do
				handleDrawMessage(message, index)
			end
		else
			removePlayerMessages(player)
		end
	end
end)

function handleDrawMessage(message, index)
	if (nowTick - message.tick) > TIME_VISIBLE then
		removePlayerMessage(message.player, index)
		return
	end

	if not shouldDrawPlayerMessage(message.player) then
		return
	end

	local bx, by, bz = getPedBonePosition(message.player, 8)
	local sx, sy = getScreenFromWorldPosition(bx, by, bz + 0.50)

	if not sx or not sy then
		return
	end

	message.alpha = message.alpha < 250 and message.alpha + 5 or message.alpha

	local elapsedTime = nowTick - message.tick
	local progress = elapsedTime / TIME_VISIBLE

	if not message.yPos then
		message.yPos = sy
	end

	--local yPos = interpolateBetween ( message.yPos, 0, 0, sy - 22*index, 0, 0, progress, 'OutElastic')
	
    local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(bx, by, bz)) - 5, 0)
	local mesh = math.min(math.max(dist/3 - 1, 1.8), 2.5)
	local textWidth = dxGetTextWidth(message.text:gsub('#%x%x%x%x%x%x', ''), 1, font)
	local yPos = outElastic(elapsedTime, message.yPos, (sy - (30/(mesh))*index) - message.yPos, ANIMATION_DURATION, 5)
	local finalContainerX, finalContainerY = sx - textWidth/2 - 10, yPos - 16
	local finalContainerWidth, finalContainerHeight = textWidth + 16, 20

	local scale = 1 - dist / 20
    if scale < 0.2 then return end

	dxDrawText(message.text:gsub("#%x%x%x%x%x%x", ''), finalContainerX + 1, finalContainerY + 1, finalContainerX + finalContainerWidth + 1, finalContainerY + finalContainerHeight + 1, tocolor(0, 0, 0, message.alpha*scale), scale, font, 'center', 'bottom', false, false, false, true, true)
	dxDrawText(message.text, finalContainerX, finalContainerY, finalContainerX + finalContainerWidth, finalContainerY + finalContainerHeight, tocolor(255, 255, 255, message.alpha*scale), scale, font, 'center', 'bottom', false, false, false, true, true)
end

function removePlayerMessage(player, index)
	if ROUND then
		messages[player][index].texture:destroy()
	end

	table.remove(messages[player], index)
end

function shouldDrawPlayerMessage(player)
	local px, py, pz = getElementPosition(player)

	return getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= DISTANCE_VISIBLE
		and isLineOfSightClear(x, y, z, px, py, pz, true, not isPedInVehicle(player), false, true)
end

function removePlayerMessages(player)
	if ROUND then
		for index, message in ipairs(messages[player]) do
			message.texture:destroy()
		end
	end

	messages[player] = nil
end
getResourceName(getThisResource(), true, 729133679); if true then return end