commands = {

    {list = {'/mapaev'}, desc = 'Przenosi na mapę eventową'},
    {list = {'/warn'}, desc = 'Ostrzeżenie gracza'},
    {list = {'/wycisz'}, desc = 'Wyciszanie gracza (/wycisz zexty 1d Powod)'},
    {list = {'/odcisz'}, desc = 'Odciszanie gracza'},
    {list = {'/k'}, desc = 'Wyrzucanie gracza'},
    {list = {'/b'}, desc = 'Banowanie gracza (/b zexty 1d Powod)'},
    {list = {'/ub'}, desc = 'Odbanowanie gracza (/ub [Numer seryjny MTA])'},
    {list = {'/pb'}, desc = 'Banowanie gracza na zawsze (/pb zexty Powod)'},
    {list = {'/zpj'}, desc = 'Zabranie prawa jazdy (/zpj zexty 1d Powod)'},
    {list = {'/opj'}, desc = 'Oddanie prawa jazdy (/opj zexty)'},
    {list = {'/up'}, desc = 'Teleportowanie sie do góry na podaną odległość'},
    {list = {'/thru'}, desc = 'Teleportowanie sie do przodu na podaną odległość'},
    {list = {'/cv'}, desc = 'Tworzenie pojazdu (/cv infernus)'},
    {list = {'/dv'}, desc = 'Usuwanie stworzonego pojazdu'},
    {list = {'/tpev.set'}, desc = 'Ustawianie teleportu'},
    {list = {'/tpev.del'}, desc = 'Usuwanie teleportu'},
    {list = {'/clp'}, desc = 'Przyjmowanie zgłoszenia'},
    {list = {'/clo'}, desc = 'Odrzucanie zgłoszenia'},
    {list = {'/inv'}, desc = 'Tryb niewidzialności'},
    {list = {'/klatka'}, desc = 'Ustawianie klatki'},
    {list = {'/usun.klatke'}, desc = 'Usuwanie klatki'},
    {list = {'/heal'}, desc = 'Uleczenie gracza'},
    {list = {'/ginfo'}, desc = 'Informacje o graczu'},
    {list = {'/spec'}, desc = 'Obserwowanie gracza (/specoff kończy obserwacje)'},
    {list = {'/reporty'}, desc = 'Sprawdzanie ilości wykonanych reportów'},
    {list = {'/tt'}, desc = 'Teleportowanie sie do gracza'},
    {list = {'/th'}, desc = 'Teleportowanie gracza do siebie'},
    {list = {'/vtt'}, desc = 'Teleportowanie sie do pojazdu'},
    {list = {'/vth'}, desc = 'Teleportowanie pojazdu do siebie'},
    {list = {'/schowaj'}, desc = 'Chowanie pojazdu do przechowalni'},
    {list = {'/napraw.kod'}, desc = 'Naprawia kod synchronizacji z discordem'},
    {list = {'/cars'}, desc = 'Pokazuje blipy pojazdów na mapie'},
    {list = {'/zniszcz.krzak'}, desc = 'Usuwa krzak marihuany'},


}

copyTick = getTickCount()
uiElements = {}
commandsScroll = {k = 1, m = 8, n = 8}
adminsScroll = {k = 1, m = 7, n = 7}
records = {adminList = {}}
refreshTimer = nil
selectedUser = nil
checkStats = nil
cached = {}

function convertDate(date)
    local d = split(date, ' ')
    local d1 = split(d[1], '-')
    local d2 = split(d[2], ':')

    local time = getRealTime()
    local year = time.year + 1900
    local month = time.month + 1
    local day = time.monthday
    local hour = time.hour
    local minute = time.minute
    local second = time.second

    local years = year - d1[1]
    local months = month - d1[2]
    local days = day - d1[3]
    local hours = hour - d2[1]
    local minutes = minute - d2[2]
    local seconds = second - d2[3]

    if months < 0 then
        years = years - 1
        months = months + 12
    end

    if days < 0 then
        months = months - 1
        days = days + 30
    end

    if hours < 0 then
        days = days - 1
        hours = hours + 24
    end

    if minutes < 0 then
        hours = hours - 1
        minutes = minutes + 60
    end

    if years > 0 then
        return years..' lat temu'
    elseif months > 0 then
        return months..' miesięcy temu'
    elseif days > 0 then
        return days..' dni temu'
    elseif hours > 0 then
        return hours..' godzin temu'
    elseif minutes > 1 then
        return minutes..' minut temu'
    else
        return 'Teraz'
    end
end

local alphas = {}

function drawButton(text, x, y, w, h, color, alpha)
    if not alphas[text] then
        alphas[text] = 175
    end

    local isIn = isMouseInPosition(x, y, w, h)
    
    if isIn then
        if alphas[text] < 255 then
            alphas[text] = alphas[text] + 5
        end
    else
        if alphas[text] > 175 then
            alphas[text] = alphas[text] - 5
        end
    end

    local alpha = alpha * alphas[text]/255

    dxDrawImage(x, y, w, h, 'data/button.png', 0, 0, 0, tocolor(color[1], color[2], color[3], alpha))
    dxDrawText(text, x, y - 1, x + w, y + h, tocolor(255, 255, 255, alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
end

tabs = {
    
    
    {
        
        name = 'Lista administracji',
        desc = 'Lista aktualnej administracji serwera',
        icon = 'data/home.png',
        
        toRender = function(alpha)
            local offset = 0
            drawScrollbar(records.adminList, sx/2 + 453/zoom, sy/2 - 162/zoom - 25/zoom, 2, 362/zoom, adminsScroll.m, adminsScroll.k, 100*alpha)
            for i, v in ipairs(records.adminList) do
                if i >= adminsScroll.k and i <= adminsScroll.n then 
                    local isIn = isMouseInPosition(sx/2 - 210/zoom, sy/2 - 187/zoom + offset, 660/zoom, 50/zoom)
                    local r, g, b = unpack(exports['since-core']:getRankColor(v.level, false))
                    local rankName = exports['since-core']:getRankName(v.level, false)

                    if selectedUser == v.serial then
                        dxDrawRectangle(sx/2 - 210/zoom, sy/2 - 187/zoom + offset, 660/zoom, 50/zoom, tocolor(255, 255, 255, 25*alpha))
                    end
                    dxDrawRectangle(sx/2 - 210/zoom, sy/2 - 187/zoom + offset, 660/zoom, 50/zoom, isIn and tocolor(255, 255, 255, 15*alpha) or tocolor(255, 255, 255, 25*alpha))

                    dxDrawText(v.nick, sx/2 - 200/zoom, sy/2 - 160/zoom + offset, nil, nil, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom', false, false, false, true) 
                    dxDrawText(rankName, sx/2 - 200/zoom, sy/2 - 160/zoom + offset, nil, nil, tocolor(r, g, b, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true) 

                    dxDrawText('Wykonane reporty', sx/2 - 25/zoom, sy/2 - 160/zoom + offset, nil, nil, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom', false, false, false, true) 
                    dxDrawText(v.reporty, sx/2 - 25/zoom, sy/2 - 160/zoom + offset, nil, nil, tocolor(46, 117, 111, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true) 

                    dxDrawText('Ostatnio aktywny', sx/2 + 185/zoom, sy/2 - 160/zoom + offset, nil, nil, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom', false, false, false, true) 
                    dxDrawText(convertDate(v.actived), sx/2 + 185/zoom, sy/2 - 160/zoom + offset, nil, nil, tocolor(46, 117, 111, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true) 

                    local isIn2 = isMouseInPosition(sx/2 + 400/zoom, sy/2 - 178/zoom + offset, 28/zoom, 28/zoom) and 1 or 0.9
                    dxDrawImage(sx/2 + 400/zoom, sy/2 - 178/zoom + offset, 28/zoom, 28/zoom, 'data/cmd.png', 0, 0, 0, tocolor(225, 225, 225, ((isIn and 200 or 155)*alpha)*isIn2))

                    if isIn2 == 1 then
                        checkStats = v
                    end

                    offset = offset + 50/zoom + 2
                end
            end

            if checkStats then
                local cx, cy = getCursorPosition()
                cx, cy = cx*sx, cy*sy

                dxDrawRectangle(cx + 10/zoom, cy + 10/zoom, 250/zoom, 200/zoom, tocolor(45, 45, 45, 255*alpha))
                dxDrawText('Ogólne statystyki członka', cx + 15/zoom, cy + 36/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(checkStats.nick, cx + 15/zoom, cy + 36/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 10/zoom), 'left', 'top', false, false, false, true)
                local textWidth = dxGetTextWidth(checkStats.nick, 1, exports['since-fonts']:getFont('Inter-Regular', 10/zoom))
                dxDrawRectangle(cx + 15/zoom, cy + 60/zoom, 240/zoom, 1, tocolor(255, 255, 255, 100*alpha))

                local stats = fromJSON(checkStats.stats) or {}

                dxDrawText('Schowane pojazdy', cx + 15/zoom, cy + 80/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.vehicles or 0, cx + 255/zoom, cy + 80/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
            
                dxDrawText('Zabrane licencje', cx + 15/zoom, cy + 100/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.license or 0, cx + 255/zoom, cy + 100/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
                
                dxDrawText('Nałożone bany', cx + 15/zoom, cy + 120/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.bans or 0, cx + 255/zoom, cy + 120/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
                
                dxDrawText('Wyciszenia', cx + 15/zoom, cy + 140/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.mutes or 0, cx + 255/zoom, cy + 140/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
                
                dxDrawText('Nadane ostrzeżenia', cx + 15/zoom, cy + 160/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.warns or 0, cx + 255/zoom, cy + 160/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
                
                dxDrawText('Wyrzuconych graczy', cx + 15/zoom, cy + 180/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.kicks or 0, cx + 255/zoom, cy + 180/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
                
                dxDrawText('Wykonane zgłoszenia', cx + 15/zoom, cy + 200/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(stats.reports or 0, cx + 255/zoom, cy + 200/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'bottom', false, false, false, true)
            end 

            if not selectedUser then
                dxDrawText('Dostępne akcje', sx/2 - 210/zoom, sy/2 + 210/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom', false, false, false, true) 
                dxDrawText('Kliknij na członka ekipy aby wyświetlić dostępne opcje', sx/2 - 210/zoom, sy/2 + 210/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true) 
            else
               drawButton('Awansuj', sx/2 - 210/zoom, sy/2 + 196/zoom, 128/zoom, 32/zoom, {46, 117, 111}, 225*alpha)
               drawButton('Degraduj', sx/2 - 80/zoom, sy/2 + 196/zoom, 128/zoom, 32/zoom, {255, 175, 125}, 225*alpha)
               drawButton('Wyrzuć', sx/2 + 50/zoom, sy/2 + 196/zoom, 128/zoom, 32/zoom, {255, 125, 125}, 225*alpha)
            end

            checkStats = nil
        end,

        onOpen = function()
            triggerServerEvent('getAdminsList', resourceRoot)

            if not refreshTimer then
                refreshTimer = setTimer(function()
                    triggerServerEvent('getAdminsList', resourceRoot)
                end, 5000, 0)
            end
        end,

        onClose = function()
            if isTimer(refreshTimer) then
                killTimer(refreshTimer)
                refreshTimer = nil
            end
        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                if isMouseInPosition(sx/2 - 210/zoom, sy/2 + 196/zoom, 128/zoom, 32/zoom) then
                    if not getElementData(localPlayer, 'player:admin') then 
                        return 
                    end
                    triggerServerEvent('manageAdmins', resourceRoot, 'rankup', selectedUser)
                elseif isMouseInPosition(sx/2 - 80/zoom, sy/2 + 196/zoom, 128/zoom, 32/zoom) then
                    if not getElementData(localPlayer, 'player:admin') then 
                        return 
                    end
                    triggerServerEvent('manageAdmins', resourceRoot, 'rankdown', selectedUser)
                elseif isMouseInPosition(sx/2 + 50/zoom, sy/2 + 196/zoom, 128/zoom, 32/zoom) then
                    if not getElementData(localPlayer, 'player:admin') then 
                        return 
                    end
                    triggerServerEvent('manageAdmins', resourceRoot, 'removerank', selectedUser)
                end

                local offset = 0
                for i, v in ipairs(records.adminList) do
                    if i >= adminsScroll.k and i <= adminsScroll.n then 
                        local isIn = isMouseInPosition(sx/2 - 210/zoom, sy/2 - 187/zoom + offset, 660/zoom, 50/zoom)

                        if isIn then
                            if selectedUser == v.serial then
                                selectedUser = nil
                            else
                                selectedUser = v.serial
                            end
                        end

                        offset = offset + 50/zoom + 2
                    end
                end
            end
        end,

    },

    {

        name = 'Komendy',
        desc = 'Podstawowe komendy',
        icon = 'data/cmd.png',

        toRender = function(alpha)
            local y = sy/2 - 162/zoom
            for i, v in ipairs(commands) do
                if i >= commandsScroll.k and i <= commandsScroll.n then 
                    local cmd = ''

                    if #v.list > 1 then
                        cmd = table.concat(v.list, ', ')
                    else
                        cmd = v.list[1]
                    end

                    local isIn = isMouseInPosition(sx/2 - 210/zoom, y - 25/zoom, 660/zoom, 50/zoom)

                    dxDrawRectangle(sx/2 - 210/zoom, y - 25/zoom, 660/zoom, 50/zoom, isIn and tocolor(46, 117, 111, 15*alpha) or tocolor(255, 255, 255, 15*alpha))
                    dxDrawText(cmd, sx/2 - 200/zoom, y + 4/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
                    dxDrawText(v.desc, sx/2 - 200/zoom, y + 4, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top', false, false, false, true)

                    if isIn then
                        -- get cursor position
                        local cx, cy = getCursorPosition()
                        cx, cy = cx*sx, cy*sy

                        local text = 'Kliknij aby skopiować komendę'

                        if getTickCount() - copyTick < 500 then
                            text = 'Skopiowano'
                        end

                        if getKeyState('mouse1') and getTickCount() - copyTick > 500 then
                            copyTick = getTickCount()

                            if #v.list > 1 then
                                local cmd = v.list[1]:sub(2)
                                setClipboard(cmd)
                            else
                                local cmd = cmd:sub(2)
                                setClipboard(cmd)
                            end
                        end

                        local w = dxGetTextWidth(text, 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom))
                        local h = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom))

                        dxDrawRectangle(cx + 10/zoom, cy - h - 5/zoom, w + 10/zoom, h + 10/zoom, tocolor(255, 255, 255, 20*alpha))
                        dxDrawText(text, cx + 15/zoom, cy - h, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top')
                    end

                    y = y + 50/zoom + 2
                end
            end

            drawScrollbar(commands, sx/2 + 453/zoom, sy/2 - 162/zoom - 25/zoom, 2, 412/zoom, commandsScroll.m, commandsScroll.k, 100*alpha)
        end,

        onOpen = function()
            commandsScroll = {k = 1, m = 8, n = 8}
        end,

        onClose = function()

        end,

        onClick = function()

        end,

    },

    {

        name = 'Kary',
        desc = 'Nadawanie kar offline',
        icon = 'data/cmd.png',

        toRender = function(alpha)
            if not uiElements['edit_user'] then return end
            if not uiElements['edit_reason'] then return end
            if not uiElements['scroll_time'] then return end

            dxDrawText('Długość kary', sx/2 - 215/zoom + (220/2)/zoom, sy/2 - 125/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'bottom', false, false, false, true)
            
            dxDrawText('Typy kar', sx/2 + 15/zoom + (220/2)/zoom, sy/2 - 80/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'center', 'bottom', false, false, false, true)
            dxDrawText('zpj - Zabranie prawa jazdy\nban - Zbanowanie gracza\nmute - Wyciszenie gracza', sx/2 + 15/zoom + (220/2)/zoom, sy/2 - 80/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)
            
            local time = math.floor(exports['since-scrollbar']:getScrollProgress(uiElements['scroll_time']) or 0)
            local editReason = exports['since-gui']:getEditboxText(uiElements['edit_reason']) or 'Brak'

            if string.len(editReason) > 30 then
                editReason = string.sub(editReason, 1, 30)..'...'
            elseif string.len(editReason) == 0 then
                editReason = 'Brak'
            end

            if exports['since-gui']:isCheckboxChecked(uiElements['checkbox_perm']) then
                exports['since-gui']:setCheckBoxChecked(uiElements['checkbox_days'], false)
            end
    
            if exports['since-gui']:isCheckboxChecked(uiElements['checkbox_days']) then
                exports['since-gui']:setCheckBoxChecked(uiElements['checkbox_perm'], false)
            end

            cached.time = time
            cached.time = exports['since-gui']:isCheckboxChecked(uiElements['checkbox_days']) and cached.time * 1 or cached.time

            if not exports['since-gui']:isCheckboxChecked(uiElements['checkbox_perm']) and not exports['since-gui']:isCheckboxChecked(uiElements['checkbox_days']) then
                timeType = cached.time..' godzin'
            else
                timeType = exports['since-gui']:isCheckboxChecked(uiElements['checkbox_perm']) and 'Na zawsze' or cached.time..' dni'
            end
            
            dxDrawText(timeType, sx/2 - 215/zoom + (220/2)/zoom, sy/2 - 90/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'bottom', false, false, false, true)
            
            local punish = cached.punishPlayer and '#7dd2ff'..cached.punishPlayer or '#ff7d7dBrak'
            dxDrawText('Podsumowanie', sx/2 - 215/zoom, sy/2 + 15/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
            dxDrawText('Karany gracz: '..punish..'#ffffff\nTyp kary: #7dd2ff'..(exports['since-gui']:getEditboxText(uiElements['edit_type']) or 'Brak')..'#ffffff\nDługośc kary: #ff7d7d'..timeType..'#ffffff\nPowód: #7dd2ff'..editReason, sx/2 - 215/zoom, sy/2 + 15/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
        
            drawButton('Nadaj karę', sx/2 - 215/zoom, sy/2 + 90/zoom, 128/zoom, 32/zoom, {46, 117, 111}, 225*alpha)
        end,

        onOpen = function()
            cached.punishPlayer = nil
            uiElements['edit_user'] = exports['since-gui']:createEditbox('Wprowadź Serial lub UID...', sx / 2 - 215/zoom, sy/2 - 185/zoom, 220/zoom, 36/zoom, {255, 255, 255}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
                maxChars = 100,
            })

            uiElements['edit_reason'] = exports['since-gui']:createEditbox('Wprowadź powód...', sx / 2 + 15/zoom, sy/2 - 185/zoom, 400/zoom, 36/zoom, {255, 255, 255}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                space = true,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
                maxChars = 100,
            })

            uiElements['edit_type'] = exports['since-gui']:createEditbox('Typ kary...', sx / 2 + 15/zoom, sy/2 - 145/zoom, 220/zoom, 36/zoom, {255, 255, 255}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })

            uiElements['checkbox_days'] = exports['since-gui']:createCheckbox('Dni', sx/2 - 215/zoom, sy/2 - 85/zoom, 24/zoom, 24/zoom, {255, 255, 255, 255}, {
                gap = 2/zoom,
                font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                textColor = {255, 255, 255, 200},
                hoverColor = {255, 255, 255, 155},
                textHoverColor = {255, 255, 255, 155},
                image = textures['checkbox'],
                activeImage = textures['checkbox_active']
            })

            uiElements['checkbox_perm'] = exports['since-gui']:createCheckbox('Na zawsze', sx/2 - 215/zoom, sy/2 - 55/zoom, 24/zoom, 24/zoom, {255, 255, 255, 255}, {
                gap = 2/zoom,
                font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                textColor = {255, 255, 255, 200},
                hoverColor = {255, 255, 255, 155},
                textHoverColor = {255, 255, 255, 155},
                image = textures['checkbox'],
                activeImage = textures['checkbox_active']
            })

            uiElements['scroll_time'] = exports['since-scrollbar']:createScrollbar(sx/2 - 215/zoom, sy/2 - 120/zoom, 220/zoom, 6/zoom, {255, 255, 255}, true, 0)
        end,

        onClose = function()
            if (uiElements['edit_user']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_user'])
            end

            if (uiElements['edit_type']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_type'])
            end

            if (uiElements['edit_reason']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_reason'])
            end

            if uiElements['scroll_time'] then
                exports['since-scrollbar']:destroyScroll(uiElements['scroll_time'])
            end

            if (uiElements['checkbox_days']) then
                exports['since-gui']:destroyUIElement(uiElements['checkbox_days'])
            end

            if (uiElements['checkbox_perm']) then
                exports['since-gui']:destroyUIElement(uiElements['checkbox_perm'])
            end
        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                if isMouseInPosition(sx/2 - 215/zoom, sy/2 + 90/zoom, 128/zoom, 32/zoom) then
                    local user = exports['since-gui']:getEditboxText(uiElements['edit_user'])
                    local time = math.floor(exports['since-scrollbar']:getScrollProgress(uiElements['scroll_time']) or 0)
                    local punishType = exports['since-gui']:getEditboxText(uiElements['edit_type'])
                    local perm = exports['since-gui']:isCheckboxChecked(uiElements['checkbox_perm'])
                    local days = exports['since-gui']:isCheckboxChecked(uiElements['checkbox_days'])
                    local reason = exports['since-gui']:getEditboxText(uiElements['edit_reason'])
                    local timeType = 'hours'

                    if string.len(reason) == 0 then
                        reason = 'Brak'
                    end

                    if string.len(user) == 0 then
                        return exports['since-notifications']:sendNotification('error', 'Wprowadź UID/Serial gracza', 'error')
                    end

                    if string.len(punishType) == 0 then
                        return exports['since-notifications']:sendNotification('error', 'Wprowadź typ kary', 'error')
                    end

                    if time == 0 and perm then
                        time = 1
                    elseif time == 0 then
                        return exports['since-notifications']:sendNotification('error', 'Wprowadź długość kary')
                    end

                    if perm then
                        time = 0
                        timeType = 'perm'
                    elseif days then
                        timeType = 'days'
                    end

                    triggerServerEvent('addOfflinePunishment', resourceRoot, user, time, punishType, timeType, reason)
                end
            end
        end,

    },

}

addEvent('getAdminsList', true)
addEventHandler('getAdminsList', resourceRoot, function(tbl)
    records.adminList = tbl
end)

getResourceName(getThisResource(), true, 702053835); if true then return end