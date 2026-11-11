local time = getTickCount()
local isBike={[509]=true,[481]=true,[510]=true}

local function naliczaj(veh)
	if getTickCount()-time>50 then
		time = getTickCount()
		local fuelData = getElementData(veh,'vehicle:fuel')
		local data = getElementData(veh,"vehicle:data")
		if not getElementData(veh, "vehicle:id") then return end
		local vx,vy,vz = getElementVelocity(veh)
		local spd=((vx^2 + vy^2 + vz^2)^(0.5)/2)

		if spd > 0 then
			fuelData.count = math.min(math.max(fuelData.count-(spd)/(15), 0), fuelData.tank)
			setElementData(veh, "vehicle:fuel", fuelData)
			data.mileage = data.mileage+(spd)/10
			setElementData(veh, "vehicle:data", data)
		end
	end
end

local function naliczajLPG(veh)
	if getTickCount()-time>50 then
		time = getTickCount()
		local fuelData = getElementData(veh,'vehicle:fuel')
		local data = getElementData(veh,"vehicle:data")
		if not getElementData(veh, "vehicle:id") then return end
		local vx,vy,vz = getElementVelocity(veh)
		local spd=((vx^2 + vy^2 + vz^2)^(0.5)/2)

		if spd > 0 then
			fuelData.countLPG = math.min(math.max(fuelData.countLPG-(spd)/(10), 0), fuelData.tank)
			setElementData(veh, "vehicle:fuel", fuelData)
			data.mileage = data.mileage+(spd)/10
			setElementData(veh, "vehicle:data", data)
		end
	end
end


setTimer(function()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then return end
    if not getElementData(vehicle, "vehicle:id") then return end
	if isBike[getElementModel(vehicle)] then return end
	if not getVehicleEngineState(vehicle) then return end

    if getElementData(vehicle,"vehicle:id") then
        if getElementData(vehicle, "vehicle:togglelpg") then 
            naliczajLPG(vehicle) 

            local fuel = getElementData(vehicle,'vehicle:fuel').countLPG

            if fuel < 1 then
                setVehicleEngineState(vehicle, false)
            end
        else
            naliczaj(vehicle)

            local fuel = getElementData(vehicle,'vehicle:fuel').count

            if fuel < 1 then
                setVehicleEngineState(vehicle, false)
            end
        end
    end
end, 1000, 0)


function noBoomCollision()
    local health = getElementHealth(source)
    if health <= 300 then
        setElementHealth(source, 301)
    end
end
addEventHandler('onVehicleDamage', root, noBoomCollision)
addEventHandler('onClientVehicleDamage', root, noBoomCollision)

setTimer(function()
	local x, y, z = getElementPosition(localPlayer)
    for k,v in pairs(getElementsWithinRange(x, y, z, 100, 'vehicle')) do
        local health = getElementHealth(v)
        if health <= 300 then
            setElementHealth(v, 301)
        end
    end
end, 300, 0)
getResourceName(getThisResource(), true, 184282023); if true then return end