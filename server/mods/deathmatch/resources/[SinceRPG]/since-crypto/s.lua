local data = {
    ['timers'] = {},
    ['autoStarted'] = {},
}

local graphicsMultipilers = {
    [1] = 0,
    [2] = 0.1,
    [3] = 0.25,
    [4] = 0.5,
    [5] = 0.75,
}

createBlip(2111.86, -2057.45, 13.5, 46, 2, 255, 255, 255, 255, 0, 400)

addEvent('cryptoEvent', true)
addEventHandler('cryptoEvent', resourceRoot, function(action, data)
    if action == 'startDigging' then
        attachTimer(client)

    elseif action == 'stopDigging' then
        detachTimer(client)

    elseif action == 'grabCryptoPrices' then
        local tbl = {
            ['bitcoin'] = {},
            ['litecoin'] = {},
            ['ethereum'] = {},
        }
        local db = exports['since-db']:query("SELECT * FROM `since-cryto-records` where `data`=? ORDER BY `date` DESC  LIMIT 10", 'bitcoin')
        tbl['bitcoin'] = db or {}
        local db = exports['since-db']:query("SELECT * FROM `since-cryto-records` where `data`=? ORDER BY `date` DESC  LIMIT 10", 'litecoin')
        tbl['litecoin'] = db or {}
        local db = exports['since-db']:query("SELECT * FROM `since-cryto-records` where `data`=? ORDER BY `date` DESC  LIMIT 10", 'ethereum')
        tbl['ethereum'] = db or {}
        triggerClientEvent(client, 'cryptoEvent', resourceRoot, 'grabCryptoPrices', tbl)

    elseif action == 'buyPart' then
        local jobStats = getElementData(client, "player:jobStats") or {}
        if not jobStats['crypto'] then
            jobStats['crypto'] = {}
        end
        if not jobStats['crypto']['parts'] then
            jobStats['crypto']['parts'] = {}
            jobStats['crypto']['parts']['powerSupply'] = 1
            jobStats['crypto']['parts']['graphicsCard'] = 1
        end
        if not jobStats['crypto']['boosts'] then
            jobStats['crypto']['boosts'] = {}
        end

        if data[1] == 'powerSupply' then
            if jobStats['crypto']['parts']['powerSupply'] >= #powerSupply then
                exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz już maksymalną ilość zasilaczy!')
                return
            end
            if data[2] == jobStats['crypto']['parts']['powerSupply'] then
                exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz już ten zasilacz!')
                return
            end
            if jobStats['crypto']['parts']['powerSupply']+1 ~= data[2] then
                exports['since-notifications']:sendNotification(client, 'error', 'Aby zakupić ten zasilacz pierw zakup poprzedni!')
                return
            end 
            local db = exports['since-db']:query("SELECT bankMoney FROM `since-users` where `uid`=? LIMIT 1", getElementData(client, 'player:sid'))
            if #db == 0 then return end
            local money = db[1]['bankMoney']
            if money < powerSupply[jobStats['crypto']['parts']['powerSupply']+1]['cost'] then
                exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczająco pieniędzy na koncie bankowym!')
                return
            end
            exports['since-db']:query("UPDATE `since-users` SET `bankMoney`=`bankMoney`-? WHERE `uid`=?", powerSupply[jobStats['crypto']['parts']['powerSupply']+1]['cost'], getElementData(client, 'player:sid'))
            jobStats['crypto']['parts']['powerSupply'] = jobStats['crypto']['parts']['powerSupply'] + 1
            exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zakupiłeś zasilacz!')

        elseif data[1] == 'graphicsCard' then
            local info = graphicsCard[data[2]]
            if jobStats['crypto']['parts']['graphicsCard'] >= #graphicsCard then
                exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz już maksymalną ilość kart graficznych!')
                return
            end
            if data[2] == jobStats['crypto']['parts']['graphicsCard'] then
                exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz już tę kartę graficzną!')
                return
            end
            if info['power'] > powerSupply[jobStats['crypto']['parts']['powerSupply']]['power'] then
                exports['since-notifications']:sendNotification(client, 'error', 'Aby zakupić tę kartę graficzną musisz posiadać lepszy zasilacz!')
                return
            end
            if jobStats['crypto']['parts']['graphicsCard']+1 ~= data[2] then
                exports['since-notifications']:sendNotification(client, 'error', 'Aby zakupić tą kartę graficzną pierw zakup poprzedną!')
                return
            end 
            local db = exports['since-db']:query("SELECT bankMoney FROM `since-users` where `uid`=? LIMIT 1", getElementData(client, 'player:sid'))
            if #db == 0 then return end
            local money = db[1]['bankMoney']
            if money < graphicsCard[jobStats['crypto']['parts']['graphicsCard']+1]['cost'] then
                exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczająco pieniędzy na koncie bankowym!')
                return
            end
            exports['since-db']:query("UPDATE `since-users` SET `bankMoney`=`bankMoney`-? WHERE `uid`=?", graphicsCard[jobStats['crypto']['parts']['graphicsCard']+1]['cost'], getElementData(client, 'player:sid'))
            jobStats['crypto']['parts']['graphicsCard'] = jobStats['crypto']['parts']['graphicsCard'] + 1
            exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zakupiłeś kartę graficzną!')

        elseif data[1] == 'boosts' then
            local info = boosts[data[2]]
            if jobStats['crypto']['boosts'][info.data] then
                exports['since-notifications']:sendNotification(client, 'error', 'Posiadasz już ten boost!')
                return
            end
            local db = exports['since-db']:query("SELECT bankMoney FROM `since-users` where `uid`=? LIMIT 1", getElementData(client, 'player:sid'))
            if #db == 0 then return end
            local money = db[1]['bankMoney']
            if money < boosts[data[2]]['cost'] then
                exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczająco pieniędzy na koncie bankowym!')
                return
            end
            exports['since-db']:query("UPDATE `since-users` SET `bankMoney`=`bankMoney`-? WHERE `uid`=?", boosts[data[2]]['cost'], getElementData(client, 'player:sid'))
            jobStats['crypto']['boosts'][info.data] = true
            exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zakupiłeś ulepszenie!')
        end

        setElementData(client, "player:jobStats", jobStats)

    elseif action == 'buyCrypto' then
        local jobStats = getElementData(client, "player:jobStats") or {}
        if not jobStats['crypto'] then
            jobStats['crypto'] = {}
        end
        if not jobStats['crypto']['wallet'] then
            jobStats['crypto']['wallet'] = {0, 0, 0}
        end
        if not jobStats['crypto']['bought'] then
            jobStats['crypto']['bought'] = true
        end
        if not jobStats['crypto']['mined'] then
            jobStats['crypto']['mined'] = {0, 0, 0}
        end
        if not jobStats['crypto']['parts'] then
            jobStats['crypto']['parts'] = {}
        end
        jobStats['crypto']['parts']['powerSupply'] = 1
        jobStats['crypto']['parts']['graphicsCard'] = 1
        if not jobStats['crypto']['boosts'] then
            jobStats['crypto']['boosts'] = {}
        end
        local db = exports['since-db']:query("SELECT bankMoney FROM `since-users` where `uid`=? LIMIT 1", getElementData(client, 'player:sid'))
        if #db == 0 then return end
        local money = db[1]['bankMoney']
        if money < cost then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczająco pieniędzy na koncie bankowym!')
            return
        end    
        exports['since-db']:query("UPDATE `since-users` SET `bankMoney`=`bankMoney`-? WHERE `uid`=?", cost, getElementData(client, 'player:sid'))
        
        setElementData(client, "player:jobStats", jobStats)
        exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie zakupiłeś siedzibę kryptowalut!')
        
    elseif action == 'sellCrypto' then
        local jobStats = getElementData(client, "player:jobStats") or {}
        if not jobStats['crypto'] then
            jobStats['crypto'] = {}
        end
        if not jobStats['crypto']['wallet'] then
            jobStats['crypto']['wallet'] = {0, 0, 0}
        end
        if not jobStats['crypto']['selled'] then
            jobStats['crypto']['selled'] = {0, 0, 0}
        end

        local cryptoIDS = {
            ['bitcoin'] = 1,
            ['litecoin'] = 2,
            ['ethereum'] = 3,
        }

        local db = exports['since-db']:query("SELECT * FROM `since-cryto-records` where `data`=? ORDER BY `date` DESC  LIMIT 1", data)
        if #db == 0 then return end
        local price = db[1]['price']
        local id = cryptoIDS[data]
        if jobStats['crypto']['wallet'][id] > 0 then
            local money = math.floor(jobStats['crypto']['wallet'][id]/10000*price)
            if not jobStats['crypto']['earned'] then
                jobStats['crypto']['earned'] = 0
            end
            jobStats['crypto']['earned'] = jobStats['crypto']['earned'] + money
            jobStats['crypto']['selled'][id] = jobStats['crypto']['selled'][id] + jobStats['crypto']['wallet'][id]
            jobStats['crypto']['wallet'][id] = 0
            exports['since-db']:query("UPDATE `since-users` SET `bankMoney`=`bankMoney`+? WHERE `uid`=?", money, getElementData(client, 'player:sid'))
            setElementData(client, "player:jobStats", jobStats)
            exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie sprzedałeś kryptowalutę za '..formatNumber(money)..'$!')
        end
    end
end)

function mineCrypto(player)
    if not player then return end
    if not isElement(player) then
        if data['timers'][player] then
            killTimer(data['timers'][player])
            data['timers'][player] = nil
        end
        return
    end
    local jobStats = getElementData(player, "player:jobStats") or {}
    if not jobStats['crypto'] then
        jobStats['crypto'] = {}
    end
    if not jobStats['crypto']['wallet'] then
        jobStats['crypto']['wallet'] = {0, 0, 0}
    end
    if not jobStats['crypto']['mined'] then
        jobStats['crypto']['mined'] = {0, 0, 0}
    end
    if not jobStats['crypto']['parts'] then
        jobStats['crypto']['parts'] = {}
        jobStats['crypto']['parts']['powerSupply'] = 1
        jobStats['crypto']['parts']['graphicsCard'] = 1
    end
    if not jobStats['crypto']['boosts'] then
        jobStats['crypto']['boosts'] = {}
    end
    local booster = jobStats['crypto']['boosts']['betterDrop'] and 1 or 1.5

    if jobStats['crypto']['boosts']['betterVents'] then
        booster = booster + 0.5
    end

    if jobStats['crypto']['boosts']['twoCards'] then
        booster = booster + 0.5
    end

    if graphicsMultipilers[jobStats['crypto']['parts']['graphicsCard']] then
        booster = booster + graphicsMultipilers[jobStats['crypto']['parts']['graphicsCard']]
    end

    local calculation = {math.random(1, 3), math.random(3, 6), math.random(6, 9)}
    local multiplier = exports['since-jobs']:getJobMultiplier('crypto')
    calculation[1] = (calculation[1] * booster) * multiplier
    calculation[2] = (calculation[2] * booster) * multiplier
    calculation[3] = (calculation[3] * booster) * multiplier
    calculation[1] = math.floor(calculation[1]*25)
    calculation[2] = math.floor(calculation[2]*35)
    calculation[3] = math.floor(calculation[3]*15)
    jobStats['crypto']['wallet'][1] = jobStats['crypto']['wallet'][1] + calculation[1]
    jobStats['crypto']['mined'][1] = jobStats['crypto']['mined'][1] + calculation[1]
    jobStats['crypto']['wallet'][2] = jobStats['crypto']['wallet'][2] + calculation[2]
    jobStats['crypto']['mined'][2] = jobStats['crypto']['mined'][2] + calculation[2]
    jobStats['crypto']['wallet'][3] = jobStats['crypto']['wallet'][3] + calculation[3]
    jobStats['crypto']['mined'][3] = jobStats['crypto']['mined'][3] + calculation[3]
    setElementData(player, "player:jobStats", jobStats)
end

function attachTimer(player)
    if data['timers'][player] then
        killTimer(data['timers'][player])
    end
    if not player then return end
    data['timers'][player] = setTimer(mineCrypto, 30000, 0, player)
    setElementData(player, 'player:cryptoMining', true)
end

function detachTimer(player)
    if not data['timers'][player] then return end
    killTimer(data['timers'][player])
    data['timers'][player] = nil
    setElementData(player, 'player:cryptoMining', nil)
end

function loadNewPrice()
    local pricess = {
        ['bitcoin'] = math.random(cryptoPrices['bitcoin'][1], cryptoPrices['bitcoin'][2]),
        ['litecoin'] = math.random(cryptoPrices['litecoin'][1], cryptoPrices['litecoin'][2]),
        ['ethereum'] = math.random(cryptoPrices['ethereum'][1], cryptoPrices['ethereum'][2]),
    }
    for i,v in pairs(pricess) do
        exports['since-db']:query("INSERT INTO `since-cryto-records` SET `data`=?, `price`=?, `date`=NOW()", i, v)
    end
end

addEventHandler('onResourceStart', resourceRoot, function()
    loadNewPrice()
    setTimer(loadNewPrice, 1000*60*15, 0)
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:cryptoMining') then
            attachTimer(v)
        end
    end
end)

local checker = {}

function check(player)
    if getElementData(player, 'player:jobStats') then
        local jobStats = getElementData(player, 'player:jobStats')
        if not jobStats['crypto'] then
            jobStats['crypto'] = {}
        end
        if not jobStats['crypto']['bought'] then
            destroyChecker(player)
            return
        end
        if not jobStats['crypto']['boosts'] then
            jobStats['crypto']['boosts'] = {}
        end
        if jobStats['crypto']['boosts']['autoTurner'] then
            attachTimer(player)
            destroyChecker(player)
        end
    end
end

function createChecker(player)
    if checker[player] then 
        killTimer(checker[player])
        checker[player] = nil 
    end
    checker[player] = setTimer(check, 10000, 0, player)
end

function destroyChecker(player)
    if checker[player] then 
        killTimer(checker[player])
        checker[player] = nil
    end
end

addEventHandler("onPlayerSpawn", root, function()
    if data['autoStarted'][source] then return end
    data['autoStarted'][source] = true
    createChecker(source)
end)

addEventHandler("onPlayerQuit", root, function()
    detachTimer(source)
    destroyChecker(source)
    if data['autoStarted'][source] then
        data['autoStarted'][source] = nil
    end
end)