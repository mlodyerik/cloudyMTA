local data = {

    progress = 0,
    updateProgress = 0,
    wrongTry = 0,
    time = 3000,
    timeTick = getTickCount(),
    page2Tick = getTickCount(),
    page2TimeLeft = 60000 * 2,
    randomLetter = math.random(1, 9),
    letterString = '',
    click = false,
    tick = getTickCount(),
    actualPage = 1,
    moneyPositions = {},
    taking = false,
    takingMoney = {

        id = 0,
        x = 0,
        y = 0,

    }


}

local moneyPosition = {

    {x = 326, y = 352},
    {x = 38, y = 213},
    {x = 384, y = 45},
    {x = 352, y = 15},
    {x = 413, y = 33},
    {x = 405, y = 342},
    {x = 370, y = 330},
    {x = 63, y = 282},
    {x = 68, y = 208},
    {x = 411, y = 132},
    {x = 345, y = 388},
    {x = 120, y = 418},
    {x = 103, y = 69},
    {x = 253, y = 28},
    {x = 137, y = 46},
    {x = 167, y = 44},
    {x = 8, y = 334},
    {x = 7, y = 3},
    {x = 12, y = 42},
    {x = 70, y = 110},
    {x = 356, y = 120},
    {x = 388, y = 202},
    {x = 102, y = 303},
    {x = 97, y = 277},
    {x = 61, y = 334},
    {x = 24, y = 260},
    {x = 46, y = 37},
    {x = 286, y = 14},
    {x = 79, y = 123},
    {x = 55, y = 210},
    {x = 90, y = 26},
    {x = 329, y = 122},

}

function makeLastLetterGreen(string)
    local string = string
    local lastLetter = string:sub(-1)
    local newString = string:sub(1, -2)

    return newString..'#2E756F'..lastLetter..'#ffffff'
end

function generateRandomLetter()
    data.randomLetter = math.random(1, 9)
    data.letterString = (data.letterString..data.randomLetter):gsub('#%x%x%x%x%x%x', '')
    data.letterString = makeLastLetterGreen(data.letterString)
end

function isMouseInCircle(x, y, radius)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy

        if (cursorX - x) ^ 2 + (cursorY - y) ^ 2 <= radius ^ 2 then
            return true
        end
    end

    return false
end

function convertTime(ms)
    local minutes = math.floor(ms / 60000)
    local seconds = math.floor((ms % 60000) / 1000)

    return string.format('%02d min. %02d sek.', minutes, seconds)
end

function renderUI()
	dxDrawImage(sx/2 - 256/zoom, sy/2 - 202/zoom, 512/zoom, 512/zoom, 'data/background.png')

    if data.actualPage == 1 then
        dxDrawText(math.floor(data.progress)..'%', sx/2, sy/2 + 270/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')

        dxDrawImage(sx/2 - 173/zoom, sy/2 + 291/zoom, 346/zoom, 6/zoom, 'data/progress.png', 0, 0, 0, tocolor(255, 255, 255, 100))
        dxDrawImageSection(sx/2 - 173/zoom, sy/2 + 291/zoom, 346/zoom * data.progress / 100, 6/zoom, 0, 0, 346 * data.progress / 100, 6, 'data/progress.png', 0, 0, 0, tocolor(46, 117, 111, 255))
        
        dxDrawText('Okradanie bankomatu', sx/2, sy/2 - 169/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
        dxDrawText('Wprowadź poprawną kombinacje znaków', sx/2 - 1/zoom, sy/2 - 171/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
        
        dxDrawText('Ciąg znaków: '..data.letterString, sx/2, sy/2 - 125/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'bottom', false, false, false, true)

        if data.updateProgress ~= data.progress then
            if data.updateProgress > data.progress then
                data.progress = math.min(data.progress + 0.5, data.updateProgress)
            else
                data.progress = math.max(data.progress - 0.5, data.updateProgress)
            end
        end
        
        if data.progress >= 100 then
            data.actualPage = 2
            data.page2Tick = getTickCount()
        end
        
        local timeProgress = data.time - (getTickCount() - data.timeTick)
        dxDrawRectangle(sx/2 - 173/zoom, sy/2 + 221/zoom, 346/zoom, 3/zoom, tocolor(46, 117, 111, 100))
        dxDrawRectangle(sx/2 - 173/zoom, sy/2 + 221/zoom, 346/zoom * timeProgress / data.time, 3/zoom, tocolor(46, 117, 111, 255))

        dxDrawText('Błędne próby: #ff5c5c'..data.wrongTry..'/3', sx/2, sy/2 + 230/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top', false, false, false, true)

        if data.timeTick + data.time < getTickCount() then
            data.timeTick = getTickCount()
            data.wrongTry = data.wrongTry + 1

            if data.updateProgress > 0 then
                data.updateProgress = data.updateProgress - 10
            end

            if data.wrongTry >= 4 then
                toggleUI(false)
                triggerServerEvent('bankRobbery:end', resourceRoot)
                return
            end

            generateRandomLetter()
        end

        local letter = 0
        for x = 1, 3 do
            for y = 1, 3 do
                letter = letter + 1

                local isIn = isMouseIn(sx/2 - 160/zoom + (x - 1) * 108/zoom, sy/2 - 112/zoom + (y - 1) * 108/zoom, 104/zoom, 104/zoom)
                dxDrawImage(sx/2 - 160/zoom + (x - 1) * 108/zoom, sy/2 - 112/zoom + (y - 1) * 108/zoom, 104/zoom, 104/zoom, 'data/letter_bg.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
                dxDrawText(letter, sx/2 - 160/zoom + (x - 1) * 108/zoom + 52/zoom, sy/2 - 112/zoom + (y - 1) * 108/zoom + 52/zoom, nil, nil, tocolor(255, 255, 255, isIn and 175 or 225), 1, exports['since-fonts']:getFont('Inter-Bold', 24/zoom), 'center', 'center')
            
                if isIn and not data.click and getKeyState('mouse1') then
                    data.click = true

                    if letter == data.randomLetter then
                        data.timeTick = getTickCount()
                        data.updateProgress = data.updateProgress + 10
                        generateRandomLetter()
                    else
                        data.timeTick = getTickCount()
                        data.wrongTry = data.wrongTry + 1

                        if data.wrongTry >= 4 then
                            toggleUI(false)
                            triggerServerEvent('bankRobbery:end', resourceRoot)
                            return
                        end

                        if data.updateProgress > 0 then
                            data.updateProgress = data.updateProgress - 10
                        end
                    end
                else
                    data.tick = getTickCount()
                end

                if not getKeyState('mouse1') then
                    data.click = false
                end
            end
        end
    elseif data.actualPage == 2 then
        local leftTime = data.page2TimeLeft - (getTickCount() - data.page2Tick)
        local time = convertTime(leftTime)

        dxDrawText('Okradanie bankomatu', sx/2, sy/2 - 169/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
        dxDrawText('Łamanie zabezpieczeń', sx/2 - 1/zoom, sy/2 - 171/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')

        dxDrawText('Trwa łamanie zabezpieczeń', sx/2, sy/2 + 25/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
        dxDrawText('Pozostały czas: '..time, sx/2, sy/2 + 25/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')

        dxDrawText('Uwaga!', sx/2, sy/2 + 115/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
        dxDrawText('Zaraz zjawią się tutaj gliny, musisz się szybko uwinąć!\nPamiętaj aby nie wychodzić z gry podczas okradania.', sx/2, sy/2 + 115/zoom, nil, nil, tocolor(145, 163, 160, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')

        dxDrawRectangle(sx/2 - 173/zoom, sy/2 + 60/zoom, 346/zoom, 3/zoom, tocolor(46, 117, 111, 100))
        dxDrawRectangle(sx/2 - 173/zoom, sy/2 + 60/zoom, 346/zoom * leftTime / data.page2TimeLeft, 3/zoom, tocolor(46, 117, 111, 255))

        if leftTime <= 0 then
            data.actualPage = 3
        end
    elseif data.actualPage == 3 then
        if #data.moneyPositions == 0 then
            for i = 1, 15 do
                local pos = moneyPosition[math.random(1, #moneyPosition)]
                table.insert(data.moneyPositions, {x = sx/2 - 256/zoom + pos.x, y = sy/2 - 150/zoom + pos.y})
            end
        end

        dxDrawText('Okradanie bankomatu', sx/2, sy/2 - 169/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
        dxDrawText('Przenieś gotówkę do torby', sx/2 - 1/zoom, sy/2 - 171/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
        
        dxDrawImage(sx/2 - 123/zoom, sy/2 - 50/zoom, 246/zoom, 246/zoom, 'data/money_bag.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(sx/2 - 80/zoom, sy/2 + 35/zoom, 160/zoom, 160/zoom, 'data/circle.png', 0, 0, 0, tocolor(255, 255, 255, 255))

        for i, money in ipairs(data.moneyPositions) do
            local isIn = isMouseIn(money.x/zoom, money.y/zoom, 42/zoom, 42/zoom)
            dxDrawImage(money.x/zoom, money.y/zoom, 42/zoom, 42/zoom, 'data/money.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))

            if data.takingMoney.id == i and getKeyState('mouse1') then
                local cursorX, cursorY = getCursorPosition()
                cursorX, cursorY = cursorX * sx, cursorY * sy

                data.moneyPositions[i].x = cursorX - 52/zoom
                data.moneyPositions[i].y = cursorY - 42/zoom
            end

            if isIn then
                if getKeyState('mouse1') then
                    if data.takingMoney.id ~= i and data.taking ~= true then
                        data.taking = true
                        data.takingMoney.id = i
                        data.takingMoney.x = money.x
                        data.takingMoney.y = money.y
                    end
                else
                    if isMouseInCircle(sx/2, sy/2 + 115/zoom, 62/zoom) and data.takingMoney.id == i then

                        if (#data.moneyPositions - 1) <= 0 then
                            toggleUI(false)
                            triggerServerEvent('bankRobbery:end', resourceRoot, true)
                        end

                        table.remove(data.moneyPositions, i)
                    end

                    data.taking = false
                    data.takingMoney.id = 0
                end
            end
        end
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    if visible then
        triggerServerEvent('bankRobbery:start', resourceRoot)
    end

    data = {

        progress = 0,
        updateProgress = 0,
        wrongTry = 0,
        time = 3000,
        timeTick = getTickCount(),
        randomLetter = math.random(1, 9),
        letterString = '',
        click = false,
        tick = getTickCount(),
        page2Tick = getTickCount(),
        page2TimeLeft = 60000 * 2,
        actualPage = 1,
        moneyPositions = {},
        taking = false,
        takingMoney = {
    
            id = 0,
            x = 0,
            y = 0,
    
        }
    
    
    }

    generateRandomLetter()

    showCursor(visible)
    eventCallback('onClientRender', root, renderUI)
end

function toggleState(toggled, element)
    if toggled then
        toggleUI(true)
    else
        toggleUI(false)
    end
end
addEvent('bankRobbery:toggleUI', true)
addEventHandler('bankRobbery:toggleUI', resourceRoot, toggleUI)