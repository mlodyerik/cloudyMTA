local trucks = {

    [514] = true,
    [515] = true,
    [443] = true,
    [403] = true,
    [532] = true,
    [408] = true,
    [431] = true,
    [437] = true,

}

addEvent('since-przecho:getVehicle',true)
addEventHandler('since-przecho:getVehicle',resourceRoot,function(trigger, types)
    local plr = client

    local vehicles = {}
    local orgVehicles = {}

    local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE owner=? AND state=?', getElementData(plr, 'player:sid'),1)
    if (#rows > 0) then
        for i,v in ipairs(rows) do

            if v.model >= 80000 then
                model = 'Automobile'
            else
                model = getVehicleType(v.model)
            end

            if types[model] then
                table.insert(vehicles, v)
            end
        end
    end

    local org = getElementData(plr, 'player:organization')
    if org then
        local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE organization=? AND state=1', org.id)
        if (#rows > 0) then
            for i,v in ipairs(rows) do

                if v.model >= 80000 then
                    model = 'Automobile'
                else
                    model = getVehicleType(v.model)
                end

                if types[model] then
                    table.insert(orgVehicles, v)
                end
            end
        end
    end

    triggerClientEvent(plr, trigger and trigger or 'since-przecho:getVehicle', plr, vehicles, orgVehicles)
    vehicles = {}
end)

categoryA = {[463] = true, [462] = true, [461] = true, [581] = true, [448] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true} 
categoryB = {[613] = true, [80001] = true, [80002] = true, [80003] = true, [80004] = true, [80005] = true, [602] = true, [545] = true, [401] = true, [496] = true, [517] = true, [585] = true, [410] = true, [518] = true, [600] = true, [506] = true, [436] = true, [589] = true, [580] = true, [419] = true, [506] = true, [533] = true, [549] = true, [526] = true, [491] = true, [474] = true, [445] = true, [467] = true, [604] = true, [426] = true, [507] = true, [547] = true, [585] = true, [405] = true, [587] = true, [409] = true, [466] = true, [550] = true, [492] = true, [566] = true, [546] = true, [540] = true, [551] = true, [421] = true, [516] = true, [529] = true, [488] = true, [460] = true, [469] = true, [487] = true, [510] = true, [509] = true, [481] = true, [586] = true, [472] = true, [473] = true, [493] = true, [595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, [454] = true, [485] = true, [552] = true, [438] = true, [574] = true, [420] = true, [525] = true, [408] = true, [596] = true, [597] = true, [427] = true, [599] = true, [490] = true, [432] = true, [528] = true, [601] = true, [407] = true, [544] = true, [470] = true, [598] = true, [588] = true, [532] = true, [443] = true, [486] = true, [531] = true, [543] = true, [422] = true, [583] = true, [478] = true, [605] = true, [554] = true, [530] = true, [418] = true, [572] = true, [582] = true, [536] = true, [575] = true, [534] = true, [567] = true, [535] = true, [576] = true, [412] = true, [402] = true, [542] = true, [603] = true, [475] = true, [449] = true, [537] = true, [570] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [568] = true, [557] = true, [424] = true, [504] = true, [495] = true, [457] = true, [539] = true, [483] = true, [571] = true, [500] = true,  [444] = true, [556] = true, [429] = true, [411] = true, [541] = true, [559] = true, [415] = true, [561] = true, [480] = true, [560] = true, [562] = true, [506] = true, [565] = true, [451] = true, [434] = true, [558] = true, [494] = true, [535] = true, [502] = true, [477] = true, [503] = true, [579] = true, [400] = true, [404] = true, [489] = true, [505] = true, [479] = true, [442] = true, [458] = true, [606] = true, [607] = true, [610] = true, [590] = true, [569] = true, [611] = true, [584] = true, [608] = true, [435] = true, [450] = true, [591] = true, [594] = true}
categoryC = {[403] = true, [406] = true, [413] = true, [414] = true, [416] = true, [423] = true, [428] = true, [431] = true, [433] = true, [437] = true, [440] = true, [455] = true, [456] = true, [459] = true, [482] = true, [498] = true, [499] = true, [508] = true, [514] = true, [515] = true, [524] = true, [538] = true, [573] = true}

function isPlayerHaveLicense(player, license)
    local licenses = getElementData(player, 'player:licenses') or {}
    return licenses[license]
end

function ifHaveLicense(plr, veh)
    if not categoryA[veh] and not categoryB[veh] and not categoryC[veh] then
        return true
    end
    
    if categoryA[veh] then
        if isPlayerHaveLicense(plr, "a") then
            return true
        else
            return false
        end
    elseif categoryB[veh] then
        if isPlayerHaveLicense(plr, "b") then
            return true
        else
            return false
        end
    elseif categoryC[veh] then
        if isPlayerHaveLicense(plr, "c") then
            return true
        else
            return false
        end
    end
end

addEvent('since-przecho:tryTakeVehicle', true)
addEventHandler('since-przecho:tryTakeVehicle', resourceRoot, function(id, pos)
    local plr = client

    local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id=? AND owner=? LIMIT 1', id, getElementData(plr,'player:sid'))

    if (#rows > 0) then 
        local result = exports["since-db"]:query("SELECT * FROM `since-punishments` WHERE serial=? AND type=? AND active=1 AND time>NOW()", getPlayerSerial(plr), 'zpj')
        if result and #result > 0 then
                outputChatBox(' ', plr, 255, 0, 0, true)
                outputChatBox("✘#ffffff Posiadasz zawieszone prawo jazdy!\n- Koniec kary: #c4c4c4"..result[1].time.."#ffffff.\n- Powód: #c4c4c4"..result[1].reason..'#ffffff.', plr, 255, 0, 0, true)
                outputChatBox(' ', plr, 255, 0, 0, true)
            return
        else
            exports["since-db"]:query("DELETE FROM `since-punishments` WHERE serial=? AND type=? AND active=1 AND time<NOW()", getPlayerSerial(plr), 'zpj')
        end

        if ifHaveLicense(plr, rows[1].model) then

        if rows[1].state ~= 1 then 
            exports['since-notifications']:sendNotification(plr, 'error', 'Pojazd został już wyjęty.')
            return 
        end

        if trucks[rows[1].model] then
            pos[3] = pos[3] + 1
        end

        rows[1].position = serpent.dump(pos)
        
            local vehicle = exports['since-core']:loadVehicle(rows[1])
            exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 0, id)

            setTimer( function()
                if isElement(vehicle) then
                    setElementFrozen(vehicle, false)  -- Odblokuj pojazd po wyjęciu z przechowalni
                    warpPedIntoVehicle(plr, vehicle)
                    exports['since-notifications']:sendNotification(plr, 'success', 'Pojazd został odebrany.')
                end
            end, 300, 1)
        else
            exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz wyjąć pojazdu ponieważ nie posiadasz prawa jazdy')
        end
    else
        local org = getElementData(plr, 'player:organization')
        if org then
            local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE id=? AND organization=? LIMIT 1', id, org.id)
            if (#rows > 0) then 
                if rows[1].state ~= 1 then 
                    exports['since-notifications']:sendNotification(plr, 'error', 'Pojazd został już wyjęty.')
                    return 
                end

                if trucks[rows[1].model] then
                    pos[3] = pos[3] + 1
                end
                
                local result = exports["since-db"]:query("SELECT * FROM `since-punishments` WHERE serial=? AND type=? AND active=1 AND time>NOW()", getPlayerSerial(plr), 'zpj')
                if result and #result > 0 then
                        outputChatBox(' ', plr, 255, 0, 0, true)
                        outputChatBox("✘#ffffff Posiadasz zawieszone prawo jazdy!\n- Koniec kary: #c4c4c4"..result[1].time.."#ffffff.\n- Powód: #c4c4c4"..result[1].reason..'#ffffff.', plr, 255, 0, 0, true)
                        outputChatBox(' ', plr, 255, 0, 0, true)
                    return
                else
                    exports["since-db"]:query("DELETE FROM `since-punishments` WHERE serial=? AND type=? AND active=1 AND time<NOW()", getPlayerSerial(plr), 'zpj')
                end

                if ifHaveLicense(plr, rows[1].model) then
                    rows[1].position = serpent.dump(pos)
                    
                    local vehicle = exports['since-core']:loadVehicle(rows[1])
                    exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 0, id)
        
                    setTimer( function()
                        if isElement(vehicle) then
                            setElementFrozen(vehicle, false)  -- Odblokuj pojazd po wyjęciu z przechowalni
                            warpPedIntoVehicle(plr, vehicle)
                            exports['since-notifications']:sendNotification(plr, 'success', 'Pojazd został odebrany.')
                        end
                    end, 300, 1)
                else
                    exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz wyjąć pojazdu ponieważ nie posiadasz prawa jazdy')
                end
            end
        end
    end
end)

addEvent('since-przecho:tryReturnVehicle',true)
addEventHandler('since-przecho:tryReturnVehicle',resourceRoot,function()
    local plr = client
    local veh = getPedOccupiedVehicle(plr)
    if not veh then return end
    if not getElementData(veh,'vehicle:id') then return end
    exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, getElementData(veh,'vehicle:id'))
    exports['since-core']:saveVehicle(veh)
    exports['since-notifications']:sendNotification(plr, 'success', 'Pojazd został oddany.')
    destroyElement(veh)
end)