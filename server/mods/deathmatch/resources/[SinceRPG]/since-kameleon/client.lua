local vehicles = {}
local toggle = true

function findCameleon(veh)
    for i = 1, #vehicles do
        if vehicles[i].vehicle == veh then
            return true
        end
    end
    return false
end

function addCameleon(source)
    if getElementData(source, "vehicle:upgrades")['cameleon'] and not findCameleon(source) and toggle then
        local vehData = getElementData(source, 'vehicle:upgrades') or {}
        vehicles[#vehicles + 1] = {
            vehicle = source,
        }
        
        if #vehicles == 1 then
            addEventHandler("onClientPreRender", root, renderCameleon)
        end
    end
end

function removeCameleon(source)
    for i = 1, #vehicles do
        local v = vehicles[i]
        if v and source == v.vehicle then
            table.remove(vehicles, i)
            break
        end
    end
    if #vehicles == 0 then
        removeEventHandler("onClientPreRender", root, renderCameleon)
    end
end

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == 'vehicle' and getElementData(source, "vehicle:id") and (not findCameleon(source)) and toggle then
        addCameleon(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == 'vehicle' then
        removeCameleon(source)
    end
end)

function scoreChangeTracker(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and (theKey == "player:settings") and source == localPlayer then
        local settings = getElementData(localPlayer, 'player:settings') or {}

        if settings['showCameleon'] then
            vehicles = {}
            toggle = false
        else
            for i, v in ipairs(getElementsByType("vehicle")) do
                if getElementData(v, "vehicle:id") and (not findCameleon(v) and isElementStreamedIn(v)) then
                    addCameleon(v)
                end
            end
        end
    end
end
addEventHandler("onClientElementDataChange", root, scoreChangeTracker)

setTimer(function()
    for i, v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "vehicle:id") and (not findCameleon(v) and isElementStreamedIn(v)) then
            addCameleon(v)
        end
    end
end, 1000, 1)

local frequency = 3

function renderCameleon()
    if #vehicles == 0 then
        return
    end

    local rootx, rooty, rootz = getCameraMatrix()
    local curtime = getTickCount() / 1000
    local r, g, b = math.floor(math.sin(curtime * frequency + 0) * 127 + 128), math.floor(math.sin(curtime * frequency + 2) * 127 + 128), math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    for i = 1, #vehicles do
        local v = vehicles[i]
        if isElement(v.vehicle) and isElementStreamedIn(v.vehicle) and isElementOnScreen(v.vehicle) then
            local _, _, _, _, _, _, r3, g3, b3, r4, g4, b4 = getVehicleColor(v.vehicle, true) 
            setVehicleColor(v.vehicle, r, g, b, r, g, b, r3, g3, b3, r4, g4, b4)
        end
    end
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end