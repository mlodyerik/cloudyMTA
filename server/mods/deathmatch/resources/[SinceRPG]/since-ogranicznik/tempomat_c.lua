local wybraneOgraniczenie = 1
local ograniczenia = {nil, 160, 120, 80, 60, 50, 40, 20}
local ograniczeniaModeli = {}
local ograniczeniaModeliWsteczne = {
    [532] = 20,
    [408] = 20,
    [481] = 10,
    [509] = 10,
    [510] = 10,
    [574] = 15,
}

local cuboids = {}

function addCuboid(data)
    table.insert(cuboids, data)
end

for _, v in ipairs(cuboids) do
    setElementData(v[1], "cub:ogr", v[2])
end

function getVehSpeed(veh)
    local speedx, speedy, speedz = getElementVelocity(veh)
    return math.ceil(((speedx^2 + speedy^2 + speedz^2)^(0.5)) * 158)
end

function tempomat()
    local plr = localPlayer
    local veh = getPedOccupiedVehicle(plr)
    if not veh or getPedOccupiedVehicleSeat(plr) ~= 0 then return end

    local ograniczenie = ograniczenia[wybraneOgraniczenie]
    local cub_ogr, isPlane = false, getVehicleType(veh) == "Plane"

    if not isPlane and not isVehicleOnGround(veh) and getElementModel(veh) ~= 573 then return end
    if not getVehicleEngineState(veh) then
        local vx, vy = getElementVelocity(veh)
        if getDistanceBetweenPoints2D(0, 0, vx, vy) < 0.1 then
            setElementVelocity(veh, 0, 0, select(3, getElementVelocity(veh)))
            return
        end
    end

    if getVehicleSirensOn(veh) ~= true or (getVehicleSirensOn(veh) == true and getElementData(veh, "vehicle:id")) then
        for _, v in ipairs(getElementsByType("colshape", resourceRoot, true)) do
            local cub_ogr_val = getElementData(v, "cub:ogr")
            if cub_ogr_val and isElementWithinColShape(veh, v) and getElementDimension(veh) == 0 and getElementInterior(veh) == 0 then
                ograniczenie = math.min(tonumber(cub_ogr_val) or 9999, tonumber(ograniczenie) or 9999)
                cub_ogr = true
            end
        end
    end

    if not isPlane and not (getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" or getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Bike") and not ograniczeniaModeli[getElementModel(veh)] then return end
    if ograniczeniaModeli[getElementModel(veh)] then ograniczenie = ograniczeniaModeli[getElementModel(veh)] end
    if getElementData(veh, "ograniczenie") then ograniczenie = getElementData(veh, "ograniczenie") end
    if ograniczeniaModeliWsteczne[getElementModel(veh)] and getControlState("brake_reverse") then ograniczenie = math.min(ograniczenie or 9999, ograniczeniaModeliWsteczne[getElementModel(veh)] or 9999) end

    local wheels = {getVehicleWheelStates(veh)}
    local l = 100
    for _, v in ipairs(wheels) do if v == 1 then l = l - 20 end end
    if l ~= 100 and (ograniczenie or 9999) > l then ograniczenie = l end

    if not ograniczenie then return end

    local speed = getVehSpeed(veh)
    if ch_gtc and (getTickCount() - ch_gtc) > 2500 then ch_gtc = nil end

    if speed > ograniczenie then
		local differ = speed - ograniczenie
		if differ > 5 then
			local accel = math.max(1, math.min(100, getVehicleHandling(veh)["engineAcceleration"]))
			local val = 1 - (accel / 100)
			if ch_gtc then
				local fin = interpolateBetween(1, 0, 0, val, 0, 0, (getTickCount() - ch_gtc) / 5000, "Linear")
				local cv, cy, cz = getElementVelocity(veh)
				setElementVelocity(veh, cv * fin, cy * fin, cz * fin)
				if fin == val then ch_gtc = nil end
			else
				local cv, cy, cz = getElementVelocity(veh)
				setElementVelocity(veh, cv * val, cy * val, cz * val)
			end
		else
			local cv, cy, cz = getElementVelocity(veh)
			local diff = math.max(0.3, ograniczenie / speed)
			setElementVelocity(veh, cv * diff, cy * diff, cz * diff)
		end
    end
end

addEventHandler("onClientRender", root, tempomat)

local last_change = getTickCount()

local function ogrSwitch(direction)
    if isCursorShowing() or isPedDoingGangDriveby(localPlayer) then return end
    if exports['since-interaction']:isInteractionOpened() then return end
    local v = getPedOccupiedVehicle(localPlayer)
    if not v or not (getVehicleType(v) == "Automobile" or getVehicleType(v) == "Monster Truck") then return end
    if getVehicleController(v) ~= localPlayer then return end
    if getElementModel(v) ~= 573 and not isVehicleOnGround(v) then return end

    if (last_change + 250 > getTickCount()) then return end
    last_change = getTickCount()

    if direction == -1 then
        wybraneOgraniczenie = wybraneOgraniczenie - 1
        if wybraneOgraniczenie < 1 then wybraneOgraniczenie = #ograniczenia end
    else
        wybraneOgraniczenie = wybraneOgraniczenie + 1
        if wybraneOgraniczenie > #ograniczenia then wybraneOgraniczenie = 1 end
    end

    ch_gtc = getTickCount()
    setElementData(localPlayer, "Ogranicznik:Set", ograniczenia[wybraneOgraniczenie], false)

    if ograniczenia[wybraneOgraniczenie] then
        outputChatBox("Ⓘ #FFFFFFOgraniczenie prędkości zostało zmienione na #00FF00" .. ograniczenia[wybraneOgraniczenie] .. "km/h.", 255, 255, 0, true)
    else
        outputChatBox("Ⓘ #FFFFFFOgraniczenie prędkości zostało #FF0000wyłączone.", 255, 255, 0, true)
    end
end

bindKey("mouse1", "down", function()
    ogrSwitch(-1)
end)

bindKey("mouse2", "down", function()
    ogrSwitch(1)
end)

addEventHandler("onClientVehicleExit", root, function(plr, s)
    if plr == localPlayer and s == 0 then
        setElementData(localPlayer, "Ogranicznik:Set", nil)
    end
end)

addEventHandler("onClientVehicleEnter", root, function(plr, s)
    if plr == localPlayer and s == 0 then
        setElementData(localPlayer, "Ogranicznik:Set", ograniczenia[wybraneOgraniczenie])
    end
end)
