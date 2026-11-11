local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048 and math.min(2.2, 2048/sx) or 1 )* 0.9
local cache = {}

function render()
    if not getPedOccupiedVehicle(localPlayer) then
        destroyRobbery()
        destroyNextRobbery()
        return
    end
    dxDrawImage(sx/2-165/zoom, sy-280/zoom, 330/zoom, 195/zoom, cache.textures.bg)
    dxDrawText('Wykradanie pojazdu', sx/2, sy-270/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[1], 'center', 'top')
    dxDrawText('Klikaj odpowiednią kombinacje klawiszy', sx/2, sy-245/zoom, nil, nil, tocolor(104,214,94), 1, cache.fonts[2], 'center', 'top')

    if not isElement(cache.rt) then
        cache.rt = dxCreateRenderTarget(300, 70, true)
    end
    local offset = cache.position
    dxSetRenderTarget(cache.rt, true)
        for i,v in ipairs(cache.keys) do
            dxDrawImage(offset + 70, 5, 60, 60, cache.textures['circleInner'])
            local color = v[2] == 0 and tocolor(255, 255, 255, 255) or v[2] == 1 and tocolor(104,214,94,255) or tocolor(255, 0, 0, 255)
            dxDrawImage(offset + 70, 5, 60, 60, cache.textures['circle'], 0, 0, 0, color)
            dxDrawText(string.upper(v[1]), offset + 70, 5, offset + 130, 65, tocolor(255, 255, 255, 255), 1, cache.fonts[1], 'center', 'center', false, false, false, true)
            offset = offset + 80
        end
    dxSetRenderTarget()

    dxDrawImage(sx/2-150/zoom, sy-220/zoom, 300/zoom, 70/zoom, cache.shader)

    dxDrawText('Postęp wykradania', sx/2, sy-140/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[3], 'center', 'top')
    dxDrawText((math.floor(cache.progress))..'%', sx/2, sy-115/zoom, nil, nil, tocolor(104,214,94), 1, cache.fonts[2], 'center', 'top')

    cache.position = cache.position - 1

    if (cache.position < -((#cache.keys + 1) * 80)) then
        if cache.finished then
            cache.finished = nil
            triggerServerEvent('onServerFinishRobbery', resourceRoot, getPedOccupiedVehicle(localPlayer))
            destroyRobbery()
        else
            cache.position = 270
            for i,v in ipairs(cache.keys) do
                if v[2] == 2 then
                    v[2] = 0
                end
            end
            getNextKey()
        end
    end
end

function getNextKey()
    cache.keyProgress = 1
    for i,v in ipairs(cache.keys) do
        if v[2] ~= 0 and cache.keyProgress == i then
            cache.keyProgress = i+1
        end
    end
end

function onKey(key, state)
    if not state or not cache.keys or cache.finished then
        return
    end
    if not tonumber(key) then
        return
    end
    local key = tostring(key)
    for i,v in ipairs(cache.keys) do
        if i == cache.keyProgress and v[2] == 0 then
            if v[1] == key then
                v[2] = 1
                getNextKey()
                cache.progress = cache.progress + 10
                if cache.progress >= 100 then
                    cache.finished = true
                end
                break
            elseif v[1] ~= key then
                v[2] = 2
                getNextKey()
                break
            end
        end
    end
end

function getKeys()
    local keys = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
    local data = {}
    for i=1,10 do
        table.insert(data, {tostring(keys[math.random(1, #keys)]), 0})
    end
    return data
end

function restartRobbery()
    if not isEventHandlerAdded('onClientRender', root, render) then
        return
    end
    cache.keys = getKeys()
    cache.tick = getTickCount()
    cache.progress = 0
    cache.position = 0
    cache.keyProgress = 1
end

function destroyRobbery()
    if not isEventHandlerAdded('onClientRender', root, render) then
        return
    end
    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientKey', root, onKey)
    if cache.textures then
        for i,v in pairs(cache.textures) do
            destroyElement(v)
        end
    end
    cache.textures = nil
    cache.fonts = nil
    cache.keys = nil
    cache.tick = nil
    cache.progress = nil
    cache.position = nil
end

addEvent('onClientStartRobbery', true)
addEventHandler('onClientStartRobbery', resourceRoot, function(vehicle)
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or veh ~= vehicle then
        return
    end
    if isEventHandlerAdded('onClientRender', root, render) then
        restartRobbery(vehicle)
    else
        if cache.textures then
            for i,v in pairs(cache.textures) do
                destroyElement(v)
            end
        end
        cache.textures = {}
        cache.fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 13/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            [3] = exports['since-fonts']:getFont('Inter-Bold', 11/zoom),
        }
        for i,v in ipairs({'circleInner', 'circle', 'bg', 'mask'}) do
            cache.textures[v] = dxCreateTexture('files/images/'..v..'.png')
        end
        cache.keys = getKeys()
        cache.tick = getTickCount()
        cache.progress = 0
        cache.position = 270
        cache.keyProgress = 1
        cache.shader = dxCreateShader('files/shaders/shader.fx')
        cache.rt = dxCreateRenderTarget(300, 70, true)
        dxSetShaderValue(cache.shader, "sPicTexture", cache.rt)
        dxSetShaderValue(cache.shader, "sMaskTexture", cache.textures['mask'])
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientKey', root, onKey)
    end
end)

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
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

function destroyNextRobbery()
    if cache.blip then
        if isElement(cache.blip) then
            destroyElement(cache.blip)
        end
        cache.blip = nil
    end
end

addEvent('onClientFinishRobbery', true)
addEventHandler('onClientFinishRobbery', resourceRoot, function(position)
    if cache.blip then
        if isElement(cache.blip) then
            destroyElement(cache.blip)
        end
    end
    cache.blip = createBlip(position[1], position[2], position[3], 41, 2, 255, 0, 0, 255, 0, 99999)
end)

addEvent('onClientDestroyNextRobbery', true)
addEventHandler('onClientDestroyNextRobbery', resourceRoot, function()
    destroyNextRobbery()
end)

addEventHandler('onClientVehicleStartExit', resourceRoot, function(player, seat)
    if (player ~= localPlayer) or (seat ~= 0) then
        return
    end
    destroyRobbery()
    destroyNextRobbery()
end)

addEvent('onClientCreateExport', true)
addEventHandler('onClientCreateExport', resourceRoot, function(position)
    if cache.exportBlip then
        if isElement(cache.exportBlip) then
            destroyElement(cache.exportBlip)
        end
    end
    if cache.exportMarker then
        if isElement(cache.exportMarker) then
            destroyElement(cache.exportMarker)
        end
    end
    cache.exportBlip = createBlip(position[1], position[2], position[3], 41, 2, 255, 0, 0, 255, 0, 99999)
    cache.exportMarker = createMarker(position[1], position[2], position[3]-1, 'cylinder', 5, 255, 255, 255, 150)
    addEventHandler('onClientMarkerHit', cache.exportMarker, function(player, md)
        if (player ~= localPlayer or not md) then
            return
        end
        triggerServerEvent('onServerFinishExport', resourceRoot)
    end)
end)

addEvent('onClientDestroyExport', true)
addEventHandler('onClientDestroyExport', resourceRoot, function()
    if cache.exportBlip then
        if isElement(cache.exportBlip) then
            destroyElement(cache.exportBlip)
        end
        cache.exportBlip = nil
    end
    if cache.exportMarker then
        if isElement(cache.exportMarker) then
            destroyElement(cache.exportMarker)
        end
        cache.exportMarker = nil
    end
end)