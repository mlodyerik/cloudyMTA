function hasAdminPerks(plr)
    if isElement(plr) and getElementType(plr) == 'player' then
        local acc = getPlayerAccount(plr)
        return isObjectInACLGroup('user.'.. getAccountName(acc), aclGetGroup('Admin'))
    end
end

function turnDebug(plr, data)
    if not hasAdminPerks(plr) then return end
    if data == true then
        setPlayerScriptDebugLevel(plr, 3)
        outputChatBox('✔ #FFFFFFDebug został uruchomiony automatycznie.', plr, 0,255,0,true)
    else
        if getPlayerScriptDebugLevel(plr) == 3 then
            setPlayerScriptDebugLevel(plr, 0)
            outputChatBox('✔ #FFFFFFPomyślnie wyłączyłeś debuga.', plr, 0,255,0,true)
        else
            setPlayerScriptDebugLevel(plr, 3)
            outputChatBox('✔ #FFFFFFPomyślnie włączyłeś debuga.', plr, 0,255,0,true)
        end
    end
end
addCommandHandler('debug', turnDebug) 

addCommandHandler("daty", function(plr, cmd, target)
    if not getElementData(plr, 'player:admin') or getElementData(plr, 'player:admin') ~= 4 then 
        return 
    end
    if not target then
        outputChatBox("#ff0000✘ #DFDFDFPoprawne użycie #84c1a7/daty (id/nick)", plr, 255,255,255, true)
        return
    end
    if (target == 'veh') then
        local veh = getPedOccupiedVehicle(plr)
        if not veh then
            outputChatBox("#ff0000✘ #DFDFDFNie jesteś w pojeździe.", plr, 255,255,255, true)
            return
        end
        outputChatBox("#009900✔ #DFDFDFData pojazdu #84c1a7"..getVehicleName(veh), plr, 255, 255, 255, true)
        local elDaty = getAllElementData(veh)
        for i,v in pairs(elDaty) do
            outputChatBox("┗ #84c1a7"..i..": #DFDFDF"..inspect(v):gsub("#%x%x%x%x%x%x", ""), plr, 255, 255, 255, true)
        end
        return
    end
    local target = exports["since-core"]:findPlayer(plr, target)
    if not target then
        outputChatBox("#ff0000✘ #DFDFDFNie znaleziono podanego gracza.", plr, 255,255,255, true)
        return
    end
    outputChatBox("#009900✔ #DFDFDFItemy Gracza #84c1a7"..getPlayerName(target), plr, 255, 255, 255, true)
    local elDaty = getAllElementData(target)
    for i,v in pairs(elDaty) do
        outputChatBox("┗ #84c1a7"..i..": #DFDFDF"..inspect(v):gsub("#%x%x%x%x%x%x", ""), plr, 255, 255, 255, true)
    end
end)

-- --[[ WZÓR
--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 18,
--         minute = 0,
--         reward = { data = 'pp', amount = 100, name = 'Punktów premium' }
--     },

--     {
--         type = 'rotation',
--         day = 9,
--         hour = 20,
--         minute = 0,
--     },
--     {
--         type = 'time',
--         day = 9,
--         hour = 20,
--         minute = 0,
--         reward = { data = 'pp', amount = 100, name = 'Punktów premium' }
--     },
--     {
--         type = 'jobs',
--         day = 9,
--         hour = 20,
--         minute = 0,
--     },
--     { 
--         type = 'players', 
--         count = 100, 
--         day = 9, 
--         reward = { data = 'car-box', amount = 1, name = 'Car Box' } 
--     },
-- ]]

-- local settings = {
--     { 
--         type = 'players', 
--         count = 50, 
--         day = 9, 
--         reward = { data = 'golden-box', amount = 1, name = 'Golden Box' } 
--     },

--     { 
--         type = 'players', 
--         count = 60, 
--         day = 9, 
--         reward = { data = 'diamond-box', amount = 1, name = 'Diamond Box' } 
--     },
--     { 
--         type = 'players', 
--         count = 70, 
--         day = 9, 
--         reward = { data = 'golden-box', amount = 2, name = 'Golden Box' } 
--     },
--     { 
--         type = 'players', 
--         count = 80, 
--         day = 9, 
--         reward = { data = 'diamond-box', amount = 2, name = 'Diamond Box' } 
--     },
--     { 
--         type = 'players', 
--         count = 90, 
--         day = 9, 
--         reward = { data = 'golden-box', amount = 3, name = 'Golden Box' } 
--     },
--     { 
--         type = 'players', 
--         count = 100, 
--         day = 9, 
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' } 
--     },
--     { 
--         type = 'players', 
--         count = 120, 
--         day = 9, 
--         reward = { data = 'car-box', amount = 2, name = 'Car Box' } 
--     },
--     { 
--         type = 'players', 
--         count = 140, 
--         day = 9, 
--         reward = { data = 'legendary-box', amount = 3, name = 'Legendary Box' } 
--     },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 14,
--     --     minute = 00,
--     --     reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 16,
--     --     minute = 00,
--     --     reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 18,
--     --     minute = 00,
--     --     reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 16,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 18,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     { 
--         type = 'time',
--         day = 9,
--         hour = 12,
--         minute = 00,
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' }
--     },

--     { 
--         type = 'time',
--         day = 9,
--         hour = 14,
--         minute = 00,
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' }
--     },

--     { 
--         type = 'time',
--         day = 9,
--         hour = 16,
--         minute = 00,
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' }
--     },

--     { 
--         type = 'time',
--         day = 9,
--         hour = 18,
--         minute = 00,
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' }
--     },

--     { 
--         type = 'time',
--         day = 9,
--         hour = 20,
--         minute = 00,
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' }
--     },

--     { 
--         type = 'time',
--         day = 9,
--         hour = 22,
--         minute = 00,
--         reward = { data = 'summer-box', amount = 1, name = 'Summer Box' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 12,
--         minute = 00,
--         reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 14,
--         minute = 00,
--         reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 16,
--         minute = 00,
--         reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 18,
--         minute = 00,
--         reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 20,
--         minute = 00,
--         reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 22,
--         minute = 00,
--         reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 18,
--         minute = 00,
--         reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     },

--     {
--         type = 'giveaway',
--         day = 9,
--         hour = 20,
--         minute = 00,
--         reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     },

--     {
--         type = 'time',
--         day = 9,
--         hour = 18,
--         minute = 00,
--         reward = { data = 'unique-box', amount = 1, name = 'Unique Box' }
--     },

--     {
--         type = 'time',
--         day = 9,
--         hour = 20,
--         minute = 00,
--         reward = { data = 'unique-box', amount = 1, name = 'Unique Box' }
--     },

--     {
--         type = 'time',
--         day = 9,
--         hour = 18,
--         minute = 00,
--         reward = { data = 'car-box', amount = 1, name = 'Car Box' }
--     },

--     {
--         type = 'time',
--         day = 9,
--         hour = 20,
--         minute = 00,
--         reward = { data = 'car-box', amount = 1, name = 'Car Box' }
--     },

--     -- {
--     --     type = 'timeRandomVouchers',
--     --     day = 9,
--     --     hour = 19,
--     --     minute = 30,
--     --     reward = { amount = 5 }
--     -- },

--     {
--         type = 'jobs',
--         day = 9,
--         hour = 23,
--         minute = 59,
--     },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'diamond', amount = 7, name = 'dni konta Diamond' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'diamond', amount = 7, name = 'dni konta Diamond' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 18,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'pp', amount = 1000, name = 'punktów premium' }
--     -- },

--     -- {
--     --     type = 'rotation',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 0,
--     -- },


--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 18,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 14,
--     --     minute = 00,
--     --     reward = { data = 'diamond', amount = 7, name = 'dni konta Diamond' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 20,
--     --     minute = 00,
--     --     reward = { data = 'diamond', amount = 7, name = 'dni konta Diamond' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'diamond', amount = 7, name = 'dni konta Diamond' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 16,
--     --     minute = 0,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 19,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'giveaway',
--     --     day = 9,
--     --     hour = 22,
--     --     minute = 00,
--     --     reward = { data = 'wpln', amount = 100, name = 'wPLN' }
--     -- },

--     -- {
--     --     type = 'jobs',
--     --     day = 9,
--     --     hour = 18,
--     --     minute = 0,
--     -- },

--   --[[  {
--         type = 'restartScript',
--         day = 9,
--         hour = 20,
--         minute = 0,
--         reward = { data = 'since-trashmasterJob', text = 'Na serwerze pojawiła się praca Śmieciarek COOP, można pracować nawet w 4 osoby. Lokalizacja prawy dolny róg Las Venturas' }
--     },]]--
    
-- }

-- function applyList()
--     local co30Minut = false
--     local hour = 12
--     local minute = 0
--     for i=1,24 do
--         if hour >= 24 then 
--             break 
--         end
--         local tbl = {
--             type = 'time',
--             day = 9,
--             hour = hour,
--             minute = minute,
--             reward = { data = 'diamond-box', amount = 1, name = 'Diamond Box' }
--         }
--         table.insert(settings, tbl)
--         if co30Minut then
--             minute = minute + 30
--             if minute >= 60 then
--                 minute = 0
--                 hour = hour + 1
--             end
--         else
--             hour = hour + 1
--         end
--     end
-- end

-- addCommandHandler('inspect.helper', function(plr)
--     if getElementData(plr, 'player:admin') ~= 4 then return end
--     for i,v in ipairs(settings) do
--         outputConsole(inspect(v), plr)
--     end
-- end)

-- local functions = {
--     ['players'] = (function(info) giveAllPlayersBox(info) end),
--     ['time'] = (function(info) giveAllPlayersBox(info) end),
--     ['jobs'] = (function() restartJobs() end),
--     ['giveaway'] = (function(info) giveRandomPlayer(info) end),
--     ['rotation'] = (function() restartDealer() end),
--     ['restartScript'] = (function(info) restartScript(info) end),
--     ['timeRandomVouchers'] = (function(info) giveAllPlayersRandomVoucher(info) end),
-- }

-- function restartScript(info)
--     if not info then return end
--     local resource = getResourceFromName(info.data)
--     if resource then
--         restartResource(resource)
--         outputChatBox(' \n✔ #FFFFFF'..info.text..'.\n ', root, 125,255,125,true)
--     end
-- end

-- function giveAllPlayersBox(info)
--     if not info then return end
--     for i, target in ipairs(getElementsByType('player')) do
--         if target and getElementData(target, 'player:spawn') then
--             exports['since-inventory']:addPlayerItem(target, info.data, tonumber(info.amount))
--             exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..info.amount..'x '..info.name..'')
--             outputChatBox('✔ #FFFFFFSystem rozdał każdemu '..info.amount..'x '..info.name, target, 125,255,125,true)
--         end
--     end
-- end

-- local vouchers = {
--     {'voucher-magazynier', 'Voucher pracy Magazynier'},
--     {'voucher-kurier', 'Voucher pracy Kurier'},
--     {'voucher-kosiarki', 'Voucher pracy Kosiarki'},
--     {'voucher-lawety', 'Voucher pracy Lawety'},
--     {'voucher-grzybiarz', 'Voucher pracy Grzybiarz'},
--     {'voucher-szambiarz', 'Voucher pracy Szambiarz'},
--     {'voucher-smieciarki', 'Voucher pracy Smieciarki'},
--     {'voucher-gornik', 'Voucher pracy Górnik'},
--     {'voucher-rybak', 'Voucher pracy Rybak'},
--     {'voucher-logistyka', 'Voucher pracy Logistyka lądowa'},
--     {'voucher-dostawca', 'Voucher pracy Dostawca'},
--     {'voucher-maszynista', 'Voucher pracy Maszynista'},
--     {'voucher-etransporter', 'Voucher pracy E-Transporter'},
--     {'voucher-import', 'Voucher pracy Import/Export'},
--     {'voucher-spedycjaLotnicza', 'Voucher pracy Spedycja lotnicza'},
-- }

-- function giveAllPlayersRandomVoucher(info)
--     if not info then return end
--     for i, target in ipairs(getElementsByType('player')) do
--         if target and getElementData(target, 'player:spawn') then
--             local voucher = vouchers[math.random(#vouchers)]
--             exports['since-inventory']:addPlayerItem(target, voucher[1], info.amount)
--             exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz x'..info.amount..' '..voucher[2]..'')
--             outputChatBox('✔ #FFFFFFSystem rozdał każdemu x'..info.amount..' losowy Voucher pracy', target, 125,255,125,true)
--         end
--     end
-- end

-- function restartJobs()
--     local resource = getResourceFromName('since-jobs')
--     if resource then
--         restartResource(resource)
--     end
-- end

-- function restartDealer()
--     local resource = getResourceFromName('since-cardealer')
--     if resource then
--         restartResource(resource)
--     end
-- end

-- function giveRandomPlayer(info)
--     if not info then return end
--     for i, target in ipairs(getElementsByType('player')) do
--         if target and getElementData(target, 'player:spawn') then
--             outputChatBox('✔ #FFFFFFSystem rozpoczyna losowanie o '..info.amount..' '..info.name..'.', target, 125,255,125,true)
--         end
--     end
--     setTimer(function()
--         local players = {}
--         for i,target in ipairs(getElementsByType('player')) do
--             if target and getElementData(target, 'player:spawn') then
--                 table.insert(players, target)
--             end
--         end
--         local player = players[math.random(#players)]
--         for i, target in ipairs(getElementsByType('player')) do
--             if target and getElementData(target, 'player:spawn') then
--                 if target == player then
--                     if info.data == 'pp' or string.find(info.data, 'box') or info.data == 'wpln' or info.data == 'diamond' then
--                         outputChatBox('✔ #FFFFFFSystem wylosował Ciebie, otrzumujesz '..info.amount..' '..info.name..'.', target, 125,255,125,true)
--                     else
--                         outputChatBox('✔ #FFFFFFSystem wylosował Ciebie, zgłoś się do Zarządu na discordzie, aby odebrać nagrodę.', target, 125,255,125,true)
--                     end
--                 else
--                     outputChatBox('✔ #FFFFFFSystem wylosował gracza '..getPlayerName(player):gsub("#%x%x%x%x%x%x", "")..'', target, 125,255,125,true)
--                 end
--             end
--         end
--         if info.data == 'pp' then
--             setElementData(player, 'player:pp', (getElementData(player, 'player:pp') or 0) + info.amount)
--         elseif string.find(info.data, 'box') then
--             exports['since-inventory']:addPlayerItem(player, info.data, tonumber(info.amount))
--         elseif info.data == 'wpln' then
--             exports['since-db']:query('UPDATE `since-users` SET wPLN = wPLN + ? WHERE uid = ?', info.amount, getElementData(player, 'player:sid'))
--         elseif info.data == 'diamond' then
--             setDiamondDay(player, info.amount)
--         end
--         if not player then return end
--         exports['since-logs']:sendDiscordLog('helper', 'System', 'System losujący wylosował gracza `(SID: '..getElementData(player, 'player:sid')..') '..getPlayerName(player):gsub("#%x%x%x%x%x%x", "")..'` i dał mu `'..info.amount..' '..info.name..'`')    
--     end, 5000, 1)
-- end

-- function ifCanContinue(v)
--     local time = getRealTime()
--     if v.day and v.hour and v.minute then
--         if time.monthday == v.day and time.hour == v.hour and time.minute == v.minute then
--             return true
--         end
--     elseif v.day and v.count then
--         if time.monthday == v.day and #getElementsByType('player') >= v.count then
--             return true
--         end
--     end
--     return false
-- end

-- function applyHelper(resource)
--     applyList()
--     setTimer(function()
--         for i,v in ipairs(settings) do
--             if not v.used then
--                 if ifCanContinue(v) then
--                     functions[v.type](v.reward)
--                     v.used = true
--                     exports['since-logs']:sendDiscordLog('helper', 'System', getLogging(v))
--                 end
--             end
--         end
--     end, 10000, 0)
--     print('['..getResourceName(resource)..'] Config succesfully loaded!')
-- end
-- addEventHandler('onResourceStart', resourceRoot, applyHelper)

-- function getLogging(v)
--     local time = getRealTime()
--     if v.type == 'time' then
--         return 'Rozdał każdemu `'..v.reward.amount..'x '..v.reward.name..'` o godzinie `'..string.format("%02d:%02d", time.hour, time.minute)..'`'
--     elseif v.type == 'players' then
--         return 'Rozdał każdemu `'..v.reward.amount..'x '..v.reward.name..'`, gdy było `'..v.count..'` osób o godzinie `'..string.format("%02d:%02d", time.hour, time.minute)..'`'
--     elseif v.type == 'jobs' then
--         return 'Zrestartował prace o godzinie `'..string.format("%02d:%02d", time.hour, time.minute)..'`'
--     elseif v.type == 'rotation' then
--         return 'Zrestartował rotacje o godzinie `'..string.format("%02d:%02d", time.hour, time.minute)..'`'
--     elseif v.type == 'giveaway' then
--         return 'Rozdał losowo graczowi `'..v.reward.amount..'x '..v.reward.name..'` o godzinie `'..string.format("%02d:%02d", time.hour, time.minute)..'`'
--     elseif v.type == 'restartScript' then
--         return 'Zrestartował skrypt `'..v.reward.data..'` o godzinie `'..string.format("%02d:%02d", time.hour, time.minute)..'`'
--     end
-- end

-- function getTime()
--     local time = getRealTime();
--     return time.hour..":"..time.minute
-- end

-- function getDate()
--     local time = getRealTime();
--     return (time.monthday).."-"..(time.month+1).."-"..(time.year+1900)
-- end
    
-- function saveInFile(name, text, date)
--     local file = fileOpen("files/"..name..".txt")
--     if not file then
--         file = fileCreate("files/"..name..".txt")
--     end
--     fileSetPos(file, fileGetSize(file))
--     if date then
--         fileWrite(file, "["..getDate().." "..getTime().."] "..text:gsub("#%x%x%x%x%x%x", "").."\r")
--     else
--         fileWrite(file, text:gsub("#%x%x%x%x%x%x", "").."\r")
--     end
--     fileFlush(file)
--     fileClose(file)
-- end

--[[function preEvent(sourceResource, eventName, eventSource, eventClient, luaFilename, luaLineNumber, ...)
    local args = {...}
    local resname = sourceResource and getResourceName(sourceResource)
    saveInFile('plik',''..tostring(resname).." "..tostring(eventName).." "..tostring(plrname).." "..tostring(luaFilename).."("..tostring(luaLineNumber)..") "..inspect(args), true)
end
addDebugHook('preEvent', preEvent)]]

-- function getDiamondDate(plr)
-- 	local queryA = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid=? AND premium > NOW() LIMIT 1", getElementData(plr, "player:sid"))

-- 	if (queryA and #queryA > 0) then
-- 		return queryA[1].premium
-- 	end

-- 	return false	
-- end

-- function setDiamondDay(plr, days)
--     if getElementData(plr,"player:sid") then
--         setElementData(plr, 'player:diamond', true)

--         if getDiamondDate(plr) then
--             return exports['since-db']:query(string.format("UPDATE `since-users` SET premium = premium + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
--         end

--         exports['since-db']:query(string.format("UPDATE `since-users` SET premium = NOW() + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
--     end
-- end
