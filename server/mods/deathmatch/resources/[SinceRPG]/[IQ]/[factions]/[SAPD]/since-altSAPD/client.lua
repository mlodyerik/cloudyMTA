  

--[[
    Author: EnoNeK
    For: cloudyMTA
]]

--[[if getElementData(localPlayer, "player:sid") == 25 then

else
    return false
end]]

local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

function render()
    if getKeyState("lalt") and getPedOccupiedVehicle(localPlayer) then
        local cx, cy, cz = getCameraMatrix(localPlayer)
        local vehicles = getElementsWithinRange(cx, cy, cz, 70, "vehicle")
        if vehicles then
            for i,v in ipairs(vehicles) do
                if getVehicleOccupant(v) and getVehicleOccupant(v) ~= localPlayer then
                    local x, y, z = getElementPosition(v)
                    local screenx, screeny = getScreenFromWorldPosition(x, y, z+1.5)
                    if screenx and screeny then
                        if isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false) then
                            local vx, vy, vz = getElementVelocity(v)
		                    local speed = ((vx^2 + vy^2 + vz^2)^(0.5))*180	
                            if isMouseIn(screenx-(50/zoom), screeny-(35/zoom), 100/zoom, 45/zoom) then
                                dxDrawText(math.floor(speed).." km/h", screenx, screeny, screenx, screeny, tocolor(255, 0, 0), 1.8/zoom, "default-bold", "center", "center", false, false, false, false)
                                if not targetVehicle then
                                    targetVehicle = v
                                end
                            else
                                dxDrawText(math.floor(speed).." km/h", screenx, screeny, screenx, screeny, white, 1.8/zoom, "default-bold", "center", "center", false, false, false, false)
                                if targetVehicle then
                                    targetVehicle = false
                                end
                            end
                        end
                    end
                end
            end
        end
        dxDrawRectangle(sx/2 - 5/zoom/2, sy/2 - 100/zoom, 5/zoom, 5/zoom, tocolor(255, 0, 0), false)
    end
    
    if not getPedOccupiedVehicle(localPlayer) then
        onalt(false, "up")
    end
end

local last_pullup = false

function pullup()
    if targetVehicle then
        if last_pullup then
            if getTickCount() - last_pullup < 10000 then
                return false
            end
        end
        local vx, vy, vz = getElementVelocity(targetVehicle)
		local speed = ((vx^2 + vy^2 + vz^2)^(0.5))*180	
        if speed > 5 then
            triggerServerEvent("enonek-altSAPD:pullup", resourceRoot, targetVehicle, speed)
            last_pullup = getTickCount()
        end
    end
end


function onalt(key, keystate)
    if keystate == "down" then
        addEv("onClientRender", root, render)
        bindKey("lctrl", "down", pullup)
        targetVehicle = false
    elseif keystate == "up" then
        removeEv("onClientRender", root, render)
        unbindKey("lctrl", "down", pullup)
    end
end

addEventHandler("onClientVehicleEnter", getRootElement(), function(ped, seat)
    if ped == localPlayer and seat == 0 then
        if getElementData(source, "vehicle:police") and getElementData(localPlayer, "player:faction") == "SAPD" then
            bindKey("lalt", "both", onalt) 
        end
    end
end)

addEventHandler("onClientVehicleExit", getRootElement(), function(ped, seat)
    if ped == localPlayer and seat == 0 then
        if getElementData(source, "vehicle:police") then
            unbindKey("lalt", "both", onalt)
            onalt(false, "up")
        end
    end
end)

function isMouseIn( x, y, width, height )
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = 0.5, 0.4
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function addEv(...)
    if not isEventHandlerAdded(...) then
        addEventHandler(...)
    end
end

function removeEv(...)
    if isEventHandlerAdded(...) then
        removeEventHandler(...)
    end
end

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
getResourceName(getThisResource(), true, 525532338); if true then return end