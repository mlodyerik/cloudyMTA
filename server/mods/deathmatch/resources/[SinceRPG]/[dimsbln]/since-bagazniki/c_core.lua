function getNearestVehicle(player, distance)
	local tempTable = {}
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)
	local vehicles = getElementsWithinRange(px, py, pz, distance + 10, "vehicle")

	for _,v in pairs(vehicles) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	return nearestVeh
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

local tick = getTickCount()
local timeout = 1000

bindKey("b", "down", function()
	if (getElementData(localPlayer, "player:job") or getElementData(localPlayer, "player:jail")) then
		return exports['since-notifications']:sendNotification('error', 'Nie możesz tego zrobić.')
	end

	local veh = getNearestVehicle(localPlayer, 5)

	if not veh then
		return exports['since-notifications']:sendNotification('error', 'Nie ma wokól ciebie żadnego pojazdu')
	end
	
	if getVehicleDoorOpenRatio(veh,1) == 0 then
		return
	end

	if getPedOccupiedVehicle(localPlayer) then
		return
	end

	if getElementSpeed(veh, "km/h") > 2 then
		return exports['since-notifications']:sendNotification('error', 'Nie możesz wsiasc do pojazdu, który się porusza')
	end

	if tick + timeout > getTickCount() then
		return
	end

	tick = getTickCount()

	triggerServerEvent("toggleTrunk", resourceRoot)
end)