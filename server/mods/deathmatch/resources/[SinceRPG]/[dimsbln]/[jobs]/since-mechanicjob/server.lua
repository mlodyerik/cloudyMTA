local data = {

    job = {},
    timers = {},
    afk = {}

}

function startCounting(plr, toggle)
    if toggle then
        if not data.timers[plr] then
            data.timers[plr] = setTimer(function(plr)
                local playerData = getElementData(plr, 'player:data') or {}
                playerData['mechanicTime'] = (tonumber(playerData['mechanicTime']) or 0) + 1
                setElementData(plr, 'player:data', playerData)
            end, 60000, 0, plr)
        end
    else
        if data.timers[plr] then
            killTimer(data.timers[plr])
            data.timers[plr] = nil
        end
    end
end

function getWorkersFromLocation(location)
    local count = 0
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:job') == 'mechanik' and getElementData(v, 'player:jobLocation') == location then
            count = count + 1
        end
    end
    return count
end

addCommandHandler('mechanicy', function(plr)
    outputChatBox(' ', plr, 255, 175, 0, true)
    outputChatBox('✉ #ffffffLista mechaników', plr, 255, 175, 0, true)
    for name, tbl in pairs(mechanic.positions) do
        local workers = getWorkersFromLocation(name)
        outputChatBox('✉ #ffffffMechanicy #bfbfbf'..name..'#ffffff: #ffaf00'..workers..'/'..data.job[name].slots..'', plr, 255, 175, 0, true)
    end
    outputChatBox(' ', plr, 255, 175, 0, true)
end)

function toggleJob(plr, locationName, bool)
    if data.job[locationName] then
        if not bool then
            if getWorkersFromLocation(locationName) < data.job[locationName].slots then
                if getElementData(plr, 'player:mute') then
                    exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz rozpocząć pracy jako mechanik będąc wyciszonym')
                    return
                end

                if getElementData(plr, 'player:job') == 'lsm' then
                    exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz rozpocząć pracy jako mechanik będąc już w pracy')
                    return
                end

                data.job[locationName].active = data.job[locationName].active + 1
                setElementData(plr, 'player:job', 'mechanik')
                setElementData(plr, 'player:jobLocation', locationName)
                setElementData(plr, 'player:jobSkin', getElementModel(plr))
                setElementModel(plr, 273)
                startCounting(plr, true)
                exports['since-notifications']:sendNotification(plr, 'success', 'Rozpocząłeś pracę jako mechanik')
                triggerClientEvent(plr, 'toggleJob', resourceRoot, locationName, true)
            else
                exports['since-notifications']:sendNotification(plr, 'error', 'Brak wolnych miejsc')
            end
        else
            if data.job[locationName].active > 0 then
                data.job[locationName].active = data.job[locationName].active - 1
            end

            setElementData(plr, 'player:job', false)
            setElementData(plr, 'player:jobLocation', false)

            local model = getElementData(plr, 'player:jobSkin') or 0

            if model then
                setElementModel(plr, model)
            end

            local plrData = getElementData(plr, 'player:data') or {}
            local money = (tonumber(plrData['mechanicTime']) or 0) * mechanic.moneyFromJob
            money = money * exports["since-jobs"]:getJobMultiplier('mechanik')

            if money > 0 then
                exports['since-notifications']:sendNotification(plr, 'success', 'Praca mechanika została zakończona. Otrzymujesz '..convertNumber(money)..' $ za przepracowane '..convertTime(tonumber(plrData['mechanicTime']) or 0))
            else
                exports['since-notifications']:sendNotification(plr, 'success', 'Praca mechanika została zakończona.')
            end

            givePlayerMoney(plr, money)

            plrData['mechanicTime'] = 0
            setElementData(plr, 'player:data', plrData)

            triggerClientEvent(plr, 'toggleJob', resourceRoot, false, false)
            startCounting(plr, false)
        end
    end
end

function toggleClientJob(location, bool)
    toggleJob(client, location, not bool)
end
addEvent('toggleJob', true)
addEventHandler('toggleJob', resourceRoot, toggleClientJob)

function getCuboidFromID(id)
    for i, v in ipairs(getElementsByType('colshape')) do
        if getElementData(v, 'cuboid:id') == id then
            return v
        end
    end
end

function addCommas( number )
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

addEvent('fixMechVehicle', true)
addEventHandler('fixMechVehicle', resourceRoot, function(veh, tbl, cost)
    if #tbl > 0 and veh and isElement(veh) then
        if getPlayerMoney(client) > cost then
            takePlayerMoney(client, cost)

            local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates ( veh )
            
            for i,id in ipairs(tbl) do
                if id == 1 then setElementHealth(veh, 10000)
                elseif id == 2 then setVehicleDoorState(veh, 0, 0)
                elseif id == 3 then setVehicleDoorState(veh, 1, 0)
                elseif id == 4 then setVehicleDoorState(veh, 2, 0)
                elseif id == 5 then setVehicleDoorState(veh, 3, 0)
                elseif id == 6 then setVehicleDoorState(veh, 4, 0)
                elseif id == 7 then setVehicleDoorState(veh, 5, 0)
                elseif id == 8 then setVehiclePanelState(veh, 4, 0)
                elseif id == 9 then setVehiclePanelState(veh, 5, 0)
                elseif id == 10 then setVehiclePanelState(veh, 6, 0)
                elseif id == 11 then setVehicleLightState(veh, 0, 0)
                elseif id == 12 then setVehicleLightState(veh, 1, 0)
                elseif id == 13 then setVehicleLightState(veh, 2, 0)
                elseif id == 14 then setVehicleLightState(veh, 3, 0)
                elseif id == 15 then setVehicleWheelStates(veh, 0, rearLeft, frontRight, rearRight) 
                elseif id == 16 then setVehicleWheelStates(veh, frontLeft, rearLeft, 0, rearRight)
                elseif id == 17 then setVehicleWheelStates(veh, frontLeft, 0, frontRight, rearRight)
                elseif id == 18 then setVehicleWheelStates(veh, frontLeft, rearLeft, frontRight, 0)
                end
            end

            if cost == 0 then
                exports['since-notifications']:sendNotification(client, 'success', 'Pomyslnie naprawiono wybrane części.')
            else
                exports['since-notifications']:sendNotification(client, 'success', 'Pomyslnie naprawiono wybrane części za kwotę #2E756F$ '..addCommas(cost)..'')
            end
        else
            exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej gotówki!')
        end
    end
end)

function constructJob()
    for name, tbl in pairs(mechanic.positions) do
        if not data.job[name] then
            data.job[name] = {
                
                slots = #tbl,
                active = 0,
                
            }
            
            local id = 0
            for i, v in ipairs(tbl) do
                cuboid = createColCuboid(v.cuboid[1], v.cuboid[2], v.cuboid[3], v.cuboid[4], v.cuboid[5], v.cuboid[6])
                marker = createMarker(v.marker[1], v.marker[2], v.marker[3] - 0.5, 'cylinder', 1.5, 125, 175, 255, 255)
                id = id + 1

                setElementData(marker, 'marker:title', 'Stanowisko #'..id)
                setElementData(marker, 'marker:desc', 'Naprawa pojazdu')

                local text = createElement("text")
                local x, y, z = unpack(v.text)
                setElementPosition(text, x, y, z)
                setElementData(text, "name", "Stanowisko naprawy\n#2E756F#"..id)

                setElementData(marker, 'marker:id', id..name)
                setElementData(cuboid, 'cuboid:id', id..name)

                addEventHandler('onMarkerHit', marker, function(element, matchingDimension)
                    if getElementType(element) == 'player' and matchingDimension then
                        if getElementData(element, 'player:job') == 'mechanik' then
                            local cuboid = getCuboidFromID(getElementData(source, 'marker:id'))

                            if cuboid then
                                local vehicle = false

                                if #getElementsWithinColShape(cuboid, 'vehicle') == 0 then
                                    exports['since-notifications']:sendNotification(element, 'error', 'Brak pojazdów do naprawy')
                                    return
                                end

                                if #getElementsWithinColShape(cuboid, 'vehicle') > 1 then
                                    exports['since-notifications']:sendNotification(element, 'error', 'Zbyt dużo pojazdów na stanowisku')
                                    return
                                end

                                for i, v in ipairs(getElementsWithinColShape(cuboid, 'vehicle')) do
                                    if v and isElement(v) then
                                        vehicle = v
                                        break
                                    end
                                end
                
                                triggerClientEvent(element, 'toggleRepairUI', resourceRoot, true, vehicle)
                            end
                        end
                    end
                end)

                addEventHandler('onMarkerLeave', marker, function(element, matchingDimension)
                    if getElementType(element) == 'player' and matchingDimension then
                        triggerClientEvent(element, 'toggleRepairUI', resourceRoot, false)
                    end
                end)

                addEventHandler('onColShapeLeave', cuboid, function(element, matchingDimension)
                    if getElementType(element) == 'player' and matchingDimension then
                        triggerClientEvent(element, 'toggleRepairUI', resourceRoot, false)
                    end
                end)
            end
        end
    end

    for i, tbl in ipairs(mechanic.startPoints) do
        local jobMarker = createMarker(tbl[1], tbl[2], tbl[3] - 0.5, 'cylinder', 2, 125, 255, 125, 255)
        local jobCuboid = createColCuboid(tbl[5], tbl[6], tbl[7], tbl[8], tbl[9], tbl[10])

        setElementData(jobMarker, 'marker:title', 'Mechanik')
        setElementData(jobMarker, 'marker:desc', 'Rozpocznij pracę')
        setElementData(jobMarker, 'marker:jobLocation', tbl[4])

        addEventHandler('onMarkerHit', jobMarker, function(element, matchingDimension)
            if getElementType(element) == 'player' and matchingDimension then
                local location = getElementData(source, 'marker:jobLocation')
                toggleJob(element, location, (getElementData(element, 'player:job') == 'mechanik'))
            end
        end)

        addEventHandler('onColShapeLeave', jobCuboid, function(element, matchingDimension)
            if getElementType(element) == 'player' and matchingDimension then
                if getElementData(element, 'player:job') == 'mechanik' then
                    toggleJob(element, getElementData(element, 'player:jobLocation'), true)
                end
            end
        end)
    end
end
constructJob()

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'player:job') == 'mechanik' then
        toggleJob(source, getElementData(source, 'player:jobLocation'), true)
    end
end)

addEventHandler('onPlayerWasted', root, function()
    if getElementData(source, 'player:job') == 'mechanik' then
        toggleJob(source, getElementData(source, 'player:jobLocation'), true)
    end
end)

function scriptStop()
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:job') == 'mechanik' then
            toggleJob(v, getElementData(v, 'player:jobLocation'), true)
        end
    end
end
addEventHandler('onResourceStop', resourceRoot, scriptStop)