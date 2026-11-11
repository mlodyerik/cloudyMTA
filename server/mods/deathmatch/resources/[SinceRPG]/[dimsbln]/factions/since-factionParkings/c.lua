local tbl = {}
local playerFaction = nil

function render()
    exports['since-blur']:dxDrawBlur(sx/2-220/zoom, sy/2-230/zoom, 440/zoom, 460/zoom, main['textures']['bg_mask'])
    dxDrawImage(sx/2-220/zoom, sy/2-230/zoom, 440/zoom, 460/zoom, main['textures']['bg'])

    main['anim'][1] = main['anim'][1] and interpolateBetween(main['anim'][1], 0, 0, isMouseIn(sx/2+188/zoom, sy/2-222/zoom, 24/zoom, 24/zoom) and 1 or 0.7, 0, 0, 0.1, 'Linear') or 0.7
    dxDrawImage(sx/2+190/zoom, sy/2-220/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,255*main['anim'][1]))
    dxDrawImage(sx/2-210/zoom, sy/2-217/zoom, 34/zoom, 34/zoom, main['textures']['icon'], 0,0,0, tocolor(255,255,255,255))
    dxDrawText('Parking wirtualny', sx/2-170/zoom, sy/2-220/zoom, _, _, tocolor(255,255,255,255), 1, main['fonts'][1], 'left', 'top')
    dxDrawText('Pojazdy frakcyjne', sx/2-170/zoom, sy/2-180/zoom, _, _, tocolor(125,255,125,255), 1, main['fonts'][2], 'left', 'bottom')

    local x=0
    for i, v in ipairs(tbl) do
        if i >= main['scroll'][1] and i <= main['scroll'][2] then
            x=x+1
            local offset = ((65/zoom)*(x-1))

            dxDrawImage(sx/2-215/zoom, sy/2-160/zoom + offset, 420/zoom, 60/zoom, main['textures']['bg2'], 0,0,0, tocolor(255,255,255,200))

            dxDrawText(v[1], sx/2-200/zoom, sy/2-140/zoom + offset, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][3], 'left', 'center')

            dxDrawImage(sx/2-200/zoom, sy/2-127/zoom + offset, 15/zoom, 15/zoom, main['textures']['icon2'], 0,0,0, tocolor(125,255,125,255))

            local rank = 'Officer'
            dxDrawText('Dostępny od rangi: #2E756F'..exports['since-factions']:getRankData(playerFaction, v[3]), sx/2-180/zoom, sy/2-118/zoom + offset, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)

            local isIn = isMouseIn(sx/2+100/zoom, sy/2-145/zoom + offset, 92/zoom, 30/zoom)
            dxDrawImage(sx/2+100/zoom, sy/2-145/zoom + offset, 92/zoom, 30/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,isIn and 255 or 200))
            dxDrawText('Wybierz', sx/2+147/zoom, sy/2-130/zoom + offset, nil, nil, tocolor(255,255,255,isIn and 255 or 200), 1, main['fonts'][2], 'center', 'center')
        end
    end

    drawScrollbar(tbl, sx/2+211/zoom, sy/2-160/zoom, 3/zoom, 320/zoom, main['scroll'][3], main['scroll'][1], 255)

    local textWidth = dxGetTextWidth('Wszystkie pojazdy', 1, main['fonts'][2]) + 20/zoom
    dxDrawRoundedRectangle(sx/2-textWidth/2, sy/2+185/zoom, textWidth, 30/zoom, 14/zoom, tocolor(217, 217, 217, 85))
    dxDrawText('Wszystkie pojazdy', sx/2, sy/2+200/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][2], 'center', 'center')

    dxDrawImage(sx/2-textWidth/2-34/zoom, sy/2+183/zoom, 34/zoom, 34/zoom, main['textures']['arrow'], 180,0,0, tocolor(255,255,255,255))
    dxDrawImage(sx/2+textWidth/2, sy/2+183/zoom, 34/zoom, 34/zoom, main['textures']['arrow'], 0,0,0, tocolor(255,255,255,255))

    if main['marker'] and isElement(main['marker']) then
        local x,y,z = getElementPosition(localPlayer)
        local x2,y2,z2 = getElementPosition(main['marker'])
        if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 5 then
            turnPanel(false)
        end
    end
end

function click(button,state)
    if (button == 'left' and state == 'down' and main['countDown'] < getTickCount()) then
        main['countDown'] = getTickCount() + 300
        if isMouseIn(sx/2+188/zoom, sy/2-222/zoom, 24/zoom, 24/zoom) then
            turnPanel(false)
            return
        end

        local x=0
        for i, v in ipairs(tbl) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                x=x+1
                local offset = ((65/zoom)*(x-1))
                if isMouseIn(sx/2+105/zoom, sy/2-145/zoom + offset, 92/zoom, 30/zoom) then
                    triggerServerEvent('onPlayerFactionParking', resourceRoot, 'take', {v[1], v[2], v[3], v[4], v[5]}, playerFaction)
                    turnPanel(false)
                end
            end
        end
    end
end

function createTextures()
    main['anim'] = {}
    main['countDown'] = getTickCount()
    main['scroll'] = {1, 5, 5}
    main['page'] = 0
    main['textures'] = {}

    for i,v in ipairs({'bg','bg_mask','bg2','button','close','icon','icon2','arrow'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end

    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom),
        [3] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
    }
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
end
addEventHandler('onClientResourceStop', resourceRoot, destroyTextures)

function turnPanel(state, marker)
    if state then
        local factionRank = getElementData(localPlayer, 'player:rank')
        playerFaction = getElementData(localPlayer, 'player:faction')
        tbl = {}
        
        vehicles[playerFaction] = vehicles[playerFaction] or {}

        for i, v in pairs(vehicles[playerFaction]) do
            for _, veh in ipairs(vehicles[playerFaction][i]) do
                if factionRank >= i then
                    table.insert(tbl, {veh.name, veh.handling, i, veh.model, veh.code})
                end
            end
        end

        table.sort(tbl, function(a, b)
            return a[3] < b[3]
        end)

        main['scroll'] = {1, 5, 5}

        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        bindKey('mouse_wheel_up', 'down', scrollUP)
        bindKey('mouse_wheel_down', 'down', scrollDOWN)
        showCursor(true,true)

        if marker then
            main['marker'] = marker
        end
    else
        showCursor(false)
        removeEventHandler('onClientRender', root, render)
        removeEventHandler('onClientClick', root, click)
        unbindKey('mouse_wheel_up', 'down', scrollUP)
        unbindKey('mouse_wheel_down', 'down', scrollDOWN)
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
        if main['scroll'][2] >= #tbl then 
            return 
        end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

function markerHit(el, md)
    if el == localPlayer and md then 
        local veh = getPedOccupiedVehicle(el)
        if veh and not isEventHandlerAdded('onClientRender', root, render) then
            if getElementData(veh, 'vehicle:faction') == getElementData(source, 'faction:parking') then
                triggerServerEvent('onPlayerFactionParking', resourceRoot, 'return', nil, getElementData(veh, 'vehicle:faction'))
            end
        else
            if not isEventHandlerAdded('onClientRender', root, render) then
                local faction = getElementData(el, 'player:faction')

                if faction and getElementData(source, 'faction:parking') == faction then
                    turnPanel(true, source)
                end
            end
        end
    end
end

function markerLeave(el, md)
    if el == localPlayer and md then 
        if isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(false)
        end
    end
end

function start()
    local tbl = {
        {2011.02, -1869.07, 13.28, 'SAPD'},
        {1798.02, -1697.98, 13.47, 'SARA'},
        --{849.82, 1837.67, 10.82, 'SAFD'},
       -- {2186.69, 1447.61, 10.82, 'TSA'}
    }

    for i, v in ipairs(tbl) do
        local marker = createMarker(v[1],v[2],v[3]-0.4,'cylinder',4,125,255,125)
        setElementData(marker, 'marker:title', 'Parking '..v[4])
        setElementData(marker, 'marker:desc', 'Wyjmij pojazd służbowy')
        setElementData(marker, 'marker:icon', 'parking')
        setElementData(marker, 'faction:parking', v[4])
        addEventHandler('onClientMarkerHit', marker, markerHit)
        addEventHandler('onClientMarkerLeave', marker, markerLeave)
    end

    createTextures()
end
start()
getResourceName(getThisResource(), true, 656703763); if true then return end