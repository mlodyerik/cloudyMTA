function addCommas(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

addEvent('since-mandates:give', true)
addEventHandler('since-mandates:give', resourceRoot, function (selectedPlayer, price, reason, description)
    local player = client

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    if (not selectedPlayer or not price or not reason or not description) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Wypełnij wszystkie pola.')
    end

    if (not getElementData(player, 'player:sid')) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś zalogowany.')
    end

    if (not getElementData(player, 'player:faction')) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś w frakcji.')
    end

    if (getElementData(player, 'player:faction') ~= "SAPD") then
        return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś w SAPD.')
    end

    if (not getElementData(selectedPlayer, 'player:sid')) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Gracz nie jest zalogowany.')
    end

    if (not tonumber(price)) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Wprowadź poprawną cenę.')
    end

    exports['since-db']:query('INSERT INTO `since-mandates` (uid, reason, description, price, receiverUID) VALUES (?, ?, ?, ?, ?)', getElementData(player, 'player:sid'), reason, description, price, getElementData(selectedPlayer, 'player:sid'))

    exports['since-notifications']:sendNotification(player, 'success', 'Mandat został wystawiony.')

    exports['since-notifications']:sendNotification(selectedPlayer, 'info', 'Otrzymałeś mandat w wysokości $'..addCommas(price)..' za: '..reason..'.')
    exports['since-notifications']:sendNotification(selectedPlayer, 'info', 'Opis: '..description..'.')
end)