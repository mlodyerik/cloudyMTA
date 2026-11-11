addEventHandler('onResourceStart', resourceRoot, function ()
    local buyMarker = createMarker(Drugs.markers.buy[1], Drugs.markers.buy[2], Drugs.markers.buy[3], 'cylinder', 1.5, 255, 0, 0, 255)
    setElementData(buyMarker, 'marker:title', 'Wytwórnia narkotyków')
    setElementData(buyMarker, 'marker:desc', 'Wytwarzaj narkotyki')

    addEventHandler('onMarkerHit', buyMarker, function (hitElement, matchingDimension)
        if matchingDimension and getElementType(hitElement) == 'player' then
            triggerClientEvent(hitElement, 'onClientOpenDrugsWindowBuy', resourceRoot)
        end
    end)
end)

setTimer(function ()
    triggerClientEvent(getPlayerFromName('xelvor'), 'onClientOpenDrugsWindowBuy', resourceRoot)
end, 300, 1)