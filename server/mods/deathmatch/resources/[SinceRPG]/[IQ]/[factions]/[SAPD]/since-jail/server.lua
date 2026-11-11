addCommandHandler('jail', function (player, cmd, p, time, money, ...)
    if (not getElementData(player, 'player:faction') or getElementData(player, 'player:faction') ~= 'SAPD') then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś w służbie SAPD.')
    end

    if (not p) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /jail [ID/Nick Gracza] [czas w minutach] [Kwota] [Powód]')
    end

    local target = exports['since-core']:findPlayer(player, p)

    if (not target) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza o podanym ID/Nicku.')
    end

    if (getElementData(target, 'player:faction') and getElementData(target, 'player:faction') == 'SAPD') then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz uwięzić innego policjanta.')
    end

    local time = tonumber(time)

    if (not time) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /jail [ID/Nick Gracza] [czas w minutach] [Kwota] [Powód]')
    end

    if (time < 1) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Czas musi być większy niż 0.')
    end

    local money = tonumber(money)
    
    if (not money) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /jail [ID/Nick Gracza] [czas w minutach] [Kwota] [Powód]')
    end

    if (money < 1) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Kwota musi być większa niż 0.')
    end

    if (getElementData(target, 'player:jail')) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Gracz jest już w więzieniu.')
    end

    local x, y, z = getElementPosition(player)
    local x2, y2, z2 = getElementPosition(target)

    if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) > 10) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Gracz jest zbyt daleko.')
    end

    local reason = table.concat({...}, ' ')

    if (not reason) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /jail [ID/Nick Gracza] [czas w minutach] [Kwota] [Powód]')
    end

    exports['since-db']:query('INSERT INTO `since-jail` (uid, time, money, reason, user, date, ward) VALUES (?, ?, ?, ?, ?, current_timestamp+interval ? minute, ?)', getElementData(target, 'player:sid'), time, money, reason, getElementData(player, 'player:sid'), time, math.random(1, #jails))
    exports['since-notifications']:sendNotification(player, 'success', 'Uwięziono gracza '..getPlayerName(target)..'.')
    exports['since-notifications']:sendNotification(target, 'error', 'Zostałeś uwięziony na '..time..' minut. Powód: '..reason)

    checkJail(target)
end)

local cuboid = createColCuboid(593.58, -616.72, 13.96, 34.72, 57.68, 19.90)

addEventHandler('onColShapeHit', cuboid, function (player)
    if (player and getElementType(player) == 'player') then
        checkJail(player)
    end
end)

addEventHandler('onColShapeLeave', cuboid, function (player)
    if (player and getElementType(player) == 'player') then
        checkJail(player)
    end
end)

function checkJail(player)
    local sid = getElementData(player, 'player:sid')
    local query = exports['since-db']:query('SELECT * FROM `since-jail` WHERE uid = ? AND date > current_timestamp AND end=0', sid)

    if (#query > 0) then
        local time = query[1].time
        local money = query[1].money
        local reason = query[1].reason
        local date = query[1].date
        local ward = query[1].ward

        exports['since-notifications']:sendNotification(player, 'error', 'Zostało ci '..time..' minut w więzieniu.')
        
        local ward = jails[ward]

        setElementPosition(player, ward[1], ward[2], ward[3])

        if (time <= 1) then
            exports['since-db']:query('DELETE FROM `since-jail` WHERE uid = ?', sid)
            exports['since-notifications']:sendNotification(player, 'success', 'Odsiedziałeś swoją karę.')
            setElementPosition(player, 631.52, -571.73, 16.34)
        end
    end
    
end

function updateJailTime(player)
    local sid = getElementData(player, 'player:sid')
    local query = exports['since-db']:query('SELECT * FROM `since-jail` WHERE uid = ? AND date > current_timestamp', sid)

    if (#query > 0) then
        exports['since-db']:query('UPDATE `since-jail` SET time = time - 1 WHERE uid = ?', sid)
    end
end

function checkPlayers()
    for i,v in pairs(getElementsByType('player')) do
        checkJail(v)
        updateJailTime(v)
    end
end

checkPlayers()

setTimer(checkPlayers, 1000 * 60, 0)

local marker = createMarker(608.73, -572.77, 17.92, 'cylinder', 1.5, 125, 255, 125, 100)
setElementData(marker, 'marker:title', 'Więzienie')
setElementData(marker, 'marker:desc', 'Uwolnienie gracza')
setElementData(marker, 'marker:icon', 'skin')

function getPlayerByUID(uid)
    for i,v in pairs(getElementsByType('player')) do
        if (getElementData(v, 'player:sid') == uid) then
            return v
        end
    end

    return false
end

function getPlayerNameBySID(sid)
    local rows = exports['since-db']:query('SELECT `nick` FROM `since-users` WHERE `uid` = ?', sid)

    if (#rows > 0) then
        return rows[1].nick
    end

    return false
end

addEventHandler('onMarkerHit', marker, function (player)
    if (player and getElementType(player) == 'player') then
        local data = exports['since-db']:query('SELECT * FROM `since-jail` WHERE date > current_timestamp')

        local players = {}

        for i,v in pairs(data) do
            if (getPlayerByUID(v.uid)) then
                table.insert(players, {
                    username = getPlayerNameBySID(v.user),
                    target = getPlayerNameBySID(v.uid),
                    time = v.time,
                    money = v.money,
                    reason = v.reason,
                    id = v.id
                })
            end
        end

        if (#players > 0) then
            triggerClientEvent(player, 'since-jail:show', resourceRoot, players)
        else
            exports['since-notifications']:sendNotification(player, 'error', 'Brak graczy w więzieniu.')
        end
    end
end)

addEventHandler('onMarkerLeave', marker, function (player)
    if (player and getElementType(player) == 'player') then
        triggerClientEvent(player, 'since-jail:hide', resourceRoot)
    end
end)

function getPlayerBankMoney(player)
    local rows = exports['since-db']:query('SELECT `bankMoney` FROM `since-users` WHERE `uid` = ?', getElementData(player, 'player:sid'))

    if (#rows > 0) then
        return rows[1].bankMoney
    end

    return false
end

function takePlayerBankMoney(player, money)
    exports['since-db']:query('UPDATE `since-users` SET `bankMoney` = `bankMoney` - ? WHERE `uid` = ?', money, getElementData(player, 'player:sid'))
end

addEvent('since-jail:pay', true)
addEventHandler('since-jail:pay', resourceRoot, function (id)
    local data = exports['since-db']:query('SELECT * FROM `since-jail` WHERE id = ?', id)

    if (#data > 0) then
        local player = getPlayerByUID(data[1].uid)

        if (player) then
            local money = getPlayerBankMoney(client)

            if (money >= data[1].money) then
                takePlayerBankMoney(client, data[1].money)
                exports['since-db']:query('DELETE FROM `since-jail` WHERE id = ?', id)
                exports['since-notifications']:sendNotification(player, 'success', 'Gracz '..getPlayerName(client)..' zapłacił za wyjście z więzienia.')
                exports['since-notifications']:sendNotification(client, 'success', 'Zapłacono za wyjście z więzienia.')
                checkJail(player)

                triggerClientEvent(client, 'since-jail:hide', resourceRoot)
            else
                exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości gotówki na koncie bankowym.')
            end
        end
    end
end)