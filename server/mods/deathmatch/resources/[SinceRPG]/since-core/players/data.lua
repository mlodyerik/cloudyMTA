local saveData = {
    { elementData = 'player:skin', key = 'skin', callback = function(player, value)
        setElementModel(player, value)
    end },
   -- { elementData = 'player:test', key = 'test', json = true},
    { key = 'money', callback = function (player, value)
        setPlayerMoney(player, value)
    end },
    { elementData = 'player:srp', key = 'srp' },
    { elementData = 'player:hours', key = 'playedTime' },
    { elementData = 'player:pp', key = 'premiumPoints' },
    { elementData = 'player:workinjob', key = 'factionTime' },
    { elementData = 'player:jobStats', key = 'jobStats', json = true },
    { elementData = 'player:data', key = 'data', json = true },
    { elementData = 'player:inventory', key = 'inventory', json = true },
    { elementData = 'player:settings', key = 'shaders', json = true },
    { elementData = 'player:friends', key = 'friends', json = true },
    { elementData = 'player:licenses', key = 'licenses', json = true },
    { elementData = 'player:skinsBought', key = 'skinsBought', json = true },
    { elementData = 'event:state', key = 'eventState' },
}

function getAllFriends(plr)
    local friends = getElementData(plr, 'player:friends') or {}
    local tbl = {}
    
    if not friends or #friends <= 0 then
        tbl = {}
    else
        for i,v in pairs(unpack(friends)) do
            for ii,vv in ipairs(getElementsByType('player')) do
                if v == getElementData(vv, 'player:sid') then
                    table.insert(tbl, vv)
                end
            end
        end
    end
    
    return tbl
end

function loadPlayerData(player)
    local uid = getElementData(player, 'player:sid')
    if not uid then return end

    local data = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', uid)

    if (#data == 0) then return end

    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE premium>NOW() AND uid=?', uid)
    if (#rows > 0) then
        setElementData(player, 'player:diamond', data[1].premium)
        outputChatBox("✓ #ffffffPosiadasz zakupioną usługę #59acffDiamond#ffffff #bfbfbf(Ważne do "..data[1].premium..")#ffffff", player, 0, 255, 0, true)
    end

    local bron = exports["since-db"]:query("SELECT * FROM `since-bronie` WHERE `owner` = ?", uid)
		
	if #bron > 0 then
		local tmp = {}
		for i,v in ipairs(bron) do
			table.insert(tmp, v.weapon)
			setElementData(player, "player:weapons", tmp)
		end
	end

    local rows = exports['since-db']:query('SELECT * FROM `since-discord` WHERE sid=?', uid)
    if (#rows > 0) then
        setElementData(player, 'player:discord', {
            
            discordID = rows[1].did,
            discordNick = rows[1].discord_login,
            discordSerial = rows[1].serial,
            discordDate = rows[1].connect_date,

        })
    elseif not rows or #rows == 0 then
        outputChatBox("✘ #ffffffPołącz swoje konto z naszym serwerem discord! Kod znajdziesz w zakładce #fffb26Ustawienia#ffffff w panelu gracza.", player, 255, 0, 0, true)
    end

    local discordCode = nil
    if data[1].kod == 'needToChange' then
        discordCode = generateDiscordCode(player, uid)
        exports['since-db']:query('UPDATE `since-users` SET `kod` = ? WHERE uid = ?', discordCode, uid)
    else
        discordCode = data[1].kod
    end

    setElementData(player, 'player:disordCode', discordCode)
    setElementData(player, 'event:data', {})

    if data[1].clothes then
        if not (data[1].clothes == "brak") then
            local t = fromJSON(data[1].clothes)
            if (type(t) == "table") then 
                for i,v in ipairs(t) do
                    addPedClothes(player,v[2],v[3],v[1])
                end
            end		
        end
    end
    setPlayerStat ( player,21,data[1].fat or 0 )
    setPlayerStat ( player,23,data[1].miesnie or 0 )	

    exports['since-org']:loadPlayerOrganizationData(player)
    
    for i,v in pairs(saveData) do
        if (v.elementData) then
            if (v.json) then
                setElementData(player, v.elementData, fromJSON(data[1][v.key]))
            else
                setElementData(player, v.elementData, data[1][v.key])
            end
        end
        
        if v.callback then
            v.callback(player, (v.json and fromJSON(data[1][v.key]) or data[1][v.key]))
        end
    end
    
    exports['since-dailyQuests']:loadQuestData(player)

    triggerClientEvent(player, 'switchSettings', player)

    local friends = getAllFriends(player)

    for i,v in ipairs(friends) do
        triggerClientEvent(v, 'createFriendNotification', v, 'Twój znajomy #f75eff'..getPlayerName(player)..'#ffffff dołączył do gry', {255, 255, 255}, 4000)
    end

    return true
end

local timers = {}

function savePlayerData(player)
    if not isElement(player) then
        if timers[player] then
            if isTimer(timers[player]) then
                killTimer(timers[player])
            end
            timers[player] = nil
        end
        return
    end
    if not getElementData(player, 'player:spawn') then
        return
    end

    local uid = getElementData(player, 'player:sid')
    if not uid then return end

    local data = {}
    data.money = getPlayerMoney(player)
    data.skin = getElementData(player, 'player:faction') and tonumber(getElementData(player, 'player:skinSave') or 0) or getElementModel(player)
    data.srp = getElementData(player, 'player:srp') or 0
    data.pp = getElementData(player, 'player:pp') or 0
    data.workingjob = getElementData(player, 'player:workinjob') or 0
    data.inventory = getElementData(player,'player:inventory') or {}
    data.jobstats = getElementData(player,'player:jobStats') or {}
    data.settings = getElementData(player,'player:settings') or {}
    data.friends = getElementData(player,'player:friends') or {}
    data.plrData = getElementData(player,'player:data') or {}
    data.hours = getElementData(player,'player:hours') or 0
    data.eventState = getElementData(player, 'event:state') or 1
    local x, y, z = getElementPosition(player)
    local int, dim = getElementInterior(player), getElementDimension(player)
    data.lastSpawn = x..', '..y..', '..z..', '..int..', '..dim
    data.licenses = getElementData(player,'player:licenses') or {}
    data.skinsBought = getElementData(player, 'player:skinsBought') or {}
    data.quest = getElementData(player, 'player:quest') or {}

    exports['since-db']:query('UPDATE `since-users` SET `money` = ?, `lastPos` = ?, `skin` = ?, `srp` = ?, `inventory` = ?, `playedTime` = ?, `licenses` = ?, `shaders` = ?, `friends` = ?, `jobStats` = ?, `skinsBought` = ?, `premiumPoints` = ? , `data` = ?, `factionTime` = ?, `dailyQuestStats` = ?, `eventState` = ? WHERE uid=? ', data.money, data.lastSpawn, data.skin, data.srp, toJSON(data.inventory), data.hours, toJSON(data.licenses), toJSON(data.settings), toJSON(data.friends), toJSON(data.jobstats), toJSON(data.skinsBought), data.pp, toJSON(data.plrData), data.workingjob, toJSON(data.quest), tonumber(data.eventState), uid)
end

addEventHandler('onPlayerConnect', root, function ()
    timers[source] = setTimer(savePlayerData, 60000, 0, source)
end)

addEventHandler('onPlayerQuit', root, function ()
    savePlayerData(source)

    local friends = getAllFriends(source)

    for i,v in ipairs(friends) do
        triggerClientEvent(v, 'createFriendNotification', v, 'Twój znajomy #f75eff'..getPlayerName(source)..'#ffffff wyszedł z gry', {255, 255, 255}, 4000)
    end

    if timers[source] then
        if isTimer(timers[source]) then
            killTimer(timers[source])
        end
        timers[source] = nil
    end
end)

function revivePlayer(plr)
    local spawn = getElementData(plr, 'player:spawn')
    local skin = getElementModel(plr)
    local int = getElementInterior(plr)
    local dim = getElementDimension(plr)
    local x, y, z = nil, nil, nil

    if spawn then
        x, y, z = spawn[1], spawn[2], spawn[3]
    else
        x, y, z = 1477.53, -1682.44, 13.93
    end

    spawnPlayer(plr, x, y, z, 0, skin, int, dim)
    setCameraTarget(plr, plr)
end

--[[addEventHandler('onPlayerWasted', root, function()
    revivePlayer(source)
end)]]

addEventHandler('onResourceStart', resourceRoot, function()
    for i, v in ipairs(getElementsByType('player')) do
        if isPedDead(v) then
            revivePlayer(v)
        end
        timers[v] = setTimer(savePlayerData, 60000, 0, v)
    end
end)

function onTransferMoney(plr, cmd, target, value)
    if not target or not tonumber(value) then
        outputChatBox('✘ #ffffffPoprawne użycie: /'..cmd..' <nick/ID> <kwota>', plr, 255, 0, 0, true)
        return
    end
		

    value=string.match(value, "%d*")
    value=tonumber(value)

    local target=findPlayer(plr, target)
    if not target then
        return outputChatBox("✘ #ffffffNie znaleziono podanego gracza.", plr, 255, 0, 0,true)
    end
    if not (getElementData(target, "player:sid")) then
        return outputChatBox("✘ #ffffffPodany gracz nie jest zalogowany.", plr, 255, 0, 0,true)
    end

    if getPlayerMoney(plr) < value then
        return outputChatBox("✘ #ffffffNie posiadasz wystarczających środków przy sobie.", plr, 255, 0, 0,true)
    end

    if value == 0 or value < 0 then
        return outputChatBox("✘ #ffffffPodano nie prawidłową wartość.", plr, 255, 0, 0,true)
    end

    takePlayerMoney(plr, value)
    givePlayerMoney(target ,value)

    outputChatBox("#30FF00✓ Przekazałeś/aś #ffffff$ "..comma_value(value).."#30FF00 dla gracza #ffffff"..getPlayerName(target):gsub("#%x%x%x%x%x%x","").."#30FF00.", plr,  0, 255, 0, true)
    outputChatBox("#30FF00✓ Otrzymałeś/aś #ffffff$ "..comma_value(value).."#30FF00 od gracza #ffffff"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#30FF00.", target,  0, 255, 0, true)

    exports['since-admins']:addMoneyTransferLog(plr, target, value)

    exports['since-logs']:sendDiscordLog('przelewy', getPlayerName(plr), 'Przekazał `'..comma_value(value)..' $` dla gracza `'..getPlayerName(target)..'`')
end
addCommandHandler('dajkase', onTransferMoney)
addCommandHandler('zaplac', onTransferMoney)

function comma_value(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function generateDiscordCode(plr, sid)
    code = string.sub(tostring(tonumber(string.sub(getTickCount()*math.random(1, 1000), 1, 7)..''..sid)*sid), 1, 6)..''..sid
    code = tonumber(code)

    return code
end

local cannels = {
    ['Antycheat'] = 'https://discord.com/api/webhooks/1184150164399726672/GARga1qgnFtIVpNO37sue3Xrx9b3HTed4dY-5uK-ywHa5QwX7FDiJJ-hNnRj44euNeXO',
  }
  
  function writeOnDiscord(cannel, text)
    if cannels[cannel] then
      sendOptions = {
        queueName = "default",
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
          username = cannel,
          content = text:gsub("#%x%x%x%x%x%x",""),
        },
      }
      fetchRemote(cannels[cannel], sendOptions, function() end)
    end
  end


  local serials = {
    ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,
    ['DBBF41553CF98C4D1C05B1CEC89CC483'] = true,
  }
  

addEvent('banCheater', true)
addEventHandler('banCheater', resourceRoot, function(info)
    local player = client
    local nick, serial, ip, versionNumber = getPlayerName(player), getPlayerSerial(player), getPlayerIP(player)
    writeOnDiscord('Antycheat', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)

    if serials[serial] then
        return
    end

    local text = ''..getPlayerName(player)..' ('..(getElementData(player, 'id') or 0)..') został zbanowany przez AntyCheat.'
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)

    if isElement(player) then
        kickPlayer(player, 'Nie posiadasz dostępu do serwera.')
    end
end)

addEventHandler("onPlayerConnect", root, function(playerNick)
	if string.find(playerNick, "#") ~= nil or string.find(playerNick, "?") ~= nil or string.find(playerNick, "!") ~= nil then
		cancelEvent(true, "Twój nick zawiera niedozwolone znaki.")
	end
end)

addEventHandler("onPlayerChangeNick", root, function() cancelEvent() end)