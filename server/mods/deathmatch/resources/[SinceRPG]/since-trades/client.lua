local sx, sy = guiGetScreenSize()
local zoom = ((sx < 2048) and math.min(2.2, 2048 / sx) or 1) * 0.9
local trade = {}

function drawTrade()
    dxDrawImage(sx/2-390/zoom, sy/2-271/zoom, 496/zoom, 542/zoom, trade.textures.background)
    dxDrawImage(sx/2+80/zoom, sy/2-261/zoom, 16/zoom, 16/zoom, trade.textures.close, 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(sx/2+80/zoom, sy/2-261/zoom, 16/zoom, 16/zoom) and 150 or 255))

    dxDrawText('Twoja oferta', sx/2-375/zoom, sy/2-227/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[1], 'left', 'bottom', false, false, false, false, false)
    local text = 'Nie zaakceptował transakcji'
    local r,g,b = 170, 75, 75 
    if trade.ready[1] then
        text = 'Zaakceptował transakcję'
        r,g,b = 107, 170, 75
    end
    local textWidth = dxGetTextWidth(text, 1, trade.fonts[2])
    local x,y,w,h = sx/2-375/zoom + dxGetTextWidth('Twoja oferta', 1, trade.fonts[1]) + 10/zoom, sy/2-247/zoom, textWidth + 20/zoom, 20/zoom
    dxDrawRoundedRectangle(x,y,w,h, 5/zoom, tocolor(r,g,b, 255))
    dxDrawText(text, x,y,x+w,y+h, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'center', 'center', false, false, false, false, false)
    dxDrawImage(sx/2-375/zoom, sy/2-219/zoom, 466/zoom, 140/zoom, trade.textures.background3)
    local offset = 0
    for i=1,4 do
        local i = i + trade.scroll1 - 1
        local v = trade.tradeItems[1][i]
        if v then
            local isIn = isMouseInPosition(sx/2-371/zoom, sy/2-215/zoom + offset, 450/zoom, 30/zoom)
            dxDrawImage(sx/2-371/zoom, sy/2-215/zoom + offset, 450/zoom, 30/zoom, trade.textures.bar2, 0, 0, 0, tocolor(255, 255, 255, isIn and 150 or 255))
            local name = v.name
            if (v.type == 'money') then
                name = formatNumber(v.value)..' #68D65E$'
            elseif (v.type == 'wpln') then
                name = formatNumber(v.value)..' #68D65EwPLN'
            elseif (v.type == 'pp') then
                name = formatNumber(v.value)..' #68D65EPP'
            elseif (v.type == 'house') then
                name = name..' #6BC2FF#'..v.id
            elseif (v.type == 'vehicle') then
                name = v.data..' #6BC2FF#'..v.id
            end
            dxDrawText(name, sx/2-366/zoom, sy/2-200/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 150 or 255), 1, trade.fonts[2], 'left', 'center', false, false, false, true, false)
            offset = offset + 34/zoom
        end
    end
    drawScrollbar(trade.tradeItems[1], sx/2+84/zoom, sy/2-215/zoom, 3/zoom, 132/zoom, 4, trade.scroll1, 255)

    local nick = trade.nick
    dxDrawText('Oferta gracza #68D65E'..nick, sx/2-375/zoom, sy/2-46/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[1], 'left', 'bottom', false, false, false, true, false)
    local text = 'Nie zaakceptował transakcji'
    local r,g,b = 170, 75, 75
    if trade.ready[2] then
        text = 'Zaakceptował transakcję'
        r,g,b = 107, 170, 75
    end
    local textWidth = dxGetTextWidth(text, 1, trade.fonts[2])
    local x,y,w,h = sx/2-375/zoom + dxGetTextWidth('Oferta gracza '..nick, 1, trade.fonts[1]) + 10/zoom, sy/2-66/zoom, textWidth + 20/zoom, 20/zoom
    dxDrawRoundedRectangle(x,y,w,h, 5/zoom, tocolor(r,g,b, 255))
    dxDrawText(text, x,y,x+w,y+h, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'center', 'center', false, false, false, false, false)
    dxDrawImage(sx/2-375/zoom, sy/2-38/zoom, 466/zoom, 140/zoom, trade.textures.background3)
    local offset = 0
    for i=1,4 do
        local i = i + trade.scroll2 - 1
        local v = trade.tradeItems[2][i]
        if v then
            dxDrawImage(sx/2-371/zoom, sy/2-215/zoom + 181/zoom + offset, 450/zoom, 30/zoom, trade.textures.bar2, 0, 0, 0, tocolor(255, 255, 255, 255))
            local name = v.name
            if (v.type == 'money') then
                name = formatNumber(v.value)..' #68D65E$'
            elseif (v.type == 'wpln') then
                name = formatNumber(v.value)..' #68D65EwPLN'
            elseif (v.type == 'pp') then
                name = formatNumber(v.value)..' #68D65EPP'
            elseif (v.type == 'house') then
                name = name..' #6BC2FF#'..v.id
            elseif (v.type == 'vehicle') then
                name = v.data..' #6BC2FF#'..v.id
            end
            dxDrawText(name, sx/2-366/zoom, sy/2-200/zoom + 181/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'center', false, false, false, true, false)
            offset = offset + 34/zoom
        end
    end
    drawScrollbar(trade.tradeItems[2], sx/2+84/zoom, sy/2-215/zoom + 181/zoom, 3/zoom, 132/zoom, 4, trade.scroll2, 255)

    dxDrawText('Podsumowanie', sx/2-375/zoom, sy/2+130/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[3], 'left', 'top', false, false, false, false, false)
    dxDrawText('• Gracz #68D65E'..nick..' #FFFFFFoferuje ci #5EABD6'..#trade.tradeItems[2]..' przedmiotów', sx/2-375/zoom, sy/2+160/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'top', false, false, false, true, false)
    dxDrawText('• Oferujesz #5EABD6'..#trade.tradeItems[1]..' przedmiotów #FFFFFFdla gracza #68D65E'..nick, sx/2-375/zoom, sy/2+180/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'top', false, false, false, true, false)

    dxDrawText('Uwaga', sx/2-375/zoom, sy/2+210/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[3], 'left', 'top', false, false, false, false, false)
    dxDrawText('• Wymiany nie można cofnąć, robisz to na własną odpowiedzialność', sx/2-375/zoom, sy/2+240/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'top', false, false, false, true, false)

    dxDrawImage(sx/2+126/zoom, sy/2-271/zoom, 265/zoom, 542/zoom, trade.textures.background2)
    dxDrawText('Dodawanie przedmiotów', sx/2+258/zoom, sy/2-261/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[1], 'center', 'top', false, false, false, false, false)

    local offset = 0
    local texts = {'Posiadłości', 'Pojazdy'}
    for i,v in ipairs(texts) do
        local font = trade.selected == i and trade.fonts[4] or trade.fonts[1]
        dxDrawText(v, sx/2+138/zoom + offset, sy/2-200/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'bottom', false, false, false, false, false)
        offset = offset + dxGetTextWidth(v, 1, font) + 15/zoom
    end

    local text = exports['since-gui']:getEditboxText(trade.editbox[1])
    local items = #text > 0 and findByNameOrId(trade.yourItems[trade.selected], text) or trade.yourItems[trade.selected]
    local offset = 0
    for i=1,4 do
        local i = i + trade.scroll3 - 1
        local v = items[i]
        if v then
            local isIn = isMouseInPosition(sx/2+138/zoom, sy/2-190/zoom + offset, 232/zoom, 34/zoom)
            dxDrawImage(sx/2+138/zoom, sy/2-190/zoom + offset, 232/zoom, 34/zoom, trade.textures.bar, 0, 0, 0, tocolor(255, 255, 255, isIn and 150 or 255))
            dxDrawText(v.name..' #6BC2FF#'..v.id, sx/2+142/zoom, sy/2-188/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 150 or 255), 1, trade.fonts[2], 'left', 'top', false, false, false, true, false)
            dxDrawText(v.data, sx/2+142/zoom, sy/2-158/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 150 or 255), 1, trade.fonts[5], 'left', 'bottom', false, false, false, false, false)
            offset = offset + 39/zoom
        end
    end
    drawScrollbar(items, sx/2+378/zoom, sy/2-190/zoom, 4/zoom, 151/zoom, 4, trade.scroll3, 255)

    local y = sy/2+50/zoom
    dxDrawText('Dodaj kasę do wymiany', sx/2+138/zoom, y, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'bottom', false, false, false, false, false)
    local isIn = isMouseInPosition(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom)
    dxDrawImage(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom, trade.textures.addButton, 0, 0, 0, tocolor(255, 255, 255, isIn and 150 or 255))
    dxDrawText('Dodaj', sx/2+310/zoom, y+9/zoom, sx/2+378/zoom, y+29/zoom, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'center', 'center', false, false, false, false, false)

    y = y + 60/zoom
    dxDrawText('Dodaj wPLN do wymiany', sx/2+138/zoom, y, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'bottom', false, false, false, false, false)
    local isIn = isMouseInPosition(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom)
    dxDrawImage(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom, trade.textures.addButton, 0, 0, 0, tocolor(255, 255, 255, isIn and 150 or 255))
    dxDrawText('Dodaj', sx/2+310/zoom, y+9/zoom, sx/2+378/zoom, y+29/zoom, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'center', 'center', false, false, false, false, false)

    y = y + 60/zoom
    dxDrawText('Dodaj PP do wymiany', sx/2+138/zoom, y, nil, nil, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'left', 'bottom', false, false, false, false, false)
    local isIn = isMouseInPosition(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom)
    dxDrawImage(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom, trade.textures.addButton, 0, 0, 0, tocolor(255, 255, 255, isIn and 150 or 255))
    dxDrawText('Dodaj', sx/2+310/zoom, y+9/zoom, sx/2+378/zoom, y+29/zoom, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'center', 'center', false, false, false, false, false)

    local isIn = isMouseInPosition(sx/2+186/zoom, sy/2+225/zoom, 144/zoom, 30/zoom)
    dxDrawImage(sx/2+186/zoom, sy/2+225/zoom, 144/zoom, 30/zoom, trade.textures.acceptButton, 0, 0, 0, tocolor(255, 255, 255, isIn and 150 or 255))
    dxDrawText(trade.ready[1] and 'Zrezygnuj' or 'Zaakceptuj', sx/2+186/zoom, sy/2+225/zoom, sx/2+330/zoom, sy/2+255/zoom, tocolor(255, 255, 255, 255), 1, trade.fonts[2], 'center', 'center', false, false, false, false, false)

    if trade.tick then
        local secounds = (trade.tick - getTickCount()) / 1000
        if secounds < 0 then
            secounds = 0
        end
        dxDrawText('Wymiana zakończy się za '..string.format('%.2f',secounds)..' sekund', sx/2-1, sy/2+275/zoom-1, nil, nil, tocolor(0, 0, 0, 155), 1, trade.fonts[2], 'center', 'top', false, false, false, false, false)
        dxDrawText('Wymiana zakończy się za '..string.format('%.2f',secounds)..' sekund', sx/2, sy/2+275/zoom, nil, nil, tocolor(255, 0, 0, 255), 1, trade.fonts[2], 'center', 'top', false, false, false, false, false)
    end

end

function findByNameOrId(data, text)
    local found = {}
    for i,v in ipairs(data) do
        if (v.name:lower():find(text:lower()) or v.data:lower():find(text:lower()) or tostring(v.id):find(text)) then
            table.insert(found, v)
        end
    end
    return found
end

function clickTrade(key, state)
    if (key ~= 'left' or state ~= 'down') then
        return false
    end
    if isMouseInPosition(sx/2+80/zoom, sy/2-261/zoom, 16/zoom, 16/zoom) then
        triggerServerEvent('breakTrade', resourceRoot)
        toggleTrade(false)
        return true
    elseif isMouseInPosition(sx/2+186/zoom, sy/2+225/zoom, 144/zoom, 30/zoom) then
        triggerServerEvent('acceptTrade', resourceRoot)
        return true
    else
        local offset = 0
        local texts = {'Posiadłości', 'Pojazdy'}
        for i,v in ipairs(texts) do
            local font = (trade.selected == i and trade.fonts[4] or trade.fonts[1])
            if isMouseInPosition(sx/2+134/zoom + offset, sy/2-224/zoom, dxGetTextWidth(v, 1, font)+8/zoom, 30/zoom) then
                if (trade.selected == i) then
                    return false
                end
                trade.scroll3 = 1
                trade.selected = i
                return true
            end
            offset = offset + dxGetTextWidth(v, 1, font) + 15/zoom
        end

        if trade.ready[1] then
            return false
        end

        local text = exports['since-gui']:getEditboxText(trade.editbox[1])
        local items = #text > 0 and findByNameOrId(trade.yourItems[trade.selected], text) or trade.yourItems[trade.selected]
        local offset = 0
        for i=1,4 do
            local i = i + trade.scroll3 - 1
            local v = items[i]
            if v then
                local isIn = isMouseInPosition(sx/2+138/zoom, sy/2-190/zoom + offset, 232/zoom, 34/zoom)
                if isIn then
                    local data = {
                        type = trade.selected == 1 and 'house' or 'vehicle',
                        id = v.id,
                        name = v.name,
                        data = v.data,
                    }
                    triggerServerEvent('addTradeItem', resourceRoot, data)
                    return true
                end
                offset = offset + 39/zoom
            end
        end

        local offset = 0
        for i=1,4 do
            local i = i + trade.scroll1 - 1
            local v = trade.tradeItems[1][i]
            if v then
                if isMouseInPosition(sx/2-371/zoom, sy/2-215/zoom + offset, 450/zoom, 30/zoom) then
                    triggerServerEvent('removeTradeItem', resourceRoot, v)
                    return true
                end
                offset = offset + 34/zoom
            end
        end

        local y = sy/2+50/zoom
        if isMouseInPosition(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom) then
            local value = exports['since-gui']:getEditboxText(trade.editbox[2])
            if not value or value == '' then
                return false
            end
            if not tonumber(value) then
                return false
            end
            if tonumber(value) < 1 then
                return false
            end
            triggerServerEvent('addTradeItem', resourceRoot, {type = 'money', value = value})
        end
        y = y + 60/zoom
        if isMouseInPosition(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom) then
            local value = exports['since-gui']:getEditboxText(trade.editbox[3])
            if not value or value == '' then
                return false
            end
            if not tonumber(value) then
                return false
            end
            if tonumber(value) < 1 then
                return false
            end
            triggerServerEvent('addTradeItem', resourceRoot, {type = 'wpln', value = value})
        end
        y = y + 60/zoom
        if isMouseInPosition(sx/2+310/zoom, y+9/zoom, 68/zoom, 20/zoom) then
            local value = exports['since-gui']:getEditboxText(trade.editbox[4])
            if not value or value == '' then
                return false
            end
            if not tonumber(value) then
                return false
            end
            if tonumber(value) < 1 then
                return false
            end
            triggerServerEvent('addTradeItem', resourceRoot, {type = 'pp', value = value})
        end

    end
end

function formatTradeItems(tradeItems)
    local items = {}
    for i,v in pairs(tradeItems) do
        if (i == localPlayer) then
            items[1] = v or {}
        else
            items[2] = v or {}
        end
    end
    if not items[1] then
        items[1] = {}
    end
    if not items[2] then
        items[2] = {}
    end
    return items
end

function formatYourItems(yourItems)
    local items = {}
    if yourItems[1] then
        for i,v in ipairs(yourItems[1]) do
            if not items[1] then
                items[1] = {}
            end
            local pos = split(v.position, ',')
            local v = {
                id = v.id,
                name = 'Posiadłość',
                data = getZoneName(pos[1], pos[2], pos[3], true),
            }
            table.insert(items[1], v)
        end
    end
    if yourItems[2] then
        for i,v in ipairs(yourItems[2]) do
            if not items[2] then
                items[2] = {}
            end
            local v = {
                id = v.id,
                name = 'Pojazd',
                data = exports['since-vehiclenames']:getVehicleName(v.model),
            }
            table.insert(items[2], v)
        end
    end
    if not items[1] then
        items[1] = {}
    end
    if not items[2] then
        items[2] = {}
    end
    return items
end

function formatReady(readyTable)
    local ready = {}
    for i,v in pairs(readyTable) do
        if (i == localPlayer) then
            ready[1] = v
        else
            ready[2] = v
        end
    end
    if not ready[1] then
        ready[1] = false
    end
    if not ready[2] then
        ready[2] = false
    end
    return ready
end

function reloadTrade(items, playerItems, ready, startTimer)
    trade.tradeItems = formatTradeItems(items)
    trade.yourItems = formatYourItems(playerItems)
    trade.ready = formatReady(ready)
    if startTimer then
        trade.tick = getTickCount() + 10000
    else
        trade.tick = nil
    end
end
addEvent('reloadTrade', true)
addEventHandler('reloadTrade', resourceRoot, reloadTrade)

function toggleTrade(state, tradeItems, yourItems, ready, nick)
    if state then
        if (isEventHandlerAdded('onClientRender', root, drawTrade)) then return end
        trade.textures = {}
        trade.fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
            [2] = exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom),
            [3] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
            [4] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
            [5] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
        }
        for i,v in ipairs({'acceptButton', 'addButton', 'addEditbox', 'background', 'background2', 'background3', 'close', 'searchEditbox', 'bar', 'bar2'}) do
            if not trade.textures[v] then
                if not fileExists('files/images/'..v..'.png') then
                    outputDebugString('Failed to load interface texture: '..v..'.png')
                    return
                end
                trade.textures[v] = dxCreateTexture('files/images/'..v..'.png')
            end
        end
        trade.tradeItems = formatTradeItems(tradeItems)
        trade.yourItems = formatYourItems(yourItems)
        trade.ready = formatReady(ready)
        trade.selected = 1
        trade.scroll1 = 1
        trade.scroll2 = 1
        trade.scroll3 = 1
        trade.editbox = {}
        trade.nick = nick
        addEventHandler('onClientRender', root, drawTrade)
        addEventHandler('onClientClick', root, clickTrade)
        bindKey('mouse_wheel_down', 'down', scrollDown)
        bindKey('mouse_wheel_up', 'down', scrollUp)
        trade.editbox[1] = exports['since-gui']:createEditbox('Wprowadź ID lub Nazwę', sx/2+138/zoom, sy/2-24/zoom, 240/zoom, 28/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 10/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = trade.textures.searchEditbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
        local y = sy/2+50/zoom
        trade.editbox[2] = exports['since-gui']:createEditbox('Ilość ($)...', sx/2+138/zoom, y+5/zoom, 164/zoom, 28/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 10/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = trade.textures.addEditbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
        y = y + 60/zoom
        trade.editbox[3] = exports['since-gui']:createEditbox('Ilość (wPLN)...', sx/2+138/zoom, y+5/zoom, 164/zoom, 28/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 10/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = trade.textures.addEditbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
        y = y + 60/zoom
        trade.editbox[4] = exports['since-gui']:createEditbox('Ilość (PP)...', sx/2+138/zoom, y+5/zoom, 164/zoom, 28/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 10/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = trade.textures.addEditbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
        showCursor(true)
    else
        if (not isEventHandlerAdded('onClientRender', root, drawTrade)) then return end
        removeEventHandler('onClientRender', root, drawTrade)
        removeEventHandler('onClientClick', root, clickTrade)
        unbindKey('mouse_wheel_down', 'down', scrollDown)
        unbindKey('mouse_wheel_up', 'down', scrollUp)
        showCursor(false)
        for i,v in pairs(trade.textures) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        for i,v in pairs(trade.editbox) do
            if v then
                exports['since-gui']:destroyUIElement(v)
            end
        end
        trade = {}
    end
end

addEvent('startTrade', true)
addEventHandler('startTrade', resourceRoot, function(items, playerItems, ready, nick)
    toggleTrade(true, items, playerItems, ready, nick)
end)

addEvent('breakTrade', true)
addEventHandler('breakTrade', resourceRoot, function()
    toggleTrade(false)
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if trade.editbox then
        for i,v in pairs(trade.editbox) do
            if v then
                exports['since-gui']:destroyUIElement(v)
            end
        end
    end
end)

function scrollDown()
    if isMouseInPosition(sx/2-375/zoom, sy/2-219/zoom, 466/zoom, 140/zoom) then
        trade.scroll1 = math.min(#trade.tradeItems[1] - 3, trade.scroll1 + 1)
    elseif isMouseInPosition(sx/2-375/zoom, sy/2-38/zoom, 466/zoom, 140/zoom) then
        trade.scroll2 = math.min(#trade.tradeItems[2] - 3, trade.scroll2 + 1)
    elseif isMouseInPosition(sx/2+126/zoom, sy/2-271/zoom, 265/zoom, 542/zoom) then
        trade.scroll3 = math.min(#trade.yourItems[trade.selected] - 3, trade.scroll3 + 1)
    end
end

function scrollUp()
    if isMouseInPosition(sx/2-375/zoom, sy/2-219/zoom, 466/zoom, 140/zoom) then
        trade.scroll1 = math.max(1, trade.scroll1 - 1)
    elseif isMouseInPosition(sx/2-375/zoom, sy/2-38/zoom, 466/zoom, 140/zoom) then
        trade.scroll2 = math.max(1, trade.scroll2 - 1)
    elseif isMouseInPosition(sx/2+126/zoom, sy/2-271/zoom, 265/zoom, 542/zoom) then
        trade.scroll3 = math.max(1, trade.scroll3 - 1)
    end
end