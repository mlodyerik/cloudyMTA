addCommandHandler('waves', function(player, cmd, height)
    if not getAdmin(player, 2) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not height then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś wysokości fal!') end

    local height = tonumber(height)
    if not height then return exports['since-notifications']:sendNotification(player, 'error', 'Podana wysokość fal jest nieprawidłowa!') end

    setWaveHeight(height)
    exports['since-notifications']:sendNotification(player, 'info', 'Ustawiono wysokość fal na '..height)
end)