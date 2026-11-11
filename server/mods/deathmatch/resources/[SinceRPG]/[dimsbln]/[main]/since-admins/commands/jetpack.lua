function useJetpack(player, cmd)
    if getAdmin(player) then
        if not doesPedHaveJetPack(player) then
            givePedJetPack(player)
            exports['since-notifications']:sendNotification(player, 'info', 'Dodano jetpack')
        else
            removePedJetPack(player)
            exports['since-notifications']:sendNotification(player, 'info', 'Usunięto jetpack')
        end
    end
end

addEventHandler('onPlayerJoin', root, function()
    bindKey(source, 'j', 'down', useJetpack)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i, v in ipairs(getElementsByType('player')) do
        bindKey(v, 'j', 'down', useJetpack)
    end
end)