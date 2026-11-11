local attachedSpaces, bindedPlayers, bindCouldown = {}, {}, {}

function isPlayerAttached(player)
    for i,v in ipairs(attachedSpaces) do
        for k,j in ipairs(v.players) do
            if j == player then
                return true
            end
        end
    end
    return false
end

function getPlayerAttachedData(player)
    for i,v in ipairs(attachedSpaces) do
        for k,j in ipairs(v.players) do
            if j == player then
                return v
            end
        end
    end
    return false
end

function isVehicleInTable(vehicle)
    for i,v in ipairs(attachedSpaces) do
        if v.vehicle == vehicle then
            return true
        end
    end
    return false
end

function attachPlayerToVehicle(vehicle, player)
    if not isElement(vehicle) then return end
    if isPlayerAttached(player) then return end
    if isPedInVehicle(player) then return end
    if getElementDimension(player) ~= getElementDimension(vehicle) then setElementDimension(player, getElementDimension(vehicle)) end
    if getElementInterior(player) ~= getElementInterior(vehicle) then setElementInterior(player, getElementInterior(vehicle)) end

    triggerClientEvent(player, 'attackInteraction', resourceRoot, 'attach', vehicle)
end

function detachPlayerFromVehicle(player, isOn)
    if not isPlayerAttached(player) then return end
    local data = getPlayerAttachedData(player)
    if not data then return end
    for i,v in ipairs(data.players) do
        if v == player then
            table.remove(data.players, i)
            break
        end
    end
    
    detachElements(player)
    setPedAnimation(player)
    if not isOn then
        triggerClientEvent(player, 'attackInteraction', resourceRoot, 'disable')
    end
    setCameraTarget(player, player)

    checkAttachedSpaces(getPlayerAttachedData(player))
end

function checkAttachedSpaces(data)
    if not data then return end
    for i,v in ipairs(data.players) do
        if not isElement(v) or getElementAttachedTo(v) ~= data.vehicle then
            table.remove(data.players, i)
        end
    end
end

function stickToVehicle(player, vehicle, space)
    if not isElement(player) or not isElement(vehicle) then return end
    if space == 1 then
        attachElements(player, vehicle, 1.2, -3.5, -0.1, 0, 0, 0)
        setPedAnimation(player, 'PED', 'gang_gunstand', -1, false)
    elseif space == 2 then
        attachElements(player, vehicle, -1.2, -3.5, -0.1, 0, 0, 0)
        setPedAnimation(player, 'MISC', 'Hiker_Pose_L', -1, false)
    end
    triggerClientEvent(player, 'attackInteraction', resourceRoot, 'enable', vehicle, space == 1 and 45 or 270)
    triggerClientEvent(client, 'attackInteraction', resourceRoot, 'refresh')
end

function onBinkClick(player)
    if not isElement(player) then return end
    if bindCouldown[player] and bindCouldown[player] > getTickCount() then return end
    bindCouldown[player] = getTickCount()+500
    if isPlayerAttached(player) then
        detachPlayerFromVehicle(player)
        return
    end
    if isPedDead(player) then return end
    local group = getGroupByPlayer(player)
    if not group then return end
    if not isElement(group.vehicle) then return end
    if not isPlayerAllowedToVehicle(player, group.vehicle) then return end
    if isPlayerHasObject(player) then return end
    triggerClientEvent(player, 'attackInteraction', resourceRoot, 'tryAttach')
end

addEvent('attackInteraction', true)
addEventHandler('attackInteraction', resourceRoot, function(action, vehicle)
    if action == 'attach' then
        if not isElement(vehicle) then triggerClientEvent(client, 'attackInteraction', resourceRoot, 'refresh') return end

        if not isPlayerAllowedToVehicle(client, vehicle) then triggerClientEvent(client, 'attackInteraction', resourceRoot, 'refresh') return end

        if isVehicleInTable(vehicle) then
            local space = false
            for i,v in ipairs(attachedSpaces) do
                if v.vehicle == vehicle then
                    space = v
                    break
                end
            end
            checkAttachedSpaces(space)
            if #space.players < 2 then
                table.insert(space.players, client)
                stickToVehicle(client, vehicle, #space.players)
            end
        else
            table.insert(attachedSpaces, {vehicle = vehicle, players = {client}})
            stickToVehicle(client, vehicle, 1)
        end

    end
end)

addEventHandler('onPlayerWasted', root, function()
    if not isPlayerAttached(source) then return end
    detachPlayerFromVehicle(source)
end)

addEventHandler('onPlayerQuit', root, function()
    bindedPlayers[source] = nil
    bindCouldown[source] = nil
end)

addEventHandler('onElementDestroy', root, function()
    if getElementType(source) ~= 'vehicle' then return end
    for i,v in ipairs(attachedSpaces) do
        if v.vehicle == source then
            for k,j in ipairs(v.players) do
                detachPlayerFromVehicle(j)
            end
            table.remove(attachedSpaces, i)
        end
    end
end)

addEventHandler('onResourceStop', resourceRoot, function()
    for i, player in ipairs(getElementsByType('player')) do
        if isPlayerAttached(player) then
            detachPlayerFromVehicle(player, true)
            setCameraTarget(player, player)
        end
    end
end)