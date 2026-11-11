function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function showNotification(text, type)
	exports['since-notifications']:sendNotification(type, text)
end

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(100, 255, 100,alpha*0.2))

    if #table > m_ then
        local scrollbarHeight = height/#table
		local scrollbarPos = 0

		if k_ == 1 then 
            scrollbarPos = y
        elseif k_ > 0 then 
            scrollbarPos = ((k_)*scrollbarHeight)+y
        end

        if #table <= m_ then 
            scrollbarHeight = height
        end
        
        dxDrawRoundedRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), w/2, tocolor(100, 255, 100, alpha))
    else
        dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(100, 255, 100, alpha))
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

function wordWrap(text, maxwidth, scale, font, colorcoded)
    local lines = {}
    local words = split(text, " ") -- this unfortunately will collapse 2+ spaces in a row into a single space
    local line = 1 -- begin with 1st line
    local word = 1 -- begin on 1st word
    local endlinecolor
    while (words[word]) do -- while there are still words to read
        repeat
            if colorcoded and (not lines[line]) and endlinecolor and (not string.find(words[word], "^#%x%x%x%x%x%x")) then -- if on a new line, and endline color is set and the upcoming word isn't beginning with a colorcode
                lines[line] = endlinecolor -- define this line as beginning with the color code
            end
            lines[line] = lines[line] or "" -- define the line if it doesnt exist

            if colorcoded then
                local rw = string.reverse(words[word]) -- reverse the string
                local x, y = string.find(rw, "%x%x%x%x%x%x#") -- and search for the first (last) occurance of a color code
                if x and y then
                    endlinecolor = string.reverse(string.sub(rw, x, y)) -- stores it for the beginning of the next line
                end
            end
      
            lines[line] = lines[line]..words[word] -- append a new word to the this line
            lines[line] = lines[line] .. " " -- append space to the line

            word = word + 1 -- moves onto the next word (in preparation for checking whether to start a new line (that is, if next word won't fit)
        until ((not words[word]) or dxGetTextWidth(lines[line].." "..words[word], scale, font, colorcoded) > maxwidth) -- jumps back to 'repeat' as soon as the code is out of words, or with a new word, it would overflow the maxwidth
    
        lines[line] = string.sub(lines[line], 1, -2) -- removes the final space from this line
        if colorcoded then
            lines[line] = string.gsub(lines[line], "#%x%x%x%x%x%x$", "") -- removes trailing colorcodes
        end
        line = line + 1 -- moves onto the next line
    end -- jumps back to 'while' the a next word exists
    return lines
end
getResourceName(getThisResource(), true, 920214390); if true then return end