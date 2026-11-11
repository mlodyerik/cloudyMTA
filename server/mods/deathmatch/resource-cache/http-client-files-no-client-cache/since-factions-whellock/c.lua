local wheellock = {}



wheellock.getPosition = function(vehicle, type)
	if vehicle then
		local x, y, z = getVehicleComponentPosition(vehicle, "wheel_lf_dummy")
		local x2, y2, z2 = getVehicleComponentPosition(vehicle, "wheel_lf_dummy", "world")
		triggerServerEvent("callbackwheelposition", resourceRoot, vehicle, x,y,z,x2,y2,z2, type)
	end
end
addEvent("getWheelPosition", true)
addEventHandler("getWheelPosition", resourceRoot, wheellock.getPosition)