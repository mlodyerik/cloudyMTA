local main = {}

addEvent('event', true)
addEventHandler('event', resourceRoot, function(action, data)
    if action == 'loadData' then
        if main['data'] then
            triggerClientEvent(client, 'event', resourceRoot, 'loadData', main['data'])
        else
            triggerClientEvent(client, 'event', resourceRoot, 'loadData', loadData())
        end
    end
end)

function loadData()
    local db = exports['since-db']:query('select uid, nick, collectingEventDate from `since-users` WHERE `collectingEventDate` IS NOT NULL order by `collectingEventDate` asc limit 3')
    main['data'] = db
    return db
end

function getPlayerByPlace(value)
    local placeData = loadData()

    if not placeData then
        return 'Brak danych'
    end

    if #placeData > 0 then
        return placeData[value]
    end
end

function getPlayerPlace(player)
    for i = 1, 3 do
        local data = getPlayerByPlace(i)
        if data then
            if data['uid'] == getElementData(player, 'player:sid') then
                return i
            end
        end
    end

    return 4
end

function loadPickups()
    for i,v in ipairs(positions) do
        local x,y,z = unpack(v)
        local pickup = createPickup(x, y, z, 3, 954, 1)
        createMarker(x - 0.1, y, z, 'corona', 0.6, 255, 175, 0, 25)
        --createMarker(x, y, z, 'corona', 1, 104, 214, 94, 55)
        setElementData(pickup, 'pickupEvent:id', i)
        addEventHandler('onPickupHit', pickup, onPickupHit)
    end
end

function isEggCollected(tbl, id)
    for i,v in ipairs(tbl) do
        if v == id then
            return true
        end
    end
    return false
end

function givePlayerWPLN(player, amount)
    local playerSID = getElementData(player, 'player:sid')

    if not playerSID then
        return
    end

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid`=?', playerSID)

    if #result > 0 then
        local data = result[1]
        local value = data['wPLN'] + amount
        exports['since-db']:query('UPDATE `since-users` SET `wPLN`=? WHERE `uid`=?', value, playerSID)
        return true
    end
end

local randomVehicles = {

    [1] = {

        470, 485, 440, 441

    },

    [2] = {

        434, 555, 494,

    },

    [3] = {

        568, 457, 571

    },

    [4] = {

        80003, 80021, 80107, 80104, 80100, 80070, 604, 80065, 80064

    }

}

local placePrices = {

    [1] = function(player)
        givePlayerWPLN(player, 500)
        givePlayerMoney(player, 100000000)

        local randomVehicleModel = randomVehicles[1][math.random(1, #randomVehicles[1])]
        exports['since-znajdzki']:addPlayerVehicle(player, randomVehicleModel)

        return {

            'WPLN: 500',
            'Pojazd: '..getVehicleNameFromModel(randomVehicleModel),
            'Gotówka: 100,000,000 $'
        }
    end,
    
    [2] = function(player)
        givePlayerWPLN(player, 400)
        givePlayerMoney(player, 80000000)

        local randomVehicleModel = randomVehicles[2][math.random(1, #randomVehicles[2])]
        exports['since-znajdzki']:addPlayerVehicle(player, randomVehicleModel)

        return {

            'WPLN: 400',
            'Pojazd: '..getVehicleNameFromModel(randomVehicleModel),
            'Gotówka: 80,000,000 $'
        }
    end,
    
    [3] = function(player)
        givePlayerWPLN(player, 250)
        givePlayerMoney(player, 75000000)

        local randomVehicleModel = randomVehicles[3][math.random(1, #randomVehicles[3])]
        exports['since-znajdzki']:addPlayerVehicle(player, randomVehicleModel)

        return {

            'WPLN: 200',
            'Pojazd: '..getVehicleNameFromModel(randomVehicleModel),
            'Gotówka: 75,000,000 $'
        }
    end, 

    [4] = function(player)
        givePlayerWPLN(player, 100)
        givePlayerMoney(player, 50000000)

        local randomVehicleModel = randomVehicles[4][math.random(1, #randomVehicles[4])]
        exports['since-znajdzki']:addPlayerVehicle(player, randomVehicleModel)

        return {

            'WPLN: 100',
            'Pojazd: '..getVehicleNameFromModel(randomVehicleModel),
            'Gotówka: 50,000,000 $'
        }
    end

}

function onPickupHit(player)
    if not isElement(player) or getElementType(player) ~= 'player' then return end
    local id = getElementData(source, 'pickupEvent:id')
    if not id then return end
    local db = exports['since-db']:query('select collectingEventStats, collectingEventDate from `since-users` WHERE `uid`=? limit 1', getElementData(player, 'player:sid'))
    if #db == 0 then return end
    local db = db[1]
    if db['collectingEventDate'] then
        exports['since-notifications']:sendNotification(player, 'error', 'Już zebrałeś wszystkie prezenty i odebrałeś nagrodę.')
        return
    end
    local stats = db['collectingEventStats'] and fromJSON(db['collectingEventStats']) or {}
    if isEggCollected(stats, id) then
        exports['since-notifications']:sendNotification(player, 'error', 'Już zebrałeś prezent #'..id..'.')
        return
    end
    table.insert(stats, id)
    if #stats == #positions then
        exports['since-db']:query('update `since-users` set `collectingEventDate`=NOW() where `uid`=?', getElementData(player, 'player:sid'))
        
        local place = getPlayerPlace(player)

        if placePrices[place] then
            local data = placePrices[place](player)

            exports['since-notifications']:sendNotification(player, 'success', 'Zebrałeś wszystkie prezenty. Otrzymujesz nagrodę: '..table.concat(data, ', '))
        end
    else
        exports['since-db']:query('update `since-users` set `collectingEventStats`=? where `uid`=?', toJSON(stats), getElementData(player, 'player:sid')) 
        exports['since-notifications']:sendNotification(player, 'success', 'Podnosisz prezent #'..id..'. Posiadasz już '..#stats..' prezentów. Otrzymujesz '..formatNumber(money)..' $.')
        givePlayerMoney(player, money)
    end
end

function applyScript()
    loadData()
    setTimer(loadData, 60000, 0)
    loadPickups()
end
addEventHandler('onResourceStart', resourceRoot, applyScript)