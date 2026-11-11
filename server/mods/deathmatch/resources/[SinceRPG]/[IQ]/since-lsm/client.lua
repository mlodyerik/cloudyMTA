sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local marker = createMarker(config.positions.startJob[1], config.positions.startJob[2], config.positions.startJob[3], "cylinder", 1.5, 255, 0, 0, 150)
setElementData(marker, 'marker:title', 'Praca LSM')
setElementData(marker, 'marker:desc', 'Praca dorywcza')

addEventHandler('onClientMarkerHit', marker, function (hitElement, matchingDimension)
    if (hitElement == localPlayer and matchingDimension) then
        exports['since-jobs']:showJobGui('lsm', marker)
    end
end)

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'lsm' then
        triggerServerEvent('onJobStart', resourceRoot)
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'lsm' then
        triggerServerEvent('onJobFinish', resourceRoot)
    end
end)

-- addEventHandler('onClientVehicleStartExit', root, function (player, seat)
--     if job == 'lsm' then
--         cancelEvent()
--         exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz opuścić pojazdu w trakcie pracy')
--     end
-- end)