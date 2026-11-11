addEvent('player:takeItem', true)
addEventHandler('player:takeItem', resourceRoot, function(player, item, amount, itemData)
    if getElementData(client, 'player:faction') ~= 'SAPD' then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie jesteś w SAPD.')
    end
    
    if client == player then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz zabrać swoich przedmiotów.')
    end

    exports['since-notifications']:sendNotification(client, 'success', 'Zabrałeś '..amount..'x '..item..' od '..getPlayerName(player))
    exports['since-inventory']:addPlayerItem(player, itemData.name, -amount)
    triggerClientEvent(client, 'player:reloadItems', resourceRoot, player)
end)

addCommandHandler('przeszukaj', function(plr, cmd, target)
    if getElementData(plr, 'player:faction') ~= 'SAPD' then
        return
    end

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użyj: /przeszukaj [ID/Nick gracza]')
    end

    local target = exports['since-core']:findPlayer(plr, target)

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym ID/Nicku.')
    end

    if getElementData(target, 'player:faction') == 'SAPD' then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz przeszukać innego policjanta.')
    end

    local px, py, pz = getElementPosition(plr)
    local tx, ty, tz = getElementPosition(target)

    if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) > 10 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Jesteś za daleko od gracza.')
    end

    triggerClientEvent(plr, 'toggleUI', resourceRoot, target)
end)