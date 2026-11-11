local tabColour = {}

function renderUI()
	dxDrawImage(sx/2 - 491/zoom, sy/2 - 336/zoom, 982/zoom, 672/zoom, 'data/bg.png')
	dxDrawImage(sx/2 - 479/zoom, sy/2 - 219/zoom, 958/zoom, 2/zoom, 'data/line.png')
	dxDrawText('Wymiana wPLN', sx/2 - 462/zoom, sy/2 - 269/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 20/zoom), 'left', 'bottom')
	dxDrawText('Posiadasz '..playerWPLN..' wPLN', sx/2 - 462/zoom, sy/2 - 269/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'top')
	
    local offset = 0 

    for i, v in ipairs(tabs) do
        if not tabColour[i] then 
            tabColour[i] = {200, 200, 200}
        end
        
        local fontWidth = dxGetTextWidth( v.name, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom) ) + 45/zoom
        local isIn = isMouseInPosition(sx/2 + 445/zoom + offset - (fontWidth-45/zoom), sy/2 - 290/zoom, (fontWidth-45/zoom), 30/zoom)

        if i == selectedTab then 
            tabX = tabX and tabX + (sx/2 + 445/zoom + offset - (fontWidth-45/zoom) - tabX) * 0.1 or sx/2 + 445/zoom + offset - (fontWidth-45/zoom)
            tabW = tabW and tabW + (fontWidth-45/zoom - tabW) * 0.1 or fontWidth-45/zoom
            tabColour[i] = {tabColour[i][1] + (125 - tabColour[i][1]) * 0.1, tabColour[i][2] + (255 - tabColour[i][2]) * 0.1, tabColour[i][3] + (125 - tabColour[i][3]) * 0.1}
        else
            tabColour[i] = {tabColour[i][1] + (200 - tabColour[i][1]) * 0.1, tabColour[i][2] + (200 - tabColour[i][2]) * 0.1, tabColour[i][3] + (200 - tabColour[i][3]) * 0.1}
        end

        dxDrawRectangle(selectedTab ~= 1 and tabX + 4/zoom or tabX, sy/2 - 255/zoom, tabW, 2, tocolor(46, 117, 111, 255))
        
        if i == selectedTab then 
            dxDrawText(v.name, sx/2 + 445/zoom + offset, sy/2 - 274/zoom, nil, nil, tocolor(tabColour[i][1], tabColour[i][2], tabColour[i][3], 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'right', 'center')
        else
            dxDrawText(v.name, sx/2 + 445/zoom + offset, sy/2 - 274/zoom, nil, nil, tocolor(tabColour[i][1], tabColour[i][2], tabColour[i][3], isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'right', 'center')
        end

        offset = offset - fontWidth
    end

    tabs[selectedTab].draw()
    
    if showedModal then 
        modalAlpha = math.min(1, modalAlpha + 0.1)
    else 
        modalAlpha = math.max(0, modalAlpha - 0.1)

        if modalAlpha == 0 then
            modalData = {}
        end
    end

    dxDrawImage(sx/2 - 491/zoom, sy/2 - 336/zoom, 982/zoom, 672/zoom, 'data/bg.png', 0, 0, 0, tocolor(0, 0, 0, 100*modalAlpha))

    dxDrawImage(sx/2 - 275/zoom, sy/2 - 172/zoom, 550/zoom, 344/zoom, 'data/modal_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*modalAlpha))
    dxDrawText('Potwierdzenie zakupu', sx/2, sy/2 - 46/zoom, nil, nil, tocolor(255, 255, 255, 255*modalAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'center', 'bottom')
    
    if modalData.vehName then
        dxDrawText('Chcesz zakupić pojazd '..modalData.vehName..'\nza '..modalData.cost..' wPLN?', sx/2, sy/2 - 25/zoom, nil, nil, tocolor(255, 255, 255, 255*modalAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
    elseif modalData.calculatedCost then
        dxDrawText('Chcesz zakupić '..modalData.itemsCount..'x przedmiotów\nza '..modalData.calculatedCost..' wPLN?', sx/2, sy/2 - 25/zoom, nil, nil, tocolor(255, 255, 255, 255*modalAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
    end

    local isIn = isMouseInPosition(sx/2 - 101/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom)
    dxDrawImage(sx/2 - 101/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom, 'data/button_buy.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200*modalAlpha or 255*modalAlpha))
    dxDrawText('Zakup', sx/2 - 50/zoom, sy/2 + 43/zoom, nil, nil, tocolor(255, 255, 255, isin and 200*modalAlpha or 255*modalAlpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')

    local isIn = isMouseInPosition(sx/2 + 3/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom)
    dxDrawImage(sx/2 + 3/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom, 'data/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200*modalAlpha or 255*modalAlpha))
    dxDrawText('Anuluj', sx/2 + 54/zoom, sy/2 + 43/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200*modalAlpha or 255*modalAlpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
end

function onClick(btn, state)
    if btn == 'left' and state == 'down' and showedModal == false then
        local offset = 0 

        for i, v in ipairs(tabs) do
            local fontWidth = dxGetTextWidth( v.name, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom) ) + 45/zoom
            local isIn = isMouseInPosition(sx/2 + 445/zoom + offset - (fontWidth-45/zoom), sy/2 - 290/zoom, (fontWidth-45/zoom), 30/zoom)

            if isIn then
                if isEventHandlerAdded('onClientClick', root, tabs[selectedTab].click) and tabs[selectedTab].click then
                    removeEventHandler('onClientClick', root, tabs[selectedTab].click)
                end

                if tabs[selectedTab].destroy then
                    tabs[selectedTab].destroy()
                end

                selectedTab = i
                scroll = {k = 1, n = 6, m = 6}

                if tabs[selectedTab].create then
                    tabs[selectedTab].create()
                end

                if not isEventHandlerAdded('onClientClick', root, tabs[selectedTab].click) and tabs[selectedTab].click then
                    addEventHandler('onClientClick', root, tabs[selectedTab].click)
                end
            end


            offset = offset - fontWidth
        end
    end
end

addEvent('itemshop:loadWPLN', true)
addEventHandler('itemshop:loadWPLN', resourceRoot, function(wPLN)
    playerWPLN = wPLN
end)

function scrollUp()
    if scroll.n == scroll.m then return end
    scroll.k = scroll.k-3
    scroll.n = scroll.n-3
end

function scrollDown()
    if not items[selectedTab] then return end
    if scroll.n >= #items[selectedTab] then return end
    scroll.k = scroll.k+3
    scroll.n = scroll.n+3
end

bindKey('mouse_wheel_down', 'down', scrollDown)
bindKey('mouse_wheel_up', 'down', scrollUp)

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler
    selectedTab = 1

    if visible then
        triggerServerEvent('itemshop:loadWPLN', resourceRoot)
    else
        if editbox then
            destroyElement(editbox[1])
            exports['since-gui']:destroyUIElement(editbox[2])
            editbox = nil
        end

        if slider then
            exports['since-scrollbar']:destroyScroll(slider)
            slider = nil
        end

        if uiElements['gridlist'] then
            exports['since-gridlist']:destroyGridList(uiElements['gridlist'])
            uiElements['gridlist'] = nil
        end

        if uiElements['editbox'] then
            exports['since-gui']:destroyUIElement(uiElements['editbox'])
            uiElements['editbox'] = nil
        end

        if uiElements['editTex'] then
            destroyElement(uiElements['editTex'])
            uiElements['editTex'] = nil
        end
    end

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
    
    for i, v in ipairs(tabs) do
        if isEventHandlerAdded('onClientClick', root, v.click) then
            removeEventHandler('onClientClick', root, v.click)
        end
    end

    eventCallback('onClientClick', root, tabs[selectedTab].click)
    buyData = {}
end

local showedMessage = false

bindKey('F7', 'down', function()
    if not getElementData(localPlayer, 'player:spawn') then 
        return 
    end

    -- if getElementData(localPlayer, 'player:sid') ~= 7920 then 
    --     return outputChatBox('✉ #ffffffPanel chwilowo wyłączony.', 255, 175, 0, true)
    -- end

    if not showedMessage then 
        outputChatBox(' ', 255, 175, 0, true)
        outputChatBox('✉ #ffffffWalutę wPLN zakupisz na naszym sklepie, który znajduje się pod linkiem: #2E756Fhttps://sklep.cloudymta.pl/', 255, 175, 0, true)
        outputChatBox(' ', 255, 175, 0, true)
        showedMessage = true
    end
    
    showedModal = false
    toggleUI(not isEventHandlerAdded('onClientRender', root, renderUI))
    showCursor(not isCursorShowing())
end)