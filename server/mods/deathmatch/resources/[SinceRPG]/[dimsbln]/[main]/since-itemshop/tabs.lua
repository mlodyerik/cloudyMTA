local tabX = 0
local tabW = 0  

tabs = {


    {

        name = 'Pojazdy',
        draw = function()
            local offsetX = 0
            local offsetY = 0
            local spacingX = 302/zoom
            local spacingY = 256/zoom

            for i, v in ipairs(items[1]) do
                if not onItem[i] then 
                    onItem[i] = 0.75
                end

                if i >= scroll.k and i <= scroll.n then 
                    local isIn = isMouseInPosition(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 236/zoom)

                    if isIn then 
                        onItem[i] = math.min(1, onItem[i] + 0.01)
                    else 
                        onItem[i] = math.max(0.75, onItem[i] - 0.01)
                    end
                    
                    dxDrawImage(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 236/zoom, 'data/item_bg.png', 0, 0, 0, tocolor(255, 255, 255, onItem[i] * 255))
                    dxDrawImage(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 128/zoom, v.image)
                    dxDrawText(v.name, sx/2 - 300/zoom + offsetX, sy/2 - 41/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
                    dxDrawText(v.price .. ' wPLN', sx/2 - 301/zoom + offsetX, sy/2 - 41/zoom + offsetY, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')

                    local isIn = isMouseInPosition(sx/2 - 375/zoom + offsetX, sy/2 - 11/zoom + offsetY, 148/zoom, 29/zoom)
                    dxDrawImage(sx/2 - 375/zoom + offsetX, sy/2 - 11/zoom + offsetY, 148/zoom, 29/zoom, 'data/buy_button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 175))
                    dxDrawText('Zakup', sx/2 - 301/zoom + offsetX, sy/2 + 3.5/zoom + offsetY, nil, nil, tocolor(255, 255, 255, isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center')

                    offsetX = offsetX + spacingX

                    if i % 3 == 0 then
                        offsetX = 0
                        offsetY = offsetY + spacingY
                    end
                end
            end

            drawScrollbar(items[1], sx/2 + 445/zoom, sy/2 - 199/zoom, 4/zoom, 490/zoom, scroll.m, scroll.k, 255, 3)
        end,

        click = function(btn, state)
            if btn == 'left' and state == 'down' then

                if showedModal then
                    local isMouseOnBuy = isMouseInPosition(sx/2 - 101/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom)
                    local isMouseOnCancel = isMouseInPosition(sx/2 + 3/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom)

                    if isMouseOnBuy then 
                        triggerServerEvent('itemshop:buy', resourceRoot, 'vehicle', modalData.id)
                        showedModal = false
                    elseif isMouseOnCancel then
                        showedModal = false
                    end
                else
                    local offsetX = 0
                    local offsetY = 0
                    local spacingX = 302/zoom
                    local spacingY = 256/zoom
    
                    for i, v in ipairs(items[1]) do
                        if i >= scroll.k and i <= scroll.n then 
                            local isIn = isMouseInPosition(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 236/zoom)
    
                            if isIn then 
                                local isIn = isMouseInPosition(sx/2 - 375/zoom + offsetX, sy/2 - 11/zoom + offsetY, 148/zoom, 29/zoom)
    
                                if isIn then 
                                    if not showedModal then
                                        showedModal = true
                                        modalData = {
                                            type = 'vehicle',
                                            id = i,
                                            vehModel = v.model,
                                            vehName = v.name,
                                            cost = v.price,
                                            electric = v.electric or false
                                        }
                                    end
                                end
                            end
    
                            offsetX = offsetX + spacingX
    
                            if i % 3 == 0 then
                                offsetX = 0
                                offsetY = offsetY + spacingY
                            end
                        end
                    end
                end
            end
        end,

    },

    {

        name = 'Tuningi',
        draw = function()
            local offsetX = 0
            local offsetY = 0
            local spacingX = 302/zoom
            local spacingY = 256/zoom

            for i,v in ipairs(items[2]) do
                if i >= scroll.k and i <= scroll.n then 
                    if not onItem[i] then 
                        onItem[i] = 0
                    end
                    local isIn = isMouseInPosition(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 180/zoom)

                    if isIn then 
                        onItem[i] = math.min(1, onItem[i] + 0.01)
                    else 
                        onItem[i] = math.max(0.75, onItem[i] - 0.01)
                    end

                    dxDrawImage(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 180/zoom, 'data/item_bg2.png', 0, 0, 0, tocolor(255, 255, 255, onItem[i] * 255))
                    dxDrawText(v.name, sx/2 - 300/zoom + offsetX, sy/2 - 161/zoom + offsetY, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
                    dxDrawText(v.desc, sx/2 - 420/zoom + offsetX, sy/2 - 161/zoom + offsetY, sx/2 - 180/zoom + offsetX, nil, tocolor(145, 163, 160, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, true)
                    dxDrawText(v.price .. ' wPLN', sx/2 - 301/zoom + offsetX, sy/2 - 85/zoom + offsetY, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'bottom')

                    local isIn = isMouseInPosition(sx/2 - 375/zoom + offsetX, sy/2 - 75/zoom + offsetY, 148/zoom, 29/zoom)
                    dxDrawImage(sx/2 - 375/zoom + offsetX, sy/2 - 75/zoom + offsetY, 148/zoom, 29/zoom, 'data/buy_button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 175))
                    dxDrawText('Dodaj do koszyka', sx/2 - 301/zoom + offsetX, sy/2 - 60/zoom + offsetY, nil, nil, tocolor(255, 255, 255, isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center')

                    offsetX = offsetX + spacingX

                    if i % 3 == 0 then
                        offsetX = 0
                        offsetY = offsetY + spacingY
                    end
                end
            end

            drawScrollbar(items[2], sx/2 + 445/zoom, sy/2 - 199/zoom, 4/zoom, 435/zoom, scroll.m, scroll.k, 255, 3)

            dxDrawImage(sx/2 - 479/zoom, sy/2 + 255/zoom, 958/zoom, 2/zoom, 'data/line.png')

            dxDrawText('Przedmioty w koszyku', sx/2 - 161/zoom, sy/2 + 297/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom')
            dxDrawText(#buyData, sx/2 - 161/zoom, sy/2 + 298/zoom, nil, nil, tocolor(145, 163, 160, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'top')
            local textWidth = dxGetTextWidth(#buyData, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom))

            dxDrawImage(sx/2 - 156/zoom + textWidth, sy/2 + 299/zoom, 14/zoom, 14/zoom, 'data/icon.png')
            local isIn = isMouseInPosition(sx/2 - 156/zoom + textWidth, sy/2 + 299/zoom, 14/zoom, 14/zoom)

            if isIn and #buyData > 0 then 
                local cx, cy = getCursorPosition()
                local x, y = cx*sx, cy*sy

                
                local offset = #buyData * 26/zoom
                dxDrawRoundedRectangle(x + 10/zoom, y + 10/zoom, 300/zoom, 16/zoom + offset, 10/zoom, tocolor(65, 65, 65, 255), true)

                local offset = 0
                for i, v in ipairs(buyData) do
                    dxDrawText(v.name..' do pojazdu ID: '..v.vehicleID..'', x + 20/zoom, y + 20/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'top', false, true, true)
                    offset = offset + 26/zoom
                end
            end

            local money = 0 
            for i, v in ipairs(buyData) do
                money = money + v.price
            end

            local textWidth = dxGetTextWidth('Przedmioty w koszyku', 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom))
            dxDrawText('Do zapłaty', sx/2 - 141/zoom + textWidth, sy/2 + 297/zoom , nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom')
            dxDrawText(money..' wPLN', sx/2 - 141/zoom + textWidth, sy/2 + 298/zoom, nil, nil, tocolor(145, 163, 160, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'top')

            local isIn = isMouseInPosition(sx/2 + 295/zoom, sy/2 + 275/zoom, 155/zoom, 40/zoom)
            dxDrawImage(sx/2 + 300/zoom, sy/2 + 305/zoom, 145/zoom, 2/zoom, 'data/line2.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 175))
            dxDrawText('Zatwierdź zakup', sx/2 + 300/zoom + 145/2/zoom, sy/2 + 302/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 13/zoom), 'center', 'bottom')

        end,

        click = function(btn, state)
            if btn == 'left' and state == 'down' then

                if showedModal then
                    local isMouseOnBuy = isMouseInPosition(sx/2 - 101/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom)
                    local isMouseOnCancel = isMouseInPosition(sx/2 + 3/zoom, sy/2 + 28/zoom, 100/zoom, 30/zoom)

                    if isMouseOnBuy then 
                        triggerServerEvent('itemshop:buy', resourceRoot, 'upgrades', buyData)
                        buyData = {}
                        modalData = {}
                        showedModal = false
                    elseif isMouseOnCancel then
                        showedModal = false
                    end
                else
                    if isMouseInPosition(sx/2 + 295/zoom, sy/2 + 275/zoom, 155/zoom, 40/zoom) then
                        if #buyData == 0 then 
                            exports['since-notifications']:sendNotification('error', 'Nie wybrałeś żadnego przedmiotu.')
                            return
                        end
                        showedModal = true
                        modalData = {itemsCount = #buyData, calculatedCost = getItemsCost(buyData)}
                        return
                    end
                    local offsetX = 0
                    local offsetY = 0
                    local spacingX = 302/zoom
                    local spacingY = 256/zoom
    
                    for i, v in ipairs(items[2]) do
                        if i >= scroll.k and i <= scroll.n then 
                            local isIn = isMouseInPosition(sx/2 - 427/zoom + offsetX, sy/2 - 199/zoom + offsetY, 252/zoom, 180/zoom)
    
                            if isIn then 
                                local isIn = isMouseInPosition(sx/2 - 375/zoom + offsetX, sy/2 - 75/zoom + offsetY, 148/zoom, 29/zoom)
    
                                if isIn then 
                                    local vehicleID = exports['since-gui']:getEditboxText(editbox[2])
                                    if not vehicleID or vehicleID == '' or not tonumber(vehicleID) then 
                                        exports['since-notifications']:sendNotification('error', 'Wprowadź poprawne ID pojazdu.')
                                        return
                                    end
                                    if isTuningItemInBasketOnVehicleID(v.name, vehicleID) then 
                                        exports['since-notifications']:sendNotification('error', 'Już dodałeś ten przedmiot (do danego ID pojazdu) do koszyka.')
                                        return
                                    end
                                    table.insert(buyData, {name = v.name, price = v.price, data = v.data, vehicleID = vehicleID})
                                end
                            end
    
                            offsetX = offsetX + spacingX
    
                            if i % 3 == 0 then
                                offsetX = 0
                                offsetY = offsetY + spacingY
                            end
                        end
                    end
                end
            end
        end,

        create = function()
            if editbox then
                destroyElement(editbox[1])
                exports['since-gui']:destroyUIElement(editbox[2])
                editbox = nil
            end
            editbox = {}
            editbox[1] = dxCreateTexture('data/editbox.png')
            editbox[2] = exports['since-gui']:createEditbox('Wprowadź ID pojazdu...', sx/2 - 461/zoom, sy/2 + 275/zoom, 280/zoom, 44/zoom, {215, 215, 215}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
                image = editbox[1],
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })
        end,

        destroy = function()
            if editbox then
                destroyElement(editbox[1])
                exports['since-gui']:destroyUIElement(editbox[2])
                editbox = nil
            end
        end,

    },

    {

        name = 'Punkty Premium',
        draw = function()
            dxDrawText('Wymiana #68D65EwPLN#ffffff na #FFC634Punkty premium', sx/2, sy/2 - 150/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 20/zoom), 'center', 'bottom', false, false, false, true)
            dxDrawText('Koszt #5EC5FF100 Punktów premium#ffffff wynosi #68D65E20 wPLN', sx/2, sy/2 - 150/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), 'center', 'top', false, false, false, true)

            local value = math.floor( exports['since-scrollbar']:getScrollProgress(slider) / 5 )
            local wPLNcost = value * 20
            local premiumPoints = value * 100
            

            dxDrawText('Wymieniasz #68D65E'..wPLNcost..' wPLN#ffffff na #FFC634'..premiumPoints..' Punktów Premium', sx/2, sy/2 - 50/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), 'center', 'top', false, false, false, true)
        
            -- draw buy button
            local isIn = isMouseInPosition(sx/2 - 100/zoom, sy/2 + 10/zoom, 200/zoom, 40/zoom)
            dxDrawImage(sx/2 - 100/zoom, sy/2 + 10/zoom, 200/zoom, 40/zoom, 'data/buy_button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 175))
            dxDrawText('Wymień', sx/2, sy/2 + 28/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), 'center', 'center')

            dxDrawText('Jak wymienić wPLN na Punkty premium?', sx/2, sy/2 + 120/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom')
            dxDrawText('Za pomocą suwaka, który znajduje się wyżej wybierz ilość wPLN, na którą chcesz wymienić\nPunkty Premium. Przy większych wymianach otrzymasz bonusowe Punkty Premium.', sx/2, sy/2 + 120/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top')
            
            dxDrawText('Uwaga!', sx/2, sy/2 + 225/zoom, nil, nil, tocolor(255, 125, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom')
            dxDrawText('Transakcji nie można cofnąć, administracja nie ponosi odpowiedzialności za omyłkowo\nprzeprowadzoną wymianę wPLN na Punkty Premium', sx/2, sy/2 + 225/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top')
            
        end,

        click = function(btn, state)
            if btn == 'left' and state == 'down' then
                if isMouseInPosition(sx/2 - 100/zoom, sy/2 + 10/zoom, 200/zoom, 40/zoom) then
                    local value = math.floor( exports['since-scrollbar']:getScrollProgress(slider) / 5 )
                    local wPLNcost = value * 20
                    local premiumPoints = value * 100

                    if wPLNcost == 0 then
                        return
                    end

                    if premiumPoints == 0 then
                        return
                    end

                    triggerServerEvent('itemshop:buy', resourceRoot, 'premium', value)
                end
            end
        end,

        create = function()
            if slider then
                exports['since-scrollbar']:destroyScroll(slider)
                slider = nil
            end

            if not slider then
                slider = exports['since-scrollbar']:createScrollbar(sx/2 - 400/zoom, sy/2 - 100/zoom, 800/zoom, 12/zoom, {255, 255, 255}, true, 0)
            end
        end,

        destroy = function()
            if slider then
                exports['since-scrollbar']:destroyScroll(slider)
                slider = nil
            end
        end,

    },

    {

        name = "Zakupy SMS'em",
        draw = function()
            dxDrawText('Itemshop SMS', sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 52/zoom + 33/zoom, nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'bottom')
            dxDrawText('Zakup wPLN wysyłając SMS!', sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 52/zoom + 33/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'top')

            dxDrawText('Informacja', sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 52/zoom + 153/zoom, nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'bottom')
            
            if (exports['since-gridlist']:getSelectedItem(uiElements['gridlist']) ~= 'Brak') then
                dxDrawText('Aby zakupić #68D65E'..getData().wpln..' wPLN#ffffff, wyślij SMS o treści #68D65E'..getData().code..' #ffffffna numer #68D65E'..getData().number..'#ffffff.', sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 52/zoom + 153/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'top', false, false, false, true)
            else
                dxDrawText('Wybierz usługę z listy...', sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 52/zoom + 153/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'top')
            end

            local isin = isMouseInPosition(sx/2 - 500/zoom + 25/zoom + 249/zoom + 10/zoom, sy/2 - 250/zoom + 47/zoom + 195/zoom + 44/zoom/2 - 38/zoom/2, 118/zoom, 38/zoom)
            dxDrawImage(sx/2 - 500/zoom + 25/zoom + 249/zoom + 10/zoom, sy/2 - 250/zoom + 47/zoom + 195/zoom + 44/zoom/2 - 38/zoom/2, 118/zoom, 38/zoom, 'data/buy_button.png', 0, 0, 0, tocolor(255, 255, 255, isin and 255 or 175))
            dxDrawText('Sprawdź kod', sx/2 - 500/zoom + 25/zoom + 249/zoom + 10/zoom + 118/zoom/2, sy/2 - 250/zoom + 47/zoom + 195/zoom + 44/zoom/2 - 38/zoom/2 + 38/zoom/2, nil, nil, tocolor(255, 255, 255, isIn and 225 or 200), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')

            dxDrawRectangle(sx/2 - 400/zoom, sy/2 + 80/zoom, 800/zoom, 2, tocolor(255, 255, 255, 55))
            dxDrawText('Regulamin płatności', sx/2, sy/2 - 250/zoom + 95/zoom + 255/zoom + 30/zoom, nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
            dxDrawText('Nasz regulamin płantości znajdziesz na naszym forum internetowym, które\nznajdziesz pod adresem: #68D65Ehttps://since-mta.pl/', sx/2, sy/2 - 250/zoom + 95/zoom + 255/zoom + 30/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top', false, false, false, true)
    
            local isin = isMouseInPosition(sx/2 - 100/zoom, sy/2 + 200/zoom, 200/zoom, 40/zoom)
            dxDrawImage(sx/2 - 100/zoom, sy/2 + 200/zoom, 200/zoom, 40/zoom, 'data/buy_button.png', 0, 0, 0, tocolor(255, 255, 255, isin and 255 or 175))
            dxDrawText('Skopiuj link', sx/2, sy/2 + 220/zoom, nil, nil, tocolor(255, 255, 255, isIn and 225 or 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')
        end,

        click = function(btn, state)
            if btn == 'left' and state == 'down' then
                if isMouseInPosition(sx/2 - 100/zoom, sy/2 + 200/zoom, 200/zoom, 40/zoom) then
                    setClipboard('https://since-mta.pl/')
                    exports['since-notifications']:sendNotification('success', 'Skopiowano link do forum.')
                end

                if isMouseInPosition(sx/2 - 500/zoom + 25/zoom + 249/zoom + 10/zoom, sy/2 - 250/zoom + 47/zoom + 195/zoom + 44/zoom/2 - 38/zoom/2, 118/zoom, 38/zoom) then
                    local selected = getData()
                    if (selected) then
                        triggerServerEvent('onClientTryToBuyPremium', resourceRoot, selected, exports['since-gui']:getEditboxText(uiElements['editbox']))
                    else
                        exports['since-notifications']:sendNotification('error', 'Wybierz usługę z listy.')
                    end
                end
            end
        end,

        create = function()
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

            uiElements['editTex'] = dxCreateTexture('data/editbox.png')
            uiElements['gridlist'] = exports['since-gridlist']:createGridList(sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 47/zoom + 53/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom)), 200/zoom, 'Wybierz usługę z listy...', 3, smsItems)
            uiElements['editbox'] = exports['since-gui']:createEditbox('Wprowadź otrzymany kod...', sx/2 - 500/zoom + 25/zoom, sy/2 - 250/zoom + 47/zoom + 195/zoom, 249/zoom, 44/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
                image = uiElements['editTex'],
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })
        end,

        destroy = function()
            if uiElements['editTex'] then
                destroyElement(uiElements['editTex'])
                uiElements['editTex'] = nil
            end

            if uiElements['gridlist'] then
                exports['since-gridlist']:destroyGridList(uiElements['gridlist'])
                uiElements['gridlist'] = nil
            end

            if uiElements['editbox'] then
                exports['since-gui']:destroyUIElement(uiElements['editbox'])
                uiElements['editbox'] = nil
            end
        end,

    },

}

addEventHandler('onClientResourceStop', resourceRoot, function()
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
end)

function isTuningItemInBasketOnVehicleID(name, vehicleID)
    for i, v in ipairs(buyData) do
        if v.name == name and v.vehicleID == vehicleID then 
            return true
        end
    end
    return false
end

function getItemsCost(data)
    local cost = 0
    for i, v in ipairs(data) do
        cost = cost + v.price
    end
    return cost
end