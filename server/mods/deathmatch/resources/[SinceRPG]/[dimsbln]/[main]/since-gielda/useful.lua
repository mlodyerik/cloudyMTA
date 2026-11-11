sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

players = {}

data = {

    tick = getTickCount(),
    actualWindow = nil,
    selectedPlayer = nil,
    seletedVehicle = nil,
    offerData = {},
    uiElements = {},
    vehicles = {},


}

textures = {

    maskChoose = dxCreateTexture('data/choose/mask.png'),
    maskCars = dxCreateTexture('data/cars/mask.png'),
    maskSelling = dxCreateTexture('data/selling/mask.png'),
    maskOffer = dxCreateTexture('data/offer/mask.png'),
    iconMoney = dxCreateTexture('data/selling/money.png'),
    editbox = dxCreateTexture('data/selling/editbox.png'),
	checkbox = dxCreateTexture('data/cars/check.png'),
	checkbox_active = dxCreateTexture('data/cars/check_active.png'),

}

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sxx, syy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sxx ), ( cy * syy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function getShapePlayers(shape)
    local players = {}
    
    for i, v in ipairs(getElementsWithinColShape(shape, 'player')) do
        if v ~= localPlayer then
            table.insert(players, v)
        end
    end

    return players
end

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRectangle(x, y, w, height, tocolor(148, 255, 139,alpha*0.2))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 0 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end
		
        dxDrawRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), tocolor(148, 255, 139, alpha))
    else
        dxDrawRectangle(x, y, w, height, tocolor(148, 255, 139,alpha))
	end
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

function getRGColorFromPercentage(percentage)
	if not percentage or
		percentage and type(percentage) ~= "number" or
		percentage > 100 or percentage < 0 then
		outputDebugString( "Invalid argument @ 'getRGColorFromPercentage'", 2 )
		return false
	end

	if percentage > 50 then
		local temp = 100 - percentage
		return temp*5.1, 255
	elseif percentage == 50 then
		return 255, 255
	end
	
	return 255, percentage*5.1
end

function RGBToHex(red, green, blue, alpha)
    local red, green, blue, alpha = tonumber(red), tonumber(green), tonumber(blue), tonumber(alpha)
	
	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end
getResourceName(getThisResource(), true, 709239093); if true then return end