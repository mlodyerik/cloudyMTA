local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local k = 1
local n = 5
local m = 5

local data = {}

function render()
    dxDrawImage(sx/2-528/zoom/2, sy/2-490/zoom/2, 528/zoom, 495/zoom, 'data/images/background.png')
    dxDrawText('Mandaty', sx/2-528/zoom/2 + 15/zoom, sy/2-490/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'center')
    dxDrawText('W tym miejscu opłacisz swoje mandaty!', sx/2-528/zoom/2 + 15/zoom, sy/2-490/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom)) - 3/zoom, nil, nil, tocolor(128, 241, 119), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center')
    dxDrawImage(sx/2-528/zoom/2, sy/2-490/zoom/2 + 65/zoom, 528/zoom, 2/zoom, 'data/images/line.png')

    local offset = 0
    for i,v in pairs(data) do
        if i >= k and i <= n then
            dxDrawImage(sx/2-528/zoom/2 + 15/zoom, sy/2-490/zoom/2 + 75/zoom + offset, 498/zoom, 77/zoom, 'data/images/element-bg.png')
            dxDrawText('Osoba wystawiająca: #438F87'..v.sender, sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-490/zoom/2 + 75/zoom + 16/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Kwota: #438F87$'..addCommas(v.price), sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-490/zoom/2 + 75/zoom + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) - 3/zoom + offset, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Powód: #438F87'..v.reason, sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-490/zoom/2 + 75/zoom + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + offset, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Opis: #438F87'..v.description, sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-490/zoom/2 + 75/zoom + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + offset, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)

            dxDrawImage(sx/2-528/zoom/2 + 498/zoom - 148/zoom, sy/2-490/zoom/2 + 75/zoom + offset + 77/zoom/2 - 29/zoom/2, 148/zoom, 29/zoom, 'data/images/button.png', 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-528/zoom/2 + 498/zoom - 148/zoom, sy/2-490/zoom/2 + 75/zoom + offset + 77/zoom/2 - 29/zoom/2, 148/zoom, 29/zoom) and 255 or 200)))
            dxDrawText('Zapłać', sx/2-528/zoom/2 + 498/zoom - 148/zoom + 74/zoom, sy/2-490/zoom/2 + 75/zoom + offset + 77/zoom/2, nil, nil, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')

            offset = offset + 77/zoom + 5/zoom
        end
    end

    dxDrawScrollbar(data, sx/2-528/zoom/2 + 519/zoom, sy/2-490/zoom/2 + 75/zoom, 3/zoom, 405/zoom, m, k, 255)
end

function scrollUp()
    if (k > 1) then
        k = k - 1
        n = n - 1
    end
end

function scrollDown()
    if (n < #data) then
        k = k + 1
        n = n + 1
    end
end

function click(button, state)
    if (button == 'left' and state == 'down') then
        local offset = 0

        for i,v in pairs(data) do
            if i >= k and i <= n then
                if (isMouseInPosition(sx/2-528/zoom/2 + 498/zoom - 148/zoom, sy/2-490/zoom/2 + 75/zoom + offset + 77/zoom/2 - 29/zoom/2, 148/zoom, 29/zoom)) then
                    triggerServerEvent('since-mandates:pay', resourceRoot, v.id)
                end

                offset = offset + 77/zoom + 5/zoom
            end
        end
    end
end

addEvent('since-mandates:show', true)
addEventHandler('since-mandates:show', root, function(rows)
    data = rows

    addEventHandler('onClientRender', root, render)
    addEventHandler('onClientClick', root, click)
    showCursor(true, false)

    bindKey('mouse_wheel_down', 'down', scrollDown)
    bindKey('mouse_wheel_up', 'down', scrollUp)
    
    k = 1
    n = 5
    m = 5
end)

addEvent('since-mandates:hide', true)
addEventHandler('since-mandates:hide', root, function()
    unbindKey('mouse_wheel_down', 'down', scrollDown)
    unbindKey('mouse_wheel_up', 'down', scrollUp)

    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientClick', root, click)
    showCursor(false)
end)

addEvent('since-mandates:update', true)
addEventHandler('since-mandates:update', resourceRoot, function(rows)
    data = rows
end)