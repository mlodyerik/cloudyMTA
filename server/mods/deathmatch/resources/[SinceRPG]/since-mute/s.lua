function checkIsPlayerMuted(plr)
    local result = exports["since-db"]:query("SELECT * FROM `since-punishments` WHERE type = ? AND serial = ? AND active = 1 AND time > NOW() LIMIT 1;", "mute", getPlayerSerial(plr))

    if #result > 0 then
        return true
    else
        return false
    end
end

function toggleMute(plr, bool)
    if type(bool) ~= "boolean" then
        return outputDebugString( "toggleMute: bool is not a boolean", 1)
    end

    setElementData(plr, 'player:mute', bool)
end

addCommandHandler('checkMute', function(plr)
    if not getElementData(plr, 'player:admin') == 4 then
        return
    end

    local result = exports["since-db"]:query("SELECT * FROM `since-punishments` WHERE type = ? AND serial = ? AND active = 1 AND time > NOW() LIMIT 1;", "mute", getPlayerSerial(plr))
    iprint(result)
end)

local isValid = {}

function getMuteTime()
    for i, v in ipairs(getElementsByType("player")) do
        if getElementData(v, 'player:spawn') and not getElementData(v, 'player:mute') then
            if not isValid[v] then
                isValid[v] = true

                local uid = getElementData(v, 'player:sid')
                local discordID = exports['since-discord']:getPlayerDiscordID(uid)

                if discordID then
                    exports['since-discord']:botWrite({
                        funcname = 'removeRole',
                        args = {
                            guild = '1143611641393586356',
                            id = discordID,
                            rank = '1270748143033520224'
                        }
                    }); 
                end
            end
        end

        if getElementData(v, 'player:spawn') and getElementData(v, 'player:mute') then
            local isMuted = checkIsPlayerMuted(v)

            if not isMuted then
                toggleMute(v, false)
                exports['since-notifications']:sendNotification(v, 'info', 'Twój czas wyciszenia minął!')

                local uid = getElementData(v, 'player:sid')
                local discordID = exports['since-discord']:getPlayerDiscordID(uid)

                if discordID then
                    exports['since-discord']:botWrite({
                        funcname = 'removeRole',
                        args = {
                            guild = '1143611641393586356',
                            id = discordID,
                            rank = '1270748143033520224'
                        }
                    }); 
                end
            else
                local uid = getElementData(v, 'player:sid')
                local discordID = exports['since-discord']:getPlayerDiscordID(uid)
                
                if discordID then
                    exports['since-discord']:botWrite({
                        funcname = 'addRole',
                        args = {
                            guild = '1143611641393586356',
                            id = discordID,
                            rank = '1270748143033520224'
                        }
                    });
                end
            end
        end
    end
end
getMuteTime()
setTimer(getMuteTime, 15000, 0)