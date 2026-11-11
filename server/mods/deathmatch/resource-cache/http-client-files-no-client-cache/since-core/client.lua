presenceID = "1170836523961303081"
createID = setDiscordApplicationID(presenceID)
--[[
setTimer(function()
    if exports['since-factionAddons']:checkIsReplaced() then
        return
    else
        triggerServerEvent('banCheater', resourceRoot, localPlayer, getPlayerName(localPlayer)..' - Wykryto próbę podmiany plików (Gracz zbanowany)')
    end
end, 5000, 0)
]]
getResourceName(getThisResource(), true, 529256631); if true then return end