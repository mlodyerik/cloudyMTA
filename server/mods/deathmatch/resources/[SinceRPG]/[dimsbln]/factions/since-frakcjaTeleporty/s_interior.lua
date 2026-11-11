wejsciedach = createMarker(2049.55, -1895.13, 13.70+1, 'arrow', 1.5, 255, 255, 0)
setElementDimension(wejsciedach, 0)
setElementInterior(wejsciedach, 0)
addEventHandler('onMarkerHit', wejsciedach, function(player)
    if getElementType(player) == 'player' then
        if getElementData(player, 'player:faction') == 'SAPD' then
            if isPedInVehicle(player) then
                return
            end
            setElementDimension(player, 0)
            setElementInterior(player, 0)
            setElementPosition(player, 2051.05, -1899.03, 24.31)
        end
    end
end)

zejsciedach = createMarker(2051.21, -1901.65, 24.31+1, 'arrow', 1.5, 255, 255, 0)
setElementDimension(zejsciedach, 0)
setElementInterior(zejsciedach, 0)
addEventHandler('onMarkerHit', zejsciedach, function(player)
    if getElementType(player) == 'player' then
        if getElementData(player, 'player:faction') == 'SAPD' then
            if isPedInVehicle(player) then
                return
            end
            setElementDimension(player, 0)
            setElementInterior(player, 0)
            setElementPosition(player, 2048.33, -1892.72, 13.70)
        end
    end
end)