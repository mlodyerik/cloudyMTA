local lobby = {}
local ids = {}

addEvent('onPlayerSendInvite', true)
addEventHandler('onPlayerSendInvite', resourceRoot, function(playerID)
    local target = findPlayer(playerID)
    if target then
        if getElementData(target, 'player:job') then
            exports['since-notifications']:sendNotification(client, 'error', 'Gracz '..getPlayerName(target)..' jest już w trakcie pracy')
            triggerClientEvent(target, 'onPlayerCancelInvite', resourceRoot)
            return
        end
        exports['since-notifications']:sendNotification(client, 'success', 'Wysłałeś zaproszenie do składu dla gracza '..getPlayerName(target)..' (będzie one aktywne przez 30 sekund)')
        exports['since-notifications']:sendNotification(target, 'info', 'Otrzymałeś zaproszenie do składu od gracza '..getPlayerName(client)..' (będzie one aktywne przez 30 sekund)')
        triggerClientEvent(target,'onPlayerGetInvite', resourceRoot, getElementData(client, 'id'))
    else
        exports['since-notifications']:sendNotification(client, 'error', 'Nie znaleziono wybranego gracza')
        triggerClientEvent(target, 'onPlayerCancelInvite', resourceRoot)
    end
end)

addEvent('onPlayerCancelInvite', true)
addEventHandler('onPlayerCancelInvite', resourceRoot, function(playerID)
    local target = findPlayer(playerID)
    if target then
        exports['since-notifications']:sendNotification(target, 'error', 'Gracz '..getPlayerName(client)..' nie zaakceptował zaproszenia do składu')
        triggerClientEvent(target, 'onPlayerCancelInvite', resourceRoot)
    end
end)

addEvent('onPlayerAcceptInvite', true)
addEventHandler('onPlayerAcceptInvite', resourceRoot, function(playerID)
    local target = findPlayer(playerID)
    if target then
        exports['since-notifications']:sendNotification(target, 'success', 'Gracz '..getPlayerName(client)..' zaakceptował zaproszenie do składu')
        createLobby(target, client)
        triggerClientEvent(target, 'onPlayerAcceptInvite', resourceRoot)
    end
end)

addEvent('onPlayerSingleStart', true)
addEventHandler('onPlayerSingleStart', resourceRoot, function()
    createLobby(client)
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', resourceRoot, function()
    local lobby = findLobbyByPlayer(client)
    if not lobby then return end
    destroyJob(lobby.id)
end)

addEvent('onPlayerTryInteractMowerWithTrailer', true)
addEventHandler('onPlayerTryInteractMowerWithTrailer', resourceRoot, function(isInVehicle)
    if isInVehicle then
        leaveMowerOnTrailer(client)
    else
        getMowerFromTrailer(client)
    end
end)

addEvent('onPlayerHitGrass', true)
addEventHandler('onPlayerHitGrass', resourceRoot, function(id, percentage, count)
    local lobby = findLobbyByPlayer(client)
    if not lobby then return end
    if id then
        if #lobby.players > 1 then
            for i,v in ipairs(lobby.players) do
                if v ~= client then
                    triggerClientEvent(v, 'onPlayerHitGrass', resourceRoot, id, percentage)
                end
            end
        end
    end
    if count == 0 then 
        onLobbyFinishedCourse(lobby.id) 
        exports['since-logs']:sendDiscordLog('debug-kosiarki', 'Logi', 'Grupa **#'..lobby.id..'** gracz **'..getPlayerName(client)..'** hituje grasa zostaje **'..count..'** krzaków')
    end
end)

addEvent('onPlayerCuboidHit', true)
addEventHandler('onPlayerCuboidHit', resourceRoot, function(id)
    local lobby = findLobbyByPlayer(client)
    if not lobby then return end
    if #lobby.players > 1 then
        for i,v in ipairs(lobby.players) do
            if v ~= client then
                triggerClientEvent(v, 'onPlayerCuboidHit', resourceRoot)
            end
        end
    end
end)

function onLobbyFinishedCourse(id)
    local lobby = findLobby(id)
    if not lobby then return end
    if lobby.moneyTick > getTickCount() then return end
    lobby.moneyTick = getTickCount() + 15000
    local course = getRandomCourse(lobby.lastCourse)
    lobby.actualCourse = course
    lobby.lastCourse = course
    local multipiler = exports["since-jobs"]:getJobMultiplier('kosiarki')
    local money = math.random(getCourseData(course).money[1], getCourseData(course).money[2]) * multipiler
    local srp = math.random(2,6) * multipiler
    for i,v in ipairs(lobby.players) do
        local money = money
        for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel(v, "kosiarki", 'Money') do
            money = money * (1.1)
        end
        if getElementData(v, 'player:diamond') then
            money = money * (1.25)
        end

        local voucher = exports['since-vouchers']:getJobVoucher(v, 'kosiarki')/100
        money = money + math.floor(money * voucher)

        money = math.floor(money)
        exports["since-jobs"]:addPlayerJobPoints(v, "kosiarki", 1)
        exports["since-jobs"]:addPlayerJobEarned(v, "kosiarki", money)
        setElementData(v, 'player:srp', getElementData(v, 'player:srp') + srp)
        triggerClientEvent(v, 'onLobbyFinishedCourse', resourceRoot, course, money)
        exports['since-notifications']:sendNotification(v, 'success', 'Skosiłeś cały teren i zarobiłeś '..money..' $, udaj się do następnego punktu na mapie')
        givePlayerMoney(v, money)
    end
end

function loadHandling(veh)
    local handling = getVehicleHandling(veh)
    setVehicleHandling(veh, 'engineAcceleration', handling['engineAcceleration'] + 3)
    setVehicleHandling(veh, 'maxVelocity', 140)
    setVehicleHandling(veh, 'steeringLock', 35)
    setVehicleHandling(veh, 'tractionLoss', handling['tractionLoss'] + 0.2)
    setVehicleHandling(veh, 'mass', 8500)
end

function createLobby(creator, player)
    if findLobbyByPlayer(creator) then return end
    if findLobbyByPlayer(player) then return end
    local id = findFreeID()
    ids[id] = true
    local data = {
        id = id,
        players = {},
        leader = creator,
        vehicle = createVehicle(552, 2445.94, 113.00, 26.10, 359.5, 360.0, 269.1),
        trailer = createVehicle(611, 2440.42, 113.08, 26.10, 359.5, 360.0, 269.2),
        mowers = {},
        objects = {},
        actualCourse = getRandomCourse(),
        moneyTick = getTickCount()
    }
    data.lastCourse = data.actualCourse
    loadHandling(data.vehicle)
    setElementData(data.vehicle, 'element:ghost', true)
    setElementData(data.trailer, 'element:ghost', true)
    setElementData(data.trailer, 'trailer:owner', creator)
    setVehicleDamageProof(data.vehicle, true)
    setVehicleDamageProof(data.trailer, true)
    table.insert(data.players, creator)
    attachTrailerToVehicle(data.vehicle, data.trailer)
    setVehicleOverrideLights(data.trailer, 1)
    local vehicle = createVehicle(572, 1146.97, -1801.58+2, 33.32, 359.1, 0.0, 92.3)
    setElementFrozen(vehicle, true)
    setVehicleColor(vehicle, 255, 255, 255)
    setElementData(vehicle, 'element:ghost', true)
    setVehicleDamageProof(vehicle, true)
    data.mowers[creator] = vehicle
    setElementCollisionsEnabled(data.mowers[creator], false)
    attachElements(data.mowers[creator], data.trailer, 0, 0.1, 0.32)
    if player then 
        triggerClientEvent(player, 'onJobFinallyStart', resourceRoot, data.actualCourse, getElementData(creator, 'id'))
        triggerClientEvent(creator, 'onJobFinallyStart', resourceRoot, data.actualCourse, getElementData(player, 'id'))
        table.insert(data.players, player) 
        local vehicle = createVehicle(572, 1146.97, -1801.58+4, 33.32, 359.1, 0.0, 92.3)
        setElementFrozen(vehicle, true)
        setVehicleDamageProof(vehicle, true)
        setVehicleColor(vehicle, 255, 255, 255)
        setElementData(vehicle, 'element:ghost', true)
        data.mowers[player] = vehicle
        setElementCollisionsEnabled(data.mowers[player], false)
        attachElements(data.mowers[player], data.trailer, 0, -2.2, 0.32)
    else
        triggerClientEvent(creator, 'onJobFinallyStart', resourceRoot, data.actualCourse)
    end
    table.insert(lobby, data)
    startJob(creator, id, true)
    if player then 
        startJob(player, id) 
    end
    print('Lobby '..id..' created')
end

function getMowerFromTrailer(player)
    local lobby = findLobbyByPlayer(player)
    if not lobby then return end

    if not isElementAttached(lobby.mowers[player]) then
        return
    end

    local x,y,z = getPositionFromElementOffset(lobby.trailer, 0, -4.2, 0.2)
    detachElements(lobby.mowers[player], lobby.trailer)
    setElementCollisionsEnabled(lobby.mowers[player], true)
    warpPedIntoVehicle(player, lobby.mowers[player], 0)
    setElementPosition(lobby.mowers[player], x,y,z)
    local _,_,rot = getElementRotation(lobby.trailer)
    setElementRotation(lobby.mowers[player],0,0,rot)

    local object = createObject(1337, 1146.97, -1801.58+2, 33.32, 0, 0, 0)
    setElementCollisionsEnabled(object, false)
    attachElements(object, lobby.mowers[player], 0, -1.35, 0.05)
    table.insert(lobby.objects, object)
    lobby.objects[player] = object

    setElementFrozen(lobby.mowers[player], false)
end

function leaveMowerOnTrailer(player)
    local lobby = findLobbyByPlayer(player)
    if not lobby then return end
    
    if isElementAttached(lobby.mowers[player]) then
        return
    end

    if lobby.objects[player] then
        if isElement(lobby.objects[player]) then
            destroyElement(lobby.objects[player])
        end
        lobby.objects[player] = nil
    end

    removePedFromVehicle(player)
    setElementCollisionsEnabled(lobby.mowers[player], false)
    setVehicleOverrideLights(lobby.mowers[player], 1)
    if lobby.leader == player then
        attachElements(lobby.mowers[player], lobby.trailer, 0, 0.1, 0.32)
    else
        attachElements(lobby.mowers[player], lobby.trailer, 0, -2.2, 0.32)
    end
end

function startJob(player, id, leader)
    local lobby = findLobby(id)
    if not lobby then return end
    setElementData(player, 'player:job', 'kosiarki')
    if leader then
        warpPedIntoVehicle(player, lobby.vehicle, 0)
    else
        warpPedIntoVehicle(player, lobby.vehicle, 1)
    end
end

function destroyJob(id)
    local lobby = findLobby(id)
    if not lobby then return end
    for i,v in ipairs(lobby.players) do
        setElementData(v, 'player:job', nil)
        setElementPosition(v, 2430.86, 112.37, 26.47)
        triggerClientEvent(v, 'onJobFinallyFinish', resourceRoot)
    end
    for i,v in pairs(lobby.mowers) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    for i,v in pairs(lobby.objects) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    if isElement(lobby.vehicle) then
        destroyElement(lobby.vehicle)
    end
    if isElement(lobby.trailer) then
        destroyElement(lobby.trailer)
    end
    removeLobby(id)
end

addEventHandler('onPlayerQuit', root, function()
    for i,v in ipairs(lobby) do
        for i2,player in ipairs(v.players) do
            if player == source then
                destroyJob(v.id)
            end
        end
    end
end)

addEventHandler('onVehicleStartEnter', resourceRoot, function(player, seat, isJacked)
    if isJacked then cancelEvent() return end
    local lobby = findLobbyByPlayer(player)
    if lobby then
        if source == lobby.vehicle then
            for i,v in ipairs(lobby.players) do
                if v == player then
                    return
                end
            end
        elseif source == lobby.mowers[player] and not isElementAttached(lobby.mowers[player]) then
            return
        end
    end
    cancelEvent()
end)

function refreshTrailer(veh)
    if veh and isElement(veh) then
        attachTrailerToVehicle(veh, source)
    elseif (not isElement(veh)) then
        destroyElement(source)
    end
end
addEventHandler("onTrailerDetach", resourceRoot, refreshTrailer)

addEventHandler('onResourceStop', resourceRoot, function()
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:job') == 'kosiarki' then
            if isPedInVehicle(v) then
                removePedFromVehicle(v)
            end
            setElementPosition(v, 2430.86, 112.37, 26.47)
            setElementData(v, 'player:job', nil)
        end
    end
end)

function findLobby(id)
    for i,v in ipairs(lobby) do
        if v.id == id then
            return v
        end
    end
end

function findLobbyByPlayer(player)
    for i,v in ipairs(lobby) do
        for i2,player2 in ipairs(v.players) do
            if player2 == player then
                return v
            end
        end
    end
end

function removeLobby(id)
    for i,v in ipairs(lobby) do
        if v.id == id then
            ids[id] = nil
            table.remove(lobby, i)
            break
        end
    end
end

function findFreeID()
    local id = 1
    while true do
        if not ids[id] then
            return id
        end
        id = id + 1
    end
end

function findPlayer(id)
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'id') == id then
            return v
        end
    end
    return false
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function saveInFile(name, text)
    local file = fileOpen(name..".txt")
    if not file then
        file = fileCreate(name..".txt")
    end
    fileSetPos(file, fileGetSize(file))
    fileWrite(file, text:gsub("#%x%x%x%x%x%x", "").."\r")
    fileFlush(file)
    fileClose(file)
end

--[[addEventHandler('onResourceStart', resourceRoot, function()
    local x, y, z = 1116.74, -1828.92, 33.63 - 1
    local offset = 2.5
    for i=1,100 do
        saveInFile('positions', '{'..x..', '..y..', '..z..'}')
        --createObject(753, x, y, z, 0, 0, 0)
        if i % 10 == 0 then
            x = x - (10 * offset)
            y = y + offset
        end
        x = x + offset
    end
end)]]