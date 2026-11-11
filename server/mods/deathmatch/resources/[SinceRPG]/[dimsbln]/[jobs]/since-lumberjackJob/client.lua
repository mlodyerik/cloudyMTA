local marker = createMarker(-1124.38, -1639.47, 76.80-0.95, 'cylinder', 3, 125, 255, 125, 50)
createBlipAttachedTo(marker, 46, 2, 255,255,255,0,0, 500)
setElementData(marker, 'marker:title', 'Drwal')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler('onClientMarkerHit', marker, function(plr)
    if plr ~= localPlayer then return end
    exports['since-jobs']:showJobGui('drwal', source)
end)

local cache = {}

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if (job == 'drwal') then
        showPanel()
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if (job == 'drwal') then
        triggerServerEvent('onJobFinish', resourceRoot)
    end
end)

addEvent('onJobFinallyStart', true)
addEventHandler('onJobFinallyStart', resourceRoot, function(course, car, sprinter)
    loadJob(course)
    if car then
        cache.car = car
    end
    if sprinter then
        cache.sprinter = (sprinter == 1 and true or false)
    end
end)

addEvent('onJobFinallyFinish', true)
addEventHandler('onJobFinallyFinish', resourceRoot, function()
    destroyJob()
end)

addEvent('onPlayerCutTree', true)
addEventHandler('onPlayerCutTree', resourceRoot, function(id, player)
    if (not cache.objects) then return end
    for i,v in ipairs(cache.objects) do
        if (v.id == id) then
            if isElement(v.object) then
                destroyElement(v.object)
            end
            if isElement(v.blip) then
                destroyElement(v.blip)
            end
            table.remove(cache.objects, i)
            outputDebugString('Usunięto obiekt o ID: '..id)
            break
        end
    end
    if (player == localPlayer) then
        cache.holdinItem = true
        cache.showCar = true
        toggleMoveing(true)
        toggleControls(true)
    end
end)

addEvent('onPlayerPutWood', true)
addEventHandler('onPlayerPutWood', resourceRoot, function()
    cache.holdinItem = nil
    cache.showCar = nil
    toggleMoveing(true)
    toggleControls(false)
end)

addEvent('onPlayerFillTruck', true)
addEventHandler('onPlayerFillTruck', resourceRoot, function(state)
    cache.filledCar = state
    if cache.unloadBlip then
        if isElement(cache.unloadBlip) then
            destroyElement(cache.unloadBlip)
        end
        cache.unloadBlip = nil
    end
    if cache.unloadMarker then
        if isElement(cache.unloadMarker) then
            destroyElement(cache.unloadMarker)
        end
        cache.unloadMarker = nil
    end
    if state then
        local x,y,z = unpack(getUnloadPoint())
        cache.unloadBlip = createBlip(x, y, z, 41, 2, 255,255,255,0,0, 500)
        cache.unloadMarker = createMarker(x, y, z-1, 'cylinder', 2, 125, 255, 125, 50)
        setElementData(cache.unloadMarker, 'marker:title', 'Drwal')
        setElementData(cache.unloadMarker, 'marker:desc', 'Wyładowanie drewna')
        setElementData(cache.unloadMarker, 'marker:icon', 'pack')
    end
end)

addEvent('onPlayerTakeWood', true)
addEventHandler('onPlayerTakeWood', resourceRoot, function(state)
    cache.holdinItem = state
    toggleMoveing(true)
    toggleControls(state)
end)

function onMarkerHit(element, md)
    if (element ~= localPlayer or not md) then 
        return false
    end
    if (source ~= cache.unloadMarker) then
        return false
    end
    if (not cache.holdinItem) then
        return false
    end
    toggleMoveing(false)
    triggerServerEvent('onPlayerUnloadWood', resourceRoot)
end

function loadJob(course)
    if (not cache.textures) then
        cache.textures = {}
        cache.textures['car'] = dxCreateTexture('assets/images/others/car.png')
        cache.textures['tree'] = dxCreateTexture('assets/images/others/tree.png')
    end
    if (not cache.fonts) then
        cache.fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 13/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        }
    end
    if (cache.objects) then
        for i,v in ipairs(cache.objects) do
            if isElement(v.object) then
                destroyElement(v.object)
            end
            if isElement(v.blip) then
                destroyElement(v.blip)
            end
        end
    end
    cache.objects = {}
    local data = getCourseById(course)
    if (data.points) then
        for i,v in ipairs(data.points) do
            local object = createObject(729, v[1], v[2], v[3]-1)
            local blip = createBlipAttachedTo(object, 41, 2, 255,255,255,0,0, 500)
            table.insert(cache.objects, {object = object, blip = blip, id = i})
        end
    end
    if (not cache.loaded) then
        toggleMoveing(true)
        toggleControls(false)
        addEventHandler('onClientRender', root, renderJob)
        addEventHandler('onClientMarkerHit', resourceRoot, onMarkerHit)
        bindKey('e', 'down', onPlayerKeyPress)
        cache.loaded = true
    end
end

function destroyJob()
    if (cache.objects) then
        for i,v in ipairs(cache.objects) do
            if isElement(v.object) then
                destroyElement(v.object)
            end
            if isElement(v.blip) then
                destroyElement(v.blip)
            end
        end
    end
    if (cache.textures) then
        for i,v in pairs(cache.textures) do
            if isElement(v) then
                destroyElement(v)
            end
        end
    end
    if (cache.loaded) then
        removeEventHandler('onClientRender', root, renderJob)
        removeEventHandler('onClientMarkerHit', resourceRoot, onMarkerHit)
        unbindKey('e', 'down', onPlayerKeyPress)
        cache.loaded = nil
    end
    if cache.unloadBlip then
        if isElement(cache.unloadBlip) then
            destroyElement(cache.unloadBlip)
        end
    end
    if cache.unloadMarker then
        if isElement(cache.unloadMarker) then
            destroyElement(cache.unloadMarker)
        end
    end
    cache = {}
end

function renderJob()
    local px, py, pz = getElementPosition(localPlayer)
    local draw = false
    for i,v in ipairs(cache.objects) do
        local x, y, z = getElementPosition(v.object)
        local sxx, syy = getScreenFromWorldPosition(x, y, z+0.6)
        if (sxx and syy) then
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            if (distance < 3) then
                draw = 1
            end
            dxDrawImage(sxx-25/zoom, syy-55/zoom, 50/zoom, 50/zoom, cache.textures['tree'])
            dxDrawText(math.floor(distance)..' m.', sxx, syy-60/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[1], 'center', 'bottom')
        end
    end
    if (isEventHandlerAdded('onClientRender', root, renderMiniGame)) then
        return false
    end
    if (isElement(cache.car) and getPedOccupiedVehicle(localPlayer) ~= cache.car) then
        if (cache.showCar or cache.filledCar) then
            local x, y, z = getElementOffsetPosition(cache.car, 0, -3, -0.2)
            local sxx, syy = getScreenFromWorldPosition(x, y, z)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            if (sxx and syy) then
                dxDrawImage(sxx-25/zoom, syy-55/zoom, 50/zoom, 50/zoom, cache.textures['car'])
                dxDrawText(math.floor(distance)..' m.', sxx, syy-60/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[1], 'center', 'bottom')
            end
            if (distance < 2) then
                if cache.filledCar then
                    draw = 3
                else
                    draw = 2
                end
            end
        end
    end
    if (draw == 1) then
        dxDrawText('Kliknij E, aby ściąć drzewo', sx/2-1, sy-100/zoom-1, nil, nil, tocolor(0,0,0,155), 1, cache.fonts[2], 'center', 'bottom')
        dxDrawText('Kliknij #00FF00E#FFFFFF, aby ściąć drzewo', sx/2, sy-100/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[2], 'center', 'bottom', false, false, false, true)
    elseif (draw == 2) then
        dxDrawText('Kliknij E, aby odstawić drewno', sx/2-1, sy-100/zoom-1, nil, nil, tocolor(0,0,0,155), 1, cache.fonts[2], 'center', 'bottom')
        dxDrawText('Kliknij #00FF00E#FFFFFF, aby odstawić drewno', sx/2, sy-100/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[2], 'center', 'bottom', false, false, false, true)
    elseif (draw == 3) then
        dxDrawText('Kliknij E, aby wyładować drewno', sx/2-1, sy-100/zoom-1, nil, nil, tocolor(0,0,0,155), 1, cache.fonts[2], 'center', 'bottom')
        dxDrawText('Kliknij #00FF00E#FFFFFF, aby wyładować drewno', sx/2, sy-100/zoom, nil, nil, tocolor(255,255,255), 1, cache.fonts[2], 'center', 'bottom', false, false, false, true)
    end
end

function getObjectId(element)
    for i,v in ipairs(cache.objects) do
        if (v.object == element) then
            return v.id
        end
    end
    return false
end

local tick = getTickCount()
function onPlayerKeyPress()
    if (tick > getTickCount()) then 
        return false
    end
    tick = getTickCount() + 500
    local px, py, pz = getElementPosition(localPlayer)
    local nearestObject = getNearestElement(localPlayer, 'object', 3)
    if (cache.car and isElement(cache.car) and cache.filledCar and not cache.holdinItem) then
        local x, y, z = getElementOffsetPosition(cache.car, 0, -3, 0.2)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if (distance < 2) then
            if isPedInVehicle(localPlayer) then
                return false
            end
            toggleMoveing(false)
            triggerServerEvent('onPlayerTakeWood', resourceRoot)
            return true
        end
    end
    if (cache.car and isElement(cache.car) and cache.showCar and cache.holdinItem) then
        local x, y, z = getElementOffsetPosition(cache.car, 0, -3, 0.2)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if (distance < 2) then
            if isPedInVehicle(localPlayer) then
                return false
            end
            toggleMoveing(false)
            triggerServerEvent('onPlayerPutWood', resourceRoot)
            return true
        end
    end
    if (nearestObject) then
        local x, y, z = getElementPosition(nearestObject)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if (distance < 3 and getElementModel(nearestObject) == 729) then
            if isPedInVehicle(localPlayer) then
                return false
            end
            toggleMoveing(false)
            triggerServerEvent('onPlayerTryCutTree', resourceRoot, getObjectId(nearestObject))
            return true
        end
    end
end

local minigame = {}

function renderMiniGame()
    dxDrawImage(sx/2-165/zoom, sy-280/zoom, 330/zoom, 195/zoom, minigame.textures.bg)
    dxDrawText('Ściananie drzewa', sx/2, sy-270/zoom, nil, nil, tocolor(255,255,255), 1, minigame.fonts[1], 'center', 'top')
    dxDrawText('Klikaj odpowiednią kombinacje klawiszy', sx/2, sy-245/zoom, nil, nil, tocolor(104,214,94), 1, minigame.fonts[2], 'center', 'top')

    if not isElement(minigame.rt) then
        minigame.rt = dxCreateRenderTarget(300, 70, true)
    end
    local offset = minigame.position
    dxSetRenderTarget(minigame.rt, true)
        for i,v in ipairs(minigame.keys) do
            dxDrawImage(offset + 70, 5, 60, 60, minigame.textures['circleInner'])
            local color = v[2] == 0 and tocolor(255, 255, 255, 255) or v[2] == 1 and tocolor(104,214,94,255) or tocolor(255, 0, 0, 255)
            dxDrawImage(offset + 70, 5, 60, 60, minigame.textures['circle'], 0, 0, 0, color)
            dxDrawText(string.upper(v[1]), offset + 70, 5, offset + 130, 65, tocolor(255, 255, 255, 255), 1, minigame.fonts[1], 'center', 'center', false, false, false, true)
            offset = offset + 80
        end
    dxSetRenderTarget()

    dxDrawImage(sx/2-150/zoom, sy-220/zoom, 300/zoom, 70/zoom, minigame.shader)

    dxDrawText('Postęp ścinania', sx/2, sy-140/zoom, nil, nil, tocolor(255,255,255), 1, minigame.fonts[3], 'center', 'top')
    dxDrawText((math.floor(minigame.progress))..'%', sx/2, sy-115/zoom, nil, nil, tocolor(104,214,94), 1, minigame.fonts[2], 'center', 'top')

    minigame.position = minigame.position - 1

    -- if getKeyState('space') then
    --     minigame.position = minigame.position - 10
    -- end

    if (minigame.position < -((#minigame.keys + 1) * 80)) then
        if minigame.finished then
            minigame.finished = nil
            triggerServerEvent('onPlayerCutTree', resourceRoot, minigame.treeID)
            toggleMiniGame(false)
        else
            minigame.position = 270
            for i,v in ipairs(minigame.keys) do
                if v[2] == 2 then
                    v[2] = 0
                end
            end
            getNextKey()
        end
    end
end

function getNextKey()
    minigame.keyProgress = 1
    for i,v in ipairs(minigame.keys) do
        if v[2] ~= 0 and minigame.keyProgress == i then
            minigame.keyProgress = i+1
        end
    end
end

function onKey(key, state)
    if not state or not minigame.keys or minigame.finished then
        return
    end
    if not tonumber(key) then
        return
    end
    local key = tostring(key)
    for i,v in ipairs(minigame.keys) do
        if i == minigame.keyProgress and v[2] == 0 then
            if v[1] == key then
                v[2] = 1
                getNextKey()
                minigame.progress = minigame.progress + 10
                if minigame.progress >= 100 then
                    minigame.finished = true
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

function toggleMiniGame(state, treeID)
    if state then
        if (isEventHandlerAdded('onClientRender', root, renderMiniGame)) then
            return false
        end
        toggleMoveing(false)
        minigame.textures = {}
        minigame.fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 13/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            [3] = exports['since-fonts']:getFont('Inter-Bold', 11/zoom),
        }
        for i,v in ipairs({'circleInner', 'circle', 'bg', 'mask'}) do
            minigame.textures[v] = dxCreateTexture('assets/images/minigame/'..v..'.png')
        end
        minigame.keys = getKeys()
        minigame.tick = getTickCount()
        minigame.progress = 0
        minigame.position = 270
        minigame.keyProgress = 1
        minigame.shader = dxCreateShader('assets/shaders/shader.fx')
        minigame.rt = dxCreateRenderTarget(300, 70, true)
        minigame.treeID = treeID
        dxSetShaderValue(minigame.shader, "sPicTexture", minigame.rt)
        dxSetShaderValue(minigame.shader, "sMaskTexture", minigame.textures['mask'])
        addEventHandler('onClientRender', root, renderMiniGame)
        addEventHandler('onClientKey', root, onKey)
    else
        if (not isEventHandlerAdded('onClientRender', root, renderMiniGame)) then
            return false
        end
        removeEventHandler('onClientRender', root, renderMiniGame)
        removeEventHandler('onClientKey', root, onKey)
        if minigame.textures then
            for i,v in pairs(minigame.textures) do
                destroyElement(v)
            end
        end
        minigame.textures = nil
        minigame.fonts = nil
        minigame.keys = nil
        minigame.tick = nil
        minigame.progress = nil
        minigame.position = nil
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

addEvent('onPlayerStartCutTree', true)
addEventHandler('onPlayerStartCutTree', resourceRoot, function(id)
    toggleMiniGame(true, id)
end)

function getElementOffsetPosition(element, offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z      
end

function getNearestElement(player, type, distance)
    local result = false
    local dist = nil
    if player and isElement(player) then
        local elements = getElementsWithinRange(Vector3(getElementPosition(player)), distance, type, getElementInterior(player), getElementDimension(player))
        for i = 1, #elements do
            local element = elements[i]
            if element ~= player then
                if not dist then
                    result = element
                    dist = getDistanceBetweenPoints3D(Vector3(getElementPosition(player)), Vector3(getElementPosition(element)))
                else
                    local newDist = getDistanceBetweenPoints3D(Vector3(getElementPosition(player)), Vector3(getElementPosition(element)))
                    if newDist <= dist then
                        result = element
                        dist = newDist
                    end
                end
            end
        end
    end
    return result
end

function toggleMoveing(state)
    toggleControl('forwards', state)
    toggleControl('backwards', state)
    toggleControl('left', state)
    toggleControl('right', state)
end

addEvent('toggleMoveing', true)
addEventHandler('toggleMoveing', resourceRoot, function(state)
    toggleMoveing(state)
end)

function toggleControls(state)
    if state then
        for i,v in ipairs({'walk','crouch','sprint','jump','enter_exit','enter_passenger'}) do
            toggleControl(v, false)
        end
        setControlState(localPlayer, 'walk', not cache.sprinter)
    else
        for i,v in ipairs({'walk','crouch','sprint','jump','enter_exit','enter_passenger'}) do
            toggleControl(v, true)
        end
        setControlState(localPlayer, 'walk', false)
    end
end