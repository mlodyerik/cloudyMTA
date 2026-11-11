local screenX, screenY
local drawTimer
local isDrawing

function drawHitMarker()
    dxDrawImage(screenX-16, screenY-16, 32, 32, 'data/hit.png')
    
end

function fireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    if hitElement then
            if getElementType(hitElement)=="player" or getElementType(hitElement)=="ped" or getElementType(hitElement)=="vehicle" then
        screenX, screenY = getScreenFromWorldPosition(hitX, hitY, hitZ)
        if not screenX then return end 
        if isDrawing then return end 
        isDrawing = true
        
    
    
        addEventHandler("onClientRender", root, drawHitMarker) 
        if drawTimer and isTimer(drawTimer) then
            killTimer(drawTimer)
        end
        
        
        drawTimer = setTimer(function() 
            isDrawing = false
            removeEventHandler("onClientRender", root, drawHitMarker) 
        end, 500, 1)
    end
    end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, fireFunc)

function get_hit()
            fadeCamera(false,1,255,0,0)
        function cam()
            fadeCamera(true,1)
        end
        setTimer(cam,150,1)
end


addEventHandler("onClientPlayerDamage",getLocalPlayer(),get_hit)

