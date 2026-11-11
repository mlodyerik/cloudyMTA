saveTPEV = {}

addCommandHandler('tpev.set', function(plr, cmd, users, ...)
    if not getAdmin(plr) then
        return
    end

    if users == 'all' then
        users = tonumber(#getElementsByType('player') + 100)
    end

    if not users or not tonumber(users) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Ilość graczy] [Tekst]')
    end

    local text = table.concat({...}, ' ')

    if #text < 2 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Ilość graczy] [Tekst]')
    end

    local rank = getElementData(plr, 'player:admin')
    local rankName = getRankName(rank)
    local rankColor = getRankHex(rank)
    local users = tonumber(users)

    local x, y, z = getElementPosition(plr)
    local dim = getElementDimension(plr)
    local int = getElementInterior(plr)

    saveTPEV[plr] = {x, y, z, int, dim, users, text}

    local usersText = users < 100 and ' #bfbfbf(Ilość miejsc: '..users..')' or ' '

    if #text > 0 then
        outputChatBox(' ', root)
        outputChatBox('*#ffffff '..rankColor..''..rankName..'#ffffff #cccccc'..getPlayerName(plr)..'#ffffff utworzył teleport: '..text..''..usersText, root, 255, 255, 0, true)
        outputChatBox('*#ffffff Wpisz #7dff7d/tpev '..getPlayerName(plr)..'#ffffff aby się przenieść', root, 255, 255, 0, true)
        outputChatBox(' ', root)
        exports['since-notifications']:sendNotification(plr, 'success', 'Teleport ('..text..') został utworzony')
    else
        outputChatBox(' ', root)
        outputChatBox('*#ffffff '..rankColor..''..rankName..'#ffffff #cccccc'..getPlayerName(plr)..'#ffffff utworzył teleport'..usersText, root, 255, 255, 0, true)
        outputChatBox('*#ffffff Wpisz #7dff7d/tpev '..getPlayerName(plr)..'#ffffff aby się przenieść', root, 255, 255, 0, true)
        outputChatBox(' ', root)
        exports['since-notifications']:sendNotification(plr, 'success', 'Teleport został utworzony')
    end
end)

addCommandHandler('tpev.del', function(plr, cmd)
    if not getAdmin(plr) then
        return
    end

    saveTPEV[plr] = nil
    exports['since-notifications']:sendNotification(plr, 'success', 'Teleport został usunięty')
end)

addCommandHandler('tpev', function(plr, cmd, target)
    if getPedOccupiedVehicle(plr) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Wyjdź z pojazdu')
    end

    if getElementData(plr, 'player:job') then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Zakończ pracę')
    end

    if getElementData(plr, 'handcuff:have') then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Jesteś zakuty(a), nie możesz użyć tpev!')
    end

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Administrator]')
    end

    local target = exports['since-core']:findPlayer(plr, target)

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Taki teleport nie istnieje')
    end


    if saveTPEV[target] then
        if 1 > saveTPEV[target][6] then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Brak miejsc.')
        end

        local x, y, z, int, dim = unpack(saveTPEV[target])
        setElementPosition(plr, x, y, z)
        setElementInterior(plr, int)
        setElementDimension(plr, dim)

        saveTPEV[target][6] = saveTPEV[target][6] - 1
    else
        return exports['since-notifications']:sendNotification(plr, 'error', 'Taki teleport nie istnieje')
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if saveTPEV[source] then
        saveTPEV[source] = nil
    end
end)

local chatBlock = createElement('chatBlock')
local chatTimer = nil

function generateDiscordCode(plr, sid)
    local code = string.sub(tostring((string.sub(getTickCount()*math.random(1, 1000), 1, 7)..''..sid)*sid), 1, 6)..''..sid
    code = (string.gsub(code, "%.", "")) -- Usuń kropki i zamień na liczbę

    return code
end

addCommandHandler('napraw.kod', function(plr, cmd, target)
    if not getAdmin(plr) then
        return
    end

    if target then
        local target = exports['since-core']:findPlayer(plr, target)

        if not target then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Taki gracz nie istnieje')
        end

        local code = generateDiscordCode(target, getElementData(target, 'player:sid'))
        setElementData(target, 'player:disordCode', code)
        exports['since-db']:query('UPDATE `since-users` SET kod=? WHERE uid=?', code, getElementData(target, 'player:sid'))
        exports['since-notifications']:sendNotification(plr, 'success', 'Naprawiono kod dla gracza '..getPlayerName(target))
    end
end)

addCommandHandler('vanish', function(plr, cmd)
    if getElementData(plr, 'player:admin') ~= 4 then
        return
    end

    local playerData = getElementData(plr, 'player:vanish')

    if playerData then
        setElementData(plr, 'player:vanish', false)
        exports['since-notifications']:sendNotification(plr, 'success', 'Zostałeś/aś widoczny(a)')
    else
        setElementData(plr, 'player:vanish', true)
        exports['since-notifications']:sendNotification(plr, 'success', 'Zostałeś/aś niewidoczny(a)')
    end
end)


addCommandHandler('zatankuj', function(plr, cmd, target)
    if not getAdmin(plr) then
        return
    end

    if target then
        local target = exports['since-core']:findPlayer(plr, target)

        if not target then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Taki gracz nie istnieje')
        end

        local veh = getPedOccupiedVehicle(target)

        if not veh then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Gracz nie jest w pojeździe')
        end

        local fuelData = getElementData(veh, 'vehicle:fuel') or {}

        if not fuelData.count then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Ten pojazd nie posiada zbiornika na paliwo')
        end

        fuelData['count'] = fuelData['tank']
        fuelData['countLPG'] = 100

        setElementData(veh, 'vehicle:fuel', fuelData)
        exports['since-notifications']:sendNotification(plr, 'success', 'Zatankowano pojazd gracza '..getPlayerName(target))
    else
        local veh = getPedOccupiedVehicle(plr)

        if not veh then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie jesteś w pojeździe')
        end

        local fuelData = getElementData(veh, 'vehicle:fuel') or {}

        if not fuelData.count then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Ten pojazd nie posiada zbiornika na paliwo')
        end

        fuelData['count'] = fuelData['tank']
        fuelData['countLPG'] = 100

        setElementData(veh, 'vehicle:fuel', fuelData)
        exports['since-notifications']:sendNotification(plr, 'success', 'Zatankowano pojazd')
    end
end)

addCommandHandler('cc', function(plr, cmd)
    if not getAdmin(plr, 4) then
        return
    end

    if isTimer(chatTimer) then
        local remain = getTimerDetails(chatTimer)
        local remain = math.floor(remain / 1000)

        return exports['since-notifications']:sendNotification(plr, 'error', 'Musisz poczekać jeszcze '..remain..' sek. przed ponownym wyczyszczeniem czatu')
    end
    
    for i = 2, 2000 do
        outputChatBox(' ', root)
    end

    outputChatBox('ⓘ #ffffffCzat został wyczyszczony przez #77ff73'..getPlayerName(plr):gsub("#%x%x%x%x%x%x", ''), root, 255, 175, 0, true)
    
    setElementData(chatBlock, 'chat:block', true)

    chatTimer = setTimer(function()
        setElementData(chatBlock, 'chat:block', false)
    end, 5000, 1)
end)

addCommandHandler('thru', function(plr, cmd, distance)
    if not getAdmin(plr) then
        return
    end

    if not distance then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Dystans]')
    end

    local distance = tonumber(distance)

    if not distance then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Dystans]')
    end

    if distance > 100 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Maksymalny dystans to 100')
    end

    local element = plr
    if getCameraTarget(plr) ~= plr then
        element = getCameraTarget(plr)
    end

    if (isPedInVehicle(plr)) then
        element = getPedOccupiedVehicle(plr)
    end
    
    local x,y,z = getElementPosition(element)
    local _,_,rz = getElementRotation(element)
    local rrz = math.rad(rz)
    local x = x + (distance * math.sin(-rrz))
    local y = y + (distance * math.cos(-rrz))
    setElementPosition(element, x, y, z)
end)

addCommandHandler('up', function(plr, cmd, distance)
    if not getAdmin(plr) then
        return
    end

    if not distance then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Dystans]')
    end

    local distance = tonumber(distance)

    if not distance then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Użycie: /'..cmd..' [Dystans]')
    end

    if distance > 100 then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Maksymalny dystans to 100')
    end

    
    local rot = getPedRotation(plr)
    local veh = getPedOccupiedVehicle(plr)

    if veh then
        local x, y, z = getElementPosition(veh)
        local z = z + distance
        setElementPosition(veh, x, y, z)
    else
        local x, y, z = getElementPosition(plr)
        local z = z + distance
        setElementPosition(plr, x, y, z)
    end
end)

addCommandHandler('klatka', function(player, cmd)
    if not getAdmin(player) then return end

    local name = getPlayerName(player)
    local position = Vector3(getElementPosition(player))
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)

    for _, gate in pairs(getElementsByType('object', resourceRoot)) do
        if getElementData(gate, 'gate:owner') == name then
            exports['since-notifications']:sendNotification(player, 'error', 'Już postawiłeś(aś) klatkę')
            return
        end
    end

    local gates = {
        createObject(971, position.x, position.y, position.z-0.9, 270, 0, 180),
        createObject(971, position.x, position.y, position.z+6, 270, 0, 180),
        createObject(971, position.x, position.y+3.5, position.z+2.5, 0, 0, 0),
        createObject(971, position.x-4.5, position.y, position.z+2.5, 0, 0, 270),
        createObject(971, position.x, position.y-3.5, position.z+2.5, 0, 0, 180),
        createObject(971, position.x+4, position.y, position.z+2.5, 0, 0, 270),
    }

    for _, gate in pairs(gates) do
        setElementData(gate, 'gate:owner', name, false)
        setElementInterior(gate, interior)
        setElementDimension(gate, dimension)
    end
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie postawiono klatkę')
end)

addCommandHandler('usun.klatke', function(player, cmd)
    if not getAdmin(player) then return end

    local name = getPlayerName(player)

    for _, gate in pairs(getElementsByType('object', resourceRoot)) do
        if getElementData(gate, 'gate:owner') == name then
            destroyElement(gate)
        end
    end
    exports['since-notifications']:sendNotification(player, 'success', 'Pomyślnie usunięto klatkę')
end)

function findVehicleByUID(uid)
    local vehicle = nil

    for i,v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == uid then
            vehicle = v
        end
    end

    return vehicle
end          

addCommandHandler("schowaj", function(plr, cmd, id)
	if getAdmin(plr) then
		if not id or not tonumber(id) then
			exports['since-notifications']:sendNotification(plr, 'error', 'Podaj ID pojazdu!')
			return
		end
        local vehicle = findVehicleByUID(tonumber(id))
        
		if vehicle then
            exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, getElementData(vehicle,'vehicle:id'))
            exports['since-core']:saveVehicle(vehicle)
            destroyElement(vehicle)
            exports['since-notifications']:sendNotification(plr, 'success', 'Schowałeś(aś) pojazd o ID '..id..' do przechowalni!')
        else
            local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id=? LIMIT 1', id)
            if #result > 0 then
                exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, id)
            end

            exports['since-notifications']:sendNotification(plr, 'success', 'Schowałeś(aś) pojazd o ID '..id..' do przechowalni!')
        end

        exports['since-adminpanel']:addAdminStats(plr, 'vehicles', 1)
	end
end)

addCommandHandler("schowaj.all", function(plr, cmd)
	if getAdmin(plr, 4) then
        local vehicles = getElementsByType('vehicle')

        exports['since-adminpanel']:addAdminStats(plr, 'vehicles', (#vehicles or 1))

        for i ,vehicle in ipairs(vehicles) do
            if getElementData(vehicle, 'vehicle:id') and not getVehicleController(vehicle) then
                exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, getElementData(vehicle, 'vehicle:id'))
                exports['since-core']:saveVehicle(vehicle)
                destroyElement(vehicle)
            end
        end

        exports['since-notifications']:sendNotification(plr, 'success', 'Schowano wszystkie pojazdy')
	end
end)

addEventHandler('onPlayerVehicleEnter', root, function(vehicle, seat)
    if seat == 0 then
        if getElementData(vehicle, 'vehicle:id') then
            local vehicleID = getElementData(vehicle, 'vehicle:id')
            exports['since-db']:query('UPDATE `since-vehicles` SET lastUse = NOW() WHERE id = ?', vehicleID)
        end
    end
end)

addCommandHandler("zmien.model", function(plr,cmd,model)
    if getAdmin(plr, 4) or getAdmin(plr, 3) then
        if (not model or not tonumber(model)) then
            exports['since-notifications']:sendNotification(plr, 'error', '/zmien.model <model>')
            return
        end
        local veh = getPedOccupiedVehicle(plr)
        if veh then
            local baseModel, isCustom = exports["since-custommodels"]:checkModelID(model, 'vehicle')
            if isCustom then
                setElementModel(veh, baseModel)
                setElementData(veh, "baseID", baseModel)
                setElementData(veh, "vehicleID", model)
                exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie podmieniono pojazd')
            else
                setElementData(veh, "baseID", nil)
                setElementData(veh, "vehicleID", nil)
                setElementModel(veh, model)
                exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie podmieniono pojazd')
            end
        end
    end
end)

addCommandHandler("do", function(player, cmd, ...)
    local message = table.concat({...}, ' ')

    if (not message or string.len(message) < 1) then 
        return 
    end

    if not getElementData(player, 'player:spawn') then 
        return 
    end

    if getElementData(player, 'player:mute') then 
        return exports['since-notifications']:sendNotification(player, 'error', 'Posiadasz nałożoną karę wyciszenia!')
    end

    local x,y,z = getElementPosition(player)
    local players = getElementsWithinRange(x, y, z, 30, 'player')
    local id = getElementData(player, 'id') or 0

    exports['since-admins']:addChatLog(player, message:gsub('#%x%x%x%x%x%x', ''))

    for i,v in pairs(players) do
        outputChatBox(' '..message:gsub('#%x%x%x%x%x%x', '')..' (( '..getPlayerName(player)..' ))', v, 0, 160, 255, true)
    end
end)

addCommandHandler("model", function(player, cmd)
    local veh = getPedOccupiedVehicle(player)

    if veh and getElementData(veh, 'vehicle:id') then
        local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE model = ?', tonumber(getElementData(veh, 'vehicle:model')))

        local value = 0
        for i, v in ipairs(result) do
            value = value + 1
            if v.id == getElementData(veh, 'vehicle:id') then
                break
            end
        end

        exports['since-notifications']:sendNotification(player, 'info', 'Jest to '..value..' pojazd tego modelu na serwerze, łącznie jest ich '..#result)
    end
end)

addCommandHandler('vehfroze', function(plr, cmd)
    if not getAdmin(plr) then
        return
    end

    local veh = getPedOccupiedVehicle(plr)

    if not veh then
        return
    end

    if isVehicleFrozen(veh) then
        setVehicleFrozen(veh, false)
        exports['since-notifications']:sendNotification(plr, 'success', 'Odmroziłeś pojazd')
    else
        setVehicleFrozen(veh, true)
        exports['since-notifications']:sendNotification(plr, 'success', 'Zamroziłeś pojazd')
    end
end)

function premiumPointsTransfer(plr, cmd, target, value)
    if not target or not value then
        return outputChatBox("#ff0000✘ #ffffffPoprawne użycie #bdbdbd/"..cmd.." (Nick/ID) (Ilość)", plr, 255, 255, 255, true)
    end

    local target = exports['since-core']:findPlayer(plr, target)

    if not target then
        return outputChatBox("#ff0000✘ #ffffffNie znaleziono takiego gracza", plr, 255, 255, 255, true)
    end

    local value = tonumber(math.floor(value or 0))

    if not tonumber(value) then
        return outputChatBox("#ff0000✘ #ffffffPoprawne użycie #bdbdbd/"..cmd.." (Nick/ID) (Ilość)", plr, 255, 255, 255, true)
    end

    if value <= 0 then
        return outputChatBox("#ff0000✘ #ffffffPoprawne użycie #bdbdbd/"..cmd.." (Nick/ID) (Ilość)", plr, 255, 255, 255, true)
    end

    if not getElementData(target, 'player:spawn') then
        return outputChatBox("#ff0000✘ #ffffffTen gracz nie jest zalogowany", plr, 255, 255, 255, true)
    end

    if target == plr then
        return
    end

    local targetPP = getElementData(target, 'player:pp') or 0
    local playerPP = getElementData(plr, 'player:pp') or 0

    if playerPP < value then
        return outputChatBox("#ff0000✘ #ffffffNie posiadasz tyle punktów premium", plr, 255, 255, 255, true)
    end

    if getElementData(plr, 'player:srp') < 50 then
        if value > 1000 then
            banPlayer(plr, true, false, true, root, "Brak dostępu do serwera")
        end

        return outputChatBox("#ff0000✘ #ffffffNie możesz tego zrobić", plr, 255, 255, 255, true)
    end

    setElementData(target, 'player:pp', targetPP + value)
    setElementData(plr, 'player:pp', playerPP - value)

    outputChatBox("#33CC00✔ #ffffffPrzekazałeś/aś #ffcd42"..value.." punktów premium#ffffff graczowi #c4c4c4("..getElementData(target, 'id')..") "..getPlayerName(target), plr, 255,255,255, true)
    outputChatBox("#33CC00✔ #ffffffOtrzymałeś/aś #ffcd42"..value.." punktów premium#ffffff od gracza #c4c4c4("..getElementData(plr, 'id')..") "..getPlayerName(plr), target, 255,255,255, true)
end
addCommandHandler("dajpp", premiumPointsTransfer)
addCommandHandler("transferpp", premiumPointsTransfer)
addCommandHandler("przelejpp", premiumPointsTransfer)

function derbyChat(plr, cmd, ...)
    if (getAdmin(plr)) then
        if (not ...) then
            outputChatBox("#ffea00ⓘ #ffffffUżycie: /derby.chat <wiadomość>", plr, _, _, _, true)
            return false
        end

        local text = table.concat({...}, " ")
        for i,v in ipairs(getElementsByType("player")) do
            if (getElementDimension(v) == 182) then
                outputChatBox("#00ffe5[DERBY] #ffffff"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..text:gsub("#%x%x%x%x%x%x",""), v, _, _, _, true)
            end
        end
    end
end
addCommandHandler("derby.chat", derbyChat)