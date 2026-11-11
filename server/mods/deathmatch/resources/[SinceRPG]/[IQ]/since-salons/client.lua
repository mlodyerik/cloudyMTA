local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

local main = {
    ['textures'] = {
        ['bg'] = dxCreateTexture('data/images/bg.png', 'argb', false, 'clamp'),
        ['info_bg'] = dxCreateTexture('data/images/info_bg.png', 'argb', false, 'clamp'),
        ['arrow_left'] = dxCreateTexture('data/images/arrow_left.png', 'argb', false, 'clamp'),
        ['arrow_left_active'] = dxCreateTexture('data/images/arrow_left_active.png', 'argb', false, 'clamp'),
        ['arrow_right'] = dxCreateTexture('data/images/arrow_right.png', 'argb', false, 'clamp'),
        ['arrow_right_active'] = dxCreateTexture('data/images/arrow_right_active.png', 'argb', false, 'clamp'),
        ['button'] = dxCreateTexture('data/images/button.png', 'argb', false, 'clamp'),
        ['button_hovered'] = dxCreateTexture('data/images/button_hovered.png', 'argb', false, 'clamp'),
    },
    ['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 13/zoom),
        [3] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
        [4] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
    },
    ['page'] = 1,
    ['pages'] = {
        {
            options = {
                {
                    text = "Przebieg",
                    value = function (veh)
                        return addCommas(getElementData(veh, 'salon:data').mileage)..' km'
                    end
                },
                {
                    text = "Rodzaj silnika",
                    value = function (veh)
                        return getElementData(veh, 'salon:data').engine
                    end
                },
                {
                    text = "Napęd",
                    value = function (veh)
                        return 'AWD'
                    end
                },
                {
                    text = "Wariant",
                    value = function (veh)
                        return 'Sport +'
                    end
                }
            }
        },
        {
            options = {}
        }
    },
    ['alpha'] = 255,
    ['animation'] = false
}

local button1, button2, button3 = 0, 0, 0
local button1RGB, button2RGB, button3RGB = {200, 200, 200}, {200, 200, 200}, {200, 200, 200}
local leftArrow = 0
local rightArrow = 0

addEventHandler('onClientRender', root, function ()
    local veh = getNearestVehicle()
    if (veh) then
        local x, y, z = getElementPosition(veh)
        dxDrawImage(sx/2-520/zoom/2, sy - 225/zoom - 30/zoom, 520/zoom, 225/zoom, main['textures']['bg'])
        dxDrawImage(sx/2-489/zoom/2, sy - 150/zoom - 30/zoom, 489/zoom, 50/zoom, main['textures']['info_bg'])
        local offset = 0
        for i,v in pairs(main['pages'][main['page']].options) do
            offset = offset + 100/zoom
            dxDrawText(v.text, sx/2-489/zoom/2 + offset, sy - 150/zoom - 30/zoom + 50/zoom/2 - dxGetFontHeight(1, main['fonts'][4])/2, nil, nil, tocolor(85, 189, 83, main['alpha']), 1, main['fonts'][4], 'center', 'center')
            dxDrawText(v.value(veh), sx/2-489/zoom/2 + offset, sy - 150/zoom - 30/zoom + 50/zoom/2 - dxGetFontHeight(1, main['fonts'][4])/2 + dxGetFontHeight(1, main['fonts'][4]), nil, nil, tocolor(238, 242, 239, main['alpha']), 1, main['fonts'][5], 'center', 'center')
        end
        dxDrawImage(sx/2-489/zoom/2 + 40/zoom/3.5, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom, main['textures']['arrow_left'])
        dxDrawImage(sx/2-489/zoom/2 + 40/zoom/3.5, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom, main['textures']['arrow_left_active'], 0, 0, 0, tocolor(255, 255, 255, leftArrow))
        if (isMouseInPosition(sx/2-489/zoom/2 + 40/zoom/3.5, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom) and main['page'] ~= 1) then
            animate(leftArrow, 255, 'InOutQuad', 70, function (c)
                leftArrow = c
            end)
        else
            if (leftArrow > 0) then
                animate(leftArrow, 0, 'InOutQuad', 70, function (c)
                    leftArrow = c
                end)
            end
        end
        dxDrawImage(sx/2+489/zoom/2 + 40/zoom/3.5 - 60/zoom, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom, main['textures']['arrow_right'])
        dxDrawImage(sx/2+489/zoom/2 + 40/zoom/3.5 - 60/zoom, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom, main['textures']['arrow_right_active'], 0, 0, 0, tocolor(255, 255, 255, rightArrow))
        if (isMouseInPosition(sx/2+489/zoom/2 + 40/zoom/3.5 - 60/zoom, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom) and main['page'] ~= #main['pages']) then
            animate(rightArrow, 255, 'InOutQuad', 70, function (c)
                rightArrow = c
            end)
        else
            if (rightArrow > 0) then
                animate(rightArrow, 0, 'InOutQuad', 70, function (c)
                    rightArrow = c
                end)
            end
        end
        dxDrawText('Salon samochodowy', sx/2-489/zoom/2, sy - 225/zoom - 30/zoom + dxGetFontHeight(1, main['fonts'][1]) + 4/zoom, nil, nil, tocolor(238, 242, 239), 1, main['fonts'][1], 'left', 'center')
        dxDrawText(''..getZoneName(x, y, z, false)..', '..getZoneName(x, y, z, true)..'', sx/2-489/zoom/2, sy - 225/zoom - 30/zoom + 4/zoom + dxGetFontHeight(1, main['fonts'][1]) + dxGetFontHeight(1, main['fonts'][2]), nil, nil, tocolor(182, 182, 182), 1, main['fonts'][2], 'left', 'center')
        dxDrawText('Dostępna ilość', sx/2-489/zoom/2 + 489/zoom, sy - 225/zoom - 30/zoom + dxGetFontHeight(1, main['fonts'][1]) + 4/zoom, nil, nil, tocolor(238, 242, 239), 1, main['fonts'][1], 'right', 'center')
        dxDrawText(getElementData(veh, 'salon:data').count, sx/2-489/zoom/2 + 489/zoom, sy - 225/zoom - 30/zoom + 4/zoom + dxGetFontHeight(1, main['fonts'][1]) + dxGetFontHeight(1, main['fonts'][2]), nil, nil, tocolor(182, 182, 182), 1, main['fonts'][2], 'right', 'center')
        dxDrawText('Cena jazdy próbnej', sx/2-489/zoom/2, sy - 108/zoom, nil, nil, white, 1, main['fonts'][3], 'left', 'center')
        dxDrawText('1,000 #46BC52$', sx/2-489/zoom/2, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]), nil, nil, white, 1, main['fonts'][4], 'left', 'center', false, false, false, true)
        dxDrawImage(sx/2-489/zoom/2, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom, main['textures']['button'])
        dxDrawImage(sx/2-489/zoom/2, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom, main['textures']['button_hovered'], 0, 0, 0, tocolor(255, 255, 255, button1))
        dxDrawText('Zamknij okno', sx/2-489/zoom/2 + 133/zoom/2, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom + 32/zoom/2, nil, nil, tocolor(unpack(button1RGB)), 1, main['fonts'][5], 'center', 'center')

        dxDrawText('Cena zakupu', sx/2-489/zoom/2 + 489/zoom, sy - 108/zoom, nil, nil, white, 1, main['fonts'][3], 'right', 'center')
        dxDrawText(''..addCommas(getElementData(veh, 'salon:data').price)..' #46BC52$', sx/2-489/zoom/2 + 489/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]), nil, nil, white, 1, main['fonts'][4], 'right', 'center', false, false, false, true)

        dxDrawImage(sx/2-489/zoom/2 + 489/zoom - 133/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom, main['textures']['button'])
        dxDrawImage(sx/2-489/zoom/2 + 489/zoom - 133/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom, main['textures']['button_hovered'], 0, 0, 0, tocolor(255, 255, 255, button2))
        dxDrawText('Kup pojazd', sx/2-489/zoom/2 + 489/zoom - 133/zoom + 133/zoom/2, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom + 32/zoom/2, nil, nil, tocolor(unpack(button2RGB)), 1, main['fonts'][5], 'center', 'center')

        dxDrawImage(sx/2-489/zoom/2 + 489/zoom - 133/zoom - 133/zoom - 5/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom, main['textures']['button'])
        dxDrawImage(sx/2-489/zoom/2 + 489/zoom - 133/zoom - 133/zoom - 5/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom, main['textures']['button_hovered'], 0, 0, 0, tocolor(255, 255, 255, button3))
        dxDrawText('Jazda próbna', sx/2-489/zoom/2 + 489/zoom - 133/zoom - 133/zoom - 5/zoom + 133/zoom/2, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom + 32/zoom/2, nil, nil, tocolor(unpack(button3RGB)), 1, main['fonts'][5], 'center', 'center')

        if (isMouseInPosition(sx/2-520/zoom/2 + dxGetFontHeight(1, main['fonts'][1]), sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom)) then
            animate(button1, 255, 'InOutQuad', 70, function (c)
                button1 = c
            end)

            animate(button1RGB[1], 255, 'InOutQuad', 70, function (c)
                button1RGB[1] = c
            end)
            animate(button1RGB[2], 255, 'InOutQuad', 70, function (c)
                button1RGB[2] = c
            end)
            animate(button1RGB[3], 255, 'InOutQuad', 70, function (c)
                button1RGB[3] = c
            end)
        else
            if (button1 > 0) then
                animate(button1, 0, 'InOutQuad', 70, function (c)
                    button1 = c
                end)
                animate(button1RGB[1], 200, 'InOutQuad', 70, function (c)
                    button1RGB[1] = c
                end)
                animate(button1RGB[2], 200, 'InOutQuad', 70, function (c)
                    button1RGB[2] = c
                end)
                animate(button1RGB[3], 200, 'InOutQuad', 70, function (c)
                    button1RGB[3] = c
                end)
            end
        end

        if (isMouseInPosition(sx/2-489/zoom/2 + 489/zoom - 133/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom)) then
            animate(button2, 255, 'InOutQuad', 70, function (c)
                button2 = c
            end)
            animate(button2RGB[1], 255, 'InOutQuad', 70, function (c)
                button2RGB[1] = c
            end)
            animate(button2RGB[2], 255, 'InOutQuad', 70, function (c)
                button2RGB[2] = c
            end)
            animate(button2RGB[3], 255, 'InOutQuad', 70, function (c)
                button2RGB[3] = c
            end)
        else
            if (button2 > 0) then
                animate(button2, 0, 'InOutQuad', 70, function (c)
                    button2 = c
                end)
                animate(button2RGB[1], 200, 'InOutQuad', 70, function (c)
                    button2RGB[1] = c
                end)
                animate(button2RGB[2], 200, 'InOutQuad', 70, function (c)
                    button2RGB[2] = c
                end)
                animate(button2RGB[3], 200, 'InOutQuad', 70, function (c)
                    button2RGB[3] = c
                end)
            end
        end

        if (isMouseInPosition(sx/2-489/zoom/2 + 489/zoom - 133/zoom - 133/zoom - 5/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom)) then
            animate(button3, 255, 'InOutQuad', 70, function (c)
                button3 = c
            end)
            animate(button3RGB[1], 255, 'InOutQuad', 70, function (c)
                button3RGB[1] = c
            end)
            animate(button3RGB[2], 255, 'InOutQuad', 70, function (c)
                button3RGB[2] = c
            end)
            animate(button3RGB[3], 255, 'InOutQuad', 70, function (c)
                button3RGB[3] = c
            end)
        else
            if (button3 > 0) then
                animate(button3, 0, 'InOutQuad', 70, function (c)
                    button3 = c
                end)
                animate(button3RGB[1], 200, 'InOutQuad', 70, function (c)
                    button3RGB[1] = c
                end)
                animate(button3RGB[2], 200, 'InOutQuad', 70, function (c)
                    button3RGB[2] = c
                end)
                animate(button3RGB[3], 200, 'InOutQuad', 70, function (c)
                    button3RGB[3] = c
                end)
            end
        end
    end
end)

addEventHandler('onClientClick', root, function (btn, state)
    if (btn == 'left' and state == 'down' and not main['animation'] and getNearestVehicle()) then
        if (isMouseInPosition(sx/2+489/zoom/2 + 40/zoom/3.5 - 60/zoom, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom)) then
            if (main['page'] ~= #main['pages']) then
                main['animation'] = true
                animate(main['alpha'], 0, 'InOutQuad', 300, function (c)
                    main['alpha'] = c
                end, function ()
                    main['page'] = main['page'] + 1
                    animate(main['alpha'], 255, 'InOutQuad', 300, function (c)
                        main['alpha'] = c
                    end, function ()
                        main['animation'] = false
                    end)
                end)
            end
        elseif (isMouseInPosition(sx/2-489/zoom/2 + 40/zoom/3.5, sy - 150/zoom - 30/zoom + 50/zoom/2 - 40/zoom/2, 40/zoom, 40/zoom)) then
            if (main['page'] ~= 1) then
                main['animation'] = true
                animate(main['alpha'], 0, 'InOutQuad', 300, function (c)
                    main['alpha'] = c
                end, function ()
                    main['page'] = main['page'] - 1
                    animate(main['alpha'], 255, 'InOutQuad', 300, function (c)
                        main['alpha'] = c
                    end, function ()
                        main['animation'] = false
                    end)
                end)
            end
        elseif (isMouseInPosition(sx/2-489/zoom/2 + 489/zoom - 133/zoom, sy - 108/zoom + dxGetFontHeight(1, main['fonts'][3]) + dxGetFontHeight(1, main['fonts'][3]) - 2/zoom, 133/zoom, 29/zoom)) then
            triggerServerEvent('tryBuyVehicle', localPlayer, localPlayer, getElementData(getNearestVehicle(), 'salon:data').id)
        end
    end
end)