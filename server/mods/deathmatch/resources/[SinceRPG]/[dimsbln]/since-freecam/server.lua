function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamEnabled", root, x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", root, dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", root, theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecam:state")
end

function enableFreecam (player)
	if getElementData(player, 'inTrunk') then
		return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz teraz tego zrobić!')
	end
    if (not isPlayerFreecamEnabled (player)) then 
        local x, y, z = getElementPosition (player)
        setPlayerFreecamEnabled (player, x, y, z) 
		setElementData(player, 'player:hudof', true)
		setElementFrozen(player, true)
    else 
        setPlayerFreecamDisabled (player) 
		setElementData(player, 'player:hudof', false)
		setCameraTarget(player, player)
		setElementFrozen(player, false)
    end 
end 
addCommandHandler('freecam', enableFreecam) 