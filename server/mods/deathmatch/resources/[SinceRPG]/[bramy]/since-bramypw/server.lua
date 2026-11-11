timers = {}

function findGateByID(id)
    local gate = nil

    local objects = getElementsByType('object', resourceRoot)

    for i, v in ipairs(objects) do
        if getElementData(v, 'gate:id') == id then
            gate = v
            break
        end
    end

    return gate
end

function moveGate(id, gate)
    local gate = findGateByID(id)
    
    if gate then
        if isTimer(timers[id]) then
            return
        end

        local x, y, z = gates[id].x, gates[id].y, gates[id].z

        moveObject(gate, 1800, x, y, z - 7, 0, 0, 0)

        timers[id] = setTimer(function(gate, x, y, z)
            moveObject(gate, 1800, x, y, z, 0, 0, 0)

            if isTimer(timers[id]) then
                killTimer(timers[id])
                timers[id] = nil
            end
        end, 2500, 1, gate, x, y, z)
    end
end

function applyConfig()
    for i, v in ipairs(gates) do
        local x, y, z, rot, gateType, value, id, rx, ry, rz, size = v.x, v.y, v.z, v.rot, v.type, v.value, v.id, v.rx, v.ry, v.rz, v.size
        
        gate = createObject(id, x, y, z, rx, ry, rot)
       --gate = createObject(id, x, y, z, 0, 0, rot)
        setElementData(gate, 'gate:id', i)

        gateCol = createColSphere(x, y, z, v.size or 8)
        setElementData(gateCol, 'sphere:id', i)
        setElementData(gateCol, 'gate:data', {
            type = gateType,
            value = value
        })

        addEventHandler('onColShapeHit', gateCol, function(hitElement)
            if getElementType(hitElement) == 'player' then
                local gateID = getElementData(source, 'sphere:id')

                if gateID then
                    local gateData = getElementData(source, 'gate:data')

                    if not gateData then
                        return
                    end

                    if gateData.type == 'org' then
                        local orgData = getElementData(hitElement, 'player:organization')
                        if orgData then
                            if orgData.name == value then
                                local theGate = findGateByID(gateID)
                                moveGate(gateID, theGate)
                            else
                                exports['since-notifications']:sendNotification(hitElement, 'error', 'Nie posiadasz dostępu do tej bramy')
                            end
                        end
                    elseif gateData.type == 'private' then
                        local owner = gateData.value
                        local playerSID = getElementData(hitElement, 'player:sid')

                        if playerSID == owner then
                            local theGate = findGateByID(gateID)
                            moveGate(gateID, theGate)
                        else
                            exports['since-notifications']:sendNotification(hitElement, 'error', 'Nie posiadasz dostępu do tej bramy')
                        end
                    elseif gateData.type == 'faction' then
                        local result = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid = ? and faction = ?', getElementData(hitElement, 'player:sid'), value)

                        if #result > 0 then
                            local theGate = findGateByID(gateID)
                            moveGate(gateID, theGate)
                        else
                            exports['since-notifications']:sendNotification(hitElement, 'error', 'Nie posiadasz dostępu')
                        end
                    end
                end
            end
        end)
    end
end


addEventHandler('onResourceStart', resourceRoot, function()
    if #gates > 0 then
        applyConfig()
    end
end)
