local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local count = 0

function render()
    dxDrawImage(sx/2-573/zoom/2, sy/2-399/zoom/2, 573/zoom, 399/zoom, 'data/images/bg.png')
    dxDrawText('Loteria na samochód GALAXY', sx/2, sy/2-399/zoom/2 + 30/zoom, nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Bold', 20/zoom), 'center', 'center')
    dxDrawText('Ilość zakupionych losów: #68D65E'..count, sx/2, sy/2-399/zoom/2 + 30/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 20/zoom)) - 7/zoom, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 15/zoom), 'center', 'center', false, false, false, true)
    dxDrawText('Większa ilość losów = większe szanse', sx/2, sy/2-399/zoom/2 + 30/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 20/zoom)) - 5/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 15/zoom)) - 7/zoom, nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center', false, false, false, true)
    dxDrawImage(sx/2-573/zoom/2, sy/2-399/zoom/2 + 100/zoom, 573/zoom, 2/zoom, 'data/images/line.png')

    dxDrawImage(sx/2-252/zoom/2, sy/2-236/zoom/2 + 35/zoom, 252/zoom, 236/zoom, 'data/images/item.png')
    dxDrawText('LOS NA LOTERIE', sx/2, sy/2-236/zoom/2 + 170/zoom + 5/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
    dxDrawText('$ 1.000.000.000', sx/2, sy/2-236/zoom/2 + 170/zoom + 5/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)), nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

    dxDrawImage(sx/2-148/zoom/2, sy/2-236/zoom/2 + 210/zoom + 5/zoom, 148/zoom, 29/zoom, 'data/images/button.png', 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-148/zoom/2, sy/2-236/zoom/2 + 210/zoom + 5/zoom, 148/zoom, 29/zoom) and 255 or 150)))
    dxDrawText('Zakup', sx/2, sy/2-236/zoom/2 + 210/zoom + 5/zoom + 29/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')
end

function click(button, state)
    if (button == 'left' and state == 'down') then
        if (isMouseInPosition(sx/2-148/zoom/2, sy/2-236/zoom/2 + 210/zoom + 5/zoom, 148/zoom, 29/zoom)) then
            triggerServerEvent('since-lottery:buy', resourceRoot)
        end
    end
end

addEvent('since-lottery:show', true)
addEventHandler('since-lottery:show', resourceRoot, function(c)
    count = c
    addEventHandler('onClientRender', root, render)
    addEventHandler('onClientClick', root, click)
    showCursor(true, false)
end)

addEvent('since-lottery:hide', true)
addEventHandler('since-lottery:hide', resourceRoot, function()
    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientClick', root, click)
    showCursor(false)
end)