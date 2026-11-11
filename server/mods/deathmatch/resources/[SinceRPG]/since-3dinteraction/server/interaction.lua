function checkIsOwner(player, vehicle)
    if getElementData(player, 'player:sid') ~= getElementData(vehicle, 'vehicle:owner') then
        exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś właścicielem tego pojazdu.')

        return false
    end

    return true
end

addEvent("envInteraction", true);
addEventHandler("envInteraction", resourceRoot, function(element, action)
    if not element or not isElement(element) then return end

    if getElementType(element) == "vehicle" then 
        if action == "openVehicleTrunk" and checkIsOwner(client, element) then
            if getVehicleDoorOpenRatio(element, 1) == 0 then
                setVehicleDoorOpenRatio(element, 1, 1, 500)
                exports['since-notifications']:sendNotification(client, 'info', 'Bagażnik pojazdu został otwarty.')
            else
                setVehicleDoorOpenRatio(element, 1, 0, 500)
                exports['since-notifications']:sendNotification(client, 'info', 'Bagażnik pojazdu został zamknięty.')
            end
        elseif action == "openVehicleMask" and checkIsOwner(client, element) then
            if getVehicleDoorOpenRatio(element, 0) == 0 then
                setVehicleDoorOpenRatio(element, 0, 1, 500)
                exports['since-notifications']:sendNotification(client, 'info', 'Maska pojazdu została otwarta.')
            else
                setVehicleDoorOpenRatio(element, 0, 0, 500)
                exports['since-notifications']:sendNotification(client, 'info', 'Maska pojazdu została zamknięta.')
            end
        elseif action == "parkVehicle" then
            if not element then return end
            if not getElementData(element,'vehicle:id') then return end
            exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, getElementData(element,'vehicle:id'))
            exports['since-core']:saveVehicle(element)
            destroyElement(element)
            exports['since-notifications']:sendNotification(client, 'success', 'Pojazd został schowany do przechowalni.')
        elseif action == 'changeVehicleLock' and checkIsOwner(client, element) then
            if isVehicleLocked( element ) then
                setVehicleLocked( element, false )

                exports['since-notifications']:sendNotification(client, 'info', 'Pojazd został otwarty.')
            else
                setVehicleLocked( element, true )

                -- close all doors and mask and trunk
                setVehicleDoorOpenRatio(element, 0, 0, 500)
                setVehicleDoorOpenRatio(element, 1, 0, 500)

                for i=2,5 do
                    setVehicleDoorOpenRatio(element, i, 0, 500)

                    if i == 5 then
                        setVehicleDoorOpenRatio(element, 5, 0, 500)
                    end
                end

                exports['since-notifications']:sendNotification(client, 'info', 'Pojazd został zamknięty.')
            end
        elseif action == 'showCarData' then
            local vehicleInformations = {

                ownerName = nil,
                ownerUID = nil,
                vehicleMileage = nil,
                vehicleID = nil,
                vehiclePlate = nil,
                vehicleTunings = nil,

            }

            local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE `id` = ? LIMIT 1', getElementData(element, 'vehicle:id'))

            if #result > 0 then
                local ownerResult = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ? LIMIT 1', result[1].owner)
                local vehicleData = getElementData(element, 'vehicle:data') or {}
                local vehicleFuel = getElementData(element, 'vehicle:fuel') or {}

                vehicleInformations.ownerName = ownerResult[1].nick
                vehicleInformations.ownerUID = ownerResult[1].uid
                vehicleInformations.vehicleMileage = string.format("%.2f", vehicleData.mileage)
                vehicleInformations.vehicleID = getElementData(element, 'vehicle:id')
                vehicleInformations.vehiclePlate = getVehiclePlateText(element)

                local przegladText = 'Przegląd ważny do '..result[1].przeglad..''

                exports['since-notifications']:sendNotification(client, 'info', 'Informacje o pojeździe ('..exports['since-vehiclenames']:getVehicleName(result[1].model)..')\n \n'..
                    'Właściciel: '..vehicleInformations.ownerName..' (UID: '..vehicleInformations.ownerUID..')\n'..
                    'Przebieg: '..vehicleInformations.vehicleMileage..' km\n'..
                    'ID: '..vehicleInformations.vehicleID..'\n'..
                    'Tablica rejestracyjna: '..vehicleInformations.vehiclePlate..'\n'..
                    przegladText
                )
            end
        elseif action == 'showCarInfo' then
            local vehicleInformations = {

                ownerName = nil,
                ownerUID = nil,
                vehicleMileage = nil,
                vehicleID = nil,
                vehiclePlate = nil,
                vehicleTunings = nil,

            }

            local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE `id` = ? LIMIT 1', getElementData(element, 'vehicle:id'))

            if #result > 0 then
                local ownerResult = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ? LIMIT 1', result[1].owner)
                local vehicleData = getElementData(element, 'vehicle:data') or {}
                local vehicleFuel = getElementData(element, 'vehicle:fuel') or {}

                vehicleInformations.ownerName = ownerResult[1].nick
                vehicleInformations.ownerUID = ownerResult[1].uid
                vehicleInformations.vehicleMileage = string.format("%.2f", vehicleData.mileage)
                vehicleInformations.vehicleID = getElementData(element, 'vehicle:id')
                vehicleInformations.vehiclePlate = getVehiclePlateText(element)

                exports['since-notifications']:sendNotification(client, 'info', 'Informacje o pojeździe ('..exports['since-vehiclenames']:getVehicleName(result[1].model)..')\n \n'..
                    'Właściciel: '..vehicleInformations.ownerName..' (UID: '..vehicleInformations.ownerUID..')\n'..
                    'Przebieg: '..vehicleInformations.vehicleMileage..' km\n'..
                    'ID: '..vehicleInformations.vehicleID..'\n'..
                    'Tablica rejestracyjna: '..vehicleInformations.vehiclePlate
                )
            end
        end
    elseif getElementType(element) == 'player' then
        if not getElementData(element, 'player:sid') then 
            return exports['since-notifications']:sendNotification(client, 'error', 'Gracz nie jest zalogowany.')
        end

        if action == 'addFriend' then
            local friendName = getPlayerName(element)
            exports['since-dashboard']:sendFriendRequest(client, friendName)
        elseif action == 'sendTrade' then
            local targetName = getPlayerName(element)
            exports['since-inventory']:sendTradeOffer(client, targetName)
        elseif action == 'showDocuments' then
            local licenses = getElementData(client, 'player:licenses') or {}
            local licensetbl = {}

            for k,v in pairs(licenses) do
                table.insert(licensetbl, string.upper(k))
            end

            local licensesStr = table.concat(licensetbl, ', ')

            local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ? LIMIT 1', getElementData(client, 'player:sid'))
            
            outputChatBox(' ', element, 255, 255, 255)
            outputChatBox(' ', element, 255, 255, 255)
            outputChatBox('|#ffffff Gracz #7dff7d'..getPlayerName(client)..'#ffffff okazuje Ci swoje dokumenty.', element, 125, 255, 125, true)
            outputChatBox(' ', element, 125, 255, 125, true)
            outputChatBox('|#ffffff Posiadane licencje: #7dff7d'..licensesStr, element, 125, 255, 125, true)
            outputChatBox('|#ffffff Login: #7dff7d'..result[1].login, element, 125, 255, 125, true)
            outputChatBox('|#ffffff UID: #7dff7d'..getElementData(client, 'player:sid'), element, 125, 255, 125, true)
            outputChatBox(' ', element, 125, 255, 125, true)
            outputChatBox(' ', element, 255, 255, 255)
        end
    elseif getElementType(element) == 'object' then
        if action == 'atmRobbery' then
            exports['since-atmRobbery']:startRobbery(client, element)
        end
    end
end)