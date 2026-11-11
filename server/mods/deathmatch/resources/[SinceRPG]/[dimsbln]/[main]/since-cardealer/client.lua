  

local vehData = nil
local vehIntDim = nil
local theVehicle = nil
local alpha = 0

function renderUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 198/zoom, sy/2 - 123/zoom, 396/zoom, 247/zoom, mask)
	dxDrawImage(sx/2 - 198/zoom, sy/2 - 123/zoom, 396/zoom, 247/zoom, 'data/background.png')
	dxDrawText('Informacje o pojeździe', sx/2, sy/2 - 27/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')

	local engine = string.format("%.1f", vehData.engine)
	local engine = tonumber(engine)

	dxDrawText('Pojemność silnika: '..engine..' dm3\nPrzebieg: '..addCommas(vehData.mileage)..' km\nPojemność baku: '..vehData.tank..' dm3', sx/2, sy/2 - 27/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
	dxDrawText('Cena', sx/2 + 174/zoom, sy/2 - 89/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'right', 'bottom')
	dxDrawText('$ #ffffff'..addCommas(vehData.cost), sx/2 + 174/zoom, sy/2 - 89/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'right', 'top', false, false, false, true)
	dxDrawText('Pojazd', sx/2 - 175/zoom, sy/2 - 89/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'bottom')
	
	local vehicleName = vehData.sport and exports['since-vehiclenames']:getVehicleName(vehData.model)..' Sport' or exports['since-vehiclenames']:getVehicleName(vehData.model)
	dxDrawText(vehicleName, sx/2 - 175/zoom, sy/2 - 91/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'left', 'top')

	local isIn = isMouseInPosition(sx/2 - 121/zoom, sy/2 + 35/zoom, 119/zoom, 30/zoom)
	dxDrawImage(sx/2 - 121/zoom, sy/2 + 35/zoom, 119/zoom, 30/zoom, 'data/button_buy.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 225 or 255))
	dxDrawText('Zakup', sx/2 - 61.5/zoom, sy/2 + 50/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')

	local isIn = isMouseInPosition(sx/2 + 2/zoom, sy/2 + 35/zoom, 119/zoom, 30/zoom)
	dxDrawImage(sx/2 + 2/zoom, sy/2 + 35/zoom, 119/zoom, 30/zoom, 'data/button_test.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 225 or 255))
	dxDrawText('Jazda testowa', sx/2 + 61.5/zoom, sy/2 + 50/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')
	
	local isIn = isMouseInPosition(sx/2 - 121/zoom, sy/2 + 70/zoom, 242/zoom, 30/zoom)
	dxDrawImage(sx/2 - 121/zoom, sy/2 + 70/zoom, 242/zoom, 30/zoom, 'data/button_close.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 225 or 255))
	dxDrawText('Zamknij', sx/2, sy/2 + 85/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')
end

function onClick(btn, state)
	if btn == 'left' and state =='down' then
		if isMouseInPosition(sx/2 - 121/zoom, sy/2 + 70/zoom, 242/zoom, 30/zoom) then
			toggleUI(false)
		elseif isMouseInPosition(sx/2 + 2/zoom, sy/2 + 35/zoom, 119/zoom, 30/zoom) then
			triggerServerEvent('testVehicle', resourceRoot, vehData, vehIntDim, theVehicle)
			toggleUI(false)
		elseif isMouseInPosition(sx/2 - 121/zoom, sy/2 + 35/zoom, 119/zoom, 30/zoom) then
			triggerServerEvent('buyVehicle', resourceRoot, vehData, theVehicle)
			toggleUI(false)
		end
	end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
	showCursor(visible, false)

	if visible == false then vehData = nil end
end

function hitSphere(element, dim)
	if element ~= localPlayer then return end
	if not dim then return end

	local data = getElementData(source, "vehicle:dealer:data")
	local intdim = getElementData(source, "vehicle:dealer:intdim")
	local shapeVeh = getElementData(source, "vehicle:dealer:veh")
	if not data then return end

	vehData = data
	vehIntDim = intdim
	theVehicle = shapeVeh

	toggleUI(true)
end
addEventHandler("onClientColShapeHit", root, hitSphere)

function leaveSphere(element, dim)
	if element ~= localPlayer then return end

	vehData = nil
	vehIntDim = nil
	theVehicle = nil

	toggleUI(false)
end
addEventHandler("onClientColShapeLeave", root, leaveSphere)

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sxx, syy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sxx ), ( cy * syy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end
getResourceName(getThisResource(), true, 195038624); if true then return end