-- if getPlayerSerial(localPlayer) ~= 'C217ED9FE6899B85C066837D5D16A4D1' then
--     return
-- end

local gridlist = {}
local dt = 0

function createGridList(x, y, w, text, maxItems, items, postGui)
    local grid = {

        x = x,
        y = y,
        w = w,
        h = 0,

        text = text,
        items = items,

        rolled = false,
        rollPrg = 0,
        selectedItem = nil,
        
        postGui = postGui or false,

        scroll = {

            save = maxItems,
            min = maxItems + 1,
            maxItems = maxItems,
            offset = 1,
        }

    }

    gridlist[#gridlist + 1] = grid

    local id = #gridlist

    return id
end

function destroyGridList(id)
    local grid = gridlist[id]

    if grid then
        table.remove(gridlist, id)
    end
end

function addGridlistItem(id, item)
    local grid = gridlist[id]

    if grid then
        table.insert(grid.items, item)
    end
end

function getGridlistItems(id)
    local grid = gridlist[id]

    if grid then
        return grid.items
    end
end

function removeGridlistItem(id, item)
    local grid = gridlist[id]

    if grid then
        for i, v in ipairs(grid.items) do
            if v.name == item then
                table.remove(grid.items, i)
                break
            end
        end
    end
end

function getSelectedItem(id)
    local grid = gridlist[id]

    if grid then
        if grid.selectedItem and grid.selectedItem ~= '---' then
            return grid.selectedItem
        else
            return 'Brak'
        end
    else
        return 'Brak'
    end
end

function resetGridScroll(id)
    local grid = gridlist[id]

    if grid then
        grid.scroll.offset = 1
        grid.scroll.min = grid.scroll.save + 1
    end
end

function isCursorOnGridlist(id)
    local grid = gridlist[id]

    if grid then
        local bgHeight = math.min(#grid.items, grid.scroll.maxItems + 1) * 30/zoom + (grid.scroll.maxItems + 1)
        
        return isMouseIn(grid.x, grid.y, grid.w, 30/zoom) or isMouseIn(grid.x, grid.y + 30/zoom, grid.w, bgHeight)
    end
end

local arrowRotations = {}

function drawGridlist(id)
    local grid = gridlist[id]

    if not arrowRotations[id] then
        arrowRotations[id] = 0
    end

    if grid then
        if grid.rolled then
            grid.rollPrg = math.min(grid.rollPrg + 0.05, 1)
        else
            grid.rollPrg = math.max(grid.rollPrg - 0.05, 0)
        end

        local bgHeight = math.min(#grid.items, grid.scroll.maxItems + 2) * 30/zoom + (grid.scroll.maxItems + 1)
        dxDrawImage(grid.x, grid.y + 1, grid.w, bgHeight - 1, 'img/list.png', 0, 0, 0, tocolor(85, 85, 85, 175*grid.rollPrg), true)
        
        local offset = 0
        for i, v in ipairs(grid.items) do
            if i >= grid.scroll.offset and i <= grid.scroll.min then 
                local isIn = isMouseIn(grid.x, grid.y + 30/zoom + offset, grid.w - 3, 30/zoom)
                local textWidth = dxGetTextWidth(removeHex(v.name), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom))
                
                if isIn and string.len(removeHex(v.name)) > 20 then
                    dxDrawRectangle(grid.x, grid.y + 30/zoom + offset, textWidth + 16/zoom, 30/zoom, tocolor(35, 35, 35, isIn and 200*grid.rollPrg or 125*grid.rollPrg), true)
                    dxDrawText(v.name, grid.x + 10/zoom, grid.y + 45/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 200*grid.rollPrg or 155*grid.rollPrg), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "left", "center", false, false, true, true)
                else
                    dxDrawRectangle(grid.x, grid.y + 30/zoom + offset, grid.w - 3, 30/zoom, tocolor(35, 35, 35, isIn and 200*grid.rollPrg or 125*grid.rollPrg), true)
                    local name = 'Brak danych'

                    if string.len(removeHex(v.name)) > 20 then
                        name = string.sub(removeHex(v.name), 1, 20).."..."
                    else
                        name = v.name
                    end
    
                    if v.icon then
                        dxDrawImage(grid.x + 10/zoom, grid.y + 34/zoom + offset, 20/zoom, 20/zoom, v.icon, 0, 0, 0, tocolor(255, 255, 255, isIn and 200*grid.rollPrg or 155*grid.rollPrg), true)
                        dxDrawText(name, grid.x + 40/zoom, grid.y + 45/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 200*grid.rollPrg or 155*grid.rollPrg), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "left", "center", false, false, true, true)
                    else
                        dxDrawText(name, grid.x + 10/zoom, grid.y + 45/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 200*grid.rollPrg or 155*grid.rollPrg), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "left", "center", false, false, true, true)
                    end
                end
                
                offset = offset + 30/zoom + 1
            end
        end
        drawScrollbar(grid.items, grid.x + grid.w - 3, grid.y + 30/zoom, 3, bgHeight - 30/zoom, grid.scroll.maxItems + 1, grid.scroll.offset, 155*grid.rollPrg)
        
        local isIn = isMouseIn(grid.x, grid.y, grid.w, 30/zoom)
        dxDrawImage(grid.x, grid.y, grid.w, 30/zoom, 'img/background.png', 0, 0, 0, tocolor(35, 35, 35, isIn and 245 or 200), true)
        
        if not grid.selectedItem or grid.selectedItem == '---' then
            dxDrawText(grid.text, grid.x + 10/zoom, grid.y + 15/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), "left", "center", false, false, true, true)
        else
            if string.len(removeHex(grid.selectedItem)) > 20 then
                dxDrawText(string.sub(removeHex(grid.selectedItem), 1, 20).."...", grid.x + 10/zoom, grid.y + 15/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), "left", "center", false, false, true, true)
            else
                dxDrawText(grid.selectedItem, grid.x + 10/zoom, grid.y + 15/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), "left", "center", false, false, true, true)
            end    
        end
        
        local isIn = isMouseIn(grid.x + grid.w - 24/zoom, grid.y, 24/zoom, 30/zoom)
        
        if grid.rolled then
            arrowRotations[id] = math.min(arrowRotations[id] + 5, 90)
        else
            arrowRotations[id] = math.max(arrowRotations[id] - 5, 0)
        end

        dxDrawImage(grid.x + grid.w - 24/zoom, grid.y + 4/zoom, 22/zoom, 22/zoom, "img/arrow.png", -arrowRotations[id], 0, 0, tocolor(255, 255, 255, isIn and 200 or 155), true)
    end
end

addEventHandler('onClientClick', root, function(btn, state)
    if #gridlist < 0 then
        return
    end

    if btn == 'left' and state == 'down' then
        for i, v in ipairs(gridlist) do
            local grid = gridlist[i]

            if grid then
                if not isCursorOnGridlist(i) then
                    grid.rolled = false
                end

                if isMouseIn(grid.x, grid.y, grid.w, 30/zoom) then
                    grid.rolled = not grid.rolled

                    if grid.rolled == true then
                        resetGridScroll(i)
                    end
                end

                if grid.rolled then
                    local offset = 0
                    for i, v in ipairs(grid.items) do
                        if i >= grid.scroll.offset and i <= grid.scroll.min then 
                            if isMouseIn(grid.x, grid.y + 30/zoom + offset, grid.w - 3, 30/zoom) then
                                grid.selectedItem = v.name
                                grid.rolled = false
                            end

                            offset = offset + 30/zoom + 1
                        end
                    end
                end
            end
        end
    end
end)

bindKey('mouse_wheel_up', 'down', function()
    if #gridlist < 0 then
        return
    end

    for i, v in ipairs(gridlist) do
        local grid = gridlist[i]

        if grid and isCursorOnGridlist(i) then
            if grid.scroll.offset > 1 then
                grid.scroll.offset = grid.scroll.offset - 1
                grid.scroll.min = grid.scroll.min - 1

            end
        end
    end
end)

bindKey('mouse_wheel_down', 'down', function()
    if #gridlist < 0 then
        return
    end

    for i, v in ipairs(gridlist) do
        local grid = gridlist[i]

        if grid and isCursorOnGridlist(i) then
            if grid.scroll.min < #grid.items then
                grid.scroll.offset = grid.scroll.offset + 1
                grid.scroll.min = grid.scroll.min + 1
            end
        end
    end
end)

addEventHandler('onClientPreRender', root, function(dt)
    delta = dt
end)

addEventHandler("onClientRender", root, function()
    if #gridlist > 0 then
        for i, v in ipairs(gridlist) do
            drawGridlist(i)
        end
    end
end)