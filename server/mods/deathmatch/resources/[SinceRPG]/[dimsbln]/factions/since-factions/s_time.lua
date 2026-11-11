local time = {}

function dutyTimer(plr)
    if isElement(plr) then
        setElementData(plr,"player:workinjob", (getElementData(plr,"player:workinjob") or 0) + (1 * exports['since-jobs']:getFactionMinutesMultipler()))
    else
        if time[plr] and isTimer(time[plr]) then
            killTimer(time[plr])
            time[plr] = nil
        end
    end
end

function startDutyTimer(plr)
	if time[plr] and isTimer(time[plr]) then
        killTimer(time[plr])
        time[plr] = nil
    end
    time[plr] = setTimer(dutyTimer, 60000, 0, plr)

    triggerClientEvent(plr, 'changeTimerState', resourceRoot, false)
end

function stopDutyTimer(plr)
	if time[plr] and isTimer(time[plr]) then
        killTimer(time[plr])
        time[plr] = nil
    end
    
    triggerClientEvent(plr, 'changeTimerState', resourceRoot, true)
end

addEventHandler('onPlayerQuit', root, function()
	if time[source] and isTimer(time[source]) then
        killTimer(time[source])
        time[source] = nil
    end
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:faction') then
            if getElementData(v, 'player:factionPause') then
                stopDutyTimer(v)
            else
                startDutyTimer(v)
            end
        end
    end
end)