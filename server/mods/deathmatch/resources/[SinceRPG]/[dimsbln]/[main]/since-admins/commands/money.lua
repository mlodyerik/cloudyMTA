addCommandHandler('money', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error',  'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end

    local target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!') end

    local money = getPlayerMoney(target)
    exports['since-notifications']:sendNotification(player, 'info', 'Gracz '..getPlayerName(target)..' posiada $'..money)
end)