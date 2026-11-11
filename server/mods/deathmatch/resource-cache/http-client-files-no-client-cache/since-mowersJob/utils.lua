sx,sy = guiGetScreenSize()
zoom = (sx < 2048 and math.min(2.2, 2048/sx) or 1)*0.9

function createTextures(path, tbl)
    local data = {}
    for i,v in ipairs(tbl) do
        if fileExists('files/images/'..path..'/'..v..'.png') then
            data[v] = dxCreateTexture('files/images/'..path..'/'..v..'.png')
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
        [1] = exports['since-fonts']:getFont("Inter-bold", 14/zoom),
        [2] = exports['since-fonts']:getFont("Inter-semiBold", 11/zoom),
        [3] = exports['since-fonts']:getFont("Inter-bold", 25/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
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

function formatNumber(n)
    n = tonumber(n)
    if not n then return '0' end
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
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

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function dxDrawTextAround(text, x, y, w, h, color, size, font, x1, x2, x3, x4, x5, x6, anim)
    local alpha = 55
    if anim then
        alpha = alpha*anim
    end
    dxDrawText(text, x-1, y-1, w, h, tocolor(0,0,0,alpha), size, font, x1, x2, x3, x4, x5, x6)
    dxDrawText(text, x-1, y+1, w, h, tocolor(0,0,0,alpha), size, font, x1, x2, x3, x4, x5, x6)
    dxDrawText(text, x+1, y-1, w, h, tocolor(0,0,0,alpha), size, font, x1, x2, x3, x4, x5, x6)
    dxDrawText(text, x+1, y+1, w, h, tocolor(0,0,0,alpha), size, font, x1, x2, x3, x4, x5, x6)
    dxDrawText(text, x, y, w, h, color, size, font, x1, x2, x3, x4, x5, x6)
end

function formatTime( tick )
    if tick then
        local tbl = {}
        local hours = math.floor(tick/3600000)
        local minutes = math.floor(tick/60000)
        local seconds = math.floor((tick/1000)%60)
		if hours > 0 then table.insert(tbl, hours..' godz.') end
		if minutes > 0 then table.insert(tbl, minutes..' min. ' ) end
		if seconds > 0 then table.insert(tbl, seconds..' sek.') else table.insert(tbl, '0 sek.') end
        return string.reverse(table.concat(tbl, ''):reverse():gsub('', '', 1 ))
    end
    return '---'
end
