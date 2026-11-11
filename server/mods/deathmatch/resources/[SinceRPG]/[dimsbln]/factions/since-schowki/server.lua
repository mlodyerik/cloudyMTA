

--[[
    Author: EnoNeK
    For: SinceRPG
-]]

local markers = {}

function toggle(veh)
    local data = getElementData(veh, "vehicle:fraction:interaction")
    if data.state then
        if data.mode then
            data.mode = false
            setElementData(veh, "vehicle:fraction:interaction", data)
            triggerClientEvent(root, "enonek-schowki:client:delete", resourceRoot, veh)
        else
            data.mode = true
            setElementData(veh, "vehicle:fraction:interaction", data)
            triggerClientEvent(root, "enonek-schowki:client:create", resourceRoot, veh)
        end
    end
    --[[if markers[veh] then
        destroyElement(markers[veh])
        markers[veh] = nil
        local data = getElementData(veh, "vehicle:fraction:interaction")
        data.mode = false
        setElementData(veh, "vehicle:fraction:interaction", data)
    else
        --local pos = Vector3(getElementPosition(veh))
        --markers[veh] = createMarker(pos.x, pos.y, pos.z, "cylinder", 1, 60, 60, 60)
        --cols[veh] = createColSphere(pos.x, pos.y, pos.z, 2)
        --attachElements(cols[veh], veh, 0, -3.8, -0.7)
        --attachElements(markers[veh], veh, 0, -3.8, -0.7)
        local data = getElementData(veh, "vehicle:fraction:interaction")
        data.mode = true
        setElementData(veh, "vehicle:fraction:interaction", data)
        triggerClientEvent(root, "enonek-schowki:client:create", resourceRoot, veh)
        table.insert(markers, {vehicle=veh})
    end--]]
end

local wiadra = {}
local r1 = {}

addEvent("enonek-schowki:wyjmij:wiadro", true)
addEventHandler("enonek-schowki:wyjmij:wiadro", resourceRoot, function()
    if wiadra[client] then
        if exports["bone_attach"]:isElementAttachedToBone(wiadra[client], client) then 
            destroyElement(wiadra[client])
            wiadra[client] = nil
            removeElementData(client, "schowek:ma:wiadro")
        end
    else
        local x, y, z = getElementPosition(client)
        wiadra[client] = createObject(2713, x, y, z)
        exports["bone_attach"]:attachElementToBone(wiadra[client], client, 12, 0, 0, 0.36, 0, 180, 90)
        setElementData(client, "schowek:ma:wiadro", true)
    end
end)

addEvent("enonek-schowki:wyjmij:r1", true)
addEventHandler("enonek-schowki:wyjmij:r1", resourceRoot, function()
    if r1[client] then
        if exports["bone_attach"]:isElementAttachedToBone(r1[client], client) then 
            destroyElement(r1[client])
            r1[client] = nil
            removeElementData(client, "schowek:ma:r1")
        end
    else
        local x, y, z = getElementPosition(client)
        r1[client] = createObject(1210, x, y, z)
        exports["bone_attach"]:attachElementToBone(r1[client], client, 12, 0, 0, 0.36, 0, 180, 0)
        setElementData(client, "schowek:ma:r1", true)
    end
end)

addEvent("enonek-schowki:wyjmij:rozpierak", true)
addEventHandler("enonek-schowki:wyjmij:rozpierak", resourceRoot, function()
    if getPedWeapon(client, 7) == 37 then
        takeWeapon(client, 37)
        removeElementData(client, "schowek:ma:rozpierak")
    else
        giveWeapon(client, 37)
        setElementData(client, "schowek:ma:rozpierak", true)
    end
end)

--addEvent("enonek-schowki:wyjmij:gasnica", true)
--addEventHandler("enonek-schowki:wyjmij:gasnica", resourceRoot, function()
    --if getPedWeapon(client, 8) == 42 then
        --takeWeapon(client, 42)
        --removeElementData(client, "schowek:ma:gasnica")
    --else
        --giveWeapon(client, 42)
        --setElementData(client, "schowek:ma:gasnica", true)
    --end
--end)

addEvent("enonek-schowki:wyjmij:liniag", true)
addEventHandler("enonek-schowki:wyjmij:liniag", resourceRoot, function()
    triggerClientEvent(client, "enonek-firehose:toggle", root)
end)

addEvent("enonek-schowki:wyjmij:pradownica", true)
addEventHandler("enonek-schowki:wyjmij:pradownica", resourceRoot, function()
    if getPedWeapon(client, 9) == 42 then
        takeWeapon(client, 42)
        removeElementData(client, "schowek:ma:pradownica")
    else
        giveWeapon(client, 42)
        setElementData(client, "schowek:ma:pradownica", true)
    end
end)

addEvent("enonek-schowki:wyjmij:pila", true)
addEventHandler("enonek-schowki:wyjmij:pila", resourceRoot, function()
    if getPedWeapon(client, 1) == 9 then
        takeWeapon(client, 9)
        removeElementData(client, "schowek:ma:pila")
    else
        giveWeapon(client, 9)
        setElementData(client, "schowek:ma:pila", true)
    end
end)

addEvent("enonek-schowki:wyjmij:aodo", true)
addEventHandler("enonek-schowki:wyjmij:aodo", resourceRoot, function()
    if getElementModel(client) == 278 then
        if getElementData(client, "aodo:last:skin") then
            setElementModel(client, getElementData(client, "aodo:last:skin"))
            removeElementData(client, "schowek:ma:aodo")
        end
    else
        setElementData(client, "aodo:last:skin", getElementModel(client))
        setElementModel(client, 278)
        setElementData(client, "schowek:ma:aodo", true)
    end
end)

addEvent("enonek-schowki:wyjmij:ratownik", true)
addEventHandler("enonek-schowki:wyjmij:ratownik", resourceRoot, function()
    if getElementModel(client) == 274 then
        if getElementData(client, "ratownik:last:skin") then
            setElementModel(client, getElementData(client, "ratownik:last:skin"))
            removeElementData(client, "schowek:ma:ratownik")
        end
    else
        setElementData(client, "ratownik:last:skin", getElementModel(client))
        setElementModel(client, 274)
        setElementData(client, "schowek:ma:ratownik", true)
    end
end)

addCommandHandler("wiadro", function(plr, cmd)
    if (getElementData(plr, "player:faction") == "SARA" or getElementData(plr, "player:faction") == "SAFD") then
        local x, y, z = getElementPosition(plr)
        if wiadra[plr] then
            if exports["bone_attach"]:isElementAttachedToBone(wiadra[plr], plr) then
                exports["bone_attach"]:detachElementFromBone(wiadra[plr])
                setElementPosition(wiadra[plr], x, y, z - 0.85)
                setElementRotation(wiadra[plr], 0, 0, 0)
                setElementFrozen(wiadra[plr], true)
                setElementCollisionsEnabled(wiadra[plr], false)
            elseif not exports["bone_attach"]:isElementAttachedToBone(wiadra[plr], plr) then
                local x2, y2, z2 = getElementPosition(wiadra[plr])
                local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
                if distance < 3 then
                    exports["bone_attach"]:attachElementToBone(wiadra[plr], plr, 12, 0, 0, 0.36, 0, 180, 90)
                end
            end
        end
    end
end)

addCommandHandler("r1", function(plr, cmd)
    if getElementData(plr, "player:faction") == "SAMD" or getElementData(plr, "player:faction") == "SAFD" then
        local x, y, z = getElementPosition(plr)
        if r1[plr] then
            if exports["bone_attach"]:isElementAttachedToBone(r1[plr], plr) then
                local rx, ry, rz = getElementRotation(r1[plr])
                exports["bone_attach"]:detachElementFromBone(r1[plr])
                destroyElement(r1[plr])
                r1[plr] = nil
                r1[plr] = createObject(1881, x, y, z)
                setElementPosition(r1[plr], x, y, z - 0.8)
                setElementRotation(r1[plr], 0, 0, rz)
                setElementFrozen(r1[plr], true)
                setElementCollisionsEnabled(r1[plr], false)
            elseif not exports["bone_attach"]:isElementAttachedToBone(r1[plr], plr) then
                local x2, y2, z2 = getElementPosition(r1[plr])
                local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
                if distance < 3 then
                    destroyElement(r1[plr])
                    r1[plr] = nil
                    r1[plr] = createObject(1210, x, y, z)
                    exports["bone_attach"]:attachElementToBone(r1[plr], plr, 12, 0, 0, 0.36, 0, 180, 0)
                end
            end
        end
    end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    if r1[source] then
        destroyElement(r1[source])
        r1[source] = nil
    end

    if wiadra[source] then
        destroyElement(wiadra[source])
        wiadra[source] = nil
    end
end)