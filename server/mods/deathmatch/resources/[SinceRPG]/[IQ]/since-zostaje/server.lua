local timeouts = {}
local wplnCount = 400

addCommandHandler('zostaje', function (player, cmd)
    if (not getElementData(player, 'player:sid')) then return end

    if (timeouts[player] and timeouts[player] > getTickCount()) then
        exports['since-notifications']:sendNotification(player, 'error', 'Poczekaj chwilę zanim użyjesz ponownie tej komendy.')
        return
    end

    timeouts[player] = getTickCount() + 1000 * 5

    local rows = exports['since-db']:query('SELECT `zostaje` FROM `since-users` WHERE `uid` = ?', getElementData(player, 'player:sid'))

    if (rows and #rows > 0) then
        local zostaje = rows[1].zostaje

        if (zostaje == 0) then
            exports['since-db']:query('UPDATE `since-users` SET `wPLN` = `wPLN` + ? WHERE `uid` = ?', wplnCount, getElementData(player, 'player:sid'))
            exports['since-db']:query('UPDATE `since-users` SET `zostaje` = 1 WHERE `uid` = ?', getElementData(player, 'player:sid'))
            exports['since-notifications']:sendNotification(player, 'success', 'Otrzymałeś(aś) ' .. wplnCount .. ' wPLN za pozostanie na serwerze.')
        else
            exports['since-notifications']:sendNotification(player, 'error', 'Już otrzymałeś(aś) wPLN za pozostanie na serwerze.')
        end
    end
end)