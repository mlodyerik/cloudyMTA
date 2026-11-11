local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

Classes = {}
Classes.actual = 1
Classes.postionY = sy/2-182/zoom/2 + 5/zoom
Classes.animation = false
Classes.alpha = 1

Classes.angle = 260
Classes.rotSpeed = 0.25

Classes.render = function ()
    Classes.angle = (Classes.angle - Classes.rotSpeed) % 360
    local cx, cy, cz, lx, ly, lz = getCameraMatrix(localPlayer)
    local c1, c2, c3, c4, c5 = 1475.52, -1681.68, 1477.42, -1662.76, 13.26
    local camx, camy = getPointFromDistanceRotation(c3, c4, 115, Classes.angle)
    smoothMoveCamera(camx, camy, c5 + 35, c3, c4, c5)

    dxDrawImage(0, 0, sx - 300/zoom, sy, 'data/images/left-shadow.png')

    dxDrawImage(35/zoom, sy/2-182/zoom/2, 48/zoom, 182/zoom, 'data/images/classes-bg.png')

    dxDrawImage(35/zoom + 4/zoom, Classes.postionY, 40/zoom, 40/zoom, 'data/images/page-active.png')

    local offset = 0
    for i,v in pairs(ClassesList) do
        dxDrawImage(35/zoom + 4/zoom, sy/2-182/zoom/2 + offset + 5/zoom, 40/zoom, 40/zoom, 'data/images/page-bg.png')
        dxDrawImage(35/zoom + 4/zoom + 40/zoom/2 - 23/zoom/2, sy/2-182/zoom/2 + offset + 5/zoom + 40/zoom/2 - 23/zoom/2, 23/zoom, 23/zoom, "data/images/"..v.icon..".png")

        offset = offset + 40/zoom + 4/zoom
    end

    dxDrawImage(sx - (959/zoom * 0.8) - 70/zoom, sy/2-(959/zoom * 0.8)/2, 959/zoom * 0.8, 959/zoom * 0.8, 'data/images/circle.png', 0, 0, 0, tocolor(255, 255, 255, 255 * Classes.alpha))

    if (not ClassesList[Classes.actual].texture) then
        ClassesList[Classes.actual].texture = dxCreateTexture('data/images/'..ClassesList[Classes.actual].image..'.png', 'argb', false, 'clamp')
    end

    dxDrawImage(sx - 810/zoom, sy/2-959/zoom/2, 751/zoom, 1356/zoom, ClassesList[Classes.actual].texture, 0, 0, 0, tocolor(255, 255, 255, 255 * Classes.alpha))

    dxDrawImage(0, 0, 1085/zoom, 854/zoom, "data/images/glow.png")

    dxDrawText(ClassesList[Classes.actual].name, 130/zoom, 96/zoom, nil, nil, tocolor(34, 160, 69, 255 * Classes.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 35/zoom), 'left', 'center')

    if (not ClassesList[Classes.actual].wrap) then
        ClassesList[Classes.actual].wrap = wordWrap(ClassesList[Classes.actual].description, 627/zoom, 1, exports['since-fonts']:getFont('Inter-Regular', 15/zoom), true)
    end

    local offset = 0
    for i,v in pairs(ClassesList[Classes.actual].wrap) do
        dxDrawText(v, 130/zoom, 120/zoom + offset, nil, nil, tocolor(255, 255, 255, 200 * Classes.alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 15/zoom), 'left', 'top')

        offset = offset + 20/zoom
    end

    dxDrawImage(130/zoom, 140/zoom + offset + 10/zoom, 627/zoom, 242/zoom, "data/images/bonuses-bg.png", 0, 0, 0, tocolor(255, 255, 255, 255 * Classes.alpha))
    dxDrawImage(130/zoom, 140/zoom + offset + 10/zoom, 627/zoom, 43/zoom, "data/images/bonuses-header.png", 0, 0, 0, tocolor(255, 255, 255, 255 * Classes.alpha))
    dxDrawText('Bonusy tej klasy', 145/zoom, 140/zoom + offset + 10/zoom + 43/zoom/2, nil, nil, tocolor(255, 255, 255, 255 * Classes.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'center')

    local offset2 = 0
    for i,v in pairs(ClassesList[Classes.actual].bonuses) do
        dxDrawImage(130/zoom + 15/zoom + offset2, 207/zoom + offset, 135/zoom, 167/zoom, "data/images/"..v.bg..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * Classes.alpha))
        dxDrawImage(130/zoom + 15/zoom + offset2 + 135/zoom/2 - 95/zoom/2, 220/zoom + offset, 95/zoom, 95/zoom, "data/images/"..v.icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * Classes.alpha))
        dxDrawText(v.name, 130/zoom + 15/zoom + offset2 + 135/zoom/2, 220/zoom + 100/zoom + offset, nil, nil, tocolor(255, 255, 255, 255 * Classes.alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 13/zoom), 'center', 'top')

        offset2 = offset2 + 155/zoom
    end


    dxDrawImage(133/zoom, sy-96/zoom, 627/zoom, 52/zoom, "data/images/select_button.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(133/zoom, sy-96/zoom, 627/zoom, 52/zoom) and 255 or 200) * Classes.alpha))
    dxDrawText('Wybierz klasę', 133/zoom, sy-96/zoom, 133/zoom + 627/zoom, sy-96/zoom + 52/zoom, tocolor(255, 255, 255, 255 * Classes.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'center')
end

Classes.click = function (button, state)
    if (button == 'left' and state == 'down' and not Classes.animation) then
        local offset = 0

        for i,v in pairs(ClassesList) do
            if (isMouseInPosition(35/zoom + 4/zoom, sy/2-182/zoom/2 + offset + 5/zoom, 40/zoom, 40/zoom) and Classes.actual ~= i) then 
                Classes.animation = true

                animate(Classes.postionY, sy/2-182/zoom/2 + offset + 5/zoom, "OutQuad", 400, function (v)
                    Classes.postionY = v
                end, function ()
                    Classes.animation = false
                end)

                animate(Classes.alpha, 0, "OutQuad", 200, function (v)
                    Classes.alpha = v
                end, function ()
                    Classes.actual = i

                    animate(Classes.alpha, 1, "OutQuad", 200, function (v)
                        Classes.alpha = v
                    end)
                end)
            end

            offset = offset + 40/zoom + 4/zoom
        end

        if (isMouseInPosition(133/zoom, sy-96/zoom, 627/zoom, 52/zoom)) then
            triggerServerEvent('since-classes:choose', resourceRoot, ClassesList[Classes.actual].name)
        end
    end
end

local toggled = false

addEvent('since-classes:show', true)
addEventHandler('since-classes:show', resourceRoot, function ()
    if (toggled) then
        return
    end

    toggled = true
    addEventHandler('onClientRender', root, Classes.render)
    addEventHandler('onClientClick', root, Classes.click)
    showChat(false)
    showCursor(true)
    setElementData(localPlayer, 'player:hudof', true)
    setCameraTarget(localPlayer)
    fadeCamera(true)
end)

addEvent('since-classes:hide', true)
addEventHandler('since-classes:hide', resourceRoot, function ()
    removeEventHandler('onClientRender', root, Classes.render)
    removeEventHandler('onClientClick', root, Classes.click)
    showChat(true)
    showCursor(false)
    setElementData(localPlayer, 'player:hudof', false)
    setCameraTarget(localPlayer)
    stopSmoothMoveCamera()
end)