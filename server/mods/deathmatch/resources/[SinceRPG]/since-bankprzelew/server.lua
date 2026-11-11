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
  
function triggeringBan(player, info, value)
    local nick, serial, ip, versionNumber = getPlayerName(player), getPlayerSerial(player), getPlayerIP(player)
    writeOnDiscord('Antycheat', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info..' - '..value)
    exports['since-logs']:sendDiscordLog('antycheat', 'AC', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info..' - '..value)

    print('Gracz '..nick..' ('..serial..') został zbanowany - '..info..' - '..value)

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

local checkList = {}

function onTransferBankMoney(plr, cmd, target, value)
    if not getElementData(plr, 'player:spawn') then return end
    if not target or not tonumber(value) then
        outputChatBox('✘ #ffffffPoprawne użycie: /'..cmd..' <nick/ID> <kwota>', plr, 255, 0, 0, true)
        return
    end
    local target = exports['since-core']:findPlayer(plr, target)
    if not target then
        outputChatBox('✘ #ffffffNie znaleziono gracza o podanym nicku/ID.', plr, 255, 0, 0, true)
        return
    end
    if not getElementData(target, 'player:spawn') then
        outputChatBox('✘ #ffffffGracz nie jest zalogowany.', plr, 255, 0, 0, true)
        return
    end
    local value = tonumber(value)
    if value == 0 or value < 0 or not value then
        outputChatBox('✘ #ffffffPodano złą wartość.', plr, 255, 0, 0, true)
        return
    end
    local db = exports['since-db']:query('select `bankMoney` from `since-users` where `uid`=? limit 1', getElementData(plr, 'player:sid'))
    if #db == 0 then return end
    local db = db[1]
    if db['bankMoney'] < value then
        outputChatBox('✘ #ffffffNie posiadasz środków na koncie.', plr, 255, 0, 0, true)
        return
    end

    if not checkList[plr] then
        checkList[plr] = { 0 , 0 }
    end

    checkList[plr][1] = checkList[plr][1] + 1
    checkList[plr][2] = checkList[plr][2] + value

    if checkList[plr][2] > 1000000000 then
        if getElementData(plr, 'player:hours') < 60 then
            triggeringBan(plr, 'Rozdawanie majątku innym graczom.', formatNumber(checkList[plr][2])..' $')
            return
        end
    end

    exports['since-db']:query('update `since-users` set `bankMoney`=`bankMoney`-? where `uid`=? limit 1', value, getElementData(plr, 'player:sid'))
    exports['since-db']:query('update `since-users` set `bankMoney`=`bankMoney`+? where `uid`=? limit 1', value, getElementData(target, 'player:sid'))

    outputChatBox("#30FF00✓ Przelałeś/aś #ffffff$ "..formatNumber(value).."#30FF00 dla gracza #ffffff"..getPlayerName(target):gsub("#%x%x%x%x%x%x","").."#30FF00.", plr,  0, 255, 0, true)
    outputChatBox("#30FF00✓ Otrzymałeś/aś przelew #ffffff$ "..formatNumber(value).."#30FF00 od gracza #ffffff"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#30FF00.", target,  0, 255, 0, true)

    exports['since-admins']:addMoneyTransferLog(plr, target, value)

    exports['since-logs']:sendDiscordLog('przelewy', getPlayerName(plr), 'Przekazał `'..formatNumber(value)..' $` dla gracza `'..getPlayerName(target)..'`')
end
addCommandHandler('przelej', onTransferBankMoney)
addCommandHandler('przelew', onTransferBankMoney)

setTimer(function()
    for player,v in pairs(checkList) do
        if v[2] > 1000000000 then
            if (isElement(player)) then
                if getElementData(player, 'player:hours') < 60 then
                    triggeringBan(player, 'Rozdawanie majątku innym graczom.', formatNumber(v[2])..' $')
                end
            end
        end
    end
    checkList = {}
end, 10000, 0)

-- function onwPLNTransfer(plr, cmd, target, value)
--     if not getElementData(plr, 'player:spawn') then return end
--     if not target or not tonumber(value) then
--         outputChatBox('✘ #ffffffPoprawne użycie: /'..cmd..' <nick/ID> <ilość wPLN>', plr, 255, 0, 0, true)
--         return
--     end
--     local target = exports['since-core']:findPlayer(plr, target)
--     if not target then
--         outputChatBox('✘ #ffffffNie znaleziono gracza o podanym nicku/ID.', plr, 255, 0, 0, true)
--         return
--     end
--     if not getElementData(target, 'player:spawn') then
--         outputChatBox('✘ #ffffffGracz nie jest zalogowany.', plr, 255, 0, 0, true)
--         return
--     end
--     local value = tonumber(value)
--     if value == 0 or value < 0 or not value then
--         outputChatBox('✘ #ffffffPodano złą wartość.', plr, 255, 0, 0, true)
--         return
--     end
--     local db = exports['since-db']:query('select `wPLN` from `since-users` where `uid`=? limit 1', getElementData(plr, 'player:sid'))
--     if #db == 0 then return end
--     local db = db[1]
--     if db['wPLN'] < value then
--         outputChatBox('✘ #ffffffNie posiadasz tylu wPLN.', plr, 255, 0, 0, true)
--         return
--     end
--     exports['since-db']:query('update `since-users` set `wPLN`=`wPLN`-? where `uid`=? limit 1', value, getElementData(plr, 'player:sid'))
--     exports['since-db']:query('update `since-users` set `wPLN`=`wPLN`+? where `uid`=? limit 1', value, getElementData(target, 'player:sid'))

--     outputChatBox("#30FF00✓ Przelałeś/aś #ffffff"..formatNumber(value).." wPLN#30FF00 dla gracza #ffffff"..getPlayerName(target):gsub("#%x%x%x%x%x%x","").."#30FF00.", plr,  0, 255, 0, true)
--     outputChatBox("#30FF00✓ Otrzymałeś/aś #ffffff"..formatNumber(value).." wPLN#30FF00 od gracza #ffffff"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#30FF00.", target,  0, 255, 0, true)

--     exports['since-admins']:addMoneyTransferLog(plr, target, value, true)

--     exports['since-logs']:sendDiscordLog('przelewy', getPlayerName(plr), 'Przekazał `'..formatNumber(value)..' wPLN` dla gracza `'..getPlayerName(target)..'`')
-- end
-- addCommandHandler('dajwpln', onwPLNTransfer)
-- addCommandHandler('przelejwpln', onwPLNTransfer)

function formatNumber(number) 
	while true do      
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')    
		if k==0 then      
			break   
		end  
	end  
	return number
end