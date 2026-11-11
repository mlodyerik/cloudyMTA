local vehicles = {}
local deafultTables = {
    ['vehicles'] = {},
    ['stats'] = {
        imported = 0,
        exported = 0,
        earned = 0
    }
}

addEvent('importexport', true)
addEventHandler('importexport', resourceRoot, function(action, data)
    if action == 'getInfo' then
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then triggerClientEvent(client, 'importexport', resourceRoot, 'giveInfo', false) return end
        db[1].vehicles = #db[1].vehicles > 0 and fromJSON(db[1].vehicles) or deafultTables['vehicles']
        db[1].stats = #db[1].stats > 0 and fromJSON(db[1].stats) or deafultTables['stats']
        triggerClientEvent(client, 'importexport', resourceRoot, 'giveInfo', db[1])

    elseif action == 'buy' then
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db > 0 then outputChatBox('❌ #FFFFFFPosiadasz już zakupiony garaż!', client, 255,55,55,true) return end
        local db = exports['since-db']:query('select * from `since-users` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz konta!', client, 255,55,55,true) return end
        if db[1].bankMoney < cost then outputChatBox('❌ #FFFFFFNie posiadasz wystarczającej ilości gotówki!', client, 255,55,55,true) return end
        exports['since-db']:query('update `since-users` set bankMoney = bankMoney - ? where uid = ?', cost, getElementData(client, 'player:sid'))
        exports['since-db']:query('insert into `since-importExport` (uid, vehicles, stats, ownedDate) values (?, ?, ?, NOW())', getElementData(client, 'player:sid'), toJSON(deafultTables['vehicles']), toJSON(deafultTables['stats']))
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie udało się zakupić garazu!', client, 255,55,55,true) return end
        db[1].vehicles = deafultTables['vehicles']
        db[1].stats = deafultTables['stats']
        triggerClientEvent(client, 'importexport', resourceRoot, 'giveInfo', db[1])
        outputChatBox('✔️ #FFFFFFZakupiłeś garaż Import Export.', client, 55,255,55,true)

    elseif action == 'startImport' then
        if vehicles[client] then
            if vehicles[client].buritto and isElement(vehicles[client].buritto) then destroyElement(vehicles[client].buritto) vehicles[client].buritto = nil end
            if vehicles[client].imported and isElement(vehicles[client].imported) then destroyElement(vehicles[client].imported) vehicles[client].imported = nil end
            if vehicles[client].exported and isElement(vehicles[client].exported) then destroyElement(vehicles[client].exported) vehicles[client].exported = nil end
            if vehicles[client].trailer and isElement(vehicles[client].trailer) then destroyElement(vehicles[client].trailer) vehicles[client].trailer = nil end
        end

        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz zakupionego garażu!', client, 255,55,55,true) return end

        local x,y,z,rx,ry,rz = unpack(createVehiclePosition)
        local veh = createVehicle(482, x,y,z,rx,ry,rz)
        exports['since-handlings']:loadVehicleCustomHandling(veh)
        setElementData(veh, 'element:ghost', true)
        setVehicleColor(veh, 255,255,255,255,255,255)
        setVehicleVariant(veh, 0,0)
        setElementDimension(client, 0)
        warpPedIntoVehicle(client, veh)
        local model = data[2]
        local baseModel, isCustom = exports['since-custommodels']:checkModelID(model, 'vehicle')
        local vehicle = createVehicle(isCustom and baseModel or model, unpack(data[3]))
        if isCustom then
            setElementData(vehicle, 'baseID', baseModel)
            setElementData(vehicle, 'vehicleID', model)
        end
        exports['since-handlings']:loadVehicleCustomHandling(vehicle)
        setVehicleVariant(vehicle, 0,0)
        setElementData(vehicle, 'element:ghost', true)
        setVehicleColor(vehicle, 255,255,255,255,255,255)
        setElementFrozen(vehicle, true)

        vehicles[client] = {
            buritto = veh,
            imported = vehicle
        }

        triggerClientEvent(client, 'importexport', resourceRoot, 'staredImport', data)
        outputChatBox('✔️ #FFFFFFRozpoczynasz import pojazdu, udaj się do celu. Czas na przejęcie samochodu 20 minut!', client, 55,255,55,true)

    elseif action == 'importFinish' then
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz zakupionego garażu!', client, 255,55,55,true) return end
        if isElement(vehicles[client].buritto) then destroyElement(vehicles[client].buritto) vehicles[client].buritto = nil end
        if isElement(vehicles[client].imported) then destroyElement(vehicles[client].imported) vehicles[client].imported = nil end
        vehicles[client] = nil

        local tbl = fromJSON(db[1].vehicles)
        table.insert(tbl, {data[1], data[2]})
        local stats = #db[1].stats > 0 and fromJSON(db[1].stats) or deafultTables['stats']
        stats.imported = stats.imported + 1
        exports['since-db']:query('update `since-importExport` set vehicles = ?, stats = ? where uid = ?', toJSON(tbl), toJSON(stats), getElementData(client, 'player:sid'))
        outputChatBox('✔️ #FFFFFFPomyślnie zimportowałeś pojazd.', client, 55,255,55,true)

    elseif action == 'importFailed' then
        if vehicles[client].buritto and isElement(vehicles[client].buritto) then destroyElement(vehicles[client].buritto) vehicles[client].buritto = nil end
        if vehicles[client].imported and isElement(vehicles[client].imported) then destroyElement(vehicles[client].imported) vehicles[client].imported = nil end
        vehicles[client] = nil
        outputChatBox('❌ #FFFFFFNie udało się zimportować pojazdu na czas.', client, 255,55,55,true)
        setTimer(setElementPosition, 500, 1, client, 1229.26, 184.42, 20.00)

    elseif action == 'startExport' then
        if vehicles[client] then
            if vehicles[client].buritto and isElement(vehicles[client].buritto) then destroyElement(vehicles[client].buritto) vehicles[client].buritto = nil end
            if vehicles[client].imported and isElement(vehicles[client].imported) then destroyElement(vehicles[client].imported) vehicles[client].imported = nil end
            if vehicles[client].exported and isElement(vehicles[client].exported) then destroyElement(vehicles[client].exported) vehicles[client].exported = nil end
            if vehicles[client].trailer and isElement(vehicles[client].trailer) then destroyElement(vehicles[client].trailer) vehicles[client].trailer = nil end
        end
        
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz zakupionego garażu!', client, 255,55,55,true) return end
        local tbl = fromJSON(db[1].vehicles)
        local i,v = findIndex(tbl, data[1])
        if not v then outputChatBox('❌ #FFFFFFNie posiadasz tego pojazdu!', client, 255,55,55,true) return end
        local x,y,z,rx,ry,rz = unpack(createVehiclePosition)
        local model = v[2]
        local baseModel, isCustom = exports['since-custommodels']:checkModelID(model, 'vehicle')
        local veh = createVehicle(isCustom and baseModel or model, x,y,z,rz,rx,ry)
        if isCustom then
            setElementData(veh, 'baseID', baseModel)
            setElementData(veh, 'vehicleID', model)
        end
        exports['since-handlings']:loadVehicleCustomHandling(veh)
        setElementData(veh, 'element:ghost', true)
        setVehicleVariant(veh, 0,0)
        setVehicleColor(veh, 255,255,255,255,255,255)
        setElementDimension(client, 0)
        warpPedIntoVehicle(client, veh)

        vehicles[client] = {
            exported = veh
        }
        triggerClientEvent(client, 'importexport', resourceRoot, 'staredExport', data)
        outputChatBox('✔️ #FFFFFFRozpoczynasz export pojazdu, udaj się do celu.', client, 55,255,55,true)

    elseif action == 'exportFinish' then
        local all = nil
        if vehicles[client].trailer then all = true end
        if vehicles[client].exported and isElement(vehicles[client].exported) then destroyElement(vehicles[client].exported) vehicles[client].exported = nil end
        if vehicles[client].trailer and isElement(vehicles[client].trailer) then destroyElement(vehicles[client].trailer) vehicles[client].trailer = nil end
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz zakupionego garażu!', client, 255,55,55,true) return end
        local tbl = fromJSON(db[1].vehicles)
        local stats = #db[1].stats > 0 and fromJSON(db[1].stats) or deafultTables['stats']
        if all then
            local money = 0
            for i,v in ipairs(tbl) do
                stats.exported = stats.exported + 1
                stats.earned = stats.earned + (vehiclePrices[v[2]] * exports['since-jobs']:getJobMultiplier('import'))
                local m = vehiclePrices[v[2]] * exports['since-jobs']:getJobMultiplier('import')
                local voucher = exports['since-vouchers']:getJobVoucher(client, 'import')/100
                m = m + math.floor(m * voucher)
                money = money + m
            end
            outputChatBox('✔️ #FFFFFFPomyślnie wyexportowano wszystkie pojazdy, twoje wynagrodzenie: '..formatNumber(money)..' $.', client, 55,255,55,true)
            exports['since-db']:query('update `since-users` set bankMoney = bankMoney + ? where uid = ?', money, getElementData(client, 'player:sid'))
            tbl = {}
        else
            local i,v = findIndex(tbl, data[1])
            if not v then outputChatBox('❌ #FFFFFFNie posiadasz tego pojazdu!', client, 255,55,55,true) return end
            table.remove(tbl, i)
            stats.exported = stats.exported + 1

            local money = vehiclePrices[v[2]] * exports['since-jobs']:getJobMultiplier('import')

            local voucher = exports['since-vouchers']:getJobVoucher(client, 'import')/100
            money = money + math.floor(money * voucher)

            stats.earned = stats.earned + money
            outputChatBox('✔️ #FFFFFFPomyślnie wyexportowano pojazd, twoje wynagrodzenie: '..formatNumber(money)..' $.', client, 55,255,55,true)
            exports['since-db']:query('update `since-users` set bankMoney = bankMoney + ? where uid = ?', (money), getElementData(client, 'player:sid'))
        end
        exports['since-db']:query('update `since-importExport` set vehicles = ?, stats = ? where uid = ?', toJSON(tbl), toJSON(stats), getElementData(client, 'player:sid'))
        setTimer(setElementPosition, 500, 1, client, 1229.26, 184.42, 20.00)

    elseif action == 'exportAll' then
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz zakupionego garażu!', client, 255,55,55,true) return end
        local tbl = fromJSON(db[1].vehicles)
        
        local x,y,z,rx,ry,rz = unpack(createTruckPosition)
        local veh = createVehicle(515, x,y,z,rx,ry,rz)
        exports['since-handlings']:loadVehicleCustomHandling(veh)
        setElementData(veh, 'element:ghost', true)
        setVehicleVariant(veh, 0,0)
        setVehicleColor(veh, 255,255,255,255,255,255)
        setElementDimension(client, 0)
        warpPedIntoVehicle(client, veh)

        local x,y,z,rx,ry,rz = unpack(createTrailerPosition)
        local trailer = createVehicle(435, x,y,z,rx,ry,rz)
        setElementData(trailer, 'element:ghost', true)
        setVehicleVariant(trailer, 0,0)
        attachTrailerToVehicle(veh, trailer)

        vehicles[client] = {
            exported = veh,
            trailer = trailer
        }
        triggerClientEvent(client, 'importexport', resourceRoot, 'staredExport', data)
        outputChatBox('✔️ #FFFFFFRozpoczynasz export wszystkich pojazdów, udaj się do celu.', client, 55,255,55,true)

    elseif action == 'enterGarage' then
        local db = exports['since-db']:query('select * from `since-importExport` where uid = ? limit 1', getElementData(client, 'player:sid'))
        if #db == 0 then outputChatBox('❌ #FFFFFFNie posiadasz zakupionego garażu!', client, 255,55,55,true) return end
        setElementPosition(client, 1220.15, 183.15, -0.12)
        setElementDimension(client, getElementData(client, 'player:sid'))
        triggerClientEvent(client, 'importexport', resourceRoot, 'enterGarage', #db[1].vehicles > 0 and fromJSON(db[1].vehicles) or deafultTables['vehicles'])
        outputChatBox('✔️ #FFFFFFWchodzisz do garażu.', client, 55,255,55,true)

    elseif action == 'exitGarage' then
        setElementDimension(client, 0)
        setElementPosition(client, 1229.26, 184.42, 20.00)
        triggerClientEvent(client, 'importexport', resourceRoot, 'exitGarage')
        outputChatBox('✔️ #FFFFFFWychodzisz z garażu.', client, 55,255,55,true)

    end
end)

addEventHandler('onTrailerDetach', resourceRoot, function(truck)
    local player = getVehicleController(truck)
    if vehicles[player] and vehicles[player].trailer and source == vehicles[player].trailer then
        attachTrailerToVehicle(truck, source)
    end
end)

addEventHandler('onVehicleStartEnter', resourceRoot, function(plr)
    if vehicles[plr] then
        if source == vehicles[plr].imported then
            return
        end

        if source == vehicles[plr].exported then
            return
        end

        if source ~= vehicles[plr].buritto then
            cancelEvent()
            return
        end
    end
end)

addEventHandler('onVehicleStartEnter', resourceRoot, function(plr)
    if not vehicles[plr] then cancelEvent() return end
    if source == vehicles[plr].buritto or source == vehicles[plr].imported then
        return
    end
    cancelEvent()
end)

addEventHandler('onVehicleEnter', resourceRoot, function(plr, seat)
    if seat ~= 0 then return end
    if vehicles[plr] and vehicles[plr].imported and source == vehicles[plr].imported then
        triggerClientEvent(plr, 'importexport', resourceRoot, 'enteredImported')
        setElementFrozen(vehicles[plr].imported, false)
        if isElement(vehicles[plr].buritto) then destroyElement(vehicles[plr].buritto) vehicles[plr].buritto = nil end
    end
end)

addEventHandler('onVehicleStartExit', resourceRoot, function(plr)
    if not vehicles[plr] then return end
    if source == vehicles[plr].exported or source == vehicles[plr].imported then
        cancelEvent()
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if vehicles[source] then
        if vehicles[source].buritto and isElement(vehicles[source].buritto) then destroyElement(vehicles[source].buritto) end
        if vehicles[source].imported and isElement(vehicles[source].imported) then destroyElement(vehicles[source].imported) end
        if vehicles[source].exported and isElement(vehicles[source].exported) then destroyElement(vehicles[source].exported) end
        if vehicles[source].trailer and isElement(vehicles[source].trailer) then destroyElement(vehicles[source].trailer) end
        vehicles[source] = nil
    end
end)

addEventHandler('onPlayerWasted', root, function()
    if vehicles[source] then
        if vehicles[source].buritto and isElement(vehicles[source].buritto) then destroyElement(vehicles[source].buritto) end
        if vehicles[source].imported and isElement(vehicles[source].imported) then destroyElement(vehicles[source].imported) end
        if vehicles[source].exported and isElement(vehicles[source].exported) then destroyElement(vehicles[source].exported) end
        if vehicles[source].trailer and isElement(vehicles[source].trailer) then destroyElement(vehicles[source].trailer) end
        vehicles[source] = nil
    end
end)
