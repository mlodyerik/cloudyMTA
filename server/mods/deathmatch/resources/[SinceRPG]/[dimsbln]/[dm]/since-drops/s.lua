local objectModel = 3798
local object = nil
local blip = nil
local timer = nil
local timeToCapture = 100
local timeOfLanding = 30
local timeToNextDrop = 60*30
local positions = {
    {-2648.55, -29.51, 6.13, -0.00, 0.00, -90},
    {-2077.72, 1347.43, 7.10, -0.00, 0.00, 97.35},
    {-1731.94, 2.87, 3.55, -0.00, 0.00, 235.11},
    {-2314.46, 101.04, 35.40, -0.00, 0.00, 37.87},
    {-2568.47, 647.86, 27.81, -0.00, 0.00, 90},
    {-2706.56, 395.34, 4.37, -0.00, 0.00, -90},
}

function getRandomPosition()
    return positions[math.random(#positions)]
end

function getRandomRewards()
    local tbl = {}
    for i=1,3 do
        if i == 1 then
            table.insert(tbl, {'weapon', math.random(1,2), 2})
        elseif i == 2 then
            table.insert(tbl, {'money', math.random(1,4), 4})
        elseif i == 3 then
            table.insert(tbl, {'drugs', math.random(1,5), 5})
        end
    end
    return tbl
end

function createDrop()
    if object then
        destroyElement(object)
        object = nil
    end
    if blip then
        destroyElement(blip)
        blip = nil
    end
    local x,y,z,rx,ry,rz = unpack(getRandomPosition())
    z = z - 1
    object = createObject(objectModel, x,y,z + 100, rx,ry,rz)
    blip = createBlipAttachedTo(object, 34, 2, 255,255,255,255,0,500)
    setElementDoubleSided(object, true)
    local data = {
        rewards = getRandomRewards(),
        landing = true,
        maxTime = timeToCapture,
    }
    setElementData(object, 'drop:data', data)
    moveObject(object, timeOfLanding*1000, x,y,z)
    setTimer(function()
        if not object then return end
        local data = getElementData(object, 'drop:data') or {}
        data.landing = nil
        setElementData(object, 'drop:data', data)
    end, timeOfLanding*1000, 1)
    setTimer(function()
        triggerClientEvent(root, 'event', resourceRoot)
    end, 500, 1)
end

function givePlayerRewards(player, rewards)
    if not isElement(player) then return end
    if not rewards then return end
    local finalRewards = {}
    for i,v in ipairs(rewards) do
        if v[1] == 'money' then
            local randomMoney = math.random(2000000,5000000)*v[2]
            givePlayerMoney(player, randomMoney)
            table.insert(finalRewards, formatNumber(randomMoney)..' $')
        elseif v[1] == 'weapon' then
            local tbl = {
                'ak-47',
                'awm',
                'm4',
                'shotgun',
                'mp5',
                'desert-eagle',
            }
            local random = math.random(#tbl)
            exports['since-inventory']:addPlayerItem(player, tbl[random], tonumber(v[2]))
            table.insert(finalRewards, string.gsub(tbl[random], '-', ' ')..' x'..v[2])
        elseif v[1] == 'drugs' then
            local tbl = {
                'top-marihuana',
                'top-sativa',
                'top-lemonhaze',
                'top-indica',
                'top-kush',
                'top-bluedream',
                'top-platinumog',
                'top-ruderalis',
            }
            local random = math.random(#tbl)
            local randomValue = math.random(4,8)*v[2]
            exports['since-inventory']:addPlayerItem(player, tbl[random], randomValue)
            table.insert(finalRewards, string.gsub(tbl[random], '-', ' ')..' x'..randomValue)
        end
    end
    exports['since-notifications']:sendNotification(player, 'success', 'W zrzucie znajdujesz: '..table.concat(finalRewards, ', '))
end

function checkIfPlayerCanInteract(player)
    if not object then return false end
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then return false end
    if isPedDead(player) then return false end
    if getElementData(player, 'player:admin') then return false end
    local px,py,pz = getElementPosition(player)
    local ox,oy,oz = getElementPosition(object)
    if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 10 then return false end
    return true
end

addEvent('dropsEvent', true)
addEventHandler('dropsEvent', resourceRoot, function()
    local data = getElementData(object, 'drop:data')
    if not data or data.landing or data.isTaken then return end
    data.isTaken = true
    data.player = client
    data.time = timeToCapture
    setElementData(object, 'drop:data', data)
    exports['since-notifications']:sendNotification(client, 'success', 'Rozpoczynasz przejmowanie zrzutu')
    if timer then
        killTimer(timer)
        timer = nil
    end
    timer = setTimer(function()
        if not isElement(object) then return end
        local data = getElementData(object, 'drop:data') or {}
        data.time = data.time - 1
        setElementData(object, 'drop:data', data)
        if not checkIfPlayerCanInteract(data.player) then
            restartDropStats()
            exports['since-notifications']:sendNotification(data.player, 'info', 'Zdobywanie dropu zostało przerwane.')
            if timer then
                killTimer(timer)
                timer = nil
            end
            return
        end
        if data.time <= 0 then
            givePlayerRewards(data.player, data.rewards)
            setTimer(function()
                setElementData(object, 'drop:data', nil)
                if blip then
                    destroyElement(blip)
                    blip = nil
                end
            end, 1000, 1)
            setTimer(function()
                createDrop()
            end, timeToNextDrop*1000, 1)
            if timer then
                killTimer(timer)
                timer = nil
            end
        end
    end, 1000, timeToCapture)
end)

function checkIsCapturing(player)
    if not isElement(player) then return false end
    if not object then return false end
    local data = getElementData(object, 'drop:data')
    if not data then return false end
    if data.isTaken and data.player == player then
        return true
    end
    return false
end

function restartDropStats()
    if not object then return end
    local data = getElementData(object, 'drop:data')
    if not data then return end
    if timer then
        killTimer(timer)
        timer = nil
    end
    data.isTaken = nil
    data.player = nil
    data.time = timeToCapture
    setElementData(object, 'drop:data', data)
end

addEventHandler('onPlayerWasted', root, function()
    if checkIsCapturing(source) then
        restartDropStats()
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if checkIsCapturing(source) then
        restartDropStats()
    end
end)

addEventHandler('onResourceStart', resourceRoot, createDrop)

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