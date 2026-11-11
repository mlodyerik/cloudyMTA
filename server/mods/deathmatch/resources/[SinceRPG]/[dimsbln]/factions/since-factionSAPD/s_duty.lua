  

createBlip(2065.87, -1887.88, 13.75,30,2,0,0,0,0,0,450)

local marker = createMarker(2059.12, -1887.22, 13.70-1, 'cylinder', 1.5, 0, 105, 255, 255)
setElementData(marker, 'marker:title', 'SAPD')
setElementData(marker, 'marker:desc', 'Służba SAPD')
setElementData(marker, 'marker:icon', 'skin')
setElementDimension(marker, 0)
setElementInterior(marker, 0)

addEventHandler('onMarkerHit', marker, function(plr, md)
	if not md then return end
	if getElementData(plr, 'player:faction') then
		if exports['since-factions']:stopDuty(plr, 'SAPD') then
			exports["since-zabezpieczenia"]:destroyObjects(plr)
			exports["since-kolczatka"]:removeCaltrop(plr)
		end
	else
		exports['since-factions']:startDuty(plr, 'SAPD')
	end
end)