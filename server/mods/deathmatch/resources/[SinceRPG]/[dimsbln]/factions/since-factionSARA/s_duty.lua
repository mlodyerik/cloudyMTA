  

createBlip(1784.28, -1710.69, 13.52,11,2,0,0,0,0,0,450)

local marker = createMarker(1784.28, -1710.69, 13.52-1, 'cylinder', 1.5, 125, 255, 125, 55)
setElementData(marker, 'marker:title', 'SARA')
setElementData(marker, 'marker:desc', 'Służba SARA')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler('onMarkerHit', marker, function(plr, md)
	if not md then return end
	if getElementData(plr, 'player:faction') then
		if exports['since-factions']:stopDuty(plr, 'SARA') then
			exports["since-zabezpieczenia"]:destroyObjects(plr)
			exports["since-kolczatka"]:removeCaltrop(plr)
		end
	else
		exports['since-factions']:startDuty(plr, 'SARA')
	end
end)