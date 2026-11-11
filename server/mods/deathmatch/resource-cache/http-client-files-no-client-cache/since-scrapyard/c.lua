  

local sx, sy = guiGetScreenSize()
local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1 

local marker = createMarker(-1870.66, -1684.08, 21.75 - 0.95, "cylinder", 3, 125, 255, 125, 55)
setElementData(marker, 'marker:title', 'Złomowisko')
setElementData(marker, 'marker:desc', 'Zezłomuj swój pojazd')
setElementData(marker, 'marker:icon', 'salon')

local data = {
    ["fonts"] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 13/zoom),
    },
    ['textures'] = {

        mask = dxCreateTexture('files/images/mask.png'),

    }
}

function render()
    if not getPedOccupiedVehicle(localPlayer) then
        return
    end

    exports['since-blur']:dxDrawBlur(sx/2 - 260/zoom, sy/2 - 168/zoom, 520/zoom, 336/zoom, data.textures.mask)
    dxDrawImage(sx/2 - 260/zoom, sy/2 - 168/zoom, 520/zoom, 336/zoom, 'files/images/bg.png')
	dxDrawText('Zezłomuj swój pojazd', sx/2 - 1/zoom, sy/2 - 131/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
	dxDrawText('Złomowisko', sx/2, sy/2 - 129/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')

	dxDrawText('Informacje dot. złomowania', sx/2 - 1/zoom, sy/2 - 43/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
	dxDrawText('Za zezłomowanie pojazdu otrzymasz #60FF63$#ffffff '..addCommas(2500), sx/2 - 1/zoom, sy/2 - 43/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)
    
    local mass = getVehicleHandlingProperty(getPedOccupiedVehicle(localPlayer), 'mass')
    dxDrawText('Informacje o pojeździe', sx/2 - 1/zoom, sy/2 + 18/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
    dxDrawText('Waga pojazdu wynosi #ffb947'..string.format("%.2f", mass)..' kg', sx/2 - 1/zoom, sy/2 + 18/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)
    
    local isIn = isMouseInPosition(sx/2 - 127/zoom, sy/2 + 79/zoom, 254/zoom, 50/zoom)
	dxDrawImage(sx/2 - 127/zoom, sy/2 + 79/zoom, 254/zoom, 50/zoom, 'files/images/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
	dxDrawText('Złomuj pojazd', sx/2, sy/2 + 104/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'center')

	dxDrawImage(sx/2 - 184/zoom, sy/2 - 100/zoom, 368/zoom, 2/zoom, 'files/images/line.png')
end

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then -- Make sure there's a valid vehicle and a property string
        local handlingTable = getVehicleHandling ( element ) -- Get the handling as table and save as handlingTable
        local value = handlingTable[property] -- Get the value from the table
        
        if value then -- If there's a value (valid property)
            return value -- Return it
        end
    end
    
    return false -- Not an element, not a vehicle or no valid property string. Return failure
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

function click(btn,state)
    if (btn=="left" and state=="up") then
        if isEventHandlerAdded("onClientRender", root, render) then
            if isMouseInPosition(sx/2 - 127/zoom, sy/2 + 79/zoom, 254/zoom, 50/zoom) then
                local veh = getPedOccupiedVehicle(localPlayer)
                if veh then
                    if (getElementData(veh, "vehicle:id") and (getElementData(veh, "vehicle:owner") == getElementData(localPlayer, "player:sid"))) then
                        triggerServerEvent("zlomowisko.S", resourceRoot, getPedOccupiedVehicle(localPlayer))
                        turnGui(false)
                    end
                end
            end
        end
   end
end

function turnGui(state)
    if state then
        if (not isEventHandlerAdded("onClientRender", root, render)) then
            addEventHandler("onClientRender", root, render)
        end
        if (not isEventHandlerAdded("onClientClick", root, click)) then
            addEventHandler("onClientClick", root, click)
            showCursor(true, false)
        end
        setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
        setTimer(function()
            setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
        end, 50, 1)
    else
        if isEventHandlerAdded("onClientRender", root, render) then
            removeEventHandler("onClientRender", root, render)
        end
        if isEventHandlerAdded("onClientClick", root, click) then
            removeEventHandler("onClientClick", root, click)
            showCursor(false)
        end

    end
end

addEventHandler("onClientMarkerHit", resourceRoot, function(el)
    if (el ~= localPlayer) then
        return
    end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and (getElementData(veh, "vehicle:id")) then
        if (getElementData(veh, "vehicle:owner") == getElementData(localPlayer, "player:sid")) then
            turnGui(true)
        end
    end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(el)
    if (el ~= localPlayer) then
        return
    end
    turnGui(false)
end)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
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

function przecinek(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') 
			
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

getResourceName(getThisResource(), true, 706592245); if true then return end