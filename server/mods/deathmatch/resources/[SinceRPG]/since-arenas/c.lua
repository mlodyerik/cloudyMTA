
local marker = createMarker(1490.61, -1785.32, 18.73-1, 'cylinder', 2.5, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Areny 1v1')
setElementData(marker, 'marker:desc', 'Zmierz się z randomem')
setElementData(marker, 'marker:icon', 'skin')
addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    turnPanel(true)
end)
addEventHandler("onClientMarkerLeave", marker, function(plr)
    if plr ~= localPlayer then return end
    turnPanel(false)
end)

function render()
    exports['since-blur']:dxDrawBlur(sx/2 - 195/zoom, sy/2 - 237/zoom, 390/zoom, 474/zoom, main['textures']['mask'])
	dxDrawImage(sx/2 - 195/zoom, sy/2 - 237/zoom, 390/zoom, 474/zoom, 'files/images/bg.png')

    dxDrawText('Areny 1vs1', sx/2, sy/2 - 195/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Stwórz arenę lub do niej dołącz', sx/2, sy/2 - 195/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
    
    local offset = 0
    for i,v in ipairs(main['lobby']) do
        if i >= main['scroll'][1] and i <= main['scroll'][2] then
            dxDrawImage(sx/2-185/zoom, sy/2-152/zoom + offset, 370/zoom, 50/zoom, 'files/images/bg2.png')
            dxDrawText('Arena gracza #92FF89'..v[1], sx/2-180/zoom, sy/2-146/zoom + offset, sx/2-180/zoom+370/zoom, sy/2-146/zoom + offset+50/zoom, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'top', false, false, false, true)
            dxDrawText('Stawka: #92FF89$ '..formatNumber(v[2]), sx/2-180/zoom, sy/2-158/zoom + offset, sx/2-180/zoom+370/zoom, sy/2-158/zoom + offset+50/zoom, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'bottom', false, false, false, true)
            dxDrawImage(sx/2+97/zoom, sy/2-141/zoom + offset, 78/zoom, 28/zoom, 'files/images/button1.png', 0, 0, 0, tocolor(255, 255, 255, isMouseIn(sx/2+97/zoom, sy/2-141/zoom + offset, 78/zoom, 28/zoom) and 215 or 245))
            dxDrawText('Dołącz', sx/2+97/zoom, sy/2-141/zoom + offset, sx/2+97/zoom+78/zoom, sy/2-141/zoom + offset+28/zoom, tocolor(255, 255, 255, isMouseIn(sx/2+97/zoom, sy/2-141/zoom + offset, 78/zoom, 28/zoom) and 215 or 245), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')
            offset = offset + 55/zoom
        end
    end

    dxDrawText('Aby stworzyć arenę wprowadź kwotę o którą chcesz się strzelać jeśli chcesz robić to bez żadnego zakładu nie wpisuj nic.', sx/2-180/zoom, sy/2+155/zoom, sx/2+180/zoom, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center', false, true)

    dxDrawImage(sx/2+70/zoom, sy/2+183/zoom, 115/zoom, 44/zoom, 'files/images/button2.png', 0, 0, 0, tocolor(255, 255, 255, isMouseIn(sx/2+70/zoom, sy/2+183/zoom, 115/zoom, 44/zoom) and 215 or 245))
    dxDrawText('Stwórz arenę', sx/2+70/zoom, sy/2+183/zoom, sx/2+70/zoom+115/zoom, sy/2+183/zoom+44/zoom, tocolor(255, 255, 255, isMouseIn(sx/2+70/zoom, sy/2+183/zoom, 115/zoom, 44/zoom) and 185 or 225), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')
end

function click(button, state)
    if not main['countDown'] then main['countDown'] = getTickCount() end
    if main['countDown'] > getTickCount() then return end
    main['countDown'] = getTickCount() + 500
    if button == 'left' and state == 'down' then
        if isMouseIn(sx/2+70/zoom, sy/2+183/zoom, 115/zoom, 44/zoom) then
            local bet = exports['since-gui']:getEditboxText(main['editbox'])
            if #bet > 0 then
                bet = tonumber(bet)

                if bet then
                    if bet < 0 or bet > 50000000 then
                        return outputChatBox('❌ #FFFFFFPodaj kwotę od $ 0 - $ 50 000 000', 255, 55, 55, true)
                    end
    
                    if getElementData(localPlayer, 'player:faction') or getElementData(localPlayer, 'player:admin') or getElementData(localPlayer, 'player:job') then
                        outputChatBox('❌ #FFFFFFNie możesz tworzyć areny będąc na służbie frakcji, w pracy lub na służbie administracji!', 255, 55, 55, true)
                        return
                    end
                    triggerServerEvent('since-arenas', resourceRoot, {action = 'create', bet = bet})
                else
                    outputChatBox('❌ #FFFFFFMusisz podać kwotę zakładu!', client, 255, 55, 55, true)
                end
            else
                outputChatBox('❌ #FFFFFFMusisz podać kwotę zakładu!', client, 255, 55, 55, true)
            end
        else
            local offset = 0
            for i,v in ipairs(main['lobby']) do
                if i >= main['scroll'][1] and i <= main['scroll'][2] then
                    if isMouseIn(sx/2+97/zoom, sy/2-141/zoom + offset, 78/zoom, 28/zoom) then
                        if getPlayerMoney(localPlayer) < v[2] then
                            outputChatBox('❌ #FFFFFFNie posiadasz wystarczającej ilości gotówki!', 255, 55, 55, true)
                            return
                        end
                        if getElementData(localPlayer, 'player:faction') or getElementData(localPlayer, 'player:admin') or getElementData(localPlayer, 'player:job') then
                            outputChatBox('❌ #FFFFFFNie możesz tworzyć areny będąc na służbie frakcji, w pracy lub na służbie administracji!', 255, 55, 55, true)
                            return
                        end
                        triggerServerEvent('since-arenas', resourceRoot, {action = 'join', id = v[3]})
                    end
                    offset = offset + 55/zoom
                end
            end
        end
    end
end

function turnPanel(state)
    if state then
        if not isEventHandlerAdded('onClientRender', root, render) then
            main['lobby'] = {}
            triggerServerEvent('since-arenas', resourceRoot, {action = 'get'})
            main['scroll'] = {1,5,5}
            main['textures'] = {}
            main['textures']['editbox'] = dxCreateTexture('files/images/editbox.png')
            main['textures']['iconMoney'] = dxCreateTexture('files/images/money.png')
            main['textures']['mask'] = dxCreateTexture('files/images/bg_mask.png')
            main['editbox'] = exports['since-gui']:createEditbox('Wprowadź kwotę..', sx/2-185/zoom, sy/2+183/zoom, 250/zoom, 44/zoom, {215, 215, 215}, {
                alignX = 'left',
                paddingX = 45/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
                image = main['textures']['editbox'],
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                icon = main['textures']['iconMoney'],
                iconPadding = 10/zoom,
                textColor = {255, 255, 255, 200},
            })
            addEventHandler('onClientRender', root, render)
            addEventHandler('onClientClick', root, click)
            showCursor(true, false)
            bindKey('mouse_wheel_up', 'down', scrollUp)
            bindKey('mouse_wheel_down', 'down', scrollDown)
        end
    else
        if isEventHandlerAdded('onClientRender', root, render) then
            unbindKey('mouse_wheel_up', 'down', scrollUp)
            unbindKey('mouse_wheel_down', 'down', scrollDown)
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, click)
            if main['editbox'] then
                exports['since-gui']:destroyUIElement(main['editbox'])
            end
            main['editbox'] = nil
            showCursor(false)
            for i,v in pairs(main['textures']) do
                destroyElement(v)
            end
            main['textures'] = nil
            main['lobby'] = nil
        end
    end
end

addEvent('since-arenas', true)
addEventHandler('since-arenas', resourceRoot, function(data)
    if data['action'] == 'give' then
        main['lobby'] = data['info']
    elseif data['action'] == 'close' then
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
        if main['scroll'][2] >= #main['lobby'] then return end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['editbox'] then
        exports['since-gui']:destroyUIElement(main['editbox'])
    end
end)
