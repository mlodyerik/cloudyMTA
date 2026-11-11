local timers = {}

function startDutyTime(player)
    setElementData(player, 'player:factionTime', 0)

    timers[player] = setTimer(function ()
        local factionTime = getElementData(player, 'player:factionTime') or 0
        setElementData(player, 'player:factionTime', factionTime + 1)
    end, 1000 * 60, 0)
end

function stopDutyTime(player)
    if isTimer(timers[player]) then
        killTimer(timers[player])
    end
end

addEventHandler('onPlayerQuit', root, function ()
    if isTimer(timers[source]) then
        killTimer(timers[source])
    end
end)