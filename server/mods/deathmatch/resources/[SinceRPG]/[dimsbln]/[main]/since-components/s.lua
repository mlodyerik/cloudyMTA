  

addEvent('H_components:buyColor', true)
addEventHandler('H_components:buyColor', resourceRoot, function(veh, type, cost, r,g,b)
    if veh and isElement(veh) then
        if exports['since-core']:takePlayerBankMoney(client, cost) then
            local color = {getVehicleColor(veh, true)}

            if type == 'podstawowy' then
                setVehicleColor(veh, r, g, b, color[4], color[5], color[6], color[7], color[8], color[9], color[10], color[11], color[12])

            elseif type == 'dodatkowy' then
                setVehicleColor(veh, color[1], color[2], color[3], r, g, b, color[7], color[8], color[9], color[10], color[11], color[12])

            elseif type == 'felgi' then
                setVehicleColor(veh, color[1], color[2], color[3], color[4], color[5], color[6], r, g, b, color[10], color[11], color[12])

            elseif type == 'ranty' then
                setVehicleColor(veh, color[1], color[2], color[3], color[4], color[5], color[6], color[7], color[8], color[9], r, g, b)
            elseif type == 'tarcze' then
                local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
                upgrades['brakesColor'] = {r,g,b}
                setElementData(veh, 'vehicle:upgrades', upgrades)
            elseif type == 'lampy' then
                setVehicleHeadLightColor(veh, r,g,b)
            elseif type == 'dym_lewy' then
                local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
                local r2, g2, b2, r3, g3, b3 = unpack(upgrades['smokeColor'] or {255, 255, 255, 255, 255, 255})
                upgrades['smokeColor'] = {r,g,b,r3,g3,b3}
                setElementData(veh, 'vehicle:upgrades', upgrades)
            elseif type == 'dym_prawy' then
                local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
                local r2, g2, b2, r3, g3, b3 = unpack(upgrades['smokeColor'] or {255, 255, 255, 255, 255, 255})
                upgrades['smokeColor'] = {r2,g2,b2,r,g,b}
                setElementData(veh, 'vehicle:upgrades', upgrades)
            elseif type == 'szyby' then
                local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
                upgrades['tintcolor'] = {r,g,b}
                setElementData(veh, 'vehicle:upgrades', upgrades)
            end

            exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zmieniono kolor!')
        else
            exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości pieniędzy w banku!')
        end
    else
        exports['since-notifications']:sendNotification(client, 'error', 'Serwer nie wykrył pojazdu!')
    end
end)

addEvent('H_components:buySpeedoPatern', true)
addEventHandler('H_components:buySpeedoPatern', resourceRoot, function(veh, pattern, cost)
    if veh and isElement(veh) then
        if exports['since-core']:takePlayerBankMoney(client, cost) then
            local tune = getElementData(veh, 'vehicle:upgrades') or {}
            tune['motyw'] = tonumber(pattern) or nil
            setElementData(veh, 'vehicle:upgrades', tune)
            exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zamontowano motyw licznika!')
        else
            exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości pieniędzy w banku!')
        end
    end
end)

addEvent('H_components:buyKeys', true)
addEventHandler('H_components:buyKeys', resourceRoot, function(veh, cost)
    if veh and isElement(veh) then
        if exports['since-core']:takePlayerBankMoney(client, cost) then
            local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
                
            if (upgrades['keys'] or 1) >= 10 then
                return exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz maksymalną ilość kluczy')
            end

            if not upgrades['keys'] then
                upgrades['keys'] = 1
            end

            upgrades['keys'] = tonumber(upgrades['keys']) + 1

            setElementData(veh, 'vehicle:upgrades', upgrades)
            exports['since-notifications']:sendNotification(client, 'success', 'Dokupiono 1 klucz do pojazdu.')
        else
            exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości pieniędzy w banku!')
        end
    end
end)