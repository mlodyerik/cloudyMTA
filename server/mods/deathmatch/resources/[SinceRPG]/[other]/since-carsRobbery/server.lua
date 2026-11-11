local cache = {
    vehicles = {},
    cooldown = {},
    cooldown = {},
    garages = {},
    exporting = {},
    timers = {},
}
for i,v in ipairs(config.positions.vehicleOnMap) do
    table.insert(cache.vehicles, {
        position = v,
    })
end

cache.marker = createMarker(config.positions.garageMarker[1], config.positions.garageMarker[2], config.positions.garageMarker[3]-1, 'cylinder', 6, 255, 255, 255, 150)
setElementData(cache.marker, 'marker:title', 'Dziupla')
setElementData(cache.marker, 'marker:desc', 'Miejsce na porzucone pojazdy')
setElementData(cache.marker, 'marker:icon', 'parking')

function findGarage(id)
    for i,v in ipairs(cache.garages) do
        if (v.id == id) then
            return v
        end
    end
    return false
end

function getPlayersInGarage(id)
    local v = findGarage(id)
    if (not v) then
        return 0
    end
    local count = 0
    for i,plr in ipairs(v.players) do
        if (isElement(plr)) then
            count = count + 1
        end
    end
    return count
end

function removePlayerFromGarage(player, id)
    local v = findGarage(id)
    if (not v) then
        return
    end
    for i,plr in ipairs(v.players) do
        if (plr == player) then
            table.remove(v.players, i)
            break
        end
    end
end

function getTableIdById(table, id)
    for i,v in ipairs(table) do
        if (v.id == id) then
            return i
        end
    end
    return false
end

function reloadVehiclesInGarage(id)
    local v = findGarage(id)
    if (not v) then
        return
    end
    if v.vehicles then
        for i,row in ipairs(v.vehicles) do
            if isElement(row.vehicle) then
                destroyElement(row.vehicle)
            end
        end
        v.vehicles = nil
    end
    v.vehicles = {}
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0 LIMIT 6', id)
    for k,row in ipairs(rows) do
        local vehicle = nil
        local baseModel, isCustom = exports['since-custommodels']:checkModelID(row.model, 'vehicle')
        if isCustom then
            vehicle = createVehicle(baseModel, unpack(config.positions.vehicleInInterior[k]))
            setElementData(vehicle, 'baseID', baseModel)
            setElementData(vehicle, 'vehicleID', row.model)
        else
            vehicle = createVehicle(row.model, unpack(config.positions.vehicleInInterior[k]))
        end
        setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
        setElementDimension(vehicle, id)
        setElementInterior(vehicle, 1)
        setVehicleVariant(vehicle, 0, 0)
        setElementFrozen(vehicle, true)
        setElementData(vehicle, 'vehicle:fromRobbery', true)
        setElementData(vehicle, 'vehicle:upgrades', {
            ['vopis'] = true,
            ['vopis:text'] = '#9bff9b'..exports['since-vehiclenames']:getVehicleName(row.model)..'\n#FFFFFFSprowadzony pojazd',
        })
        setElementData(vehicle, 'vehicle:robberyAction', row.state)
        setElementHealth(vehicle, row.state == 1 and 250 or 1000)
        table.insert(v.vehicles, {
            vehicle = vehicle, 
            model = row.model,
            id = row.id,
        })
    end
end

function loadGarage(id)
    local v = findGarage(id)
    if v then
        return
    end
    table.insert(cache.garages, {
        id = id,
    })
    local v = findGarage(id)
    if v.object then
        if isElement(v.object) then
            destroyElement(v.object)
        end
        v.object = nil
    end
    if v.vehicles then
        for i,row in ipairs(v.vehicles) do
            if isElement(row.vehicle) then
                destroyElement(row.vehicle)
            end
        end
        v.vehicles = nil
    end
    if v.marker then
        if isElement(v.marker) then
            destroyElement(v.marker)
        end
        v.marker = nil
    end
    v.object = createObject(3907, unpack(config.positions.object))
    setElementDimension(v.object, id)
    setElementInterior(v.object, 1)
    v.marker = createMarker(config.positions.garageComputerMarker[1], config.positions.garageComputerMarker[2], config.positions.garageComputerMarker[3]-1, 'cylinder', 2, 255, 255, 255, 150)
    setElementData(v.marker, 'marker:title', 'Komputer')
    setElementData(v.marker, 'marker:desc', 'Panel sterowania garażem')
    setElementData(v.marker, 'marker:icon', 'default')
    setElementDimension(v.marker, id)
    setElementInterior(v.marker, 1)
    addEventHandler('onMarkerHit', v.marker, function(player, md)
        if (not isElement(player) or not md or getElementType(player) ~= 'player') then
            return
        end
        if (not getElementData(player, 'player:gang')) then
            exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz dostępu do tego miejsca.')
            return
        end
        local organization = getElementData(player, 'player:organization')
        if not organization then
            return
        end
        local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0', organization.id)
        local rowsOrg = exports['since-db']:query('Select * from `since-orgs` where `uid` = ?', organization.id)
        local positions = {}
        for t,k in ipairs(config.positions.vehicleOnMap) do
            table.insert(positions, k)
        end
        triggerClientEvent(player, 'onClientShowGarage', resourceRoot, rows, rowsOrg[1].garageMap, positions)
    end)
    v.vehicles = {}
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0 LIMIT 6', id)
    for k,row in ipairs(rows) do
        local vehicle = nil
        local baseModel, isCustom = exports['since-custommodels']:checkModelID(row.model, 'vehicle')
        if isCustom then
            vehicle = createVehicle(baseModel, unpack(config.positions.vehicleInInterior[k]))
            setElementData(vehicle, 'baseID', baseModel)
            setElementData(vehicle, 'vehicleID', row.model)
        else
            vehicle = createVehicle(row.model, unpack(config.positions.vehicleInInterior[k]))
        end
        setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
        setElementDimension(vehicle, id)
        setElementInterior(vehicle, 1)
        setVehicleVariant(vehicle, 0, 0)
        setElementFrozen(vehicle, true)
        setElementData(vehicle, 'vehicle:fromRobbery', true)
        setElementData(vehicle, 'vehicle:upgrades', {
            ['vopis'] = true,
            ['vopis:text'] = '#9bff9b'..exports['since-vehiclenames']:getVehicleName(row.model)..'\n#FFFFFFSprowadzony pojazd',
        })
        setElementData(vehicle, 'vehicle:robberyAction', row.state)
        setElementHealth(vehicle, row.state == 1 and 250 or 1000)
        table.insert(v.vehicles, {
            vehicle = vehicle, 
            model = row.model,
            id = row.id,
        })
    end
    v.players = {}
    v.tick = getTickCount()
end

function destroyGarage(id)
    local v = findGarage(id)
    if (not v) then
        return
    end
    if v.object then
        if isElement(v.object) then
            destroyElement(v.object)
        end
        v.object = nil
    end
    if v.vehicles then
        for i,row in ipairs(v.vehicles) do
            if isElement(row.vehicle) then
                destroyElement(row.vehicle)
            end
        end
        v.vehicles = nil
    end
    if v.marker then
        if isElement(v.marker) then
            destroyElement(v.marker)
        end
        v.marker = nil
    end
    table.remove(cache.garages, getTableIdById(cache.garages, id))
end

addEventHandler('onMarkerHit', cache.marker, function(player)
    if (not isElement(player)) or (getElementType(player) ~= 'player') then
        return
    end
    if (not getElementData(player, 'player:gang')) then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz dostępu do tego miejsca.')
        return
    end
    local organization = getElementData(player, 'player:organization')
    if not organization then
        return
    end
    local rows = exports['since-db']:query('Select * from `since-orgs` where `uid` = ? limit 1', organization.id)
    if #rows == 0 then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono organizacji.')
        return
    end
    if rows[1].garage == 0 then
        exports['since-notifications']:sendNotification(player, 'error', 'Twoja organizacja nie posiada garażu. (Można go zakupić w panelu organizacji F4 w zakładce AKCJE)')
        return
    end
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        if (not getElementData(vehicle, 'vehicle:fromRobbery')) then
            exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wjechać tutaj tym pojazdem.')
            return
        end
        local id = getElementData(vehicle, 'vehicle:robberyID')
        if (not id) then return end
        local slot = getSlotByVehicle(vehicle)
        if (not slot) then return end
        local v = cache.vehicles[slot]
        if v.timer then
            if isTimer(v.timer) then
                killTimer(v.timer)
            end
            v.timer = nil
        end
        destroyElement(vehicle)
        local organization = getElementData(player, 'player:organization')
        if not organization then
            return
        end
        v.timer = setTimer(function(slot)
            createNewVehicle(slot)
        end, (60000 * config.minutesToNewVehicle), 1, slot)
        triggerClientEvent(player, 'onClientDestroyNextRobbery', resourceRoot)

        local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0', organization.id)
        if #rows >= 6 then
            exports['since-notifications']:sendNotification(player, 'error', 'Pojazd nie został zaliczony do garażu, ponieważ posiadasz już 6 pojazdów w garażu.')
            exports['since-db']:query('Delete from `since-carsRobbery` where `id` = ?', id)
            return
        end

        exports['since-db']:query('Update `since-carsRobbery` set `onMap` = 0, `inGarage` = ? where `id` = ?', organization.id, id)
        exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został odstawiony do garażu.')
        if (getPlayersInGarage(organization.id) > 0) then
            reloadVehiclesInGarage(organization.id)
        end
    else
        local organization = getElementData(player, 'player:organization')
        if not organization then
            return
        end
        enterGarage(player)
    end
end)

function enterGarage(player)
    if not isElement(player) then
        return
    end
    triggerClientEvent(player, 'onClientEnterGarage', resourceRoot)
end

addEvent('onServerEnterGarage', true)
addEventHandler('onServerEnterGarage', resourceRoot, function()
    if not isElement(client) then
        return
    end
    local organization = getElementData(client, 'player:organization')
    if not organization then
        return
    end
    loadGarage(organization.id)
    setElementPosition(client, 1418.25, -1687.02, 60.39)
    setElementDimension(client, organization.id)
    setElementInterior(client, 1)
    local garage = findGarage(organization.id)
    triggerClientEvent(client, 'onClientEnterGarage', resourceRoot, true, garage.vehicles)
    table.insert(garage.players, client)
end)

addEvent('onServerLeaveGarage', true)
addEventHandler('onServerLeaveGarage', resourceRoot, function()
    if not isElement(client) then
        return
    end
    local organization = getElementData(client, 'player:organization')
    if not organization then
        return
    end
    setElementPosition(client, -2201.19, -2324.79, 30.6)
    setElementDimension(client, 0)
    setElementInterior(client, 0)
    triggerClientEvent(client, 'onClientExitGarage', resourceRoot)
    removePlayerFromGarage(client, organization.id)
    if (getPlayersInGarage(organization.id) == 0) then
        destroyGarage(organization.id)
    end
end)

addEvent('onServerSellVehicle', true)
addEventHandler('onServerSellVehicle', resourceRoot, function(data)
    if not isElement(client) then
        return 
    end
    local organization = getElementData(client, 'player:organization')
    if (not organization or not getElementData(client, 'player:gang')) then
        return 
    end
    local v = findGarage(organization.id)
    if not v then
        return 
    end
    if (v.sellingTick and getTickCount() - v.sellingTick < 1000) then
        exports['since-notifications']:sendNotification(client, 'error', 'Poczekaj chwilę przed sprzedażą kolejnego pojazdu.')
        return 
    end
    local id = data.id
    if cache.timers[id] then
        if cache.timers[id].action == 1 then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz sprzedać pojazdu, który jest aktualnie w trakcie naprawy.')
        elseif cache.timers[id].action == 2 then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz sprzedać pojazdu, który jest aktualnie w trakcie zmiany numeru VIN.')
        end
        return
    end
    v.sellingTick = getTickCount()
    for i,row in ipairs(v.vehicles) do
        if (row.model == data.model) then
            if isElement(row.vehicle) then
                destroyElement(row.vehicle)
            end
            table.remove(v.vehicles, i)
            exports['since-db']:query('Delete from `since-carsRobbery` where `id` = ?', data.id)
            startExportingVehicle(client, data.model, data.id, data.state)
            break
        end
    end
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0', organization.id)
    local rowsOrg = exports['since-db']:query('Select * from `since-orgs` where `uid` = ?', organization.id)
    for i,player in ipairs(v.players) do
        if isElement(player) then
            triggerClientEvent(player, 'onClientRefresh', resourceRoot, rows, rowsOrg[1].garageMap)
        end
    end
end)

function startExportingVehicle(player, model, id, state)
    if not isElement(player) then
        return 
    end
    local organization = getElementData(player, 'player:organization')
    if not organization then
        return 
    end
    local vehicle = nil
    local baseModel, isCustom = exports['since-custommodels']:checkModelID(model, 'vehicle')
    if isCustom then
        vehicle = createVehicle(baseModel, unpack(config.positions.exportVehicleCreation))
        setElementData(vehicle, 'baseID', baseModel)
        setElementData(vehicle, 'vehicleID', model)
    else
        vehicle = createVehicle(model, unpack(config.positions.exportVehicleCreation))
    end
    setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
    setVehicleVariant(vehicle, 0, 0)
    setElementData(vehicle, 'elemen:ghost', true)
    setElementData(vehicle, 'vehicle:upgrades', {
        ['vopis'] = true,
        ['vopis:text'] = '#9bff9b'..exports['since-vehiclenames']:getVehicleName(model)..'\n#FFFFFFSprzedaż pojazdu #9bff9b#'..id,
    })
    exports['since-handlings']:loadVehicleCustomHandling(vehicle)
    local org = organization.id

    fadeCamera(player, false, 0.5)

    setTimer(function(player, vehicle)
        if not isElement(player) then
            return
        end
        setElementDimension(player, 0)
        setElementInterior(player, 0)
        warpPedIntoVehicle(player, vehicle)
        fadeCamera(player, true)
        local pos = config.positions.exportPoints[math.random(#config.positions.exportPoints)]
        triggerClientEvent(player, 'onClientCreateExport', resourceRoot, pos)

        local location = getZoneName(pos[1], pos[2], pos[3])
        for i,v in ipairs(getElementsByType('player')) do
            if getElementData(v, 'player:faction') == 'SAPD' then
                outputChatBox(' ', v)
                outputChatBox('#9bff9b[INFO] #ffffffGracz '..getPlayerName(player)..' rozpoczął sprzedaż pojazdu, kieruje się do '..location, v, 255, 255, 255, true)
                outputChatBox(' ', v)
            end
        end

        removePlayerFromGarage(player, org)
        if (getPlayersInGarage(org) == 0) then
            destroyGarage(org)
        end
    end, 1000, 1, player, vehicle)

    cache.exporting[player] = {
        vehicle = vehicle,
        tick = getTickCount(),
        state = state,
    }
end

addEvent('onServerFinishExport', true)
addEventHandler('onServerFinishExport', resourceRoot, function()
    local player = client
    if not isElement(player) then
        return
    end
    local model, state = false, false
    if cache.exporting[player] then
        if isElement(cache.exporting[player].vehicle) then
            model = getElementData(cache.exporting[player].vehicle, 'vehicleID') or getElementModel(cache.exporting[player].vehicle)
            state = cache.exporting[player].state
            destroyElement(cache.exporting[player].vehicle)
        end
        cache.exporting[player] = nil
    end
    triggerClientEvent(player, 'onClientDestroyExport', resourceRoot)

    local organization = getElementData(player, 'player:organization')
    if not organization then
        return
    end
    
    local money = getVehicleCost(model, state)
    exports['since-db']:query('UPDATE `since-orgs` SET money = money + ? WHERE uid = ?', money, organization.id)

    exports['since-db']:query("INSERT INTO `since-orgs-logs` (org,member,title,subTitle,description) VALUES (?,?,?,?,?)", organization.id, getPlayerName(player), 'Export pojazdu', '#84e374$#ffffff '..addCommas(money)..'', 'Brak')

    exports['since-notifications']:sendNotification(player, 'success', 'Sprzedano pojazd za '..addCommas(money)..' $, kasa wpadła na konto organizacji.')
end)

addEvent('onServerBuyMap', true)
addEventHandler('onServerBuyMap', resourceRoot, function(mapCost)
    if not isElement(client) then
        return
    end
    local organization = getElementData(client, 'player:organization')
    if not organization then
        return
    end
    local money = getPlayerMoney(client)
    if (money < mapCost) then
        exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości gotówki.')
        return
    end
    takePlayerMoney(client, mapCost)
    exports['since-db']:query('Update `since-orgs` set `garageMap` = 1 where `uid` = ?', organization.id)
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0', organization.id)
    local rowsOrg = exports['since-db']:query('Select * from `since-orgs` where `uid` = ?', organization.id)
    local garage = findGarage(organization.id)
    for i,player in ipairs(garage.players) do
        if isElement(player) then
            triggerClientEvent(player, 'onClientRefresh', resourceRoot, rows, rowsOrg[1].garageMap)
        end
    end
    exports['since-notifications']:sendNotification(client, 'success', 'Zakupiono mapę garażu.')
end)

function getSlotByVehicle(vehicle)
    for i,v in ipairs(cache.vehicles) do
        if (v.veh == vehicle) then
            return i
        end
    end
    return false
end

function getVehicleFromSlot(slot)
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `slot` = ? and `onMap` = 1', slot)
    if #rows == 0 then
        return false
    end
    return rows[1]
end

function createVehicleOnPosition(slot, id, model)
    if (not cache.vehicles[slot]) then
        return
    end
    local v = cache.vehicles[slot]
    if isElement(v.veh) then
        destroyElement(v.veh)
        v.veh = nil
    end
    if v.timer then
        if isTimer(v.timer) then
            killTimer(v.timer)
        end
        v.timer = nil
    end

    local position = config.positions.vehicleOnMap[slot]

    local vehicle = nil
    local baseModel, isCustom = exports['since-custommodels']:checkModelID(model, 'vehicle')
    if isCustom then
        vehicle = createVehicle(baseModel, unpack(position))
        setElementData(vehicle, 'baseID', baseModel)
        setElementData(vehicle, 'vehicleID', model)
    else
        vehicle = createVehicle(model, unpack(position))
    end
    setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
    setVehicleDamageProof(vehicle, true)
    setElementFrozen(vehicle, true)
    setVehicleVariant(vehicle, 0, 0)
    setElementData(vehicle, 'elemen:ghost', true)
    setElementData(vehicle, 'vehicle:upgrades', {
        ['vopis'] = true,
        ['vopis:text'] = '#9bff9b'..exports['since-vehiclenames']:getVehicleName(model)..'\n#FFFFFFPorzucony pojazd #9bff9b#'..id,
    })
    setElementData(vehicle, 'vehicle:keyIsBlocked', true)
    setElementData(vehicle, 'vehicle:fromRobbery', true)
    setElementData(vehicle, 'vehicle:robberyID', id)
    exports['since-handlings']:loadVehicleCustomHandling(vehicle)
    v.veh = vehicle
end

function unblockVehicle(vehicle)
    if (not isElement(vehicle)) then
        return
    end
    setElementData(vehicle, 'vehicle:keyIsBlocked', nil)
    setVehicleEngineState(vehicle, true)
    setElementFrozen(vehicle, false)
    local player = getVehicleOccupant(vehicle)
    if (player and isElement(player)) then
        exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został odblokowany, udaj się do dziupli.')
    end
end

function createNewVehicle(slot, toDestroy)
    local v = cache.vehicles[slot]
    if (not v) then
        return
    end
    if isElement(v.veh) then
        destroyElement(v.veh)
        v.veh = nil
    end
    if v.timer then
        if isTimer(v.timer) then
            killTimer(v.timer)
        end
        v.timer = nil
    end
    local model = config.vehicleModels[math.random(#config.vehicleModels)][1]
    local _,_,id = exports['since-db']:query('Insert into `since-carsRobbery` set `slot` = ?, `model` = ?, `onMap` = 1, `data` = ?', slot, model, toJSON({}))
    createVehicleOnPosition(slot, id, model)
    if toDestroy then
        exports['since-db']:query('delete from `since-carsRobbery` where `id` = ? and `onMap` = 1', toDestroy)
    end
end

addEventHandler('onResourceStart', resourceRoot, function()
    local count = 0
    for i,v in ipairs(cache.vehicles) do
        local vehicle = getVehicleFromSlot(i)
        if vehicle then
            createVehicleOnPosition(i, vehicle.id, vehicle.model)
            count = count + 1
        end
    end
    for i,v in ipairs(cache.vehicles) do
        if (not v.veh) then
            createNewVehicle(i)
        end
        if (not v.cuboid) then
            v.cuboid = createColSphere(v.position[1], v.position[2], v.position[3], 5)
        end
    end
end)

addEventHandler('onVehicleStartEnter', resourceRoot, function(player, seat, jacked)
    if jacked then
        cancelEvent()
        return
    end
    if getElementData(source, 'vehicle:fromRobbery') and getElementInterior(source) == 1 then
        cancelEvent()
        return
    end
    if (not getElementData(player, 'player:gang')) then
        cancelEvent()
        return
    end
end)

addEventHandler('onVehicleExit', resourceRoot, function(player, seat)
    if (seat ~= 0 or not isElement(source)) then
        return
    end
    if (cache.exporting[player] and cache.exporting[player].vehicle == source) then
        destroyElement(source)
        cache.exporting[player] = nil
        triggerClientEvent(player, 'onClientDestroyExport', resourceRoot)
        return
    end
    setVehicleEngineState(source, false)
    setElementData(source, 'vehicle:keyIsUnlocking', nil)
    local slot = getSlotByVehicle(source)
    if not slot then
        return
    end
    local v = cache.vehicles[slot]
    v.tick = getTickCount()
end)

addEventHandler('onVehicleEnter', resourceRoot, function(player, seat, jacked)
    if (seat ~= 0) then
        return
    end
    setVehicleEngineState(source, false)
    setElementData(source, 'vehicle:keyIsUnlocking', nil)
    local slot = getSlotByVehicle(source)
    if not slot then
        return
    end
    local v = cache.vehicles[slot]
    v.tick = getTickCount()
end)

function startRobbery(player, vehicle)
    if not isElement(player) or not isElement(vehicle) then
        return
    end
    local veh = getPedOccupiedVehicle(player)
    if (not veh or veh ~= vehicle) then
        return
    end
    if getElementData(vehicle, 'vehicle:keyIsUnlocking') then
        return
    end
    if (cache.cooldown[player] and getTickCount() - cache.cooldown[player] < 10000) then
        exports['since-notifications']:sendNotification(player, 'error', 'Poczekaj chwilę przed ponowną próbą.')
        return
    end
    local organization = getElementData(player, 'player:organization')
    if (not organization) then
        return
    end
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0', organization.id)
    if #rows >= 6 then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz zabrać więcej pojazdów do garażu.')
        return
    end
    cache.cooldown[player] = getTickCount()
    setElementData(vehicle, 'vehicle:keyIsUnlocking', true)
    triggerClientEvent(player, 'onClientStartRobbery', resourceRoot, vehicle)
end

function tryTurnEngine(player, vehicle)
    if not isElement(player) or not isElement(vehicle) then
        return
    end
    local veh = getPedOccupiedVehicle(player)
    if (not veh or veh ~= vehicle) then
        return
    end
    local organization = getElementData(player, 'player:organization')
    if (not organization) then
        return
    end
    local rows = exports['since-db']:query('Select * from `since-carsRobbery` where `inGarage` = ? and `onMap` = 0', organization.id)
    if #rows >= 6 then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz zabrać więcej pojazdów do garażu.')
        return
    end
    setVehicleEngineState(veh, not getVehicleEngineState(veh))
end

addEvent('onServerFinishRobbery', true)
addEventHandler('onServerFinishRobbery', resourceRoot, function(vehicle)
    local veh = getPedOccupiedVehicle(client)
    if (not veh or veh ~= vehicle) then
        return
    end
    if (not getElementData(vehicle, 'vehicle:keyIsUnlocking') or not getElementData(vehicle, 'vehicle:keyIsBlocked')) then
        return
    end
    unblockVehicle(vehicle)
    triggerClientEvent(client, 'onClientFinishRobbery', resourceRoot, config.positions.garageMarker)
end)

setTimer(function()
    for i,v in ipairs(cache.vehicles) do
        if (not v.timer) then
            if (v.veh and isElement(v.veh)) then
                local occupants = 0
                for i,v in pairs(getVehicleOccupants(v.veh)) do
                    occupants = occupants + 1
                end
                if occupants == 0 then
                    if (v.tick and getTickCount() - v.tick > 60000*10 and not isElementWithinColShape(v.veh, v.cuboid)) then
                        createNewVehicle(i, getElementData(v.veh, 'vehicle:robberyID'))
                    end
                end
            else
                if (v.tick and getTickCount() - v.tick > 60000*60) then
                    createNewVehicle(i)
                end
            end
        end
    end
    for player,row in pairs(cache.exporting) do
        if isElement(player) then
            local veh = getPedOccupiedVehicle(player)
            if (not veh or veh ~= row.vehicle) then
                if row.tick and getTickCount() - row.tick > 10000 then
                    if isElement(row.vehicle) then
                        destroyElement(row.vehicle)
                    end
                    triggerClientEvent(player, 'onClientDestroyExport', resourceRoot)
                    cache.exporting[player] = nil
                end
            end
        else
            if isElement(row.vehicle) then
                destroyElement(row.vehicle)
            end
            cache.exporting[player] = nil
        end
    end
end, 5000, 0)

addEventHandler('onPlayerQuit', root, function()
    if cache.cooldown[source] then
        cache.cooldown[source] = nil
    end
    if cache.exporting[source] then
        if isElement(cache.exporting[source].vehicle) then
            destroyElement(cache.exporting[source].vehicle)
        end
        cache.exporting[source] = nil
    end
    for i,v in ipairs(cache.garages) do
        for k,plr in ipairs(v.players) do
            if (plr == source) then
                table.remove(v.players, k)
                if (getPlayersInGarage(v.id) == 0) then
                    destroyGarage(v.id)
                end
                break
            end
        end
    end
end)

addEvent('vehicle:robberyAction', true)
addEventHandler('vehicle:robberyAction', resourceRoot, function(vehicle, action)
    if not isElement(client) or not isElement(vehicle) then
        return
    end
    local organization = getElementData(client, 'player:organization')
    if not organization then
        return
    end
    local v = findGarage(organization.id)
    if not v then
        return
    end
    if action >= 3 then
        return
    end
    local save = false
    for i,row in ipairs(v.vehicles) do
        if (row.vehicle == vehicle) then
            save = row
            break
        end
    end
    if not save then
        return
    end
    local id = save.id
    if cache.timers[id] then
        if cache.timers[id].action == 1 then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz ingerować w stan pojazdu, który jest aktualnie w trakcie naprawy.')
        elseif cache.timers[id].action == 2 then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz ingerować w stan pojazdu, który jest aktualnie w trakcie zmiany numeru VIN.')
        end
        return
    end
    local data = {}
    data.action = action
    data.timer = setTimer(function(id, action, player)
        local vehicle = findVehicleRobberyFromId(id)
        if (action == 1) then
            if vehicle then
                setElementData(vehicle, 'vehicle:robberyAction', 2)
                setElementHealth(vehicle, 1000)
            end
            exports['since-db']:query('Update `since-carsRobbery` set `state` = 2 where `id` = ?', id)
        elseif (action == 2) then
            if vehicle then
                setElementData(vehicle, 'vehicle:robberyAction', 3)
            end
            exports['since-db']:query('Update `since-carsRobbery` set `state` = 3 where `id` = ?', id)
        end
        if isTimer(cache.timers[id].timer) then
            killTimer(cache.timers[id].timer)
        end
        cache.timers[id] = nil
        if player then
            if isElement(player) then
                if action == 1 then
                    exports['since-notifications']:sendNotification(player, 'success', 'Zakończono naprawę pojazdu w dziupli.')
                elseif action == 2 then
                    exports['since-notifications']:sendNotification(player, 'success', 'Zakończono zmianę numeru VIN pojazdu w dziupli.')
                end
            end
        end
    end, 15*60000, 1, id, action, client)
    cache.timers[id] = data
    if action == 1 then
        exports['since-notifications']:sendNotification(client, 'success', 'Rozpoczęto naprawę pojazdu. (potrwa 15 minut)')
    elseif action == 2 then
        exports['since-notifications']:sendNotification(client, 'success', 'Rozpoczęto zmianę numeru VIN pojazdu. (potrwa 15 minut)')
    end
end)

function findVehicleRobberyFromId(id)
    for i,v in ipairs(cache.garages) do
        for k,row in ipairs(v.vehicles) do
            if (row.id == id) then
                return row.vehicle
            end
        end
    end
    return false
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end