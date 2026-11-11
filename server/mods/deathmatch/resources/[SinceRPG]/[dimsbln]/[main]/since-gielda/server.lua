addEvent('getPlayerVehicles',true)
addEventHandler('getPlayerVehicles',resourceRoot,function(plr,trigger)
    local vehicles = {}

    local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE owner = ?', getElementData(plr, 'player:sid'))

    if (#rows > 0) then
        for i,v in pairs(rows) do
            table.insert(vehicles, v)
        end
    end

    triggerClientEvent(plr, trigger and trigger or 'getPlayerVehicles', plr, vehicles)
end)

addEvent('sendPlayerGieldaTransaction',true)
addEventHandler('sendPlayerGieldaTransaction',resourceRoot,function(plr, target, vehicle, cost)
    local isOnline = findPlayer(plr, target)
    
    if isOnline then
        local data = {

            from = plr,
            vehicle = vehicle,
            cost = cost,

        }
        
        triggerClientEvent(target, 'showPlayerGieldaOffer', target, data)
    end
end)

addEvent('sendPlayerInfo',true)
addEventHandler('sendPlayerInfo', resourceRoot, function(target, type)
    if not findPlayer(client, target) then 
        return 
    end

    local text = ''

    if type == 1 then
        type = 'error'
        text = 'Gracz #f2ff42'..getPlayerName(client)..'#ffffff nie zaakceptował twojej oferty na czas.'
    elseif type == 2 then
        type = 'error'
        text = 'Gracz #f2ff42'..getPlayerName(client)..'#ffffff odrzucił twoją ofertę!'
    end

    exports['since-notifications']:sendNotification(target, type, text)
end)

function getPlayerBankMoney(plr)
    local result = exports['since-db']:query('SELECT bankMoney FROM `since-users` WHERE uid = ?', getElementData(plr, 'player:sid'))

    if result and #result > 0 then
        return result[1].bankMoney
    end

    return 0
end

function takePlayerBankMoney(plr, amount)
    local money = getPlayerBankMoney(plr)

    if money >= amount then
        exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney - ? WHERE uid = ?', amount, getElementData(plr, 'player:sid'))
        return true
    end

    return false
end

function givePlayerBankMoney(plr, amount)
    exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney + ? WHERE uid = ?', amount, getElementData(plr, 'player:sid'))
end

addEvent('acceptGieldaOffer',true)
addEventHandler('acceptGieldaOffer', resourceRoot, function(plr, data)
    local isOnline = findPlayer(plr, data.from)

    if isOnline then
        local money = getPlayerBankMoney(plr)
        local cost = tonumber(data.cost)

        if cost < money then
            takePlayerBankMoney(plr, cost)
            givePlayerBankMoney(data.from, cost)
            setVehicleOwner(plr, data.vehicle)

            exports['since-notifications']:sendNotification(plr, 'info', 'Zakupiłeś pojazd #7db5ff'..exports['since-vehiclenames']:getVehicleName(data.vehicle.model)..'#ffffff od gracza #f2ff42'..getPlayerName(data.from)..'#ffffff za kwotę #82fa8e$ '..addCommas(data.cost))
            exports['since-notifications']:sendNotification(data.from, 'info', 'Sprzedano pojazd #7db5ff'..exports['since-vehiclenames']:getVehicleName(data.vehicle.model)..'#ffffff za kwotę #82fa8e$ '..addCommas(data.cost)..'#ffffff. Kupujący #f2ff42'..getPlayerName(plr))
            exports['since-logs']:sendDiscordLog('gielda', 'Wymieniarka', '`'..getPlayerName(data.from)..'` (UID: `'..getElementData(data.from, 'player:sid')..'`) sprzedał(a) pojazd `'..exports['since-vehiclenames']:getVehicleName(data.vehicle.model)..'` (ID: `'..data.vehicle.id..'`) dla gracza `'..getPlayerName(plr)..'` (UID: `'..getElementData(plr, 'player:sid')..'`) za kwotę `$ '..addCommas(data.cost)..'`')
            --exports['since-logs']:sendDiscordLog('gielda', getPlayerName(client), 'Zakupił pojazd `'..name..' (ID: '..getElementData(veh, 'vehicle:id')..')` za `'..addCommas(price)..' $`'..(plr and ' od `'..getPlayerName(plr)..' `' or ' UID właściciela: `'..owner..'`'))
            --exports['since-logs']:sendDiscordLog('gielda', getPlayerName(plr), 'Zakupił pojazd `'..exports['since-vehiclenames']:getVehicleName(data.vehicle.model)..' (ID: '..vehicle.id..')` za `'..addCommas(data.cost)..' $` od `'..getPlayerName(data.from)..'`')
        else
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz tyle gotówki')
        end
    else
        return exports['since-notifications']:sendNotification(plr, 'error', 'Sprzedający opuścił serwer')
    end
end)

addEvent("buyGieldaOfflineCar", true)
addEventHandler("buyGieldaOfflineCar", resourceRoot, function(veh)
    local sid = getElementData(client, "player:sid")
    local owner = getElementData(veh, "vehicle:owner")

    if not owner or not sid then return end

    local price = getElementData(veh, "vehicle:gielda").price
    if getPlayerBankMoney(client) < price then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz tyle gotówki')
    end

    if sid == owner then
        return exports["since-notifications"]:sendNotification(client, "error", "Nie możesz kupić swojego pojazdu")
    end

    local name = exports['since-vehiclenames']:getVehicleName(getElementData(veh, 'vehicle:model'))

    takePlayerBankMoney(client, price)
    setVehicleOwnerOffline(client, veh)
    setElementData(veh, "vehicle:gielda", false)
    exports["since-db"]:query("UPDATE `since-users` SET bankMoney=bankMoney+"..(tonumber(price) or 0).." WHERE uid="..tonumber(owner).."")
    exports["since-notifications"]:sendNotification(client, "success", "Zakupiłeś pojazd #7db5ff" .. name .. "#ffffff za #82fa8e$ " .. addCommas(price) .. "")

    local plr = findPlayerBySid(owner)
    if plr then
        exports["since-notifications"]:sendNotification(plr, "success", "Twój pojazd #7db5ff" .. name .. "#ffffff sprzedał się za #82fa8e$ " .. addCommas(price) .. "#ffffff. Pieniądze zostały dodane na twoje konto bankowe")
    end

    warpPedIntoVehicle(client, veh)
    
    exports['since-logs']:sendDiscordLog('gielda', getPlayerName(client), 'Zakupił pojazd `'..name..' (ID: '..getElementData(veh, 'vehicle:id')..')` za `'..addCommas(price)..' $`'..(plr and ' od `'..getPlayerName(plr)..' `' or 'UID właściciela: `'..owner..'`'))
end)

function findPlayerBySid(sid)
    for k,v in pairs(getElementsByType("player")) do
        if getElementData(v, "player:sid") == sid then
            return v
        end
    end
end

function setVehicleOwner(plr, vehicle)
    local ownerSID = getElementData(plr, 'player:sid')

    exports['since-db']:query('UPDATE `since-vehicles` SET owner = ? WHERE id=?', ownerSID, vehicle.id)

    for i, v in ipairs(getElementsByType('vehicle')) do
        if vehicle.id == getElementData(v, 'vehicle:id') then
            setElementData(v, 'vehicle:owner', ownerSID)
        end
    end
end

function setVehicleOwnerOffline(plr, vehicle)
    local ownerSID = getElementData(plr, 'player:sid')

    exports['since-db']:query('UPDATE `since-vehicles` SET owner = ? WHERE id=?', ownerSID, getElementData(vehicle, 'vehicle:id'))

    for i, v in ipairs(getElementsByType('vehicle')) do
        if getElementData(vehicle, 'vehicle:id') == getElementData(v, 'vehicle:id') then
            setElementData(v, 'vehicle:owner', ownerSID)
        end
    end
end

function findPlayer(player, target)
    local online = false

    for i, v in ipairs(getElementsByType('player')) do
        if v == target then
            online = true
            break
        end
    end

    return online
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

addEventHandler('onColShapeLeave', resourceRoot, function(veh, md)
    if getElementType(veh) ~= 'vehicle' or not md then return end
    if veh and getElementData(veh, 'vehicle:gielda') then
        setElementData(veh, 'vehicle:gielda', nil)
    end
end)

local hitted = {}

addEventHandler('onColShapeHit', resourceRoot, function(element, md)
    if getElementType(element) ~= 'player' or not md then
        return
    end

    local info = {}
    local veh = getPedOccupiedVehicle(element)

    if veh then
        if getElementHealth(veh) < 900 then
            info['broken'] = true
        end
    end

    if not hitted[element] then
        hitted[element] = true

        outputChatBox(' ', element, 85, 185, 255, true)
        outputChatBox('✉#ffffff Witaj na giełdzie, zapoznaj się z regulaminem na forum w dziale "Giełda".', element, 85, 185, 255, true)
        outputChatBox('✉#ffffff Dział giełdy na forum: #b8b8b8https://www.since-mta.pl/index.php?/forum/37-gie%C5%82da/', element, 85, 185, 255, true)
        outputChatBox('✉#ffffff Spis giełd na serwerze: #b8b8b8https://www.since-mta.pl/index.php?/topic/1345-spis-gie%C5%82d-na-serwerze/#comment-5391', element, 85, 185, 255, true)
        
        if info['broken'] then
            outputChatBox('✉#ffffff Poruszasz się niesprawnym pojazdem, napraw go.', element, 255, 175, 0, true)
        end
        
        outputChatBox(' ', element, 85, 185, 255, true)
    else
        if info['broken'] then
            outputChatBox(' ', element, 85, 185, 255, true)
            outputChatBox('✉#ffffff Poruszasz się niesprawnym pojazdem, napraw go.', element, 255, 175, 0, true)
            outputChatBox(' ', element, 85, 185, 255, true)
        end
    end
end)