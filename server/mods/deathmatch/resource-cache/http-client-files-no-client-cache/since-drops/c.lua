local sx, sy = guiGetScreenSize()
local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1 
local elements = {}
local renderTargets = {}
local main = {}

function loadRenderTarget(element)
    if not renderTargets[element] then
        renderTargets[element] = dxCreateRenderTarget(512, 512, true)
    end
    local data = getElementData(element, 'drop:data')
    local x,y,z = getElementPosition(element)
    dxSetRenderTarget(renderTargets[element], true)
        dxSetBlendMode('modulate_add')
        dxDrawImage(0, 101, 512, 310, 'files/images/bg.png', 0, 0, 0, tocolor(255,255,255,255))
        dxDrawText('Zrzut', 256, 155, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Bold', 22), 'center', 'bottom')
        dxDrawText('Nielegalny pakunek', 256, 155, nil, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Medium', 15), 'center', 'top')

        if data then
            if data.landing then
                dxDrawText('Zlatuje', 256, 270, nil, nil, tocolor(255,255,255,155), 1, exports['since-fonts']:getFont('Inter-Black', 45), 'center', 'center')
                dxDrawText(getZoneName(x,y,z,true)..', '..getZoneName(x,y,z,false), 256, 400, nil, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Medium', 17), 'center', 'bottom')
            else
                if data.isTaken then
                    local player = data.player
                    local nick = getPlayerName(player)
                    local time = data.time
                    local maxTime = data.maxTime
                    local organization = getElementData(player, 'player:organization') or {name = 'Brak organizacji'}
                    dxDrawText('Przejmujący', 10, 220, nil, nil, tocolor(222,222,222,255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'left', 'bottom')
                    dxDrawImage(10, 300, 100, 100, exports['since-avatars']:getPlayerAvatar(getElementData(data.player, 'player:sid'), main['avatarMask']), 0, 0, 0, tocolor(255,255,255,255))
                    dxDrawImage(10, 300, 100, 100, 'files/images/avatarBg.png', 0, 0, 0, tocolor(255,255,255,255))
                    dxDrawText(nick, 10, 260, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Bold', 19), 'left', 'bottom')
                    dxDrawText(organization.name, 10, 260, nil, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Bold', 15), 'left', 'top')
                    dxDrawText('Lokalizacja', 512-10, 220, nil, nil, tocolor(222,222,222,255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'right', 'bottom')
                    dxDrawText(getZoneName(x,y,z,true)..'\n'..getZoneName(x,y,z,false), 512-10, 225, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 17), 'right', 'top')
                    dxDrawText('Postęp', 512-10, 320, nil, nil, tocolor(222,222,222,255), 1, exports['since-fonts']:getFont('Inter-Black', 14), 'right', 'bottom')
                    dxDrawText(math.floor(100-100*time/maxTime)..'%', 512-10, 320, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Black', 45), 'right', 'top')
                else
                    dxDrawText('W skrzyni znajduje się', 256, 225, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 13), 'center', 'bottom')
                    local rewards = data.rewards
                    local offset = -((#rewards-1)*66+(#rewards-1)*36)/2-(66)/2
                    for i,v in ipairs(rewards) do
                        dxDrawImage(256 + offset, 240, 66, 66, 'files/images/itemFrame.png', 0, 0, 0, tocolor(255,255,255,255))
                        dxDrawImage(258 + offset, 242, 62, 62, 'files/images/'..v[1]..'Icon.png', 0, 0, 0, tocolor(255,255,255,255))
                        dxDrawText(rewardNames[v[1]], 256 + offset, 330, 256 + offset + 66, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'center', 'bottom')
                        dxDrawText(v[2]..'/'..v[3], 256 + offset, 330, 256 + offset + 66, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Bold', 11), 'center', 'top')
                        offset = offset + 66 + 36
                    end
                    local textWidth = dxGetTextWidth('Aby przejąć zrzut kliknij', 1, exports['since-fonts']:getFont('Inter-Medium', 16))
                    dxDrawText('Aby przejąć zrzut kliknij', 236+textWidth/2, 380, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 16), 'right', 'center')
                    dxDrawImage(246+textWidth/2, 360, 40, 40, 'files/images/buttonFrame.png', 0, 0, 0, tocolor(255,255,255,255))
                    dxDrawText('E', 246+textWidth/2, 360, 246+textWidth/2+40, 360+40, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Bold', 18), 'center', 'center')
                end
            end
        else
            dxDrawText('Zrzut został już przejęty', 0, 270, 512, nil, tocolor(255,255,255,155), 1, exports['since-fonts']:getFont('Inter-Black', 45), 'center', 'center', false, true)
            dxDrawText(getZoneName(x,y,z,true)..', '..getZoneName(x,y,z,false), 256, 400, nil, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Medium', 17), 'center', 'bottom')
        end
        dxSetBlendMode('blend')
    dxSetRenderTarget()
end

function preRender()
    local px,py,pz = getElementPosition(localPlayer)
    for element, _ in pairs(elements) do
        if renderTargets[element] then
            local x,y,z = getElementPosition(element)
            local ox,oy,oz = getPositionFromElementOffset(element, 1.02, 0, 0)
            local ox2,oy2,oz2 = getPositionFromElementOffset(element, 3, 0, 0)
            dxDrawMaterialLine3D(ox,oy,oz+0.1 + 1.95, ox,oy,oz+0.1, renderTargets[element], 1.95, tocolor(255,255,255,255), false, ox2,oy2,oz2)
        end
    end
end

function render()
    local px,py,pz = getElementPosition(localPlayer)
    for object, _ in pairs(elements) do
        local ox, oy, oz = getElementPosition(object)
        if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) < 45 then
            local data = getElementData(object, 'drop:data')
            if data and not data.landing then
                local offset = 0.05
                for i=1,4 do
                    dxDrawOctagon3D(ox, oy, oz+offset, 10, 3, tocolor(104,214,94,25))
                    offset = offset + 0.1
                end
            end
        end
    end
end

function checkIfPlayerCanInteract(object)
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then return false end
    if isPedDead(localPlayer) then return false end
    if getElementData(localPlayer, 'player:admin') then return false end
    local px,py,pz = getElementPosition(localPlayer)
    local ox,oy,oz = getElementPosition(object)
    if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 10 then return false end
    return true
end

local tick = getTickCount()
function clickKey()
    local object = getNearestElement(localPlayer, 'object', 10)
    if object and isElement(object) then
        local data = getElementData(object, 'drop:data')
        if not data or data.landing or data.isTaken then return end
        if checkIfPlayerCanInteract(object) then
            if tick > getTickCount() then return end
            tick = getTickCount() + 500
            triggerServerEvent('dropsEvent', resourceRoot)
        end
    end
end

function switchState(state)
    if state then
        loadEvent('onClientRender', root, render)
        loadEvent('onClientPreRender', root, preRender)
        if not main['avatarMask'] then
            main['avatarMask'] = dxCreateTexture('files/images/avatarMask.png')
        end
        if not main['binded'] then
            bindKey('e', 'down', clickKey)
            main['binded'] = true
        end
    else
        removeEvent('onClientRender', root, render)
        removeEvent('onClientPreRender', root, preRender)
        if main['binded'] then
            unbindKey('e', 'down', clickKey)
            main['binded'] = nil
        end
    end
end

addEventHandler('onClientElementDataChange', resourceRoot, function(key)
    if key == 'drop:data' and isElementStreamedIn(source) then
        loadRenderTarget(source)
    end
end)

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    elements[source] = true
    loadRenderTarget(source)
    switchState(true)
end)

addEventHandler('onClientElementStreamOut', resourceRoot, function()
    elements[source] = nil
    if getElementsCount(elements) == 0 then
        switchState(false)
    end
end)

addEventHandler('onClientElementDestroy', resourceRoot, function()
    elements[source] = nil
    if getElementsCount(elements) == 0 then
        switchState(false)
    end
end)

addEvent('event', true)
addEventHandler('event', resourceRoot, function()
    for i,v in ipairs(getElementsByType('object', resourceRoot)) do
        if isElementStreamedIn(v) then
            elements[v] = true
            switchState(true)
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    setTimer(function()
        for i,v in ipairs(getElementsByType('object', resourceRoot)) do
            if isElementStreamedIn(v) then
                elements[v] = true
                switchState(true)
            end
        end
        if getElementsCount(elements) == 0 then
            switchState(false)
        end
    end, 500, 1)
end)

addEventHandler('onClientRestore', root, function()
    if getElementsCount(elements) > 0 then
        for element,_ in pairs(elements) do
            loadRenderTarget(element)
        end
    end
end)