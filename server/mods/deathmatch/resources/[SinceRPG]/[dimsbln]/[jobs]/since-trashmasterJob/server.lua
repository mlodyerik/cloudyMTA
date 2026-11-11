local groups, ids, objects, blocks, vehicleSpawnPosition, binds = {}, {}, {}, {}, {2808.18, 909.65, 11.30, 1.3, 0.1, 90}, {}

addEvent('onPlayerGetGroups', true)
addEventHandler('onPlayerGetGroups', resourceRoot, function()
    triggerClientEvent(client, 'onPlayerGetGroups', resourceRoot, groups)
end)

addEvent('onPlayerLobbyCreate', true)
addEventHandler('onPlayerLobbyCreate', resourceRoot, function()
    if getElementData(client, 'player:job') then return end
    createGroup(client, false)
end)

addEvent('onPlayerJoinGroup', true)
addEventHandler('onPlayerJoinGroup', resourceRoot, function(id)
    joinGroup(client, id)
end)

addEvent('onPlayerFinishJob', true)
addEventHandler('onPlayerFinishJob', resourceRoot, function()
    leaveGroup(client)
end)

addEvent('onPlayerTryPickTrash', true)
addEventHandler('onPlayerTryPickTrash', resourceRoot, function(id, trashType)
    local group = getGroupByPlayer(client)
    if not group then 
        triggerClientEvent(client, 'turnControls', resourceRoot, 0) 
        return 
    end

    local fillUp, fillUpLimit = group.fillUp, group.fillUpLimit

    if fillUp >= fillUpLimit then
        exports['since-notifications']:sendNotification(client, 'error', 'Śmieciarka jest pełna, udaj się do punktu, aby ją opróżnić.')
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)
        return
    end

    local playersHolding = 0
    for i,v in ipairs(group.players) do
        if objects[v] then
            playersHolding = playersHolding + 1
        end
    end

    if group.object and isElement(group.object) then
        playersHolding = playersHolding + 1
    end

    if fillUp + playersHolding >= fillUpLimit then
        exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz podnieść kolejnego śmiecia, ktoś inny już trzyma inny kosz w ręce.')
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)
        return
    end
    
    local success = false
    
    for i,v in ipairs(group.objects) do
        if v.id == id then
            table.remove(group.objects, i)
            success = true
            onPlayerPickTrash(client, id, trashType)
            for k,player in ipairs(group.players) do triggerClientEvent(player, 'destroyObject', resourceRoot, id) end
            break
        end
    end

    if not success then
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)
    end
end)

addEvent('onPlayerDestroyBlip', true)
addEventHandler('onPlayerDestroyBlip', resourceRoot, function(id)   
    local group = getGroupByPlayer(client)
    if not group then return end
    for i,v in ipairs(group.blips) do
        if v.id == id then
            table.remove(group.blips, i)
            break
        end
    end
end)

addEvent('onPlayerTryPlaceTrash', true)
addEventHandler('onPlayerTryPlaceTrash', resourceRoot, function(vehicle)
    local group = getGroupByPlayer(client)
    if not group then 
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)
        return 
    end
    if vehicle ~= group.vehicle then 
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)
        return 
    end
    if not objects[client] or not isElement(objects[client]) then 
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)
        return 
    end
    local model = getElementModel(objects[client])
    if model == 1339 then
        if group.block or group.timer or group.object then 
            triggerClientEvent(client, 'turnControls', resourceRoot, 0)
            return 
        end
        group.block = true
        --exports['since-pattach']:detach(objects[client])
        detachElements(objects[client], client)
        resetAnimation(client)
        group.object = objects[client]
        objects[client] = nil
        setElementData(client, 'player:holdingTrash', nil)
        setElementFrozen(vehicle, true)
        local rx, ry, rz = getElementRotation(vehicle)
        local px2,py2,pz2 = getPositionFromElementOffset(vehicle, 0, -3.8, -0.5)
        local px5,py5,pz5 = getPositionFromElementOffset(vehicle, 0, -3.8, 0.25)
        local px3,py3,pz3 = getPositionFromElementOffset(vehicle, 0, -3.3, 0.25)
        local px4,py4,pz4 = getPositionFromElementOffset(vehicle, 0, -4, -0.25)
        local rrz3 = math.rad(rz)
        local rot1 = 0
        local rot2 = rx
        local x = -2
        if ((rx < 360) and (rx > 180)) then
            rot2 = (360-rx)
            x = 2
            rot1 = (rot2/12)
        end
        if ((rx > 0) and (rx < 180)) then
            rot1 = rx
            rot1 = (0-rot1/15)
        end
        setElementPosition(group.object, px2, py2, pz2)
        setElementRotation(group.object, rx, -ry, rz+180)
        moveObject(group.object, 2000, px3, py3, pz3, 120+(x*rot2), 0, 0, 'OutBounce')
        setTimer(function(object)
            if not isElement(object) then return end
            moveObject(object, 2000, px4, py4, pz4, -120, 0, 0, 'OutBounce')
        end, 3000, 1, group.object)
        
        triggerClientEvent(client, 'turnControls', resourceRoot, 0)

        group.timer = setTimer(function(id, client)
            local group = getGroup(id)
            if not group then return end
            if group.object then
                if isElement(group.object) then
                    destroyElement(group.object)
                end
                group.object = nil
            end
            if isElement(group.vehicle) then
                setElementFrozen(group.vehicle, false)
            end
            group.fillUp = group.fillUp + 1
            group.block = nil
            if isTimer(group.timer) then
                killTimer(group.timer)
            end
            group.timer = nil

            if isElement(client) then
                exports['since-jobs']:addPlayerJobPoints(client, 'smieciarki', 1)
            end

            local playerName = isElement(client) and getPlayerName(client):gsub('#%x%x%x%x%x%x', '') or 'Niezalogowany'
            for i,v in ipairs(group.players) do
                if client == v then
                    exports['since-notifications']:sendNotification(v, 'success', 'Wrzuciłeś śmieci do śmieciarki.\nAktualne zapełnienie śmieciarki: '..group.fillUp..'/'..group.fillUpLimit..'')
                else
                    exports['since-notifications']:sendNotification(v, 'success', 'Gracz '..playerName..' wrzucił śmieci do śmieciarki.\nAktualne zapełnienie śmieciarki: '..group.fillUp..'/'..group.fillUpLimit..'')
                end
            end

            if #group.objects == 0 then loadObjectsToGroup(group.id) end
            if group.fillUp >= group.fillUpLimit then
                for i,v in ipairs(group.players) do
                    exports['since-notifications']:sendNotification(v, 'info', 'Śmieciarka jest pełna, udaj się do punktu, aby ją opróżnić.')
                    triggerClientEvent(v, 'createBlip', resourceRoot)
                end
            end
        end, 5000, 1, group.id, client) 

    else
        if blocks[client] then 
            triggerClientEvent(client, 'turnControls', resourceRoot, 0)
            return 
        end
        blocks[client] = true
        setPedAnimation(client, 'baseball', 'Bat_3', 1.0, false, false, false, true)
        setTimer(function(client)
            local group = getGroup(group.id)
            if not group then 
                triggerClientEvent(client, 'turnControls', resourceRoot, 0)
                return 
            end

            if objects[client] then
                if isElement(objects[client]) then
                    destroyElement(objects[client])
                end
                objects[client] = nil
            end
            resetAnimation(client)

            group.fillUp = group.fillUp + 1

            if isElement(client) then
                exports['since-jobs']:addPlayerJobPoints(client, 'smieciarki', 1)
                triggerClientEvent(client, 'turnControls', resourceRoot, 0)
            end

            local playerName = isElement(client) and getPlayerName(client):gsub('#%x%x%x%x%x%x', '') or 'Niezalogowany'
            for i,v in ipairs(group.players) do
                if client == v then
                    exports['since-notifications']:sendNotification(v, 'success', 'Wrzuciłeś śmieci do śmieciarki.\nAktualne zapełnienie śmieciarki: '..group.fillUp..'/'..group.fillUpLimit..'')
                else
                    exports['since-notifications']:sendNotification(v, 'success', 'Gracz '..playerName..' wrzucił śmieci do śmieciarki.\nAktualne zapełnienie śmieciarki: '..group.fillUp..'/'..group.fillUpLimit..'')
                end
            end

            if #group.objects == 0 then loadObjectsToGroup(group.id) end
            if group.fillUp >= group.fillUpLimit then
                for i,v in ipairs(group.players) do
                    exports['since-notifications']:sendNotification(v, 'info', 'Śmieciarka jest pełna, udaj się do punktu, aby ją opróżnić.')
                    triggerClientEvent(v, 'createBlip', resourceRoot)
                end
            end

            setElementData(client, 'player:holdingTrash', nil)
            blocks[client] = nil
        end, 500, 1, client)
    end
end)

function resetAnimation(player)
    setPedAnimation(player, 'baseball', 'Bat_2', 0.0, false, false, false, false)
end

function onPlayerPickTrash(player, id, trashType)
    if getElementData(player, 'player:holdingTrash') then return end
    local group = getGroupByPlayer(player)
    if not group then return end
    setElementData(player, 'player:holdingTrash', true)
    if trashType == 1 then
        local object = createObject(1339, 0, 0, 0)
        setElementCollisionsEnabled(object, false)
        local rx, ry, rz = getElementRotation(object)
        setElementRotation(object, rx,ry,rz+180)
        attachElements(object, player, 0, 0.8, -0.165, 0, 0, 180)
        setPedAnimation(client, 'CARRY', 'crry_prtial', 4.1, true, true, true)
        objects[player] = object
        triggerClientEvent(player, 'turnControls', resourceRoot, 1, group.upgrades.fastWalk)
    else
        setPedAnimation(player, 'CARRY', 'liftup', -1, false, false, false, false)
        setTimer(function(player)
            if not isElement(player) then return end
            local object = createObject(1265, 0, 0, 0)
            setObjectScale(object, 0.5)
            setElementCollisionsEnabled(object, false)
            exports['since-pattach']:attach(object, player, 25, -0.05, -0.05, -0.05, 0, 270, 0)
            objects[player] = object
            triggerClientEvent(player, 'turnControls', resourceRoot, 1, group.upgrades.fastWalk)
        end, 500, 1, player)
    end
end

function findFreeID()
    local id = 1
    while true do
        if id > 100 then break end
        if not ids[id] then
            return id
        end
        id = id + 1
    end
end

function getGroup(id)
    for i,v in ipairs(groups) do
        if v.id == id then
            return v
        end
    end
    return false
end

function getGroupByPlayer(player)
    for i,v in ipairs(groups) do
        for k,j in ipairs(v.players) do
            if j == player then
                return v
            end
        end
    end
    return false
end

function createGroup(player, upgrade)
    if not isElement(player) then return end
    local id = findFreeID()
    ids[id] = true
    local group = {
        id = id,
        name = 'Grupa '..getPlayerName(player):gsub('#%x%x%x%x%x%x', ''),
        players = {player},
        upgrades = {
            fastWalk = false,
            moreMoney = false,
        },
        vehicle = createVehicle(408, unpack(vehicleSpawnPosition)),
        objects = {},
        fillUp = 0,
        fillUpLimit = 50,
    }
    if exports['since-jobs']:getPlayerUpgradeLevel(player, 'smieciarki', 'Sprinter') and exports['since-jobs']:getPlayerUpgradeLevel(player, 'smieciarki', 'Pojemny') > 0 then
        group.fillUpLimit = 70
    end
    if exports['since-jobs']:getPlayerUpgradeLevel(player, 'smieciarki', 'Sprinter') and exports['since-jobs']:getPlayerUpgradeLevel(player, 'smieciarki', 'Sprinter') > 0 then
        group.upgrades.fastWalk = true
    end
    if exports['since-jobs']:getPlayerUpgradeLevel(player, 'smieciarki', 'Sprinter') and exports['since-jobs']:getPlayerUpgradeLevel(player, 'smieciarki', 'Money') > 0 then
        group.upgrades.moreMoney = true
    end
    setVehicleHandling(group.vehicle, 'maxVelocity', 220)
    setVehicleHandling(group.vehicle, 'engineAcceleration', 12)
    addEventHandler('onVehicleStartEnter', group.vehicle, tryEnterVehicle)
    setElementData(group.vehicle, 'vehicle:group', id)
    setElementData(group.vehicle, 'vehicle:job', 'smieciarki')
    setElementData(group.vehicle, 'element:ghost', true)
    setElementFrozen(group.vehicle, true)
    warpPedIntoVehicle(player, group.vehicle)
    setTimer(function(vehicle)
        setElementFrozen(vehicle, false)
    end, 50, 1, group.vehicle)
    table.insert(groups, group)
    triggerClientEvent(player, 'onPlayerJoinGroup', resourceRoot, group.vehicle)
    loadObjectsToGroup(id)
    bindPlayer(player, true)
end

function joinGroup(player, id)
    local group = getGroup(id)
    if not group then return end
    if #group.players >= 4 then return end
    table.insert(group.players, player)
    warpPedIntoTrashmaster(group.vehicle, player)
    triggerClientEvent(player, 'onPlayerJoinGroup', resourceRoot, group.vehicle)
    triggerClientEvent(player, 'createObjects', resourceRoot, group.objects, group.blips)
    bindPlayer(player, true)
end

function leaveGroup(player)
    local group = getGroupByPlayer(player)
    if not group then return end
    for i,v in ipairs(group.players) do
        if v == player then
            table.remove(group.players, i)
            break
        end
    end
    if objects[player] then
        if isElement(objects[player]) then
            destroyElement(objects[player])
        end
        objects[player] = nil
    end
    blocks[player] = nil
    setElementData(player, 'player:holdingTrash', nil)
    triggerClientEvent(player, 'onPlayerLeaveGroup', resourceRoot)
    if #group.players == 0 then destroyGroup(group.id) end    
    bindPlayer(player, false)
end

function destroyGroup(id)
    local group = getGroup(id)
    if not group then return end
    ids[id] = nil
    for i,v in ipairs(group.players) do
        triggerClientEvent(v, 'onPlayerLeaveGroup', resourceRoot, group)
    end
    if group.vehicle then
        if isElement(group.vehicle) then
            destroyElement(group.vehicle)
        end
    end
    if group.object then
        if isElement(group.object) then
            destroyElement(group.object)
        end
    end
    for i,v in ipairs(groups) do
        if v.id == id then
            table.remove(groups, i)
            break
        end
    end
end

function isPlayerAllowedToVehicle(player, vehicle)
    if not isElement(player) or not isElement(vehicle) then return false end
    local group = getGroupByPlayer(player)
    if not group then return false end
    if getElementData(vehicle, 'vehicle:group') == group.id then
        return true
    end
    return false
end

function tryEnterVehicle(player)
    local vehicle = source
    if not isPlayerAllowedToVehicle(player, vehicle) then 
        cancelEvent() 
        return 
    end
end

function warpPedIntoTrashmaster(vehicle, player)
    local passengers = getVehicleOccupants(vehicle)
    if passengers[0] and passengers[1] then
        attachPlayerToVehicle(vehicle, player)
    else
        for i=0,1 do
            if not passengers[i] then
                warpPedIntoVehicle(player, vehicle, i)
                break
            end
        end
    end
end

function bindPlayer(player, state)
    if state then
        outputChatBox(' \n✔ #FFFFFFAby podnieść śmieci kliknij #22ff22E', player, 55, 255, 55, true)
        outputChatBox('✔ #FFFFFFAby stanąć na tyle śmieciarki kliknij #22ff22H\n ', player, 55, 255, 55, true)
        if binds[player] then return end
        binds[player] = true
        bindKey(player, 'h', 'down', onBinkClick)
    else
        if not binds[player] then return end
        unbindKey(player, 'h', 'down', onBinkClick)
        binds[player] = nil
    end
end

function isPlayerHasObject(player)
    if objects[player] then return true end
    return false
end

function loadObjectsToGroup(id)
    local group = getGroup(id)
    if not group then return end
    local objects = {}

    if not group.courses then
        group.courses = {}
    end

    local save = group.courses
    local new = {}

    local i = 1
    while true do
        local random = math.random(#config.trashPositions)
        if not new[random] and not save[random] then
            new[random] = true
            i = i + 1
        end
        if i > 3 then 
            break 
        end
    end

    group.courses = new

    local blips = {}

    for i,v in pairs(new) do

        table.insert(blips, {
            position = config.trashPositions[i].blip,
            id = i..'x',
        })

        for k, g in ipairs(config.trashPositions[i].points) do
            local type = math.random(1, 2)
            table.insert(objects, {
                position = g,
                model = type == 1 and 1339 or 1265,
                type = type,
                id = i..'x'..k,
            })
        end

    end

    group.blips = blips
    group.objects = objects

    for i,v in ipairs(group.players) do
        triggerClientEvent(v, 'createObjects', resourceRoot, objects, blips)
    end
end

addEventHandler('onPlayerQuit', root, function()
    leaveGroup(source)
    if objects[source] then
        if isElement(objects[source]) then
            destroyElement(objects[source])
        end
        objects[source] = nil
    end
    blocks[source] = nil
end)

addEventHandler('onResourceStop', resourceRoot, function()
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:holdingTrash') then
            setElementData(v, 'player:holdingTrash', nil)
            setPedAnimation(v)
        end
    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end

local x,y,z = 2862.76, 924.71, 10.75
local marker = createMarker(x,y,z-1, 'cylinder', 5, 255, 255, 255, 255)
setElementData(marker, 'marker:title', 'Śmieciarz')
setElementData(marker, 'marker:desc', 'Opróżnianie śmieciarki')
setElementData(marker, 'marker:icon', 'skin')
addEventHandler('onMarkerHit', marker, function(el, md)
    if not md then return end
    if el and getElementType(el) == 'vehicle' then
        local player = getVehicleOccupant(el, 0)
        if not player then return end
        local group = getGroupByPlayer(player)
        if not group then return end
        if group.fillUp == 0 then
            exports['since-notifications']:sendNotification(player, 'error', 'Śmieciarka jest pusta.')
            return
        end
        local multipiler = exports['since-jobs']:getJobMultiplier('smieciarki') or 1
        setElementFrozen(el, true)
        for i,v in ipairs(group.players) do
            if isElement(v) then
                local money = config.moneyPerTrash * group.fillUp * (group.upgrades.moreMoney and 1.3 or 1)
                local voucher = exports['since-vouchers']:getJobVoucher(v, 'smieciarki')/100
                money = money + math.floor(money * voucher)
                money = money * multipiler
                money = math.floor(money)
                givePlayerMoney(v, money)
                exports['since-jobs']:addPlayerJobEarned(v, 'smieciarki', money)
                exports['since-notifications']:sendNotification(v, 'success', 'Otrzymałeś wynagrodzenie za opróżnienie śmieciarki: $'..formatNumber(money)..'')
                triggerClientEvent(v, 'destroyBlip', resourceRoot)
            end
        end
        group.fillUp = 0
        exports['since-notifications']:sendNotification(player, 'success', 'Opróżniłeś śmieciarkę.\nAktualne zapełnienie śmieciarki: 0/'..group.fillUpLimit..'')
        setTimer(function(el)
            if isElement(el) then
                setElementFrozen(el, false)
            end
        end, 50, 1, el)
    end
end)

function formatNumber(n)
    n = tonumber(n)
    if not n then return '0' end
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end