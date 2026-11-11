  

local types = {
    ['a'] = {
        model = 586,
        spawn = {1402.76, -1773.98, 13.05, 359.9, 0.0, 89.8},
    },
    ['b'] = {
        model = 589,
        spawn = {1402.76, -1773.45, 13.21, 0.3, 360.0, 89.8},
    },
    ['c'] = {
        model = 414,
        spawn = {1403.71, -1773.02, 13.64, 0.0, 0.0, 89.8},
    }
}

local vehicles = {}

addEvent('stryStartExam', true)
addEventHandler('stryStartExam', resourceRoot, function (cost, type)
    plr = client

    if vehicles[plr] then
        destroyElement(vehicles[plr])
    end
    if not types[type] then return end
    if (exports['since-core']:isPlayerHaveLicense(plr, type)) then
        exports['since-notifications']:sendNotification(plr, 'error', 'Posiadasz juz prawo jazdy kat. '..type)
        return
    end
    if getPlayerMoney(plr) < cost then
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz wystarczającej ilości pieniędzy')
        return
    end
    takePlayerMoney(plr, cost)

    local veh = createVehicle(types[type].model, types[type].spawn[1], types[type].spawn[2], types[type].spawn[3], types[type].spawn[4], types[type].spawn[5], types[type].spawn[6])
    setElementFrozen(veh, true)
    setElementData(veh,'vehicle:prawko',getElementData(plr, 'player:sid'))
    setElementData(veh, 'vehicle:prawkoKM', 2.5)
    setElementData(veh, 'element:ghost', true)
    setElementData(plr, 'player:prawko', type)
    warpPedIntoVehicle(plr, veh)
    setVehicleLocked(veh, true)
    setVehicleHandling(veh, "maxVelocity", 59)

    triggerClientEvent(plr, 'startExamC', resourceRoot, type)

    exports['since-notifications']:sendNotification(plr, 'success', 'Rozpoczynasz egzamin na prawo jazdy kat. '..type)

    setElementFrozen(veh, false)

    vehicles[plr] = veh
end)

addEvent('sendLicense', true)
addEventHandler('sendLicense', resourceRoot, function ()
    plr = client
    local veh = vehicles[plr]
    if not veh then return end
    destroyElement(veh)
    vehicles[plr] = nil
    exports['since-core']:addPlayerLicense(plr, getElementData(plr, 'player:prawko'))
    setElementData(plr, 'player:prawko', nil)
    exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zdano egzamin praktyczny')
    setTimer(function ()
        setElementPosition(plr, 1489.15, -1722.96, 13.43)
    end,500, 1)
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function()
    cancelEvent()
end)

addEventHandler("onVehicleStartExit", resourceRoot, function()
    cancelEvent()
end)

addEventHandler("onPlayerQuit", root, function()
    if vehicles[source] then
        if isElement(vehicles[source]) then
            destroyElement(vehicles[source])
        end
        vehicles[source] = nil
    end
end)