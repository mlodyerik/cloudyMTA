sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sxx, syy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sxx ), ( cy * syy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function dxDrawRoundedRectangle(x, y, w, h, r, color, postGUI, subPixelPositioning)
    local r = type(r) == 'table' and r or {r, r, r, r}

    local th = math.max(r[1], r[2])
    dxDrawRectangle(x + r[1], y, w - r[1] - r[2], th, color, postGUI, subPixelPositioning)
    dxDrawCircle(x+r[1], y+r[1], r[1], 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+w-r[2], y+r[2], r[2], 270, 360, color, color, 16, 1, postGUI)
    if r[1] < r[2] then
        dxDrawRectangle(x, y + r[1], r[1], r[2]-r[1], color, postGUI, subPixelPositioning)
    else
        dxDrawRectangle(x + w - r[2], y + r[2], r[2], r[1]-r[2], color, postGUI, subPixelPositioning)
    end
    
    local bh = math.max(r[3], r[4])
    dxDrawRectangle(x + r[3], y + h, w - r[3] - r[4], -bh, color, postGUI, subPixelPositioning)
    dxDrawCircle(x+r[3], y+h-r[3], r[3], 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle(x+w-r[4], y+h-r[4], r[4], 0, 90, color, color, 16, 1, postGUI)
    if r[3] < r[4] then
        dxDrawRectangle(x, y + h - r[4], r[3], r[4]-r[3], color, postGUI, subPixelPositioning)
    else
        dxDrawRectangle(x + w - r[4], y + h - r[3], r[4], r[3]-r[4], color, postGUI, subPixelPositioning)
    end

    dxDrawRectangle(x, y + th, w, h - th - bh, color, postGUI, subPixelPositioning)
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end