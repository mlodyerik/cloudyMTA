-- if getElementData(localPlayer, 'player:sid') == 1 or getElementData(localPlayer, 'player:sid') == 4 then else return end
sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9
alpha = 1

function isPedAiming(element)
	if isElement(element) then
		if getElementType(element) == "player" or getElementType(element) == "ped" then
			if getPedTask(element, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end

	return false
end

local returnOriginalCrosshair = {

    [34] = true

}

function drawCrosshair()
    local settings = getElementData(localPlayer, 'player:settings') or {}

    if settings['toggleCrosshair'] then return end
    
    local weaponSlot = getPedWeaponSlot(localPlayer)
    local actualWeapon = getPedWeapon(localPlayer)

    if returnOriginalCrosshair[actualWeapon] then
            setPlayerHudComponentVisible('crosshair', true)
        return 
    else
        setPlayerHudComponentVisible('crosshair', false)
    end

	if(weaponSlot > 1 and weaponSlot < 7) and not isElementInWater(localPlayer) and isPedAiming(localPlayer) and getPedControlState(localPlayer, "aim_weapon") then
		local hX,hY,hZ = getPedTargetEnd(localPlayer)
		local screen1, screen2 = getScreenFromWorldPosition(hX,hY,hZ)
		if (screen1 and screen2) then
            local playerData = getElementData(localPlayer, 'player:data') or {}
            local crosshairData = playerData['crosshair'] or {}

            if not crosshairData.position then crosshairData.position = 2 end
            if not crosshairData.size then crosshairData.size = 1 end
            if not crosshairData.line then crosshairData.line = 5 end
            if not crosshairData.color then crosshairData.color = {255, 255, 255} end
            if not crosshairData.modeT then crosshairData.modeT = false end

            dxDrawRectangle(screen1 - 2.5 + crosshairData.position, screen2 - crosshairData.size/2, 2/zoom + crosshairData.line, crosshairData.size, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
            dxDrawRectangle(screen1 - crosshairData.position - crosshairData.line, screen2 - crosshairData.size/2, 2/zoom + crosshairData.line, crosshairData.size, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
            
            if not crosshairData.modeT then
                dxDrawRectangle(screen1 - crosshairData.size/2, screen2 - crosshairData.position - crosshairData.line, crosshairData.size, 2/zoom + crosshairData.line, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
            end
        
            dxDrawRectangle(screen1 - crosshairData.size/2, screen2 - 2 + crosshairData.position, crosshairData.size, 2/zoom + crosshairData.line, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
		end
	end
end

function setupScript()
    addEventHandler('onClientRender', root, drawCrosshair)
end
addEventHandler('onClientResourceStart', resourceRoot, setupScript)