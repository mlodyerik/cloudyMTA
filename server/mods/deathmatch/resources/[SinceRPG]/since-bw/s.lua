markers = {}
timers = {}

function cooldown(plr)
    local x, y, z = getElementPosition(plr)
    setElementData(plr, "admin:antykill", true)
    setElementAlpha(plr, 130)
    setElementData(plr, "temp:bw:ghost", true)

    exports['since-notifications']:sendNotification(plr, 'info', 'Przechodzisz w tryb ducha na 20 sekund.')

    timers[plr] = setTimer(function(player)
        if isElement(markers[player]) then
            destroyElement(markers[player])
        end
        
        timers[player] = nil

        if (getElementData(player, "strefa")) then
            local data = getElementData(player, "player:weapons")
            if (data) then
                for i,v in ipairs(data) do
                    giveWeapon(player, v, 500000)
                end
            end
        end

        setElementData(player, "admin:antykill", nil)
        setElementData(player, "temp:bw:ghost", nil)
        setElementAlpha(player, 255)

        exports['since-notifications']:sendNotification(plr, 'info', 'Tryb ducha został wyłączony.')
    end, 20000, 1, plr)
end

addEventHandler('onResourceStop', resourceRoot, function()
    for i, player in ipairs(getElementsByType('player')) do
        if getElementData(player, 'player:bw') then
            local x, y, z = getElementPosition(player)
            local _, _, rz = getElementRotation(player)
            spawnPlayer(player, x, y, z, rz, getElementModel(player), getElementInterior(player), getElementDimension(player))
            setElementData(player, "player:bw", nil)
        end
        
        if getElementData(player, 'admin:antykill') then
            if (getElementData(player, "strefa")) then
                local data = getElementData(player, "player:weapons")
                if (data) then
                    for i,v in ipairs(data) do
                        giveWeapon(player, v, 500000)
                    end
                end
            end
            setElementData(player, "admin:antykill", nil)
            setElementData(player, "temp:bw:ghost", nil)
            setElementAlpha(player, 255)
            exports['since-notifications']:sendNotification(player, 'info', 'Tryb ducha został wyłączony.')
        end
    end
end)

addCommandHandler('unbw', function(plr, cmd, target)
    if getElementData(plr, 'player:admin') and getElementData(plr, 'player:admin') > 1 then
        local target = exports['since-core']:findPlayer(plr, target)
        if target then
            if getElementData(target, 'player:bw') then
                local x, y, z = getElementPosition(target)
                local _, _, rz = getElementRotation(target)
                spawnPlayer(target, x, y, z, rz, getElementModel(target), getElementInterior(target), getElementDimension(target))
                setElementData(target, "player:bw", nil)
                triggerClientEvent(target, 'destroyBW', resourceRoot)
                exports['since-notifications']:sendNotification(plr, 'info', 'Usunięto bw dla gracza '..getPlayerName(target)..'.')
            end
        end
    end
end)

addEvent("spawn.player", true)
addEventHandler("spawn.player", resourceRoot, function()
    local x, y, z = getElementPosition(client)
    local _, _, rz = getElementRotation(client)
    spawnPlayer(client, x, y, z, rz, getElementModel(client), getElementInterior(client), getElementDimension(client))
	setElementData(client, "player:bw", nil)

    if not getElementData(client, 'player:arena') then
        cooldown(client)
    end
end)

addEvent("kills.top", true)
addEventHandler("kills.top", resourceRoot, function(killer)
    local plr = getPlayerFromName(killer)
    local rows = exports['since-db']:query('SELECT * FROM `since-killstop` WHERE uid = ?', getElementData(plr, 'player:sid'))
    local rows2 = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', getElementData(plr, 'player:sid'))

    local username = rows2[1].nick

    if #rows > 0 then
        exports['since-db']:query('UPDATE `since-killstop` SET total = ? WHERE uid = ?', rows[1].total + 1, getElementData(plr, 'player:sid'))
    else
        exports['since-db']:query('INSERT INTO `since-killstop` (uid, total, username) VALUES (?, ?, ?)', getElementData(plr , 'player:sid'), 0, username)
    end
end)