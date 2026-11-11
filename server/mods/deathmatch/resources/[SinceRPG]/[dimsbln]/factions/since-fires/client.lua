getResourceName(getThisResource(), true, 724949419); --if true then return end

local effects = {}
local timers = {}

addEventHandler("onClientElementStreamIn", resourceRoot, function()
	if (getElementType(source) == "ped") then
		local x, y, z = getElementPosition(source)
		effects[source] = {createEffect("fire", x, y, z-0.5, 0, 0, 0, 150, true), createEffect("smoke50lit", x, y, z-0.5, 0, 0, 0, 150, false)}
		timers[source] = setTimer(function(ped)
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if (vehicle and ped) then
				setElementCollidableWith(ped, vehicle, false)
				setElementCollidableWith(vehicle, ped, false)
			end
		end, 1000, 0, source)

		setElementCollidableWith(source, localPlayer, false)
		setElementCollidableWith(localPlayer, source, false)
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (vehicle) then
			setElementCollidableWith(source, vehicle, false)
			setElementCollidableWith(vehicle, source, false)
		end
	end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
	if (getElementType(source) == "ped") then
		destroyElement(effects[source][1])
		destroyElement(effects[source][2])
		effects[source] = nil
		killTimer(timers[source])
		timers[source] = nil
	end
end)

addEventHandler("onClientPedHitByWaterCannon", root, function(ped)
	if (getElementType(ped) == "ped" and getElementData(localPlayer, "player:faction") == "SAFD" and getElementData(ped, "fire") and getElementData(source, "vehicle:linia:owner") == localPlayer and effects[ped]) then
		cancelEvent()
		local health = getElementHealth(ped)
		if (health <= 5) then
			triggerServerEvent("fire:destroy", resourceRoot, ped)
			return false
		end

		triggerServerEvent("fire:damage", resourceRoot, ped)
	end
end)

addEventHandler("onClientElementDestroy", resourceRoot, function()
	if (getElementType(source) == "ped") then
		if (effects[source]) then
			destroyElement(effects[source][1])
			destroyElement(effects[source][2])
			effects[source] = nil
			killTimer(timers[source])
			timers[source] = nil
		end
	end
end)