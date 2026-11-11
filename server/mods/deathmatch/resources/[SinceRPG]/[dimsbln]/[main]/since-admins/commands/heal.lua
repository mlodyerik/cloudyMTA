addCommandHandler('heal', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end

    local target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza!') end

    setElementHealth(target, 100)
    exports['since-notifications']:sendNotification(player, 'success', 'Uleczono gracza!')
    exports['since-notifications']:sendNotification(target, 'success', 'Zostałeś uleczony przez '..getPlayerName(player))
end)