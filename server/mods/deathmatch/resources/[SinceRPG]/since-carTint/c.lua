  

local shaders = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	local x, y, z = getElementPosition(getLocalPlayer())
	local vehicles = getElementsWithinRange(x, y, z, 450, 'vehicle')
	for i,v in ipairs(vehicles) do
		if getElementData(v, "vehicle:id") then
		    local carTint = getElementData(v, "vehicle:carTint") or 0
		
		    if carTint > 0 then
                applyWindowTint(v, carTint)
		    end
        end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
        if getElementData(source, "vehicle:id") then
		    local carTint = getElementData(source, "vehicle:carTint") or 0
		
		    if carTint > 0 then
                applyWindowTint(source, carTint)
		    end
        end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "vehicle:id") then
			if getElementData(source, "vehicle:carTint") > 0 then
				destroyTint(source)
			end
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "vehicle:id") then
			local carTint = getElementData(source, "vehicle:carTint") or 0
		
			if carTint > 0 then
				destroyTint(source)
			end
		end
	end
end)

function switchTint(el_data_key, new_data)
	if (getElementType(source) == "vehicle") then
    	if (el_data_key == "vehicle:carTint") or (el_data_key == 'vehicle:upgrades') then
			for i,v in ipairs(getElementsByType("vehicle")) do
				if v == source then
					local getData = getElementData(v, "vehicle:carTint") or 0
					if getData > 0 then
						applyWindowTint(source, getData)
					end
				end
			end
    	end
	end
end
addEventHandler("onClientElementDataChange", root, switchTint)

function applyWindowTint(veh, percent)
    if veh and percent then
        destroyTint(veh)
        shaders[veh] = dxCreateShader("szyby.fx", 1, 200, true)
        engineApplyShaderToWorldTexture(shaders[veh], "vehiclegeneric256", veh)
		engineApplyShaderToWorldTexture(shaders[veh], "@hite", veh)
		engineApplyShaderToWorldTexture(shaders[veh], "car_tint", veh)
		engineApplyShaderToWorldTexture(shaders[veh], "lob_steklo", veh)
		engineApplyShaderToWorldTexture(shaders[veh], "1", veh)

		local data = getElementData(veh, 'vehicle:upgrades') or {}
		local color = data['tintcolor'] or {0, 0, 0}

		if color[1] == 0 and color[2] == 0 and color[3] == 0 then
			dxSetShaderValue(shaders[veh], "tint_color", 0 / 255, 0 / 255, 0 / 255, 1)
        	dxSetShaderValue(shaders[veh], "tint_level", percent)
		else
			dxSetShaderValue(shaders[veh], "tint_color", color[1] / 255, color[2] / 255, color[3] / 255, 1)
			dxSetShaderValue(shaders[veh], "tint_level", 25)
		end
    end
end

function destroyTint(veh)
    if isElement(shaders[veh]) then
        destroyElement(shaders[veh]) 
        return true
    else
        return false
    end
end
getResourceName(getThisResource(), true, 302984961); if true then return end