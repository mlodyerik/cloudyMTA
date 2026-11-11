local maskQ = dxCreateTexture('data/quick-mask.png')

function renderQuickInventory()
    if not getElementData(localPlayer, 'player:quickEQ') then
        return
    end

    if getElementData(localPlayer, 'player:hudof') then
        return
    end

    if not getElementData(localPlayer, 'player:spawn') then return end

    local w = 6 * 70/zoom + 5 * 5/zoom
    exports['since-blur']:dxDrawBlur(sx/2 - w/2 - 5/zoom, sy - 105/zoom, w + 10/zoom, 80/zoom, maskQ, 255)
    dxDrawImage(sx/2 - w/2 - 5/zoom, sy - 105/zoom, w + 10/zoom, 80/zoom, 'data/quick-background.png', 0, 0, 0, tocolor(255, 255, 255, 155))
    
    for i = 1, 6 do
        local x = sx/2 - w/2 + (i - 1) * 70/zoom + (i - 1) * 5/zoom
        local y = sy - 100/zoom
        local w = 70/zoom
        local h = 70/zoom

        local over = isInventoryVisible()
        dxDrawImage(x, y, w, h, 'data/quick-item.png', 0, 0, 0, tocolor(255, 255, 255, over and 255 or 155))
        
        local item = getItemOnQuickSlot(i)
        if item then
            local itemData = getItemInfo(item.name)
            if itemData then
                local classColor = tocolor(unpack(classes[itemData.class].color))
                dxDrawImage(x, y, w, h, 'data/item_shadow.png', 0, 0, 0, classColor)
                dxDrawImage(x + 5/zoom, y + 5/zoom, 50/zoom + 10/zoom, 50/zoom + 10/zoom, 'data/' .. itemData.icon .. '.png')

                if itemData.icon == 'ak47' or itemData.icon == 'awm' or itemData.icon == 'deagle' or itemData.icon == 'mp5' or itemData.icon == 'M4' or itemData.icon == 'shotgun' or itemData.icon == 'wedka' then
                    
                else
                    dxDrawText('x'..item.amount, x + w - 5/zoom, y + h - 5/zoom, nil, nil, tocolor(255, 255, 255, 155), 0.9, regular3, 'right', 'bottom')
                end

                if item.progress then
                    dxDrawImage(x + w*0.1, y + h * 1.1, w * 0.8, h * 0.1, 'data/level_progress.png',0,0,0,tocolor(71,71,71,150))
                    dxDrawImageSection(x + w*0.1, y + h * 1.1, w * 0.8*item.progress/100, h * 0.1, 0, 0, 122*item.progress/100, 8, 'data/level_progress.png',0,0,0,classColor)
                end
            end
        end

        if isInventoryVisible() then
            dxDrawText(i, x + 5/zoom, y + 5/zoom, nil, nil, tocolor(255, 255, 255, 70), 1, regular3, 'left', 'top')
        end
    end

    if isInventoryVisible() then
        dxDrawText('Najedź myszka na item oraz nacisnij przycisk 1-6 aby dodac go do szybkiego wyboru', sx/2 + 1, sy - 125/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'center', 'bottom')
        dxDrawText('Najedź myszka na item oraz nacisnij przycisk 1-6 aby dodac go do szybkiego wyboru', sx/2, sy - 125/zoom, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'center', 'bottom')
    end
end

function getItemOnQuickSlot(id)
    local items = getPlayerInventory()
    for k,v in pairs(items) do
        if v.quickslot == id then
            return {
                id = k,
                name = v.name,
                amount = v.amount,
                token = v.token,
                progress = v.progress,
            }
        end
    end
end

local lastClick = getTickCount()
function useQuickSlot(id)
    if not getElementData(localPlayer, 'player:quickEQ') then
        return
    end

    if getElementData(localPlayer, 'player:hudof') then
        return
    end

    if isInventoryVisible() or getElementData(localPlayer, 'trade') then return end
    id = tonumber(id)

    local item = getItemOnQuickSlot(id)
    if not item then return end

    if (lastClick > getTickCount()) then
        return false
    end
    lastClick = getTickCount() + 250

    useItem(item)
end

for i = 1, 6 do
    bindKey(tostring(i), 'down', useQuickSlot)
end

addEventHandler("onClientRender", root, renderQuickInventory)
getResourceName(getThisResource(), true, 594245743); if true then return end