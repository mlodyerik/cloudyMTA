addCommandHandler('tt', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end

    local target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza!') end

    local playerData = getElementData(target, 'player:data') or {}

    if getElementData(player, 'player:admin') ~= 4 then
        if getElementData(target, 'player:admin') == 4 and not playerData['admin:allow.tp'] then
            return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz teleportować się do właściciela!')
        end
    end

    local element = getPedOccupiedVehicle(player) or player
    local vehicle = getPedOccupiedVehicle(target)

    

    if vehicle then
        local freeSeat = false
        for i = 0, getVehicleMaxPassengers(vehicle) do
            if not getVehicleOccupant(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            if getPedOccupiedVehicle(player) then
                removePedFromVehicle(player)
            end

            setElementInterior(player, getElementInterior(target))
            setElementDimension(player, getElementDimension(target))
            warpPedIntoVehicle(player, vehicle, freeSeat)
            exports['since-notifications']:sendNotification(player, 'success', 'Teleportowano do pojazdu gracza!')
            return
        end
    end

    if getPedOccupiedVehicle(player) then
        removePedFromVehicle(player)
    end

    local x, y, z = getElementPosition(target)
    setElementPosition(element, x, y + 1, z)
    setElementInterior(element, getElementInterior(target))
    setElementDimension(element, getElementDimension(target))

    exports['since-notifications']:sendNotification(player, 'success', 'Teleportowano do gracza!')
end)

addCommandHandler('allow.tp', function(player, cmd)
    if getAdmin(player, 4) then
        local playerData = getElementData(player, 'player:data') or {}

        playerData['admin:allow.tp'] = not playerData['admin:allow.tp']

        setElementData(player, 'player:data', playerData)

        if playerData['admin:allow.tp'] then
            exports['since-notifications']:sendNotification(player, 'success', 'Włączono możliwość teleportowania się do ciebie!')
        else
            exports['since-notifications']:sendNotification(player, 'success', 'Wyłączono możliwość teleportowania się do ciebie!')
        end
    end
end)

addCommandHandler('th', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end

    local target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza!') end

    local playerData = getElementData(target, 'player:data') or {}

    if getElementData(player, 'player:admin') ~= 4 then
        if getElementData(target, 'player:admin') == 4 and not playerData['admin:allow.tp'] then
            return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz teleportować właściciela do siebie!')
        end
    end

    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        local freeSeat = false
        for i = 0, getVehicleMaxPassengers(vehicle) do
            if not getVehicleOccupant(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            if getPedOccupiedVehicle(target) then
                removePedFromVehicle(target)
            end

            setElementInterior(target, getElementInterior(player))
            setElementDimension(target, getElementDimension(player))
            warpPedIntoVehicle(target, vehicle, freeSeat)
            exports['since-notifications']:sendNotification(player, 'success', 'Teleportowano gracza do pojazdu!')
            return
        end
    end

    if getPedOccupiedVehicle(target) then
        removePedFromVehicle(target)
    end

    local x, y, z = getElementPosition(player)
    setElementPosition(target, x, y + 1, z)
    setElementInterior(target, getElementInterior(player))
    setElementDimension(target, getElementDimension(player))

    exports['since-notifications']:sendNotification(player, 'success', 'Teleportowano gracza do siebie!')
end)

addCommandHandler('vtt', function(player, cmd, id)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error','Nie posiadasz uprawnień do tej komendy!') end
    if not id or not tonumber(id) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś ID pojazdu!') end

    local vehicle = false
    for _, v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == tonumber(id) then
            vehicle = v
            break
        end
    end
    if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono pojazdu!') end

    local freeSeat = false
    for i = 0, getVehicleMaxPassengers(vehicle) do
        if not getVehicleOccupant(vehicle, i) then
            freeSeat = i
            break
        end
    end

    if freeSeat then
        if getPedOccupiedVehicle(player) then
            removePedFromVehicle(player)
        end

        setElementInterior(player, getElementInterior(vehicle))
        setElementDimension(player, getElementDimension(vehicle))
        warpPedIntoVehicle(player, vehicle, freeSeat)
        exports['since-notifications']:sendNotification(player, 'success', 'Teleportowano do pojazdu!')
        return
    end

    if getPedOccupiedVehicle(player) then
        removePedFromVehicle(player)
    end

    local x, y, z = getElementPosition(vehicle)
    setElementPosition(player, x, y, z + 1)
    setElementInterior(player, getElementInterior(vehicle))
    setElementDimension(player, getElementDimension(vehicle))
    exports['since-notifications']:sendNotification(player, 'success', 'Teleportowano do pojazdu!')
end)

addCommandHandler('vth', function(player, cmd, id)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not id or not tonumber(id) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś ID pojazdu!') end

    local vehicle = false
    for _, v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == tonumber(id) then
            vehicle = v
            break
        end
    end

    if not vehicle then 
        local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id=?', id)

        if getElementData(player, 'player:admin') and getElementData(player, 'player:admin') ~= 4 then
            if (#rows > 0 and rows[1].state == 2) then
                return exports['since-notifications']:sendNotification(player, 'error', 'Pojazd znajduje się na parkingu policyjnym')
            end
        end

        if (#rows > 0 and rows[1].state == 1) then
            local x, y, z = getElementPosition(player)
            local rx, ry, rz = getElementRotation(player)
            local vehicle = exports['since-core']:loadVehicle(rows[1])
            exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 0, id)

            setElementPosition(vehicle, x, y, z)
            setElementRotation(vehicle, rx, ry, rz)
            setElementInterior(vehicle, getElementInterior(player))
            setElementDimension(vehicle, getElementDimension(player))

            setTimer(function ()
                warpPedIntoVehicle(player, vehicle)
                exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został przeniesiony z przechowalni')
            end, 100, 1)
        end
    else
        local x, y, z = getElementPosition(player)
        local rx, ry, rz = getElementRotation(player)
        setElementPosition(vehicle, x, y, z)
        setElementRotation(vehicle, rx, ry, rz)
        setElementInterior(vehicle, getElementInterior(player))
        setElementDimension(vehicle, getElementDimension(player))
        warpPedIntoVehicle(player, vehicle, 0)
        exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został teleportowany do ciebie!')
    end
end)

addCommandHandler('vth.cars', function(player, cmd, ...)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    local ids = {...}
    local count = 0

    -- transfer ids to table of numbers
    for i, id in ipairs(ids) do
        ids[i] = tonumber(id)
    end

    if #ids == 0 then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś ID pojazdów!')
    end

    for _, id in ipairs(ids) do
        local vehicle = false
        for _, v in ipairs(getElementsByType('vehicle')) do
            if getElementData(v, 'vehicle:id') == id then
                vehicle = v
                break
            end
        end

        count = count + 1

        if not vehicle then
            local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id=?', id)

            if getElementData(player, 'player:admin') and getElementData(player, 'player:admin') ~= 4 then
                if (#rows > 0 and rows[1].state == 2) then
                    return exports['since-notifications']:sendNotification(player, 'error', 'Pojazd znajduje się na parkingu policyjnym')
                end
            end

            if (#rows > 0 and rows[1].state == 1) then
                local x, y, z = getElementPosition(player)
                local rx, ry, rz = getElementRotation(player)
                local vehicle = exports['since-core']:loadVehicle(rows[1])
                exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 0, id)

                setElementPosition(vehicle, x, y + (3 * count), z)
                setElementRotation(vehicle, rx, ry, rz)
                setElementInterior(vehicle, getElementInterior(player))
                setElementDimension(vehicle, getElementDimension(player))

                setTimer(function ()
                    warpPedIntoVehicle(player, vehicle)
                    exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został przeniesiony z przechowalni')
                end, 100, 1)
            end
        else
            local x, y, z = getElementPosition(player)
            local rx, ry, rz = getElementRotation(player)
            setElementPosition(vehicle, x, y + (3 * count), z)
            setElementRotation(vehicle, rx, ry, rz)
            setElementInterior(vehicle, getElementInterior(player))
            setElementDimension(vehicle, getElementDimension(player))
            warpPedIntoVehicle(player, vehicle, 0)
            exports['since-notifications']:sendNotification(player, 'success', 'Pojazd został teleportowany do ciebie!')
        end
    end
end)