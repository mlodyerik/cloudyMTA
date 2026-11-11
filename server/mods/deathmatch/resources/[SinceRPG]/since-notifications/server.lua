function sendNotification(player, type, text)
    if not player then return end
    triggerClientEvent(player, "addNotification", resourceRoot, type, text)
end