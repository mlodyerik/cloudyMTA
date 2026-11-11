  

--[[
    Author: EnoNeK
    For: cloudyMTA
--]]

local objects = {}
local settings = {
    [561] = {-0.9, 0, -0.12},
    [402] = {-0.9, -0.5, -0.25},
    [541] = {-0.9, -0.3, -0.3},
    [579] = {-0.9, -0.3, 0.3},
    [560] = {-1, -0.0, -0.1},
    [411] = {-0.9, -0.0, -0.25},
    [480] = {-0.9, -0.3, -0.22},
    [562] = {-0.9, -0.3, -0.15},
    [415] = {-0.8, -0.35, -0.3, -8, 0, 0},
    [490] = {-1, 0.3, 0.16},
    [598] = {-0.8, -0.1, 0.13},
}

function toggle(plr, cmd)
    if getElementData(plr, "player:faction") == "SAPD" then
        if isPedInVehicle(plr) then
            local vehicle = getPedOccupiedVehicle(plr)
            local model = getElementModel(vehicle)
            if getElementData(vehicle, "vehicle:police") and settings[model] then
                if (getVehicleController(vehicle) ~= plr) then
                    return false
                end
                if objects[vehicle] then
                    destroyElement(objects[vehicle])
                    objects[vehicle] = nil
                else
                    local x, y, z = getElementPosition(vehicle)
                    objects[vehicle] = createObject(1994, x, y, z)
                    setElementCollisionsEnabled(objects[vehicle], false)
                    local v = settings[model]
                    if (v[4]) then
                        attachElements(objects[vehicle], vehicle, v[1], v[2], v[3], v[4], v[5], v[6])
                    else
                        attachElements(objects[vehicle], vehicle, v[1], v[2], v[3])
                    end
                end
            end
        end
    end
end
addCommandHandler("kogut", toggle)

addEventHandler("onElementDestroy", root, function()
    if (getElementType(source) == "vehicle") then
        if (objects[source]) then
            destroyElement(objects[source])
            objects[source] = nil
        end
    end
end)