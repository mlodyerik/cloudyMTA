-- local sx, sy = guiGetScreenSize()

-- local toggleBlur = false
-- local 

-- function processPed()
-- 	if not toggleBlur then 
-- 		return 
-- 	end

-- 	dxUpdateScreenSource(screen)
-- 	dxSetRenderTarget(rt, false)
-- 	dxDrawImage(0, 0, sx, sy, blurV)
-- 	dxSetRenderTarget()

-- 	dxSetRenderTarget(rt2, false)
-- 	dxDrawImage(0, 0, sx, sy, blurH)
-- 	dxSetRenderTarget()
-- end

function dxDrawBlur(x, y, w, h, mask, alpha, useMaskColors)
	if not toggleBlur then 
		return 
	end
	
    -- dxSetShaderValue(blurH2, "sMaskTexture", mask or defaultMask)
    -- dxSetShaderValue(blurH2, "useMaskColors", not useMaskColors)
    -- dxSetShaderValue(blurH2, "position", x/sx, y/sy, w/sx, h/sy)
    -- dxDrawImage(x, y, w, h, blurH2, 0, 0, 0, tocolor(255, 255, 255, alpha or 255))
end

-- function switchBlur(state)
-- 	if state then
-- 		addEventHandler("onClientPedsProcessed", root, processPed)
-- 		blurH = dxCreateShader('data/fxBlurH.fx')
-- 		blurV = dxCreateShader('data/fxBlurV.fx')
-- 		blurH2 = dxCreateShader('data/fxBlurH.fx')
-- 		rt = dxCreateRenderTarget(sx, sy)
-- 		rt2 = dxCreateRenderTarget(sx, sy)
-- 		screen = dxCreateScreenSource(sx, sy)
-- 		defaultMask = dxCreateTexture('mask.png')
-- 		dxSetShaderValue(blurV, "sTex0", screen)
-- 		dxSetShaderValue(blurH2, "sTex0", screen)
-- 		dxSetShaderValue(blurH, "sTex0", rt)
-- 		dxSetShaderValue(blurH2, "sTex0", rt2)
-- 		dxSetShaderValue(blurV, "TexSize", sx, sy)
-- 		dxSetShaderValue(blurH2, "TexSize", sx, sy)
-- 		dxSetShaderValue(blurH, "TexSize", sx, sy)
-- 		dxSetShaderValue(blurH, "gBlurFac", 2)
-- 		dxSetShaderValue(blurV, "gBlurFac", 2)
-- 		dxSetShaderValue(blurH2, "gBlurFac", 2)
-- 		dxSetShaderValue(blurH, "sMaskTexture", defaultMask)
-- 	else
-- 		if isEventHandlerAdded("onClientPedsProcessed", root, processPed) then
-- 			removeEventHandler("onClientPedsProcessed", root, processPed)
-- 		end

-- 		if isElement(blurH) then
-- 			destroyElement(blurH)
-- 		end

-- 		if isElement(blurV) then
-- 			destroyElement(blurV)
-- 		end

-- 		if isElement(blurH2) then
-- 			destroyElement(blurH2)
-- 		end

-- 		if isElement(rt) then
-- 			destroyElement(rt)
-- 		end

-- 		if isElement(rt2) then
-- 			destroyElement(rt2)
-- 		end

-- 		if isElement(screen) then
-- 			destroyElement(screen)
-- 		end

-- 		if isElement(defaultMask) then
-- 			destroyElement(defaultMask)
-- 		end

-- 		blurH = nil
-- 		blurV = nil
-- 		blurH2 = nil
-- 		rt = nil
-- 		rt2 = nil
-- 		screen = nil
-- 		defaultMask = nil
-- 	end

-- 	toggleBlur = state
-- end

-- addEventHandler('onClientElementDataChange', localPlayer, function(dataName, oldValue, newValue)
-- 	if dataName == 'player:settings' then
-- 		local getData = getElementData(localPlayer, 'player:settings') or {}

-- 		if oldValue.drawBlurUI ~= newValue.drawBlurUI then
-- 			if newValue.drawBlurUI then
-- 				switchBlur(false)
-- 			else
-- 				switchBlur(true)
-- 			end
-- 		end
-- 	end
-- end)

-- addEventHandler("onClientResourceStart", resourceRoot, function()
-- 	local getData = getElementData(localPlayer, 'player:settings') or {}

-- 	if getData['drawBlurUI'] then
-- 		switchBlur(false)
-- 	else
-- 		switchBlur(true)
-- 	end
-- end)

-- function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
-- 	if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
-- 		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
-- 		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
-- 			for i, v in ipairs( aAttachedFunctions ) do
-- 				if v == func then
-- 					return true
-- 				end
-- 			end
-- 		end
-- 	end
-- 	return false
-- end
-- getResourceName(getThisResource(), true, 770889284); if true then return end