addEventHandler('onPlayerQuit', root, function(type)
	if getElementData(source, 'kajdany') then
		local vehicle = getPedOccupiedVehicle(source)
		if not vehicle then
			return false
		end
		exports['since-db']:query("INSERT INTO `since-jail` (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? hour,??,?)", getPlayerSerial(source), 1, 1, "SYSTEM - Logout w radiowozie")
	end
end)