function convertTimer(miliseconds)
    local seconds = math.floor(miliseconds / 1000)
    local miliseconds = math.floor(miliseconds % 1000) / 10

    return string.format("%02d:%02d", seconds, miliseconds)
end

addEvent("sentRecord:1/4",true)
addEventHandler("sentRecord:1/4", resourceRoot, function(time, veh)
    if not time or not veh then
        return
    end

    local vehicle = exports['since-vehiclenames']:getVehicleName(getElementData(veh, 'vehicle:model') or getElementModel(veh))

    local result = exports['since-db']:query('SELECT * FROM `since-14mili` WHERE `uid` = ?', getElementData(client, 'player:sid'))

    if #result > 0 then
        local bestTime = result[1].time

        if time < bestTime then
            exports['since-db']:query('UPDATE `since-14mili` SET `nick` = ?, `model` = ?, `time` = ? WHERE `uid` = ?', getPlayerName(client):gsub('#%x%x%x%x%x%x', ''), vehicle, time, getElementData(client, 'player:sid'))
        end
    else
        exports['since-db']:query('INSERT INTO `since-14mili` (uid, nick, model, time) VALUES(?,?,?,?)', getElementData(client, 'player:sid'), getPlayerName(client):gsub('#%x%x%x%x%x%x', ''), vehicle, time)
    end

    local result = exports['since-db']:query('SELECT * FROM `since-14mili` ORDER BY `time` ASC LIMIT 1')

    if #result > 0 then
        if result[1].uid == getElementData(client, 'player:sid') then
            exports['since-notifications']:sendNotification(client, 'success', 'Twój czas to: '..convertTimer(time)..'. Wskakujesz na pierwsze miejsce!')
        else
            exports['since-notifications']:sendNotification(client, 'success', 'Twój czas to: '..convertTimer(time)..'. Pierwsze miejsce: '..result[1].nick..' z czasem '..convertTimer(result[1].time))
        end
    else
        exports['since-notifications']:sendNotification(client, 'success', 'Twój czas to: '..convertTimer(time)..'. Jesteś pierwszy!')
    end
end)

local given = false
function addMoneyEveryDay()
    local result = exports['since-db']:query('SELECT * FROM `since-14mili` ORDER BY `time` ASC LIMIT 1')
    local dateTime = getRealTime()

    if dateTime.hour ~= 23 or dateTime.minute ~= 59 then
        given = false
        return
    end

    if given then return end

    if #result > 0 then
        local money = 10000000
        local uid = result[1].uid

        if uid then
            local queryResponse = exports['since-db']:query('UPDATE `since-users` SET `bankMoney` = `bankMoney` + ? WHERE `uid` = ?', money, uid)

            given = true

            if queryResponse then
                outputDebugString('[since-14mili]: Nadano graczowi '..result[1].nick..' $ '..money..' za najlepszy czas', 3)
                outputServerLog('[since-14mili]: Nadano graczowi '..result[1].nick..' $ '..money..' za najlepszy czas')
            end
        end
    end
end
setTimer(addMoneyEveryDay, 10000, 0)