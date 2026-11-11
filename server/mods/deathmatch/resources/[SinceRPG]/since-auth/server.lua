    

function getOrganizationSpawn(org)
    if org then
        local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE uid = ?', org)

        if #result > 0 then
            if result[1].spawn then
                local x, y, z = unpack(fromJSON(result[1].spawn))
            
                return {x, y, z}
            else
                return false
            end
        else
            return false
        end
        
    end
end

function checkPlayerBan(serial)
    local banned = 0
    local q = exports['since-db']:query('SELECT * FROM `since-ban` WHERE serial = ? AND type = 2', serial)

    if q and #q > 0 then
        banned = 2
    end

    local q = exports['since-db']:query('SELECT * FROM `since-ban` WHERE serial = ? AND time > NOW()', serial)

    if q and #q > 0 then
        banned = 1
    end

    return banned
end

local serials = {
    -- ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,
    -- ['C217ED9FE6899B85C066837D5D16A4D1'] = true,
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
    ['auth:login'] = {},
    ['auth:register'] = {},
    ['core-spawnPlayer'] = {},
}


addEvent('auth:login',true)
addEventHandler('auth:login', resourceRoot, function(login,password)
    local plr = client
    if not checkList['auth:login'][plr] then
        checkList['auth:login'][plr] = 0
    end
    checkList['auth:login'][plr] = checkList['auth:login'][plr] + 1

    if checkList['auth:login'][plr] > 10 then triggeringBan(plr, 'since-auth masywka') return end

    if getElementData(plr, 'player:sid') then return end
    local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE login=?', login)

    if (#rows > 0) then
        if (rows[1].password == md5(password)) then
            local function findPlayer(sid)
                for i,v in pairs(getElementsByType('player')) do
                    if (getElementData(v,'player:sid') == sid) then
                        return true
                    end
                end

                return false
            end

            if rows[1].serial ~= getPlayerSerial(plr) then
                exports['since-discord']:sendDiscordNotification(rows[1].serial, 'Próba logowania na konto', 'Ktoś próbował zalogować się na konto `'..rows[1].login..'` z serialu `'..getPlayerSerial(plr)..'` `Inny numer seryjny klienta`', '#ffaa00')
                return exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz zalogować się na to konto!', 5000)
            end

            if findPlayer(rows[1].uid) then
                exports['since-notifications']:sendNotification(plr,'error', 'Ktos jest juz zalogowany na te konto', 5000)
            else
                -- check ban
                local check = checkPlayerBan(getPlayerSerial(client))

                if check ~= 0 then
                    exports['since-db']:query('INSERT INTO `since-ban` (`sid`, `serial`, `reason`, `time`, `type`, `admin`, `admin_name`, `admin_serial`) VALUES (?, ?, ?, NOW(), 2, ?, ?, ?)', getElementData(client, 'player:sid'),getPlayerSerial(client), 'Omijanie bana', 1, 'System', 'System')
                     kickPlayer(client, 'Zostałeś zbanowany na tym serwerze!\nPowód: Omijanie bana')

                    local text = 'System zbanował gracza '..getPlayerName(client)..' ('..getElementData(client, 'id')..') na zawsze. Powód: Omijanie bana'
                    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)
                    return
                end

                local org = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `owner` = ? OR `members` LIKE ?', rows[1].uid, '%'..rows[1].uid..'%')
                if #org > 0 then
                    local item = false
                    for k,v in ipairs(org) do
                        if tonumber(v.owner) == rows[1].uid then
                            item = v
                            break
                        end
            
                        local members = fromJSON(v.members)
                        for kk,vv in ipairs(members) do
                            if tonumber(vv[1]) == rows[1].uid then
                                item = org[k]
                                break
                            end
                        end
                    end
                    if item then
                        local pos = getOrganizationSpawn(item.uid)

                        if pos then
                            local x, y, z = unpack(pos)
                            triggerClientEvent(plr, 'addLoginSpawn', plr, 'Spawn organizacji', {x, y, z}, {x, y, z, x + 10, y, z})
                        end
                    end
                end

                if rows[1].lastPos ~= '0, 0, 0, 0, 0' then
                    local spawnPos = split(rows[1].lastPos, ",")

                    if spawnPos[4] and spawnPos[5] then
                        if tonumber(spawnPos[4]) == 0 and tonumber(spawnPos[5]) == 0 then
                            triggerClientEvent(plr, 'addLoginSpawn', plr, 'Ostatnia pozycja', {spawnPos[1], spawnPos[2], spawnPos[3]}, {spawnPos[1], spawnPos[2], spawnPos[3], spawnPos[1] + 10, spawnPos[2], spawnPos[3]})
                        end
                    end
                end

                local houseResult = exports['since-db']:query('SELECT * FROM `since-houses` WHERE owner = ?', rows[1].uid)

                if #houseResult > 0 then
                    for i,v in ipairs(houseResult) do
                        local spawnPos = split(v.position, ",")
                        triggerClientEvent(plr, 'addLoginSpawn', plr, 'Dom ID: '..v.id, {spawnPos[1], spawnPos[2], spawnPos[3]}, {spawnPos[1], spawnPos[2], spawnPos[3], spawnPos[1] + 10, spawnPos[2], spawnPos[3]})
                    end
                end

                local isMuted = exports['since-mute']:checkIsPlayerMuted(plr)

                if isMuted then
                    exports['since-mute']:toggleMute(plr, true)
                end

                exports['since-notifications']:sendNotification(plr,'success', 'Pomyslnie zalogowano sie na konto: '..rows[1].login..'', 5000)
                setPlayerName(plr, rows[1].nick)
                setElementData(plr, 'player:sid', rows[1].uid)
                setElementData(plr, 'player:registerDate', rows[1].registerDate)
                triggerClientEvent(plr,'changeLoginWindow',plr, 'spawn')

                exports['since-logs']:sendDiscordLog('logowanie', getPlayerName(plr), 'Zalogował się na konto `' .. rows[1].login .. '` z serialu `' .. getPlayerSerial(plr) .. '`')


                local discordID = exports['since-discord']:getPlayerDiscordID(rows[1].uid)

                if discordID then
                    local haveDiamond = exports['since-db']:query('SELECT * FROM `since-users` WHERE premium>NOW() AND uid=?', rows[1].uid)

                    exports['since-discord']:botWrite({
                        funcname = 'addRole',
                        args = {
                            guild = '1143611641393586356',
                            id = discordID,
                            rank = '1167188550006095892'
                        }
                    });

                    if (#haveDiamond > 0) then
                        exports['since-discord']:botWrite({
                            funcname = 'addRole',
                            args = {
                                guild = '1143611641393586356',
                                id = discordID,
                                rank = '1201677988446605323'
                            }
                        });
                    else
                        exports['since-discord']:botWrite({
                            funcname = 'removeRole',
                            args = {
                                guild = '1143611641393586356',
                                id = discordID,
                                rank = '1201677988446605323'
                            }
                        });
                    end
                end
            end
        else
            exports['since-notifications']:sendNotification(plr,'error', 'Podano zle haslo', 5000)
            exports['since-discord']:sendDiscordNotification(rows[1].serial, 'Próba logowania na konto', 'Ktoś próbował zalogować się na konto `'..rows[1].login..'` z serialu `'..getPlayerSerial(plr)..'` `(Błędne hasło)`', '#ffaa00')
        end
    else
        exports['since-notifications']:sendNotification(plr,'error', 'Nie ma takiego konta', 5000)
    end
end)

local maks_ilosc_kont = 2

function setRegister()
    for i,v in ipairs(getElementsByType('player')) do
        if not getElementData(v, 'player:registerDate') and getElementData(v, 'player:sid') then
            local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(v, 'player:sid'))

            if result and #result > 0 then
                setElementData(v, 'player:registerDate', result[1].registerDate)
            end
        end
    end
end
addEventHandler('onResourceStart', resourceRoot, setRegister)

local words = {

    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'W', 'X', 'Y', 'Z'

}

function table.find(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function checkString(text)
    -- text only can have a-z, A-Z, 0-9
    for i = 1, #text do
        local char = string.sub(text, i, i)
        if not table.find(words, char) then
            return true
        end
    end

    if string.find(text, "%c") or string.find(text, "%p") or string.find(text, "%s") or string.find(text, "%z") then
      return true
    else
      return false
    end
end

function hasSpecialCharacters(text)
    -- Definiujemy wzorzec dla znaków specjalnych (wszystko poza literami i cyframi)
    local specialPattern = "[^%w%s]" -- %w oznacza litery i cyfry, %s oznacza białe znaki (spacje, tabulatory)

    iprint(text)
    -- Sprawdzamy, czy tekst zawiera znaki specjalne
    if string.find(text, specialPattern) then
        return true -- Zawiera znaki specjalne
    else
        return false -- Nie zawiera znaków specjalnych
    end
end


addEvent('auth:register',true)
addEventHandler('auth:register',resourceRoot,function(login,password)
    local plr = client

    if not checkList['auth:register'][plr] then
        checkList['auth:register'][plr] = 0
    end
    checkList['auth:register'][plr] = checkList['auth:register'][plr] + 1

    if checkList['auth:register'][plr] > 10 then triggeringBan(plr, 'since-auth masywka') return end

    if not login then
        return exports['since-notifications']:sendNotification(plr,'error', 'Wprowadź login')
    end

    if #login > 12 then
        return exports['since-notifications']:sendNotification(plr,'error', 'Login nie może zawierać więcej niż 12 znaków')
    end

    if #login < 3 then
        return exports['since-notifications']:sendNotification(plr,'error', 'Login musi mieć więcej niż 3 znaki')
    end

    if not password then
        return exports['since-notifications']:sendNotification(plr,'error', 'Wprowadź login')
    end

    if #password > 20 then
        return exports['since-notifications']:sendNotification(plr,'error', 'Hasło nie może zawierać więcej niż 20 znaków')
    end

    if #password < 3 then
        return exports['since-notifications']:sendNotification(plr,'error', 'Hasło musi mieć więcej niż 3 znaki')
    end

    if hasSpecialCharacters(login) then
        return exports['since-notifications']:sendNotification(plr,'error', 'Login może zawierać tylko litery i cyfry')
    end

    local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE serial=?", getPlayerSerial(plr))
	if result and #result >= 1 then
        exports['since-notifications']:sendNotification(plr,'error', 'Możesz posiadać maksymalnie 1 konto')
	    return
    end

	local result=exports["since-db"]:query("SELECT * FROM `since-users` WHERE login=?", login)
	if result and #result > 0 then
        exports['since-notifications']:sendNotification(plr,'error', 'Konto o tej nazwie już istnieje')
	else
		local query = exports['since-db']:query('INSERT INTO `since-users` (`login`, `nick`, `password`, `serial`, `ip`, `kod`) VALUES (?, ?, ?, ?, ?, ?)',
        login, login, md5(password), getPlayerSerial(plr), getPlayerIP(client), 'needToChange')
        
		if query then
            exports['since-notifications']:sendNotification(plr,'success', 'Pomyślnie się zarejestrowałeś')
            reloadPlayersData()

            outputDebugString('[since-auth] Zarejestrowano konto: '..login..' ('..getPlayerSerial(plr)..') ('..getPlayerIP(client)..') ID: '..getElementData(plr, 'id'))
		end
	end
end)

local spawned = {}

addEvent('core-spawnPlayer',true)
addEventHandler('core-spawnPlayer', resourceRoot, function(pos)
    local plr = client
    exports['since-core']:spawnPlr(plr, pos)

    exports['since-vouchers']:loadPlayerVouchers(plr)

    if not spawned[plr] then
        spawned[plr] = true
    end
    --exports['since-fabular']:loadEventState(plr)
end)

setTimer(function()
    for i,v in pairs(checkList) do
        for player, count in pairs(v) do
            v[player] = nil
        end
    end
end, 2000, 0)

addEventHandler('onPlayerQuit', root, function()
    local plr = source
    if checkList['auth:login'][plr] then
        checkList['auth:login'][plr] = nil
    end
    if checkList['auth:register'][plr] then
        checkList['auth:register'][plr] = nil
    end
    if checkList['core-spawnPlayer'][plr] then
        checkList['core-spawnPlayer'][plr] = nil
    end
end)

function reloadPlayersData()
    local result = exports["since-db"]:query("SELECT * FROM `since-users`")
    local tbl = {}

    for i, v in ipairs(result) do
        table.insert(tbl, {login = v.login, uid = v.uid})
    end

    triggerClientEvent('loadPlayersData', root, tbl)
end

function generateDiscordCode(plr, sid)
    local code = string.sub(tostring((string.sub(getTickCount()*math.random(1, 1000), 1, 7)..''..sid)*sid), 1, 6)..''..sid
    code = (string.gsub(code, "%.", ""))

    return code
end

addEventHandler('onResourceStart', resourceRoot, function()
    setTimer(function()
    reloadPlayersData()
    end, 500, 1)
end)

addEventHandler('onPlayerConnect', resourceRoot, function()
    setTimer(function()
    reloadPlayersData()
    end, 500, 1)
end)