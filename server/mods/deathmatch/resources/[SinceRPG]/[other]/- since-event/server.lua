addEvent('event:finish', true)
addEventHandler('event:finish', resourceRoot, function()
    if getElementData(client, 'player:finished') then
        outputChatBox('nie buguj kurwo', client, 255, 0, 0)
        return
    end

    givePlayerMoney(client, 100000)
end)

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

-- USUN TO POTEM
addEventHandler('onPlayerJoin', root, function()
    setElementData(source, 'event:state', 1)
    setElementData(source, 'event:data', {})
    loadEventState(source)
end)

setTimer(function()
    for i, player in ipairs(getElementsByType('player')) do
        setElementData(player, 'event:state', 1)
        setElementData(player, 'event:data', {})
        loadEventState(player)
    end
end, 1000, 1)