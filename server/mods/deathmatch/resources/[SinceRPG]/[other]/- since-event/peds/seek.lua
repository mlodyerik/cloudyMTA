function isClear(x, y, z, ex, ey, ez)
    local clear = isLineOfSightClear(x, y, z, ex, ey, ez, true, true, false, true, false, false, false, localPlayer)
    dxDrawLine3D(x, y, z, ex, ey, ez, clear and tocolor(46, 117, 111) or tocolor(255, 0, 0), 2)
    return clear
end

function pedWalk(ped)
    setPedControlState(ped, 'forwards', true)
    setPedControlState(ped, 'walk', true)
    local seekPosition = getElementData(ped, 'event:seek:position')

    local x, y, z = getElementPosition(ped)
    local inFront = Vector3(getPositionFromElementOffset(ped, 0, 2, 0))
    local clear = isClear(x, y, z, inFront.x, inFront.y, inFront.z)

    local rot = getPedRotation(ped)
    if not clear then
        local right = Vector3(getPositionFromElementOffset(ped, 2, 0, 0))
        local left = Vector3(getPositionFromElementOffset(ped, -2, 0, 0))

        if isClear(x, y, z, right.x, right.y, right.z) then
            setPedRotation(ped, rot + 90)
        elseif isClear(x, y, z, left.x, left.y, left.z) then
            setPedRotation(ped, rot - 90)
        else
            setPedRotation(ped, rot + 180)
        end
    end

    local distance = getDistanceBetweenPoints3D(x, y, z, seekPosition.x, seekPosition.y, seekPosition.z)
    if distance > seekPosition.distance then
        local rot = findRotation(x, y, seekPosition.x, seekPosition.y)
        setPedRotation(ped, rot)
    end
end

function seekForPlayer(ped, px, py, pz)
    local x, y, z = getPedBonePosition(ped, 8)
    local clear = isClear(x, y, z, px, py, pz)
    local angleDiff = angleDifference(getPedRotation(ped), findRotation(x, y, px, py))

    if clear and angleDiff < 25 then
        local angle = findRotation(px, py, x, y)
        setPedRotation(ped, angle + 180)

        -- aim weapon
        setPedControlState(ped, 'aim_weapon', true)
        setPedControlState(ped, 'forwards', false)
        setPedAimTarget(ped, px, py, pz)

        if not getElementData(ped, 'event:seek:spot-time') then
            setElementData(ped, 'event:seek:spot-time', getTickCount())
        else
            if getTickCount() - getElementData(ped, 'event:seek:spot-time') > 1000 then
                setPedControlState(ped, 'fire', true)
            end
        end
    else
        setPedControlState(ped, 'aim_weapon', false)
        setPedControlState(ped, 'fire', false)
        setElementData(ped, 'event:seek:spot-time', false)

        if not getElementData(ped, 'event:walk-time') then
            setElementData(ped, 'event:walk-time', getTickCount())
        else
            if getTickCount() - getElementData(ped, 'event:walk-time') > 1000 then
                pedWalk(ped)
            end
        end
    end
end

-- disable weapon damage
addEventHandler('onClientPlayerDamage', root, function()
    cancelEvent()
end)

addEventHandler('onClientRender', root, function()
    local x, y, z = getElementPosition(localPlayer)
    local state = getPedMoveState(localPlayer)
    if state == 'crouch' or state == 'crawl' then z = z - 0.8 else z = z + 0.4 end
    local peds = getElementsWithinRange(x, y, z, 100, 'ped')

    for i, ped in ipairs(peds) do
        if getElementData(ped, 'event:seek') then
            seekForPlayer(ped, x, y, z)
        end
    end
end)