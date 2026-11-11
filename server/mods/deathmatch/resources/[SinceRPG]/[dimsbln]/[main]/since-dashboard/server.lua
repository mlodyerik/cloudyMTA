addEvent('getPlayerDashboardData', true)
addEventHandler('getPlayerDashboardData', resourceRoot, function()
    local playerUID = getElementData(client, 'player:sid')

    if not playerUID then
        return
    end

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ? LIMIT 1', playerUID)

    triggerClientEvent(client, 'getPlayerDashboardData', client, result[1])
end)

addEvent('getVehiclesDashboardData', true)
addEventHandler('getVehiclesDashboardData', resourceRoot, function()
    local playerUID = getElementData(client, 'player:sid')

    if not playerUID then
        return
    end

    local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE owner = ?', playerUID)

    triggerClientEvent(client, 'getVehiclesDashboardData', client, result)
end)

local tpTimeout = 60000 * 10
local timeout = {}

function getNearbyCops(plr)
	local x, y, z = getElementPosition(plr)
	local nearby = {}

	for i, v in ipairs(getElementsWithinRange(x, y, z, 50, 'player')) do
		if getElementData(v, 'player:faction') == 'SAPD' then
			table.insert(nearby, v)
		end
	end

	return #nearby
end


function getDriversOnDuty()
    local count = 0
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:faction') == 'TSA' then
            count = count + 1
        end
    end

    return count
end

addEvent('onTeleportJob', true)
addEventHandler('onTeleportJob', resourceRoot, function(position)
    local playerUID = getElementData(client, 'player:sid')

    if not playerUID then
        return
    end
	
	if timeout[client] then
		local remaining, executesRemaining, timeInterval = getTimerDetails(timeout[client])
		return exports['since-notifications']:sendNotification(client, 'error', 'Musisz odczekać jeszcze '..math.ceil(remaining / 1000)..' sekund przed następnym teleportem.')
	end
	
	if getNearbyCops(client) > 0 then
		return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz teleportować się będąc w pobliżu policjantów.')
	end

	local vehicle = getPedOccupiedVehicle(client)

	if vehicle then
		return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz teleportować się będąc w pojeździe.')
	end

	if getElementData(client, 'player:job') then
		return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz teleportować się będąc w pracy.')
	end

	if getElementData(client, 'player:faction') then
		return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz teleportować się będąc w frakcji.')
	end

	if getElementData(client, 'player:strefa') then
		return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz teleportować się będąc w strefie bezprawia.')
	end

	if getDriversOnDuty() > 0 then
		return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz teleportować się jeśli jest dostępny kierowca TSA, wezwij taksówkę używając komendy /taxi.')
	end

	local x, y, z, rx, ry, rz = unpack(position)

	setElementPosition(client, x, y, z)
	setElementRotation(client, rx, ry, rz)

	timeout[client] = setTimer(function(plr)
		if timeout[plr] then
			killTimer(timeout[plr])
			timeout[plr] = nil
		end
	end, tpTimeout, 1, client)
end)

function isPrizeActive(plr)
	local queryA = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? AND daily_date > NOW() LIMIT 1", getElementData(plr, "player:sid"))

	if (queryA and #queryA > 0) then
		return false
	end

	return true	
end


addEvent('getDailyPrizeData', true)
addEventHandler('getDailyPrizeData', resourceRoot, function()
    local playerUID = getElementData(client, 'player:sid')

    if not playerUID then
        return
    end

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ? LIMIT 1', playerUID)

    triggerClientEvent(client, 'getDailyPrizeData', client, result, isPrizeActive(client))
end)

function findPlayerBySID(sid)
	for i, v in ipairs(getElementsByType('player')) do
		if getElementData(v, 'player:sid') == sid then
			return v
		end
	end

	return false
end

addEvent('promocodeAction', true)
addEventHandler('promocodeAction', resourceRoot, function(action, ...)
    local args = {...}
	local playerSID = getElementData(client, 'player:sid')

	if not playerSID then
		return
	end

	if action == 'reward' then
		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", playerSID)
		local reward = args[1]
		local rewardData = codeRewards[reward]

		if not rewardData then
			return
		end

		if query[1]['codeReward_'..reward] >= rewardData.uses then
			return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz odebrać tej nagrody.')
		end

		givePromoReward(client, rewardData.type, rewardData.value)
		exports['since-db']:query("UPDATE `since-users` SET codeReward_"..reward.." = codeReward_"..reward.." + 1 WHERE uid = ?", playerSID)

		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", playerSID)

		if query and #query > 0 then
			triggerClientEvent(client, 'promocodeAction', client, 'get', query[1])
		end
	elseif action == 'use' then
		local code = tostring(args[1])

		if string.len(code) < 3 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Podany kod jest za krótki!')
		end

		if string.len(code) > 15 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Podany kod jest za długi!')
		end

		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE promocode = ? LIMIT 1", code)
		local query2 = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", playerSID)

		if #query < 1 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Podany kod nie istnieje!')
		end

		if query[1].uid == playerSID then
			return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz użyć własnego kodu!')
		end

		if query2[1].usingPromocode == 1 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Już użyłeś kodu polecającego!')
		end

		exports['since-db']:query("UPDATE `since-users` SET usingPromocode = ? WHERE uid = ?", 1, playerSID)
		exports['since-db']:query("UPDATE `since-users` SET promocodeCount = promocodeCount + 1 WHERE promocode = ?", query[1].promocode)

		exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie użyłeś kodu polecającego gracza '..query[1].nick..'.')

		givePromoReward(client, 'diamond', 2)
		givePromoReward(client, 'money', 50000)

		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", playerSID)
		local query2 = exports['since-db']:query("SELECT * FROM `since-users` WHERE promocode = ? LIMIT 1", code)
		triggerClientEvent(client, 'promocodeAction', client, 'get', query[1])

		local target = findPlayerBySID(query2[1].uid)
		if target then
			exports['since-notifications']:sendNotification(target, 'info', 'Gracz '..getPlayerName(client):gsub("#%x%x%x%x%x%x", "")..' użył twój kod polecający! Otrzymujesz $ 50,000 na konto bankowe.')

			local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", query2[1].uid)
			triggerClientEvent(target, 'promocodeAction', target, 'get', query[1])
			exports['since-db']:query("UPDATE `since-users` SET bankMoney = bankMoney + 50000 WHERE uid = ?", query[1].uid)
		else
			exports['since-db']:query("UPDATE `since-users` SET bankMoney = bankMoney + 50000 WHERE uid = ?", query2[1].uid)
		end
	elseif action == 'get' then
		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", playerSID)

		if query and #query > 0 then
			triggerClientEvent(client, 'promocodeAction', client, 'get', query[1])
		end
	elseif action == 'change' then
		local code = tostring(args[1])

		if string.len(code) < 3 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Podany kod jest za krótki!')
		end

		if string.len(code) > 15 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Podany kod jest za długi!')
		end

		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE promocode = ? LIMIT 1", code)

		if query and #query > 0 then
			return exports['since-notifications']:sendNotification(client, 'error', 'Podany kod już istnieje!')
		end

		exports['since-db']:query("UPDATE `since-users` SET promocode = ? WHERE uid = ?", code, playerSID)
		exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zmieniono kod promocyjny na '..code..'.')

		local query = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", playerSID)

		if query and #query > 0 then
			triggerClientEvent(client, 'promocodeAction', client, 'get', query[1])
		end
	end
end)

local prize = {

    {
        fnc = function(plr)
            local random = math.random(10, 50)
            local playerData = getElementData(plr, 'player:pp')

            setElementData(plr, 'player:pp', playerData + random)

            return addCommas(random)..' PP'
        end,
    },

    {
        fnc = function(plr)
            local random = math.random(10, 35)
            local playerData = getElementData(plr, 'player:srp') or 0

            setElementData(plr, 'player:srp', playerData + random)

            return addCommas(random)..' SRP'
        end,
    },

    {
        fnc = function(plr)
            local random = math.random(35000, 125000)

            givePlayerMoney(plr, random)

            return addCommas(random)..' $'
        end,
    },

}

function givePlayerPrize(plr)
    local playerUID = getElementData(plr, 'player:sid')
    local randomPrize = prize[math.random(1, #prize)].fnc(plr)
    exports['since-notifications']:sendNotification(plr, 'info', 'Otrzymujesz '..randomPrize..' z nagrody dziennej!')
    exports['since-db']:query("UPDATE `since-users` SET daily_info = ? WHERE `uid` = ?", randomPrize, playerUID)

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ? LIMIT 1', playerUID)
    triggerClientEvent(plr, 'getDailyPrizeData', plr, result, isPrizeActive(plr))
end

addEvent('giveDailyPrize', true)
addEventHandler('giveDailyPrize', resourceRoot, function(plr, selected)
    local playerUID = getElementData(client, 'player:sid')

    if not playerUID then
        return
    end

    local checkPrizeActive = isPrizeActive(client)

    if not checkPrizeActive then
        exports['since-notifications']:sendNotification(client, 'error', 'Odebrałeś już dzienną nagrodę!')
    else
        exports['since-db']:query("UPDATE `since-users` SET daily_date = NOW() + INTERVAL ? DAY WHERE `uid` = ?", 1, playerUID)
        exports['since-db']:query("UPDATE `since-users` SET daily_selected = ? WHERE `uid` = ?", selected, playerUID)
        exports['since-db']:query("UPDATE `since-users` SET daily_count = daily_count + 1 WHERE `uid` = ?", playerUID)

        givePlayerPrize(client)
    end
end)

addEvent('getFriendsInfo', true)
addEventHandler('getFriendsInfo', resourceRoot, function(plr)
    local playerUID = getElementData(client, 'player:sid')

    if not playerUID then
        return
    end

    local friendsData = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=? LIMIT 1", playerUID)
	local friendsJson = fromJSON(friendsData[1].friends)
	local tblF = {}
	
	if friendsJson and #friendsJson > 0 then
		for i, v in ipairs(friendsJson) do
			local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=? LIMIT 1", v[1])
			table.insert(tblF, result[1])
		end
	end

	triggerClientEvent(client, 'getFriendsInfo', client, tblF)
end)

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

addEvent("sendFriendRequest", true)
addEventHandler("sendFriendRequest", resourceRoot, function(friend)
	if friend and client then
		local target = exports["since-core"]:findPlayer(client, friend)
		if target then
			if target == client then
				return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wysłać zaproszenia do samego siebie!')
			end
			local id = getElementData(client, "id")
			local eldata = getElementData(client, "friend_request")
			local friends = getElementData(client, "player:friends")

			if friends then
				for i,v in ipairs(friends) do
					if v[1] == getElementData(target, "player:sid") then
						return exports['since-notifications']:sendNotification(client, 'error', 'Podany gracz jest już twoim znajomym')
					end 
				end
			end

			if eldata then
				for i,v in ipairs(eldata) do
					if v.userdata == target then
						return exports['since-notifications']:sendNotification(client, 'error', 'Podany gracz posiada już aktywne od ciebie zaproszenie')
					end
				end

				table.insert(eldata, {userdata = target, tick = getTickCount()})
				setElementData(client, "friend_request", eldata)
				outputChatBox("#fffb00* #ffffffGracz #a9a9a9"..getPlayerName(client):gsub("#%x%x%x%x%x%x", "").." #ffffffwysłał Ci zaproszenie do znajomych. Aby je zaakceptować użyj #a9a9a9/zaproszenie.akceptuj "..id, target, 255, 255, 255, true)
				exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie wysłano zaproszenie do znajomych')
			else
				setElementData(client, "friend_request", {userdata = target, tick = getTickCount()})
				outputChatBox("#fffb00* #ffffffGracz #a9a9a9"..getPlayerName(client):gsub("#%x%x%x%x%x%x", "").." #ffffffwysłał Ci zaproszenie do znajomych. Aby je zaakceptować użyj #a9a9a9/zaproszenie.akceptuj "..id, target, 255, 255, 255, true)
				exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie wysłano zaproszenie do znajomych')
			end
		else
			exports['since-notifications']:sendNotification(client, 'error', 'Nie znaleziono gracza')
		end
	end
end)

function sendFriendRequest(player, friend)
	if friend and player then
		local target = exports["since-core"]:findPlayer(player, friend)
		if target then
			if target == player then
				return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wysłać zaproszenia do samego siebie!')
			end
			local id = getElementData(player, "id")
			local eldata = getElementData(player, "friend_request")
			local friends = getElementData(player, "player:friends")

			if friends then
				for i,v in ipairs(friends) do
					if v[1] == getElementData(target, "player:sid") then
						return exports['since-notifications']:sendNotification(player, 'error', 'Podany gracz jest już twoim znajomym')
					end 
				end
			end

			if eldata then
				for i,v in ipairs(eldata) do
					if v.userdata == target then
						return exports['since-notifications']:sendNotification(player, 'error', 'Podany gracz posiada już aktywne od ciebie zaproszenie')
					end
				end

				table.insert(eldata, {userdata = target, tick = getTickCount()})
				setElementData(player, "friend_request", eldata)
				outputChatBox("#fffb00* #ffffffGracz #a9a9a9"..getPlayerName(player):gsub("#%x%x%x%x%x%x", "").." #ffffffwysłał Ci zaproszenie do znajomych. Aby je zaakceptować użyj #a9a9a9/zaproszenie.akceptuj "..id, target, 255, 255, 255, true)
				exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie wysłano zaproszenie do znajomych')
			else
				setElementData(player, "friend_request", {userdata = target, tick = getTickCount()})
				outputChatBox("#fffb00* #ffffffGracz #a9a9a9"..getPlayerName(player):gsub("#%x%x%x%x%x%x", "").." #ffffffwysłał Ci zaproszenie do znajomych. Aby je zaakceptować użyj #a9a9a9/zaproszenie.akceptuj "..id, target, 255, 255, 255, true)
				exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie wysłano zaproszenie do znajomych')
			end
		else
			exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza')
		end
	end
end

addEvent("removeFriendFromList", true)
addEventHandler("removeFriendFromList", resourceRoot, function(sid, login)
	local ttable = getElementData(client, "player:friends")
	if ttable then
		for i,v in ipairs(ttable) do
			if v[1] == sid then
				table.remove(ttable, i)
				break
			end
		end
		setElementData(client, "player:friends", ttable)
		exports["since-db"]:query("UPDATE `since-users` SET friends=? WHERE uid=?", toJSON(ttable), getElementData(client, "player:sid"))
		local target = exports["since-core"]:findPlayer(client, login)
		if target then
			local ttable3 = getElementData(target, "player:friends")
			if ttable3 then
				for i,v in ipairs(ttable3) do
					if v[1] == getElementData(client, "player:sid") then
						table.remove(ttable3, i)
						break
					end
				end
				setElementData(target, "player:friends", ttable3)
				exports["since-db"]:query("UPDATE `since-users` SET friends=? WHERE uid=?", toJSON(ttable3), sid)
			end
		else
			local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=? LIMIT 1", sid)
			if #result > 0 then
				local ttable2 = fromJSON(result[1].friends)
				if ttable2 then
					for i,v in ipairs(ttable2) do
						if v[1] == getElementData(client, "player:sid") then
							table.remove(ttable2, i)
							break
						end
					end
				end
				exports["since-db"]:query("UPDATE `since-users` SET friends=? WHERE uid=?", toJSON(ttable2), sid)
			end
		end
	end
end)

function findPlayerByID(plr, id)
	local cel = false

	for i,v in ipairs(getElementsByType('player')) do
		if tonumber(getElementData(v, 'id')) == tonumber(id) then
			cel = v
		end
	end

	return cel
end

addCommandHandler("zaproszenie.akceptuj", function(plr, cmd, id)
	if tonumber(id) then
		local target = findPlayerByID(plr, id)
		if target then
			local eldata = getElementData(target, "friend_request")
			if eldata then
				if eldata.userdata == plr then
					outputChatBox("#00ff00✔ #ffffffPomyślnie zaakceptowałeś zaproszenie do znajomych od gracza #a9a9a9"..getPlayerName(target):gsub("#%x%x%x%x%x%x", "").."", plr, 255, 255, 255, true)
					outputChatBox("#00ff00✔ #ffffffGracz #a9a9a9"..getPlayerName(plr):gsub("#%x%x%x%x%x%x", "").." #ffffffpomyślnie zaakceptował twoje zaproszenie do znajomych!", target, 255, 255, 255, true)

					table.remove(eldata, i)
					setElementData(target, "friend_request", eldata)

					if getElementData(target, "player:friends") then
						local ttable = getElementData(target, "player:friends")
						table.insert(ttable, {getElementData(plr, "player:sid")})
						setElementData(target, "player:friends", ttable)
					else
						local ttable = {}
						table.insert(ttable, {getElementData(plr, "player:sid")})
						setElementData(target, "player:friends", ttable)
					end

					if getElementData(plr, "player:friends") then
						local ttable = getElementData(plr, "player:friends")
						table.insert(ttable, {getElementData(target, "player:sid")})
						setElementData(plr, "player:friends", ttable)
					else
						local ttable = {}
						table.insert(ttable, {getElementData(target, "player:sid")})
						setElementData(plr, "player:friends", ttable)
					end

					exports["since-db"]:query("UPDATE `since-users` SET friends=? WHERE uid=?", toJSON(getElementData(target, "player:friends")), getElementData(target, "player:sid"))
					exports["since-db"]:query("UPDATE `since-users` SET friends=? WHERE uid=?", toJSON(getElementData(plr, "player:friends")), getElementData(plr, "player:sid"))
				end
			else
				outputChatBox("#ff0000✘ #ffffffGracz nie posiada aktywnego zaproszenia", plr, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000✘ #ffffffNie znaleziono podanego gracza!", plr, 255, 255, 255, true)
		end
	end
end)

function getDiamondDate(plr)
	local queryA = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid=? AND premium > NOW() LIMIT 1", getElementData(plr, "player:sid"))

	if (queryA and #queryA > 0) then
		return queryA[1].premium
	end

	return false	
end

function setDiamondDay(plr, days)
	if getDiamondDate(plr) then
		return exports['since-db']:query(string.format("UPDATE `since-users` SET premium = premium + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
	end

	exports['since-db']:query(string.format("UPDATE `since-users` SET premium = NOW() + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
end

function giveDiamondFromDiscordConnect(uid)
	exports['since-db']:query(string.format("UPDATE `since-users` SET premium = NOW() + INTERVAL %d DAY WHERE uid = %d", 3, uid))

	for i,v in ipairs(getElementsByType('player')) do
		if getElementData(v, 'player:sid') == uid then
			setElementData(v, 'player:diamond', true)

			outputChatBox(" ", v, 255, 255, 255, true)
			outputChatBox("#00ff00✔ #ffffffOtrzymujesz 3 dni konta Diamond za połączenie konta z naszym discordem!", v, 255, 255, 255, true)
			outputChatBox(" ", v, 255, 255, 255, true)
		end
	end
end

function givePromoReward(plr, type, value)
	if type == 'diamond' then
		setDiamondDay(plr, value)
		setElementData(plr, 'player:diamond', true)

		outputChatBox(" ", plr, 255, 255, 255, true)
		outputChatBox("#00ff00✔ #ffffffAktywowano konto Diamond na "..value.." dni.", plr, 255, 255, 255, true)
		outputChatBox(" ", plr, 255, 255, 255, true)
	elseif type == 'money' then
		givePlayerMoney(plr, value)

		outputChatBox(" ", plr, 255, 255, 255, true)
		outputChatBox("#00ff00✔ #ffffffOtrzymujesz "..value.." $.", plr, 255, 255, 255, true)
		outputChatBox(" ", plr, 255, 255, 255, true)
	elseif type == 'pp' then
		local playerData = getElementData(plr, 'player:pp') or 0
		setElementData(plr, 'player:pp', playerData + value)

		outputChatBox(" ", plr, 255, 255, 255, true)
		outputChatBox("#00ff00✔ #ffffffOtrzymujesz "..value.." PP.", plr, 255, 255, 255, true)
		outputChatBox(" ", plr, 255, 255, 255, true)
	end
end

local checkList = {

    ['buyBox'] = {},
    ['buyDiamond'] = {},

}

setTimer(function()
    for i,v in pairs(checkList) do
        for player, count in pairs(v) do
            v[player] = nil
        end
    end
end, 2000, 0)


function triggeringBan(player, info)
    local nick, serial, ip, versionNumber = getPlayerName(player), getPlayerSerial(player), getPlayerIP(player)
    writeOnDiscord('Antycheat', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)
    exports['since-logs']:sendDiscordLog('antycheat', 'AC', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)

    if serials[serial] then
      return
    end
    
    local text = ''..getPlayerName(player)..' ('..(getElementData(player, 'id') or 0)..') został zbanowany przez AntyCheat.'
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)
    
    banPlayer(player, true, false, true, root, 'Nie posiadasz dostępu do serwera.')

    if isElement(player) then
        kickPlayer(player, 'Nie posiadasz dostępu do serwera.')
    end
end

addEvent('buyDiamond', true)
addEventHandler('buyDiamond', resourceRoot, function(plr, cost, days)
	if not checkList['buyDiamond'][plr] then
        checkList['buyDiamond'][plr] = 0
    end
    checkList['buyDiamond'][plr] = checkList['buyDiamond'][plr] + 1

    if checkList['buyDiamond'][plr] >= 50 then triggeringBan(plr, 'since-dashboard spam kupnem diamond') return end

    local actualPoints = getElementData(client, "player:pp") or 0

	if actualPoints < cost then
		return
	end

    setElementData(client, "player:pp", actualPoints - cost)
	
	setDiamondDay(client, days)
	outputChatBox(" ", client, 0, 255, 0, true)
	local spr = exports["since-db"]:query("SELECT * from `since-users` WHERE uid=? LIMIT 1", getElementData(plr, "player:sid"))
	outputChatBox("✓ #ffffffZakupiono usługę #59acffDiamond#ffffff na okres #2E756F"..days.." dni#ffffff #bfbfbf(Ważne do "..spr[1].premium..")#ffffff", client, 0, 255, 0, true)
	outputChatBox(" ", client, 0, 255, 0, true)

	if not getElementData(client, 'player:diamond') then
		setElementData(client, "player:diamond", true)
	end
end)

local boxTypes = {

    ['box_bronze'] = 'bronze-box',
    ['box_silver'] = 'silver-box',
    ['box_gold'] = 'golden-box',
    ['box_diamond'] = 'diamond-box',
    ['box_legendary'] = 'legendary-box',
    ['box_car'] = 'car-box',

}

local colors = {

	['box_bronze'] = '#c4a000',
	['box_silver'] = '#c4c4c4',
	['box_gold'] = '#ffcc00',
	['box_diamond'] = '#59acff',
	['box_legendary'] = '#f94dff',
	['box_car'] = '#00ff00',

}

addEvent('buyBox', true)
addEventHandler('buyBox', resourceRoot, function(plr, cost, name, token)
	if not checkList['buyBox'][plr] then
        checkList['buyBox'][plr] = 0
    end
    checkList['buyBox'][plr] = checkList['buyBox'][plr] + 1

    if checkList['buyBox'][plr] >= 50 then triggeringBan(plr, 'since-dashboard spam kupnem boxów') return end

    local actualPoints = getElementData(client, "player:pp") or 0

	if actualPoints < cost then
		return
	end

    setElementData(client, "player:pp", actualPoints - cost)

	exports['since-inventory']:addPlayerItem(client, boxTypes[token], 1)
	
	outputChatBox(" ", client, 0, 255, 0, true)
	local color = colors[token]
	outputChatBox("✓ #ffffffZakupiono "..color..""..name.."#ffffff.", client, 0, 255, 0, true)
	outputChatBox(" ", client, 0, 255, 0, true)
end)

addEventHandler('onPlayerQuit', root, function()
    if checkList['buyBox'][source] then
        checkList['buyBox'][source] = nil
    end

	if checkList['buyDiamond'][source] then
		checkList['buyDiamond'][source] = nil
	end
end)

local items = {

	['rainbownick'] = {

		func = function(plr, token)
			local playerData = getElementData(plr, 'player:data') or {}
			playerData[token] = true
			setElementData(plr, 'player:data', playerData)
		end,

	}

}

addEvent('buyDashboardItem', true)
addEventHandler('buyDashboardItem', resourceRoot, function(plr, cost, token, name)
    if items[token] then
		local actualPoints = getElementData(client, "player:pp") or 0

		if actualPoints < cost then
			return
		end

		local playerData = getElementData(client, 'player:data') or {}

		if playerData[token] then
			return outputChatBox("✘ #ffffffPosiadasz już zakupioną usługę #c4c4c4"..name.."#ffffff", client, 255, 0, 0, true)
		end

    	setElementData(client, "player:pp", actualPoints - cost)

		items[token].func(client, token)

		outputChatBox(" ", client, 0, 255, 0, true)
		outputChatBox("✓ #ffffffZakupiono usługę #c4c4c4"..name.."#ffffff", client, 0, 255, 0, true)
		outputChatBox(" ", client, 0, 255, 0, true)
	end
end)

addEvent('loadDailyQuestData', true)
addEventHandler('loadDailyQuestData', resourceRoot, function()
	if not getElementData(client, 'player:sid') then return end
	exports['since-dailyQuests']:loadQuestData(client)
end)

addEvent('collectDailyReward', true)
addEventHandler('collectDailyReward', resourceRoot, function()
	if not getElementData(client, 'player:sid') then return end
	exports['since-dailyQuests']:collectReward(client)
end)

addEvent('exchangeSummerEventPoints', true)
addEventHandler('exchangeSummerEventPoints', resourceRoot, function(exchangeType, points, value)
	if not getElementData(client, 'player:sid') then return end
	local playerData = getElementData(client, "player:data") or {}

	if not playerData.halloweenPoints then
		playerData.halloweenPoints = 0
	end

	if playerData.halloweenPoints < points then
		return
	end

	playerData.halloweenPoints = playerData.halloweenPoints - points

	setElementData(client, 'player:data', playerData)

	if exchangeType == 'money' then
		exports['since-db']:query("UPDATE `since-users` SET bankMoney = bankMoney + ? WHERE uid = ?", value, getElementData(client, 'player:sid'))
		exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie wymieniono '..addCommas(points)..' punktów eventu na '..addCommas(value)..' $.')
		exports['since-logs']:sendDiscordLog('event', getPlayerName(client), 'Wymieniono '..addCommas(points)..' punktów eventu na '..addCommas(value)..' $ (SID: '..getElementData(client, 'player:sid')..')')
	elseif exchangeType == 'pp' then
		setElementData(client, 'player:pp', (getElementData(client, 'player:pp') or 0) + value)
		exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie wymieniono '..addCommas(points)..' punktów eventu na '..addCommas(value)..' PP.')
		exports['since-logs']:sendDiscordLog('event', getPlayerName(client), 'Wymieniono '..addCommas(points)..' punktów eventu na '..addCommas(value)..' PP (SID: '..getElementData(client, 'player:sid')..')')
	elseif exchangeType == 'wpln' then
		exports['since-db']:query("UPDATE `since-users` SET wpln = wpln + ? WHERE uid = ?", value, getElementData(client, 'player:sid'))
		exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie wymieniono '..addCommas(points)..' punktów eventu na '..addCommas(value)..' wPLN.')
		exports['since-logs']:sendDiscordLog('event', getPlayerName(client), 'Wymieniono '..addCommas(points)..' punktów eventu na '..addCommas(value)..' wPLN. (SID: '..getElementData(client, 'player:sid')..')')
	end
end)