addEvent('ulecz', true)
addEventHandler('ulecz', resourceRoot, function(player)
	local x, y, z = getElementPosition(player)
	if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(client)) > 2) then
		return
	end
	tick = client:getData('leczenie_tick')
	if (tick and tick+1000*60*2 > getTickCount()) then
	else
		client:setData('leczenie_tick', getTickCount(), false)
	end
end)

local cooldown = {}

function giveSpray(player)
    if cooldown[player] then
        if getTickCount() - cooldown[player] < 1000 then
            return false
        end
    end
    if getElementData(player, 'player:faction') == 'SAFD' then
    	if getPedWeapon(player, 2) ~= 41 then
    		exports['since-notifications']:sendNotification(player, 'success', 'Wyciągasz spray')
    		giveWeapon(player, 41, 100000)
    		cooldown[player] = getTickCount()
    	else
    		exports['since-notifications']:sendNotification(player, 'info', 'Spray został schowany')
    		takeWeapon(player, 41)
    		cooldown[player] = getTickCount()
    	end
    end
end
addCommandHandler('spray', giveSpray)
