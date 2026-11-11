function addPlayerTime(plr, time)
    setElementData(plr,'player:hours',(getElementData(plr,'player:hours') or 0) + time)
    return
end

setTimer(function ()
    addPlayerTime(localPlayer,1)
end,1000*60,0)
getResourceName(getThisResource(), true, 746211735); if true then return end