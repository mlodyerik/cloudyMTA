local createdVehicle = nil
local blip = nil

function renderWaypoint()
    if (createdVehicle and isElement(createdVehicle)) then
        local x, y, z = getElementPosition(createdVehicle)
        local px, py, pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        local sx, sy = guiGetScreenSize()
        local x, y = getScreenFromWorldPosition(x, y, z + 1.0)
        if (x and y) then
            local size = 1.0 - (distance / 99999.0)

            dxDrawText(math.round(distance, 2, "floor") .. 'm', x, y - 20, x, y - 20, tocolor(255, 255, 255, 255), 1.0, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'center')
            if (distance < 5) then
                dxDrawText('Kliknij #68D65EE#c8c8c8 aby rozpocząć naprawe pojazdu!', x, y - 20 + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)), x, y - 20 + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)), tocolor(200, 200, 200), 1.0, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center', false, false, false, true)
            end
        end
    else
        removeEventHandler('onClientRender', root, renderWaypoint)
    end
end

function tryFixVehicle()
    if (createdVehicle and isElement(createdVehicle)) then
        local x, y, z = getElementPosition(createdVehicle)
        local px, py, pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if (distance < 5 and not getPedOccupiedVehicle(localPlayer)) then
            tryOpenFixGUI()
        end
    end
end

addEvent('onClientStartJobVehicle', true)
addEventHandler('onClientStartJobVehicle', resourceRoot, function ()
    local data = getJobData()

    local baseModel, isCustom = exports['since-custommodels']:checkModelID(data.vehicles[data.actual.type][data.actual.current].model, 'vehicle')

    if (isCustom) then
        createdVehicle = createVehicle(baseModel, data.vehicles[data.actual.type][data.actual.current].position[1], data.vehicles[data.actual.type][data.actual.current].position[2], data.vehicles[data.actual.type][data.actual.current].position[3], data.vehicles[data.actual.type][data.actual.current].position[4], data.vehicles[data.actual.type][data.actual.current].position[5], data.vehicles[data.actual.type][data.actual.current].position[6])
        setElementData(createdVehicle, 'baseID', baseModel)
        setElementData(createdVehicle, 'vehicleID', data.vehicles[data.actual.type][data.actual.current].model)
        setElementData(createdVehicle, 'vehicle:model', data.vehicles[data.actual.type][data.actual.current].model)
    else
        createdVehicle = createVehicle(data.vehicles[data.actual.type][data.actual.current].model, data.vehicles[data.actual.type][data.actual.current].position[1], data.vehicles[data.actual.type][data.actual.current].position[2], data.vehicles[data.actual.type][data.actual.current].position[3], data.vehicles[data.actual.type][data.actual.current].position[4], data.vehicles[data.actual.type][data.actual.current].position[5], data.vehicles[data.actual.type][data.actual.current].position[6])
    end

    setElementHealth(createdVehicle, math.random(300, 550))

    setElementFrozen(createdVehicle, true)
    setVehicleLocked(createdVehicle, true)

    blip = createBlipAttachedTo(createdVehicle, 0, 2, 255, 0, 0, 255, 0, 99999.0, localPlayer)

    exports['since-notifications']:sendNotification('success', 'Pojazd został zaznaczony na mapie')
    exports['since-radar']:findBestWay(data.vehicles[data.actual.type][data.actual.current].position[1], data.vehicles[data.actual.type][data.actual.current].position[2])

    addEventHandler('onClientRender', root, renderWaypoint)

    bindKey('e', 'down', tryFixVehicle)
end)

function destroyCreatedVehicle()
    if (createdVehicle and isElement(createdVehicle)) then
        destroyElement(createdVehicle)
        createdVehicle = nil

        if (blip and isElement(blip)) then
            destroyElement(blip)
            blip = nil
        end
    end
end