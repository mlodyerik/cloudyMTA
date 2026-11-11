  

local lastPlayerPositions = {}

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function isPlayerDrivingInCircle(player)
    local vehicle = getPedOccupiedVehicle(player)
    
    if not vehicle then
        return false
    end

    if getElementSpeed(vehicle, 1) >= 20 then
        local vehiclePosition = {getElementPosition(vehicle)}
        local playerPosition = {getElementPosition(player)}
    
        local minDistance = 15
    
        local lastPosition = lastPlayerPositions[player]
    
        if lastPosition then
            local distance = getDistanceBetweenPoints2D(lastPosition[1], lastPosition[2], playerPosition[1], playerPosition[2])
    
            if distance < minDistance then
                return true
            end
        end
    
        lastPlayerPositions[player] = playerPosition
    end

    return false
end

function checkPlayersDrivingInCircle(plr)
    if isPlayerDrivingInCircle(plr) then
        return true
    else
        return false
    end
end

local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

local shaders = {}
local wasAt = {}

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

local function didIWasAt(px, py, pz)
	for k,v in pairs(wasAt) do
		if getDistanceBetweenPoints3D(px, py, pz, v[1], v[2], v[3]) < 2.5 then
			return true
		end
	end
	return false
end

local function isVehicleReversing(theVehicle)
    local getMatrix = getElementMatrix (theVehicle)
    local getVelocity = Vector3 (getElementVelocity(theVehicle))
    local getVectorDirection = (getVelocity.x * getMatrix[2][1]) + (getVelocity.y * getMatrix[2][2]) + (getVelocity.z * getMatrix[2][3])
    if (getVectorDirection < 0) then
        return true
    end
    return false
end

function getSurface(veh)
	if isElement(veh) then
        local cx, cy, cz = getElementPosition(veh)
        local gz = getGroundPosition(cx, cy, cz)-0.001
        local hit, _, _, _, _, _, _, _, surface = processLineOfSight(cx, cy, gz+0.1, cx, cy, gz)
        if hit then
            return surface
        end
    end
    return false
end

local time,timelicz=getTickCount(), getTickCount()

local function naliczaj(veh)
	if checkPlayersDrivingInCircle(localPlayer) then
		return
	end
	if getTickCount()-time > 2000 then
		time = getTickCount()
		local snow = getElementData(localPlayer, "player:snieg")
		local vx,vy,vz = getElementVelocity(veh)
		local spd=((vx^2 + vy^2 + vz^2)^(0.5)/2)
		if spd>0 then
			--outputChatBox("speed good")
			local x, y, z = getPositionFromElementOffset(veh, 0, 2, 0)
			if not didIWasAt(x, y, z) then
				--outputChatBox("dup[a")
				snow = snow+(spd)
				setElementData(localPlayer, "player:snieg", snow)
			end
		end
	end

	--[[if getTickCount() - timelicz > 250 then
		timelicz = getTickCount()
		local x, y, z = getPositionFromElementOffset(veh, 0, -2, 0)
		table.insert(wasAt, {x, y, z})
	end]]
end

local surfaces = {
	[0] = true,
	[1] = true,
	[4] = true,
	[2] = true,
	[3] = true,
	[5] = true,
	[7] = true,
	[34] = true, 
	[89] = true, 
	[165] = true,
}

function render()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and getElementData(vehicle, "vehicle:job") == "odsniezarki" then
		local surface = getSurface(vehicle)
		local sxx, syy, szz = getElementVelocity(vehicle)
		local predkosc = (sxx^2 + syy^2 + szz^2)^(0.5)
		local speed = predkosc * 158
		dxDrawText("Przebyty dystans", sx/2 + 1, sy - 135/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), "center", "bottom", false, false, false, false)
		dxDrawText(""..string.format("%.2f", getElementData(localPlayer, "player:snieg")).." km", sx/2 + 1, sy - 135/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "center", "top", false, false, false, false)
		dxDrawText("Przebyty dystans", sx/2, sy - 135/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), "center", "bottom", false, false, false, false)
		dxDrawText(""..string.format("%.2f", getElementData(localPlayer, "player:snieg")).." km", sx/2, sy - 135/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "center", "top", false, false, false, false)
		
		local text = ""
		if math.floor(speed) > 60 then
			text = "Nie możesz przekroczyć 60 km/h"
		elseif math.floor(speed) < 50 then
			text = "Musisz jechać więcej niż 50 km/h"
		elseif not surfaces[surface] then
			text = "Na terenach innych niż twarde odśnieżanie jest niemożliwe"
		elseif isVehicleReversing(vehicle) then
			text = "Nie możesz odśnieżać tyłem"
		else
			text = ""
			naliczaj(vehicle)
		end

		dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), sx/2 + 1, sy - 98/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "center", "bottom", false, false, false, true)
		dxDrawText(text, sx/2, sy - 98/zoom, nil, nil, tocolor(125, 255, 125, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "center", "bottom", false, false, false, true)
	end
end

addEvent("enonek-odsniezarki:start", true)
addEventHandler("enonek-odsniezarki:start", resourceRoot, function()
	tex = {
		[1] = dxCreateTexture("data/textures/bg.png"),
		[2] = dxCreateTexture("data/textures/line.png"),
		[3] = dxCreateTexture("data/textures/logo.png"),
	}
	
	fonts = {
		[1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
		[2] = exports['since-fonts']:getFont('Inter-Bold', 17/zoom),
	}
	addEventHandler("onClientRender", root, render)
end)

addEvent("enonek-odsniezarki:end", true)
addEventHandler("enonek-odsniezarki:end", resourceRoot, function()
	removeEventHandler("onClientRender", root, render)
	for i,v in ipairs(tex) do
		if isElement(v) then
			destroyElement(v)
		end
	end

	if (maskTexture) then
		destroyElement(maskTexture)
	end
	maskTexture = nil

	tex = {}
	fonts = {}
	wasAt = {}

	triggerEvent('onJobFinish', resourceRoot, 'odsniezarki')
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	collectgarbage()
end)

local data = {}

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'odsniezarki' then
		if getElementData(localPlayer, 'player:srp') < 300 then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz 300 srp')
			return
		end
		local licenses = getElementData(localPlayer, 'player:licenses') or {}
		if not licenses['b'] then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz prawa jazdy kat. B')
			return
		end
		
        data.timer = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('odsniezarki', 1)
        end, 60000, 0)

		triggerServerEvent('odsniezarki.s', resourceRoot, 'start')

		setElementData(localPlayer, 'player:job', job)
        exports['since-notifications']:sendNotification('success', 'Rozpoczęto prace')
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'odsniezarki' then
		if data.timer then
            if isTimer(data.timer) then
                killTimer(data.timer)
            end
            data.timer = nil
        end

		triggerServerEvent('odsniezarki.s', resourceRoot, 'stop')

		setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('success', 'Zakończono prace')
    end
end)

local marker = createMarker(620.87, 1225.63, 11.89-0.90, 'cylinder', 2, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Odśnieżarki')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    exports["since-jobs"]:showJobGui("odsniezarki", source)
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

getResourceName(getThisResource(), true, 673964721); if true then return end