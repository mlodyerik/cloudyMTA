local missionElements = {}
local vehicles = {}

function destroyAllMissionElements()
    for i, v in ipairs(missionElements) do
        if isElement(v) then
            destroyElement(v)
        end
    end
end

function setMission(id)
    destroyAllMissionElements()

    local missionData = missions[id]
    if not missionData then
        setEventText(false)
        return
    end

    for i, v in ipairs(missionData.peds or {}) do
        if v[1] >= 20000 then
            ped = createPed(0, v[2], v[3], v[4], v[5] == 'random' and math.random(0, 360) or v[5])
        else
            ped = createPed(v[1], v[2], v[3], v[4], v[5] == 'random' and math.random(0, 360) or v[5])
        end
        
        setElementData(ped, 'ped:model', v[1])
        if v.dialog then
            local col = createColSphere(v[2], v[3], v[4], 1.5)
            setElementData(col, 'event:dialog', {ped, v.dialog})
            table.insert(missionElements, col)
        end

        if v.animation then setPedAnimation(ped, v.animation[1], v.animation[2], -1, true, false, false, false) end
        if v.weapon then
            givePedWeapon(ped, v.weapon, 9999)
            local slot = getSlotFromWeapon(v.weapon)
            setPedWeaponSlot(ped, slot)
        end

        if v.seek then
            setPedWalkingStyle(ped, 134) 
            setPedFightingStyle(ped, 15)  
            setElementData(ped, 'event:seek', true)
            setElementData(ped, 'event:seek:position', {x = v[2], y = v[3], z = v[4], distance = v.seek})
        end

        setElementFrozen(ped, not v.seek)
        setElementHealth(ped, 10000)
        setElementData(ped, 'event:ped', true)

        table.insert(missionElements, ped)
    end

    for i, v in ipairs(missionData.pickups or {}) do
        local elData = 'event:pickups:' .. id .. ':' .. i

        if not getEventData(elData) then
            local pickup = createPickup(v[2], v[3], v[4], 3, v[1])
            setElementData(pickup, 'event:pickup:id', id)
            setElementData(pickup, 'event:pickup:index', i)
            table.insert(missionElements, pickup)
        end
    end

    -- for i, v in ipairs(missionData.vehicles or {}) do
    --     triggerServerEvent('createMissionVehicle', resourceRoot, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
    -- end

    for i, v in ipairs(missionData.objects or {}) do
        local obj = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
        table.insert(missionElements, obj)
    end

    if type(missionData.missionText) == 'string' then
        setEventText(missionData.missionText)
    elseif type(missionData.missionText) == 'function' then
        local result = missionData.missionText()
        if not result then return end

        setEventText(result)
    else
        setEventText(false)
    end
end

function updateEventText()
    local id = getElementData(localPlayer, 'event:state') or 1
    local missionData = missions[id]
    if not missionData then
        setEventText(false)
        return
    end

    if type(missionData.missionText) == 'string' then
        setEventText(missionData.missionText)
    elseif type(missionData.missionText) == 'function' then
        local result = missionData.missionText()
        if not result then return end

        setEventText(result)
    else
        setEventText(false)
    end
end

function stopMission()
    setMission(-1)
end

addEventHandler('onClientPedDamage', root, function()
    if getElementData(source, 'event:ped') then
        cancelEvent()
    end
end)

addEventHandler('onClientColShapeHit', root, function(el, md)
    if el == localPlayer and md then
        local dialog = getElementData(source, 'event:dialog')
        if dialog then
            startDialogue(dialog[1], dialog[2])
        end
    end
end)

addEventHandler('onClientPickupHit', root, function(el)
    if el == localPlayer then
        local id = getElementData(source, 'event:pickup:id')
        local index = getElementData(source, 'event:pickup:index')
        if id and index then
            destroyElement(source)
            setEventData('event:pickups:' .. id .. ':' .. index, true)
            updateEventText()
        end
    end
end)

function loadEventState()
    local state = getElementData(localPlayer, 'event:state') or 1
    setMission(state)
end

addEvent('event:load', true)
addEventHandler('event:load', resourceRoot, loadEventState)

function getEventState()
    local state = getElementData(localPlayer, 'event:state') or 1
    local data = getElementData(localPlayer, 'event:data') or {}

    return state, data
end

function setMissionStatus(state)
    setElementData(localPlayer, 'event:state', state)
    setMission(state)
end

function setEventData(key, value)
    local data = getElementData(localPlayer, 'event:data') or {}
    data[key] = value
    setElementData(localPlayer, 'event:data', data)
end

function getEventData(key)
    local data = getElementData(localPlayer, 'event:data') or {}
    return data[key]
end