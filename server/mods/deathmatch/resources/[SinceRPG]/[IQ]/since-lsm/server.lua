local playersData = {}

addEvent('onJobStart', true)
addEventHandler('onJobStart', resourceRoot, function ()
    local player = client
    if (not isElement(player)) then return end

    setElementData(player, 'player:job', 'lsm')
    exports['since-notifications']:sendNotification(player, 'success', 'Rozpocząłeś pracę LSM')
    playersData[player] = {
        vehicles = getRandomVehicles(player),
        actual = false
    }
    triggerClientEvent(player, 'onClientStartLSMJob', resourceRoot, playersData[player])
end)

-- addEventHandler("onVehicleStartExit", root, function(player, seat)
--     if (getElementData(player, 'player:job') == 'lsm') then
--         cancelEvent()
--         exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz opuścić pojazdu w trakcie pracy')
--     end
-- end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', resourceRoot, function ()
    local player = client
    if (not isElement(player)) then return end

    setElementData(player, 'player:job', nil)
    exports['since-notifications']:sendNotification(player, 'success', 'Zakończyłeś pracę LSM')
    playersData[player] = nil
    triggerClientEvent(player, 'onClientFinishLSMJob', resourceRoot)
end)

addEventHandler('onResourceStop', resourceRoot, function ()
    for i, player in ipairs(getElementsByType('player')) do
        if (getElementData(player, 'player:job') == 'lsm') then
            setElementData(player, 'player:job', nil)
        end
    end
end)

function getPlayerJobData(player)
    return playersData[player]
end

function updatePlayerJobData(player, data)
    playersData[player] = data
    triggerClientEvent(player, 'onClientUpdateLSMJob', resourceRoot, data)
end

addEventHandler('onPlayerQuit', root, function ()
    if (playersData[source]) then
        if (isElement(playersData[source].actual.vehicle)) then
            destroyElement(playersData[source].actual.vehicle)
        end

        playersData[source] = nil
    end
end)