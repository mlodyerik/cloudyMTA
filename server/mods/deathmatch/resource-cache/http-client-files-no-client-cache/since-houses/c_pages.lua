pages = {
    [1] = (function(anim)

        dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, main['textures']['mask'], 0,0,0, tocolor(255,255,255,(anim/255)*155))
        if main['data'].owner then 
            dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, exports['since-avatars']:getPlayerAvatar(main['data'].owner), 0,0,0, tocolor(255,255,255,(anim/255)*155)) 
        else
            dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, main['textures']['avatar_frame'], 0,0,0, tocolor(255,255,255,(anim/255)*155))
            dxDrawText('?', sx/2-68/zoom, sy/2-215/zoom, sx/2-68/zoom+136/zoom, sy/2-215/zoom+136/zoom, tocolor(255,255,255,anim), 1, main['fonts'][3], 'center', 'center')
        end

        dxDrawText('Własciciel', sx/2, sy/2-60/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][3], 'center', 'center')
        dxDrawText('Brak', sx/2-2/zoom, sy/2-35/zoom, _, _, tocolor(207,151,146,anim), 1, main['fonts'][4], 'center', 'center')

        dxDrawText('Informacje o nieruchomości', sx/2, sy/2-5/zoom, _, _, tocolor(205,205,205,anim), 1, main['fonts'][3], 'center', 'center')
        dxDrawText('Wielkość', sx/2-140/zoom, sy/2+25/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Maks. liczba lokatorów', sx/2-140/zoom, sy/2+45/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Wynajem - 24h', sx/2-140/zoom, sy/2+65/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Wartość', sx/2-140/zoom, sy/2+85/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')

        dxDrawText(types[main['data'].type].size, sx/2+140/zoom, sy/2+25/zoom, _, _, tocolor(235,235,235,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(types[main['data'].type].locators, sx/2+140/zoom, sy/2+45/zoom, _, _, tocolor(116,154,206,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(formatNumber(main['data'].cost)..'$', sx/2+140/zoom, sy/2+65/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(formatNumber(main['data'].value)..'$', sx/2+140/zoom, sy/2+85/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')

        dxDrawText('Wynajem nieruchomości', sx/2, sy/2+145/zoom, _, _, tocolor(200,200,200,anim), 1, main['fonts'][4], 'center', 'bottom')  
        --dxDrawRectangle(sx/2-200/zoom, sy/2+150/zoom, 400/zoom, 2/zoom, tocolor(102, 102, 102,(anim/255)*155))

        dxDrawImage(sx/2-50/zoom, sy/2+160/zoom, 100/zoom, 30/zoom, main['textures']['days_bg'], 0,0,0, tocolor(255,255,255,anim))

        if isMouseIn(sx/2-50/zoom, sy/2+160/zoom, 30/zoom, 30/zoom) then
            dxDrawText('-', sx/2-50/zoom, sy/2+160/zoom, sx/2-50/zoom+30/zoom, sy/2+160/zoom+30/zoom, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'center')  
        else
            dxDrawText('-', sx/2-50/zoom, sy/2+160/zoom, sx/2-50/zoom+30/zoom, sy/2+160/zoom+30/zoom, tocolor(155,155,155,anim), 1, main['fonts'][1], 'center', 'center')  
        end
        dxDrawText(main['days'], sx/2-50/zoom, sy/2+160/zoom, sx/2-50/zoom+100/zoom, sy/2+160/zoom+30/zoom, tocolor(200,200,200,anim), 1, main['fonts'][1], 'center', 'center')  
        if isMouseIn(sx/2+20/zoom, sy/2+160/zoom, 30/zoom, 30/zoom) then
            dxDrawText('+', sx/2+20/zoom, sy/2+160/zoom, sx/2+20/zoom+30/zoom, sy/2+160/zoom+30/zoom, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'center')  
        else
            dxDrawText('+', sx/2+20/zoom, sy/2+160/zoom, sx/2+20/zoom+30/zoom, sy/2+160/zoom+30/zoom, tocolor(155,155,155,anim), 1, main['fonts'][1], 'center', 'center')  
        end

        dxDrawText('Koszt wynajmu', sx/2-110/zoom, sy/2+210/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText(formatNumber(main['cost'])..'$', sx/2+110/zoom, sy/2+210/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')  

        local isIn = isMouseIn(sx/2-115/zoom, sy/2+230/zoom, 230/zoom, 36/zoom)
        main['anim'][5] = interpolateBetween(main['anim'][5], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-115/zoom, sy/2+230/zoom, 230/zoom, 36/zoom, main['textures']['button_3'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
        dxDrawImage(sx/2-103/zoom, sy/2+235/zoom, 26/zoom, 26/zoom, main['textures']['hh_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
        dxDrawText('Zakup nieruchomość', sx/2-70/zoom, sy/2+230/zoom, sx/2-50/zoom+160/zoom, sy/2+230/zoom+36/zoom, tocolor(255,255,255,anim*main['anim'][5]), 1, main['fonts'][1], 'left', 'center')

    end),
    [2] = (function(anim)

        dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, main['textures']['mask'], 0,0,0, tocolor(255,255,255,(anim/255)*155))
        if main['data'].owner then 
            dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, exports['since-avatars']:getPlayerAvatar(main['data'].owner), 0,0,0, tocolor(255,255,255,anim)) 
        else
            dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, main['textures']['mask'], 0,0,0, tocolor(255,255,255,(anim/255)*155))
            dxDrawImage(sx/2-68/zoom, sy/2-215/zoom, 136/zoom, 136/zoom, main['textures']['avatar_frame'], 0,0,0, tocolor(255,255,255,(anim/255)*155))
            dxDrawText('?', sx/2-68/zoom, sy/2-215/zoom, sx/2-68/zoom+136/zoom, sy/2-215/zoom+136/zoom, tocolor(255,255,255,anim), 1, main['fonts'][3], 'center', 'center')
        end

        dxDrawText('Własciciel', sx/2, sy/2-60/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][3], 'center', 'center')
        local text = main['data'].ownerNick or '---'
        dxDrawText(text, sx/2-2/zoom, sy/2-35/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][4], 'center', 'center')
        dxDrawImage(sx/2+3/zoom+dxGetTextWidth(text, 1, main['fonts'][4])/2, sy/2-40/zoom, 10/zoom, 10/zoom, main['textures']['circle_icon'], 0,0,0, isPlayerOnline(main['data'].owner) and tocolor(124,209,121,anim) or tocolor(218,36,36,anim))
        
        dxDrawText('Informacje o nieruchomości', sx/2, sy/2-5/zoom, _, _, tocolor(205,205,205,anim), 1, main['fonts'][3], 'center', 'center')
        dxDrawText('Wielkość', sx/2-140/zoom, sy/2+25/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Maks. liczba lokatorów', sx/2-140/zoom, sy/2+45/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Wynajem - 24h', sx/2-140/zoom, sy/2+65/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Wartość', sx/2-140/zoom, sy/2+85/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Data końca wynajmu', sx/2-140/zoom, sy/2+105/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText('Garaż', sx/2-140/zoom, sy/2+125/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')

        dxDrawText(types[main['data'].type].size, sx/2+140/zoom, sy/2+25/zoom, _, _, tocolor(235,235,235,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(types[main['data'].type].locators, sx/2+140/zoom, sy/2+45/zoom, _, _, tocolor(116,154,206,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(formatNumber(main['data'].cost)..'$', sx/2+140/zoom, sy/2+65/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(formatNumber(main['data'].value)..'$', sx/2+140/zoom, sy/2+85/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(main['data'].date, sx/2+140/zoom, sy/2+105/zoom, _, _, tocolor(108,191,205,anim), 1, main['fonts'][4], 'right', 'center')
        dxDrawText(main['data'].garage and 'Posiada' or 'Brak', sx/2+140/zoom, sy/2+125/zoom, _, _, tocolor(207,151,146,anim), 1, main['fonts'][4], 'right', 'center')  

        local isIn = isMouseIn(sx/2-140/zoom, sy/2+150/zoom, 280/zoom, 36/zoom)
        main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-140/zoom, sy/2+150/zoom, 280/zoom, 36/zoom, main['textures']['button_1'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawImage(sx/2-127/zoom, sy/2+155/zoom, 26/zoom, 26/zoom, main['textures']['settings_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawText('Zarządzaj nieruchomością', sx/2-94/zoom, sy/2+150/zoom, sx/2-95/zoom+240/zoom, sy/2+150/zoom+36/zoom, tocolor(255,255,255,anim*main['anim'][4]), 1, main['fonts'][1], 'left', 'center')

        local isIn = isMouseIn(sx/2-100/zoom, sy/2+195/zoom, 200/zoom, 36/zoom)
        main['anim'][5] = interpolateBetween(main['anim'][5], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-100/zoom, sy/2+195/zoom, 200/zoom, 36/zoom, main['textures']['button_2'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
        dxDrawImage(sx/2-85/zoom, sy/2+200/zoom, 26/zoom, 26/zoom, main['textures']['enter_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
        dxDrawText('Wejdź do środka', sx/2-52/zoom, sy/2+195/zoom, sx/2-50/zoom+160/zoom, sy/2+195/zoom+36/zoom, tocolor(255,255,255,anim*main['anim'][5]), 1, main['fonts'][1], 'left', 'center')

    end),
    [3] = (function(anim)
        
        dxDrawText('Zarządzanie nieruchomością', sx/2, sy/2-225/zoom, _, _, tocolor(205,205,205,anim), 1, main['fonts'][3], 'center', 'center')

        dxDrawText('Współlokatorzy', sx/2, sy/2-190/zoom, _, _, tocolor(205,205,205,anim), 1, main['fonts'][4], 'center', 'bottom')
        --dxDrawRectangle(sx/2-200/zoom,sy/2-188/zoom,400/zoom, 3/zoom, tocolor(102,102,102,anim))
        dxDrawImage(sx/2-195/zoom, sy/2-185/zoom, 390/zoom, 140/zoom, main['textures']['locators_bg'], 0,0,0, tocolor(255,255,255,anim))

        local x = 0
        for i,v in ipairs(main['data'].locators) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                x=x+1
                local offset = ((45/zoom)*(x-1))
                dxDrawImage(sx/2-190/zoom, sy/2-180/zoom+offset, 370/zoom, 40/zoom, main['textures']['locators_bar'], 0,0,0, tocolor(255,255,255,anim))

                dxDrawImage(sx/2-185/zoom, sy/2-175/zoom+offset, 30/zoom, 30/zoom, main['textures']['mask'], 0,0,0, tocolor(255,255,255,(anim/255)*155))

                dxDrawImage(sx/2-185/zoom, sy/2-175/zoom+offset, 30/zoom, 30/zoom, exports['since-avatars']:getPlayerAvatar(v.uid), 0,0,0, tocolor(255,255,255,anim))

                local text = '['..v.uid..'] '..v.nick
                dxDrawText(text, sx/2-145/zoom, sy/2-160/zoom+offset, _, _, tocolor(205,205,205,anim), 1, main['fonts'][1], 'left', 'center')
                dxDrawImage(sx/2-140/zoom+dxGetTextWidth(text, 1, main['fonts'][1]), sy/2-165/zoom+offset, 10/zoom, 10/zoom, main['textures']['circle_icon'], 0,0,0, isPlayerOnline(v.uid) and tocolor(124,209,121,anim) or tocolor(218,36,36,anim))

                local isIn = isMouseIn(sx/2+150/zoom, sy/2-170/zoom+offset, 20/zoom, 20/zoom)
                dxDrawImage(sx/2+150/zoom, sy/2-170/zoom+offset, 20/zoom, 20/zoom, main['textures']['close_icon'], 0,0,0, tocolor(255,255,255,((pageChanger or turning) and (anim/255)*155) or (isIn and (anim/255)*195) or 155))

            end
        end
        renderScroll(main['data'].locators, sx/2+185/zoom, sy/2-180/zoom, 130/zoom, main['scroll'][3], main['scroll'][1], anim/255)
        
        local isIn = isMouseIn(sx/2-115/zoom, sy/2+5/zoom, 230/zoom, 36/zoom)
        main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-115/zoom, sy/2+5/zoom, 230/zoom, 36/zoom, main['textures']['button_3'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawImage(sx/2-103/zoom, sy/2+10/zoom, 26/zoom, 26/zoom, main['textures']['person_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawText('Dodaj współlokatora', sx/2-70/zoom, sy/2+5/zoom, sx/2-50/zoom+160/zoom, sy/2+5/zoom+36/zoom, tocolor(255,255,255,anim*main['anim'][4]), 1, main['fonts'][1], 'left', 'center')

        dxDrawText('Opłata wynajmu', sx/2, sy/2+75/zoom, _, _, tocolor(205,205,205,anim), 1, main['fonts'][4], 'center', 'bottom')
        --dxDrawRectangle(sx/2-200/zoom,sy/2+70/zoom,400/zoom, 3/zoom, tocolor(102,102,102,anim))

        dxDrawImage(sx/2-50/zoom, sy/2+80/zoom, 100/zoom, 30/zoom, main['textures']['days_bg'], 0,0,0, tocolor(255,255,255,anim))

        if isMouseIn(sx/2-50/zoom, sy/2+80/zoom, 30/zoom, 30/zoom) then
            dxDrawText('-', sx/2-50/zoom, sy/2+80/zoom, sx/2-50/zoom+30/zoom, sy/2+80/zoom+30/zoom, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'center')  
        else
            dxDrawText('-', sx/2-50/zoom, sy/2+80/zoom, sx/2-50/zoom+30/zoom, sy/2+80/zoom+30/zoom, tocolor(155,155,155,anim), 1, main['fonts'][1], 'center', 'center')  
        end
        dxDrawText(main['days'], sx/2-50/zoom, sy/2+80/zoom, sx/2-50/zoom+100/zoom, sy/2+80/zoom+30/zoom, tocolor(200,200,200,anim), 1, main['fonts'][1], 'center', 'center')  
        if isMouseIn(sx/2+20/zoom, sy/2+80/zoom, 30/zoom, 30/zoom) then
            dxDrawText('+', sx/2+20/zoom, sy/2+80/zoom, sx/2+20/zoom+30/zoom, sy/2+80/zoom+30/zoom, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'center')  
        else
            dxDrawText('+', sx/2+20/zoom, sy/2+80/zoom, sx/2+20/zoom+30/zoom, sy/2+80/zoom+30/zoom, tocolor(155,155,155,anim), 1, main['fonts'][1], 'center', 'center')  
        end

        local isIn = isMouseIn(sx/2-115/zoom, sy/2+115/zoom, 230/zoom, 36/zoom)
        main['anim'][5] = interpolateBetween(main['anim'][5], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-115/zoom, sy/2+115/zoom, 230/zoom, 36/zoom, main['textures']['button_3'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
        dxDrawImage(sx/2-103/zoom, sy/2+120/zoom, 26/zoom, 26/zoom, main['textures']['hh_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
        dxDrawText('Opłać nieruchomość', sx/2-70/zoom, sy/2+115/zoom, sx/2-50/zoom+160/zoom, sy/2+115/zoom+36/zoom, tocolor(255,255,255,anim*main['anim'][5]), 1, main['fonts'][1], 'left', 'center')

        dxDrawText('Koszt wynajmu', sx/2-110/zoom, sy/2+170/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText(formatNumber(main['cost'])..'$', sx/2+110/zoom, sy/2+170/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')  

        dxDrawText('Wynajem - 24h', sx/2-110/zoom, sy/2+190/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText(formatNumber(main['data'].cost)..'$', sx/2+110/zoom, sy/2+190/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')  

        dxDrawText('Wynajem do', sx/2-110/zoom, sy/2+210/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        dxDrawText(main['data'].date, sx/2+110/zoom, sy/2+210/zoom, _, _, tocolor(124,209,121,anim), 1, main['fonts'][4], 'right', 'center')  

        dxDrawText('Zwolnienie wynajmu', sx/2, sy/2+250/zoom, _, _, tocolor(205,205,205,anim), 1, main['fonts'][4], 'center', 'bottom')
        --dxDrawRectangle(sx/2-200/zoom,sy/2+245/zoom,400/zoom, 3/zoom, tocolor(102,102,102,anim))

        local isIn = isMouseIn(sx/2-115/zoom, sy/2+255/zoom, 230/zoom, 36/zoom)
        main['anim'][6] = interpolateBetween(main['anim'][6], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-100/zoom, sy/2+255/zoom, 200/zoom, 36/zoom, main['textures']['button_2'], 0,0,0, tocolor(255,255,255,anim*main['anim'][6]))
        dxDrawImage(sx/2-85/zoom, sy/2+260/zoom, 26/zoom, 26/zoom, main['textures']['hh_icon'], 0,0,0, tocolor(255,255,255,anim*main['anim'][6]))
        dxDrawText('Zwolnij wynajem', sx/2-52/zoom, sy/2+255/zoom, sx/2-52/zoom+160/zoom, sy/2+255/zoom+36/zoom, tocolor(255,255,255,anim*main['anim'][6]), 1, main['fonts'][1], 'left', 'center')

    end),
}
getResourceName(getThisResource(), true, 937442035); if true then return end