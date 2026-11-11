oilstains = {}

function haveOffroadTires(veh)
    if getVehicleUpgradeOnSlot(veh, 12) == 1025 then
        return true
    end

    return false
end

function getVehicleSpeed(veh)
    local vx, vy, vz = getElementVelocity(veh)
    return math.sqrt(vx^2 + vy^2 + vz^2)
end

function rollVehicle(veh)
    if not veh then 
        return 
    end

    local speed = getVehicleSpeed(veh)
    local roll = haveOffroadTires(veh) and 0 or (math.random(1, 4) / 75) * (speed * 2)
    local isMinus = math.random(0, 1)

    if isMinus == 1 then
        roll = -roll
    end

    setElementAngularVelocity(veh, 0, 0, roll)
end

local timers = {}
local removing = {}

function isInFaction(plr)
    if getElementData(plr, 'player:faction') == 'SAFD' or getElementData(plr, 'player:faction') == 'SARA' then
        return true
    end

    return false
end

function addComma(number)
    number = tostring(number)
    return number:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function removeOilStain(_, _, _, element, shape)
    if not element or not shape then 
        return 
    end

    if removing[element] then
        return
    end

    removing[element] = true
    unbindKey(element, 'E', 'down', removeOilStain)
    setElementFrozen(element, true)
    setPedAnimation(element, 'BOMBER', 'BOM_Plant', -1)

    timers[element] = setTimer(function(player, shape)
        setElementFrozen(player, false)
        setPedAnimation(player, false)

        local theShape = getElementData(shape, 'oilstain:id') or false

        if theShape then
            destroyElement(oilstains[theShape])
            oilstains[theShape] = nil

            local randomMoney = math.random(800000, 1000000)
            exports['since-notifications']:sendNotification(player, 'success', 'Pomyslnie usunięto plamę oleju. Za usunięcie plamy otrzymujesz $ '..addComma(randomMoney)..'.')

            givePlayerMoney(player, randomMoney)

            if isTimer(timers[player]) then
                killTimer(timers[player])
            end

            timers[player] = nil
            removing[player] = nil
        end
    end, 2000, 1, element, shape)
end

function onHitShape(element, md)
    if not md then 
        return 
    end

    if getElementType(element) == 'vehicle' then
        rollVehicle(element)
    elseif getElementType(element) == 'player' then
        local veh = getPedOccupiedVehicle(element)

        if not veh then
            if isInFaction(element) then
                exports['since-notifications']:sendNotification(element, 'info', 'Aby usunąć plamę oleju kliknij E')
                bindKey(element, 'E', 'down', removeOilStain, element, source)
            end
        end
    end
end

function createRandomOilStain()
    local index = math.random(1, #positions)

    if oilstains[index] then
        return
    end

    local x, y, z = positions[index][1], positions[index][2], positions[index][3]
    local shape = createColSphere(x, y, z, 3)

    setElementData(shape, 'oilstain:id', index)
    oilstains[index] = shape

    addEventHandler('onColShapeHit', shape, onHitShape)

    return shape
end

function createOilStains()
    for i = 1, 10 do
        print('Creating oil stain: ' .. i)
        createRandomOilStain()
    end
end
createOilStains()
setTimer(createOilStains, 1000 * 60 * 60, 0)