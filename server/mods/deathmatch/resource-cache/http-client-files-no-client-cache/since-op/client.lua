-- local sx, sy = guiGetScreenSize() 
-- local zoom = sx < 1920 and math.min(2, 1920 / sx) or 1

-- local cache = {}
-- local cooldown = 1 -- czas w minutach cooldownu co ile mozna uzywac komendy

-- local textures = {
-- 	['j'] = dxCreateTexture('data/keyboard_j.png', 'argb', false, 'clamp'),
-- 	['m'] = dxCreateTexture('data/keyboard_m.png', 'argb', false, 'clamp'),
-- 	['b'] = dxCreateTexture('data/keyboard_b.png', 'argb', false, 'clamp'),
-- 	['h'] = dxCreateTexture('data/keyboard_h.png', 'argb', false, 'clamp'),
-- }

-- local allowedKeys = {'j', 'm', 'b', 'h'}
-- scale = 1
-- progress = 0
-- actualkey = 'j'
-- function render()
-- 	if cache.vehicle and isElement(cache.vehicle) then 
-- 		if getKeyState(actualkey) then 
-- 			scale = 1.1
-- 		else
-- 			scale = 1
-- 		end
-- 		dxDrawImage(sx/2-((58*scale)/2)/zoom, sy-194/zoom, (58*scale)/zoom, (58*scale)/zoom, textures[actualkey] or textures['n'], 0, 0, 0, tocolor(255, 255, 255, 255))
-- 		dxDrawText('Klikaj klawisz', sx/2, sy-125/zoom, sx/2, sy-115/zoom, tocolor(125, 255, 125, 242), 1/zoom, exports['since-fonts']:getFont('Inter-Medium', 20/zoom), 'center')
-- 		dxDrawText('Aby obrócić pojazd ('..progress..'%)', sx/2, sy-95/zoom, sx/2, sy-90/zoom, tocolor(185, 185, 185, 219), 1/zoom, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center')


-- 		local x,y,z = getElementPosition(cache.vehicle)
-- 		local x1, y1, z1 = getElementPosition(localPlayer)
-- 		if getDistanceBetweenPoints3D(x, y, z, x1, y1, z1) > 4 then 
-- 			closeUI()
-- 		end
-- 	else
-- 		closeUI()
-- 	end
-- end

-- function drawKey()
-- 	local r = math.random(1, 10)
-- 	if r == 1 then 
-- 		actualkey = allowedKeys[math.random(1, #allowedKeys)]
-- 	end
-- end

-- function bind(key)
-- 	if key == actualkey then 
-- 		drawKey()
-- 		progress = progress+(math.random(5, 9))
-- 		if progress >= 100 then 
-- 			triggerServerEvent('rotateVehicle', getResourceRootElement(), cache.vehicle)
-- 			closeUI()
-- 			tick = getTickCount()
-- 		end
-- 	end
-- end


-- function showUI()
-- 	addEventHandler('onClientRender', root, render)
-- 	addEventHandler('onClientKey', root, bind)
-- end

-- function closeUI()
-- 	removeEventHandler('onClientRender', root, render)
-- 	removeEventHandler('onClientKey', root, bind)
-- 	cache.vehicle = nil 
-- end

-- addCommandHandler('op', function(cmd)
-- 	if getPedOccupiedVehicle(localPlayer) then return end 
--     if not getNearestVehicle(localPlayer, 4) then exports['since-notifications']:sendNotification('error', 'Nie znaleziono żadnego pojazdu w pobliżu') return end 
-- 	cache.vehicle = getNearestVehicle(localPlayer, 4)
--     local rx, ry, rz = getElementRotation(cache.vehicle)
--     if not tick or tick < getTickCount()-cooldown*60000 then 
--         if rx >= 180 then 
-- 			showUI()
--         else
--             exports['since-notifications']:sendNotification('error', 'Pojazd nie wymaga obrócenia')
--             return 
--         end
-- 	else
-- 		exports['since-notifications']:sendNotification('error', 'Obracać pojazd możesz co 60 sekund')
-- 		return 
--     end
-- end)

-- function getNearestVehicle(player,distance)
-- 	local tempTable = {}
-- 	local lastMinDis = distance-0.0001
-- 	local nearestVeh = false
-- 	local px,py,pz = getElementPosition(player)
-- 	local pint = getElementInterior(player)
-- 	local pdim = getElementDimension(player)

-- 	for _,v in pairs(getElementsByType("vehicle")) do
-- 		local vint,vdim = getElementInterior(v),getElementDimension(v)
-- 		if vint == pint and vdim == pdim then
-- 			local vx,vy,vz = getElementPosition(v)
-- 			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
-- 			if dis < distance then
-- 				if dis < lastMinDis then 
-- 					lastMinDis = dis
-- 					nearestVeh = v
-- 				end
-- 			end
-- 		end
-- 	end
-- 	return nearestVeh
-- end
