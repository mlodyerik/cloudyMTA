local recast = {}

function startRecast()
    local x,y,z = -12.74, 2346.31, 24.14
    recast["marker"] = createMarker(x,y,z-0.95, "cylinder", 2, 125, 255, 125, 155)
    setElementData(recast['marker'], 'marker:title', 'Przeróbka narkotyków')
    setElementData(recast['marker'], 'marker:desc', 'Przerób swój towar')
    setElementData(recast['marker'], 'marker:icon', 'skin')
    setElementData(recast["marker"], "recast.marker", true)
end
setTimer(startRecast, 1000, 1)

function getMaterials()
    triggerClientEvent(client, "recast.getMaterials:C", resourceRoot, getInventoryInfo(client, 'recast'))
end
addEvent("recast.getMaterials:S", true)
addEventHandler("recast.getMaterials:S", resourceRoot, getMaterials)

function changeToAnother(v)
    if (not v) then
        return
    end

    if string.find(v[1], 'top') then

        exports['since-inventory']:addPlayerItem(client, v[1], -v[2])
        exports['since-inventory']:addPlayerItem(client, string.gsub(v[1], 'top', 'recasted'), v[2])
        exports['since-notifications']:sendNotification(client, 'success', 'Przerobiłeś '..v[2]..' g. topów.')
        triggerClientEvent(client, "recast.getMaterials:C", resourceRoot, getInventoryInfo(client, 'recast'))

    elseif string.find(v[1], 'recasted') then

        exports['since-inventory']:addPlayerItem(client, v[1], -v[2])
        exports['since-inventory']:addPlayerItem(client, string.gsub(v[1], 'recasted', 'drug'), v[2])
        exports['since-notifications']:sendNotification(client, 'success', 'Przerobiłeś '..v[2]..' g. przerobionych topów.')
        triggerClientEvent(client, "recast.getMaterials:C", resourceRoot, getInventoryInfo(client, 'recast'))

    end
end
addEvent("recast.changeToAnother:S", true)
addEventHandler("recast.changeToAnother:S", resourceRoot, changeToAnother)
