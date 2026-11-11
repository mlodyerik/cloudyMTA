sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
main = {}

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

function createTextures()
    main['anim'] = {}
    main['countDown'] = getTickCount()
    main['scroll'] = {1, 7, 7}
    main['textures'] = {}

    for i,v in ipairs({'bg','bg_mask','bar_1','bar_2','ETransporter','barBackground','barFilled','levelBackground','levelSelected','optionalBackground'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end

    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
        [2] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
        [3] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
        [4] = exports['since-fonts']:getFont('Inter-Black', 14/zoom),
    }
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
end

function isMouseIn( x, y, width, height )
    if ( not isCursorShowing( ) ) then
        return false
    end
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

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
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

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

getResourceName(getThisResource(), true, 708210858); if true then return end