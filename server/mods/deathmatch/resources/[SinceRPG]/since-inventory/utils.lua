  

sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 1.2
bold = dxCreateFont('data/Inter-Bold.ttf', 17/zoom)
regular = dxCreateFont('data/Inter-Medium.ttf', 17/zoom)
regular2 = dxCreateFont('data/Inter-Medium.ttf', 14/zoom)
regular3 = dxCreateFont('data/Inter-Medium.ttf', 13/zoom)
regular4 = exports['since-fonts']:getFont('Inter-Medium', 11/zoom)
regular5 = dxCreateFont('data/Inter-Medium.ttf', 15/zoom)
bold = dxCreateFont('data/Inter-Bold.ttf', 14/zoom)
bold2 = dxCreateFont('data/Inter-Bold.ttf', 15/zoom)

maskTex = dxCreateTexture('data/mask.png')

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function drawScrollbar(x, y, height, max, visibleCount, pos)
    dxDrawRectangle(x, y, 4, height, tocolor(46, 117, 111, 55))

	local scrollHeight = visibleCount / max
	local progress = pos / (max - visibleCount)
	if scrollHeight > 1 then return end
	if scrollHeight ~= scrollHeight then return end
	if progress ~= progress then return end
	dxDrawRectangle(x, y + (height * (1-scrollHeight)) * progress, 4, height * scrollHeight, tocolor(46, 117, 111, 200))
end

function drawButton(text, x, y, w, h, font, color, colorInactive, textColor)
    local inside = isMouseInPosition(x, y, w, h)
    --dxDrawImage(x, y, w, h, 'data/button.png', 0, 0, 0, inside and color or colorInactive)
    dxDrawRoundedRectangle(x, y, w, h, 8/zoom, inside and color or colorInactive)
    dxDrawText(text, x + w/2, y + h/2, nil, nil, tocolor(255, 255, 255, inside and 175 or 225), 1, font, 'center', 'center')
end

function rgbToHex(r, g, b)
    -- Ensure the RGB values are within the valid range (0-255)
    r, g, b = math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b))
    
    -- Convert each component to a two-digit hexadecimal string
    local hexString = string.format("#%02X%02X%02X", r, g, b)
    return hexString
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 32, 1, postGUI, 1)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 32, 1, postGUI, 1)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 32, 1, postGUI, 1)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 32, 1, postGUI, 1)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end
getResourceName(getThisResource(), true, 987591654); if true then return end