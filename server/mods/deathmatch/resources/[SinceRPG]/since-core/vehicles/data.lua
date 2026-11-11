categoryA = {[463] = true, [462] = true, [461] = true, [581] = true, [448] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true} 
categoryB = {[613] = true, [80001] = true, [80002] = true, [80003] = true, [80004] = true, [80005] = true, [602] = true, [545] = true, [401] = true, [496] = true, [517] = true, [585] = true, [410] = true, [518] = true, [600] = true, [506] = true, [436] = true, [589] = true, [580] = true, [419] = true, [506] = true, [533] = true, [549] = true, [526] = true, [491] = true, [474] = true, [445] = true, [467] = true, [604] = true, [426] = true, [507] = true, [547] = true, [585] = true, [405] = true, [587] = true, [409] = true, [466] = true, [550] = true, [492] = true, [566] = true, [546] = true, [540] = true, [551] = true, [421] = true, [516] = true, [529] = true, [488] = true, [460] = true, [469] = true, [487] = true, [510] = true, [509] = true, [481] = true, [586] = true, [472] = true, [473] = true, [493] = true, [595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, [454] = true, [485] = true, [552] = true, [438] = true, [574] = true, [420] = true, [525] = true, [408] = true, [596] = true, [597] = true, [427] = true, [599] = true, [490] = true, [432] = true, [528] = true, [601] = true, [407] = true, [544] = true, [470] = true, [598] = true, [588] = true, [532] = true, [443] = true, [486] = true, [531] = true, [543] = true, [422] = true, [583] = true, [478] = true, [605] = true, [554] = true, [530] = true, [418] = true, [572] = true, [582] = true, [536] = true, [575] = true, [534] = true, [567] = true, [535] = true, [576] = true, [412] = true, [402] = true, [542] = true, [603] = true, [475] = true, [449] = true, [537] = true, [570] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [568] = true, [557] = true, [424] = true, [504] = true, [495] = true, [457] = true, [539] = true, [483] = true, [571] = true, [500] = true,  [444] = true, [556] = true, [429] = true, [411] = true, [541] = true, [559] = true, [415] = true, [561] = true, [480] = true, [560] = true, [562] = true, [506] = true, [565] = true, [451] = true, [434] = true, [558] = true, [494] = true, [535] = true, [502] = true, [477] = true, [503] = true, [579] = true, [400] = true, [404] = true, [489] = true, [505] = true, [479] = true, [442] = true, [458] = true, [606] = true, [607] = true, [610] = true, [590] = true, [569] = true, [611] = true, [584] = true, [608] = true, [435] = true, [450] = true, [591] = true, [594] = true}
categoryC = {[403] = true, [406] = true, [413] = true, [414] = true, [416] = true, [423] = true, [428] = true, [431] = true, [433] = true, [437] = true, [440] = true, [455] = true, [456] = true, [459] = true, [482] = true, [498] = true, [499] = true, [508] = true, [514] = true, [515] = true, [524] = true, [538] = true, [573] = true}

function loadVehicle(data)
    local position = loadstring((data.position and #data.position > 3) and data.position or "return {}")()
    local color = loadstring((data.color and #data.color > 3) and data.color or "return {}")()
    local headlight = loadstring((data.headlight and #data.headlight > 3) and data.headlight or "return {}")()
    local upgrades = loadstring((data.upgrades and #data.upgrades > 3) and data.upgrades or "return {}")()
    local fuel = loadstring((data.fuel and #data.fuel > 3) and data.fuel or "return {}")()
    local wheelTuning = loadstring((data.wheelTuning and #data.wheelTuning > 3) and data.wheelTuning or "return {}")()
    local data2 = loadstring((data.data and #data.data > 3) and data.data or "return {}")()
    local damages = loadstring((data.damages and #data.damages > 3) and data.damages or "return {}")()
    local variant = loadstring((data.variant and #data.variant > 2) and data.variant or "return {}")()

    local vehicle = nil
    local baseModel, isCustom = exports['since-custommodels']:checkModelID(data.model, 'vehicle')
    local x, y, z, rotX, rotY, rotZ = position[1] or 0, position[2] or 0, position[3] or 0, position[4] or 0, position[5] or 0, position[6] or 0
    if isCustom then
        vehicle = createVehicle(baseModel, x, y, z, rotX, rotY, rotZ,tostring(("%08d"):format(data.id)))
        setElementData(vehicle, 'baseID', baseModel)
        setElementData(vehicle, 'vehicleID', data.model)
        setElementData(vehicle, 'vehicle:model', data.model)
    else
        vehicle = createVehicle(data.model,x, y, z, rotX, rotY, rotZ,tostring(("%08d"):format(data.id)))
        setElementData(vehicle, 'vehicle:model', data.model)
    end

    setVehiclePlateText(vehicle, #data.licenseplate > 3 and data.licenseplate or 'LS '..data.id)

    setVehicleColor(vehicle,color[1],color[2],color[3],color[4],color[5],color[6],color[7],color[8],color[9],color[10],color[11],color[12])
    setVehicleHeadLightColor(vehicle, headlight[1],headlight[2],headlight[3])

    setElementData(vehicle,'vehicle:upgrades', upgrades)
    setElementData(vehicle,'vehicle:owner', data.owner)
    setElementData(vehicle,'vehicle:carTint', data.carTint)
    setElementData(vehicle,'vehicle:data', data2)

    setVehiclePaintjob(vehicle, upgrades['paintjob'] or 3)
    
    if data.organization and data.organization > 0 then
        setElementData(vehicle,'vehicle:organization', data.organization)
    end

    if not tonumber(fuel) and not fuel.countLPG then
        fuel.countLPG = 0 
    end

    setElementData(vehicle,'vehicle:fuel', fuel)
    setElementData(vehicle,'vehicle:wheelTuning', wheelTuning)
    setElementData(vehicle,'vehicle:id', data.id)

    if (type(data['rent']) == "string") then
        local tabelka = {}
        local rente = split(data['rent'], ',')

        for k, v in ipairs(rente) do
            table.insert(tabelka, v) 
        end

        setElementData(vehicle, "vehicle:rent", tabelka or false)
    else
        setElementData(vehicle, "vehicle:rent",0)
    end

    for i = 0, 6 do if damages[i + 1] then setVehiclePanelState(vehicle, i, damages[i + 1]) end end
    for i = 0, 1 do if damages[i + 8] then setVehicleLightState(vehicle, i, damages[i + 8]) end end
    for i = 0, 5 do if damages[i + 10] then setVehicleDoorState(vehicle, i, damages[i + 10]) end end
    setElementHealth(vehicle, damages[16] and damages[16] or 1000)
    
    for i,v in ipairs(split(data["tuning"], ",")) do 
        addVehicleUpgrade(vehicle, v) 
    end
    
    exports['since-handlings']:loadVehicleCustomHandling(vehicle)

    if upgrades['nitro'] then
        addVehicleUpgrade(vehicle, 1010)
        setElementData(vehicle,'vehicle:nitroCount',100)
    end

    setElementFrozen(vehicle, true)
    setVehicleVariant(vehicle, variant[1] or 0, variant[2] or 0)
    setElementData(vehicle, 'vehicle:variant', {variant[1] or 0, variant[2] or 0})

    return vehicle
end

function saveVehicle(vehicle)
    local id = getElementData(vehicle,'vehicle:id')
    if not id then 
        return 
    end
    local data = getElementData(vehicle,'vehicle:data') or {}
    local owner = getElementData(vehicle,'vehicle:owner')
    local fuel = getElementData(vehicle,'vehicle:fuel')
    local upgrades = getElementData(vehicle,'vehicle:upgrades') or {}
    local rent = getElementData(vehicle,'vehicle:rent')
    local carTint = getElementData(vehicle,'vehicle:carTint') or 0
    local paintjob = getVehiclePaintjob(vehicle)
    local wheelTuning = getElementData(vehicle,'vehicle:wheelTuning')
    local r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(vehicle, true)
    local h1,h2,h3 = getVehicleHeadLightColor(vehicle)
    local x,y,z = getElementPosition(vehicle)
    local rx, ry, rz = getElementRotation(vehicle)
    local clr = {r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4}
    local hclr = {h1,h2,h3}
    local position = {x,y,z,rx, ry, rz}
    tuning = getVehicleUpgrades(vehicle)
    local model = getElementData(vehicle, 'vehicleID') or getElementModel(vehicle)
    if not tuning then tuning = {} end
    tuning = table.concat(tuning, ",")

    upgrades['paintjob'] = paintjob
    
    local damages = {}
    for i = 0, 6 do table.insert(damages, getVehiclePanelState(vehicle, i)) end
    for i = 0, 1 do table.insert(damages, getVehicleLightState(vehicle, i)) end
    for i = 0, 5 do table.insert(damages, getVehicleDoorState(vehicle, i)) end
    damages[16] = math.floor(getElementHealth(vehicle))
    local variant1, variant2 = getVehicleVariant(vehicle)
    local variant = {variant1 or 0, variant2 or 0}
    local organization = getElementData(vehicle, 'vehicle:organization') or 0

    if (type(rent) == "table") then
        local rentTable = string.format("%s", table.concat(rent, ','))
        local rentUpdate = exports['since-db']:query("UPDATE `since-vehicles` SET rent = ? WHERE id = ?", rentTable, id)
    end

    exports['since-db']:query('UPDATE `since-vehicles` SET `data` = ?, `model` = ?, `owner` = ?, `fuel` = ?, `upgrades` = ?, `color` = ?, `headlight` = ?, `position` = ?, `tuning` = ?, `wheelTuning` = ?, `carTint` = ?, `damages` = ?, `variant` = ?, `organization` = ? WHERE id=? ', serpent.dump(data), model, owner, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(clr), serpent.dump(hclr), serpent.dump(position), tuning, serpent.dump(wheelTuning), carTint, serpent.dump(damages), serpent.dump(variant), organization, id)
end

addEventHandler('onVehicleStartEnter',root,function (plr, seat, jacked)
    if (getElementData(source,'vehicle:id')) then
        local owner = getElementData(source, 'vehicle:owner')
        local rent = getElementData(source, "vehicle:rent")
        local organization = getElementData(source, 'vehicle:organization')

        if seat == 0 then
            local result = exports["since-db"]:query("SELECT * FROM `since-punishments` WHERE serial=? AND type=? AND active=1 AND time>NOW()", getPlayerSerial(plr), 'zpj')
            if result and #result > 0 then
                    cancelEvent()
                    outputChatBox(' ', plr, 255, 0, 0, true)
                    outputChatBox("✘#ffffff Posiadasz zawieszone prawo jazdy!\n- Koniec kary: #c4c4c4"..result[1].time.."#ffffff.\n- Powód: #c4c4c4"..result[1].reason..'#ffffff.', plr, 255, 0, 0, true)
                    outputChatBox(' ', plr, 255, 0, 0, true)
                return
            else
                exports["since-db"]:query("UPDATE `since-punishments` SET active=0 WHERE serial=? AND type=? AND active=1 AND time<NOW()", getPlayerSerial(plr), 'zpj')
            end
    
            if categoryA[(getElementData(source, "vehicleID") or getElementModel(source))] then
                if not isPlayerHaveLicense(plr, "a") then
                        cancelEvent()
                        exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz prawa jazdy kat. A')
                    return
                end
            elseif categoryB[(getElementData(source, "vehicleID") or getElementModel(source))] then
                if not isPlayerHaveLicense(plr, "b") then
                        cancelEvent()
                        exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz prawa jazdy kat. B')
                    return
                end
            elseif categoryC[(getElementData(source, "vehicleID") or getElementModel(source))] then
                if not isPlayerHaveLicense(plr, "c") then
                        cancelEvent()
                        exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz prawa jazdy kat. C')
                    return
                end
            end
        end
        
        if seat == 0 then
            if rent and (type(rent) == "table") then
                for i, s in pairs(rent) do
                    if tonumber(s) == getElementData(plr, "player:sid") then
                        if jacked then
                            cancelEvent()
                        end
                        
                        return 
                    end
                end
            end

            local org = getElementData(plr, 'player:organization')
            if organization and org and organization == org.id then
                if jacked then
                    cancelEvent()
                end

                return
            end
        
            if (owner ~= getElementData(plr,'player:sid')) then
                if jacked then
                    cancelEvent()
                end
                
                if seat == 0 then
                    cancelEvent()
                    exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz kluczy do tego pojazdu!')
                end
            end
        end
    end
end)

addEventHandler('onVehicleEnter',root,function (plr, seat)
    local vehID = getElementData(source, "vehicle:id")

    if not vehID then
        return
    end

    if seat ~= 0 then
        return
    end

    local vehicleData = getElementData(source, "vehicle:data") or {}
    vehicleData['driver'] = getPlayerName(plr):gsub('#%x%x%x%x%x%x', '')
    setElementData(source, "vehicle:data", vehicleData)
    
    exports['since-db']:query('UPDATE `since-vehicles` SET `data` = ? WHERE id = ? ', serpent.dump(vehicleData), vehID)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    setTimer(function()
        for i, v in ipairs(getElementsByType('vehicle')) do
            if getElementData(v, 'vehicle:id') then
                saveVehicle(v)
            end
        end
    end, 5*60000, 0)
end)