local x,y,z = 1486.99, -1785.59, 18.73
local marker = createMarker(x,y,z-1, 'cylinder', 2, 125, 255, 125, 255)
setElementData(marker, 'marker:title', 'Wymiany')
setElementData(marker, 'marker:desc', '/wymiana (id/nick)')
setElementData(marker, 'marker:icon', 'treasure')
local cuboid = createColSphere(x,y,z, 10)

local trades = {}

function getFreeId()
    local ids = {}
    for i,v in ipairs(trades) do
        ids[v.id] = true
    end
    local id = 1
    while true do
        if not ids[id] then
            return id
        end
        id = id + 1
    end
end

function getTradeByPlayer(player)
    for i,v in ipairs(trades) do
        for k,player in ipairs(v.players) do
            if player == player then
                return v
            end
        end
    end
    return false
end

function getReadyCountById(id)
    for i,v in ipairs(trades) do
        if v.id == id then
            local count = 0
            for k,ready in pairs(v.ready) do
                if ready then
                    count = count + 1
                end
            end
            return count
        end
    end
end

function getTradeById(id)
    for i,v in ipairs(trades) do
        if v.id == id then
            return v
        end
    end
    return false
end

function disableItems(type, tradeItems, items)
    local sort = {}
    local rest = {}
    for i,v in ipairs(tradeItems) do
        if v.type == type then
            sort[v.id] = true
        end
    end
    for i,v in ipairs(items) do
        if not sort[v.id] then
            table.insert(rest, v)
        end
    end
    return rest
end

function createTrade(player, target)
    if getTradeByPlayer(player) or getTradeByPlayer(target) then
        return false
    end
    local id = getFreeId()
    local trade = {
        id = id,
        players = {player, target},
        items = {
            [player] = {},
            [target] = {}
        },
        ready = {
            [player] = false,
            [target] = false
        },
    }
    table.insert(trades, trade)
    for i,v in ipairs(trade.players) do
        local sid = getElementData(v, 'player:sid')
        local houses = exports['since-db']:query('Select id, position, owner from `since-houses` where `owner` = ?', sid)
        local vehicles = exports['since-db']:query('Select id, model, owner from `since-vehicles` where `owner` = ?', sid)
        local enemy = trade.players[1] == v and trade.players[2] or trade.players[1]
        triggerClientEvent(v, 'startTrade', resourceRoot, trade.items, {houses, vehicles}, trade.ready, getPlayerName(enemy))
    end
end

function finishTrade(id)
    local trade = getTradeById(id)
    if not trade then
        return false
    end
    local playersAlive = 0
    for i,v in ipairs(trade.players) do
        if isElement(v) then
            playersAlive = playersAlive + 1
        end
    end
    if (playersAlive ~= 2) then
        return false
    end
    for player,v in pairs(trade.items) do
        local enemy = trade.players[1] == player and trade.players[2] or trade.players[1]
        local enemySid = getElementData(enemy, 'player:sid')
        local sid = getElementData(player, 'player:sid')
        for i,item in ipairs(v) do
            if item.type == 'vehicle' then
                local row = exports['since-db']:query('Select owner from `since-vehicles` where `id` = ?', item.id)
                if (row[1] and row[1].owner == sid) then
                    exports['since-db']:query('Update `since-vehicles` set `owner` = ? where `id` = ?', enemySid, item.id)
                    outputDebugString('Vehicle '..item.id..' traded from '..sid..' to '..enemySid)
                    exports['since-logs']:sendDiscordLog('gielda', 'Trade (/wymiana)', 'Gracz `'..getPlayerName(player)..'` (UID: `'..sid..'`) wymienił się z graczem `'..getPlayerName(enemy)..'` (UID: `'..enemySid..'`), wartość: **Pojazd o ID:** `'..item.id..'`')
                    local vehicle = findVehicle(item.id)
                    if vehicle then
                        setElementData(vehicle, 'vehicle:owner', enemySid)
                    end
                end
            elseif item.type == 'house' then
                local row = exports['since-db']:query('Select owner from `since-houses` where `id` = ?', item.id)
                if (row[1] and row[1].owner == sid) then
                    exports['since-db']:query('Update `since-houses` set `owner` = ? where `id` = ?', enemySid, item.id)
                    outputDebugString('House '..item.id..' traded from '..sid..' to '..enemySid)
                    exports['since-logs']:sendDiscordLog('gielda', 'Trade (/wymiana)', 'Gracz `'..getPlayerName(player)..'` (UID: `'..sid..'`) wymienił się z graczem `'..getPlayerName(enemy)..'` (UID: `'..enemySid..'`), wartość: **Nieruchomość o ID:** `'..item.id..'`')
                end
            elseif item.type == 'money' then
                local value = tonumber(item.value)
                local rows = exports['since-db']:query('Select bankMoney from `since-users` where `uid` = ?', sid)
                if (value and rows[1] and rows[1].bankMoney >= value) then
                    exports['since-db']:query('Update `since-users` set `bankMoney` = `bankMoney` + ? where `uid` = ?', value, enemySid)
                    exports['since-db']:query('Update `since-users` set `bankMoney` = `bankMoney` - ? where `uid` = ?', value, sid)
                    outputDebugString('Money '..value..' traded from '..sid..' to '..enemySid)
                    exports['since-logs']:sendDiscordLog('gielda', 'Trade (/wymiana)', 'Gracz `'..getPlayerName(player)..'` (UID: `'..sid..'`) wymienił się z graczem `'..getPlayerName(enemy)..'` (UID: `'..enemySid..'`), wartość: `$ '..value..'`')
                end
            elseif item.type == 'wpln' then
                local value = tonumber(item.value)
                local rows = exports['since-db']:query('Select wPLN from `since-users` where `uid` = ?', sid)
                if (value and rows[1] and rows[1].wPLN >= value) then
                    exports['since-db']:query('Update `since-users` set `wPLN` = `wPLN` + ? where `uid` = ?', value, enemySid)
                    exports['since-db']:query('Update `since-users` set `wPLN` = `wPLN` - ? where `uid` = ?', value, sid)
                    outputDebugString('WPLN '..value..' traded from '..sid..' to '..enemySid)
                    exports['since-logs']:sendDiscordLog('gielda', 'Trade (/wymiana)', 'Gracz `'..getPlayerName(player)..'` (UID: `'..sid..'`) wymienił się z graczem `'..getPlayerName(enemy)..'` (UID: `'..enemySid..'`), wartość: `'..value..' wPLN`')
                end
            elseif item.type == 'pp' then
                local value = tonumber(item.value)
                local pp = getElementData(player, 'player:pp')
                if pp and pp >= value then
                    setElementData(player, 'player:pp', pp - value)
                    setElementData(enemy, 'player:pp', (getElementData(enemy, 'player:pp') or 0) + value)
                    outputDebugString('PP '..value..' traded from '..sid..' to '..enemySid)
                    exports['since-logs']:sendDiscordLog('gielda', 'Trade (/wymiana)', 'Gracz `'..getPlayerName(player)..'` (UID: `'..sid..'`) wymienił się z graczem `'..getPlayerName(enemy)..'` (UID: `'..enemySid..'`), wartość: `'..value..' punktów premium`')
                end
            end
        end
    end
    for i,v in ipairs(trade.players) do
        triggerClientEvent(v, 'breakTrade', resourceRoot)
    end
    for i,v in ipairs(trades) do
        if v.id == trade.id then
            table.remove(trades, i)
            break
        end
    end
end

addEvent('breakTrade', true)
addEventHandler('breakTrade', resourceRoot, function()
    local trade = getTradeByPlayer(client)
    if not trade then
        return false
    end
    for i,v in ipairs(trade.players) do
        triggerClientEvent(v, 'breakTrade', resourceRoot)
    end
    for i,v in ipairs(trades) do
        if v.id == trade.id then
            table.remove(trades, i)
            break
        end
    end
end)

addEvent('addTradeItem', true)
addEventHandler('addTradeItem', resourceRoot, function(item)
    local trade = getTradeByPlayer(client)
    if not trade then
        return false
    end
    if item.type == 'vehicle' or item.type == 'house' then else
        local value = tonumber(item.value)
        if not value then
            return false
        end
        if value <= 0 then
            return false
        end
        if item.type == 'money' then
            local rows = exports['since-db']:query('Select bankMoney from `since-users` where `uid` = ?', getElementData(client, 'player:sid'))
            if not rows[1] or rows[1].bankMoney < value then
                return false
            end
        elseif item.type == 'wpln' then
            local rows = exports['since-db']:query('Select wPLN from `since-users` where `uid` = ?', getElementData(client, 'player:sid'))
            if not rows[1] or rows[1].wPLN < value then
                return false
            end
        elseif item.type == 'pp' then
            local pp = getElementData(client, 'player:pp')
            if not pp or pp < value then
                return false
            end
        end
    end
    local add = true
    for i,v in ipairs(trade.items[client]) do
        if v.type == item.type then
            if v.type == 'vehicle' or v.type == 'house' then
                if v.id == item.id then
                    return false
                end
            else
                add = false
                v.value = v.value + item.value
                break
            end
        end
    end
    if add then
        table.insert(trade.items[client], item)
    end
    local count = getReadyCountById(trade.id)
    for i,v in ipairs(trade.players) do
        local sid = getElementData(v, 'player:sid')
        local houses = exports['since-db']:query('Select id, position, owner from `since-houses` where `owner` = ?', sid)
        local vehicles = exports['since-db']:query('Select id, model, owner from `since-vehicles` where `owner` = ?', sid)
        houses = disableItems('house', trade.items[v], houses)
        vehicles = disableItems('vehicle', trade.items[v], vehicles)
        triggerClientEvent(v, 'reloadTrade', resourceRoot, trade.items, {houses, vehicles}, trade.ready, count == 2)
    end
end)

addEvent('removeTradeItem', true)
addEventHandler('removeTradeItem', resourceRoot, function(item)
    local trade = getTradeByPlayer(client)
    if not trade then
        return false
    end
    for i,v in ipairs(trade.items[client]) do
        if v.type == item.type then
            if v.type == 'vehicle' or v.type == 'house' then
                if v.id == item.id then
                    table.remove(trade.items[client], i)
                    break
                end
            else
                table.remove(trade.items[client], i)
                break
            end
        end
    end
    local count = getReadyCountById(trade.id)
    for i,v in ipairs(trade.players) do
        local sid = getElementData(v, 'player:sid')
        local houses = exports['since-db']:query('Select id, position, owner from `since-houses` where `owner` = ?', sid)
        local vehicles = exports['since-db']:query('Select id, model, owner from `since-vehicles` where `owner` = ?', sid)
        houses = disableItems('house', trade.items[v], houses)
        vehicles = disableItems('vehicle', trade.items[v], vehicles)
        triggerClientEvent(v, 'reloadTrade', resourceRoot, trade.items, {houses, vehicles}, trade.ready, count == 2)
    end
end)

addEvent('acceptTrade', true)
addEventHandler('acceptTrade', resourceRoot, function()
    local trade = getTradeByPlayer(client)
    if not trade then
        return false
    end
    trade.ready[client] = not trade.ready[client]
    local count = getReadyCountById(trade.id)
    if (trade.timer and count ~= 2) then
        if isTimer(trade.timer) then
            killTimer(trade.timer)
        end
        trade.timer = nil
    elseif (count == 2) then
        if (trade.timer and isTimer(trade.timer)) then
            killTimer(trade.timer)
        end
        trade.timer = setTimer(function(id)
            finishTrade(id)
        end, 10000, 1, trade.id)
    end
    for i,v in ipairs(trade.players) do
        local sid = getElementData(v, 'player:sid')
        local houses = exports['since-db']:query('Select id, position, owner from `since-houses` where `owner` = ?', sid)
        local vehicles = exports['since-db']:query('Select id, model, owner from `since-vehicles` where `owner` = ?', sid)
        houses = disableItems('house', trade.items[v], houses)
        vehicles = disableItems('vehicle', trade.items[v], vehicles)
        triggerClientEvent(v, 'reloadTrade', resourceRoot, trade.items, {houses, vehicles}, trade.ready, count == 2)
    end
end)

function findVehicle(id)
    for i,v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == id then
            return v
        end
    end
    return false
end

local invites = {}

addCommandHandler('wymiana', function(player, cmd, target)
    if not getElementData(player, 'player:sid') then return end
    if not isElementWithinColShape(player, cuboid) then
        exports['since-notifications']:sendNotification(player, 'error', 'Jesteś za daleko od punktu wymiany')
        return false
    end
    if not target then
        exports['since-notifications']:sendNotification(player, 'error', 'Poprawne użycie /wymiana (id/nick)')
        return false
    end
    local target = exports['since-core']:findPlayer(player, target)
    if not target then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza o podanym id/nicku')
        return false
    end
    if getTradeByPlayer(player) then
        exports['since-notifications']:sendNotification(player, 'error', 'Jesteś już w trakcie wymiany')
        return false
    end
    if getTradeByPlayer(target) then
        exports['since-notifications']:sendNotification(player, 'error', 'Gracz jest już w trakcie wymiany')
        return false
    end
    if target == player then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wysłać sam sobie oferty!')
        return false
    end
    if invites[target] then
        if invites[target].tick > getTickCount() then
            exports['since-notifications']:sendNotification(player, 'error', 'Gracz ma aktywne zaproszenie')
            return false
        end
        invites[target] = nil
    end
    invites[target] = {
        tick = getTickCount() + 30000,
        player = player
    }
    exports['since-notifications']:sendNotification(player, 'success', 'Zaproszenie do wymiany zostało wysłane, będzie aktywne przez 30 sekund')
    exports['since-notifications']:sendNotification(target, 'info', 'Gracz '..getPlayerName(player)..' zaprosił Cię do wymiany, aby zaakceptować wpisz /akceptuj')
end)

addCommandHandler('akceptuj', function(player)
    if not getElementData(player, 'player:sid') then return end
    if not invites[player] then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie masz aktywnego zaproszenia')
        return false
    end
    if invites[player].tick < getTickCount() then
        exports['since-notifications']:sendNotification(player, 'error', 'Zaproszenie wygasło')
        return false
    end
    if not isElement(invites[player].player) then
        exports['since-notifications']:sendNotification(player, 'error', 'Gracz, który cię zaprosił nie jest online')
        return false
    end
    if not isElementWithinColShape(player, cuboid) then
        exports['since-notifications']:sendNotification(player, 'error', 'Jesteś za daleko od punktu wymiany')
        return false
    end
    local x,y,z = getElementPosition(player)
    local tx,ty,tz = getElementPosition(invites[player].player)
    if getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) > 10 then
        exports['since-notifications']:sendNotification(player, 'error', 'Jesteś za daleko od gracza')
        return false
    end
    createTrade(player, invites[player].player)
    exports['since-notifications']:sendNotification(player, 'success', 'Zaakceptowano zaproszenie do wymiany')
    exports['since-notifications']:sendNotification(invites[player].player, 'success', 'Gracz zaakceptował twoje zaproszenie do wymiany')
    invites[player] = nil
end)

addEventHandler('onPlayerQuit', root, function()
    if invites[source] then
        invites[source] = nil
    end
    local trade = getTradeByPlayer(source)
    if not trade then
        return false
    end
    for i,v in ipairs(trade.players) do
        if isElement(v) then
            triggerClientEvent(v, 'breakTrade', resourceRoot)
        end
    end
    for i,v in ipairs(trades) do
        if v.id == trade.id then
            table.remove(trades, i)
            break
        end
    end
end)