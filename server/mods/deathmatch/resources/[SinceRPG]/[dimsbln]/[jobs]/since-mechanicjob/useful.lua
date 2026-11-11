carParts = {

    {"Silnik", 1, fn = function(veh) if getElementHealth(veh) >= 1000 then return true end; return false end}, 
    {"Maska", 2, fn = function(veh) if getVehicleDoorState(veh, 0) == 0 then return true end; return false end},
    {"Bagażnik", 3, fn = function(veh) if getVehicleDoorState(veh, 1) == 0 then return true end; return false end},
    {"Drzwi lewy przód", 4, fn = function(veh) if getVehicleDoorState(veh, 2) == 0 then return true end; return false end},
    {"Drzwi prawy przód", 5, fn = function(veh) if getVehicleDoorState(veh, 3) == 0 then return true end; return false end},
    {"Drzwi lewy tył", 6, fn = function(veh) if getVehicleDoorState(veh, 4) == 0 then return true end; return false end},
    {"Drzwi prawy tył", 7, fn = function(veh) if getVehicleDoorState(veh, 5) == 0 then return true end; return false end},
    {"Szyba przednia", 8, fn = function(veh) if getVehiclePanelState(veh, 4) == 0 then return true end; return false end},
    {"Zderzak przedni", 9, fn = function(veh) if getVehiclePanelState(veh, 5) == 0 then return true end; return false end},
    {"Zderzak tylni", 10, fn = function(veh) if getVehiclePanelState(veh, 6) == 0 then return true end; return false end},
    {"Światło lewe przednie", 11, fn = function(veh) if getVehicleLightState(veh, 0) == 0 then return true end; return false end},
    {"Światła prawe przednie", 12, fn = function(veh) if getVehicleLightState(veh, 1) == 0 then return true end; return false end},
    {"Światła lewe tylnie", 13, fn = function(veh) if getVehicleLightState(veh, 2) == 0 then return true end; return false end},
    {"Światła prawe tylnie", 14, fn = function(veh) if getVehicleLightState(veh, 3) == 0 then return true end; return false end},

    {"Lewe przednie koło", 15, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if frontLeft == 0 then
            return true
        else
            return false 
        end
    end},
    
    {"Prawe przednie koło", 16, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if frontRight == 0 then
            return true
        else
            return false 
        end
    end},
    
    {"Lewe tylne koło", 17, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if rearLeft == 0 then
            return true
        else
            return false 
        end
    end},
    
    {"Prawe tylne koło", 18, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if rearRight == 0 then
            return true
        else
            return false 
        end
    end},

}

partCost = {4500, 3000, 3500, 2500, 2500, 2500, 2500, 2500, 4000, 3500, 2500, 2500, 2500, 2500, 2500, 2500, 2500, 2500}

for i,v in ipairs(carParts) do
    partCost[i] = partCost[i] * 3.75
end

if localPlayer then
    sx, sy = guiGetScreenSize()
    zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
    zoom = zoom * 0.9

    function isMouseIn(posX, posY, sizeX, sizeY)
        if isCursorShowing() then
            local cX, cY = getCursorPosition()
            cX, cY = cX * sx, cY * sy
            return (cX >= posX and cX <= posX + sizeX) and (cY >= posY and cY <= posY + sizeY)
        end
        return false
    end

    function getTable(veh)
        local tbl = {}
        for i,v in pairs(carParts) do
            if v.fn(veh) == false then
                local tbl2 = v
                table.insert(tbl, tbl2)
            end
        end
        return tbl
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
end

function convertNumber(number)
    if number > 999 then
        local formatted = number
        while true do  
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
            if (k==0) then
                break
            end
        end
        return formatted
    end
    return number
end

function convertTime(minutes)
    local hours = math.floor(minutes / 60)
    local minutes = minutes - (hours * 60)
    return string.format('%02d godz. %02d min.', hours, minutes)
end