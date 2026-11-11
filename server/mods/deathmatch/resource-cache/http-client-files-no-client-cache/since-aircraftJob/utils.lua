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

function formatTime(time)
	local time = time and time*60 or 0
	if time <= 0 then
		return "0 godz. 0 min."
	else
		hours = string.format("%02.f", math.floor(time/3600))
		mins = string.format("%02.f", math.floor(time/60 - (hours*60)))
		secs = string.format("%02.f", math.floor(time - hours*3600 - mins *60))
		return ""..hours.." godz. "..mins.." min."
	end
end

function isMouseIn(x, y, width, height)
    if not isCursorShowing() then
        return false
    end
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy = (cx * sx), (cy * sy)
    if (cx > x and cx < x + width) and (cy > y and cy < y + height) then
        return true
    else
        return false
    end
end