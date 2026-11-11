local cache = {
    position = {1477.55, -1655.79, 13.28},
    vehicleModels = {

        80124,
        411,
        80073,
        80065,
        80064,
        80006,
        585,
        558,
        442,
        559,
        562,
        467,
        495,
        489,

    },
    engine = 2.0,
    allowed = {},
}

function getRandomVehicleModel()
    return cache.vehicleModels[math.random(1, #cache.vehicleModels)]
end

function onPickupHit(player)
    if getElementType(player) ~= 'player' or isPedInVehicle(player) or not getElementData(player, 'player:sid') then return end
    local playerSID = getElementData(player, 'player:sid')
    --if not cache.allowed[playerSID] then return end
    local rows = exports['since-db']:query('select * from `since-gift` where uid = ?', playerSID)
    if #rows > 0 then
        exports['since-notifications']:sendNotification(player, 'error', 'Zebrałeś już ten prezent!')
        return
    end
    exports['since-db']:query('insert into `since-gift` set uid = ?', playerSID)

    local clr = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
    local hclr = {255, 255, 255}
    local vehicleModel = getRandomVehicleModel()
    local wheelTuning = {
        vinylRim = 0,
        vinylWounds = 0,
        wheelTilt = 0,
        innerSize = 0.8,
        wheelResize = 1,
    }
    local theEngine = string.format("%.1f", cache.engine)
    local theEngine = tonumber(theEngine)
    local vehData = {
        driver = 'Brak',
        mileage = 0,
        engine = theEngine,
    }
    local fuel = {
        count = 25,
        tank = 25,
    }
    local variant = {0,0}
    local upgrades = {}
    upgrades['tradeban'] = true

    exports['since-db']:query('INSERT INTO `since-vehicles` (`model`, `fuel`, `upgrades`, `data`, `color`, `headlight`, `wheelTuning`, `owner`, `state`, `variant`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)', vehicleModel, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(vehData), serpent.dump(clr), serpent.dump(hclr), serpent.dump(wheelTuning), playerSID, serpent.dump(variant))

    exports['since-notifications']:sendNotification(player, 'success', 'Odebrałeś prezent, otrzymujesz unikalny pojazd #47afff'..exports['since-vehiclenames']:getVehicleName(vehicleModel)..'#ffffff. Pojazd możesz odebrać w przechowalni.')
end

function loadScript()
    cache.pickup = createPickup(cache.position[1], cache.position[2], cache.position[3], 3, 1248, 0)
    setElementInterior(cache.pickup, 0)
    setElementDimension(cache.pickup, 0)
    addEventHandler('onPickupHit', cache.pickup, onPickupHit)
end
addEventHandler('onResourceStart', resourceRoot, loadScript)