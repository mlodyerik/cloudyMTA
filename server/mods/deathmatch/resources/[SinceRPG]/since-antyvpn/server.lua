function findPlayerBySerial(serial)
    for i, player in ipairs(getElementsByType('player')) do
        if getPlayerSerial(player) == serial then
            return player
        end
    end
    return false
end

addEventHandler('onPlayerConnect', root, function(playerNick, playerIP)
    fetchRemote('http://51.77.48.139:3000/getPlayerVPNState/'..playerIP..'', function(data)
        if data == '"yes"' then
            setTimer(function(playerNick, playerIP)
                local player = getPlayerFromName(playerNick)

                if player then
                    outputServerLog('Player '..playerNick..' ('..playerIP..') has proxy.')
                    kickPlayer(player, 'Nie możesz dołączyć na serwer, zgłoś się do zarządu.')
                end
            end, 5000, 2, playerNick, playerIP)
        end
    end)
end)