local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

Mandates = {}
Mandates.selected = false
Mandates.elements = {}
Mandates.textures = {
    ['editbox'] = dxCreateTexture('data/images/editbox.png', 'argb', false, 'clamp')
}

local k = 1
local n = 7
local m = 7

function destroyAllElements()
    for i,v in pairs(Mandates.elements) do
        if (v) then
            exports['since-gui']:destroyUIElement(v)
            v = nil
        end
    end
end

function splitText(text, width)
    local newText = ''
    local line = ''
    local linesHeight = 0

    for i=1, #text do
        local char = text:sub(i, i)
        line = line..char

        if (dxGetTextWidth(line, 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom)) > width) then
            newText = newText..line..'\n'
            line = ''
            linesHeight = linesHeight + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom))
        end
    end

    newText = newText..line
    return newText, linesHeight
end

function render()
    dxDrawImage(sx/2-496/zoom/2, sy/2-398/zoom/2, 496/zoom, 398/zoom, 'data/images/background.png')
    dxDrawText('Panel mandatów', sx/2-496/zoom/2 + 15/zoom, sy/2-398/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'center')
    dxDrawText('Tutaj wystawisz mandaty', sx/2-496/zoom/2 + 15/zoom, sy/2-398/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom)), nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center')
    dxDrawImage(sx/2-496/zoom/2, sy/2-398/zoom/2 + 60/zoom, 496/zoom, 2/zoom, "data/images/line.png")
    
    dxDrawImage(sx/2-496/zoom/2 + 496/zoom - 15/zoom - 15/zoom, sy/2-398/zoom/2 + 25/zoom, 15/zoom, 15/zoom, "data/images/close.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-496/zoom/2 + 496/zoom - 15/zoom - 15/zoom, sy/2-398/zoom/2 + 25/zoom, 15/zoom, 15/zoom) and 255 or 200)))

    local players = getPlayers()
    local x, y, z = getElementPosition(localPlayer)

    local offset = 0
    for i, v in pairs(players) do
        if i >= k and i <= n then
            local x2, y2, z2 = getElementPosition(v)
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            local name = getPlayerName(v).." ("..getElementData(v, "id")..")"
            local name = (#name > 10) and name:sub(1, 10)..'...' or name

            if (Mandates.selected and Mandates.selected == v) then
                dxDrawRectangle(sx/2-496/zoom/2 + 5/zoom, sy/2-398/zoom/2 + 65/zoom + offset, 142/zoom - 5/zoom, 45/zoom, tocolor(148, 255, 139, 25))
            end

            dxDrawImage(sx/2-496/zoom/2 + 5/zoom, sy/2-398/zoom/2 + 65/zoom + offset + 45/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom, exports['since-avatars']:getPlayerCircleAvatar(getElementData(v, 'player:sid')))
            dxDrawText(name, sx/2-496/zoom/2 + 5/zoom + 30/zoom + 5/zoom, sy/2-398/zoom/2 + 65/zoom + offset + 45/zoom/2 - 30/zoom/2 + 30/zoom/2 - 4/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center')
            dxDrawText(string.format('%.2f km', distance/1000), sx/2-496/zoom/2 + 5/zoom + 30/zoom + 5/zoom, sy/2-398/zoom/2 + 65/zoom + offset + 45/zoom/2 - 30/zoom/2 + 30/zoom/2 + 8/zoom, nil, nil, tocolor(180, 180, 180), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'center')
            
            offset = offset + 45/zoom + 1
        end
    end

    dxDrawScrollbar(players, sx/2-496/zoom/2 + 142/zoom, sy/2-398/zoom/2 + 65/zoom, 4/zoom, 322/zoom, m, k, 255)

    if (not Mandates.selected) then
        dxDrawText('Błąd', sx/2-496/zoom/2 + 147/zoom + 347/zoom/2, sy/2-398/zoom/2 + 62/zoom + 337/zoom/2 - dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom)), nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'center')
        dxDrawText('Wybierz kogoś z listy', sx/2-496/zoom/2 + 147/zoom + 347/zoom/2, sy/2-398/zoom/2 + 62/zoom + 337/zoom/2, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')
    else
        local x, y = sx/2-496/zoom/2 + 147/zoom, sy/2-398/zoom/2 + 62/zoom
        local padding = 10/zoom

        dxDrawImage(x, y + 45/zoom, 347/zoom, 2/zoom, "data/images/line.png")

        dxDrawText('Nadawanie mandatu', x + padding, y + padding + 10/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center')
        dxDrawText('Wypełnianie danych dotyczących mandatu.', x + padding, y + padding + 10/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) - 3/zoom, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'center')

        dxDrawText('Podsumowanie', x + padding, y + padding + 160/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center')
        dxDrawText('Podsumowanie twojego mandatu.', x + padding, y + padding + 160/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) - 3/zoom, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'center')

        local text, linesHeight = splitText(exports['since-gui']:getEditboxText(Mandates.elements[2]), 200/zoom)

        dxDrawText('Gracz #ffffff'..getPlayerName(Mandates.selected)..'#c8c8c8 otrzyma mandat w wysokości #ffffff'..getPlayerName(Mandates.selected)..'#c8c8c8\nz powodem: #ffffff'..text, x + padding, y + padding + 160/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) + 5/zoom, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true)

        dxDrawText('Opis sytuacji jest następujący', x + padding, y + padding + 160/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) + 40/zoom + linesHeight + 5/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center')

        local text2, linesHeight2 = splitText(exports['since-gui']:getEditboxText(Mandates.elements[3]), 320/zoom)

        dxDrawText(text2, x + padding, y + padding + 160/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) - 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom)) + 40/zoom + linesHeight + 15/zoom, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true)
        
        dxDrawImage(x + padding, y + 275/zoom + linesHeight + linesHeight2, 128/(zoom * 1.3), 32/(zoom * 1.3), 'data/images/button.png', 0, 0, 0, tocolor(46, 117, 111, (isMouseInPosition(x + padding, y + 275/zoom + linesHeight + linesHeight2, 128/(zoom * 1.3), 32/(zoom * 1.3)) and 255 or 150)))
        dxDrawText('Wystaw', x + padding + (128/(zoom * 1.3))/2, y + 275/zoom + linesHeight + linesHeight2 + (32/(zoom * 1.3))/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')

        dxDrawImage(x + padding + 128/(zoom * 1.3) + 5/zoom, y + 275/zoom + linesHeight + linesHeight2, 128/(zoom * 1.3), 32/(zoom * 1.3), 'data/images/button.png', 0, 0, 0, tocolor(255, 125, 125, (isMouseInPosition(x + padding + 128/(zoom * 1.3) + 5/zoom, y + 275/zoom + linesHeight + linesHeight2, 128/(zoom * 1.3), 32/(zoom * 1.3)) and 255 or 150)))
        dxDrawText('Anuluj', x + padding + 128/(zoom * 1.3) + 5/zoom + (128/(zoom * 1.3))/2, y + 275/zoom + linesHeight + linesHeight2 + (32/(zoom * 1.3))/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
    end
end

function click(button, state)
    if (button == 'left' and state == 'down') then
        if (isMouseInPosition(sx/2-496/zoom/2 + 496/zoom - 15/zoom - 15/zoom, sy/2-398/zoom/2 + 25/zoom, 15/zoom, 15/zoom)) then
            destroyAllElements()
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, click)
            unbindKey('mouse_wheel_down', 'down', scrollDown)
            unbindKey('mouse_wheel_up', 'down', scrollUp)
            showCursor(false)
        end

        if (Mandates.selected) then
            local x, y = sx/2-496/zoom/2 + 147/zoom, sy/2-398/zoom/2 + 62/zoom
            local padding = 10/zoom

            local text, linesHeight = splitText(exports['since-gui']:getEditboxText(Mandates.elements[2]), 200/zoom)
            local text2, linesHeight2 = splitText(exports['since-gui']:getEditboxText(Mandates.elements[3]), 320/zoom)

            if (isMouseInPosition(x + padding, y + 275/zoom + linesHeight + linesHeight2, 128/(zoom * 1.3), 32/(zoom * 1.3))) then
                triggerServerEvent('since-mandates:give', resourceRoot, Mandates.selected, exports['since-gui']:getEditboxText(Mandates.elements[1]), exports['since-gui']:getEditboxText(Mandates.elements[2]), exports['since-gui']:getEditboxText(Mandates.elements[3]))
            end

            if (isMouseInPosition(x + padding + 128/(zoom * 1.3) + 5/zoom, y + 275/zoom + linesHeight + linesHeight2, 128/(zoom * 1.3), 32/(zoom * 1.3))) then
                Mandates.selected = false
                destroyAllElements()
            end
        end

        local players = getPlayers()
        local x, y, z = getElementPosition(localPlayer)

        local offset = 0
        for i, v in pairs(players) do
            if i >= k and i <= n then
                if (isMouseInPosition(sx/2-496/zoom/2 + 5/zoom, sy/2-398/zoom/2 + 65/zoom + offset, 142/zoom - 5/zoom, 45/zoom)) then
                    Mandates.selected = v
                    destroyAllElements()

                    Mandates.elements[1] = exports['since-gui']:createEditbox('Kwota mandatu', sx/2-496/zoom/2 + 147/zoom + 10/zoom, sy/2-398/zoom/2 + 62/zoom + 45/zoom, 330/zoom, 32/zoom, {155, 155, 155}, {
                        alignX = 'left',
                        paddingX = 10/zoom,
                        caretColor = {255, 255, 255, 100},
                        caretWidth = 1,
                        font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                        image = Mandates.textures['editbox'],
                        placeholderColor = {155, 155, 155},
                        specialCharacters = '.*[_].*',
                        passworded = false,
                        caretHeight = 18/zoom,
                        textColor = {255, 255, 255, 200},
                    })

                    Mandates.elements[2] = exports['since-gui']:createEditbox('Powód', sx/2-496/zoom/2 + 147/zoom + 10/zoom, sy/2-398/zoom/2 + 62/zoom + 45/zoom + 32/zoom + 5/zoom, 330/zoom, 32/zoom, {155, 155, 155}, {
                        alignX = 'left',
                        paddingX = 10/zoom,
                        caretColor = {255, 255, 255, 100},
                        caretWidth = 1,
                        font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                        image = Mandates.textures['editbox'],
                        placeholderColor = {155, 155, 155},
                        specialCharacters = '.*[_].*',
                        passworded = false,
                        caretHeight = 18/zoom,
                        textColor = {255, 255, 255, 200},
                        maxChars = 9999
                    })

                    Mandates.elements[3] = exports['since-gui']:createEditbox('Opis', sx/2-496/zoom/2 + 147/zoom + 10/zoom, sy/2-398/zoom/2 + 62/zoom + 45/zoom + 32/zoom + 5/zoom + 32/zoom + 5/zoom, 330/zoom, 32/zoom, {155, 155, 155}, {
                        alignX = 'left',
                        paddingX = 10/zoom,
                        caretColor = {255, 255, 255, 100},
                        caretWidth = 1,
                        font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                        image = Mandates.textures['editbox'],
                        placeholderColor = {155, 155, 155},
                        specialCharacters = '.*[_].*',
                        passworded = false,
                        caretHeight = 18/zoom,
                        textColor = {255, 255, 255, 200},
                        maxChars = 9999
                    })
                    break
                end

                offset = offset + 45/zoom + 1
            end
        end
    end
end

function scrollUp()
    if (k > 1) then
        k = k - 1
        n = n - 1
    end
end

function scrollDown()
    if (n < #getPlayers()) then
        k = k + 1
        n = n + 1
    end
end

local state = false

bindKey('f6', 'down', function()
    if (getElementData(localPlayer, 'player:faction') and getElementData(localPlayer, 'player:faction') == "SAPD") then
        state = not state

        if (state) then
            addEventHandler('onClientRender', root, render)
            addEventHandler('onClientClick', root, click)

            bindKey('mouse_wheel_down', 'down', scrollDown)
            bindKey('mouse_wheel_up', 'down', scrollUp)
            showCursor(true)
            Mandates.selected = false
        else
            destroyAllElements()
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, click)
            unbindKey('mouse_wheel_down', 'down', scrollDown)
            unbindKey('mouse_wheel_up', 'down', scrollUp)
            showCursor(false)
        end
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    destroyAllElements()
end)