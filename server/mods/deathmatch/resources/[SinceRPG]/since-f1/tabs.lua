rules = [[§1 Każdy użytkownik ma obowiązek zachować pełną kulturę osobistą.
§2 Zakazuje się notorycznego przeklinania na kanałach tekstowych jak i głosowych.
§3 Zakazuje się nagrywania głosu innych osób na kanale głosowym.
§4 Zakazuje się korzystania z jakichkolwiek modulatorów głosu, bindów itp.
§5 Zakazuje się podszywania pod administrację serwera.
§6 Nieznajomość regulaminu nie zwalnia z jego przestrzegania.
§7 Zakazuje się używania wulgarnych oraz wyzywających inne osoby nicków.
§8 Zakazuje się posiadania wulgarnych, wyzywających inne osoby avatarów.
§9 Zakazuje się wysyłania zaproszeń na inne serwery Discord (również w prywatnej wiadomości)
§10 Niestosowanie się do regulaminu serwer Discord może zostać ukarane przez administrację.]]

diamond_info = [[- Dostęp do unikalnych skinów
    - Zwiększony mnożnik zarobku
    - Możliwość korzystania z czatu /d
    - Wyróżnienie w postaci koloru nicku
    - Wyróżnienie w postaci rangi
    ]]

commands = {

    {list = {'/share'}, desc = 'Udostępnianie kluczy do pojazdu'},
    {list = {'/wezwij.sapd', '/wezwij.safd', '/wezwij.sara'}, desc = 'Wzywanie frakcji'},
    {list = {'/report'}, desc = 'Zgłoś gracza'},
    {list = {'/v'}, desc = 'Czat premium'},
    {list = {'/d'}, desc = 'Czat diamond'},
    {list = {'/ogloszenie'}, desc = 'Wyślij ogłoszenie'},
    {list = {'/pmoff'}, desc = 'Wyłącz wiadomości prywatne'},
    {list = {'/pmon'}, desc = 'Włącz wiadomości prywatne'},
    {list = {'/admins'}, desc = 'Administracja na służbie'},
    {list = {'/model'}, desc = 'Sprawdź który to model pojazdu na serwerze'},
    {list = {'/revive', '/podnies'}, desc = 'Podnoszenie gracza podczas BW'},

}

commandsScroll = {k = 1, m = 8, n = 8}
chart = nil

local copyTick = getTickCount()


tabs = {


    {

        name = 'O serwerze',
        desc = 'Podstawowe informacje o serwerze',
        icon = 'data/home.png',

        toRender = function(alpha)
            dxDrawText('Zarząd serwera', sx/2 - 210/zoom, sy/2 - 165/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
            dxDrawText('tworix, xelvor,', sx/2 - 210/zoom, sy/2 - 165/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top', false, false, false, true)

            dxDrawText('Forum serwerowe', sx/2 - 210/zoom, sy/2 - 115/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
            dxDrawText('OFFLINE', sx/2 - 210/zoom, sy/2 - 115/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top', false, false, false, true)

            dxDrawText('Autorzy', sx/2 - 210/zoom, sy/2 - 65/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
            dxDrawText('Skrypt: #2E756Fzexty, Hixagon#ffffff\nModele: #2E756Fdamix10#ffffff\nMapy: #2E756Fzexty, damix10#ffffff\nGrafiki: #2E756Fzexty, Hixagon#ffffff', sx/2 - 210/zoom, sy/2 - 65/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top', false, false, false, true)
            
            dxDrawText('Statystyki graczy', sx/2 - 210/zoom, sy/2 + 25/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
            dxDrawText('Liczba graczy w przeciągu ostatnich 7 dni', sx/2 - 210/zoom, sy/2 + 25/zoom, nil, nil, tocolor(155, 255, 155, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top', false, false, false, true) 
        end,

        onOpen = function()
            triggerServerEvent('getPlayerRecords', resourceRoot)

            chart = exports['since-charts']:createChart({
                    x = sx/2 - 210/zoom,
                    y = sy/2 + 55/zoom,
                    w = 675/zoom,
                    h = 170/zoom,
                    radius = 10,
                    blur = false,
                    type = 'line',
                    background = tocolor(125, 125, 125, 25),
                    color = tocolor(155, 255, 155, 175),
                    bottomColor = tocolor(155, 255, 155, 75),
                    line = tocolor(155, 255, 155, 175),
                    point = tocolor(155, 255, 155, 255),
                    pointSize = 10,
                    min = 0,
                    max = 225,
                    width = 5,
                    round = 10,
                    marginHorizontal = 5,
                    marginVertical = 10,
                    font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
                
                    data = {
                        0, 0, 0, 0, 0, 0, 0
                    },
                    
                    labels = {
                        horizontalPosition = 'left',
                        verticalPosition = 'bottom',
                        horizontal = {
                            '7 dni temu', '6 dni temu', '5 dni temu', '4 dni temu', '3 dni temu', 'Wczoraj', 'Dzisiaj'
                        },
                        vertical = 50
                    }
                })
        end,

        onClose = function()
            if isElement(chart) then
                destroyElement(chart)
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

    },

    {
        
        name = 'Diamond',
        desc = 'Informacje dotyczące premium',
        icon = 'data/star.png',
        toRender = function(alpha)
            dxDrawImage(sx/2 - 199.5/zoom, sy/2 + 1/zoom, 194/zoom, 225/zoom, 'data/diamond_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Co zyskujesz?', sx/2 - 102.5/zoom, sy/2 + 110/zoom, nil, nil, tocolor(255, 255, 255, 229*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'center', 'bottom')
            dxDrawText(diamond_info, sx/2 - 102.5/zoom, sy/2 + 110/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 7/zoom), 'center', 'top')
            dxDrawText('Diamond', sx/2 - 102.5/zoom, sy/2 + 75/zoom, nil, nil, tocolor(88, 183, 252, 229*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'center', 'top')

            dxDrawText('Kupno statusu diamond', sx/2 - 200.5/zoom, sy/2 - 164/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Kupno punktów premium', sx/2 - 200.5/zoom, sy/2 - 108/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Płatności', sx/2 - 199.5/zoom, sy/2 - 66/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Aby zakupić konto diamond należy otworzyć panel gracza (F5) i przejść do zakładki “Sklep”. Następnie\nwybierz interesującą cię opcje z kilku dostępnych.', sx/2 - 200.5/zoom, sy/2 - 166/zoom, nil, nil, tocolor(255, 255, 255, 191*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')
            dxDrawText('Punkty premium możesz zakupić pisząc do jednego z właścicieli na naszym serwerze discord.', sx/2 - 200.5/zoom, sy/2 - 108/zoom, nil, nil, tocolor(255, 255, 255, 191*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')
            dxDrawText('Bilk, PaySafeCard, PayPal, Skrill, Przelew bankowy', sx/2 - 199.5/zoom, sy/2 - 66/zoom, nil, nil, tocolor(255, 255, 255, 191*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')
        end,

        onOpen = function()
            
        end,

        onClose = function()

        end,


    },

    {

        name = 'Regulamin',
        desc = 'Przestrzegaj zasad na serwerze',
        icon = 'data/rules.png',
        toRender = function(alpha) 
            dxDrawText('Regulamin serwera cloudyMTA', sx/2 - 210/zoom, sy/2 - 165/zoom, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
            dxDrawText(rules, sx/2 - 210/zoom, sy/2 - 165/zoom, nil, nil, tocolor(225, 225, 225, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 10/zoom), 'left', 'top', false, false, false, true)

            dxDrawText('Uwaga', sx/2 - 210/zoom, sy/2 + 45/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom', false, false, false, true) 
            dxDrawText('Nie stosowanie sie do regulaminu może liczyć się z karami które będą nakładane na twoje konto!', sx/2 - 210/zoom, sy/2 + 45/zoom, nil, nil, tocolor(225, 125, 125, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Regular', 10/zoom), 'left', 'top', false, false, false, true)
        end,

        onOpen = function()
            
        end,

        onClose = function()

        end,
        
    },


}

function sortDate(a, b)
    return a.date < b.date
end

addEvent('onPlayersStatsReceive', true)
addEventHandler('onPlayersStatsReceive', resourceRoot, function(recived)
    if not chart then
        return
    end

    local tbl = {}

    local id = 7
    for i = 1, 7 do
        local v = recived[id]

        if v then
            table.insert(tbl, v.players)
        else
            table.insert(tbl, 0)
        end
        id = id - 1
    end
    
    local data = getElementData(chart, 'chart:data')
    data.data = {
        unpack(tbl)
    }
    setElementData(chart, 'chart:data', data)
end)

getResourceName(getThisResource(), true, 702053835); if true then return end