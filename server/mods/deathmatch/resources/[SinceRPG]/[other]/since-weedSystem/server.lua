Async:setPriority('medium')
local plants, players, cooldown = {}, {}, {}

function createPlant(data)
    local x,y,z = unpack(fromJSON(data.position))
    local object = createObject(325, x, y, z)
    setElementData(object, 'plant:data', {
        id = data.id,
        state = data.state,
        usedState = data.usedState,
        ownerName = data.ownerName,
        ownerSid = data.ownerSid,
        type = data.type,
    })
    setElementID(object, 'weed#'..data.id)
    table.insert(plants, object)
end

function destroyPlant(element, id)
    if not isElement(element) or not getElementData(element, 'plant:data') then return end
    removeElementFromTable(element)
    destroyElement(element)
    if not id then return end
    exports['since-db']:query('Delete from `since-weed` where `id` = ?', id)
end

addEvent('collectPlant', true)
addEventHandler('collectPlant', resourceRoot, function(element)
    if isPedDead(client) or isPedInVehicle(client) or players[client] or not isElement(element) or getElementType(element) ~= 'object' then return end
    local data = getElementData(element, 'plant:data')
    if not data then return end
    if data.state > 0 then return end
    if getElementData(client, 'player:sid') ~= data.ownerSid then return end
    local type = data.type
    local x,y,z = getElementPosition(client)
    local ox,oy,oz = getElementPosition(element)
    if getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) > 2 then return end
    players[client] = true
    setPedAnimation(client, 'COP_AMBIENT', 'Copbrowse_nod', -1, true, false)
    setTimer(function(client, element)
        if not isElement(client) or not isElement(element) then return end
        destroyPlant(element, data.id)
        setPedAnimation(client, nil)
        local value = math.random(config[type].drop[1], config[type].drop[2])
        exports['since-inventory']:addPlayerItem(client, 'top-'..config[type].data, value)
        exports['since-notifications']:sendNotification(client, 'success', 'Zebrałeś '..value..' g. z krzaku '..config[type].name)
        players[client] = nil
    end, 5000, 1, client, element)
end)

function putPlant(player, type)
    if isPedDead(player) or isPedInVehicle(player) or players[player] then return end
    if isAnyPlantNearest(player) then exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz posadzić sadzonki tak blisko.') return end
    local rows = exports['since-db']:query('Select * from `since-weed` where `ownerSid` = ?', getElementData(player, 'player:sid'))
    if #rows > 10 then
        return exports['since-notifications']:sendNotification(player, 'error', 'Posiadasz już maksymalną ilość roślin.')
    end
    if not type or not tonumber(type) then type = 1 end
    players[player] = true
    setPedAnimation(player, 'COP_AMBIENT', 'Copbrowse_nod', -1, true, false)
    exports['since-inventory']:addPlayerItem(player, 'seed-'..config[type].data, -1)
    setTimer(function(player)
        if not isElement(player) then return end
        local x,y,z = getElementPosition(player)
        z = z - 1
        local _,_,id = exports['since-db']:query('Insert into `since-weed` set `ownerName` = ?, `ownerSid` = ?, `type` = ?, `state` = ?, `position` = ?', getPlayerName(player), getElementData(player, 'player:sid'), type, config[type].time, toJSON({x,y,z}))
        local rows = exports['since-db']:query('Select * from `since-weed` where `id` = ?', id)
        createPlant(rows[1])
        setPedAnimation(player, nil)
        players[player] = nil
    end, 2500, 1, player)
end

addEvent('putPlant', true)
addEventHandler('putPlant', resourceRoot, function(type)
    if not cooldown[client] then cooldown[client] = getTickCount()-1 end
    if cooldown[client] > getTickCount() then return end
    cooldown[client] = getTickCount() + 2000
    putPlant(client, type)
end)

function savePlant(element)
    if not isElement(element) then return end
    if not getElementData(element, 'plant:data') then return end
    local data = getElementData(element, 'plant:data')
    if not data then return end
    exports['since-db']:query('Update `since-weed` set `state` = ?, `usedState` = ? where `id` = ?', data.state, data.usedState, data.id)
    -- iprint('Zapisano roślinę o id: '..data.id..' i stanie: '..math.floor(100 - (data.state / config[data.type].time) * 100)..'%')
end

addCommandHandler('zniszcz.krzak', function(player, cmd, id)
    if not getElementData(player, 'player:admin') then return end
    if not id or not tonumber(id) then exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /zniszcz.krzak [id]') return end
    local rows = exports['since-db']:query('Select * from `since-weed` where `id` = ?', id)
    if #rows == 0 then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono krzaka o id: '..id) end
    local element = getElementByID('weed#'..id)
    if not element or not isElement(element) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono krzaka o id: '..id) end
    destroyPlant(element, id)
    exports['since-notifications']:sendNotification(player, 'success', 'Zniszczono krzak o id: '..id)
end)

-- addCommandHandler('narko', function(player)
--     if not getElementData(player, 'player:sid') then return end
--     if getElementData(player, 'player:sid') == 1 or getElementData(player, 'player:sid') == 4 then else return end
--     putPlant(player)
-- end)

local timeToDestroy = 120 * 48

setTimer(function()
    Async:foreach(plants, function(v)
        local element = v
        if not isElement(element) then return end
        if not getElementData(element, 'plant:data') then return end
        local data = getElementData(element, 'plant:data')
        if not data then return end
        if data.state > 0 then
            data.state = data.state - 1
            if data.state == 0 then
                savePlant(element)
            end
        elseif data.state == 0 then
            data.usedState = data.usedState + 1
        elseif data.state < 0 then
            data.state = 0
        end
        if data.usedState >= timeToDestroy then
            destroyPlant(element, data.id)
            return
        end
        setElementData(element, 'plant:data', data)
    end)
end, 30000, 0)

function isElementInTable(element)
    for i,v in ipairs(plants) do
        if v == element then
            return true
        end
    end
end

function removeElementFromTable(element)
    for i,v in ipairs(plants) do
        if v == element then
            table.remove(plants, i)
            break
        end
    end
end

function loadPlants()
    local rows = exports['since-db']:query('Select * from `since-weed`')
    if #rows == 0 then return end
    Async:foreach(rows, function(v)
        createPlant(v)
    end)
end
addEventHandler('onResourceStart', resourceRoot, loadPlants)

function savePlants()
    Async:foreach(plants, function(v)
        savePlant(v)
    end)
end
addEventHandler('onResourceStop', resourceRoot, savePlants)

addEventHandler('onPlayerQuit', root, function()
    if players[source] then
        players[source] = nil
    end
    if cooldown[source] then
        cooldown[source] = nil
    end
end)

function isAnyPlantNearest(player)
    if not isElement(player) then return false end
    local x,y,z = getElementPosition(player)
    for i,v in ipairs(getElementsWithinRange(x, y, z, 3, 'object')) do
        if getElementData(v, 'plant:data') then
            return true
        end
    end
    return false
end