local loadedFactions = {}

addEventHandler('onResourceStart', resourceRoot, function ()
    for i,v in pairs(factions) do
        local faction = {}
        faction.markers = {}
        faction.blip = createBlip(v.blip.position[1], v.blip.position[2], v.blip.position[3], v.blip.id)

        faction.markers.start = createMarker(v.markers.startDuty[1], v.markers.startDuty[2], v.markers.startDuty[3], 'cylinder', 1.5, v.colors.rgb[1], v.colors.rgb[2], v.colors.rgb[3], 255)
        setElementData(faction.markers.start, 'marker:title', "Frakcja "..i)
        setElementData(faction.markers.start, 'marker:desc', "Wejscie na słuzbe")

        faction.markers.clothing = createMarker(v.markers.clothing[1], v.markers.clothing[2], v.markers.clothing[3], 'cylinder', 1.5, v.colors.rgb[1], v.colors.rgb[2], v.colors.rgb[3], 255)
        setElementData(faction.markers.clothing, 'marker:title', "Frakcja "..i)
        setElementData(faction.markers.clothing, 'marker:desc', "Zmiana ubrania")

        faction.markers.getVehicles = createMarker(v.markers.getVehicles[1], v.markers.getVehicles[2], v.markers.getVehicles[3], 'cylinder', 1.5, v.colors.rgb[1], v.colors.rgb[2], v.colors.rgb[3], 255)
        setElementData(faction.markers.getVehicles, 'marker:title', "Frakcja "..i)
        setElementData(faction.markers.getVehicles, 'marker:desc', "Pobranie pojazdow")

        faction.markers.returnVehicle = createMarker(v.markers.returnVehicle[1], v.markers.returnVehicle[2], v.markers.returnVehicle[3], 'cylinder', 4, v.colors.rgb[1], v.colors.rgb[2], v.colors.rgb[3], 255)
        setElementData(faction.markers.returnVehicle, 'marker:title', "Frakcja "..i)
        setElementData(faction.markers.returnVehicle, 'marker:desc', "Oddanie pojazdu")

        faction.markers.panel = createMarker(v.markers.panel[1], v.markers.panel[2], v.markers.panel[3], 'cylinder', 1.5, v.colors.rgb[1], v.colors.rgb[2], v.colors.rgb[3], 255)
        setElementData(faction.markers.panel, 'marker:title', "Frakcja "..i)
        setElementData(faction.markers.panel, 'marker:desc', "Zarządzanie frakcją")

        addEventHandler('onMarkerHit', faction.markers.start, function (player, md)
            if not md then return end
   
            if (isPlayerInDuty(player)) then
                stopDuty(player)
            else
                startDuty(player, i)
            end
        end)

        addEventHandler('onMarkerHit', faction.markers.clothing, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-clothing']:show(player, i)
            end
        end)

        addEventHandler('onMarkerLeave', faction.markers.clothing, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-clothing']:hide(player)
            end
        end)

        addEventHandler('onMarkerHit', faction.markers.getVehicles, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-parking']:show(player, i)
            end
        end)

        addEventHandler('onMarkerLeave', faction.markers.getVehicles, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-parking']:hide(player)
            end
        end)

        addEventHandler('onMarkerHit', faction.markers.returnVehicle, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-parking']:returnVehicle(player)
            end
        end)

        addEventHandler('onMarkerHit', faction.markers.panel, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-panel']:show(player, i)
            end
        end)

        addEventHandler('onMarkerLeave', faction.markers.panel, function (player, md)
            if not md then return end

            if (isPlayerInDuty(player)) then
                exports['since-factions-panel']:hide(player)
            end
        end)
    end
end)