local markers = {}
local active = {}

addEvent("createFactionMarker", true)
addEventHandler("createFactionMarker", resourceRoot, function(x, y, z, uid)
	if not active[uid] then
		markers[#markers + 1] = createMarker(x, y, z, "corona", 10, 255, 0, 0, 0)
		setElementData(markers[#markers], "marker:id", #markers)
		setElementData(markers[#markers], "marker:uid", uid)
		createBlipAttachedTo(markers[#markers], 41, 2, 255, 0, 0, 255, 0, 99999)

		active[uid] = true

		addEventHandler("onClientMarkerHit", markers[#markers], function(hitElement, matchingDimension)
			if hitElement and getElementType(hitElement) == "player" and matchingDimension then
				if getElementData(hitElement, "player:faction") then
					local markerID = getElementData(source, "marker:id")
					local markerUID = getElementData(source, "marker:uid")
					triggerServerEvent("onFactionMarkerHit", resourceRoot, markerID, markerUID)
				end
			end
		end)
	end
end)

addEvent("destroyFactionMarker", true)
addEventHandler("destroyFactionMarker", resourceRoot, function(markerID, uid)
	active[uid] = false

	if isElement(markers[markerID]) then
		destroyElement(markers[markerID])
	end
end)