local airBreak = false
local cuboid14 = createColCuboid(1446.03, -2723.93, 12.56, 194.59, 28.31, 21.40)

bindKey('x', 'down', function()
    if getAdmin(localPlayer, 2) or getAdmin(localPlayer, 3) or getAdmin(localPlayer, 4) or getAdmin(localPlayer, 1) then
        airBreak = not airBreak
        local element = getPedOccupiedVehicle(localPlayer) or localPlayer
        setElementFrozen(element, airBreak)
        setElementCollisionsEnabled(element, not airBreak)
    end
end)

function removeAirbreakIfJob()
    if getElementData(localPlayer, 'player:job') then
        if getAdmin(localPlayer, 4) then
            return
        end
        
        airBreak = false
        local element = getPedOccupiedVehicle(localPlayer) or localPlayer
        setElementFrozen(element, airBreak)
        setElementCollisionsEnabled(element, not airBreak)
    end
end

function checkIsInCuboid()
    if isElementWithinColShape(localPlayer, cuboid14) then
        if getAdmin(localPlayer, 4) then
            return
        end

        airBreak = false
        local element = getPedOccupiedVehicle(localPlayer) or localPlayer
        setElementFrozen(element, airBreak)
        setElementCollisionsEnabled(element, not airBreak)
    end
end

addEventHandler('onClientRender', root, function()
    if not airBreak then 
        return 
    end

    removeAirbreakIfJob()
    checkIsInCuboid()

    local element = getPedOccupiedVehicle(localPlayer) or localPlayer
    local x, y, z = getElementPosition(element)
    local rx, ry, rz = getElementRotation(getCamera())

    rz = rz + 90
    
    local speed = getKeyState('lctrl') and 10 or (getKeyState('lalt') and 0.5 or 2)

    if getKeyState('w') and not isCursorShowing() then
        x = x + math.cos(math.rad(rz)) * speed
        y = y + math.sin(math.rad(rz)) * speed
    elseif getKeyState('s') and not isCursorShowing() then
        x = x - math.cos(math.rad(rz)) * speed
        y = y - math.sin(math.rad(rz)) * speed
    end

    if getKeyState('d') and not isCursorShowing() then
        x = x + math.cos(math.rad(rz - 90)) * speed
        y = y + math.sin(math.rad(rz - 90)) * speed
    elseif getKeyState('a') and not isCursorShowing() then
        x = x + math.cos(math.rad(rz + 90)) * speed
        y = y + math.sin(math.rad(rz + 90)) * speed
    end

    if getKeyState('space') then
        z = z + speed
    elseif getKeyState('lshift') then
        z = z - speed
    end

    setElementPosition(element, x, y, z)
    setElementRotation(element, 0, 0, rz - 90, 'default', true)

    local rx, ry, rz = getElementRotation(element)
    dxDrawText('Airbreak', 10/zoom + 1, sy/2 - 20/zoom + 1, nil, nil, black, 1, getFigmaFont('Inter-Black', 13/zoom), 'left', 'bottom')
    dxDrawText('Airbreak', 10/zoom, sy/2 - 20/zoom, nil, nil, tocolor(125, 255, 125), 1, getFigmaFont('Inter-Black', 13/zoom), 'left', 'bottom')
    dxDrawText(('Pozycja gracza: %.3f, %.3f, %.3f\nRotacja: %.3f, %.3f, %.3f'):format(x, y, z, rx, ry, rz), 10/zoom + 1, sy/2 - 20/zoom + 1, nil, nil, black, 1, getFigmaFont('Inter-Medium', 11/zoom), 'left', 'top')
    dxDrawText(('Pozycja gracza: %.3f, %.3f, %.3f\nRotacja: %.3f, %.3f, %.3f'):format(x, y, z, rx, ry, rz), 10/zoom, sy/2 - 20/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', 11/zoom), 'left', 'top')

    local controls = 'W - Do przodu\nS - Do tyłu\nD - W prawo\nA - W lewo\nSpacja - W góre\nShift - W dół\nCTRL - Szybciej\nALT - Wolniej\nX - Wyłącz airbreak'

    dxDrawText('Klawiszologia', 10/zoom + 1, sy/2 + 40/zoom + 1, nil, nil, black, 1, getFigmaFont('Inter-Black', 12/zoom), 'left', 'bottom')
    dxDrawText('Klawiszologia', 10/zoom, sy/2 + 40/zoom, nil, nil, tocolor(125, 255, 125), 1, getFigmaFont('Inter-Black', 12/zoom), 'left', 'bottom')
    dxDrawText(controls, 10/zoom + 1, sy/2 + 40/zoom + 1, nil, nil, black, 1, getFigmaFont('Inter-Medium', 10/zoom), 'left', 'top')
    dxDrawText(controls, 10/zoom, sy/2 + 40/zoom, nil, nil, white, 1, getFigmaFont('Inter-Medium', 10/zoom), 'left', 'top')

end)
getResourceName(getThisResource(), true, 222456884); if true then return end