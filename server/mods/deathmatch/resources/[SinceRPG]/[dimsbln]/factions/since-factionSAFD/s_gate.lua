bramys = {}
local function findPoint(el)
    for i,v in ipairs(bramys) do
	if (v[2]==el) or (v[3]==el) then return v end
    end
    return nil
end


function isPlayerInFaction(plr)
 local sid=getElementData(plr,'player:sid')
 if not sid then return end

 local result=exports['since-db']:query('SELECT * FROM `since-factions` WHERE faction=? AND uid=? LIMIT 1', "SAFD", sid)
 if result[1] then
  return true
 else
  return false
 end
end

local pad = createObject(2922, 854.95, 1903.13, 11.2, 0, 0, 90)
local pad2 = createObject(2922, 855.37, 1903.13, 11.2, 0, 0, -90)

local pad3 = createObject(2922, 854.95, 1890.45, 11.2, 0, 0, 90)
local pad4 = createObject(2922, 855.37, 1890.45, 11.2, 0, 0, -90)

local pad5 = createObject(2922, 854.95, 1877.79, 11.2, 0, 0, 90)
local pad6 = createObject(2922, 855.37, 1877.79, 11.2, 0, 0, -90)

local bramy = {
	[1] = {
	obiekt={989, 855.20, 1880.95, 11.45, 0, 0, 17+180},
	marker1={854.59, 1877.83, 10.82},
	marker2={855.73, 1877.79, 10.82},
	},

	[2] = {
	obiekt={989, 855.20, 1893.6, 11.45, 0, 0, 17+180},
	marker1={854.59, 1890.45, 10.82},
	marker2={855.74, 1890.44, 10.82},
	},
	
	[3] = {
	obiekt={989, 855.20, 1906.25, 11.45, 0, 0, 17+180},
	marker1={854.58, 1903.13, 10.82},
	marker2={855.73, 1903.14, 10.82},
	},
}


local cubs = {}
local moving = {}

for i,v in ipairs(bramy) do
	local object = createObject(v.obiekt[1],v.obiekt[2],v.obiekt[3],v.obiekt[4],v.obiekt[5],v.obiekt[6],v.obiekt[7])
	--setElementDoubleSided(object, true)
	cub1 = createColSphere(v.marker1[1],v.marker1[2],v.marker1[3],0.5)
	cub2 = createColSphere(v.marker2[1],v.marker2[2],v.marker2[3],0.5)
	cubs[cub1] = object
	cubs[cub2] = object
end

addEventHandler("onColShapeHit", resourceRoot, function(element)
	if (getElementType(element) == "player") then
		if getPedOccupiedVehicle(element) then 
			return false 
		end
		bindKey(element, "mouse_wheel_down", "both", movedoor, cubs[source]) 
		bindKey(element, "mouse_wheel_up", "both", movedoor, cubs[source]) 

	end
end)

addEventHandler("onColShapeLeave", resourceRoot, function(element)
	if (getElementType(element) == "player") then
		unbindKey(element, "mouse_wheel_down", "both", movedoor, cubs[source]) 
		unbindKey(element, "mouse_wheel_up", "both", movedoor, cubs[source]) 

	end
end)

function movedoor(plr, key, state, object)
	if (getElementData(plr, "player:faction") == "SAFD") then
		if (moving[object]) then
			return false
		end
		local x, y, z = getElementPosition(object)

		if (key == "mouse_wheel_up") then
			if (z == 11.45) then
				return false
			end
			moveObject(object, 1500, x, y, 11.45)
			moving[object] = true
			setTimer(function(obj)
				moving[obj] = nil
			end, 1500, 1, object)

			setPedAnimation(plr, "CRIB", "CRIB_Use_Switch", -1, false, true, true, false)
		elseif (key == "mouse_wheel_down") then
			if (z == 7.5) then
				return false
			end
			moveObject(object, 1500, x, y, 7.5)
			moving[object] = true
			setTimer(function(obj)
				moving[obj] = nil
			end, 1500, 1, object)

			setPedAnimation(plr, "CRIB", "CRIB_Use_Switch", -1, false, true, true, false)
		end
	end
end