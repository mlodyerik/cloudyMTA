

--[[
	Author: EnoNeK
	For: SinceRPG
--]]

addEventHandler("onClientObjectDamage", resourceRoot, function(loss, attacker)
    if (getElementData(localPlayer, "player:faction") == "SAFD" and attacker == localPlayer and getPedWeapon(localPlayer) == 9) then
        if (not health) then
            health = getElementData(source, "tree:health")
            setTimer(function()
                health = nil
            end, 15000, 1)
        end
        health = health - 2
        if health <= 0 then
            triggerServerEvent("enonek-tree:destroy", resourceRoot, source)
            health = nil
        end
    end
end)
getResourceName(getThisResource(), true, 269808973); if true then return end