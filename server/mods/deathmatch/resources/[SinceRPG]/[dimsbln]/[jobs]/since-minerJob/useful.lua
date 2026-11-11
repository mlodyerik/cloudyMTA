sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

jobInfo = ''
renderAlpha = 0
renderJobHelp = true
randomKeys = {}
clickedKeys = {[1] = false, [2] = false, [3] = false, [4] = false}
keyStage = 1
miningTime = 2000
tick = getTickCount()
color = {}
magazineCoal = 0

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sxx, syy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sxx ), ( cy * syy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function isPlayerInMiningCuboid()
    local isInCuboid = false

    for i,v in ipairs(getElementsByType('colshape', resourceRoot)) do
        if getElementData(v, 'miner:job:mining') and isElementWithinColShape(localPlayer, v) then
            isInCuboid = v
        end
    end

    return isInCuboid
end

function isPlayerInJobCuboid()
    local isInCuboid = false

    for i,v in ipairs(getElementsByType('colshape', resourceRoot)) do
        if getElementData(v, 'miner:job') and isElementWithinColShape(localPlayer, v) then
            isInCuboid = v
        end
    end

    return isInCuboid
end

function randomizeKeys()
    miningKeys = {}
    keys = {'q', 'w', 'e'}

    for i = 1, 4 do
        miningKeys[i] = keys[math.random(1, #keys)]
    end

    return miningKeys
end

addEvent('getCoal', true)
addEventHandler('getCoal', root, function(resultCoal)
    magazineCoal = resultCoal
end)
getResourceName(getThisResource(), true, 32657370); if true then return end