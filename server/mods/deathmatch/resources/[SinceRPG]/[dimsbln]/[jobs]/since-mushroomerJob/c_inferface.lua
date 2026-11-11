local sx, sy = guiGetScreenSize()
local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1
local gui = {}

function render()
    if not main['collected'] then return end
    dxDrawImage(330/zoom-1, sy-80/zoom-1, 50/zoom, 50/zoom, 'files/images/icon.png', 0, 0, 0, tocolor(0, 0, 0, 125))
    dxDrawImage(330/zoom, sy-80/zoom, 50/zoom, 50/zoom, 'files/images/icon.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(#main['collected']..' / '.. main['limit'], 390/zoom-1, sy-80/zoom+50/2/zoom-1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), 'left', 'center')
    dxDrawText(#main['collected']..' / '.. main['limit'], 390/zoom, sy-80/zoom+50/2/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), 'left', 'center')
end

function sellRender()
	exports['since-blur']:dxDrawBlur(sx/2-210/zoom, sy/2-474/2/zoom, 420/zoom, 474/zoom, gui['textures']['bg'])
    dxDrawImage(sx/2-210/zoom, sy/2-474/2/zoom, 420/zoom, 474/zoom, gui['textures']['bg'], 0, 0, 0, tocolor(255, 255, 255, 235))

    dxDrawText('Sprzedaż grzybów', sx/2, sy/2 - 205/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Otrzymaj wynagrodzenie za zebrane grzyby', sx/2, sy/2 - 205/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')

    dxDrawText('Nazwa', sx/2-190/zoom, sy/2 - 160/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'left', 'center')
    dxDrawText('Rozmiar', sx/2, sy/2 - 160/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'center', 'center')
    dxDrawText('Wartość', sx/2+190/zoom, sy/2 - 160/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'right', 'center')

    local offset = 0
    for i, v in ipairs(main['collected']) do
        if i <= 11 then
            dxDrawImage(sx/2-200/zoom, sy/2-145/zoom+offset, 400/zoom, 25/zoom, gui['textures']['bar'], 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawText(names[v.model], sx/2-190/zoom, sy/2-145/zoom+25/2/zoom+offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center')
            dxDrawText(getSizeFromValue(v.size), sx/2, sy/2-145/zoom+25/2/zoom+offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')
            local money = formatNumber(calculateMoney({v}))
            dxDrawText('$ '..money, sx/2+190/zoom, sy/2-145/zoom+25/2/zoom+offset, nil, nil, tocolor(88, 255, 115, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'center')
            offset = offset + 29/zoom
        end
    end

    local isIn = isMouseIn(sx/2-150/2/zoom, sy/2+188/zoom, 150/zoom, 35/zoom)
    dxDrawImage(sx/2-150/2/zoom, sy/2+188/zoom, 150/zoom, 35/zoom, gui['textures']['button'], 0, 0, 0, tocolor(255, 255, 255, isIn and 225 or 255))
    dxDrawText('Sprzedaj grzyby', sx/2-150/2/zoom, sy/2+188/zoom, sx/2-150/2/zoom+150/zoom, sy/2+188/zoom+35/zoom, tocolor(255, 255, 255, isIn and 225 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')

    if gui['marker'] then
        local x,y,z = getElementPosition(gui['marker'])
        local px,py,pz = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(x,y,z,px,py,pz) > 2.5 then
            turnPanel(2, false)
            return
        end
    end
end

function click(button, state)
    if button == 'left' and state == 'down' then
        if isMouseIn(sx/2-150/2/zoom, sy/2+188/zoom, 150/zoom, 35/zoom) then
            triggerServerEvent('mushroomer', resourceRoot, 'sellMushrooms', {#main['collected'], calculateMoney(main['collected'])})
            turnPanel(2, false)
        end
    end
end

function turnPanel(id, state, marker)
    if id == 1 then
        if state then
            if isEventHandlerAdded('onClientRender', root, render) then return end
            addEventHandler('onClientRender', root, render)
        else
            if not isEventHandlerAdded('onClientRender', root, render) then return end
            removeEventHandler('onClientRender', root, render)
        end
    elseif id == 2 then
        if state then
            if isEventHandlerAdded('onClientRender', root, sellRender) then return end
            gui['fonts'] = {}
            gui['textures'] = {}
            for i,v in ipairs({'bg','bg_mask','bar','button'}) do
                if fileExists('files/images/'..v..'.png') then
                    gui['textures'][v] = dxCreateTexture('files/images/'..v..'.png')
                end
            end
            gui['marker'] = marker
            addEventHandler('onClientRender', root, sellRender)
            addEventHandler('onClientClick', root, click)
            showCursor(true, false)
        else
            if not isEventHandlerAdded('onClientRender', root, sellRender) then return end
            removeEventHandler('onClientClick', root, click)
            removeEventHandler('onClientRender', root, sellRender)
            showCursor(false)
            for i,v in pairs(gui['textures']) do
                if isElement(v) then
                    destroyElement(v)
                    gui['textures'][i] = nil
                end
            end
            gui['textures'] = nil
            gui['marker'] = nil
            gui['fonts'] = nil
        end
    end
end

function formatNumber(n)
    n = tostring(n)
    return n:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function isMouseIn(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local fullx, fully = guiGetScreenSize()
        cursorx, cursory = mx*fullx, my*fully
        if cursorx > x and cursorx < x+w and cursory > y and cursory < y+h then
            return true
        end
    end
    return false
end
