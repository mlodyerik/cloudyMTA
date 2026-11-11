  
function createDate()
    local time = getRealTime()
    local year = time.year + 1900
    local month = time.month + 1
    local day = time.monthday
    local hour = time.hour
    local minute = time.minute

    return {year = year, month = month, day = day, hour = hour, minute = minute}
end

function compareDates(date1, date2)
    -- Porównanie rok, miesiąc, dzień, godzina, minuta
    if date1.year ~= date2.year then
        return date1.year < date2.year
    elseif date1.month ~= date2.month then
        return date1.month < date2.month
    elseif date1.day ~= date2.day then
        return date1.day < date2.day
    elseif date1.hour ~= date2.hour then
        return date1.hour < date2.hour
    elseif date1.minute ~= date2.minute then
        return date1.minute < date2.minute
    end
    return false -- Daty są takie same
end

function getDate(oldDate)
    local newDate = createDate()
    oldDate = oldDate or newDate

    -- Porównaj oldDate z newDate
    if compareDates(oldDate, newDate) then
        return true, newDate  -- oldDate jest starsze, zwracamy true i newDate
    else
        return false, oldDate -- oldDate nie jest starsze, zwracamy false i oldDate
    end
end

function updateDays(amount)
    local date = createDate()

    date.day = date.day + amount

    return date
end

function getPrzegladDate(vehicle)
	local queryA = exports['since-db']:query("SELECT * FROM `since-vehicles` WHERE id=? AND przeglad > NOW() LIMIT 1", getElementData(vehicle, "vehicle:id"))

	if (queryA and #queryA > 0) then
		return queryA[1].przeglad
	end

	return false	
end

function setPrzegladDay(vehicle, days)
	if getPrzegladDate(vehicle) then
		return exports['since-db']:query(string.format("UPDATE `since-vehicles` SET przeglad = przeglad + INTERVAL %d DAY WHERE id = %d", days, getElementData(vehicle,"vehicle:id")))
	end

	exports['since-db']:query(string.format("UPDATE `since-vehicles` SET przeglad = NOW() + INTERVAL %d DAY WHERE id = %d", days, getElementData(vehicle,"vehicle:id")))
end

addEvent("getData", true)
addEventHandler("getData", resourceRoot, function(eType, ...)
    local args = {...}

    if eType == 'get' then
        local vehicle = args[1]
        local vehicleID = getElementData(vehicle, 'vehicle:id')

        if vehicleID then
            local przeglad = getPrzegladDate(vehicle)

            if przeglad then
                triggerClientEvent(client, 'getData', resourceRoot, 'get', przeglad and 'Przegląd ważny do #7dff7d'..przeglad..'' or 'Przegląd przedawniony')
            else
                triggerClientEvent(client, 'getData', resourceRoot, 'get', 'Brak przeglądu')
            end
        end
    elseif eType == 'set' then
        local vehicle = args[1]
        local vehicleID = getElementData(vehicle, 'vehicle:id')

        if vehicleID then
            local vehicleOccupant = getVehicleController(vehicle)

            if not vehicleOccupant then
                return exports['since-notifications']:sendNotification(client, 'error', 'W pojeździe musi znajdować się kierowca.')
            end

            local money = getPlayerMoney(vehicleOccupant)

            if money < cost then
                exports['since-notifications']:sendNotification(vehicleOccupant, 'error', 'Nie posiadasz wystarczającej ilości gotówki.')
                return exports['since-notifications']:sendNotification(client, 'error', 'Gracz nie posiada wystarczającej ilości gotówki.')
            end

            local vehicleData = getElementData(vehicle, 'vehicle:data') or {}

            if vehicleData.mileage > 10000 then
                exports['since-notifications']:sendNotification(vehicleOccupant, 'error', 'Pojazd ma za dużo przejechanych kilometrów (10,000 km). Wykonaj remont silnika w warsztacie tuningowym')
                return exports['since-notifications']:sendNotification(client, 'error', 'Pojazd ma za dużo przejechanych kilometrów (10,000 km).')
            end

            takePlayerMoney( vehicleOccupant, cost )
            givePlayerMoney( client, math.floor(cost/2) )
            exports['since-notifications']:sendNotification(client, 'info', 'Przegląd pojazdu został wykonany pomyślnie, otrzymano $ '..addCommas(math.floor(cost/2))..'.')
            exports['since-notifications']:sendNotification(vehicleOccupant, 'info', 'Przegląd pojazdu został wykonany pomyślnie, pobrano $ '..addCommas(cost)..'.')

            setPrzegladDay(vehicle, 14)

            setTimer(function(vehicle, plr)
                local date = getPrzegladDate(vehicle)

                triggerClientEvent(plr, 'getData', resourceRoot, 'get', 'Przegląd ważny do #7dff7d'..date..'')
            end, 100, 1, vehicle, client)
        end
    end
end)

function getCuboidByID(id)
    local cuboids = getElementsByType('colshape', resourceRoot)

    for i, v in ipairs(cuboids) do
        if getElementData(v, 'cuboid:id') == id then
            return v
        end
    end
end

function construct()
    for i, v in ipairs(positions) do
        local x, y, z = unpack(v.cuboid)
        local cuboid = createColSphere(x, y, z-0.4, 2.5)
        setElementData(cuboid, 'cuboid:id', i)

        local x, y, z = unpack(v.marker)
        local marker = createMarker(x, y, z - 0.8, 'cylinder', 2, 125, 255, 125, 0)
        setElementData(marker, 'marker:title', 'Przegląd')
        setElementData(marker, 'marker:desc', 'Stacja kontroli pojazdów')
        setElementData(marker, 'marker:icon', 'salon')
        setElementData(marker, 'marker:id', i)

        addEventHandler('onMarkerLeave', marker, function(leaveElement, md)
            if leaveElement and md then
                if getElementType(leaveElement) == 'player' then
                    local markerID = getElementData(source, 'marker:id')

                    if markerID then
                        triggerClientEvent(leaveElement, 'getData', resourceRoot, 'markerLeave')
                    end
                end
            end
        end)

        addEventHandler('onMarkerHit', marker, function(hitElement, md)
            if hitElement and md then
                if getElementType(hitElement) == 'player' and getElementData(hitElement, 'player:faction') == 'SARA' then
                    local markerID = getElementData(source, 'marker:id')

                    local vehicleCol = getCuboidByID(markerID)

                    if vehicleCol then
                        local vehicles = getElementsWithinColShape(vehicleCol, 'vehicle')

                        if #vehicles > 1 then
                            return
                        end

                        local vehicle = vehicles[1]

                        if vehicle then
                            local vehicleID = getElementData(vehicle, 'vehicle:id')

                            if vehicleID then
                                triggerClientEvent(hitElement, 'getData', resourceRoot, 'markerHit', vehicle)
                            end
                        end
                    end
                end
            end
        end)
    end
end
addEventHandler("onResourceStart", resourceRoot, construct)