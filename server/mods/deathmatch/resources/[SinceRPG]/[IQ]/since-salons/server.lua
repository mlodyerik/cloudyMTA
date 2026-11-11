local vehicles = {}
local blips = {
    {-1953.57, 270.34, 35.47}
}

function loadVehicles()
    for i,v in pairs(vehicles) do
        if (isElement(v)) then
            destroyElement(v)
        end
    end
    local rows = exports['since-db']:query('SELECT * FROM `since-salony`')
    for i,v in pairs(rows) do
        local x, y, z, r, o, t = unpack(fromJSON(v.position))
        local vehicle = createVehicle(v.model, x, y, z, r, o, t)
        setElementData(vehicle, 'salon:data', {
            model = v.model,
            count = v.count,
            price = v.price,
            engine = v.engine,
            mileage = math.random(1, 99999),
            id = v.id
        })
        setElementFrozen(vehicle, true)
        setVehicleLocked(vehicle, true)
        setVehicleColor(vehicle, 114, 137, 218)
        setElementData(vehicle, 'vehicle:desc', 'Aby dowiedziec sie wiecej o pojezdzie podejdz do niego!')
        table.insert(vehicles, vehicle)
    end
end

addEventHandler('onResourceStart', resourceRoot, loadVehicles)

for i,v in pairs(blips) do
    local blip = createBlip(v[1], v[2], v[3], 55)
end

local engines = {
    ['benzyna'] = true,
    ['disel'] = true
}

addCommandHandler('salon.dodaj', function (plr, cmd, model, count, price, engine, x, y, z, r, o, t)
    if (exports['since-utils']:isPlayerHaveOwnerPermissions(getPlayerSerial(plr))) then
        print(model, count, price, engine, x, y, z, r, o, t)
        if not model then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales modelu')
        end
        if not price then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales ceny')
        end
        if not engine then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales silnika')
        end
        if not x then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales x')
        end
        if not y then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales y')
        end
        if not z then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales z')
        end
        if not r then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales r')
        end
        if not o then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales o')
        end
        if not t then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales t')
        end
        if not engines[engine] then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales silnika')
        end
        if not count then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales ilosc')
        end
        exports['since-db']:query('INSERT INTO `since-salony` (`model`, `count`, `price`, `engine`, `position`) VALUES (?, ?, ?, ?, ?)', model, count, price, engine, toJSON({x, y, z, r, o, t}))
        exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie dodano pojazd:\nModel: '..model..'\nIlosc: '..count..'\nCena: '..price..'\nSilnik: '..engine..'\nX: '..x..'\nY: '..y..'\nZ: '..z..'\nR: '..r..'\nO: '..o..'\nT: '..t)
        loadVehicles()
    else
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie masz uprawnien')
    end
end)

addEvent('tryBuyVehicle', true)
addEventHandler('tryBuyVehicle', root, function (plr, id)
    local rows = exports['since-db']:query('SELECT * FROM `since-salony` WHERE id=?', id)
    if (#rows > 0) then
        if (rows[1].count > 0) then
            local money = getPlayerMoney(plr)
            if (money < rows[1].price) then
                exports['since-notifications']:sendNotification(plr, 'error', 'Nie masz wystarczajaco pieniedzy!')
            else
                exports['since-db']:query('UPDATE `since-salony` SET `count`=`count`-1 WHERE id=?', id)
                exports['since-core']:createPrivateVehicle(getElementData(plr, 'player:sid'), rows[1].model)
                takePlayerMoney(plr, rows[1].price)
                exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zakupiono pojazd!')
                loadVehicles()
            end
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Brak dostepnych pojazdow!')
        end
    end 
end)

local tryExit = {}
local vehs = {}

function testVehicle(id)
    local plr = client
    local playerSID = getElementData(plr, "player:sid")

    if not playerSID then
        return
    end

    if not tryExit[plr] then tryExit[plr] = 0 end

    local data = false

    for i,v in pairs(vehicles) do
        if (getElementData(v, 'salon:data').id == id) then
            data = getElementData(v, 'salon:data')
        end
    end

    if not data then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono pojazdu')
    end

    local x, y, z = getElementPosition(plr)
    local var1, var2 = getVehicleVariant(vehicle)
    setElementData(plr, 'player:safepos', {x, y, z, intdim[1], intdim[2]})

    local baseModel, isCustom = exports['since-custommodels']:checkModelID(data.model, 'vehicle')
    if isCustom then
        vehs[plr] = createVehicle(baseModel, -1105.35, 397.98, 13.88, 0.0, 360.0, 134.9)
        setElementData(vehs[plr], 'baseID', baseModel)
        setElementData(vehs[plr], 'vehicleID', data.model)
        setElementData(vehs[plr], 'vehicle:model', data.model)
    else
        vehs[plr] = createVehicle(data.model, -1105.35, 397.98, 13.88, 0.0, 360.0, 134.9)
    end

    setElementData(vehs[plr], 'vehicle:data', {

        engine = data.engine,

    })

    if data.sport then
        setElementData(vehs[plr], 'vehicle:upgrades', {sport = true})
    end

    if data.electric then
        setElementData(vehs[plr], 'vehicle:upgrades', {electric = true})
    end

    setVehicleColor(vehs[plr], 255, 255, 255, 255, 255, 255)
    setVehicleVariant(vehs[plr], var1, var2)

    if getVehicleType(vehs[plr]) == 'Boat' then
        setElementPosition(vehs[plr], 2450.06, 548.82, -0.51)
        setElementRotation(vehs[plr], 2.6, 0.1, 177.1)
    end

    setElementDimension(vehs[plr], playerSID)
    setElementDimension(plr, playerSID)
    setElementInterior(plr, 0)

    setTimer(function(player)
        warpPedIntoVehicle( player, vehs[player] )
        exports['since-handlings']:loadVehicleCustomHandling(vehs[player])

        exports['since-notifications']:sendNotification(player, 'info', 'Aby zakończyć jazdę próbną spróbuj wysiąść z pojazdu')
    end, 100, 1, plr)
end