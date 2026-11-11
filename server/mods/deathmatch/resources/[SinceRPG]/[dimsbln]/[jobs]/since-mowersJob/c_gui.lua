local inviteTime = 30
local main = {}

function getPlayersAround()
    local x,y,z = getElementPosition(localPlayer)
    local data = {}
    for i,v in ipairs(getElementsByType('player')) do
        if v ~= localPlayer then
            local x2,y2,z2 = getElementPosition(v)
            if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) <= 20 then
                table.insert(data, v)
            end
        end
    end
    return data
end

local function render()
    dxDrawImage(sx/2-165/zoom, sy/2-325/2/zoom, 330/zoom, 325/zoom, main['textures']['bg'], 0, 0, 0, tocolor(255, 255, 255, main['alpha']))
	dxDrawText('Wybierz tryb pracy', sx/2, sy/2-128/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][1], 'center', 'bottom')
	dxDrawText('Rozpocznij sesje samemu lub wybierz gracza z listy', sx/2, sy/2-125/zoom, nil, nil, tocolor(103, 213, 94, main['alpha']), 1, main['fonts'][2], 'center', 'top')

    local players = getPlayersAround()
    if #players > 0 then
        local offset = 0
        for i,v in ipairs(players) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                dxDrawImage(sx/2-150/zoom, sy/2-105/zoom+offset, 300/zoom, 32/zoom, main['textures']['bar'], 0, 0, 0, tocolor(255, 255, 255, main['alpha']))
                local nick = getPlayerName(v):gsub('#%x%x%x%x%x%x', '')
                dxDrawText(nick, sx/2-140/zoom, sy/2-105/zoom+16/zoom+offset, nil, nil, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][3], 'left', 'center')
                local textWidth = dxGetTextWidth(nick, 1, main['fonts'][3]) 
                local id = getElementData(v, 'id') or 0
                local textWidth2 = dxGetTextWidth('ID: '..id, 1, main['fonts'][3])+10/zoom
                dxDrawRoundedRectangle(sx/2-135/zoom+textWidth, sy/2-105/zoom+14/2/zoom+offset, textWidth2, 18/zoom, 7/zoom, tocolor(255, 255, 255, 55*main['alpha']/255))
                dxDrawText('ID: '..id,sx/2-134/zoom+textWidth, sy/2-103/zoom+14/2/zoom+offset, sx/2-135/zoom+textWidth+textWidth2, sy/2-105/zoom+14/2/zoom+offset+18/zoom, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][3], 'center', 'center')
        
                local isIn = isMouseInPosition(sx/2+124/zoom, sy/2-99/zoom+offset, 20/zoom, 20/zoom)
                dxDrawImage(sx/2+124/zoom, sy/2-99/zoom+offset, 20/zoom, 20/zoom, main['textures']['button3'], 0, 0, 0, tocolor(255, 255, 255, isIn and main['alpha'] or 200*main['alpha']/255))
                if isIn then
                    local cx,cy = getCursorPosition()
                    local cx, cy = (cx*sx), (cy*sy)
                    dxDrawText(main['states'][main['state']], cx+15/zoom, cy+5/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][3], 'left', 'center')
                end
                offset = offset + 34/zoom
            end
        end
    end
    
    local isIn = isMouseInPosition(sx/2-150/zoom, sy/2+70/zoom, 300/zoom, 35/zoom)
	dxDrawImage(sx/2-150/zoom, sy/2+70/zoom, 300/zoom, 35/zoom, main['textures']['button1'], 0, 0, 0, tocolor(255, 255, 255, isIn and main['alpha'] or 200*main['alpha']/255))
	dxDrawText('Rozpocznij prace jednoosobwą', sx/2, sy/2+68/zoom+35/2/zoom, nil, nil, tocolor(255, 255, 255, isIn and main['alpha'] or 200*main['alpha']/255), 1, main['fonts'][4], 'center', 'center')

    local isIn = isMouseInPosition(sx/2-150/zoom, sy/2+112/zoom, 300/zoom, 35/zoom)
	dxDrawImage(sx/2-150/zoom, sy/2+112/zoom, 300/zoom, 35/zoom, main['textures']['button2'], 0, 0, 0, tocolor(255, 255, 255, isIn and main['alpha'] or 200*main['alpha']/255))
	dxDrawText('Anuluj', sx/2, sy/2+112/zoom+35/2/zoom, nil, nil, tocolor(255, 255, 255, isIn and main['alpha'] or 200*main['alpha']/255), 1, main['fonts'][4], 'center', 'center')
end

local function turnPanel(state)
    if main['block'] then return end
    if state then
        if isEventHandlerAdded('onClientRender', root, render) then return end
        main['block'] = true
        main['textures'] = createTextures('panel', {'bar', 'bg', 'button1', 'button2', 'button3'})
        main['fonts'] = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            [3] = exports['since-fonts']:getFont('Inter-Bold', 10/zoom),
            [4] = exports['since-fonts']:getFont('Inter-SemiBold', 9.333/zoom),
        }
        main['alpha'] = 0
        main['scroll'] = {1,5,5}
        main['states'] = {
            [1] = 'Wybierz gracza',
            [2] = 'Wysłałeś już zaproszenie do składu',
        }
        main['state'] = 1
        addEventHandler('onClientRender', root, render)
        showCursor(true)
        animate(0, 255, 2, 300, function(val)
            main['alpha'] = val
        end, function()
            addEventHandler('onClientClick', root, click)
            bindKey('mouse_wheel_up', 'down', scrollUp)
            bindKey('mouse_wheel_down', 'down', scrollDown)
            main['block'] = nil
        end)
    else
        if not isEventHandlerAdded('onClientRender', root, render) then return end
        main['block'] = true
        showCursor(false)
        unbindKey('mouse_wheel_up', 'down', scrollUp)
        unbindKey('mouse_wheel_down', 'down', scrollDown)
        animate(255, 0, 2, 300, function(val)
            main['alpha'] = val
        end, function()
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, click)
            main['textures'] = destroyTextures(main['textures'])
            for i,v in pairs(main) do
                main[i] = nil
            end
        end)
    end
end

function click(button, state)
    if button == 'left' and state == 'down' then
        if isMouseInPosition(sx/2-150/zoom, sy/2+70/zoom, 300/zoom, 35/zoom) then
            triggerServerEvent('onPlayerSingleStart', resourceRoot)
            turnPanel(false)
        elseif isMouseInPosition(sx/2-150/zoom, sy/2+112/zoom, 300/zoom, 35/zoom) then
            turnPanel(false)
        else
            if main['state'] > 1 then return end
            local players = getPlayersAround()
            if #players > 0 then
                local offset = 0
                for i,v in ipairs(players) do
                    if i >= main['scroll'][1] and i <= main['scroll'][2] then
                        if isMouseInPosition(sx/2+124/zoom, sy/2-99/zoom+offset, 20/zoom, 20/zoom) then
                            triggerServerEvent('onPlayerSendInvite', resourceRoot, getElementData(v, 'id'))
                            main['state'] = 2
                        end
                        offset = offset + 34/zoom
                    end
                end
            end
        end
    end
end

function showPanel()
    turnPanel(true)
end

addEvent('onPlayerCancelInvite', true)
addEventHandler('onPlayerCancelInvite', resourceRoot, function()
    if main['state'] then
        main['state'] = 1
    end
end)

addEvent('onPlayerAcceptInvite', true)
addEventHandler('onPlayerAcceptInvite', resourceRoot, function()
    if isEventHandlerAdded('onClientRender', root, render) then
        turnPanel(false)
    end
end)

function scrollUp()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] == main['scroll'][3] then return end
        main['scroll'][1] = main['scroll'][1] - 1
        main['scroll'][2] = main['scroll'][2] - 1
    end
end

function scrollDown()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] >= #getPlayersAround() then return end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

local main = {}

local function render()
    if not main['invite'] then cancelInvite(true) return end
    if not isElement(main['invite']['element']) then cancelInvite(true) return end

    dxDrawImage(sx/2-165/zoom, sy/2-100/zoom, 330/zoom, 200/zoom, main['textures']['bg'], 0, 0, 0, tocolor(255, 255, 255, main['alpha']))
    dxDrawText('Zaproszenie do grupy', sx/2, sy/2-60/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][1], 'center', 'bottom')
    dxDrawText('Zaproszenie gracza '..main['invite']['nick'], sx/2, sy/2-55/zoom, nil, nil, tocolor(103, 213, 94, main['alpha']), 1, main['fonts'][2], 'center', 'top')

    dxDrawText('Pozostały czas', sx/2, sy/2-5/zoom, nil, nil, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][3], 'center', 'bottom')
    dxDrawImage(sx/2-150/zoom, sy/2, 300/zoom, 35/zoom, main['textures']['bar'], 0, 0, 0, tocolor(255, 255, 255, 55*main['alpha']/255))
    dxDrawImageSection(sx/2-150/zoom, sy/2, (300/zoom)*math.max((main['invite']['tick']-getTickCount())/(inviteTime*1000), 0), 35/zoom, 0, 0, 300*math.max((main['invite']['tick']-getTickCount())/(inviteTime*1000), 0), 35, main['textures']['bar'], 0, 0, 0, tocolor(255, 255, 255, main['alpha']))
    dxDrawText(string.format("%.1f", (math.max(main['invite']['tick']-getTickCount(), 0)/1000))..' sek.', sx/2-150/zoom, sy/2, sx/2+150/zoom, sy/2+35/zoom, tocolor(255, 255, 255, main['alpha']), 1, main['fonts'][3], 'center', 'center')

    dxDrawText('Aby zaakceptować kliknij przycisk #4FCB63B', sx/2, sy/2+65/zoom, nil, nil, tocolor(255, 255, 255, 200*main['alpha']/255), 1, main['fonts'][4], 'center', 'center', false, false, false, true)

    if main['invite']['tick'] < getTickCount() then
        if main['block'] then return end
        cancelInvite(true)
    end
end

function cancelInvite(state)
    if not isEventHandlerAdded('onClientRender', root, render) then return end
    main['block'] = true
    unbindKey('b', 'down', acceptInvite)
    animate(255, 0, 2, 300, function(val)
        main['alpha'] = val
    end, function()
        removeEventHandler('onClientRender', root, render)
        main['textures'] = destroyTextures(main['textures'])
        if main['sound'] then
            if isElement(main['sound']) then
                stopSound(main['sound'])
            end
        end
        for i,v in pairs(main) do
            main[i] = nil
        end
    end)
    if state then
        triggerServerEvent('onPlayerCancelInvite', resourceRoot, main['invite']['id'])
    end
end

function acceptInvite()
    triggerServerEvent('onPlayerAcceptInvite', resourceRoot, main['invite']['id'])
    cancelInvite()
end

local function turnPanel(state)
    if state then
        if isEventHandlerAdded('onClientRender', root, render) then return end
        main['block'] = true
        main['textures'] = createTextures('invite', {'bar', 'bg'})
        main['fonts'] = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 17/zoom),
            [2] = exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom),
            [3] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
            [4] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
        }
        main['alpha'] = 0
        addEventHandler('onClientRender', root, render)
        animate(0, 255, 2, 300, function(val)
            main['alpha'] = val
        end, function()
            main['block'] = nil
            bindKey('b', 'down', acceptInvite)
        end)
        main['sound'] = playSound('files/sounds/invite.mp3')
        setSoundVolume(main['sound'], 0.25)
    else
        if not isEventHandlerAdded('onClientRender', root, render) then return end
        main['block'] = true
        animate(255, 0, 2, 300, function(val)
            main['alpha'] = val
        end, function()
            removeEventHandler('onClientRender', root, render)
            main['textures'] = destroyTextures(main['textures'])
            if main['sound'] then
                if isElement(main['sound']) then
                    stopSound(main['sound'])
                    destroyElement(main['sound'])
                end
            end
            for i,v in pairs(main) do
                main[i] = nil
            end
        end)
    end
end

addEvent('onPlayerGetInvite', true)
addEventHandler('onPlayerGetInvite', resourceRoot, function(playerID)
    local target = findPlayer(playerID)
    if target then
        main['invite'] = {
            ['element'] = target,
            ['nick'] = getPlayerName(target):gsub('#%x%x%x%x%x%x', ''),
            ['id'] = getElementData(target, 'id'),
            ['tick'] = getTickCount()+inviteTime*1000
        }
        turnPanel(true)
    end
end)
