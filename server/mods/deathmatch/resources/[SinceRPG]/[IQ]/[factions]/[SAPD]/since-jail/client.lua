local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local k = 1
local n = 4
local m = 4

local data = {}

function render()
    dxDrawImage(sx/2-528/zoom/2, sy/2-460/zoom/2, 528/zoom, 460/zoom, 'data/images/background.png')
    dxDrawText('Więzienie', sx/2-528/zoom/2 + 15/zoom, sy/2-460/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'center')
    dxDrawText('W tym miejscu możesz uwolnić wybranego gracza!', sx/2-528/zoom/2 + 15/zoom, sy/2-460/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom)) - 3/zoom, nil, nil, tocolor(128, 241, 119), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center')
    dxDrawImage(sx/2-528/zoom/2, sy/2-460/zoom/2 + 65/zoom, 528/zoom, 2/zoom, 'data/images/line.png')

    local offset = 0
    for i,v in pairs(data) do
        if i >= k and i <= n then
            dxDrawImage(sx/2-528/zoom/2 + 15/zoom, sy/2-460/zoom/2 + 75/zoom + offset, 498/zoom, 90/zoom, 'data/images/element-bg.png')

            dxDrawText('Gracz: #438F87'..v.target, sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-460/zoom/2 + 75/zoom + 16/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Funkcjonariusz: #438F87'..v.username, sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-460/zoom/2 + 75/zoom + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) - 3/zoom + offset, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Powód: #438F87'..v.reason, sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-460/zoom/2 + 75/zoom + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)) + offset, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Wykupienie: #438F87$'..addCommas(v.money)..'#c8c8c8 pozostało #438F87'..v.time..'#c8c8c8 minut', sx/2-528/zoom/2 + 15/zoom + 10/zoom, sy/2-460/zoom/2 + 75/zoom + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)) + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)) + offset, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center', false, false, false, true)

            dxDrawImage(sx/2-528/zoom/2 + 498/zoom - 148/zoom, sy/2-460/zoom/2 + 75/zoom + offset + 90/zoom/2 - 29/zoom/2, 148/zoom, 29/zoom, 'data/images/button.png', 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-528/zoom/2 + 498/zoom - 148/zoom, sy/2-460/zoom/2 + 75/zoom + offset + 77/zoom/2 - 29/zoom/2, 148/zoom, 29/zoom) and 255 or 200)))
            dxDrawText('Zapłać', sx/2-528/zoom/2 + 498/zoom - 148/zoom + 74/zoom, sy/2-460/zoom/2 + 75/zoom + offset + 90/zoom/2, nil, nil, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')

            offset = offset + 90/zoom + 5/zoom
        end
    end

    dxDrawScrollbar(data, sx/2-528/zoom/2 + 519/zoom, sy/2-460/zoom/2 + 75/zoom, 3/zoom, 375/zoom, m, k, 255)
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
                if (isMouseInPosition(sx/2-528/zoom/2 + 498/zoom - 148/zoom, sy/2-460/zoom/2 + 75/zoom + offset + 90/zoom/2 - 29/zoom/2, 148/zoom, 29/zoom)) then
                    triggerServerEvent('since-jail:pay', resourceRoot, v.id)
                    break
                end

                offset = offset + 90/zoom + 5/zoom
            end
        end
    end
end

addEvent('since-jail:show', true)
addEventHandler('since-jail:show', resourceRoot, function (d)
    data = d
    addEventHandler('onClientRender', root, render)
    addEventHandler('onClientClick', root, click)
    bindKey('mouse_wheel_up', 'down', scrollUp)
    bindKey('mouse_wheel_down', 'down', scrollDown)
    showCursor(true, false)
end)

addEvent('since-jail:hide', true)
addEventHandler('since-jail:hide', resourceRoot, function ()
    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientClick', root, click)
    unbindKey('mouse_wheel_up', 'down', scrollUp)
    unbindKey('mouse_wheel_down', 'down', scrollDown)
    showCursor(false)
end)