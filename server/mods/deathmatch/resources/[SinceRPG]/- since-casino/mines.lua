local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local zoom = zoom * 0.8
local cache = {
    mines = {},
    multiplier = 1,
}
local mines = {1,2,3,4,5,6,7,8,9,10}
local stakes = {10000, 50000, 100000, 500000, 1000000, 5000000, 10000000}
local selectedStake = false
local selectedMines = false
local minesBlocked = false

function getMinesButtonPosition()
    local w = 0
    for i, v in ipairs(stakes) do
        w = w + 105/zoom
    end
    return {sx/2 - w/2, sy/2 + 210/zoom, w, 30/zoom}
end

function renderMines(alpha)
    local a = alpha/255
    local buttonW = 0

    dxDrawText("Ilość min", sx/2, sy/2 + 90/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), "center", "center", false, false, false, false, false)

    local offset = -((#mines-1)*100/zoom+(#mines-1)*5/zoom)/2-(100/zoom)/2
    for i, v in ipairs(mines) do
        local isIn = isMouseIn(sx/2 + offset, sy/2 + 105/zoom, 100/zoom, 30/zoom) or selectedMines == i
        dxDrawRoundedRectangle(sx/2 + offset, sy/2 + 105/zoom, 100/zoom, 30/zoom, 11/zoom, tocolor(46, 117, 111, alpha*((isIn and 155 or 100)/255)), false, false)
        dxDrawText('x'..v, sx/2 + offset + 50/zoom, sy/2 + 120/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "center", "center", false, false, false, false, false)
        
        offset = (offset + 105/zoom)
    end
    dxDrawText("Kwota", sx/2, sy/2 + 150/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), "center", "center", false, false, false, false, false)

    local offset = -((#stakes-1)*100/zoom+(#stakes-1)*5/zoom)/2-(100/zoom)/2

    for i, v in ipairs(stakes) do
        local isIn = isMouseIn(sx/2 + offset, sy/2 + 165/zoom, 100/zoom, 30/zoom) or selectedStake == i
        dxDrawRoundedRectangle(sx/2 + offset, sy/2 + 165/zoom, 100/zoom, 30/zoom, 11/zoom, tocolor(46, 117, 111, alpha*((isIn and 155 or 100)/255)), false, false)
        dxDrawText(convertNumberToString(v), sx/2 + offset + 50/zoom, sy/2 + 180/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "center", "center", false, false, false, false, false)
        
        offset = (offset + 105/zoom)
        buttonW = buttonW + 105/zoom
    end

    local isIn = isMouseIn(sx/2 - buttonW/2, sy/2 + 210/zoom, buttonW, 30/zoom)
    dxDrawRoundedRectangle(sx/2 - buttonW/2, sy/2 + 210/zoom, buttonW, 30/zoom, 11/zoom, tocolor(46, 117, 111, alpha*((isIn and 155 or 100)/255)), false, false)
    dxDrawText(minesWorking and "Kliknij aby wypłacić" or "Kliknij aby rozpocząć", sx/2, sy/2 + 225/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), "center", "center", false, false, false, false, false)

    local zetony = getElementData(localPlayer, "client:coin")
    local textWidth = dxGetTextWidth(kropki(zetony), 1, fonts[1])
    dxDrawImage(sx/2-18/zoom-textWidth/2, sy/2 + 260/zoom, 28/zoom, 28/zoom, textures[23], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText(kropki(zetony), sx/2+14/zoom-textWidth/2, sy/2 + 274/zoom, left, center, tocolor(255, 255, 255, alpha), 1, fonts[1], "left", "center", false, false, false, false)

    dxDrawRoundedRectangle(sx/2 - 532/zoom, sy/2 - 342/zoom, 1064/zoom, 414/zoom, 16/zoom, tocolor(46, 117, 111, a*25), false, false)
    dxDrawRoundedRectangle(sx/2 - 530/zoom, sy/2 - 340/zoom, 1060/zoom, 410/zoom, 15/zoom, tocolor(25, 36, 38, a*255), false, false)

    if minesWorking then
        for i = 1, 24 do
            if not cache.mines[i] then return end
            local x = 0
            local y = 0
            if i <= 8 then
                x = i
                y = 1
            elseif i <= 16 then
                x = i - 8
                y = 2
            else
                x = i - 16
                y = 3
            end

            local posX = sx/2 - 519/zoom + (x - 1) * 130/zoom
            local posY = sy/2 - 330/zoom + (y - 1) * 130/zoom

            local isIn = isMouseIn(posX, posY, 128/zoom, 128/zoom)

            if alpha > 254 then
                if cache.mines[i].state == 'bomb' then
                    dxDrawImage(posX, posY, 128/zoom, 128/zoom, mineTextures.rectangle, 0, 0, 0, tocolor(46, 117, 111, 155*a))
                    dxDrawImage(posX + 32/zoom, posY + 32/zoom, 64/zoom, 64/zoom, mineTextures.bomb)
                else
                    dxDrawImage(posX, posY, 128/zoom, 128/zoom, mineTextures.rectangle, 0, 0, 0, tocolor(125, 215, 255, 155*a))
                    dxDrawImage(posX + 32/zoom, posY + 32/zoom, 64/zoom, 64/zoom, mineTextures.diamond)
                end
            end

            if not cache.mines[i].showing then
                dxDrawImage(posX, posY, 128/zoom, 128/zoom, mineTextures.rectangle, 0, 0, 0, isIn and tocolor(85, 85, 85, alpha) or tocolor(65, 65, 65, alpha))
            end
        end
    end
end

local clickTick = getTickCount()
function minesClick()
    if clickTick > getTickCount() then return end
    clickTick = getTickCount() + 250
    if minesBlocked then return end
    if minesWorking then
        if isMouseIn(unpack(getMinesButtonPosition())) then
            minesBlocked = true
            triggerServerEvent('withdrawMines', resourceRoot, stakes[selectedStake], cache.multiplier)
            exports['since-notifications']:sendNotification('success', 'Wygrana została wypłacona. Otrzymujesz '..stakes[selectedStake]*cache.multiplier..' żetonów')
            return
        end

        for i = 1, 24 do
            if not cache.mines[i] then return end
            local x = 0
            local y = 0
            if i <= 8 then
                x = i
                y = 1
            elseif i <= 16 then
                x = i - 8
                y = 2
            else
                x = i - 16
                y = 3
            end

            local posX = sx/2 - 519/zoom + (x - 1) * 130/zoom
            local posY = sy/2 - 330/zoom + (y - 1) * 130/zoom

            if isMouseIn(posX, posY, 128/zoom, 128/zoom) and not cache.mines[i].showing then
                cache.mines[i].showing = true
                cache.multiplier = cache.multiplier + 0.005 * mines[selectedMines]
                if cache.mines[i].state == 'bomb' then
                    exports['since-notifications']:sendNotification('error', 'Nie udało ci się wygrać')
                    minesWorking = false
                    minesBlocked = false
                    cache.mines = {}
                    cache.multiplier = 1
                else
                    exports['since-notifications']:sendNotification('success', 'Mnoznik zwiekszony: x'..cache.multiplier..'')
                end
            end
        end
    else
        local offset = -((#mines-1)*100/zoom+(#mines-1)*5/zoom)/2-(100/zoom)/2
        for i, v in ipairs(mines) do
            if isMouseIn(sx/2 + offset, sy/2 + 105/zoom, 100/zoom, 30/zoom) then
                selectedMines = i
                return
            end
            offset = (offset + 105/zoom)
        end

        local offset = -((#stakes-1)*100/zoom+(#stakes-1)*5/zoom)/2-(100/zoom)/2
        for i, v in ipairs(stakes) do
            if isMouseIn(sx/2 + offset, sy/2 + 165/zoom, 100/zoom, 30/zoom) then
                selectedStake = i
                return
            end
            offset = (offset + 105/zoom)
        end

        if isMouseIn(unpack(getMinesButtonPosition())) then

            if not selectedMines or not selectedStake then
                exports['since-notifications']:sendNotification('error', 'Wybierz ilość min oraz kwotę')
                return
            end

            if getElementData(localPlayer, "client:coin") < stakes[selectedStake] then
                exports['since-notifications']:sendNotification('error', 'Nie posiadasz wystarczającej ilości żetonów')
                return
            end

            triggerServerEvent('betMines', resourceRoot, stakes[selectedStake], mines[selectedMines])
        end
    end
end

function startMines(bombs, tralala)
    if tralala ~= true then
        for i = 1, 24 do
            cache.mines[i] = {state = 'clear', showing = false}
        end
    end
    
    minesWorking = true

    for i = 1, bombs do 
        local randomBomb = math.random(1, 24)
        if cache.mines[randomBomb].state == 'bomb' then
            startMines(1, true)
        else
            cache.mines[randomBomb].state = 'bomb' 
        end
    end 
end

addEvent('onMinesStart', true)
addEventHandler('onMinesStart', resourceRoot, function(mines)
    startMines(mines)
end)

addEvent('onMinesStop', true)
addEventHandler('onMinesStop', resourceRoot, function()
    minesWorking = false
    cache.mines = {}
    cache.multiplier = 1
    minesBlocked = false
end)

function createMines()
    mineTextures = {
        bomb = dxCreateTexture("files/mines/bomb.png"),
        diamond = dxCreateTexture("files/mines/diamond.png"),
        rectangle = dxCreateTexture("files/mines/rectangle.png"),
    }
    selectedStake = false
    selectedMines = false
    minesWorking = false
    minesBlocked = false
end

function destroyMines()
    if mineTextures then
        for i,v in pairs(mineTextures) do
            if isElement(v) then
                destroyElement(v)
            end
        end
    end
end
addEventHandler("onClientResourceStop", resourceRoot, destroyMines)