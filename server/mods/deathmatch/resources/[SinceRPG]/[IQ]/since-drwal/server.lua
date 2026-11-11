local vehicles = {}

addEvent('onJobStart', true)
addEventHandler('onJobStart', resourceRoot, function ()
    if (not client or not isElement(client)) then return end

    local baseModel, isCustom = exports['since-custommodels']:checkModelID(80149, 'vehicle')
    
    local x, y, z, rotX, rotY, rotZ = unpack(Config.positions.spawn)

    vehicles[client] = createVehicle(baseModel, x, y, z, rotX, rotY, rotZ)
    setElementData(vehicles[client], 'baseID', baseModel)
    setElementData(vehicles[client], 'vehicleID', 80149)
    setElementData(vehicles[client], 'vehicle:model', 80149)
    setVehicleVariant(vehicles[client], 1, 2)
    setElementData(vehicles[client], 'vehicle:upgrades', {
        ['vopis:text'] = "Pojazd pracy drwal gracza "..getPlayerName(client)..""
    })

    warpPedIntoVehicle(client, vehicles[client])

    createBlipAttachedTo(vehicles[client], 0, 2, 255, 0, 0, 255, 0, 99999.0, client)

    setElementData(client, 'player:job', 'drwal')

    triggerClientEvent(client, 'onClientStartJob', resourceRoot)
end)

addEventHandler('onResourceStop', resourceRoot, function ()
    for i,v in pairs(getElementsByType('player')) do
        if (getElementData(v, 'player:job') == 'drwal') then
            setElementData(v, 'player:job', false)
        end
    end
end)

-- local rows = exports['since-db']:query('SELECT * FROM `since-users` ORDER BY `bankMoney` DESC LIMIT 20')

-- function addCommas(n)
--     return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
-- end

-- for i,v in pairs(rows) do
--     outputChatBox('['..i..'] '..v.nick..': $'..addCommas(v.bankMoney)..'', getPlayerFromName('xelvor'))
--     outputChatBox('['..i..'] '..v.nick..': $'..addCommas(v.bankMoney)..'', getPlayerFromName('tworix'))
--     outputChatBox('['..i..'] '..v.nick..': $'..addCommas(v.bankMoney)..'', getPlayerFromName('zevy'))
-- end

-- select * from since-users where bankmoney > 1000000000 and registerDate > 2024-12-19 19:03:59 order by bankmoney desc

-- local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE `wPLN` > 100 AND `registerDate` > "2024-12-19 19:03:59" ORDER BY `wPLN` DESC LIMIT 20')

-- function addCommas(n)
--     return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
-- end

-- for i,v in pairs(rows) do
--     outputChatBox('['..i..'] '..v.nick..': $'..addCommas(v.wPLN)..'', getPlayerFromName('xelvor'))
--     outputChatBox('['..i..'] '..v.nick..': $'..addCommas(v.wPLN)..'', getPlayerFromName('tworix'))
-- end

-- DELETE * FROM since-vehicles WHERE owner =6253 AND model=80150