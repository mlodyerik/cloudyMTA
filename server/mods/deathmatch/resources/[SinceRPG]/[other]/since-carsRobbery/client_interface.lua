local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048 and math.min(2.2, 2048/sx) or 1)
local interface = {}

function renderInterface()
    dxDrawImage(sx/2-550/zoom, sy/2-354/zoom, 1100/zoom, 708/zoom, interface.textures.bg, 0, 0, 0, tocolor(255,255,255,255))
    dxDrawImage(sx/2-540/zoom, sy/2-344/zoom, 50/zoom, 50/zoom, interface.textures.garage_icon, 0, 0, 0, tocolor(255,255,255,255))
    dxDrawText('Dziupla', sx/2-480/zoom, sy/2-335/zoom, nil, nil, tocolor(143,214,137,255), 1, interface.fonts[1], 'left', 'top', false, false, false, false, false)
    dxDrawText('Miejsce na porzucone pojazdy', sx/2-480/zoom, sy/2-295/zoom, nil, nil, tocolor(255,255,255,255), 1, interface.fonts[2], 'left', 'bottom', false, false, false, false, false)

    local isIn = isMouseInPosition(sx/2+504/zoom, sy/2-328/zoom, 20/zoom, 20/zoom)
    dxDrawImage(sx/2+504/zoom, sy/2-328/zoom, 20/zoom, 20/zoom, interface.textures.close, 0, 0, 0, tocolor(255,255,255,isIn and 255 or 150))

    local isAt = false
    local offset = 0
    for i=1,6 do
        local v = interface.rows[i]
        local isIn = v and isMouseInPosition(sx/2-540/zoom, sy/2-270/zoom+offset, 500/zoom, 100/zoom) or false
        if isIn then
            isAt = i
        end
        dxDrawImage(sx/2-540/zoom, sy/2-270/zoom+offset, 500/zoom, 100/zoom, v and interface.textures.bg3 or interface.textures.bg2, 0, 0, 0, tocolor(255,255,255,isIn and 255 or 215))
        dxDrawImage(sx/2-530/zoom, sy/2-245/zoom+offset, 50/zoom, 50/zoom, v and interface.textures.car_icon or interface.textures.none_icon, 0, 0, 0, tocolor(255,255,255,isIn and 255 or 215))

        dxDrawText(v and exports['since-vehiclenames']:getVehicleName(v.model) or 'Pusty slot', sx/2-470/zoom, sy/2-240/zoom+offset, nil, nil, tocolor(255,255,255,255), 1, interface.fonts[1], 'left', 'top', false, false, false, false, false)
        dxDrawText(v and 'Kliknij aby sprzedać pojazd' or 'Ta powierzchnia dziupli jest pusta ', sx/2-470/zoom, sy/2-240/zoom+40/zoom+offset, nil, nil, tocolor(255,255,255,255), 1, interface.fonts[2], 'left', 'bottom', false, false, false, true, false)

        offset = offset + 103/zoom
    end

    if isAt then
        local cost = getVehicleCost(interface.rows[isAt].model, interface.rows[isAt].state)
        local cx, cy = getCursorPosition()
        cx, cy = cx*sx, cy*sy
        dxDrawText('Za sprzedarz dostaniesz: '..formatNumber(cost)..' $', cx + 1, cy + 20/zoom + 1, nil, nil, tocolor(0,0,0,155), 1, interface.fonts[1], 'center', 'top')
        dxDrawText('Za sprzedarz dostaniesz: #9FFF97'..formatNumber(cost)..' $', cx, cy + 20/zoom, nil, nil, tocolor(255,255,255,255), 1, interface.fonts[1], 'center', 'top', false, false, false, true, false)
    end

    dxDrawImage(sx/2-20/zoom, sy/2-269/zoom, 550/zoom, 550/zoom, interface.textures.map, 0, 0, 0, tocolor(255,255,255,255))
    if interface.mapIs then
        for i,v in ipairs(interface.cars or {}) do
            local x, y = v[1], v[2]
            local x = x > 3000 and 3000 or x < -3000 and -3000 or x
            local y = y > 3000 and 3000 or y < -3000 and -3000 or y
            local x, y = (x+3000)/6000*(550/zoom), (-y+3000)/6000*(550/zoom)
            dxDrawImage(sx/2-20/zoom+x-10/zoom, sy/2-269/zoom+y-10/zoom, 20/zoom, 20/zoom, interface.textures.point, 0, 0, 0, tocolor(255,255,255,255))
        end
    end

    local isIn = isMouseInPosition(sx/2+340/zoom, sy/2+294/zoom, 200/zoom, 50/zoom)
    dxDrawImage(sx/2+340/zoom, sy/2+294/zoom, 200/zoom, 50/zoom, interface.mapIs and interface.textures.button2 or interface.textures.button1, 0, 0, 0, tocolor(255,255,255,isIn and 150 or 255))
    dxDrawText(interface.mapIs and 'Posiadasz mape' or 'Zakup mapę', sx/2+340/zoom, sy/2+294/zoom, sx/2+540/zoom, sy/2+344/zoom, tocolor(255,255,255,isIn and 150 or 255), 1, interface.fonts[1], 'center', 'center')
    if (isIn and not interface.mapIs) then
        local cx, cy = getCursorPosition()
        cx, cy = cx*sx, cy*sy
        dxDrawText('Koszt mapy: '..formatNumber(config.mapCost)..' $\nKwota zostanie pobrana z twojego portfela', cx + 1, cy + 20/zoom + 1, nil, nil, tocolor(0,0,0,155), 1, interface.fonts[1], 'center', 'top')
        dxDrawText('Koszt mapy: #9FFF97'..formatNumber(config.mapCost)..' $\nKwota zostanie pobrana z twojego portfela', cx, cy + 20/zoom, nil, nil, tocolor(255,255,255,255), 1, interface.fonts[1], 'center', 'top', false, false, false, true, false)
    end
end

function clickInterface(button, state)
    if (button ~= 'left' or state ~= 'down') then
        return
    end
    if isMouseInPosition(sx/2+504/zoom, sy/2-328/zoom, 20/zoom, 20/zoom) then
        removeInterface()
    elseif isMouseInPosition(sx/2+340/zoom, sy/2+294/zoom, 200/zoom, 50/zoom) then
        if interface.mapIs then
            return
        end
        triggerServerEvent('onServerBuyMap', resourceRoot, config.mapCost)
    else
        local offset = 0
        for i=1,6 do
            local v = interface.rows[i]
            if v and isMouseInPosition(sx/2-540/zoom, sy/2-270/zoom+offset, 500/zoom, 100/zoom) then
                triggerServerEvent('onServerSellVehicle', resourceRoot, v)
                removeInterface()
                break
            end
            offset = offset + 103/zoom
        end
    end
end

function createInterface()
    if isEventHandlerAdded('onClientRender', root, renderInterface) then
        return
    end
    if interface.textures then
        for i,v in pairs(interface.textures) do
            destroyElement(v)
        end
    end
    interface.textures = {}
    for i,v in ipairs({'bg','bg2','bg3','car_icon','close','garage_icon','none_icon', 'map', 'button1', 'button2', 'point'}) do
        interface.textures[v] = dxCreateTexture('files/images/garage/'..v..'.png')
    end
    interface.fonts = {
        [1] = exports['since-fonts']:getFont("Inter-bold", 14/zoom),
        [2] = exports['since-fonts']:getFont("Inter-semiBold", 11/zoom),
        [3] = exports['since-fonts']:getFont("Inter-bold", 25/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [6] = exports['since-fonts']:getFont('Inter-Regular', 11/zoom),
    }
    addEventHandler('onClientRender', root, renderInterface)
    addEventHandler('onClientClick', root, clickInterface)
    showCursor(true)
end

function removeInterface()
    if not isEventHandlerAdded('onClientRender', root, renderInterface) then
        return
    end
    removeEventHandler('onClientRender', root, renderInterface)
    removeEventHandler('onClientClick', root, clickInterface)
    if interface.textures then
        for i,v in pairs(interface.textures) do
            destroyElement(v)
        end
    end
    interface.textures = nil
    interface.fonts = nil
    interface.mapIs = nil
    interface.rows = nil
    showCursor(false)
end

function isMouseInPosition(x, y, w, h)
    if (not isCursorShowing()) then
        return false
    end
    local mx,my = getCursorPosition()
    local fullx,fully = guiGetScreenSize()
    mx,my = mx*fullx,my*fully
    return (mx >= x and mx <= x+w and my >= y and my <= y+h)
end

function formatNumber(n)
    n = tostring(n)
    return n:reverse():gsub('(%d%d%d)','%1,'):reverse():gsub('^,', '')
end

local garage = {}

addEvent('onClientShowGarage', true)
addEventHandler('onClientShowGarage', resourceRoot, function(rows, mapIs, positions)
    createInterface()
    interface.rows = rows
    interface.mapIs = (mapIs and mapIs > 0) and true or false
    interface.cars = positions
end)

addEvent('onClientEnterGarage', true)
addEventHandler('onClientEnterGarage', resourceRoot, function(state, vehicles)
    if state then
        if garage.leaveMarker then
            if isElement(garage.leaveMarker) then
                destroyElement(garage.leaveMarker)
            end
            garage.leaveMarker = nil
        end
        garage.leaveMarker = createMarker(1415.28, -1687.35, 60.38-1, 'cylinder', 1.5, 255, 255, 255, 150)
        setElementData(garage.leaveMarker, 'marker:title', 'Wyjście')
        setElementData(garage.leaveMarker, 'marker:desc', 'Drzwi wyjściowe z dziupli')
        setElementData(garage.leaveMarker, 'marker:icon', 'entrance')
        setElementDimension(garage.leaveMarker, getElementDimension(localPlayer))
        setElementInterior(garage.leaveMarker, getElementInterior(localPlayer))
        addEventHandler('onClientMarkerHit', garage.leaveMarker, function(el, md)
            if (el ~= localPlayer or not md) then
                return
            end
            fadeCamera(false, 0.5)
            toggleMoveing(false)
            setTimer(function()
                triggerServerEvent('onServerLeaveGarage', resourceRoot)
            end, 500, 1)
        end)
        fadeCamera(true, 1)
        toggleMoveing(true)
        loadRenderTargets(vehicles)
    else
        toggleMoveing(false)
        fadeCamera(false, 0.5)
        setTimer(function()
            triggerServerEvent('onServerEnterGarage', resourceRoot)
        end, 500, 1)
    end
end)

addEvent('onClientExitGarage', true)
addEventHandler('onClientExitGarage', resourceRoot, function()
    if garage.leaveMarker then
        if isElement(garage.leaveMarker) then
            destroyElement(garage.leaveMarker)
        end
        garage.leaveMarker = nil
    end
    fadeCamera(true, 0.5)
    toggleMoveing(true)
end)

function toggleMoveing(state)
    toggleControl('forwards', state)
    toggleControl('backwards', state)
    toggleControl('left', state)
    toggleControl('right', state)
end

addEvent('onClientRefresh', true)
addEventHandler('onClientRefresh', resourceRoot, function(rows, mapIs)
    if isEventHandlerAdded('onClientRender', root, renderInterface) then
        interface.rows = rows
        interface.mapIs = (mapIs and mapIs > 0) and true or false
    end
end)

-- fadeCamera(true, 0.1)
-- toggleMoveing(true)