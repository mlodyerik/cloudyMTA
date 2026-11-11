main = {
    ['bot'] = false,
    ['handshake'] = false
}

function restartDiscordAPI()
    local resource = getResourceFromName('since-discord')
    local result = restartResource(resource)

    if result then
        outputDebugString('[DISCORD-API]: Resource has been restarted.')
    else
        outputDebugString('[DISCORD-API]: Cant restart.')
    end

    return result and true or false
end

function connecttobot()
    if (main['bot'] ~= false) then
		sockClose(main['bot']);
	end
	
    main['bot'] = sockOpen('83.168.107.6', 6666);
end

connecttobot()

addEventHandler('onSockOpened', root, function(socket)
	if (socket ~= main['bot']) then return end;
	print('[DISCORD-API]: Connected to port 6666.');
end)


function test()
	return true
end

function normalJSON(arr)
	if not arr then
		return false;
	end
	arr.auth = ':JdB{K)Q17r238F:h';
	local json = toJSON(arr);
	json = json:sub(2, -2);
	return json;
end

function botWrite(...) 
	sockWrite(main['bot'], normalJSON(...)..';;');
end

function findPlayerBySID(sid)
	for i,v in pairs(getElementsByType('player')) do
		if getElementData(v,'player:sid') == tonumber(sid) then
			return v
		end
	end
	return false
end

addEventHandler('onSockData', root, function(socket, received)
	if (socket ~= main['bot']) then return end;
	local jsons = split(received, ';;;');
	for _, json in pairs(jsons) do
		local data = fromJSON(json);
		if (data) then
			if (data.handshake) then
				handshake = true;
			end
			if (data.funcname) then
				functions[data.funcname](data);
			end
		end
	end
end)

function sendDiscordNotification(player, title, message, color)
    local targetID = nil
    if isElement(player) and getElementType(player) == 'player' then
        local discordResult = exports['since-db']:query('SELECT * FROM `since-discord` WHERE `serial` = ?', getPlayerSerial(player))
            
        if #discordResult > 0 then
            targetID = discordResult[1]['did'] 
        end
    else
        local discordResult = exports['since-db']:query('SELECT * FROM `since-discord` WHERE `serial` = ?', player)

        if #discordResult > 0 then
            targetID = discordResult[1]['did']
        end
    end

    if targetID then
        botWrite({
            funcname = 'sendDiscordMessage',
            args = {
                member = targetID,
                title = title,
                message = message,
                color = color
            }
        });
    end
end

function getPlayerDiscordID(playerSID)
    if playerSID then
        local discordResult = exports['since-db']:query('SELECT * FROM `since-discord` WHERE `sid` = ?', playerSID)
        
        if #discordResult > 0 then
            return discordResult[1]['did']
        end
    end

    return false
end