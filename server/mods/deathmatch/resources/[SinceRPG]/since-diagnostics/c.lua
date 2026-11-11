  

local main = {

	shader = dxCreateShader("shader.fx"),
	myRenderTarget = dxCreateRenderTarget(1024, 600),

	upgrades1 = {

		{'ID', false, 'vehicle:id'},
		{'MK1', 'mk1', 'vehicle:upgrades'},
		{'MK2', 'mk2', 'vehicle:upgrades'},
		{'MK3', 'mk3', 'vehicle:upgrades'},
		{'MK4', 'mk4', 'vehicle:upgrades'},
		{'MK5', 'mk5', 'vehicle:upgrades'},
		{'Turbo', 'turbo', 'vehicle:upgrades'},
		{'Nitro', 'nitro', 'vehicle:upgrades'},
		{'Neony', 'neon', 'vehicle:upgrades'},
		{'Chiptuning', 'chiptuning', 'vehicle:upgrades'},
		{'Strzały z wydechu', 'exhaust', 'vehicle:upgrades'},
		{'Instalacja LPG', 'lpg', 'vehicle:upgrades'},
		{'RH', 'gz', 'vehicle:upgrades'},
		{'ABS', 'abs', 'vehicle:upgrades'},
		{'TwinTurbo', 'twinturbo', 'vehicle:upgrades'},

	},

	--do local _={vinylRim=0,vinylWounds=0,wheelTilt=-12,wheelResize=1.45,innerSize=0.85000001999999997};return _;end

	upgrades2 = {
		{'Przebieg', 'mileage', "vehicle:data", "km", 'string'},
		{'Pojemność silnika', 'engine', 'vehicle:data', 'dm3', 'string'},
		{'Przyciemnione szyby', false, "vehicle:carTint", "%", 'floor'},
		{'Negatyw', 'wheelTilt', "vehicle:wheelTuning", "°", 'floor'},
		{'Motyw licznika', 'motyw', 'vehicle:upgrades'},

	},

	shape = createColSphere(2507.64, -1544.33, 23.69, 6)

}

local fonts = {

	[1] = exports['since-fonts']:getFont('Inter-SemiBold', 20),
	[2] = exports['since-fonts']:getFont('Inter-Regular', 20),
	[3] = exports['since-fonts']:getFont('Inter-Regular', 15),

}

dxSetShaderValue(main.shader, "tex", main.myRenderTarget)

local positions = {

	{2507.66, -1549.63, 23.60, 0, 0, 90},

}

objects = {}

for i,v in ipairs(positions) do
	object = createObject(3354, v[1], v[2], v[3]+1)
	setElementRotation(object, v[4], v[5], v[6])

	table.insert(objects, object)
end

function renderDiagnostic(v)
	if main.myRenderTarget then
		
		dxSetRenderTarget(main.myRenderTarget)

			dxDrawRectangle(0, 0, 1024, 600, tocolor(25, 25, 25, 255))
			dxDrawText("Stacja diagnostyczna", 1024 / 2, 50, nil, nil, tocolor(125, 255, 125, 200), 1, fonts[1], "center", "bottom", false, false, false, false, false)
			--dxDrawRectangle(512 - 200, 55, 400, 2, tocolor(75, 75, 75, 255))

			local veh = getElementsWithinColShape(main.shape, "vehicle")
			if #veh == 1 then
				for i, v in ipairs(veh) do
					veh = v
				end
				if not getElementData(veh, "vehicle:id") then return end

				dxDrawText(exports['since-vehiclenames']:getVehicleName(getElementData(veh, "vehicle:model") or getElementModel(veh)), 1024 / 2, 55, nil, nil, tocolor(255, 255, 255, 200), 1, fonts[3], "center", "top", false, false, false, false, false)

				offset = -100
				for i, v in ipairs(main.upgrades1) do
					if v[2] and v[3] then
						local upgrades = getElementData(veh, v[3]) or {}

						dxDrawRoundedRectangle(12, 215+offset, 488, 30, 8, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 22, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						local ifElse = upgrades[v[2]] and tocolor(125, 255, 125, 255) or tocolor(200, 55, 55, 255)
						if upgrades[v[2]]==true or not upgrades[v[2]] then
							dxDrawText(upgrades[v[2]] and "Tak" or "Nie", 490, 230 + offset, nil, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)
						else
							dxDrawText((v[5]=='string' and string.format("%.1f", upgrades[v[2]]) or v[5]=='floor' and math.floor(upgrades[v[2]]) or upgrades[v[2]])..(v[4] or ''), 490, 230 + offset, nil, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)
						end

					elseif v[2] ~= false and not v[3] then
						local upgrades = getElementData(veh, "vehicle:upgrades") or {}

						dxDrawRoundedRectangle(12, 215+offset, 488, 30, 8, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 22, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						local ifElse = upgrades[v[2]] and tocolor(125, 255, 125, 255) or tocolor(200, 55, 55, 255)
						dxDrawText(upgrades[v[2]] and "Tak" or "Nie", 490, 230 + offset, nil, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)

					elseif v[3] and not v[2] then
						local result = getElementData(veh, v[3]) or "..."
						dxDrawRoundedRectangle(12, 215+offset, 488, 30, 8, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 22, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						if v[4] then
							dxDrawText(result..v[4], 490, 230 + offset, nil, nil, tocolor(125, 255, 125, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						else
							dxDrawText(result, 490, 230 + offset, nil, nil, tocolor(125, 255, 125, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						end
					end

					offset = offset + 40
				end


				offset = -100
				for i, v in ipairs(main.upgrades2) do
					if v[2] and v[3] then
						local upgrades = getElementData(veh, v[3]) or {}
						dxDrawRoundedRectangle(524, 215 + offset, 488, 30, 8, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 534, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						local ifElse = upgrades[v[2]] and tocolor(125, 255, 125, 255) or tocolor(200, 55, 55, 255)

						if upgrades[v[2]]==true or not upgrades[v[2]] then
							dxDrawText(upgrades[v[2]] and "Tak" or "Nie", 1002, 230 + offset, nil, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)
						else
							dxDrawText((v[5]=='string' and string.format("%.1f", upgrades[v[2]]) or v[5]=='floor' and math.floor(upgrades[v[2]]) or upgrades[v[2]])..(v[4] or ''), 1002, 230 + offset, nil, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)
						end

					elseif v[2] ~= false and not v[3] then
						local upgrades = getElementData(veh, "vehicle:upgrades") or {}
						dxDrawRoundedRectangle(524, 215 + offset, 488, 30, 8, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 534, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						local ifElse = upgrades[v[2]] and tocolor(125, 255, 125, 255) or tocolor(200, 55, 55, 255)
						dxDrawText(upgrades[v[2]] and "Tak" or "Nie", 1002, 230 + offset, nil, nil, ifElse, 1, fonts[3], "right", "center", false, false, false, false, false)

					elseif v[3] and not v[2] then
						local result = getElementData(veh, v[3]) or "..."
						dxDrawRoundedRectangle(524, 215 + offset, 488, 30, 8, tocolor(35, 35, 35, 200))
						dxDrawText(v[1], 534, 230 + offset, nil, nil, tocolor(200, 200, 200, 255), 1, fonts[3], "left", "center", false, false, false, false, false)
						if v[4] then
							dxDrawText(result..v[4], 1002, 230 + offset, nil, nil, tocolor(125, 255, 125, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						else
							dxDrawText(result, 1002, 230 + offset, nil, nil, tocolor(125, 255, 125, 255), 1, fonts[3], "right", "center", false, false, false, false, false)
						end
					end

					offset = offset + 40
				end
			elseif #veh >= 1 then
				dxDrawText("Zbyt wiele pojazdów na stanowisku", 1024 / 2, 55, nil, nil, tocolor(255, 75, 75, 200), 1, fonts[3], "center", "top", false, false, false, false, false)
			else
				dxDrawText("Brak pojazdu na stanowisku", 1024 / 2, 55, nil, nil, tocolor(255, 75, 75, 200), 1, fonts[3], "center", "top", false, false, false, false, false)
			end

		dxSetRenderTarget()

		for i, v in ipairs(objects) do
			engineApplyShaderToWorldTexture(main.shader, "ws_garagedoor3_white", objects[i])
		end
	end
end

local tick = getTickCount()
local refreshTimeMs = 1000

addEventHandler('onClientRender', root, function()
	local x, y, z = getElementPosition(localPlayer)
	local theObj = getElementsWithinRange(x, y, z, 20, "object")

	for i, v in ipairs(theObj) do
		if getElementModel(v) == 3354 then
			if getTickCount() - tick > refreshTimeMs then
				renderDiagnostic(v)
				tick = getTickCount()
			end
		end
	end
end)

function convertNumber(amount)
    local formatted = amount 
    while true do
      formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1.%2') 
        if k == 0 then 
            break 
        end 
    end 
    return formatted 
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	if isElement(main.myRenderTarget) then destroyElement(main.myRenderTarget) end
end)

function getVehicleHandlingProperty(element, property)
    if isElement(element) and getElementType(element) == "vehicle" and type(property) == "string" then
        local handlingTable = getVehicleHandling(element) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
    return false
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end
getResourceName(getThisResource(), true, 692077907); if true then return end