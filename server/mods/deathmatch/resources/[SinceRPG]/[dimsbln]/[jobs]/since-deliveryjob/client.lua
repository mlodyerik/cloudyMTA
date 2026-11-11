local data = {

    moneyForPack = 3650,
    fonts = {},
    textures = {},
    list = {},
    markers = {},
    returnBlip = nil,
    reloadListMarker = nil,
    deliveryCount = 0,
    vehicleMarker = nil,
    deliveryObject = nil,
    jobTimer = nil,

}

local marker = createMarker(1872.71, 2071.81, 11.06-0.95, 'cylinder', 2, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Dostawca')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    exports["since-jobs"]:showJobGui("dostawca", source)
end)

function toggleControls(state)
    if exports["since-jobs"]:getPlayerUpgradeLevel("dostawca", 'Sprinter') == 1 then
        toggleControl("sprint", true)
    else
        toggleControl("sprint", state)
    end
    toggleControl("crouch", state)
    toggleControl("enter_exit", state)
    toggleControl("fire", false)
    toggleControl("aim", false)
    toggleControl("jump", state)
end

function checkIfHaveJobVehicle()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh then
        if getElementData(veh, 'vehicle:job') == 'dostawca' then
            return true
        else
            return false
        end
    else
        return 'noVehicle'
    end
end

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'dostawca' then
        if getElementData(localPlayer, 'player:job') then
            return
        end
        data.jobTimer = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('dostawca', 1)
        end, 60000, 0)

        setElementData(localPlayer, 'player:job', job)
        addEventHandler('onClientRender', root, renderNotes)
        addEventHandler('onClientRender', root, renderMarkers)
        updateList()
        exports['since-notifications']:sendNotification('success', 'Rozpoczęto prace')
  
        data.reloadListMarker = createMarker(1857.32, 2102.81, 10.82-0.95, 'cylinder', 5, 125, 255, 125, 50)
        setElementData(data.reloadListMarker, 'marker:title', 'Restauracja')
        setElementData(data.reloadListMarker, 'marker:desc', 'Załaduj nowe zamówienia')

        triggerServerEvent('startDeliveryJob', resourceRoot, exports["since-jobs"]:getPlayerUpgradeLevel("dostawca", 'Pojazd'))

        addEventHandler('onClientMarkerHit', data.reloadListMarker, function(plr)
            if plr ~= localPlayer or getElementData(localPlayer, 'player:job') ~= 'dostawca' then 
                return 
            end

            if data.deliveryCount > 0 then
                return exports['since-notifications']:sendNotification('error', 'Aby załadować nowe zamówienia, musisz dostarczyć aktualne.')
            end

            if not checkIfHaveJobVehicle() then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz załadować zamówień do tego pojazdu.')
            elseif checkIfHaveJobVehicle() == 'noVehicle' then
                return exports['since-notifications']:sendNotification('error', 'Musisz być w pojeździe, aby załadować zamówienia.')
            end

            data.markers = {}
            data.deliveryCount = 0

            if isElement(data.returnBlip) then
                destroyElement(data.returnBlip)
            end

            updateList()
        end)
    end
end)

function destroyMarkers()
    for k, v in pairs(data.markers) do
        if isElement(v) then
            destroyElement(v)
        end
    end

    if isElement(data.reloadListMarker) then
        destroyElement(data.reloadListMarker)
    end

    if isElement(data.vehicleMarker) then
        destroyElement(data.vehicleMarker)
    end

    if isElement(data.deliveryObject) then
        destroyElement(data.deliveryObject)
    end

    data.markers = {}
    data.reloadListMarker = nil
    data.deliveryCount = 0
    data.vehicleMarker = nil
    data.deliveryObject = nil
    data.list = {}
end

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'dostawca' then
        if getElementData(localPlayer, 'player:job') ~= 'dostawca' then 
            return
        end

        if isTimer(data.jobTimer) then
            killTimer(data.jobTimer)
            data.jobTimer = nil
        end

        destroyMarkers()
        triggerServerEvent('stopDeliveryJob', resourceRoot)
        removeEventHandler('onClientRender', root, renderNotes)
        removeEventHandler('onClientRender', root, renderMarkers)
        toggleControls(true)
        exports['since-notifications']:sendNotification('success', 'Zakończono prace')
    end
end)

toggleControls(true)

addEventHandler('onClientPlayerVehicleEnter', localPlayer, function(veh)
    if getElementData(localPlayer, 'player:job') == 'dostawca' and getElementData(veh, 'vehicle:job') == 'dostawca' then
        if data.vehicleMarker and isElement(data.vehicleMarker) then
            destroyElement(data.vehicleMarker)

            setVehicleDoorOpenRatio(veh, 1, 0, 500)
        end
    end
end)

addEventHandler('onClientPlayerVehicleExit', localPlayer, function(veh)
    if getElementData(localPlayer, 'player:job') == 'dostawca' and getElementData(veh, 'vehicle:job') == 'dostawca' then
        data.vehicleMarker = createMarker(0, 0, 0, 'cylinder', 1.15, 125, 255, 125, 50)
        setElementData(data.vehicleMarker, 'marker:title', 'Bagażnik')
        setElementData(data.vehicleMarker, 'marker:desc', 'Wyjmij zamównienie')

        if getElementData(veh, 'vehicleID') == 80022 then
            attachElements(data.vehicleMarker, veh, 0, -2.9, -0.45)
            setVehicleDoorOpenRatio(veh, 1, 1, 500)
        else
            attachElements(data.vehicleMarker, veh, 0, -1.65, -0.45)
        end

        addEventHandler('onClientMarkerHit', data.vehicleMarker, function(plr)
            if plr ~= localPlayer or getElementData(localPlayer, 'player:job') ~= 'dostawca' then 
                return 
            end

            if data.deliveryCount == 0 then
                return exports['since-notifications']:sendNotification('error', 'Nie masz żadnych zamówień w bagażniku.')
            end

            if data.deliveryObject and isElement(data.deliveryObject) then
                destroyElement(data.deliveryObject)
                data.deliveryObject = nil
                setPedAnimation(localPlayer, "CARRY", "putdwn", 5000, false, false, false, false)
                toggleControls(true)
            else
                setPedAnimation(localPlayer, "CARRY", "liftup", 5000, false, false, false, false)

                setTimer(function()
                    toggleControls(false)
                    data.deliveryObject = createObject(2814, 0, 0, 0)

                    setTimer(function()
                        exports["since-pattach"]:attach(data.deliveryObject, localPlayer, 23, -0.15, -0.05, 0.35, 0, 100, 160)
                        setPedAnimation(localPlayer, "carry", "crry_prtial", 1, false, true)
                    end, 100, 1)
                end, 1000, 1)
            end
        end)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    data.fonts['ink'] = dxCreateFont('data/ink-font.ttf', 16/zoom)
    data.fonts['ink2'] = dxCreateFont('data/ink-font.ttf', 14/zoom)
    data.textures['notes'] = dxCreateTexture('data/notes.png')

    if getElementData(localPlayer, 'player:job') == 'dostawca' then
        addEventHandler('onClientRender', root, renderNotes)
    end
end)

function renderMarkers()
    local markers = getElementsByType('marker', resourceRoot)

    for i, v in ipairs(markers) do
        if getMarkerType(v) == 'corona' then
            local x, y, z = getElementPosition(v)
            local z = getGroundPosition(x, y, z) + 0.1
            local px, py, pz = getElementPosition(localPlayer)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

            if distance < 50 then
                local size = 0.8

                dxDrawOctagon3D(x, y, z, size, 2, tocolor(255, 155, 25, 100))
                dxDrawOctagon3D(x, y, z + 0.05, size, 2, tocolor(255, 155, 25, 75))
                dxDrawOctagon3D(x, y, z + 0.1, size, 2, tocolor(255, 155, 25, 50))
                dxDrawOctagon3D(x, y, z + 0.15, size, 2, tocolor(255, 155, 25, 25))
            end
        end
    end

    local x, y, z = getElementPosition(localPlayer)
    local vehicles = getElementsWithinRange(x, y, z, 60, 'vehicle')

    for i, v in ipairs(vehicles) do
        if getElementData(v, 'vehicle:job') == 'dostawca' and not getPedOccupiedVehicle(localPlayer) and getElementData(v, 'vehicle:jobOwner') == getElementData(localPlayer, 'player:sid') then
            local x, y, z = getElementPosition(v)
            local z = z + 1.7
            local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(x, y, z)) - 5, 0)
            local x, y = getScreenFromWorldPosition(x, y, z)
            if not x or not y then return end

            local scale = 0.9 - dist / 60

            if dist < 60 then
                dxDrawImage(x - 118 * scale + 1, y - 50 * scale + 1, 236 * scale, 100 * scale, 'data/yourcar.png', 0, 0, 0, tocolor(0, 0, 0, 155))
                dxDrawImage(x - 118 * scale, y - 50 * scale, 236 * scale, 100 * scale, 'data/yourcar.png', 0, 0, 0, tocolor(255, 175, 45, 255))
            end
        end
    end
end

function updateList()
    local listID = math.random(1, #positions)
    for i = 1, #positions[listID] do
        table.insert(data.list, {name = noteTypes[math.random(1, #noteTypes)], count = math.random(1, 5)})

        local x, y, z = unpack(positions[listID][i])
        
        data.markers[i] = createMarker(x, y, z-0.95, 'corona', 2, 125, 255, 125, 0)
        setElementData(data.markers[i], 'marker:id', i)
        createBlipAttachedTo(data.markers[i], 41, 2, 255, 255, 255, 255, 0, 99999.0)

        data.deliveryCount = data.deliveryCount + 1

        addEventHandler('onClientMarkerHit', data.markers[i], function(plr)
            if plr ~= localPlayer or getElementData(localPlayer, 'player:job') ~= 'dostawca' then 
                return 
            end

            if not data.deliveryObject or not isElement(data.deliveryObject) then
                return exports['since-notifications']:sendNotification('error', 'Wyjmij zamówienie z bagażnika.')
            end
            
            setPedAnimation(localPlayer, "CARRY", "putdwn", 5000, false, false, false, false)

            setTimer(function(marker, player)
                local id = getElementData(marker, 'marker:id')
                
                destroyElement(data.deliveryObject)
                
                data.deliveryObject = nil
                data.deliveryCount = data.deliveryCount - 1
                
                local money = data.moneyForPack + math.random(-math.floor(data.moneyForPack/10),math.floor(data.moneyForPack/10))
                money = money * exports["since-jobs"]:getJobMultiplier('dostawca')
                
                for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel("dostawca", 'Money') do
                    money = money * (1.1)
                end
                
                if getElementData(player, 'player:diamond') then
                    money = money * (1.2)
                end
                
                local voucher = exports['since-vouchers']:getJobVoucher('dostawca')/100
                money = money + math.floor(money * voucher)    

                money = math.floor(money)
                
                exports['since-notifications']:sendNotification('success', 'Dostarczono zamówienie, otrzymano $ '..money..'')

                exports["since-jobs"]:addPlayerJobEarned("dostawca", money)

                local rnd = math.random(1, 10)
                if rnd > 5 then
                    exports["since-jobs"]:addPlayerJobPoints("dostawca", 1)
                end

                local srp = math.random(0, 2) * exports["since-jobs"]:getJobMultiplier('dostawca')

                triggerServerEvent('givePlayerMoneyFromDelivery', resourceRoot, money, srp)

                destroyElement(marker)
                table.remove(data.list, id)
                
                if data.deliveryCount == 0 then
                    data.list = {}
                    data.returnBlip = createBlipAttachedTo(data.reloadListMarker, 41, 2, 255, 255, 255, 255, 0, 99999.0)
                    exports['since-notifications']:sendNotification('info', 'Wróć do restauracji po nowe zamówienia!')
                end

                toggleControls(true)
            end, 1000, 1, source, localPlayer)
        end)
    end
end

function renderNotes()
    if #data.list > 0 then
        exports['since-blur']:dxDrawBlur(15/zoom, sy / 2 - 150/zoom, 300/zoom, 300/zoom, data.textures['notes'])
        dxDrawImage(15/zoom, sy / 2 - 150/zoom, 300/zoom, 300/zoom, data.textures['notes'], 0, 0, 0, tocolor(255, 255, 255, 240))

        dxDrawText('Lista zamównień', 165/zoom, sy / 2 - 55/zoom, nil, nil, tocolor(0, 0, 0, 240), 1, data.fonts['ink'], 'center', 'bottom')

        local offset = 0
        for k, v in pairs(data.list) do
            dxDrawText(v.count..'x', 50/zoom, sy / 2 - 15/zoom + offset, nil, nil, tocolor(25, 75, 155, 255), 1, data.fonts['ink2'], 'left', 'bottom')
            dxDrawText(v.name, 85/zoom, sy / 2 - 15/zoom + offset, nil, nil, tocolor(25, 75, 155, 255), 1, data.fonts['ink2'], 'left', 'bottom')

            offset = offset + 19/zoom
        end
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    for k, v in pairs(data.fonts) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    for k, v in pairs(data.textures) do
        if isElement(v) then
            destroyElement(v)
        end
    end

    if getElementData(localPlayer, 'player:job') == 'dostawca' then
        setPedAnimation(localPlayer, false)
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('info', 'Praca dostawcy została zrestartowana, rozpocznij ją ponownie.')
        toggleControls(true)
    end
end)
getResourceName(getThisResource(), true, 684659149); if true then return end