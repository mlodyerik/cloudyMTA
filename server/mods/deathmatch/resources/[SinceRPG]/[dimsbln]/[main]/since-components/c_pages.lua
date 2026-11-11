components = {
    { text = 'Kolor podstawowy', desc = 'Zmień podstawowy kolor pojazdu', icon = 'paint_icon', cost = 25000, anim = 0.7, page = 1, data = 'podstawowy' },
    { text = 'Kolor dodatkowy', desc = 'Zmień dodatkowy kolor pojazdu', icon = 'paint_icon', cost = 15000, anim = 0.7, page = 1, data = 'dodatkowy' },
    { text = 'Kolor felg', desc = 'Zmień kolor felg w pojeździe', icon = 'paint_icon', cost = 150000, anim = 0.7, page = 1, data = 'felgi' },
    { text = 'Kolor rantów', desc = 'Zmień kolor rantów felg', icon = 'paint_icon', cost = 65000, anim = 0.7, page = 1, data = 'ranty' },
    { text = 'Kolor tarcz', desc = 'Zmień kolor tarcz hamulcowych', icon = 'paint_icon', cost = 65000, anim = 0.7, page = 1, data = 'tarcze' },
    { text = 'Kolor lamp', desc = 'Zmień kolor lamp w pojeździe', icon = 'paint_icon', cost = 2500000, anim = 0.7, page = 1, data = 'lampy' },
    { text = 'Kolor szyb', desc = 'Zmień kolor szyb w pojeździe', icon = 'paint_icon', cost = 3000000, anim = 0.7, page = 1, data = 'szyby' },
    { text = 'Kolor dymu spod opon', desc = 'Zmień kolor dymu spod opon (Lewa strona)', icon = 'smoke_icon', cost = 150000, anim = 0.7, page = 1, data = 'dym_lewy' },
    { text = 'Kolor dymu spod opon', desc = 'Zmień kolor dymu spod opon (Prawa strona)', icon = 'smoke_icon', cost = 150000, anim = 0.7, page = 1, data = 'dym_prawy' },
    --{ text = 'Kolor dymu spod opon', desc = 'Zmień kolor dymu spod opon', icon = 'smoke_icon', cost = 5000000, anim = 0.7, page = 1, data = 'dym' },
    { text = 'Motyw licznika', desc = 'Zmień motyw licznika', icon = 'speedo_icon', cost = 4500000, anim = 0.7, page = 2, data = 'motyw' },
    { text = 'Klucze', desc = 'Dorabianie kluczy do pojazdu', icon = 'keys', cost = nil, anim = 0.7, page = 3, data = 'keys' },
}

iconsSizes = {
    ['paint_icon'] = {46/zoom, 46/zoom},
    ['smoke_icon'] = {66/zoom, 48/zoom},
    ['speedo_icon'] = {46/zoom, 46/zoom},
    ['keys'] = {46/zoom, 46/zoom},
}

colors = {
    {167, 226, 212},
    {181, 121, 161},
    {29, 30, 35},
    {39, 83, 135},
    {181, 242, 138},
    {221, 210, 150},
    {30, 11, 29},
    {33, 37, 38},
    {42, 51, 41},
    {50, 196, 229},
    {50, 46, 51},
    {66, 55, 50},
    {106, 140, 128},
    {33, 31, 0},
    {12, 10, 10},
    {53, 43, 32},
}

speedoPatterns = {
    { id = 1, anim = {0.7,0.7} },
    { id = 2, anim = {0.7,0.7} },
}

speedoClicked = nil

function getVehicleKeys(veh)
    local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}

    if vehicleUpgrades['keys'] then
        return tonumber(vehicleUpgrades['keys'])
    else
        return 1
    end
end

pages = {
    [0] = (function(anim)

        local x = 0
        for i,v in ipairs(components) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                x=x+1
                local offset = ((75/zoom)*(x-1))
                dxDrawImage(sx/2-320/zoom, sy/2-125/zoom+offset, 640/zoom, 68/zoom, main['textures']['bg2'], 0,0,0, tocolor(255,255,255,anim))
                dxDrawImage(sx/2-277/zoom-iconsSizes[v.icon][1]/2, sy/2-91/zoom-iconsSizes[v.icon][2]/2+offset, iconsSizes[v.icon][1], iconsSizes[v.icon][2], main['textures'][v.icon], 0,0,0, tocolor(255,255,255,anim))

                dxDrawText(v.text, sx/2-235/zoom, sy/2-112/zoom+offset, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'top')
                
                if v.cost then
                    dxDrawText(v.desc..' #68D65E($'..formatNumber(v.cost)..')', sx/2-235/zoom, sy/2-119/zoom+48/zoom+offset, _, _, tocolor(255,255,255,anim), 1, main['fonts'][2], 'left', 'bottom', false,false,false,true)        
                else
                    dxDrawText(v.desc..'', sx/2-235/zoom, sy/2-119/zoom+48/zoom+offset, _, _, tocolor(255,255,255,anim), 1, main['fonts'][2], 'left', 'bottom', false,false,false,true)        
                end

                local isIn = isMouseIn(sx/2+180/zoom, sy/2-106/zoom+offset, 120/zoom, 30/zoom)
                v.anim = interpolateBetween(v.anim, 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
                dxDrawImage(sx/2+180/zoom, sy/2-106/zoom+offset, 120/zoom, 30/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,anim*v.anim))
                dxDrawText('Wybierz', sx/2+180/zoom, sy/2-106/zoom+offset, sx/2+180/zoom+120/zoom, sy/2-106/zoom+offset+30/zoom, tocolor(255,255,255,anim*v.anim), 1, main['fonts'][3], 'center', 'center')
            end
        end

    end),
    [1] = (function(anim)

        local isIn = isMouseIn(sx/2-72/zoom, sy/2-25/zoom, 144/zoom, 30/zoom)
        main['anim'][3] = interpolateBetween(main['anim'][3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-72/zoom, sy/2-25/zoom, 144/zoom, 30/zoom, main['textures']['button_2'], 0,0,0, tocolor(255,255,255,anim*main['anim'][3]))
        dxDrawText('Lakieruj', sx/2-72/zoom, sy/2-25/zoom, sx/2-72/zoom+144/zoom, sy/2-25/zoom+30/zoom, tocolor(255,255,255,anim*main['anim'][3]), 1, main['fonts'][4], 'center', 'center')

        local isIn = isMouseIn(sx/2-72/zoom, sy/2+10/zoom, 144/zoom, 30/zoom)
        main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2-72/zoom, sy/2+10/zoom, 144/zoom, 30/zoom, main['textures']['button_1'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawText('Anuluj', sx/2-72/zoom, sy/2+10/zoom, sx/2-72/zoom+144/zoom, sy/2+10/zoom+30/zoom, tocolor(255,255,255,anim*main['anim'][4]), 1, main['fonts'][4], 'center', 'center')

        dxDrawImage(sx/2-320/zoom, sy/2+95/zoom, 235/zoom, 35/zoom, main['textures']['color_info'], 0,0,0, tocolor(255,255,255,anim))
        dxDrawText('RGB', sx/2-310/zoom, sy/2+95/zoom, sx/2-310/zoom+235/zoom, sy/2+95/zoom+35/zoom, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        local r,g,b = pickerData["color"][1], pickerData["color"][2], pickerData["color"][3]
        local text = r..', '..g..', '..b
        local textWidth = dxGetTextWidth(text, 1, main['fonts'][5])
        dxDrawText(text, sx/2-330/zoom, sy/2+95/zoom, sx/2-330/zoom+235/zoom, sy/2+95/zoom+35/zoom, tocolor(255,255,255,anim), 1, main['fonts'][5], 'right', 'center')
        dxDrawImage(sx/2-113/zoom-textWidth,sy/2+104/zoom,14/zoom,14/zoom,main['textures']['color_rect'], 0,0,0, tocolor(r,g,b,anim))

        dxDrawImage(sx/2-320/zoom, sy/2+135/zoom, 235/zoom, 35/zoom, main['textures']['color_info'], 0,0,0, tocolor(255,255,255,anim))
        dxDrawText('HEX', sx/2-310/zoom, sy/2+135/zoom, sx/2-310/zoom+235/zoom, sy/2+135/zoom+35/zoom, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'center')
        local text = RGBToHex(r,g,b)
        local textWidth = dxGetTextWidth(text, 1, main['fonts'][5])
        dxDrawText(text, sx/2-330/zoom, sy/2+135/zoom, sx/2-330/zoom+235/zoom, sy/2+135/zoom+35/zoom, tocolor(255,255,255,anim), 1, main['fonts'][5], 'right', 'center')
        dxDrawImage(sx/2-112/zoom-textWidth,sy/2+145/zoom,14/zoom,14/zoom,main['textures']['color_rect'], 0,0,0, tocolor(r,g,b,anim))

        dxDrawImage(sx/2+82/zoom, sy/2-125/zoom, 235/zoom, 245/zoom, main['textures']['color_list'], 0,0,0, tocolor(255,255,255,anim))
        dxDrawText('Proponowane kolory', sx/2+200/zoom, sy/2-120/zoom, _, _, tocolor(215,215,215,anim), 1, main['fonts'][4], 'center', 'top')

        local x,y = sx/2+99/zoom, sy/2-94/zoom
        for i=1,16 do
            local r,g,b = 255,255,255
            if colors[i] then
                r,g,b = unpack(colors[i])
            end

            local isIn = isMouseIn(x, y, 44/zoom, 44/zoom)
            dxDrawImage(x, y, 44/zoom, 44/zoom, main['textures']['color_fill'], 0,0,0, tocolor(r,g,b,isIn and anim*0.75 or anim*0.95))

            x = x + 52/zoom
            if x > (sx/2+99/zoom+((52/zoom)*3.9)) then
                x = sx/2+99/zoom
                y = y + 52/zoom
            end
        end

        dxDrawText('Koszt lakierowania pojazdu', sx/2+317/zoom, sy/2+127/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][5], 'right', 'top')

        dxDrawText('#68d65e$ #FFFFFF'..formatNumber(components[main['chosedComponent']].cost), sx/2+317/zoom, sy/2+147/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][6], 'right', 'top', false,false,false,true)
        
    end),
    [2] = (function(anim)

        local isIn = isMouseIn(sx/2+137/zoom, sy/2-171/zoom, 144/zoom, 30/zoom)
        main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2+137/zoom, sy/2-171/zoom, 144/zoom, 30/zoom, main['textures']['button_1'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawText('Cofnij', sx/2+137/zoom, sy/2-171/zoom, sx/2+137/zoom+144/zoom, sy/2-171/zoom+30/zoom, tocolor(255,255,255,anim*main['anim'][4]), 1, main['fonts'][4], 'center', 'center')

        local x = 0
        for i,v in ipairs(speedoPatterns) do
            if i >= main['scroll'][1] and i <= main['scroll'][2] then
                x=x+1
                local offset = ((57/zoom)*(x-1))
                local isIn = isMouseIn(sx/2-320/zoom, sy/2-125/zoom+offset, 640/zoom, 54/zoom) and not isMouseIn(sx/2+180/zoom, sy/2-113/zoom+offset, 120/zoom, 30/zoom)
                v.anim[1] = interpolateBetween(v.anim[1], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
                dxDrawImage(sx/2-320/zoom, sy/2-125/zoom+offset, 640/zoom, 54/zoom, main['textures']['bg3'], 0,0,0, tocolor(255,255,255,anim*v.anim[1]))

                dxDrawText(v.name or 'Motyw #'..v.id, sx/2-310/zoom, sy/2-117/zoom+offset, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'top')
                dxDrawText('#68D65EKliknij aby włączyć podgląd motywu licznika', sx/2-310/zoom, sy/2-126/zoom+48/zoom+offset, _, _, tocolor(255,255,255,anim), 1, main['fonts'][2], 'left', 'bottom', false,false,false,true)        

                local isIn = isMouseIn(sx/2+180/zoom, sy/2-113/zoom+offset, 120/zoom, 30/zoom)
                v.anim[2] = interpolateBetween(v.anim[2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
                dxDrawImage(sx/2+180/zoom, sy/2-113/zoom+offset, 120/zoom, 30/zoom, main['textures']['button'], 0,0,0, tocolor(255,255,255,anim*v.anim[2]))
                dxDrawText('Zamontuj', sx/2+180/zoom, sy/2-113/zoom+offset, sx/2+180/zoom+120/zoom, sy/2-113/zoom+offset+30/zoom, tocolor(255,255,255,anim*v.anim[2]), 1, main['fonts'][3], 'center', 'center')

                if (v.id == speedoClicked) then
                    exports['since-speedo']:showSpeedoPatern(v.id)
                end
            end
        end
    end),

    [3] = (function(anim)
        local isIn = isMouseIn(sx/2+137/zoom, sy/2-171/zoom, 144/zoom, 30/zoom)
        main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
        dxDrawImage(sx/2+137/zoom, sy/2-171/zoom, 144/zoom, 30/zoom, main['textures']['button_1'], 0,0,0, tocolor(255,255,255,anim*main['anim'][4]))
        dxDrawText('Cofnij', sx/2+137/zoom, sy/2-171/zoom, sx/2+137/zoom+144/zoom, sy/2-171/zoom+30/zoom, tocolor(255,255,255,anim*main['anim'][4]), 1, main['fonts'][4], 'center', 'center')

        local veh = getPedOccupiedVehicle(localPlayer)
        local numberofkeys = getVehicleKeys(veh)

        dxDrawText('Dorabianie kluczy', sx/2, sy/2-90/zoom, nil, nil, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'bottom')
        dxDrawText('Twój pojazd posiada #80b7ff'..numberofkeys..' / 10 kluczy', sx/2, sy/2-90/zoom, nil, nil, tocolor(200,200,200,anim), 1, main['fonts'][2], 'center', 'top', false, false, false, true)

        local animin = isMouseIn(sx/2 - (140/zoom) / 2, sy/2 - 50/zoom, 140/zoom, 35/zoom) and 0.8 or 1
        dxDrawImage(sx/2 - (140/zoom) / 2, sy/2 - 50/zoom, 140/zoom, 35/zoom, main['textures']['button'], 0,0,0, tocolor(255, 255, 255, anim*animin))
        dxDrawText('Dorób klucz', sx/2, sy/2 - 33/zoom, nil, nil, tocolor(255,255,255,anim*animin), 1, main['fonts'][5], 'center', 'center')

        dxDrawText('Dorobienie klucza', sx/2, sy/2+20/zoom, nil, nil, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'bottom')
        dxDrawText('Dorobienie kolejnego klucza będzie kosztować #2E756F$ '.. numberofkeys * 75000 ..'', sx/2, sy/2+20/zoom, nil, nil, tocolor(200,200,200,anim), 1, main['fonts'][2], 'center', 'top', false, false, false, true)

        dxDrawText('Informacje', sx/2, sy/2+70/zoom, nil, nil, tocolor(255,255,255,anim), 1, main['fonts'][1], 'center', 'bottom')
        dxDrawText('Dorobienie klucza jest nieodwracalne, dorabiając klucz musisz liczyć się\nz tym, że nie otrzymasz zwrotu pieniędzy.\nAby udostępnic komuś klucze wpisz #c680ff/klucze#c8c8c8 a następnie\nwprowadź UID osoby, której chcesz podarować klucze.', sx/2, sy/2+70/zoom, nil, nil, tocolor(200,200,200,anim), 1, main['fonts'][2], 'center', 'top', false, false, false, true)
    end),
}

getResourceName(getThisResource(), true, 622606442); if true then return end