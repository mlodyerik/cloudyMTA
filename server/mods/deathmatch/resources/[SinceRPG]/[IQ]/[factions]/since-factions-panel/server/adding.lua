addEvent('since-factions-panel:onPlayerAdd', true)
addEventHandler('since-factions-panel:onPlayerAdd', resourceRoot, function(uid)
    local player = client

    if (not uid or #uid == 0 or not tonumber(uid)) then
        exports['since-notifications']:sendNotification(player, 'error', 'Wprowadź UID gracza.')
        return
    end

    if (not isElement(player) or getElementType(player) ~= 'player') then return end

    if (not getElementData(player, 'player:faction')) then return end

    local faction = getElementData(player, 'player:faction')

    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', uid)

    if (not rows[1]) then
        exports['since-notifications']:sendNotification(player, 'error', 'Gracz o podanym UID nie istnieje.')
        return
    end

    if (not isPlayerHavePermission(player)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej akcji.')
    end

    local user = rows[1]

    local rows = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid=?', uid)

    if (rows[1]) then
        exports['since-notifications']:sendNotification(player, 'error', 'Gracz jest już w jakiejś frakcji.')
        return
    end

    exports['since-db']:query('INSERT INTO `since-factions` SET uid=?, nick=?, faction=?, rank=?, added_by=?', uid, user.nick, faction, 1, getPlayerName(player))

    exports['since-notifications']:sendNotification(player, 'success', 'Gracz został dodany do frakcji.')

    updateFactionData(player)
end)