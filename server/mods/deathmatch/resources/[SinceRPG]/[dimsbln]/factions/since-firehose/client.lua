  

--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

--[[if getElementData(localPlayer, "player:sid") == 25 or getElementData(localPlayer, "player:sid") == 941 or getElementData(localPlayer, "player:sid") == 1 or getElementData(localPlayer, "player:sid") == 8534 then

else
    return false
end]]

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

engineImportTXD(engineLoadTXD("files/pradownica.txd"), 366)
engineReplaceModel(engineLoadDFF("files/pradownica.dff"), 366)

local firehose = {}
local owners = {}
elements = {}

local trigger = false

addEvent("enonek-firehose:toggle", true)
addEventHandler("enonek-firehose:toggle", root, function()
    if getElementData(localPlayer, "schowek:ma:liniag") then
        triggerServerEvent("enonek-firehose:synchronize:linia", resourceRoot, localPlayer)
        triggerServerEvent("enonek-firehose:synchronize:water", resourceRoot, localPlayer, false)
        firehose[localPlayer] = {}
        destroySystemWater(localPlayer)
        toggleControl("jump", true)
        toggleControl("sprint", true)
        setElementData(getElementData(localPlayer, "schowek:ma:liniag"), "vehicle:linieg", (getElementData(getElementData(localPlayer, "schowek:ma:liniag"), "vehicle:linieg")+1))
        setElementData(localPlayer, "schowek:ma:liniag", false)
        return false
    end

    local x, y, z = getElementPosition(localPlayer)
    local offx, offy, offz = getPositionFromElementOffset(localPlayer, 0, 1.7, 0)

    if isLineOfSightClear(x,y,z,offx,offy,offz,false,true,false,false,false) then
        return false
    end

    local hit,_,_,_,veh,_,_,_,_,_,component = processLineOfSight(x,y,z,offx,offy,offz,false,true,false,false,false)

    if not hit or not veh then
        return false
    end

    if getElementType(veh) ~= "vehicle" then
        return false
    end

    if getElementData(veh, "vehicle:linieg") then
        if getElementData(veh, "vehicle:linieg") < 1 then
            outputChatBox("#ff0000✘ #ffffffW pojeździe nie ma dostępnych węży gaśniczych!", 255, 255, 255, true)
            return false
        end
    end

    local offx, offy, offz = getPositionFromElementOffset(veh, 0, -3.5, -0.5)

    triggerServerEvent("enonek-firehose:synchronize", resourceRoot, localPlayer, offx, offy, offz)
    toggleControl("jump", false)
    toggleControl("sprint", false)

    setElementData(localPlayer, "schowek:ma:liniag", veh)
    setElementData(veh, "vehicle:linieg", (getElementData(veh, "vehicle:linieg")-1))
end)

addEvent("enonek-firehose:client", true)
addEventHandler("enonek-firehose:client", resourceRoot, function(own, x2, y2, z2)
    table.insert(owners, {own})
    firehose[own] = {}
    table.insert(firehose[own], {x=x2, y=y2, z=z2, owner=own})
    createSystemWater(own, x2, y2, z2)
end)

local tex = dxCreateTexture("files/firehose.png")

addEventHandler("onClientRender", root, function()
    for i2=1,#owners do
        if firehose[owners[i2][1]] and isElement(owners[i2][1]) then
            for i,v in ipairs(firehose[owners[i2][1]]) do
                if #firehose[v.owner] > 0 then
                    local bx, by, bz = getPedBonePosition(v.owner, 25)

                    local position = firehose[v.owner][#firehose[v.owner]]  
                    local x,y,z = position.x, position.y, position.z

                    if not x or not y or not z or not bx or not by or not bz or not v.x or not v.y or not v.z or not v.owner or not position then
                        return false
                    end

                    if #firehose[v.owner] > 1 then
                        local x2, y2, z2 = firehose[v.owner][#firehose[v.owner]-1].x, firehose[v.owner][#firehose[v.owner]-1].y, firehose[v.owner][#firehose[v.owner]-1].z 
                        if getDistanceBetweenPoints3D(bx, by, bz, x2, y2, z2) < 1.5 then
                            table.remove(firehose[v.owner], #firehose[v.owner])
                        end
                    end

                    if getDistanceBetweenPoints3D(bx, by, 0, x, y, 0) > 1.5 then
                        table.insert(firehose[v.owner], {x=bx, y=by, z=getGroundPosition(bx, by, bz), owner=v.owner})
                    end
                    
                    if not firehose[v.owner][i+1] then
                        --dxDrawLine3D(v.x, v.y, v.z+0.2, bx, by, bz+0.2, tocolor(46, 43, 43,255), 7)
                        dxDrawMaterialLine3D(v.x, v.y, v.z+0.2, bx, by, bz+0.2, tex, 0.1)
                    end
                    
                    if firehose[v.owner][i] and firehose[v.owner][i+1] then
                        local b = firehose[v.owner][i+1]
                        --dxDrawLine3D(v.x, v.y, v.z+0.2, b.x, b.y, b.z+0.2, tocolor(46, 43, 43,255), 7)
                        dxDrawMaterialLine3D(v.x, v.y, v.z+0.2, b.x, b.y, b.z+0.2, tex, 0.1)
                    end

                    if #firehose[v.owner] > 45 and v.owner == localPlayer then
                        outputChatBox("#ff0000✘ #ffffffLinia gaśnicza się skończyła!", 255, 255, 255, true)
                        triggerServerEvent("enonek-firehose:synchronize:linia", resourceRoot, v.owner)
                        triggerServerEvent("enonek-firehose:synchronize:water", resourceRoot, localPlayer, false)
                        firehose[v.owner] = nil
                        destroySystemWater(localPlayer)
                        toggleControl("jump", true)
                        toggleControl("sprint", true)
                        setElementData(getElementData(localPlayer, "schowek:ma:liniag"), "vehicle:linieg", (getElementData(getElementData(localPlayer, "schowek:ma:liniag"), "vehicle:linieg")+1))
                        setElementData(localPlayer, "schowek:ma:liniag", false)
                    end 

                    if elements[localPlayer] and elements[elements[localPlayer]] and v.owner == localPlayer then
                        if getKeyState("mouse1") and not trigger then
                            if getPedWeapon(localPlayer) == 42 then
                                setPedControlState(elements[elements[localPlayer]], "vehicle_fire", true)
                                triggerServerEvent("enonek-firehose:synchronize:water", resourceRoot, localPlayer, true)
                                trigger = true
                            end
                        elseif not getKeyState("mouse1") and trigger then
                            setPedControlState(elements[elements[localPlayer]], "vehicle_fire", false)
                            triggerServerEvent("enonek-firehose:synchronize:water", resourceRoot, localPlayer, false)
                            trigger = false
                        end
                    end
                
                    if elements[v.owner] then
                        setVehicleEngineState(elements[v.owner], false)
                        setVehicleOverrideLights(elements[v.owner], 1)
                    end

                end
            end
        end
    end
end)

function createSystemWater(plr, x, y, z)
    elements[plr] = createVehicle(407, x, y, z)
    setElementCollisionsEnabled(elements[plr], false)
    setElementAlpha(elements[plr], 0)
    setElementData(elements[plr], "vehicle:linia:owner", plr)
    --attachElements(veh, own, 0.4, -1.4, -1.5)
    exports["bone_attach"]:attachElementToBone(elements[plr], plr, 1, 0.4, -1.4, -2, 0, 0, 0)
    elements[elements[plr]] = createPed(0, x, y, z)
    setElementAlpha(elements[elements[plr]], 0)
    warpPedIntoVehicle(elements[elements[plr]], elements[plr])
    setVehicleEngineState(elements[plr], false)
end

function destroySystemWater(plr)
    if elements[plr] then
        if elements[elements[plr]] then
            if isElement(elements[elements[plr]]) then
                destroyElement(elements[elements[plr]])
                elements[elements[plr]] = nil
            end
        end
        if isElement(elements[plr]) then
            destroyElement(elements[plr])
            elements[plr] = nil
        end
    end
end

addEventHandler("onClientVehicleStartEnter", getRootElement(), function(plr)
    for i,v in ipairs(owners) do
        if v[1] == plr then
            cancelEvent()
        end
    end
end)

addEventHandler("onClientPlayerHitByWaterCannon", root, function()
    cancelEvent()
end)

addEvent("enonek-firehose:synchronizeclient:water", true)
addEventHandler("enonek-firehose:synchronizeclient:water", resourceRoot, function(plr, state)
    if state then
        if elements[elements[plr]] then
            setPedControlState(elements[elements[plr]], "vehicle_fire", true)
        end
    else
        if elements[elements[plr]] then
            setPedControlState(elements[elements[plr]], "vehicle_fire", false)
        end
    end
end)

addEvent("enonek-firehose:synchronizeclient:linia", true)
addEventHandler("enonek-firehose:synchronizeclient:linia", resourceRoot, function(own)
    destroySystemWater(own)
    firehose[own] = nil
    for i,v in ipairs(owners) do
        if v[1] == own then
            table.remove(owners, i)
        end
    end
end)
getResourceName(getThisResource(), true, 988327231); if true then return end