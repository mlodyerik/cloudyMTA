sx, sy = guiGetScreenSize()
zoom = 1 
if sx < 2048 then
	zoom = math.min(2.2, 2048/sx)
end 

function isMouseIn(x, y, width, height)
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )

	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
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

function formatTime(time)
	local time = time or 0
	time = time*60
    if (time > 0) then
        local h = math.floor(time/3600)
        local m = math.floor(time/60 - (h*60))
		return (h > 0 and ""..h.." godz. "..m.." min." or ""..m.." min.")
    else
        return "0 min."
    end
end

function destroy(el)
    if el and isElement(el) then 
        destroyElement(el) 
    end
end

function addEv(ev, el, fnc)
    if (not isEventHandlerAdded(ev, el, fnc)) then
        addEventHandler(ev, el, fnc)
    end
end
function removeEv(ev, el, fnc)
    if isEventHandlerAdded(ev, el, fnc) then
        removeEventHandler(ev, el, fnc)
    end
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') 
			
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end
getResourceName(getThisResource(), true, 277149379); if true then return end