local renderID, renderData
local main = {}

function render()
    local anim = main['anim'][1]
    dxDrawImage(sx/2-534/zoom, sy/2-265/zoom, 1068/zoom, 530/zoom, main['textures']['bg'], 0, 0, 0, tocolor(255, 255, 255, anim))
    dxDrawImage(sx/2-115/zoom, sy/2+160/zoom, 230/zoom, 2/zoom, main['textures']['line'], 0, 0, 0, tocolor(255, 255, 255, anim))
    
    if main['pages'][main['actualPage']] then
        main['pages'][main['actualPage']]['render']()
    end

    dxDrawText('Aby zamknąć panel kliknij #68D65Ebackspace', sx/2, sy/2+270/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][3], 'center', 'top', false, false, false, true)

    local offset = -((#main['pages']-1)*68/zoom+(#main['pages']-1)*13/zoom)/2-(68/zoom)/2
    if #main['pages'] > 0  then
        for i=1,#main['pages'] do
            local buttonAnim = animateButton('button'..i, isMouseInPosition(sx/2+offset, sy/2+180/zoom, 68/zoom, 68/zoom))
            dxDrawImage(sx/2+offset, sy/2+180/zoom, 68/zoom, 68/zoom, main['textures']['page_button'], 0, 0, 0, tocolor(255, 255, 255, anim*buttonAnim))
            dxDrawImage(sx/2+offset+10/zoom, sy/2+190/zoom, 48/zoom, 48/zoom, main['textures']['page'..i..'_icon'], 0, 0, 0, tocolor(255, 255, 255, anim*buttonAnim))
            offset = offset + 81/zoom
        end
    end
end

main['pages'] = {
    [1] = {
        render = function()
            local anim = main['anim'][1]
            if not main['fanRotation'] then main['fanRotation'] = 0 end
            dxDrawImage(sx/2-514/zoom, sy/2-245/zoom, 232/zoom, 232/zoom, main['textures']['fan_bg'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2-514/zoom, sy/2-245/zoom, 232/zoom, 232/zoom, main['textures']['fan'], main['fanRotation'], 0, 0, tocolor(255, 255, 255, anim))
            local r,g,b = 211, 78, 78
            local isTurned = main['state'] == 1
            if isTurned then
                main['fanRotation'] = main['fanRotation'] >= 360 and 0 or main['fanRotation'] + 2
                r,g,b = 104, 214, 94
            end
            local jobStats = getElementData(localPlayer, "player:jobStats") or {}
            if not jobStats['crypto'] then
                jobStats['crypto'] = {}
            end
            if not jobStats['crypto']['wallet'] then
                jobStats['crypto']['wallet'] = {0, 0, 0}
            end
            if not jobStats['crypto']['parts'] then
                jobStats['crypto']['parts'] = {
                    ['graphicsCard'] = 1,
                    ['powerSupply'] = 1
                }
            end
            if not jobStats['crypto']['earned'] then
                jobStats['crypto']['earned'] = 0
            end

            dxDrawText('Status koparki', sx/2-509/zoom, sy/2+30/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][1], 'left', 'bottom')
            dxDrawImage(sx/2-509/zoom, sy/2+32/zoom, 20/zoom, 20/zoom, main['textures'][isTurned and 'stateOn' or 'stateOff'], 0, 0, 0, tocolor(r, g, b, anim))
            dxDrawText(isTurned and 'Pracuje' or 'Nie pracuje', sx/2-482/zoom, sy/2+30/zoom, nil, nil, tocolor(r, g, b, anim), 1, main['fonts'][2], 'left', 'top')

            dxDrawText('Łączny dochód', sx/2-509/zoom, sy/2+100/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][1], 'left', 'bottom')
            dxDrawText('$ '..formatNumber(jobStats['crypto']['earned']), sx/2-509/zoom, sy/2+100/zoom, nil, nil, tocolor(46, 117, 111, anim), 1, main['fonts'][2], 'left', 'top')

            dxDrawImage(sx/2-242/zoom, sy/2-240/zoom, 230/zoom, 130/zoom, main['textures']['bg2'], 0, 0, 0, tocolor(255, 255, 255, anim))

            dxDrawImage(sx/2-234/zoom, sy/2-232/zoom, 34/zoom, 34/zoom, main['textures']['bitcoin_icon'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawText(string.format('%.4f', jobStats['crypto']['wallet'][1]/10000)..' BTC', sx/2-194/zoom, sy/2-215/zoom, nil, nil, tocolor(215, 215, 215, anim), 1, main['fonts'][2], 'left', 'center')
            
            dxDrawImage(sx/2-234/zoom, sy/2-194/zoom, 34/zoom, 34/zoom, main['textures']['litecoin_icon'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawText(string.format('%.4f', jobStats['crypto']['wallet'][2]/10000)..' LTC', sx/2-194/zoom, sy/2-177/zoom, nil, nil, tocolor(215, 215, 215, anim), 1, main['fonts'][2], 'left', 'center')

            dxDrawImage(sx/2-234/zoom, sy/2-156/zoom, 34/zoom, 34/zoom, main['textures']['ethereum_icon'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawText(string.format('%.4f', jobStats['crypto']['wallet'][3]/10000)..' ETH', sx/2-194/zoom, sy/2-139/zoom, nil, nil, tocolor(215, 215, 215, anim), 1, main['fonts'][2], 'left', 'center')

            local buttonAnim = animateButton('turnOn', isMouseInPosition(sx/2-242/zoom, sy/2-100/zoom, 230/zoom, 50/zoom))
            dxDrawImage(sx/2-242/zoom, sy/2-100/zoom, 230/zoom, 50/zoom, main['textures'][isTurned and 'turnOff_button' or 'turnOn_button'], 0, 0, 0, tocolor(255, 255, 255, anim*buttonAnim))
            dxDrawText((isTurned and 'Wyłącz' or 'Włącz')..' koparkę', sx/2-192/zoom, sy/2-75/zoom, nil, nil, tocolor(235, 235, 235, anim*buttonAnim), 1, main['fonts'][2], 'left', 'center')

            dxDrawRectangle(sx/2-2/zoom, sy/2-175/zoom, 100/zoom, 5/zoom, tocolor(217, 217, 217, 155*(anim/255)))
            dxDrawRectangle(sx/2+30/zoom, sy/2-170/zoom, 5/zoom, 135/zoom, tocolor(217, 217, 217, 155*(anim/255)))
            dxDrawRectangle(sx/2+35/zoom, sy/2-40/zoom, 50/zoom, 5/zoom, tocolor(217, 217, 217, 155*(anim/255)))

            dxDrawImage(sx/2+376/zoom, sy/2-245/zoom, 138/zoom, 138/zoom, main['textures']['bg3'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2+383/zoom, sy/2-238/zoom, 124/zoom, 124/zoom, main['textures']['graphics1'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawText('Karta graficzna', sx/2+366/zoom, sy/2-205/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText(graphicsCard[jobStats['crypto']['parts']['graphicsCard']]['name'], sx/2+366/zoom, sy/2-205/zoom, nil, nil, tocolor(46, 117, 111, anim), 1, main['fonts'][5], 'right', 'top')

            if not main['powerSave'] then main['powerSave'] = {math.random(30,80)/100, math.random(30,80)/100} end

            if not main['powerTick1'] then main['powerTick1'] = getTickCount() end
            if main['powerTick1'] < getTickCount() and isTurned then
                main['powerTick1'] = getTickCount()+500
                main['powerSave'][1] = math.random(60,80)/100
            end
            
            dxDrawImage(sx/2+161/zoom, sy/2-165/zoom, 196/zoom, 10/zoom, main['textures']['power_bar'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImageSection(sx/2+161/zoom, sy/2-165/zoom, 196/zoom*main['powerSave'][1], 10/zoom, 0, 0, 196*main['powerSave'][1], 10, main['textures']['power_bar2'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2+137/zoom, sy/2-170/zoom, 20/zoom, 20/zoom, main['textures']['thor_icon'], 0, 0, 0, tocolor(255, 255, 255, anim))

            dxDrawImage(sx/2+161/zoom, sy/2-135/zoom, 196/zoom, 10/zoom, main['textures']['health_bar'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImageSection(sx/2+161/zoom, sy/2-135/zoom, 196/zoom*1, 10/zoom, 0, 0, 196*1, 10, main['textures']['health_bar2'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2+137/zoom, sy/2-140/zoom, 20/zoom, 20/zoom, main['textures']['health_icon'], 0, 0, 0, tocolor(255, 255, 255, anim))

            if not main['powerTick2'] then main['powerTick2'] = getTickCount() end
            if main['powerTick2'] < getTickCount() and isTurned then
                main['powerTick2'] = getTickCount()+500
                main['powerSave'][2] = math.random(60,80)/100
            end
            dxDrawImage(sx/2+376/zoom, sy/2-87/zoom, 138/zoom, 138/zoom, main['textures']['bg3'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2+383/zoom, sy/2-80/zoom, 124/zoom, 124/zoom, main['textures']['power1'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawText('Zasilacz koparki', sx/2+366/zoom, sy/2-47/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][4], 'right', 'bottom')
            dxDrawText(powerSupply[jobStats['crypto']['parts']['powerSupply']]['name'], sx/2+366/zoom, sy/2-47/zoom, nil, nil, tocolor(46, 117, 111, anim), 1, main['fonts'][5], 'right', 'top')

            dxDrawImage(sx/2+161/zoom, sy/2-7/zoom, 196/zoom, 10/zoom, main['textures']['power_bar'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImageSection(sx/2+161/zoom, sy/2-7/zoom, 196/zoom*main['powerSave'][2], 10/zoom, 0, 0, 196*main['powerSave'][2], 10, main['textures']['power_bar2'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2+137/zoom, sy/2-13/zoom, 20/zoom, 20/zoom, main['textures']['thor_icon'], 0, 0, 0, tocolor(255, 255, 255, anim))
        end,
    },
    [2] = {
        render = function()
            local anim = main['anim'][1]
            dxDrawImage(sx/2-502/zoom, sy/2-233/zoom, 234/zoom, 360/zoom, main['textures']['bg4'], 0, 0, 0, tocolor(255, 255, 255, anim))
            dxDrawImage(sx/2-260/zoom, sy/2-233/zoom, 758/zoom, 360/zoom, main['textures']['bg5'], 0, 0, 0, tocolor(255, 255, 255, anim))

            local offset = 0
            for i=1,3 do
                local isIn = isMouseInPosition(sx/2-502/zoom, sy/2-233/zoom+offset, 234/zoom, 56/zoom)
                local buttonAnim = animateButton('secoundPage'..i, isIn, 0.5)
                if main['secoundPage']==i then buttonAnim = 1 end
                dxDrawImage(sx/2-502/zoom, sy/2-233/zoom+offset, 234/zoom, 56/zoom, main['textures'][i==1 and 'category_button1' or 'category_button2'], 0, 0, 0, tocolor(255, 255, 255, (125*(anim/255))*buttonAnim))
                dxDrawText(secoundPages[i], sx/2-502/zoom+234/2/zoom, sy/2-233/zoom+56/2/zoom+offset, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][5], 'center', 'center')
                if i < 3 then
                    dxDrawRectangle(sx/2-502/zoom, sy/2-233/zoom+56/zoom+offset, 234/zoom, 2/zoom, tocolor(255, 255, 255, 55*(anim/255)))
                end
                offset = offset + 58/zoom
            end

            if renderData then
                local tbl = main['secoundPage'] == 1 and graphicsCard or main['secoundPage'] == 2 and powerSupply or boosts
                if not main['tick'] then main['tick'] = getTickCount()-1 end
                if main['tick'] < getTickCount() then
                    main['tick'] = getTickCount() + 50
                    reloadRenderTarget()
                end

                if main['showInfo'] then
                    if main['secoundPage'] == 1 then
                        local cx, cy = getCursorPosition()
                        local cx, cy = (cx * sx), (cy * sy)
                        local fontHeight = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        local width, height = 200/zoom, fontHeight*4+5/zoom
                        local textWidth = dxGetTextWidth('Karta graficzna: '..tbl[main['showInfo']].name, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        if width < textWidth then width = textWidth+10/zoom end
                        local textWidth = dxGetTextWidth('Wymagana moc zasilacza: '..tbl[main['showInfo']].power..'W', 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        if width < textWidth then width = textWidth+10/zoom end
                        dxDrawRoundedRectangle(cx + 10/zoom, cy + 10/zoom, width, height, 4/zoom, tocolor(45, 45, 45, 245), true)
                        dxDrawText('Karta graficzna: '..tbl[main['showInfo']].name, cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Moc: '..tbl[main['showInfo']].power..'W', cx + 15/zoom, cy + 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Wymagana moc zasilacza: '..tbl[main['showInfo']].power..'W', cx + 15/zoom, cy + 55/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Koszt: $'..formatNumber(tbl[main['showInfo']].cost), cx + 15/zoom, cy + 75/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                    elseif main['secoundPage'] == 2 then
                        local cx, cy = getCursorPosition()
                        local cx, cy = (cx * sx), (cy * sy)
                        local fontHeight = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        local width, height = 200/zoom, fontHeight*3+5/zoom
                        local textWidth = dxGetTextWidth('Zasilacz: '..tbl[main['showInfo']].name, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        if width < textWidth then width = textWidth+10/zoom end
                        local textWidth = dxGetTextWidth('Moc: '..tbl[main['showInfo']].power..'W', 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        if width < textWidth then width = textWidth+10/zoom end
                        dxDrawRoundedRectangle(cx + 10/zoom, cy + 10/zoom, width, height, 4/zoom, tocolor(45, 45, 45, 245), true)
                        dxDrawText('Zasilacz: '..tbl[main['showInfo']].name, cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Moc: '..tbl[main['showInfo']].power..'W', cx + 15/zoom, cy + 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Koszt: $'..formatNumber(tbl[main['showInfo']].cost), cx + 15/zoom, cy + 55/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                    else
                        local cx, cy = getCursorPosition()
                        local cx, cy = (cx * sx), (cy * sy)
                        local fontHeight = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        local width, height = 200/zoom, fontHeight*3+5/zoom
                        local textWidth = dxGetTextWidth('Ulepszenie: '..tbl[main['showInfo']].name, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        if width < textWidth then width = textWidth+10/zoom end
                        local textWidth = dxGetTextWidth('Działanie: '..tbl[main['showInfo']].desc, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom))
                        if width < textWidth then width = textWidth+10/zoom end

                        if (cx + 10/zoom + width) > sx then
                            cx = sx - width - 10/zoom
                        end

                        dxDrawRoundedRectangle(cx + 10/zoom, cy + 10/zoom, width, height, 4/zoom, tocolor(45, 45, 45, 245), true)
                        dxDrawText('Ulepszenie: '..tbl[main['showInfo']].name, cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Działanie: '..tbl[main['showInfo']].desc, cx + 15/zoom, cy + 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)
                        dxDrawText('Koszt: $'..formatNumber(tbl[main['showInfo']].cost), cx + 15/zoom, cy + 55/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, true)

                    end
                end
            end

        end,
        load = function()
            local tbl = main['secoundPage'] == 1 and graphicsCard or main['secoundPage'] == 2 and powerSupply or boosts
            renderID, renderData = exports['since-renders']:createTarget({
                x = sx/2-260/zoom,
                y = sy/2-233/zoom,
                w = 758/zoom,
                h = 360/zoom,
                alpha = true,
                max_scroll = getMaxOffset(#tbl, 87/zoom, 4, 360/zoom),
                scrollSpeed = 20,
                noDrag = true,
                        
                scrollData = {
                    visible = true,
                    x = sx/2-260/zoom+758/zoom+5/zoom,
                    w = 5/zoom,
                    color = {100, 100, 100},
                }
            })
            reloadRenderTarget()
        end,
        destroy = function()
            exports['since-renders']:destroyTarget(renderID)
            renderID, renderData = nil, nil
        end,
    },
    [3] = {
        render = function()
            local anim = main['anim'][1]
            local jobStats = getElementData(localPlayer, "player:jobStats") or {}
            if not jobStats['crypto'] then
                jobStats['crypto'] = {}
            end
            if not jobStats['crypto']['wallet'] then
                jobStats['crypto']['wallet'] = {0, 0, 0}
            end

            local buttonAnim = animateButton('btc', isMouseInPosition(sx/2-502/zoom, sy/2+75/zoom, 50/zoom, 50/zoom))
            dxDrawImage(sx/2-502/zoom, sy/2+75/zoom, 50/zoom, 50/zoom, main['textures']['bitcoin_icon'], 0, 0, 0, tocolor(255, 255, 255, anim*buttonAnim))
            dxDrawText('Bitcoin', sx/2-447/zoom, sy/2+100/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][2], 'left', 'center')
            local textWidth = dxGetTextWidth('Bitcoin', 1, main['fonts'][2])
            dxDrawText('[ '..string.format('%.4f', jobStats['crypto']['wallet'][1]/10000)..' BTC ]', sx/2-447/zoom+textWidth+10/zoom, sy/2+99/zoom, nil, nil, tocolor(215, 215, 215, anim), 1, main['fonts'][5], 'left', 'center')

            local buttonAnim = animateButton('ltc', isMouseInPosition(sx/2-162/zoom, sy/2+75/zoom, 50/zoom, 50/zoom))
            dxDrawImage(sx/2-162/zoom, sy/2+75/zoom, 50/zoom, 50/zoom, main['textures']['litecoin_icon'], 0, 0, 0, tocolor(255, 255, 255, anim*buttonAnim))
            dxDrawText('Litecoin', sx/2-107/zoom, sy/2+100/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][2], 'left', 'center')
            local textWidth = dxGetTextWidth('Litecoin', 1, main['fonts'][2])
            dxDrawText('[ '..string.format('%.4f', jobStats['crypto']['wallet'][2]/10000)..' LTC ]', sx/2-107/zoom+textWidth+10/zoom, sy/2+99/zoom, nil, nil, tocolor(215, 215, 215, anim), 1, main['fonts'][5], 'left', 'center')

            local buttonAnim = animateButton('eth', isMouseInPosition(sx/2+172/zoom, sy/2+75/zoom, 50/zoom, 50/zoom))
            dxDrawImage(sx/2+172/zoom, sy/2+75/zoom, 50/zoom, 50/zoom, main['textures']['ethereum_icon'], 0, 0, 0, tocolor(255, 255, 255, anim*buttonAnim))
            dxDrawText('Ethereum', sx/2+229/zoom, sy/2+100/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][2], 'left', 'center')
            local textWidth = dxGetTextWidth('Ethereum', 1, main['fonts'][2])
            dxDrawText('[ '..string.format('%.4f', jobStats['crypto']['wallet'][3]/10000)..' ETH ]', sx/2+227/zoom+textWidth+10/zoom, sy/2+99/zoom, nil, nil, tocolor(215, 215, 215, anim), 1, main['fonts'][5], 'left', 'center')

            dxDrawText('Aby sprzedać wybraną kryptowalutę kliknij na jej ikonkę pod wykresem', sx/2, sy/2+140/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][5], 'center', 'center')

        end,
        load = function()
            if not main['charts'] then main['charts'] = {} end
            if #main['charts'] > 0 then return end
            local offset = 0
            for i=1,3 do
                local type = i==1 and 'bitcoin' or i==2 and 'litecoin' or 'ethereum'
                local valuesSave = main['prices'][type]
                for k=1,10 do
                    if not valuesSave[k] then valuesSave[k] = 0 end
                end
                local values = {}
                for k=1,10 do
                    values[11-k] = valuesSave[k] or 0
                end
                main['charts'][i] = exports['since-charts']:createChart({
                    x = sx/2-502/zoom + offset,
                    y = sy/2-233/zoom,
                    w = 330/zoom,
                    h = 300/zoom,
                    radius = 15,
                    blur = false,
                    type = 'line',
                    background = tocolor(155, 155, 155, 25),
                    color = tocolor(155, 255, 155, 175),
                    bottomColor = tocolor(155, 255, 155, 75),
                    line = tocolor(155, 255, 155, 175),
                    point = tocolor(155, 255, 155, 255),
                    pointSize = 10,
                    min = cryptoPrices[type][1]-1000,
                    max = cryptoPrices[type][2]+1000,
                    width = 5,
                    round = 0,
                    marginHorizontal = 5,
                    marginVertical = 10,
                    font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                
                    data = {
                        values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], values[9], values[10]
                    },
                    
                    labels = {
                        horizontalPosition = 'left',
                        verticalPosition = 'bottom',
                        horizontal = {
                            '', '', '', '', '', '', ''
                        },
                        vertical = 50
                    }
                })
                offset = offset + 340/zoom
            end
        end,
        destroy = function()
            for i,v in pairs(main['charts']) do
                destroyElement(v)
            end
            main['charts'] = {}
        end,
    },
}

function reloadRenderTarget()
    if not renderData then return end
    local tbl = main['secoundPage'] == 1 and graphicsCard or main['secoundPage'] == 2 and powerSupply or boosts
    local count = 0
    dxSetRenderTarget(renderData.rt, true)
        dxSetBlendMode('modulate_add')
            local offset = 2/zoom

            for i = 1,#tbl do
                dxDrawRoundedRectangle(2/zoom, offset, 754/zoom, 81/zoom, 10/zoom, tocolor(76, 76, 76, 225))
                dxDrawImage(20/zoom, offset + 10/zoom, 61/zoom, 61/zoom, 'files/images/graphics1.png', 0, 0, 0, tocolor(255, 255, 255, 255))

                dxDrawText(tbl[i].name, 95/zoom, offset + 44/zoom, nil, nil, tocolor(46, 117, 111, anim), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), 'left', 'bottom')

                dxDrawText('Najedź kursorem aby wyświetlić statystyki', 95/zoom, offset + 44/zoom, nil, nil, tocolor(255, 255, 255, 185), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top')

                if isMouseInRender(690/zoom, offset + 26/zoom, 42/zoom, 34/zoom, renderData, renderID) then
                    count = count + 1
                    main['showInfo'] = i
                end

                dxDrawImage(690/zoom, offset + 26/zoom, 42/zoom, 34/zoom, 'files/images/basket_icon.png', 0, 0, 0, tocolor(255, 255, 255, main['showInfo'] == i and 155 or 255))

                offset = offset + 87/zoom
            end

        dxSetBlendMode('blend')
    dxSetRenderTarget()
    if count == 0 then
        main['showInfo'] = nil
    end
end

function click(button, state)
    if not main['clickTick'] then main['clickTick'] = getTickCount()-5 end
    if main['clickTick'] > getTickCount() then return end
    if button == 'left' and state == 'down' then
        main['clickTick'] = getTickCount()+250
        if main['actualPage'] == 1 then
            if isMouseInPosition(sx/2-242/zoom, sy/2-100/zoom, 230/zoom, 50/zoom) then
                triggerServerEvent('cryptoEvent', resourceRoot, main['state'] == 1 and 'stopDigging' or 'startDigging')
                main['state'] = main['state'] == 1 and 0 or 1
                return
            end

        elseif main['actualPage'] == 2 then

            local offset = 0
            for i=1,3 do
                local isIn = isMouseInPosition(sx/2-502/zoom, sy/2-233/zoom+offset, 234/zoom, 56/zoom)
                if isIn then
                    if main['secoundPage'] == i then return end
                    main['secoundPage'] = i
                    local tbl = main['secoundPage'] == 1 and graphicsCard or main['secoundPage'] == 2 and powerSupply or boosts
                    exports['since-renders']:setMaxScrollLimit(renderID, getMaxOffset(#tbl, 87/zoom, 4, 360/zoom))
                    exports['since-renders']:setScrollPosition(renderID, 0)
                    return
                end
                offset = offset + 58/zoom
            end

            local tbl = main['secoundPage'] == 1 and graphicsCard or main['secoundPage'] == 2 and powerSupply or boosts
            local offset = 2/zoom
            for i = 1,#tbl do
                if isMouseInRender(690/zoom, offset + 26/zoom, 42/zoom, 34/zoom, renderData, renderID) then
                    triggerServerEvent('cryptoEvent', resourceRoot, 'buyPart', {main['secoundPage'] == 1 and 'graphicsCard' or main['secoundPage'] == 2 and 'powerSupply' or 'boosts', i})
                    return
                end
                offset = offset + 87/zoom
            end
            
        elseif main['actualPage'] == 3 then
            if isMouseInPosition(sx/2-502/zoom, sy/2+75/zoom, 50/zoom, 50/zoom) then
                local jobStats = getElementData(localPlayer, "player:jobStats") or {}
                if not jobStats['crypto'] then
                    jobStats['crypto'] = {}
                end
                if not jobStats['crypto']['wallet'] then
                    jobStats['crypto']['wallet'] = {0, 0, 0}
                end
                if jobStats['crypto']['wallet'][1] == 0 then return end
                triggerServerEvent('cryptoEvent', resourceRoot, 'sellCrypto', 'bitcoin')
            elseif isMouseInPosition(sx/2-162/zoom, sy/2+75/zoom, 50/zoom, 50/zoom) then
                local jobStats = getElementData(localPlayer, "player:jobStats") or {}
                if not jobStats['crypto'] then
                    jobStats['crypto'] = {}
                end
                if not jobStats['crypto']['wallet'] then
                    jobStats['crypto']['wallet'] = {0, 0, 0}
                end
                if jobStats['crypto']['wallet'][2] == 0 then return end
                triggerServerEvent('cryptoEvent', resourceRoot, 'sellCrypto', 'litecoin')
            elseif isMouseInPosition(sx/2+172/zoom, sy/2+75/zoom, 50/zoom, 50/zoom) then
                local jobStats = getElementData(localPlayer, "player:jobStats") or {}
                if not jobStats['crypto'] then
                    jobStats['crypto'] = {}
                end
                if not jobStats['crypto']['wallet'] then
                    jobStats['crypto']['wallet'] = {0, 0, 0}
                end
                if jobStats['crypto']['wallet'][3] == 0 then return end
                triggerServerEvent('cryptoEvent', resourceRoot, 'sellCrypto', 'ethereum')
            end
        end
        local offset = -((#main['pages']-1)*68/zoom+(#main['pages']-1)*13/zoom)/2-(68/zoom)/2
        if #main['pages'] > 0  then
            for i=1,#main['pages'] do
                if isMouseInPosition(sx/2+offset, sy/2+180/zoom, 68/zoom, 68/zoom) then
                    if main['actualPage'] == i then return end
                    if main['pages'][main['actualPage']]['destroy'] then
                        main['pages'][main['actualPage']]['destroy']()
                    end
                    main['actualPage'] = i
                    if main['pages'][main['actualPage']]['load'] then
                        main['pages'][main['actualPage']]['load']()
                    end
                    return
                end
                offset = offset + 81/zoom
            end
        end
    end
end

function turnPanel(state)
    if main['block'] then return end
    if state and state == true then
        if isEventHandlerAdded('onClientRender', root, render) then return end
        local jobStats = getElementData(localPlayer, "player:jobStats") or {}
        if not jobStats['crypto'] then
            jobStats['crypto'] = {}
        end
        if not jobStats['crypto']['bought'] then
            return exports['since-notifications']:sendNotification('error', 'Nie posiadasz kupionej siedziby!')
        end
        main['block'] = true
        main['textures'] = createTextures({
            'bg', 'bg2', 'bg3', 'bitcoin_icon', 'ethereum_icon', 'fan', 'fan_bg', 'graphics1', 'health_bar', 
            'health_bar2', 'health_icon', 'line', 'lines', 'litecoin_icon', 'page_button', 'page1_icon', 'page2_icon', 'page3_icon', 'power_bar', 
            'power_bar2', 'power1', 'thor_icon', 'turnOn_button', 'turnOff_button', 'stateOn', 'stateOff', 
            'basket_icon', 'bg4', 'bg5', 'category_bar1', 'category_bar2', 'category_button1', 'category_button2', 'boost_icon', 'sell_button'
        })
        main['fonts'] = loadFonts()
        main['anim'] = {}
        main['anim'][1] = 0
        main['actualPage'] = 1
        main['secoundPage'] = 1
        main['state'] = getElementData(localPlayer, 'player:cryptoMining') and 1 or 0
        main['charts'] = {}
        if main['pages'][main['actualPage']]['load'] then
            main['pages'][main['actualPage']]['load']()
        end
        addEventHandler('onClientRender', root, renderAnimate)
        addEventHandler('onClientRender', root, render)
        triggerServerEvent('cryptoEvent', resourceRoot, 'grabCryptoPrices')
        showCursor(true)
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, click)
            bindKey('backspace', 'down', turnPanel)
            main['block'] = nil
        end)
    else
        if not isEventHandlerAdded('onClientRender', root, render) then return end
        main['block'] = true
        removeEventHandler('onClientClick', root, click)
        unbindKey('backspace', 'down', turnPanel)
        showCursor(false)
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            destroyTextures(main['textures'])
            removeEventHandler('onClientRender', root, renderAnimate)
            for i,v in pairs(main) do
                if i ~= 'pages' then
                    main[i] = nil
                end
            end
        end)
        if main['pages'][main['actualPage']]['destroy'] then
            main['pages'][main['actualPage']]['destroy']()
        end
    end
end

addEvent('cryptoEvent', true)
addEventHandler('cryptoEvent', resourceRoot, function(action, data)
    if action == 'grabCryptoPrices' then
        if isEventHandlerAdded('onClientRender', root, render) then
            main['prices'] = {
                ['bitcoin'] = {},
                ['litecoin'] = {},
                ['ethereum'] = {}
            }
            for i,v in pairs(data) do
                main['prices'][i] = {}
                for i2,v2 in ipairs(v) do
                    table.insert(main['prices'][i], v2.price)
                end
            end
        end
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['charts'] then
        for i,v in pairs(main['charts']) do
            destroyElement(v)
        end
    end
end)

function animateButton(button, isIn, outValue)
    local outValue = outValue or 0.7
    local animPower = {isIn and 1 or outValue, 0.1}
    if not main['anim'][button] then main['anim'][button] = animPower[1] end
    if main['anim'][button] == animPower[1] then return main['anim'][button] end
    main['anim'][button] = interpolateBetween(main['anim'][button], 0, 0, animPower[1], 0, 0, animPower[2], 'Linear')
    return main['anim'][button]
end

function renderBuy()
    dxDrawImage(sx/2-150/zoom, sy/2-140/zoom, 300/zoom, 280/zoom, main['textures']['bg'], 0,0,0, tocolor(255,255,255,main['anim'][1]))
    dxDrawText('Siedziba #68D65E#001', sx/2-135/zoom, sy/2-115/zoom, nil, nil, tocolor(255,255,255,main['anim'][1]), 1, main['fonts'][4], 'left', 'center', false, false, false, true)
    local isIn = isMouseInPosition(sx/2+115/zoom, sy/2-125/zoom, 20/zoom, 20/zoom)
    dxDrawImage(sx/2+115/zoom, sy/2-125/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,isIn and main['anim'][1] or 200*(main['anim'][1]/255)))
    local jobStats = getElementData(localPlayer, "player:jobStats") or {}
    if not jobStats['crypto'] then
        jobStats['crypto'] = {}
    end
    
        dxDrawText('Zakup Siedzibe z #68D65Ekryptowalutami', sx/2, sy/2-70/zoom, nil, nil, tocolor(255,255,255,main['anim'][1]), 1, main['fonts'][5], 'center', 'center', false, false, false, true)
        dxDrawText('Aby zakupić siedzibe musisz posiadac '..srp..' SRP.', sx/2-150/zoom, sy/2-55/zoom, sx/2+150/zoom, nil, tocolor(255,255,255,main['anim'][1]), 1, main['fonts'][6], 'center', 'top', false, true)
        dxDrawText('Cena siedziby', sx/2, sy/2+25/zoom, nil, nil, tocolor(104,214,94,main['anim'][1]), 1, main['fonts'][5], 'center', 'center')
        dxDrawText('Cena siedziby wynosi: #68D65E$ '..formatNumber(cost), sx/2, sy/2+40/zoom, nil, nil, tocolor(255,255,255,main['anim'][1]), 1, main['fonts'][6], 'center', 'top', false, false, false, true)

    local isIn = isMouseInPosition(sx/2-100/zoom, sy/2+85/zoom, 200/zoom, 36/zoom)
    dxDrawImage(sx/2-100/zoom, sy/2+85/zoom, 200/zoom, 36/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,isIn and main['anim'][1] or 200*(main['anim'][1]/255)))
    dxDrawText('Zakup siedziby', sx/2-100/zoom, sy/2+85/zoom, sx/2+100/zoom, sy/2+121/zoom, tocolor(255,255,255,main['anim'][1]), 1, main['fonts'][5], 'center', 'center', false, false, false, true)

    local x,y,z = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(x,y,z, main['pos'][1], main['pos'][2], main['pos'][3]) > 3 then
        turnBuyPanel(false)
    end
end

function clickBuy(button, state)
    if not main['clickTick'] then main['clickTick'] = getTickCount()-5 end
    if main['clickTick'] > getTickCount() then return end
    if button == 'left' and state == 'down' then
        main['clickTick'] = getTickCount()+250
        if isMouseInPosition(sx/2+115/zoom, sy/2-125/zoom, 20/zoom, 20/zoom) then
            turnBuyPanel(false)
            return
        end
        if isMouseInPosition(sx/2-100/zoom, sy/2+85/zoom, 200/zoom, 36/zoom) then
            local jobStats = getElementData(localPlayer, "player:jobStats") or {}
            if not jobStats['crypto'] then
                jobStats['crypto'] = {}
            end
            if not jobStats['crypto']['bought'] then
                if getElementData(localPlayer, 'player:srp') < srp then
                    exports['since-notifications']:sendNotification('error', 'Nie posiadasz wystarczającej ilości SRP! ('..formatNumber(srp)..')')
                    return
                end
                turnBuyPanel(false, true)
            end
            triggerServerEvent('cryptoEvent', resourceRoot, 'buyCrypto')
            return
        end
    end
end

function turnBuyPanel(state, isNext)
    if main['block'] then return end
    if state then
        if isEventHandlerAdded('onClientRender', root, renderBuy) then return end
        main['block'] = true
        local x,y,z = getElementPosition(localPlayer)
        main['textures'] = createTextures({ 'bg', 'close', 'button' }, 'entering')
        main['fonts'] = loadFonts()
        main['anim'] = {}
        main['anim'][1] = 0
        main['pos'] = {x,y,z}
        showCursor(true)
        addEventHandler('onClientRender', root, renderAnimate)
        addEventHandler('onClientRender', root, renderBuy)
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, clickBuy)
            main['block'] = nil
        end)
    else
        if not isEventHandlerAdded('onClientRender', root, renderBuy) then return end
        main['block'] = true
        showCursor(false)
        removeEventHandler('onClientClick', root, clickBuy)
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, renderBuy)
            removeEventHandler('onClientRender', root, renderAnimate)
            destroyTextures(main['textures'])
            for i,v in pairs(main) do
                if i ~= 'pages' then
                    main[i] = nil
                end
            end
            if isNext then
                turnPanel(true)
            end
        end)

    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if renderID then
        exports['since-renders']:destroyTarget(renderID)
    end
end)