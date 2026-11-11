function getRandomValue()
    local random = math.random(1, 3)
    return random..'/'..random*math.floor(math.random(1.5,4))
end

rewardNames = {
    ['weapon'] = 'Broń',
    ['money'] = 'Gotówka',
    ['drugs'] = 'Narkotyki',
}

function loadEvent(...)
    if not isEventHandlerAdded(unpack({...})) then
        addEventHandler(unpack({...}))
    end
end

function removeEvent(...)
    if isEventHandlerAdded(unpack({...})) then
        removeEventHandler(unpack({...}))
    end
end

function getElementsCount(tbl)
    local count = 0
    for i,v in pairs(tbl) do
        count = count + 1
    end
    return count
end

function formatTime(time)
	time = time or 0
	if time <= 0 then
		return '00:00'
	else
		hours = string.format('%02.f', math.floor(time/60))
		mins = string.format('%02.f', math.floor(time - (hours*60)))
		return ''..hours..':'..mins
	end
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function getDistanceBetweenElements(arg1, arg2)
	local element1 = Vector3(getElementPosition( arg1 ))
	local element2 = Vector3(getElementPosition( arg2 ))
	local distance = getDistanceBetweenPoints3D( element1,element2 )
	return distance
end

function getNearestElement(player, type, distance)
    local result = false
    local dist = nil
    if player and isElement(player) then
        local elements = getElementsWithinRange(Vector3(getElementPosition(player)), distance, type, getElementInterior(player), getElementDimension(player))
        for i = 1, #elements do
            local element = elements[i]
            if not dist then
                result = element
                dist = getDistanceBetweenPoints3D(Vector3(getElementPosition(player)), Vector3(getElementPosition(element)))
            else
                local newDist = getDistanceBetweenPoints3D(Vector3(getElementPosition(player)), Vector3(getElementPosition(element)))
                if newDist <= dist then
                    result = element
                    dist = newDist
                end
            end
        end
    end
    return result
end

function dxDrawOctagon3D(x, y, z, radius, width, color)
	if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then
		return false
	end

	local radius = radius or 1
	local radius2 = radius/math.sqrt(2)
	local width = width or 1
	local color = color or tocolor(255,255,255,150)

	point = {}

	for i=1,8 do
		point[i] = {}
	end

	point[1].x = x
	point[1].y = y-radius
	point[2].x = x+radius2
	point[2].y = y-radius2
	point[3].x = x+radius
	point[3].y = y
	point[4].x = x+radius2
	point[4].y = y+radius2
	point[5].x = x
	point[5].y = y+radius
	point[6].x = x-radius2
	point[6].y = y+radius2
	point[7].x = x-radius
	point[7].y = y
	point[8].x = x-radius2
	point[8].y = y-radius2
		
	for i=1,8 do
		if i ~= 8 then
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[i+1].x,point[i+1].y,z
		else
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[1].x,point[1].y,z
		end
		dxDrawLine3D(x, y, z, x2, y2, z2, color, width)
	end
	return true
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end