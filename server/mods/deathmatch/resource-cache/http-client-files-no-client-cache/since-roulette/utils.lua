local sx, sy = guiGetScreenSize()

function isMouseIn(x, y, width, height)
    if not isCursorShowing() then
        return false
    end
    local cx, cy = getCursorPosition()
    local cx, cy = cx*sx, cy*sy
    return (cx >= x and cx <= x+width) and (cy >= y and cy <= y+height)
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

local animations = {}

function getAnimation( id )
    return animations[id] or 0
end

function setAnimation( id, value )
	animations[ id ] = value
end

function animateButton( id, isIn, data )
    if not data then data = {0.7, 1} end
    if not data[3] then data[3] = 0.1 end
    if not animations[ id ] then animations[ id ] = data[1] end
    if formatRound(animations[id], 2) == (isIn and data[2] or data[1]) then
        return animations[id]
    end
    animations[ id ] = interpolateBetween( animations[ id ], 0, 0, isIn and data[2] or data[1], 0, 0, data[3], 'Linear' )
    return animations[ id ]
end

function formatRound(value, precision)
    precision = precision or 0
    local multiplier = 10^precision
    return math.floor(value * multiplier + 0.5) / multiplier
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
	if not isEventHandlerAdded("onClientRender", root, renderAnimations) then
		addEventHandler("onClientRender", root, renderAnimations)
	end
	return #anims
end

function renderAnimations()
	if #anims == 0 then
		removeEventHandler("onClientRender", root, renderAnimations)
		return
	end
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

function destroyAnimations()
    animations = {}
	anims = {}
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

function formatTime(minutes)
    local hours = math.floor(minutes / 60)
    local minutes = minutes - hours * 60
    local text = ''
    if hours > 0 then
        text = text..hours..' godz. '
    end
    if minutes > 0 then
        text = text..minutes..' min.'
    elseif minutes <= 0 then
        text = text..'0 min.'
    end
    return text
end

function formatDate(date)
    local months = {'Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'}
    local day = date:sub(9, 10)
    local month = months[tonumber(date:sub(6, 7))]
    local year = date:sub(1, 4)
    return day..' '..month..' '..year
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

function dxDrawScrollbar(x,y,w,h, scroll, max, alpha)
    if max <= 0 then
        dxDrawRectangle(x, y, w, h, tocolor(75,75,75,75*alpha))
        dxDrawRectangle(x, y, w, h, tocolor(90,147,160, 150*alpha)) 
        return 
    end
    local a = animateButton('scrollbar', isMouseIn(x, y, w, h), {0.6, 0.3, 0.05})
    dxDrawRectangle(x, y, w, h, tocolor(75,75,75,75*alpha))
    dxDrawRectangle(x, y+h/max*scroll, w, h/max, tocolor(96,131,177, 150*alpha))
end