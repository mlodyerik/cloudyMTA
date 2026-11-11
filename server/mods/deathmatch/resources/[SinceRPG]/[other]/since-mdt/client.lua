local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

local mandaty = {
    {"Jazda pod prąd", 50000, selected = false},
    --{"Przekroczenie prędkości", 500, selected = false},
    {"Brawurowa jazda", 100000, selected = false},
    {"Blokowanie drogi", 70000, selected = false},
    {"Spowodowanie wypadku", 100000, selected = false},
    {"Skracanie", 40000, selected = false},
    {"Nie zatrzymanie się do kontroli", 100000, selected = false},
    {"Przekroczenie prędkości o 20-60km/h", 50000, selected = false},
    {"Przekroczenie prędkości o 60km/h", 70000, selected = false},
    {"Prowokacja funkcjonariusza", 100000, selected = false},
    {"Utrudnianie pracy funkcjonariusza", 100000, selected = false},
    {"Fałszywe zgłoszenie", 50000, selected = false},
    {"Niestosowne animacje", 50000, selected = false},
    {"Próba przekupstwa/wręczenie łapówki", 50000, selected = false},
    {"Bieganie po ulicy", 50000, selected = false},
    {"Poruszanie się uszkodzonym pojazdem", 50000, selected = false},
}

local upomnienia = {
    {"Jazda pod prąd", 0, selected = false},
    --{"Przekroczenie prędkości", 0, selected = false},
    {"Brawurowa jazda", 0, selected = false},
    {"Blokowanie drogi", 0, selected = false},
    {"Spowodowanie wypadku", 0, selected = false},
    {"Skracanie", 0, selected = false},
    {"Nie zatrzymanie się do kontroli", 0, selected = false},
    {"Przekroczenie prędkości o 20-60km/h", 0, selected = false},
    {"Przekroczenie prędkości o 60km/h", 0, selected = false},
    {"Prowokacja funkcjonariusza", 0, selected = false},
    {"Utrudnianie pracy funkcjonariusza", 0, selected = false},
    {"Fałszywe zgłoszenie", 0, selected = false},
    {"Niestosowne animacje", 0, selected = false},
    {"Próba przekupstwa/wręczenie łapówki", 0, selected = false},
    {"Bieganie po ulicy", 0, selected = false},
    {"Poruszanie się uszkodzonym pojazdem", 0, selected = false},  
}

local selected_mandaty = {}
local selected_upomnienia = {}
local grzywna = 0

local current, current2, current_wyszukaj = "Main", "Wyszukaj", "Mandaty"
local alpha, alpha2, alpha3, alpha4, alpha5, alpha6, alpha7, alpha8, alpha9 = 255, 0, 255, 255, 0, 255, 0, 255, 0
local finger_state, finger_end = 0, false
local first, first2, first3, first4 = 0, 0, 0, 0
local y_button, y_button2 = sy/2 - 55/zoom, sy/2 - 55/zoom
local x = (sx/2 - 26/zoom) + 325/zoom
local first_wpisy, first_mandaty, first_wyroki, first_t = 0, 0, 0, 0

--local y_button = sy/2 + 85/zoom

function render()
    dxDrawImage(sx/2 - 1267/zoom/2, sy/2 - 808/zoom/2, 1267/zoom, 808/zoom, textures[1], 0, 0, 0, white, false)

    if current == "Start" then
        dxDrawImage(sx/2 - 352/zoom/2, sy/2 - 300/zoom, 352/zoom, 353/zoom, textures[2], 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        dxDrawText("San Andreas Police Department", sx/2, sy/2 + 130/zoom, center, center, tocolor(255, 255, 255, alpha), 1/zoom, fonts[1], "center", "center", false, false, false, false)
        dxDrawText("Kliknij, aby kontynuować...", sx/2, sy/2 + 220/zoom, center, center, tocolor(211, 211, 211, alpha), 1/zoom, fonts[2], "center", "center", false, false, false, false)
    elseif current == "Logging" then
        dxDrawText("San Andreas Police Department", sx/2, sy/2 - 200/zoom, center, center, tocolor(255, 255, 255, alpha2), 1/zoom, fonts[1], "center", "center", false, false, false, false)
        dxDrawImage(sx/2 - 102/zoom/2, sy/2 - 143/zoom/2, 102/zoom, 143/zoom, textures[3], 0, 0, 0, tocolor(255, 255, 255, alpha2), false)
        --dxDrawImage(sx/2 - 102/zoom/2, sy/2 - 143/zoom/2, 102/zoom, 100/zoom, textures[4], 0, 0, 0, tocolor(255, 255, 255, alpha2), false)
        --dxDrawImageSection(sx/2 - 102/zoom/2, sy - 143/zoom/2, 489/zoom * logging_state/100, 37/zoom, 0/zoom, 0/zoom, 489/zoom * logging_state/100, 38/zoom, textures[3])
        dxDrawImageSection(sx/2 - 102/zoom/2, sy/2 - 143/zoom/2, 102/zoom, 143/zoom * finger_state/100, 0/zoom, 0/zoom, 102/zoom, 143/zoom * finger_state/100, textures[4], 0, 0, 0, tocolor(255, 255, 255, alpha2))
        dxDrawText("Przytrzymaj, aby się zalogować", sx/2, sy/2 + 220/zoom, center, center, tocolor(211, 211, 211, alpha2), 1/zoom, fonts[2], "center", "center", false, false, false, false)

        if finger_state == 100 and not finger_end then
            finger_end = true
            animate(alpha2, 0, 3, 300, function(v) alpha2 = v end)
            setTimer(function()
                current = "Main"
                animate(alpha3, 255, 3, 300, function(v) alpha3 = v end)
                animate(alpha4, 255, 3, 300, function(v) alpha4 = v end)
            end, 301, 1)
        end

        if isMouseIn(sx/2 - 102/zoom/2, sy/2 - 143/zoom/2, 102/zoom, 143/zoom) and getKeyState("mouse1") and finger_state < 100 and not finger_end then
            finger_state = finger_state + 1
        end

        if finger_state > 0 and not getKeyState("mouse1") and not finger_end then
            finger_state = finger_state - 1
        end
    elseif current == "Main" then
        dxDrawImage(sx/2 - 574/zoom, sy/2 - 706/zoom/2, 199/zoom, 706/zoom, textures[5], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
        dxDrawImage(sx/2 - 516/zoom, sy/2 - 325/zoom, 84/zoom, 84/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
        dxDrawRectangle(sx/2 - 574/zoom, sy/2 - 200/zoom, 200/zoom, 2/zoom, tocolor(39, 52, 71, alpha3), false)
        dxDrawRectangle(sx/2 - 574/zoom, sy/2, 200/zoom, 2/zoom, tocolor(39, 52, 71, alpha3), false)
        dxDrawImage(sx/2 - 316/zoom, sy/2 - 500/zoom/2, 830/zoom, 500/zoom, textures[6], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
        dxDrawImage(sx/2 + 350/zoom, sy/2 - 318/zoom, 20/zoom, 36/zoom, textures[8], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
        dxDrawText(removeHex(getPlayerName(localPlayer)), sx/2 + 380/zoom, sy/2 - 297/zoom, left, center, tocolor(255, 255, 255, alpha3), 1/zoom, fonts[3], "left", "center", false, false, false, false)

        if current2 == "Mandaty" then
            dxDrawImage(sx/2 - 550/zoom, sy/2 - 160/zoom, 20/zoom, 14/zoom, textures[10], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
            dxDrawText("Mandaty", sx/2 - 520/zoom, sy/2 - 152/zoom, left, center, tocolor(255, 255, 255, alpha3), 1/zoom, fonts[4], "left", "center", false, false, false, false)
        else
            dxDrawImage(sx/2 - 550/zoom, sy/2 - 160/zoom, 20/zoom, 14/zoom, textures[9], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
            dxDrawText("Mandaty", sx/2 - 520/zoom, sy/2 - 152/zoom, left, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "left", "center", false, false, false, false)
        end

        if current2 == "Upomnienie" then
            dxDrawImage(sx/2 - 550/zoom, sy/2 - 110/zoom, 17/zoom, 15/zoom, textures[12], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
            dxDrawText("Upomnienie", sx/2 - 520/zoom, sy/2 - 102/zoom, left, center, tocolor(255, 255, 255, alpha3), 1/zoom, fonts[4], "left", "center", false, false, false, false)
        else
            dxDrawImage(sx/2 - 550/zoom, sy/2 - 110/zoom, 17/zoom, 15/zoom, textures[11], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
            dxDrawText("Upomnienie", sx/2 - 520/zoom, sy/2 - 102/zoom, left, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "left", "center", false, false, false, false)
        end

        if current2 == "Wyszukaj" then
            dxDrawImage(sx/2 - 550/zoom, sy/2 - 60/zoom, 18/zoom, 18/zoom, textures[14], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
            dxDrawText("Wyszukaj", sx/2 - 520/zoom, sy/2 - 50/zoom, left, center, tocolor(255, 255, 255, alpha3), 1/zoom, fonts[4], "left", "center", false, false, false, false)
        else
            dxDrawImage(sx/2 - 550/zoom, sy/2 - 60/zoom, 18/zoom, 18/zoom, textures[13], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)
            dxDrawText("Wyszukaj", sx/2 - 520/zoom, sy/2 - 50/zoom, left, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "left", "center", false, false, false, false)
        end

        if current2 == "Mandaty" then
            dxDrawImage(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom, textures[15], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)

            dxDrawImage(sx/2 + 38/zoom, sy/2 - 190/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
            dxDrawImage(sx/2 + 38/zoom, sy/2 - 130/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)

            dxDrawText("Mandat", sx/2 + 170/zoom, sy/2 - 157/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            dxDrawText("Grzywna", sx/2 + 410/zoom, sy/2 - 157/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)

            for i=1,7 do
                if mandaty[first+i] then
                    local v = mandaty[first+i]
                    if v.selected then
                        dxDrawText(v[1], sx/2 - 124/zoom, sy/2 - 170/zoom + ((i-1)*55/zoom), center, center, tocolor(255, 140, 0, alpha4), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                    else
                        dxDrawText(v[1], sx/2 - 124/zoom, sy/2 - 170/zoom + ((i-1)*55/zoom), center, center, tocolor(255, 255, 255, alpha4), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                    end
                    --dxDrawRectangle(sx/2 - 240/zoom, sy/2 - 190/zoom + ((i-1)*55/zoom), 233/zoom, 40/zoom, white, false)
                    if i < 7 then
                        dxDrawImage(sx/2 - 240/zoom, sy/2 - 145/zoom + ((i-1)*55/zoom), 233/zoom, 2/zoom, textures[17], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
                    end
                end
            end

            --[[dxDrawText("Przekroczenie prędkości", sx/2 + 170/zoom, sy/2 - 90/zoom, center, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "center", "center", false, false, false, false)
            dxDrawText("5000 PLN", sx/2 + 410/zoom, sy/2 - 90/zoom, center, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "center", "center", false, false, false, false)
            dxDrawImage(sx/2 + 38/zoom, sy/2 - 60/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)

            dxDrawText("Przekroczenie prędkości", sx/2 + 170/zoom, sy/2 - 20/zoom, center, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "center", "center", false, false, false, false)
            dxDrawText("5000 PLN", sx/2 + 410/zoom, sy/2 - 20/zoom, center, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "center", "center", false, false, false, false)
            dxDrawImage(sx/2 + 38/zoom, sy/2 + 10/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)

            dxDrawText("Przekroczenie prędkości", sx/2 + 170/zoom, sy/2 + 50/zoom, center, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "center", "center", false, false, false, false)
            dxDrawText("5000 PLN", sx/2 + 410/zoom, sy/2 + 50/zoom, center, center, tocolor(211, 211, 211, alpha3), 1/zoom, fonts[4], "center", "center", false, false, false, false)
            dxDrawImage(sx/2 + 38/zoom, sy/2 + 80/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha3), false)]]

            for i=1,3 do
                if selected_mandaty[first2+i] then
                    local v = selected_mandaty[first2+i]
                    dxDrawText(v.name, sx/2 + 170/zoom, sy/2 - 90/zoom + ((i-1)*70/zoom), center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[4], "center", "center", false, false, false, false)
                    dxDrawText(przecinek(v.price).." PLN", sx/2 + 410/zoom, sy/2 - 90/zoom + ((i-1)*70/zoom), center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[4], "center", "center", false, false, false, false)
                    dxDrawImage(sx/2 + 38/zoom, sy/2 - 60/zoom + ((i-1)*70/zoom), 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
                end
            end

            if #selected_mandaty > 0 then
                if isMouseIn((sx/2 - 100/zoom/2) + 360/zoom, y_button, 100/zoom, 25/zoom) then
                    dxDrawImage((sx/2 - 100/zoom/2) + 360/zoom, y_button, 100/zoom, 25/zoom, textures[19], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
                else
                    dxDrawImage((sx/2 - 100/zoom/2) + 360/zoom, y_button, 100/zoom, 25/zoom, textures[18], 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
                end
                dxDrawText("Wystaw", sx/2 + 360/zoom, y_button + 15/zoom, center, center, tocolor(255, 255, 255, alpha4), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            end

            if #selected_mandaty == 1 then
                dxDrawText("Podsumowanie", sx/2 + 170/zoom, sy/2 - 20/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
                dxDrawText(przecinek(grzywna).." PLN", sx/2 + 410/zoom, sy/2 - 20/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            elseif #selected_mandaty == 2 then
                dxDrawText("Podsumowanie", sx/2 + 170/zoom, sy/2 + 50/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
                dxDrawText(przecinek(grzywna).." PLN", sx/2 + 410/zoom, sy/2 + 50/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            elseif #selected_mandaty >= 3 then
                dxDrawText("Podsumowanie", sx/2 + 170/zoom, sy/2 + 120/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
                dxDrawText(przecinek(grzywna).." PLN", sx/2 + 410/zoom, sy/2 + 120/zoom, center, center, tocolor(211, 211, 211, alpha4), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            end


            --dxDrawRectangle(sx/2 - 550/zoom, sy/2 - 160/zoom, 135/zoom, 20/zoom, white)
            --dxDrawRectangle(sx/2 - 550/zoom, sy/2 - 110/zoom, 135/zoom, 20/zoom, white)
            --dxDrawRectangle(sx/2 - 550/zoom, sy/2 - 60/zoom, 135/zoom, 20/zoom, white)

            exports["since-mdteditbox"]:dxSetEditAlpha("mdt:mandaty", alpha4)

        elseif current2 == "Upomnienie" then
            dxDrawImage(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom, textures[15], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)

            dxDrawImage(sx/2 + 38/zoom, sy/2 - 190/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)
            dxDrawImage(sx/2 + 38/zoom, sy/2 - 130/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)

            dxDrawText("Upomnienie", sx/2 + 170/zoom, sy/2 - 157/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            dxDrawText("Grzywna", sx/2 + 410/zoom, sy/2 - 157/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)


            for i=1,7 do
                if upomnienia[first3+i] then
                    local v = upomnienia[first3+i]
                    if v.selected then
                        dxDrawText(v[1], sx/2 - 124/zoom, sy/2 - 170/zoom + ((i-1)*55/zoom), center, center, tocolor(255, 140, 0, alpha5), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                    else
                        dxDrawText(v[1], sx/2 - 124/zoom, sy/2 - 170/zoom + ((i-1)*55/zoom), center, center, tocolor(255, 255, 255, alpha5), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                    end
                    --dxDrawRectangle(sx/2 - 240/zoom, sy/2 - 190/zoom + ((i-1)*55/zoom), 233/zoom, 40/zoom, white, false)
                    if i < 7 then
                        dxDrawImage(sx/2 - 240/zoom, sy/2 - 145/zoom + ((i-1)*55/zoom), 233/zoom, 2/zoom, textures[17], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)
                    end
                end
            end

            for i=1,3 do
                if selected_upomnienia[first4+i] then
                    local v = selected_upomnienia[first4+i]
                    dxDrawText(v.name, sx/2 + 170/zoom, sy/2 - 90/zoom + ((i-1)*70/zoom), center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[4], "center", "center", false, false, false, false)
                    dxDrawText(przecinek(v.price).." PLN", sx/2 + 410/zoom, sy/2 - 90/zoom + ((i-1)*70/zoom), center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[4], "center", "center", false, false, false, false)
                    dxDrawImage(sx/2 + 38/zoom, sy/2 - 60/zoom + ((i-1)*70/zoom), 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)
                end
            end

            if #selected_upomnienia > 0 then
                if isMouseIn((sx/2 - 100/zoom/2) + 360/zoom, y_button2, 100/zoom, 25/zoom) then
                    dxDrawImage((sx/2 - 100/zoom/2) + 360/zoom, y_button2, 100/zoom, 25/zoom, textures[19], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)
                else
                    dxDrawImage((sx/2 - 100/zoom/2) + 360/zoom, y_button2, 100/zoom, 25/zoom, textures[18], 0, 0, 0, tocolor(255, 255, 255, alpha5), false)
                end
                dxDrawText("Wystaw", sx/2 + 360/zoom, y_button2 + 15/zoom, center, center, tocolor(255, 255, 255, alpha5), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            end

            exports["since-mdteditbox"]:dxSetEditAlpha("mdt:upomnienia", alpha5)

            if #selected_upomnienia == 1 then
                dxDrawText("Podsumowanie", sx/2 + 170/zoom, sy/2 - 20/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
                dxDrawText("0 PLN", sx/2 + 410/zoom, sy/2 - 20/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            elseif #selected_upomnienia == 2 then
                dxDrawText("Podsumowanie", sx/2 + 170/zoom, sy/2 + 50/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
                dxDrawText("0 PLN", sx/2 + 410/zoom, sy/2 + 50/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            elseif #selected_upomnienia >= 3 then
                dxDrawText("Podsumowanie", sx/2 + 170/zoom, sy/2 + 120/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
                dxDrawText("0 PLN", sx/2 + 410/zoom, sy/2 + 120/zoom, center, center, tocolor(211, 211, 211, alpha5), 1/zoom, fonts[6], "center", "center", false, false, false, false)
            end

        elseif current2 == "Wyszukaj" then
            dxDrawImage(sx/2 + 385/zoom, sy/2 - 235/zoom, 100/zoom, 25/zoom, textures[18], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
            dxDrawImage(sx/2 + 275/zoom, sy/2 - 235/zoom, 100/zoom, 25/zoom, textures[18], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
            dxDrawImage(sx/2 + 165/zoom, sy/2 - 235/zoom, 100/zoom, 25/zoom, textures[18], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)

            dxDrawImage(sx/2 + 38/zoom, sy/2 - 190/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
            dxDrawImage(sx/2 + 38/zoom, sy/2 - 145/zoom, 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)

            if current_wyszukaj == "Wpisy" then
                dxDrawText("Wpisy", sx/2 + 215/zoom, sy/2 - 221/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            else
                dxDrawText("Wpisy", sx/2 + 215/zoom, sy/2 - 221/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            end

            if current_wyszukaj == "Mandaty" then
                dxDrawText("Mandaty", sx/2 + 325/zoom, sy/2 - 221/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            else
                dxDrawText("Mandaty", sx/2 + 325/zoom, sy/2 - 221/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            end

            if current_wyszukaj == "Wyroki" then
                dxDrawText("Wyroki", sx/2 + 435/zoom, sy/2 - 221/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            else
                dxDrawText("Wyroki", sx/2 + 435/zoom, sy/2 - 221/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            end

            if result then
                if hudMaskShader then
                    dxDrawImage(sx/2 - 225/zoom, sy/2 - 150/zoom, 163/zoom, 163/zoom, hudMaskShader, 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                else
                    dxDrawImage(sx/2 - 225/zoom, sy/2 - 150/zoom, 163/zoom, 163/zoom, textures[20], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                end

                local avatar = result[1].uid and exports['since-avatars']:getPlayerCircleAvatar(result[1].uid) or exports['since-avatars']:drawNoAvatar()
                dxDrawImage(sx/2 - 225/zoom, sy/2 - 150/zoom, 163/zoom, 163/zoom, avatar, 0, 0, 0, tocolor(255, 255, 255, alpha6), false)

                dxDrawText(result[1].login, sx/2 - 145/zoom, sy/2 + 40/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[2], "center", "center", false, false, false, false)

                local online = isPlayerOnline(result[1].uid)
                local pjA = online and getElementData(online, "player:licenses") and getElementData(online, "player:licenses")['a'] or true
                local pjB = online and getElementData(online, "player:licenses") and getElementData(online, "player:licenses")['b'] or true
                local pjC = online and getElementData(online, "player:licenses") and getElementData(online, "player:licenses")['c'] or true

                if pjB then
                    dxDrawImage((sx/2 - 44/zoom) - 90/zoom, sy/2 + 75/zoom, 110/zoom, 22/zoom, textures[22], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                else
                    dxDrawImage((sx/2 - 44/zoom) - 90/zoom, sy/2 + 75/zoom, 110/zoom, 22/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                end

                if pjA then
                    dxDrawImage((sx/2 - 44/zoom) - 210/zoom, sy/2 + 75/zoom, 110/zoom, 22/zoom, textures[22], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                else
                    dxDrawImage((sx/2 - 44/zoom) - 210/zoom, sy/2 + 75/zoom, 110/zoom, 22/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                end

                if pjC then
                    dxDrawImage((sx/2 - 44/zoom) - 210/zoom, sy/2 + 110/zoom, 110/zoom, 22/zoom, textures[22], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                else
                    dxDrawImage((sx/2 - 44/zoom) - 210/zoom, sy/2 + 110/zoom, 110/zoom, 22/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                end
                --dxDrawImage((sx/2 - 44/zoom) - 210/zoom, sy/2 + 110/zoom, 110/zoom, 22/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)

                if #result_wpisy > 1 then
                    dxDrawImage((sx/2 - 44/zoom) - 90/zoom, sy/2 + 110/zoom, 110/zoom, 22/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                    dxDrawText("Poszukiwany", sx/2 - 80/zoom, sy/2 + 122/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                else
                    dxDrawImage((sx/2 - 44/zoom) - 90/zoom, sy/2 + 110/zoom, 110/zoom, 22/zoom, textures[22], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)
                    dxDrawText("Nie poszukiwany", sx/2 - 80/zoom, sy/2 + 122/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                end

                dxDrawText("Prawo jazdy B", sx/2 - 200/zoom, sy/2 + 88/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                dxDrawText("Prawo jazdy A", sx/2 - 80/zoom, sy/2 + 88/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                dxDrawText("Prawo jazdy C", sx/2 - 200/zoom, sy/2 + 122/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                --dxDrawText("Poszukiwany", sx/2 - 80/zoom, sy/2 + 122/zoom, center, center, tocolor(255, 255, 255, alpha6), 1/zoom, fonts[5], "center", "center", false, false, false, false)
            end

            if current_wyszukaj == "Mandaty" then
                if result_mandaty then
                    for i=1,4 do
                        if result_mandaty[first_mandaty+i] then
                            local v = result_mandaty[first_mandaty+i]
                            if v.type == "Mandat" then
                                t = split(v.text, ",")
                                --outputConsole(inspect(t))
                                if #t > 3 then
                                    --if wyswietlany3 == 0 then
                                        for i2=1,3 do
                                            if t[first_t+i2] then
                                                local v2 = t[first_t+i2]
                                                dxDrawText(v2, sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*80/zoom) + ((i2-1)*20/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                            end
                                        end
                                    --end
                                    --dxDrawText(t[1], sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*70/zoom), center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                else
                                    if t[1] and not #t == 1  then
                                        dxDrawText(t[1], sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    elseif t[1] and #t == 1 then
                                        dxDrawText(t[1], sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                    if t[2] then
                                        dxDrawText(t[2], sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                    if t[3] then
                                        dxDrawText(t[3], sx/2 + 100/zoom, sy/2 - 80/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                end
                                dxDrawText(v.przez, sx/2 + 240/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawText(v.date, sx/2 + 410/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha7), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawImage(sx/2 + 38/zoom, sy/2 - 60/zoom + ((i-1)*80/zoom), 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha7), false)
                                dxDrawImage(sx/2 + 490/zoom, sy/2 - 110/zoom + ((i-1)*80/zoom), 15/zoom, 15/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha7), false)

                                if isMouseIn(sx/2 + 490/zoom, sy/2 - 110/zoom + ((i-1)*80/zoom), 15/zoom, 15/zoom) then
                                    tooltip("Szczegóły mandatu:", przecinek(v.total).." PLN")
                                end
                            end
                        end
                    end
                end
            elseif current_wyszukaj == "Wyroki" then
                if result_wyroki then
                    for i=1,4 do
                        if result_wyroki[first_wyroki+i] then
                            local v = result_wyroki[first_wyroki+i]
                            if v.type == "Wyrok" then
                                local d = split(v.text, ",")
                                if #d > 3 then
                                    --if wyswietlany3 == 0 then
                                    for i2=1,3 do
                                        if d[first_t+i2] then
                                            local v2 = d[first_t+i2]
                                            dxDrawText(v2, sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*80/zoom) + ((i2-1)*20/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                        end
                                    end
                                else
                                    if d[1] and not #d == 1 then
                                        dxDrawText(d[1], sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    elseif d[1] and #d == 1 then
                                        dxDrawText(d[1], sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                    if d[2] then
                                        dxDrawText(d[2], sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                    if d[3] then
                                        dxDrawText(d[3], sx/2 + 100/zoom, sy/2 - 80/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                end
                                dxDrawText(v.przez, sx/2 + 240/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawText(v.date, sx/2 + 410/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha8), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawImage(sx/2 + 38/zoom, sy/2 - 60/zoom + ((i-1)*80/zoom), 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha8), false)
                                dxDrawImage(sx/2 + 490/zoom, sy/2 - 110/zoom + ((i-1)*80/zoom), 15/zoom, 15/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha8), false)
                                if isMouseIn(sx/2 + 490/zoom, sy/2 - 110/zoom + ((i-1)*80/zoom), 15/zoom, 15/zoom) then
                                    tooltip("Szczegóły wyroku:", v.wyrok_h.." h "..v.wyrok_m.." min")
                                end
                            end
                        end
                    end
                end




            elseif current_wyszukaj == "Wpisy" then
                if result_wpisy then
                    for i=1,4 do
                        if result_wpisy[first_wyroki+i] then
                            local v = result_wpisy[first_wyroki+i]
                            if v.type == "Wpis" then
                                --local c = split(v.text, ",")
                                --[[if #c > 3 then
                                    for i2=1,3 do
                                        if c[first_t+i2] then
                                            local v2 = c[first_t+i2]
                                            dxDrawText(v2, sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*80/zoom) + ((i2-1)*20/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                        end
                                    end
                                else
                                    if c[1] and not #c == 1 then
                                        dxDrawText(c[1], sx/2 + 100/zoom, sy/2 - 120/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    elseif c[1] and #c == 1 then
                                        dxDrawText(c[1], sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                    if c[2] then
                                        dxDrawText(c[2], sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                    if c[3] then
                                        dxDrawText(c[3], sx/2 + 100/zoom, sy/2 - 80/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                    end
                                end--]]
                                dxDrawText(v.text, sx/2 + 100/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawText(v.przez, sx/2 + 240/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawText(v.date, sx/2 + 410/zoom, sy/2 - 100/zoom + ((i-1)*80/zoom), center, center, tocolor(211, 211, 211, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)
                                dxDrawImage(sx/2 + 38/zoom, sy/2 - 60/zoom + ((i-1)*80/zoom), 476/zoom, 2/zoom, textures[16], 0, 0, 0, tocolor(255, 255, 255, alpha9), false)

                                --dxDrawImage(sx/2 + 490/zoom, sy/2 - 110/zoom + ((i-1)*80/zoom), 15/zoom, 15/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha9), false)
                                dxDrawText("✘", sx/2 + 496/zoom, sy/2 - 103/zoom + ((i-1)*80/zoom), center, center, tocolor(255, 0, 0, alpha9), 1/zoom, fonts[7], "center", "center", false, false, false, false)

                            end
                        end
                    end
                    exports["since-mdteditbox"]:dxSetEditAlpha("mdt:wpis", alpha9)
                    if isMouseIn((sx/2 - 100/zoom/2) - 1/zoom,  sy/2 + 195/zoom, 100/zoom, 25/zoom) then
                        dxDrawImage((sx/2 - 100/zoom/2) - 1/zoom,  sy/2 + 195/zoom, 100/zoom, 25/zoom, textures[19], 0, 0, 0, tocolor(255, 255, 255, alpha9), false)
                    else
                        dxDrawImage((sx/2 - 100/zoom/2) - 1/zoom,  sy/2 + 195/zoom, 100/zoom, 25/zoom, textures[18], 0, 0, 0, tocolor(255, 255, 255, alpha9), false)
                    end
                    dxDrawText("Dodaj", sx/2 - 1/zoom, sy/2 + 195/zoom + 15/zoom, center, center, tocolor(255, 255, 255, alpha9), 1/zoom, fonts[5], "center", "center", false, false, false, false)
                end
            end

            dxDrawImage(x, sy/2 - 195/zoom, 52/zoom, 5/zoom, textures[23], 0, 0, 0, tocolor(255, 255, 255, alpha6), false)

            dxDrawText("Powód", sx/2 + 100/zoom, sy/2 - 165/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[7], "center", "center", false, false, false, false)
            dxDrawText("Wystawiający", sx/2 + 240/zoom, sy/2 - 165/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[7], "center", "center", false, false, false, false)
            dxDrawText("Data wystawienia", sx/2 + 410/zoom, sy/2 - 165/zoom, center, center, tocolor(211, 211, 211, alpha6), 1/zoom, fonts[7], "center", "center", false, false, false, false)
            exports["since-mdteditbox"]:dxSetEditAlpha("mdt:wyszukaj", alpha6)
        end
    end
end
--addEventHandler("onClientRender", root, render)

--[[exports["since-mdteditbox"]:dxDestroyEdit("mdt:wyszukaj")
exports["since-mdteditbox"]:dxDestroyEdit("mdt:mandaty")
exports["since-mdteditbox"]:dxDestroyEdit("mdt:upomnienia")
exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")--]]


function tooltip(text, text2)
    local cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy
    dxDrawImage(cx, cy, 214/zoom, 53/zoom, textures[24], 0, 0, 0, white, false)
    dxDrawText(text, cx + 5/zoom, cy + 15/zoom, left, center, white, 1/zoom, fonts[7], "left", "center", false, false, true, false)
    dxDrawText(text2, cx + 5/zoom, cy + 35/zoom, left, center, tocolor(255, 140, 0), 1/zoom, fonts[7], "left", "center", false, false, true, false)
end

function onStartKey(b, s)
    if s then
        removeEventHandler("onClientKey", root, onStartKey)
        animate(alpha, 0, 3, 300, function(v) alpha = v end)
        setTimer(function()
            current = "Logging"
            animate(alpha2, 255, 3, 300, function(v) alpha2 = v end)
            showCursor(true)
        end, 301, 1)
    end
end

function isPlayerOnline(sid)
    for i,v in ipairs(getElementsByType("player")) do
        if getElementData(v, "player:sid") == sid then
            return v
        end
    end
end

-- function setAvatar(player)
-- 	if getElementData(player, "avatar22") then
--         local ava = getElementData(player, "avatar22")
-- 		tex = dxCreateTexture(ava)
-- 		if not tex then
-- 			hudMaskShader = false
-- 			return
-- 		end
-- 		hudMaskShader = dxCreateShader("hud_mask.fx")	
-- 		maskTexture = textures[20]
-- 		dxSetShaderValue(hudMaskShader, "sPicTexture", tex)
-- 		dxSetShaderValue(hudMaskShader, "sMaskTexture", maskTexture)
--     else
--         hudMaskShader = false
--     end
-- end

addEvent("since-mdt:search:set", true)
addEventHandler("since-mdt:search:set", resourceRoot, function(db, db2, db3, db4)
    result = db
    result_mandaty = db2
    result_wyroki = db3
    result_wpisy = db4
    hudMaskShader = false
    if current_wyszukaj == "Wpisy" then
        exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")
        exports["since-mdteditbox"]:dxCreateEdit("mdt:wpis", "", "Wprowadź nowy wpis", (sx/2 - 200/zoom/2) - 180/zoom, sy/2 + 180/zoom, 200/zoom, 50/zoom, false, false, 0, {255, 255, 255, 0})
    end
end)

function onKey(b, s)
    if b == "enter" and s then
        if tick_spam then
            if getTickCount() - tick_spam < 1000 then
                return false
            end
        end
        local login = exports["since-mdteditbox"]:dxGetEditText("mdt:wyszukaj")
        if login then
            if string.len(login) < 75 and string.len(login) > 0 then
                triggerServerEvent("since-mdt:search", resourceRoot, login)
            end
        end
        tick_spam = getTickCount()
    end
end
--addEventHandler("onClientKey", root, onKey)

function scroll_up()
    if current2 == "Mandaty" then
        if first > 0 and isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first = first - 1
        end

        if first2 > 0 and not isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first2 = first2 - 1
        end
    elseif current2 == "Upomnienie" then
        if first3 > 0 and isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first3 = first3 - 1
        end

        if first4 > 0 and not isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first4 = first4 - 1
        end

       
    elseif current2 == "Wyszukaj" then
        if current_wyszukaj == "Wpisy" then
            if not isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_wpisy > 0 then
                first_wpisy = first_wpisy - 1
            end
        elseif current_wyszukaj == "Mandaty" then
            if not isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_mandaty > 0 then
                first_mandaty = first_mandaty - 1
            end
        elseif current_wyszukaj == "Wyroki" then
            if not isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_wyroki > 0 then
                first_wyroki = first_wyroki - 1
            end
        end

        if isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_t > 0 then
            first_t = first_t - 1
        end
    end
end
--exports["since-mdteditbox"]:dxDestroyEdit("mdt:wyszukaj")
function scroll_down()
    if current2 == "Mandaty" then
        if first + 7 < #mandaty and isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first = first + 1
        end

        if first2 + 3 < #selected_mandaty and not isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first2 = first2 + 1
        end
    elseif current2 == "Upomnienie" then
        if first3 + 7 < #upomnienia and isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first3 = first3 + 1
        end

        if first4 + 3 < #selected_upomnienia and not isMouseIn(sx/2 - 260/zoom, sy/2 - 390/zoom/2, 271/zoom, 390/zoom) then
            first4 = first4 + 1
        end
    elseif current2 == "Wyszukaj" then
        if current_wyszukaj == "Wpisy" then
            if not result_wpisy then
                return false
            end
            if not isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_wpisy + 3 < #result_wpisy then
                first_wpisy = first_wpisy + 1
            end
        elseif current_wyszukaj == "Mandaty" then
            if not result_mandaty then
                return false
            end
            if not isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_mandaty + 3 < #result_mandaty then
                first_mandaty = first_mandaty + 1
            end
        elseif current_wyszukaj == "Wyroki" then
            if not result_wyroki then
                return false
            end
            if not isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_wyroki + 3 < #result_wyroki then
                first_wyroki = first_wyroki + 1
            end
        end
        if isMouseIn(sx/2, sy/2 - 140/zoom, 190/zoom, 400/zoom) and first_t < 17 and current_wyszukaj ~= "Wpisy" then
            first_t = first_t + 1
        end
    end
end
--bindKey("mouse_wheel_down", "down", scroll_down)
--bindKey("mouse_wheel_up", "down", scroll_up)

local tick_spam = false

function click(b, s)
    if b == "left" and s == "down" then
        if tick_spam then
            if getTickCount() - tick_spam < 1000 then
                return false
            end
        end

        if current == "Main" then
            if isMouseIn(sx/2 - 550/zoom, sy/2 - 160/zoom, 135/zoom, 20/zoom) and current2 ~= "Mandaty" then
                animate(alpha5, 0, 3, 300, function(v) alpha5 = v end)
                animate(alpha6, 0, 3, 300, function(v) alpha6 = v end)
                animate(alpha7, 0, 3, 300, function(v) alpha7 = v end)
                animate(alpha8, 0, 3, 300, function(v) alpha8 = v end)
                animate(alpha9, 0, 3, 300, function(v) alpha9 = v end)
                setTimer(function()
                    current2 = "Mandaty"
                    animate(alpha4, 255, 3, 300, function(v) alpha4 = v end)
                    --exports["since-mdteditbox"]:dxDestroyEdit("mdt:upomnienia")
                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:wyszukaj")
                    if isEventHandlerAdded("onClientKey", root, onKey) then
                        removeEventHandler("onClientKey", root, onKey)
                    end
                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")
                    if isEventHandlerAdded("onClientKey", root, onKey) then
                        removeEventHandler("onClientKey", root, onKey)
                    end
                end, 301, 1)
                tick_spam = getTickCount()
            elseif isMouseIn(sx/2 - 550/zoom, sy/2 - 110/zoom, 135/zoom, 20/zoom) and current2 ~= "Upomnienie" then
                animate(alpha4, 0, 3, 300, function(v) alpha4 = v end)
                animate(alpha6, 0, 3, 300, function(v) alpha6 = v end)
                animate(alpha7, 0, 3, 300, function(v) alpha7 = v end)
                animate(alpha8, 0, 3, 300, function(v) alpha8 = v end)
                animate(alpha9, 0, 3, 300, function(v) alpha9 = v end)
                setTimer(function()
                    current2 = "Upomnienie"
                    animate(alpha5, 255, 3, 300, function(v) alpha5 = v end)
                    --exports["since-mdteditbox"]:dxDestroyEdit("mdt:mandaty")
                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:wyszukaj")
                    if isEventHandlerAdded("onClientKey", root, onKey) then
                        removeEventHandler("onClientKey", root, onKey)
                    end
                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")
                    if isEventHandlerAdded("onClientKey", root, onKey) then
                        removeEventHandler("onClientKey", root, onKey)
                    end
                end, 301, 1)
                tick_spam = getTickCount()
            elseif isMouseIn(sx/2 - 550/zoom, sy/2 - 60/zoom, 135/zoom, 20/zoom) and current2 ~= "Wyszukaj" then
                animate(alpha4, 0, 3, 300, function(v) alpha4 = v end)
                animate(alpha5, 0, 3, 300, function(v) alpha5 = v end)
                setTimer(function()
                    current2 = "Wyszukaj"
                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:wyszukaj")
                    exports["since-mdteditbox"]:dxCreateEdit("mdt:wyszukaj", "", "Wyszukaj gracza", (sx/2 - 175/zoom/2) - 180/zoom, sy/2 - 210/zoom, 175/zoom, 50/zoom, false, false, 0, {255, 255, 255, 255})
                    addEventHandler("onClientKey", root, onKey)
                    animate(alpha6, 255, 3, 300, function(v) alpha6 = v end)
                    animate(alpha7, 255, 3, 300, function(v) alpha7 = v end)
                    current_wyszukaj = "Mandaty"
                    x = (sx/2 - 26/zoom) + 325/zoom
                    if not isEventHandlerAdded("onClientKey", root, onKey) then
                        addEventHandler("onClientKey", root, onKey)
                    end
                end, 301, 1)
                tick_spam = getTickCount()
            end









            if current2 == "Mandaty" then
                for i=1,7 do
                    if mandaty[first+i] then
                        local v = mandaty[first+i]
                        if isMouseIn(sx/2 - 240/zoom, sy/2 - 190/zoom + ((i-1)*55/zoom), 233/zoom, 40/zoom) then
                            if v.selected then
                                v.selected = false
                                for i2,v2 in ipairs(selected_mandaty) do
                                    if v[1] == v2.name then
                                        table.remove(selected_mandaty, i2)
                                        grzywna = grzywna - v[2]
                                        if #selected_mandaty < 1 then
                                            exports["since-mdteditbox"]:dxDestroyEdit("mdt:mandaty")
                                        end
                                        if #selected_mandaty < 3 then
                                            y_button = y_button - 70/zoom
                                            exports["since-mdteditbox"]:dxSetEditPosition("mdt:mandaty", (sx/2 - 125/zoom/2) + 220/zoom, y_button - 15/zoom)
                                        end
                                    end
                                end
                            else
                                v.selected = true
                                table.insert(selected_mandaty, {name=v[1], price=v[2]})
                                grzywna = grzywna + v[2]
                                if #selected_mandaty < 2 then
                                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:mandaty")
                                    exports["since-mdteditbox"]:dxCreateEdit("mdt:mandaty", "", "Wprowadź ID", (sx/2 - 125/zoom/2) + 220/zoom, y_button - 15/zoom, 125/zoom, 50/zoom, false, false, 0, {255, 255, 255, 0})
                                end
                                if #selected_mandaty < 4 then
                                    y_button = y_button + 70/zoom
                                    exports["since-mdteditbox"]:dxSetEditPosition("mdt:mandaty", (sx/2 - 125/zoom/2) + 220/zoom, y_button - 15/zoom)
                                end
                            end
                        end
                    end
                end

                if #selected_mandaty > 0 then
                    if isMouseIn((sx/2 - 100/zoom/2) + 360/zoom, y_button, 100/zoom, 25/zoom) then
                        local id = exports["since-mdteditbox"]:dxGetEditText("mdt:mandaty")
                        if id then
                            if tonumber(id) then
                                triggerServerEvent("since-mdt:mandat", resourceRoot, id, selected_mandaty, grzywna)
                            else
                                outputChatBox("#ff0000✘ #ffffffID musi być liczbą!", 255, 255, 255, true)
                            end
                        end
                    end
                    tick_spam = getTickCount()
                end
            elseif current2 == "Upomnienie" then
                for i=1,7 do
                    if upomnienia[first3+i] then
                        local v = upomnienia[first3+i]
                        if isMouseIn(sx/2 - 240/zoom, sy/2 - 190/zoom + ((i-1)*55/zoom), 233/zoom, 40/zoom) then
                            if v.selected then
                                v.selected = false
                                for i2,v2 in ipairs(selected_upomnienia) do
                                    if v[1] == v2.name then
                                        table.remove(selected_upomnienia, i2)
                                        if #selected_upomnienia < 1 then
                                            exports["since-mdteditbox"]:dxDestroyEdit("mdt:upomnienia")
                                        end
                                        if #selected_upomnienia < 3 then
                                            y_button2 = y_button2 - 70/zoom
                                            exports["since-mdteditbox"]:dxSetEditPosition("mdt:upomnienia", (sx/2 - 125/zoom/2) + 220/zoom, y_button2 - 15/zoom)
                                        end
                                    end
                                end
                            else
                                v.selected = true
                                table.insert(selected_upomnienia, {name=v[1], price=v[2]})
                                if #selected_upomnienia < 2 then
                                    exports["since-mdteditbox"]:dxDestroyEdit("mdt:upomnienia")
                                    exports["since-mdteditbox"]:dxCreateEdit("mdt:upomnienia", "", "Wprowadź ID", (sx/2 - 125/zoom/2) + 220/zoom, y_button2 - 15/zoom, 125/zoom, 50/zoom, false, false, 0, {255, 255, 255, 0})
                                    exports["since-mdteditbox"]:dxSetEditAlpha("mdt:upomnienia", 255)
                                end
                                if #selected_upomnienia < 4 then
                                    y_button2 = y_button2 + 70/zoom
                                    exports["since-mdteditbox"]:dxSetEditPosition("mdt:upomnienia", (sx/2 - 125/zoom/2) + 220/zoom, y_button2 - 15/zoom)
                                end
                            end
                        end
                    end
                end
                if #selected_upomnienia > 0 then
                    if isMouseIn((sx/2 - 100/zoom/2) + 360/zoom, y_button2, 100/zoom, 25/zoom) then
                        local id = exports["since-mdteditbox"]:dxGetEditText("mdt:upomnienia")
                        if id then
                            if tonumber(id) then
                                triggerServerEvent("since-mdt:upomnienie", resourceRoot, id, selected_upomnienia)
                            else
                                outputChatBox("#ff0000✘ #ffffffID musi być liczbą!", 255, 255, 255, true)
                            end
                        end
                    end
                    tick_spam = getTickCount()
                end

            elseif current2 == "Wyszukaj" then
                if isMouseIn(sx/2 + 165/zoom, sy/2 - 235/zoom, 100/zoom, 25/zoom) and current_wyszukaj ~= "Wpisy" then
                    animate(x, (sx/2 - 26/zoom) + 215/zoom, 3, 300, function(v) x = v end)
                    animate(alpha7, 0, 3, 300, function(v) alpha7 = v end)
                    animate(alpha8, 0, 3, 300, function(v) alpha8 = v end)
                    setTimer(function()
                        current_wyszukaj = "Wpisy"
                        exports["since-mdteditbox"]:dxCreateEdit("mdt:wpis", "", "Wprowadź nowy wpis", (sx/2 - 200/zoom/2) - 180/zoom, sy/2 + 180/zoom, 200/zoom, 50/zoom, false, false, 0, {255, 255, 255, 0})
                        animate(alpha9, 255, 3, 300, function(v) alpha9 = v end)
                    end, 301, 1)
                    tick_spam = getTickCount()
                elseif isMouseIn(sx/2 + 275/zoom, sy/2 - 235/zoom, 100/zoom, 25/zoom) and current_wyszukaj ~= "Mandaty" then
                    animate(x, (sx/2 - 26/zoom) + 325/zoom, 3, 300, function(v) x = v end) -- 385
                    animate(alpha8, 0, 3, 300, function(v) alpha8 = v end)
                    animate(alpha9, 0, 3, 300, function(v) alpha9 = v end)
                    setTimer(function()
                        current_wyszukaj = "Mandaty"
                        animate(alpha7, 255, 3, 300, function(v) alpha7 = v end)
                        exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")
                    end, 301, 1)
                    tick_spam = getTickCount()
                elseif isMouseIn(sx/2 + 385/zoom, sy/2 - 235/zoom, 100/zoom, 25/zoom) and current_wyszukaj ~= "Wyroki" then
                    animate(x, (sx/2 - 26/zoom) + 435/zoom, 3, 300, function(v) x = v end)
                    animate(alpha7, 0, 3, 300, function(v) alpha7 = v end)
                    animate(alpha9, 0, 3, 300, function(v) alpha9 = v end)
                    setTimer(function() 
                        current_wyszukaj = "Wyroki"
                        animate(alpha8, 255, 3, 300, function(v) alpha8 = v end)
                        exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")
                    end, 301, 1)
                    tick_spam = getTickCount()
                end

                if current_wyszukaj == "Wpisy" then
                    if result_wpisy then
                        for i=1,4 do
                            if result_wpisy[first_wyroki+i] then
                                local v = result_wpisy[first_wyroki+i]
                                if isMouseIn(sx/2 + 490/zoom, sy/2 - 110/zoom + ((i-1)*80/zoom), 15/zoom, 15/zoom) then
                                    triggerServerEvent("since-mdt:wpis:delete", resourceRoot, result[1].uid, v.text, v.date)
                                    triggerServerEvent("since-mdt:search", resourceRoot, result[1].login)
                                    tick_spam = getTickCount()
                                end
                            end
                        end
                    end

                    if isMouseIn((sx/2 - 100/zoom/2) - 1/zoom,  sy/2 + 195/zoom, 100/zoom, 25/zoom) and result_wpisy then
                        local text = exports["since-mdteditbox"]:dxGetEditText("mdt:wpis")
                        if text then
                            if string.len(text) > 40 then
                                outputChatBox("#ff0000✘ #ffffffWpis jest za długi!", 255, 255, 255, true)
                                return false
                            end
                            if string.len(text) > 5 then
                                triggerServerEvent("since-mdt:wpis", resourceRoot, result[1].uid, text)
                                triggerServerEvent("since-mdt:search", resourceRoot, result[1].login)
                            end
                            tick_spam = getTickCount()
                        end
                    end
                end
            end
        end
    end
end
--addEventHandler("onClientClick", root, click)

function start()
    if getElementData(localPlayer, "player:faction") == 'SAPD' then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if vehicle then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1 then
                if getElementData(vehicle, "vehicle:police") then
                    if isEventHandlerAdded("onClientRender", root, render) then
                        removeEventHandler("onClientRender", root, render)
                        for i,v in ipairs(textures) do
                            if isElement(v) then
                                destroyElement(v)
                            end
                        end
                        for i,v in ipairs(fonts) do
                            if isElement(v) then
                                destroyElement(v)
                            end
                        end
                        textures = {}
                        fonts = {}
                        if isEventHandlerAdded("onClientKey", root, onKey) then
                            removeEventHandler("onClientKey", root, onKey)
                        end
                        if isEventHandlerAdded("onClientKey", root, onStartKey) then
                            removeEventHandler("onClientKey", root, onStartKey)
                        end
                        if isEventHandlerAdded("onClientClick", root, click) then
                            removeEventHandler("onClientClick", root, click)
                        end
                        showCursor(false)
                        exports["since-mdteditbox"]:dxDestroyEdit("mdt:upomnienia")
                        exports["since-mdteditbox"]:dxDestroyEdit("mdt:mandaty")
                        exports["since-mdteditbox"]:dxDestroyEdit("mdt:wyszukaj")
                        exports["since-mdteditbox"]:dxDestroyEdit("mdt:wpis")
                        guiSetInputMode("allow_binds")
                        unbindKey("mouse_wheel_down", "down", scroll_down)
                        unbindKey("mouse_wheel_up", "down", scroll_up)
                    else
                        fonts = {
                            [1] = dxCreateFont("fonts/Poppins-SemiBold.ttf", 26) or "default",
                            [2] = dxCreateFont("fonts/Poppins-SemiBold.ttf", 21) or "default",
                            [3] = dxCreateFont("fonts/Poppins-Regular.ttf", 18) or "default",
                            [4] = dxCreateFont("fonts/Poppins-Regular.ttf", 16) or "default",
                            [5] = dxCreateFont("fonts/Poppins-Regular.ttf", 14) or "default",
                            [6] = dxCreateFont("fonts/Poppins-SemiBold.ttf", 17) or "default",
                            [7] = dxCreateFont("fonts/Poppins-Regular.ttf", 15) or "default",
                        }
                        
                        textures = {
                            [1] = dxCreateTexture("files/tablet.png"),
                            [2] = dxCreateTexture("files/logo.png"),
                            [3] = dxCreateTexture("files/finger.png"),
                            [4] = dxCreateTexture("files/finger2.png"),
                            [5] = dxCreateTexture("files/bg.png"),
                            [6] = dxCreateTexture("files/bg2.png"),
                            [7] = dxCreateTexture("files/logo2.png"),
                            [8] = dxCreateTexture("files/badge.png"),
                        
                            [9] = dxCreateTexture("files/icon.png"),
                            [10] = dxCreateTexture("files/icon_l.png"),
                            [11] = dxCreateTexture("files/icon2.png"),
                            [12] = dxCreateTexture("files/icon2_l.png"),
                            [13] = dxCreateTexture("files/icon3.png"),
                            [14] = dxCreateTexture("files/icon3_l.png"),
                        
                            [15] = dxCreateTexture("files/bg3.png"),
                            [16] = dxCreateTexture("files/line.png"),
                            [17] = dxCreateTexture("files/line2.png"),
                        
                            [18] = dxCreateTexture("files/button.png"),
                            [19] = dxCreateTexture("files/button_l.png"),
                        
                            [20] = dxCreateTexture("files/avatar.png"),
                        
                            [21] = dxCreateTexture("files/no.png"),
                            [22] = dxCreateTexture("files/yes.png"),
                        
                            [23] = dxCreateTexture("files/line3.png"),
                        
                            [24] = dxCreateTexture("files/szczegoly.png"),
                            [25] = dxCreateTexture("files/search.png"),
                        }
                        current = "Start"
                        addEventHandler("onClientRender", root, render)
                        addEventHandler("onClientKey", root, onStartKey)
                        addEventHandler("onClientClick", root, click)
                        bindKey("mouse_wheel_down", "down", scroll_down)
                        bindKey("mouse_wheel_up", "down", scroll_up)
                        current, current2, current_wyszukaj = "Start", "Mandaty", "Mandaty"
                        alpha, alpha2, alpha3, alpha4, alpha5, alpha6, alpha7, alpha8, alpha9 = 255, 0, 0, 0, 0, 0, 0, 0, 0
                        finger_state, finger_end = 0, false
                        result, result_mandaty, result_wyroki, result_wpisy = false, false, false, false
                        first, first2, first3, first4 = 0, 0, 0, 0
                        y_button, y_button2 = sy/2 - 55/zoom, sy/2 - 55/zoom
                        x = (sx/2 - 26/zoom) + 325/zoom
                        first_wpisy, first_mandaty, first_wyroki, first_t = 0, 0, 0, 0
                        selected_mandaty = {}
                        selected_upomnienia = {}
                        grzywna = 0
                        guiSetInputMode("no_binds_when_editing")
                        for i,v in ipairs(mandaty) do
                            v.selected = false
                        end
                        for i,v in ipairs(upomnienia) do
                            v.selected = false
                        end
                    end
                end
            end
        end
    end
end
addCommandHandler("mdt", start)