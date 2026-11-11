local wheellock = {}

local object = {}

invalidModels = {[472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [592]=true, [577]=true, [511]=true,
[512]=true, [593]=true, [520]=true, [553]=true, [476]=true, [519]=true, [460]=true, [513]=true, [548]=true, [425]=true, [487]=true, [417]=true, [488]=true, [497]=true, [563]=true,
[432]=true, [590]=true, [538]=true, [570]=true, [569]=true, [537]=true, [449]=true, [539]=true, [557]=true, [556]=true, [444]=true, [464]=true, [441]=true,
[571]=true, [457]=true, [591]=true, [450]=true, [435]=true, [608]=true, [611]=true, [584]=true, [610]=true, [607]=true, [606]=true, [564]=true, [465]=true, [501]=true, [594]=true,
[586]=true, [468]=true, [448]=true, [461]=true, [522]=true, [510]=true, [463]=true, [521]=true, [462]=true, [481]=true, [509]=true, [581]=true, }

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element ) 
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1] 
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z 
end

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

function whellock(plr, cmd)
    if getElementData(plr, 'player:faction') == 'SAPD' or getElementData(plr, 'player:faction') == 'SARA' then
    	if getElementData(plr, 'zakladanie:blokady') then
    		return
    	end
    	local veh = getPedOccupiedVehicle(plr)
    	if veh then
    		outputChatBox('#ff0000✘#FFFFFF Nie możesz nałożyć blokady na koło będąc w pojeździe!', plr, 255, 255, 255, true)
    		return
    	end

    	local x, y, z = getElementPosition(plr)
    	local vehiclerange = getElementsWithinRange(x, y, z, 3, 'vehicle')

    	if #vehiclerange > 1 then
    		outputChatBox('#ff0000✘#FFFFFF Znaleziono więcej niż jeden pojazd w pobliżu!', plr, 255, 255, 255, true)
    		return
    	end

    	for i, v in ipairs(vehiclerange) do
    		vehicle = v
    	end

    	if (invalidModels[getElementModel(vehicle)]) then
    		outputChatBox('#ff0000✘#FFFFFF Nie możesz założyć blokady na ten model pojazdu!', plr, 255, 255, 255, true)
    		return
    	end

    	if getElementSpeed(vehicle, 1) > 5 then
    		return
    	end

    	if getElementData(vehicle, 'blokada:kola') then
    		triggerClientEvent(plr, 'getWheelPosition', resourceRoot, vehicle, 2)
    	else
    		triggerClientEvent(plr, 'getWheelPosition', resourceRoot, vehicle, 1)
    	end
    else
    	outputChatBox('#ff0000✘#FFFFFF Blokadę na koło może założyć tylko frakcja #2b78ffSAPD#ffffff, bądź #ff9900SARA#ffffff!', plr, 255, 255, 255, true)
    end
end
addCommandHandler('blokada', whellock)

function toggleWheelBlock(plr, veh)
	if getElementData(veh, 'blokada:kola') then
		triggerClientEvent(plr, 'getWheelPosition', resourceRoot, veh, 2)
	end
end

wheellock.callback = function(vehicle, x, y, z, x2, y2, z2, type)
	local model = getElementModel(vehicle)
	local xo, yo, zo = getPositionFromElementOffset(vehicle, -1.6, y, 0)
	if type == 1 then
		if isElement(object[vehicle]) then
		return end
		setElementFrozen(vehicle, true)
		--setElementPosition(client, x2, y2+1, z2)
		setElementPosition(client, xo, yo, zo)
		setPedAnimation(client, "COP_AMBIENT", "Copbrowse_nod", -1, true, false )
		setElementData(client, "zakladanie:blokady", true)

		setTimer(function(client)
			local name = getPlayerName(client) 
			setPedAnimation(client, false)
			outputChatBox('#00ff00✔#ffffff Założyłeś(aś) blokadę na koło w pojeździe #cccccc'..exports['since-vehiclenames']:getVehicleName(model)..'#ffffff.', client, 255, 255, 255, true)
			object[vehicle] = createObject(1832, 0, 0, 0)
			attachElements(object[vehicle], vehicle, x, y, z+0.15)
			setElementData(vehicle, "blokada:kola", true)
			setElementData(object[vehicle], "blokada:zalozona:przez", name)
			removeElementData(client, "zakladanie:blokady")
		end, 3500, 1, client)
	end
	if type == 2 then
		if isElement(object[vehicle]) then
			--setElementPosition(client, x2, y2+1, z2)
			setElementPosition(client, xo, yo, zo)
			setPedAnimation(client, "COP_AMBIENT", "Copbrowse_nod", -1, true, false )
			setElementData(client, "zakladanie:blokady", true)

			setTimer(function(client)
				setPedAnimation(client, false)
				destroyElement(object[vehicle])
				outputChatBox('#00ff00✔#ffffff Zdjąłeś(aś) blokadę z koła w pojeździe #cccccc'..exports['since-vehiclenames']:getVehicleName(model)..'#ffffff.', client, 255, 255, 255, true)
				removeElementData(vehicle, "blokada:kola")
				setElementFrozen(vehicle, false)
				removeElementData(client, "zakladanie:blokady")
			end, 3500, 1, client)
		end
	end
end
addEvent("callbackwheelposition", true)
addEventHandler("callbackwheelposition", resourceRoot, wheellock.callback)

addEventHandler("onVehicleEnter", getRootElement(), function(plr, seat, jacked)
	if isElement(object[source]) and seat == 0 then
		outputChatBox("#00ff00✔#ffffff Posiadasz założoną blokadę na koło, blokada założona przez pracownika #808080"..getElementData(object[source], "blokada:zalozona:przez"), plr, 255, 255, 255, true)
	end
end)

addEventHandler("onElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		if isElement(object[source]) then
			destroyElement(object[source])
		end
	end
end)