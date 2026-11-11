

addEvent('onJobVehicleStart', true)
addEventHandler('onJobVehicleStart', resourceRoot, function (current, type)
    local player = client

    if (not isElement(player)) then return end

    local data = getPlayerJobData(player)

    if (not data) then return end

    if (data.actual and data.actual.current) then
        exports['since-notifications']:sendNotification(player, 'error', 'Masz już aktywne zlecenie')
        return
    end

    local vehicle = data.vehicles[type][current]

    if (not vehicle) then return end

    if (data.actual and data.actual.vehicle and isElement(data.actual.vehicle)) then
        data.actual.type = type
        data.actual.current = current

        updatePlayerJobData(player, data)

        triggerClientEvent(player, 'onClientStartJobVehicle', resourceRoot, vehicle)
    else
        local veh = createVehicle(config.vehicles[type], config.positions.spawnVehicle[1], config.positions.spawnVehicle[2], config.positions.spawnVehicle[3], config.positions.spawnVehicle[4], config.positions.spawnVehicle[5], config.positions.spawnVehicle[6])
        warpPedIntoVehicle(player, veh)
        
        setElementData(veh, 'vehicle:job', true)
        setElementData(veh, 'vehicle:job:player', player)
        setElementData(player, 'player:job:vehicle', veh)

        data.actual = {
            vehicle = veh,
            type = type,
            current = current
        }

        -- add handling
        setVehicleHandling(veh, 'maxVelocity', 200)
        setVehicleHandling(veh, 'engineAcceleration', 17)
        setVehicleHandling(veh, 'steeringLock', 40)
        setVehicleHandling(veh, 'tractionLoss', 1.5)
        setVehicleHandling(veh, 'brakeDeceleration', 10)
        
        updatePlayerJobData(player, data)

        triggerClientEvent(player, 'onClientStartJobVehicle', resourceRoot)
    end
end)

addEventHandler('onVehicleStartEnter', root, function (player, seat, jacked)
    if (getElementData(source, 'vehicle:job') and getElementData(source, 'vehicle:job:player') ~= player) then
        cancelEvent()
    end

    if (getElementData(source, 'vehicle:id') and getElementData(player, 'player:job') == 'lsm') then
        cancelEvent()
        exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wsiąść do pojazdu w trakcie pracy')
    end
end)

addEvent('onJobEndFixVehicle', true)
addEventHandler('onJobEndFixVehicle', resourceRoot, function ()
    local player = client

    if (not isElement(player)) then return end

    local data = getPlayerJobData(player)

    if (not data) then return end

    if (not data.actual) then return end
    
    local vehicleData = data.vehicles[data.actual.type][data.actual.current]

    givePlayerMoney(player, vehicleData.money * exports['since-jobs']:getJobMultiplier('lsm'))
    exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został naprawiony, otrzymujesz $' .. addCommas(vehicleData.money))

    local random = math.random(1, 100)

    if (random <= 30) then
        local rnd = math.random(1, 6)
        exports['since-jobs']:addPlayerJobPoints(player, 'lsm', rnd)

        exports['since-notifications']:sendNotification(player, 'success', 'Otrzymujesz '..rnd..' punktów ulepszeń')
    end

    table.remove(data.vehicles[data.actual.type], data.actual.current)

    if (#data.vehicles[data.actual.type] == 0) then
        exports['since-notifications']:sendNotification(player, 'success', 'Zakończyłeś wszystkie zlecenia')
        destroyElement(data.actual.vehicle)
        updatePlayerJobData(player, false)
        setElementPosition(player, config.positions.spawnPlayer[1], config.positions.spawnPlayer[2], config.positions.spawnPlayer[3])
        triggerClientEvent(player, 'onClientFinishLSMJob', resourceRoot)
        setElementData(player, 'player:job:vehicle', false)
        setElementData(player, 'player:job', false)

        return
    end

    data.actual.current = false
    data.actual.type = false

    updatePlayerJobData(player, data)
end)