p_lights = {}
p_timer = {}
p_lvar = {}
p_pvar = {}
p_lvar2 = {}
p_lvar3 = {}
p_lvar4 = {}






function toggleLights(thePlayer, cmd)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh then return end
	if getElementData(veh,"vehicle:faction") and getElementData(thePlayer, "player:faction") == "SAPD" then
			if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
				p_pvar[veh] = 1
				p_lights[veh] = 1
				setVehicleOverrideLights ( veh, 2 )
				
				p_timer[veh] = setTimer( function()
					if(p_lvar[veh] == 0) or (p_lvar[veh] == nil) then
						p_lvar[veh] = 1
						setVehicleLightState ( veh, 1, 0)
						setVehicleLightState ( veh, 2, 0)
						setVehicleLightState ( veh, 0, 1)
						setVehicleLightState ( veh, 3, 1)
						setVehicleHeadLightColor(veh, 0, 0, 255)
					else
						setVehicleLightState ( veh, 3, 0)
						setVehicleLightState ( veh, 0, 0)
						setVehicleLightState ( veh, 1, 1)
						setVehicleLightState ( veh, 2, 1)	
						setVehicleHeadLightColor(veh, 255, 0, 0)
						p_lvar[veh] = 0
					end
				end, 240, 0)
				else
					p_lights[veh] = 0
					killTimer(p_timer[veh])
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 3, 0)	
					setVehicleHeadLightColor(veh, 255, 255, 255)
					setVehicleOverrideLights ( veh, 2 )
				end
	elseif getElementData(veh,"vehicle:faction") and getElementData(thePlayer, "player:faction") == "SARA" then
			if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
				p_pvar[veh] = 1
				p_lights[veh] = 1
				setVehicleOverrideLights ( veh, 2 )
				
				p_timer[veh] = setTimer( function()
					if(p_lvar[veh] == 0) or (p_lvar[veh] == nil) then
						p_lvar[veh] = 1
						setVehicleLightState ( veh, 1, 0)
						setVehicleLightState ( veh, 2, 0)
						setVehicleLightState ( veh, 0, 1)
						setVehicleLightState ( veh, 3, 1)
						setVehicleHeadLightColor(veh, 255, 155, 0)
					else
						setVehicleLightState ( veh, 3, 0)
						setVehicleLightState ( veh, 0, 0)
						setVehicleLightState ( veh, 1, 1)
						setVehicleLightState ( veh, 2, 1)	
						setVehicleHeadLightColor(veh, 255, 255, 255)
						p_lvar[veh] = 0
					end
				end, 240, 0)
				else
					p_lights[veh] = 0
					killTimer(p_timer[veh])
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 3, 0)	
					setVehicleHeadLightColor(veh, 255, 255, 255)
					setVehicleOverrideLights ( veh, 2 )
				end
		elseif getElementData(veh,"vehicle:faction") and getElementData(thePlayer, "player:faction") == "SAFD" then
			if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
				p_pvar[veh] = 1
				p_lights[veh] = 1
				setVehicleOverrideLights ( veh, 2 )
				
				p_timer[veh] = setTimer( function()
					if(p_lvar[veh] == 0) or (p_lvar[veh] == nil) then
						p_lvar[veh] = 1
						setVehicleLightState ( veh, 1, 0)
						setVehicleLightState ( veh, 2, 0)
						setVehicleLightState ( veh, 0, 1)
						setVehicleLightState ( veh, 3, 1)
						setVehicleHeadLightColor(veh, 255, 255, 255)
					else
						setVehicleLightState ( veh, 3, 0)
						setVehicleLightState ( veh, 0, 0)
						setVehicleLightState ( veh, 1, 1)
						setVehicleLightState ( veh, 2, 1)	
						setVehicleHeadLightColor(veh, 252, 3, 3)
						p_lvar[veh] = 0
					end
				end, 240, 0)
				else
					p_lights[veh] = 0
					killTimer(p_timer[veh])
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 3, 0)	
					setVehicleHeadLightColor(veh, 255, 255, 255)
					setVehicleOverrideLights ( veh, 2 )
				end
			end
		end

for key, value in ipairs(getElementsByType("player")) do
bindKey(value,"n","down",toggleLights)
end

addEventHandler("onPlayerJoin",root,function ()
bindKey(source,"n","down",toggleLights)
end)



addEventHandler ( "onVehicleExplode", getRootElement(), 
function()
	if(p_lights[source] == 1) then
		killTimer(p_timer[source])	
	end
end )

addEventHandler ( "onVehicleRespawn", getRootElement(), 
function()
	if(p_lights[source] == 1) then
		killTimer(p_timer[source])	
	end
end )

addEventHandler("onElementDestroy", getRootElement(), 
function ()
	if getElementType(source) == "vehicle" then
		if(p_lights[source] == 1) then
			killTimer(p_timer[source])
		end
	end
end)
