local main = {}

local function render()
    dxDrawImage(sx/2-165/zoom, sy/2-325/2/zoom, 330/zoom, 325/zoom, main.textures['bg'], 0, 0, 0, tocolor(255, 255, 255, main.alpha))
	dxDrawText('Wybierz tryb pracy', sx/2, sy/2-128/zoom, nil, nil, tocolor(255, 255, 255, main.alpha), 1, main.fonts[1], 'center', 'bottom')
	dxDrawText('Stwórz grupę lub dołącz do istniejącej', sx/2, sy/2-125/zoom, nil, nil, tocolor(46, 117, 111, main.alpha), 1, main.fonts[2], 'center', 'top')

    local groups = main.gropus
    if #groups > 0 then
        local offset = 0
        for i,v in ipairs(groups) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                dxDrawImage(sx/2-150/zoom, sy/2-105/zoom+offset, 300/zoom, 32/zoom, main.textures['bar'], 0, 0, 0, tocolor(255, 255, 255, main.alpha))
                dxDrawText(v.name, sx/2-140/zoom, sy/2-105/zoom+16/zoom+offset, nil, nil, tocolor(255, 255, 255, main.alpha), 1, main.fonts[3], 'left', 'center')
                local textWidth = dxGetTextWidth(v.name, 1, main.fonts[3]) 
                local members = #v.players
                local textWidth2 = dxGetTextWidth(members..'/4', 1, main.fonts[3])+10/zoom
                dxDrawRoundedRectangle(sx/2-135/zoom+textWidth, sy/2-105/zoom+14/2/zoom+offset, textWidth2, 18/zoom, 7/zoom, tocolor(255, 255, 255, 55*main.alpha/255))
                dxDrawText(members..'/4', sx/2-134/zoom+textWidth, sy/2-103/zoom+14/2/zoom+offset, sx/2-135/zoom+textWidth+textWidth2, sy/2-105/zoom+14/2/zoom+offset+18/zoom, tocolor(255, 255, 255, main.alpha), 1, main.fonts[3], 'center', 'center')
        
                local isIn = isMouseInPosition(sx/2+124/zoom, sy/2-99/zoom+offset, 20/zoom, 20/zoom)
                dxDrawImage(sx/2+124/zoom, sy/2-99/zoom+offset, 20/zoom, 20/zoom, main.textures['button3'], 0, 0, 0, tocolor(255, 255, 255, isIn and main.alpha or 200*main.alpha/255))
                if isIn then
                    local cx,cy = getCursorPosition()
                    local cx, cy = (cx*sx), (cy*sy)
                    local text = members >= 4 and 'Grupa pełna' or 'Dołącz'
                    dxDrawText(text, cx+15/zoom, cy+5/zoom, nil, nil, tocolor(255, 255, 255, main.alpha), 1, main.fonts[3], 'left', 'center')
                end
                offset = offset + 34/zoom
            end
        end
    end
    
    local isIn = isMouseInPosition(sx/2-150/zoom, sy/2+70/zoom, 300/zoom, 35/zoom)
	dxDrawImage(sx/2-150/zoom, sy/2+70/zoom, 300/zoom, 35/zoom, main.textures['button1'], 0, 0, 0, tocolor(255, 255, 255, isIn and main.alpha or 200*main.alpha/255))
	dxDrawText('Stwórz grupę', sx/2, sy/2+68/zoom+35/2/zoom, nil, nil, tocolor(255, 255, 255, isIn and main.alpha or 200*main.alpha/255), 1, main.fonts[4], 'center', 'center')

    local isIn = isMouseInPosition(sx/2-150/zoom, sy/2+112/zoom, 300/zoom, 35/zoom)
	dxDrawImage(sx/2-150/zoom, sy/2+112/zoom, 300/zoom, 35/zoom, main.textures['button2'], 0, 0, 0, tocolor(255, 255, 255, isIn and main.alpha or 200*main.alpha/255))
	dxDrawText('Anuluj', sx/2, sy/2+112/zoom+35/2/zoom, nil, nil, tocolor(255, 255, 255, isIn and main.alpha or 200*main.alpha/255), 1, main.fonts[4], 'center', 'center')
end

local function turnPanel(state)
    if main.block then return end
    if state then
        if isEventHandlerAdded('onClientRender', root, render) then return end
        main.block = true
        main.textures = createTextures({'bar', 'bg', 'button1', 'button2', 'button3'})
        main.fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            [3] = exports['since-fonts']:getFont('Inter-Bold', 10/zoom),
            [4] = exports['since-fonts']:getFont('Inter-SemiBold', 9.333/zoom),
        }
        main.scroll = {1,5,5}
        main.alpha = 0
        main.gropus = {}
        triggerServerEvent('onPlayerGetGroups', resourceRoot)
        animate(0, 255, 2, 300, function(a)
            main.alpha = a
        end, function()
            bindKey('mouse_wheel_up', 'down', scrollUp)
            bindKey('mouse_wheel_down', 'down', scrollDown)
            addEventHandler('onClientClick', root, click)
            main.block = nil
        end)
        addEventHandler('onClientRender', root, render)
        showCursor(true)
    else
        if not isEventHandlerAdded('onClientRender', root, render) then return end
        main.block = true
        removeEventHandler('onClientClick', root, click)
        unbindKey('mouse_wheel_up', 'down', scrollUp)
        unbindKey('mouse_wheel_down', 'down', scrollDown)
        showCursor(false)
        animate(255, 0, 2, 300, function(a)
            main.alpha = a
        end, function()
            removeEventHandler('onClientRender', root, render)
            main.textures = destroyTextures(main.textures)
            main = {}
        end)
    end
end

function click(button, state)
    if button ~= 'left' or state ~= 'down' then return end
    if main.block then return end
    if isMouseInPosition(sx/2-150/zoom, sy/2+70/zoom, 300/zoom, 35/zoom) then
        triggerServerEvent('onPlayerLobbyCreate', resourceRoot)
        turnPanel(false)
    elseif isMouseInPosition(sx/2-150/zoom, sy/2+112/zoom, 300/zoom, 35/zoom) then
        turnPanel(false)
    else
        local groups = main.gropus
        if #groups > 0 then
            local offset = 0
            for i,v in ipairs(groups) do
                if i >= main['scroll'][1] and i <= main['scroll'][2] then
                    local isIn = isMouseInPosition(sx/2+124/zoom, sy/2-99/zoom+offset, 20/zoom, 20/zoom)
                    if isIn then
                        if #v.players >= 4 then return end
                        triggerServerEvent('onPlayerJoinGroup', resourceRoot, v.id)
                        turnPanel(false)
                        break
                    end
                    offset = offset + 34/zoom
                end
            end
        end

    end
end

function showPanel()
    turnPanel(true)
end

addEvent('onPlayerGetGroups', true)
addEventHandler('onPlayerGetGroups', resourceRoot, function(groups)
    if not isEventHandlerAdded('onClientRender', root, render) then return end
    main.gropus = groups
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
        if not main.gropus then return end
        if main['scroll'][2] >= #main.gropus then return end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end