local data = {
    points = {
        {2785.86, 938.40, 10.75, -0.00, 0.00, 90.21},
        {2434.68, 1055.03, 10.82, -0.00, 0.00, 3.19},
        {2382.07, 1480.11, 10.82, -0.00, 0.00, 2.39},
        {2514.19, 1929.05, 10.82, -0.00, 0.00, 355.94},
        {2272.28, 2420.65, 10.82, -0.00, 0.00, 91.02},
        {2139.58, 2460.89, 10.81, -0.00, 0.00, 90.21},
        {1920.07, 2214.54, 10.82, -0.00, 0.00, 180.05},
        {1920.40, 2068.96, 10.82, -0.00, 0.00, 90.05},
        {2126.69, 1425.70, 10.82, -0.00, 0.00, 270.29},
        {1911.66, 1280.35, 10.82, -0.00, 0.00, 89.96},
        {1704.45, 1437.07, 10.74, -0.00, 0.00, 183.83},
        {1559.74, 1010.33, 10.81, -0.00, 0.00, 181.01},
        {1353.45, 741.69, 10.82, -0.00, 0.00, 186.09},
        {1133.21, 1365.75, 10.82, -0.00, 0.00, 269.33},

        {0.39, 978.60, 19.82, -0.00, 0.00, 266.26},
        {-258.84, 1090.84, 19.74, -0.00, 0.00, 88.35},
        {-268.47, 1125.10, 19.74, -0.00, 0.00, 358.52},
        {-312.54, 1155.99, 19.74, -0.00, 0.00, 89.96},
        {-331.85, 1090.38, 19.74, -0.00, 0.00, 180.04},
        {16.60, 1090.37, 19.74, -0.00, 0.00, 270.04},
        {4.90, 1177.65, 19.46, -0.00, 0.00, 89.32},
        {596.73, 1230.53, 11.72, -0.00, 0.00, 318.79},
        {-84.33, 1376.24, 10.27, -0.00, 0.00, 2.30},
        {-347.79, 1202.02, 19.74, -0.00, 0.00, 34.77},

        {114.21, -153.29, 1.58, -0.00, 0.00, 178.35},
        {167.29, -54.22, 1.58, -0.00, 0.00, 358.67},
        {249.93, -156.23, 1.57, -0.00, 0.00, 268.03},
        {340.92, -100.41, 1.42, -0.00, 0.00, 358.67},
        {292.78, -64.52, 1.58, -0.00, 0.00, 88.51},
        {275.59, -180.68, 1.58, -0.00, 0.00, 179.56},
        {53.21, -232.07, 1.58, -0.00, 0.00, 179.56},
        {314.84, 45.69, 2.93, -0.00, 0.00, 194.22},

        {-61.52, -1581.41, 2.61, -0.00, 0.00, 269.24},
        {252.46, -1741.30, 4.38, -0.00, 0.00, 268.03},
        {429.42, -1779.17, 5.55, -0.00, 0.00, 282.94},
        {647.49, -1658.22, 14.92, -0.00, 0.00, 356.26},
        {853.84, -1378.08, 13.55, -0.00, 0.00, 175.93},
        {1001.06, -1457.08, 13.55, -0.00, 0.00, 90.93},
        {1145.55, -1294.26, 13.64, -0.00, 0.00, 265.77},
        {1386.64, -1581.12, 13.55, -0.00, 0.00, 74.57},
        {1126.41, -1733.84, 13.77, -0.00, 0.00, 270.76},
        {2481.07, -1747.90, 13.55, -0.00, 0.00, 180.92},
        {2377.98, -1886.44, 13.55, -0.00, 0.00, 270.76},
        {2405.98, -2106.11, 13.55, -0.00, 0.00, 359.23},
        {2530.02, -2010.03, 13.55, -0.00, 0.00, 273.83},
        {2016.15, -1268.40, 23.98, -0.00, 0.00, 357.54},

        {2464.21, -43.83, 26.48, -0.00, 0.00, 182.94},
        {2508.85, 119.54, 26.48, -0.00, 0.00, 268.10},
        {2442.91, 49.56, 26.48, -0.00, 0.00, 90.44},
        {2401.79, 21.54, 26.48, -0.00, 0.00, 169.00},
        {2336.34, 7.15, 26.48, -0.00, 0.00, 177.46},
        {2335.76, 190.04, 26.49, -0.00, 0.00, 359.95},
        {2351.56, 136.23, 26.47, -0.00, 0.00, 185.92},
        {2271.68, -84.82, 26.51, -0.00, 0.00, 272.37},
        {2316.36, -91.22, 26.48, -0.00, 0.00, 296.46},
        {2314.50, -105.40, 26.48, -0.00, 0.00, 86.16},

        {1274.36, 169.17, 19.98, -0.00, 0.00, 216.85},
        {1217.21, 272.80, 19.55, -0.00, 0.00, 335.13},
        {1278.76, 366.90, 19.55, -0.00, 0.00, 336.90},
        {1343.91, 390.53, 19.55, -0.00, 0.00, 340.93},
        {1345.48, 353.50, 19.55, -0.00, 0.00, 154.81},
        {1395.10, 286.77, 19.55, -0.00, 0.00, 246.66},
        {1354.36, 253.24, 19.55, -0.00, 0.00, 339.88},
        {1342.41, 282.85, 19.56, -0.00, 0.00, 63.52},
    },
    levels = {
        [1] = {
            expToNext = 250,
            multiplier = 1,
        },
        [2] = {
            expToNext = 500,
            multiplier = 1.3,
        },
        [3] = {
            expToNext = 1000,
            multiplier = 1.6,
        },
        [4] = {
            multiplier = 2,
        },
    },
}

function getActualLevel(exp)
    local level = 1
    for i, v in ipairs(data.levels) do
        if not v.expToNext then
            break
        elseif exp >= v.expToNext then
            level = i + 1
        end
    end
    return level
end

function getMultiplierLevel(level)
    return data.levels[level or 1].multiplier
end

function render()
    exports['since-blur']:dxDrawBlur(sx/2-435/zoom, sy/2-275/zoom, 870/zoom, 550/zoom, main['textures']['bg_mask'])
    dxDrawImage(sx/2-435/zoom, sy/2-275/zoom, 870/zoom, 550/zoom, main['textures']['bg'])
    
    dxDrawImage(sx/2-126/zoom, sy/2-215/zoom-57/zoom, 252/zoom, 64/zoom, main['textures']['ETransporter'])

    dxDrawImage(sx/2-422/zoom, sy/2-133/zoom-57/zoom, 845/zoom, 35/zoom, main['textures']['bar_1'])
    dxDrawText('Nazwa', sx/2-412/zoom, sy/2-133/zoom+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)
    dxDrawText('Punkt odbioru', sx/2-212/zoom, sy/2-133/zoom+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)
    dxDrawText('Dystans', sx/2+162/zoom, sy/2-133/zoom+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)
    dxDrawText('Stawka', sx/2+302/zoom, sy/2-133/zoom+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][2], 'left', 'center', false, false, false, true)

    local x=0
    for i, v in ipairs(data.actualCourses) do
        if i >= main['scroll'][1] and i <= main['scroll'][2] then
            x=x+1
            local offset = ((37/zoom)*(x-1))
            local isIn = isMouseIn(sx/2-422/zoom, sy/2-93/zoom+offset-57/zoom, 845/zoom, 35/zoom)
            dxDrawImage(sx/2-422/zoom, sy/2-93/zoom+offset-57/zoom, 845/zoom, 35/zoom, main['textures']['bar_2'], 0,0,0, tocolor(255,255,255, isIn and 255 or 200))
            dxDrawText(v[1], sx/2-412/zoom, sy/2-93/zoom+offset+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255, isIn and 255 or 200), 1, main['fonts'][1], 'left', 'center', false, false, false, true)
            local x,y,z = unpack(v[2])
            local x2,y2,z2 = unpack(v[3])
            local xP,yP,zP = getElementPosition(localPlayer)
            dxDrawText(getZoneName(x,y,z, true)..', '..getZoneName(x,y,z)..' #68D65E('..string.format('%.2f', getDistanceBetweenPoints3D(x,y,z,xP,yP,zP)/1000)..' km)', sx/2-212/zoom, sy/2-93/zoom+offset+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,isIn and 255 or 200), 1, main['fonts'][1], 'left', 'center', false, false, false, true)
            dxDrawText(string.format('%.2f', getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)/1000)..' km', sx/2+162/zoom, sy/2-93/zoom+offset+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,isIn and 255 or 200), 1, main['fonts'][1], 'left', 'center', false, false, false, true)
            dxDrawText('#68D65E$ #ffffff'..formatNumber(math.floor(v[5] * getMultiplierLevel(data.stats.level))), sx/2+302/zoom, sy/2-93/zoom+offset+(35/zoom/2)-57/zoom, nil, nil, tocolor(255,255,255,isIn and 255 or 200), 1, main['fonts'][1], 'left', 'center', false, false, false, true)
        end
    end

    dxDrawText('Aby zamknąć panel naciśnij BACKSPACE', sx/2, sy/2+190/zoom-57/zoom, nil, nil, tocolor(255,255,255,200), 1, main['fonts'][1], 'center', 'center', false, false, false, true)

    local offset = 0
    for i=1,4 do
        local isLevelActive = (data.stats.level or 1) >= i
        dxDrawImage(sx/2-420/zoom + offset, sy/2+180/zoom, 35/zoom, 35/zoom, main['textures'][isLevelActive and 'levelSelected' or 'levelBackground'])
        dxDrawText(i, sx/2-420/zoom + offset, sy/2+180/zoom, sx/2-420/zoom + 35/zoom + offset, sy/2+180/zoom+35/zoom, tocolor(255,255,255, isLevelActive and 200 or 100), 1, main['fonts'][4], 'center', 'center', false, false, false, true)
        offset = offset + 41/zoom
    end

    local maxExp = data.stats.maxExp or levels[1].expToNext
    local progres = data.stats.progres or 0

    dxDrawImage(sx/2-420/zoom, sy/2+225/zoom, 840/zoom, 35/zoom, main['textures']['barBackground'])
    dxDrawImageSection(sx/2-420/zoom, sy/2+225/zoom, 840/zoom * progres, 35/zoom, 0, 0, 840 * progres, 35, main['textures']['barFilled'])

    dxDrawText( data.stats.level == 4 and 'Maksymalny poziom' or (math.floor(maxExp*progres)..' / '..maxExp..' EXP'), sx/2-420/zoom, sy/2+225/zoom, sx/2-420/zoom + 840/zoom, sy/2+225/zoom + 35/zoom, tocolor(255,255,255,200), 1, main['fonts'][3], 'center', 'center', false, false, false, true)

    local texts = {
        '#68D65E'..(data.stats.time or 0)..' #FFFFFFminut w pracy',
        '#68D65E'..(data.stats.courses or 0)..' #FFFFFFwykonanych kursów',
        '#FFFFFFAktualny level: #68D65E'..(data.stats.level or 0)..'',
    }

    offset = offset + 8/zoom
    for i=1,3 do
        dxDrawImage(sx/2-420/zoom + offset, sy/2+180/zoom, 218/zoom, 35/zoom, main['textures']['optionalBackground'])
        dxDrawText(texts[i], sx/2-420/zoom + offset, sy/2+180/zoom, sx/2-420/zoom + 218/zoom + offset, sy/2+180/zoom+35/zoom, tocolor(255,255,255,200), 1, main['fonts'][1], 'center', 'center', false, false, false, true)
        offset = offset + 225/zoom
    end

end    

function click(button,state)
    if (button == 'left' and state == 'down' and main['countDown'] < getTickCount()) then
        main['countDown'] = getTickCount() + 300

        local x=0
        for i, v in ipairs(data.actualCourses) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                x=x+1
                local offset = ((37/zoom)*(x-1))
                if isMouseIn(sx/2-422/zoom, sy/2-93/zoom+offset-57/zoom, 845/zoom, 35/zoom) then
                    if checkJob() then 
                        return
                    end
                    startJob(v[5], {v[2], v[3]}, v[1])
                end
            end
        end
    end
end

function loadJobStats()
    local exp = exports['since-jobs']:getPlayerJobExp('etransporter')
    local level = getActualLevel(exp)

    if level > 1 then
        exp = exp - (data.levels[level-1] and data.levels[level-1].expToNext or 0)
    end
    
    local maxExp = data.levels[level] and data.levels[level].expToNext or 0
    local progres = exp/maxExp

    if progres > 1 then
        progres = 1
    end

    local courses = exports['since-jobs']:getPlayerJobCourses('etransporter')
    local time = exports['since-jobs']:getPlayerJobTime('etransporter')
    data.stats = {
        level = level,
        exp = exp,
        maxExp = maxExp,
        progres = progres,
        courses = courses,
        time = time,
    }
end

function turnPanel(state)
    if state == true then
        if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'etransporter' then
            endJob()
            return
        end
        if checkJob() then 
            return
        end
        if not isEventHandlerAdded('onClientRender', root, render) then
            if not data.actualCourses or #data.actualCourses == 0 then
                findNewCourses()
            end

            createTextures()
            loadJobStats()
            addEventHandler('onClientRender', root, render)
            addEventHandler('onClientClick', root, click)
            bindKey('mouse_wheel_up', 'down', scrollUP)
            bindKey('mouse_wheel_down', 'down', scrollDOWN)
            bindKey('backspace', 'down', turnPanel)
            showCursor(true,true)
        end
        return
    end
    if isEventHandlerAdded('onClientRender', root, render) then

        showCursor(false)
        removeEventHandler('onClientRender', root, render)
        removeEventHandler('onClientClick', root, click)
        data.stats = nil
        unbindKey('mouse_wheel_up', 'down', scrollUP)
        unbindKey('mouse_wheel_down', 'down', scrollDOWN)
        unbindKey('backspace', 'down', turnPanel)
        setTimer(destroyTextures, 50, 1)

    else

        createTextures()
        loadJobStats()
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        bindKey('mouse_wheel_up', 'down', scrollUP)
        bindKey('mouse_wheel_down', 'down', scrollDOWN)
        bindKey('backspace', 'down', turnPanel)
        showCursor(true,true)
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
        if main['scroll'][2] >= #data.actualCourses then 
            return 
        end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

function calculateMoneyFromDistance(marker, point)
    local x1,y1,z1 = unpack(marker)
    local x2,y2,z2 = unpack(point)
    local dist = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
    local money = 35*dist
    return math.floor(money)
end

function calculateMoney(money)
    local money = money
    local TempMoney = (getElementData(localPlayer, 'player:diamond') and money * (0.15) or 0)

    local voucher = exports['since-vouchers']:getJobVoucher('etransporter')/100
    money = money + math.floor(money * voucher)    

    money = money * exports["since-jobs"]:getJobMultiplier('etransporter')    
    money = money + TempMoney
    return math.floor(money)
end

function findNewCourses()
    data.actualCourses = {}
    while true do
        local pos = data.points[math.random(#data.points)]
        local pos2 = data.points[math.random(#data.points)]
        local money = calculateMoney(calculateMoneyFromDistance(pos, pos2))
        if getDistanceBetweenPoints3D(pos[1],pos[2],pos[3],pos2[1],pos2[2],pos2[3]) > 500 then
            table.insert(data.actualCourses, {getRandomName(math.random(1,2)==1 and true or false), pos, pos2, string.format('%.2f', getDistanceBetweenPoints3D(pos[1],pos[2],pos[3],pos2[1],pos2[2],pos2[3])), money})
        end
        if #data.actualCourses > 10 then
            break
        end
    end
end

function checkJob()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then
        return true
    end
    if getVehicleController(veh) ~= localPlayer then
        return true
    end
    if getElementData(localPlayer, 'player:job') then
        exports['since-notifications']:sendNotification('error', 'Jesteś już gdzieś zatrudniony!')
        return true
    end
    return false
end

function hitGettingPassagerMarker(el, md)
    if el == localPlayer and md then 
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh and getElementData(localPlayer, 'player:job') == 'etransporter' then
            if data.saver.block then
                return
            end
            if getElementSpeed(veh, "km/h") > 120 then 
                exports['since-notifications']:sendNotification('error', 'Zbyt duża prędkość! Podjedź jeszcze raz, ale z mniejszą prędkością.')
                return 
            end
            setElementFrozen(veh, true)
            setTimer(setElementFrozen, 50, 1, veh, false)
            createJobState()
        else
            endJob()
        end
    end
end

function hitUnloadingMarker(el, md)
    if el == localPlayer and md then 
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh and getElementData(localPlayer, 'player:job') == 'etransporter' then
            if data.saver.block then
                return
            end
            if data.saver.timer and isTimer(data.saver.timer) then
                killTimer(data.saver.timer)
                data.saver.timer = nil
            end
            setElementFrozen(veh, true)
            data.saver.timer = setTimer(function(veh)
                setElementFrozen(veh, false)
                endJob(true)
            end, 50, 0, veh)
            --[[local ped = getElementByID('etransporter-'..getElementData(localPlayer, 'player:sid'))
            if ped and isElement(ped) and isElementSyncer(ped) then
                setPedExitVehicle(ped)
            end]]
        end
    end
end

function createJobState(state)
    if data.saver.block then
        return
    end
    if state then
        exports['since-notifications']:sendNotification('success', 'Udaj się do miejsca, aby odebrać pasażera!')
        if data.saver.marker and isElement(data.saver.marker) then
            destroyElement(data.saver.marker)
            data.saver.marker = nil
        end
        if data.saver.timer and isTimer(data.saver.timer) then
            killTimer(data.saver.timer)
            data.saver.timer = nil
        end
        local x,y,z = unpack(data.saver.positions[1])
        triggerServerEvent('since-transporterJob', resourceRoot, 'start', data.saver.positions[1], data.saver.name)
        local marker = createMarker(x,y,z-0.4,'cylinder',6,125,255,125)
        addEventHandler('onClientMarkerHit', marker, hitGettingPassagerMarker)
        createBlipAttachedTo(marker, 41)
        exports['since-radar']:findBestWay(x, y)
        data.saver.marker = marker
        data.saver.block = nil
    else
        data.saver.block = true
        if data.saver.timer and isTimer(data.saver.timer) then
            killTimer(data.saver.timer)
            data.saver.timer = nil
        end
        local veh = getPedOccupiedVehicle(localPlayer)
        setElementFrozen(veh, true)
        data.saver.timer = setTimer(setElementFrozen, 50, 0, veh, true)
        setTimer(function()
            triggerServerEvent('since-transporterJob', resourceRoot, 'unfreeze')
        end, 250, 1)
    end
end

function startJob(money, positions, name)
    if checkJob() then 
        return
    end

    turnPanel()

    local level = getActualLevel(exports['since-jobs']:getPlayerJobExp('etransporter') or 0)
    local money = money * data.levels[level].multiplier

    data.saver = {
        money = math.floor(money),
        positions = positions,
        name = name,
    }

    setElementData(localPlayer, 'player:job', 'etransporter')
    createJobState(true)

    data.timer = setTimer(function()
        exports["since-jobs"]:addPlayerJobTime('etransporter', 1)
    end, 60000, 0)
end

function endJob(state)
    if state then
        local money = data.saver.money
        local srp = math.random(1,5)
        triggerServerEvent('givePlayerMoneyetransporter', resourceRoot, money, srp)
        exports['since-notifications']:sendNotification('success', 'Dotarłeś do celu z pasażerem, otrzymujesz $ '..formatNumber(money))
        findNewCourses()
        exports["since-jobs"]:addPlayerJobEarned("etransporter", money)
        exports["since-jobs"]:addPlayerJobPoints("etransporter", 1)
        exports['since-jobs']:addPlayerJobCourses('etransporter', 1)
        exports['since-dailyQuests']:addProgress(localPlayer, 1, 5)

        exports['since-jobs']:addPlayerJobExp('etransporter', math.random(1,3))
    end
    destroyJob()
end

function destroyJob()
    if data.saver.marker and isElement(data.saver.marker) then
        destroyElement(data.saver.marker)
        data.saver.marker = nil
    end 
    if data.saver.timer and isTimer(data.saver.timer) then
        killTimer(data.saver.timer)
        data.saver.timer = nil
    end

    if data.timer then
        if isTimer(data.timer) then
            killTimer(data.timer)
        end
        data.timer = nil
    end

    triggerServerEvent('since-transporterJob', resourceRoot, 'destroy')
    setElementData(localPlayer, 'player:job', nil)
    exports['since-radar']:removeGPS()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        setElementFrozen(veh, false)
    end
    data.saver = nil
end

function onVehicleExit(veh, sit)
    if source ~= localPlayer then
        return
    end
    if sit == 0 and getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'etransporter' then
        endJob()
        exports['since-notifications']:sendNotification('info', 'Opuściłeś pojazd, praca została zakończona.')
        setElementFrozen(veh, false)
    end
end
addEventHandler('onClientPlayerVehicleExit', root, onVehicleExit)

addEvent('since-transporterJob', true)
addEventHandler('since-transporterJob', resourceRoot, function(state)
    if state == 'start' then
        if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'etransporter' then
            local veh = getPedOccupiedVehicle(localPlayer)
            setTimer(function(veh)
                if data.saver.timer and isTimer(data.saver.timer) then
                    killTimer(data.saver.timer)
                    data.saver.timer = nil
                end
                if data.saver.marker and isElement(data.saver.marker) then
                    destroyElement(data.saver.marker)
                    data.saver.marker = nil
                end
                setElementFrozen(veh, false)
                local x,y,z = unpack(data.saver.positions[2])
                local marker = createMarker(x,y,z-0.4,'cylinder',6,125,255,125)
                addEventHandler('onClientMarkerHit', marker, hitUnloadingMarker)
                setElementData(marker, 'marker:title', 'Cel')
                setElementData(marker, 'marker:desc', 'Punkt docelowy')
                createBlipAttachedTo(marker, 41)
                exports['since-radar']:findBestWay(x, y)
                data.saver.marker = marker
                data.saver.block = nil
                exports['since-notifications']:sendNotification('success', 'Udaj się do miejsca docelowego z pasażerem!')
            end, 50, 1, veh)
        end

    elseif state == 'ped enter' then
        setTimer(function()
            local veh = getPedOccupiedVehicle(localPlayer)
            local ped = getElementByID('etransporter-'..getElementData(localPlayer, 'player:sid'))
            if ped and isElement(ped) then
                setPedEnterVehicle(ped, veh, true)
            end
            setTimer(function()
                triggerServerEvent('since-transporterJob', resourceRoot, 'get in ped', ped)
            end, 250, 1)
        end, 250, 1)

    elseif state == 'end' then
        endJob(true)

    elseif state == 'ped synced' then
        if not getElementData(localPlayer, 'player:job') or getElementData(localPlayer, 'player:job') ~= 'etransporter' then
            return
        end
        if data.saver.block then
            setTimer(function()
                local veh = getPedOccupiedVehicle(localPlayer)
                local ped = getElementByID('etransporter-'..getElementData(localPlayer, 'player:sid'))
                if ped and isElement(ped) then
                    setPedEnterVehicle(ped, veh, true)
                end
            end, 250, 1)

        end

    end
end)

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if getElementType(source) == 'ped' then
        triggerServerEvent('since-transporterJob', resourceRoot, 'ped sync', source)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    findNewCourses()
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'etransporter' then
        setElementData(localPlayer, 'player:job', nil)
        exports['since-radar']:removeGPS()
        exports['since-notifications']:sendNotification('success', 'Praca E-Transporter została przeładowania. Praca została zakończona.')
    end
end)

addEventHandler('onClientRender', root, function()
    local x, y, z = getElementPosition(localPlayer)
    for k,v in pairs(getElementsWithinRange(x, y, z, 20, 'ped')) do
        local datsa = getElementData(v, 'etransporter.ped')
        if datsa then
            local px, py, pz = getPedBonePosition(v, 8)
            local sx, sy = getScreenFromWorldPosition(px, py, pz + 0.4)
            local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(px, py, pz)) - 5, 0)

            local scale = 0.9 - dist / 15

            if sx and sy and scale > 0 then
                dxDrawText(datsa, sx + 1, sy + 1, nil, nil, tocolor(0, 0, 0, 155), scale, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'center', 'bottom', false, false, false, false, true)
                dxDrawText(datsa, sx, sy, nil, nil, tocolor(125, 255, 125, 200), scale, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'center', 'bottom', false, false, false, false, true)
                dxDrawText('Pasażer', sx + 1, sy + 1, nil, nil, tocolor(0, 0, 0, 155), scale, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top', false, false, false, false, true)
                dxDrawText('Pasażer', sx, sy, nil, nil, tocolor(225, 225, 225, 200), scale, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top', false, false, false, false, true)
            end
        end
    end
end)

getResourceName(getThisResource(), true, 638483511); if true then return end