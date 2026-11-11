  

local screenW, screenH = guiGetScreenSize()
-- pozycje 
local baseX = 2048
zoom = 1 
local selectedBlip = false
local minZoom = 2.2
if screenW < baseX then
	zoom = math.min(minZoom, baseX/screenW)
end 
local mapPos = {x=0, y=0, w=sx, h=sy}
zoom = zoom*0.9
local showing = false 
local textures = {}
local playerX, playerY = 0, 0
local sW, sH = guiGetScreenSize()
local createdGPS = false

local mapUnit = 1980/6000 -- rozmiar mapki / 6000
local mapZoom = 2
local mapIsMoving, mapOffsetX, mapOffsetY = false, 0, 0
local wasMapMoved = true 

local scrollZoom = mapZoom

local guiInfo = {

	pos = {x = 0, y = 0},
	selected = false,

}

local blipOptions = {

	{
		name = 'Nawiguj',
		use = function(blip)
			local x, y = getElementPosition(blip)
			--exports['since-radar']:findBestWay(x, y)
			--exports['borsuk-notyfikacje']:addNotification('success', 'Nawigacja', 'Ustawiono trasę GPS!', 6000);
			return false
		end
	},

}


local blips = {

	[0] = {name="Gracz", texture="player"},
	[1] = {name="Gracz", texture="player"},
	[53] = {name="Tor 1/4 mili", texture="radar_Flag"},
	[45] = {name="Przebieralnia", texture="radar_tshirt"},
	[35] = {name="Przechowalnia pojazdów", texture="radar_saveGame"},
	[8] = {name="Parking policyjny", texture="radar_BIGSMOKE"},
	[55] = {name="Salon pojazdów", texture="radar_impound"},
	[43] = {name="Giełda", texture="radar_triads"},
	[38] = {name="Sklep 24/7", texture="radar_SWEET"},
	[18] = {name="Ammunation", texture="radar_ammugun"},
	[47] = {name="Złomowisko", texture="radar_ZERO"},
	[30] = {name="San Andreas Police Department", texture="radar_police"},
	[11] = {name="San Andreas Road Assistance", texture="radar_bulldozer"},
	[60] = {name="Transport of San Andreas", texture="radar_gangY"},
	[27] = {name="Mechanik", texture="radar_modGarage"},
	[23] = {name="Warsztat tuningowy", texture="radar_LocoSyndicate"},
	[39] = {name="Urząd miasta", texture="radar_tattoo"},
	[56] = {name="Stacja benzynowa", texture="radar_light"},
	[46] = {name="Praca dorywcza", texture="radar_WOOZIE"},
	[52] = {name="Bankomat", texture="radar_cash"},
	[31] = {name="Wolny dom", texture="radar_propertyG"},
	[32] = {name="Zajęty dom", texture="radar_propertyR"},
	[41] = {name="Cel", texture="radar_waypoint"},
	[29] = {name="Restauracja", texture="radar_pizza"},
	[25] = {name="Kasyno", texture="radar_mafiaCasino"},
	[28] = {name="Melina", texture="radar_OGLOC"},
	[13] = {name="Kupowanie nasion", texture="radar_CESARVIAPANDO"},
	[51] = {name="Logistyka lądowa", texture="radar_truck"},
	[34] = {name="Zrzut", texture="radar_RYDER"},

}

local main = {
    ['textures'] = {},
    ['fonts'] = {},
    ['toggle'] = false,
    ['colors'] = {
        {
            name = 'Twoja lokalizacja',
            icon = 'my_locate',
            color = {255,255,255}
        },
        {
            name = 'Gracz',
            icon = 'circle',
            color = {255,255,255}
        },
        {
            name = 'Twój znajomy',
            icon = 'circle',
            color = {90,187,133}
        },
        {
            name = 'San Andreas Police Department',
            icon = 'circle',
            color = {99,186,215}
        },
        {
            name = 'San Andreas Road Assistance',
            icon = 'circle',
            color = {215,170,99}
        },
        {
            name = 'San Andreas Medical Center',
            icon = 'circle',
            color = {253,157,255}
        },
        {
            name = 'Transport of San Andreas',
            icon = 'circle',
            color = {215,208,99}
        },
        {
            name = 'San Andreas Fire Department',
            icon = 'circle',
            color = {215,99,99}
        }
    }
}

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function drawLine(x, y, tx, ty, color, width)
    local angle = findRotation(x, y, tx, ty)
    local dist = getDistanceBetweenPoints2D(x, y, tx, ty)
    local w, h = dist, width
    dxDrawImage(x, y-h/2, w, h, 'images/line.png', angle+90, -w/2, 0, color)
end

local blipSize = 40/zoom

local memoryButton = nil 
local memoryCheckbox = false 
local blipsNames = {}
local target = false

local data = {
    ['anims'] = {
        tick = getTickCount(),
        state = 'down',
        anim = 1,
    }
}

function setMapTarget(x, y)
	target = {x, y}
end

function renderBigMap()	
	if not wasMapMoved then 
		playerX, playerY = 0, 0
	end 
	
	local absoluteX, absoluteY = 0, 0
	local cursorX, cursorY = getCursorPosition()

	if target then
		playerX = playerX + (target[1] - playerX) / 20
		playerY = playerY + (target[2] - playerY) / 20
	end
			
	if (getKeyState('mouse1')) and mapIsMoving then
		target = false

		absoluteX = (cursorX * screenW)
		absoluteY = (cursorY * screenH)
		
		playerX = -(absoluteX * mapZoom / mapUnit - mapOffsetX)
		playerY = (absoluteY * mapZoom / mapUnit - mapOffsetY)
						
		playerX = math.max(-3000, math.min(3000, playerX))
		playerY = math.max(-3000, math.min(3000, playerY))
	end

	local mapX = (((3000 + playerX) * mapUnit) - (mapPos.w / 2) * mapZoom)
	local mapY = (((3000 - playerY) * mapUnit) - (mapPos.h / 2) * mapZoom)
	local mapWidth, mapHeight = mapPos.w * mapZoom, mapPos.h * mapZoom
	local offset = 0

	if scrollZoom > mapZoom then 
		mapZoom = math.min(mapZoom + 0.03, scrollZoom)
	elseif scrollZoom < mapZoom then
		mapZoom = math.max(mapZoom - 0.03, scrollZoom)
	end

	--dxDrawRectangleLined(mapPos.x, mapPos.y, mapPos.w, mapPos.h, tocolor(125, 125, 125, 255), 1)
	exports['since-blur']:dxDrawBlur(0, 0, sx, sy)
	dxDrawImage(0,0,sx,sy, 'images/winieta.png', 0, 0, 0, tocolor(0, 0, 0, 155))
	dxDrawRectangle(0,0,sx,sy,tocolor(35,35,35,155))
	dxDrawImageSection(mapPos.x, mapPos.y, mapPos.w, mapPos.h, mapX, mapY, mapWidth, mapHeight, textures.map, 0, 0, 0, tocolor(255, 255, 255, 200)) -- mapka
	dxDrawImage(0, 0, sx, sy, 'images/rectangle.png', 0, 0, 0, tocolor(25, 25, 25, 255))
	-- dxDrawText('Mapa serwera', 0 + 351/2/zoom, 17/zoom, nil, (17/zoom) + (32/zoom), tocolor(215, 215, 215, 255), 1, main['fonts'][1], 'center', 'top')
    -- dxDrawText('Legenda mapy', 0 + 351/2/zoom, 43/zoom, nil, (43/zoom) + (26/zoom), tocolor(215, 215, 215, 255), 1, main['fonts'][2], 'center', 'top')

	local GPS = exports["since-radar"]:getGPS()

	local startRGB = {255, 55, 55}
	local endRGB = {185, 0, 0}
	if GPS and GPS.road then
        if #GPS.road > 0 then
            for i = #GPS.road, 1, -1 do
                if (GPS.road[i + 1] ~= nil) then
                    local x, y = getMapFromWorldPosition(GPS.road[i].posX, GPS.road[i].posY)
                    local ex, ey = getMapFromWorldPosition(GPS.road[i + 1].posX, GPS.road[i + 1].posY)
					if (x > mapPos.x or ex > mapPos.x) and (x < mapPos.x + mapPos.w or ex < mapPos.x + mapPos.w) and (y > mapPos.y or ey > mapPos.y) and (y < mapPos.y + mapPos.h or ey < mapPos.y + mapPos.h) then
						x = math.min(math.max(x, mapPos.x), mapPos.x + mapPos.w)
						ex = math.min(math.max(ex, mapPos.x), mapPos.x + mapPos.w)
						y = math.min(math.max(y, mapPos.y), mapPos.y + mapPos.h)
						ey = math.min(math.max(ey, mapPos.y), mapPos.y + mapPos.h)

						drawLine(x, y, ex, ey, tocolor(255, 0, 0, 255), 6/mapZoom)
					end
                end
            end
        end
    end
	
	for k,v in ipairs(getElementsByType("radararea")) do
		local x, y = getElementPosition(v)
		local w, h = getRadarAreaSize(v)
		local r, g, b, a = getRadarAreaColor(v)
		local flashing = isRadarAreaFlashing(v)
		if flashing then
			a = a*data['anims'].anim
		end

		x, y = getMapFromWorldPosition(x, y)
		w, h = getMapFromWorldPosition(w, h)
		_w, _h = getMapFromWorldPosition(0, 0)
		w, h = w - _w, h - _h
        x = x + w
        w = -w

		if (x + w > mapPos.x and x < mapPos.x + mapPos.w) and (y > mapPos.y and y + h < mapPos.y + mapPos.h) then
			if x < mapPos.x then
				w = w - (mapPos.x - x)
				x = mapPos.x
			end
			if y < mapPos.y then
				h = h - (mapPos.y - y)
				y = mapPos.y
			end
			if x + w > mapPos.x + mapPos.w then
				w = mapPos.x + mapPos.w - x
			end
			if y + h > mapPos.y + mapPos.h then
				h = mapPos.y + mapPos.h - y
			end
			dxDrawRectangle(x, y, w, h, tocolor(r, g, b, a))
		end
	end
	
	local blipSize = 40/zoom - math.max(math.min(mapZoom, 2), 1)
	for _, blip in ipairs(getElementsByType("blip")) do
		if getElementInterior(blip) == getElementInterior(localPlayer) and getElementDimension(blip) == getElementDimension(localPlayer) then 
			local icon = getBlipIcon(blip)
			if blips[icon] then
				local blipX, blipY, blipZ = getElementPosition(blip)
				local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
				local leftFrame = (centerX - mapPos.w / 2) + (blipSize/ 2)
				local rightFrame = (centerX + mapPos.w / 2) - (blipSize/ 2)
				local topFrame = (centerY - mapPos.h / 2) + (blipSize/ 2)
				local bottomFrame = (centerY + mapPos.h / 2) - (blipSize/ 2)
				local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
								
				centerX = math.max(leftFrame, math.min(rightFrame, blipX))
				centerY = math.max(topFrame, math.min(bottomFrame, blipY))

				if selectedBlip and not isElement(selectedBlip) then selectedBlip = nil end
				local alpha = (selectedBlip and getBlipIcon(selectedBlip) == getBlipIcon(blip)) and 255 or (not selectedBlip and 255 or 0)

				if selectedBlip and selectedBlip == blip then
					local text = blips[icon].name
					local description = getElementData(blip, "blip:description")
					local width = dxGetTextWidth(text, 1, main['fonts'][1]) + 15/zoom
					local descriptionWidth = 0
					if description then
						width = dxGetTextWidth(text, 1, main['fonts'][2]) + 15/zoom
						descriptionWidth = dxGetTextWidth(description, 1, main['fonts'][2]) + 15/zoom
					end
					width = math.max(width, descriptionWidth)

					local height = #blipOptions * (dxGetFontHeight(1, main['fonts'][2]) + 7/zoom) + 35/zoom
					dxDrawRectangle(centerX - (blipSize/2) - 5/zoom, centerY - (blipSize/2) - 5/zoom, blipSize + 5/zoom + width, blipSize + 10/zoom + height, tocolor(25, 25, 25, 240), true)
					dxDrawRectangle(centerX - (blipSize/2) - 5/zoom, centerY - 10/zoom + blipSize, blipSize + 5/zoom + width, 1, tocolor(45, 45, 45, 240), true)
					
					if not description then
						dxDrawText(text, centerX + blipSize/2 + 5/zoom, centerY, nil, nil, white, 1, main['fonts'][1], 'left', 'center', false, true, true)
					else
						dxDrawText(text, centerX + blipSize/2 + 10/zoom, centerY, nil, nil, white, 1, main['fonts'][2], 'left', 'bottom', false, true, true)
						dxDrawText(description, centerX + blipSize/2 + 10/zoom, centerY, nil, nil, tocolor(255, 255, 255, 170), 1, main['fonts'][3], 'left', 'top', false, true, true)
					end

					local y = 0
					for k,v in pairs(blipOptions) do
						local gx, gy, gw, gh = centerX - (blipSize/2) - 5/zoom, centerY + (blipSize/2) + 10/zoom + y, blipSize + 5/zoom + width, dxGetFontHeight(1, main['fonts'][2]) + 7/zoom - 1
						local inside = isMouseIn(gx, gy, gw, gh)
						dxDrawRectangle(gx, gy, gw, gh, tocolor(55, 55, 55, inside and 200 or 50), true)
						dxDrawText(v.name, centerX - (blipSize/2), centerY + (blipSize/2) + 13/zoom + y, nil, nil, white, 1, main['fonts'][2], 'left', 'top', false, true, true)

						if k ~= #blipOptions then
							y = y + dxGetFontHeight(1, main['fonts'][2]) + 7/zoom
						else
							y = y + 25/zoom
						end
					end

					local insideArrowLeft = isMouseIn(centerX - (blipSize/2), centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom)
					local insideArrowRight = isMouseIn(centerX + (blipSize/2) + width - 27/zoom, centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom)
					dxDrawImage(centerX - (blipSize/2), centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom, 'images/arrow.png', 0, 0, 0, tocolor(255, 255, 255, insideArrowLeft and 255 or 150), true)
					dxDrawImage(centerX + (blipSize/2) + width - 5/zoom, centerY + (blipSize/2) + 15/zoom + y, -22/zoom, 22/zoom, 'images/arrow.png', 0, 0, 0, tocolor(255, 255, 255, insideArrowRight and 255 or 150), true)
				end

				if icon == 1 or icon == 0 then
					local r, g, b = getBlipColor(blip)
					dxDrawImage(centerX - (blipSize/2), centerY - (blipSize/ 2), blipSize - 5/zoom, blipSize, BLIP_TEXTURES[blips[icon].texture], 0, 0, 0, tocolor(r, g, b, alpha))
				else
					local x, y, w, h = centerX - (blipSize/2), centerY - (blipSize/ 2), blipSize - 5/zoom, blipSize
					--[[if isMouseIn(x, y, w, w) then
						x = x - w * 0.1
						y = y - h * 0.1
						w = w * 1.2
					end]]

					dxDrawImage(x, y, w, w, BLIP_TEXTURES[blips[icon].texture], 0, 0, 0, tocolor(255, 255, 255, alpha), selectedBlip == blip)
				end
			end
		end
	end
	
	local localX, localY, localZ = getElementPosition(localPlayer)
	local blipX, blipY = getMapFromWorldPosition(localX, localY)
	if not selectedBlip and (blipX >= mapPos.x and blipX <= mapPos.x + mapPos.w) and (blipY >= mapPos.y and blipY <= mapPos.y + mapPos.h) then
		local _, _, playerRotation = getElementRotation(localPlayer)
		dxDrawImage(blipX - 10, blipY - 10, 20, 20, BLIP_TEXTURES["radar_centre"], 360 - playerRotation)
	end

	dxDrawImage(mapPos.x - 1/zoom, mapPos.y - 1/zoom, mapPos.w + 2/zoom, mapPos.h + 2/zoom, vignette, 0, 0, 0, tocolor(255, 255, 255, 180))

	dxDrawText('Legenda', 30/zoom, 25/zoom, nil, nil, tocolor(255,255,255),1,main['fonts'][1],'left','center')
	local textWidth = dxGetTextWidth('Legenda', 1, main['fonts'][1])
	local x, y, z = getElementPosition(localPlayer)
	local zoneName = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)
	dxDrawText(zoneName, 40/zoom+textWidth, 25/zoom, nil, nil, tocolor(125,255,125),1,main['fonts'][3],'left','center')

	x = 0
	for i = 1, 70 do
		if blips[i] then
			x = x + 1
			offsetY = (34/zoom + 1)*(x-1)

			local name = blips[i].name or "Brak"
			local textWidth = dxGetTextWidth(name, 1, main['fonts'][3])
			dxDrawImage(mapPos.x + 10/zoom + 25/zoom, mapPos.y + 30/zoom + 12/zoom + offsetY, 34/zoom, 34/zoom, BLIP_TEXTURES[blips[i].texture], 0, 0, 0, tocolor(255, 255, 255, 255))
			dxDrawText(name, mapPos.x + 50/zoom + 25/zoom, mapPos.y + 34/zoom + 25/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 200), 1, main['fonts'][3], "left", "center", false, true, false, false, false)
		end
	end

	if data['anims'].state == 'up' then
		local progress = (getTickCount() - data['anims'].tick)/1555
		data['anims'].anim = interpolateBetween(0.25, 0, 0, 1, 0, 0, progress, 'InOutQuad')
		if progress >= 1 then
			data['anims'].state = 'down'
			data['anims'].tick = getTickCount()
		end
	elseif data['anims'].state == 'down' then
		local progress = (getTickCount() - data['anims'].tick)/1555
		data['anims'].anim = interpolateBetween(1, 0, 0, 0.25, 0, 0, progress, 'InOutQuad')
		if progress >= 1 then
			data['anims'].state = 'up'
			data['anims'].tick = getTickCount()
		end
	end
end 

function getMapPositionFromWorld(x, y, w, h)
	return (x+3000)/6000*w, (3000-y)/6000*h
end

function moveBigMap(button, state, cursorX, cursorY)
	if (button == 'left' and state == 'down') then
		if (cursorX >= mapPos.x and cursorX <= mapPos.x + mapPos.w) and (cursorY >= mapPos.y and cursorY <= mapPos.y + mapPos.h)  then
			-- if is cursor over any blip
			for _, blip in ipairs(getElementsByType("blip")) do
				-- check if it's not localplayers blip
				if selectedBlip and not isElement(selectedBlip) then selectedBlip = nil end
				local alpha = (selectedBlip and getBlipIcon(selectedBlip) == getBlipIcon(blip)) or (not selectedBlip)
				if getElementInterior(blip) == getElementInterior(localPlayer) and getElementDimension(blip) == getElementDimension(localPlayer) and alpha then 
					local icon = getBlipIcon(blip)
					if blips[icon] and icon ~= 0 then
						local blipX, blipY, blipZ = getElementPosition(blip)
						local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
						local leftFrame = (centerX - mapPos.w / 2) + (blipSize/ 2)
						local rightFrame = (centerX + mapPos.w / 2) - (blipSize/ 2)
						local topFrame = (centerY - mapPos.h / 2) + (blipSize/ 2)
						local bottomFrame = (centerY + mapPos.h / 2) - (blipSize/ 2)
						local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
										
						centerX = math.max(leftFrame, math.min(rightFrame, blipX))
						centerY = math.max(topFrame, math.min(bottomFrame, blipY))

						if selectedBlip == blip then
							local text = blips[icon].name
							local width = dxGetTextWidth(text, 1, main['fonts'][1]) + 15/zoom
							local height = #blipOptions * (dxGetFontHeight(1, main['fonts'][2]) + 7/zoom) + 35/zoom
		
							local y = 0
							for k,v in pairs(blipOptions) do
								if isMouseIn(centerX - (blipSize/2) - 5/zoom, centerY + (blipSize/2) + 10/zoom + y, blipSize + 5/zoom + width, dxGetFontHeight(1, main['fonts'][2]) + 7/zoom - 1) then
									local result = v.use(blip)
									if not result then selectedBlip = nil end
									return
								end
		
								if k ~= #blipOptions then
									y = y + dxGetFontHeight(1, main['fonts'][2]) + 7/zoom
								else
									y = y + 25/zoom
								end
							end
		
							if isMouseIn(centerX - (blipSize/2), centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom) then
								local previousBlip = false
								for k,v in pairs(getElementsByType("blip")) do
									if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
										if not firstBlip then
											firstBlip = v
										end
										if v == blip then
											break
										else
											previousBlip = v
										end
									end
								end

								if not previousBlip then
									for k,v in pairs(getElementsByType("blip")) do
										if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
											previousBlip = v
										end
									end
								end

								if previousBlip then
									selectedBlip = previousBlip
									local blipX, blipY, blipZ = getElementPosition(previousBlip)
									setMapTarget(blipX, blipY)
									return
								end
							end
							if isMouseIn(centerX + (blipSize/2) + width - 27/zoom, centerY + (blipSize/2) + 15/zoom + y, 22/zoom, 22/zoom) then
								local nextBlip = false
								local nextBlipElement = false
								for k,v in pairs(getElementsByType("blip")) do
									if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
										if v == blip then
											nextBlip = true
										elseif nextBlip then
											nextBlipElement = v
											break
										end
									end
								end

								if not nextBlipElement then
									for k,v in pairs(getElementsByType("blip")) do
										if getElementInterior(v) == getElementInterior(localPlayer) and getElementDimension(v) == getElementDimension(localPlayer) and getBlipIcon(v) == getBlipIcon(blip) then
											nextBlipElement = v
											break
										end
									end
								end

								if nextBlipElement then
									selectedBlip = nextBlipElement
									local blipX, blipY, blipZ = getElementPosition(nextBlipElement)
									setMapTarget(blipX, blipY)
									return
								end
							end

							if isMouseIn(centerX - (blipSize/2) - 5/zoom, centerY - (blipSize/2) - 5/zoom, blipSize + 5/zoom + width, blipSize + 10/zoom + height) then
								return
							end
						end

					end
				end
			end

			selectedBlip = nil

			mapOffsetX = (cursorX * mapZoom / mapUnit + playerX)
			mapOffsetY = (cursorY * mapZoom / mapUnit - playerY)
			mapIsMoving = true
			wasMapMoved = true
		end
	elseif (button == 'left' and state == 'up') then
		mapIsMoving = false
	end

	if (button == 'right' and state == 'down') then
		if (cursorX >= mapPos.x and cursorX <= mapPos.x + mapPos.w) and (cursorY >= mapPos.y and cursorY <= mapPos.y + mapPos.h) then
			if not createdGPS then
				centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
				
				local absoluteX, absoluteY = 0, 0
				local cursorX, cursorY = getCursorPosition()
				absoluteX = (cursorX * screenW)
				absoluteY = (cursorY * screenH)
				
				local relativeX = absoluteX - centerX
				local relativeY = absoluteY - centerY
				
				local worldX = relativeX * mapZoom / mapUnit
				local worldY = relativeY * mapZoom / mapUnit

				local worldX = worldX + playerX
				local worldY = -worldY + playerY
				
				if worldX and worldY then
					exports['since-radar']:findBestWay(worldX, worldY)

					local zoneName = getZoneName(worldX, worldY, 0, true)..', '..getZoneName(worldX, worldY, 0, false)
					exports['since-notifications']:sendNotification('info', 'Ustawiono GPS na '..zoneName)
					
					local vehicle = getPedOccupiedVehicle(localPlayer)

					if vehicle then
						local vehicleController = getVehicleController(vehicle)

						if vehicleController == localPlayer or not vehicleController then
						else
							triggerServerEvent('switchGPS', resourceRoot, worldX, worldY)
						end
					end
				end
				createdGPS = true
			else
				exports['since-radar']:removeGPS()
				createdGPS = false

				exports['since-notifications']:sendNotification('info', 'Anulowano GPS')
			end
		end
	end
end

addEvent('switchGPS', true)
addEventHandler('switchGPS', resourceRoot, function(player, x, y)
	exports['since-radar']:findBestWay(x, y)

	local zoneName = getZoneName(x, y, 0, true)..', '..getZoneName(x, y, 0, false)
	exports['since-notifications']:sendNotification('info', 'Gracz '..getPlayerName(player)..' ustawia GPS na: '..zoneName)
end)

function createdGPSToggle()
	createdGPS = false
end

function dxDrawRectangleLined( x, y, width, height, color, _width, postGUI )
    local _width = _width or 1
    dxDrawLine ( x, y, x+width, y, color, _width, postGUI ) -- Top
    dxDrawLine ( x, y, x, y+height, color, _width, postGUI ) -- Left
    dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI ) -- Bottom
    dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI ) -- Right
end

function scrollBigMap(key)
	if key == "mouse_wheel_down" then 
		scrollZoom = math.min(scrollZoom+0.3, 3)
	elseif key == "mouse_wheel_up" then 
		scrollZoom = math.max(0.75, scrollZoom-0.3)
	end
end 

main['fonts'][1] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom)
main['fonts'][2] = exports['since-fonts']:getFont('Inter-Medium' ,13/zoom)
main['fonts'][3] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom)

function showBigMap()
	if not getElementData(localPlayer, "player:spawn") then return end
	showing = not showing
	showCursor(showing)
	selectedBlip = nil
	
	if showing then 
		toggleRadar(true)
		local c = {
			['map'] = true,
		}
		for i,v in pairs(c) do
			if not main['textures'][i] then
				main['textures'][i] = dxCreateTexture('images/map/'..i..'.png','argb',false,'clamp')
			end
		end
		playerX, playerY = getElementPosition(localPlayer)
		wasMapMoved = false 
		mapZoom = 2

		vignette = dxCreateTexture("images/winieta.png", "argb", true, "clamp")
		
		if not memoryCheckbox then
			if not textures.map then
				textures.map = dxCreateTexture("images/map/map.png")
				dxSetTextureEdge(textures.map, 'clamp')
			end
		end 
		
		showChat(false)
		setElementData(localPlayer, "player:hudof", true)
		bindKey("mouse_wheel_up", "down", scrollBigMap)
		bindKey("mouse_wheel_down", "down", scrollBigMap)
		
		addEventHandler("onClientRender", root, renderBigMap)
		addEventHandler("onClientClick", root, moveBigMap)
	else 
		toggleRadar(false)

		for i, v in pairs(main['textures']) do
			if (isElement(v)) then
				destroyElement(v)
			end
		end

		if isElement(textures.map) then
			destroyElement(textures.map)
			textures = {}
		end

		main['textures'] = {}

		if isElement(vignette) then
			destroyElement(vignette)
			vignette = nil
		end

		unbindKey("mouse_wheel_up", "down", scrollBigMap)
		unbindKey("mouse_wheel_down", "down", scrollBigMap)
		removeEventHandler("onClientRender", root, renderBigMap)
		removeEventHandler("onClientClick", root, moveBigMap)

		showChat(true)
		setElementData(localPlayer, "player:hudof", false)
	end
end 

function isBigMapShowing()
	return showing
end

addEventHandler("onClientKey", root, function(key, state)
	if key == "F11" and state then
		cancelEvent()
		forcePlayerMap(false)

		showBigMap()
	end
end)

function getWorldFromMapPosition(centerX, centerY)
	local worldX = screenW/2
	local worldY = screenH/2
	worldX = ((playerX + centerX) * mapZoom * mapUnit)
	
	return worldX, worldY
end

function getMapFromWorldPosition(worldX, worldY)
	local worldX, worldY = worldX + 3000, (worldY + 3000)
	local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
	local playerX, playerY = (playerX + 3000), (playerY + 3000)
	centerX = centerX - ((playerX - worldX) / mapZoom * mapUnit)
	centerY = centerY - ((worldY - playerY) / mapZoom * mapUnit)
	
	return centerX, centerY
end

--[[function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
	local mapLeftFrame = centerX - ((playerX - worldX) / mapZoom * mapUnit)
	local mapRightFrame = centerX + ((worldX - playerX) / mapZoom * mapUnit)
	local mapTopFrame = centerY - ((worldY - playerY) / mapZoom * mapUnit)
	local mapBottomFrame = centerY + ((playerY - worldY) / mapZoom * mapUnit)
	
	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX))
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY))
	
	return centerX, centerY
end]]

function isMouseIn(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end

    cx,cy = getCursorPosition()
    cx,cy = cx*sW, cy*sH
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true, cx, cy
    else
        return false
    end
end

getResourceName(getThisResource(), true, 849716583); if true then return end