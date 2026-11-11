
local function render()
    local anim = main['anim'][1]
    exports['since-blur']:dxDrawBlur(sx/2-220/zoom, sy/2-230/zoom, 440/zoom, 460/zoom, main['textures']['bg_mask'], anim)
    dxDrawImage(sx/2-220/zoom, sy/2-230/zoom, 440/zoom, 460/zoom, main['textures']['bg'], 0,0,0, tocolor(255,255,255,anim))

    local isIn = isMouseIn(sx/2+188/zoom, sy/2-222/zoom, 24/zoom, 24/zoom)
    main['anim'][2] = interpolateBetween(main['anim'][2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2+190/zoom, sy/2-220/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,anim*main['anim'][2]))

    dxDrawImage(sx/2-200/zoom, sy/2-215/zoom, 30/zoom, 30/zoom, main['textures']['fish_icon'], 0,0,0, tocolor(255,255,255,anim))

    dxDrawText('Skup ryb', sx/2-155/zoom, sy/2-220/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'top')
    dxDrawText('Sprzedaj swoje ryby', sx/2-155/zoom, sy/2-180/zoom, _, _, tocolor(55,255,55,anim), 1, main['fonts'][2], 'left', 'bottom')

    for i=1,5 do
        if types[i] then
            dxDrawImage(sx/2-203/zoom, sy/2-160/zoom+((i-1)*(68/zoom)), 406/zoom, 64/zoom, main['textures']['bg2'], 0,0,0, tocolor(255,255,255,anim))
            dxDrawImage(sx/2-195/zoom, sy/2-152/zoom+((i-1)*(68/zoom)), 48/zoom, 48/zoom, main['textures']['bg3'], 0,0,0, tocolor(255,255,255,anim))
            dxDrawImage(sx/2-190/zoom, sy/2-147/zoom+((i-1)*(68/zoom)), 38/zoom, 38/zoom, ':since-inventory/data/'..string.lower(types[i].name)..'.png', 0,0,0, tocolor(255,255,255,anim))

            dxDrawText(types[i].name, sx/2-140/zoom, sy/2-128/zoom+((i-1)*(68/zoom)), _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'bottom')
            dxDrawText('Cena: #68D65E$ '..formatNumber(main['prizes'][i])..' / kg', sx/2-140/zoom, sy/2-128/zoom+((i-1)*(68/zoom)), _, _, tocolor(255,255,255,anim), 1, main['fonts'][2], 'left', 'top', false,false,false,true)
            
            local value = ((main['fishes'][string.lower(types[i].name)] or 0) * exports['since-scrollbar']:getScrollProgress(main['scrolls'][i]))/100
            dxDrawText('Sprzedaj #68D65E'..math.floor(value)..' kg', sx/2+90/zoom, sy/2-128/zoom+((i-1)*(68/zoom)), _, _, tocolor(255,255,255,anim), 1, main['fonts'][2], 'center', 'top', false,false,false,true)
        end
    end

    local isIn = isMouseIn(sx/2-100/zoom, sy/2-230/zoom+415/zoom, 200/zoom, 35/zoom)
    main['anim'][3] = interpolateBetween(main['anim'][3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2-100/zoom, sy/2-230/zoom+415/zoom, 200/zoom, 35/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,anim*main['anim'][3]))
    dxDrawText('Sprzedaj ryby', sx/2-100/zoom, sy/2-230/zoom+415/zoom,  sx/2-100/zoom+200/zoom, sy/2-230/zoom+415/zoom+35/zoom, tocolor(255,255,255,anim*main['anim'][3]), 1, main['fonts'][1], 'center', 'center')

    if main['marker'] then
        if isElement(main['marker']) then
            local x,y,z = getElementPosition(localPlayer)
            local x2,y2,z2 = getElementPosition(main['marker'])
            if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 3 then
                if not main['block'] then
                    turnPanel(false)
                end
            end
        end
    end
end

function click(button,state)
    if not main['countDown'] then main['countDown'] = getTickCount()-50 end
    if (button == 'left' and state == 'down' and not main['block'] and main['countDown'] < getTickCount()) then
        main['countDown'] = getTickCount() + 300
        if isMouseIn(sx/2+188/zoom, sy/2-222/zoom, 24/zoom, 24/zoom) then
            turnPanel(false)

        elseif isMouseIn(sx/2-100/zoom, sy/2-230/zoom+415/zoom, 200/zoom, 35/zoom) then
            local count = 0
            local tbl = {}
            for i=1,5 do 
                count = count + math.floor(((main['fishes'][string.lower(types[i].name)] or 0) * exports['since-scrollbar']:getScrollProgress(main['scrolls'][i]))/100)
                tbl[i] = math.floor(((main['fishes'][string.lower(types[i].name)] or 0) * exports['since-scrollbar']:getScrollProgress(main['scrolls'][i]))/100)
            end
            if count > 0 then
                triggerServerEvent('fish.s', resourceRoot, 'sell', tbl)
                turnPanel(false)
            end
        end
    end
end

function createTextures()
    main['anim'] = {0,0,0,0}
    main['textures'] = {}
    for i,v in ipairs({'bg','bg_mask','bg2','bg3','button','close','fish_icon'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Regular', 12/zoom),
        [3] = exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
        [6] = exports['since-fonts']:getFont('Inter-SemiBold', 17/zoom),
    }
    main['scrolls'] = {}
    for i=1,5 do
        main['scrolls'][i] = exports['since-scrollbar']:createScrollbar(sx/2, sy/2-146/zoom+((i-1)*(68/zoom)), 180/zoom, 8/zoom, {255, 255, 255}, true, 0, nil, nil, 0)
    end
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in ipairs(main['scrolls']) do
        exports['since-scrollbar']:destroyScroll(v)
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
end

function getPlayerFishes()
    local tbl = {}
    for i,v in ipairs(getElementData(localPlayer, 'player:inventory') or {}) do
        if drop[v.name] then
            tbl[v.name] = v.amount
        end
    end
    return tbl
end

function turnPanel(state, marker)
    if main['block'] then return end
    if state then
        main['block'] = true
        createTextures()
        main['prizes'] = getElementData(source, 'rybak:prizes') or {}
        main['fishes'] = getPlayerFishes()
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
            for i,v in ipairs(main['scrolls']) do
                exports['since-scrollbar']:setScrollAlpha(v, value)
            end
        end, function()
            addEventHandler('onClientClick', root, click)
            main['block'] = nil
        end)
        showCursor(true)
        addEventHandler('onClientRender', root, render)
        if marker then
            main['marker'] = marker
        end
    else
        main['block'] = true
        showCursor(false)
        removeEventHandler('onClientClick', root, click)
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
            for i,v in ipairs(main['scrolls']) do
                exports['since-scrollbar']:setScrollAlpha(v, value)
            end
        end, function()
            removeEventHandler('onClientRender', root, render)
            destroyTextures()
        end)
    end
end

addEventHandler('onClientMarkerHit', resourceRoot, function(el)
    if el ~= localPlayer or getElementType(el) ~= 'player' or not getElementData(source,'rybak:marker') or getPedOccupiedVehicle(el) then 
        return 
    end
    turnPanel(true, source)
end)

addEventHandler('onClientMarkerLeave', resourceRoot, function(el, md)
    if el ~= localPlayer then 
        return
    end
    if isEventHandlerAdded('onClientRender', root, render) then
        turnPanel(false)
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['scrolls'] and #main['scrolls'] > 0 then
        for i,v in ipairs(main['scrolls']) do
            exports['since-scrollbar']:destroyScroll(v)
        end
    end
end)
getResourceName(getThisResource(), true, 74078387); if true then return end