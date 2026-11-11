function formatPlayers(count)
    local count = tostring(count)
    if #count == 1 then
        return '#4a944a00#2E756F'..count
    elseif #count == 2 then
        return '#4a944a0#2E756F'..count
    else
        return '#2E756F'..count
    end
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f, t, easing, duration, onChange, onEnd)
	assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
	assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
	assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
	table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims, a)
	end
end

addEventHandler("onClientRender", root, function( )
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims, k)
		end
	end
end)

function getPlayersBySort(sort, edit)
	local players = {}

	if (sort == 'all') then
		players = getElementsByType('player')
	elseif (sort == 'administrations') then
		for i, player in ipairs(getElementsByType('player')) do
			if (getElementData(player, 'player:admin')) then
				table.insert(players, player)
			end
		end
	elseif (sort == 'factions') then
		for i, player in ipairs(getElementsByType('player')) do
			if (getElementData(player, 'player:faction')) then
				table.insert(players, player)
			end
		end
	elseif (sort == 'diamond') then
		for i, player in ipairs(getElementsByType('player')) do
			if (getElementData(player, 'player:diamond')) then
				table.insert(players, player)
			end
		end
	end

	table.sort(players, function(a, b)
		if (isElement(a) and isElement(b)) then
			return (getElementData(a, 'id') and getElementData(a, 'id') or 0) < (getElementData(b, 'id') and getElementData(b, 'id') or 0)
		end
	end)

	local players_ = {}

	for i, v in pairs(players) do
		if getPlayerName(v):lower():find(exports['since-gui']:getEditboxText(edit):lower()) or tostring(getElementData(v, 'id') or 0):lower():find(exports['since-gui']:getEditboxText(edit)) then
            table.insert(players_, v)
        end
	end

	return players_
end

function hexToRGB(hex)
    hex = hex:gsub("#","")
    return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end

function rainbowColorizeString(inputString, frequency)
    local curtime = getTickCount() / 1000
    local rainbowColors = {}

    for i = 1, #inputString do
        local charTimeOffset = i * 0.1
        local r = math.floor(math.sin((curtime + charTimeOffset) * frequency + 0) * 127 + 128)
        local g = math.floor(math.sin((curtime + charTimeOffset) * frequency + 2) * 127 + 128)
        local b = math.floor(math.sin((curtime + charTimeOffset) * frequency + 4) * 127 + 128)

        local hexColor = string.format("#%02X%02X%02X", r, g, b)
        table.insert(rainbowColors, hexColor)
    end

    local coloredString = ""

    for i = 1, #inputString do
        local char = inputString:sub(i, i)
        coloredString = coloredString .. rainbowColors[i] .. char
    end

    return coloredString
end

function getPlayerStatus(plr)
    if getElementData(plr, 'player:afk') then
        local afkTime = tonumber(getElementData(plr, 'player:afk:time') or 0)
        return 'AFK od: #ee99ff'..timeFormat(afkTime)
    elseif getElementData(plr, 'player:job') then
        local jobName = exports['since-jobs']:getJobName(getElementData(plr, 'player:job'))
        return 'Pracuje jako: #2E756F'..jobName
    else
        local sessionTime = tonumber(getElementData(plr, 'player:actualSesion') or 0)
        return 'W grze od: #ffce7a'..timeFormat(sessionTime)
    end
end

function timeFormat(time)
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time - hours * 3600) / 60)
    local seconds = math.floor(time - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function checkIsFriend(plr)
    local friends = getElementData(localPlayer, 'player:friends') or {}

    if #friends == 0 then
        return false
    end

    if friends and type(friends) == 'table' then
        for i,v in pairs(friends) do
            if getElementData(plr, 'player:sid') == v[1] then
                return true
            end
        end
    end

    return false
end