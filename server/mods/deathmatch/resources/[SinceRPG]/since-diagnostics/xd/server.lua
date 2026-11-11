--[[
    Author: EnoNeK
    For: cloudyMTA
]]

--createBlip(-2722.43, 216.99, 4.64, 33, 2, 255, 255, 255, 255, 0, 200)

local cols = {
    {1952.18, -2349.23, 10.05, 18.59, 28.16, 8.90},
}

local cubs = {}
for i,v in ipairs(cols) do
    cubs[i] = createColCuboid(unpack(v))
end

addEventHandler("onColShapeHit", resourceRoot, function(element, dim)
    if (getElementType(element) == "vehicle" and dim) then
        local vehicles = getElementsWithinColShape(source, "vehicle")
        if (#vehicles > 1) then
            triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, "max")
            tune = "max"
            return false
        end
        if (not getElementData(element, "vehicle:id")) then
            --tune = "not"
            --triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
            return false
        end
        tune = {
            {"MK1", getElementData(element, "vehicle:mk1") == 1 and "TAK" or "NIE"},
            {"MK2", getElementData(element, "vehicle:mk2") == 1 and "TAK" or "NIE"},
            {"MK3", getElementData(element, "vehicle:mk3") == 1 and "TAK" or "NIE"},
            {"MK4", getElementData(element, "vehicle:mk4") == 1 and "TAK" or "NIE"},
            {"Turbo", getElementData(element, "vehicle:turbo") and "TAK" or "NIE"},
            {"Bak", getElementData(element, "vehicle:bak").." l" or "100 l"},
            {"LPG", getElementData(element, "vehicle:lpg:bak") and getElementData(element, "vehicle:lpg:bak").." l" or "NIE"},
            {"Nitro", getVehicleUpgradeOnSlot(element, 8) ~= 0 and "TAK" or "NIE"},
            {"Bateria", getElementData(element, "vehicle:battery") and getElementData(element, "vehicle:battery").." %" or "NIE"},
            {"Chiptuning", getElementData(element, "vehicle:chiptuning") and "TAK" or "NIE"},
            {"Szyby", getElementData(element, "vehicle:window:tint") and getElementData(element, "vehicle:window:tint").." %" or "NIE"},
            {"Pojemność", getElementData(element, "vehicle:pojemnosc").." dm3" or "---"},
            {"Przebieg", math.round(getElementData(element, "vehicle:mileage")).." km" or "0 km"},
            {"Stereo", getVehicleUpgradeOnSlot(element, 10) ~= 0 and "TAK" or "NIE"},
            {"Deluxomode", getElementData(element, "vehicle:deluxo").state and "TAK" or "NIE"},
            {"Hovermode", getElementData(element, "vehicle:hover").state and "TAK" or "NIE"},
            {"Neon", getElementData(element, "vehicle:neon") and "TAK" or "NIE"},
            {"Licznik RGB", getElementData(element, "vehicle:lgbt") ~= 0 and "TAK" or "NIE"},
            name = getVehicleName(element),
            id = getElementData(element, "vehicle:id"),
            vehicle = element,
        }
        triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
    end
end)

addEventHandler("onColShapeLeave", resourceRoot, function(element, dim)
    if (getElementType(element) == "vehicle" and dim) then
        local vehicles = getElementsWithinColShape(source, "vehicle")
        if (vehicles and #vehicles == 1) then
            if (not getElementData(element, "vehicle:id")) then
                tune = "not"
                triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
                return false
            end
            tune = {
                {"MK1", getElementData(element, "vehicle:mk1") == 1 and "TAK" or "NIE"},
                {"MK2", getElementData(element, "vehicle:mk2") == 1 and "TAK" or "NIE"},
                {"MK3", getElementData(element, "vehicle:mk3") == 1 and "TAK" or "NIE"},
                {"MK4", getElementData(element, "vehicle:mk4") == 1 and "TAK" or "NIE"},
                {"Turbo", getElementData(element, "vehicle:turbo") and "TAK" or "NIE"},
                {"Bak", getElementData(element, "vehicle:bak").." l" or "100 l"},
                {"LPG", getElementData(element, "vehicle:lpg:bak") and getElementData(element, "vehicle:lpg:bak").." l" or "NIE"},
                {"Nitro", getVehicleUpgradeOnSlot(element, 8) ~= 0 and "TAK" or "NIE"},
                {"Bateria", getElementData(element, "vehicle:battery") and getElementData(element, "vehicle:battery").." %" or "NIE"},
                {"Chiptuning", getElementData(element, "vehicle:chiptuning") and "TAK" or "NIE"},
                {"Szyby", getElementData(element, "vehicle:window:tint") and getElementData(element, "vehicle:window:tint").." %" or "NIE"},
                {"Pojemność", getElementData(element, "vehicle:pojemnosc").." dm3" or "---"},
                {"Przebieg", math.round(getElementData(element, "vehicle:mileage")).." km" or "0 km"},
                {"Stereo", getVehicleUpgradeOnSlot(element, 10) ~= 0 and "TAK" or "NIE"},
                {"Deluxomode", getElementData(element, "vehicle:deluxo").state and "TAK" or "NIE"},
                {"Hovermode", getElementData(element, "vehicle:hover").state and "TAK" or "NIE"},
                {"Neon", getElementData(element, "vehicle:neon") and "TAK" or "NIE"},
                {"Licznik RGB", getElementData(element, "vehicle:lgbt") ~= 0 and "TAK" or "NIE"},
                name = getVehicleName(element),
                id = getElementData(element, "vehicle:id"),
                vehicle = element,
            }
            triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
            return false
        end
        
        tune = nil
        triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, nil)
    end
end)

addEventHandler("onElementDestroy", root, function()
    if (getElementType(source) == "vehicle") then
        if (tune == "max") then
            setTimer(function()
                local vehicles = getElementsWithinColShape(cubs[1], "vehicle")
                if (vehicles and #vehicles == 1) then
                    if (not getElementData(vehicles[1], "vehicle:id")) then
                        tune = "not"
                        triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
                        return false
                    end
                    tune = {
                        {"MK1", getElementData(vehicles[1], "vehicle:mk1") == 1 and "TAK" or "NIE"},
                        {"MK2", getElementData(vehicles[1], "vehicle:mk2") == 1 and "TAK" or "NIE"},
                        {"MK3", getElementData(vehicles[1], "vehicle:mk3") == 1 and "TAK" or "NIE"},
                        {"MK4", getElementData(vehicles[1], "vehicle:mk4") == 1 and "TAK" or "NIE"},
                        {"Turbo", getElementData(vehicles[1], "vehicle:turbo") and "TAK" or "NIE"},
                        {"Bak", getElementData(vehicles[1], "vehicle:bak").." l" or "100 l"},
                        {"LPG", getElementData(vehicles[1], "vehicle:lpg:bak") and getElementData(vehicles[1], "vehicle:lpg:bak").." l" or "NIE"},
                        {"Nitro", getVehicleUpgradeOnSlot(vehicles[1], 8) ~= 0 and "TAK" or "NIE"},
                        {"Bateria", getElementData(vehicles[1], "vehicle:battery") and getElementData(vehicles[1], "vehicle:battery").." %" or "NIE"},
                        {"Chiptuning", getElementData(vehicles[1], "vehicle:chiptuning") and "TAK" or "NIE"},
                        {"Szyby", getElementData(vehicles[1], "vehicle:window:tint") and getElementData(vehicles[1], "vehicle:window:tint").." %" or "NIE"},
                        {"Pojemność", getElementData(vehicles[1], "vehicle:pojemnosc").." dm3" or "---"},
                        {"Przebieg", math.round(getElementData(vehicles[1], "vehicle:mileage")).." km" or "0 km"},
                        {"Stereo", getVehicleUpgradeOnSlot(vehicles[1], 10) ~= 0 and "TAK" or "NIE"},
                        {"Deluxomode", getElementData(vehicles[1], "vehicle:deluxo").state and "TAK" or "NIE"},
                        {"Hovermode", getElementData(vehicles[1], "vehicle:hover").state and "TAK" or "NIE"},
                        {"Neon", getElementData(vehicles[1], "vehicle:neon") and "TAK" or "NIE"},
                        {"Licznik RGB", getElementData(vehicles[1], "vehicle:lgbt") ~= 0 and "TAK" or "NIE"},
                        name = getVehicleName(vehicles[1]),
                        id = getElementData(vehicles[1], "vehicle:id"),
                        vehicle = vehicles[1],
                    }
                    triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
                    return false
                end
            end, 100, 1)
        elseif (tune == "not") then
            tune = nil
            triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
        elseif (tune and tune.vehicle == source) then
            tune = nil
            triggerClientEvent(root, "enonek-diagnostics:updateRT", resourceRoot, tune)
        end
    end
end)

addEvent("enonek-diagnostics:getData", true)
addEventHandler("enonek-diagnostics:getData", resourceRoot, function()
    triggerClientEvent(client, "enonek-diagnostics:updateRT", resourceRoot, tune)
end)

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end