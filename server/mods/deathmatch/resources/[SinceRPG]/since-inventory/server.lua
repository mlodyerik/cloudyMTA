local treshold = {}

addEvent('useItem', true)
addEventHandler('useItem', resourceRoot, function(name, token)
    if (not treshold[client]) then
        treshold[client] = 0
    end
    treshold[client] = treshold[client] + 1
    if (treshold[client] > 10) then
        exports['since-antycheat']:detect(client, 'Próba spammu eventem użycia przedmiotów')
        return false
    end
    local itemData = getItemInfo(name)
    if itemData and itemData.useServer then
        itemData.useServer(client, token)
    end
end)

setTimer(function()
    treshold = {}
end, 1000, 0)

addEvent('useItemVoucher', true)
addEventHandler('useItemVoucher', resourceRoot, function(name, ...)
    if not getItemInfo(name) then return end
    exports['since-vouchers']:useVoucher(client, arg[1], arg[2], arg[3])
    exports['since-logs']:sendDiscordLog('vouchery-eq', getPlayerName(client)..' (SID: '..getElementData(client, 'player:sid')..')', 'Użył vouchera '..name..' na prace '..arg[1]..' +'..arg[2]..'% na czas '..arg[3]..' minut')
end)

addEvent('useItemTune', true)
addEventHandler('useItemTune', resourceRoot, function(name, vehicle)
    if not getItemInfo(name) then return end
    local localVeh = getPedOccupiedVehicle(client)
    if not vehicle or not localVeh then return end
    if localVeh ~= vehicle then return end
    if not getElementData(vehicle, 'vehicle:id') then return end
    if getElementData(vehicle, 'vehicle:owner') ~= getElementData(client, 'player:sid') then
        return
    end
    if name == 'stereo' then
        local info = getVehicleUpgradeOnSlot(vehicle, 10)
        if (info == 1086) then
            return
        end
        addVehicleUpgrade(vehicle, 1086)
        exports['since-notifications']:sendNotification(client, 'success', 'Zamontowano unikatowy tuning '..name)
        return
    end
    local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
    if tunings[name] then
        return
    end
    if name == 'vopisrgb' then
        tunings['vopis'] = true
    end
    tunings[name] = true
    setElementData(vehicle, 'vehicle:upgrades', tunings)
    exports['since-notifications']:sendNotification(client, 'success', 'Zamontowano unikatowy tuning '..name)
    exports['since-logs']:sendDiscordLog('tuningi-eq', getPlayerName(client)..' (SID: '..getElementData(client, 'player:sid')..')', 'Zamontował unikatowy tuning '..name..' na pojeździe o id '..getElementData(vehicle, 'vehicle:id'))
end)

function startTrade(playerA, playerB)
    setElementData(playerA, 'trade', {
        player = playerB,
        state = 'waiting',
        items = {},
    })

    setElementData(playerB, 'trade', {
        player = playerA,
        state = 'waiting',
        items = {},
    })

    triggerClientEvent(playerA, 'trade:start', resourceRoot)
    triggerClientEvent(playerB, 'trade:start', resourceRoot)
end

addEvent('trade:stop', true)
addEventHandler('trade:stop', resourceRoot, function(player)
    local data = getElementData(player, 'trade')
    if (not data) then 
        return false
    end

    triggerClientEvent(player, 'trade:stop', resourceRoot)

    exports['since-notifications']:sendNotification(client, 'info', 'Wymiana została przerwana')
    exports['since-notifications']:sendNotification(player, 'info', 'Wymiana została przerwana')
end)

addEvent('trade:done', true)
addEventHandler('trade:done', resourceRoot, function(player, itemsA, itemsB)
    if (not isElement(player)) then 
        return false
    end

    if (client == player) then
        return exports['since-antycheat']:detect(client, 'Próba nadania sobie przedmiotów')
    end

    local itemsFromPlayerA = getElementData(client, 'player:inventory') or {}
    local itemsFromPlayerAFormatted = {}
    for _,v in pairs(itemsFromPlayerA) do
        itemsFromPlayerAFormatted[v.name] = (itemsFromPlayerAFormatted[v.name] or 0) + v.amount
    end

    local itemsFromPlayerB = getElementData(player, 'player:inventory') or {}
    local itemsFromPlayerBFormatted = {}
    for _,v in pairs(itemsFromPlayerB) do
        itemsFromPlayerBFormatted[v.name] = (itemsFromPlayerBFormatted[v.name] or 0) + v.amount
    end

    for _,v in pairs(itemsA) do
        if (not itemsFromPlayerAFormatted[v.name]) or (itemsFromPlayerAFormatted[v.name] < v.amount) then
            return exports['since-antycheat']:detect(client, 'Próba nadania sobie przedmiotów, przedmiot nie istnieje')
        end
    end

    for _,v in pairs(itemsB) do
        if (not itemsFromPlayerBFormatted[v.name]) or (itemsFromPlayerBFormatted[v.name] < v.amount) then
            return exports['since-antycheat']:detect(client, 'Próba nadania sobie przedmiotów, przedmiot nie istnieje')
        end
    end

    local itemsData = {}
    for _,v in pairs(itemsA) do
        local itemData = getItemDataByToken(client, v.token)
        itemsData[v.token] = itemData
    end

    for _,v in pairs(itemsB) do
        local itemData = getItemDataByToken(player, v.token)
        itemsData[v.token] = itemData
    end

    for _,v in pairs(itemsA) do
        local itemData = itemsData[v.token]
        removeItemByToken(client, v.token, v.amount)
        addPlayerItemWithData(player, v.name, v.amount, itemData)
    end
    
    for _,v in pairs(itemsB) do
        local itemData = itemsData[v.token]
        removeItemByToken(player, v.token, v.amount)
        addPlayerItemWithData(client, v.name, v.amount, itemData)
    end

    exports['since-notifications']:sendNotification(client, 'success', 'Wymiana zakończona pomyślnie')
    exports['since-notifications']:sendNotification(player, 'success', 'Wymiana zakończona pomyślnie')
end)

function isPriceCorrect(item, price)
    for _,v in ipairs(shops) do
        if (v.items and #v.items > 0) then
            for _,itemData in ipairs(v.items) do
                if (itemData.name == item) then
                    if (itemData.price == price) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

addEvent('shopBuy', true)
addEventHandler('shopBuy', resourceRoot, function(cart, total)
    if (getPlayerMoney(client) < total) then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz tyle gotówki')
    end
    
    local cache = {}
    local itemsAvailable = {}
    local cost = 0
    local incorrectPrice = 0
    
    for i,v in pairs(cart) do
        if not cache[v.name] then
            cache[v.name] = {0, 0}
        end
        cache[v.name][1] = cache[v.name][1] + v.amount
        cache[v.name][2] = cache[v.name][2] + v.price
    end

    for itemName,itemCount in pairs(cache) do
        for _,shopList in ipairs(shops) do
            if (shopList.items and #shopList.items > 0) then
                for _,item in ipairs(shopList.items) do
                    if (item.name == itemName) then
                        if (not itemsAvailable[itemName]) then
                            itemsAvailable[itemName] = {}
                        end
                        table.insert(itemsAvailable[itemName], item)
                    end
                end
            end
        end
    end

    for i,v in pairs(cache) do
       if (not itemsAvailable[i]) then
            return exports['since-antycheat']:detect(client, 'Próba nadania sobie przedmiotów, przedmiot nie istnieje')
        end
    end

    for itemName,v in pairs(cache) do
        if isPriceCorrect(itemName, v[2]) then
            cost = cost + (v[1] * v[2])
        else
            incorrectPrice = incorrectPrice + 1
        end
    end

    if (cost ~= total) or (incorrectPrice > 0) then
        return exports['since-antycheat']:detect(client, 'Próba nadania sobie przedmiotów, cena nie zgadza się')
    end

    takePlayerMoney(client, total)

    for i,v in pairs(cart) do
        if v.amount > 0 then
            addPlayerItem(client, v.name, v.amount)
        end
    end

    exports['since-notifications']:sendNotification(client, 'success', 'Zakupiono przedmioty za $ '..total)
end)

function getPlayerFromPartialName(name)
    local name = name and name:gsub('#%x%x%x%x%x%x', ''):lower()
    if not name then
        return
    end

    local players = getElementsByType('player')
    for _,player in ipairs(players) do
        local name_ = getPlayerName(player):gsub('#%x%x%x%x%x%x', ''):lower()
        if name_:find(name, 1, true) then
            return player
        end
    end
end

local waitingTrades = {}
local sentTrades = {}

function sendTradeOffer(player, target)
    if not target then return end
    local targetPlayer = exports['since-core']:findPlayer(player, target)
    if not targetPlayer then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza') end
    if targetPlayer == player then return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wymienić się sam ze sobą') end
    if getElementData(player, 'trade') then return exports['since-notifications']:sendNotification(player, 'error', 'Już jesteś w trakcie wymiany') end
    if getElementData(targetPlayer, 'trade') then return exports['since-notifications']:sendNotification(player, 'error', 'Ten gracz jest już w trakcie wymiany') end

    exports['since-notifications']:sendNotification(player, 'info', 'Wysłano propozycję wymiany do '..getPlayerName(targetPlayer))
    exports['since-notifications']:sendNotification(targetPlayer, 'info', 'Otrzymano propozycję wymiany od '..getPlayerName(player) .. ' (/trade)')
    
    waitingTrades[targetPlayer] = {player, getTickCount()+30000}
    sentTrades[player] = {targetPlayer, getTickCount()+30000}
end

addCommandHandler('trade', function(player)
    local targetPlayer = waitingTrades[player]
    if not targetPlayer then return exports['since-notifications']:sendNotification(player, 'error', 'Nie otrzymano propozycji wymiany') end
    if sentTrades[targetPlayer[1]][1] ~= player then return exports['since-notifications']:sendNotification(player, 'error', 'Nie otrzymano propozycji wymiany') end
    if getTickCount() > targetPlayer[2] then return exports['since-notifications']:sendNotification(player, 'error', 'Propozycja wymiany wygasła') end
    if getElementData(player, 'trade') then return exports['since-notifications']:sendNotification(player, 'error', 'Już jesteś w trakcie wymiany') end
    if getElementData(targetPlayer[1], 'trade') then return exports['since-notifications']:sendNotification(player, 'error', 'Ten gracz jest już w trakcie wymiany') end

    startTrade(player, targetPlayer[1])
    waitingTrades[player] = nil
    sentTrades[targetPlayer] = nil
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element ) 
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1] 
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z 
end

local timers = {}

function trytytka(plr, cmd, targ)
    if getElementData(plr, "player:gang") then
        if not targ then
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie podałeś gracza')
            return false
        end

        local isItem = false
        local items = getElementData(plr, "player:inventory") or {}
        for i,v in ipairs(items) do
            if (v.name == 'trytytki') then
                isItem = true
                break
            end
        end

        if (not isItem) then
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz trytytek')
            return false
        end

        if isPedInVehicle(plr) then
            return false
        end

        local target = exports["since-core"]:findPlayer(plr, targ)

        if not target then
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza')
            return false
        end

        if target == plr then
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz użyć trytytek na sobie')
            return false
        end

        local x, y, z = getElementPosition(plr)
        local x2, y2, z2 = getElementPosition(target)
        local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

        if distance > 5 then
            exports['since-notifications']:sendNotification(plr, 'error', 'Podany gracz jest za daleko')
            return false
        end

        if getElementData(plr, 'handcuff:target') then
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz użyć trytytek dwa razy')
            return false
        end

        if getElementData(target, 'handcuff:have') then
            exports['since-notifications']:sendNotification(plr, 'error', 'Gracz jest już złapany')
            return false
        end

        if isPedInVehicle(target) then
            removePedFromVehicle(target)
        end

        toggleControl(plr, "jump", false)
        toggleAllControls(target, false, true, false)
        toggleControl(target, "enter_exit", false)
        toggleControl(target, "enter_passenger", false)
		setPedAnimation(plr, "CHAINSAW", "csaw_part",  0, false, true, true)
        setPedAnimation(target, "FAT","IDLE_tired", -1, true, false)
        attachElements(target, plr, 0, 0.4, 0.0)

        outputChatBox('ⓘ#ffffff Zostałeś(aś) złapany przez członka organizacji przestępczej #cccccc'..getPlayerName(plr), target, 255, 255, 0, true)
        outputChatBox('ⓘ#ffffff Złapałeś(aś) gracza #cccccc'..getPlayerName(target), plr, 255, 255, 0, true)
        addPlayerItem(plr, 'trytytki', -1)

        setElementData(plr, "handcuff:target", target)
        setElementData(target, "handcuff:have", plr)

        local rX, rY, rZ = getElementRotation(plr)
        setElementRotation(target, rX, rY, rZ)
        
        timers[target] = setTimer(function(player, player2)
            if isElement(player) and isElement(player2) then
                local rX, rY, rZ = getElementRotation(player)
                setElementRotation(player2, rX, rY, rZ)
            end
        end, 100, 0, plr, target)
       -- triggerClientEvent(target, "enonek-bank_robbery:allEND", target)
    end
end
addCommandHandler("trytytka", trytytka)

function pusctryta(plr, cmd, targ)
    if getElementData(plr, "player:gang") then
        if not targ then
            return false
        end

        local target = exports["since-core"]:findPlayer(plr, targ)

        if not target then
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza')
            return false
        end

        if target == plr then
            return false
        end

        local x, y, z = getElementPosition(plr)
        local x2, y2, z2 = getElementPosition(target)
        local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

        if distance > 5 then
            exports['since-notifications']:sendNotification(plr, 'error', 'Gracz jest za daleko')
            return false
        end

        if not getElementData(target, "handcuff:have") then
            exports['since-notifications']:sendNotification(plr, 'error', 'Gracz nie jest złapany')
            return false
        end

        toggleControl(plr, "jump", true)
        toggleAllControls(target, true, true, false)
        toggleControl(target, "enter_exit", true)
        toggleControl(target, "enter_passenger", true)

        removeElementData(plr, "handcuff:target")
        removeElementData(target, "handcuff:have")

        outputChatBox('ⓘ#ffffff Zostałeś(aś) puszczony przez #cccccc'..getPlayerName(plr), target, 255, 255, 0, true)
        outputChatBox('ⓘ#ffffff Puściłeś(aś) gracza #cccccc'..getPlayerName(target), plr, 255, 255, 0, true)

        detachElements(target, plr)

        local x, y, z = getPositionFromElementOffset(plr, 0, 0.5, 0)
        setElementPosition(target, x, y, z)

        setPedAnimation(plr)
        setPedAnimation(target)

        if isTimer(timers[target]) then
            killTimer(timers[target])
        end
        timers[target] = nil
    end
end
addCommandHandler("u.trytytka", pusctryta)

addEventHandler("onVehicleStartEnter", getRootElement(), function(plr, seat)
    if getElementData(plr, "player:gang") then
        if getElementData(plr, "handcuff:target") then
            if seat == 0 then
                cancelEvent()
                return false
            end
            local target = getElementData(plr, "handcuff:target")
            if isElement(target) then
                detachElements(target, plr)

                setPedAnimation(target)
                setPedAnimation(plr)

                local x, y, z = getPositionFromElementOffset(plr, 0, 0.5, 2)
                setElementPosition(target, x, y, z)
                cancelEvent()
                toggleControl(plr, "jump", true)

                if isTimer(timers[target]) then
                    killTimer(timers[target])
                end
                timers[target] = nil
                removeElementData(plr, "handcuff:target")                
                setTimer(function(player, v, s)
                    warpPedIntoVehicle(player, v, s)
                    removeElementData(player, "handcuff:have")
                end, 500, 1, target, source, seat)
            end
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if getElementData(source, "handcuff:have") then
        local plr = getElementData(source, "handcuff:have")
        if isElement(plr) then
            removeElementData(plr, "handcuff:target")
            toggleControl(plr, "jump", true)
            setTimer(setPedAnimation, 100, 1, plr, false)
        end

        if isTimer(timers[source]) then
            killTimer(timers[source])
        end
        timers[source] = nil
    end

    if getElementData(source, "handcuff:target") then
        local target = getElementData(source, "handcuff:target")
        if isElement(target) then
            detachElements(target, source)
            removeElementData(target, "handcuff:have")
            toggleAllControls(target, true, true, false)
            toggleControl(target, "enter_exit", true)
            toggleControl(target, "enter_passenger", true)
            setTimer(setPedAnimation, 100, 1, target, false)
            if isTimer(timers[target]) then
                killTimer(timers[target])
            end
            timers[target] = nil
        end
    end
end)