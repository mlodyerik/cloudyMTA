local toggled = false
local polygons = {}

function renderFix()
    dxDrawImage(sx/2-758/zoom/2, sy/2-420/zoom/2, 758/zoom, 420/zoom, "data/images/bg2.png")
    dxDrawText('Naprawianie auta', sx/2-758/zoom/2 + 15/zoom, sy/2-420/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'center')
    dxDrawText('Since Los Santos Mechs', sx/2-758/zoom/2 + 15/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom)), nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center')
    dxDrawImage(sx/2-758/zoom/2, sy/2-420/zoom/2 + 70/zoom, 758/zoom, 2/zoom, "data/images/line2.png")

    for i,v in pairs(polygons) do
        local x, y = unpack(v.position)
        
        dxDrawImage(x, y, 46/zoom, 50/zoom, "data/images/"..(v.level == 100 and "polygon-success" or "polygon")..".png", v.level, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(x, y, 46/zoom, 50/zoom) and 255 or 150)))
        dxDrawText(v.level..'%', x + 46/zoom/2, y + 50/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')
    end
end

function checkIsDoneAll()
    for i,v in pairs(polygons) do
        if (v.level ~= 100) then
            return false
        end
    end

    return true
end

function scrollUp()
    for i,v in pairs(polygons) do
        if (isMouseInPosition(v.position[1], v.position[2], 46/zoom, 50/zoom)) then
            if (v.level < 100) then
                v.level = v.level + 1

                if (checkIsDoneAll()) then
                    removeEventHandler('onClientRender', root, renderFix)
                    unbindKey('mouse_wheel_up', 'down', scrollUp)
                    unbindKey('mouse_wheel_down', 'down', scrollDown)
                    toggled = false
                    setElementFrozen(localPlayer, false)
                    showCursor(false)
                    setPedAnimation(localPlayer, false)
                    polygons = {}
                    destroyCreatedVehicle()

                    triggerServerEvent('onJobEndFixVehicle', resourceRoot)
                end
            end
        end
    end
end

function scrollDown()
    for i,v in pairs(polygons) do
        if (isMouseInPosition(v.position[1], v.position[2], 46/zoom, 50/zoom) and v.level ~= 100) then
            if (v.level > 0) then
                v.level = v.level - 1
            end
        end
    end
end

function isFixing()
    return toggled
end

function tryOpenFixGUI()
    if (toggled) then return end

    addEventHandler('onClientRender', root, renderFix)
    showCursor(true, false)
    setElementFrozen(localPlayer, true)
    setPedAnimation(localPlayer, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)

    bindKey('mouse_wheel_up', 'down', scrollUp)
    bindKey('mouse_wheel_down', 'down', scrollDown)

    toggled = true

    for i = 1, 12 do
        local x, y = math.random(sx/2-758/zoom/2 + 15/zoom, sx/2-758/zoom/2 + 15/zoom + 700/zoom), math.random(sy/2-420/zoom/2 + 85/zoom, sy/2-420/zoom/2 + 85/zoom + 280/zoom)
        table.insert(polygons, {position = {x, y}, level = math.random(20, 50)})
    end
end