addCommandHandler('tppos', function(player, cmd, ...)
    if not getElementData(player, 'player:sid') then return end
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local pos = table.concat({...}, ','):gsub(' ', ''):gsub(',,', ',')
    if not pos then
        return exports['since-notifications']:sendNotification(player, 'warning', 'Użyj: /tppos x, y, z')
    end

    local x, y, z = unpack(split(pos, ','))
    if not x or not y or not z then
        return exports['since-notifications']:sendNotification(player, 'warning', 'Użyj: /tppos x, y, z')
    end

    setElementPosition(player, x, y, z)
    exports['since-notifications']:sendNotification(player, 'success', 'Zostałeś przeniesiony na pozycję: ' .. x .. ', ' .. y .. ', ' .. z)
end)