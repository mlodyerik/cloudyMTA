if (getPlayerName(localPlayer) == "xelvor") then
    sx, sy = guiGetScreenSize()
    zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

    Job = {}

    Job.info = {
        trees = 0,
        maxTrees = 10
    }

    local startMarker = createMarker(Config.markers.startJob[1], Config.markers.startJob[2], Config.markers.startJob[3], "cylinder", 1.5, 255, 255, 255, 150)
    setElementData(startMarker, "marker:title", "Praca dorywcza")
    setElementData(startMarker, "marker:desc", "Drwal")
    setElementData(startMarker, "marker:icon", "pack")

    addEventHandler("onClientMarkerHit", startMarker, function(hitElement, matchingDimension)
        if hitElement == localPlayer and matchingDimension then
            if isPedInVehicle(hitElement) then
                return
            end

            exports['since-jobs']:showJobGui('drwal', startMarker)
        end
    end)

    addEvent('onJobStart', true)
    addEventHandler('onJobStart', root, function(job)
        if job == 'drwal' then
            triggerServerEvent('onJobStart', resourceRoot)
        end
    end)
end