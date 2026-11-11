  

--[[
    Author: EnoNeK
    For: cloudyMTA
]]

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

local objects, cooldown = {}, {}

addCommandHandler("kolczatka", function(plr)
	if getElementData(plr, "player:faction") == "SAPD" then
		if not getPedOccupiedVehicle(plr) and not objects[plr] then
			if (cooldown[plr]) then
				if (getTickCount() - cooldown[plr] < 3000) then
					return false
				end
			end
			setElementFrozen(plr, true)
			toggleAllControls(plr, false, true, false)
			setPedAnimation(plr, "BOMBER", "BOM_plant", 3000, false, false, false)
			cooldown[plr] = getTickCount()
			setTimer(function(player)
				local dim = getElementDimension(player)
				local int = getElementInterior(player)
				local x, y, z = getPositionFromElementOffset(player, 0, 2.8, 0)
				local x2, y2, z2 = getPositionFromElementOffset(player, 0, 7.5, 0)
				local rx, ry, rz = getElementRotation(player)
				local object = createObject(2899, x, y, z-0.9, rx, ry, rz)
				local object2 = createObject(2899, x2, y2, z2-0.9, rx, ry, rz)
				setElementData(object, "caltrop", true)
				setElementData(object2, "caltrop", true)
				objects[player] = {object, object2}
				setElementInterior(object, int)
				setElementDimension(object, dim)
				setPedAnimation(player, false)
				toggleAllControls(player, true, true, false)
				setElementFrozen(player, false)
			end, 2000, 1, plr)
		end
	end
end)

function removeCaltrop(player)
	if objects[player] then
		for i,v in ipairs(objects[player]) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		objects[player] = nil
	end
end

addCommandHandler("ukolczatka", function(plr)
	if getElementData(plr, "player:faction") == "SAPD" then
		removeCaltrop(plr)
	end
end)

addEventHandler("onPlayerQuit", root, function()
	removeCaltrop(source)
end)

addEvent("enonek-kolczatka:break", true)
addEventHandler("enonek-kolczatka:break", resourceRoot, function(veh, o1, o2, o3, o4)
	setVehicleWheelStates(veh, o1, o2, o3, o4)
end)