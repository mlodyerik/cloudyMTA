local blacklist = {

}

function checkBan(player)
    local bans = getBans()

    for _, ban in ipairs(bans) do
        local bannedSerial = getBanSerial(ban)
        local bannedIP = getBanIP(ban)

        if bannedSerial == getPlayerSerial(player) or bannedIP == getPlayerIP(player) then
            banPlayer(player, true, false, true, getBanReason(ban))
        end
    end
end

addEventHandler('onPlayerJoin', root, function()
    local serial = getPlayerSerial(source)
    local ip = getPlayerIP(source)
    local name = getPlayerName(source)

    checkBan(source)

    if blacklist[serial] or blacklist[ip] then
        banPlayer(source, true, false, true, 'Zostales permanentnie zbanowany na tym serwerze!')
    end

    if blacklist[name] then
        kickPlayer(source, 'Zostales permanentnie zbanowany na tym serwerze!')
    end
end)