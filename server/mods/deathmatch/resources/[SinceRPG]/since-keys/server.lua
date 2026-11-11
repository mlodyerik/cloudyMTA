function getVehicleKeys(veh)
    local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}

    if vehicleUpgrades['keys'] then
        return tonumber(vehicleUpgrades['keys'])
    else
        return 1
    end
end

function getKeysNumber(veh)
    local keys = getElementData(veh, 'vehicle:rent') or {}
    local value = 0

    for i, v in ipairs(keys) do
        value = value + 1
    end

    return value
end

function manageKeys(plr, cmd)
    local veh = getPedOccupiedVehicle(plr)
    local playerSID = getElementData(plr, 'player:sid')

    if veh and playerSID then
        if getElementData(veh, 'vehicle:id') and playerSID == getElementData(veh, 'vehicle:owner') then
            local keys = getElementData(veh, 'vehicle:rent') or {}
            local numberofkeys = getVehicleKeys(veh)
            local keyTable = {}

            if getKeysNumber(veh) > numberofkeys then
                setElementData(veh, 'vehicle:rent', {})
                keys = {}
            end

            for i, v in ipairs(keys) do
                local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', tonumber(v))

                table.insert(keyTable, {uid = tonumber(v), name = result[1].nick})
            end

            triggerClientEvent(plr, 'getKeysInfo', resourceRoot, keyTable)
        end
    end
end
addCommandHandler('klucze', manageKeys)
addCommandHandler('vdodaj', manageKeys)
addCommandHandler('share', manageKeys)

function refreshKeys(plr, veh)
    local keys = getElementData(veh, 'vehicle:rent') or {}
    local numberofkeys = getVehicleKeys(veh)
    local keyTable = {}

    if #keys > numberofkeys then
        setElementData(veh, 'vehicle:rent', {})
    end

    for i, v in ipairs(keys) do
        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', tonumber(v))

        table.insert(keyTable, {uid = tonumber(v), name = result[1].nick})
    end

    triggerClientEvent(plr, 'getKeysInfo', resourceRoot, keyTable)
end

function findPlayerByUID(uid)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') == uid then
            return v
        end
    end
    return false
end 

addEvent('manageKeys', true)
addEventHandler('manageKeys', resourceRoot, function(kType, ...)
    local veh = getPedOccupiedVehicle(client)  -- Zmieniono 'plr' na 'client', ponieważ funkcja jest wywoływana po stronie serwera
    local playerSID = getElementData(client, 'player:sid')

    if veh and playerSID then
        if getElementData(veh, 'vehicle:id') and playerSID == getElementData(veh, 'vehicle:owner') then
            local args = {...}
            local args = unpack(args)
            local numberofkeys = getVehicleKeys(veh)

            if kType == 'delete' then
                local uid = tonumber(args[1])  -- Pobranie UID do usunięcia
                local name = args[2]
                local keys = getElementData(veh, 'vehicle:rent') or {}  -- Sprawdzenie aktualnej listy kluczy

                for i, v in ipairs(keys) do
                    if tonumber(v) == uid then  -- Porównanie UID
                        table.remove(keys, i)  -- Usunięcie użytkownika z listy
                        exports['since-notifications']:sendNotification(client, 'info', name..' (UID: '..uid..') nie posiada juz kluczy do tego pojazdu.')
                        break
                    end
                end

                setElementData(veh, 'vehicle:rent', keys)  -- Zapisanie zaktualizowanej listy
                refreshKeys(client, veh)
            elseif kType == 'add' then
                local uid = tonumber(args[1])
                local keys = getElementData(veh, 'vehicle:rent') or {}

                if uid == playerSID then
                    return exports['since-notifications']:sendNotification(client, 'error', 'Możesz udostępnić swojego pojazdu sobie.')
                end

                if getKeysNumber(veh) + 1 > numberofkeys then
                    return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz tylu kluczy! (Klucze: '..numberofkeys..')')
                end

                for i, v in ipairs(keys) do
                    if tonumber(v) == tonumber(uid) then  -- Porównanie UID
                        return exports['since-notifications']:sendNotification(client, 'error', 'Ta osoba posiada już klucze do tego pojazdu.')
                    end
                end

                table.insert(keys, tonumber(uid))

                setElementData(veh, 'vehicle:rent', keys)

                local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', tonumber(uid))
                exports['since-notifications']:sendNotification(client, 'info', result[1].nick..' (UID: '..uid..') otrzymał klucze do tego pojazdu.')

                local target = findPlayerByUID(uid)

                if target then
                    exports['since-notifications']:sendNotification(target, 'info', getPlayerName(client)..' udostępnia Ci klucze do pojazdu ID '..getElementData(veh, 'vehicle:id'))
                end

                refreshKeys(client, veh)
            end
        end
    end
end)