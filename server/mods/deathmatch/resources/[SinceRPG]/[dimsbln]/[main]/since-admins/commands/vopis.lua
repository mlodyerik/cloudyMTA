addCommandHandler('vopis', function(player, cmd, ...)
    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znajdujesz się w pojeździe!') end

    local upgrades = getElementData(vehicle, 'vehicle:upgrades') or {}
    local owner = getElementData(vehicle, 'vehicle:owner')

    if owner ~= getElementData(player, 'player:sid') then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś właścicielem tego pojazdu!')
    end

    if getElementData(player, 'player:mute') then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz tego zrobić będąc wyciszonym!')
    end

    if not upgrades['vopis'] then
        return exports['since-notifications']:sendNotification(player, 'error', 'Pojazd nie posiada zakupionego opisu!')
    end

    local desc = table.concat({...}, ' ')
    if not desc then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś opisu!') end

    local vehicleData = getElementData(vehicle, 'vehicle:upgrades') or {}
    desc = desc:gsub('\\n', '\n')
    vehicleData['vopis:text'] = desc
    setElementData(vehicle, 'vehicle:upgrades', vehicleData)
    exports['since-notifications']:sendNotification(player, 'info', 'Zmieniłeś opis pojazdu na '..desc)
end)