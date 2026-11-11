engineImportTXD(engineLoadTXD("files/rozpierak.txd"), 361)
engineReplaceModel(engineLoadDFF("files/rozpierak.dff"), 361)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function toggle()
    if getPedWeapon(localPlayer) == 37 then
        local x, y, z = getElementPosition(localPlayer)
        local offx, offy, offz = getPositionFromElementOffset(localPlayer, 0, 1.1, 0)

        if isLineOfSightClear(x,y,z,offx,offy,offz,false,true,false,false,false) then
            return false
        end

        local hit,_,_,_,veh,_,_,_,_,_,component = processLineOfSight(x,y,z,offx,offy,offz,false,true,false,false,false)

        if not hit or not veh or not component then
            return false
        end

        if getElementType(veh) ~= "vehicle" then
            return false
        end

        if component == 5 then
            component = 2
        elseif component == 6 then
            component = 3
        elseif component == 7 then
            component = 4
        elseif component == 8 then
            component = 5
        else
            outputChatBox('ⓘ Musisz stać przodem do wybranych drzwi!', 255, 255, 0, true)
            return false
        end

        triggerServerEvent("enonek-rozpierak:start", resourceRoot, veh, component)
    end


end
bindKey("h", "down", toggle)

function enableSound(x, y, z)
    --[[sound = playSound3D('files/rozpierak.mp3', x, y, z, false)
    setSoundVolume(sound, 15)
    setSoundMaxDistance(sound, 15)]]
end
addEvent("enonek-rozpierak:enableSound", true)
addEventHandler("enonek-rozpierak:enableSound", resourceRoot, enableSound)

function disableSound()
    setSoundVolume(sound, 0)
    stopSound(sound)
end
addEvent("enonek-rozpierak:disableSound", true);
addEventHandler("enonek-rozpierak:disableSound", resourceRoot, disableSound)
getResourceName(getThisResource(), true, 365165153); if true then return end