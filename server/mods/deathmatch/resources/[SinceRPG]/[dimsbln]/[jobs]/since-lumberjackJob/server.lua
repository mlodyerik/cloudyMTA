local lobby, ids = {}, {}
local tpAfterPos = {-1113.59, -1645.45, 76.38}

function loadHandling(veh)
    local handling = getVehicleHandling(veh)
    setVehicleHandling(veh, 'engineAcceleration', handling['engineAcceleration'] + 3)
    setVehicleHandling(veh, 'maxVelocity', 140)
    setVehicleHandling(veh, 'steeringLock', 35)
    setVehicleHandling(veh, 'tractionLoss', handling['tractionLoss'] + 0.2)
    setVehicleHandling(veh, 'mass', 8500)
end

function getRandomCourse()
    local courses = getCourses()
    local id = math.random(#courses)
    return courses[id] and id or 1
end

function createLobby(creator, player)
    if (findLobbyByPlayer(creator) or findLobbyByPlayer(player)) then 
        return false
    end
    local id = findFreeID()
    ids[id] = true
    local actual = { id = id, creator = creator, players = {creator}, course = getRandomCourse(), objects = {}, elements = {}, objectsOnCar = {} }
    local vehicle = createVehicle(554, unpack(getVehicleCreation()))
    addEventHandler('onVehicleStartEnter', vehicle, tryEnterVehicle)
    loadHandling(vehicle)
    setElementData(vehicle, 'element:ghost', true)
    setVehicleDamageProof(vehicle, true)
    setVehicleOverrideLights(vehicle, 2)
    setVehicleColor(vehicle, 255, 255, 255)
    for i,v in ipairs(getCourses()[actual.course].points) do
        table.insert(actual.objects, {id = i})
    end
    if player then
        triggerClientEvent(player, 'onJobFinallyStart', resourceRoot, actual.course, vehicle, exports['since-jobs']:getPlayerUpgradeLevel(player, 'drwal', 'Sprinter') and exports['since-jobs']:getPlayerUpgradeLevel(player, 'drwal', 'Sprinter') > 0 and 1 or 0)
        triggerClientEvent(creator, 'onJobFinallyStart', resourceRoot, actual.course, vehicle, exports['since-jobs']:getPlayerUpgradeLevel(creator, 'drwal', 'Sprinter') and exports['since-jobs']:getPlayerUpgradeLevel(creator, 'drwal', 'Sprinter') > 0 and 1 or 0)
        table.insert(actual.players, player)
    else
        triggerClientEvent(creator, 'onJobFinallyStart', resourceRoot, actual.course, vehicle, exports['since-jobs']:getPlayerUpgradeLevel(creator, 'drwal', 'Sprinter') and exports['since-jobs']:getPlayerUpgradeLevel(creator, 'drwal', 'Sprinter') > 0 and 1 or 0)
    end
    actual.vehicle = vehicle
    actual.last = actual.course
    actual.maxSpace = exports['since-jobs']:getPlayerUpgradeLevel(creator, 'drwal', 'Pojemny') and exports['since-jobs']:getPlayerUpgradeLevel(creator, 'drwal', 'Pojemny') > 0 and getCarMax()[2] or getCarMax()[1]
    table.insert(lobby, actual)
    startJob(creator, id, true)
    if player then 
        startJob(player, id) 
    end
end

function startJob(player, id, leader)
    local lobby = findLobby(id)
    if not lobby then return end
    setElementData(player, 'player:job', 'drwal')
    if leader then
        warpPedIntoVehicle(player, lobby.vehicle, 0)
    else
        warpPedIntoVehicle(player, lobby.vehicle, 1)
    end
end

function destroyJob(id)
    local lobby = findLobby(id)
    if not lobby then return end
    local x,y,z = unpack(tpAfterPos)
    for i,v in ipairs(lobby.players) do
        setElementData(v, 'player:job', nil)
        setElementPosition(v, x,y,z)
        triggerClientEvent(v, 'onJobFinallyFinish', resourceRoot)
        triggerClientEvent(v, 'toggleMoveing', resourceRoot, true)
    end
    for i,v in pairs(lobby.objects or {}) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    if isElement(lobby.vehicle) then
        destroyElement(lobby.vehicle)
    end
    for i,v in pairs(lobby.elements or {}) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    for i,v in pairs(lobby.objectsOnCar or {}) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    removeLobby(id)
end

function onPlayerStartCutTree(player, id)
    local lobby = findLobbyByPlayer(player)
    if (not lobby) then 
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return 
    end
    if (#lobby.objects == 0) then
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    local isFound = false
    for i,v in ipairs(lobby.objects) do
        if (v.id == id) then
            if (v.isCutted and v.isCutted == player) then
                isFound = true
                break
            end
        end
    end
    if (not isFound) then
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    setElementFrozen(player, true)
    setPedAnimation(player, 'CHAINSAW', 'WEAPON_csaw')
    giveWeapon(player, 9, 1)
    setPedWeaponSlot(player, 1)
    triggerClientEvent(player, 'onPlayerStartCutTree', resourceRoot, id)
end

addEvent('onPlayerTryCutTree', true)
addEventHandler('onPlayerTryCutTree', resourceRoot, function(id)
    local lobby = findLobbyByPlayer(client)
    if (not lobby) then 
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    if (not canInteractWithAction(client, 'cutWood')) then
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    for i,v in ipairs(lobby.objects) do
        if (v.id == id) then
            if (v.isCutted) then
                triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
                return false
            else
                v.isCutted = client
                onPlayerStartCutTree(client, id)
                return true
            end
        end
    end
end)

addEvent('onPlayerCutTree', true)
addEventHandler('onPlayerCutTree', resourceRoot, function(id)
    local lobby = findLobbyByPlayer(client)
    if not lobby then return end
    if (#lobby.objects == 0) then
        return false
    end

    lobby.lock = true
    setElementFrozen(client, false)
    setPedAnimation(client, false)
    takeWeapon(client, 9)

    for i,v in ipairs(lobby.players) do
        triggerClientEvent(v, 'onPlayerCutTree', resourceRoot, id, client)
    end

    for i,v in ipairs(lobby.objects) do
        if (v.id == id) then
            if (v.isCutted == client) then
                table.remove(lobby.objects, i)
                break
            end
        end
    end

    if lobby.elements[client] then
        if isElement(lobby.elements[client]) then
            destroyElement(lobby.elements[client])
        end
        lobby.elements[client] = nil
    end

    setPedAnimation(client,'CARRY','liftup',-1,false,true,false)
    setTimer(function(client)
        if isElement(client) then
            setPedAnimation(client, 'CARRY', 'crry_prtial', 1)
            local object = createObject(1463, 0, 0, 0)
            setElementCollisionsEnabled(object, false)
            setObjectScale(object, 0.35, 0.35, 0.35)
            exports['bone_attach']:attachElementToBone(object, client, 12, 0.23,0.12,0.15,90,170,0)
            lobby.elements[client] = object
            exports['since-jobs']:addPlayerJobPoints(client, 'drwal', 1)
        end
        if (#lobby.objects == 0) then
            findNewCourse(lobby.id)
        end
        lobby.lock = nil
    end, 500, 1, client)
end)

addEvent('onPlayerTakeWood', true)
addEventHandler('onPlayerTakeWood', resourceRoot, function()
    local lobby = findLobbyByPlayer(client)
    if (not lobby) then 
        triggerClientEvent(client, 'onPlayerTakeWood', resourceRoot, true)
        return false
    end
    if (not canInteractWithAction(client, 'takeWood')) then
        triggerClientEvent(client, 'onPlayerTakeWood', resourceRoot, true)
        return false
    end
    lobby.lock = true
    if lobby.objectsOnCar[#lobby.objectsOnCar] then
        if isElement(lobby.objectsOnCar[#lobby.objectsOnCar]) then
            destroyElement(lobby.objectsOnCar[#lobby.objectsOnCar])
        end
        table.remove(lobby.objectsOnCar, #lobby.objectsOnCar)
    end
    setPedAnimation(client,'CARRY','liftup',-1,false,true,false)
    setTimer(function(client)
        if isElement(client) then
            setPedAnimation(client, 'CARRY', 'crry_prtial', 1)
            local object = createObject(1463, 0, 0, 0)
            setElementCollisionsEnabled(object, false)
            setObjectScale(object, 0.35, 0.35, 0.35)
            exports['bone_attach']:attachElementToBone(object, client, 12, 0.23,0.12,0.15,90,170,0)
            lobby.elements[client] = object
            triggerClientEvent(client, 'onPlayerTakeWood', resourceRoot, true)
        end
        lobby.lock = nil
    end, 500, 1, client)
end)

addEvent('onPlayerUnloadWood', true)
addEventHandler('onPlayerUnloadWood', resourceRoot, function()
    local lobby = findLobbyByPlayer(client)
    if (not lobby or not lobby.elements[client]) then 
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    lobby.lock = true
    setPedAnimation(client,'CARRY','liftup',-1,false,true,false)
    setTimer(function(client, id)
        if isElement(client) then
            setPedAnimation(client, false)
            if lobby.elements[client] then
                if isElement(lobby.elements[client]) then
                    destroyElement(lobby.elements[client])
                end
                lobby.elements[client] = nil
            end
            triggerClientEvent(client, 'onPlayerTakeWood', resourceRoot, false)
            checkIsCarEmpty(id)
        end
        lobby.lock = nil
    end, 500, 1, client, lobby.id)
end)

function checkIsCarEmpty(id)
    local lobby = findLobby(id)
    if (not lobby) then return end
    if (#lobby.objectsOnCar == 0) then
        local count = 0 
        for i,v in pairs(lobby.elements) do
            if (isElement(v)) then
                count = count + 1
            end
        end
        if (count > 0) then
            return false
        end
        for i,v in ipairs(lobby.players) do
            if isElement(v) then
                triggerClientEvent(v, 'onPlayerFillTruck', resourceRoot, false)
            end
        end
        lobby.filled = nil
        if (#lobby.objects == 0) then
            findNewCourse(lobby.id)
        end
        giveLobbyRewards(lobby.id)
        return true
    end
    return false
end

function giveLobbyRewards(id)
    local lobby = findLobby(id)
    if (not lobby) then
        return false
    end
    local money = getMoneyForOneWood()
    money = money * lobby.maxSpace
    money = money * exports["since-jobs"]:getJobMultiplier('drwal')
    for i,v in ipairs(lobby.players) do
        if isElement(v) then
            local money = money
            if (exports['since-jobs']:getPlayerUpgradeLevel(v, 'drwal', 'Money') and exports['since-jobs']:getPlayerUpgradeLevel(v, 'drwal', 'Money') > 0) then
                money = money * 1.3
            end
            money = math.floor(money)
            exports['since-notifications']:sendNotification(v, 'success', 'Pojazd został wyładowany. Zarobiłeś '..formatNumber(money)..' za dostarczenie drewna. Możesz kontynuować pracę')
            givePlayerMoney(v, money)
        end
    end
end

function findNewCourse(lobbyID)
    local lobby = findLobby(lobbyID)
    if (not lobby) then return end
    local course = getRandomCourse()
    while (course == lobby.last) do
        if (#getCourses() < 2) then
            break
        end
        course = getRandomCourse()
    end
    lobby.last = course
    for i,v in ipairs(lobby.players) do
        triggerClientEvent(v, 'onJobFinallyStart', resourceRoot, course)
    end
    for i,v in ipairs(getCourses()[course].points) do
        table.insert(lobby.objects, {id = i})
    end
    outputDebugString('New course loaded')
end

function canInteractWithAction(player, action)
    local lobby = findLobbyByPlayer(player)
    if (not lobby) then 
        return false
    end
    local vehicle = lobby.vehicle
    if (not vehicle or not isElement(vehicle)) then
        return false
    end
    if (action == 'putWood') then
        local count = #lobby.objectsOnCar
        local offsets = getVehicleWoodsOffsets()
        if (count >= #offsets) then
            return false
        end
        return true
    elseif (action == 'takeWood') then
        if (#lobby.objects == 0) then
            return false
        end
        if (lobby.elements[client]) then
            return false
        end
        if (#lobby.objectsOnCar == 0) then
            return false
        end
        if (lobby.lock) then
            return false
        end
        return true
    elseif (action == 'cutWood') then
        if (#lobby.objects == 0) then
            return false
        end
        if (lobby.elements[client]) then
            return false
        end
        if (lobby.lock) then
            return false
        end
        if (lobby.filled) then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz ściąć drzewa, ponieważ pojazd jest pełny. Udaj się go wyładować.')
            return false
        end
        local count = #lobby.objectsOnCar
        for i,v in pairs(lobby.elements) do
            if (isElement(v)) then
                count = count + 1
            end
        end
        for i,v in ipairs(lobby.objects) do
            if (v.isCutted) then
                count = count + 1
            end
        end
        if (count >= lobby.maxSpace) then
            exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz ściąć drzewa, ponieważ nie ma już na nie miejsca. Udaj się wyładować pojazd.')
            return false
        end
        return true
    end
end

function putWoodOnVehicle(player)
    local lobby = findLobbyByPlayer(player)
    if (not lobby) then 
        return false
    end
    local vehicle = lobby.vehicle
    if (not vehicle or not isElement(vehicle)) then
        return false
    end
    if (not canInteractWithAction(player, 'putWood')) then
        return false
    end
    local offsets = getVehicleWoodsOffsets()
    local v = offsets[#lobby.objectsOnCar + 1]
    local object = createObject(1463, 0, 0, 0)
    setElementCollisionsEnabled(object, false)
    setObjectScale(object, 0.35, 0.35, 0.35)
    attachElements(object, vehicle, v[1], v[2], v[3], 0, 0, 0)
    table.insert(lobby.objectsOnCar, object)
    if (#lobby.objectsOnCar >= lobby.maxSpace) then
        lobby.filled = true
        for i,v in ipairs(lobby.players) do
            exports['since-notifications']:sendNotification(player, 'success', 'Pojazd jest pełny udaj się go wyładować.')
            triggerClientEvent(v, 'onPlayerFillTruck', resourceRoot, true)
        end
    end
end

addEvent('onPlayerPutWood', true)
addEventHandler('onPlayerPutWood', resourceRoot, function()
    local lobby = findLobbyByPlayer(client)
    if (not lobby) then 
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    if (not lobby.elements[client]) then
        triggerClientEvent(client, 'toggleMoveing', resourceRoot, true)
        return false
    end
    setPedAnimation(client,'CARRY','liftup',-1,false,true,false)
    setTimer(function(client)
        if lobby.elements[client] then
            putWoodOnVehicle(client)
        end
        if isElement(client) then
            setPedAnimation(client, false)
            if isElement(lobby.elements[client]) then
                destroyElement(lobby.elements[client])
            end
            lobby.elements[client] = nil
            triggerClientEvent(client, 'onPlayerPutWood', resourceRoot)
        end
    end, 500, 1, client)
    takeWeapon(client, 9)
end)

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

function tryEnterVehicle(player)
    local vehicle = source
    local lobby = findLobbyByVehicle(vehicle)
    local lobbyPlayer = findLobbyByPlayer(player)
    if (not lobby or not lobbyPlayer or (lobbyPlayer.id ~= lobby.id)) then
        cancelEvent() 
        return
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

addEventHandler('onPlayerQuit', root, function()
    local lobby = findLobbyByPlayer(source)
    if (not lobby) then return end
    destroyJob(lobby.id)
end)

addEventHandler('onResourceStop', resourceRoot, function()
    local x,y,z = unpack(tpAfterPos)
    for i,v in ipairs(getElementsByType('player')) do
        if (getElementData(v, 'player:job') == 'drwal') then
            if isPedInVehicle(v) then
                removePedFromVehicle(v)
            end
            setElementPosition(v, x,y,z)
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

function findLobbyByVehicle(vehicle)
    for i,v in ipairs(lobby) do
        if v.vehicle == vehicle then
            return v
        end
    end
end

function findLobbyByPlayer(player)
    if not player then return false end
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