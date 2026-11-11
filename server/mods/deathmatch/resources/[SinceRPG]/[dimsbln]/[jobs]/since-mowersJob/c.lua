local main = {}
local jobData = {}

local function render()
    if getElementData(localPlayer, 'player:job') ~= 'kosiarki' then
        hidePanel()
        return
    end
    if main['info'].progressAnim ~= main['info'].progress then
        main['info'].progressAnim = interpolateBetween(main['info'].progressAnim or 0, 0, 0, main['info'].progress, 0, 0, 0.2, 'InOutQuad')
    end
    if main['info'].cashAnim ~= main['info'].cash then
        main['info'].cashAnim = interpolateBetween(main['info'].cashAnim or 0, 0, 0, main['info'].cash, 0, 0, 0.2, 'InOutQuad')
    end
    local progress = string.format('%.2f', main['info'].progressAnim)
    local cash = formatNumber(math.floor(main['info'].cashAnim))
    local time = formatTime(getTickCount()-main['info'].tick)
    if main['type'] == 1 then
        dxDrawImage(sx-250/zoom, 181/zoom, 250/zoom, 82/zoom, main['textures']['fade'])
        dxDrawText('Zarobiona gotówka', sx-10/zoom, 205/zoom, nil, nil, tocolor(255, 255, 255, 215), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'bottom')
        dxDrawText('$ #FFFFFF'..cash, sx-10/zoom, 205/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'top', false, false, false, true)
        dxDrawText('Przepracowany czas', sx-10/zoom, 244/zoom, nil, nil, tocolor(255, 255, 255, 215), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'bottom')
        dxDrawText(time, sx-10/zoom, 244/zoom, nil, nil, tocolor(122, 194, 185, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'top')
        dxDrawImage(sx-130/zoom, 271/zoom, 122/zoom, 22/zoom, main['textures']['progress_bg'], 0, 0, 0, tocolor(255, 255, 255, 155))
        local progress2 = main['info'].progress/100
        dxDrawImageSection(sx-130/zoom, 271/zoom, (122/zoom)*progress2, 22/zoom, 0, 0, 124*progress2, 22, main['textures']['progress'])
        dxDrawText(progress..' / 100.00', sx-130/zoom+1, 271/zoom+1, sx-130/zoom+122/zoom+1, 271/zoom+22/zoom+1, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
        dxDrawText(progress..' / 100.00', sx-130/zoom, 271/zoom, sx-130/zoom+122/zoom, 271/zoom+22/zoom, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
    else
        local nick = main['info'].nick
        dxDrawImage(sx-390/zoom, 181/zoom, 280/zoom, 122/zoom, main['textures']['fade'])
        if main['info']['avatar'] then
            dxDrawImage(sx-135/zoom, 181/zoom, 122/zoom, 122/zoom, main['info']['avatar'])
            dxDrawImage(sx-137/zoom, 179/zoom, 126/zoom, 126/zoom, main['textures']['avatarFrame'])
        else
            dxDrawImage(sx-137/zoom, 179/zoom, 126/zoom, 126/zoom, main['textures']['avatar'])
        end
        dxDrawText('Współpraca z graczem', sx-140/zoom, 205/zoom, nil, nil, tocolor(255, 255, 255, 215), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'bottom')
        dxDrawText(nick, sx-140/zoom, 205/zoom, nil, nil, tocolor(94, 170, 213, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'top')
        dxDrawText('Zarobiona gotówka', sx-140/zoom, 244/zoom, nil, nil, tocolor(255, 255, 255, 215), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'bottom')
        dxDrawText('$ #FFFFFF'..cash, sx-140/zoom, 244/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'top', false, false, false, true)
        dxDrawText('Przepracowany czas', sx-140/zoom, 283/zoom, nil, nil, tocolor(255, 255, 255, 215), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'bottom')
        dxDrawText(time, sx-140/zoom, 283/zoom, nil, nil, tocolor(122, 194, 185, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'top')
        dxDrawImage(sx-135/zoom, 308/zoom, 122/zoom, 22/zoom, main['textures']['progress_bg'], 0, 0, 0, tocolor(255, 255, 255, 155))
        local progress2 = main['info'].progress/100
        dxDrawImageSection(sx-135/zoom, 308/zoom, (122/zoom)*progress2, 22/zoom, 0, 0, 124*progress2, 22, main['textures']['progress'])
        dxDrawText(progress..' / 100.00', sx-135/zoom+1, 308/zoom+1, sx-135/zoom+122/zoom+1, 308/zoom+22/zoom+1, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
        dxDrawText(progress..' / 100.00', sx-135/zoom, 308/zoom, sx-135/zoom+122/zoom, 308/zoom+22/zoom, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
    end
end

local function turnPanel(state, partner)
    if state then
        main['textures'] = createTextures('stats', {'fade', 'avatar', 'avatarFrame', 'progress_bg', 'progress', 'time'})
        main['type'] = 1
        main['info'] = {
            cash = 0,
            time = 0,
            progress = 0,
            tick = getTickCount(),
        }
        bindKey('e', 'down', mowerInteractionWithTrailer)
        if partner then
            main['type'] = 2
            main['info'].nick = getPlayerName(partner)
            main['info'].partner = partner
            maskTexture = createTextures('stats', {'mask'})['mask']
            main['info'].avatar = exports['since-avatars']:getPlayerAvatar(getElementData(partner, 'player:sid'), maskTexture)
        end
        addEventHandler('onClientRender', root, render)
        addEventHandler("onClientRender", root, renderJob)

    else
        removeEventHandler('onClientRender', root, render)
        removeEventHandler('onClientRender', root, renderJob)
        for i,v in pairs(main) do
            if i == 'textures' then
                main[i] = destroyTextures(v)
            else
                main[i] = nil
            end
        end
        unbindKey('e', 'down', mowerInteractionWithTrailer)
        if isElement(maskTexture) then 
            destroyElement(maskTexture)
        end
        maskTexture = nil
    end
end

function hidePanel()
    turnPanel(false)
end

local marker = createMarker(2428.37, 108.91, 26.78-0.95, 'cylinder', 3, 125, 255, 125, 50)
--createBlipAttachedTo(marker, 46, 2, 255,255,255,0,0, 500)
setElementData(marker, 'marker:title', 'Kosiarki')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')
addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    --if not getElementData(localPlayer, 'player:admin') then return end
    exports["since-jobs"]:showJobGui("kosiarki", source)
end)

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'kosiarki' then
        if getElementData(localPlayer, 'player:job') then
            return
        end
        --if getElementData(localPlayer, 'player:admin') then
            showPanel()
            jobData['timer'] = setTimer(function()
                exports["since-jobs"]:addPlayerJobTime('kosiarki', 1)
            end, 60000, 0)
            jobData['moneyCheckTimer'] = setTimer(function()
                if not main['info'] then return end
                if not main['info'].progress then return end
                if main['info'].progress == 100 then
                    triggerServerEvent('onPlayerHitGrass', resourceRoot, nil, nil, 0)
                end
            end, 10000, 0)
        --end
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'kosiarki' then
        if getElementData(localPlayer, 'player:job') ~= 'kosiarki' then
            return
        end
        triggerServerEvent('onJobFinish', resourceRoot)
        if jobData['timer'] then
            if isTimer(jobData['timer']) then
                killTimer(jobData['timer'])
            end
            jobData['timer'] = nil
        end
        if jobData['moneyCheckTimer'] then
            if isTimer(jobData['moneyCheckTimer']) then
                killTimer(jobData['moneyCheckTimer'])
            end
            jobData['moneyCheckTimer'] = nil
        end
    end
end)

addEvent('onJobFinallyStart', true)
addEventHandler('onJobFinallyStart', resourceRoot, function(course, partner)
    turnPanel(true, partner and findPlayer(partner) or nil)
    loadJob(course)
end)

addEvent('onJobFinallyFinish', true)
addEventHandler('onJobFinallyFinish', resourceRoot, function()
    turnPanel(false)
    destroyJob()
end)

addEvent('onLobbyFinishedCourse', true)
addEventHandler('onLobbyFinishedCourse', resourceRoot, function(course, money)
    if main['info'] then
        main['info'].progress = 0
        main['info'].cash = main['info'].cash + money
    end
    loadJob(course)
end)

local texts = { "Aby zdjąć kosiarkę naciśnij", "Aby schować kosiarkę naciśnij" }
local text = 1
local tick = getTickCount()
function renderJob()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and (getElementModel(veh) == 552) then 
        return 
    elseif veh and (getElementModel(veh) == 572) then
        text = 2
    else
        text = 1
    end
    local v = jobData['trailer']
    if v and isElement(v) then
        local x, y, z = getPositionFromElementOffset(v, 0, -5, 0.5)
        local sxx, syy = getScreenFromWorldPosition(x, y, z)
        local px, py, pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
        if sxx and syy then
            dxDrawImage(sxx-25/zoom, syy-55/zoom, 50/zoom, 50/zoom, "files/images/other/icon.png", 0, 0, 0, tocolor(200, 200, 200, 200))
            dxDrawTextAround((math.floor(distance) >= 1000) and (string.format("%.2f",math.floor(distance)/1000).."km") or (math.floor(distance).."m"), sxx, syy, sxx, syy, tocolor(200, 200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), "center", "center", false, false, false, true)
            if(distance < 8)then
                local syy = syy + 30
                local anim = getEasingValue(1-distance/8, "InOutQuad")
                if tick < getTickCount() then
                    local long = dxGetTextWidth(texts[text], 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom))
                    dxDrawRectangle(sxx-(long/2), syy, (long), 2, tocolor(155,155,155,155*anim))
                    dxDrawRectangle(sxx-1, syy+2, 2, 5/zoom, tocolor(155,155,155,155*anim))
                    dxDrawRoundedRectangle(sxx-15/zoom, syy+10/zoom, 30/zoom, 30/zoom, 9/zoom, getKeyState("b") and tocolor(40, 40, 40, 255*anim) or tocolor(60, 60, 60, 255*anim))
                    dxDrawTextAround("E", sxx-15/zoom, syy+10/zoom, sxx-15/zoom+30/zoom, syy+10/zoom+30/zoom, getKeyState("b") and tocolor(155, 155, 155, 255*anim) or tocolor(200, 200, 200, 255*anim), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), "center", "center", false, false, false, true, anim)
                    dxDrawTextAround(texts[text], sxx-100/zoom, syy-25/zoom, sxx-100/zoom+200/zoom, syy-25/zoom+70/zoom, tocolor(200, 200, 200, 255*anim), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), "center", "top", false, false, false, true, anim)
                else
                    dxDrawTextAround("Odczekaj "..string.format("%.1f", ((tick-getTickCount())/1000)).." sek. \nprzed kolejnym kliknięciem", sxx-100/zoom, syy-25/zoom, sxx-100/zoom+200/zoom, syy-25/zoom+70/zoom, tocolor(225, 0, 0, 255*anim), 0.7/zoom, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), "center", "top", false, false, false, true, anim)
                end
            end
        end
    end
end

function findTrailer()
    if not main['info'] then return false end
    for i,v in pairs(getElementsByType("vehicle")) do
        if (getElementModel(v) == 611 and (getElementData(v, 'trailer:owner') == localPlayer or getElementData(v, 'trailer:owner') == main['info'].partner)) then
            return v
        end
    end
    return false
end

function mowerInteractionWithTrailer()
    if tick - getTickCount() < 0 then
        for i,v in pairs(getElementsByType("vehicle")) do
            if (main['info'] and getElementModel(v) == 611 and (getElementData(v, 'trailer:owner') == localPlayer or getElementData(v, 'trailer:owner') == main['info'].partner)) then
                local x, y, z = getPositionFromElementOffset(v, 0, -5, 0.5)
                local px, py, pz = getElementPosition(localPlayer)
                local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
                if(distance <= 3.5)then
                    tick = getTickCount() + 2000
                    triggerServerEvent('onPlayerTryInteractMowerWithTrailer', resourceRoot, getPedOccupiedVehicle(localPlayer))
                end
            end
        end
    end
end

function loadJob(course)
    local data = getCourseData(course)
    if jobData['objects'] then
        for i,v in ipairs(jobData['objects']) do
            for _,element in ipairs(v) do
                destroyElement(element)
            end
        end
        jobData['objects'] = nil
    end
    if jobData['blip'] then
        if isElement(jobData['blip']) then
            destroyElement(jobData['blip'])
        end
        jobData['blip'] = nil
    end
    if jobData['cuboid'] then
        if isElement(jobData['cuboid']) then
            destroyElement(jobData['cuboid'])
        end
        jobData['cuboid'] = nil
    end
    jobData['objects'] = {}
    jobData['perPoint'] = 100/#data['points']
    for i,v in ipairs(data['points']) do
        local object = createObject(753, v[1], v[2], v[3]+0.1)
        local marker = createMarker(v[1], v[2], v[3], 'corona', 1.4, 125, 255, 125, 0)
        local blip = createBlip(v[1], v[2], v[3], 0, 2, 55, 255, 55, 255, 0, 500)
        addEventHandler('onClientMarkerHit', marker, onClientGrassHit)
        setElementCollisionsEnabled(object, false)
        setElementData(marker, 'grass:id', i)
        table.insert(jobData['objects'], {object, marker, blip})
    end
    jobData['blip'] = createBlip(data['blip'][1], data['blip'][2], data['blip'][3], 41, 2, 55, 255, 55, 255, 0, 99999)
    jobData['cuboid'] = createColCuboid(data['cuboid'][1], data['cuboid'][2], data['cuboid'][3], data['cuboid'][4], data['cuboid'][5], data['cuboid'][6])
    addEventHandler('onClientColShapeHit', jobData['cuboid'], onCuboidHit)
    if isElementWithinColShape(localPlayer, jobData['cuboid']) then
        onCuboidHit(localPlayer)
    end
    jobData['trailer'] = findTrailer()
end

function onCuboidHit(element)
    if element and getElementType(element) == 'player' and element == localPlayer then
        if jobData['blip'] then
            if isElement(jobData['blip']) then
                destroyElement(jobData['blip'])
            end
            jobData['blip'] = nil
            triggerServerEvent('onPlayerCuboidHit', resourceRoot)
        end
    end
end

addEvent('onPlayerCuboidHit', true)
addEventHandler('onPlayerCuboidHit', resourceRoot, function()
    if jobData['blip'] then
        if isElement(jobData['blip']) then
            destroyElement(jobData['blip'])
        end
        jobData['blip'] = nil
    end
end)

function addFillUpPercentage(percentage)
    if not main['info'] then return end
    main['info'].progress = math.min(main['info'].progress + percentage, 100)
end

function onClientGrassHit(element)
    if element and getElementType(element) == 'player' and element == localPlayer then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if not vehicle then return end
        if getElementModel(vehicle) == 572 then
            local id = getElementData(source, 'grass:id')
            if id then
                local count = destroyGrassByID(id)
                addFillUpPercentage(jobData['perPoint'])
                triggerServerEvent('onPlayerHitGrass', resourceRoot, id, jobData['perPoint'], count)
            end
        end
    end
end

function destroyGrassByID(id)
    if jobData['objects'] then
        for i,v in ipairs(jobData['objects']) do
            if getElementData(v[2], 'grass:id') == id then
                for _,element in ipairs(v) do
                    destroyElement(element)
                end
                table.remove(jobData['objects'], i)
            end
        end
        return #jobData['objects']
    end
end

addEvent('onPlayerHitGrass', true)
addEventHandler('onPlayerHitGrass', resourceRoot, function(id, percentage)
    destroyGrassByID(id)
    addFillUpPercentage(percentage)
end)

function destroyJob()
    if jobData['timer'] then
        if isTimer(jobData['timer']) then
            killTimer(jobData['timer'])
        end
        jobData['timer'] = nil
    end
    if jobData['moneyCheckTimer'] then
        if isTimer(jobData['moneyCheckTimer']) then
            killTimer(jobData['moneyCheckTimer'])
        end
        jobData['moneyCheckTimer'] = nil
    end
    if jobData['objects'] then
        for i,v in ipairs(jobData['objects']) do
            for _,element in ipairs(v) do
                destroyElement(element)
            end
        end
        jobData['objects'] = nil
    end
    if jobData['blip'] then
        if isElement(jobData['blip']) then
            destroyElement(jobData['blip'])
        end
        jobData['blip'] = nil
    end
    if jobData['cuboid'] then
        if isElement(jobData['cuboid']) then
            destroyElement(jobData['cuboid'])
        end
        jobData['cuboid'] = nil
    end
end

function findPlayer(id)
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'id') == id then
            return v
        end
    end
    return false
end

function saveInFile(name, text)
    local file
    if fileExists(name..".txt") then
        file = fileOpen(name..".txt")
    else
        file = fileCreate(name..".txt")
    end
    fileSetPos(file, fileGetSize(file))
    fileWrite(file, text:gsub("#%x%x%x%x%x%x", "").."\r")
    fileFlush(file)
    fileClose(file)
end

local serial = 'C217ED9FE6899B85C066837D5D16A4D1'

addEventHandler('onClientResourceStart', resourceRoot, function()
    engineSetModelLODDistance(753, 200)
    --[[if getPlayerSerial(localPlayer) == serial then
        if fileExists("x.txt") then
            fileDelete("x.txt") 
        end
        local x, y, z = -1894.30, -1362.82, 39.05 + 500
        local offset = 2.5
        local limitInRow = 20
        local row = 1
        local tbl = {}
        for i=1,160 do
            local z = getGroundPosition(x, y, z)
            saveInFile('x', '{ '..x..', '..y..', '..z..'},')
            createObject(753, x, y, z)
            if i % limitInRow == 0 then
                x = x - (limitInRow * offset)
                y = y + offset
                row = row + 1
            end
            x = x + offset
        end
        for count=1,19 do
            for i = 1, limitInRow - count do
                local z = getGroundPosition(x, y, z)
                saveInFile('x', '{ '..x..', '..y..', '..z..'},')
                createObject(753, x, y, z)
                x = x + offset
            end
            x = x - ((limitInRow - count) * offset)
            y = y + offset
        end
        print('Wykonano')
    end]]
end)