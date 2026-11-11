addEventHandler('onClientPlayerDamage', root, function(attacker, weapon)
	if (weapon == 41) then
		cancelEvent()
	end
	if ((weapon == 41) and attacker) then
		local x, y, z = getElementPosition(localPlayer)
		if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(attacker)) > 2) then
			return
		end
		local health = getElementHealth(localPlayer) + 1
		if (health < 100) then
			setElementHealth(localPlayer, health)
			if (math.floor(health) == 99) then
				setElementHealth(localPlayer, 100)
				triggerServerEvent('healthPlayer', resourceRoot, attacker)
			end
		end
	end
end)