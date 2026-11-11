  
local marker = createMarker(-2032.89, -117.44, 1034.17, 'cylinder', 1.5, 125, 255, 125, 55)
setElementData(marker, 'marker:title', 'TSA')
setElementData(marker, 'marker:desc', 'Służba TSA')
setElementData(marker, 'marker:icon', 'skin')
setElementDimension(marker, 0)
setElementInterior(marker, 3)

addEventHandler('onMarkerHit', marker, function(plr, md)
	if not md then return end
	if getElementData(plr, 'player:faction') then
		if exports['since-factions']:stopDuty(plr, 'TSA') then
			exports["since-zabezpieczenia"]:destroyObjects(plr)
			exports["since-kolczatka"]:removeCaltrop(plr)
		end
	else
		exports['since-factions']:startDuty(plr, 'TSA')
	end
end)