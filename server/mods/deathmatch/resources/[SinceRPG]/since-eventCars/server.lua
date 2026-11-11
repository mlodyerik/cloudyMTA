local positions = {
    -- {1465.84, -1661.10, 12.94, 358.9, 0.0, 270.6},
    {2361.49, 674.64, 10.93, 358.3, 0.2, 269.9},
    {2911.42, 701.13, 29.62, 9.1, 359.6, 30.4},
    {2841.45, 987.01, 13.06, 359.5, 360.0, 178.6},
    {2846.58, 1635.12, 10.47, 359.4, 360.0, 1.2},
    {2617.47, 2128.16, 10.48, 359.5, 0.0, 88.6},
    {2255.40, 2340.41, 10.48, 359.5, 360.0, 207.4},
    {1940.38, 2211.94, 23.57, 359.6, 360.0, 0.4},
    {1749.52, 2822.06, 10.49, 359.5, 360.0, 208.8},
    {1450.17, 2772.90, 26.43, 359.7, 28.3, 269.8},
    {1675.28, 1435.79, 10.43, 359.6, 359.9, 178.4},
    {1160.26, 1396.52, 5.48, 359.5, 360.0, 180.4},
    {1124.26, 1939.40, 10.48, 359.5, 360.0, 90.4},
    {1147.06, 2332.49, 10.48, 359.5, 360.0, 134.8},
    {2115.55, 2435.42, 60.46, 359.6, 360.0, 328.4},
    {2443.13, 2251.89, 10.48, 359.5, 0.0, 179.4},
    {2493.83, 1834.83, 15.98, 359.5, 360.0, 196.8},
    {2185.73, 1078.80, 10.46, 359.5, 360.0, 30.5},
    {2121.81, 1492.94, 10.46, 359.5, 0.0, 358.2},
    {2308.54, 1686.76, 10.47, 359.5, 360.0, 356.4},
    {2102.60, 1996.64, 10.47, 359.6, 0.0, 228.4},
    {2000.49, 1566.13, 15.01, 359.5, 360.0, 181.2},
    {1970.15, 1560.78, 9.83, 359.4, 3.7, 97.0},
    {1630.24, 1157.12, 10.46, 359.3, 360.0, 359.8},
    {1263.06, 1360.25, 10.47, 359.5, 360.0, 353.2},
    {1342.75, 2017.36, 10.46, 359.2, 360.0, 1.2},
    {1338.43, 2079.43, 13.55, 359.8, 348.3, 91.6},
    {1316.19, 2212.39, 11.64, 359.5, 0.1, 269.8},
    {1692.23, 2229.05, 17.33, 0.4, 328.1, 268.2},
    {1693.28, 2229.13, 17.32, 0.5, 328.1, 267.9},
    {1741.36, 2257.29, 10.35, 359.7, 360.0, 358.5},
    {1773.90, 2167.37, 6.14, 10.2, 328.2, 159.7},
    {1974.76, 2091.72, 10.48, 359.5, 0.0, 183.4},
    {1891.86, 1474.71, 9.61, 355.6, 319.5, 271.3},
    {2099.59, 887.69, 10.46, 359.5, 360.0, 178.5},
}

local model = 80150
local price = 500000000

local vehicles = {}

function addCommas(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function setVehicleDesc(veh, text)
    local upgrades = getElementData(veh, "vehicle:upgrades") or {}
    upgrades['vopis'] = true
    upgrades['vopis:text'] = text
    setElementData(veh, "vehicle:upgrades", upgrades)
end

function getNearestVehicle(player)
    if (not isElement(player)) then
        return
    end

    local x, y, z = getElementPosition(player)
    local nearestVehicle = nil
    local nearestDistance = 5

    for i,v in pairs(vehicles) do
        local vx, vy, vz = getElementPosition(v)
        local distance = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)

        if (distance < nearestDistance) then
            nearestDistance = distance
            nearestVehicle = v
        end
    end

    return nearestVehicle
end

function removeBuyedVehicle(vehicle)
    for i,v in pairs(vehicles) do
        if (v == vehicle) then
            table.remove(vehicles, i)
            break
        end
    end
end

function tryBuyVehicle(player, cuboid)
    if (isPedInVehicle(player)) then
        return
    end

    local vehicle = getNearestVehicle(player)

    if (not vehicle) then
        return
    end

    if (not getElementData(vehicle, 'vehicle:model')) then
        return
    end

    if (getElementData(vehicle, 'vehicle:model') ~= model) then
        return
    end

    local money = getPlayerMoney(player)

    if (money < price) then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz wystarczającej ilości gotówki')
        return
    end

    takePlayerMoney(player, price)

    local upgrades = {
        ['mk1'] = true,
        ['mk2'] = true,
        ['mk3'] = true,
        ['mk4'] = true,
        ['mk5'] = true,
        ['mk6'] = true
    }

    local fuel = {
        ['count'] = 100,
        ['tank'] = 100
    }

    local clr = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
    local hclr = {255, 255, 255}

    local vehData = {
        ['driver'] = 'Brak',
        ['mileage'] = 0,
        ['engine'] = 0,
        ['non_transferable'] = false
    }

    local wheelTuning = {
        ['vinylRim'] = 0,
        ['vinylWounds'] = 0,
        ['wheelTilt'] = 0,
        ['innerSize'] = 0.8,
        ['wheelResize'] = 1
    }

    local variant = {0, 0}

    local q = exports['since-db']:query('INSERT INTO `since-vehicles` (`model`, `fuel`, `upgrades`, `data`, `color`, `headlight`, `wheelTuning`, `owner`, `state`, `variant`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)', model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(vehData), serpent.dump(clr), serpent.dump(hclr), serpent.dump(wheelTuning), getElementData(player, 'player:sid'), serpent.dump(variant))

    if (q) then
        destroyElement(getElementData(vehicle, 'vehicle:cuboid'))
        exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie zakupiłeś pojazd')
        removeBuyedVehicle(vehicle)
        destroyElement(vehicle)

        outputChatBox('Gracz #7dff7d'..getPlayerName(player)..'#ffffff zakupił unikatowy pojazd!', root, 255, 255, 255, true)
        outputChatBox('Pozostało: #7dff7d'..#vehicles..'#ffffff pojazdów', root, 255, 255, 255, true)
    else
        exports['since-notifications']:sendNotification(player, 'error', 'Wystąpił błąd podczas zakupu pojazdu')
    end
end

addCommandHandler('kuppojazd', function (player)
    if (isPedInVehicle(player)) then
        return
    end

    local vehicle = getNearestVehicle(player)

    if (not vehicle) then
        return
    end

    if (not getElementData(vehicle, 'vehicle:model')) then
        return
    end

    if (getElementData(vehicle, 'vehicle:model') ~= model) then
        return
    end

    tryBuyVehicle(player)
end)

addEventHandler('onResourceStart', resourceRoot, function ()
    for i,v in pairs(positions) do
        local baseModel, isCustom = exports['since-custommodels']:checkModelID(model, 'vehicle')

        local x, y, z, rotX, rotY, rotZ = unpack(v)

        local vehicle = createVehicle(baseModel, x, y, z, rotX, rotY, rotZ)
        setElementData(vehicle, 'baseID', baseModel)
        setElementData(vehicle, 'vehicleID', model)
        setVehicleLocked(vehicle, true)
        setElementData(vehicle, 'vehicle:model', model)

        local cuboid = createColSphere(x, y, z, 3)

        setElementData(vehicle, 'vehicle:cuboid', cuboid)

        addEventHandler('onColShapeHit', cuboid, function (hitElement, matchingDimension)
            if (hitElement and getElementType(hitElement) == 'player' and matchingDimension) then
                local player = hitElement

                if (not isPedInVehicle(player)) then
                    exports['since-notifications']:sendNotification(player, 'info', 'Aby zakupić pojazd wpisz /kuppojazd')
                end
            end
        end)

        addEventHandler('onColShapeLeave', cuboid, function (hitElement, matchingDimension)
            if (hitElement and getElementType(hitElement) == 'player' and matchingDimension) then
                local player = hitElement

                if (not isPedInVehicle(player)) then
                end
            end
        end)

        setElementFrozen(vehicle, true)
        setVehicleDesc(vehicle, [[
            #7dff7dLimitowana edycja#ffffff

            Pojazd: #7dff7d]]..i..[[ #ffffffz #7dff7d]]..#positions..[[#ffffff
            Cena: #7dff7d$]]..addCommas(price)..[[#ffffff
        ]])

        table.insert(vehicles, vehicle)
    end
end)