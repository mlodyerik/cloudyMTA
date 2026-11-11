

--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

local blips = {}
local timers = {}
local cooldowns = {}

function checkDistance(plr)
    timers[plr] = setTimer(function()
        if blips[plr] then
            local x, y, z = getElementPosition(blips[plr])
            local x2, y2, z2 = getElementPosition(plr)
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            if distance > 500 then
                destroyElement(blips[plr])
                blips[plr] = nil
                killTimer(timers[plr])
                timers[plr] = nil
            end
        end
    end, 5000, 0)
end

addCommandHandler("utrudnienie", function(plr ,cmd)
    if getElementData(plr, "player:faction") and getElementData(plr, "player:faction") ~= "TSA" then
        if blips[plr] then
            destroyElement(blips[plr])
            blips[plr] = nil
            if isTimer(timers[plr]) then
                killTimer(timers[plr])
            end
            timers[plr] = nil
        else
            if cooldowns[plr] then
                if getTickCount() - cooldowns[plr] < 60000 then
                    outputChatBox("#ff0000✘ #ffffffUtrudnienie można postawić raz na 60 sekund!", plr, _, _, _, true)
                    return false
                end
            end
            local x, y, z = getElementPosition(plr)
            blips[plr] = createBlip(x, y, z, 19)
            local zone = getZoneName(x, y, z)
            local city = getZoneName(x, y, z, true)
            exports['since-admins']:createAdminNotification('Zanotowano utrudnienia w ruchu w lokalizacji '..city..', '..zone..'. Zalecamy jazdę z mniejszą prędkością.', 255, 175, 0, 5000)
            outputChatBox("#00ff00✔ #ffffffPomyślnie ustawiłeś/aś utrudnienie w ruchu!", plr, _, _, _, true)
            checkDistance(plr)
            cooldowns[plr] = getTickCount()
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if blips[source] then
        destroyElement(blips[source])
        blips[source] = nil
    end
    if isTimer(timers[plr]) then
        killTimer(timers[plr])
        timers[plr] = nil
    end
end)