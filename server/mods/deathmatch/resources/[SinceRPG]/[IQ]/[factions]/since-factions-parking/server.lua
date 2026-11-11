function show(player, faction)
    triggerClientEvent(player, 'since-factions-parking:show', resourceRoot, faction)
end

function hide(player)
    triggerClientEvent(player, 'since-factions-parking:hide', resourceRoot)
end

local shapes = {}

addEvent('since-factions-parking:tryGetVehicle', true)
addEventHandler('since-factions-parking:tryGetVehicle', resourceRoot, function(model)
    local player = client

    if (not isElement(player)) then
        return
    end

    local factionVehicles = exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction')).vehicles

    for i,v in pairs(factionVehicles) do
        if v.model == tonumber(model) then
            if v.rank <= getElementData(player, 'player:rank') then
                local x, y, z , rx, ry, rz = unpack(exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction')).markers.spawnVehicle)

                local vehicle = createVehicle(model, x, y, z, rx, ry, rz)
                setElementData(vehicle, 'vehicle:faction', getElementData(player, 'player:faction'))
                setElementData(vehicle, 'vehicle:rank', getElementData(player, 'player:rank'))
                setVehiclePlateText(vehicle, v.code..' '..#factionVehicles)

                if (getElementData(player, 'player:faction') == "SAPD") then
                    setElementData(vehicle, "vehicle:lights:sirens", true)
                    setElementData(vehicle, "vehicle:police", true)

                    if model == 578 then
                        local x, y, z = getElementPosition(vehicle)
                        shapes[vehicle] = createColSphere(x, y, z, 4)
                        attachElements(shapes[vehicle], vehicle, 0, -8, -0.605)
                        setElementData(shapes[vehicle], 'vehicle:shape', vehicle)
                    end
                end
                
                if tonumber(model) == 578 then
                    local x, y, z = getElementPosition(vehicle)
                    shapes[vehicle] = createColSphere(x, y, z, 4)
                    attachElements(shapes[vehicle], vehicle, 0, -8, -0.605)
                    iprint('created shape')
                    setElementData(shapes[vehicle], 'vehicle:shape', vehicle)
                end

                for k, v in pairs(v.handling) do
                    local hData = getVehicleHandlingProperty(vehicle, k)
                    setVehicleHandling(vehicle, k, type(v) == 'string' and v or v)
                end

                warpPedIntoVehicle(player, vehicle)

                hide(player)

                                
                if (v.specialData) then
                    v.specialData(vehicle)
                    triggerClientEvent(player, 'since-factions-parking:showSpecialData', resourceRoot)
                end
                return
            end
        end
    end
end)

addEventHandler('onVehicleStartEnter', resourceRoot, function (player, seat)
    if seat == 0 then
        if getElementData(source, 'vehicle:faction') then
            if getElementData(player, 'player:faction') ~= getElementData(source, 'vehicle:faction') then
                cancelEvent()
            end
        end
    end
end)

function returnVehicle(player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        if getElementData(vehicle, 'vehicle:faction') then
            if getElementData(player, 'player:faction') == getElementData(vehicle, 'vehicle:faction') then
                if getElementData(player, 'player:rank') >= getElementData(vehicle, 'vehicle:rank') then
                    destroyElement(vehicle)
                end
            end
        end
    end
end

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element ) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
 
    return false
end