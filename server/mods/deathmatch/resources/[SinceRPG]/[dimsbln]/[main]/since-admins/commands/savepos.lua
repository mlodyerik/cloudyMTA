local savedPos = {}

addCommandHandler('sp', function(player, cmd)
    if not getAdmin(player, 3) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local x, y, z = getElementPosition(player)
    local rot = getPedRotation(player)
    savedPos[player] = {x, y, z, rot}
    exports['since-notifications']:sendNotification(player, 'info', 'Pozycja została zapisana!')
end)

addCommandHandler('lp', function(player, cmd)
    if not getAdmin(player, 3) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not savedPos[player] then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz zapisanej pozycji!') end

    local x, y, z, rot = unpack(savedPos[player])
    setElementPosition(player, x, y, z)
    setPedRotation(player, rot)
    exports['since-notifications']:sendNotification(player, 'info', 'Teleportowano na zapisaną pozycję!')
end)