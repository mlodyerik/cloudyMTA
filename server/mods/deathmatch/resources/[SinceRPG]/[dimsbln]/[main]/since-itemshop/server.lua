local verify = {
    
}

function findPlayerByUID(playerUID)
    local player = false

    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') == playerUID then
            player = v
            break
        end
    end

    return player
end

local bonus = {

    {min = 1000, bonus = 100},
    {min = 2000, bonus = 400},
    {min = 5000, bonus = 1000},
    {min = 10000, bonus = 2500},

}

function getBonus(wPLN)
    local bonusData = false

    for i, v in ipairs(bonus) do
        if wPLN >= v.min then
            bonusData = v.bonus
        end
    end

    return bonusData
end

local bonuses = {

    ['xmass'] = function(player)
        local workVouchers = {'voucher-magazynier', 'voucher-kosiarki', 'voucher-grzybiarz', 'voucher-smieciarki', 'voucher-logistyka', 'voucher-dostawca', 'voucher-maszynista', 'voucher-etransporter', 'voucher-import', 'voucher-spedycjaLotnicza'}
        local tuningVouchers = {'mk4', 'mk5', 'mk6', 'stereo', 'exhaust', 'licznikrgb', 'rgbsmoke', 'neonrgb', 'vopisrgb', 'vopis', 'cameleon', 'jumpmode', 'hovermode', 'deluxomode', 'chiptuning'}
        local recive = {}

        for i = 1, 6 do
            local randomWorkVoucher = workVouchers[math.random(1, #workVouchers)]

            exports['since-inventory']:addPlayerItem(player, randomWorkVoucher, 1)
            
            local itemName = exports['since-inventory']:getItemInfo(randomWorkVoucher).name

            if itemName then
                table.insert(recive, itemName)
            end
        end

        for i = 1, 4 do
            local randomTuningVoucher = tuningVouchers[math.random(1, #tuningVouchers)]

            exports['since-inventory']:addPlayerItem(player, randomTuningVoucher, 1)
            
            local itemName = exports['since-inventory']:getItemInfo(randomTuningVoucher).name

            if itemName then
                table.insert(recive, itemName)
            end
        end

        outputChatBox(' ', player)
        outputChatBox(' ', player)
        outputChatBox('✉ #ffffffOtrzymałeś bonusowe przedmioty (Sprawdź swój ekwipunek):', player, 125, 185, 255, true)
        outputChatBox(' ', player)

        for i, v in ipairs(recive) do
            outputChatBox('➥ #ffffff'..v, player, 125, 185, 255, true)
        end

        outputChatBox(' ', player)
        outputChatBox(' ', player)
    end,

}

function giveBonus(bType)
    if not bType then 
        return print('[ITEMSHOP]: Błąd w funkcji giveBonus. Brak argumentów.')
    end

    if not bonuses[bType] then 
        return print('[ITEMSHOP]: Błąd w funkcji giveBonus. Brak funkcji dla bonusu '..bType..'.')
    end

    bonuses[bType]()
end

function returnShopData(playerUID, wPLN)
    if not playerUID or not wPLN then 
        return print('[ITEMSHOP]: Błąd w funkcji returnShopData. Brak argumentów.')
    end

    local player = findPlayerByUID(playerUID)
    if player then
        outputChatBox(' ', player)
        outputChatBox(' ', player)

        if wPLN >= 1000 then
            local theBonus = getBonus(wPLN)
            outputChatBox("✓ #ffffffZakupiono #2E756F"..wPLN.." wPLN#ffffff #fca503(+ Bonusowe "..theBonus.." wPLN)#ffffff. Dziękujemy za zakupy!", player, 0, 255, 0, true)
            exports['since-db']:query('UPDATE `since-users` SET wPLN = wPLN + ? WHERE uid = ?', theBonus, playerUID)

            print('[ITEMSHOP]: Gracz UID ' .. playerUID .. ' zakupił ' .. wPLN .. ' wPLN. Bonus: '..theBonus..' wPLN.')
            exports['since-logs']:sendDiscordLog('shop', 'Sklep', 'Gracz UID ' .. playerUID .. ' zakupił ' .. wPLN .. ' wPLN. Bonus: '..theBonus..' wPLN.')

            giveBonus('xmass')
        else
            outputChatBox("✓ #ffffffZakupiono #2E756F"..wPLN.." wPLN#ffffff. Dziękujemy za zakupy!", player, 0, 255, 0, true)
            exports['since-logs']:sendDiscordLog('shop', 'Sklep', 'Gracz UID ' .. playerUID .. ' zakupił ' .. wPLN .. ' wPLN.')
            print('[ITEMSHOP]: Gracz UID ' .. playerUID .. ' zakupił ' .. wPLN .. ' wPLN.')
        end
    
        outputChatBox("✉ #ffffffItemshop dostępny jest pod klawiszem #2E756FF7", player, 125, 125, 255, true)
        outputChatBox(' ', player)
        outputChatBox(' ', player)
    end


    return true
end

function checkPromotion(plr, cmd)
    if not getElementData(plr, 'player:sid') then
        return
    end

    local result = exports['since-db']:query('SELECT * FROM since_promocodes')

    if #result == 0 then
        return outputChatBox('✘ #ffffffBrak aktywnych promocji.', plr, 255, 25, 25, true)
    end

    outputChatBox(' ', plr, 125, 255, 125, true)
    outputChatBox('Aktywne promocje: ', plr, 255, 255, 255, true)
    
    for i, v in ipairs(result) do
        outputChatBox('➥ #ffffffZ kodem #2E756F'..v.code..'#ffffff zyskujesz #2E756F-'..v.promotion..'%#ffffff na zakup wPLN', plr, 125 * 0.75, 185 * 0.75, 255 * 0.75, true)
    end
    
    outputChatBox(' ', plr, 125, 255, 125, true)
    outputChatBox('✉ #ffffffKod możesz wykorzystać w naszym sklepie: #2E756Fhttps://sklep.since-mta.pl/', plr, 125, 185, 255, true)
    outputChatBox(' ', plr, 125, 255, 125, true)
end
addCommandHandler('promocje', checkPromotion)
addCommandHandler('znizki', checkPromotion)
addCommandHandler('kody', checkPromotion)


function givePlayerVehicle(plr, data)
    local playerSID = getElementData(plr, 'player:sid')

    if not playerSID then
        return
    end

    local clr = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
    local hclr = {255, 255, 255}
    local wheelTuning = {

        vinylRim = 0,
        vinylWounds = 0,
        wheelTilt = 0,
        innerSize = 0.8,
        wheelResize = 1,

    }

    local vehData = {

        driver = 'Brak',
        mileage = data.mileage,
        engine = data.engine,


    }

    local fuel = {

        count = data.tank,
        tank = data.tank,

    }

    local variant = data.variant or {0,0}

    local upgrades = {}

    if data.electric then
        upgrades['electric'] = true
    end

    local q = exports['since-db']:query('INSERT INTO `since-vehicles` (`model`, `fuel`, `upgrades`, `data`, `color`, `headlight`, `wheelTuning`, `owner`, `state`, `variant`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)', data.model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(vehData), serpent.dump(clr), serpent.dump(hclr), serpent.dump(wheelTuning), playerSID, serpent.dump(variant))
    
    if q then
        exports['since-notifications']:sendNotification(plr, 'success', 'Zakupiłeś pojazd #47afff'..exports['since-vehiclenames']:getVehicleName(data.model)..'#ffffff. Pojazd możesz odebrać w przechowalni.')
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Zakup zakończony niepowodzeniem, zgłoś błąd do administracji')
    end
end

function getVehicleFromUID(vehicleID)
    local vehicle = false
    
    for i, v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == vehicleID then
            vehicle = v
            break
        end
    end

    return vehicle
end

function loadWPLN(player)
    local playerUID = getElementData(player, 'player:sid')

    if not playerUID then 
        return print('[ITEMSHOP]: Błąd w funkcji itemshop:loadWPLN. Brak UID gracza.')
    end

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', playerUID)

    if #result == 0 then 
        return print('[ITEMSHOP]: Błąd w funkcji itemshop:loadWPLN. Brak gracza o UID ' .. playerUID .. '.')
    end

    triggerClientEvent(player, 'itemshop:loadWPLN', resourceRoot, result[1].wPLN)
end

addEvent('itemshop:loadWPLN', true)
addEventHandler('itemshop:loadWPLN', resourceRoot, function()
    loadWPLN(client)
end)

local apiKey = 'ZJpcdVsUEbUjUNeynwdPAgJUm'

addEvent('onClientTryToBuyPremium', true)
addEventHandler('onClientTryToBuyPremium', resourceRoot, function(data, code)
    local player = client
    if (not isElement(player) or not data or not getElementData(player, 'player:sid')) then return end

    fetchRemote('https://admin.serverproject.eu/api/smsapi.php?key='..apiKey..'&amount='..data.count..'&code='..code..'&desc=wPLN', 'shopBuy', 1, 4000, function (responseData, errno, player)
        if (errno ~= 0) then
            exports['since-notifications']:sendNotification(player, 'error', 'Wystąpił błąd podczas zakupu usługi.')
            return
        end

        if (string.find(responseData, '"error":"bad_code"')) then
            exports['since-notifications']:sendNotification(player, 'error', 'Wprowadzony kod jest nieprawidłowy lub został wykorzystany.')
            return
        end

        if (string.find(responseData, '"status":"fail"')) then
            exports['since-notifications']:sendNotification(player, 'error', 'Wystąpił nieznany błąd podczas zakupu usługi.')
            return
        end

        local count = data.wpln
        local playerUID = getElementData(player, 'player:sid')

        exports['since-db']:query('UPDATE `since-users` SET wPLN = wPLN + ? WHERE uid = ?', count, playerUID)

        print('[ITEMSHOP - SMS]: Gracz UID ' .. playerUID .. ' zakupił ' .. count .. ' wPLN.')
        exports['since-logs']:sendDiscordLog('shop', 'Sklep', '[SMS]: Gracz UID ' .. playerUID .. ' zakupił ' .. count .. ' wPLN.')

        outputChatBox(' ', player)
        outputChatBox(' ', player)
        outputChatBox("✓ #ffffffZakupiono #2E756F"..count.." wPLN#ffffff. Dziękujemy za zakupy!", player, 0, 255, 0, true)
        outputChatBox(' ', player)
        outputChatBox(' ', player)
    end, "", false, client)
end)

addEvent('itemshop:buy', true)
addEventHandler('itemshop:buy', resourceRoot, function(buyType, ...)
    if buyType == 'vehicle' then 
        local args = {...}
        
        local id = args[1]

        if not id then 
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak argumentów.')
        end

        local vehicleData = items[1][id]

        if not vehicleData then 
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak danych dla pojazdu o ID ' .. id .. '.')
        end
        
        local playerUID = getElementData(client, 'player:sid')

        if not playerUID then 
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak UID gracza.')
        end

        local playerWPLN = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', playerUID)[1].wPLN

        if playerWPLN < vehicleData.price then 
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości wPLN.')
        end

        exports['since-db']:query('UPDATE `since-users` SET wPLN = ? WHERE uid = ?', playerWPLN - vehicleData.price, playerUID)

        givePlayerVehicle(client, {model = vehicleData.model, mileage = 0, engine = 1.8, tank = 100, electric = vehicleData.electric})

        exports['since-logs']:sendDiscordLog('shop-panel', 'Sklep', 'Gracz UID ' .. playerUID .. ' zakupił pojazd '..vehicleData.name..' za '..vehicleData.price..' wPLN.')

        loadWPLN(client)
    elseif buyType == 'premium' then
        local args = {...}

        if not args[1] then 
            exports['since-notifications']:sendNotification(client, 'error', 'Wystąpił błąd. Spróbuj ponownie.')
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak argumentów.')
        end

        local playerUID = getElementData(client, 'player:sid')

        if not playerUID then 
            exports['since-notifications']:sendNotification(client, 'error', 'Wystąpił błąd. Spróbuj ponownie.')
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak UID gracza.')
        end

        -- local wPLNcost, premiumPoints = args[1], args[2]

        local value = args[1]

        local wPLNcost = value * 20
        local premiumPoints = value * 100

        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', playerUID)

        if #result == 0 then 
            exports['since-notifications']:sendNotification(client, 'error', 'Wystąpił błąd. Spróbuj ponownie.')
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak gracza o UID ' .. playerUID .. '.')
        end

        local playerWPLN = result[1].wPLN

        if playerWPLN < wPLNcost then 
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości wPLN.')
        end

        exports['since-db']:query('UPDATE `since-users` SET wPLN = ? WHERE uid = ?', playerWPLN - wPLNcost, playerUID)

        local actualPoints = getElementData(client, 'player:pp') or 0
        setElementData(client, 'player:pp', actualPoints + premiumPoints)

        exports['since-logs']:sendDiscordLog('shop-panel', 'Sklep', 'Gracz UID ' .. playerUID .. ' zakupił '..premiumPoints..' punktów premium za '..wPLNcost..' wPLN.')
        exports['since-notifications']:sendNotification(client, 'success', 'Wymieniasz '..wPLNcost..' wPLN na '..premiumPoints..' Punktów premium.')

        loadWPLN(client)
    elseif buyType == 'upgrades' then
        local args = {...}

        if not args[1] then 
            exports['since-notifications']:sendNotification(client, 'error', 'Wystąpił błąd. Spróbuj ponownie.')
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak argumentów.')
        end

        local playerUID = getElementData(client, 'player:sid')

        if not playerUID then 
            exports['since-notifications']:sendNotification(client, 'error', 'Wystąpił błąd. Spróbuj ponownie.')
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak UID gracza.')
        end

        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', playerUID)

        if #result == 0 then 
            exports['since-notifications']:sendNotification(client, 'error', 'Wystąpił błąd. Spróbuj ponownie.')
            return print('[ITEMSHOP]: Błąd w funkcji itemshop:buy. Brak gracza o UID ' .. playerUID .. '.')
        end

        local buyData = args[1]

        if #buyData == 0 then 
            return
        end

        local cost = 0
        local tunings = {}

        for i, v in ipairs(buyData) do
            cost = cost + v.price
        end

        if result[1].wPLN < cost then 
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości wPLN.')
        end

        local customBuy = false

        for i, v in ipairs(buyData) do
            table.insert(tunings, '- '..v.name..' do pojazdu ID '..v.vehicleID)

            if v.data ~= 'stereo' and v.data ~= 'custompj' and v.data ~= 'fuelCan' then
                local vehID = tonumber(v.vehicleID)
                local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id = ?', vehID)

                if #result == 0 then 
                    return
                end

                local vehicle = loadstring((result[1].upgrades and #result[1].upgrades > 3) and result[1].upgrades or "return {}")()

                vehicle[v.data] = true
                
                if v.data == 'vopisrgb' then
                    vehicle['vopis'] = true
                end

                exports['since-db']:query('UPDATE `since-vehicles` SET upgrades = ? WHERE id = ?', serpent.dump(vehicle), vehID)

                local veh = getVehicleFromUID(vehID)

                if veh then
                    setElementData(veh, 'vehicle:upgrades', vehicle)
                end
            elseif v.data == 'stereo' then
                local vehID = tonumber(v.vehicleID)
                local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id = ?', vehID)
                
                if #result == 0 then 
                    return
                end
                
                local tunes = result[1].tuning
                
                tunes = tunes..', 1086'

                exports['since-db']:query('UPDATE `since-vehicles` SET tuning = ? WHERE id = ?', tunes, vehID)

                local veh = getVehicleFromUID(vehID)

                if veh then
                    addVehicleUpgrade(veh, 1086)
                end
            elseif v.data == 'custompj' then
                customBuy = v.name
            elseif v.data == 'fuelCan' then
                local vehID = tonumber(v.vehicleID)
                local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id = ?', vehID)

                if #result == 0 then 
                    return
                end

                local vehicle = loadstring((result[1].fuel and #result[1].fuel > 3) and result[1].fuel or "return {}")()

                if tonumber(vehicle['tank']) >= 500 then
                    return exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz najwyższą możliwą pojemność zbiornika paliwa.')
                end

                vehicle['tank'] = tonumber(vehicle['tank']) + 100

                exports['since-notifications']:sendNotification(client, 'info', 'Aktualna pojemność zbiornika wynosi '..vehicle['tank']..' L (Maks. 500L).')

                exports['since-db']:query('UPDATE `since-vehicles` SET fuel = ? WHERE id = ?', serpent.dump(vehicle), vehID)

                local veh = getVehicleFromUID(vehID)

                if veh then
                    setElementData(veh, 'vehicle:fuel', vehicle)
                end
            end
        end

        local playerWPLN = result[1].wPLN
        exports['since-db']:query('UPDATE `since-users` SET wPLN = ? WHERE uid = ?', playerWPLN - cost, playerUID)


        local tunings = table.concat(tunings, '\n')
        exports['since-notifications']:sendNotification(client, 'success', 'Zakupiono tuningi:\n'..tunings..'\nZa '..cost..' wPLN.')
        exports['since-logs']:sendDiscordLog('shop-panel', 'Sklep', 'Gracz UID ' .. playerUID .. ' zakupił tuningi:\n'..tunings..'\nZa '..cost..' wPLN.')

        
        loadWPLN(client)
    end
end)