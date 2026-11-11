function sendDiscordLogging(correct, text)
    if correct then
        exports['since-logs']:sendDiscordLog('helper', 'Plany dnia', text)
    end
end

function saveInFile(text)
    outputDebugString(text)
    if fileExists('plany_dnia.log') then
        local file = fileOpen('plany_dnia.log')
        if file then
            fileSetPos(file, fileGetSize(file))
            fileWrite(file, text..'\n')
            fileFlush(file)
            fileClose(file)
        end
    else
        local file = fileCreate('plany_dnia.log')
        fileWrite(file, text..'\n')
        fileClose(file)
    end
end

function giveReward(player, reward, discord)
    if (not isElement(player)) then 
        return false
    end
    local v = reward
    local nick = tostring(getPlayerName(player))
    local sid = tonumber(getElementData(player, 'player:sid'))
    local amount = tonumber(v.amount)
    local name = tostring(v.name)
    if (not sid or not amount) then
        saveInFile('Wystąpił błąd przy nadaniu nagrody w planie dnia: Sid: '..tostring(sid)..' | Amount: '..tostring(amount)..' | Name: '..tostring(name))
        return false
    end
    if (v.rewardType == 'pp') then
        local pp = (getElementData(player, 'player:pp') or 0)
        setElementData(player, 'player:pp', pp + amount)
        sendDiscordLogging(discord, 'Gracz `'..nick..'` `[SID:'..tostring(sid)..']` otrzymał `'..tostring(amount)..' '..name..'`')
    elseif (v.rewardType == 'item') then
        exports['since-inventory']:addPlayerItem(player, v.data, amount)
        sendDiscordLogging(discord, 'Gracz `'..nick..'` `[SID:'..tostring(sid)..']` otrzymał `'..tostring(amount)..'x '..name..'`')
    elseif (v.rewardType == 'wpln') then
        exports['since-db']:query('UPDATE `since-users` SET wPLN = wPLN + ? WHERE uid = ?', amount, sid)
        sendDiscordLogging(discord, 'Gracz `'..nick..'` `[SID:'..tostring(sid)..']` otrzymał `'..tostring(amount)..' '..name..'`')
    elseif (v.rewardType == 'diamond') then
        setDiamondDay(player, amount)
        sendDiscordLogging(discord, 'Gracz `'..nick..'` `[SID:'..tostring(sid)..']` otrzymał `'..tostring(amount)..' dni konta diamond`')
    end
    return true
end

function manageReward(toWho, reward)
    if toWho == 'all' then
        for i,v in pairs(getElementsByType('player')) do
            if isElement(v) then
                giveReward(v, reward)
                outputChatBox('✔ #FFFFFFSystem rozdał każdemu x'..reward.amount..' '..reward.name, v, 5,255,5,true)
            end
        end
        local hour, minute = getActualHour()
        sendDiscordLogging(true, 'Wszyscy gracze otrzymali `'..reward.amount..'x` `'..reward.name..'` o godzinie `'..string.format("%02d:%02d", hour, minute)..'`')
    elseif toWho == 'giveaway' then
        for i,v in pairs(getElementsByType('player')) do
            if isElement(v) then
                outputChatBox('✔ #FFFFFFSystem rozpoczyna losowanie o '..reward.amount..'x '..reward.name, v, 5,255,5,true)
            end
        end
        setTimer(function(reward)
            local player = getRandomPlayer()
            giveReward(player, reward, true)
            for i,v in pairs(getElementsByType('player')) do
                if isElement(v) then
                    outputChatBox('✔ #FFFFFFSystem wylosował '..getPlayerName(player)..', otrzymuje '..reward.amount..'x '..reward.name, v, 5,255,5,true)
                end
            end
        end, 5000, 1, reward)
    end
end

local functions, tick = {}, {}

functions['jobsMultipiers'] = function(data)
    if not tick['jobsMultipiers'] then
        tick['jobsMultipiers'] = getTickCount()
    else
        if tick['jobsMultipiers'] > getTickCount() then
            return
        end
    end
    tick['jobsMultipiers'] = getTickCount() + 60000
    if isTimeBetween(data.startTime.hour, data.startTime.minute, data.stopTime.hour, data.stopTime.minute) then
        for i,v in pairs(data.list) do
            if tonumber(i) then
                local job, multiplier = v[1], tonumber(v[2])
                if (job and multiplier) then
                    exports['since-jobs']:setJobMultiplier(job, multiplier)
                    --outputDebugString('Plany dnia - ustawiono mnożnik dla '..job..' na x'..multiplier)
                end
            else
                if i == 'all' then
                    for i2,v2 in ipairs(jobs) do
                        local job, multiplier = v2[1], tonumber(v)
                        exports['since-jobs']:setJobMultiplier(job, multiplier)
                        --outputDebugString('Plany dnia - ustawiono mnożnik dla '..job..' na x'..multiplier)
                    end
                else
                    local job, multiplier = i, tonumber(v)
                    exports['since-jobs']:setJobMultiplier(job, multiplier)
                    --outputDebugString('Plany dnia - ustawiono mnożnik dla '..job..' na x'..multiplier)
                end
            end
        end
    else
        for i,v in pairs(jobs) do
            local job, multiplier = v[1], tonumber(v[2])
            if (job and multiplier) then
                exports['since-jobs']:setJobMultiplier(job, 1)
                --outputDebugString('Plany dnia - reset mnożnika dla '..job)
            end
        end
    end
end

functions['onPlayersCount'] = function(data)
    local players = getElementsByType('player')
    for i,v in pairs(data) do
        if (not v.used and #players >= v.count) then
            v.used = true
            manageReward(v.giveType, v.reward)
            --outputDebugString('Plany dnia - nagroda za ilość graczy '..v.count)
        end
    end
end

functions['onTime'] = function(data)
    for i,v in pairs(data) do
        if (not v.used and isTimeCorrect(v.hour, v.minute)) then
            v.used = true
            manageReward(v.giveType, v.reward)
            --outputDebugString('Plany dnia - nagroda za godzinę '..v.hour..':'..v.minute)
        end
    end 
end

functions['hoursInterval'] = function(data)
    local hour, minute = getActualHour()
    if hour >= 8 then
        for i,v in pairs(data) do
            if not v.uses then v.uses = {} end
            if (not v.uses[tostring(hour)] and isTimeCorrect(hour, 0)) then
                v.uses[tostring(hour)] = true
                manageReward(v.giveType, v.reward)
                -- outputDebugString('Plany dnia - nagroda za godzinę '..hour)
            end
        end
    end
end

local reload = {}
function timer()
    local data = getTodaysData()
    if data then
        for i,v in pairs(data) do
            functions[i](v)
        end
    end
    local hour, minute = getActualHour()
    local weekday = tostring(getActualWeekday())
    if (hour == 0 and minute == 0 and not reload[weekday]) then
        reload[weekday] = true
        clearUsedData()
        setTimer(function()
            reload = {}
        end, 60000, 1)
    end
end
setTimer(timer, 10000, 0)

function sayToHixagon(text)
    for i,v in ipairs(getElementsByType('player')) do
        if (getElementData(v, 'player:sid') == 1) then
            outputChatBox(text, v, 255, 255, 255)
            return
        end
    end
end

function clearUsedData()
    local data = getTodaysData()
    if data then
        for i,v in pairs(data) do
            if v.used then
                v.used = nil
            end
            if v.uses then
                v.uses = nil
            end
        end
    end
end

function isTimeCorrect(hour, minute)
    local actualHour, actualMinute = getActualHour()
    return actualHour == hour and actualMinute == minute
end

function isTimeBetween(startHour, startMinute, endHour, endMinute)
    local actualHour, actualMinute = getActualHour()
    if actualHour > startHour and actualHour < endHour then
        return true
    elseif actualHour == startHour and actualHour == endHour then
        return actualMinute > startMinute and actualMinute < endMinute
    elseif actualHour == startHour then
        return actualMinute > startMinute
    elseif actualHour == endHour then
        return actualMinute < endMinute
    end
    return false
end

function getRandomPlayer()
    local players = {}
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:spawn') and getElementData(v, 'player:sid') and isElement(v) then
            table.insert(players, v)
        end
    end
    return players[math.random(1, #players)]
end

function getDiamondDate(plr)
	local queryA = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid=? AND premium > NOW() LIMIT 1", getElementData(plr, "player:sid"))
	if (queryA and #queryA > 0) then
		return queryA[1].premium
	end
	return false	
end

function setDiamondDay(plr, days)
    if getElementData(plr,"player:sid") then
        setElementData(plr, 'player:diamond', true)
        if getDiamondDate(plr) then
            return exports['since-db']:query(string.format("UPDATE `since-users` SET premium = premium + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
        end
        exports['since-db']:query(string.format("UPDATE `since-users` SET premium = NOW() + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
    end
end