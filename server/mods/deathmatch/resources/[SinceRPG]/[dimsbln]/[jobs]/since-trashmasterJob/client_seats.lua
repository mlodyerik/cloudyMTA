local attaching = {}

function renderRotation()
    if not isElement(attaching.vehicle) then
        removeEventHandler('onClientPreRender', root, renderRotation)
        attaching.vehicle = nil
        attaching.rotation = nil
        attaching.render = nil
        attaching.block = nil
        return
    end
    local xo,yo,zo = getPositionFromElementOffset(attaching.vehicle, 0, -10.5, 3)
    local xv,yv,zv = getElementPosition(attaching.vehicle)
    setCameraMatrix(xo,yo,zo, xv,yv,zv)
    local xr,yr,zr = getElementRotation(attaching.vehicle)
    setPedRotation(localPlayer, zr + attaching.rotation)
end

function isPlayerAttachedToVehicle()
    return isElement(attaching.vehicle)
end

addEvent('attackInteraction', true)
addEventHandler('attackInteraction', resourceRoot, function(action, vehicle, rotation)
    if action == 'attach' then

        if attaching.block then return end
        attaching.block = true

        triggerServerEvent('attackInteraction', resourceRoot, 'attach', vehicle)
        
    elseif action == 'refresh' then

        attaching.block = nil

    elseif action == 'enable' then

        attaching.vehicle = vehicle
        attaching.rotation = rotation
        if not attaching.render then
            attaching.render = true
            addEventHandler('onClientPreRender', root, renderRotation)
        end
        attaching.block = nil

    elseif action == 'disable' then
    
        if attaching.render then
            removeEventHandler('onClientPreRender', root, renderRotation)
            attaching.vehicle = nil
            attaching.rotation = nil
            attaching.render = nil
        end
        attaching.block = nil

    elseif action == 'tryAttach' then

        if isPedInVehicle(localPlayer) then return end
        local x,y,z = getElementPosition(localPlayer)
        local ox,oy,oz = getPositionFromElementOffset(localPlayer, 0, 1.1, 0)
        if isLineOfSightClear(x,y,z,ox,oy,oz,false,true,false,false,false) then return end
        local is,_,_,_,currentVehicle = processLineOfSight(x,y,z,ox,oy,oz,false,true,false,false,false)
        if not is then return end
        if getElementType(currentVehicle) ~= 'vehicle' then return end
        if not isElement(currentVehicle) then return end
        if getElementModel(currentVehicle) ~= 408 then return end
        local vox,voy,voz = getPositionFromElementOffset(currentVehicle, 0, -4.5, 0)
        if getDistanceBetweenPoints3D(x,y,z,vox,voy,voz) > 5 then return end
        if attaching.block then return end
        attaching.block = true
        triggerServerEvent('attackInteraction', resourceRoot, 'attach', currentVehicle)

    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end