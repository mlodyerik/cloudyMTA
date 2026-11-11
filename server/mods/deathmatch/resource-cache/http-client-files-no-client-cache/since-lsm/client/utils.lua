function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function getDistanceFromPosition(x, y, z)
	local x1, y2, z3 = getElementPosition(localPlayer)
	return getDistanceBetweenPoints3D(x, y, z, x1, y2, z3)
end

function math.round(number, decimals, method)
	decimals = decimals or 0
	local factor = 10 ^ decimals
	if (method == "ceil" or method == "floor") then
		return math[method](number * factor) / factor
	else
		return tonumber(("%."..decimals.."f"):format(number))
	end
end