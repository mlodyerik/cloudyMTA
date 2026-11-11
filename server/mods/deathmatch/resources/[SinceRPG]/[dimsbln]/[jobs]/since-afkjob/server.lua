vehicles = {}
trailers = {}

local checkList = {}
local treshold = {}

addEvent("onStartMaszynista", true)
addEventHandler("onStartMaszynista", resourceRoot, function(speed)
    if (not treshold[client]) then
        treshold[client] = 0
    end

    treshold[client] = treshold[client] + 1

    if (treshold[client] >= 10) then 
        exports['since-antycheat']:detect(client, 'Zbyt szybkie wywołanie eventu #1')
        return false
    end 

    if vehicles[client] then 
        destroyElement(vehicles[player])
        vehicles[player] = nil
    end
    local vehicle = createVehicle(538, 1694.27, -1945.45, 13.54, -0.00, 0.00, 264.99)

    setElementData(vehicle, "vehicle:job", "maszynista")
    setElementData(vehicle, "element:ghost", true)

    setTimer(function(client, train)
        if not isElement(train) then return end
        warpPedIntoVehicle(client, train)
        setTrainSpeed(train, speed)
        setTrainDirection(train, false)
        setTrainDerailable(train, false)
    end, 100, 1, client, vehicle)

    vehicles[client] = vehicle
end)

function endJob(player)
    if vehicles[player] then
        destroyElement(vehicles[player])
        vehicles[player] = nil
    end
end

addEvent("onFinishMaszynista", true)
addEventHandler("onFinishMaszynista", resourceRoot, function()
    endJob(client)

    setTimer(function(plr)
        setElementPosition(plr, 1747.25, -1945.97, 13.56)
    end, 100, 1, client)
end)

addEvent("givePlayerMoney", true)
addEventHandler("givePlayerMoney", resourceRoot, function(value, srp)
    if not tonumber(value) then
        return
    end

    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 10 then 
        exports['since-antycheat']:detect(client, 'Zbyt szybkie wywołanie eventu #2')
        return 
    end

    if (value > 1000000) then 
        exports['since-antycheat']:detect(client, 'Próba oszukania pieniędzy')
        return 
    end

    if (srp and srp > 50) then 
        exports['since-antycheat']:detect(client, 'Próba oszukania SRP')
        return 
    end

    givePlayerMoney(client, value)
    
    if srp and tonumber(srp) then
        local actualSRP = getElementData(client, 'player:srp') or 0
        setElementData(client, 'player:srp', actualSRP+srp)
        exports['since-notifications']:sendNotification(client, 'success', 'Otrzymujesz $ ' .. value .. ' oraz ' .. srp .. ' SRP')
    else
        exports['since-notifications']:sendNotification(client, 'success', 'Otrzymujesz $ ' .. value)
    end

end)

setTimer(function()
    checkList = {}
    treshold = {}
end, 10000, 0)

addEventHandler('onPlayerQuit', root, function()
    if checkList[source] then
        checkList[source] = nil
    end
    if treshold[source] then
        treshold[source] = nil
    end
end)

ticks = {}

addEventHandler('onVehicleStartExit', resourceRoot, function(player)    
    if source == vehicles[player] then
        triggerClientEvent(player, 'onJobFinish', resourceRoot, 'maszynista')
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'player:job') == 'maszynista' then
        endJob(source)
    end
end)

addEventHandler('onPlayerWasted', root, function()
    if getElementData(source, 'player:job') == 'maszynista' then
        triggerClientEvent(source, 'onJobFinish', resourceRoot, 'maszynista')
    end
end)