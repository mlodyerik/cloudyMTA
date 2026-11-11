  

--[[
    Author: EnoNeK
    For: cloudyMTA
]]

--[[if getElementData(localPlayer, "player:sid") == 25 then

else
    return false
end]]

function pobierzPozycjeKol(veh, kolo)
	local x, y, z = 0, 0, 0
	if not veh then return end
	local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(veh)
	if kolo == 1 then
		x, y, z = pobierzPozycje(veh, x1, y2, z1)
	elseif kolo == 2 then
		x, y, z = pobierzPozycje(veh, x1, -y2, z1)		
	elseif kolo == 3 then
		x, y, z = pobierzPozycje(veh, x2, y2, z1)
	elseif kolo == 4 then
		x, y, z = pobierzPozycje(veh, x2, -y2, z1)
	end	 
	return x, y, z
end

function pobierzPozycje(plr, x, y, z)
	if not x or not y or not z then      
		return x, y, z   
	end        
	local matrix = getElementMatrix(plr)
	local pozX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
	local pozY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
	local pozZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
	return pozX, pozY, pozZ
end

local function preRender()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local x, y, z = getElementPosition(vehicle)
		local objects = getElementsWithinRange(x, y, z, 5, "object")
		if not objects or #objects == 0 then
			return false
		end
		
		local wx1, wy1, wz1 = pobierzPozycjeKol(vehicle, 1)
		local wx2, wy2, wz2 = pobierzPozycjeKol(vehicle, 2)
		local wx3, wy3, wz3 = pobierzPozycjeKol(vehicle, 3)
		local wx4, wy4, wz4 = pobierzPozycjeKol(vehicle, 4)
		local fl, rl, fr, rr = getVehicleWheelStates(vehicle)
		for k, v in ipairs(objects) do
			if getElementModel(v) == 2899 and getElementData(v, "caltrop") then
				local xo, yo, zo = getElementPosition(v)
				if getDistanceBetweenPoints3D(wx1, wy1, wz1, xo, yo, zo) <= 2.5 and (fl == 0) then
					triggerServerEvent("enonek-kolczatka:break", resourceRoot, vehicle, 1, -1, -1, -1)
				end
				if getDistanceBetweenPoints3D(wx2, wy2, wz2, xo, yo, zo) <= 2.5 and (rl == 0) then
					triggerServerEvent("enonek-kolczatka:break", resourceRoot, vehicle, -1, 1, -1, -1)
				end
				if getDistanceBetweenPoints3D(wx3, wy3, wz3, xo, yo, zo) <= 2.5 and (fr == 0) then
					triggerServerEvent("enonek-kolczatka:break", resourceRoot, vehicle, -1, -1, 1, -1)
				end
				if getDistanceBetweenPoints3D(wx4, wy4, wz4, xo, yo, zo) <= 2.5 and (rr == 0) then
					triggerServerEvent("enonek-kolczatka:break", resourceRoot, vehicle, -1, -1, -1, 1)
				end		
			end										
		end
	end
end

local function addEv(...)
	if not isEventHandlerAdded(...) then
		addEventHandler(...)
	end
end

local function removeEv(...)
	if isEventHandlerAdded(...) then
		removeEventHandler(...)
	end
end

addEventHandler("onClientVehicleEnter", root, function(ped, seat)
	if ped == localPlayer and seat == 0 then
		addEv("onClientPreRender", root, preRender)
	end
end)

addEventHandler("onClientVehicleExit", root, function(ped, seat)
	if ped == localPlayer and seat == 0 then
		removeEv("onClientPreRender", root, preRender)
	end
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
getResourceName(getThisResource(), true, 273998174); if true then return end