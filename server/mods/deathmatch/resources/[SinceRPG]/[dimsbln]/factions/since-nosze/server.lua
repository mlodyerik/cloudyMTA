object = {}
attach = {}
controls = {'jump', 'sprint', 'crouch', 'enter_exit', 'enter_passenger'}

addCommandHandler('nosze-pomoc', function(player, cmd)
	if getElementData(player, 'player:faction') == 'SAFD' then
		outputChatBox('Ⓘ #FFFFFF/nosze - rozstawia nosze / usuwa nosze', player, 255, 255, 0, true)
		outputChatBox('Ⓘ #FFFFFF/nosze-ustaw [id] - ustawia gracza na noszach', player, 255, 255, 0, true)
		outputChatBox('Ⓘ #FFFFFF/nosze-zdejmij [id] - zdejmuje gracza z noszy', player, 255, 255, 0, true)
	else
		outputChatBox('✘ #FFFFFFNie jesteś na służbie!', player, 255, 0, 0, true)
	end
end)

function stretcher(player, command)
	if getElementData(player, 'player:faction') == 'SAFD' then
		if getPedOccupiedVehicle(player) then
			return
		end
		if not getElementData(player, 'have:stretcher') then
			setElementData(player, 'have:stretcher', true)
			object[player] = Object(1997, 0, 0, 0)
			object[player]:attach(player, 0, 1.5, -1)
			object[player]:setCollisionsEnabled(false)
		else
			removeElementData(player, 'have:stretcher')
			if object[player] then
				destroyElement(object[player])
			end
		end
	end
end
addCommandHandler('nosze', stretcher)

function ustaw(player, cmd, target)
	if object[player] then
		if not attach[player] then
			if not target then
				exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza')
				return
			end
			local target = exports['since-core']:findPlayer(player, target)
			if not getElementData(player, 'have:stretcher') then
				exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz rozłożonych noszy!')
				return
			end
			if (player.position-Vector3(getElementPosition(target))).length < 5 then
				if not target.vehicle then
					target:attach(object[player], 0, -0.2, 2)
					attach[player] = target
						
					for _,control in ipairs(controls) do
						toggleControl(player, control, false)
					end
					local rotation = {getElementRotation(player)}
					target:setAnimation('CRACK', 'crckidle4', -1, true, false)
					Timer(function() triggerClientEvent(target, 'createRotationStretcher', root, target, object[player],true) end, 500, 1)
				else
					exports['since-notifications']:sendNotification(player, 'error', 'Podany gracz znajduje się w pojeździe, nie możesz wziąć go na nosze!')
				end
			else
				exports['since-notifications']:sendNotification(player, 'error', 'Znajdujesz się zbyt daleko od gracza, aby móc go wziąc na nosze!')
			end
		else
			exports['since-notifications']:sendNotification(player, 'error', 'Na tych noszach ktoś już się znajduje!')
		end
	else
		exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz rozłożonych noszy!')
	end
end
addCommandHandler('nosze-ustaw', ustaw)

function zdejmij(player, cmd, target)
	if object[player] then
		if attach[player] then
			for _,control in ipairs(controls) do
				toggleControl(player, control, true)
			end
			if not target then
				exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza')
				return
			end
			local target = exports['since-core']:findPlayer(player, target)
			target:detach(object[player])
			attach[player] = false
			triggerClientEvent(target, 'deleteRotationStretcher', root)
		else
			exports['since-notifications']:sendNotification(player, 'error', 'Na tych noszach nikt się nie znajduje!')
		end
	else
		exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz rozłożonych noszy!')
	end
end
addCommandHandler('nosze-zdejmij', zdejmij)

addEventHandler('onPlayerQuit', root, function(_,_,_)
local player=source
	if object[player] then
		if attach[player] then
			attach[player]:detach(object[player])
			triggerClientEvent(attach[player], 'deleteRotationStretcher', root)
			attach[player] = false
		end
		destroyElement(object[player])
	end
end)

function getTarget(player)
if not player then return end
if attach[player] then return attach[player] end
return false
end

function usun(player,target)
if not player then return end
if not target then return end
	if attach[player] then
			for _,control in ipairs(controls) do
				toggleControl(player, control, true)
			end
		target:detach(object[player])
		attach[player] = false
		triggerClientEvent(target, 'deleteRotationStretcher', root)
	end
	if getElementData(player, 'have:stretcher') then
			removeElementData(player, 'have:stretcher')
			if object[player] then
			destroyElement(object[player])
			end
	end
end
