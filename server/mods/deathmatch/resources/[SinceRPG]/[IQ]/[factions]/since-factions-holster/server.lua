addEvent('since-factions-parking:tryGetWeapon', true)
addEventHandler('since-factions-parking:tryGetWeapon', resourceRoot, function (id)
    local player = client

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    if (not getElementData(player, 'player:faction') or getElementData(player, 'player:faction') ~= 'SAPD') then
        return
    end

    local weapon = items[id].weapon

    if (items[id].fnc(player) == "Schowaj") then
        takeWeapon(player, weapon)
        exports['since-notifications']:sendNotification(player, 'success', 'Schowano broń '..items[id].name..'.')
    else
        giveWeapon(player, weapon, 9999)
        exports['since-notifications']:sendNotification(player, 'success', 'Wyciągnięto broń '..items[id].name..'.')
    end
end)