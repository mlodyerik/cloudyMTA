local popupPos = {
    [80026] = {
        name = "headlight_closed", -- Nazwa komponentu, którą należy zaktualizować
        startPosition = {0, 0.15, -0.62},
        startRotation = {0, 0, 0, 'parent'},
        endPosition = {0, 0.6, -1.35},
        endRotation = {25, 0, 0, 'parent'},
    },

    [80103] = {
        name = "misc_a", -- Nazwa komponentu, którą należy zaktualizować
        startPosition = {0, 1.95, 0.02},
        startRotation = {0, 0, 0, 'parent'},
        endPosition = {0, 1.95, 0.02},
        endRotation = {40, 0, 0, 'parent'},
    },

    [80138] = {
        name = "misc_a", -- Nazwa komponentu, którą należy zaktualizować
        startPosition = {0, 2.04, 0.16},
        startRotation = {0, 0, 0, 'parent'},
        endPosition = {0, 2.04, 0.16},
        endRotation = {40, 0, 0, 'parent'},
    },
    -- Dodaj inne modele pojazdów w ten sposób
}

local showVehicleBlips = false
local blips = {}

addCommandHandler('cars', function()
    if getElementData(localPlayer, 'player:admin') then
        showVehicleBlips = not showVehicleBlips
        
        for i, v in ipairs(getElementsByType('vehicle')) do
            if showVehicleBlips then
                local dim = getElementDimension(localPlayer)
                local vehDim = getElementDimension(v)

                local int = getElementInterior(localPlayer)
                local vehInt = getElementInterior(v)

                if dim == vehDim and int == vehInt and isElementInWater( v ) == false then
                    if not blips[v] then
                        blips[v] = createBlipAttachedTo(v, 1, 1, 255, 175, 0, 255, 0, 1000, localPlayer)
                    end
                end
            else
                if blips[v] then
                    destroyElement(blips[v])
                    blips[v] = nil
                end
            end
        end
    end
end)

addEventHandler("onClientResourceStart",resourceRoot,function()
	setVehiclesLODDistance(50)
    setPedsLODDistance(150)
    setAmbientSoundEnabled( "general", true )
    setAmbientSoundEnabled( "gunfire", false )
end)

local vehicleData = {}
local duration = 750  -- Czas interpolacji w milisekundach

addEventHandler('onClientRender', root, function()
    local now = getTickCount()
    local x, y, z = getElementPosition(localPlayer)
    local vehicles = getElementsWithinRange(x, y, z, 100, 'vehicle')

    for i, v in ipairs(vehicles) do
        local vehicleModel = getElementData(v, 'vehicle:model')

        if vehicleModel and popupPos[vehicleModel] then
            if not vehicleData[v] then
                vehicleData[v] = {
                    startTick = now,
                    endTick = now + duration,
                    startPosition = popupPos[vehicleModel].startPosition,
                    startRotation = popupPos[vehicleModel].startRotation,
                    endPosition = popupPos[vehicleModel].endPosition,
                    endRotation = popupPos[vehicleModel].endRotation
                }
            end

            local lightState = getVehicleOverrideLights(v)
            local targetPosition, targetRotation

            if lightState == 2 then
                targetPosition = popupPos[vehicleModel].endPosition
                targetRotation = popupPos[vehicleModel].endRotation
            else
                targetPosition = popupPos[vehicleModel].startPosition
                targetRotation = popupPos[vehicleModel].startRotation
            end

            if targetPosition[1] ~= vehicleData[v].endPosition[1] or 
               targetPosition[2] ~= vehicleData[v].endPosition[2] or 
               targetPosition[3] ~= vehicleData[v].endPosition[3] or 
               targetRotation[1] ~= vehicleData[v].endRotation[1] or 
               targetRotation[2] ~= vehicleData[v].endRotation[2] or 
               targetRotation[3] ~= vehicleData[v].endRotation[3] then

                vehicleData[v].startTick = now
                vehicleData[v].endTick = now + duration
                vehicleData[v].startPosition = vehicleData[v].endPosition
                vehicleData[v].startRotation = vehicleData[v].endRotation
                vehicleData[v].endPosition = targetPosition
                vehicleData[v].endRotation = targetRotation
            end

            local progress = (now - vehicleData[v].startTick) / duration
            if progress > 1 then progress = 1 end

            local xPos, yPos, zPos = interpolateBetween(
                vehicleData[v].startPosition[1], vehicleData[v].startPosition[2], vehicleData[v].startPosition[3],
                vehicleData[v].endPosition[1], vehicleData[v].endPosition[2], vehicleData[v].endPosition[3],
                progress, 'Linear'
            )

            local xRot, yRot, zRot = interpolateBetween(
                vehicleData[v].startRotation[1], vehicleData[v].startRotation[2], vehicleData[v].startRotation[3],
                vehicleData[v].endRotation[1], vehicleData[v].endRotation[2], vehicleData[v].endRotation[3],
                progress, 'Linear'
            )

            setVehicleComponentPosition(v, popupPos[vehicleModel].name, xPos, yPos, zPos)
            setVehicleComponentRotation(v, popupPos[vehicleModel].name, xRot, yRot, zRot)
        end
    end
end)