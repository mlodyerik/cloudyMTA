local sh = [[
    texture gTexture;

    technique TextureReplace {
        pass Pass0 {
            Texture[0] = gTexture;
        }
    }
]]


function removeDefaultSmoke()
    SHADER = dxCreateShader(sh)
    TEX = dxCreateTexture(1, 1)
	dxSetShaderValue(SHADER, "gTexture", TEX)
	engineApplyShaderToWorldTexture(SHADER, "collisionsmoke")
end

local smokeVehicles = {}

local MIN_DRIFT_ANGLE = 4
local MAX_DRIFT_ANGLE = 200

local function detectVehicleDrift(vehicle)
	local velocity = vehicle.velocity
	local direction = vehicle.matrix.forward

	if velocity.length < 0.12 then 
		return 0, false
	end
	velocity = velocity:getNormalized()

	local angle = math.abs(math.deg(math.acos(velocity:dot(direction) / (velocity.length * direction.length))))
	if angle > MIN_DRIFT_ANGLE and angle < 110 then
		return angle
	end
	return false
end

local function checkVehicleOnGround(vehicle)
	local ox, oy, oz = vehicle:getComponentPosition("wheel_lb_dummy")
	local vehicleMatrix = vehicle.matrix
	local centerPosition1 = vehicleMatrix:transformPosition(0, oy, oz)
	local centerPosition2 = vehicleMatrix:transformPosition(0, oy, oz - 0.5)
	return not isLineOfSightClear(centerPosition1, centerPosition2, true, false, false, true, false)
end

local colors = {
	{255, 0, 0},
	{255, 165, 0},
	{255, 255, 0},
	{0, 128, 0},
	{0, 0, 255},
	{75, 0, 130},
	{238, 130, 238}
}

local frequency = 2

local disabledModels = {

	[573] = true,

}

function setSmokeColor(vehicle, r, g, b, r2, g2, b2)
	local upgrades = getElementData(vehicle, 'vehicle:upgrades') or {}

	upgrades['smokeColor'] = {r, g, b, r2, g2, b2}

	setElementData(vehicle, 'vehicle:upgrades', upgrades)

	return true
end

function getSmokeColor(vehicle)
	local upgrades = getElementData(vehicle, 'vehicle:upgrades') or {}

	return upgrades['smokeColor'] or {255, 255, 255, 255, 255, 255}
end

local function update()
	for vehicle, emitters in pairs(smokeVehicles) do
		if not disabledModels[vehicle.model] and isElementOnScreen(vehicle) then
			local upgrades = getElementData(vehicle, 'vehicle:upgrades') or {}

			-- Left wheel
			local vehicleMatrix = vehicle.matrix
			local ox, oy, oz = getVehicleComponentPosition(vehicle, "wheel_lb_dummy")				
			-- Right wheel
			local ox2, oy2, oz2 = getVehicleComponentPosition(vehicle, "wheel_rb_dummy")
			if ox and oy and oz and ox2 and oy2 and oz2 then
				local leftPosition = vehicleMatrix:transformPosition(ox, oy, oz)	
				local rightPosition = vehicleMatrix:transformPosition(ox2, oy2, oz2)
				exports["since-particles"]:setEmitterPosition(emitters.rightEmitter, rightPosition.x, rightPosition.y, rightPosition.z)
				exports["since-particles"]:setEmitterPosition(emitters.leftEmitter, leftPosition.x, leftPosition.y, leftPosition.z)
				exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "density", 0)
				exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "density", 0)
			end

			if getElementDimension(vehicle) == getElementDimension(localPlayer) and isVehicleOnGround(vehicle) then
				local driftAngle = detectVehicleDrift(vehicle)

				if driftAngle then
					local smokeMul = (driftAngle - MIN_DRIFT_ANGLE) / MAX_DRIFT_ANGLE
					if smokeMul > 1 then
						smokeMul = 1
					end
					local density = 0
					if smokeMul > 0 then
						density = 1
					end
					exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "density", density)
					exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "density", density)

					local sizeMul = 0.7 + smokeMul * 0.3
					local startSize = {1 * sizeMul, 2 * sizeMul}
					exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "startSize", startSize)
					exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "startSize", startSize)

					local endSize = {6 * sizeMul, 8 * sizeMul}
					exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "endSize", endSize)
					exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "endSize", endSize)

					local delay = 0.025 + (1 - smokeMul) * 0.03
					exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "delay", delay)
					exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "delay", delay)

					local alpha = smokeMul * 0.8 + 0.2 
					exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "alpha", alpha)
					exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "alpha", alpha)

					local color = false

					if upgrades['rgbsmoke'] then
						if upgrades['rgbsmoke'] then
							local curtime = getTickCount() / 1000
							r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
							g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
							b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)
					
							color = {r, g, b, r, g, b}
						end
					else
						if upgrades['smokeColor'] then
							color = upgrades['smokeColor']
						end
					end
					
					if color then
						exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "r", color[1])
						exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "r", color[4])

						exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "g", color[2])
						exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "g", color[5])

						exports["since-particles"]:setEmitterOption(emitters.leftEmitter, "b", color[3])
						exports["since-particles"]:setEmitterOption(emitters.rightEmitter, "b", color[6])										
					end
				end
			end
		end
	end
end

local blockedTypes = {

	['BMX'] = true,
	['Bike'] = true,
	['BMX'] = true,
	['Boat'] = true,
	['Plane'] = true,
	['Helicopter'] = true,
	['Train'] = true,
	['Trailer'] = true,
	['Monster Truck'] = true,
	['Quad'] = true,

}

local function addVehicleSmoke(vehicle)
	if not isElement(vehicle) or smokeVehicles[vehicle] then
		return false
	end

	if blockedTypes[getVehicleType(vehicle)] then
		return false
	end

	if not getElementData(vehicle, "vehicle:id") then
		return false
	end

	local options = {
		x = vehicle.position.x,
		y = vehicle.position.y,
		z = vehicle.position.z,

		density = 0.01,
		delay = 0.025,
		lifetime = {2, 3},
		fadeInAt = 0.1,

		startSize = 0,
		endSize = 0,

		forceZ = 1.2,
	}

	local leftEmitter = exports["since-particles"]:createEmitter(options)
	local rightEmitter = exports["since-particles"]:createEmitter(options)

	smokeVehicles[vehicle] = {
		leftEmitter = leftEmitter,
		rightEmitter = rightEmitter
	}

	return true
end

local function removeVehicleSmoke(vehicle)
	if not smokeVehicles[vehicle] then
		return false
	end
	exports["since-particles"]:destroyEmitter(smokeVehicles[vehicle].leftEmitter)
	exports["since-particles"]:destroyEmitter(smokeVehicles[vehicle].rightEmitter)
	smokeVehicles[vehicle] = nil
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	addEventHandler("onClientPreRender", root, update)
	removeDefaultSmoke()
end)

local enabled = true

local function refresh()
	if (not enabled) then
		return false
	end
	
    local x, y, z = getElementPosition(localPlayer)
    local vehs = getElementsWithinRange(x, y, z, 15, "vehicle")
    if vehs then
        for i,v in pairs(vehs) do
            if not blockedTypes[getVehicleType(v)] then
				if not smokeVehicles[v] then
					if getVehicleOccupants(v)[0] and getElementData(v, 'vehicle:id') then
						addVehicleSmoke(v)
					end
				else
					if smokeVehicles[v] then
						removeVehicleSmoke(v)
					end
				end
            end
        end
    end
end
refresh()
setTimer(refresh, 10000, 0)

function disable()
	enabled = false
	for i,v in pairs(smokeVehicles) do
		if (isElement(i)) then
			exports["since-particles"]:destroyEmitter(smokeVehicles[i].leftEmitter)
			exports["since-particles"]:destroyEmitter(smokeVehicles[i].rightEmitter)
			smokeVehicles[i] = nil
		end
	end
	engineRemoveShaderFromWorldTexture(SHADER, "collisionsmoke")
end

function enable()
	enabled = true
	dxSetShaderValue(SHADER, "gTexture", TEX)
	engineApplyShaderToWorldTexture(SHADER, "collisionsmoke")
end

function toggleSmoke(bool)
	if not bool then enable() else disable() end
end

addEventHandler("onClientElementStreamOut", root, function ()
	if (source.type == "vehicle" and enabled) then
		removeVehicleSmoke(source)
	end
end)

addEventHandler("onClientElementDestroy", root, function ()
	if (source.type == "vehicle" and enabled) then
		removeVehicleSmoke(source)
	end
end)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if (not enabled) then
		return false
	end
	if key == CONFIG_PROPERTY_NAME then
		for i, v in ipairs(getElementsByType("vehicle")) do
			if value and isElementStreamedIn(v) then
				addVehicleSmoke(v)
			else
				removeVehicleSmoke(v)
			end
		end
	end
end)