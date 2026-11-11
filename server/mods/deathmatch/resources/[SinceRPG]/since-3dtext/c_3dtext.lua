local font = exports["since-fonts"]:getFont("Inter-SemiBold", 14, false)

addEventHandler("onClientRender", root, function()
	local rootx, rooty, rootz = getCameraMatrix()
	local dim = getElementDimension(localPlayer)
	local int = getElementInterior(localPlayer)
	
	local texty=getElementsByType("text")
	for i,text in pairs(texty) do
		if text and isElement(text) and getElementDimension(text) == dim and getElementInterior(text) == int then
			local x,y,z=getElementPosition(text)
			local dist=getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
			if dist < 30 then
				local sx,sy=getScreenFromWorldPosition(x, y, z, 100, true)
				if sx and sy then
					local name = getElementData(text, "name")
					if not name then return end
					if isLineOfSightClear(rootx, rooty, rootz, x, y, z, true, true, false, true, false, true, true ) then
						alpha = 255 / 15 * (30 - dist)
						alpha = math.min(255, math.max(0, alpha))
						
						dxDrawText(name:gsub("#%x%x%x%x%x%x",""), sx + 2, sy + 2, sx, sy, tocolor(0,0,0,alpha/2), 1-dist/30, font, "center", "center", false, false, false, false, true)
        				dxDrawText(name, sx, sy, sx, sy, tocolor(255,255,255,alpha), 1-dist/30, font, "center", "center", false, false, false, true, true)
					end
        		end
        	end
        end
    end
end)
getResourceName(getThisResource(), true, 925033292); if true then return end