

--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

--[[if getElementData(localPlayer, "player:sid") == 25 or getElementData(localPlayer, "player:sid") == 1 then

else
    return false
end--]]

local font = dxCreateFont("files/Poppins-Medium.ttf", 15) or "default"
local tick = getTickCount()

function render()
    if getPedOccupiedVehicle(localPlayer) then
        for i,v in ipairs(getElementsByType("blip", resourceRoot)) do
            local x, y, z = getElementPosition(v)
            local x2, y2, z2 = getElementPosition(localPlayer)
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            if distance < 300 then
                if distance < 100 then
                    local alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount()-tick)/2000, "SineCurve")
                    dxDrawImage(10/zoom, sy - 80/zoom, 50/zoom, 50/zoom, "files/warn.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
                else
                    dxDrawImage(10/zoom, sy - 80/zoom, 50/zoom, 50/zoom, "files/warn.png", 0, 0, 0, white, false)
                end
                dxDrawRectangle(5/zoom, sy - 30/zoom, 60/zoom, 20/zoom, tocolor(0, 0, 0, 180), false)
                dxDrawText(math.floor(distance).."m", 35/zoom, sy - 19/zoom, center, center, white, 1/zoom, font, "center", "center", false, false, false, false)
                break
            end
        end
    end
end
addEventHandler("onClientRender", root, render)
getResourceName(getThisResource(), true, 245308177); if true then return end