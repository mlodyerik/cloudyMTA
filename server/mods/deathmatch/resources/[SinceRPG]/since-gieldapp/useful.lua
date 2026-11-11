sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.8

uiElements = {

    textures = {}

}

function getMaxOffset(number, offset, max, rt)
    local maxOffset = 0
    if number > max then
        maxOffset = number * (offset) - rt
    else
        maxOffset = 1
    end
    return math.min(maxOffset, 11532/zoom)
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function isMouseInRender( x, y, width, height, rndData, rndID )
    if not rndData or not rndID then return end
    local scrollPos = exports['since-renders']:getScrollPosition(rndID)

    if ( not isCursorShowing( ) ) then
        return false
    end

    if not isMouseInPosition(rndData.x, rndData.y, rndData.w, rndData.h) then
        return false
    end

    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    local x, y = x + rndData.x, y + rndData.y - scrollPos
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function getCursorPositionInRender( x, y, width, height, rndData, rndID )
    if not rndData or not rndID then return end
    local scrollPos = exports['since-renders']:getScrollPosition(rndID)

    if ( not isCursorShowing( ) ) then
        return false
    end

    if not isMouseInPosition(rndData.x, rndData.y, rndData.w, rndData.h) then
        return false
    end

    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    local x, y = x + rndData.x, y + rndData.y - scrollPos
    
    return cx - x, cy - y
end