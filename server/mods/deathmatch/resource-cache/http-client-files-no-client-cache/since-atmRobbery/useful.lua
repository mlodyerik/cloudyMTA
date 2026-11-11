sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

function isMouseIn(posX, posY, sizeX, sizeY)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy

        if cursorX >= posX and cursorX <= posX + sizeX and cursorY >= posY and cursorY <= posY + sizeY then
            return true
        end
    end

    return false
end