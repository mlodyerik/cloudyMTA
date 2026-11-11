local data = {
    allowedModels = {
        [515] = true,
        [514] = true,
        [403] = true,
    },
    bases = {
        {-41.26, -1127.80, 1.08, {{-43.35, -1142.53, 1.71, 0.9, 360.0, 65.4}, {-41.26, -1138.74, 1.72, 1.0, 360.0, 64.9}}},
        --{2786.63, -1618.73, 10.92, {{2772.46, -1615.72, 11.57, 1.2, 360.0, 270.3}, {2772.50, -1608.22, 11.58, 1.3, 360.0, 270.4}}},
        {1079.98, 2344.68, 10.8, {{1095.30, 2342.89, 11.45, 1.0, 360.0, 0.3}, {1062.97, 2342.66, 11.47, 1.2, 360.0, 0.3}}},
        {2470.32, 1043.03, 10.65, {{2472.93, 1052.77, 11.29, 1.1, 360.0, 89.9}, {2473.28, 1032.49, 11.30, 1.2, 360.0, 90.3}}},
    },
    points = {
        {'Art. spożywcze', {
            {160.93, 1187.91, 14.94},
            {-160.15, 1230.36, 19.74},
            {206.54, -174.59, 1.58},
            {1010.12, -1355.59, 13.35},
            {1346.08, -1752.06, 13.36},
            {1842.13, -1832.03, 13.59},
            {2118.22, -1781.07, 13.39},
            {2481.32, -1749.63, 13.55},
            {2304.82, -1640.33, 14.50},
        }, 435},
        {'Paczki', {
            {1273.66, -1652.25, 13.55},
            {763.31, -1027.77, 23.99},
            {902.52, -1679.43, 13.55},
            {428.82, -1794.39, 5.55},
            {42.61, -245.16, 1.70},
            {312.70, -244.36, 1.58},
            {-295.75, 1020.18, 19.59},
        }, 435},
        {'Części samochodowe', {
            {202.73, -220.50, 1.58},
            {706.70, -443.23, 16.34},
            {1671.21, 2207.88, 10.82},
            {-2197.61, -2319.88, 30.62},
            {1611.50, -1833.61, 13.51},
        }, 435},
        {'Paliwo lotnicze', {
            {1677.81, 1624.64, 10.82},
            {2033.70, -2212.29, 13.55},
            {-1117.84, -167.47, 14.15},
            {386.47, 2598.97, 16.48},
        }, 584},
        {'Elektronika', {
            {2429.74, -1230.67, 24.99},
            {1485.02, 2678.81, 10.82},
            {1843.49, 2080.69, 10.83},
            {1986.23, 2077.37, 10.82},
            {2466.74, 2335.32, 10.82},
            {2357.11, 2767.37, 10.82},
            {-1039.64, -608.59, 32.01},
            {-495.09, -519.56, 25.52},
            {2106.25, -1367.51, 23.98},
            {2260.58, -84.82, 26.51},
        }, 435},
        {'Paliwo', {
            {40.53, 1220.05, 19.12},
            {-106.39, -1191.35, 2.36},
            {-1613.46, -2702.03, 48.54},
            {-2238.07, -2571.41, 31.92},
            {1938.94, -1788.65, 13.38},
            {1407.58, 457.58, 20.22},
            {251.09, 1420.89, 10.59},
            {1584.59, 2211.19, 10.82},
            {2168.68, 2490.33, 10.82},
        }, 584},
        {'Nielegalne substancje', {
            {767.48, 1893.35, 5.10},
            {1732.23, 2077.91, 10.82},
            {-287.11, 2662.43, 62.66},
            {-641.58, 2706.84, 72.38},
            {-1522.37, 2572.29, 55.84},
            {-1506.92, 1966.45, 48.42},
            {-647.33, 1459.39, 13.41},
        }, 435},
    },
    actualCourses = {},
    actualCoursesBaseID = nil,
    levels = {
        [1] = {
            coursesToNext = 250,
            multiplier = 0
        },
        [2] = {
            coursesToNext = 500,
            multiplier = 0.2
        },
        [3] = {
            coursesToNext = 500,
            multiplier = 0.5
        },
    },
    ui = {},
}

function getCourses()
    local upgrades = getElementData(localPlayer, "player:jobStats") or {}
    if not upgrades then upgrades = {} end
    if not upgrades['logistyka'] then upgrades['logistyka'] = {} end
    if not upgrades['logistyka'].courses then upgrades['logistyka'].courses = 0 end
    return upgrades['logistyka'].courses
end

function getLevel()
    local courses = getCourses()
    return courses >= data.levels[2].coursesToNext and 3 or courses >= data.levels[1].coursesToNext and 2 or 1
end

function getLevelLimit()
    return data.levels[getLevel()].coursesToNext
end

function calculateMoney(money)
    local money = money
    local TempMoney = money * data.levels[getLevel()].multiplier + (getElementData(localPlayer, 'player:diamond') and money * (0.15) or 0)

    local voucher = exports['since-vouchers']:getJobVoucher('logistyka')/100
    money = money + math.floor(money * voucher)

    money = money * exports["since-jobs"]:getJobMultiplier('logistyka')    
    money = money + TempMoney
    return math.floor(money)
end

function endJob(state)
    if state == true then
        local money = data.saver.money
        money = math.floor(money * (data['ui'].hp/1000))
        local srp = math.random(0,3) * exports["since-jobs"]:getJobMultiplier('logistyka')
        exports["since-jobs"]:addPlayerJobEarned("logistyka", money)
        exports["since-jobs"]:addPlayerJobPoints("logistyka", 1)
        exports['since-jobs']:addPlayerJobCourses('logistyka', 1)
        exports['since-notifications']:sendNotification('success', 'Otrzymujesz '..formatNumber(money)..' $ za dostarczony ładunek. Udaj się po kolejny na baze!')
        triggerServerEvent("givePlayerMoneytruck", resourceRoot, money, srp)
    elseif state ~= false then
        exports['since-notifications']:sendNotification('success', 'Zakończono prace')
    end
    turnUiRender(false)
    if data.timer then
        if isTimer(data.timer) then
            killTimer(data.timer)
        end
        data.timer = nil
    end
    if data.checkTimer then
        if isTimer(data.checkTimer) then
            killTimer(data.checkTimer)
        end
        data.checkTimer = nil
    end
    if data.saver.marker then
        if isElement(data.saver.marker) then
            destroyElement(data.saver.marker)
        end
        data.saver.marker = nil
    end
    data.saver = nil
    setElementData(localPlayer, 'player:job', nil)
    findNewCourses(data.actualCoursesBaseID)
    data.actualCoursesBaseID = nil
end

function fastStop(type)
    triggerServerEvent('since-truckJob', resourceRoot, 'end')
    endJob(false)
    if type == 1 then
        exports['since-notifications']:sendNotification('success', 'Praca została zakończona, opuściłeś pojazd!')
    elseif type == 2 then
        exports['since-notifications']:sendNotification('success', 'Praca została zakończona, naczepa została zniszczona!')
    elseif type == 3 then
        exports['since-notifications']:sendNotification('success', 'Praca została zakończona, oddaliłeś się za bardzo od naczepy!')
    elseif type == 4 then
        exports['since-notifications']:sendNotification('success', 'Praca została zakończona, uszkodziłeś za bardzo od naczepę!')
    end
end

function checkJobState()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then fastStop(1) return end
    local trailer = findTrainer()
    if not trailer then fastStop(2) return end
    local x1,y1,z1 = getElementPosition(veh)
    local x2,y2,z2 = getElementPosition(trailer)
    if getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)>100 then fastStop(3) return end
    if getElementHealth(trailer) < 350 then fastStop(4) return end
end

addEvent("since-truckJob", true)
addEventHandler("since-truckJob", resourceRoot, function(state, info)
    if state == 'started' then
        data.timer = setTimer(function()
            exports['since-jobs']:addPlayerJobTime('logistyka', 1)
        end, 60000, 0)
        data.checkTimer = setTimer(checkJobState, 5000, 0)

        setElementData(localPlayer, 'player:job', 'logistyka')
        exports['since-notifications']:sendNotification('success', 'Rozpoczęto prace')
        data.saver = {
            money = info[1],
            pointPos = info[2],
        }

        turnUiRender(true, {info[3], getZoneName(info[2][1], info[2][2], info[2][3], true)..', '..getZoneName(info[2][1], info[2][2], info[2][3])})

    elseif state == 'showPoints' then
        if data.saver.marker then
            if isElement(data.saver.marker) then
                destroyElement(data.saver.marker)
            end
            data.saver.marker = nil
        end
        local x,y,z = unpack(data.saver.pointPos)
        local marker = createMarker(x,y,z-0.4,'cylinder',6,125,255,125)
        addEventHandler('onClientMarkerHit', marker, hitUnloadingMarker)
        setElementData(marker, 'marker:title', 'Rozładunek')
        setElementData(marker, 'marker:desc', 'Odstaw ładunek')
        setElementData(marker, 'marker:icon', 'pack')
        createBlipAttachedTo(marker, 41)
        data.saver.marker = marker
        exports['since-notifications']:sendNotification('info', 'Udaj się do punktu docelowego')

    elseif state == 'hidePoints' then
        if data.saver.marker then
            if isElement(data.saver.marker) then
                destroyElement(data.saver.marker)
            end
            data.saver.marker = nil
        end
        exports['since-notifications']:sendNotification('info', 'Podłącz naczepę!')
        
    elseif state == 'end' then
        endJob()
    end
end)

function hitUnloadingMarker(el, md)
    if el ~= localPlayer or not md then
        return
    end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getElementData(localPlayer, 'player:job') == 'logistyka' then
        setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
        setTimer(setElementFrozen, 50, 1, getPedOccupiedVehicle(localPlayer), false)
        triggerServerEvent('since-truckJob', resourceRoot, 'end')
        endJob(true)
    end
end

function calculateMoneyFromDistance(marker, point)
    local x1,y1,z1 = getElementPosition(marker)
    local x2,y2,z2 = unpack(point)
    local dist = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
    local money = 28*dist
    return money
end

function checkJob()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or not getElementData(veh, 'vehicle:id') then
        exports['since-notifications']:sendNotification('error', 'Do tej pracy wymygana jest ciężarówka (wypożyczona/prywatna).')
        return true
    end
    if getVehicleController(veh) ~= localPlayer then
        return true
    end
    if not data.allowedModels[getElementModel(veh)] then
        exports['since-notifications']:sendNotification('error', 'Ten model pojazdu nie jest kompatybilny z tą pracą!')
        return true
    end
    if getElementData(localPlayer, 'player:job') then
        exports['since-notifications']:sendNotification('error', 'Jesteś już gdzieś zatrudniony!')
        return true
    end
    if getElementData(localPlayer, 'player:srp') < 3000 then 
        exports['since-notifications']:sendNotification('error', 'Nie posiadasz 3000 srp')
        return true
    end
    return false
end

function render()
    exports['since-blur']:dxDrawBlur(sx/2-220/zoom, sy/2-230/zoom, 440/zoom, 460/zoom, main['textures']['bg_mask'])
    dxDrawImage(sx/2-220/zoom, sy/2-230/zoom, 440/zoom, 460/zoom, main['textures']['bg'])

    main['anim'][1] = main['anim'][1] and interpolateBetween(main['anim'][1], 0, 0, isMouseIn(sx/2+188/zoom, sy/2-222/zoom, 24/zoom, 24/zoom) and 1 or 0.7, 0, 0, 0.1, 'Linear') or 0.7
    dxDrawImage(sx/2+190/zoom, sy/2-220/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,255*main['anim'][1]))
    dxDrawImage(sx/2-210/zoom, sy/2-217/zoom, 34/zoom, 34/zoom, main['textures']['icon'], 0,0,0, tocolor(255,255,255,255))
    dxDrawText('Firma logistyczna', sx/2-170/zoom, sy/2-220/zoom, _, _, tocolor(255,255,255,255), 1, main['fonts'][1], 'left', 'top')
    dxDrawText('Since Logistics', sx/2-170/zoom, sy/2-180/zoom, _, _, tocolor(46,117,111,255), 1, main['fonts'][2], 'left', 'bottom')

    local x=0
    for i, v in ipairs(data.tbl) do
        if i >= main['scroll'][1] and i <= main['scroll'][2] then
            x=x+1
            local offset = ((65/zoom)*(x-1))

            dxDrawImage(sx/2-215/zoom, sy/2-160/zoom + offset, 420/zoom, 60/zoom, main['textures']['bg2'], 0,0,0, tocolor(255,255,255,200))

            dxDrawText(v[1], sx/2-200/zoom, sy/2-140/zoom + offset, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][3], 'left', 'center')

            dxDrawImage(sx/2-200/zoom, sy/2-126/zoom + offset, 15/zoom, 15/zoom, main['textures']['icon2'], 0,0,0, tocolor(255,255,255,255))
            local x,y,z = unpack(v[3])
            local text = getZoneName(x,y,z)
            dxDrawText(text, sx/2-180/zoom, sy/2-118/zoom + offset, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)

            local textWidth = dxGetTextWidth(text, 1, main['fonts'][2]) + 30/zoom
            dxDrawImage(sx/2-200/zoom+textWidth, sy/2-126/zoom + offset, 15/zoom, 15/zoom, main['textures']['icon3'], 0,0,0, tocolor(255,255,255,255))
            dxDrawText('#8AFF80$ '..formatNumber(v[2]), sx/2-179/zoom+textWidth, sy/2-118/zoom + offset, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)

            local isIn = isMouseIn(sx/2+100/zoom, sy/2-145/zoom + offset, 92/zoom, 30/zoom)
            dxDrawImage(sx/2+100/zoom, sy/2-145/zoom + offset, 92/zoom, 30/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,isIn and 255 or 200))
            dxDrawText('Wybierz', sx/2+147/zoom, sy/2-130/zoom + offset, nil, nil, tocolor(255,255,255,isIn and 255 or 200), 1, main['fonts'][2], 'center', 'center')
        end
    end

    drawScrollbar(data.tbl, sx/2+211/zoom, sy/2-160/zoom, 3/zoom, 320/zoom, main['scroll'][3], main['scroll'][1], 255)

    local textWidth = dxGetTextWidth('Poziom '..getLevel(), 1, main['fonts'][2]) + 120/zoom
    dxDrawRoundedRectangle(sx/2-textWidth/2, sy/2+185/zoom, textWidth, 30/zoom, 14/zoom, tocolor(217, 217, 217, 85))
    dxDrawText('Poziom '..getLevel(), sx/2, sy/2+200/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][2], 'center', 'center')

    --dxDrawImage(sx/2-textWidth/2-34/zoom, sy/2+183/zoom, 34/zoom, 34/zoom, main['textures']['arrow'], 180,0,0, tocolor(255,255,255,255))
    --dxDrawImage(sx/2+textWidth/2, sy/2+183/zoom, 34/zoom, 34/zoom, main['textures']['arrow'], 0,0,0, tocolor(255,255,255,255))

    if main['marker'] and isElement(main['marker']) then
        local x,y,z = getElementPosition(localPlayer)
        local x2,y2,z2 = getElementPosition(main['marker'])
        if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 10 then
            turnPanel(false)
        end
    end
end

function click(button,state)
    if (button == 'left' and state == 'down' and main['countDown'] < getTickCount()) then
        main['countDown'] = getTickCount() + 300
        if isMouseIn(sx/2+188/zoom, sy/2-222/zoom, 24/zoom, 24/zoom) then
            turnPanel(false)
            return
        else
            local x=0
            for i, v in ipairs(data.tbl) do
                if i >= main['scroll'][1] and i <= main['scroll'][2] then
                    x=x+1
                    local offset = ((65/zoom)*(x-1))
                    if isMouseIn(sx/2+100/zoom, sy/2-145/zoom + offset, 92/zoom, 30/zoom) then
                        local id = getElementData(main['marker'], 'trailer:spawn')
                        local rnd = math.random(#data.bases[id][4])
                        triggerServerEvent('since-truckJob', resourceRoot, 'start', {v[4], data.bases[id][4][rnd], v[2], v[3], v[1]})
                        data.actualCoursesBaseID = id
                        turnPanel(false)
                    end
                end
            end
        end
    end
end

function turnPanel(state, marker)
    if state then

        setElementFrozen(getPedOccupiedVehicle(localPlayer), true)

        main['scroll'] = {1, 5, 5}

        createTextures()

        data.tbl = {}
        for i,v in ipairs(data.actualCourses[getElementData(marker, 'trailer:spawn')]) do
            table.insert(data.tbl, {v[1], calculateMoney(calculateMoneyFromDistance(marker, v[2])), v[2], v[3]})
        end

        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        bindKey('mouse_wheel_up', 'down', scrollUP)
        bindKey('mouse_wheel_down', 'down', scrollDOWN)
        showCursor(true,true)

        main['marker'] = marker
    else

        setElementFrozen(getPedOccupiedVehicle(localPlayer), false)

        showCursor(false)
        removeEventHandler('onClientRender', root, render)
        removeEventHandler('onClientClick', root, click)
        unbindKey('mouse_wheel_up', 'down', scrollUP)
        unbindKey('mouse_wheel_down', 'down', scrollDOWN)

        setTimer(destroyTextures, 50, 1)
    end
end

function markerHit(el, md)
    if el == localPlayer and md then 
        if checkJob() then 
            return
        end
        if not isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(true, source)        
        end
    end
end

function markerLeave(el, md)
    if el == localPlayer and md then 
        if isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(false)
        end
    end
end

function scrollUP()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] == main['scroll'][3] then return end
        main['scroll'][1] = main['scroll'][1] - 1
        main['scroll'][2] = main['scroll'][2] - 1
    end
end

function scrollDOWN()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] >= #data.tbl then 
            return 
        end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

function findTrainer()
    for i,v in ipairs(getElementsByType('vehicle', resourceRoot)) do
        if getElementData(v, 'trailer:owner') == localPlayer then
            return v
        end
    end
end

function turnUiRender(state, info)
    if state then
        if not isEventHandlerAdded('onClientRender', root, renderUI) then
            data['ui'].textures = {}
            data['ui'].fonts = {exports['since-fonts']:getFont('Inter-Bold', 13/zoom), exports['since-fonts']:getFont('Inter-Medium', 10/zoom)}
            data['ui'].name = info[1]
            data['ui'].point = info[2]
            for i,v in ipairs({'panel_bg','panel_bg_mask','panel_icon'}) do
                if fileExists('files/images/'..v..'.png') then
                    data['ui'].textures[v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
                end
            end
            addEventHandler('onClientRender', root, renderUI)
            data['ui'].veh = findTrainer()
            data['ui'].hp = getElementHealth(data['ui'].veh)
        end
    else
        if isEventHandlerAdded('onClientRender', root, renderUI) then
            removeEventHandler('onClientRender', root, renderUI)
            for i,v in pairs(data['ui'].textures) do
                if isElement(v) then 
                    destroyElement(v) 
                end
            end
            data['ui'] = {}
        end
    end
end

function renderUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 211/zoom, 25/zoom, 422/zoom, 100/zoom, data['ui'].textures['panel_bg_mask'])
    dxDrawImage(sx/2 - 211/zoom, 25/zoom, 422/zoom, 100/zoom, data['ui'].textures['panel_bg'])
    dxDrawImage(sx/2 - 193/zoom, 45/zoom, 60/zoom, 60/zoom, data['ui'].textures['panel_icon'])
    dxDrawText('Logistyka lądowa', sx/2 - 122/zoom, 65/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, data['ui'].fonts[1], 'left', 'bottom')
    dxDrawText('Stan ładunku', sx/2 + 200/zoom, 65/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, data['ui'].fonts[1], 'right', 'bottom')
    dxDrawText('Przewozisz: '..data['ui'].name, sx/2 - 122/zoom, 63/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, data['ui'].fonts[2], 'left', 'top')
    if not data['ui'].veh then data['ui'].veh = findTrainer() end
    data['ui'].hp = getElementHealth(data['ui'].veh)
    dxDrawText((data['ui'].veh and string.format('%.0f',data['ui'].hp/10) or 100)..' %', sx/2 + 200/zoom, 63/zoom, nil, nil, tocolor(158, 255, 0, 255), 1, data['ui'].fonts[2], 'right', 'top')
    dxDrawText('Przewieź ładunek do '..data['ui'].point, sx/2 + 39/zoom, 92/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, data['ui'].fonts[2], 'center', 'top')
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    for i, v in ipairs(data.bases) do
        local marker = createMarker(v[1],v[2],v[3]-0.4,'cylinder',6,125,255,125)
        createBlipAttachedTo(marker, 51, 2, 255,255,255,0,0, 500)
        setElementData(marker, 'marker:title', 'Logistyka lądowa')
        setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
        setElementData(marker, 'marker:icon', 'skin')
        setElementData(marker, 'trailer:spawn', i) 
        addEventHandler('onClientMarkerHit', marker, markerHit)
        addEventHandler('onClientMarkerLeave', marker, markerLeave)
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'logistyka' then
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('success', 'Praca logistyki lądowej została przeładowania. Praca została zakończona.')
    end
end)

function findNewCourses(id)
    if id then
        data.actualCourses[id] = {}
        for i,v in ipairs(data.points) do
            local pos = v[2][math.random(#v[2])]
            table.insert(data.actualCourses[id], {v[1], pos, v[3]})
        end
    else
        data.actualCourses = {}
        for k, vv in ipairs(data.bases) do
            data.actualCourses[k] = {}
            for i,v in ipairs(data.points) do
                local pos = v[2][math.random(#v[2])]
                table.insert(data.actualCourses[k], {v[1], pos, v[3]})
            end
        end
    end
end
findNewCourses()

getResourceName(getThisResource(), true, 708210858); if true then return end