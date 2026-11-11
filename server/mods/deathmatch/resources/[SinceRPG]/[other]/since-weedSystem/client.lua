local plants, cuboids, textures, fonts, timer, data = {}, {}, {
    ['background'] = dxCreateTexture('files/images/background.png'),
    ['circle'] = dxCreateTexture('files/images/circle.png')
}, {
    [1] = exports['since-fonts']:getFont('Inter-Bold', 30),
    [2] = exports['since-fonts']:getFont('Inter-Medium', 20),
    [3] = exports['since-fonts']:getFont('Inter-Bold', 22),
    [4] = exports['since-fonts']:getFont('Inter-Medium', 15),
}, nil, {}

function getPlantsCount()
    local count = 0
    for i,v in pairs(plants) do
        count = count + 1
    end
    return count
end

function renderPlants()
	local x, y, z = getElementPosition(localPlayer)
    for element,v in pairs(plants or {}) do
        if v.shader then
            local ox, oy, oz = getElementPosition(element)
            if getDistanceBetweenPoints3D(x, y, z, ox, oy, oz) < 10 and isElementOnScreen(element) then
                dxDrawMaterialLine3D(ox, oy, oz + 1.7, ox, oy, oz + 1, v.shader, 1.1)
            end
        end
    end
end

function reloadRenderTarget(element)
    if not isElement(element) then return end
    local data = getElementData(element, 'plant:data')
    local v = plants[element]
    v.state = data.state
    if not v.id then v.id = data.id end
    if not v.ownerSid then v.ownerSid = data.ownerSid end
    if not v.ownerName then v.ownerName = data.ownerName end
    if not v.type then v.type = data.type end
    if not v.shader then v.shader = dxCreateRenderTarget(650, 440, true) end
    local elements = {}
    elements.rt = dxCreateRenderTarget(400, 400, true)
    elements.shader = dxCreateShader('files/shaders/shader.fx')
    v.progress = math.min(math.max(v.state / config[v.type or 1].time, 0), 1)
    local name = config[v.type or 1].name..(getElementData(localPlayer, 'player:admin') and ' #'..data.id or '')
    dxSetRenderTarget(elements.rt, true)
        dxSetBlendMode('modulate_add')
            dxDrawCircle(200,200,200, 0, 360,tocolor(255,255,255, 255),tocolor(255,255,255, 255),100,1)	
            if v.progress > 0 then	
                dxDrawCircle(200,200,200, 90, 90-(360*v.progress) ,tocolor(55, 55, 55, 255),tocolor(55, 55, 55, 255),100,1)
            end
        dxSetBlendMode('blend')
    dxSetRenderTarget()
    dxSetShaderValue(elements.shader, 'sPicTexture', elements.rt)
    dxSetShaderValue(elements.shader, 'sMaskTexture', textures['circle'])
    dxSetRenderTarget(v.shader, true)
        dxDrawImage(25,15,600,406,textures['background'])
        dxDrawText(name,0, 30,650,95, tocolor(255,255,255, 255), 1, fonts[1], 'center', 'top')
        dxDrawText('Typ posadzonej rośliny',0, 50,650,115, tocolor(185,185,185, 255), 1, fonts[2], 'center', 'bottom')
        dxDrawText('Właściciel rośliny',70, 140,580,140, tocolor(255,255,255, 255), 1, fonts[3], 'left', 'top')
        dxDrawText(v.ownerName,70, 210,580,210, tocolor(46, 117, 111, 255), 1, fonts[2], 'left', 'bottom')
        dxDrawText('Status',70, 215,580,215, tocolor(255,255,255, 255), 1, fonts[3], 'left', 'top', false,false,false,false,false)
        dxDrawText((v.state <= 0 and 'Do zebrania' or 'Rośnie'),70, 285,580,285, tocolor(46, 117, 111, 255), 1, fonts[2], 'left', 'bottom', false,false,false,true,false)
        dxDrawText('Zbieranie krzaka',70, 295,580,295, tocolor(255,255,255, 255), 1, fonts[3], 'left', 'top', false,false,false,false,false)
        dxDrawText('Kliknij #68D65EE #FFFFFFżeby zebrać',70, 365,580,365, tocolor(255,255,255, 255), 1, fonts[2], 'left', 'bottom', false,false,false,true,false)
        dxDrawImage(390,155,200,200,elements.shader,0,0,0,tocolor(46, 117, 111))
        dxDrawText(math.floor(100-100*v.progress)..'%',390,240,590,240, tocolor(255,255,255, 255), 1, fonts[1], 'center', 'center', false,false,false,false,false)
        dxDrawText('Stan rośliny',390,275,590,275, tocolor(46, 117, 111, 255), 1, fonts[4], 'center', 'center', false,false,false,false,false)
    dxSetRenderTarget()
    for i,v in pairs(elements) do
        if isElement(v) then
            destroyElement(v)
        end
    end
end

function refreshPlants()
    local x,y,z = getElementPosition(localPlayer) 
    for element,v in pairs(plants or {}) do
        if isElement(element) then
            local ox, oy, oz = getElementPosition(element)
            if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) < 15 then
                reloadRenderTarget(element)
            end
        end
    end
    if (getPlantsCount() > 0) then
        if isEventHandlerAdded('onClientPreRender', root, renderPlants) then return end
        addEventHandler('onClientPreRender', root, renderPlants)
    else
        if not isEventHandlerAdded('onClientPreRender', root, renderPlants) then return end
        removeEventHandler('onClientPreRender', root, renderPlants)
    end
end

function createPlant()
    if getElementType(source) ~= 'object' then return end
    plants[source] = getElementData(source, 'plant:data')
    local x,y,z = getElementPosition(source)
    cuboids[source] = createColSphere(x, y, z+1, 1.4)
    setElementParent(cuboids[source], source)
    if not timer then
        refreshPlants()
        timer = setTimer(refreshPlants, 2000, 0)
    end
end

function destroyPlant()
    if getElementType(source) ~= 'object' then return end
    if cuboids[source] then
        if isElement(cuboids[source]) then
            destroyElement(cuboids[source])
        end
        if source == data.current then
            if data.binded then
                unbindKey('e', 'down', tryCollectPlant)
                data.binded = nil
            end
            data.current = nil
        end
    end
    cuboids[source] = nil
    if plants[source] then 
        if plants[source].shader then
            destroyElement(plants[source].shader)
        end
        plants[source] = nil 
        if getPlantsCount() == 0 then
            if data.binded then
                unbindKey('e', 'down', tryCollectPlant)
                data.binded = nil
            end
            data.current = nil
            if timer then
                if isTimer(timer) then
                    killTimer(timer)
                end
                timer = nil
            end
        end
    end
end

function reloadPlants()
    local x,y,z = getElementPosition(localPlayer)
    for i,v in ipairs(getElementsByType('object', resourceRoot, true)) do
        if getElementData(v, 'plant:data') and not plants[v] then
            plants[v] = getElementData(v, 'plant:data')
        end
    end
    refreshPlants()
end

function tryCollectPlant()
    if not data.current then return end
    if not isElement(data.current) then return end
    if not plants[data.current] then return end
    if plants[data.current].state > 0 then return end
    if getElementData(localPlayer, 'player:sid') ~= plants[data.current].ownerSid then return end
    local x,y,z = getElementPosition(localPlayer) 
    local ox, oy, oz = getElementPosition(data.current)
    if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) > 2 then return end
    if not data.pickTick then data.pickTick = getTickCount()-1 end
    if data.pickTick > getTickCount() then return end
    data.pickTick = getTickCount() + 500
    triggerServerEvent('collectPlant', resourceRoot, data.current)
end

local minerals = {
    [9] = 'Grass (short lush)',
    [10] = 'Grass (medium lush)',
    [11] = 'Grass (long lush)',
    [12] = 'Grass (short dry)',
    [13] = 'Grass (medium dry)',
    [14] = 'Grass (long dry)',
    [15] = 'Golf Grass (rough)',
    [16] = 'Golf Grass (smooth)',
    [17] = 'Steep Slidy Grass',
    [20] = 'Meadow',
    [80] = 'Grass (short)',
    [81] = 'Grass (meadow)',
    [82] = 'Grass (dry)',
    [115] = 'Grass (wee flowers)',
    [116] = 'Grass (dry tall)',
    [117] = 'Grass (lush tall)',
    [118] = 'Grass (green mix)',
    [119] = 'Grass (brown mix)',
    [120] = 'Grass (low)',
    [121] = 'Grass (rocky)',
    [122] = 'Grass (small trees)',
    [125] = 'Grass (weeds)',
    [146] = 'Grass (light)',
    [147] = 'Grass (lighter)',
    [148] = 'Grass (lighter 2)',
    [149] = 'Grass (mid 1)',
    [150] = 'Grass (mid 2)',
    [151] = 'Grass (dark)',
    [152] = 'Grass (dark 2)',
    [153] = 'Grass (dirt mix)',
    [160] = 'Park Grass',
}

function getSurfacePedIsOn(ped)
    if isElement(ped) and isPedOnGround(ped) then
        local cx, cy, cz = getElementPosition(ped)
        local gz = getGroundPosition(cx, cy, cz)-0.001
        local hit, _, _, _, _, _, _, _, surface = processLineOfSight(cx, cy, gz+0.1, cx, cy, gz)
        if hit then
            return surface
        end
    end
    return false
end

function putPlant(type)
    if not data.plantTick then data.plantTick = getTickCount()-1 end
    if data.plantTick > getTickCount() then return end
    if not isPedOnGround(localPlayer) then return end

    -- local surface = getSurfacePedIsOn(localPlayer)
    -- print('1 '..surface..' '..math.random())

    -- local x,y,z = getElementPosition(localPlayer)
    -- local gz = getGroundPosition(x,y,z)
    -- local hit, _,_,_,ele,_,_,_,material,_,_,model,_,_,_,_,textureName = processLineOfSight(x,y,z, x,y,gz-1, true,false,true,false,false,true,true,true,localPlayer, true)
    -- print('2 '..material..' '..math.random())

    data.plantTick = getTickCount() + 500
    triggerServerEvent('putPlant', resourceRoot, type)
end

function onClientColShapeHit(hitElement, matchingDimension)
    if hitElement ~= localPlayer or not matchingDimension then return end
    local element = getElementParent(source)
    if not cuboids[element] then return end
    if not data.binded then
        data.binded = true
        bindKey('e', 'down', tryCollectPlant)
    end
    data.current = element
end

function onClientColShapeLeave(leaveElement, matchingDimension)
    if leaveElement ~= localPlayer or not matchingDimension then return end
    local element = getElementParent(source)
    if not cuboids[element] then return end
    if data.binded then
        unbindKey('e', 'down', tryCollectPlant)
        data.binded = nil
    end
end

addEventHandler('onClientElementStreamIn', resourceRoot, createPlant)
addEventHandler('onClientElementStreamOut', resourceRoot, destroyPlant)
addEventHandler('onClientElementDestroy', resourceRoot, destroyPlant)
addEventHandler('onClientRestore', root, reloadPlants)
addEventHandler('onClientColShapeHit', resourceRoot, onClientColShapeHit)
addEventHandler('onClientColShapeLeave', resourceRoot, onClientColShapeLeave)
setTimer(refreshPlants, 2000, 0)

engineImportTXD(engineLoadTXD('files/models/weed.txd'), 325) 
engineReplaceModel(engineLoadDFF('files/models/weed.dff', 325), 325)

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

