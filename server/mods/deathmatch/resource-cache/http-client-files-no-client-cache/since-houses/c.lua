turning, block, pageChanger, moneyAnim, countDown, exitMarker, interiorSave = nil, nil, nil, nil, getTickCount(), nil, nil

function render()
    local anim = main['anim'][1]
    exports['since-blur']:dxDrawBlur(sx/2-227/zoom, sy/2-299/zoom, 454/zoom, 598/zoom, main['textures']['bg_mask'], pageChanger and 255 or anim)
    local status = getHousePlayerStatus(getElementData(localPlayer, 'player:sid'))
    dxDrawImage(sx/2-227/zoom, sy/2-299/zoom, 454/zoom, 598/zoom, main['textures'][status == 1 and 'bg_red' or status == 2 and 'bg_blue' or status == 0 and 'bg_green'], 0,0,0, tocolor(255,255,255,pageChanger and 255 or anim))
    dxDrawImage(sx/2-207/zoom, sy/2-279/zoom, 34/zoom, 34/zoom, main['textures']['home_icon'], 0,0,0, tocolor(255,255,255,pageChanger and 255 or anim))
    dxDrawText('Nieruchomość #'..main['data'].id, sx/2-167/zoom, sy/2-279/zoom, sx/2-167/zoom+100/zoom, sy/2-279/zoom+34/zoom, tocolor(255,255,255,pageChanger and 255 or anim), 1, main['fonts'][1], 'left', 'top')
    dxDrawText(main['data'].location, sx/2-167/zoom, sy/2-279/zoom, sx/2-167/zoom+100/zoom, sy/2-279/zoom+34/zoom, tocolor(89,255,96,pageChanger and 255 or anim), 1, main['fonts'][2], 'left', 'bottom')

    local isIn = isMouseIn(sx/2+185/zoom, sy/2-281/zoom, 24/zoom, 24/zoom)
    main['anim'][2] = interpolateBetween(main['anim'][2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2+187/zoom, sy/2-279/zoom, 20/zoom, 20/zoom, main['textures']['close_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][2]))

    if main['page'] > 2 then
        local isIn = isMouseIn(sx/2+150/zoom, sy/2-281/zoom, 24/zoom, 24/zoom)
        main['anim'][3] = interpolateBetween(main['anim'][3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2+152/zoom, sy/2-279/zoom, 20/zoom, 20/zoom, main['textures']['arrow_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][3]))
    end

    pages[main['page']](anim)

    if main['marker'] and isElement(main['marker']) then
        local x,y,z = getElementPosition(localPlayer)
        local x2,y2,z2 = getElementPosition(main['marker'])
        if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 2 then
            if not block then
                turnPanel(false)
            end
        end
    end
end

function click(button,state)
    if (button == 'left' and state == 'down' and not block and countDown < getTickCount()) then
        countDown = getTickCount() + 300
        if isMouseIn(sx/2+185/zoom, sy/2-281/zoom, 24/zoom, 24/zoom) then
            turnPanel(false)
        elseif main['page'] == 1 then
            if isMouseIn(sx/2-50/zoom, sy/2+160/zoom, 30/zoom, 30/zoom) then
                main['days'] = math.max(main['days']-1, 0)
                animateMoney(main['days']*main['data'].cost)

            elseif isMouseIn(sx/2+20/zoom, sy/2+160/zoom, 30/zoom, 30/zoom) then
                main['days'] = math.min(main['days']+1, 7)
                animateMoney(main['days']*main['data'].cost)

            elseif isMouseIn(sx/2-115/zoom, sy/2+230/zoom, 230/zoom, 36/zoom) then
                if main['days'] > 0 then
                    triggerServerEvent('H_Houses:buyHouse', resourceRoot, main['data'].id, main['days'], main['days']*main['data'].cost)
                else
                    outputChatBox('#ff0000✘ #FFFFFFNajpierw wybierz ilość dni powyżej', 255,255,255, true)
                end
            end

        elseif main['page'] == 2 then
            if main['data'].owner == getElementData(localPlayer, 'player:sid') then
                if isMouseIn(sx/2-140/zoom, sy/2+150/zoom, 280/zoom, 36/zoom) then
                    changeSide(3)

                elseif isMouseIn(sx/2-100/zoom, sy/2+195/zoom, 200/zoom, 36/zoom) then
                    local uid = getElementData(localPlayer, 'player:sid')
                    if main['data'].owner == uid then
                        enterHouse(main['data'].owner)
                        return
                    end
                end
            else
                if isMouseIn(sx/2-140/zoom, sy/2+150/zoom, 280/zoom, 36/zoom) then
                    outputChatBox('#ff0000✘ #FFFFFFBrak dostępu', 255,255,255, true)

                elseif isMouseIn(sx/2-100/zoom, sy/2+195/zoom, 200/zoom, 36/zoom) then
                    local uid = getElementData(localPlayer, 'player:sid')
                    for i,v in ipairs(main['data'].locators) do
                        if tonumber(v.uid) == tonumber(uid) then
                            enterHouse(main['data'].owner)
                            return
                        end
                    end
                    outputChatBox('#ff0000✘ #FFFFFFBrak dostępu', 255,255,255, true)
                    
                end
            end

        elseif main['page'] == 3 then
            if main['data'].owner ~= getElementData(localPlayer, 'player:sid') then 
                return 
            end
            if isMouseIn(sx/2+150/zoom, sy/2-281/zoom, 24/zoom, 24/zoom) then
                changeSide(2)

            elseif isMouseIn(sx/2-115/zoom, sy/2+5/zoom, 230/zoom, 36/zoom) then
                if #main['data'].locators >= types[main['data'].type].locators then outputChatBox('#ff0000✘ #FFFFFFOsiągnięto limit lokatorów', 255,255,255, true) return end
                local text = exports['since-gui']:getEditboxText(main['editbox'][1])
                if not text or not tonumber(text) then
                    outputChatBox('#ff0000✘ #FFFFFFWprowadź uid gracza', 255,255,255, true)
                    return
                end
                triggerServerEvent('H_Houses:addLocator', resourceRoot, text, main['data'].id)

            elseif isMouseIn(sx/2-195/zoom, sy/2-185/zoom, 390/zoom, 140/zoom) then
                local x = 0
                for i,v in ipairs(main['data'].locators) do
                    if i >= main['scroll'][1] and i <= main['scroll'][2] then
                        x=x+1
                        local offset = ((45/zoom)*(x-1))
                        if isMouseIn(sx/2+150/zoom, sy/2-170/zoom+offset, 20/zoom, 20/zoom) then
                            triggerServerEvent('H_Houses:removeLocator', resourceRoot, v.uid, main['data'].id)
                        end
                    end
                end

            elseif isMouseIn(sx/2-50/zoom, sy/2+80/zoom, 30/zoom, 30/zoom) then
                main['days'] = math.max(main['days']-1, 0)
                animateMoney(main['days']*main['data'].cost)

            elseif isMouseIn(sx/2+20/zoom, sy/2+80/zoom, 30/zoom, 30/zoom) then
                main['days'] = math.min(main['days']+1, 7)
                animateMoney(main['days']*main['data'].cost)

            elseif isMouseIn(sx/2-115/zoom, sy/2+115/zoom, 230/zoom, 36/zoom) then
                if main['days'] > 0 then
                    triggerServerEvent('H_Houses:payHouse', resourceRoot, main['data'].id, main['days'], main['days']*main['data'].cost)
                else
                    outputChatBox('#ff0000✘ #FFFFFFNajpierw wybierz ilość dni powyżej', 255,255,255, true)
                end

            elseif isMouseIn(sx/2-115/zoom, sy/2+255/zoom, 230/zoom, 36/zoom) then
                triggerServerEvent('H_Houses:leaveHouse', resourceRoot, main['data'].id)

            end
        end
    end
end

function getHousePlayerStatus(sid)
    if not main['data'] then return end
    if main['data'].owner == tonumber(sid) then
        return 2
    end
    for i,v in ipairs(main['data'].locators) do
        if tonumber(v.uid) == tonumber(sid) then
            return 2
        end
    end
    if not main['data'].owner then
        return 0
    end
    if main['data'].owner then
        return 1
    end
end

function enterHouse(uid)
    local info = types[main['data'].type].interior
    turnPanel(false, nil, 2000)
    fadeCamera(false, 0.5)
    setElementFrozen(localPlayer, true)
    setTimer(function()
        local x,y,z = unpack(info.exit)
        exitMarker = createMarker(x,y,z+0.6, 'arrow', 1.25, 255,255,255,55)
        setElementDimension(exitMarker, uid)
        setElementInterior(exitMarker, info.int)
        interiorSave = {getElementPosition(main['marker'])}
        triggerServerEvent('H_Houses:enterHouse', resourceRoot, info, uid)
        setTimer(function()
            setElementFrozen(localPlayer, false)
            fadeCamera(true, 1.5)
            addEventHandler('onClientMarkerHit', exitMarker, exitHouse)
        end, 500, 1)
    end, 1000, 1)
end

function exitHouse(el, md)
    if el == localPlayer and md then
        removeEventHandler('onClientMarkerHit', exitMarker, exitHouse)
        fadeCamera(false, 0.5)
        setElementFrozen(localPlayer, true)
        setTimer(function()
            setElementFrozen(localPlayer, false)
            destroyElement(exitMarker)
            exitMarker = nil
            triggerServerEvent('H_Houses:exitHouse', resourceRoot, interiorSave)
            interiorSave = nil
            setTimer(function()
                setElementFrozen(localPlayer, false)
                fadeCamera(true, 1.5)
            end, 500, 1)
        end, 1000, 1)
    end
end

function createTextures()
    main['anim'] = {0,0,0,0,0,0}
    main['textures'] = {}
    main['fonts'] = {}
    for i,v in ipairs({'bg_red','bg_green','bg_blue','home_icon','close_icon','arrow_icon','circle_icon','button_1','button_2','button_3','avatar','settings_icon','enter_icon','hh_icon','mask','avatar_frame','days_bg','locators_bg','locators_bar','editbox','person_icon','bg_mask'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    for i,v in ipairs({{'bold', 12/zoom},{'medium', 10/zoom},{'bold', 16/zoom},{'medium', 11/zoom}}) do
        if fileExists('files/fonts/'..v[1]..'.ttf') then
            main['fonts'][i] = dxCreateFont('files/fonts/'..v[1]..'.ttf', v[2])
        end
    end
    main['editbox'] = {}
    setTimer(function()
        main['editbox'][1] = exports['since-gui']:createEditbox('Wprowadź uid', sx/2-115/zoom, sy/2-40/zoom, 230/zoom, 36/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 10/zoom,
            caretColor = {255, 255, 255, 50},
            caretWidth = 2,
            font = main['fonts'][2],
            image = main['textures']['editbox'],
            placeholderColor = {198, 198, 198}
        })
        exports['since-gui']:setElementAlpha(main['editbox'][1], 0)
    end, 250, 1)
end

function destroyTextures()
    exports['since-gui']:destroyUIElement(main['editbox'][1])
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in ipairs(main['fonts']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['editbox'] and main['editbox'][1] then
        exports['since-gui']:destroyUIElement(main['editbox'][1])
    end
end)

function changeSide(page)
    if main['page'] == page then
        return
    end
    block = true
    pageChanger = true
    main['pageChanger'] = page
    if page ~= 3 then
        exports['since-gui']:fadeElement(main['editbox'][1], 0, 200, 'InOutQuad')
    end
    animate(255, 0, 2, 300, function(value)
        main['anim'][1] = value
    end, function()
        main['page'] = page
        main['days'] = 0
        main['cost'] = 0
        if page == 3 then
            exports['since-gui']:fadeElement(main['editbox'][1], 1, 200, 'InOutQuad')
        end
        main['scroll'] = {1, 3, 3}
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            block = nil
            pageChanger = nil
        end)
    end)
end

function animateMoney(value)
    if moneyAnim then
        destroyAnimation(moneyAnim)
    end
    moneyAnim = animate(main['cost'], value, 1, 300, function(value)
        main['cost'] = math.floor(value)
    end, function()
        moneyAnim = nil
    end)
end

function turnPanel(state, marker, timer)
    if block then return end
    if state then
        if getElementData(localPlayer, 'player:job') == 'dostawca' then
            return
        end

        turning = true
        block = true
        createTextures()
        main['marker'] = marker
        main['data'] = getElementData(marker, 'house:data')
        main['data'].date = main['data'].date and string.gsub(main['data'].date, '-', '.') or nil
        local x,y,z = getElementPosition(marker)
        main['data'].location = getZoneName(x,y,z,true)..', '..getZoneName(x,y,z)
        main['page'] = main['data'].owner and 2 or 1
        main['pageChanger'] = main['data'].owner and 2 or 1
        main['days'] = 0
        main['cost'] = 0
        main['scroll'] = {1, 3, 3}
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, click)
            bindKey('mouse_wheel_up', 'down', scrollUP)
            bindKey('mouse_wheel_down', 'down', scrollDOWN)
            turning = nil
            block = nil
        end)
        showCursor(true, false)
        addEventHandler('onClientRender', root, render)
        guiSetInputEnabled(false)
    else
        turning = true
        block = true
        removeEventHandler('onClientClick', root, click)
        unbindKey('mouse_wheel_up', 'down', scrollUP)
        unbindKey('mouse_wheel_down', 'down', scrollDOWN)
        showCursor(false)
        exports['since-gui']:fadeElement(main['editbox'][1], 0, 200, 'InOutQuad')
        guiSetInputEnabled(true)
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            if timer then
                setTimer(function()
                    destroyTextures()
                    turning = nil
                    block = nil
                end, timer, 1)
            else
                destroyTextures()
                turning = nil
                block = nil
            end
        end)
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
        if main['scroll'][2] >= #main['data'].locators then 
            return 
        end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

addEventHandler('onClientMarkerHit', resourceRoot, function(el, md)
    if el ~= localPlayer or getPedOccupiedVehicle(localPlayer) or isEventHandlerAdded('onClientRender', root, render) or not getElementData(localPlayer, 'player:sid') or not getElementData(source, 'house:data') then return end
    turnPanel(true, source)
end)

function isPlayerOnline(uid)
    if not uid or not tonumber(uid) then 
        return 
    end
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') == tonumber(uid) then
            return true
        end
    end
end

addEvent('H_Houses:refresh', true)
addEventHandler('H_Houses:refresh', resourceRoot, function(page)
    main['data'] = getElementData(main['marker'], 'house:data')
    main['data'].date = main['data'].date and string.gsub(main['data'].date, '-', '.') or nil
    local x,y,z = getElementPosition(main['marker'])
    main['data'].location = getZoneName(x,y,z,true)..', '..getZoneName(x,y,z)
    if #main['data'].locators > 0 then
        main['scroll'] = {1, 3, 3}
    end
    if page then
        changeSide(main['data'].owner and 2 or 1)
    end
end)

bindKey('k', 'both', function(key, state)
	if state == 'down' then
		for i, v in ipairs(getElementsByType('marker', resourceRoot)) do
			local data = getElementData(v, 'house:data')
            if data then
			    createBlipAttachedTo(v, data.owner and 32 or 31, 2, 255, 255, 255, 255, 0, 450)
            end
		end
	else
		for i, v in ipairs(getElementsByType('blip', resourceRoot)) do
			destroyElement(v)
		end
	end
end)
getResourceName(getThisResource(), true, 734636413); if true then return end