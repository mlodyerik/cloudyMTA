usingPositions = {}
bots = exports['since-bots']

function table.find(t, value)
    for i, v in pairs(t) do
        if v == value then
            return i
        end
    end
    return false
end

function getWeaponSlot(weaponID)
    local slot = false
    for i, v in pairs(settings.weaponSlots) do
        if table.find(v, weaponID) then
            slot = i
            break
        end
    end
    return slot
end

function initBot(index)
    if not usingPositions[index] then
        local x, y, z, rx, ry, rz = unpack(settings.positions[index])
        local pedName = settings.names[math.random(1, #settings.names)]
        local level = math.random(1, 10)
        local skin = settings.skins[math.random(1, #settings.skins)]
        local randomWeapon = settings.levelWeapons[level][math.random(1, #settings.levelWeapons[level])]

        local bot = bots:spawnBot(x, y, z, rz, skin, 0, 0, false, randomWeapon, 'guarding')

        setTimer(function(bot)
            exports['since-bots']:setBotAttackEnabled(bot, false)
        end, 1000, 2, bot)

        setElementData(bot, 'bot:data', {name = pedName, level = level, shooting = false})
        usingPositions[index] = bot
    end
end

function initBots()
    for i, v in ipairs(settings.positions) do
        if not usingPositions[i] then
            local x, y, z, rx, ry, rz = unpack(v)
            local pedName = settings.names[math.random(1, #settings.names)]
            local level = math.random(1, 10)
            local skin = settings.skins[math.random(1, #settings.skins)]
            local randomWeapon = settings.levelWeapons[level][math.random(1, #settings.levelWeapons[level])]

            local bot = bots:spawnBot(x, y, z, rz, skin, 0, 0, false, randomWeapon, 'guarding')

            setTimer(function(bot)--
                exports['since-bots']:setBotAttackEnabled(bot, false)
            end, 1000, 2, bot)

            setElementData(bot, 'bot:data', {name = pedName, level = level, shooting = false})
            usingPositions[i] = bot
        end
    end
end
setTimer(initBots, 60000 * 5, 0)
addEventHandler('onResourceStart', resourceRoot, initBots)

local switched = {}

addEvent('switchBotAttack', true)
addEventHandler('switchBotAttack', resourceRoot, function(bot, attacker, toggle)
    if bot and attacker then
        if not switched[bot] then
            switched[bot] = true
            exports['since-bots']:setBotAttackEnabled(bot, toggle)
            exports['since-bots']:setBotChase(bot, attacker)
            setElementData(bot, 'bot:data', {name = getElementData(bot, 'bot:data').name, level = getElementData(bot, 'bot:data').level, shooting = toggle})
        end 
    end
end)

function createPickupBots(player, x, y, z, level)
    local pickup = createPickup(x, y, z, 3, 1276)
    setElementData(pickup, 'pickup:owner', player)
    setElementData(pickup, 'pickup:level', level)
    
    addEventHandler('onPickupHit', pickup, function(hitElement)
        if hitElement and getElementType(hitElement) == 'player' then
            local owner = getElementData(source, 'pickup:owner')

            if owner and owner == hitElement then
                local level = getElementData(source, 'pickup:level')

                local randomPrice = settings.prices[level][math.random(1, #settings.prices[level])]

                local givePrice = randomPrice.add(hitElement)
                exports['since-notifications']:sendNotification(hitElement, 'success', 'Przeszukano martwego przeciwnika i znaleziono ' .. givePrice .. '.')

                destroyElement(source)
            else
                cancelEvent()
            end
        end
    end)
end

local pickups = {}

addEvent('killPed', true)
addEventHandler('killPed', resourceRoot, function(attacker, ped)
    if ped and getElementData(ped, 'bot:data') then
        for i, v in ipairs(usingPositions) do
            if v == ped then
                usingPositions[i] = nil

                setTimer(function(index)
                    initBot(index)
                end, 60000 * 5, 1, i)
            end
        end

        local x, y, z = getElementPosition(ped)
        local level = getElementData(ped, 'bot:data').level

        if not pickups[ped] then
            pickups[ped] = true
            createPickupBots(attacker, x, y, z, level)
            print(getPlayerName(attacker) .. ' killed bot')
        end

        killPed(ped)
    end
end)