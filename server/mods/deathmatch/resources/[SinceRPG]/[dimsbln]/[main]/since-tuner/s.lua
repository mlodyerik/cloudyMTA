  

addEvent("setMyDimension2", true)
addEventHandler("setMyDimension2", resourceRoot, function(dim, int)
    setElementDimension(client, dim)
    if int then setElementInterior(client, 321) setElementInterior(client, int) end
    local veh = getPedOccupiedVehicle(client)
    if not veh then return end
    setElementDimension(veh, dim)
    if int then setElementInterior(veh, int) end
end)

addEvent("buyTuningAndPay", true)
addEventHandler("buyTuningAndPay", resourceRoot, function(veh, tune, visual, tint, engine, bak, variant, cost)
    takePlayerMoney(client, cost)
    for i = 0, 16 do
        removeVehicleUpgrade(veh, getVehicleUpgradeOnSlot(veh, i))
		if tune[i] then
			addVehicleUpgrade(veh, tune[i])
		end
    end

    setElementData(veh, "vehicle:wheelTuning", visual)
    setElementData(veh, "vehicle:carTint", tint)
    setElementData(veh, "vehicle:engine", engine)
    setElementData(veh, "vehicle:bak", bak)

    setVehicleVariant(veh, variant[1], variant[2])
    setElementData(veh, 'newmodels:savedVariant', {variant[1], variant[2]})
    setElementData(veh, 'vehicle:variant', {variant[1], variant[2]})
end)

addEvent("buyTuningCustom", true)
addEventHandler("buyTuningCustom", resourceRoot, function(vehicle, name, cost)
    local ups = getElementData(vehicle, "vehicle:upgrades") or {}
    if ups[name] == true then
        ups[name] = false
        givePlayerMoney(client, cost/2)
        setElementData(vehicle, "vehicle:upgrades", ups)

        exports['since-notifications']:sendNotification(client, "success", "Zdemontowano " .. name .. ". Otrzymujsz $ ".. cost/2 .."")
        return
    end

    if getPlayerMoney(client) < cost then
        return exports['since-notifications']:sendNotification(client, "error", "Nie posiadasz wystarczającej ilości gotówki!")
    end

    takePlayerMoney(client, cost)

    if name == 'remontsilnika' then
            local vehicleData = getElementData(vehicle, 'vehicle:data') or {}

            if vehicleData.mileage < 500 then
                return exports['since-notifications']:sendNotification(client, "error", "Silnik nie wymaga naprawy!")
            end

            vehicleData.mileage = 0
            setElementData(vehicle, 'vehicle:data', vehicleData)

            exports['since-notifications']:sendNotification(client, "success", "Wyremontowano silnik za "..cost.." $")
        return
    end
    
    ups[name] = true

    if name == "lpg" then
        setElementData(vehicle, "vehicle:fuellpg", 100)
    elseif name == "nitro" then
        addVehicleUpgrade(vehicle, 1010)
    end

    setElementData(vehicle, "vehicle:upgrades", ups)
    exports['since-notifications']:sendNotification(client, "success", "Zakupiono " .. name .. " za "..cost.." $")
end)