function getRandomQuest(lastQuest)
    local quest = nil
    if lastQuest then
        while true do
            local random = math.random(#quests)
            if random ~= lastQuest then
                quest = random
                break
            end
        end
    else
        quest = math.random(#quests) 
    end
    return quest
end

function checkDateIsInRow(date)
    local tomorrowDate = exports['since-db']:query('SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS tomorrowDate')[1].tomorrowDate
    return tomorrowDate == date and true or false
end

function checkIsDateActual(date)
    local time = getRealTime()
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    local formattedTime = string.format("%04d-%02d-%02d", year + 1900, month + 1, monthday)
    return formattedTime == date and true or false
end

function getActualDate()
    local time = getRealTime()
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    return string.format("%04d-%02d-%02d", year + 1900, month + 1, monthday)
end

function loadQuestData(player)
    if not getElementData(player, 'player:sid') then return end
    local db = exports['since-db']:query('SELECT dailyQuestDate, dailyQuestDays, dailyQuestStats FROM `since-users` WHERE uid = ? LIMIT 1', getElementData(player, 'player:sid'))
    if #db == 0 then return end
    local db = db[1]
    local questData = db.dailyQuestStats and fromJSON(db.dailyQuestStats) or nil
    if not questData or not checkIsDateActual(db.dailyQuestDate) then
        loadNewQuest(player)
    else
        setElementData(player, 'player:quest', questData)
    end
end

function loadNewQuest(player)
    if not getElementData(player, 'player:sid') then return end
	local db = exports['since-db']:query('SELECT dailyQuestDate, dailyQuestDays, dailyQuestStats FROM `since-users` WHERE uid = ? LIMIT 1', getElementData(player, 'player:sid'))
    if #db == 0 then return end
    local db = db[1]
    local lastQuestData = db.dailyQuestStats and fromJSON(db.dailyQuestStats) or nil
    local daysInRow = lastQuestData and lastQuestData.finished and checkDateIsInRow(db.dailyQuestDate) and db.dailyQuestDays + 1 or 1
    local randomQuest = getRandomQuest(lastQuestData and lastQuestData.last or nil)
    local isWeekCompleted = nil
    if daysInRow > 7 then
        daysInRow = 1
    end
    local questData = {
        id = randomQuest,
        last = randomQuest,
        date = db.dailyQuestDate,
        daysInRow = daysInRow,
        progress = 0,
    }
    setElementData(player, 'player:quest', questData)
    exports['since-db']:query('UPDATE `since-users` SET dailyQuestDate = NOW(), dailyQuestDays = ?, dailyQuestStats = ? WHERE uid = ?', daysInRow, toJSON(questData), getElementData(player, 'player:sid'))
end

addEvent('event', true)
addEventHandler('event', resourceRoot, function(action, data, questID)
    if action == 'addProgress' then
        addProgress(client, data, questID)
    end
end)

function addProgress(player, value, questID)
    local questData = getElementData(player, 'player:quest')
    if not questData then return end
    if questData.id ~= questID then return end
    if questData.finished then return end
    local progressMax = quests[questData.id].progress
    if not value or not tonumber(value) then value = 1 end
    questData.progress = math.min(questData.progress + value, progressMax)
    if questData.progress >= progressMax then
        questData.finished = true
        exports['since-notifications']:sendNotification(player, 'info', 'Ukończyłeś dzisiejsze zadanie! Odbierz nagrodę.')
    end
    setElementData(player, 'player:quest', questData)
end

function collectReward(player)
    local questData = getElementData(player, 'player:quest')
    if not questData then return end
    if not questData.finished then return end
    if questData.collected then return end
    local quest = quests[questData.id]
    local rewards = quest.rewards
    local rewardInfo = {}
    for i,v in ipairs(rewards) do
        if v[1] == 'money' then
            givePlayerMoney(player, v[2])
            table.insert(rewardInfo, formatNumber(v[2])..' $')
        elseif v[1] == 'srp' then
            setElementData(player, 'player:srp', (getElementData(player, 'player:srp') or 0) + v[2])
            table.insert(rewardInfo, formatNumber(v[2])..' SRP')
        elseif v[1] == 'wpln' then
            exports['since-db']:query('UPDATE `since-users` SET wpln = wpln + ? WHERE uid = ? limit 1', v[2], getElementData(player, 'player:sid'))
            table.insert(rewardInfo, formatNumber(v[2])..' WPLN')
        elseif v[1] == 'pp' then
            setElementData(player, 'player:pp', (getElementData(player, 'player:pp') or 0) + v[2])
            table.insert(rewardInfo, formatNumber(v[2])..' PP')
        end
    end
    exports['since-notifications']:sendNotification(player, 'success', 'Odbierasz nagrodę za dzisiejsze zadanie! Otrzymujesz: '..table.concat(rewardInfo, ', ')..'.')
    questData.collected = true
    if questData.daysInRow == 7 then
        local rewardInfo = {}
        local v = weekRewards[math.random(#weekRewards)]
        if v[1] == 'money' then
            givePlayerMoney(player, v[2])
            table.insert(rewardInfo, formatNumber(v[2])..' $')
        elseif v[1] == 'srp' then
            setElementData(player, 'player:srp', (getElementData(player, 'player:srp') or 0) + v[2])
            table.insert(rewardInfo, formatNumber(v[2])..' SRP')
        elseif v[1] == 'wpln' then
            exports['since-db']:query('UPDATE `since-users` SET wpln = wpln + ? WHERE uid = ? limit 1', v[2], getElementData(player, 'player:sid'))
            table.insert(rewardInfo, formatNumber(v[2])..' WPLN')
        elseif v[1] == 'pp' then
            setElementData(player, 'player:pp', (getElementData(player, 'player:pp') or 0) + v[2])
            table.insert(rewardInfo, formatNumber(v[2])..' PP')
        end
        exports['since-notifications']:sendNotification(player, 'info', 'Ukończyłeś tydzień z rzędu! Otrzymujesz '..table.concat(rewardInfo, ', ')..'.')
    end
    setElementData(player, 'player:quest', questData)
end

local reloadedDate = nil
function applyCheckingTimer()
    setTimer(function()
        if reloadedDate == getActualDate() then return end
        reloadedDate = getActualDate()
        for k, v in ipairs(getElementsByType('player')) do
            local questData = getElementData(v, 'player:quest')
            if not questData then
                loadQuestData(v)
            else
                if not checkIsDateActual(questData.date) then
                    loadQuestData(v)
                end
            end
        end
    end, 10000, 0)
end
addEventHandler('onResourceStart', resourceRoot, applyCheckingTimer)

addCommandHandler('quest.reset', function(player, cmd, target)
    if getElementData(player, 'player:admin') ~= 4 then return end
    local questData = getElementData(player, 'player:quest')
    if not questData then return end
    if target then 
        target = exports['since-core']:findPlayer(player, target)
        if not target then exports['since-notifications']:sendNotification(player, 'info', 'Nieznaleziono podanego gracza') return end
        loadNewQuest(target)
        exports['since-notifications']:sendNotification(player, 'info', 'Zresetowałeś zadanie gracza '..getPlayerName(target))
        exports['since-notifications']:sendNotification(target, 'info', getPlayerName(player)..' zresetował twoje zadanie dzienne')
    else
        loadNewQuest(player)
        exports['since-notifications']:sendNotification(player, 'info', 'Zresetowałeś swoje zadanie dzienne')
    end
end)

addCommandHandler('quest.max', function(player, cmd, target)
    if getElementData(player, 'player:admin') ~= 4 then return end
    local questData = nil
    if target then 
        target = exports['since-core']:findPlayer(player, target)
        if not target then exports['since-notifications']:sendNotification(player, 'info', 'Nieznaleziono podanego gracza') return end
        local questData = getElementData(target, 'player:quest')
        questData.daysInRow = 7
        questData.progress = quests[questData.id].progress
        questData.finished = true
        questData.collected = nil
        setElementData(target, 'player:quest', questData)
        exports['since-notifications']:sendNotification(player, 'info', 'Wymaksowałeś zadanie gracza '..getPlayerName(target))
        exports['since-notifications']:sendNotification(target, 'info', getPlayerName(player)..' wymaksował twoje zadanie dzienne')
    else
        local questData = getElementData(player, 'player:quest')
        questData.daysInRow = 7
        questData.progress = quests[questData.id].progress
        questData.finished = true
        questData.collected = nil
        setElementData(player, 'player:quest', questData)
        exports['since-notifications']:sendNotification(player, 'info', 'Wymaksowałeś swoje zadanie dzienne')
    end
end)