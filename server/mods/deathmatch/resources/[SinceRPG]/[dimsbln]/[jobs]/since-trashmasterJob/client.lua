local marker = createMarker(2804.95, 899.39, 13.41-0.95, 'cylinder', 3, 125, 255, 125, 50)
createBlipAttachedTo(marker, 46, 2, 255,255,255,0,0, 500)
setElementData(marker, 'marker:title', 'Śmieciarz')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler('onClientMarkerHit', marker, function(plr)
    if plr ~= localPlayer then return end
    exports['since-jobs']:showJobGui('smieciarki', source)
end)

local job = {}
job.models = {1339, 1265}

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job ~= 'smieciarki' then return end
    if getElementData(localPlayer, 'player:job') then return end
    showPanel()
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'smieciarki' then
        if getElementData(localPlayer, 'player:job') ~= 'smieciarki' then return end
        triggerServerEvent('onPlayerFinishJob', resourceRoot)
        setElementData(localPlayer, 'player:job', nil)
    end
end)

addEvent('onPlayerJoinGroup', true)
addEventHandler('onPlayerJoinGroup', resourceRoot, function(vehicle)
    setElementData(localPlayer, 'player:job', 'smieciarki')
    loadJob(vehicle)
end)

addEvent('onPlayerLeaveGroup', true)
addEventHandler('onPlayerLeaveGroup', resourceRoot, function()
    destroyJob()
    setElementData(localPlayer, 'player:job', nil)
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'smieciarki' then
        setElementData(localPlayer, 'player:job', nil)
        for i,v in ipairs({'walk','crouch','sprint','jump','enter_exit','enter_passenger'}) do
            toggleControl(v, true)
        end
        setControlState(localPlayer, 'walk', false)
        toggleControl('forwards', true)
        toggleControl('backwards', true)
        toggleControl('left', true)
        toggleControl('right', true)
    end
end)

addEvent('createObjects', true)
addEventHandler('createObjects', resourceRoot, function(data, blips)
    createObjects(data)
    createBlips(blips)
end)

addEvent('destroyObject', true)
addEventHandler('destroyObject', resourceRoot, function(id)
    destroyObject(id)
    if job.blips and type(job.blips) == 'table' then
        for i,v in ipairs(job.blips) do
            if string.find(id, v.id) then
                if isElement(v.blip) then destroyElement(v.blip) end
                triggerServerEvent('onPlayerDestroyBlip', resourceRoot, v.id)
                table.remove(job.blips, i)
                break
            end
        end
    end
end)

addEvent('createBlip', true)
addEventHandler('createBlip', resourceRoot, function()
    if job.blip then
        if isElement(job.blip) then 
            destroyElement(job.blip) 
        end
        job.blip = nil
    end
    local x,y,z = 2862.76, 924.71, 10.75
    job.blip = createBlip(x, y, z, 41, 2, 255, 55, 55)
end)

addEvent('destroyBlip', true)
addEventHandler('destroyBlip', resourceRoot, function()
    if job.blip then
        if isElement(job.blip) then 
            destroyElement(job.blip) 
        end
        job.blip = nil
    end
end)

function toggleMoveing(state)
    toggleControl('forwards', state)
    toggleControl('backwards', state)
    toggleControl('left', state)
    toggleControl('right', state)
end

addEvent('turnControls', true)
addEventHandler('turnControls', resourceRoot, function(state, upgrade)
    if state == 1 then
        for i,v in ipairs({'walk','crouch','sprint','jump','enter_exit','enter_passenger'}) do
            toggleControl(v, false)
        end
        setControlState(localPlayer, 'walk', not upgrade)
        toggleMoveing(true)
    elseif state == 0 then
        for i,v in ipairs({'walk','crouch','sprint','jump','enter_exit','enter_passenger'}) do
            toggleControl(v, true)
        end
        setControlState(localPlayer, 'walk', false)
        toggleMoveing(true)
    elseif state == 2 then
        toggleMoveing(false)
    end
end)

function createBlips(data)
    if not job.blips then job.blips = {} end
    job.blips = {}
    for i,v in ipairs(data) do
        table.insert(job.blips, {
            id = v.id,
            blip = createBlip(v.position[1], v.position[2], v.position[3], 41, 2, 255, 55, 55)
        })
    end
end

function destroyBlips(id)
    if id then
        for i,v in ipairs(job.blips or {}) do
            if v.id == id then
                if isElement(v.blip) then destroyElement(v.blip) end
                table.remove(job.blips, i)
                break
            end
        end
    else
        for i,v in ipairs(job.blips or {}) do
            if isElement(v.blip) then destroyElement(v.blip) end
        end
        job.blips = {}
    end
end

function createObjects(data)
    destroyObject()
    job.objects = {}
    local offsets = { [1339] = -0.35, [1265] = -0.5 }
    for i,v in ipairs(data) do
        local marker = createMarker(v.position[1], v.position[2], v.position[3]-1.35, 'cylinder', 2, 255, 255, 255, 255)
        v.position[3] = v.position[3] + offsets[v.model]
        local object = createObject(v.model, unpack(v.position))
        setObjectBreakable(object, false)
        local blip = createBlipAttachedTo(marker, 0, 2, 255, 55, 55)
        setElementFrozen(object, true)
        setElementData(object, 'trash:id', v.id)
        setElementData(object, 'trash:type', v.type)
        table.insert(job.objects, {
            object = object, 
            marker = marker,
            blip = blip,
            id = v.id
        })
        v.position[3] = v.position[3] + (v.model == 1339 and 0.8 or 0.4)
        job.elements['object'..v.id] = {
            position = v.position,
            text = 'Kliknij E aby podnieść\n↓',
            distance = 15,
            font = exports['since-fonts']:getFont('Inter-Bold', 11/zoom),
            walls = true,
            fnc = function()
                if isPedInVehicle(localPlayer) then return false end
                if getElementData(localPlayer, 'player:holdingTrash') then return false end
                return true
            end
        }
    end
end

function destroyObject(id)
    if id then
        for i,v in ipairs(job.objects or {}) do
            if v.id == id then
                job.elements['object'..v.id] = nil
                if isElement(v.object) then destroyElement(v.object) end
                if isElement(v.marker) then destroyElement(v.marker) end
                if isElement(v.blip) then destroyElement(v.blip) end
                table.remove(job.objects, i)
                break
            end
        end
    else
        for i,v in ipairs(job.objects or {}) do
            job.elements['object'..v.id] = nil
            if isElement(v.object) then destroyElement(v.object) end
            if isElement(v.marker) then destroyElement(v.marker) end
            if isElement(v.blip) then destroyElement(v.blip) end
        end
    end
end

function tryInteract()
    if not job.interactTick then job.interactTick = getTickCount() end
    if job.interactTick > getTickCount() then return end
    if isPedInVehicle(localPlayer) then return end
    if getElementData(localPlayer, 'player:holdingTrash') then
        local x,y,z = getElementPosition(localPlayer)
        local ox,oy,oz = getPositionFromElementOffset(localPlayer, 0, 1.5, 0.5)
        if isLineOfSightClear(x,y,z,ox,oy,oz,false,true,false,false,false) then return end
        local is,_,_,_,vehicle=processLineOfSight(x,y,z,ox,oy,oz,false,true,false,false,false)
        if not is then return end
        if getElementType(vehicle) ~= 'vehicle' then return end
        if not vehicle or not isElement(vehicle) then return end
        if getElementModel(vehicle) ~= 408 then return end
        local vx,vy,vz = getPositionFromElementOffset(vehicle, 0, -4.5, 0)
        if getDistanceBetweenPoints3D(x,y,z,vx,vy,vz) > 5 then return end
        job.interactTick = getTickCount() + 250
        toggleMoveing(false)
        triggerServerEvent('onPlayerTryPlaceTrash', resourceRoot, vehicle)
    else
        local object = getNearestElement(localPlayer, 'object', 2)
        if not object then return end
        local id = getElementData(object, 'trash:id')
        if not id then return end
        local trashType = getElementData(object, 'trash:type')
        if not trashType then return end
        job.interactTick = getTickCount() + 250
        toggleMoveing(false)
        triggerServerEvent('onPlayerTryPickTrash', resourceRoot, id, trashType)
    end
end

function show3dText(v, playerX, playerY, playerZ)
    local x2,y2,z2 = unpack(v.position)

    if v.distance and getDistanceBetweenPoints3D(playerX, playerY, playerZ, x2, y2, z2) > v.distance then
        return
    end

    if v.fnc then
        if not v.fnc() then return end
    end

    if not v.font then
        v.font = exports['since-fonts']:getFont('Inter-Bold', 15/zoom)
    end

    if v.walls then
        if not isLineOfSightClear(playerX, playerY, playerZ, x2, y2, z2, false, false, false, false, false, false, false, localPlayer) then
            return
        end
    end
    
    local x,y = getScreenFromWorldPosition(x2, y2, z2)
    if x and y then
        dxDrawText(v.text, x, y, x, y, tocolor(255, 255, 255), 1, v.font, 'center', 'bottom')
    end
end

function render3dText()
    if not job.elements then return end
    local x,y,z = getElementPosition(localPlayer)
    for i,v in pairs(job.elements) do
        if v.updatePositionFnc then
            v.position = v.updatePositionFnc()
        end
        show3dText(v, x,y,z)
    end
end

function loadJob(vehicle)
    if not job.binded then
        job.binded = true
        bindKey('e', 'down', tryInteract)
    end
    if not job.timer then
        job.timer = setTimer(function()
            exports['since-jobs']:addPlayerJobTime('smieciarki', 1)
        end, 60000, 0)
    end
    job.elements = {}
    if not isEventHandlerAdded('onClientRender', root, render3dText) then
        addEventHandler('onClientRender', root, render3dText)
    end
    job.vehicle = vehicle

    job.elements['vehicle'] = {
        position = {0, 0, 0},
        text = 'Twój pojazd\n↓',
        font = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        fnc = function()
            if not isElement(job.vehicle) then
                return false
            end
            if isPedInVehicle(localPlayer) then
                return false
            end
            if getDistanceBetweenElements(localPlayer, job.vehicle) < 5 then
                return false
            end
            return true
        end,
        updatePositionFnc = function()
            local x,y,z = getElementPosition(job.vehicle or localPlayer)
            return {x, y, z+2.5}
        end,
    }
end

function destroyJob()
    if job.binded then
        job.binded = nil
        unbindKey('e', 'down', tryInteract)
    end
    destroyObject()
    destroyBlips()
    if job.blip then
        if isElement(job.blip) then 
            destroyElement(job.blip) 
        end
        job.blip = nil
    end
    if job.timer then
        if isTimer(job.timer) then
            killTimer(job.timer)
        end
        job.timer = nil
    end
    job.elements = nil
    job.vehicle = nil
    if isEventHandlerAdded('onClientRender', root, render3dText) then
        removeEventHandler('onClientRender', root, render3dText)
    end
end

function getDistanceBetweenElements(arg1, arg2)
	local element1 = Vector3(getElementPosition( arg1 ))
	local element2 = Vector3(getElementPosition( arg2 ))
	local distance = getDistanceBetweenPoints3D( element1,element2 )
	return distance
end