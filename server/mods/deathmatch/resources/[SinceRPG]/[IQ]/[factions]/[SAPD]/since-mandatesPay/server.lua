local marker = createMarker(1471.47, -1779.03, 18.73 - 1, 'cylinder', 1.5, 125, 255, 125, 100)
setElementData(marker, 'marker:title', 'Mandaty')
setElementData(marker, 'marker:desc', 'Płacenie mandatów')
setElementData(marker, 'marker:icon', 'skin')

function getPlayerNameByUID(uid)
    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)

    if (#rows == 0) then
        return 'Nieznany'
    end

    return rows[1].login
end

addEventHandler('onMarkerHit', marker, function(el, md)
    if (getElementType(el) == 'player' and md) then
        -- triggerClientEvent(el, 'since-mandates:show', el)
        local rows = exports['since-db']:query('SELECT * FROM `since-mandates` WHERE receiverUID = ? and payed = 0', getElementData(el, 'player:sid'))

        if (#rows == 0) then
            return exports['since-notifications']:sendNotification(el, 'error', 'Nie posiadasz żadnych mandatów.')
        end

        local data = {}

        for i,v in pairs(rows) do
            v.sender = getPlayerNameByUID(v.uid)

            table.insert(data, v)
        end

        triggerClientEvent(el, 'since-mandates:show', el, data)
    end
end)

function updateData(player)
    local rows = exports['since-db']:query('SELECT * FROM `since-mandates` WHERE receiverUID = ? and payed = 0', getElementData(player, 'player:sid'))

    if (#rows == 0) then
        return triggerClientEvent(player, 'since-mandates:hide', player)
    end

    local data = {}

    for i,v in pairs(rows) do
        v.sender = getPlayerNameByUID(v.uid)

        table.insert(data, v)
    end

    triggerClientEvent(player, 'since-mandates:update', resourceRoot, data)
end

addEventHandler('onMarkerLeave', marker, function(el, md)
    if (getElementType(el) == 'player' and md) then
        triggerClientEvent(el, 'since-mandates:hide', el)
    end
end)

function getPlayerBankMoney(player)
    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', getElementData(player, 'player:sid'))

    if (#rows == 0) then
        return 0
    end

    return rows[1].bankMoney
end

function takePlayerBankMoney(player, amount)
    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', getElementData(player, 'player:sid'))

    if (#rows == 0) then
        return false
    end

    if (rows[1].bankMoney < amount) then
        return false
    end

    exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney - ? WHERE uid = ?', amount, getElementData(player, 'player:sid'))

    return true
end

addEvent('since-mandates:pay', true)
addEventHandler('since-mandates:pay', root, function(id)
    local player = client

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    local rows = exports['since-db']:query('SELECT * FROM `since-mandates` WHERE id = ?', id)

    if (#rows == 0) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Mandat nie istnieje.')
    end

    local row = rows[1]

    if (getPlayerBankMoney(player) < row.price) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz wystarczającej ilości gotówki na koncie bankowym.')
    end

    if (takePlayerBankMoney(player, row.price)) then
        exports['since-db']:query('UPDATE `since-mandates` SET payed = 1 WHERE id = ?', id)

        exports['since-notifications']:sendNotification(player, 'success', 'Mandat został opłacony.')

        updateData(player)
    else
        exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz wystarczającej ilości gotówki na koncie bankowym.')
    end
end)