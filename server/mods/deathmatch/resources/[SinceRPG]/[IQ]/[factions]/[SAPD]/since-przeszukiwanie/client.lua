local items = {}
local selectedPlayer = localPlayer
local scrollData = {k = 1, n = 6, m = 6}

function renderUI()
	dxDrawImage(sx/2 - 165/zoom, sy/2 - 174/zoom, 330/zoom, 349/zoom, 'data/bg.png')
	dxDrawText('Przeszukiwanie', sx/2, sy/2 - 150/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'center', 'bottom')
	dxDrawText('Przedmioty gracza '..getPlayerName(selectedPlayer), sx/2, sy/2 - 150/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 7/zoom), 'center', 'top')

    local offset =  0
    for i, v in ipairs(items) do
        if i >= scrollData.k and i <= scrollData.n then
            dxDrawImage(sx/2 - 153/zoom, sy/2 - 120/zoom + offset, 306/zoom, 40/zoom, 'data/itembg.png')

            dxDrawText(v.name, sx/2 - 143/zoom, sy/2 - 98/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8/zoom), 'left', 'bottom')
            dxDrawText('Przedmiot', sx/2 - 143/zoom, sy/2 - 98/zoom + offset, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 6.5/zoom), 'left', 'top')
    
            dxDrawText(v.amount..' szt.', sx/2 - 1/zoom, sy/2 - 98/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8/zoom), 'left', 'bottom')
            dxDrawText('Ilość', sx/2 - 1/zoom, sy/2 - 98/zoom + offset, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 6.5/zoom), 'left', 'top')
            
            local isIn = isMouseIn(sx/2 + 62/zoom, sy/2 - 110/zoom + offset, 83/zoom, 22/zoom)
            dxDrawImage(sx/2 + 62/zoom, sy/2 - 110/zoom + offset, 83/zoom, 22/zoom, 'data/button.png', 0, 0, 0, tocolor(67, 143, 135, isIn and 255 or 200))
            dxDrawText('Zarekwiruj', sx/2 + 103.5/zoom, sy/2 - 99/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7/zoom), 'center', 'center')
    
            offset = offset + 42/zoom
        end
    end

    drawScrollbar(items, sx/2 + 155/zoom, sy/2 - 120/zoom, 2/zoom, offset - 2/zoom, scrollData.m, scrollData.k, 255)

    local isIn = isMouseIn(sx/2 - (83/zoom)/2, sy/2 + 142/zoom, 83/zoom, 22/zoom)
    dxDrawImage(sx/2 - (83/zoom)/2, sy/2 + 142/zoom, 83/zoom, 22/zoom, 'data/button.png', 0, 0, 0, tocolor(255, 55, 55, isIn and 255 or 200))
    dxDrawText('Zamknij', sx/2, sy/2 + 153/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7/zoom), 'center', 'center')
end

function onClick(btn, state)
    if btn ~= 'left' or state ~= 'down' then return end

    if isMouseIn(sx/2 - (83/zoom)/2, sy/2 + 142/zoom, 83/zoom, 22/zoom) then
        toggleUI(false)
    end

    local offset = 0
    for i, v in ipairs(items) do
        if i >= scrollData.k and i <= scrollData.n then
            if isMouseIn(sx/2 + 62/zoom, sy/2 - 110/zoom + offset, 83/zoom, 22/zoom) then
                triggerServerEvent('player:takeItem', resourceRoot, selectedPlayer, v.name, v.amount, v.itemData)
                break
            end

            offset = offset + 42/zoom
        end
    end
end

addEvent('player:reloadItems', true)
addEventHandler('player:reloadItems', resourceRoot, function(player)
    items = {}
    scrollData = {k = 1, n = 6, m = 6}

    local inventory = getElementData(selectedPlayer, 'player:inventory') or {}

    for i, v in ipairs(inventory) do
        if v.class == 'illegal' or weaponNames[v.name] then
            local name = exports['since-inventory']:getItemInfo(v.name)
            table.insert(items, {name = name.name, amount = v.amount, itemData = v})
        end
    end
end)

bindKey("mouse_wheel_down", "both", function()
    if isEventHandlerAdded('onClientRender', root, renderUI) then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if isEventHandlerAdded('onClientRender', root, renderUI) then
        scrollDown()
    end
end)

function scrollDown()
    if scrollData.n == scrollData.m then return end
    scrollData.k = scrollData.k - 1
    scrollData.n = scrollData.n - 1
end

function scrollUp()
    if scrollData.n >= #items then return end
    scrollData.k = scrollData.k + 1
    scrollData.n = scrollData.n + 1
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    showCursor(visible)
    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
end

addEvent('toggleUI', true)
addEventHandler('toggleUI', resourceRoot, function(player)
    scrollData = {k = 1, n = 6, m = 6}
    selectedPlayer = player
    
    local inventory = getElementData(selectedPlayer, 'player:inventory') or {}
    for i, v in ipairs(inventory) do
        if v.class == 'illegal' or weaponNames[v.name] then
            local name = exports['since-inventory']:getItemInfo(v.name)
            table.insert(items, {name = name.name, amount = v.amount, itemData = v})
        end
    end

    toggleUI(true)
end)

