  

urls = {}

function loadPlayersAvatars()
    local rows = exports['since-db']:query('SELECT * FROM `since-discord`')

    for i,v in ipairs(rows) do
        if #v.avatarurl > 3 then
            urls[v.sid] = v.avatarurl
        end
    end
end

addEventHandler('onResourceStart', resourceRoot, function()
    loadPlayersAvatars()
    setTimer(loadPlayersAvatars, 60000, 0)
end)

function getPlayerAvatarURL(uid)
    local result = false

    for i,v in pairs(urls) do
        if tonumber(i) == uid then
            result = v
        end
    end

    return result
end

addEvent('fetchAvatar',true)
addEventHandler('fetchAvatar',resourceRoot,function (uid)
    local avatarURl = getPlayerAvatarURL(uid)
    if avatarURl then
        fetchRemote(avatarURl, 'custom_avatars', 1, 4000, function (responseData, error, player, uid)
            if player and isElement(player) then
                triggerClientEvent(player,'returnAvatars',resourceRoot,responseData,uid,avatarURl)
            end
        end, "", false, client, uid)
    end
end)

addEvent('fetchCircleAvatar',true)
addEventHandler('fetchCircleAvatar',resourceRoot,function (uid)
    local avatarURl = getPlayerAvatarURL(uid)
    if avatarURl then
        fetchRemote(avatarURl, 'custom_avatars', 1, 4000, function (responseData, error, player, uid)
            if player and isElement(player) then
                triggerClientEvent(player,'returnCircleAvatars',resourceRoot,responseData,uid)
            end
        end, "", false, client, uid)
    end
end)

function reloadPlayerSerialAvatar(serial)
    local plr = findPlayerBySerial(serial)

    if plr then
        local rows = exports['since-db']:query('SELECT * FROM `since-discord` WHERE serial=?', serial)

        if #rows > 0 and #rows[1].sid then
            urls[rows[1].sid] = rows[1].avatarurl
        end
        
        if (#rows > 0) and #rows[1].avatarurl > 3 then
            fetchRemote(rows[1].avatarurl, 'custom_avatars', 1, 4000, function (responseData, error, player, uid)
                triggerClientEvent(root, 'returnAvatars', root, responseData, uid)
            end, "", false, plr, rows[1].sid)
        end

        if (#rows > 0) and #rows[1].avatarurl > 3 then
            fetchRemote(rows[1].avatarurl, 'custom_avatarsCircle', 1, 4000, function (responseData, error, player, uid)
                triggerClientEvent(root, 'returnCircleAvatars', root, responseData, uid)
            end, "", false, plr, rows[1].sid)
        end
    end
end

function findPlayerBySerial(serial)
    local plr = false

    for i,v in ipairs(getElementsByType('player')) do
        if getPlayerSerial(v) == serial then
            plr = v
        end
    end

    return plr
end