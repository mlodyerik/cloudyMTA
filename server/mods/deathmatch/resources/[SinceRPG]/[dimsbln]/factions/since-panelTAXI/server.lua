local factionReports = {}

function findPlayerInTable(uid)
    for i, v in ipairs(factionReports) do
        if v[1] == uid then
            return v[2]
        end
    end
end

function deleteFromTable(uid)
    for i, v in ipairs(factionReports) do
        if v[1] == uid then
            table.remove(factionReports, i)
            return true
        end
    end
end

function getTaxiWorker(uid)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:taxiJob') == uid then
            return v
        end
    end
end

function setTableVariable(uid, key, value)
    for i, v in ipairs(factionReports) do
        if v[1] == uid then
            v[2][key] = value
            return true
        end
    end
end

addEventHandler('onPlayerQuit', root, function()
    local UID = getElementData(source, 'player:sid')
    if UID then
        deleteFromTable(UID)
        outputChatBox('✗#ffffff Zgłoszenie do TAXI zostało anulowane.', source, 255, 55, 55, true)

        local worker = getTaxiWorker(UID)

        if worker then
            setElementData(worker, 'player:taxiJob', false)
            outputChatBox('✗#ffffff Zgłoszenie gracza #54acff'..getPlayerName(source)..'#ffffff zostało anulowane.', worker, 255, 55, 55, true)
            triggerClientEvent(worker, 'onTaxiRequest', resourceRoot, 'cancel')
        end
    end
end)

addEventHandler('onPlayerWasted', root, function()
    local UID = getElementData(source, 'player:sid')
    if UID then
        deleteFromTable(UID)
        outputChatBox('✗#ffffff Zgłoszenie do TAXI zostało anulowane.', source, 255, 55, 55, true)

        local worker = getTaxiWorker(UID)

        if worker then
            setElementData(worker, 'player:taxiJob', false)
            outputChatBox('✗#ffffff Zgłoszenie gracza #54acff'..getPlayerName(source)..'#ffffff zostało anulowane.', worker, 255, 55, 55, true)
            triggerClientEvent(worker, 'onTaxiRequest', resourceRoot, 'cancel')
        end
    end
end)

function messageForAllDrivers(message)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:faction') == 'TSA' then
            outputChatBox(message, v, 255, 175, 25, true)
        end
    end
end

function getDriversOnDuty()
    local count = 0
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:faction') == 'TSA' then
            count = count + 1
        end
    end

    return count
end

addCommandHandler('taxi', function(plr, cmd)
    local UID = getElementData(plr, 'player:sid')
    if UID then
        if getPedOccupiedVehicle(plr) then
            return outputChatBox('✗#ffffff Nie możesz wysłać zgłoszenia będąc w pojeździe.', plr, 255, 55, 55, true)
        end

        if findPlayerInTable(UID) then
            return outputChatBox('✗#ffffff Wysłałeś już zgłoszenie do TAXI.', plr, 255, 55, 55, true)
        end

        if getDriversOnDuty() == 0 then
            return outputChatBox('✗#ffffff W tej chwili nie ma dostępnych kierowców TAXI.', plr, 255, 55, 55, true)
        end

        if getElementData(plr, 'player:faction') then
            return
        end

        local x, y, z = getElementPosition(plr)
        local playerData = {

            uid = UID,
            name = getPlayerName(plr),
            pos = {x, y, z},
            getBy = false,
            
        }

        setElementData(plr, 'player:waitingForTaxi', true)

        table.insert(factionReports, {UID, playerData})
        outputChatBox('✓#ffffff Wysłano zgłoszenie do TAXI, aby anulować zgłoszenie kliknij #bababaEnter', plr, 55, 255, 55, true)

        local x, y, z = getElementPosition(plr)
        local zoneName = getZoneName(x, y, z)..', '..getZoneName(x, y, z, true)
        messageForAllDrivers('⚠#ffffff Gracz #54acff'..getPlayerName(plr)..'#ffffff zamawia taksówkę. Lokalizacja: #b8b8b8'..zoneName)
    end
end)

function getPlayerFromUID(uid)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') == uid then
            return v
        end
    end
end

addEvent('onTaxiRequest', true)
addEventHandler('onTaxiRequest', resourceRoot, function(type, ...)
    if type == 'cancel' then
        local UID = getElementData(client, 'player:sid')
        if UID then
            if deleteFromTable(UID) then
                setElementData(client, 'player:waitingForTaxi', false)
                outputChatBox('✗#ffffff Anulowano zgłoszenie do TAXI.', client, 255, 55, 55, true)

                local worker = getTaxiWorker(UID)

                if worker then
                    setElementData(worker, 'player:taxiJob', false)
                    outputChatBox('✗#ffffff Zgłoszenie gracza #54acff'..getPlayerName(client)..'#ffffff zostało anulowane.', worker, 255, 55, 55, true)

                    triggerClientEvent(worker, 'onTaxiRequest', resourceRoot, 'cancel')
                end
            end
        end
    elseif type == 'get' then
        for i, v in ipairs(factionReports) do
            triggerClientEvent(client, 'onTaxiRequest', resourceRoot, 'add', v[2])
        end
    elseif type == 'startCourse' then
        local args = {...}

        if not findPlayerInTable(args[2]) then
            return outputChatBox('✗#ffffff Te zgłoszenie nie istnieje lub zostało przyjęte przez innego kierowce.', client, 255, 55, 55, true)
        end

        local driver = args[1]
        local passager = getPlayerFromUID(args[2])

        if not driver or not passager then return end

        if factionReports[1][2].getBy then
            return outputChatBox('✗#ffffff Te zgłoszenie zostało przyjęte przez innego kierowce.', driver, 255, 55, 55, true)
        end

        setTableVariable(args[2], 'getBy', driver)

        setElementData(driver, 'player:taxiJob', args[2])

        triggerClientEvent(driver, 'onTaxiRequest', resourceRoot, 'getCourse')

        outputChatBox('✓#ffffff Kierowca #54acff'..getPlayerName(driver)..'#ffffff przyjmuje twoje zgłoszenie, za chwilę się zjawi.', passager, 55, 255, 55, true)
        outputChatBox('✓#ffffff Przyjęto zgłoszenie gracza #54acff'..getPlayerName(passager)..'#ffffff.', driver, 55, 255, 55, true)
    elseif type == 'onPosition' then
        local args = {...}
        deleteFromTable(args[1])

        local passager = getPlayerFromUID(args[1])
        setPedAnimation(passager, false)
        setElementData(passager, 'player:waitingForTaxi', false)
    end
end)