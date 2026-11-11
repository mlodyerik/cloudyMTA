local position = {1480.21, -1718.91, 13.53}

local marker = createMarker(position[1], position[2], position[3], "cylinder", 1.5, 255, 0, 0, 150)

setElementData(marker, "marker:title", "List do świętego Mikołaja")
setElementData(marker, "marker:desc", "Napisz list do mikolaja")

function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing( ) ) then
        return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local sx, sy = guiGetScreenSize()
local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1

local elements = {}

local editbox = dxCreateTexture("data/images/editbox.png")

function render()
    dxDrawImage(sx/2-329/zoom/2, sy/2-259/zoom/2, 329/zoom, 259/zoom, 'data/images/bg.png')
    dxDrawText('List do Mikołaja', sx/2, sy/2-259/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
    dxDrawText('Napisz list do świętego mikołaja, pamiętaj\nżeby go jakoś przekonać!', sx/2, sy/2-259/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom))/2, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top')
    
    dxDrawImage(sx/2-249/zoom/2, sy/2-44/zoom + 44/zoom + 10/zoom, 249/zoom, 44/zoom, 'data/images/button_buy.png', 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(sx/2-249/zoom/2, sy/2-44/zoom + 44/zoom + 10/zoom, 249/zoom, 44/zoom) and 200 or 255))
    dxDrawText('Wyślij!', sx/2, sy/2-44/zoom + 44/zoom + 10/zoom + 44/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

    dxDrawImage(sx/2-249/zoom/2, sy/2-44/zoom + 44/zoom + 10/zoom + 44/zoom + 6/zoom, 249/zoom, 44/zoom, 'data/images/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(sx/2-249/zoom/2, sy/2-44/zoom + 44/zoom + 10/zoom + 44/zoom + 6/zoom, 249/zoom, 44/zoom) and 200 or 255))
    dxDrawText('Anuluj', sx/2, sy/2-44/zoom + 44/zoom + 10/zoom + 44/zoom + 6/zoom + 44/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')
end


function click(button, state)
    if (button == 'left' and state == 'down') then
        if (isMouseInPosition(sx/2-249/zoom/2, sy/2-44/zoom + 44/zoom + 10/zoom, 249/zoom, 44/zoom)) then
            local text = exports['since-gui']:getEditboxText(elements['editbox'])

            if (string.len(text) < 10) then
                exports['since-notifications']:sendNotification('error', 'List musi zawierać przynajmniej 10 znaków')
                return
            end

            triggerServerEvent('since-list:send', resourceRoot, text)
        end

        if (isMouseInPosition(sx/2-249/zoom/2, sy/2-44/zoom + 44/zoom + 10/zoom + 44/zoom + 6/zoom, 249/zoom, 44/zoom)) then
            removeEventHandler('onClientRender', root, render)
            exports['since-gui']:destroyUIElement(elements['editbox'])
            showCursor(false)
            removeEventHandler('onClientClick', root, click)
        end
    end
end


addEventHandler('onClientMarkerHit', marker, function (player)
    if (player == localPlayer) then
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        showCursor(true, false)

        elements['editbox'] = exports['since-gui']:createEditbox('Treść listu..', sx/2-249/zoom/2, sy/2-44/zoom, 249/zoom, 44/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 12/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
            image = editbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = true,
            caretHeight = 18/zoom,
            maxChars = 400,
            textColor = {255, 255, 255, 200},
        })
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function ()
    if (elements['editbox']) then
        exports['since-gui']:destroyUIElement(elements['editbox'])
    end
end)