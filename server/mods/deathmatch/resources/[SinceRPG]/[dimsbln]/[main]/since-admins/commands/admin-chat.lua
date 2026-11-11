addCommandHandler('e', function(player, cmd, ...)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error','Nie posiadasz uprawnień do tej komendy!') end
    local message = table.concat({...}, ' ')
    if not message or #message < 1 then return exports['since-notifications']:sendNotification(player, 'error','Nie podałeś treści wiadomości!') end

    local rgb = getRankRGB(getElementData(player, 'player:admin'))
    local hex = getRankHex(getElementData(player, 'player:admin'))
    local id = getElementData(player, 'id')
    local name = getPlayerName(player)

    local message = ('ⓘ #c9c9c9(%s)#ffffff %s%s#FFFFFF: %s'):format(id, hex, name, message:gsub('#%x%x%x%x%x%x',''))
    for _, p in pairs(getElementsByType('player')) do
        if getElementData(p, 'player:admin') then
            outputChatBox(message,p,255,55,55,true)
        end
	end
    exports['since-logs']:sendDiscordLog('chat-adm', 'Czat administracji (/e)', message)
end)