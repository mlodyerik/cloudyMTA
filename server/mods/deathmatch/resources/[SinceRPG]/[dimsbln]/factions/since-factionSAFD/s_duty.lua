  

local blip = createBlip(851.65, 1917.08, 10.82, 20,2,0,0,0,0,0,275)      

local marker = createMarker(851.65, 1917.08, 10.82-1, 'cylinder', 1.5, 125, 255, 125, 55)
setElementData(marker, 'marker:title', 'SAFD')
setElementData(marker, 'marker:desc', 'Służba SAFD')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler('onMarkerHit', marker, function(plr, md)
	if not md then return end
	if getElementData(plr, 'player:faction') then
		if exports['since-factions']:stopDuty(plr, 'SAFD') then
			exports["since-zabezpieczenia"]:destroyObjects(plr)
		end
	else
		exports['since-factions']:startDuty(plr, 'SAFD')
	end
end)