function stopScript()
    if vignette then destroyElement(vignette) end
    if mask then destroyElement(mask) end
end
addEventHandler('onClientResourceStop', resourceRoot, stopScript)

function startScript()
    vignette = dxCreateTexture('data/info_bg.png', 'argb', false, 'clamp')
    mask = dxCreateTexture('data/mask.png', 'dxt3', false, 'clamp')
    for i, v in ipairs(positions.jobCuboids) do
        jobCuboid = createColCuboid(unpack(v))
        setElementData(jobCuboid, 'miner:job', true)
        setElementInterior(jobCuboid, 3)
        setElementDimension(jobCuboid, 0)

        addEventHandler('onClientColShapeHit', jobCuboid, function(el, md)
            if el ~= localPlayer or not md then
                return
            end

            if getElementData(localPlayer, 'player:srp') < 1000 then
                exports['since-notifications']:sendNotification('error', 'Nie posiadasz 1000 srp')
                return
            end

            addEventHandler('onClientRender', root, renderUI)
            triggerServerEvent('getCoal', resourceRoot)
            setElementData(localPlayer, 'player:job', 'Górnik')
            triggerServerEvent('setMinerWeapon', resourceRoot, 8)
        end)
        
        addEventHandler('onClientColShapeLeave', jobCuboid, function(el, md)
            if el ~= localPlayer or not md then
                return
            end
            
            setElementData(localPlayer, 'player:job', false)
            triggerServerEvent('takeMinerWeapon', resourceRoot, 8)
        end)
    end
    
    for i, v in ipairs(positions.miningSpheres) do
        miningSphere = createColSphere(unpack(v))
        setElementData(miningSphere, 'miner:job:mining', true)
        setElementInterior(miningSphere, 3)
        setElementDimension(miningSphere, 0)

        addEventHandler('onClientColShapeHit', miningSphere, function(el, md)
            if el ~= localPlayer or not md then
                return
            end

            if getElementData(localPlayer, 'player:srp') < 1000 then
                return
            end

            if not isEventHandlerAdded('onClientKey', root, onKey) then
                addEventHandler('onClientKey', root, onKey)
            end
        end)

        addEventHandler('onClientColShapeLeave', miningSphere, function(el, md)
            if el ~= localPlayer or not md then
                return
            end
            if isEventHandlerAdded('onClientKey', root, onKey) then
                removeEventHandler('onClientKey', root, onKey)
            end
        end)
    end

    for i, v in ipairs(positions.infoPeds) do
        infoPed = createPed(27, unpack(v))
        setElementData(infoPed, 'miner:info', {name = 'Górnik rysiek'})
        pedSphere = createColSphere(v[1], v[2], v[3], 2)
        setElementData(pedSphere, 'sphere:ped', infoPed)
        setElementData(infoPed, 'miner:infoPed', true)
        setElementFrozen(infoPed, true)
        addEventHandler('onClientPedDamage', infoPed, cancelEvent)
        setElementInterior(infoPed, 3)
        setElementInterior(pedSphere, 3)
        setElementDimension(infoPed, 0)
        setElementDimension(pedSphere, 0)

        addEventHandler('onClientColShapeHit', pedSphere, function(el, md)
            if el ~= localPlayer or not md then
                return
            end

            if getElementData(localPlayer, 'player:srp') < 1000 then
                return
            end

            local thePed = getElementData(source, 'sphere:ped')
            local message = '#dededeW twoim magazynie znajduje się #fff347'..magazineCoal..' kg#dedede węgla'
            outputChatBox('Górnik rysiek (#2E756FBOT#ffffff): '..message, 255, 255, 255, true)
            triggerEvent('onChatbubblesMessageIncome', localPlayer, message, thePed)
        end)
    end
end
addEventHandler('onClientResourceStart', resourceRoot, startScript)

addEventHandler('onClientRender', root, function()
    local x, y, z = getElementPosition(localPlayer)
    for k,v in pairs(getElementsWithinRange(x, y, z, 20, 'ped')) do
        local minerPed = getElementData(v, 'miner:info')
        if minerPed then
            local px, py, pz = getElementPosition(v)
            local sxx, syy = getScreenFromWorldPosition(px, py, pz + 1.1)
            local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(px, py, pz)) - 5, 0)

            local scale = 0.9 - dist / 15

            if sxx and syy and scale > 0 then
                if isLineOfSightClear( px, py, pz, x, y, z, true, false, false, false, false, true, true ) then
                    dxDrawText(minerPed.name, sxx + 1, syy + 1, nil, nil, tocolor(0, 0, 0, 155), scale, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'center', 'bottom')
                    dxDrawText(minerPed.name, sxx, syy, nil, nil, tocolor(46, 117, 111, 200), scale, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'center', 'bottom')
                    dxDrawText('Podejdź aby sprawdzić stan magazynu', sxx + 1, syy + 1, nil, nil, tocolor(0, 0, 0, 155), scale, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
                    dxDrawText('Podejdź aby sprawdzić stan magazynu', sxx, syy, nil, nil, tocolor(225, 225, 225, 200), scale, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
                end
            end
        end
    end
end)

bindKey('F6', 'down', function()
    if isPlayerInJobCuboid() then
        renderJobHelp = not renderJobHelp
    end
end)

function giveMiningReward()
    local random = tonumber(math.random(0,2)..'.'..math.random(70,99))
    local random = string.format('%.2f', random)
    local random = random / 1.65

    local multi = 0
    for i,v in pairs(clickedKeys) do
        if v == 1 then
            multi = multi + 0.5
        elseif v == 0 then
            multi = multi - 0.5
        end
    end

    if getElementData(localPlayer, 'player:diamond') then
        random = random * 1.15
    end

    local voucher = exports['since-vouchers']:getJobVoucher('gornik')/100
    random = random + math.floor(random * voucher)

    random=random*exports["since-jobs"]:getJobMultiplier('gornik')

    local random = string.format('%.2f', random*multi)
    
    triggerServerEvent('giveCoal', resourceRoot, random)
    triggerServerEvent('getCoal', resourceRoot)

    exports['since-dailyQuests']:addProgress(localPlayer, math.floor(random), 7)
end

function miningKey(btn, press)
    if press then 
        if btn == 'F6' then
            return
        end

        if keyStage == 1 then
            if btn == randomKeys[1] then
                clickedKeys[1] = 1
                tick = getTickCount()
                keyStage = 2
                return
            else
                clickedKeys[1] = 0
                tick = getTickCount()
                keyStage = 2
                return
            end

        elseif keyStage == 2 then
            if btn == randomKeys[2] then
                clickedKeys[2] = 1
                tick = getTickCount()
                keyStage = 3
                return
            else
                clickedKeys[2] = 0
                tick = getTickCount()
                keyStage = 3
                return
            end

        elseif keyStage == 3 then
            if btn == randomKeys[3] then
                clickedKeys[3] = 1
                tick = getTickCount()
                keyStage = 4
                return
            else
                clickedKeys[3] = 0
                tick = getTickCount()
                keyStage = 4
                return
            end

        elseif keyStage == 4 then
            if btn == randomKeys[4] then
                clickedKeys[4] = 1
                tick = getTickCount()
            else
                clickedKeys[4] = 0
                tick = getTickCount()
            end

            removeEventHandler('onClientKey', root, miningKey)
            
            setTimer(function()
                randomKeys = {}
                setElementData(localPlayer, 'player:mining', false)
                giveMiningReward()
                triggerServerEvent('toggleMinerAnimation', resourceRoot, false)
            end, 1500, 1)
        end
    end
end

function onKey(btn, press)
    if (btn == 'mouse1' and press) then
        if getPedOccupiedVehicle(localPlayer) then
            return
        end

        if isPlayerInMiningCuboid() and not getElementData(localPlayer, 'player:mining') then
            setElementData(localPlayer, 'player:mining', true)

            clickedKeys = {[1] = false, [2] = false, [3] = false}
            randomKeys = randomizeKeys()
            keyStage = 1
            tick = getTickCount()
            addEventHandler('onClientKey', root, miningKey)
            triggerServerEvent('toggleMinerAnimation', resourceRoot, true)
        end
    end
end

function renderUI()
    if isPlayerInJobCuboid() then
        renderAlpha = math.min(renderAlpha + 0.1, 1)
    else
        renderAlpha = math.max(renderAlpha - 0.1, 0)

        if renderAlpha == 0 then
            removeEventHandler('onClientRender', root, renderUI)
        end
    end

    if renderJobHelp then
        dxDrawImage(sx / 2 - 700/zoom, 0, 1400/zoom, 380/zoom, vignette, 0, 0, 0, tocolor(255, 255, 255, 255*renderAlpha))
        dxDrawText('Górnik', sx / 2 + 1, 45/zoom + 1, nil, nil, tocolor(0, 0, 0, 155*renderAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom')
        dxDrawText('Górnik', sx / 2, 45/zoom, nil, nil, tocolor(46, 117, 111, 200*renderAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom')

        if getElementData(localPlayer, 'player:mining') then
            jobInfo = 'Trwa wydobywanie surowca, klikaj odpowiednie klawisze a następnie zaczekaj chwilę..'
        else
            if #randomKeys > 0 then
                jobInfo = 'Aby wykopac węgiel klikaj odpowiednie klawisze'
            else
                if not isPlayerInMiningCuboid() then
                    jobInfo = 'Aby kopac węgiel podejdź do jednej ze stref kopania'
                elseif isPlayerInMiningCuboid() then
                    jobInfo = 'Kliknij lewy przycisk myszy aby zacząć kopanie'
                end
            end
        end

        dxDrawText(jobInfo, sx / 2 + 1, 45/zoom + 1, nil, nil, tocolor(0, 0, 0, 155*renderAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
        dxDrawText(jobInfo, sx / 2, 45/zoom, nil, nil, tocolor(255, 255, 255, 200*renderAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')

        dxDrawText('Aby schować pomocnik kliknij F6', sx / 2 + 1, 68/zoom + 1, nil, nil, tocolor(0, 0, 0, 155*renderAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
        dxDrawText('Aby schować pomocnik kliknij F6', sx / 2, 68/zoom, nil, nil, tocolor(255, 200, 125, 200*renderAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
    end

    if #randomKeys > 0 then
        if renderJobHelp then
            y = 100/zoom
        else
            y = sy - 180/zoom
        end

        local progress = interpolateBetween(100, 0, 0, 0, 0, 0, (getTickCount() - tick) / miningTime, 'Linear' )

        local offset = -((4 - 2) * 40/zoom + 2) / 2 - (40/zoom)/2 - 2
        for i = 1, 4 do
            if clickedKeys[i] == 1 then
                color[i] = tocolor(46, 117, 111, 75*renderAlpha) 
            elseif clickedKeys[i] == 0 then
                color[i] = tocolor(255, 125, 125, 75*renderAlpha)
            else
                color[i] = tocolor(255, 255, 255, 75*renderAlpha)
            end 

            dxDrawRectangle(sx / 2 - 20/zoom + offset, y, 40/zoom, 40/zoom, color[i])
            dxDrawText(string.upper(randomKeys[i]), sx / 2 + offset + 1, y + 20/zoom, nil, nil, tocolor(255, 255, 255, 225*renderAlpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom), 'center', 'center')

            dxDrawRectangle(sx / 2 - 20/zoom + offset, y + 45/zoom, 40/zoom, 3, tocolor(46, 117, 111, 100*renderAlpha))

            if clickedKeys[i] == 1 then
                dxDrawRectangle(sx / 2 - 20/zoom + offset, y + 45/zoom, 40/zoom, 3, tocolor(46, 117, 111, 255*renderAlpha))
            else
                if i == keyStage then
                    dxDrawRectangle(sx / 2 - 20/zoom + offset, y + 45/zoom, 40/zoom * progress / 100, 3, tocolor(46, 117, 111, 255*renderAlpha))
                end
            end
            

            offset = offset + 40/zoom + 2
        end


        if progress == 0 then
            if keyStage == 4 then
                randomKeys = {}
                setElementData(localPlayer, 'player:mining', false)
                removeEventHandler('onClientKey', root, miningKey)
                giveMiningReward()
                triggerServerEvent('toggleMinerAnimation', resourceRoot, false)
            end

            clickedKeys[keyStage] = 0
            keyStage = keyStage + 1
            tick = getTickCount()
        end
        
    end
end

addEvent('stopMinerJob', true)
addEventHandler('stopMinerJob', root, function()
    jobInfo = ''
    renderAlpha = 0
    randomKeys = {}
    clickedKeys = {[1] = false, [2] = false, [3] = false, [4] = false}
    keyStage = 1
    miningTime = 2000
    tick = getTickCount()
    color = {}
    magazineCoal = 0
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

setElementData(localPlayer, 'player:mining', nil)
getResourceName(getThisResource(), true, 796694312); if true then return end