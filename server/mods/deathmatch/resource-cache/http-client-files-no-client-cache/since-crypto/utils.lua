sx,sy = guiGetScreenSize()
zoom = (sx < 2048 and math.min(2.2, 2048/sx) or 1)



markers = {}
for i,v in pairs(markerPositions) do
    markers[i] = createMarker(v[1], v[2], v[3], 'cylinder', 2, 55, 255, 55, 100)
    setElementData(markers[i], 'cryptoMarker', i)
    addEventHandler('onClientMarkerHit', markers[i], function(hitElement, md)
        if hitElement == localPlayer and md and not isPedInVehicle(localPlayer) then
            local info = getElementData(source, 'cryptoMarker')
            if info == 'enter' then
                local jobStats = getElementData(localPlayer, 'player:jobStats')
                if not jobStats['crypto'] then
                    jobStats['crypto'] = {}
                end
                if jobStats['crypto']['bought'] then
                    turnPanel(true)
                else
                    turnBuyPanel(true)
                end
            end
        end
    end)
end

secoundPages = {'Karty graficzne', 'Zasilacze', 'Boosty'}

function createTextures(tbl, info)
    local data = {}
    for i,v in ipairs(tbl) do
        if fileExists(info and 'files/images/'..info..'/'..v..'.png' or 'files/images/'..v..'.png') then
            data[v] = dxCreateTexture(info and 'files/images/'..info..'/'..v..'.png' or 'files/images/'..v..'.png')
        end
    end
    return data
end

function destroyTextures(tbl)
    for i,v in pairs(tbl) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    return nil
end

function loadFonts()
    return {
        [1] = exports['since-fonts']:getFont("Inter-Bold", 19/zoom),
        [2] = exports['since-fonts']:getFont("Inter-Medium", 15/zoom),
        [3] = exports['since-fonts']:getFont("Inter-Bold", 13/zoom),
        [4] = exports['since-fonts']:getFont('Inter-Bold', 17/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Medium', 13/zoom),
        [6] = exports['since-fonts']:getFont('Inter-Regular', 11/zoom),
    }
end

function isEventHandlerAdded( sEventName, pElement, pFunction )
    if type( sEventName ) == 'string' and isElement( pElement ) and type( pFunction ) == 'function' then
        local tEventHandlers = getEventHandlers( sEventName, pElement )
        if type( tEventHandlers ) == 'table' and #tEventHandlers > 0 then
            for i, v in ipairs( tEventHandlers ) do
                if v == pFunction then
                    return true
                end
            end
        end
    end
    return false
end

function isMouseInPosition ( x, y, width, height )
    if isCursorShowing( ) then
        local sx, sy = guiGetScreenSize ( )
        local cx, cy = getCursorPosition ( )
        local cx, cy = ( cx * sx ), ( cy * sy )
        if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
            return true
        else
            return false
        end
    end
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

local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f, t, easing, duration, onChange, onEnd)
	assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
	assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
	assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
	table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims, a)
	end
end

function renderAnimate()
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims, k)
		end
	end
end

function getMaxOffset(number, offset, max, rt)
    local maxOffset = 0
    if number > max then
        maxOffset = number * (offset) - rt
    else
        maxOffset = 1
    end
    return math.min(maxOffset, 11532/zoom)
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
