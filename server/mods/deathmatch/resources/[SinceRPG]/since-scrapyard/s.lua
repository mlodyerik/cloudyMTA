  

addEvent("zlomowisko.S", true)
addEventHandler("zlomowisko.S", resourceRoot, function(veh)
    local plr = client
    local veh = veh
    if (getElementData(veh, "vehicle:owner") == getElementData(plr, "player:sid")) then
        local id = getElementData(veh, "vehicle:id")
        if (not id) then
            return
        end
        exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, id)
        setElementData(veh, "vehicle:owner", 0)
        exports['since-core']:saveVehicle(veh)
        givePlayerMoney(plr, 2500)
        exports['since-notifications']:sendNotification(plr, 'success', 'Pojazd został zezłomowany, otrzymujesz $ 5 000')
        destroyElement(veh)
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie jesteś właścicielem pojazdu!')
    end
end)