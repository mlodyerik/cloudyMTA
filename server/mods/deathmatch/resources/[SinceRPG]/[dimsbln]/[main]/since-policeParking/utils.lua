function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
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

function getVehicles(c, edit1)
    local vehicles = {}
    for k,v in pairs(c) do
		local name = exports['since-vehiclenames']:getVehicleName(v.model)
        if name:lower():find(exports['since-gui']:getEditboxText(edit1):lower()) or tostring(v.id or 0):lower():find(exports['since-gui']:getEditboxText(edit1)) then
            table.insert(vehicles, v)
        end
    end
    return vehicles
end

addEventHandler("onClientRender", root, function( )
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

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
		local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
		if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs(aAttachedFunctions) do
				if v == func then
					return true
				end
			end
		end
	end
	return false
end

getResourceName(getThisResource(), true, 331240342); if true then return end