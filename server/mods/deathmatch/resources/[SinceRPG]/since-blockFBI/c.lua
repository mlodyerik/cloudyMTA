  

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	if getElementModel(veh) == 490 or getElementModel(veh) == 528 then
		if veh and (not getElementData(veh, "vehicle:duty")) then
			toggleControl("horn", false)
		else
			toggleControl("horn", true)
		end
	end
end)
getResourceName(getThisResource(), true, 647116); if true then return end