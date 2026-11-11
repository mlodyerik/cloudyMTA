local bronieFire = {
	[0] = true,
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[8] = true,
	[9] = true,
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true,
	[14] = true,
	[15] = true,
	[16] = true,
	[17] = true,
	[18] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[30] = true,
	[31] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[39] = true,
	[40] = true,
	[41] = true,
	[42] = true,
	[43] = true,
	[44] = true,
	[45] = true,
	[46] = true,
	[1008] = true,
	[1009] = true,
	[1010] = true,
}

local bronieAim = {
	[22] = true,
}

local blockVehicles = {

	[432] = true,
	[520] = true,
	[425] = true,

}
   
local napadCuboid = createColCuboid(356.39, -81.03, 995.51, 29.07, 26.27, 9.90)
local toggledDM = false

addCommandHandler('toggle.dm', function()
	if getElementData(localPlayer, 'player:admin') == 4 then
		toggledDM = not toggledDM

		if toggledDM then
			outputChatBox('Włączono tryb DM.')
		else
			outputChatBox('Wyłączono tryb DM.')
		end
	end
end)

setTimer(function()
	if toggledDM then
		toggleControl('aim_weapon', true)
		toggleControl('fire', true)
		toggleControl('action', true)
	elseif bronieAim[getPedWeapon(localPlayer)] then
		toggleControl('aim_weapon', true)
		toggleControl('fire', false)
		toggleControl('action', false)
	elseif getElementData(localPlayer, 'player:faction') == 'SAFD' then
		if getPedWeapon(localPlayer) == 9 then
			toggleControl('fire', true)
			toggleControl('aim_weapon', true)
			toggleControl('action', true)
		elseif getPedWeapon(localPlayer) == 42 then
			toggleControl('fire', false)
			toggleControl('aim_weapon', true)
			toggleControl('action', true)
		else
			toggleControl('fire', false)
			toggleControl('action', false)
			toggleControl('aim_weapon', false)
		end
	elseif (getElementData(localPlayer, 'player:job') or getElementData(localPlayer, 'player:admin') or getElementData(localPlayer, 'temp:bw:ghost')) then
        toggleControl('action',false)
		toggleControl('fire',false)

		if bronieAim[getPedWeapon(localPlayer)] then
			toggleControl('aim_weapon', true)
		else
			toggleControl('aim_weapon', false)
		end
	elseif isCursorShowing() then
		toggleControl('action', false)
		toggleControl('fire', false)
		toggleControl('aim_weapon', false)
		toggleControl('vehicle_fire', false)
		toggleControl('vehicle_secondary_fire', false)
	elseif getElementData(localPlayer, 'player:gz') then
        toggleControl('action', false)
		toggleControl('fire', false)
		toggleControl('aim_weapon', false)
	elseif getElementData(localPlayer, 'player:gang') then
		toggleControl('fire', true)
		toggleControl('aim_weapon', true)
		toggleControl('action', true)
		toggleControl('vehicle_fire', true)
		toggleControl('vehicle_secondary_fire', true)
	elseif not exports['since-dashboard']:isPlayerPassive(localPlayer) then
		toggleControl('fire', true)
		toggleControl('aim_weapon', true)
		toggleControl('action', true)
		toggleControl('vehicle_fire', true)
		toggleControl('vehicle_secondary_fire', true)
	elseif getElementData(localPlayer, 'player:faction') == 'SAPD' then
		toggleControl('action',true)
		toggleControl('fire',true)
		toggleControl('aim_weapon',true)
	elseif isElementInWater(localPlayer) then
		toggleControl('fire', true)
		toggleControl('aim_weapon', true)
		toggleControl('action', true)
	else
		toggleControl('vehicle_fire', false)
		toggleControl('fire', false)
		toggleControl('aim_weapon', false)
		toggleControl('vehicle_secondary_fire', false)
		toggleControl('action', false)
	end

	local veh = getPedOccupiedVehicle(localPlayer)
	if veh and blockVehicles[getElementModel(veh)] then
		toggleControl('vehicle_secondary_fire', false)
		toggleControl('vehicle_fire', false)
	end
end, 150, 0)

addEventHandler('onClientPlayerDamage', root, function(attacker)
	if attacker and getElementType(attacker) == 'player' and getPedWeapon(attacker) == 23 then
		return
	end
	
	if getElementData(source, 'player:god') or getElementData(source, 'player:gz') or getElementData(source, 'player:job') or getElementData(source, 'player:admin') or getElementData(source, 'temp:bw:ghost') then
		--print(math.random()..' #1')
		cancelEvent()
		return 
	end

	if not getElementData(source, 'player:gang') and exports['since-dashboard']:isPlayerPassive(source) then
		--print(math.random()..' #2')
		cancelEvent()
		return
	end

	if attacker and getElementType(attacker) == 'player' then
		if getElementData(attacker, 'player:faction') == 'SAPD' and not getElementData(source, 'player:god') and not getElementData(source, 'player:gz') and not getElementData(source, 'temp:bw:ghost') and not getElementData(source, 'player:job') then
			return
		end
		if getElementData(attacker, 'player:gang') then
			if (getElementData(source, 'player:faction') == 'SAPD' or getElementData(source, 'player:gang')) then
				if getElementData(source, 'player:god') or getElementData(source, 'player:gz') or getElementData(source, 'temp:bw:ghost') or getElementData(source, 'player:job') or exports['since-dashboard']:isPlayerPassive(source) then
					--print(math.random()..' #3')
				else
					return
				end
			else
				if getElementData(source, 'player:god') or getElementData(source, 'player:gz') or getElementData(source, 'temp:bw:ghost') or getElementData(source, 'player:job') or exports['since-dashboard']:isPlayerPassive(source) then
					--print(math.random()..' #4')
				else
					return
				end
			end
		else
			if getElementData(source, 'player:god') or getElementData(source, 'player:gz') or getElementData(source, 'temp:bw:ghost') or getElementData(source, 'player:job') or exports['since-dashboard']:isPlayerPassive(source) then
				--print(math.random()..' #5')
				cancelEvent()
				return
			else
				return
			end
		end
		-- if getElementData(attacker, 'player:gang') and (getElementData(source, 'player:faction') == 'SAPD' or getElementData(source, 'player:gang')) and not getElementData(source, 'player:god') and not getElementData(source, 'player:gz') and not getElementData(source, 'temp:bw:ghost') and not getElementData(source, 'player:job') and not exports['since-dashboard']:isPlayerPassive(source) then
		-- 	return
		-- end
		cancelEvent()
	end
end)
     
addEventHandler("onClientPlayerStealthKill", localPlayer, function()
	if getElementType(source) ~= 'vehicle' then
		return
	end
	
    if (getElementData(source, "player:god") or getElementData(source, "player:job") or getElementData(source, "player:admin") or getElementData(source, 'temp:bw:ghost')) or exports['since-dashboard']:isPlayerPassive(source) or not getElementData(source, 'player:gang') then
        cancelEvent()
    end
end)