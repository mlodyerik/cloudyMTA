sx, sy = guiGetScreenSize()
zoom = (sx < 1920) and math.min(2.2, 1920/sx) or 1

function isMouseIn(posX, posY, sizeX, sizeY)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy

        return cursorX >= posX and cursorX <= posX + sizeX and cursorY >= posY and cursorY <= posY + sizeY
    end
end