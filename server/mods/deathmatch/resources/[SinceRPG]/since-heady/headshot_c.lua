  

function sendHeadshot ( attacker, weapon, bodypart, loss )
	if attacker == getLocalPlayer() then
		if bodypart == 9 then
			if getElementData(attacker, "player:faction") == "SAPD" then
			else
				if getElementData(attacker, 'player:gang') then
					if not getElementData(source, 'player:gang') and exports['since-dashboard']:isPlayerPassive(source) then
						cancelEvent()
						print(math.random()..' #1')
						return
					end
				else
					if exports['since-dashboard']:isPlayerPassive(source) then
						cancelEvent()
						print(math.random()..' #2')
						return
					end
				end
			end

			if (getElementData(source, "strefa:bank") and getElementData(attacker, "player:faction") == "SAPD") then
				triggerServerEvent( "onServerHeadshot", resourceRoot, source, attacker, weapon, loss)
				setElementHealth ( source, 0 )
				setPedHeadless( source, true )

				local playerData = getElementData(attacker, 'player:data') or {}
				playerData.respekt = (playerData.respekt or 0) + 2
				setElementData(attacker, 'player:data', playerData)

				local playerData = getElementData(source, 'player:data') or {}
				playerData.respekt = (playerData.respekt or 0) - 2
				setElementData(source, 'player:data', playerData)
				return false
			end

			if (getElementData(source, "admin:antykill") == true or getElementData(source, "strefa:bank")) then 
				return
			end

			local attackerOrg = getElementData(attacker, 'player:organization')
			local sourceOrg = getElementData(source, 'player:organization')
			
			if not getElementData(source, 'player:arena') then
				if sourceOrg and attackerOrg then
					if (sourceOrg.id == attackerOrg.id) then
						cancelEvent()
						return
					end
				end
			end

			triggerServerEvent( "onServerHeadshot", resourceRoot, source, attacker, weapon, loss )
			setElementHealth ( source, 0 )
			setPedHeadless( source, true )
			local playerData = getElementData(attacker, 'player:data') or {}
			playerData.respekt = (playerData.respekt or 0) + 2
			setElementData(attacker, 'player:data', playerData)

			local playerData = getElementData(source, 'player:data') or {}
			playerData.respekt = (playerData.respekt or 0) - 2
			setElementData(source, 'player:data', playerData)
		end
	end
end
addEventHandler ( "onClientPedDamage", getRootElement(), sendHeadshot )
addEventHandler ( "onClientPlayerDamage", getRootElement(), sendHeadshot )

getResourceName(getThisResource(), true, 540824815); if true then return end