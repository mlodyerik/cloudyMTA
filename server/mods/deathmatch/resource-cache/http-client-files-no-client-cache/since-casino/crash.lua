local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local crash = {}

function renderCrash(alpha)
    local a = alpha/255

    dxDrawImage(sx/2 - 928/zoom, 125/zoom, 28/zoom, 28/zoom, textures[23], 0, 0, 0, tocolor(255, 255, 255, alpha), false)
    dxDrawText(kropki(getElementData(localPlayer, "client:coin") or 0), sx/2 - 895/zoom, 139/zoom, left, center, tocolor(255, 255, 255, alpha), 1, fonts[1], "left", "center", false, false, false, false)

    dxDrawImage(sx/2-928/zoom, 166/zoom, 958/zoom, 588/zoom, textures[46], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImage(sx/2-918/zoom, 176/zoom, 938/zoom, 58/zoom, textures[60], 0, 0, 0, tocolor(255, 255, 255, alpha))

    local offset = 0
    for i=1,9 do
        local v = crash.lastCrashes[i]
        if v then
            dxDrawImage(sx/2-900/zoom+offset, 182/zoom, 46/zoom, 46/zoom, textures[54], 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawText(v..'x', sx/2-860/zoom+offset, 205/zoom, nil, nil, tocolor(135, 255, 124, alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "left", "center", false, false, false, false, false)
            if i < 9 then
                dxDrawRectangle(sx/2-900/zoom+offset + 98/zoom, 188/zoom, 1, 34/zoom, tocolor(104, 214, 94, 155*a))
            end
        end
        offset = offset + 100/zoom
    end
    
    dxDrawImage(sx/2-872/zoom, 284/zoom, 846/zoom, 421/zoom, textures[53], 0, 0, 0, tocolor(255, 255, 255, alpha))

    if crash.loaded then
        if crash.state then
            dxDrawImage(sx/2-872/zoom, 391/zoom, 827/zoom, 313/zoom, textures[42], 0, 0, 0, tocolor(255, 255, 255, alpha))
            if crash.stopped then
                dxDrawText('Crashed', sx/2-872/zoom, 270/zoom, sx/2-872/zoom + 827/zoom, 270/zoom+313/zoom, tocolor(104, 214, 94, alpha), 1, exports['since-fonts']:getFont('Inter-Black', 28/zoom), "center", "center", false, false, false, false, false)
                dxDrawText('@'..string.format('%.2f',crash.value)..'x', sx/2-872/zoom, 315/zoom, sx/2-872/zoom + 827/zoom, 315/zoom+313/zoom, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 24/zoom), "center", "center", false, false, false, false, false)        
            else
                dxDrawText('Aktualny mnożnik', sx/2-872/zoom, 270/zoom, sx/2-872/zoom + 827/zoom, 270/zoom+313/zoom, tocolor(104, 214, 94, alpha), 1, exports['since-fonts']:getFont('Inter-Black', 28/zoom), "center", "center", false, false, false, false, false)
                dxDrawText(string.format('%.2f',crash.value)..'x', sx/2-872/zoom, 315/zoom, sx/2-872/zoom + 827/zoom, 315/zoom+313/zoom, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 24/zoom), "center", "center", false, false, false, false, false)
            end
        else
            dxDrawText('Następne losowanie za', sx/2-872/zoom, 270/zoom, sx/2-872/zoom + 827/zoom, 270/zoom+313/zoom, tocolor(104, 214, 94, alpha), 1, exports['since-fonts']:getFont('Inter-Black', 28/zoom), "center", "center", false, false, false, false, false)
            dxDrawText(string.format("%.2f", math.max((crash.tick-getTickCount())/1000, 0))..'s', sx/2-872/zoom, 315/zoom, sx/2-872/zoom + 827/zoom, 315/zoom+313/zoom, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 24/zoom), "center", "center", false, false, false, false, false)
        end
    else
        dxDrawText('Ładowanie...', sx/2-872/zoom, 270/zoom, sx/2-872/zoom + 827/zoom, 270/zoom+313/zoom, tocolor(104, 214, 94, alpha), 1, exports['since-fonts']:getFont('Inter-Black', 28/zoom), "center", "center", false, false, false, false, false)
    end

    dxDrawImage(sx/2-928/zoom, 795/zoom, 958/zoom, 243/zoom, textures[47], 0, 0, 0, tocolor(255, 255, 255, alpha))

    local texts = {'1/2','x2','MAX'}
    local offset = 0
    for i=1,3 do
        local isIn = isMouseIn(sx/2-619/zoom + offset, 815/zoom, 44/zoom, 44/zoom)
        dxDrawImage(sx/2-619/zoom + offset, 815/zoom, 44/zoom, 44/zoom, textures[57], 0, 0, 0, tocolor(255, 255, 255, a * (isIn and 155 or 255)))
        dxDrawText(texts[i], sx/2-619/zoom + offset, 815/zoom, sx/2-619/zoom + offset + 44/zoom, 815/zoom + 44/zoom, tocolor(255, 255, 255, a * (isIn and 155 or 255)), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), "center", "center", false, false, false, false, false)
        offset = offset + 56/zoom
    end

    local isIn = isMouseIn(sx/2-189/zoom, 815/zoom, 172/zoom, 44/zoom)
    dxDrawImage(sx/2-189/zoom, 815/zoom, 172/zoom, 44/zoom, textures[43], 0, 0, 0, tocolor(255, 255, 255, a * (isIn and 155 or 255)))
    dxDrawText((crash.autoCashout and 'Wyłącz' or 'Włącz')..' auto cashout', sx/2-189/zoom, 815/zoom, sx/2-189/zoom + 172/zoom, 815/zoom + 44/zoom, tocolor(255, 255, 255, a * (isIn and 155 or 255)), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), "center", "center", false, false, false, false, false)

    dxDrawText('Stawiasz #68D65E$ '..kropki(crash.bet or 0), sx/2-648/zoom + (398/2)/zoom, 943/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), "center", "bottom", false, false, false, true, false)

    local isIn = isMouseIn(sx/2-648/zoom, 953/zoom, 398/zoom, 68/zoom)
    dxDrawImage(sx/2-648/zoom, 953/zoom, 398/zoom, 68/zoom, textures[51], 0, 0, 0, tocolor(255, 255, 255, (isIn and 155 or 255) * a))
    dxDrawText(crash.cashouted and 'Wypłaciłeś' or crash.state and crash.bet > 0 and 'Wypłać' or not crash.state and crash.bet > 0 and 'Postawiłeś już zakład' or 'Postaw zakład', sx/2-648/zoom, 953/zoom, sx/2-648/zoom + 398/zoom, 953/zoom+68/zoom, tocolor(255, 255, 255, (isIn and 155 or 255) * a), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), "center", "center", false, false, false, false, false)

    dxDrawImage(sx/2+50/zoom, 166/zoom, 860/zoom, 68/zoom, textures[48], 0, 0, 0, tocolor(255, 255, 255, alpha))
    
    dxDrawImage(sx/2+350/zoom, 180/zoom, 42/zoom, 36/zoom, textures[59], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Ostatnie wygrane', sx/2+405/zoom, 198/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 19/zoom), "left", "center", false, false, false, false, false)

    dxDrawImage(sx/2+50/zoom, 255/zoom, 860/zoom, 783/zoom, textures[49], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImage(sx/2+50/zoom, 255/zoom, 860/zoom, 60/zoom, textures[50], 0, 0, 0, tocolor(255, 255, 255, alpha))

    dxDrawImage(sx/2+82/zoom, 268/zoom, 34/zoom, 34/zoom, textures[58], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Gracz', sx/2+122/zoom, 285/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 15/zoom), "left", "center", false, false, false, false, false)

    dxDrawImage(sx/2+429/zoom, 268/zoom, 34/zoom, 34/zoom, textures[45], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Bet', sx/2+469/zoom, 285/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 15/zoom), "left", "center", false, false, false, false, false)

    dxDrawImage(sx/2+736/zoom, 275/zoom, 20/zoom, 20/zoom, textures[55], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Cashout', sx/2+769/zoom, 285/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 15/zoom), "left", "center", false, false, false, false, false)

    local offset = 0
    for i=1,15 do
        local v = crash.bets[i]
        if v then
            dxDrawImage(sx/2+74/zoom, 335/zoom + offset, 812/zoom, 40/zoom, textures[44], 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawText(v.nick, sx/2+122/zoom, 355/zoom + offset, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "left", "center", false, false, false, false, false)
            dxDrawText(v.multiplier and string.format('%.2f',v.multiplier)..'x' or '---', sx/2+469/zoom, 355/zoom + offset, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "left", "center", false, false, false, false, false)
            dxDrawText(v.cashouted and kropki(v.cashouted)..' $' or '---', sx/2+769/zoom, 355/zoom + offset, nil, nil, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "left", "center", false, false, false, false, false)
            offset = offset + 46/zoom
        end
    end

end

local clickTick = getTickCount()
function crashClick()
    if clickTick > getTickCount() then return end
    clickTick = getTickCount() + 250

    if isMouseIn(sx/2-648/zoom, 953/zoom, 398/zoom, 68/zoom) then
        if crash.state then
            if crash.bet <= 0 then return end
            if crash.cashouted or crash.stopped then return end
            local betted = false
            for i,v in ipairs(crash.bets) do
                if v.player == localPlayer then
                    betted = true
                    break
                end
            end
            if not betted then return end
            crash.cashouted = true
            triggerServerEvent('crashInteraction', resourceRoot, 'cashout', crash.value)

        else
            local bet = exports['since-gui']:getEditboxText(crash.editboxes[1])
            local autoCashout = exports['since-gui']:getEditboxText(crash.editboxes[2])

            if not tonumber(bet) then
                exports['since-notifications']:sendNotification('error', 'Wprowadź poprawną kwotę zakładu.')
                return
            end

            if crash.autoCashout then
                if not tonumber(autoCashout) then
                    exports['since-notifications']:sendNotification('error', 'Wprowadź poprawną wartość automatycznego cashoutu.')
                    return
                end
            end

            local data = {}
            data.bet = tonumber(bet)
            if data.bet <= 0 then return end
            if crash.autoCashout then
                data.autoCashout = tonumber(autoCashout)
                if data.autoCashout <= 0 then return end
            end

            if data.bet > getElementData(localPlayer, "client:coin") then
                exports['since-notifications']:sendNotification('error', 'Nie posiadasz tyle żetonów.')
                return
            end

            triggerServerEvent('crashInteraction', resourceRoot, 'placeBet', data)
            
        end

    elseif isMouseIn(sx/2-189/zoom, 815/zoom, 172/zoom, 44/zoom) then
        if crash.bet > 0 then return end
        crash.autoCashout = not crash.autoCashout

    else

        local texts = {'1/2','x2','MAX'}
        local offset = 0
        for i=1,3 do
            if isMouseIn(sx/2-619/zoom + offset, 815/zoom, 44/zoom, 44/zoom) then
                if i == 1 then
                    local bet = exports['since-gui']:getEditboxText(crash.editboxes[1])
                    if not tonumber(bet) then
                        exports['since-notifications']:sendNotification('error', 'Wprowadź poprawną kwotę zakładu.')
                        return
                    end
                    local value = math.floor(tonumber(bet)/2)
                    exports['since-gui']:setEditboxText(crash.editboxes[1], tostring(value))
                elseif i == 2 then
                    local bet = exports['since-gui']:getEditboxText(crash.editboxes[1])
                    if not tonumber(bet) then
                        exports['since-notifications']:sendNotification('error', 'Wprowadź poprawną kwotę zakładu.')
                        return
                    end
                    local value = math.floor(tonumber(bet)*2)
                    if value > crash.maxBet then
                        value = crash.maxBet
                    end
                    exports['since-gui']:setEditboxText(crash.editboxes[1], tostring(value))
                elseif i == 3 then
                    local coin = getElementData(localPlayer, "client:coin") or 0
                    if coin > crash.maxBet then
                        coin = crash.maxBet
                    end
                    exports['since-gui']:setEditboxText(crash.editboxes[1], tostring(coin))
                end
            end
            offset = offset + 56/zoom
        end
        
    end
end

function toggleCrash(state)
    if state then
        if crash.editboxes then
            for i,v in ipairs(crash.editboxes) do
                exports['since-gui']:destroyUIElement(v)
            end
        end

        crash.bet = 0 

        crash.editboxes = {}
        crash.editboxes[1] = exports['since-gui']:createEditbox('Wprowadź kwotę zakładu...', sx/2-878/zoom, 815/zoom, 250/zoom, 44/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 40/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = textures[56],
            placeholderColor = {155, 155, 155},
            specialCharacters = false,
            icon = textures[52],
            iconPadding = 34/zoom,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
        crash.editboxes[2] = exports['since-gui']:createEditbox('Wprowadź wartość cashoutu...', sx/2-451/zoom, 815/zoom, 250/zoom, 44/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 40/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = textures[56],
            placeholderColor = {155, 155, 155},
            specialCharacters = false,
            icon = textures[52],
            iconPadding = 34/zoom,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
    else

        crash.bet = 0

        if crash.editboxes then
            for i,v in ipairs(crash.editboxes) do
                exports['since-gui']:destroyUIElement(v)
            end
        end

    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if crash.editboxes then
        for i,v in ipairs(crash.editboxes) do
            exports['since-gui']:destroyUIElement(v)
        end
    end
end)

crash.tick = getTickCount()
crash.timeToNext = 20000
crash.value = 0
crash.bet = 0
crash.bets = {}
crash.lastCrashes = {}
crash.maxBet = 2000000

addEvent('crashInteraction', true)
addEventHandler('crashInteraction', resourceRoot, function(action, data)
    if action == 'startCrash' then

        if not crash.loaded then 
            crash.loaded = true
        end
        crash.state = true
        animate(crash.value, data.random, 1, data.time, function(value)
            crash.value = value
            if not crash.cashouted then
                if crash.autoCashout and crash.autoCashoutValue and crash.value >= crash.autoCashoutValue then
                    triggerServerEvent('crashInteraction', resourceRoot, 'autoCashout', crash.value)
                    crash.cashouted = true
                end
            end
        end, function()
            crash.stopped = true
        end)

    elseif action == 'endCrash' then

        if not crash.loaded then crash.loaded = true end
        crash.stopped = nil
        crash.tick = getTickCount() + crash.timeToNext
        crash.state = nil
        crash.bets = {}

        table.insert(crash.lastCrashes, string.format('%.2f', data.random))
        if #crash.lastCrashes > 9 then
            table.remove(crash.lastCrashes, 1)
        end

        crash.value = 0
        crash.bet = 0
        crash.cashouted = nil

    elseif action == 'reloadBets' then

        crash.bets = data

    elseif action == 'placedBet' then

        crash.bet = data[1]
        if crash.autoCashout then
            crash.autoCashoutValue = data[2]
        end

    end
end)