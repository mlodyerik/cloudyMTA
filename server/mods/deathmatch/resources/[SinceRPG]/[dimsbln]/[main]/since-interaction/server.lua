  

local kabriolety = {

    [429] = {

        {1, 1, 2, 2},

    },

    [410] = {

        {2, 2, 1, 1},

    },

}

addEvent("vehicleEngine", true)
addEventHandler("vehicleEngine", resourceRoot, function(veh)
    if getVehicleEngineState(veh) == false then
        if getElementHealth(veh) < 400 then
            local randomize = math.random(1, 10)
            if randomize <= 2 or randomize >= 8 then
                return exports['since-notifications']:sendNotification(client, 'error', 'Silnik jest uszkodzony, spróbuj ponownie.')
            end
        end
    end

    if getElementData(veh, 'vehicle:fromRobbery') then
        if getElementData(veh, 'vehicle:keyIsBlocked') then
            exports['since-carsRobbery']:startRobbery(client, veh)
            return
        else
            exports['since-carsRobbery']:tryTurnEngine(client, veh)
            return
        end
    end

    setVehicleEngineState(veh, not getVehicleEngineState(veh))
end)

addEvent("vehicleLights", true)
addEventHandler("vehicleLights", resourceRoot, function(veh)
    setVehicleOverrideLights(veh, (getVehicleOverrideLights(veh) == 2) and 1 or 2)
end)

addEvent("turnOffEngine", true)
addEventHandler("turnOffEngine", resourceRoot, function()
    local veh = getPedOccupiedVehicle(client)
    if veh then
        setVehicleEngineState(veh, false)
    end
end)

addEvent("vehicleHandbrake", true)
addEventHandler("vehicleHandbrake", resourceRoot, function(veh)
    if getElementModel(veh) == 444 and not getElementData(veh, 'vehicle:id') then 
        return 
    end

    if getElementData(veh, 'blokada:kola') then
        return
    end

    if getElementData(veh, 'vehicle:job') and getElementData(veh, 'vehicle:job') == 'smieciarki' then
        return
    end

    setElementFrozen(veh, not isElementFrozen(veh))
end)

addEvent("vehicleDoors", true)
addEventHandler("vehicleDoors", resourceRoot, function(veh)
    setVehicleLocked(veh, not isVehicleLocked(veh))
end)

addEvent("vehicleTrunk", true)
addEventHandler("vehicleTrunk", resourceRoot, function(veh)
    setVehicleDoorOpenRatio( veh, 1, getVehicleDoorOpenRatio(veh, 1) == 1 and 0 or 1, 500 )
end)

addEvent("vehicleABS", true)
addEventHandler("vehicleABS", resourceRoot, function(veh)
    setElementData(veh, "vehicle:toggleABS", not getElementData(veh, "vehicle:toggleABS"))
end)

addEvent("vehicleLPG", true)
addEventHandler("vehicleLPG", resourceRoot, function(veh)
    setElementData(veh, "vehicle:togglelpg", not getElementData(veh, "vehicle:togglelpg"))
end)

addEvent("vehicleNitro", true)
addEventHandler("vehicleNitro", resourceRoot, function(veh)
    setElementData(veh, "vehicle:toggleNitro", not getElementData(veh, "vehicle:toggleNitro"))
end)

addEvent("vehicleChip", true)
addEventHandler("vehicleChip", resourceRoot, function(veh)
    setElementData(veh, "vehicle:toggleChip", not getElementData(veh, "vehicle:toggleChip"))

    if getElementData(veh, "vehicle:toggleChip") then
        setVehicleHandling(veh, "engineAcceleration", getVehicleHandlingProperty(veh, "engineAcceleration") + 3)
        setVehicleHandling(veh, "maxVelocity", getVehicleHandlingProperty(veh, "maxVelocity") + 30)
    else
        setVehicleHandling(veh, "engineAcceleration", getVehicleHandlingProperty(veh, "engineAcceleration") - 3)
        setVehicleHandling(veh, "maxVelocity", getVehicleHandlingProperty(veh, "maxVelocity") - 30)
    end
end)

addEvent("vehicleDrift", true)
addEventHandler("vehicleDrift", resourceRoot, function(veh)
    setElementData(veh, "vehicle:toggleDriftmode", not getElementData(veh, "vehicle:toggleDriftmode"))

    local state = getElementData(veh, "vehicle:toggleDriftmode")

    setElementData(veh, "vehicle:suspension", 0)
    setElementData(veh, "vehicle:mk1", 0)
    setElementData(veh, "vehicle:mk2", 0)
    setElementData(veh, "vehicle:mk3", 1)
    setElementData(veh, "vehicle:mk4", 0)
    setElementData(veh, "vehicle:mk5", 0)
    setElementData(veh, "vehicle:turbo", 0)

    if state then
        local handling = getModelHandling(562) 

        for k,v in pairs(handling) do
            setVehicleHandling(veh, k, v)
        end

        setVehicleHandling(veh, "suspensionForceLevel", 0.7)
        setVehicleHandling(veh, "tractionLoss", 0.85)
        setVehicleHandling(veh, "tractionMultiplier", 0.75)
        setVehicleHandling(veh, "engineInertia", -1000)
        setVehicleHandling(veh, "driveType", 'rwd')
        setVehicleHandling(veh, "steeringLock", 50)
        setVehicleHandling(veh, "tractionBias", 0.4)
        setVehicleHandling(veh, "tractionMultiplier", 0.5)
        setVehicleHandling(veh, "engineAcceleration", 35)
        setVehicleHandling(veh, "maxVelocity", 2000)
        setVehicleHandling(veh, "turnMass", 1250)
    else
        if getElementData(veh, 'baseID') then
            local handling = getModelHandling(getElementData(veh, 'baseID')) 

            for k,v in pairs(handling) do
                setVehicleHandling(veh, k, v)
            end

            exports['since-handlings']:loadVehicleCustomHandling(veh)
        else
            local handling = getModelHandling(getElementModel(veh)) 

            for k,v in pairs(handling) do
                setVehicleHandling(veh, k, v)
            end
        end
    end
end)

function getTowShape(veh)
    local result = false

    for i, v in pairs(getElementsByType('colshape')) do
        if getElementData(v, 'vehicle:shape') and getElementData(v, 'vehicle:shape') == veh then
            result = v
            break
        end
    end

    return result
end

function tryTowVehicle(veh, shape, state)
    if state == 'get' then
        if getElementModel(veh) == 578 and not getElementData(veh, "vehicle:loaded:laweta") then
            local vehicles = getElementsWithinColShape(shape, "vehicle")
            if vehicles[1] and getElementData(vehicles[1], 'vehicle:id') then
                attachElements(vehicles[1], veh, 0, -1.2, 0.5)
                setElementData(veh, "vehicle:loaded:laweta", vehicles[1])
                setElementFrozen(vehicles[1], false)
                setElementCollisionsEnabled(vehicles[1], false)
            end
        end
    elseif state == 'return' then
        if getElementModel(veh) == 578 and getElementData(veh, "vehicle:loaded:laweta") then
            local vehicle = getElementData(veh, "vehicle:loaded:laweta")

            if not isElement(vehicle) then
                return
            end
            
            if vehicle and getElementType(vehicle) == "vehicle" then
                local x, y, z = getElementPosition(vehicle)
                attachElements(vehicle, veh, 0, -9, 0)
                detachElements(vehicle, veh)
                setElementFrozen(vehicle, false)
                setElementData(veh, "vehicle:loaded:laweta", nil)
				setElementCollisionsEnabled(vehicle, true)
            end
        end
    end
end

addEvent("toggleZaladunek", true)
addEventHandler("toggleZaladunek", resourceRoot, function(veh)
    local shape = getTowShape(veh)

    if getElementData(veh, "vehicle:loaded:laweta") then
        tryTowVehicle(veh, shape, 'return')
    else
        tryTowVehicle(veh, shape, 'get')
    end
end)

addEvent("vehicleDeluxo", true)
addEventHandler("vehicleDeluxo", resourceRoot, function(veh)
    if getElementData(veh, 'vehicle:deluxomode') then
        setElementData(veh, 'vehicle:deluxomode', false)
        triggerClientEvent(client, "toggleDeluxo", resourceRoot, false)
    else
        setElementData(veh, 'vehicle:deluxomode', true)
        triggerClientEvent(client, "toggleDeluxo", resourceRoot, true)
    end
end)

addEvent("vehicleHovermode", true)
addEventHandler("vehicleHovermode", resourceRoot, function(veh)
    if getElementData(veh, 'vehicle:hovermode') then
        setElementData(veh, 'vehicle:hovermode', false)
        triggerClientEvent(client, "toggleHover", resourceRoot, false)
    else
        setElementData(veh, 'vehicle:hovermode', true)
        triggerClientEvent(client, "toggleHover", resourceRoot, true)
    end
end)

addEvent("vehicleFactionInteraction", true)
addEventHandler("vehicleFactionInteraction", resourceRoot, function(veh)
    if isElementFrozen(veh) then
        exports["since-schowki"]:toggle(veh)
    end
end)

addEventHandler("onVehicleExit", getRootElement(), function(player, seat)
    if seat == 0 then
        triggerClientEvent(player, "toggleDeluxo", resourceRoot, false)
        triggerClientEvent(player, "toggleHover", resourceRoot, false)

        if source then
            setElementData(source, "vehicle:hovermode", false)
            setElementData(source, "vehicle:deluxomode", false)
        end 
    end
end)

addEventHandler("onVehicleStartExit", getRootElement(), function(player, seat)
    if getElementType(source) ~= "vehicle" then return end
    if isVehicleLocked(source) and getElementData(source, 'vehicle:faction') ~= 'TSA' then 
        cancelEvent()
    end

    if seat ~= 0 then return end
    local veh = getPedOccupiedVehicle(player)
    if veh then
        triggerClientEvent(player, "toggleDeluxo", resourceRoot, false)
        triggerClientEvent(player, "toggleHover", resourceRoot, false)
        setElementData(veh, "vehicle:hovermode", false)
        setElementData(veh, "vehicle:deluxomode", false)
    end
end)

addEvent("turnOff", true)
addEventHandler("turnOff", resourceRoot, function(veh, part)
    if part == 'engine' then
        setVehicleEngineState(veh, false)
    elseif part == 'lights' then
        setVehicleOverrideLights(veh, 1)
    end
end)

addEvent("vehicleSwitchVariant", true)
addEventHandler("vehicleSwitchVariant", resourceRoot, function(veh)
    local var1, var2 = getVehicleVariant(veh)

    if kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2] == var2 then
        ifKabrio = 1
    elseif kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4] == var2 then
        ifKabrio = 2
    else
        ifKabrio = false
    end

    if kabriolety[getVehicleModelFromName(getVehicleName(veh))] and ifKabrio ~= false then
        if ifKabrio == 2 then
            setVehicleVariant(veh, kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1], kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2])
        else
            setVehicleVariant(veh, kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3], kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4])
        end
    end
end)

addEvent("kickPassengers", true)
addEventHandler("kickPassengers", resourceRoot, function(veh)
    if getElementData(client, 'player:job') == 'etransporter' then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz użyć tej opcji posiadając aktywny E-Transporter')
    end

    for seat,plr in pairs(getVehicleOccupants(veh)) do
        if seat ~= 0 then
            removePlayerFromVehicle(plr)
        end
    end
end)

addEvent("suspensionRegulate", true)
addEventHandler("suspensionRegulate", resourceRoot, function(veh, state)
    if state == "down" then
        local getSuspension = getVehicleHandlingProperty(veh, "suspensionForceLevel")
        
        setVehicleHandling(veh, "suspensionForceLevel", tonumber(getSuspension) - 0.10)
    elseif state == "up" then
        local getSuspension = getVehicleHandlingProperty(veh, "suspensionForceLevel")
        
        setVehicleHandling(veh, "suspensionForceLevel", tonumber(getSuspension) + 0.10)
    end
end)

addEvent("regulateMK1", true)
addEventHandler("regulateMK1", resourceRoot, function(veh, state)
    if state == "down" then
        local getmaxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(getmaxVelocity) - 5)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 0.5)
    elseif state == "up" then
        local getmaxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(getmaxVelocity) + 5)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 0.5)
    end
end)

addEvent("regulateMK2", true)
addEventHandler("regulateMK2", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 1.5)
        setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) - 0.05)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 1.5)
	    setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) + 0.05)
    end
end)

addEvent("regulateMK4", true)
addEventHandler("regulateMK4", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) - 2)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 2)
        setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) - 0.05)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) + 2)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 2)
	    --setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) + 0.05)
    end
end)

addEvent("regulateMK6", true)
addEventHandler("regulateMK6", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) - 8)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 3.5)
        setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) - 0.05)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) + 8)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 3.5)
	    setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) + 0.05)
    end
end)

addEvent("regulateECU", true)
addEventHandler("regulateECU", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) - 8)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 2.5)
        setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) - 0.05)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) + 8)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 2.5)
	    setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) + 0.05)
    end
end)

addEvent("regulateMK2137", true)
addEventHandler("regulateMK2137", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) - 200)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 20)
        setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) - 0.2)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        local getTractionLoss = getVehicleHandlingProperty(veh, "tractionLoss")
        local maxVelocity = getVehicleHandlingProperty(veh, "maxVelocity")
        
        setVehicleHandling(veh, "maxVelocity", tonumber(maxVelocity) + 200)
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 20)
	    setVehicleHandling(veh, "tractionLoss", tonumber(getTractionLoss) + 0.2)
    end
end)

addEvent("regulateMK5", true)
addEventHandler("regulateMK5", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "mass")
        
        setVehicleHandling(veh, "mass", tonumber(getengineAcceleration) - 1.5)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "mass")
        
        setVehicleHandling(veh, "mass", tonumber(getengineAcceleration) + 1.5)
    end
end)

local napedy = {

    [0] = "awd",
    [1] = "rwd",
    [2] = "fwd",
    ["awd"] = 0,
    ["rwd"] = 1,
    ["fwd"] = 2,

}

addEvent("regulateMK3", true)
addEventHandler("regulateMK3", resourceRoot, function(veh, state)
    local actualDrive = getVehicleHandlingProperty(veh, "driveType")
    if not getElementData(veh, "vehicle:mk3") then setElementData(veh, "vehicle:mk3", napedy[actualDrive]) end

    if state == "down" then
        local actualDrive = getElementData(veh, "vehicle:mk3") or 0
        if 0 >= actualDrive then return end

        setElementData(veh, "vehicle:mk3", tonumber(actualDrive) - 1)
    elseif state == "up" then
        local actualDrive = getElementData(veh, "vehicle:mk3") or 0
        if actualDrive >= 2 then return end
        
        setElementData(veh, "vehicle:mk3", tonumber(actualDrive) + 1)
    end
    local actualDrive = getElementData(veh, "vehicle:mk3") or 0
    setVehicleHandling(veh, "driveType", napedy[actualDrive])
end)

addEvent("regulateTurbo", true)
addEventHandler("regulateTurbo", resourceRoot, function(veh, state)
    if state == "down" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) - 0.35)
    elseif state == "up" then
        local getengineAcceleration = getVehicleHandlingProperty(veh, "engineAcceleration")
        
        setVehicleHandling(veh, "engineAcceleration", tonumber(getengineAcceleration) + 0.35)
    end
end)

function getActualDate()
    local time = getRealTime()
    local year = time.year + 1900
    local month = time.month + 1
    local day = time.monthday
    local hour = time.hour
    local minute = time.minute
    local second = time.second

    return string.format("%02d.%02d.%04d %02d:%02d:%02d", day, month, year, hour, minute, second)
end

addEventHandler("onVehicleEnter", root, function(plr, seat)
	if seat == 0 then
        local upgrades = getElementData(source, "vehicle:upgrades")
        if upgrades then
            local toshow = {}
            if upgrades["deluxomode"] then
                table.insert(toshow, {'deluxomode', 'C'})
            end

            if upgrades["jumpmode"] then
                table.insert(toshow, {'jumpmode', 'LCTRL'})
            end

            if getVehicleUpgradeOnSlot(source, 10) == 1086 then
                table.insert(toshow, {'stereo', 'F6'})
            end

            if #toshow > 0 then
                outputChatBox(" ", plr, 255, 175, 0, true)

                for i,v in ipairs(toshow) do
                    outputChatBox("ⓘ #ffffffAby włączyć #bfbfbf"..v[1].."#ffffff wciśnij klawisz #57abff"..v[2], plr, 255, 211, 110, true)
                end

                outputChatBox(" ", plr, 255, 175, 0, true)
            end     
        end

        if getElementData(source, 'blokada:kola') then
            setElementFrozen(source, true)
        end

        local actualDrive = getVehicleHandlingProperty(source, "driveType")
        if not (getElementData(source, "vehicle:mk3") or false) then setElementData(source, "vehicle:mk3", napedy[actualDrive]) end

        local drivers = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id = ? LIMIT 1', getElementData(source, "vehicle:id"))

        -- update last 10 drivers (delete oldest)
        if #drivers > 0 then
            local lastDrivers = fromJSON(drivers[1].drivers)
            if lastDrivers then

                if #lastDrivers >= 10 then
                    table.remove(lastDrivers, 1)
                end

                table.insert(lastDrivers, {getPlayerName(plr), getActualDate()})
                
                exports['since-db']:query('UPDATE `since-vehicles` SET drivers = ? WHERE id = ?', toJSON(lastDrivers), getElementData(source, "vehicle:id"))
            else
                local driversTable = {}
                table.insert(driversTable, {getPlayerName(plr), getActualDate()})
                exports['since-db']:query('UPDATE `since-vehicles` SET drivers = ? WHERE id = ?', toJSON(driversTable), getElementData(source, "vehicle:id"))
            end
        end

        local nitro = getElementData(source, "vehicle:id")
        if nitro then
            if getElementData(source, "vehicle:upgrades")["nitro"] then
                if not getElementData(source, "vehicle:nitroCount") then setElementData(source, "vehicle:nitroCount", 100); addVehicleUpgrade(source, 1010) end
            end
        end
    end
end)

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element ) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
 
    return false
end

function getElementSpeed(theElement, unit)
    if not theElement then
        return 
    end

    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 188 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end