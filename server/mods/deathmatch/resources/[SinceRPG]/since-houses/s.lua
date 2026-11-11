local houses = {}
local models = {}
local reloaded = nil

Async:setPriority('medium')

function getLocatorsInfo(locators)
    local tbl = {}
    for i, v in ipairs(locators) do
        local db = exports['since-db']:query('select login from `since-users` where uid=? limit 1', v)
        if #db > 0 then table.insert(tbl, { nick = db[1].login, uid = v }) end
    end
    return tbl
end
addEvent('H_Houses:getLocatorsInfo', true)
addEventHandler('H_Houses:getLocatorsInfo', resourceRoot, getLocatorsInfo)

addEvent('H_Houses:enterHouse', true)
addEventHandler('H_Houses:enterHouse', resourceRoot, function(interior, uid)
    if not interior then return end
    setElementPosition(client, unpack(interior.exit))
    setElementInterior(client, interior.int)
    setElementDimension(client, tonumber(uid))
end)

addEvent('H_Houses:exitHouse', true)
addEventHandler('H_Houses:exitHouse', resourceRoot, function(data)
    if not data then return end
    local uid = getElementData(client, 'player:sid')
    setElementPosition(client, data[1],data[2],data[3]+1)
    setElementInterior(client, 0)
    setElementDimension(client, 0)
end)

addEvent('H_Houses:payHouse', true)
addEventHandler('H_Houses:payHouse', resourceRoot, function(id, days, cost)
    if id and days and cost and tonumber(id) and tonumber(days) and tonumber(cost) then
        local uid = getElementData(client, 'player:sid')
        local db = exports['since-db']:query('select * from `since-houses` where id=? and owner=? limit 1', id, uid)
        if #db == 0 then return end
        if getPlayerMoney(client) >= cost then
            local days_between = exports['since-db']:query('select DATEDIFF(CURDATE(), date) as days_between from `since-houses` where id=? limit 1', id)[1].days_between
            if days_between <= -config.days_limit then
                outputChatBox('#ff0000✘ #FFFFFFOsiągnięto limit przedłużonego czasu nieruchomości (7 dni)', client, 255,255,255, true)
                return
            end
            if days_between-days < -config.days_limit then
                outputChatBox('#ff0000✘ #FFFFFFNie możesz opłacić na taki długi okres, gdyż przekroczysz limit 7 dni', client, 255,255,255, true)
                return
            end
            takePlayerMoney(client, cost)
            exports['since-db']:query('update `since-houses` set date=DATE_ADD(date, INTERVAL ? DAY) where id=? and owner=?', tonumber(days), id, uid)
            reloadHouse(id)
            outputChatBox('✔ #FFFFFFPomyślnie przedłużyłeś wynajem nieruchomości o '..days..' dni', client, 0,255,0,true)
            triggerClientEvent(client, 'H_Houses:refresh', resourceRoot, true)
        else
            outputChatBox('#ff0000✘ #FFFFFFNie posiadasz wymaganej kwoty pieniędzy przy sobie', client, 255,255,255, true)
        end
    end
end)

addEvent('H_Houses:leaveHouse', true)
addEventHandler('H_Houses:leaveHouse', resourceRoot, function(id)
    local uid = getElementData(client, 'player:sid')
    local db = exports['since-db']:query('select * from `since-houses` where id=? and owner=? limit 1', id, uid)
    if #db == 0 then return end

    exports['since-db']:query('update `since-houses` set owner=NULL, date=CURDATE()-INTERVAL 1 DAY, locators=NULL where id=? and owner=? limit 1', id, uid)
    reloadHouse(id)
    outputChatBox('✔ #FFFFFFPomyślnie zwolniłeś nieruchomość', client, 0,255,0,true)

    triggerClientEvent(client, 'H_Houses:refresh', resourceRoot, true)
end)

function tableFind(tbl, value)
    for i,v in pairs(tbl) do
        if v == value then
            return i
        end
    end
end

addEvent('H_Houses:addLocator', true)
addEventHandler('H_Houses:addLocator', resourceRoot, function(hisUID, id)
    local uid = getElementData(client, 'player:sid')
    local hisUID = hisUID
    if tonumber(hisUID) == tonumber(uid) then outputChatBox('#ff0000✘ #FFFFFFNie możesz dodać samego siebie jako lokatora', client, 255,255,255, true) return end
    local db = exports['since-db']:query('select uid from `since-users` where uid=? limit 1', hisUID)
    if #db == 0 then outputChatBox('#ff0000✘ #FFFFFFNie odnaleziono konta o podanym UID', client, 255,255,255, true) return end
    local db = exports['since-db']:query('select locators from `since-houses` where id=? and owner=? limit 1', id, uid)
    if #db == 0 then return end
    local locators = db[1].locators and split(db[1].locators, ',') or {}
    if tableFind(locators, hisUID) then
        outputChatBox('#ff0000✘ #FFFFFFGracz z podanym UID jest już dodany jako lokator', client, 255,255,255, true)
        return
    end
    local data = getElementData(houses[id], 'house:data')
    if #locators >= types[data.type].locators then outputChatBox('#ff0000✘ #FFFFFFOsiągnąłeś limit lokatorów', client, 255,255,255, true) return end
    table.insert(locators, hisUID)
    data.locators = getLocatorsInfo(locators)
    setElementData(houses[id], 'house:data', data)    
    exports['since-db']:query('update `since-houses` set locators=? where id=? and owner=? limit 1', table.concat(locators, ','), id, uid)
    outputChatBox('✔ #FFFFFFPomyślnie dodałeś lokatora', client, 0,255,0,true)
    triggerClientEvent(client, 'H_Houses:refresh', resourceRoot, false)
end)

addEvent('H_Houses:removeLocator', true)
addEventHandler('H_Houses:removeLocator', resourceRoot, function(hisUID, id)
    local uid = getElementData(client, 'player:sid')
    local db = exports['since-db']:query('select uid from `since-users` where uid=? limit 1', hisUID)
    if #db == 0 then return end
    local db = exports['since-db']:query('select locators from `since-houses` where id=? and owner=? limit 1', id, uid)
    if #db == 0 then return end
    local locators = db[1].locators and split(db[1].locators, ',') or {}
    if tableFind(locators, hisUID) then
        table.remove(locators, tableFind(locators, hisUID))
    end
    local data = getElementData(houses[id], 'house:data')
    data.locators = getLocatorsInfo(locators)
    setElementData(houses[id], 'house:data', data)
    exports['since-db']:query('update `since-houses` set locators=? where id=? and owner=? limit 1', table.concat(locators, ','), id, uid)
    outputChatBox('✔ #FFFFFFPomyślnie usunąłeś lokatora', client, 0,255,0,true)
    triggerClientEvent(client, 'H_Houses:refresh', resourceRoot, false)
end)

function reloadHouse(id)
    if not id or not tonumber(id) or not houses[id] then return end
    exports['since-db']:query('update `since-houses` set owner=NULL, date=CURDATE()-INTERVAL 1 DAY, locators=NULL where date<CURDATE() or date is NULL and id=?', id)
    local db = exports['since-db']:query('select * from `since-houses` where id=? limit 1', id)
    if #db == 0 then return end
    local ownerNick = exports['since-db']:query('select login from `since-users` where uid=? limit 1', db[1].owner)
    local data = getElementData(houses[id], 'house:data')
    local tbl = {
        id = db[1].id,
        owner = db[1].owner or nil,
        ownerNick = #ownerNick == 1 and ownerNick[1].login or 'Nieznany',
        type = db[1].type,
        cost = db[1].cost,
        value = db[1].value,
        date = db[1].date~='0000-00-00' and db[1].date or nil,
        locators = db[1].locators and getLocatorsInfo(split(db[1].locators, ',')) or {},
        garage = db[1].garage and true or nil,
    }
    setMarkerColor(houses[id], unpack(tbl.owner and {255,55,55,55} or {55,255,55,55}))
    setElementData(houses[id], 'house:data', tbl)

    if models[id] then
        if isElement(models[id]) then
            destroyElement(models[id])
            local pos = split(db[1].position, ',')
            models[id] = createPickup(pos[1], pos[2], pos[3] + 0.6, 3, db[1].owner and 1576 or 1575, 0)
        end
    end

    local debug = {}
    if data.date ~= tbl.date then table.insert(debug, 'zmiana daty') end
    if data.owner ~= tbl.owner then table.insert(debug, 'zmiana wlasciciela') end
    outputDebugString(#debug>0 and table.concat(debug, ',') or 'brak zmian', 0, 145, 145, 145)
end

setTimer(function()
    if reloaded == true then 
        return
    end
    local time = getRealTime()
    if tonumber(time.hour) == 0 and tonumber(time.minute) == 0 then
        reloaded = true
        exports['since-db']:query('update `since-houses` set owner=NULL, date=CURDATE()-INTERVAL 1 DAY, locators=NULL where date<CURDATE() or date is NULL')
        for i,v in pairs(houses) do
            if v and isElement(v) then
                destroyElement(v)
                houses[i] = nil
            end
        end
        for i,v in pairs(models) do
            if v and isElement(v) then
                destroyElement(v)
                models[i] = nil
            end
        end
        loadAllHouses()
        outputDebugString('Przeladowano domki ('..#houses..' nieruchomosci)', 0, 145, 145, 145)
        setTimer(function()
            reloaded = nil
        end, 70000, 1)
    end
end, 30000, 0)

addEvent('H_Houses:buyHouse', true)
addEventHandler('H_Houses:buyHouse', resourceRoot, function(id,days,cost)
    if id and days and cost and tonumber(id) and tonumber(days) and tonumber(cost) then
        local db = exports['since-db']:query('select * from `since-houses` where id=? limit 1', id)
        if #db == 0 then outputChatBox('#ff0000✘ #FFFFFFNieodnaleziono domu, który chcesz wykupić', client, 255,255,255, true) return end
        if db[1].owner then outputChatBox('#ff0000✘ #FFFFFFKtoś już zakupił ten dom', client, 255,255,255, true) return end
        if getPlayerMoney(client) >= cost then
            local uid = getElementData(client, 'player:sid')
            takePlayerMoney(client, cost)
            exports['since-db']:query('update `since-houses` set date=CURDATE()+INTERVAL ? DAY, owner=? where id=?', days, uid, id)
            reloadHouse(id)
            triggerClientEvent(client, 'H_Houses:refresh', resourceRoot, true)
            outputChatBox('✔ #FFFFFFPomyślnie opłacono nieruchomość na '..days..' dni', client, 0,255,0,true)
        else
            outputChatBox('#ff0000✘ #FFFFFFNie posiadasz wymaganej kwoty pieniędzy przy sobie', client, 255,255,255, true)
        end
    end
end)

function loadHouse(id)
    if not id or not tonumber(id) then return end
    local db = exports['since-db']:query('select * from `since-houses` where id=? limit 1', id)
    if #db == 0 then return end
    if houses[id] then 
        if isElement(houses[id]) then destroyElement(houses[id]) end
        houses[id] = nil
    end
    if models[id] then 
        if isElement(models[id]) then destroyElement(models[id]) end
        models[id] = nil
    end
    local pos = split(db[1].position, ',')
    local marker = createMarker(pos[1],pos[2],pos[3] + 0.6, 'corona', 1, 255,255,255,25)
    local ownerNick = exports['since-db']:query('select login from `since-users` where uid=? limit 1', db[1].owner)
    setElementData(marker, 'house:data', {
        id = db[1].id,
        owner = db[1].owner,
        ownerNick = #ownerNick == 1 and ownerNick[1].login or 'Nieznany',
        type = db[1].type,
        cost = db[1].cost,
        value = db[1].value,
        date = db[1].date~='0000-00-00' and db[1].date or nil,
        locators = db[1].locators and getLocatorsInfo(split(db[1].locators, ',')) or {},
        garage = db[1].garage and true or nil,
    })
    setMarkerColor(marker, unpack(db[1].owner and {255,0,0,25} or {0,255,0,25}))
    houses[id] = marker
    local pickup = createPickup(pos[1], pos[2], pos[3] + 0.6, 3, db[1].owner and 1576 or 1575, 0)
    models[id] = pickup
end

addCommandHandler('create.house', function(plr, cmd, type)
    if getElementData(plr, 'player:admin') ~= 4 then
        return
    end
    if not type or not tonumber(type) or not types[tonumber(type)] then
        outputChatBox('#ff0000✘ #FFFFFFPoprawne użycie #84c1a7/create.house (typ (1-mały,2-średni,3-duży,4-ogromny))', plr, 255,255,255, true)
        return 
    end
    local x,y,z = getElementPosition(plr) 
    local _,_,id = exports['since-db']:query('insert into `since-houses` (position, type, cost, value, date) values (?,?,?,?,CURDATE()-INTERVAL 1 DAY)', table.concat({tonumber(string.format('%.2f', x)), tonumber(string.format('%.2f', y)), tonumber(string.format('%.2f', z-0.95))}, ','), type, types[tonumber(type)].cost, types[tonumber(type)].value)
    loadHouse(id)
end)

function loadAllHouses()
    local db = exports['since-db']:query('select * from `since-houses`')
    if not db or #db == 0 then return end
	Async:foreach(db, function(v)
        local id = v.id
        if houses[id] then 
            if isElement(houses[id]) then destroyElement(houses[id]) end
            houses[id] = nil
        end
        if models[id] then 
            if isElement(models[id]) then destroyElement(models[id]) end
            models[id] = nil
        end
        local pos = split(v.position, ',')
        local marker = createMarker(pos[1],pos[2],pos[3] + 0.6, 'corona', 1, 255,255,255,25)
        local ownerNick = exports['since-db']:query('select login from `since-users` where uid=? limit 1', v.owner)
        setElementData(marker, 'house:data', {
            id = v.id,
            owner = v.owner,
            ownerNick = #ownerNick == 1 and ownerNick[1].login or 'Nieznany',
            type = v.type,
            cost = v.cost,
            value = v.value,
            date = v.date~='0000-00-00' and v.date or nil,
            locators = v.locators and getLocatorsInfo(split(v.locators, ',')) or {},
            garage = v.garage and true or nil,
        })
        setMarkerColor(marker, unpack(v.owner and {255,0,0,25} or {0,255,0,25}))
        houses[id] = marker
        local pickup = createPickup(pos[1], pos[2], pos[3] + 0.6, 3, v.owner and 1576 or 1575, 0)
        models[id] = pickup
	end)
end
addEventHandler('onResourceStart', resourceRoot, loadAllHouses)

addEventHandler("onPickupHit", resourceRoot, function() cancelEvent() end)