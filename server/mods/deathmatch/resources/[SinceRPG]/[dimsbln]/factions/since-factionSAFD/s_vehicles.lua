function setVehicleDesc(veh, text)
    local upgrades = getElementData(veh, "vehicle:upgrades") or {}
    upgrades['vopis'] = true
    upgrades['vopis:text'] = text
    setElementData(veh, "vehicle:upgrades", upgrades)
end


local vehicles = {

	{472, 1622.80, 572.19, 0.08, 2.4, 360.0, 90.8},

}

for i, v in ipairs(vehicles) do
	local vehicle = createVehicle(v[1], v[2], v[3], v[4])
	setElementRotation(vehicle, v[5], v[6], v[7])
	setVehicleVariant(vehicle, 2, 2)
	setElementFrozen(vehicle, true)
	setVehicleColor(vehicle, 255, 155, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0)
	setElementData(vehicle, 'vehicle:duty', 'SAFD')
	setElementData(vehicle, 'vehicle:rank', 1)
	setVehicleDesc(vehicle, '#ff0000San Andreas Fire Department')
end
