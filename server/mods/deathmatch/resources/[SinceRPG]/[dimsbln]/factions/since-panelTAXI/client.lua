local cacheTable = {}
local cache = {}

bindKey('ENTER', 'down', function()
    if getElementData(localPlayer, 'player:waitingForTaxi') then
        triggerServerEvent('onTaxiRequest', resourceRoot, 'cancel')
    end
end)

local window = guiCreateWindow(0.35, 0.35, 0.3, 0.3, 'Panel zgłoszeń TAXI', true)
local grid = guiCreateGridList(0.025, 0.1, 0.95, 0.8, true, window)
local name = guiGridListAddColumn(grid, 'Nick', 0.2)
local location = guiGridListAddColumn(grid, 'Lokalizacja', 0.35)
local distance = guiGridListAddColumn(grid, 'Dystans', 0.35)
local button = guiCreateButton(0.025, 0.9, 0.95, 0.1, 'Przyjmij zgłoszenie', true, window)
guiSetVisible(window, false)
guiWindowSetSizable(window, false)
guiWindowSetMovable(window, false)

function convertNumber(number)
    local number = tostring(number)
    return number:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function getDistance(x, y, z)
    return convertNumber(math.floor(getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer))))..' m'
end

function checkIsTaxi(veh)
    if veh and getElementData(veh, 'vehicle:faction') == 'TSA' then
        return true
    else
        return false
    end

    return false
end

addEvent('onTaxiRequest', true)
addEventHandler('onTaxiRequest', resourceRoot, function(type, data)
    if type == 'add' then
        cacheTable[data.name] = data
        local row = guiGridListAddRow(grid)
        guiGridListSetItemText(grid, row, name, data.name, false, false)
        local pos = data.pos
        local zoneName = getZoneName(pos[1], pos[2], pos[3])..', '..getZoneName(pos[1], pos[2], pos[3], true)
        guiGridListSetItemText(grid, row, location, zoneName, false, false)

        local dist = getDistance(pos[1], pos[2], pos[3])
        guiGridListSetItemText(grid, row, distance, dist, false, false)
    elseif type == 'remove' then
        for i = 0, guiGridListGetRowCount(grid) do
            if guiGridListGetItemText(grid, i, col1) == data then
                guiGridListRemoveRow(grid, i)
                break
            end
        end
    elseif type == 'cancel' then
        if cache.blip then
            destroyElement(cache.blip)
        end
    
        if cache.marker then
            destroyElement(cache.marker)
        end
    
        exports['since-radar']:removeGPS()
    elseif type == 'getCourse' then
        cache.blip = createBlip(cache.data.pos[1], cache.data.pos[2], cache.data.pos[3], 41)
        cache.marker = createMarker(cache.data.pos[1], cache.data.pos[2], cache.data.pos[3], 'corona', 15, 255, 55, 55, 0)

        addEventHandler('onClientMarkerHit', cache.marker, function(hitElement)
            if hitElement == localPlayer then
                destroyElement(cache.blip)
                destroyElement(cache.marker)
                exports['since-radar']:removeGPS()
                setElementData(localPlayer, 'player:taxiJob', false)

                outputChatBox('✓#ffffff Dotarto do celu.', 55, 255, 55, true)

                triggerServerEvent('onTaxiRequest', resourceRoot, 'onPosition', cache.data.uid)

                cache.data = nil
            end
        end)

        setTimer(function(x, y, z)
            exports['since-radar']:findBestWay(x, y)
        end, 100, 1, cache.data.pos[1], cache.data.pos[2], cache.data.pos[3])

        cache.data = nil
    end
end)

addEventHandler('onClientGUIClick', button, function()
    local row = guiGridListGetSelectedItem(grid)
    if row == -1 then return end

    local data = cacheTable[guiGridListGetItemText(grid, row, name)]

    guiSetVisible(window, false)
    showCursor(false)
    
    triggerServerEvent('onTaxiRequest', resourceRoot, 'startCourse', localPlayer, data.uid)

    if cache.blip and isElement(cache.blip) then
        destroyElement(cache.blip)
    end

    if cache.marker and isElement(cache.marker) then
        destroyElement(cache.marker)
    end

    exports['since-radar']:removeGPS()
    cache.data = data
end)

addEventHandler('onClientVehicleExit', root, function(player, seat)
    if player == localPlayer then
        if guiGetVisible(window) then
            guiSetVisible(window, false)
            showCursor(false)
        end
    end
end)

bindKey('b', 'down', function()
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if not getElementData(localPlayer, 'player:faction') == 'TSA' then
        return
    end

    if not checkIsTaxi(vehicle) then
        return
    end

    if not vehicle then
        return outputChatBox('✗#ffffff Musisz być w pojeździe, aby otworzyć panel zgłoszeń TAXI.', 255, 55, 55, true)
    end

    guiGridListClear(grid)
    guiSetVisible(window, not guiGetVisible(window))
    showCursor(guiGetVisible(window))
    triggerServerEvent('onTaxiRequest', resourceRoot, 'get')
end)

setElementData(localPlayer, 'player:waintingForTaxi', false)