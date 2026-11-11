local sh = [[
texture gTexture;

technique TexReplace
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}
]]

local streamedVehicles = {}

local applyTexutures = {

	'sultan1body', 'elegy2body256', 'vehiclegeneric256', '?emap*', 'santori', 'unnamed', 'vehiclegrunge256'

}

local withoutGeneric = {

	[562] = true,
	[559] = true,

}

function applyPaintjob(vehicle)
	if (not streamedVehicles[vehicle]) then
		local eldata = getElementData(vehicle, "vehicle:upgrades") or {}
		local eldata = eldata.custompaintjob
		if (eldata) then
			local paintjobName = paintjobsList[eldata] 

			if not paintjobName then 
				return-- outputDebugString( "Nie znaleziono nazwy paintjoba o ID: "..eldata.."", 1, 255, 0, 0 )
			end

			if (not fileExists("paintjobs/"..paintjobName..".png")) then
				return outputDebugString( "Nie znaleziono pliku paintjoba o ID: "..eldata.."", 1, 255, 0, 0 )
			end

			local texture = dxCreateTexture('paintjobs/'..paintjobName..'.png')

			if (isElement(texture)) then
				local shader = dxCreateShader(sh)
				dxSetShaderValue(shader, "gTexture", texture)	

				if (withoutGeneric[getElementModel(vehicle)]) then
					for i, v in ipairs(applyTexutures) do
						if i ~= 3 then
							engineApplyShaderToWorldTexture(shader, v, vehicle)
						end
					end
				else
					for i, v in ipairs(applyTexutures) do
						engineApplyShaderToWorldTexture(shader, v, vehicle)
					end
				end
				
				streamedVehicles[vehicle] = shader
				destroyElement(texture)		
			end	
		end
	end
end

function removePaintjob(vehicle)
	if (streamedVehicles[vehicle]) then
		if (isElement(streamedVehicles[vehicle])) then
			destroyElement(streamedVehicles[vehicle])
		end
		streamedVehicles[vehicle] = nil
	end
end

addEventHandler("onClientElementStreamIn", root, function()
	if (getElementType(source) == "vehicle") then
		applyPaintjob(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if (getElementType(source) == "vehicle") then
		removePaintjob(source)
	end
end)

addEventHandler('onClientElementDataChange', root, function(dataName, oldValue, newValue)
	if (getElementType(source) == "vehicle") then
		if (dataName == "vehicle:upgrades") then
			local data = getElementData(source, "vehicle:upgrades") or {}

			if data and data.custompaintjob then
				if not oldValue and newValue.custompaintjob then
					applyPaintjob(source)
					return
				end

				if (oldValue.custompaintjob ~= newValue.custompaintjob) then
					if oldValue.custompaintjob ~= 0 and newValue.custompaintjob == 0 then
						removePaintjob(source)
						return
					end
	
					removePaintjob(source)
					applyPaintjob(source)
				end
			end
		end
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for i,v in ipairs(getElementsByType("vehicle")) do
		local data = getElementData(v, "vehicle:upgrades") or {}
		if (isElementStreamedIn(v) and data and data.paintjob) then
			applyPaintjob(v)
		end
	end
end)

getResourceName(getThisResource(), true, 875590587); if true then return end