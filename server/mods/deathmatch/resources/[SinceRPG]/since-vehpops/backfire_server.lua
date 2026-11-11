local CarsSettings = {}

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end
 
	return false
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

local bytes = {["2"] = true, ["6"] = true, ["A"] = true, ["E"] = true}
function isDoubleExhauts (veh)
    local handling = getVehicleHandling (veh)["modelFlags"]
    local newHandling = string.format ("%X", handling)
    local reversedHex = string.reverse ( newHandling )..string.rep ( "0", 8 - string.len ( newHandling ) )
	
    local byte4 = string.sub(reversedHex, 4, 4)
    if bytes[byte4] then
        return true
    else
        return false
    end
end

addEvent ( "create3DBackfireSound", true )
addEventHandler ( "create3DBackfireSound", resourceRoot,
	function ( theVehicle)
		if ( theVehicle ) then
			local vehicleData = getElementData(theVehicle, "vehicle:upgrades") or {}

			if not vehicleData['exhaust'] then
				return
			end

			local vehicleName = getVehicleName( theVehicle )
			local isExhaust = isDoubleExhauts(theVehicle)
			
			triggerClientEvent(root, "create3DBackfireSoundClient", resourceRoot, theVehicle, isExhaust)
		end
	end
)

function startMonitoring ( thePlayer, seat, jacked )
	if (seat == 0) then
		local vehicleData = getElementData(source, "vehicle:upgrades") or {}

		if not vehicleData['exhaust'] then
			return
		end

		triggerClientEvent(thePlayer, "chandeMonitoringState", resourceRoot, true, source)
	end
end
addEventHandler ( "onVehicleEnter", getRootElement(), startMonitoring )
 
function stopMonitoring ( thePlayer, seat, jacked )
    if (seat == 0) then
		local vehicleData = getElementData(source, "vehicle:upgrades") or {}

		if not vehicleData['exhaust'] then
			return
		end

		triggerClientEvent(thePlayer, "chandeMonitoringState", resourceRoot, false)
	end
end
addEventHandler ( "onVehicleExit", getRootElement(), stopMonitoring )