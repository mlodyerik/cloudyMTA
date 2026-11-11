local cuboid = createColCuboid(785.46, 605.27, -14.27, 2159.82, 2407.43, 181.90)

addEventHandler("onColShapeHit", cuboid, function(hitElement)
    if (getElementType(hitElement) == "player") then
        -- exports['since-notifications']:sendNotification(hitElement, 'success', 'Wszedłeś do strefy w której obowiązuje waluta: $C')
    end
end)

addEventHandler("onColShapeLeave", cuboid, function(hitElement)
    if (getElementType(hitElement) == "player") then
        -- exports['since-notifications']:sendNotification(hitElement, 'error', 'Opuściłeś strefę w której obowiązuje waluta: $C')
    end
end)

function givePlayerSinceCash(player, amount)
    if (not getElementData(player, 'player:sid')) then return end

    local sid = getElementData(player, 'player:sid')

    exports['since-db']:query('UPDATE `since-users` SET `$C` = `$C` + ? WHERE `sid` = ?', amount, sid)
end

function takePlayerSinceCash(player, amount)
    if (not getElementData(player, 'player:sid')) then return end

    local sid = getElementData(player, 'player:sid')

    exports['since-db']:query('UPDATE `since-users` SET `$C` = `$C` - ? WHERE `sid` = ?', amount, sid)
end

function getPlayerSinceCash(player)
    if (not getElementData(player, 'player:sid')) then return end

    local sid = getElementData(player, 'player:sid')

    local rows = exports['since-db']:query('SELECT `$C` FROM `since-users` WHERE `sid` = ?', sid)

    if (not rows or #rows == 0) then return 0 end

    return rows[1]['$C']
end