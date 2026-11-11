local lastPm = {}

addEventHandler('onPlayerChat',root,function (message, type)
    local player = source
    cancelEvent()

    if not getElementData(player, 'player:spawn') then 
        return 
    end

    if getElementData(player, 'player:mute') then 
        return exports['since-notifications']:sendNotification(player, 'error', 'Posiadasz nałożoną karę wyciszenia!')
    end

    local message = replaceWords(message)

    local x,y,z = getElementPosition(player)
    local players = getElementsWithinRange(x, y, z, 30, 'player')
    local id = getElementData(player, 'id') or 0
    local hex = getRankHexColor(getElementData(player, 'player:admin'), getElementData(player, 'player:diamond'))

    exports['since-admins']:addChatLog(player, message:gsub('#%x%x%x%x%x%x', ''))
    
    if type == 0 then
        for i,v in pairs(players) do
            outputChatBox(''..getPlayerName(player)..' ('..hex..''..id..'#ffffff): #e6e6e6'..message:gsub('#%x%x%x%x%x%x', ''), v, 255, 255, 255, true)
        end
    elseif type == 1 then
        for i,v in pairs(players) do
            outputChatBox('** '..getPlayerName(player)..' '..message:gsub('#%x%x%x%x%x%x', '')..' **', v, 255, 128, 255, true)
        end
    end

    exports['since-logs']:sendDiscordLog('chats', getPlayerName(player), 'Wysyła wiadomość: `'..message:gsub('#%x%x%x%x%x%x', '')..'`')
end)

addCommandHandler("pmon", function(plr,cmd)
    removeElementData(plr,"pmoff")
    outputChatBox("✓#ffffff Włączono wiadomości prywatne", plr, 0, 255, 0, true)
end)
 
addCommandHandler("pmoff", function(plr,cmd,...)
    local powod=table.concat({...}, ' ')
    if (not powod or string.len(powod)<2) then 
        powod = 'Brak' 
    end
    setElementData(plr, "pmoff", powod)

    outputChatBox("✘#ffffff Wyłączono wiadomości prywatne (Powód: "..(powod == 'Brak' and '#d9a0a0Nie podano powodu' or '#bababa'..powod).."#ffffff)", plr, 255, 0, 0, true)
 end)

function onPrivateMessage(plr, cmd, target, ...)
	if not getElementData(plr, 'player:spawn') then 
        return 
    end

    if getElementData(plr, 'player:mute') then 
        return exports['since-notifications']:sendNotification(plr, 'error', 'Posiadasz nałożoną karę wyciszenia!')
    end

    if not target or not {...} then
    	return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [ID/Nick] [Treść]')
    end
    
    local target = findPlayer(plr, target)

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono takiego gracza')
    end

    local pmoff = getElementData(target, "pmoff")
    if pmoff then
		if pmoff ~= 'Brak' then
            exports['since-notifications']:sendNotification(plr, 'error', 'Gracz posiada wyłączone wiadomości prywatne. Powód: '..pmoff)
		else
            exports['since-notifications']:sendNotification(plr, 'error', 'Gracz posiada wyłączone wiadomości prywatne')
		end
        return
	end
    
    local text = table.concat({...}, ' ')

    if #text < 1 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Wprowadź więcej znaków')
    end

    if getElementData(plr,"pmoff") then exports['since-notifications']:sendNotification(plr, 'info', 'Posiadasz wyłączone wiadomości prywatne, ten gracz Ci nie odpisze.') end
	if getElementData(target, "player:mute") then exports['since-notifications']:sendNotification(plr, 'info', 'Ten gracz posiada nałożoną karę wyciszenia, nie będzie w stanie Ci odpisać.') end

    outputChatBox(">>#ffffff #cccccc("..getElementData(target,"id")..")#ffffff "..getPlayerName(target):gsub("#%x%x%x%x%x%x","")..": "..text.."", plr, 245, 219, 0, true)
	outputChatBox("<<#ffffff #cccccc("..getElementData(plr,"id")..")#ffffff "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..text.."", target, 225, 199, 0, true)
	
    lastPm[target] = plr
	playSoundFrontEnd(target, 12)
    exports['since-admins']:addPrivateMessage(plr, target, text)

    exports['since-logs']:sendDiscordLog('chats', getPlayerName(plr), 'Wysyła prywatną wiadomość do `'..getPlayerName(target)..'`: `'..text:gsub('#%x%x%x%x%x%x', '')..'`')
end
addCommandHandler('pw', onPrivateMessage)
addCommandHandler('pm', onPrivateMessage)
addCommandHandler('w', onPrivateMessage)

addCommandHandler('re', function(plr, cmd, ...)
	local text = table.concat({...}, ' ')

    if isElement(lastPm[plr]) then
        onPrivateMessage(plr, "pm", getPlayerName(lastPm[plr]), ...)
    else
        return exports['since-notifications']:sendNotification(plr, 'error', 'Gracz opuścił serwer')
    end
end)

addCommandHandler('v',function (plr,cmd,...)
    if not getElementData(plr,'player:sid') then 
        return 
    end

    if getElementData(plr, 'player:mute') then 
        return exports['since-notifications']:sendNotification(plr, 'error', 'Posiadasz nałożoną karę wyciszenia!')
    end

    local text = table.concat({...}, ' ')

    if #text < 1 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Wprowadź więcej znaków')
    end

    local text = replaceWords(text)
    local id = getElementData(plr, 'id') or 0
    local hex = getRankHexColor(getElementData(plr, 'player:admin'), getElementData(plr, 'player:diamond'))

    for i,v in pairs(getElementsByType('player')) do
        outputChatBox("#FFD100(Premium) > #ffffff"..getPlayerName(plr):gsub('#%x%x%x%x%x%x', '').."#ffffff ("..hex..""..id.."#ffffff): "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
    end

    exports['since-admins']:addGlobalChatLog(plr, text:gsub('#%x%x%x%x%x%x', ''), 'PREMIUM', tocolor(255, 209, 0))

    local q = exports['since-db']:query('SELECT * FROM `since-discord` WHERE sid = ?', getElementData(plr, 'player:sid'))

    local url = "https://ptb.discord.com/api/webhooks/1167192068410585180/DDoqzx9g_s7LlbwiapqqYOpHNO6aIYh0NzspNHVsF9o2ex-5E97fznSnyD2Y2AoH2UZu"
    if url then
        sendOptions = {
            queueName = "premium-chat",
            connectionAttempts = 3,
            connectTimeout = 5000,
            formFields = {
                username = getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..' ('..id..')',
	            avatar_url = (#q > 0 and q[1].avatarurl or nil),
    	        content = text:gsub("#%x%x%x%x%x%x",""),
            },
        }
            
        fetchRemote(url, sendOptions, function() end)
    end

    exports['since-logs']:sendDiscordLog('chats', getPlayerName(plr), 'Wysyła wiadomość premium: `'..text:gsub('#%x%x%x%x%x%x', '')..'`')
end)

addCommandHandler('d',function (plr,cmd,...)
    if not getElementData(plr,'player:sid') then 
        return 
    end

    if getElementData(plr, 'player:mute') then 
        return exports['since-notifications']:sendNotification(plr, 'error', 'Posiadasz nałożoną karę wyciszenia!')
    end

    if not getElementData(plr, 'player:diamond') then 
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz statusu diamond!')
    end

    local text = table.concat({...}, ' ')

    if #text < 1 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Wprowadź więcej znaków')
    end

    local id = getElementData(plr, 'id') or 0
    local hex = getRankHexColor(getElementData(plr, 'player:admin'), getElementData(plr, 'player:diamond'))

    for i,v in pairs(getElementsByType('player')) do
        if getElementData(v, 'player:diamond') then
            outputChatBox("#59acff(Diamond) > #ffffff"..getPlayerName(plr):gsub('#%x%x%x%x%x%x', '').."#ffffff ("..hex..""..id.."#ffffff): "..text:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
        end
    end

    exports['since-admins']:addGlobalChatLog(plr, text:gsub('#%x%x%x%x%x%x', ''), 'DIAMOND', tocolor(89, 172, 255))

    exports['since-logs']:sendDiscordLog('chats', getPlayerName(plr), 'Wysyła wiadomość diamond: `'..text:gsub('#%x%x%x%x%x%x', '')..'`')
end)

function sendPremiumchatMessage(msg, user)
    if #msg > 1 then

        msg = msg:sub(1, 80)

        if not msg:match("^[%w%s]+$") then
            return
        end

        for i,v in pairs(getElementsByType('player')) do
            outputChatBox("#FFD100(Premium) > #ffffff"..user.."#ffffff (#7ea1e6Discord#ffffff): "..msg:gsub("#%x%x%x%x%x%x","").."", v, 255, 255, 255, true)
        end
    end
end

function getPlayerCount()
    local plrs = getElementsByType("player")
    return tonumber(#plrs)
end