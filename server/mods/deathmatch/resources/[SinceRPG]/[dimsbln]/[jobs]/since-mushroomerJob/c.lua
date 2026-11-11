main = {
    ['cost'] = 2000,
}

function preRender()
    local x,y,z = getElementPosition(localPlayer)
    for i,v in ipairs(main['points']) do
        if isElement(v.object) then
            local ox,oy,oz = getElementPosition(v.object)
            local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz)
            if distance < 20 then
                if v.renderTarget and isElement(v.renderTarget) then
                    dxDrawMaterialLine3D(ox,oy,oz+0.5 + 0.45, ox,oy,oz+0.5 - 0.65, v.renderTarget, 1.75, tocolor(255,255,255,255), false)
                end
            end
        end
    end
end

names = {
    [2061] = 'Borowik',
    [2062] = 'Muchomor',
    [2063] = 'Podgrzybek',
}

function loadRenderTarget(v)
    local rt = dxCreateRenderTarget(500, 300, true)
    dxSetRenderTarget(rt, false)
        dxDrawImage(150, 110, 250, 50,"files/images/window.png",0,0,0,tocolor(255,255,255,255))
        dxDrawText(getSizeFromValue(v.size)..' '..string.lower(names[v.model]), 210, 113, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][1], "left", "top")
        dxDrawText("Kliknij aby zebrać", 210, 157, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][2], "left", "bottom")
        dxDrawImage(150, 110, 50, 50,"files/images/bind.png",0,0,0,tocolor(255,255,255,245))
        dxDrawText("E", 150, 110, 200, 160, tocolor(255, 255, 255, 255), 1, main['fonts'][1], "center", "center")
    dxSetRenderTarget()
    return rt
end

function restore()
    for i,v in ipairs(main['points']) do
        if v.renderTarget and isElement(v.renderTarget) then
            destroyElement(v.renderTarget)
        end
        v.renderTarget = loadRenderTarget({model = getElementModel(v.object), size = v.size})
    end
end

function findPointById(id)
    for i,v in ipairs(main['points']) do
        if v.id == id then
            return v
        end
    end
end

function turnControls(state)
    setElementFrozen(localPlayer, not state)
    toggleAllControls(state)
end

function getSizeFromValue(value)
    if value <= 0.4 then
        return 'Drobny'
    elseif value > 0.4 and value <= 0.55 then
        return 'Mały'
    elseif value > 0.55 and value <= 0.7 then
        return 'Średni'
    elseif value > 0.7 and value <= 0.9 then
        return 'Duży'
    elseif value > 0.9 then
        return 'Ogromny'
    end
end

function calculateMoney(info, size, multipiler)
    local jobMultiplier = exports["since-jobs"]:getJobMultiplier('grzybiarz')
    local upgradeMultipiler = exports["since-jobs"]:getPlayerUpgradeLevel("grzybiarz", 'Money')
    local diamond = getElementData(localPlayer, 'player:diamond') and 1.5 or 1
    local money = 0
    if type(info) == 'table' then
        for i,v in ipairs(info) do
            money = money + (main['cost']*v.size*v.multipiler)
        end
    else
        if size and multipiler then
            money = main['cost']*size*multipiler
        end
    end
    for i = 0, upgradeMultipiler do
        money = money * (1.1)
    end

    money = money * diamond

    local voucher = exports['since-vouchers']:getJobVoucher('grzybiarz')/100
    money = money + math.floor(money * voucher)

    return math.floor( money * jobMultiplier )
end

function collectMushroom(id)
    if not id then return end
    for i,v in ipairs(main['points']) do
        if v.id == id then
            if v.object and isElement(v.object) then
                destroyElement(v.object)
            end
            if v.growMarker and isElement(v.growMarker) then
                destroyElement(v.growMarker)
            end
            if v.renderTarget and isElement(v.renderTarget) then
                destroyElement(v.renderTarget)
            end
            reloadMushroom(v.id)
            local chanses = math.random(1,100)
            if chanses > 40 and chanses < 60 then
                local srp = math.random(1,3)
                exports['since-notifications']:sendNotification('success', 'Zdobywasz '..srp..' srp')
                triggerServerEvent('giveSrpMushroom', resourceRoot, srp)
            elseif chanses >= 20 and chanses <= 40 then
                exports["since-jobs"]:addPlayerJobPoints("grzybiarz", 2)
            elseif chanses >= 60 and chanses <= 80 then
                exports["since-jobs"]:addPlayerJobPoints("grzybiarz", 1)
            end
            table.remove(main['points'], i)
            table.insert(main['collected'], { model = v.model, size = v.size, multipiler = v.multipiler})
            break
        end
    end
end

function tryPickup()
    local v = getNearestPoint()
    if not v or main['picking'] then return end
    local x,y,z = getElementPosition(localPlayer)
    local ox,oy,oz = getElementPosition(v.object)
    local distance = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz)
    if distance < 1.5 then
        if #main['collected'] >= main['limit'] then exports['since-notifications']:sendNotification('error', 'Twój koszyk jest pełny') return end
        main['picking'] = true
        turnControls(false)
        triggerServerEvent('mushroomer', resourceRoot, 'pickupMushroom', v.id)
    end
end

addEvent('mushroomer', true)
addEventHandler('mushroomer', resourceRoot, function(action, data)
    if action == 'pickupMushroom' then
        collectMushroom(data)
        turnControls(true)
        main['picking'] = nil
        exports['since-dailyQuests']:addProgress(localPlayer, 1, 2)
    elseif action == 'selled' then
        exports["since-jobs"]:addPlayerJobEarned("grzybiarz", tonumber(data))
        main['collected'] = {}
    end
end)

function onCuboidLeave(plr)
    if plr == localPlayer then
        triggerEvent('onJobFinish', localPlayer, 'grzybiarz')
    end
end

function sellMarkerHit(plr)
    if plr ~= localPlayer then return end
    if main['picking'] then return end
    if #main['collected'] == 0 then
        exports['since-notifications']:sendNotification('error', 'Nie masz żadnych grzybów w koszyku')
        return
    end
    turnPanel(2, true, source)
end

function loadMushroom(id)
    if main['timers'][id] then
        if isTimer(main['timers'][id]) then
            killTimer(main['timers'][id])
        end
        main['timers'][id] = nil
    end
    if #main['points'] >= #positions then return end
    if not positions[id] then return end
    if findPointById(id) then return end
    local x,y,z = unpack(positions[id])
    z = z - 0.95
    local size = math.random(40, 100)/100
    local model = math.random(2061,2063)
    local object = createObject(model, x, y, z)
    local marker = createMarker(x, y, z, 'corona', 1, 0, 255, 0, 15)
    setElementCollisionsEnabled(object, false)
    setObjectScale(object, size*1.3)
    table.insert(main['points'], { 
        object = object, 
        growMarker = marker,
        renderTarget = loadRenderTarget({model = model, size = size}),
        model = model,
        size = size,
        multipiler = math.random(80,120)/100,
        position = {x,y,z},
        id = id
    })
end

function reloadMushroom(id)
    if main['timers'][id] and isTimer(main['timers'][id]) then
        killTimer(main['timers'][id])
    end

    main['timers'][id] = setTimer(loadMushroom, math.random(20,40)*1000, 1, id)
end

function createJob()
    main['cuboid'] = createColCuboid(-1123.09, -1314.55, 126.72, 49.40, 61.05, 23.90)
    local marker = createMarker(-1077.94, -1276.75, 129.22-0.95, 'cylinder', 2, 125, 255, 125, 50)
    setElementData(marker, 'marker:title', 'Grzybiarz')
    setElementData(marker, 'marker:desc', 'Sprzedaż grzybów')
    setElementData(marker, 'marker:icon', 'skin')
    addEventHandler('onClientMarkerHit', marker, sellMarkerHit)
    main['makrer'] = marker
    main['fonts'] = { exports['since-fonts']:getFont('Inter-Bold', 14), exports['since-fonts']:getFont('Inter-Bold', 10) }
    main['points'] = {}
    main['collected'] = {}
    main['timers'] = {}
    main['limit'] = 15

    for i = 0, exports['since-jobs']:getPlayerUpgradeLevel('grzybiarz', 'Pojemny') do
        main['limit'] = main['limit'] + 5
    end
    
    local id = 1
    while true do
        if #main['points'] >= #positions then break end
        loadMushroom(id)
        id = id + 1
    end
    if not isEventHandlerAdded('onClientPreRender', root, preRender) then
        addEventHandler('onClientPreRender', root, preRender)
        bindKey('e', 'down', tryPickup)
        addEventHandler('onClientRestore', root, restore)
        addEventHandler('onClientColShapeLeave', main['cuboid'], onCuboidLeave)
        turnPanel(1, true)
    end
    triggerServerEvent('mushroomer', resourceRoot, 'start')
end

function destroyJob()
    if not main['points'] or #main['points'] == 0 then return end
    if isEventHandlerAdded('onClientPreRender', root, preRender) then
        removeEventHandler('onClientPreRender', root, preRender)
        removeEventHandler('onClientRestore', root, restore)
        removeEventHandler('onClientColShapeLeave', main['cuboid'], onCuboidLeave)
        unbindKey('e', 'down', tryPickup)
        turnPanel(1, false)
    end
    for i,v in ipairs(main['points']) do
        if isElement(v.object) then
            destroyElement(v.object)
        end
        if isElement(v.growMarker) then
            destroyElement(v.growMarker)
        end
        if isElement(v.renderTarget) then
            destroyElement(v.renderTarget)
        end
    end 
    main['points'] = nil
    for i,v in pairs(main['timers']) do
        if isTimer(v) then
            killTimer(v)
        end
    end
    main['timers'] = nil
    if main['cuboid'] and isElement(main['cuboid']) then
        destroyElement(main['cuboid'])
        main['cuboid'] = nil
    end
    if main['makrer'] and isElement(main['makrer']) then
        destroyElement(main['makrer'])
        main['makrer'] = nil
    end
    triggerServerEvent('mushroomer', resourceRoot, 'destroy')
end

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(name)
    if name == 'grzybiarz' then
        if getElementData(localPlayer, 'player:job') then
            return
        end
        if getElementData(localPlayer, 'player:srp') < 1500 then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz 1500 srp')
			return
		end
        main['timer'] = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('grzybiarz', 1)
        end, 60000, 0)
        main['points'] = {}
        setElementData(localPlayer, 'player:job', 'grzybiarz')
        exports['since-notifications']:sendNotification('success', 'Rozpoczynasz pracę')
        createJob()
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(name)
    if name == 'grzybiarz' then
        if getElementData(localPlayer, 'player:job') ~= 'grzybiarz' then
            return
        end
        if main['picking'] then
            cancelEvent()
            return
        end
        if main['timer'] then
            if isTimer(main['timer']) then
                killTimer(main['timer'])
            end
            main['timer'] = nil
        end
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('success', 'Zakończono pracę')
        destroyJob()
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') == 'grzybiarz' then
        exports['since-notifications']:sendNotification('success', 'Program został zatrzymany. Zakończono pracę')
        setElementData(localPlayer, 'player:job', nil)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    local marker = createMarker(-1080.77, -1288.52, 129.49-0.95, 'cylinder', 2, 125, 255, 125, 50)
    setElementData(marker, 'marker:title', 'Grzybiarz')
    setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
    setElementData(marker, 'marker:icon', 'skin')
    createBlipAttachedTo(marker, 46, 2, 255,255,255,0,0, 500)
    addEventHandler('onClientMarkerHit', marker, function(plr)
        if plr ~= localPlayer then return end
        exports['since-jobs']:showJobGui('grzybiarz', source)
    end)

    local models = {
        {'grzyb1', 2061, 'grzyb'},
        {'grzyb2', 2062, 'grzyb'},
        {'grzyb3', 2063, 'grzyb'},
        {'koszyk', 2060},
    }
    for i,v in ipairs(models) do
        if v[3] then
            if fileExists('files/models/'..v[3]..'.txd') then
                engineImportTXD(engineLoadTXD ('files/models/'..v[3]..'.txd'), v[2])
            end
        else
            if fileExists('files/models/'..v[1]..'.txd') then
                engineImportTXD(engineLoadTXD ('files/models/'..v[1]..'.txd'), v[2])
            end
        end
        if fileExists('files/models/'..v[1]..'.dff') then
            engineReplaceModel(engineLoadDFF('files/models/'..v[1]..'.dff', v[2]), v[2])
        end
        if fileExists('files/models/grzyb.col') then
            engineReplaceCOL(engineLoadCOL('files/models/grzyb.col'), v[2])
        end
        engineSetModelLODDistance(v[2], 250)
    end
end)

function getNearestPoint()
    local x,y,z = getElementPosition(localPlayer)
    local nearest = nil
    local distance = 9999
    for i,v in ipairs(main['points']) do
        if isElement(v.object) then
            local ox,oy,oz = getElementPosition(v.object)
            local dist = getDistanceBetweenPoints3D(x,y,z,ox,oy,oz)
            if dist < distance then
                distance = dist
                nearest = v
            end
        end
    end
    return nearest
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end
