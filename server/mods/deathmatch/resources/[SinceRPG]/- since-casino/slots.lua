local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local zoom = zoom * 0.8
local cache = {}

local slotSymbols = {"cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond","cherry", "blueberry", "watermelon", "diamond"}
local stakes = {10000, 50000, 100000, 500000, 1000000, 5000000, 10000000}
local spinResults = {}
local spinStartTime = 0
local spinDuration = 1500
local refreshRate = 1000 / 60
local selectedStake = false
local spinBet = false
local blockingTick = getTickCount()
local blockClicking = false
spinning = false

function convertNumberToString(number)
    local formattedNumber = number

    if number >= 10000 then
        local suffixes = {"", "k", "kk", 'kkk'}
        local suffixIndex = 1

        while number >= 1000 do
            number = number / 1000
            suffixIndex = suffixIndex + 1
        end

        formattedNumber = string.format("%d", number) .. suffixes[suffixIndex]
    else
        formattedNumber = string.format("%d", number)
    end

    return formattedNumber
end

function startSpin()
    if spinning or blockClicking then
        return
    end

    if not selectedStake then exports['since-notifications']:sendNotification('error', 'Nie wybrałeś kwoty betu') return end

    if blockingTick > getTickCount() then return end

    blockingTick = getTickCount() + 500
    blockClicking = true

    triggerServerEvent('betSlots', resourceRoot, stakes[selectedStake])
end

addEvent('spinSlots', true)
addEventHandler('spinSlots', resourceRoot, function()
    spinBet = stakes[selectedStake]
    spinResults = spinSlotMachine()
    spinning = true
    spinStartTime = getTickCount()
    animationSymbols = {}
    for j = 1, 3 do
        animationSymbols[j] = shuffleSymbols(slotSymbols)
    end
end)

function getSlotsStartButtonPosition()
    local buttonW = 0
    for i, v in ipairs(stakes) do
        buttonW = buttonW + 105/zoom
    end
    return {sx/2 - buttonW/2, sy/2 + 370/zoom, buttonW, 30/zoom}
end

function renderSlotMachine(alpha)
    local offset = -((#stakes-1)*100/zoom+(#stakes-1)*5/zoom)/2-(100/zoom)/2
    local buttonW = 0

    for i, v in ipairs(stakes) do
        local isIn = isMouseIn(sx/2 + offset, sy/2 + 325/zoom, 100/zoom, 30/zoom) or selectedStake == i
        dxDrawRoundedRectangle(sx/2 + offset, sy/2 + 325/zoom, 100/zoom, 30/zoom, 11/zoom, tocolor(125, 255, 125, alpha*((isIn and 155 or 100)/255)), false, false)
        dxDrawText(convertNumberToString(v), sx/2 + offset + 50/zoom, sy/2 + 340/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "center", "center", false, false, false, false, false)
        
        offset = (offset + 105/zoom)
        buttonW = buttonW + 105/zoom
    end

    local isIn = isMouseIn(sx/2 - buttonW/2, sy/2 + 370/zoom, buttonW, 30/zoom)
    dxDrawRoundedRectangle(sx/2 - buttonW/2, sy/2 + 370/zoom, buttonW, 30/zoom, 11/zoom, tocolor(125, 255, 125, alpha*((isIn and 155 or 100)/255)), false, false)
    dxDrawText("Kliknij aby zakręcić za wybraną kwotę", sx/2, sy/2 + 385/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), "center", "center", false, false, false, false, false)

    dxSetRenderTarget(renderTarget, true)
        if spinning then
            local elapsedTime = getTickCount() - spinStartTime
            local progress = elapsedTime / spinDuration
            if progress >= 1 then

                local won, reward = checkReward(animationSymbols)
                
                if won then
                    local money = (spinBet*reward)
                    triggerServerEvent('winSlots', resourceRoot, money)
                    exports['since-notifications']:sendNotification('success', 'Wygrałeś! Otrzymujesz '..kropki(money)..' żetonów')
                else
                    exports['since-notifications']:sendNotification('info', 'Nie udało ci się wygrać')
                end

                blockingTick = getTickCount() + 500
                spinning = false
                spinBet = false
                spinResults = {}
                progress = 1
                blockClicking = false

            end
            drawSlotsWithAnimation(animationSymbols, progress)
        else
            drawSlotsWithAnimation(animationSymbols, 1)
        end
    dxSetRenderTarget()

    dxDrawRoundedRectangle(sx/2 - 322/zoom, sy/2 - 342/zoom, 644/zoom, 644/zoom, 16/zoom, tocolor(104, 214, 94, (alpha/255)*25), false, false)
    dxDrawRoundedRectangle(sx/2 - 320/zoom, sy/2 - 340/zoom, 640/zoom, 640/zoom, 15/zoom, tocolor(32, 32, 32, (alpha/255)*255), false, false)
    dxDrawImage(sx/2 - 300/zoom, sy/2 - 320/zoom, 600/zoom, 600/zoom, renderTarget, 0, 0, 0, tocolor(255, 255, 255, alpha))

    local zetony = getElementData(localPlayer, "client:coin")
    local textWidth = dxGetTextWidth(kropki(zetony), 1, fonts[1])
    dxDrawImage(sx/2-18/zoom-textWidth/2, sy/2 + 420/zoom, 28/zoom, 28/zoom, textures[23], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText(kropki(zetony), sx/2+14/zoom-textWidth/2, sy/2 + 434/zoom, left, center, tocolor(255, 255, 255, alpha), 1, fonts[1], "left", "center", false, false, false, false)
end

function slotsClick()
    if isMouseIn(unpack(getSlotsStartButtonPosition())) then
        startSpin()
    else
        local offset = -((#stakes-1)*100/zoom+(#stakes-1)*5/zoom)/2-(100/zoom)/2
        for i, v in ipairs(stakes) do
            if isMouseIn(sx/2 + offset, sy/2 + 325/zoom, 100/zoom, 30/zoom) then
                selectedStake = i
                break
            end
            offset = (offset + 105/zoom)
        end
    end
end

function drawSlots(results)
    for i = 1, 3 do
        for j = 1, 3 do
            local symbol = results[i][j].name
            dxDrawImage((j - 1) * 100, (i - 1) * 100, 100, 100, symbolTextures[symbol])
        end
    end
end

function drawSlotsWithAnimation(results, progress)
    local totalSlots = #slotSymbols
    local yOffset

    yOffset = easeOutQuad(progress, 0, 100 * totalSlots, 1)

    for j = 1, 3 do
        for i = 1, 3 do
            symbolIndex = (math.floor((i - 1 + yOffset / 100) % totalSlots) + 1)
            
            if animationSymbols[j] then
                symbol = animationSymbols[j][symbolIndex]
            end

            dxDrawImage((j - 1) * 108, (i - 1) * 100 - yOffset % 100, 75, 75, symbolTextures[symbol])
            
            local nextSymbolIndex = (symbolIndex % totalSlots) + 1
            local nextSymbol = animationSymbols[j][nextSymbolIndex]
            dxDrawImage((j - 1) * 108, (i - 1) * 100 + 100 - yOffset % 100, 75, 75, symbolTextures[nextSymbol])
        end
    end
end

function createSlots()
    symbolTextures = {
        cherry = dxCreateTexture("files/slots/cherry.png"),
        blueberry = dxCreateTexture("files/slots/blueberry.png"),
        watermelon = dxCreateTexture("files/slots/watermelon.png"),
        diamond = dxCreateTexture("files/slots/diamond.png"),
    }

    animationSymbols = {}

    selectedStake = nil
    spinBet = false
    spinResults = {}
    blockClicking = false
    spinning = false
    
    for j = 1, 3 do
        animationSymbols[j] = shuffleSymbols(slotSymbols)
    end
    
    renderTarget = dxCreateRenderTarget(300, 300, true)
end

function destroySlots()
    if symbolTextures then
        for _, texture in pairs(symbolTextures) do
            if isElement(texture) then
                destroyElement(texture)
            end
        end
    end

    if renderTarget and isElement(renderTarget) then
        destroyElement(renderTarget)
    end
end
addEventHandler("onClientResourceStop", resourceRoot, destroySlots)

cache.drops = {
    {name = 'cherry', chance = 50, multipler = 8},
    {name = 'blueberry', chance = 40, multipler = 12},
    {name = 'watermelon', chance = 10, multipler = 16},
    {name = 'diamond', chance = 10, multipler = 20},
}

function isMouseIn(posX, posY, sizeX, sizeY)
    local mx, my = getCursorPosition()
    mx, my = mx * sx, my * sy
    return mx >= posX and mx <= posX + sizeX and my >= posY and my <= posY + sizeY
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function getRandomSymbol()
    local totalChance = 0
    for _, drop in ipairs(cache.drops) do
        totalChance = totalChance + drop.chance
    end
    
    local randomChance = math.random(totalChance)
    local cumulativeChance = 0
    
    for _, drop in ipairs(cache.drops) do
        cumulativeChance = cumulativeChance + drop.chance
        if randomChance <= cumulativeChance then
            return drop
        end
    end
end

function spinSlotMachine()
    local results = {}
    for i = 1, 3 do
        results[i] = {}
        for j = 1, 3 do
            results[i][j] = getRandomSymbol()
        end
    end

    return results
end

function easeOutQuad(t, b, c, d)
    t = t / d
    return -c * t * (t - 2) + b
end

function getMultiplerByName(name)
    for _, drop in ipairs(cache.drops) do
        if drop.name == name then
            return drop.multipler
        end
    end
end

function checkReward(animationSymbols)
    local centerLine = {animationSymbols[1][2], animationSymbols[2][2], animationSymbols[3][2]}

    if centerLine[1] == centerLine[2] and centerLine[2] == centerLine[3] then
        local reward = getMultiplerByName(centerLine[1])
        return true, reward
    end
    
    return false, 0
end

function shuffleSymbols(symbols)
    local shuffled = {}
    local symbolIndices = {}
    for i = 1, #symbols do
        table.insert(symbolIndices, i)
    end
    while #symbolIndices > 0 do
        local randIndex = math.random(#symbolIndices)
        local symbol = symbols[symbolIndices[randIndex]]
        table.insert(shuffled, symbol)
        table.remove(symbolIndices, randIndex)
    end
    return shuffled
end
