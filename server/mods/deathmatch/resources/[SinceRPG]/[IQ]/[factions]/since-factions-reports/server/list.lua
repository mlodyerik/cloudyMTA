addEvent('since-factions-reports:getReports', true)
addEventHandler('since-factions-reports:getReports', resourceRoot, function ()
    triggerClientEvent(client, 'since-factions-reports:receiveReports', resourceRoot, reports)
end)

addEvent('since-factions-reports:acceptReport', true)
addEventHandler('since-factions-reports:acceptReport', resourceRoot, function (id)
    local report = reports[id]

    if (not report) then
        return
    end

    local player = report.player

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    table.remove(reports, id)

    exports['since-notifications']:sendNotification(player, 'success', 'Zgłoszenie zostało zaakceptowane.')

    outputChatBox('  ', player)
    outputChatBox('  ', player)
    outputChatBox("ⓘ#ffffff Twoje zgłoszenie zostało zaakceptowane przez frakcję.", player, 100, 175, 255, true)
    outputChatBox('  ', player)
    outputChatBox('  ', player)

    outputChatBox('  ', client)
    outputChatBox('  ', client)
    outputChatBox("ⓘ#ffffff Na mapie pojawił się znacznik z lokalizacją zgłoszenia.", client, 100, 175, 255, true)
    outputChatBox('  ', client)
    outputChatBox('  ', client)

    local x, y, z = getElementPosition(player)

    local blip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 99999.0, client)
    local colshape = createColSphere(x, y, z, 5)

    setElementData(colshape, 'colshape:blip', blip)
    setElementData(colshape, 'colshape:player', player)
    setElementData(colshape, 'colshape:client', client)

    triggerClientEvent(client, 'since-factions-reports:closeReport', resourceRoot)

    addEventHandler('onColShapeHit', colshape, function (element)
        if (getElementType(element) == 'player' and element == getElementData(colshape, 'colshape:client')) then
            destroyElement(blip)
            destroyElement(colshape)

            outputChatBox('  ', client)
            outputChatBox('  ', client)
            outputChatBox("ⓘ#ffffff Zgłoszenie zostało zakończone.", client, 100, 175, 255, true)
            outputChatBox('  ', client)
            outputChatBox('  ', client)
        end
    end)
end)

addEvent('since-factions-reports:rejectReport', true)
addEventHandler('since-factions-reports:rejectReport', resourceRoot, function (id)
    local report = reports[id]

    if (not report) then
        return
    end

    local player = report.player

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    table.remove(reports, id)

    exports['since-notifications']:sendNotification(player, 'error', 'Zgłoszenie zostało odrzucone.')

    outputChatBox('  ', player)
    outputChatBox('  ', player)
    outputChatBox("ⓘ#ffffff Twoje zgłoszenie zostało odrzucone przez frakcję.", player, 100, 175, 255, true)
    outputChatBox('  ', player)
    outputChatBox('  ', player)

    triggerClientEvent(client, 'since-factions-reports:closeReport', resourceRoot)
end)