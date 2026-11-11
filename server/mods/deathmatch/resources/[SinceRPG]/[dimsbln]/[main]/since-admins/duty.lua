timers = {}

addCommandHandler('duty', function(player)
    if getElementData(player, 'player:admin') then
        if getElementData(player, 'player:sid') ~= 1 and getElementData(player, 'player:sid') ~= 3 then
    	    if getElementData(player, 'player:inv') then return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz zejść z duty będąc na inv!') end
        end
        setElementData(player, 'player:admin', false)
        exports['since-notifications']:sendNotification(player, 'success', 'Wylogowano z służby administracyjnej!')

        takeWeapon(player, 22)
        toggleControl(player, 'aim_weapon', false)

        if timers[player] then
            killTimer(timers[player])
            timers[player] = nil
        end
    else
        local q = exports['since-db']:query('SELECT * FROM `since-admins` WHERE serial=?', getPlayerSerial(player))
        if not q or #q == 0 then return exports['since-notifications']:sendNotification(player, 'error', 'Brak uprawnień!') end

        setElementData(player, 'player:admin', q[1].level)
        local name = getRankName(q[1].level)
        exports['since-notifications']:sendNotification(player, 'success','Zalogowano na służbę '..name..'!')

        addRankLogin(player, name)
        
        giveWeapon(player, 22)
        toggleControl(player, 'aim_weapon', true)

        exports['since-db']:query('UPDATE `since-admins` SET `actived` = NOW() WHERE `serial` = ?', getPlayerSerial(player))

        if timers[player] then
            killTimer(timers[player])
            timers[player] = nil
        end

        timers[player] = setTimer(function(plr)
            if isElement(plr) then
                exports['since-db']:query('UPDATE `since-admins` SET `actived` = NOW() WHERE `serial` = ?', getPlayerSerial(plr))
            else
                killTimer(timers[plr])
                timers[plr] = nil
            end
        end, 60000, 0, player)
    end
end)

function createAdminNotification(text, r, g, b, time)
    triggerClientEvent(root, 'createAdminNotification', root, text, {r, g, b}, time)
end

addEventHandler('onPlayerQuit', root, function()
    if timers[source] then
        killTimer(timers[source])
        timers[source] = nil
    end
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:admin') then
            exports['since-db']:query('UPDATE `since-admins` SET `actived` = NOW() WHERE `serial` = ?', getPlayerSerial(v))
        end
    end
end)