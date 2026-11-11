local positions = {
    {1494.09, -1765.31, 18.45, -0.00, 0.00, -90},
    {1928.58, -1783.33, 13.55-0.4, 0, 0, 90},
    {2175.11, -2259.19, 14.4, 0, 0, 45},
    {1538.01, 1014.20, 10.82-0.4, 0, 0, 180},
    {-104.40, -1562.26, 2.61, -0.00, 0.00, 47.22},
    {2133.34, 2380.25, 10.82-0.3, -0.00, 0.00, 3.69},
    {1595.77, -1797.20, 13.35-0.2, -0.00, 0.00, 90.45},
    {1837.37, -1691.92, 13.32-0.4, -0.00, 0.00, 273.35},
    {-588.29, -1056.54, 23.39-0.4, -0.00, 0.00, 60.55},
    {2812.50, 897.24, 10.76-0.4, -0.00, 0.00, 181.81},
    {2502.93, -1538.37, 23.80-0.4, -0.00, 0.00, 182.37},
    {-357.64, 1207.20, 19.75-0.4, -0.00, 0.00, 89.06},
    {-908.19, 1521.15, 25.91-0.5, -0.00, 0.00, 182.84},
    {1603.59, -1170.44, 24.08-0.4, -0.00, 0.00, 181.14},
    {2301.83, 546.75, 7.78-0.3, -0.00, 0.00, 182.10},
    {242.46, -252.63, 1.58-0.3, -0.00, 0.00, 271.85},
    {1314.33, -1365.96, 13.1, -0.00, 0.00, 180},
    {992.58, -1457.01, 13.1, -0.00, 0.00, 90},
    {1085.31, -1698.4, 13.2, -0.00, 0.00, 360},
    {1349.77, -1759.07, 13.1, -0.00, 0.00, 180},
    {1760.11, -1940.33, 13.1, -0.00, 0.00, 90},
    {2089.54, -2079.90, 13.1, -0.00, 0.00, 360},
    {2006.18, -2271.69, 13.1, -0.00, 0.00, 360},
    {1367.04, -1283.67, 13.1, -0.00, 0.00, 270},
    {1446.93, -2208.18, 13.1, 0, 0, 90},
    {2111.32, -1211.53, 23.5, -0.00, 0.00, 360},
    {1242.37, 175.32, 20.0, -0.00, 0.00, 160},
    {726.95, 294.12, 19.8, -0.00, 0.00, 0},
    {99.26, -160.46, 2.1, -0.00, 0.00, 180},
    {-1076.72, -1290.40, 128.8, -0.00, 0.00, 0},
    {-83.02, -1183.65, 1.3, -0.00, 0.00, 333},
    {615.71, 1228.41, 11.3, -0.00, 0.00, 298},
    {1078.55, 1798.66, 10.4, -0.00, 0.00, 0},
    {1061.70, 1939.90, 10.4, -0.00, 0.00, 90},
    {1877.34, 2073.88, 10.6, -0.00, 0.00, 90},
    {2187.71, 2479.61, 10.8, -0.00, 0.00, 90},
    {2320.68, 1787.50, 10.4, -0.00, 0.00, 0},
    {2377.06, 1404.34, 10.4, -0.00, 0.00, 270},
    {2122.95, 896.78, 10.7, -0.00, 0.00, 180},
    {1557.80, 986.73, 10.4, -0.00, 0.00, 90},
    {2433.37, 109.89, 26.0, -0.00, 0.00, 90},
    {2359.91, 548.24, 1.4, -0.00, 0.00, 360},
    {1624.80, -1554.31, 13.2, -0.00, 0.00, 180},
    {1546.96, -1671.70, 13.1, -0.00, 0.00, 180},
    {425.74, 2472.60, 16.50-0.5, -0.00, 0.00, 270},
    {1371.03, 694.70, 10.43, -0.00, 0.00, 270},
}

local blips = {
    {2175.11, -2259.19, 14.4, 0, 0, 45},
    {-104.40, -1562.26, 2.61, -0.00, 0.00, 47.22},
    {2133.34, 2380.25, 10.82-0.3, -0.00, 0.00, 3.69},
    {-588.29, -1056.54, 23.39-0.4, -0.00, 0.00, 60.55},
    {1603.59, -1170.44, 24.08-0.4, -0.00, 0.00, 181.14},
    {242.46, -252.63, 1.58-0.3, -0.00, 0.00, 271.85},
}


local serials = {
    ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,
    ['C217ED9FE6899B85C066837D5D16A4D1'] = true,
}

local cannels = {
    ['Antycheat'] = 'https://discord.com/api/webhooks/1184150164399726672/GARga1qgnFtIVpNO37sue3Xrx9b3HTed4dY-5uK-ywHa5QwX7FDiJJ-hNnRj44euNeXO',
}
  
function writeOnDiscord(cannel, text)
    if cannels[cannel] then
      sendOptions = {
        queueName = "antycheatWebhook",
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
          username = cannel,
          content = text:gsub("#%x%x%x%x%x%x",""),
        },
      }
      fetchRemote(cannels[cannel], sendOptions, function() end)
    end
end

function triggeringBan(player, info)
    local nick, serial, ip, versionNumber = getPlayerName(player), getPlayerSerial(player), getPlayerIP(player)
    writeOnDiscord('Antycheat', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)
    exports['since-logs']:sendDiscordLog('antycheat', 'AC', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)

    if serials[serial] then
      return
    end
    
    local text = ''..getPlayerName(player)..' ('..(getElementData(player, 'id') or 0)..') został zbanowany przez AntyCheat.'
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)
    
    banPlayer(player, true, false, true, root, 'Nie posiadasz dostępu do serwera.')

    if isElement(player) then
        kickPlayer(player, 'Nie posiadasz dostępu do serwera.')
    end
end

local checkList = {
    ['addATMLogg'] = {},
    ['addATMOrgLogg'] = {},
    ['updateBankMoneyy'] = {},
    ['updateBankLogss'] = {},
    ['transferBankMoneyy'] = {},
    ['transferOrgBankMoneyy'] = {},
}

function updateBankMoney(plr, eventName, org)
    plr = client

    if not checkList['updateBankMoneyy'][plr] then
        checkList['updateBankMoneyy'][plr] = 0
    end
    checkList['updateBankMoneyy'][plr] = checkList['updateBankMoneyy'][plr] + 1

    if checkList['updateBankMoneyy'][plr] >= 50 then triggeringBan(plr, 'since-atms spam triggerów') return end

    if org then
        local sid = getElementData(plr, 'player:sid')
        if not sid then return end
        local result = exports['since-org']:getOrganizationData(sid).data

        triggerClientEvent(plr, eventName or 'updateATMMoneyy', plr, result.money)
    else
        local sid = getElementData(plr, 'player:sid')
        if not sid then return end
        local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", sid)
        local result = result[1].bankMoney
    
        triggerClientEvent(plr, eventName or 'updateATMMoneyy', plr, result)
    end
    
    return result
end
addEvent('updateBankMoneyy', true)
addEventHandler('updateBankMoneyy', resourceRoot, updateBankMoney)

function updateBankLogs(plr, eventName, org)
    plr = client

    if not checkList['updateBankLogss'][plr] then
        checkList['updateBankLogss'][plr] = 0
    end
    checkList['updateBankLogss'][plr] = checkList['updateBankLogss'][plr] + 1

    if checkList['updateBankLogss'][plr] >= 50 then triggeringBan(plr, 'since-atms spam triggerów') return end

    if org then
        local result = exports['since-org']:getOrganizationLogs(org)

        triggerClientEvent(plr, eventName or 'updateATMLogss', plr, result)
    else
        local sid = getElementData(plr, 'player:sid')
        if not sid then return end
        local result = exports["since-db"]:query("SELECT * FROM `since-atms-logs` WHERE uid = ? ORDER BY `date` DESC LIMIT 4", sid)
    
        triggerClientEvent(plr, eventName or 'updateATMLogss', plr, result)
    end
    
    return result
end
addEvent('updateBankLogss', true)
addEventHandler('updateBankLogss', resourceRoot, updateBankLogs)

function addLog(plr, icon, color, text, amount)
    plr = client

    if not checkList['addATMLogg'][plr] then
        checkList['addATMLogg'][plr] = 0
    end
    checkList['addATMLogg'][plr] = checkList['addATMLogg'][plr] + 1

    if checkList['addATMLogg'][plr] >= 50 then triggeringBan(plr, 'since-atms spam triggerów') return end

    if not getElementData(plr,'player:sid') then return end

    exports['since-db']:query("INSERT INTO `since-atms-logs` (uid,serial,ip,icon,color,text,amount) VALUES (?,?,?,?,?,?,?)", getElementData(plr,'player:sid'), getPlayerSerial(plr), getPlayerIP(plr), icon, color, text, amount)
    updateBankLogs(plr)
end
addEvent('addATMLogg', true)
addEventHandler('addATMLogg', resourceRoot, addLog)

function addOrgLog(plr, title, subtitle, desc)
    plr = client
    
    if not checkList['addATMOrgLogg'][plr] then
        checkList['addATMOrgLogg'][plr] = 0
    end
    checkList['addATMOrgLogg'][plr] = checkList['addATMOrgLogg'][plr] + 1

    if checkList['addATMOrgLogg'][plr] >= 50 then triggeringBan(plr, 'since-atms spam triggerów') return end

    if not getElementData(plr,'player:sid') then return end

    local orgID = getElementData(plr, 'player:organization').id
    local orgName = getElementData(plr, 'player:organization').name

    exports['since-db']:query("INSERT INTO `since-orgs-logs` (org,member,title,subTitle,description) VALUES (?,?,?,?,?)", orgID, getPlayerName(plr), title, subtitle, desc)
    updateBankLogs(plr, false, orgID)
end
addEvent('addATMOrgLogg', true)
addEventHandler('addATMOrgLogg', resourceRoot, addOrgLog)

setTimer(function()
    for i,v in pairs(checkList) do
        for player, count in pairs(v) do
            v[player] = nil
        end
    end
end, 2000, 0)

addEventHandler('onPlayerQuit', root, function()
    if checkList['addATMLogg'][source] then
        checkList['addATMLogg'][source] = nil
    end
    if checkList['addATMOrgLogg'][source] then
        checkList['addATMOrgLogg'][source] = nil
    end
    if checkList['updateBankMoneyy'][source] then
        checkList['updateBankMoneyy'][source] = nil
    end
    if checkList['updateBankLogss'][source] then
        checkList['updateBankLogss'][source] = nil
    end
    if checkList['transferBankMoneyy'][source] then
        checkList['transferBankMoneyy'][source] = nil
    end
    if checkList['transferOrgBankMoneyy'][source] then
        checkList['transferOrgBankMoneyy'][source] = nil
    end
end)

addEvent('transferBankMoneyy', true)
addEventHandler('transferBankMoneyy', resourceRoot, function(type, money)

    if not checkList['transferBankMoneyy'][client] then
        checkList['transferBankMoneyy'][client] = 0
    end
    checkList['transferBankMoneyy'][client] = checkList['transferBankMoneyy'][client] + 1

    if checkList['transferBankMoneyy'][client] >= 50 then triggeringBan(client, 'since-atms spam triggerów') return end

    local money = tonumber(money)
    local sid = getElementData(client, 'player:sid')

    if type == 'add' then
        if money < 1 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wpłacić takiej ilości gotówki')
        end

        if getPlayerMoney(client) < money then 
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz tyle gotówki')
        end

        exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney + ? WHERE uid = ?', money, sid)
        takePlayerMoney(client, money)
        exports['since-db']:query('UPDATE `since-users` SET money = money - ? WHERE uid = ?', money, sid)
        addLog(client, 'transaction', '125, 255, 125', 'Wpłaciłeś #84e374$ '..addCommas(money)..'#ffffff na konto bankowe', money)
        exports['since-notifications']:sendNotification(client, 'success', 'Wpłaciłeś #84e374$ '..addCommas(money)..'#ffffff na konto bankowe')

        exports['since-logs']:sendDiscordLog('bankomaty', getPlayerName(client), 'Wpłacił `'..addCommas(money)..' $` na konto bankowe')
    elseif type == 'take' then
        if money < 1 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wypłacić takiej ilości gotówki')
        end

        local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid = ? LIMIT 1", sid)
        local result = result[1]

		if not result or not result.bankMoney then
            return exports['since-notifications']:sendNotification(client, 'error', 'Brak danych')
        end

        if money > 999999999 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wypłacić takiej ilości gotówki')
        end
        
        if getPlayerMoney(client) + money > 999999999 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wypłacić takiej ilości gotówki')
        end

		result.bankMoney = tonumber(result.bankMoney)
		if (result.bankMoney < math.abs(money)) then
			return exports['since-notifications']:sendNotification(client, 'error', 'Brak środków na koncie bankowym')
		end

        exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney - ? WHERE uid = ?', money, sid)
        givePlayerMoney(client, money)
        addLog(client, 'transaction', '255, 125, 125', 'Wypłaciłeś #84e374$ '..addCommas(money)..'#ffffff z konta bankowego', money)
        exports['since-notifications']:sendNotification(client, 'success', 'Wypłaciłeś #84e374$ '..addCommas(money)..'#ffffff z konta bankowego')

        exports['since-logs']:sendDiscordLog('bankomaty', getPlayerName(client), 'Wypłacił `'..addCommas(money)..' $` z konta bankowego')
    end
    updateBankMoney(client)
end)

addEvent('transferOrgBankMoneyy', true)
addEventHandler('transferOrgBankMoneyy', resourceRoot, function(type, money)
    if not checkList['transferOrgBankMoneyy'][client] then
        checkList['transferOrgBankMoneyy'][client] = 0
    end

    checkList['transferOrgBankMoneyy'][client] = checkList['transferOrgBankMoneyy'][client] + 1

    if checkList['transferOrgBankMoneyy'][client] >= 50 then triggeringBan(client, 'since-atms spam triggerów') return end

    local money = tonumber(money)
    local orgID = getElementData(client, 'player:organization').id
    local playerSID = getElementData(client, 'player:sid')
    local orgData = exports['since-org']:getOrganizationData(playerSID).data

    if orgData.myRank < 3 then
        return exports['since-notifications']:sendNotification(client, 'error', 'Brak dostępu')
    end

    if type == 'add' then
        if money < 1 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wpłacić takiej ilości gotówki')
        end

        if getPlayerMoney(client) < money then 
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz tyle gotówki')
        end

        exports['since-db']:query('UPDATE `since-orgs` SET money = money + ? WHERE uid = ?', money, orgID)
        takePlayerMoney(client, money)
        exports['since-db']:query('UPDATE `since-users` SET money = money - ? WHERE uid = ?', money, playerSID)
        exports['since-notifications']:sendNotification(client, 'success', 'Wpłaciłeś #84e374$ '..addCommas(money)..'#ffffff na konto bankowe organizacji')
        addOrgLog(client, 'Wpłata gotówki', '#84e374$#ffffff '..addCommas(money)..'', 'Brak')
    elseif type == 'take' then
        if money < 1 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wypłacić takiej ilości gotówki')
        end

        local result = exports["since-db"]:query("SELECT * FROM `since-orgs` WHERE uid = ? LIMIT 1", orgID)
        local result = result[1]

		if not result or not result.money then
            return exports['since-notifications']:sendNotification(client, 'error', 'Brak danych')
        end
        
        if getPlayerMoney(client) + money > 999999999 then
            return exports['since-notifications']:sendNotification(client, 'error', 'Nie możesz wypłacić takiej ilości gotówki')
        end

		result.money = tonumber(result.money)
		if (result.money < math.abs(money)) then
			return exports['since-notifications']:sendNotification(client, 'error', 'Brak środków na koncie bankowym')
		end

        exports['since-db']:query('UPDATE `since-orgs` SET money = money - ? WHERE uid = ?', money, orgID)
        givePlayerMoney(client, money)
        addOrgLog(client, 'Wypłata gotówki', '#84e374$#ffffff '..addCommas(money)..'', 'Brak')
        exports['since-notifications']:sendNotification(client, 'success', 'Wypłaciłeś #84e374$ '..addCommas(money)..'#ffffff z konta bankowego organizacji')
    end

    updateBankMoney(client, false, orgID)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i,v in pairs(positions) do
        local x, y, z, rx, ry, rz = unpack(v)
        local atm = createObject(2942, x, y, z + 0.55, rx, ry, rz - 90)
        positions[i] = createColSphere(x, y, z, 1.2)
        setElementFrozen(atm, true)
        setObjectBreakable(atm, false)
        setElementData(positions[i], 'sphere:atm', true)
    end
    for i,v in pairs(blips) do
        local x, y, z, rx, ry, rz = unpack(v)
        createBlip(x,y,z,52,2,255,255,255,255,0,450)
    end
end)

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end