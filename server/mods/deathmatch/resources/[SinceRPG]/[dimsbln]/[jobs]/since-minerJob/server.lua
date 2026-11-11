

addEvent('giveCoal', true)
addEventHandler('giveCoal', resourceRoot, function(coal)
    if not coal or not tonumber(coal) then return end
    local plr = client

    if string.len(coal) > 10 then
        return
    end

    local coal = tonumber(string.format('%.2f', coal))
    local result = exports['since-db']:query('UPDATE `since-users` SET coal = coal + ? WHERE uid = ?', tonumber(coal), getElementData(plr, 'player:sid'))

    if tonumber(coal) < 0.01 then
        exports['since-notifications']:sendNotification(plr, 'error', 'Popełniłeś zbyt wiele błędów, węgiel nie został wykopany!')
    else
        exports['since-notifications']:sendNotification(plr, 'info', 'Wykopano '..coal..' kg węgla')
    end
end)

addEvent('getCoal', true)
addEventHandler('getCoal', resourceRoot, function(plr)
    local plr = client
    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ? LIMIT 1', getElementData(plr, 'player:sid'))
    local coal = 0

    if result and result[1].coal then
        coal = tonumber(result[1].coal) or 0 
    end

    triggerClientEvent(plr, 'getCoal', plr, string.format('%.2f', coal))
end)

addEvent('toggleMinerAnimation',true)
addEventHandler('toggleMinerAnimation', resourceRoot, function(toggle)
    setElementFrozen(client, toggle)
    if toggle then
        setPedAnimation(client,'baseball','bat_4',-1,true)
    else
        setPedAnimation(client,false)
    end
end )

addEvent('setMinerWeapon',true)
addEventHandler('setMinerWeapon', resourceRoot, function(id)
    giveWeapon(client, id)
    setPedWeaponSlot(client,1)
end )

addEvent('takeMinerWeapon',true)
addEventHandler('takeMinerWeapon', resourceRoot, function(id)
    takeWeapon(client, id)
end )

addEventHandler('onPlayerWeaponSwitch', root, function(previousWeaponID, currentWeaponID)
    if getElementData(source, 'player:job') == 'Górnik' then 
        if currentWeaponID == 7 then
            toggleControl(source, 'fire', false)
        else 
            setPedWeaponSlot(source,1)
        end
    end
end)

addEventHandler("onPlayerWasted", root, function()
	if getElementData(source, 'player:job') == 'Górnik' then
        setElementData(source, 'player:mining', false)
        setElementData(source, 'player:job', false)

        triggerClientEvent(source, 'stopMinerJob', source)

        stopWywoz(source)
    end
end)

addEventHandler("onPlayerQuit", root, function()
	if getElementData(source, 'player:job') == 'Górnik' or getElementData(source, 'player:miner:savepos') then
        setElementData(source, 'player:mining', false)
        setElementData(source, 'player:job', false)

        triggerClientEvent(source, 'stopMinerJob', source)
        triggerClientEvent(source, 'endWywoz', source)

        stopWywoz(source)
    end
end)

vehicles = {}
tryExit = {}

addEvent('createWywoz', true)
addEventHandler('createWywoz', resourceRoot, function(pos, coal)
    local plr = client
    if vehicles[plr] then 
        destroyElement(vehicles[plr]) 
        vehicles[plr]=nil 
    end

    tryExit[plr] = 0
    vehicles[plr] = createVehicle(455, unpack(pos))
    setVehicleColor(vehicles[plr], 255, 255, 255, 255, 255, 255)
    setElementData(vehicles[plr], 'vehicle:job', 'miner')
    setElementData(vehicles[plr], 'vehicle:jobOwner', plr)
    setElementData(vehicles[plr], 'vehicle:coal', coal)

    local x, y, z = getElementPosition(plr)
    setElementData(plr, 'player:miner:savepos', {x, y, z})

    takePlayerMoney(plr, 5000)

    setTimer(warpPedIntoVehicle, 100, 1, plr, vehicles[plr])
end)

addEvent('endWywoz', true)
addEventHandler('endWywoz', resourceRoot, function()
    local plr = client
    local veh = getPedOccupiedVehicle(plr)
    if veh then
        local coal = getElementData(veh, 'vehicle:coal')
        local coalCost = coalCost
        local money = math.floor(coal*coalCost)
        
        givePlayerMoney(plr, money + 5000)

        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', getElementData(plr, 'player:sid'))
        local resultCoal = result[1].coal - coal

        if resultCoal <= 0 then
            resultCoal = 0
        end

        local result = exports['since-db']:query('UPDATE `since-users` SET coal = ? WHERE uid = ?', resultCoal, getElementData(plr, 'player:sid'))
        exports['since-notifications']:sendNotification(plr, 'success', 'Otrzymujesz '..money..' $ za sprzedaż '..coal..' kg węgla (+ $ 5 000 zwrotu kaucji za ciężarówkę)')

        stopWywoz(plr, true)
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Wystąpił błąd, nie oddano węgla do skupu')
    end
end)

function stopWywoz(plr, koniec)
    if getElementData(plr, 'player:miner:savepos') then
        if vehicles[plr] then destroyElement(vehicles[plr]) end
        vehicles[plr] = nil
        triggerClientEvent(plr, 'endWywoz', plr)

        if not koniec then
            givePlayerMoney(plr, 5000)
        end
        
        if plr then
            setTimer(function()
                local x, y, z = unpack(getElementData(plr, 'player:miner:savepos'))
                setElementPosition(plr, x, y, z)
                setElementData(plr, 'player:miner:savepos', false)
            end, 100, 1)
        end
    end
end

function enterVehicle(player, seat, jacked)
    if getElementData(source, 'vehicle:job') and getElementData(source, 'vehicle:job') == 'miner' and getElementData(source, 'vehicle:jobOwner') and getElementData(source, 'vehicle:jobOwner') ~= player then
        cancelEvent()
    end
end
addEventHandler("onVehicleStartEnter", root, enterVehicle)

function onTryExit(plr, seat, jacked)
    if not plr then 
        return
    end
    
    if not tryExit[plr] then tryExit[plr] = 0 end

    tryExit[plr] = tryExit[plr] + 1

    if tryExit[plr] == 1 then
        exports['since-notifications']:sendNotification(plr, 'info', 'Aby zakończyć wywóz wyjdź z pojazdu (Kaucja nie zostanie zwrócona)')

        setTimer(function()
            tryExit[plr] = 0
        end, 500, 1)

        cancelEvent()
    elseif tryExit[plr] >= 2 then
        tryExit[plr] = 0
        exports['since-notifications']:sendNotification(plr, 'success', 'Wywóz zakończony')
        cancelEvent()

        stopWywoz(plr)
    end
end
addEventHandler("onVehicleStartExit", resourceRoot, onTryExit)