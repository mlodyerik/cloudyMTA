function getNearestVehicle(player, distance)
	local tempTable = {}
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)
	local vehicles = getElementsWithinRange(px, py, pz, distance + 10, "vehicle")

	for _,v in pairs(vehicles) do
		local vint, vdim = getElementInterior(v), getElementDimension(v)
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

function getVehicleTrunkPosition(vehicle, adding)
	local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)

	local x = x - (4 + adding) * math.cos(math.rad(rz + 90))
	local y = y - (4 + adding) * math.sin(math.rad(rz + 90))
	local z = z - 0.5

	return x, y, z
end

function isTrunkClosed(vehicle)
	return getVehicleDoorOpenRatio(vehicle, 1) == 0
end

players = {}

addEvent("toggleTrunk", true)
addEventHandler("toggleTrunk", resourceRoot, function()
	if source == resourceRoot then
		local veh = getNearestVehicle(client, 5)
		local x, y, z = getVehicleTrunkPosition(veh, -0.8)
		local rx, ry, rz = getElementRotation(veh)
	
		local shape = createColSphere(x, y, z + 0.5, 0.8)

		local x, y, z = getVehicleTrunkPosition(veh, 0.5)
	
		if not players[client] or players[client] == false then
			if isElementWithinColShape(client, shape) then
				setElementPosition(client, x, y, z)
				setElementRotation(client, 0, 0, 0)
				setPedAnimation(client, "CRACK", "crckidle2", -1, true, false)
				setElementCollisionsEnabled(client, false)

				attachElements(client, veh, 0, -1.75, 0.8, 90, 0, 0)
				
				players[client] = true
				setElementData(client, "inTrunk", veh)
			end
		else
			if isTrunkClosed(veh) then
				return exports['since-notifications']:sendNotification(client, 'error', 'Bagażnik jest zamknięty')
			end

			detachElements(client)
			setPedAnimation(client, false)
			setElementCollisionsEnabled(client, true)
			setElementPosition(client, x, y, z + 1)
	
			players[client] = false

			setElementData(client, "inTrunk", false)
		end
	
		destroyElement(shape)
	end
end)