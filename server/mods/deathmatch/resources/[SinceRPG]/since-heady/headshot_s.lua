  

function MakePlayerHeadshot( attacker, weapon, bodypart, loss )
	if attacker and getElementType ( attacker ) == "ped" then
		if bodypart == 9 then
			if getElementData(attacker, 'player:faction') == 'SAPD' and not getElementData(source, "player:god") and not getElementData(source, "player:job") and not getElementData(source, "player:admin") and not getElementData(source, 'temp:bw:ghost') and not getElementData(source, 'player:gz') then
			elseif getElementData(attacker, 'player:gang') and (getElementData(source, 'player:gang') or getElementData(source, "player:faction") == "SAPD") then
			else
				if (getElementData(source, "player:god") or getElementData(source, "player:job") or getElementData(source, "player:admin") or getElementData(source, 'temp:bw:ghost') or getElementData(source, 'player:gz')) or exports['since-dashboard']:isPlayerPassive(source) then
					BackUp( source )
					return
				end
			end
			triggerEvent( "onPlayerHeadshot", source, attacker, weapon, loss )
			setPedHeadless ( source, true )
			killPed( source, attacker, weapon, bodypart )
			setTimer( BackUp, 900, 1, source )
		end
	end
end

function MakeHeadshot( source, attacker, weapon, loss )
	if getElementData(attacker, 'player:faction') == 'SAPD' and not getElementData(source, "player:god") and not getElementData(source, "player:job") and not getElementData(source, "player:admin") and not getElementData(source, 'temp:bw:ghost') and not getElementData(source, 'player:gz') then
	elseif getElementData(attacker, 'player:gang') and (getElementData(source, 'player:gang') or getElementData(source, "player:faction") == "SAPD") then
	else
		if (getElementData(source, "player:god") or getElementData(source, "player:job") or getElementData(source, "player:admin") or getElementData(source, 'temp:bw:ghost') or getElementData(source, 'player:gz')) or exports['since-dashboard']:isPlayerPassive(source) then
			BackUp( source )
			return
		end
	end
	triggerEvent( "onPlayerHeadshot", source, attacker, weapon, loss )
	killPed( source, attacker, weapon, 9 )
	setPedHeadless ( source, true )
	setTimer( BackUp, 900, 1, source )
end

function BackUp( source )	
	if getElementType ( source ) == "player" then
		setPedHeadless ( source, false )
	end
end

function outputHeadshotIcon (killer, weapon, bodypart)
	if bodypart == 9 then
		cancelEvent()			
	end
end
addEvent ( "onServerHeadshot", true )
addEventHandler( "onPlayerDamage", getRootElement(), MakePlayerHeadshot )
addEventHandler( "onPlayerKillMessage", getRootElement(), outputHeadshotIcon )
addEventHandler( "onServerHeadshot", resourceRoot, MakeHeadshot )
