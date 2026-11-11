local playedTime = 0
local count = 0

function addPlayedTime()
    if not getElementData(localPlayer, 'player:actualSesion') then
        setElementData(localPlayer, 'player:actualSesion', 0)
    end

    setTimer(function()
        if not getElementData(localPlayer, 'player:spawn') then 
            return 
        end
        
        if getElementData(localPlayer, 'player:afk') then
            return
        end

        local actualSesion = getElementData(localPlayer, 'player:actualSesion') or 0
        setElementData(localPlayer, 'player:actualSesion', actualSesion + 1)

        count = count + 1

        if count == (60*60) then
            playedTime = playedTime + 1
            count = 0

            triggerServerEvent('giveReward', resourceRoot)
        end
    end, 1000, 0)
end
addEventHandler('onClientResourceStart', resourceRoot, addPlayedTime)
getResourceName(getThisResource(), true, 660350080); if true then return end