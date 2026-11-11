local losvagos = createMarker(1275.85, -800.37, 1089.94-1, 'cylinder', 1.2, 0, 122, 255)
setElementDimension(losvagos, 5237)
setElementInterior(losvagos, 5)
setElementData(losvagos, 'marker:title', 'Szafka')
setElementData(losvagos, 'marker:desc', 'Los Vagos')
setElementData(losvagos, 'marker:icon', 'tshirt')

function takeSkin(player)
    if source == losvagos then
        local orgData = getElementData(player, 'player:organization')
        if orgData.name == 'Los Vagos' then
            setElementModel(player, 173)
        else
            exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz tu odebrać skina organizacyjnego!')
        end
    end
end
addEventHandler('onMarkerHit', losvagos, takeSkin)
