sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

Panel = {}
Panel.pages = {}
Panel.page = 1
Panel.data = {}
Panel.scrolls = {
    members = {
        k = 1,
        n = 8,
        m = 8
    }
}
Panel.elements = {}
Panel.textures = {
    ['editbox'] = dxCreateTexture('data/images/editbox.png', 'argb', false, 'clamp')
}

function render()
    dxDrawImage(sx/2-942/zoom/2, sy/2-500/zoom/2, 942/zoom, 500/zoom, 'data/images/background.png')

    dxDrawRectangle(sx / 2 - 224/zoom, sy / 2 - 250/zoom, 1, 500/zoom, tocolor(200, 200, 200, 65))
    dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 135/zoom - 1, 247/zoom, 1, tocolor(255, 255, 255, 65))

    dxDrawImage(sx/2 - 455/zoom, sy/2 - 232/zoom, 218/zoom, 75/zoom, 'data/images/logo.png')
    dxDrawImage(sx/2 - 223/zoom, sy/2 - 250/zoom, 694/zoom, 47/zoom, 'data/images/toprectangle.png')

    local offset = 0

    for i,v in pairs(Panel.pages) do
        local isMouse = isMouseInPosition(sx/2 - 471/zoom, sy/2 - 135/zoom + offset, 247/zoom, 45/zoom) and 15 or 0
        local tabColor = (Panel.page == i and tocolor(100, 200, 100, 25 + isMouse) or tocolor(200, 200, 200, 25 + isMouse))

        dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 135/zoom + offset, 247/zoom, 45/zoom, tabColor)
        dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 89/zoom - 1 + offset, 247/zoom, 1, tocolor(255, 255, 255, 65))
        dxDrawImage(sx/2 - 459/zoom, sy/2 - 126/zoom + offset, 26/zoom, 26/zoom, "data/images/"..v.icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255))

        dxDrawText(v.name, sx/2 - 422/zoom, sy/2 - 113/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'center')

        offset = offset + 45/zoom + 1
    end

    local v = Panel.pages[Panel.page]

    dxDrawImage(sx/2 - 211/zoom, sy/2 - 239/zoom, 26/zoom, 26/zoom, "data/images/"..v.icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(v.name, sx/2 - 178/zoom, sy/2 - 222/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 12/zoom), 'left', 'bottom')
    dxDrawText(v.description, sx/2 - 178/zoom, sy/2 - 224/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'top')

    if (v.render) then
        v.render()
    end
end

function click(button, state)
    if (button == 'left' and state == 'down') then
        local offset = 0

        for i,v in pairs(Panel.pages) do
            if (isMouseInPosition(sx/2 - 471/zoom, sy/2 - 135/zoom + offset, 247/zoom, 45/zoom)) then
                if (Panel.pages[Panel.page].onExit) then
                    Panel.pages[Panel.page].onExit()
                end
                
                Panel.page = i

                if (Panel.pages[i].onEnter) then
                    Panel.pages[i].onEnter()
                end

                break
            end

            offset = offset + 45/zoom + 1
        end

        if (Panel.pages[Panel.page].onClick) then
            Panel.pages[Panel.page].onClick()
        end
    end
end

addEvent('since=factions-panel:show', true)
addEventHandler('since=factions-panel:show', resourceRoot, function(s)
    Panel.data = s
    addEventHandler('onClientRender', root, render)
    addEventHandler('onClientClick', root, click)
    showCursor(true, false)
end)

addEvent('since=factions-panel:update', true)
addEventHandler('since=factions-panel:update', resourceRoot, function(s)
    Panel.data = s
end)

addEvent('since=factions-panel:hide', true)
addEventHandler('since=factions-panel:hide', resourceRoot, function()
    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientClick', root, click)
    showCursor(false, false)

    if (Panel.pages[Panel.page].onExit) then
        Panel.pages[Panel.page].onExit()
    end

    Panel.page = 1
    Panel.scrolls.members.k = 1
    Panel.scrolls.members.n = 8
    Panel.scrolls.members.m = 8
end)

addEventHandler('onClientResourceStop', resourceRoot, function ()
    for i,v in pairs(Panel.elements) do
        if (v) then
            exports['since-gui']:destroyUIElement(v)
        end
    end
end)