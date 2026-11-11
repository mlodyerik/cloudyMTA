local saveData = {}

function onPointMarkerHit(element, md)
    if element ~= localPlayer or not md then return end
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then return end
    if vehicle ~= saveData.vehicle then return end
    if saveData.hitDelay then return end
    fadeCamera(false, 0.1, 104, 214, 94)
    local x,y,z = getElementPosition(source)
    saveData.hitDelay = true
    saveData.packs = math.max(saveData.packs - 1, 0)
    triggerServerEvent('onPlayerCreateObject', resourceRoot, x,y,z, saveData.jobType, saveData.packs)
    setTimer(function()
        fadeCamera(true)
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if not vehicle then return end
        if vehicle ~= saveData.vehicle then return end
        if saveData.packs == 0 then
            createLoadingMarkers()
        else
            loadPoints()
        end
    end, 50, 1)
end

function loadPoints()
    if saveData.lastPoint then
        while true do
            local random = math.random(#points)
            if saveData.lastPoint ~= random then
                saveData.lastPoint = random
                break
            end
        end
    else
        saveData.lastPoint = math.random(#points)
    end
    if saveData.actualPoint then
        if isElement(saveData.actualPoint) then
            destroyElement(saveData.actualPoint)
        end
    end
    if saveData.actualPointBlip then
        if isElement(saveData.actualPointBlip) then
            destroyElement(saveData.actualPointBlip)
        end
    end
    local x,y,z,tx,ty,tz = unpack(points[saveData.lastPoint])
    local marker = createMarker(x,y,z, 'ring', 6, 104, 214, 94, 135)
    setMarkerTarget(marker, tx,ty,tz)
    addEventHandler('onClientMarkerHit', marker, onPointMarkerHit)
    saveData.actualPoint = marker
    saveData.actualPointBlip = createBlip(x,y,z, 41)
    saveData.hitDelay = nil
end

function onLoadingMarkerHit(element, md)
    if element ~= localPlayer or not md then return end
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then return end
    if saveData.loadingPacks then return end
    saveData.blockExit = true
    saveData.loadingPacks = true
    fadeCamera(false)
    setElementFrozen(vehicle, true)
    setTimer(function(vehicle)
        if getElementData(localPlayer, 'player:job') == 'Spedycja lotnicza' then
            if saveData.loadMarkers then
                for i,v in ipairs(saveData.loadMarkers) do
                    if isElement(v) then
                        destroyElement(v)
                    end
                end
                saveData.loadMarkers = nil
            end
            loadPoints()
            saveData.packs = 20
            if isElement(vehicle) then
                setElementFrozen(vehicle, false)
            end
            saveData.blockExit = nil
            saveData.loadingPacks = nil
            exports['since-notifications']:sendNotification('success', 'Załadunek zakończony. Rozpocznij dostarczanie paczek.')
        end
        fadeCamera(true)
    end, 5000, 1, vehicle)
end

-- if getElementData(localPlayer, 'player:sid') == 4 then
--     for i,v in ipairs(points) do
--         local x,y,z,tx,ty,tz = unpack(v)
--         local marker = createMarker(x,y,z, 'ring', 6, 104, 214, 94, 135)
--         setMarkerTarget(marker, tx,ty,tz)
--         createBlip(x,y,z, 41)
--     end
--     local save = true
--     local position = ''
--     bindKey('b', 'down', function()
--         local x,y,z = getElementPosition(localPlayer)
--         x,y,z = string.format('%.2f', x), string.format('%.2f', y), string.format('%.2f', z)
--         if save then
--             position = '{'..x..', '..y..', '..z
--             save = false
--         else
--             position = position..' + 70, '..x..', '..y..', '..z..' + 70},'
--             outputChatBox(position)
--             save = true
--         end
--     end)
-- end

function createLoadingMarkers()
    if saveData.loadMarkers then
        for i,v in ipairs(saveData.loadMarkers) do
            if isElement(v) then
                destroyElement(v)
            end
        end
    end
    if saveData.actualPoint then
        if isElement(saveData.actualPoint) then
            destroyElement(saveData.actualPoint)
        end
    end
    if saveData.actualPointBlip then
        if isElement(saveData.actualPointBlip) then
            destroyElement(saveData.actualPointBlip)
        end
    end
    saveData.loadMarkers = {}
    for i,v in ipairs(loaderPositions) do
        local x,y,z = unpack(v)
        local marker = createMarker(x, y, z-0.99, 'cylinder', 12, 104, 214, 94, 100)
        local col = createColSphere(x, y, z, 7)
        setElementData(marker, 'marker:title', 'Załadunek')
        setElementData(marker, 'marker:desc', 'Załadunek towaru')
        setElementData(marker, 'marker:icon', 'pack')
        table.insert(saveData.loadMarkers, marker)
        table.insert(saveData.loadMarkers, col)
        addEventHandler('onClientColShapeHit', col, onLoadingMarkerHit)
        createBlipAttachedTo(marker, 41)
    end
end

function createJob(vehicle)
    if saveData.actualPoint then
        if isElement(saveData.actualPoint) then
            destroyElement(saveData.actualPoint)
        end
    end
    if saveData.actualPointBlip then
        if isElement(saveData.actualPointBlip) then
            destroyElement(saveData.actualPointBlip)
        end
    end
    saveData.vehicle = vehicle
    createLoadingMarkers()
    addEventHandler('onClientVehicleStartExit', vehicle, function(player, seat)
        if player == localPlayer and seat == 0 then
            if saveData.blockExit then
                cancelEvent()
            end
        end
    end)
    addEventHandler('onClientVehicleExit', saveData.vehicle, function(player, seat)
        if player == localPlayer and seat == 0 then
            destroyJob(true)
        end
    end)
    saveData.timer = setTimer(function()
        exports["since-jobs"]:addPlayerJobTime('Aircraft', 1)
    end, 60000, 0)
end

function destroyJob(isTriggering)
    if saveData.timer then
        if isTimer(saveData.timer) then
            killTimer(saveData.timer)
        end
        saveData.timer = nil
    end
    if saveData.loadMarkers then
        for i,v in ipairs(saveData.loadMarkers) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        saveData.loadMarkers = nil
    end
    if saveData.actualPoint then
        if isElement(saveData.actualPoint) then
            destroyElement(saveData.actualPoint)
        end
    end
    if saveData.actualPointBlip then
        if isElement(saveData.actualPointBlip) then
            destroyElement(saveData.actualPointBlip)
        end
    end
    saveData.vehicle = nil
    saveData.hitDelay = nil
    saveData.lastPoint = nil
    saveData.actualPoint = nil
    saveData.actualPointBlip = nil
    saveData.blockExit = nil
    if isTriggering then
        triggerServerEvent('onPlayerStartEnd', resourceRoot)
        exports['since-notifications']:sendNotification('success', 'Praca spedycji lotniczej została zakończona.')
    end
    setElementData(localPlayer, 'player:job', nil)
end

addEvent('onPlayerStartJob', true)
addEventHandler('onPlayerStartJob', resourceRoot, function(jobType, vehicle)
    saveData.jobType = jobType
    createJob(vehicle)
end)

addEvent('onPlayerStartEnd', true)
addEventHandler('onPlayerStartEnd', resourceRoot, function()
    destroyJob(false)
end)

local function onClientMarkerHit(hitElement, matchingDimension)
    if hitElement ~= localPlayer or not matchingDimension then
        return
    end
    changeGuiState(true, source)
end

local function onClientMarkerLeave(leaveElement, matchingDimension)
    if leaveElement ~= localPlayer or not matchingDimension then
        return
    end
    changeGuiState(false)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    local pos = {2003.75, -2403.52, 13.55}
    local marker = createMarker(pos[1], pos[2], pos[3]-0.99, 'cylinder', 1.5, 104, 214, 94, 100)
    setElementData(marker, 'marker:title', 'Spedycja lotnicza')
    setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
    setElementData(marker, 'marker:icon', 'skin')
    addEventHandler('onClientMarkerHit', marker, onClientMarkerHit)
    addEventHandler('onClientMarkerLeave', marker, onClientMarkerLeave)

    createBlipAttachedTo(marker, 46, 2, 255,255,255,0,0, 500)
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'Spedycja lotnicza' then
        setElementData(localPlayer, 'player:job', nil)
        setElementData(localPlayer, 'lawety:packing', nil)
        exports['since-notifications']:sendNotification('success', 'Praca spedycji lotniczej została przeładowania. Praca została zakończona.')
    end
end)

