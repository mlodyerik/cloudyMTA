-- function rotateVehicle(vehicle)
--     if not vehicle then return end 
--     local rx, ry, rz = getElementRotation(vehicle)
--     if rx >= 180 then
--         setElementRotation(vehicle, 0, 0, rz)
--         exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie obrócono pojazd')
--     end 
-- end
-- addEvent('rotateVehicle', true)
-- addEventHandler('rotateVehicle', getResourceRootElement(), rotateVehicle)

local ticks = {}

addCommandHandler('op', function (plr)
    if (not getPedOccupiedVehicle(plr)) then
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie znajdujesz się w pojeździe')
        return
    end

    if (ticks[plr] and ticks[plr] > getTickCount() - 5000) then
        exports['since-notifications']:sendNotification(plr, 'error', 'Obracać pojazd możesz co 5 sekund')
        return
    end

    local vehicle = getPedOccupiedVehicle(plr)
    local rx, ry, rz = getElementRotation(vehicle)

    if (getElementModel(vehicle) == 444 ) then
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie można obrócić tego pojazdu')
        return
    end

    -- if (rx < 180) then
    --     exports['since-notifications']:sendNotification(plr, 'error', 'Pojazd nie wymaga obrócenia')
    --     return
    -- end

    ticks[plr] = getTickCount()
    setElementRotation(vehicle, 0, 0, rz)
    exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie obrócono pojazd')
end)