local vehicles = {}

addEvent('event:finish', true)
addEventHandler('event:finish', resourceRoot, function()
    if getElementData(client, 'player:finished') then
        return
    end
    
    if not getElementData(client, 'player:sid') then
        return
    end

    local sid = getElementData(client, 'player:sid')
    exports['since-db']:query('UPDATE `since-users` SET `wPLN` = wPLN + ? WHERE `uid` = ?', 100, sid)
    exports['since-db']:query('UPDATE `since-users` SET `bankMoney` = bankMoney + ? WHERE `uid` = ?', 250000000, sid)

    exports['since-notifications']:sendNotification(client, 'success', 'Otrzymujesz 100 wPLN i 250,000,000$ za ukończenie wydarzenia fabularnego!')

    exports['since-logs']:sendDiscordLog('fabular', 'Event Fabularny', '`'..getPlayerName(client)..'` (UID: `'..getElementData(client, 'player:sid')..'`) ukończył wydarzenie fabularne')
end)

-- addEventHandler('onResourceStart', resourceRoot, function()
--     for i, player in ipairs(getElementsByType('player')) do
--         setElementData(player, 'event:state', 1)
--         setElementData(player, 'event:data', {})
--     end
-- end)

-- addEventHandler('onVehicleStartEnter', resourceRoot, function(plr, seat, jacked)
--     if getElementData(source, 'event:vehicle') then
--         local player = getElementData(source, 'event:player')

--         if player ~= plr then
--             cancelEvent()
--         end
--     end
-- end)

-- addEventHandler('onVehicleStartExit', resourceRoot, function(plr, seat, jacked)
--     if getElementData(source, 'event:vehicle') then
--         cancelEvent()
--     end
-- end)

-- addEventHandler('onVehicleExplode', resourceRoot, function()
--     if getElementData(source, 'event:vehicle') then
--         fixVehicle(source)
--     end
-- end)

-- addEventHandler('onPlayerQuit', root, function()
--     if vehicles[source] then
--         destroyElement(vehicles[source])
--         vehicles[source] = nil
--     end
-- end)

-- addEvent('createMissionVehicle', true)
-- addEventHandler('createMissionVehicle', resourceRoot, function(eType, model, x, y, z, rx, ry, rz)
--     if eType == 'create' then
--         if not vehicles[client] then
--             vehicles[client] = createVehicle(model, x, y, z)
--             setElementRotation(vehicles[client], rx, ry, rz)
--             setVehicleColor(vehicles[client], 255, 255, 255, 255, 255, 255)
--             setElementData(vehicles[client], 'event:vehicle', true)
--             setElementData(vehicles[client], 'event:player', client)
--         end
--     else
--         if vehicles[client] then
--             destroyElement(vehicles[client])
--             vehicles[client] = nil
--         end
--     end
-- end)

function loadEventState(player)
    triggerClientEvent(player, 'event:load', resourceRoot)
end

function getEventState(player)
    local state = getElementData(player, 'event:state') or 1
    local data = getElementData(player, 'event:data') or {}

    return {state=state, data=data}
end

function setEventState(player, state)
    local state = state.state
    local data = state.data

    setElementData(player, 'event:state', state)
    setElementData(player, 'event:data', data)
end

function setMissionStatus(state)
    setElementData(player, 'event:state', state)
    setMission(state)
end

function setEventData(key, value)
    local data = getElementData(player, 'event:data') or {}
    data[key] = value
    setElementData(player, 'event:data', data)
end

function getEventData(key)
    local data = getElementData(player, 'event:data') or {}
    return data[key]
end

-- ZAPISYWANIE DO BAZY:
-- local data = toJSON(getEventState())

-- WCZYTYWANIE Z BAZY:
-- local state = fromJSON(state)
-- setEventState(player, state)

setTimer(function()
    for i, player in ipairs(getElementsByType('player')) do
        local eventState = tonumber(getElementData(player, 'event:state')) or 1

        if not eventState then
            setElementData(player, 'event:state', 1)
            loadEventState(player)
        end

        if eventState then
            if eventState == 0 then
                setElementData(player, 'player:state', 1)
            end
            
            loadEventState(player)
        end
    end
end, 1000, 1)