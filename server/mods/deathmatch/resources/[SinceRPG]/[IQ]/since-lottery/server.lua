local marker = createMarker(1481.68, -1667.28, 13.27, "cylinder", 2, 125, 255, 125, 100)
setElementData(marker, 'marker:title', 'Loteria')
setElementData(marker, 'marker:desc', 'Loteria o samochód')

addEventHandler('onMarkerHit', marker, function(el, md)
    if (not md or getElementType(el) ~= 'player' or isPedInVehicle(el)) then return end

    local rows = exports['since-db']:query('SELECT * FROM `since-lottery` WHERE uid=?', getElementData(el, 'player:sid'))

    triggerClientEvent(el, 'since-lottery:show', resourceRoot, #rows)
end)

addEventHandler('onMarkerLeave', marker, function(el, md)
    if (getElementType(el) == 'player') then
        triggerClientEvent(el, 'since-lottery:hide', resourceRoot)
    end
end)

function getPlayerBankMoney(player)
    if (not isElement(player) or getElementType(player) ~= 'player') then return end

    local rows = exports['since-db']:query('SELECT `bankMoney` FROM `since-users` WHERE `uid`=?', getElementData(player, 'player:sid'))

    if (#rows > 0) then
        return rows[1].bankMoney
    end

    return 0
end

function addCommas(n)
    n = tostring(n)
    return n:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function takePlayerBankMoney(player, amount)
    if (not isElement(player) or getElementType(player) ~= 'player') then return end

    return exports['since-db']:query('UPDATE `since-users` SET `bankMoney`=`bankMoney`-? WHERE `uid`=?', amount, getElementData(player, 'player:sid'))
end

addEvent('since-lottery:buy', true)
addEventHandler('since-lottery:buy', resourceRoot, function()
    local player = client

    if (not isElement(player) or getElementType(player) ~= 'player') then return end
    
    local price = 1000000000

    if (getPlayerBankMoney(player) < price) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz wystarczającej ilości gotówki na koncie bankowym.')
    end

    takePlayerBankMoney(player, price)
    exports['since-notifications']:sendNotification(player, 'success', 'Zakupiłeś los na loterię o samochód.')
    exports['since-db']:query('INSERT INTO `since-lottery` SET `uid`=?', getElementData(player, 'player:sid'))
    triggerClientEvent(player, 'since-lottery:hide', resourceRoot)
    exports['since-logs']:sendDiscordLog('loteria', getPlayerName(player), 'UID: **'..getElementData(player, 'player:sid')..'** zakupił los na loterię o samochód. Pozostałe pieniądze: **$'..addCommas(getPlayerBankMoney(player))..'** Ilość zakupionych losów: **'..(#exports['since-db']:query('SELECT * FROM `since-lottery` WHERE uid=?', getElementData(player, 'player:sid')))..'**')
end)