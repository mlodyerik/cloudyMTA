local streamedVehicles = {}
local defaultVolume = 0.1
local mathMin, mathMax, mathRandom, mathFloor = math.min, math.max, math.random, math.floor

function haveTurbo(veh)
    local vehicleData = getElementData(veh, "vehicle:upgrades")

    if (vehicleData) then
        if (vehicleData.turbo) then
            return true
        end
    end

    return false
end

function isTurboSoundsEnabled()
    local playerSettings = getElementData(localPlayer, 'player:settings') or {}
    return playerSettings['turboSounds'] or false
end

local function preRender(dt)
    if isTurboSoundsEnabled() then 
        return
    end

	local cx, cy, cz = getCameraMatrix()
	
	for vehicle, data in pairs(streamedVehicles) do 
        if not isElement(vehicle) then 
            streamedVehicles[vehicle] = nil
            return
        end
        
		if (isElement(vehicle) and getVehicleEngineState(vehicle)) then
			local x, y, z = getElementPosition(vehicle)
			local distance = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
			
			if (distance < 140) then
				local plr = getVehicleController(vehicle)
                data.changedGear = false

                data.previousGear = data.previousGear or 1

                data.currentGear = getVehicleCurrentGear(vehicle)
                if (data.previousGear ~= data.currentGear) then
                    if (data.currentGear > data.previousGear) then
                        data.changedGear = "up"
                    else
                        data.changedGear = "down"
                    end
                end

                data.previousGear = data.currentGear
                

				
				data.throttle = plr and (getPedControlState(plr, "accelerate"))
                data.turboValue = data.turboValue or 0


				-- turbo 
				if data.throttle then 
					data.turboValue = mathMin( 0.5, data.turboValue+ 0.0008*dt )
                    data.tsh1 = false
				else 
					data.turboValue = mathMax( 0, data.turboValue - 0.0005*dt )
				end 
			
				-- dźwięki
				if not data.sounds then 
					data.sounds = {} 
					data.sounds[1] = playSound3D("sounds/turbo.wav", x, y, z, true)
				else 			
                    if not (data.throttle) then
                        if (data.turboValue >= 0.3 and not data.tsh1) then
                            data.sounds[2] = playSound3D("sounds/turbo_shift1.wav", x, y, z, false)
                            setSoundVolume(data.sounds[2], 0.025)
                            data.tsh1 = true
                        end
                    end

					local vol = data.turboValue*0.025
						
					if data.throttle then 
						vol = vol*1
					end
						
					setSoundVolume(data.sounds[1], mathMax(0, vol*2))
					setSoundSpeed(data.sounds[1], data.turboValue+0.8) 
					
					if (data.changedGear == "up" and data.throttle) then
						data.sounds[3] = playSound3D("sounds/turbo_shift2.wav", x, y, z, false)
						setSoundVolume(data.sounds[3], 0.025)
						
						if not data.throttle then 
							data.turboValue = 0
						end
					end
					
					for i=1, #data.sounds do
						local v = data.sounds[i] 
						if isElement(v) then
							setElementPosition(v, x, y, z)
							if vehicle == getPedOccupiedVehicle(localPlayer) then 
								setSoundMaxDistance(v, 70*2)
							else 
								setSoundMaxDistance(v, 70)
							end
						end
					end
				end
			end
        else 
            if data.sounds then 
                for k, v in pairs(data.sounds) do 
                    if isElement(v) then 
                        destroyElement(v)
                    end
                end
                data.sounds = false
            end
		end
	end
end
addEventHandler("onClientPreRender", root, preRender)

addEventHandler('onClientElementDestroy', root, function()
    if (getElementType(source) == "vehicle") then
        if (streamedVehicles[source]) then
            if streamedVehicles[source].sounds then 
                for k, v in pairs(streamedVehicles[source].sounds) do 
                    if isElement(v) then 
                        destroyElement(v)
                    end
                end
                streamedVehicles[source].sounds = false
            end
            streamedVehicles[source] = nil
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if (getElementType(source) == "vehicle") then
        if (haveTurbo(source) and not streamedVehicles[source]) then
            streamedVehicles[source] = {}
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if (getElementType(source) == "vehicle") then
        if (streamedVehicles[source]) then
            streamedVehicles[source] = nil
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for i,v in ipairs(getElementsByType("vehicle")) do
        if (isElementStreamedIn(v)) then
            if (haveTurbo(v)) then
                streamedVehicles[v] = {}
            end
        end
    end
end)
getResourceName(getThisResource(), true, 965265747); if true then return end
