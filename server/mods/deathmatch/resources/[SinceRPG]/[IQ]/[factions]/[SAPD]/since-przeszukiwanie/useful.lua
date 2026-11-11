sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

zoom = zoom * 0.6

weaponNames = {

    ['desert-eagle'] = true,
    ['ak-47'] = true,
    ['awm'] = true,
    ['m4'] = true,
    ['shotgun'] = true,
    ['mp5'] = true,

}

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRectangle(x, y, w, height, tocolor(175, 175, 175, alpha*0.2))

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
		
        dxDrawRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), tocolor(175, 175, 175, alpha))
    else
        dxDrawRectangle(x, y, w, height, tocolor(175, 175, 175, alpha))
	end
end

function isMouseIn(posX, posY, sizeX, sizeY)
    if isCursorShowing() then
        local cX, cY = getCursorPosition()
        cX, cY = cX * sx, cY * sy

        return cX >= posX and cX <= posX + sizeX and cY >= posY and cY <= posY + sizeY
    end

    return false
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