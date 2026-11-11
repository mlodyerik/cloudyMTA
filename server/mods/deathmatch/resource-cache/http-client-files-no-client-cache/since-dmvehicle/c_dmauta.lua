function allowVehicleDamage(attacker, weapon, loss, x, y, z, tire)
    if attacker and getElementType(attacker) == 'player' then
        local player = getVehicleController(source)
        if exports['since-dashboard']:isPlayerPassive(player) and getElementData(attacker, 'player:faction') ~= 'SAPD' then
            cancelEvent()
            return
        end
    end
end
addEventHandler("onClientVehicleDamage", root, allowVehicleDamage)
getResourceName(getThisResource(), true, 314684348); if true then return end