local vehs = {}
local tryExit = {}
local timers = {}

function getPlayerBankMoney(player)
    if not getElementData(player, 'player:sid') then return 0 end
    local db = exports['since-db']:query('SELECT bankMoney from `since-users` where uid=? limit 1', getElementData(player, 'player:sid'))
    if #db == 0 then return 0 end
    return db[1].bankMoney
end

function takePlayerBankMoney(player, amount)
    if not getElementData(player, 'player:sid') then return end
    exports['since-db']:query('UPDATE `since-users` SET bankMoney=bankMoney-? WHERE uid=?', amount, getElementData(player, 'player:sid'))
end

function buyVehicle(data, vehicle)
    local plr = client
    local playerSID = getElementData(plr, 'player:sid')

    if not playerSID then
        return
    end

    if data.cost > getPlayerBankMoney(plr) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz tyle gotówki na koncie bankowym')
    end

    -- takePlayerMoney(plr, data.cost)
    takePlayerBankMoney(plr, data.cost)

    -- local x, y, z = getElementPosition(vehicle)
    -- setElementPosition(vehicle, x, y, z + 500)
    -- setElementAlpha(vehicle, 0)
    -- setElementCollisionsEnabled(vehicle, false)

    -- local time = data.sport and 2 or 0.1

    -- timers[vehicle] = setTimer(function(vehicle)
    --     local x, y, z = getElementPosition(vehicle)
    --     setElementPosition(vehicle, x, y, z - 500)
    --     setElementAlpha(vehicle, 255)
    --     setElementCollisionsEnabled(vehicle, true)
    -- end, (60000 * 60) * time, 1, vehicle)

    local clr = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
    local hclr = {255, 255, 255}
    local wheelTuning = {

        vinylRim = 0,
        vinylWounds = 0,
        wheelTilt = 0,
        innerSize = 0.8,
        wheelResize = 1,

    }

    local theEngine = string.format("%.1f", data.engine)
    local theEngine = tonumber(theEngine)

    local vehData = {

        driver = 'Brak',
        mileage = data.mileage,
        engine = theEngine,
        non_transferable = data.tradeban or false,


    }

    local fuel = {

        count = data.tank,
        tank = data.tank,

    }

    local variant = data.variant or {0,0}

    local upgrades = {}

    if data.sport then
        upgrades['sport'] = true
    end

    if data.paintjob then
        upgrades['custompaintjob'] = 93
    end

    if data.electric then
        upgrades['electric'] = true
    end

    if (data.model == 432 or data.model == 520) then
        exports['since-antycheat']:detect(plr, 'Próba zakupu czołgu')
    end

    local isInTable = false
    local actualCost = {}
    for i,v in ipairs(vehicles) do
        if (v and v.data and v.data.model == data.model) then
            table.insert(actualCost, v.data.cost)
            isInTable = true
        end
    end

    if (not isInTable) then
        exports['since-antycheat']:detect(plr, 'Próba zakupu nieistniejącego w salonie pojazdu')
    else
        if (#actualCost > 0) then
            local count = 0
            for i,v in ipairs(actualCost) do
                if (v == data.cost) then
                    count = count + 1
                end
            end
            if (count == 0) then
                exports['since-antycheat']:detect(plr, 'Próba zakupu pojazdu za inną cenę niż w salonie')
            end
        end
    end
    
    local q = exports['since-db']:query('INSERT INTO `since-vehicles` (`model`, `fuel`, `upgrades`, `data`, `color`, `headlight`, `wheelTuning`, `owner`, `state`, `variant`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)', data.model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(vehData), serpent.dump(clr), serpent.dump(hclr), serpent.dump(wheelTuning), playerSID, serpent.dump(variant))
    
    if q then
        exports['since-notifications']:sendNotification(plr, 'success', 'Zakupiłeś pojazd #47afff'..exports['since-vehiclenames']:getVehicleName(data.model)..'#ffffff za kwotę #7ce673$ '..addCommas(data.cost)..'#ffffff. Pojazd możesz odebrać w przechowalni.')
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Zakup zakończony niepowodzeniem, zgłoś błąd do administracji')
    end
end
addEvent('buyVehicle', true)
addEventHandler('buyVehicle', resourceRoot, buyVehicle)

function testVehicle(data, intdim, vehicle)
    local plr = client
    local playerSID = getElementData(plr, "player:sid")

    if not playerSID then
        return
    end

    if not tryExit[plr] then tryExit[plr] = 0 end

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
addEvent('testVehicle', true)
addEventHandler('testVehicle', resourceRoot, testVehicle)

function destroyTestVehicle(plr)
    removePedFromVehicle(plr)
    if vehs[plr] then
        destroyElement(vehs[plr])
    end

    tryExit[plr] = 0

    setTimer(function()
        local x, y, z, int, dim = unpack(getElementData(plr, 'player:safepos'))
        setElementDimension(plr, dim)
        setElementInterior(plr, int)
        setElementPosition(plr, x, y, z)
        setElementData(plr, "player:safepos", false)
    end, 100, 1)
end

function onTryExit(plr, seat, jacked)
    if not tryExit[plr] then tryExit[plr] = 0 end
    
    tryExit[plr] = tryExit[plr] + 1

    if tryExit[plr] == 1 then
        exports['since-notifications']:sendNotification(plr, 'info', 'Aby zakończyć jazdę próbną szybko kliknij klawisz ponownie')

        setTimer(function()
            tryExit[plr] = 0
        end, 500, 1)

        cancelEvent()
    elseif tryExit[plr] >= 2 then
        exports['since-notifications']:sendNotification(plr, 'success', 'Jazda próbna zakończona')
        destroyTestVehicle(plr)
        cancelEvent()
    end
end
addEventHandler("onVehicleStartExit", resourceRoot, onTryExit)


addEventHandler("onVehicleStartEnter", resourceRoot, function()
    cancelEvent()
end)

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

