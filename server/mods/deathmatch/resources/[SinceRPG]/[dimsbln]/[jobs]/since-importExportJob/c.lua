local main = {}

function render()
    exports['since-blur']:dxDrawBlur(sx/2-425/zoom, sy/2-605/2/zoom, 850/zoom, 605/zoom, main['textures']['bg_mask'])
    dxDrawImage(sx/2-425/zoom, sy/2-605/2/zoom, 850/zoom, 605/zoom, main['textures']['bg'], 0, 0, 0, tocolor(255,255,255,255))
    dxDrawImage(sx/2-415/zoom, sy/2-292/zoom, 50/zoom, 50/zoom, main['textures']['garage_icon'], 0, 0, 0, tocolor(255,255,255,255))
    dxDrawText('Import export pojazdów', sx/2-355/zoom, sy/2-285/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][1], 'left', 'top', false, false, false, false, false)
    dxDrawText('Importuj i exportuj pojazdy pozdrooo', sx/2-355/zoom, sy/2-245/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][2], 'left', 'bottom', false, false, false, false, false)

    local tbl = main['info'] and main['info']['vehicles'] or {}

    local offset = 0    
    for i=1,5 do
        local isIn = isMouseInPosition(sx/2-416/zoom, sy/2-220/zoom+offset, 832/zoom, 100/zoom)
        local _,isVehicleOnSlot = findIndex(tbl, i)
        dxDrawImage(sx/2-416/zoom, sy/2-220/zoom+offset, 832/zoom, 100/zoom, main['textures'][isVehicleOnSlot and 'bg3' or 'bg2'], 0, 0, 0, tocolor(255,255,255,isIn and 255 or 215))
        dxDrawImage(sx/2-405/zoom, sy/2-220/zoom+45/2/zoom+offset, 55/zoom, 55/zoom, main['textures'][isVehicleOnSlot and 'car_icon' or 'none_icon'], 0, 0, 0, tocolor(255,255,255,255))
        dxDrawText(isVehicleOnSlot and exports['since-vehiclenames']:getVehicleName(isVehicleOnSlot[2]) or 'Pusty slot', sx/2-720/2/zoom+20/zoom, sy/2-220/zoom+30/zoom+offset, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][1], 'left', 'top', false, false, false, false, false)
        dxDrawText(isVehicleOnSlot and 'Wartość pojazdu: #9FFF97'..formatNumber(vehiclePrices[isVehicleOnSlot[2]] * exports['since-jobs']:getJobMultiplier('import'))..' $' or 'Ta powierzchnia piwnicy jest pusta ', sx/2-720/2/zoom+20/zoom, sy/2-220/zoom+70/zoom+offset, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][2], 'left', 'bottom', false, false, false, true, false)

        dxDrawText(isVehicleOnSlot and 'Kliknij aby exportować' or 'Kliknij aby importować', sx/2+400/zoom, sy/2-170/zoom+offset, nil, nil, tocolor(255,255,255,isIn and 255 or 200), 1, main['fonts'][1], 'right', 'center', false, false, false, false, false)
        offset = offset + 103/zoom
    end

    dxDrawImage(sx/2+425/zoom-51/zoom, sy/2-605/2/zoom+25/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0, 0, 0, tocolor(255,255,255,isMouseInPosition(sx/2+425/zoom-51/zoom, sy/2-605/2/zoom+25/zoom, 24/zoom, 24/zoom) and 255 or 150))
    local x,y,z = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(x,y,z, main['pos'][1], main['pos'][2], main['pos'][3]) > 3 then
        turnPanel(0, false)
    end
end

function click(button, state)
    if not main['countDown'] then main['countDown'] = getTickCount()-5 end
    if main['countDown'] > getTickCount() then return end
    main['countDown'] = getTickCount()+250
    if button == 'left' and state == 'down' then
        if isMouseInPosition(sx/2+425/zoom-51/zoom, sy/2-605/2/zoom+25/zoom, 24/zoom, 24/zoom) then
            turnPanel(1, false)
        else
            local tbl = main['info'] and main['info']['vehicles'] or {}
            local offset = 0    
            for i=1,5 do
                local _,isVehicleOnSlot = findIndex(tbl, i)
                if isMouseInPosition(sx/2-416/zoom, sy/2-220/zoom+offset, 832/zoom, 100/zoom) then
                    if isVehicleOnSlot then
                        triggerServerEvent('importexport', resourceRoot, 'startExport', {i, getRandomPoint(false)})
                    else
                        triggerServerEvent('importexport', resourceRoot, 'startImport', {i, getRandomModel(), getRandomPoint(true)})
                    end
                    break
                end
                offset = offset + 103/zoom
            end
        end
    end
end

function renderBuy()
    exports['since-blur']:dxDrawBlur(sx/2-150/zoom, sy/2-140/zoom, 300/zoom, 280/zoom, main['textures']['bg_mask'])
    dxDrawImage(sx/2-150/zoom, sy/2-140/zoom, 300/zoom, 280/zoom, main['textures']['bg'], 0,0,0, tocolor(255,255,255,255))
    dxDrawText('Garaż #68D65E#001', sx/2-135/zoom, sy/2-115/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][4], 'left', 'center', false, false, false, true)
    local isIn = isMouseInPosition(sx/2+115/zoom, sy/2-125/zoom, 20/zoom, 20/zoom)
    dxDrawImage(sx/2+115/zoom, sy/2-125/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,isIn and 255 or 200))

    if main['info'] then
        dxDrawText('Garaż #68D65EImport Export', sx/2, sy/2-70/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][5], 'center', 'center', false, false, false, true)
        dxDrawText('Statystyki', sx/2, sy/2-40/zoom, nil, nil, tocolor(104,214,94,255), 1, main['fonts'][5], 'center', 'center')
        dxDrawText('Zimportowane pojazdy: #9FFF97'..formatNumber(main['info']['stats'].imported or 0), sx/2, sy/2-20/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][6], 'center', 'center', false, false, false, true)
        dxDrawText('Wyexportowane pojazdy: #9FFF97'..formatNumber(main['info']['stats'].exported or 0), sx/2, sy/2, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][6], 'center', 'center', false, false, false, true)
        dxDrawText('Zarobione: #9FFF97'..formatNumber(main['info']['stats'].earned or 0)..' $', sx/2, sy/2+20/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][6], 'center', 'center', false, false, false, true)
    else
        dxDrawText('Zakup garażu #68D65EImport Export', sx/2, sy/2-70/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][5], 'center', 'center', false, false, false, true)
        dxDrawText('Aby zakupić garaż musisz posiadac '..srp..' SRP.', sx/2-150/zoom, sy/2-55/zoom, sx/2+150/zoom, nil, tocolor(255,255,255,255), 1, main['fonts'][6], 'center', 'top', false, true)
        dxDrawText('Cena garażu', sx/2, sy/2+25/zoom, nil, nil, tocolor(104,214,94,255), 1, main['fonts'][5], 'center', 'center')
        dxDrawText('Cena garażu wynosi: #68D65E$ '..formatNumber(cost), sx/2, sy/2+40/zoom, nil, nil, tocolor(255,255,255,255), 1, main['fonts'][6], 'center', 'top', false, false, false, true)
    end

    local isIn = isMouseInPosition(sx/2-100/zoom, sy/2+85/zoom, 200/zoom, 36/zoom)
    dxDrawImage(sx/2-100/zoom, sy/2+85/zoom, 200/zoom, 36/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,isIn and 255 or 200))
    dxDrawText(main['info'] and 'Wejdź do garażu' or 'Zakup garaż', sx/2-100/zoom, sy/2+85/zoom, sx/2+100/zoom, sy/2+121/zoom, tocolor(255,255,255,255), 1, main['fonts'][4], 'center', 'center', false, false, false, true)

    local x,y,z = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(x,y,z, main['pos'][1], main['pos'][2], main['pos'][3]) > 3 then
        turnPanel(0, false)
    end
end

function clickBuy(button, state)
    if not main['countDown'] then main['countDown'] = getTickCount()-5 end
    if main['countDown'] > getTickCount() then return end
    if button == 'left' and state == 'down' then
        main['countDown'] = getTickCount()+250
        if isMouseInPosition(sx/2+115/zoom, sy/2-125/zoom, 20/zoom, 20/zoom) then
            turnPanel(0, false)
        elseif isMouseInPosition(sx/2-100/zoom, sy/2+85/zoom, 200/zoom, 36/zoom) then
            if main['info'] then
                enterGarage()
                turnPanel(0, false)
            else
                if getElementData(localPlayer, 'player:srp') < srp then
                    outputChatBox('❌ #FFFFFFNie spełniasz wymagań, nie posiadasz '..srp..' srp.', 255,0,0,true)
                    return
                end
                triggerServerEvent('importexport', resourceRoot, 'buy')
            end
        end
    end
end

function turnPanel(id, state)
    if state then
        if main['block'] or main['timer'] then return end
        if not isEventHandlerAdded("onClientRender", root, id == 1 and render or renderBuy) then
            main['info'] = nil
            triggerServerEvent('importexport', resourceRoot, 'getInfo')
            main['fonts'] = loadFonts()
            local textures = {
                [0] = {'entering', {'bg','bg_mask','button','close'}},
                [1] = {'garage', {'bg','bg_mask','bg2','bg3','car_icon','close','garage_icon','none_icon'}},
            }
            main['textures'] = createTextures(textures[id][1], textures[id][2])
            addEventHandler("onClientRender", root, id == 1 and render or renderBuy)
            addEventHandler('onClientClick', root, id == 1 and click or clickBuy)
            main['pos'] = {getElementPosition(localPlayer)}
            showCursor(true, false)
        end
    else
        if isEventHandlerAdded("onClientRender", root, id == 1 and render or renderBuy) then
            removeEventHandler("onClientRender", root, id == 1 and render or renderBuy)
            removeEventHandler('onClientClick', root, id == 1 and click or clickBuy)
            showCursor(false)
            main['textures'] = destroyTextures(main['textures'])
            main['fonts'] = nil
            main['info'] = nil
            main['pos'] = nil
            return
        end
    end
end

function tryToLeaveGarage(el, md)
    if el == localPlayer and md and not main['block'] then
        exitGarage()
    end
end

function hitGarageMarker(el, md)
    if el == localPlayer and md and not main['block'] then
        turnPanel(1, true)
    end
end

function leaveGarageMarker(el, md)
    if el == localPlayer and md and not main['block'] then
        turnPanel(1, false)
    end
end

function enterGarage()
    main['block'] = true
    setElementFrozen(localPlayer, true)
    toggleAllControls(false)
    setTimer(function()
        triggerServerEvent('importexport', resourceRoot, 'enterGarage')
    end, 100, 1)
end

function exitGarage()
    main['block'] = true
    setElementFrozen(localPlayer, true)
    toggleAllControls(false)
    setTimer(function()
        triggerServerEvent('importexport', resourceRoot, 'exitGarage')
    end, 100, 1)
end

function garageLeaved()
    if isElement(main['leaveMarker']) then
        destroyElement(main['leaveMarker'])
    end
    main['leaveMarker'] = nil
    if isElement(main['garageMarker']) then
        destroyElement(main['garageMarker'])
    end
    main['garageMarker'] = nil
    for i,v in ipairs(main['vehicles']) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    main['vehicles'] = nil
end

function garageEntered(tbl)
    local marker = createMarker(1217.14, 183.20, -0.13+0.6, 'arrow', 1.1, 155,255,155,55)
    addEventHandler('onClientMarkerHit', marker, tryToLeaveGarage)
    setElementDimension(marker, getElementData(localPlayer, 'player:sid'))
    main['leaveMarker'] = marker

    local marker = createMarker(1222.05, 155.58, -0.11-1, 'cylinder', 2, 155,255,155,55)
    setElementData(marker, 'marker:icon', 'parking')
    setElementData(marker, 'marker:title', 'Garaż')
    setElementData(marker, 'marker:desc', 'Import export')
    addEventHandler('onClientMarkerHit', marker, hitGarageMarker)
    addEventHandler('onClientMarkerLeave', marker, leaveGarageMarker)
    setElementDimension(marker, getElementData(localPlayer, 'player:sid'))
    main['garageMarker'] = marker

    local slots = {
        {1239.59, 179.47, -0.51, 359.5, 360.0, 89.3},
        {1239.27, 171.97, -0.51, 359.4, 360.0, 89.1},
        {1238.85, 161.98, -0.51, 359.4, 360.0, 88.0},
        {1223.08, 178.85, -0.51, 359.5, 360.0, 268.9},
        {1222.74, 172.36, -0.51, 359.4, 360.0, 267.5},
    }

    setElementDimension(model, getElementData(localPlayer, 'player:sid'))

    local vehicles = {}
    for i,v in ipairs(tbl) do
        local x,y,z,rz,rx,ry = unpack(slots[v[1]])
        local model = v[2]
        local baseModel, isCustom = exports['since-custommodels']:checkModelID(model, 'vehicle')
        local veh = createVehicle(isCustom and baseModel or model, x,y,z+0.15,rz,rx,ry)
        if isCustom then
            setElementData(veh, 'baseID', baseModel)
            setElementData(veh, 'vehicleID', model)
        end
        setVehicleColor(veh, 255,255,255,255,255,255)
        setVehicleVariant(veh, 0,0)
        setElementDimension(veh, getElementData(localPlayer, 'player:sid'))
        addEventHandler('onClientVehicleStartEnter', veh, disableEntering)
        setElementFrozen(veh, true)
        table.insert(vehicles, veh)
    end
    main['vehicles'] = vehicles
end

function disableEntering(player, seat)
    if player == localPlayer then
        cancelEvent()
    end
end

function breakImport(el, md)
    if el == localPlayer and md then
        triggerServerEvent('importexport', resourceRoot, 'importFinish', main['saver'])
        if isElement(main['blip']) then
            destroyElement(main['blip'])
        end
        main['blip'] = nil
        if isElement(main['marker']) then
            destroyElement(main['marker'])
        end
        main['marker'] = nil
        main['saver'] = nil
        if isTimer(main['timer']) then
            killTimer(main['timer'])
        end
        main['timer'] = nil
    end
end

function breakExport(el, md)
    if el == localPlayer and md then
        triggerServerEvent('importexport', resourceRoot, 'exportFinish', main['saver'])
        if isElement(main['blip']) then
            destroyElement(main['blip'])
        end
        main['blip'] = nil
        if isElement(main['marker']) then
            destroyElement(main['marker'])
        end
        main['marker'] = nil
        main['saver'] = nil
    end
end

function endImportOnTime()
        triggerServerEvent('importexport', resourceRoot, 'importFailed')
        if isElement(main['blip']) then
            destroyElement(main['blip'])
        end
        main['blip'] = nil
        if isElement(main['marker']) then
            destroyElement(main['marker'])
        end
        main['marker'] = nil
        main['saver'] = nil
        if isTimer(main['timer']) then
            killTimer(main['timer'])
        end
        main['timer'] = nil
end

addEvent('importexport', true)
addEventHandler('importexport', resourceRoot, function(action, data)
    if action == 'giveInfo' then
        main['info'] = data

    elseif action == 'enterGarage' then
        turnPanel(0, false)
        garageEntered(data)
        setTimer(function()
            toggleAllControls(true)
            setElementFrozen(localPlayer, false)
            main['block'] = nil
        end, 100, 1)

    elseif action == 'exitGarage' then
        garageLeaved()
        setTimer(function()
            toggleAllControls(true)
            setElementFrozen(localPlayer, false)
            main['block'] = nil
        end, 100, 1)

    elseif action == 'staredImport' then
        garageLeaved()
        if isElement(main['blip']) then
            destroyElement(main['blip'])
        end
        main['saver'] = data
        turnPanel(1, false)
        local x,y,z,rx,ry,rz = unpack(data[3])
        main['blip'] = createBlip(x,y,z, 41)
        main['timer'] = setTimer(endImportOnTime, 60000*25, 1)

    elseif action == 'staredExport' then
        garageLeaved()
        turnPanel(1, false)
        main['saver'] = data
        local x,y,z = unpack(data[2])
        main['blip'] = createBlip(x,y,z, 41)
        main['marker'] = createMarker(x,y,z-1, 'cylinder', 5, 155,255,155,55)
        addEventHandler('onClientMarkerHit', main['marker'], breakExport)

    elseif action == 'enteredImported' then
        if isElement(main['blip']) then
            destroyElement(main['blip'])
        end
        local x,y,z,rx,ry,rz = unpack(createVehiclePosition)
        main['blip'] = createBlip(x,y,z, 41)
        main['marker'] = createMarker(x,y,z-1, 'cylinder', 5, 155,255,155,55)
        addEventHandler('onClientMarkerHit', main['marker'], breakImport)
        outputChatBox('✔️ #FFFFFFPrzejmujesz importowany pojazd, udaj się na bazę.', 155,255,155,true)

    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    local x,y,z = unpack(garageMarkerPosition)
    local marker = createMarker(x,y,z-1, 'cylinder', 1.5, 155,255,155,55)
    setElementData(marker, 'marker:icon', 'parking')
    setElementData(marker, 'marker:title', 'Garaż')
    setElementData(marker, 'marker:desc', 'Import export')
    addEventHandler('onClientMarkerHit', marker, function(el, md)
        if el == localPlayer and md then
            local x,y,z = getElementPosition(localPlayer)
            local xx,yy,zz = getElementPosition(marker)
            if getDistanceBetweenPoints3D(x,y,z, xx,yy,zz) < 2 then
                turnPanel(0, true)
            end
        end
    end)
    addEventHandler('onClientMarkerLeave', marker, function(el, md)
        if el == localPlayer and md then
            turnPanel(0, false)
        end
    end)
    model = createObject(3907, 1229.22, 166.58, 0.87, 0, 0, 0)
    if getElementData(localPlayer, 'player:sid') then
        setElementDimension(model, getElementData(localPlayer, 'player:sid'))
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['block'] then
        setElementFrozen(localPlayer, false)
        toggleAllControls(true)
    end
end)