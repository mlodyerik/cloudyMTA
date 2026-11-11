positions = {

    {1302.07, -1864.30, 13.55, -0.00, 0.00, 178.31},
    {1302.15, -1870.78, 13.55, -0.00, 0.00, 185.32},
    {1302.43, -1877.23, 13.55, -0.00, 0.00, 182.50},
    {-2875.28, -2216.41, 35.50, -0.00, 0.00, 117.86},

}

addEvent('setBatteryVariable', true)
addEventHandler('setBatteryVariable', resourceRoot, function(data)
    local vehicle = getPedOccupiedVehicle(client)

    if not vehicle then
        return
    end

    setElementData(vehicle, 'vehicle:fuel', data)
end)

for i, v in pairs(positions) do
    local marker = createMarker(v[1], v[2], v[3] - 0.7, 'cylinder', 3, 125, 255, 125, 100)
    setElementData(marker, 'marker:icon', 'charger')
    setElementData(marker, 'marker:title', 'Supercharger')
    setElementData(marker, 'marker:desc', 'Ładowanie pojazdów elektrycznych')

    addEventHandler('onMarkerHit', marker, function(el, md)
        if el and getElementType(el) ~= 'player' then
            return
        end

        if not md then
            return
        end

        if not getPedOccupiedVehicle(el) then
            return
        end

        local upgrades = getElementData(getPedOccupiedVehicle(el), 'vehicle:upgrades') or {}

        if not upgrades.electric then
            return exports['since-notifications']:sendNotification(el, 'error', 'Twój pojazd nie posiada silnika elektrycznego')
        end

        triggerClientEvent(el, 'toggleBatteryUI', resourceRoot, true)
    end)

    addEventHandler('onMarkerLeave', marker, function(el, md)
        if el and getElementType(el) ~= 'player' then
            return
        end

        if not md then
            return
        end

        triggerClientEvent(el, 'toggleBatteryUI', resourceRoot, false)
    end)
end