local models = {
	[444] = true,
	[556] = true,
	[557] = true,
}

setTimer(function()
	for k, v in ipairs(getElementsByType("vehicle")) do
		if isElementInWater(v) then
			local model = getElementModel(v)
			if model then
				if models[model] and not getElementData(v, "vehicle:id") then
					destroyElement(v)
					return false
				end
				if (getVehicleType(v) == "Boat") then
				elseif not models[model] then
 					local x, y, z = getElementPosition(v)
					setElementPosition(v, x, y, z - 500)
				elseif models[model] and getElementData(v, "vehicle:id") then
					local x, y, z = getElementPosition(v)
					setElementPosition(v, x, y, z - 500)
				end
			end
		end
	end
end, 5000, 0)