local vehicles = {}
local objects = {}

addEvent('onPlayerStartJob', true)
addEventHandler('onPlayerStartJob', resourceRoot, function(jobType)
    if vehicles[client] then
        if isElement(vehicles[client]) then
            destroyElement(vehicles[client])
        end
        vehicles[client] = nil
    end
    if objects[client] then
        for i,v in ipairs(objects[client]) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        objects[client] = nil
    end

    objects[client] = {}

    local stats = getElementData(client, 'player:jobStats') or {}
    if not stats['Aircraft'] then stats['Aircraft'] = {} end
	if not stats['Aircraft'].earned then stats['Aircraft'].earned = 0 end
	if not stats['Aircraft'].time then stats['Aircraft'].time = 0 end
    if not stats['Aircraft'].level then stats['Aircraft'].level = 1 end
    if not stats['Aircraft'].levelExp then stats['Aircraft'].levelExp = 0 end
	if not stats['Aircraft'].points then stats['Aircraft'].points = 0 end
	if not stats['Aircraft'].upgrades then stats['Aircraft'].upgrades = {} end
    setElementData(client, 'player:jobStats', stats)
    if jobType == 1 then
        local vehicle = createVehicle(593, unpack(createVehiclePosition))
        setElementData(vehicle, 'element:ghost', true)
        warpPedIntoVehicle(client, vehicle)
        vehicles[client] = vehicle
        triggerClientEvent(client, 'onPlayerStartJob', resourceRoot, jobType, vehicle)
        return
    else
        local vehicle = createVehicle(487, unpack(createVehiclePosition))
        setElementData(vehicle, 'element:ghost', true)
        warpPedIntoVehicle(client, vehicle)
        vehicles[client] = vehicle
        triggerClientEvent(client, 'onPlayerStartJob', resourceRoot, jobType, vehicle)
        return
    end
end)

addEvent('onPlayerStartEnd', true)
addEventHandler('onPlayerStartEnd', resourceRoot, function()
    if vehicles[client] then
        if isElement(vehicles[client]) then
            destroyElement(vehicles[client])
        end
        vehicles[client] = nil
    end
    if objects[client] then
        for i,v in ipairs(objects[client]) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        objects[client] = nil
    end
    triggerClientEvent(client, 'onPlayerStartEnd', resourceRoot)
end)

function getJobLevelExp(level)
    return levels[level or 1]
end

function giveJobExp(player, exp)
    local stats = getElementData(player, 'player:jobStats') or {}
    if not stats['Aircraft'] then stats['Aircraft'] = {} end
    if not stats['Aircraft'].level then stats['Aircraft'].level = 1 end
    if not stats['Aircraft'].levelExp then stats['Aircraft'].levelExp = 0 end
    stats['Aircraft'].levelExp = stats['Aircraft'].levelExp + exp
    if stats['Aircraft'].level < 5 then
        if stats['Aircraft'].levelExp >= getJobLevelExp(stats['Aircraft'].level) then
            stats['Aircraft'].level = stats['Aircraft'].level + 1
            stats['Aircraft'].levelExp = 0
            exports['since-notifications']:sendNotification(player, 'success', 'Awansujesz na kolejny poziom w pracy. Twój poziom to '..stats['Aircraft'].level..'.')
        end
    end
    setElementData(player, 'player:jobStats', stats)
end

function onPointHit(player, jobType, pointsCount)
    local level = getElementData(player, 'player:jobStats') and getElementData(player, 'player:jobStats')['Aircraft'] and getElementData(player, 'player:jobStats')['Aircraft'].level or 1
    local multipiler = exports['since-jobs']:getJobMultiplier('spedycjaLotnicza')
    local money = math.random(money[1], money[2]) * 5
    money = money * levelMultipilers[level]
    money = money * multipiler
    
    if jobType == 1 then
        money = money * 1.25
    end

    local voucher = exports['since-vouchers']:getJobVoucher(player, 'spedycjaLotnicza')/100
    money = money + math.floor(money * voucher)

    money = math.floor(money)
    exports['since-jobs']:addPlayerJobPoints(player, 'Aircraft', 1)
    exports['since-jobs']:addPlayerJobEarned(player, 'Aircraft', money)
    local srp = math.random(2,4) * multipiler
    setElementData(player, 'player:srp', getElementData(player, 'player:srp') + srp)
    givePlayerMoney(player, money)
    if pointsCount == 0 then
        exports['since-notifications']:sendNotification(player, 'success', 'Otrzymujesz '..formatNumber(money)..' za dostarczenie ostatniej paczki. Udaj się do punktu, aby załadować kolejne paczki.')
    else
        exports['since-notifications']:sendNotification(player, 'success', 'Otrzymujesz '..formatNumber(money)..' za dostarczenie paczki. Pozostało '..pointsCount..' paczek do dostarczenia.')
    end
    giveJobExp(player, math.random(4,7))
end

addEvent('onPlayerCreateObject', true)
addEventHandler('onPlayerCreateObject', resourceRoot, function(x, y, z, jobType, pointsCount)
    if not objects[client] then return end
    local px, py, pz = getElementPosition(client)
    if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 25 then return end
    local object = createObject(2903, x, y, z-3)
    setElementCollisionsEnabled(object, false)
    table.insert(objects[client], object)
    moveObject(object, 5000, x, y, z-50)
    onPointHit(client, jobType, pointsCount)
    setTimer(function(object, client)
        if not objects[client] then return end
        for i,v in ipairs(objects[client]) do
            if v == object then
                destroyElement(v)
                table.remove(objects[client], i)
                return
            end
        end
    end, 5000, 1, object, client)
end)

addEventHandler('onPlayerQuit', root, function()
    if vehicles[source] then
        if isElement(vehicles[source]) then
            destroyElement(vehicles[source])
        end
        vehicles[source] = nil
    end
    if objects[source] then
        for i,v in ipairs(objects[source]) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        objects[source] = nil
    end
end)

addEventHandler('onPlayerWasted', root, function()
    if vehicles[source] then
        if isElement(vehicles[source]) then
            destroyElement(vehicles[source])
        end
        vehicles[source] = nil
    end
    if objects[source] then
        for i,v in ipairs(objects[source]) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        objects[source] = nil
    end
    triggerClientEvent(source, 'onPlayerStartEnd', resourceRoot)
end)


function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end
