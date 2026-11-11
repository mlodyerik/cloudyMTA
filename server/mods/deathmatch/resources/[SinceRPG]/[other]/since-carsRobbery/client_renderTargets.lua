local cache = {}
cache.actions = {
    [1] = { 'Napraw pojazd', 'Wymaga naprawy', 'Kliknij #6CCAFFE #FFFFFFaby naprawić pojazd' },
    [2] = { 'Zmień numer VIN pojazdu', 'Wymaga zmiany numeru VIN', 'Kliknij #6CCAFFE #FFFFFFaby zmienić VIN' },
    [3] = { 'Gotowy' },
}

function showRenderTargets()
    if not cache.renderTargets then return end
    for i,v in pairs(cache.renderTargets) do
        if isElement(i) and isElement(v) then
            local x, y, z = getElementPosition(i)
            local _, _, _, _, by = getElementBoundingBox(i)
            local x, y, z = getPositionFromElementOffset(i, 0, by, 0.8)
            local lx, ly, lz = getPositionFromElementOffset(i, 0, 10, 0)
            dxDrawMaterialLine3D(x, y, z + 0.5 - 0.1, x, y, z - 0.5 - 0.1, v, 2, tocolor(255,255,255,255), false, lx, ly, lz)
        end
    end
    if cache.tick and getTickCount() - cache.tick > 100 then
        for i,v in pairs(cache.renderTargets) do
            if isElement(i) and isElement(v) then
                reloadRenderTarget(i)
            end
        end
        cache.tick = getTickCount()
    end
end

function reloadRenderTarget(vehicle)
    if not isElement(vehicle) then return end
    dxSetRenderTarget(cache.renderTargets[vehicle], true)
        dxSetBlendMode('modulate_add')  
        local model = getElementData(vehicle, 'vehicleID') or getElementModel(vehicle)
        local name = exports['since-vehiclenames']:getVehicleName(model)
        local actualAction = getElementData(vehicle, 'vehicle:robberyAction') or 1
        local cost = '#68D65E$ #FFFFFF'..formatNumber(getVehicleCost(model, actualAction))
        local state = cache.actions[actualAction][2] or 'Gotowy'
        local action = cache.actions[actualAction][3] or 'Exportuj w panelu'
        dxDrawImage(13, 4, 474, 106, cache.texture)
        dxDrawText('Pojazd', 23, 10, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'left', 'top')
        dxDrawText(name, 23, 52, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'left', 'bottom')
        
        dxDrawText('Status pojazdu', 23, 58, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'left', 'top')
        dxDrawText(state, 23, 100, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'left', 'bottom')

        dxDrawText('Wartość', 474, 10, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'right', 'top')
        dxDrawText(cost, 474, 52, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'right', 'bottom', false, false, false, true)

        dxDrawText('Akcja', 474, 58, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'right', 'top')
        dxDrawText(action, 474, 100, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'right', 'bottom', false, false, false, true)

        local textWidth = dxGetTextWidth('Lista akcji', 1, exports['since-fonts']:getFont('Inter-Black', 14))
        dxDrawText('Lista akcji', 23, 112, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'left', 'top')
        dxDrawRectangle(23, 136, textWidth, 2, tocolor(46, 117, 111, 255))

        local actions = {}
        for i,v in ipairs(cache.actions) do
            if v[2] then
                table.insert(actions, v[1])
            end
        end

        dxSetBlendMode('overwrite')

        local textHeight = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 11))

        local offset = 0
        for i,v in ipairs(actions) do
            local textWidth = dxGetTextWidth('- '..v, 1, exports['since-fonts']:getFont('Inter-Bold', 11)) + 20
            if i < actualAction then
                dxDrawText('- '..v, 23, 140 + offset, nil, nil, tocolor(255, 255, 255, 155), 1, exports['since-fonts']:getFont('Inter-Bold', 11), 'left', 'top')
                dxDrawRectangle(13, 140 + offset + textHeight/2-1, textWidth, 2, tocolor(217, 217, 217, 200))
            elseif i > actualAction then
                dxDrawText('- '..v, 23, 140 + offset, nil, nil, tocolor(255, 255, 255, 155), 1, exports['since-fonts']:getFont('Inter-Bold', 11), 'left', 'top')
            else
                dxDrawText('- '..v, 23, 140 + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11), 'left', 'top')
            end
            offset = offset + 20
        end

        dxSetBlendMode('blend')

    dxSetRenderTarget()
end

function useAction()
    local vehicle = getNearestVehicle()
    if not vehicle then return end
    local x,y,z = getElementPosition(localPlayer)
    local vx,vy,vz = getElementPosition(vehicle)
    if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) > 5 then return end
    local actualAction = getElementData(vehicle, 'vehicle:robberyAction') or 1
    triggerServerEvent('vehicle:robberyAction', resourceRoot, vehicle, actualAction)
end

function loadRenderTargets(vehicles)
    cache.tick = getTickCount()
    if not cache.texture then
        cache.texture = dxCreateTexture('files/images/rt/background.png')
    end
    if not isEventHandlerAdded('onClientRender', root, showRenderTargets) then
        addEventHandler('onClientRender', root, showRenderTargets)
    end
    if cache.renderTargets then
        for i,v in pairs(cache.renderTargets) do
            if isElement(v.element) then
                destroyElement(v.element)
            end
        end
        cache.renderTargets = nil
    end
    cache.renderTargets = {}
    for i,v in ipairs(vehicles) do
        local rt = dxCreateRenderTarget(500, 250, true)
        cache.renderTargets[v.vehicle] = rt
        reloadRenderTarget(v.vehicle)
    end
    if not cache.binded then
        bindKey('e', 'down', useAction)
        cache.binded = true
    end
end

function destroyRenderTargets()
    if isEventHandlerAdded('onClientRender', root, showRenderTargets) then
        removeEventHandler('onClientRender', root, showRenderTargets)
    end
    if cache.texture then
        if isElement(cache.texture) then
            destroyElement(cache.texture)
        end
        cache.texture = nil
    end
    if cache.renderTargets then
        for i,v in pairs(cache.renderTargets) do
            if isElement(v.element) then
                destroyElement(v.element)
            end
        end
        cache.renderTargets = nil
    end
    if cache.binded then
        unbindKey('e', 'down', useAction)
        cache.binded = nil
    end
    cache.tick = nil
end

addEventHandler('onClientElementDestroy', resourceRoot, function()
    if cache.renderTargets then
        if cache.renderTargets[source] then
            if isElement(cache.renderTargets[source]) then
                destroyElement(cache.renderTargets[source])
            end
            cache.renderTargets[source] = nil
        end
    end
end)

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        for i,v in ipairs(getEventHandlers(sEventName, pElementAttachedTo)) do
            if v == func then
                return true
            end
        end
    end
    return false
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function getNearestVehicle()
    local x, y, z = getElementPosition(localPlayer)
    local vehicles = getElementsByType('vehicle')
    local nearest = nil
    local distance = 100
    for i,v in ipairs(vehicles) do
        local vx, vy, vz = getElementPosition(v)
        local dist = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
        if dist < distance then
            distance = dist
            nearest = v
        end
    end
    return nearest
end