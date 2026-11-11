local marker = createMarker(1058.61, 1940.33, 10.98-0.95, 'cylinder', 2, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Lawety')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')
setElementInterior(marker, 0)
addEventHandler('onClientMarkerHit', marker, function(plr)
    if plr ~= localPlayer then return end
    exports['since-jobs']:showJobGui('lawety', source)
end)

local data = {
    moneyForCourse = 45000,
    loadingMarkers = {
        {1093.39, 1854.54, 10.82},
        {1108.33, 1854.64, 10.82},
    },
    points = {
        {-1856.28, -1719.94, 21.75},
        {844.80, -601.10, 18.42},
        {-765.24, 1636.65, 27.29},
        {-1476.68, 2650.95, 55.84},
        {326.89, 2540.62, 16.81},
        {2138.90, -2162.08, 13.55},
        {320.67, -52.25, 1.57},
    },
    levels = {
        [1] = {
            coursesToNext = 250,
            multiplier = 1
        },
        [2] = {
            coursesToNext = 500,
            multiplier = 1.1
        },
        [3] = {
            coursesToNext = 500,
            multiplier = 1.15
        },
    },
}

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'lawety' then
        if getElementData(localPlayer, 'player:job') then
            return
        end
        if getElementData(localPlayer, 'player:srp') < 2500 then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz 2500 srp')
			return
		end
		local licenses = getElementData(localPlayer, 'player:licenses') or {}
		if not licenses['c'] then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz prawa jazdy kat. C')
			return
		end
		
        data.timer = setTimer(function()
            exports['since-jobs']:addPlayerJobTime('lawety', 1)
        end, 60000, 0)
        triggerServerEvent('since-lawety:s', resourceRoot, 'start')
        setElementData(localPlayer, 'lawety:packing', nil)
        loadJob()
        setElementData(localPlayer, 'player:job', job)
        exports['since-notifications']:sendNotification('success', 'Rozpoczęto prace')
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'lawety' then
        if getElementData(localPlayer, 'player:job') ~= 'lawety' then
            return
        end
        if data.timer then
            if isTimer(data.timer) then
                killTimer(data.timer)
            end
            data.timer = nil
        end
        triggerServerEvent('since-lawety:s', resourceRoot, 'end')
        setElementData(localPlayer, 'lawety:packing', nil)
        destroyJob()
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('success', 'Zakończono prace')
    end
end)

function hitLoadingMarker(el, md)
    if el ~= localPlayer or not md then
        return
    end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getElementData(veh, 'laweta:owner') == localPlayer then
        if data.packed then
            exports['since-notifications']:sendNotification('error', 'Posiadasz już ładunek na lawecie!')
            return
        end
        turnPanel(true, source)
    end
end

function loadJob()
    data.count = 0
    data.exitTick = getTickCount()
    data.markers = {}
    for i, v in ipairs(data.loadingMarkers) do
        local marker = createMarker(v[1], v[2], v[3]-1, 'cylinder', 5, 125, 255, 125, 50)
        addEventHandler('onClientMarkerHit', marker, hitLoadingMarker)
        setElementData(marker, 'marker:title', 'Załadunek')
        setElementData(marker, 'marker:desc', 'Załaduj lawetę')
        setElementData(marker, 'marker:icon', 'pack')
        table.insert(data.markers, marker)
    end
end

function destroyJob()
    for i, v in pairs(data.markers) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    data.markers = nil
    data.packed = nil
    data.count = nil
    data.exitTick = nil
    data.blocking = nil
end

function createTextures()
    main['click'] = getTickCount()
    main['anim'] = {0,0,0}
    main['textures'] = {}
    for i,v in ipairs({'bg','bg_mask','bar','close','button'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
        [3] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
    }
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
end

function getCourses()
    local upgrades = getElementData(localPlayer, "player:jobStats") or {}
    if not upgrades then upgrades = {} end
    if not upgrades['lawety'] then upgrades['lawety'] = {} end
    if not upgrades['lawety'].courses then upgrades['lawety'].courses = 0 end
    return upgrades['lawety'].courses
end

function getLevel()
    local courses = getCourses()
    return courses >= data.levels[2].coursesToNext and 3 or courses >= data.levels[1].coursesToNext and 2 or 1
end

function getLevelLimit()
    return data.levels[getLevel()].coursesToNext
end

function render()
    local x,y,z = getElementPosition(main["marker"])
    local anim = main["anim"][1]

    exports['since-blur']:dxDrawBlur(sx/2-225/zoom, sy/2-260/zoom, 450/zoom, 520/zoom, main['textures']['bg_mask'], anim)
    dxDrawImage(sx/2-225/zoom, sy/2-260/zoom, 450/zoom, 520/zoom, main['textures']["bg"], 0, 0, 0, tocolor(255,255,255,anim))

    local isIn = isMouseIn(sx/2+193/zoom, sy/2-252/zoom, 24/zoom, 24/zoom)
    main['anim'][2] = interpolateBetween(main['anim'][2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2+195/zoom, sy/2-250/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0, 0, 0, tocolor(255,255,255,anim*main['anim'][2]))

    dxDrawText('Ładunek', sx/2-205/zoom, sy/2-241/zoom, _, _, tocolor(215,215,215,anim), 1, main['fonts'][1], 'left', 'top')
    dxDrawText('Załaduj ładunek na lawetę', sx/2-205/zoom, sy/2-199/zoom, _, _, tocolor(46, 117, 111,anim), 1, main['fonts'][2], 'left', 'bottom')

    dxDrawText('Aktualny poziom', sx/2, sy/2-140/zoom, nil, nil, tocolor(46, 117, 111,anim), 1, main['fonts'][1], 'center', 'bottom')
    dxDrawText(getLevel(), sx/2-200/zoom, sy/2-139/zoom, sx/2+200/zoom, nil, tocolor(255, 255, 255,anim), 1, main['fonts'][3], 'center', 'top', false, true)

    dxDrawText('Etap poziomu', sx/2, sy/2-70/zoom, nil, nil, tocolor(46, 117, 111,anim), 1, main['fonts'][1], 'center', 'bottom')
    dxDrawImageSection(sx/2-215/zoom, sy/2-60/zoom, 430/zoom, 40/zoom, 0, 0, 430, 40, main['textures']['bar'], 0,0,0, tocolor(255,255,255,anim*main['anim'][2]))
    dxDrawImageSection(sx/2-215/zoom, sy/2-60/zoom, 430/zoom*math.min(getCourses()/getLevelLimit(), 1), 40/zoom, 0, 0, 430*math.min(getCourses()/getLevelLimit(), 1), 40, main['textures']['bar'], 0,0,0, tocolor(255,255,255,anim*main['anim'][2]))

    dxDrawText(getLevel()==3 and 'Maksymalny poziom' or (formatNumber(getCourses())..' / '..formatNumber(getLevelLimit())), sx/2-215/zoom, sy/2-60/zoom, sx/2-215/zoom+430/zoom, sy/2-60/zoom+40/zoom, tocolor(255, 255, 255,anim), 1, main['fonts'][3], 'center', 'center')

    dxDrawText('Ładując załadunek losowany jest punkt dostawy, do którego musisz dotrzeć. Każde uszkodzenie towaru będzie odliczone od twojego wynagrodzenia. Każdy kurs to jeden punkt do poziomu pracy.', sx/2-200/zoom, sy/2-5/zoom, sx/2+200/zoom, nil, tocolor(255, 255, 255,anim), 1, main['fonts'][2], 'center', 'top', false, true)

    dxDrawText('Lokalizacja', sx/2, sy/2+130/zoom, nil, nil, tocolor(46, 117, 111,anim), 1, main['fonts'][1], 'center', 'bottom')
    dxDrawText(getZoneName(x, y, z, true)..', '..getZoneName(x, y, z), sx/2-200/zoom, sy/2+130/zoom, sx/2+200/zoom, nil, tocolor(255, 255, 255,anim), 1, main['fonts'][2], 'center', 'top', false, true)

    local isIn = isMouseIn(sx/2-185/zoom, sy/2+170/zoom, 370/zoom, 100/zoom)
    main['anim'][3] = interpolateBetween(main['anim'][3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2-125/zoom, sy/2+170/zoom, 250/zoom, 60/zoom, main['textures']['button'], 0, 0, 0, tocolor(255,255,255,anim*main['anim'][3]))
    dxDrawText('Załaduj ładunek', sx/2-125/zoom, sy/2+170/zoom, sx/2-125/zoom+250/zoom, sy/2+170/zoom+60/zoom, tocolor(255,255,255,anim*main['anim'][3]), 1, main['fonts'][1], 'center', 'center')

    if not getPedOccupiedVehicle(localPlayer) then
        if not main['block'] then
            turnPanel(false)
        end
    elseif main['marker'] then
        if isElement(main['marker']) then
            local x,y,z = getElementPosition(getPedOccupiedVehicle(localPlayer))
            local x2,y2,z2 = getElementPosition(main['marker'])
            if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 10 then
                if not main['block'] then
                    turnPanel(false)
                end
            end
        end
    end
end

function startPacking(state)
    if not getPedOccupiedVehicle(localPlayer) then return end
    setElementData(localPlayer, 'lawety:packing', true)
    data.packed = true
    fadeCamera(false, 0.5, 0, 0, 0)
    setTimer(function()
        triggerServerEvent('since-lawety:s', resourceRoot, state and 'endCourse' or 'pack')
    end, 2500, 1)
    if state then
        data.blocking = true
    else
        turnPanel(false)
    end
end

function hitUnloadingMarker(el, md)
    if el ~= localPlayer or not md then
        return
    end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getElementData(veh, 'laweta:owner') == localPlayer then
        if data.packed then
            if data.blocking then return end
            setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
            startPacking(true)
        end
    end
end

function createPoint()
    local x,y,z = unpack(data.points[math.random(#data.points)])
    local marker = createMarker(x,y,z-1, 'cylinder', 5, 125, 255, 125, 50)
    addEventHandler('onClientMarkerHit', marker, hitUnloadingMarker)
    setElementData(marker, 'marker:title', 'Rozładunek')
    setElementData(marker, 'marker:desc', 'Rozładuj lawetę')
    setElementData(marker, 'marker:icon', 'pack')
    createBlipAttachedTo(marker, 41)
    data.markers.cel = marker
end

function destroyPoint()
    if data.markers.cel then
        if isElement(data.markers.cel) then
            destroyElement(data.markers.cel)
        end
        data.markers.cel = nil
    end
end

function finishCourse()
    local money = data.moneyForCourse + math.random(-math.floor(data.moneyForCourse/10),math.floor(data.moneyForCourse/10))

    money = money * data.levels[getLevel()].multiplier

    money = money * exports["since-jobs"]:getJobMultiplier('lawety')

    for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel("lawety", 'Money') do
        money = money * (1.015)
    end

    if getElementData(localPlayer, 'player:diamond') then
        money = money * (1.15)
    end

    local voucher = exports['since-vouchers']:getJobVoucher('lawety')/100
    money = money + math.floor(money * voucher)

    money = math.floor(money)

    local srp = math.random(0,3) * exports["since-jobs"]:getJobMultiplier('lawety')

    triggerServerEvent("givePlayerMoneyTowtruck", resourceRoot, money, srp)

    exports["since-jobs"]:addPlayerJobEarned("lawety", money)
    exports["since-jobs"]:addPlayerJobPoints("lawety", 1)
    exports['since-jobs']:addPlayerJobCourses('lawety', 1)

    exports['since-notifications']:sendNotification('success', 'Otrzymujesz '..formatNumber(money)..' $ za dostarczony ładunek. Udaj się po kolejny na baze!')

    exports['since-dailyQuests']:addProgress(localPlayer, 1, 8)
end

addEvent('since-lawety:c', true)
addEventHandler('since-lawety:c', resourceRoot, function(state)
    if state == 'packed' then
        setTimer(function()
            fadeCamera(true, 0.5)
            if getPedOccupiedVehicle(localPlayer) then
                setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
            end
            exports['since-notifications']:sendNotification('success', 'Załadowałeś ładunek, udaj się do wyznaczonego punktu.')
            createPoint()
            setElementData(localPlayer, 'lawety:packing', nil)
        end, 2500, 1)
    elseif state == 'unpacked' then
        setTimer(function()
            fadeCamera(true, 0.5)
            if getPedOccupiedVehicle(localPlayer) then
                setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
            end
            destroyPoint()
            finishCourse()
            data.packed = nil
            data.blocking = nil
            setElementData(localPlayer, 'lawety:packing', nil)
        end, 2500, 1)
    elseif state == 'end' then
        triggerEvent('onJobFinish', root, 'lawety')
    end
end)

function click(button, state)
    if (button == 'left' and state == 'down' and not main['block'] and main['click'] < getTickCount()) then
        main['click'] = getTickCount()+500
        if isMouseIn(sx/2+193/zoom, sy/2-252/zoom, 24/zoom, 24/zoom) then
            turnPanel(false)

        elseif isMouseIn(sx/2-185/zoom, sy/2+170/zoom, 370/zoom, 100/zoom) then
            if data.packed then
                return
            end
            startPacking()

        end
    end
end

function turnPanel(state, marker)
    if main['block'] then return end
    if state then
        if not getPedOccupiedVehicle(localPlayer) then return end
        if getPedOccupiedVehicle(localPlayer) then
            setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
        end
        main['block'] = true
        main['marker'] = marker
        createTextures()
        addEventHandler('onClientRender', root, render)
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, click)
            main['block'] = nil
        end)
        showCursor(true)
    else
        if not data.packed then
            if getPedOccupiedVehicle(localPlayer) then
                setElementFrozen(getPedOccupiedVehicle(localPlayer), false)
            end
        end
        main['block'] = true
        showCursor(false)
        removeEventHandler('onClientClick', root, click)
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            destroyTextures()
            main['block'] = nil
        end)
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'lawety' then
        setElementData(localPlayer, 'player:job', nil)
        setElementData(localPlayer, 'lawety:packing', nil)
        exports['since-notifications']:sendNotification('success', 'Praca lawet została przeładowania. Praca została zakończona.')
    end
end)
getResourceName(getThisResource(), true, 264402302); if true then return end