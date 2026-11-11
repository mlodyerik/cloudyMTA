local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local k = 1
local n = 6
local m = 6

function render()
    dxDrawImage(sx/2-440/zoom/2, sy/2-460/zoom/2, 440/zoom, 460/zoom, 'data/images/bg.png')
    dxDrawText('Kabura', sx/2-440/zoom/2 + 15/zoom, sy/2-460/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
    dxDrawText('Frakcja '..getElementData(localPlayer, 'player:faction')..'', sx/2-440/zoom/2 + 15/zoom, sy/2-460/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom)), nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center')
    dxDrawImage(sx/2-440/zoom/2, sy/2-460/zoom/2 + 64/zoom, 440/zoom, 2/zoom, 'data/images/line.png')

    local x = 0
    for i, v in pairs(items) do
        if i >= k and i <= n then
            dxDrawImage(sx/2-440/zoom/2 + 440/zoom/2 - 420/zoom/2, sy/2-460/zoom/2 + 75/zoom + x, 420/zoom, 60/zoom, 'data/images/list-bg.png')
            dxDrawText(v.name, sx/2-440/zoom/2 + 440/zoom/2 - 420/zoom/2 + 13/zoom, sy/2-460/zoom/2 + 75/zoom + x + 60/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'center')

            dxDrawImage(sx/2-440/zoom/2 + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 75/zoom + x + 60/zoom/2 - 30/zoom/2, 88/zoom, 30/zoom, 'data/images/button.png', 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-440/zoom/2 + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 75/zoom + x + 60/zoom/2 - 30/zoom/2, 88/zoom, 30/zoom) and 255 or 200)))
            dxDrawText(v.fnc(localPlayer), sx/2-440/zoom/2 + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom + 44/zoom, sy/2-460/zoom/2 + 75/zoom + x + 60/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

            x = x + 60/zoom + 4/zoom
        end
    end

    drawScrollbar(items, sx/2+440/zoom/2 - 6/zoom, sy/2-460/zoom/2 + 75/zoom, 2/zoom, 375/zoom, m, k, 255)
end

function wheelUp()
    if k > 1 then
        k = k - 1
        n = n - 1
    end
end

function wheelDown()
    if n < #items then
        k = k + 1
        n = n + 1
    end
end

function click(button, state)
    if button == 'left' and state == 'down' then
        local x = 0
        for i, v in pairs(items) do
            if i >= k and i <= n then
                if isMouseInPosition(sx/2-440/zoom/2 + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 75/zoom + x + 60/zoom/2 - 30/zoom/2, 88/zoom, 30/zoom) then
                    triggerServerEvent('since-factions-parking:tryGetWeapon', resourceRoot, i)
                    return
                end

                x = x + 60/zoom + 4/zoom
            end
        end
    end
end

-- if (getPlayerName(localPlayer) == 'xelvor') then
--     addEventHandler('onClientRender', root, render)
--     addEventHandler('onClientClick', root, click)

--     bindKey('mouse_wheel_down', 'down', wheelDown)
--     bindKey('mouse_wheel_up', 'down', wheelUp)
--     showCursor(true, false)
-- end

local toggled = false

addCommandHandler('kabura', function()
    if (not getElementData(localPlayer, 'player:faction') or getElementData(localPlayer, 'player:faction') ~= 'SAPD') then
        return
    end

    if (toggled) then
        removeEventHandler('onClientRender', root, render)
        removeEventHandler('onClientClick', root, click)
        unbindKey('mouse_wheel_down', 'down', wheelDown)
        unbindKey('mouse_wheel_up', 'down', wheelUp)
        showCursor(false)
        toggled = false
    else
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        bindKey('mouse_wheel_down', 'down', wheelDown)
        bindKey('mouse_wheel_up', 'down', wheelUp)
        showCursor(true, false)
        toggled = true
    end
end)