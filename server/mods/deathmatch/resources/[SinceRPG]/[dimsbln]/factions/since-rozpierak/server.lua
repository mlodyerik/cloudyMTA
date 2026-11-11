local checkList = {
    ['enonek-rozpierak:start'] = {},
}

addEvent("enonek-rozpierak:start", true)
addEventHandler("enonek-rozpierak:start", resourceRoot, function(vehicle, component)

--[[if not checkList['auth:login'][client] then
        checkList['auth:login'][client] = 0
    end
    checkList['auth:login'][client] = checkList['auth:login'][client] + 1

    if checkList['auth:login'][client] > 20 then triggeringBan(client, 'since-rozpierak masywka') return end]]--

    if getVehicleDoorState(vehicle, component) == 4 then
        outputChatBox('#ff0000✖ #ffffffW pobliżu nie znaleziono drzwi!', client, 255, 255, 255, true)
        return false
    end

    setPedAnimation(client, "CHAINSAW", "csaw_part", -1, true, false, false)
    setElementFrozen(vehicle, true)
    local x, y, z = getElementPosition(client)
    triggerClientEvent(root, "enonek-rozpierak:enableSound", resourceRoot, x, y, z)
    setTimer(function()
    	if vehicle and isElement(vehicle) and component then
    		setVehicleDoorState(vehicle, component, 2)
    	end
    end, 2500, 1)

    setTimer(function(client)
    	if client and isElement(client) and vehicle and isElement(vehicle) and component then
    		setPedAnimation(client, false)
            setElementFrozen(vehicle, false)
    		setVehicleDoorState(vehicle, component, 4)
    	end
    end, 5000, 1, client)
end)

addEvent("enonek-rozpierak:synchronize", true)
addEventHandler("enonek-rozpierak:synchronize", resourceRoot, function(owner, x, y, z)
    triggerClientEvent(root, "enonek-rozpierak:client", resourceRoot, owner, x, y, z)
end)

setTimer(function()
    for i,v in pairs(checkList) do
        for player, count in pairs(v) do
            v[player] = nil
        end
    end
end, 1000, 0)

addEventHandler('onPlayerQuit', root, function()
    local plr = source
    for i,v in pairs(checkList) do
        if v[plr] then
            v[plr] = nil
        end
    end
end)