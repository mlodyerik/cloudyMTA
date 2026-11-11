  

local col = createColCuboid(1918.57, 963.45, 987.88, 106.89, 111.98, 21.40)
setElementDimension(col,0)
setElementInterior(col,10)

local Ped = createPed(12, 1953.79, 1018.09, 992.47)
setElementRotation(Ped, 0,0,270)
setElementDimension(Ped, 0)
setElementInterior(Ped, 10)
setElementFrozen(Ped, true)

addEventHandler("onColShapeHit", col, function(hit, dim)
	if getElementType(hit) == "player" then
		if getPedOccupiedVehicle(hit) then
            return false 
        end

		local sid = getElementData(hit, "player:sid")
		if not tonumber(sid) then 
            return false 
        end			

        if getElementDimension(hit) == 0 then
		    local result = exports['since-db']:query("SELECT * FROM `since-casino` WHERE sid=?", sid)
		    if result and #result > 0 then	
		    	setElementData(hit, "client:coin", tonumber(result[1].zetony))
		    else
		    	exports['since-db']:query("INSERT INTO `since-casino` (sid) VALUES (?)", sid)	
		    	setElementData(hit, "client:coin", 0)
		    end
        end
	end 
end)

addEventHandler("onColShapeLeave", col, function(hit, dim)
	if getElementType(hit) == "player" then
		setElementData(hit, "client:coin", false)
	end
end)


local positions = {
    {1968.20, 1029.06, 992.47, 3},
    {1968.07, 1021.79, 992.47, 3},
    {1967.98, 1014.15, 991.57, 3},
    {1968.21, 1006.30, 992.47, 3},
}

for i,v in ipairs(positions) do
    local col = createColSphere(v[1], v[2], v[3], v[4])
end

local tick = getTickCount()

addEventHandler("onColShapeHit", resourceRoot, function(hit, dim)
    if getElementType(hit) == "player" then
        if source == col then
            return false
        end

        if not isPedInVehicle(hit) then
            if tick then
                triggerClientEvent(hit, "enonek-casino:toggleUI", resourceRoot, true, getTickCount() - tick)
            else
                triggerClientEvent(hit, "enonek-casino:toggleUI", resourceRoot, true, false)
            end
        end
    end
end)

local last_wins = {}

function addToLastWins(texture)
    if #last_wins == 10 then
        table.remove(last_wins, 1)
    end

    table.insert(last_wins, texture)

    if texture == 6 then
        win = "black"
    elseif texture == 7 then
        win = "green"
    else
        win = "red"
    end

    --outputDebugString("KASYNO: WYLOSOWANY KOLOR "..win, 0, 227, 5, 227)
end

bets = {["red"] = {}, ["green"]={}, ["black"] = {}}

setTimer(function()
    if tick then
        if getTickCount() - tick >= 15000 then
            if ustawionybet then
                percent = tonumber(ustawionybet)
            else
                percent = math.random(1, 100)
            end
            if not random_textures then
                local random_textures = {}
                for i=1,300 do
                    table.insert(random_textures, {math.random(15, 17), alpha=0})
                end

                if percent < 50 then
                    for i=1,150 do
                        if random_textures[i+100][1] == 15 then
                            index_textures = i+100
                            break
                        end
                    end
                    addToLastWins(15-9)
                elseif percent > 49 and percent < 99 then
                    for i=1,150 do
                        if random_textures[i+100][1] == 17 then
                            index_textures = i+100
                            break
                        end
                    end
                    addToLastWins(17-9)
                elseif percent > 98 then
                    for i=1,150 do
                        if random_textures[i+100][1] == 16 then
                            index_textures = i+100
                            break
                        end
                    end
                    addToLastWins(16-9)
                end
                triggerClientEvent(root, "enonek-casino:start", resourceRoot, index_textures, random_textures)
            else
                if percent < 50 then
                    for i=1,150 do
                        if random_textures[i+100][1] == 15 then
                            index_textures = i+100
                            break
                        end
                    end
                    addToLastWins(15-9)
                elseif percent > 49 and percent < 99 then
                    for i=1,150 do
                        if random_textures[i+100][1] == 17 then
                            index_textures = i+100
                            break
                        end
                    end
                    addToLastWins(17-9)
                elseif percent > 98 then
                    for i=1,150 do
                        if random_textures[i+100][1] == 16 then
                            index_textures = i+100
                            break
                        end
                    end
                    addToLastWins(16-9)
                end

                triggerClientEvent(root, "enonek-casino:start", resourceRoot, index_textures, false)
            end
            tick = false
            ustawionybet = false
            setTimer(function()
                triggerClientEvent(root, "enonek-casino:podsumowanie", resourceRoot, win)
                ustawionybet = false
                for i,v in ipairs(bets[win]) do
                    if isElement(v[1]) then
                        if getElementData(v[1], "client:coin") then
                            local coin = getElementData(v[1], "client:coin")
                            if win == "green" then
                                setElementData(v[1], "client:coin", (coin+(v[2]*14)))
                            else
                                setElementData(v[1], "client:coin", (coin+(v[2]*2)))
                            end
                            exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(v[1], "client:coin"), getElementData(v[1],"player:sid"))
                        end
                    end
                end
                bets = {["red"] = {}, ["green"]={}, ["black"] = {}}
            end, 8000, 1)
            setTimer(function()
                random_textures = {}
                for i=1,300 do
                    table.insert(random_textures, {math.random(15, 17), alpha=0})
                end
                tick = getTickCount()
                triggerClientEvent(root, "enonek-casino:end", resourceRoot, random_textures, index_textures, getTickCount() - tick, last_wins)
            end, 15000, 1)
        end
    end
end, 1000, 0)

addCommandHandler("ustaw.bet", function(plr, cmd, color)
    if getElementData(plr, "player:admin") == 4 then
        if not color then
            outputChatBox("/ustaw.bet <red: 50-99, black: 2-49, green-99)>", plr)
            return false
        end
        ustawionybet = color
    end
end)

addCommandHandler("inspectbet", function(plr, cmd)
    if getElementData(plr, "player:admin") == 4 then
        outputConsole(inspect(bets), plr)
    end
end)

local coinflip_games = {}

function check_games()
    for i,v in ipairs(coinflip_games) do
        if getTickCount() - v[4] >= 300000 then
            triggerClientEvent(root, "enonek-casino:client:deleteGame", resourceRoot, v[1], v[2], v[3])
            table.remove(coinflip_games, i)
            exports['since-db']:query("UPDATE `since-casino` SET zetony=zetony+? WHERE sid=?", v[3], v[5])
            if isElement(v[2]) then
                setElementData(v[2], "client:coin", (getElementData(v[2], "client:coin")+v[3]))
            end
        end
    end
end
setTimer(check_games, 5000, 0)

local strony = {
    [1] = "black",
    [2] = "red",
}

timers = {[1] = {}, [2] = {}} -- {player, bet, color, clp}

function endCoinFlip(player, target, bet)
    triggerClientEvent(player, "enonek-casino:client:gameEnd", resourceRoot, player, false)
    triggerClientEvent(target, "enonek-casino:client:gameEnd", resourceRoot, player, false)

    setElementData(player, 'client:coin', (getElementData(player, 'client:coin') + bet))
    setElementData(target, 'client:coin', (getElementData(target, 'client:coin') + bet))

    if timers[1][player] then
        killTimer(timers[1][player])
    end

    if timers[2][player] then
        killTimer(timers[2][player])
    end

    if timers[1][target] then
        killTimer(timers[1][target])
    end

    if timers[2][target] then
        killTimer(timers[2][target])
    end

    setElementData(player, 'player:coinflipData', false)
    setElementData(target, 'player:coinflipData', false)
end

addEventHandler("onPlayerQuit", root, function()
    local data = getElementData(source, 'player:coinflipData')

    if not data then return end

    endCoinFlip(source, data[1], data[2])
end)

addEvent("enonek-coinflip:joinGame", true)
addEventHandler("enonek-coinflip:joinGame", resourceRoot, function(playerdata)
    for i,v in ipairs(coinflip_games) do
        if isElement(v[2]) then
            if v[2] == playerdata then
                if getElementData(client, "client:coin") >= v[3] then
                    local randomwin = math.random(1, 2)
                    if v[1] == strony[randomwin] then
                        timers[1][client] = setTimer(function(player, bet, color, clp)
                            if player then
                                setElementData(player, "client:coin", (getElementData(player, "client:coin")+bet*2))
                                exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(player, "client:coin"), getElementData(player, "player:sid"))
                                exports['since-logs']:sendDiscordLog('kasyno', 'Kasyno', 'Gracz **'..getPlayerName(player)..'** wygrał coinflipa o **'..formatNumber(bet)..'** x2 zetonów **#'..v[6]..'**.')
                                print("COINFLIP WIN: "..inspect(player))
                                triggerClientEvent(player, "enonek-casino:client:gameEnd", resourceRoot, player, color)
                                triggerClientEvent(clp, "enonek-casino:client:gameEnd", resourceRoot, player, color)

                                setElementData(player, 'player:coinflipData', false)
                                setElementData(clp, 'player:coinflipData', false)
                            end
                        end, 5000, 1, v[2], v[3], strony[randomwin], client)
                    else
                        timers[2][client] = setTimer(function(player, bet, color, clp)
                            if clp then
                                setElementData(clp, "client:coin", (getElementData(clp, "client:coin")+bet*2))
                                exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(clp, "client:coin"), getElementData(clp, "player:sid"))
                                exports['since-logs']:sendDiscordLog('kasyno', 'Kasyno', 'Gracz **'..getPlayerName(clp)..'** wygrał coinflipa o **'..formatNumber(bet)..'** x2 zetonów **#'..v[6]..'**.')
                                print("COINFLIP WIN: "..inspect(clp))
                            end
                            triggerClientEvent(player, "enonek-casino:client:gameEnd", resourceRoot, player, color)
                            triggerClientEvent(clp, "enonek-casino:client:gameEnd", resourceRoot, player, color)


                            setElementData(player, 'player:coinflipData', false)
                            setElementData(clp, 'player:coinflipData', false)
                        end, 5000, 1, v[2], v[3], strony[randomwin], client)
                    end
                    setElementData(client, 'player:coinflipData', {v[2], v[3]})
                    setElementData(v[2], 'player:coinflipData', {client, v[3]})

                    triggerClientEvent(client, "enonek-casino:client:startGame", resourceRoot, v[1], getPlayerName(v[2]):gsub("#%x%x%x%x%x%x", ""), v[3], v[2], client)
                    triggerClientEvent(v[2], "enonek-casino:client:startGame", resourceRoot, v[1], getPlayerName(v[2]):gsub("#%x%x%x%x%x%x", ""), v[3], v[2], client)
                    triggerClientEvent(root, "enonek-casino:client:deleteGame", resourceRoot, v[1], v[2], v[3])
                    setElementData(client, "client:coin", (getElementData(client, "client:coin")-v[3]))
                    exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))
                    exports['since-logs']:sendDiscordLog('kasyno', 'Kasyno', 'Gracz **'..getPlayerName(client)..'** dołącza do coinflipa o **'..formatNumber(coinflip_games[i][3])..'** zetonów **#'..coinflip_games[i][6]..'**.')
                    table.remove(coinflip_games, i)
                end
            end
        end
    end
end)

addEvent("enonek-casino:addGame", true)
addEventHandler("enonek-casino:addGame", resourceRoot, function(strona, bet)
    for i,v in ipairs(coinflip_games) do
        if v[2] == client then
            return false
        end
    end

    local randomID = math.random(0,100000)
    table.insert(coinflip_games, {strona, client, bet, getTickCount(), getElementData(client, "player:sid"), randomID})

    if getElementData(client, "client:coin") >= bet then
        triggerClientEvent(root, "enonek-casino:client:addGame", resourceRoot, strona, getPlayerName(client):gsub("#%x%x%x%x%x%x", ""), bet, client)
        setElementData(client, "client:coin", (getElementData(client, "client:coin")-bet))
        exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))

        exports['since-logs']:sendDiscordLog('kasyno', 'Kasyno', 'Gracz **'..getPlayerName(client)..'** stworzył coinflipa o **'..formatNumber(bet)..'** zetonów **#'..randomID..'**.')
    end
end)

addEvent("enonek-casino:addBet", true)
addEventHandler("enonek-casino:addBet", resourceRoot, function(color, bet)
    if not tick then
        return false
    end

    for i,v in ipairs(bets[color]) do
        if v[1] == client then
            return false
        end
    end

    if color == "black" then
        for i,v in ipairs(bets["red"]) do
            if v[1] == client then
                return false
            end
        end
    elseif color == "red" then
        for i,v in ipairs(bets["black"]) do
            if v[1] == client then
                return false
            end
        end
    end

    triggerClientEvent(root, "enonek-casino:client:addBet", resourceRoot, getPlayerName(client):gsub("#%x%x%x%x%x%x", ""), color, bet, client)
    table.insert(bets[color], {client, bet})
    setElementData(client, "client:coin", (getElementData(client, "client:coin")-bet))
    exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))
end)

addEvent('betSlots', true)
addEventHandler('betSlots', resourceRoot, function(value)
    local data = getElementData(client, 'client:coin')
    if not data then return end
    if data < value then exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz '..formatNumber(value)..' żetonów') return end
    setElementData(client, "client:coin", (getElementData(client, "client:coin")-value))
    exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))
    triggerClientEvent(client, 'spinSlots', resourceRoot)
end)

addEvent('winSlots', true)
addEventHandler('winSlots', resourceRoot, function(value)
    setElementData(client, "client:coin", (getElementData(client, "client:coin")+value))
    exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))
end)

addEvent('betMines', true)
addEventHandler('betMines', resourceRoot, function(value, mines)
    local data = getElementData(client, 'client:coin')
    if not data then return end
    if data < value then exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz '..formatNumber(value)..' żetonów') return end
    setElementData(client, "client:coin", (getElementData(client, "client:coin")-value))
    exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))
    triggerClientEvent(client, 'onMinesStart', resourceRoot, mines or 1)
end)

addEvent('withdrawMines', true)
addEventHandler('withdrawMines', resourceRoot, function(value, multiplier)
    local data = getElementData(client, 'client:coin')
    if not data then return end
    local value = math.floor(value * multiplier)
    setElementData(client, "client:coin", (getElementData(client, "client:coin")+value))
    exports['since-db']:query("UPDATE `since-casino` SET zetony=? WHERE sid=?", getElementData(client, "client:coin"), getElementData(client, "player:sid"))
    triggerClientEvent(client, 'onMinesStop', resourceRoot)
end)

addEventHandler("onColShapeLeave", resourceRoot, function(hit, dim)
    if getElementType(hit) == "player" then
        if source == col then
            return false
        end

        triggerClientEvent(hit, "enonek-casino:toggleUI", resourceRoot, false)
    end
end)

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end