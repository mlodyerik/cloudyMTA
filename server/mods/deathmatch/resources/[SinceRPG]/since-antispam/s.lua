local commandSpam = {}
local spamTick = 500
local list = {}

function onCommandSpam()
    if getElementData(source, 'player:admin') and getElementData(source, "player:admin") >= 3 then 
        return 
    end

    if commandSpam[source] then
        local tick = getTickCount()

        if (tick - commandSpam[source] > spamTick) then
            commandSpam[source] = getTickCount()
        else
            cancelEvent()
        end
	else
		commandSpam[source] = getTickCount()
    end
end
addEventHandler("onPlayerCommand", root, onCommandSpam)
addEventHandler("onPlayerChat", root, onCommandSpam)