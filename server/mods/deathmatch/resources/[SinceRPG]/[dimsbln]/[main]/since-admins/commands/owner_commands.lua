addCommandHandler('daj.pp', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local playerPP = getElementData(target, 'player:pp') or 0
            setElementData(target, 'player:pp', playerPP + value)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' PP dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' PP od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.pp.uid', function(plr, cmd, uid, value)
    if getAdmin(plr, 4) then
        if not uid or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [UID] [Ilosc]')
        end

        local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)

        if #rows > 0 then
            exports['since-db']:query('UPDATE `since-users` SET premiumPoints = premiumPoints + ? WHERE uid = ?', value, uid)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' PP dla gracza o podanym UID!')
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym UID!')
        end
    end
end)

addCommandHandler('daj.srp', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local playerPP = getElementData(target, 'player:srp') or 0
            setElementData(target, 'player:srp', playerPP + value)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' SRP dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' SRP od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.srp.uid', function(plr, cmd, uid, value)
    if getAdmin(plr, 4) then
        if not uid or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [UID] [Ilosc]')
        end

        local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)

        if #rows > 0 then
            exports['since-db']:query('UPDATE `since-users` SET srp = srp + ? WHERE uid = ?', value, uid)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' SRP dla gracza o podanym UID!')
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym UID!')
        end
    end
end)

addCommandHandler('setmodel', function(plr, cmd, model)
    if getAdmin(plr, 4) then
        if not model then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Model]')
        end

        local vehicle = getPedOccupiedVehicle(plr)
        if not vehicle then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
        end

        
        setElementData(vehicle, 'baseID', getElementModel(vehicle))
        setElementData(vehicle, 'vehicleID', tonumber(model))
        setElementData(vehicle, 'vehicle:model', tonumber(model))
    end
end)

addCommandHandler('daj.wpln', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', getElementData(target, 'player:sid'))

            if #result > 0 then
                exports['since-db']:query('UPDATE `since-users` SET wPLN = wPLN + ? WHERE uid = ?', value, getElementData(target, 'player:sid'))

                exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' wPLN dla gracza '..getPlayerName(target))
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' wPLN od '..getPlayerName(plr))
            else
                exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
            end
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.wpln.uid', function(plr, cmd, uid, value)
    if getAdmin(plr, 4) then
        if not uid or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [UID] [Ilosc]')
        end

        local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)

        if #rows > 0 then
            exports['since-db']:query('UPDATE `since-users` SET wPLN = wPLN + ? WHERE uid = ?', value, uid)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' wPLN dla gracza o podanym UID!')
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym UID!')
        end
    end
end)

addCommandHandler('clear.bans', function(plr, cmd)
    if getAdmin(plr, 4) then
        local bans = getBans()
        local count = 0

        for i, ban in ipairs(bans) do
            local banSerial = getBanSerial(ban) or 'n/a'

            if banSerial then
                if banSerial ~= 'n/a' then
                    removeBan(ban)
                    count = count + 1
                end
            end
        end

        exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie usunieto '..count..' ban�w (AdminPanel).')
    end
end)

addCommandHandler('check.vehicles', function(player)
    if not getAdmin(player, 4) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnien do tej komendy!') end
    vehicles = 0
    for key, value in pairs(getElementsByType('vehicle')) do
        if getElementData(value, 'vehicle:id') then
            vehicles = vehicles+1
        end
    end
    exports['since-notifications']:sendNotification(player, 'info', 'Ilosc pojazd�w na mapie: '..vehicles)
end)

addCommandHandler('daj.minuty', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local playerPP = getElementData(target, 'player:hours') or 0
            setElementData(target, 'player:hours', playerPP + value)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' minut dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' minut od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.fminuty', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local timeFaction = getElementData(target, 'player:workinjob') or 0
            setElementData(target, 'player:workinjob', timeFaction + value)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' minut we frakcji dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' minut frakcyjnych od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.prawko', function(plr, cmd, cel)
    if getAdmin(plr, 4) then
        if not cel then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            setElementData(target, 'player:licenses', {
                ['a'] = true,
                ['b'] = true,
                ['c'] = true
            })

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano wszystkie kategoria prawa jazdy dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz wszystkie kategoria prawa jazdy od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.kase', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            givePlayerMoney(target, value)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' $ dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' $ od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.bank', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local sid = getElementData(target, 'player:sid')
            if not sid then
                return
            end

            exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney + ? WHERE uid = ?', value, sid)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' $ w banku dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' $ w banku od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('daj.bank.uid', function(plr, cmd, uid, value)
    if getAdmin(plr, 4) then
        if not uid or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [UID] [Ilosc]')
        end

        local rows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)

        if #rows > 0 then
            exports['since-db']:query('UPDATE `since-users` SET bankMoney = bankMoney + ? WHERE uid = ?', value, uid)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' $ w banku dla gracza o podanym UID!')
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym UID!')
        end
    end
end)

addCommandHandler('daj.kg', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ilosc]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            local sid = getElementData(target, 'player:sid')
            if not sid then
                return
            end

            exports['since-db']:query('UPDATE `since-users` SET coal = coal + ? WHERE uid = ?', value, sid)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' kg wegla dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' kg wegla od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('tradeban', function(plr, cmd)
    if getAdmin(plr, 4) then
        local veh = getPedOccupiedVehicle(plr)

        if not veh then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
        end

        local vehicleData = getElementData(veh, 'vehicle:data')

        if vehicleData['non_transferable'] then
            vehicleData['non_transferable'] = false
            exports['since-notifications']:sendNotification(plr, 'success', 'Zdejmujesz tradebana z pojazdu')
        else
            vehicleData['non_transferable'] = true
            exports['since-notifications']:sendNotification(plr, 'success', 'Pojazd otrzymal tradebana')
        end

        setElementData(veh, 'vehicle:data', vehicleData)
    end
end)

addCommandHandler('check.1', function(player, cmd, cel)
	if getAdmin(player, 4) or getAdmin(player, 3) or getAdmin(player, 2) then
		if not cel then
			exports['since-notifications']:sendNotification(player, 'error', 'Uzycie: /'..cmd..' <UID>')
			return
		end

		local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', cel)

		if not result or #result < 1 then
			exports['since-notifications']:sendNotification(player, 'error', 'W bazie danych nie znalezio gracza o podanym UID!')
			return
		end

		outputChatBox('#23E552? #ffffffLogin: #cccccc'..result[1].login, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffNick: #cccccc'..result[1].nick, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffSerial: #cccccc'..result[1].serial, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffUID: #cccccc'..result[1].uid, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffIlosc wPLN: #cccccc'..result[1].wPLN, player, 255, 255, 255, true)
        --outputChatBox('#23E552? #ffffffPrzegrany czas: #cccccc'..result[1].playedTime, player, 255, 255, 255, true)
	end
end)

addCommandHandler('check.2', function(player, cmd, cel)
	if getAdmin(player, 4) or getAdmin(player, 3) or getAdmin(player, 2) then
		if not cel then
			exports['since-notifications']:sendNotification(player, 'error', 'Uzycie: /'..cmd..' <serial>')
			return
		end

		local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE serial = ?', cel)

		if not result or #result < 1 then
			exports['since-notifications']:sendNotification(player, 'error', 'W bazie danych nie znalezio gracza o podanym serialu!')
			return
		end

		outputChatBox('#23E552? #ffffffLogin: #cccccc'..result[1].login, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffNick: #cccccc'..result[1].nick, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffSerial: #cccccc'..result[1].serial, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffUID: #cccccc'..result[1].uid, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffIlosc wPLN: #cccccc'..result[1].wPLN, player, 255, 255, 255, true)
	end
end)

addCommandHandler('check.3', function(player, cmd, cel)
	if getAdmin(player, 4) or getAdmin(player, 3) or getAdmin(player, 2) then
		if not cel then
			exports['since-notifications']:sendNotification(player, 'error', 'Uzycie: /'..cmd..' <nick>')
			return
		end

		local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE nick = ?', cel)

		if not result or #result < 1 then
			exports['since-notifications']:sendNotification(player, 'error', 'W bazie danych nie znalezio gracza o podanym nicku!')
			return
		end

		outputChatBox('#23E552? #ffffffLogin: #cccccc'..result[1].login, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffNick: #cccccc'..result[1].nick, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffSerial: #cccccc'..result[1].serial, player, 255, 255, 255, true)
		outputChatBox('#23E552? #ffffffUID: #cccccc'..result[1].uid, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffIlosc wPLN: #cccccc'..result[1].wPLN, player, 255, 255, 255, true)
	end
end)

addCommandHandler('check.4', function(player, cmd, cel)
    if getAdmin(player, 4) or getAdmin(player, 3) or getAdmin(player, 2) then
        if not cel then
            exports['since-notifications']:sendNotification(player, 'error', 'Uzycie: /'..cmd..' <login>')
            return
        end

        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE login = ?', cel)

        if not result or #result < 1 then
            exports['since-notifications']:sendNotification(player, 'error', 'W bazie danych nie znalezio gracza o podanym loginie!')
            return
        end

        outputChatBox('#23E552? #ffffffLogin: #cccccc'..result[1].login, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffNick: #cccccc'..result[1].nick, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffSerial: #cccccc'..result[1].serial, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffUID: #cccccc'..result[1].uid, player, 255, 255, 255, true)
        outputChatBox('#23E552? #ffffffIlosc wPLN: #cccccc'..result[1].wPLN, player, 255, 255, 255, true)
    end
end)

local boxTypes = {

    ['Bronze'] = 'bronze-box',
    ['Silver'] = 'silver-box',
    ['Gold'] = 'golden-box',
    ['Diamond'] = 'diamond-box',
    ['Christmas'] = 'christmas-box',
    ['Legendary'] = 'legendary-box',
    ['Car'] = 'car-box',
    ['Easter'] = 'easter-box',
    ['Summer'] = 'summer-box',
    ['Unique'] = 'unique-box',
    ['Winter'] = 'winter-box',
    ['Birth'] = 'birhtday-box',
    ['newcars'] = 'newcars',

}
local boxes = {}
for i,v in pairs(boxTypes) do
    table.insert(boxes, i)
end

function giveSponsorBox()
    local boxType = {

        key = 'diamond-box',
        value = 1,
        name = 'Diamond Box',
    }

    for i, target in ipairs(getElementsByType('player')) do
        if target and getElementData(target, 'player:spawn') then
            local data = getElementData(target, 'player:data') or {}

            if data['visualRank'] == 'Sponsor' then
                exports['since-inventory']:addPlayerItem(target, boxType.key, tonumber(boxType.value))
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..boxType.value..'x '..boxType.name..'.')
            end
        end
    end
end
setTimer(giveSponsorBox, 60000 * 60, 0)

addCommandHandler('rozdaj.boxy', function(plr, cmd, box, value)
    if getAdmin(plr, 4) then
        if not box or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Box] [Ilosc]')
        end

        if not boxTypes[box] then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego boxa! Dostepne boxy: '..table.concat(boxes, ', '))
        end

        for i, target in ipairs(getElementsByType('player')) do
            if target and getElementData(target, 'player:spawn') then
                exports['since-inventory']:addPlayerItem(target, boxTypes[box], tonumber(value))
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' box�w '..box..' od '..getPlayerName(plr))
            end
        end

        exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' box�w '..box..' dla kazdej zalogowanej osoby')
    end
end)

addCommandHandler('rozdaj.fboxy', function(plr, cmd, box, value)
    if getAdmin(plr, 4) then
        if not box or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Box] [Ilosc]')
        end

        if not boxTypes[box] then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego boxa! Dostepne boxy: '..table.concat(boxes, ', '))
        end

        for i, target in ipairs(getElementsByType('player')) do
            if target and getElementData(target, 'player:spawn') then
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' box�w '..box..' od '..getPlayerName(plr))
            end
        end

        exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' box�w '..box..' dla kazdej zalogowanej osoby')
    end
end)

addCommandHandler('rozdaj.item', function(plr, cmd, item, value)
    if getAdmin(plr, 4) then
        if not item or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nazwa itemu] [Ilosc]')
        end
    
        if not exports['since-inventory']:getItemInfo(item) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego itemu!')
        end
    
        for i, target in ipairs(getElementsByType('player')) do
            if target and getElementData(target, 'player:sid') then
                exports['since-inventory']:addPlayerItem(target, item, tonumber(value))
                
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..'x '..item..' od '..getPlayerName(plr))
            end
        end
        exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..'x '..item..' dla kazdego gracza')
    end
end)


addCommandHandler('daj.boxy', function(plr, cmd, cel, box, value)
    if getAdmin(plr, 4) then
        if not cel or not box or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Box] [Ilosc]')
        end

        if not boxTypes[box] then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego boxa! Dostepne boxy: '..table.concat(boxes, ', '))
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            exports['since-inventory']:addPlayerItem(target, boxTypes[box], tonumber(value))

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' box�w '..box..' dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' box�w '..box..' od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('rozdaj.kase', function(plr, cmd, value)
    if getAdmin(plr, 4) then
        if not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Ilosc]')
        end

        for i, target in ipairs(getElementsByType('player')) do
            if target then
                givePlayerMoney(target, value)
    
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' $ od '..getPlayerName(plr))
            end
        end
        exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' $ dla kazdej zalogowanej osoby')
    end
end)

local visualRanks = {

    ['Sponsor'] = true,
    ['Modeler'] = true,
    ['Mapper'] = true,
    ['Skrypter'] = true,
    ['Darczynca'] = true,

}

local visualRanksColors = {

    ['Sponsor'] = '#fa5eff',
    ['Modeler'] = '#61ff5e',
    ['Mapper'] = '#5ed1ff',
    ['Skrypter'] = '#b95eff',
    ['Darczynca'] = '#ff4de4',

}

addCommandHandler('visualrank', function(plr, cmd, target, rank)
    if getAdmin(plr, 4) then
        if not target then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Ranga]')
        end

        local target =  exports['since-core']:findPlayer(plr, target)

        if not target then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end

        if not visualRanks[rank] or not rank then
            local playerData = getElementData(target, 'player:data') or {}
            playerData['visualRank'] = false
            playerData['visualRankColor'] = false
            setElementData(target, 'player:data', playerData)
    
            exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie usunieto range gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Ranga wizualna usunieta przez '..getPlayerName(plr)) 
        else
            local playerData = getElementData(target, 'player:data') or {}
            playerData['visualRank'] = rank
            playerData['visualRankColor'] = visualRanksColors[rank]
            setElementData(target, 'player:data', playerData)

            exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zmieniono range gracza '..getPlayerName(target)..' na '..rank)
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz range '..rank..' od '..getPlayerName(plr))
        end
    end
end)

function getDiamondDate(plr)
	local queryA = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid=? AND premium > NOW() LIMIT 1", getElementData(plr, "player:sid"))

	if (queryA and #queryA > 0) then
		return queryA[1].premium
	end

	return false	
end

function setDiamondDay(plr, days)
    if getElementData(plr,"player:sid") then
        if getDiamondDate(plr) then
            return exports['since-db']:query(string.format("UPDATE `since-users` SET premium = premium + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
        end

        exports['since-db']:query(string.format("UPDATE `since-users` SET premium = NOW() + INTERVAL %d DAY WHERE uid = %d", days, getElementData(plr,"player:sid")))
    end
end

addCommandHandler('daj.diamond', function(plr, cmd, cel, value)
    if getAdmin(plr, 4) then
        if not cel or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Dni]')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            setDiamondDay(target, value)
            setElementData(target, 'player:diamond', true)

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' dni Diamond dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' dni Diamond od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)

addCommandHandler('rozdaj.diamond', function(plr, cmd, value)
    if getAdmin(plr, 4) then
        if not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Dni]')
        end

        for i, target in ipairs(getElementsByType('player')) do
            if target then
                setDiamondDay(target, value)
                setElementData(target, 'player:diamond', true)
    
                exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..' dni konta diamond od '..getPlayerName(plr))
            end
        end
        exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..' dni konta diamond dla kazdej zalogowanej osoby')
    end
end)

addCommandHandler('przepisz.pojazd', function(plr, cmd, uid)
    if getAdmin(plr, 4) or getAdmin(plr, 3) then
        local veh = getPedOccupiedVehicle(plr)

        if not veh then return end

        if not uid then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [UID]')
        end

        setElementData(veh, 'vehicle:owner', uid)
        exports['since-notifications']:sendNotification(plr, 'success', 'Pojazd przepisany na gracza UID '..uid..'.')
    end
end)

addCommandHandler('zmien.motyw', function(plr, cmd, value)
    if getAdmin(plr, 4) then
        if not value or not tonumber(value) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Motyw]')
        end

        local veh = getPedOccupiedVehicle(plr)

        if not veh then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
        end

        local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
        vehicleUpgrades['motyw'] = tonumber(value)
        setElementData(veh, 'vehicle:upgrades', vehicleUpgrades)

        exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zmieniono motyw licznika!')
    end
end)

addCommandHandler('zmien.galaxy', function (plr, cmd, value)
    if getAdmin(plr, 4) then
        if not value or not tonumber(value) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [ID]')
        end

        local veh = getPedOccupiedVehicle(plr)

        if not veh then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
        end

        local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
        vehicleUpgrades['galaxy'] = tonumber(value)
        setElementData(veh, 'vehicle:upgrades', vehicleUpgrades)

        exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zmieniono galaxy!')
    end
end)

addCommandHandler('zmien.paintjob', function(plr, cmd, value)
    if getAdmin(plr, 4) then
        if not value or not tonumber(value) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [ID]')
        end

        local veh = getPedOccupiedVehicle(plr)

        if not veh then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
        end

        if value == 0 then
            local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
            vehicleUpgrades['custompaintjob'] = false
            setElementData(veh, 'vehicle:upgrades', vehicleUpgrades)
        else
            local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
            vehicleUpgrades['custompaintjob'] = tonumber(value)
            setElementData(veh, 'vehicle:upgrades', vehicleUpgrades)
        end

        exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zmieniono paintjob!')
    end
end)

addCommandHandler('zmien.haslo.serial', function(plr, cmd, serial, haslo)
    if getAdmin(plr, 4) then
        if serial and string.len(serial) > 3 and haslo and string.len(haslo) > 3 then
            local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE serial = ?', serial)
            local password = md5(haslo)

            if (result and #result > 0) then
                exports['since-db']:query('UPDATE `since-users` SET password = ? WHERE serial = ?', password, serial)
                exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zmieniono haslo dla gracza o serialu '..serial)
            else
                exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym serialu')
            end
        else
            return exports['since-notifications']:sendNotification(plr, 'error', 'Podaj serial i haslo')
        end
    end
end)

addCommandHandler('odblokuj', function(plr, cmd, sid, serial)
    if getAdmin(plr, 4) or getAdmin(plr, 3) or getAdmin(plr, 2) then
        if serial and string.len(serial) > 3 and sid and tonumber(sid) then
            local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', sid)

            if (result and #result > 0) then
                exports['since-db']:query('UPDATE `since-users` SET serial = ? WHERE uid = ?', serial, sid)
                exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie odblokowano konto dla gracza o UID '..sid)
            else
                exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym UID')
            end
        else
            return exports['since-notifications']:sendNotification(plr, 'error', 'Podaj UID oraz Serial')
        end
    end
end)

addCommandHandler('ghostmode', function(plr, cmd)
    if getAdmin(plr, 4) then
        local veh = getPedOccupiedVehicle(plr)

        if veh then
            local data = getElementData(veh, 'element:ghost') 

            if data then
                setElementData(veh, 'element:ghost', false)
                exports['since-notifications']:sendNotification(plr, 'success', 'Ghostmode wylaczony')
            else
                setElementData(veh, 'element:ghost', true)
                exports['since-notifications']:sendNotification(plr, 'success', 'Ghostmode wlaczony')
            end
        end
    end
end)

addCommandHandler('wyzeruj.konto', function(plr, cmd, uid)
    if getAdmin(plr, 4) and tonumber(uid) then
        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)
        if #result > 0 then
            exports['since-db']:query('UPDATE `since-users` SET money = 0, bankMoney = 0, srp = 0, coal = 0, premiumPoints = 0, factionTime = 0, wPLN = 0, playedTime = 0 WHERE uid = ?', uid)
            
            local vehicles = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE owner = ?', uid)

            for i, v in ipairs(vehicles) do
                exports['since-db']:query('UPDATE `since-vehicles` SET owner = 3 WHERE id = ?', v.id)
            end

            exports['since-notifications']:sendNotification(plr, 'success', 'Wyzerowano konto gracza o nicku '..result[1].nick..' (UID: '..uid..')')
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza o podanym UID')
        end
    end
end)

addCommandHandler('zmien.sid', function(plr, cmd, uid)
    if getAdmin(plr, 4) and tonumber(uid) then
        setElementData(plr, 'player:sid', tonumber(uid))
        exports['since-notifications']:sendNotification(plr, 'success', 'Zmieniono SID na '..uid)
    end
end)

local tunes = {
    
    ['abs'] = {},
    ['mk1'] = {},
    ['mk2'] = {},
    ['mk3'] = {},
    ['mk4'] = {},
    ['mk5'] = {},
    ['mk6'] = {},
    ['mk2137'] = {},
    ['electric'] = {},
    ['turbo'] = {},
    ['chiptuning'] = {},
    ['deluxomode'] = {},
    ['hovermode'] = {},
    ['jumpmode'] = {},
    ['neon'] = {},
    ['licznikrgb'] = {},
    ['vopisrgb'] = {},
    ['vopis'] = {},
    ['neonrgb'] = {},
    ['rgbsmoke'] = {},
    ['taxi'] = {},
    ['driftmode'] = {},
    ['exhaust'] = {},
    ['cameleon'] = {},
    ['sport'] = {},
    ['twinturbo'] = {},
    ['rgblights'] = {},
    ['ecu'] = {},
    ['stereo'] = {},

}

local dodatki = {

    ['rainbownick'] = {},

}

local serials = {

    ['3424E57BF56F93801EA5181D7BB10FF4'] = true,
    ['AF06E724C564FD4C61DFFB4059E1AF52'] = true,
    ['5574030858F7B0C5748E33B68CF45C50'] = true,
    ['57DCE25B5A5F519A3C42C5CEFDF4AA33'] = true,
    ['6892B667ED01261C7857C6196F6934B2'] = true
}

function getAllTunes()
    local text = ''
    for i,v in pairs(tunes) do
        text = text..i..', '
    end
    return text
end

function getAllDodatki()
    local text = ''
    for i,v in pairs(dodatki) do
        text = text..i..', '
    end
    return text
end

addCommandHandler('tune', function (plr, cmd, name)
    if (not serials[getPlayerSerial(plr)]) then return end

    local veh = getPedOccupiedVehicle(plr)
    if (not veh) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
    end
    if (not getElementData(veh, 'vehicle:id')) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Do tego pojazdu nie mozesz nadac ulepszenia!')
    end
    if (not tunes[name]) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono wybranego tuningu! Dostepne tuningi: '..getAllTunes()..'')
    end

    local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
    upgrades[name] = not upgrades[name]

    if name == 'neonrgb' then
        upgrades['neon'] = true
    end

    if name == 'stereo' then
        addVehicleUpgrade(veh, 1086)
    end
    
    setElementData(veh, 'vehicle:upgrades', upgrades)
    exports['since-notifications']:sendNotification(plr, 'success', (upgrades[name] and 'Pomyslnie zamontowano tuning!' or 'Pomyslnie zdemontowano tuning!'))
end)

addCommandHandler('tune.all', function (plr, cmd)
    if (not serials[getPlayerSerial(plr)]) then return end

    local veh = getPedOccupiedVehicle(plr)
    if (not veh) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
    end
    if (not getElementData(veh, 'vehicle:id')) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Do tego pojazdu nie mozesz nadac ulepszenia!')
    end

    local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
    for i,v in pairs(tunes) do
        upgrades[i] = true
    end

    setElementData(veh, 'vehicle:upgrades', upgrades)
    exports['since-notifications']:sendNotification(plr, 'success', 'Pomyslnie zamontowano wszystkie tuningi!')
end)

addCommandHandler('zmien.neon', function (plr, cmd, nType)
    if (not serials[getPlayerSerial(plr)]) then return end

    local veh = getPedOccupiedVehicle(plr)
    if (not veh) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jestes w pojezdzie!')
    end

    if (not getElementData(veh, 'vehicle:id')) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Do tego pojazdu nie mozesz nadac ulepszenia!')
    end

    if (not nType) or not tonumber(nType) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Wprowadz typ neonu (1, 2, 3...)')
    end

    local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
    upgrades['neonType'] = tonumber(nType)
    setElementData(veh, 'vehicle:upgrades', upgrades)

    exports['since-notifications']:sendNotification(plr, 'success', 'Zmieniono typ neonu na: '..nType)
end)

addCommandHandler('dodatek', function (plr, cmd, name, target)
    if (not serials[getPlayerSerial(plr)]) then return end

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Dostepne dodatki: '..getAllDodatki()..'')
    end

    local target = exports['since-core']:findPlayer(plr, target)
    if (not target) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza')
    end

    if (not getElementData(target, 'player:sid')) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Blad')
    end

    if (not dodatki[name]) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono wybranego dodatku! Dostepne dodatki: '..getAllDodatki()..'')
    end

    local upgrades = getElementData(target, 'player:data') or {}
    upgrades[name] = not upgrades[name]
    setElementData(target, 'player:data', upgrades)
    exports['since-notifications']:sendNotification(plr, 'success', (upgrades[name] and 'Pomyslnie nadano dodatek!' or 'Pomyslnie usunieto dodatek!'))
end)

addCommandHandler('reload.org', function (plr, cmd, target)
    if getAdmin(plr, 4) then
        if not target then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podales gracza')
        end

        local target = exports['since-core']:findPlayer(plr, target)
        if (not target) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza')
        end

        if (not getElementData(target, 'player:sid')) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Gracz nie jest zalogowany')
        end

        exports['since-org']:loadPlayerOrganizationData(target)

        exports['since-notifications']:sendNotification(plr, 'success', 'Przeladowales wczytana organizacje gracza')
    end
end)

addCommandHandler('daj.item', function(plr, cmd, cel, item, value)
    if getAdmin(plr, 4) then
        if not cel or not item or not value then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Uzycie: /'..cmd..' [Nick/ID] [Nazwa itemu] [Ilosc]')
        end

        if not exports['since-inventory']:getItemInfo(item) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego itemu!')
        end

        local target = exports['since-core']:findPlayer(plr, cel)
        if target then
            exports['since-inventory']:addPlayerItem(target, item, tonumber(value))

            exports['since-notifications']:sendNotification(plr, 'success', 'Nadano '..value..'x '..item..' dla gracza '..getPlayerName(target))
            exports['since-notifications']:sendNotification(target, 'success', 'Otrzymujesz '..value..'x '..item..' od '..getPlayerName(plr))
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
        end
    end
end)