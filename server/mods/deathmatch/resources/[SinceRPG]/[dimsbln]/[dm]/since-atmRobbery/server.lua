local atmElements = {}
local timeouts = {}
local robbing = {}

function startRobbery(player, element)
    local data = getElementData(element, 'atm:data') or {}
    local isGang = getElementData(player, 'player:gang')

    if getPedOccupiedVehicle( player ) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Musisz opuścić pojazd, aby okraść bankomat.')
    end

    if not isGang then
        return exports['since-notifications']:sendNotification(player, 'error', 'Musisz być w organizacji przestępczej, aby okraść bankomat.')
    end

    if data.robbing then
        return exports['since-notifications']:sendNotification(player, 'error', 'Ten bankomat jest okradany.')
    end

    local playerSerial = getPlayerSerial(player)

    if timeouts[playerSerial] then
        return exports['since-notifications']:sendNotification(player, 'error', 'Musisz odczekać 15 minut przed ponownym okradaniem bankomatu.')
    end

    table.insert(atmElements, element)

    setElementData(element, 'atm:data', {robbing = true, robber = player})
    robbing[player] = element

    triggerClientEvent(player, 'bankRobbery:toggleUI', resourceRoot, true, element)
end

function addComma(number)
    local number = tostring(number)
    return number:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

addEvent('bankRobbery:start', true)
addEventHandler('bankRobbery:start', resourceRoot, function()
    if client then
        local playerSID = getElementData(client, 'player:sid')

        setElementFrozen(client, true)

        if playerSID then
            local players = getElementsByType('player')
            local x, y, z = getElementPosition(client)
            local location = getZoneName(x, y, z)..', '..getZoneName(x, y, z, true)

            for i, player in ipairs(players) do
                if getElementData(player, 'player:faction') == 'SAPD' then
                    outputChatBox(' ', player)
                    outputChatBox('✉#ffffff W lokalizacji #6b98ff'..location..'#ffffff odnotowano napad na bankomat.', player, 255, 175, 0, true)
                    outputChatBox('✉#ffffff Masz ok. #c2c2c22 minuty#ffffff aby dotrzeć na miejsce', player, 255, 175, 0, true)
                    outputChatBox(' ', player)
                end
            end
        end
    end
end)

function addCommas(n)
    local n = tostring(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1 '):reverse()) .. right
end

function addOrganizationMoney(organization, money)
    if not organization then
        return
    end

    if not money then
        return
    end

    if not tonumber(money) then
        return
    end

    exports['since-db']:query('UPDATE `since-orgs` SET `money` = `money` + ? WHERE `uid` = ?', money, organization)
    exports['since-db']:query("INSERT INTO `since-orgs-logs` (org,member,title,subTitle,description) VALUES (?,?,?,?,?)", organization, getPlayerName(client), 'Obrabowanie bankomatu', '#7dff7d$#ffffff '..addCommas(money)..'', 'Brak')
end

addEvent('bankRobbery:end', true)
addEventHandler('bankRobbery:end', resourceRoot, function(isTrue)
    local robbingATM = robbing[client]

    if not robbingATM then
        return
    end

    local data = getElementData(robbingATM, 'atm:data') or {}

    if data.robbing then
        data.robbing = false
        setElementData(robbingATM, 'atm:data', data)
    end

    for i, element in ipairs(atmElements) do
        if element == robbingATM then
            table.remove(atmElements, i)
        end
    end

    setElementFrozen(client, false)

    timeouts[getPlayerSerial(client)] = true

    setTimer( function(serial)
        timeouts[serial] = nil
    end, 60000 * 15, 1, getPlayerSerial(client))

    if isTrue then
        local randomMoney = math.random(850000, 1750000)

        local organization = getElementData(client, 'player:organization')
        addOrganizationMoney(organization.id, randomMoney)

        exports['since-notifications']:sendNotification(client, 'success', 'Udało ci się okraść bankomat. W torbie znalazłeś ' .. addComma(randomMoney) .. '$ a pieniądze trafiły na konto organizacji')
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if robbing[source] then
        local element = robbing[source]
        local data = getElementData(element, 'atm:data') or {}

        if data.robbing then
            data.robbing = false
            setElementData(element, 'atm:data', data)
        end

        for i, element in ipairs(atmElements) do
            if element == element then
                table.remove(atmElements, i)
            end
        end

        robbing[source] = nil
    end
end)

addEventHandler('onPlayerWasted', root, function()
    if robbing[source] then
        local element = robbing[source]
        local data = getElementData(element, 'atm:data') or {}

        if data.robbing then
            data.robbing = false
            setElementData(element, 'atm:data', data)
        end

        for i, element in ipairs(atmElements) do
            if element == element then
                table.remove(atmElements, i)
            end
        end

        robbing[source] = nil
    end
end)

addEventHandler('onResourceStop', resourceRoot, function()
    for i, element in ipairs(atmElements) do
        local data = getElementData(element, 'atm:data') or {}

        if data.robbing then
            data.robbing = false
            setElementData(element, 'atm:data', data)
        end
    end
end)