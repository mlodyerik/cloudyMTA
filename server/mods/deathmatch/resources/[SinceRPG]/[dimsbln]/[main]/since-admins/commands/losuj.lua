addCommandHandler('losuj', function(player, cmd, ...)
    if not getAdmin(player, 2) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local reward = table.concat({...}, ' ')
    reward = #reward > 0 and reward or false
    local hex = getRankHex(getElementData(player, 'player:admin'))
    local message;
    if reward then
        message = ('#ffee00★ #ffffffAdministrator %s%s #ffffffrozpoczyna losowanie! Nagroda: #27f561%s'):format(hex, getPlayerName(player), reward)
    else
        message = ('#ffee00★ #ffffffAdministrator %s%s #ffffffrozpoczyna losowanie'):format(hex, getPlayerName(player))
    end

    outputChatBox(message, root, 255, 255, 255, true)

    setTimer(function()
        local players = getElementsByType('player')
        local winner = players[math.random(#players)]
        local message;
        if reward then
            message = ('#ffee00★ #ffffffGracz #cccccc%s #ffffffwygrał losowanie! Nagroda: #27f561%s'):format(getPlayerName(winner), reward)
        else
            message = ('#ffee00★ #ffffffGracz #cccccc%s #ffffffwygrał losowanie'):format(getPlayerName(winner))
        end
        outputChatBox(message, root, 255, 255, 255, true)

        exports['since-notifications']:sendNotification(winner, 'info', 'Wygrałeś losowanie! Nagroda zostanie niebawem nadana przez jednego z ownerów')
    end, 10000, 1)
end)