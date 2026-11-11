function getExchangeData()
    local result = exports['since-db']:query('SELECT * FROM `since-exchange`')
    local tbl = {}

    for i, data in ipairs(result) do
        local playerName = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ?', tonumber(data.player))

        table.insert(tbl, {
            id = data.id,
            player = playerName[1].nick,
            value = data.value,
            price = data.price,
            uid = data.player
        })
    end

    return tbl
end

addEvent('returnUserExchangeData', true)
addEventHandler('returnUserExchangeData', resourceRoot, function()
    local result = exports['since-db']:query('SELECT * FROM `since-exchange`')
    local tbl = {}

    for i, data in ipairs(result) do
        local playerName = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ?', tonumber(data.player))

        table.insert(tbl, {
            id = data.id,
            player = playerName[1].nick,
            value = data.value,
            price = data.price,
            uid = data.player
        })
    end

    triggerClientEvent(client, 'returnUserExchangeData', resourceRoot, tbl)
end)

function findPlayerByUID(uid)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') == uid then
            return v
        end
    end
end

addEvent('onPlayerExchangeUse', true)
addEventHandler('onPlayerExchangeUse', resourceRoot, function(type, ...)
    if type == 'delete' then    
        local args = {...}
        local id = args[1]

        local result = exports['since-db']:query('SELECT * FROM `since-exchange` WHERE `id` = ?', id)

        if #result > 0 then
            if tonumber(result[1].player) == getElementData(client, 'player:sid') then
                exports['since-db']:query('UPDATE `since-users` SET `wPLN` = `wPLN` + ? WHERE `uid` = ?', result[1].value, getElementData(client, 'player:sid'))
                exports['since-db']:query('DELETE FROM `since-exchange` WHERE `id` = ?', id)
                exports['since-notifications']:sendNotification(client, 'success', 'Usunięto ofertę wPLN.')
            else
                exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz usunąć oferty, która nie należy do Ciebie.')
            end
        else
            exports['since-notifications']:sendNotification(client, 'error', 'Nie znaleziono oferty o podanym ID.')
        end

        local data = getExchangeData()
        triggerClientEvent(client, 'returnUserExchangeData', resourceRoot, data)
    elseif type == 'add' then
        local args = {...}
        local value, price = args[1], args[2]

        local result = exports['since-db']:query('SELECT * FROM `since-exchange` WHERE `player` = ?', getElementData(client, 'player:sid'))

        if #result > 0 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz już aktywną ofertę wPLN.')
        end

        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ?', getElementData(client, 'player:sid'))

        if #result == 0 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie znaleziono Twojego konta w bazie danych.')
        end

        if value < 0 then
            return
        end

        if result[1].wPLN < value then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości wPLN.')
        end

        exports['since-db']:query('INSERT INTO `since-exchange` SET `player` = ?, `value` = ?, `price` = ?', getElementData(client, 'player:sid'), value, price)
        exports['since-db']:query('UPDATE `since-users` SET `wPLN` = `wPLN` - ? WHERE `uid` = ?', value, getElementData(client, 'player:sid'))
        exports['since-notifications']:sendNotification(client, 'success', 'Dodano ofertę wPLN.')

        local data = getExchangeData()
        triggerClientEvent(client, 'returnUserExchangeData', resourceRoot, data)
    elseif type == 'buy' then
        local args = {...}
        local id, player, value, price, sellerUID = args[1], args[2], args[3], args[4], args[5]

        local result = exports['since-db']:query('SELECT * FROM `since-exchange` WHERE `id` = ?', id)
        if #result > 0 then
            if result[1].value then
                local playerMoney = getPlayerMoney(client)

                if playerMoney < result[1].price then
                    return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości gotówki przy sobie.')
                end

                if tonumber(sellerUID) == getElementData(client, 'player:sid') then
                    return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz kupić od siebie.')
                end

                takePlayerMoney(client, result[1].price)

                local seller = findPlayerByUID(sellerUID)
                exports['since-db']:query('UPDATE `since-users` SET `bankMoney` = `bankMoney` + ? WHERE `uid` = ?', result[1].price, sellerUID)
                exports['since-db']:query('UPDATE `since-users` SET `wPLN` = `wPLN` + ? WHERE `uid` = ?', result[1].value, getElementData(client, 'player:sid'))

                exports['since-notifications']:sendNotification(client, 'success', 'Kupiłeś '..result[1].value..' wPLN za '..result[1].price..' $.')

                if seller then
                    exports['since-notifications']:sendNotification(seller, 'success', 'Gracz '..getPlayerName(client)..' kupił od Ciebie '..result[1].value..' wPLN za '..result[1].price..' $.')
                end

                local text = 'Gracz **'..getPlayerName(client)..'** `(UID: '..getElementData(client, 'player:sid')..')` kupił od gracza **'..player..'** `(UID: '..sellerUID..')` **'..result[1].value..' wPLN** za **'..result[1].price..' $**.'
                exports['since-logs']:sendDiscordLog('gielda-wpln', 'Kupno wPLN', text)

                exports['since-db']:query('DELETE FROM `since-exchange` WHERE `id` = ?', id)

                local data = getExchangeData()
                triggerClientEvent(client, 'returnUserExchangeData', resourceRoot, data)
            else
                local data = getExchangeData()
                triggerClientEvent(client, 'returnUserExchangeData', resourceRoot, data)

                return exports['since-notifications']:sendNotification(client, 'error', 'Ta oferta nie posiada już takiej ilości wPLN.')
            end
        else
            local data = getExchangeData()
            triggerClientEvent(client, 'returnUserExchangeData', resourceRoot, data)

            return exports['since-notifications']:sendNotification(client, 'error', 'Ta oferta jest już niedostępna.')
        end
    end
end)