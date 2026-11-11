local block, pageChanger, countDown = nil, nil, getTickCount()
zoom=zoom*0.95

function render()
    local anim = main['anim'][1]
    local anim2 = (pageChanger and 255 or anim)
    exports['since-blur']:dxDrawBlur(sx/2-334/zoom, sy/2-184/zoom, 668/zoom, 368/zoom, main['textures']['bg_mask'], anim2)
    dxDrawImage(sx/2-334/zoom, sy/2-184/zoom, 668/zoom, 368/zoom, main['textures']['bg'], 0,0,0, tocolor(255,255,255,anim2))

    local isIn = isMouseIn(sx/2+297/zoom, sy/2-171/zoom, 24/zoom, 24/zoom)
    main['anim'][2] = interpolateBetween(main['anim'][2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2+299/zoom, sy/2-169/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,anim2*main['anim'][2]))

    dxDrawText('Komponenty', sx/2-315/zoom, sy/2-175/zoom, _, _, tocolor(255,255,255,anim2), 1, main['fonts'][1], 'left', 'top')
    dxDrawText('Zmodernizuj swój samochód!', sx/2-315/zoom, sy/2-135/zoom, _, _, tocolor(55,255,55,anim2), 1, main['fonts'][2], 'left', 'bottom')

    pages[main['page']](anim)

    if not getPedOccupiedVehicle(localPlayer) then
        if not block then
            turnPanel(false)
        end
    elseif main['marker'] then
        if isElement(main['marker']) then
            local x,y,z = getElementPosition(getPedOccupiedVehicle(localPlayer))
            local x2,y2,z2 = getElementPosition(main['marker'])
            if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 5 then
                if not block then
                    turnPanel(false)
                end
            end
        end
    end
end

function click(button,state)
    if (button == 'left' and state == 'down' and not block and countDown < getTickCount()) then
        countDown = getTickCount() + 300
        if isMouseIn(sx/2+297/zoom, sy/2-171/zoom, 24/zoom, 24/zoom) then
            turnPanel(false)

        elseif main['page'] == 0 then
            if isMouseIn(sx/2-320/zoom, sy/2-125/zoom, 640/zoom, 290/zoom) then
                local x = 0
                for i,v in ipairs(components) do
                    if i >= main['scroll'][1] and i <= main['scroll'][2] then
                        x=x+1
                        local offset = ((75/zoom)*(x-1))
                        if isMouseIn(sx/2+180/zoom, sy/2-106/zoom+offset, 120/zoom, 30/zoom) then
                            chagneSide(v.page, i)
                        end
                    end
                end
            end
            
        elseif main['page'] == 1 then
            if isMouseIn(sx/2+82/zoom, sy/2-125/zoom, 235/zoom, 245/zoom) then
                local x,y = sx/2+99/zoom, sy/2-94/zoom
                for i=1,16 do
                    if isMouseIn(x, y, 44/zoom, 44/zoom) then
                        updatePaletteColor2(unpack(colors[i]))
                    end
                    x = x + 52/zoom
                    if x > (sx/2+99/zoom+((52/zoom)*3.9)) then
                        x = sx/2+99/zoom
                        y = y + 52/zoom
                    end
                end
        
            elseif isMouseIn(sx/2-72/zoom, sy/2-25/zoom, 144/zoom, 30/zoom) then
                local veh = getPedOccupiedVehicle(localPlayer)
                if not veh then return end
                local r,g,b = pickerData["color"][1], pickerData["color"][2], pickerData["color"][3]
                if #exports['since-gui']:getEditboxText(main['editbox'][1]) > 0 and #exports['since-gui']:getEditboxText(main['editbox'][2]) > 0 then
                    exports['since-notifications']:sendNotification('error', 'Wyszyść jedno pole RGB lub HEX')
                    return
                end
                if #exports['since-gui']:getEditboxText(main['editbox'][1]) > 0 and exports['since-gui']:getEditboxText(main['editbox'][2]) then
                    r,g,b = unpack(split(exports['since-gui']:getEditboxText(main['editbox'][1]), ','))
                    if not r or not tonumber(r) or not g or not tonumber(g) or not b or not tonumber(b) then
                        exports['since-notifications']:sendNotification('error', 'Niepoprawna wartość RGB')
                        return
                    end
                end
                if #exports['since-gui']:getEditboxText(main['editbox'][2]) > 0 then
                    if getColorFromString('#'..exports['since-gui']:getEditboxText(main['editbox'][2])) then
                        r,g,b,a = getColorFromString('#'..exports['since-gui']:getEditboxText(main['editbox'][2]))
                    else
                        exports['since-notifications']:sendNotification('error', 'Niepoprawna wartość HEX')
                        return
                    end
                end
                triggerServerEvent('H_components:buyColor', resourceRoot, veh, components[main['chosedComponent']].data, components[main['chosedComponent']].cost, r,g,b)

            elseif isMouseIn(sx/2-72/zoom, sy/2+10/zoom, 144/zoom, 30/zoom) then
                chagneSide(0)

            end

        elseif main['page'] == 2 then
            if isMouseIn(sx/2+137/zoom, sy/2-171/zoom, 144/zoom, 30/zoom) then
                chagneSide(0)
                return
            end
            local x = 0
            for i,v in ipairs(speedoPatterns) do
                if i >= main['scroll'][1] and i <= main['scroll'][2] then
                    x=x+1
                    local offset = ((57/zoom)*(x-1))
                    if isMouseIn(sx/2-320/zoom, sy/2-125/zoom+offset, 640/zoom, 54/zoom) and not isMouseIn(sx/2+180/zoom, sy/2-113/zoom+offset, 120/zoom, 30/zoom) then
                        speedoClicked = v.id
                        
                    elseif isMouseIn(sx/2+180/zoom, sy/2-113/zoom+offset, 120/zoom, 30/zoom) then
                        local veh = getPedOccupiedVehicle(localPlayer)
                        if not veh then return end
                        triggerServerEvent('H_components:buySpeedoPatern', resourceRoot, veh, v.id, components[main['chosedComponent']].cost)

                    end
                end
            end
        end
    elseif main['page'] == 3 then
        if isMouseIn(sx/2+137/zoom, sy/2-171/zoom, 144/zoom, 30/zoom) then
            chagneSide(0)
            return
        end

        if isMouseIn(sx/2 - (140/zoom) / 2, sy/2 - 50/zoom, 140/zoom, 35/zoom) then
            local veh = getPedOccupiedVehicle(localPlayer)
            if not veh then return end

            local function getVehicleKeys(veh)
                local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
            
                if vehicleUpgrades['keys'] then
                    return tonumber(vehicleUpgrades['keys'])
                else
                    return 1
                end
            end

            local cost = getVehicleKeys(veh) * 75000
            triggerServerEvent('H_components:buyKeys', resourceRoot, veh, tonumber(cost))
        end
    end
end

function createTextures()
    main['anim'] = {0,0,0,0}
    main['scroll'] = {1, 4, 4}
    main['page'] = 0
    main['textures'] = {}
    for i,v in ipairs({'bg','bg_mask','bg2','bg3','button','keys','close','paint_icon','smoke_icon','light','palette','color_info','color_icon','editbox','button_1','button_2','color_rect','color_list','color_fill','speedo_icon'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 13/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Regular', 11/zoom),
        [3] = exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
        [6] = exports['since-fonts']:getFont('Inter-SemiBold', 16/zoom),
    }
    main['editbox'] = {}
    setTimer(function() 
        main['editbox'][1] = exports['since-gui']:createEditbox('R, G, B...', sx/2-72/zoom, sy/2-125/zoom, 144/zoom, 44/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 45/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
            image = main['textures']['editbox'],
            placeholderColor = {155, 155, 155},
            passworded = false,
            caretHeight = 18/zoom,
            icon = main['textures']['color_icon'],
            iconPadding = 35/zoom,
            textColor = {255, 255, 255, 200},
            maxChars = 30,
        })
        exports['since-gui']:setElementAlpha(main['editbox'][1], 0)
        main['editbox'][2] = exports['since-gui']:createEditbox('HEX...', sx/2-72/zoom, sy/2-78/zoom, 144/zoom, 44/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 45/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
            image = main['textures']['editbox'],
            placeholderColor = {155, 155, 155},
            passworded = false,
            caretHeight = 18/zoom,
            icon = main['textures']['color_icon'],
            iconPadding = 35/zoom,
            textColor = {255, 255, 255, 200},
            maxChars = 30,
        })
        exports['since-gui']:setElementAlpha(main['editbox'][2], 0)
    end, 250, 1)
end

function destroyTextures()
    speedoClicked = nil
    for i,v in ipairs(main['editbox']) do
        exports['since-gui']:destroyUIElement(v)
    end
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    destroyColorPicker()
    for i,v in pairs(main) do
        main[i] = nil
    end
end

function chagneSide(page, data)
    if main['page'] == page then
        return
    end
    block = true
    pageChanger = true
    local lastPage = main['page']
    if lastPage == 1 then
        for i,v in ipairs(main['editbox']) do
            exports['since-gui']:fadeElement(v, 0, 400, 'InOutQuad')
        end
    end
    animate(255, 0, 2, 300, function(value)
        main['anim'][1] = value
    end, function()
        main['page'] = page
        main['scroll'] = {1, page == 2 and 5 or 4, page == 2 and 5 or 4}
        main['chosedComponent'] = data or nil
        speedoClicked = nil
        local veh = getPedOccupiedVehicle(localPlayer)
        if page == 1 then
            createColorPicker(veh, sx/2-320/zoom, sy/2-125/zoom, 235/zoom, 190/zoom, "color1")
            for i,v in ipairs(main['editbox']) do
                exports['since-gui']:fadeElement(v, 1, 400, 'InOutQuad')
                exports['since-gui']:setEditboxText(v, '')
            end
        elseif lastPage == 1 then
            destroyColorPicker()
        end
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            block = nil
            pageChanger = nil
        end)
    end)
end

function turnPanel(state, marker)
    if block then return end
    if state then
        block = true
        createTextures()
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, click)
            addEventHandler("onClientClick", root, clickColorPicker)
            bindKey('mouse_wheel_up', 'down', scrollUP)
            bindKey('mouse_wheel_down', 'down', scrollDOWN)
            block = nil
        end)
        showCursor(true,true)
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientRender', root, renderColorPicker)
        if marker then
            main['marker'] = marker
        end
    else
        block = true
        showCursor(false)
        removeEventHandler('onClientClick', root, click)
        removeEventHandler('onClientClick', root, clickColorPicker)
        unbindKey('mouse_wheel_up', 'down', scrollUP)
        unbindKey('mouse_wheel_down', 'down', scrollDOWN)
        for i,v in ipairs(main['editbox']) do
            exports['since-gui']:fadeElement(v, 0, 400, 'InOutQuad')
        end
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientRender', root, renderColorPicker)
            destroyTextures()
            block = nil
        end)
    end
end

function scrollUP()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] == main['scroll'][3] then return end
        main['scroll'][1] = main['scroll'][1] - 1
        main['scroll'][2] = main['scroll'][2] - 1
    end
end

function scrollDOWN()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] >= (main['page']==2 and #speedoPatterns or #components) then 
            return 
        end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

function markerHit(el, md)
    if el == localPlayer and md and getPedOccupiedVehicle(el) then 
        local veh = getPedOccupiedVehicle(el)
        if getVehicleController(veh) ~= el or not getElementData(veh, 'vehicle:id') then
            return
        end
        if (getElementData(veh, "vehicle:owner") ~= getElementData(localPlayer, "player:sid")) then
            return
        end
        if not isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(true, source)
        end
    end
end

function markerLeave(el, md)
    if el == localPlayer and md and getPedOccupiedVehicle(el) then 
        local veh = getPedOccupiedVehicle(el)
        if getVehicleController(veh) ~= el or not getElementData(veh, 'vehicle:id') then
            return
        end
        if isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(false)
        end
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['editbox'] then
        if #main['editbox'] > 0 then
            for i,v in ipairs(main['editbox']) do
                exports['since-gui']:destroyUIElement(v)
            end
        end
    end
end)

function start()
    local tbl = {
        {2530.20, -1543.16, 23.71},
        {2519.13, -1542.87, 23.72},
        {1990.72, -2345.90, 13.55},
        {1058.26, 1733.54, 10.82},
    }
    for i, v in ipairs(tbl) do
        local marker = createMarker(v[1],v[2],v[3],'cylinder',4,55,255,55)
        setElementData(marker, 'marker:title', 'Komponenty')
        setElementData(marker, 'marker:desc', 'Zmodyfikuj swój pojazd')
        addEventHandler('onClientMarkerHit', marker, markerHit)
        addEventHandler('onClientMarkerLeave', marker, markerLeave)
    end
end
start()
getResourceName(getThisResource(), true, 81643758); if true then return end