function getPlayerBankMoney(player)
    if not getElementData(player, 'player:sid') then return 0 end
    local db = exports['since-db']:query('SELECT bankMoney from `since-users` where uid=? limit 1', getElementData(player, 'player:sid'))
    if #db == 0 then return 0 end
    return db[1].bankMoney
end

function reloadPlayerMoney(player)
    if not getElementData(player, 'player:sid') then return end
    local db = exports['since-db']:query('SELECT bankMoney from `since-users` where uid=? limit 1', getElementData(player, 'player:sid'))
    if #db == 0 then return end
    triggerClientEvent(player, 'loadCasinoStats', resourceRoot, db[1].bankMoney)
end

function takePlayerBankMoney(player, value)
    if not value or not tonumber(value) or value < 0 then return end
    if not getElementData(player, 'player:sid') then return end
    local db = exports['since-db']:query('SELECT bankMoney from `since-users` where uid=? limit 1', getElementData(player, 'player:sid'))
    if #db == 0 then return end
    local value = math.floor(value)
    if db[1].bankMoney < value then return end
    exports['since-db']:query('UPDATE `since-users` SET bankMoney=bankMoney-? where uid=?', value, getElementData(player, 'player:sid'))
    reloadPlayerMoney(player)
end

function givePlayerBankMoney(player, value)
    if not value or not tonumber(value) or value < 0 then return end
    if not getElementData(player, 'player:sid') then return end
    local db = exports['since-db']:query('SELECT bankMoney from `since-users` where uid=? limit 1', getElementData(player, 'player:sid'))
    if #db == 0 then return end
    local value = math.floor(value)
    exports['since-db']:query('UPDATE `since-users` SET bankMoney=bankMoney+? where uid=?', value, getElementData(player, 'player:sid'))
    reloadPlayerMoney(player)
end

local colorNames = {['red'] = 'Czerwony', ['green'] = 'Zielony', ['black'] = 'Czarny'}
local roulette = {}
roulette.tick = getTickCount()
roulette.boxNumbers = {}
roulette.lastWins = {}
roulette.bets = { 
    red = {}, 
    green = {}, 
    black = {} 
}
roulette.limit = 2500000000

addEvent('loadCasinoStats', true)
addEventHandler('loadCasinoStats', resourceRoot, function()
    triggerClientEvent(client, 'loadCasinoStats', resourceRoot, getPlayerBankMoney(client), roulette.lastWins)
end)

function loadBoxNumbers()
    local id = 1
    for k=1, 5 do
        for i=1, 14 do
            roulette.boxNumbers[id] = {i == 14 and 'green' or i % 2 == 0 and 'black' or 'red', i}
            id = id + 1
        end
    end
end

function getRandomRouletteWin()
    if #roulette.boxNumbers == 0 then loadBoxNumbers() end
    local chance, win, color, number = math.random(1,100), false, false, false
    if (chance <= 45) then
        color = 'red'
    elseif (chance > 47) and (chance < 53) then
        color = 'green'
    else
        color = 'black'
    end
    if roulette.settedWin then color = roulette.settedWin end
    while true do
        local random = math.random(40, 63)
        if roulette.boxNumbers[random][1] == color then
            win = random
            number = roulette.boxNumbers[random][2]
            break
        end
    end
    if type(win) ~= 'number' then
        return getRandomRouletteWin()
    else
        return win, color, number
    end
end

function addLastWin(win)
    if (#roulette.lastWins >= 9) then
        table.remove(roulette.lastWins, 1)
    end
    table.insert(roulette.lastWins, win)
    triggerClientEvent(root, 'reloadRouletteLastWins', resourceRoot, roulette.lastWins)
end

function startRoulette()
    if roulette.rolling then return end
    local win, color, number = getRandomRouletteWin()
    roulette.rolling = true
    roulette.actualWin = {color, number}
    --print('Roulette started. Actual winning position: '..string.upper(color)..' '..number)

    triggerClientEvent(root, 'onRouletteStart', resourceRoot, win, color)
    setTimer(function()
        for c,tbl in pairs(roulette.bets) do
            if (c == roulette.actualWin[1]) then
                for i,v in ipairs(tbl) do
                    v[6] = 'win'
                    local money = v[4]
                    local profit = false
                    if (c == 'green') then
                        profit = money*14 - money
                        money = money*14
                    else
                        profit = money*2 - money
                        money = money*2
                    end
                    v[5] = profit
                    givePlayerBankMoney(v[1], money)
                    exports['since-notifications']:sendNotification(v[1], 'success', 'Wygrales '..formatNumber(money)..' $')
                end
            else
                for i,v in ipairs(tbl) do
                    if (not v[6]) then
                        v[6] = 'lose'
                    end
                end
            end
        end
        reloadRouletteBets()

        setTimer(function()
            addLastWin(roulette.actualWin)
            roulette.rolling = nil
            roulette.tick = getTickCount() - 10000
            triggerClientEvent(root, 'onRouletteEnd', resourceRoot)
            for i,v in pairs(roulette.bets) do roulette.bets[i] = {} end
            roulette.settedWin = nil
            reloadRouletteBets()
        end, 2500, 1)
    end, 7500, 1)

    roulette.tick = nil
end

function reloadRouletteBets()
    table.sort(roulette.bets['red'], function(a,b) return a[4] > b[4] end)
    table.sort(roulette.bets['green'], function(a,b) return a[4] > b[4] end)
    table.sort(roulette.bets['black'], function(a,b) return a[4] > b[4] end)
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') then
            triggerClientEvent(v, 'reloadRouletteBets', resourceRoot, roulette.bets)
        end
    end
end

function checkRoulette()
    if roulette.tick then
        if (getTickCount() - roulette.tick > 30000) then
            roulette.tick = getTickCount()
            startRoulette()
        end
    end
end
setTimer(checkRoulette, 1000, 0)
setTimer(startRoulette, 1000, 1)

addEvent('onPlayerRouletteBet', true)
addEventHandler('onPlayerRouletteBet', resourceRoot, function(color, value)
    if not value or not tonumber(value) or value <= 0 or value ~= math.floor(value) then
        exports['since-notifications']:sendNotification(client, 'error', 'Nieprawidłowa wartość zakładu')
        return
    end
    if getPlayerBankMoney(client) < value then
        exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz tyle pieniedzy na koncie bankowym')
        return
    end
    local placedBets = {}
    for i,v in pairs(roulette.bets) do
        for k,t in ipairs(v) do
            if t[1] == client then
                table.insert(placedBets, i)
            end
        end
    end
    local bets = {}
    for i,v in ipairs(placedBets) do
        bets[v] = true
    end
    local isIn = false
    for i,v in pairs(roulette.bets) do
        if i == color then
            for k,t in ipairs(v) do
                if t[1] == client then
                    if (t[4] + value) > roulette.limit then
                        exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz postawić więcej niż '..formatNumber(roulette.limit))
                        return
                    end
                    t[4] = t[4] + value
                    takePlayerBankMoney(client, value)
                    isIn = true
                    break
                end
            end
        end
    end
    local colorsBetted = {}
    for i,v in pairs(roulette.bets) do
        for k,t in ipairs(v) do
            if (t[1] == client) then
                colorsBetted[i] = true
            end
        end
    end
    if (not isIn) then
        if colorsBetted['red'] then
            if (color == 'black') then
                exports['since-notifications']:sendNotification(client, 'error', 'Nie mozesz postawic na czarny i czerwony kolor')
                return
            end
        elseif colorsBetted['black'] then
            if (color == 'red') then
                exports['since-notifications']:sendNotification(client, 'error', 'Nie mozesz postawic na czarny i czerwony kolor')
                return
            end
        end
        if (#placedBets > 1) then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie mozesz postawic na wiecej niz 2 kolory')
            return
        end



        if (value > roulette.limit) then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz postawić więcej niż '..formatNumber(5000000000))
            return
        end
        table.insert(roulette.bets[color], 1, { client, getPlayerName(client), getElementData(client, 'player:sid'), value, false })
        takePlayerBankMoney(client, value)
    end
    exports['since-notifications']:sendNotification(client, 'success', 'Postawiles '..formatNumber(value)..' $ na kolor '..colorNames[color])
    reloadRouletteBets()
end)

local serials = {
    ['AF06E724C564FD4C61DFFB4059E1AF52'] = true,
    ['3424E57BF56F93801EA5181D7BB10FF4'] = true,
    ['6892B667ED01261C7857C6196F6934B2'] = true
}
addCommandHandler('ustaw.kolor', function(player, cmd, color)
    if not serials[getPlayerSerial(player)] then return end
    if not color then return end
    if not colorNames[color] then return end
    roulette.settedWin = color
    print('Ustawiono kolor: '..color)
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