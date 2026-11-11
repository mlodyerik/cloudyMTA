addCommandHandler('mapaev', function(player, cmd)
	if getAdmin(player) then
		setElementDimension(player, getElementData(player, 'player:sid'))
		exports['since-notifications']:sendNotification(player, 'success', 'Przeniosłeś(aś) się na mapę eventową ('..getElementData(player, 'player:sid')..')')
	end
end)