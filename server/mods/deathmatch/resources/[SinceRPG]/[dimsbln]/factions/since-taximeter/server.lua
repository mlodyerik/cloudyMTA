addEventHandler('onVehicleEnter', root, function(player, seat)
    if not getElementData(source, 'vehicle:faction') == 'TSA' then
        return
    end
    
    if player and seat ~= 0 then
        local vehicle = source
        local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {}

        if not vehicleData then return end

        if not vehicleData.passager then
            vehicleData.passager = player

            setElementData(vehicle, 'vehicle:taxi', vehicleData)
        end
    elseif player and seat == 0 then
        local vehicle = source
        local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {}

        if not vehicleData then return end

        vehicleData.driver = player

        setElementData(vehicle, 'vehicle:taxi', vehicleData)
    end
end)

function addComma(number)
    local number = tostring(number)
    return number:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function takeMoney(player, money)
    if getPlayerMoney(player) < money then
        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ?', getElementData(player, 'player:sid'))

        if #result > 0 then
            local bankMoney = result[1].bankMoney

            if bankMoney < money then
                return false
            else
                exports['since-db']:query('UPDATE `since-users` SET `bankMoney` = ? WHERE `uid` = ?', bankMoney - money, getElementData(player, 'player:sid'))
                return true
            end
        else
            return false
        end
    else
        takePlayerMoney(player, money)
        return true
    end

    return false
end

addEventHandler('onVehicleExit', root, function(player, seat)
    if not getElementData(source, 'vehicle:faction') == 'TSA' then
        return
    end

    if player and seat ~= 0 then
        local vehicle = source
        local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {}

        if not vehicleData then return end

        triggerEvent('onTaxiRequest', resourceRoot, 'endCourse', { player, vehicle })
    elseif player and seat == 0 then
        local vehicle = source
        local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {}

        if not vehicleData then return end

        vehicleData.driver = false

        setElementData(vehicle, 'vehicle:taxi', vehicleData)
    end
end)

addEvent('onTaxiRequest', true)
addEventHandler('onTaxiRequest', resourceRoot, function(ev, args)
    if ev == 'startCourse' then
        local driver, client_ = args[1], args[2]
        outputChatBox('✓#ffffff Kierowca #54acff'..getPlayerName(driver)..'#ffffff rozpoczyna twój kurs.', client_, 55, 255, 55, true)

        outputChatBox('✓#ffffff Rozpoczęto kurs dla gracza #54acff'..getPlayerName(client_)..'#ffffff.', driver, 55, 255, 55, true)
    elseif ev == 'endCourse' then
        local player, vehicle, byDriver = args[1], args[2], args[3]

        local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {}
        local driver = vehicleData.driver

        if vehicleData.passager and vehicleData.passager == player and driver then
            local money = vehicleData.money or 0
            
            if vehicleData.doinCurse then
                outputChatBox('✓#ffffff Zakończono kurs gracza #54acff'..getPlayerName(player)..'#ffffff', driver, 55, 255, 55, true)
            end

            if money > 0 then
                if takeMoney(player, money) ~= true then
                    outputChatBox('✗#ffffff Nie posiadasz wystarczającej ilości gotówki aby opłacić kurs.', player, 255, 55, 55, true)

                    if byDriver then
                        outputChatBox('✗#ffffff Klient #54acff'..getPlayerName(player)..'#ffffff nie posiada wystarczającej ilości gotówki aby opłacić kurs.', driver, 255, 55, 55, true)
                    end
                    return
                end

                if byDriver then
                    outputChatBox('✓#ffffff #5EABD6'..getPlayerName(driver)..'#ffffff zakończył twój kurs. Pobrano: #2E756F'..addComma(money)..'$', player, 55, 255, 55, true)
                else
                    outputChatBox('✓#ffffff Twój kurs został zakończony. Pobrano: #2E756F'..addComma(money)..'$', player, 55, 255, 55, true)
                end
            end

            if not byDriver then
                vehicleData.passager = false
            end

            vehicleData.kilometers = 0
            vehicleData.money = 0
            vehicleData.doinCurse = false
            vehicleData.passagerMoney = 0

            setElementData(vehicle, 'vehicle:taxi', vehicleData)

            triggerClientEvent(driver, 'stopCounting', resourceRoot)
        end
    end
end)