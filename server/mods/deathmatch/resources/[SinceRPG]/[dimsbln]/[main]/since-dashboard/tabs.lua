activeTab = 1

vehiclesList = {}
refreshTimer = nil
sliders = {}

orgRanks = {
    [4] = {
        name = 'Lider',
        color = 0xCCC23232,
        textColor = 0xFFFF4444,
    },
    [3] = {
        name = 'V-Lider',
        color = 0xCCFFAC60,
        textColor = 0xFFFFAC60,
    },
    [2] = {
        name = 'Członek',
        color = 0xCC60FF66,
        textColor = 0xFF60FF66,
    },
    [1] = {
        name = 'Rekrut',
        color = 0xCCFFFFFF,
        textColor = 0xFFFFFFFF,
    },
}

quest = {}

local jobs = {
    {
        name = 'Magazynier',
        tp = {2184.68, -2261.22, 13.42, -0.00, 0.00, 110.69},
    },
    {
        name = 'Kurier',
        tp = {103.37, -284.58, 1.58, -0.00, 0.00, 84.11},
    },
    {
        name = 'Kosiarki',
        tp = {2435.48, 117.41, 26.47, -0.00, 0.00, 84.11},
    },
    {
        name = 'Górnik',
        tp = {-582.40, -1057.63, 23.68, -0.00, 0.00, 84.11},
    },
    {
        name = 'Lawety',
        tp = {1057.28, 1934.57, 10.82, -0.00, 0.00, 84.11},
    },
    {
        name = 'Dostawca',
        tp = {1880.04, 2071.63, 11.06, -0.00, 0.00, 84.11},
    },
    {
        name = 'Grzybiarz',
        tp = {-1069.47, -1285.66, 129.22, -0.00, 0.00, 110.69},
    },
    {
        name = 'Szambiarz',
        tp = {613.78, 1226.15, 11.79, -0.00, 0.00, 110.69},
    },
    {
        name = 'Maszynista',
        tp = {1756.22, -1944.88, 13.57, -0.00, 0.00, 110.69},
    },
    {
        name = 'Rybak',
        tp = {-366.33, 1193.81, 19.75, -0.00, 0.00, 110.69},
    },
    {
        name = 'eTransporter',
    },
    {
        name = 'Logistyka lądowa',
        elementData = 'logistyka',
        tp = {1230.04, 185.42, 19.85, -0.00, 0.00, 267.81},
    },
    {
        name = 'Spedycja lotnicza',
        elementData = 'Aircraft',
        tp = {1999.28, -2403.11, 13.55, -0.00, 0.00, 267.81},
    },
}

scroll.jobs = {k = 1, n = 8, m = 8}
scroll.friends = {k = 1, n = 12, m = 12}

local function getNextLevelExp(level)
    return math.floor(100 * ((level + 1) ^ 2))
end

function getVehicles(c, edit1)
    local vehicles = {}
    for k,v in pairs(c) do
		local name = exports['since-vehiclenames']:getVehicleName(v.model)
        if name:lower():find(exports['since-gui']:getEditboxText(edit1):lower()) or tostring(v.id or 0):lower():find(exports['since-gui']:getEditboxText(edit1)) then
            table.insert(vehicles, v)
        end
    end
    return vehicles
end

local function upper(str)
    return str:sub(1, 1):upper()..str:sub(2)
end

function convertTime(minutes)
    local minutes = tonumber(minutes)
    local hours = math.floor(minutes / 60)
    local minutes = minutes - (hours * 60)

    return hours, minutes
end

function convertDate(date)
    local d = split(date, ' ')
    local d1 = split(d[1], '-')
    local d2 = split(d[2], ':')

    -- return hours ago, days ago, months ago, years ago
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

    -- check years by months
    if months < 0 then
        years = years - 1
        months = months + 12
    end

    -- check months by days

    if days < 0 then
        months = months - 1
        days = days + 30
    end

    -- check days by hours

    if hours < 0 then
        days = days - 1
        hours = hours + 24
    end

    -- check hours by minutes

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
    elseif minutes > 0 then
        return minutes..' minut temu'
    else
        return 'Niecała minuta temu'
    end
end

tabs = {


    {

        name = 'Informacje o koncie',
        desc = 'Podstawowe informacje o twoim koncie',
        icon = 'data/home.png',

        toRender = function(alpha)
            local playedHours, playedMinutes = convertTime(getElementData(localPlayer, 'player:hours'))
            local registerDate = convertDate(cache.playerData.registerDate or '2024-01-01 00:00:00')
            local playerData = {

                {name = 'UID', data = getElementData(localPlayer, 'player:sid')},
                {name = 'Numer ID', data = getElementData(localPlayer, 'id')},
                {name = 'Twój nick', data = getPlayerName(localPlayer)},
                {name = 'Reputacja (SRP)', data = getElementData(localPlayer, 'player:srp') or 0},
                {name = 'Punkty premium', data = (getElementData(localPlayer, 'player:pp') or 0)},
                {name = 'wPLN', data = cache.playerData.wPLN},
                {name = 'Przegrany czas', data = playedHours..' godz. '..playedMinutes..' min.'},
                {name = 'Rejestracja', data = registerDate},

            }

            local playerMoney = {

                {name = 'Gotówka', data = '$ '..addCommas(getPlayerMoney(localPlayer))},
                {name = 'Stan konta bankowego', data = '$ '..addCommas((cache.playerData.bankMoney or 0))},

            }

            local isDiscord = getElementData(localPlayer, 'player:discord')
            local isOrganization = getElementData(localPlayer, 'player:organization')
            local licenses = getElementData(localPlayer, 'player:licenses') or {}

            dxDrawImage(sx/2 - 213/zoom, sy/2 - 193/zoom, 335/zoom, 150/zoom, 'data/user_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawImage(sx/2 - 213/zoom, sy/2 - 39/zoom, 335/zoom, 150/zoom, 'data/bank_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawImage(sx/2 + 126/zoom, sy/2 - 39/zoom, 335/zoom, 150/zoom, 'data/organization_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawImage(sx/2 + 125.999/zoom, sy/2 - 193/zoom, 335/zoom, 150/zoom, 'data/license_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawImage(sx/2 - 213/zoom, sy/2 + 115/zoom, 674/zoom, 122/zoom, 'data/discord_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

            dxDrawText('Twoje konto', sx/2 - 200/zoom, sy/2 - 165/zoom, nil, nil, tocolor(255, 225, 155, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
            local offset = 0
            for i,v in ipairs(playerData) do
                dxDrawText(v.name..': ', sx/2 - 200/zoom, sy/2 - 165/zoom + offset, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true)
                local textWidth = dxGetTextWidth(v.name..': ', 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom)) + 1/zoom
                dxDrawText(v.data, sx/2 - 200/zoom + textWidth, sy/2 - 165/zoom + offset, nil, nil, tocolor(255, 225, 155, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top', false, false, false, true)
                
                offset = offset + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom))
            end

            dxDrawText('Twoje licencje', sx/2 + 138/zoom, sy/2 - 165/zoom, nil, nil, tocolor(255, 155, 155, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
            
            local licenseCount = 0
            for k, v in pairs(licenses) do
                licenseCount = licenseCount + 1
            end

            if licenseCount == 0 then
                dxDrawText('Nie posiadasz licencji', sx/2 + 138/zoom, sy/2 - 165/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
            else
                local offset = 0
                for k, v in pairs(licenses) do
                    local name = k == 'L' and 'Licencja lotnicza' or 'Prawo jazdy kat.'
                    dxDrawText(name..' '..utf8.upper(k)..': ', sx/2 + 138/zoom, sy/2 - 165/zoom + offset, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
                    local textWidth = dxGetTextWidth(name..' '..utf8.upper(k)..': ', 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + 1/zoom
                    dxDrawText(v == true and 'Posiadane' or 'Nie posiadane', sx/2 + 138/zoom + textWidth, sy/2 - 165/zoom + offset, nil, nil, v == true and tocolor(155, 255, 155, 200*alpha) or tocolor(255, 155, 155, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
    
                    offset = offset + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom))
                end
            end
            

            dxDrawText('Majątek', sx/2 - 200/zoom, sy/2 - 8/zoom, nil, nil, tocolor(46, 117, 111, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
            local offset = 0
            for k, v in pairs(playerMoney) do
                dxDrawText(v.name..': ', sx/2 - 200/zoom, sy/2 - 8/zoom + offset, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
                local textWidth = dxGetTextWidth(v.name..': ', 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + 1/zoom
                dxDrawText(v.data, sx/2 - 200/zoom + textWidth, sy/2 - 8/zoom + offset, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                offset = offset + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom))
            end

            dxDrawText('Twoja organizacja', sx/2 + 138/zoom, sy/2 - 8/zoom, nil, nil, tocolor(195, 125, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
            if isOrganization then
                dxDrawText('Nazwa organizacji: #eb7aff'..isOrganization.name..' - #'..upper(isOrganization.tag), sx/2 + 138/zoom, sy/2 - 8/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
                dxDrawText('Ranga w organizacji: #2E756F'..orgRanks[isOrganization.rank].name, sx/2 + 138/zoom, sy/2 - 8/zoom + 16/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
                dxDrawText('Poziom organizacji: #7af8ff'..isOrganization.level..' #77b2b5('..isOrganization.exp..' / '..getNextLevelExp(isOrganization.level)..' EXP)', sx/2 + 138/zoom, sy/2 - 8/zoom + 32/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
            else
                dxDrawText('Nie należysz do żadnej organizacji!', sx/2 + 138/zoom, sy/2 - 8/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
            end

            dxDrawText('Status połączenia z discordem', sx/2 - 200/zoom, sy/2 + 145/zoom, nil, nil, tocolor(135, 185, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
            if isDiscord then
                dxDrawText('Twoje konto jest połączone z discordem!', sx/2 - 200/zoom, sy/2 + 145/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                dxDrawText('Twój identyfikator discord', sx/2 - 200/zoom, sy/2 + 204/zoom, nil, nil, tocolor(135, 185, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(isDiscord.discordID, sx/2 - 200/zoom, sy/2 + 204/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                dxDrawText('Twój login discord', sx/2 - 15/zoom, sy/2 + 204/zoom, nil, nil, tocolor(135, 185, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(isDiscord.discordNick, sx/2 - 15/zoom, sy/2 + 204/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                dxDrawText('Data połączenia konta', sx/2 + 120/zoom, sy/2 + 204/zoom, nil, nil, tocolor(135, 185, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom', false, false, false, true)
                dxDrawText(isDiscord.discordDate, sx/2 + 120/zoom, sy/2 + 204/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
            else
                dxDrawText('Nie posiadasz połączonego konta!', sx/2 - 200/zoom, sy/2 + 145/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
            end
        end,

        onOpen = function()
            triggerServerEvent('getPlayerDashboardData', resourceRoot, localPlayer)
        end,

        onClose = function()

        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then

            end
        end,

    },
    
    -- {
    --     name = 'Karnet',
    --     desc = 'Karnet SinceRPG',
    --     icon = 'data/promoicon.png',

    --     toRender = function(alpha)
    --         if (not getElementData(localPlayer, 'player:sid') == 7679) then return end
    --     end,

    --     onOpen = function()
    --         if (not getElementData(localPlayer, 'player:sid') == 7679) then return end
    --         print('cwel')
    --     end,

    --     onClose = function()

    --     end,
    -- },

    {

        name = 'Pojazdy',
        desc = 'Lista dostępnych pojazdów',
        icon = 'data/vehicle.png',

        toRender = function(alpha)
            dxDrawImage(sx/2 - 213/zoom, sy/2 - 190/zoom, 674/zoom, 424/zoom, 'data/vehsbg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
	        dxDrawRectangle(sx/2 - 213/zoom, sy/2 - 158/zoom, 674/zoom, 1, tocolor(255, 255, 255, 100*alpha))
	        dxDrawText('Lokalizacja', sx/2 + 439/zoom, sy/2 - 174/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'right', 'center')
	        dxDrawText('Model', sx/2 + 240/zoom, sy/2 - 174/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'right', 'center')
	        dxDrawText('Ost. kierowca', sx/2 + 40/zoom, sy/2 - 174/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'right', 'center')
	        dxDrawText('VID', sx/2 - 130/zoom, sy/2 - 174/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'right', 'center')

	        dxDrawText('Posiadane pojazdy: #8eff7a'..#cache.vehicles, sx/2 - 213/zoom + 337/zoom, sy/2 + 230/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'bottom', false, false, false, true)
	        
            local offset = 0
            local x = 0

            for i, v in ipairs(vehiclesList) do
                if i >= scroll.vehicles.k and i <= scroll.vehicles.n then 
                    local vehLocations = {

                        [2] = 'Parking policyjny',
                        [1] = 'Przechowalnia',
                        [0] = function(v)
                            local veh = findVehicleByID(v.id)

                            if veh then
                                local x, y, z = getElementPosition(veh)
                                local location = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)

                                return location
                            else
                                return 'Błąd lokalizacji'
                            end
                        end,

                    }

                    local vehLocalization = v.state ~= 0 and vehLocations[v.state] or vehLocations[v.state](v)

                    if i ~= scroll.vehicles.n then
                        dxDrawRectangle(sx/2 - 213/zoom, sy/2 - 124/zoom + offset, 656/zoom, 1, tocolor(255, 255, 255, 75*alpha))
                    end

                    local vehData = loadstring(v.data)()
                    
                    dxDrawText(vehLocalization, sx/2 + 439/zoom, sy/2 - 140/zoom + offset, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, #vehLocalization > 25 and exports['since-fonts']:getFont('Inter-Medium', 10/zoom) or exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'center')
                    dxDrawText(exports['since-vehiclenames']:getVehicleName(v.model), sx/2 + 240/zoom, sy/2 - 140/zoom + offset, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, #exports['since-vehiclenames']:getVehicleName(v.model) > 15 and exports['since-fonts']:getFont('Inter-Medium', 10/zoom) or exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'center')
                    dxDrawText(vehData.driver, sx/2 + 40/zoom, sy/2 - 140/zoom + offset, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'center')
                    dxDrawText(v.id, sx/2 - 130/zoom, sy/2 - 140/zoom + offset, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'right', 'center')

                    offset = offset + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom)) + 15/zoom
                end
            end

            drawScrollbar(vehiclesList, sx/2 + 449/zoom, sy/2 - 150/zoom, 4/zoom, 370/zoom, scroll.vehicles.m, scroll.vehicles.k, 255*alpha)
        end,

        onOpen = function()
            triggerServerEvent('getVehiclesDashboardData', resourceRoot, localPlayer)
            scroll.vehicles = {k = 1, n = 11, m = 11}

            uiElements['edit_vehicles'] = exports['since-gui']:createEditbox('Wprowadź nazwę lub id pojazdu...', sx/2 + 100/zoom, sy/2 - 241/zoom, 359/zoom, 32/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })

            vehiclesList = getVehicles(cache.vehicles, uiElements['edit_vehicles'])

            refreshTimer = setTimer(function()
                vehiclesList = getVehicles(cache.vehicles, uiElements['edit_vehicles'])
            end, 500, 0)
        end,

        onClose = function()
            if uiElements['edit_vehicles'] then
                exports['since-gui']:destroyUIElement(uiElements['edit_vehicles'])
            end

            if isTimer(refreshTimer) then
                killTimer(refreshTimer)
            end
        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then

            end
        end,

    },

    {

        name = 'Nagroda dzienna',
        desc = 'Odbieraj nagrody za przegrane dni!',
        icon = 'data/daily.png',

        toRender = function(alpha)

            if playerPrize.selected ~= 0 then
                local isIn = playerPrize.selected == 1 and false or true
                dxDrawImage(sx/2 - 196/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, playerPrize.selected == 1 and 'data/card.png' or 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))

                if playerPrize.selected == 1 then
                    dxDrawImage(sx/2 - 196/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, playerPrize.selected == 1 and 'data/card.png' or 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                end

                local isIn = playerPrize.selected == 2 and false or true
                dxDrawImage(sx/2 + 38/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, playerPrize.selected == 2 and 'data/card.png' or 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))

                if playerPrize.selected == 2 then
                    dxDrawImage(sx/2 + 38/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, playerPrize.selected == 2 and 'data/card.png' or 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                end

                local isIn = playerPrize.selected == 3 and false or true
                dxDrawImage(sx/2 + 272/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, playerPrize.selected == 3 and 'data/card.png' or 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                
                if playerPrize.selected == 3 then
                    dxDrawImage(sx/2 + 272/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, playerPrize.selected == 3 and 'data/card.png' or 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                end
            else
                local isIn = isMouseInPosition(sx/2 - 196/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom)
                dxDrawImage(sx/2 - 196/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                local isIn = isMouseInPosition(sx/2 + 38/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom)
                dxDrawImage(sx/2 + 38/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                local isIn = isMouseInPosition(sx/2 + 272/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom)
                dxDrawImage(sx/2 + 272/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom, 'data/card_sel.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
            end

            if playerPrize.selected ~= 0 then
                dxDrawText('Odebrano nagrodę dzienną!', sx/2 + 124.5/zoom, sy/2 + 123/zoom, nil, nil, tocolor(255, 125, 125, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'center', 'bottom')
                dxDrawText('Dzisiejsza nagroda dzienna: #fcff4f'..playerPrize.info..'#ffffff\nNastępną nagrodę możesz odebrać: #2E756F'..playerPrize.date, sx/2 + 124.5/zoom, sy/2 + 123/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)
            else
                dxDrawText('Odbierz nagrodę dzienną!', sx/2 + 124.5/zoom, sy/2 + 123/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'center', 'bottom')
                dxDrawText('Nagrodę dzienną odebrać możesz tylko i wyłącznie raz na 24 godziny, aby odebrać nagrodę\nkliknij na jedną z trzech powyższych kart. Nagrody są mnożone względem ilości odebranych\npod rząd nagród. Dostępne nagrody to: Gotówka, punkty SRP czy też punkty premium.', sx/2 + 124.5/zoom, sy/2 + 123/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
            end
            
            dxDrawImage(sx/2 - 196/zoom, sy/2 + 193/zoom, 640/zoom, 32/zoom, 'data/rectanglemn.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Odebrałes łącznie '..playerPrize.count..' nagród dziennych', sx/2 + 124/zoom, sy/2 + 209/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')
        end,

        onOpen = function()
            triggerServerEvent('getDailyPrizeData', resourceRoot, localPlayer)
        end,

        onClose = function()

        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                if playerPrize.selected == 0 then
                    local isIn = isMouseInPosition(sx/2 - 196/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom)
                    if isIn then 
                        playerPrize.selected = 1 
                        triggerServerEvent('giveDailyPrize', resourceRoot, localPlayer, playerPrize.selected)
                    end
                    
                    local isIn2 = isMouseInPosition(sx/2 + 38/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom)
                    if isIn2 then 
                        playerPrize.selected = 2 
                        triggerServerEvent('giveDailyPrize', resourceRoot, localPlayer, playerPrize.selected)
                    end
                    
                    local isIn3 = isMouseInPosition(sx/2 + 272/zoom, sy/2 - 174/zoom, 172/zoom, 250/zoom)
                    if isIn3 then 
                        playerPrize.selected = 3 
                        triggerServerEvent('giveDailyPrize', resourceRoot, localPlayer, playerPrize.selected)
                    end
                end 
            end
        end,

    },

    {

        name = 'Celowniki',
        desc = 'Ustaw swój celownik',
        icon = 'data/crosshair_icon.png',

        toRender = function(alpha)
            dxDrawImage(sx/2 - 211/zoom, sy/2 - 187/zoom, 670/zoom, 418/zoom, 'data/dailyQuests-bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

            local playerData = getElementData(localPlayer, 'player:data') or {}
            local crosshairData = playerData['crosshair'] or {}

            if not crosshairData.position then crosshairData.position = 2 end
            if not crosshairData.size then crosshairData.size = 1 end
            if not crosshairData.line then crosshairData.line = 5 end
            if not crosshairData.color then crosshairData.color = {255, 255, 255} end
            if not crosshairData.modeT then crosshairData.modeT = false end

            if sliders['position'] then
                if not crosshairData.position then crosshairData.position = 2 end

                crosshairData.position = math.floor(exports['since-scrollbar']:getScrollProgress(sliders['position']) / 10)

                playerData.crosshair = crosshairData
            end

            if sliders['line'] then
                if not crosshairData.line then crosshairData.line = 5 end

                crosshairData.line = math.floor(exports['since-scrollbar']:getScrollProgress(sliders['line']) / 10)

                playerData.crosshair = crosshairData
            end

            if sliders['size'] then
                if not crosshairData.size then crosshairData.size = 1 end

                crosshairData.size = math.floor(exports['since-scrollbar']:getScrollProgress(sliders['size']) / 10)
                crosshairData.size = crosshairData.size < 1 and 1 or crosshairData.size

                playerData.crosshair = crosshairData
            end

            if sliders['r'] then
                if not crosshairData.color then crosshairData.color = {255, 255, 255} end

                crosshairData.color[1] = math.floor(exports['since-scrollbar']:getScrollProgress(sliders['r']) * 2.55)
                crosshairData.color[1] = crosshairData.color[1] < 0 and 0 or crosshairData.color[1]

                playerData.crosshair = crosshairData
            end

            if sliders['g'] then
                if not crosshairData.color then crosshairData.color = {255, 255, 255} end

                crosshairData.color[2] = math.floor(exports['since-scrollbar']:getScrollProgress(sliders['g']) * 2.55)
                crosshairData.color[2] = crosshairData.color[2] < 0 and 0 or crosshairData.color[2]

                playerData.crosshair = crosshairData
            end

            if sliders['b'] then
                if not crosshairData.color then crosshairData.color = {255, 255, 255} end

                crosshairData.color[3] = math.floor(exports['since-scrollbar']:getScrollProgress(sliders['b']) * 2.55)
                crosshairData.color[3] = crosshairData.color[3] < 0 and 0 or crosshairData.color[3]

                playerData.crosshair = crosshairData
            end

            setElementData(localPlayer, 'player:data', playerData)
            
            dxDrawText('Podgląd celownika', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('W zakładce ustawień możesz wymusić używanie domyślnego celownika z GTA:SA', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')

            dxDrawRectangle(sx/2 + 105/zoom - 1.5 + crosshairData.position, sy/2 - 105/zoom - crosshairData.size/2, 2/zoom + crosshairData.line, crosshairData.size, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
            dxDrawRectangle(sx/2 + 105/zoom - crosshairData.position - crosshairData.line, sy/2 - 105/zoom - crosshairData.size/2, 2/zoom + crosshairData.line, crosshairData.size, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
            
            if not crosshairData.modeT then
                dxDrawRectangle(sx/2 + 105/zoom - crosshairData.size/2, sy/2 - 105/zoom - crosshairData.position - crosshairData.line, crosshairData.size, 2/zoom + crosshairData.line, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
            end

            dxDrawRectangle(sx/2 + 105/zoom - crosshairData.size/2, sy/2 - 105/zoom - 1.5 + crosshairData.position, crosshairData.size, 2/zoom + crosshairData.line, tocolor(crosshairData.color[1], crosshairData.color[2], crosshairData.color[3], 255*alpha))
        
            dxDrawText('Pozycja celownika', sx/2 + 105/zoom, sy/2 + 5/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'bottom')
            dxDrawText('Długość celownika', sx/2 + 105/zoom, sy/2 + 60/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'bottom')
            dxDrawText('Grubość celownika', sx/2 + 105/zoom, sy/2 + 115/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'bottom')

            -- draw line
            dxDrawRectangle(sx/2 + 105/zoom - 200/zoom, sy/2 + 155/zoom, 400/zoom, 1, tocolor(255, 255, 255, 55*alpha))

            dxDrawText('Czerwony', sx/2 + 105/zoom - 200/zoom, sy/2 + 190/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'bottom')
            dxDrawText('Zielony', sx/2 + 105/zoom, sy/2 + 190/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'bottom')
            dxDrawText('Niebieski', sx/2 + 105/zoom + 200/zoom, sy/2 + 190/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'bottom')
        end,

        onOpen = function()
            sliders['position'] = exports['since-scrollbar']:createScrollbar(sx/2 + 105/zoom - 80/zoom, sy/2 + 20/zoom, 160/zoom, 6/zoom, {255, 255, 255}, true, 0)
            sliders['line'] = exports['since-scrollbar']:createScrollbar(sx/2 + 105/zoom - 80/zoom, sy/2 + 70/zoom, 160/zoom, 6/zoom, {255, 255, 255}, true, 0)
            sliders['size'] = exports['since-scrollbar']:createScrollbar(sx/2 + 105/zoom - 80/zoom, sy/2 + 125/zoom, 160/zoom, 6/zoom, {255, 255, 255}, true, 0)

            sliders['r'] = exports['since-scrollbar']:createScrollbar(sx/2 + 105/zoom - 80/zoom - 200/zoom, sy/2 + 200/zoom, 160/zoom, 6/zoom, {255, 255, 255}, true, 0)
            sliders['g'] = exports['since-scrollbar']:createScrollbar(sx/2 + 105/zoom - 80/zoom, sy/2 + 200/zoom, 160/zoom, 6/zoom, {255, 255, 255}, true, 0)
            sliders['b'] = exports['since-scrollbar']:createScrollbar(sx/2 + 105/zoom - 80/zoom + 200/zoom, sy/2 + 200/zoom, 160/zoom, 6/zoom, {255, 255, 255}, true, 0)

            local playerData = getElementData(localPlayer, 'player:data') or {}
            local crosshairData = playerData['crosshair'] or {}

            exports['since-scrollbar']:setScrollProgress(sliders['position'], crosshairData.position * 10)
            exports['since-scrollbar']:setScrollProgress(sliders['line'], crosshairData.line * 10)
            exports['since-scrollbar']:setScrollProgress(sliders['size'], crosshairData.size * 10)

            exports['since-scrollbar']:setScrollProgress(sliders['r'], crosshairData.color[1] / 2.55)
            exports['since-scrollbar']:setScrollProgress(sliders['g'], crosshairData.color[2] / 2.55)
            exports['since-scrollbar']:setScrollProgress(sliders['b'], crosshairData.color[3] / 2.55)
        end,

        onClose = function()
            if sliders['position'] then
                exports['since-scrollbar']:destroyScroll(sliders['position'])
                sliders['position'] = nil
            end

            if sliders['line'] then
                exports['since-scrollbar']:destroyScroll(sliders['line'])
                sliders['line'] = nil
            end

            if sliders['size'] then
                exports['since-scrollbar']:destroyScroll(sliders['size'])
                sliders['size'] = nil
            end

            if sliders['r'] then
                exports['since-scrollbar']:destroyScroll(sliders['r'])
                sliders['r'] = nil
            end

            if sliders['g'] then
                exports['since-scrollbar']:destroyScroll(sliders['g'])
                sliders['g'] = nil
            end

            if sliders['b'] then
                exports['since-scrollbar']:destroyScroll(sliders['b'])
                sliders['b'] = nil
            end
        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
    
            end
        end,

    },

    {
        name = 'Zadania dzienne',
        desc = 'Dzienne zadania',
        icon = 'data/daily.png',
        toRender = function(alpha)
            local questData = getElementData(localPlayer, 'player:quest')
            if not questData then return end
            local questInfo = exports['since-dailyQuests']:getActualQuest(questData.id) 
            local h, m = getDailyQuestTimeToEnd()

            dxDrawImage(sx/2 - 211/zoom, sy/2 - 187/zoom, 670/zoom, 418/zoom, 'data/dailyQuests-bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Zadania dzienne', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Wykonuj zadania, aby otrzymać nagrody', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')

            dxDrawText('Ciągłość wykonywania zadań', sx/2 - 211/zoom + 46/zoom, sy/2 - 90/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText(questData.daysInRow..' z 7 dni', sx/2 + 410/zoom, sy/2 - 90/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'right', 'bottom')

            local offset = -(6*80/zoom+6*3/zoom)/2-(80/zoom)/2
            for i=1,7 do
                dxDrawImage(sx/2 - 211/zoom + 670/2/zoom + offset, sy/2-85/zoom, 80/zoom, 24/zoom, questData.daysInRow >= i and 'data/dailyQuests-filled.png' or 'data/dailyQuests-nofilled.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
                offset = offset + 83/zoom
            end

            dxDrawImage(sx/2 - 201/zoom, sy/2 - 10/zoom, 650/zoom, 230/zoom, 'data/dailyQuests-bg2.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Aktualne zadanie', sx/2 - 190/zoom, sy/2 + 22/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText(questInfo.text, sx/2 - 190/zoom, sy/2 + 22/zoom, sx/2 - 190/zoom + 434/zoom, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, true)

            dxDrawText('Nagroda za ukończenie zadania', sx/2 - 190/zoom, sy/2 + 79/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText(questInfo.rewardsText, sx/2 - 190/zoom, sy/2 + 79/zoom, sx/2 - 190/zoom + 434/zoom, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, true)

            dxDrawText('Status', sx/2 - 190/zoom, sy/2 + 136/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            if questData.finished then
                dxDrawText('Zadanie wykonane', sx/2 - 190/zoom, sy/2 + 136/zoom, sx/2 - 190/zoom + 434/zoom, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, true)
            else
                dxDrawText('Zadanie niewykonane', sx/2 - 190/zoom, sy/2 + 136/zoom, sx/2 - 190/zoom + 434/zoom, nil, tocolor(215, 94, 94, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, true)
            end

            dxDrawText('Aktualny postęp', sx/2 - 190/zoom, sy/2 + 193/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText(questData.progress..' / '..questInfo.progress, sx/2 - 190/zoom, sy/2 + 193/zoom, sx/2 - 190/zoom + 434/zoom, nil, tocolor(113, 204, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, true)

            dxDrawImage(sx/2 + 253/zoom, sy/2 - 10/zoom, 196/zoom, 230/zoom, 'data/dailyQuests-bg3.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Dzisiejsza nagroda', sx/2 + 351/zoom, sy/2 + 33/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'bottom')
            dxDrawText(questInfo.rewardsText, sx/2 + 351/zoom, sy/2 + 37/zoom, nil, nil, tocolor(124, 255, 113, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 11/zoom), 'center', 'top')

            if questData.collected then
                dxDrawText('Nagroda odebrana', sx/2 + 283/zoom, sy/2 + 70/zoom, sx/2 + 283/zoom + 135/zoom, sy/2 + 70/zoom + 35/zoom, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 12/zoom), 'center', 'center')
            else
                local isIn = isMouseInPosition(sx/2 + 283/zoom, sy/2 + 70/zoom, 135/zoom, 35/zoom)
                dxDrawImage(sx/2 + 283/zoom, sy/2 + 70/zoom, 135/zoom, 35/zoom, 'data/dailyQuests-button.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                dxDrawText('Odbierz nagrodę', sx/2 + 283/zoom, sy/2 + 70/zoom, sx/2 + 283/zoom + 135/zoom, sy/2 + 70/zoom + 35/zoom, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')
            end

            dxDrawText('Następne zadanie będzie dostępne za', sx/2 + 253/zoom, sy/2 + 173/zoom, sx/2 + 253/zoom + 196/zoom, nil, tocolor(195, 195, 195, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'bottom', false, true)
            dxDrawText(h..' godz. '..m..' min.', sx/2 + 253/zoom, sy/2 + 180/zoom, sx/2 + 253/zoom + 196/zoom, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 13/zoom), 'center', 'top')

        end,
        onOpen = function()
            if not getElementData(localPlayer, 'player:quest') then
                triggerServerEvent('loadDailyQuestData', resourceRoot)
            end
        end,
        onClose = function()
            quest = nil
        end,
        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                if isMouseInPosition(sx/2 + 283/zoom, sy/2 + 70/zoom, 135/zoom, 35/zoom) then 
                    triggerServerEvent('collectDailyReward', resourceRoot)
                end
            end
        end,
    },

--[[    {

        name = 'Halloween event',
        desc = 'Event halloweenowy',
        icon = 'data/halloweenevent.png',

        toRender = function(alpha)

            local saveAlpha = alpha
            local alpha = summereventSelectedOption and alpha*0.25 or alpha

            local playerData = getElementData(localPlayer, "player:data") or {}

            if not playerData.halloweenPoints then
                playerData.halloweenPoints = 0
            end
    
            dxDrawImage(sx/2 - 211/zoom, sy/2 - 187/zoom, 670/zoom, 418/zoom, 'data/summerevent-bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Halloween event', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Zdobywaj punkty, aby je wymienić', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')

            dxDrawText('Twoje Punkty', sx/2 + 448/zoom, sy/2 - 158/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'right', 'bottom')
            dxDrawText(addCommas(playerData.halloweenPoints)..' pkt', sx/2 + 448/zoom, sy/2 - 158/zoom, nil, nil, tocolor(113, 204, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'top')

            dxDrawImage(sx/2 - 211/zoom, sy/2 - 131/zoom, 670/zoom, 2/zoom, 'data/line.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

            local offset = 0
            if summerEventRewards then
                for i,v in ipairs(summerEventRewards) do
                    if i >= scroll.event.k and i <= scroll.event.n then 
                        local isIn = isMouseInPosition(sx/2 - 198/zoom, sy/2 - 120/zoom + offset, 644/zoom, 48/zoom)
                        if summereventSelectedOption then isIn = false end
                        dxDrawImage(sx/2 - 198/zoom, sy/2 - 120/zoom + offset, 644/zoom, 48/zoom, 'data/summerevent-bar.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                        dxDrawText(v[2], sx/2 - 150/zoom, sy/2 - 93/zoom + offset, nil, nil, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'bottom')
                        dxDrawText(v[3], sx/2 - 150/zoom, sy/2 - 93/zoom + offset, nil, nil, tocolor(46, 117, 111, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')
                        dxDrawImage(sx/2 - 189/zoom, sy/2 - 111/zoom + offset, 30/zoom, 30/zoom, 'data/'..v[6]..'.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                        offset = offset + 58/zoom
                    end
                end
                drawScrollbar(summerEventRewards, sx/2 + 451/zoom, sy/2 - 120/zoom, 4/zoom, 224/zoom, scroll.event.m, scroll.event.k, 255*alpha)
            end

            dxDrawImage(sx/2 - 211/zoom, sy/2 + 110/zoom, 670/zoom, 2/zoom, 'data/line.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

            dxDrawText('Jak pozystać punkty?', sx/2 - 211/zoom+670/2/zoom, sy/2 + 142/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
            if summereventHowTo then
                local offset = 0
                for i,v in ipairs(summereventHowTo) do
                    dxDrawText(v, sx/2 - 211/zoom+670/2/zoom, sy/2 + 142/zoom + offset, nil, nil, tocolor(113, 204, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
                    offset = offset + 17/zoom
                end
            end

            if summereventSelectedOption then
                local alpha = saveAlpha
                local v = summereventSelectedOption

                dxDrawImage(sx/2 - 111/zoom, sy/2 - 110/zoom, 470/zoom, 200/zoom, 'data/summerevent-bgselected.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

                dxDrawText(v[3], sx/2 - 96/zoom, sy/2 - 100/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'top')

                local isIn = isMouseInPosition(sx/2 + 329/zoom, sy/2 - 100/zoom, 20/zoom, 20/zoom)
                dxDrawImage(sx/2 + 329/zoom, sy/2 - 100/zoom, 20/zoom, 20/zoom, 'data/close.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))      

                local sliderData = math.floor(exports['since-scrollbar']:getScrollProgress(summereventSlider) or 0)
                local sliderData = math.floor(playerData.halloweenPoints*sliderData/100)

                dxDrawText('Wybrane punkty', sx/2 + 124/zoom, sy/2 - 45/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
                dxDrawText(addCommas(sliderData)..' #71CCFFpkt', sx/2 + 124/zoom, sy/2 - 45/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)

                dxDrawText('Otrzymasz', sx/2 + 124/zoom, sy/2 + 15/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
                dxDrawText(v[4] and type(v[4]) == 'function' and v[5](v[4](sliderData)) or v[4] and v[4] or '---', sx/2 + 124/zoom, sy/2 + 15/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)

                local isIn = isMouseInPosition(sx/2 + 24/zoom, sy/2 + 45/zoom, 200/zoom, 35/zoom)
                dxDrawImage(sx/2 + 24/zoom, sy/2 + 45/zoom, 200/zoom, 35/zoom, 'data/summerevent-button.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha))
                dxDrawText('Wymień', sx/2 + 24/zoom, sy/2 + 45/zoom, sx/2 + 24/zoom+200/zoom, sy/2 + 45/zoom+35/zoom, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')

            end

        end,

        onOpen = function()

            summerEventRewards = {
                {'money', 'Gotówka', 'Wymień swoje punkty na gotówkę', function(value)
                    local perPoint = 2500
                    return math.floor(value*perPoint)
                end, function(value)
                    return addCommas(value)..' #68D65E$'
                end, 'money'},
                {'pp', 'Punkty premium', 'Wymień swoje punkty na punkty premium', function(value)
                    local perPoint = 2
                    return math.floor(value*perPoint)
                end, function(value)
                    return addCommas(value)..' #68D65Epp'
                end, 'star'},
                {'wpln', 'wPLN', 'Wymień swoje punkty na wPLN', function(value)
                    local perPoint = 0.05
                    return math.floor(value*perPoint)
                end, function(value)
                    return addCommas(value)..' #68D65EwPLN'
                end, 'jobsstat'},
            }
            summereventHowTo = {
                'Za minute na serwerze - 1 pkt',
                'Za minute na pracy - 2 pkt',
                'Za minute na służbie frakcji - 2 pkt',
            }
            scroll.event = {k = 1, n = 4, m = 4}  
            summereventSelectedOption = nil

        end,

        onClose = function()

            if summereventSlider then
                exports['since-scrollbar']:destroyScroll(summereventSlider) 
            end

            summerEventRewards = nil
            summereventHowTo = nil
            summereventSelectedOption = nil

        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then

                if summereventSelectedOption then
                    if isMouseInPosition(sx/2 + 329/zoom, sy/2 - 100/zoom, 20/zoom, 20/zoom) then
                        if summereventSlider then
                            exports['since-scrollbar']:destroyScroll(summereventSlider) 
                        end
                        summereventSelectedOption = nil
                    elseif isMouseInPosition(sx/2 + 24/zoom, sy/2 + 45/zoom, 200/zoom, 35/zoom) then
                        local playerData = getElementData(localPlayer, "player:data") or {}

                        if not playerData.halloweenPoints then
                            playerData.halloweenPoints = 0
                        end

                        local sliderData = math.floor(exports['since-scrollbar']:getScrollProgress(summereventSlider) or 0)
                        local sliderData = math.floor(playerData.halloweenPoints*sliderData/100)

                        if playerData.halloweenPoints < sliderData then
                            return exports['since-notifications']:sendNotification('error', 'Nie posiadasz tylu punktów!')
                        end

                        if not sliderData or sliderData <= 0 then 
                            return 
                        end

                        if not summereventSelectedOption[4](sliderData) or summereventSelectedOption[4](sliderData) <= 0 then
                            return
                        end                        

                        triggerServerEvent('exchangeSummerEventPoints', resourceRoot, summereventSelectedOption[1], sliderData, summereventSelectedOption[4](sliderData))
                        if summereventSlider then
                            exports['since-scrollbar']:destroyScroll(summereventSlider) 
                        end
                        summereventSelectedOption = nil
                    end
                else
                    local offset = 0
                    for i,v in ipairs(summerEventRewards) do
                        if i >= scroll.event.k and i <= scroll.event.n then 
                            if isMouseInPosition(sx/2 - 198/zoom, sy/2 - 120/zoom + offset, 644/zoom, 48/zoom) and not summereventSelectedOption then
                                summereventSelectedOption = v
                                summereventSlider = exports['since-scrollbar']:createScrollbar(sx/2 - 11/zoom, sy/2 - 20/zoom, 270/zoom, 6/zoom, {255, 255, 255}, true, 0)
                            end
                            offset = offset + 58/zoom
                        end
                    end
                end

            end
        end,

    },]]--

    {

        name = 'Kody polecające',
        desc = 'Polecaj serwer i zgarniaj nagrody!',
        icon = 'data/promoicon.png',

        toRender = function(alpha)
            dxDrawImage(sx/2 - 213/zoom, sy/2 - 190/zoom, 674/zoom, 424/zoom, 'data/vehsbg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Kod polecający', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Twój kod polecający', sx/2 - 200/zoom, sy/2 - 158/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')

            local code = playerCodeData['playerCode']
            local code = code == nil and 'Brak' or code

            if string.len(code) > 3 then
                code = code
            else
                code = 'Brak'
            end

            local textWidth = dxGetTextWidth(code, 1, exports['since-fonts']:getFont('Inter-Black', 23/zoom)) + 25/zoom

            if string.len(code) > 3 and code ~= 'Brak' then
                dxDrawRoundedRectangle(sx/2 - 200/zoom, sy/2 - 135/zoom, textWidth, 55/zoom, 4/zoom, tocolor(255, 255, 255, 45*alpha))
                dxDrawText(code, sx/2 - 200/zoom, sy/2 - 135/zoom, sx/2 - 200/zoom + textWidth, sy/2 - 135/zoom + 55/zoom, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Black', 23/zoom), 'center', 'center')

                local isIn = isMouseInPosition(sx/2 - 200/zoom, sy/2 - 135/zoom, textWidth, 55/zoom)
                if isIn then
                    local cx, cy = getCursorPosition()
                    local cx, cy = cx*sx, cy*sy

                    if getKeyState('mouse1') then
                        dxDrawText('Skopiowano kod', cx + 15/zoom + 1, cy + 15/zoom + 1, nil, nil, tocolor(0, 0, 0, 55*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
                        dxDrawText('Skopiowano kod', cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
    
                        setClipboard(code)
                    else
                        dxDrawText('Kliknij aby skopiować do schowka', cx + 15/zoom + 1, cy + 15/zoom + 1, nil, nil, tocolor(0, 0, 0, 55*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
                        dxDrawText('Kliknij aby skopiować do schowka', cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
                    end
                end
            else
                dxDrawRoundedRectangle(sx/2 - 200/zoom, sy/2 - 135/zoom, textWidth, 55/zoom, 4/zoom, tocolor(255, 125, 125, 45*alpha))
                dxDrawText(code, sx/2 - 200/zoom, sy/2 - 135/zoom, sx/2 - 200/zoom + textWidth, sy/2 - 135/zoom + 55/zoom, tocolor(255, 125, 125, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Black', 23/zoom), 'center', 'center')
            end

            dxDrawText('Użycia kodu polecającego', sx/2 + 450/zoom, sy/2 - 158/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'right', 'bottom')
            dxDrawText('Liczba użyć twojego kodu polecającego', sx/2 + 450/zoom, sy/2 - 158/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'top')

            local uses = playerCodeData['playerUses'] or 0
            
            dxDrawRoundedRectangle(sx/2 + 250/zoom, sy/2 - 135/zoom, 200/zoom, 55/zoom, 4/zoom, tocolor(94, 171, 214, 45*alpha))
            dxDrawText(uses, sx/2 + 250/zoom, sy/2 - 135/zoom, sx/2 + 250/zoom + 200/zoom, sy/2 - 135/zoom + 55/zoom, tocolor(94, 171, 214, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Black', 23/zoom), 'center', 'center')

            dxDrawText('Ustawianie kodu', sx/2 - 200/zoom, sy/2 - 35/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Ustaw kod i zbieraj nagrody!', sx/2 - 200/zoom, sy/2 - 35/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')

            local isIn = isMouseInPosition(sx/2 + 165/zoom, sy/2 - 10/zoom, 118/zoom, 40/zoom)
            dxDrawImage(sx/2 + 165/zoom, sy/2 - 10/zoom, 118/zoom, 40/zoom, 'data/code_button.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 155 or 200)*alpha))
            dxDrawText('Ustaw kod', sx/2 + 165/zoom, sy/2 - 10/zoom, sx/2 + 165/zoom + 118/zoom, sy/2 - 9/zoom + 40/zoom, tocolor(255, 255, 255, (isIn and 135 or 200)*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
            
            if playerCodeData['playerUsePromo'] == 1 then
                dxDrawText('Kod wykorzystany', sx/2 + 165/zoom, sy/2 + 40/zoom, sx/2 + 165/zoom + 118/zoom, sy/2 + 40/zoom + 40/zoom, tocolor(255, 255, 255, 155*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
            else
                local isIn = isMouseInPosition(sx/2 + 165/zoom, sy/2 + 40/zoom, 118/zoom, 40/zoom)
                dxDrawImage(sx/2 + 165/zoom, sy/2 + 40/zoom, 118/zoom, 40/zoom, 'data/code_button.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 155 or 200)*alpha))
                dxDrawText('Użyj kod', sx/2 + 165/zoom, sy/2 + 40/zoom, sx/2 + 165/zoom + 118/zoom, sy/2 + 40/zoom + 40/zoom, tocolor(255, 255, 255, (isIn and 135 or 200)*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
            end

            local offset = 0
            for i = 1, 3 do
                dxDrawRoundedRectangle(sx/2 - 200/zoom, sy/2 + 95/zoom + offset, 650/zoom, 38/zoom, 4/zoom, tocolor(255, 255, 255, 35*alpha))
                dxDrawText(codeRewards[i].name, sx/2 - 190/zoom, sy/2 + 95/zoom + 19/zoom + offset, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center')
                local textWidth = dxGetTextWidth(codeRewards[i].name, 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) + 10/zoom
                local useWidth = dxGetTextWidth('Wymagane '..codeRewards[i].uses..' użyć kodu', 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + 10/zoom
                dxDrawRoundedRectangle(sx/2 - 200/zoom + textWidth + 5/zoom, sy/2 + 102/zoom + offset, useWidth + 10/zoom, 22/zoom, 11/zoom, tocolor(46, 117, 111, 55*alpha))
                dxDrawText('Wymagane '..codeRewards[i].uses..' użyć kodu', sx/2 - 195/zoom + textWidth + 10/zoom, sy/2 + 95/zoom + 19/zoom + offset, nil, nil, tocolor(46, 117, 111, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')
                
                if playerCodeData['playerRewards'] and playerCodeData['playerRewards'][i] ~= 1 then
                    if playerCodeData['playerUses'] < codeRewards[i].uses then
                        dxDrawText('Nie możesz odebrac tej nagrody', sx/2 + 440/zoom, sy/2 + 95/zoom + 19/zoom + offset, nil, nil, tocolor(255, 255, 255, 155*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'right', 'center')
                    else
                        local isIn = isMouseInPosition(sx/2 + 440/zoom - textWidth - 5/zoom, sy/2 + 84/zoom + 19/zoom + offset, textWidth + 10/zoom, 22/zoom)
                        local textWidth = dxGetTextWidth('Odbierz nagrodę', 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom)) + 10/zoom
                        dxDrawRoundedRectangle(sx/2 + 440/zoom - textWidth - 5/zoom, sy/2 + 84/zoom + 19/zoom + offset, textWidth + 10/zoom, 22/zoom, 11/zoom, tocolor(255, 255, 255, (isIn and 45 or 55)*alpha))
                        dxDrawText('Odbierz nagrodę', sx/2 + 436/zoom, sy/2 + 95/zoom + 19/zoom + offset, nil, nil, tocolor(255, 255, 255, (isIn and 155 or 200)*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'right', 'center')
                    end
                else
                    dxDrawText('Nagroda odebrana', sx/2 + 440/zoom, sy/2 + 95/zoom + 19/zoom + offset, nil, nil, tocolor(255, 255, 255, 155*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'right', 'center')
                end

                offset = offset + 43/zoom
            end
        end,

        onOpen = function()
            triggerServerEvent('promocodeAction', resourceRoot, 'get')

            uiElements['edit_code'] = exports['since-gui']:createEditbox('Wpisz nowy kod polecający...', sx/2 - 200/zoom, sy/2 - 10/zoom, 350/zoom, 40/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })

            uiElements['edit_codeuse'] = exports['since-gui']:createEditbox('Wprowadź kod polecający...', sx/2 - 200/zoom, sy/2 + 40/zoom, 350/zoom, 40/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })
        end,

        onClose = function()
            if (uiElements['edit_code']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_code'])
            end

            if (uiElements['edit_codeuse']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_codeuse'])
            end
        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                local isIn = isMouseInPosition(sx/2 + 165/zoom, sy/2 - 10/zoom, 118/zoom, 40/zoom)

                if isIn then
                    local code = exports['since-gui']:getEditboxText(uiElements['edit_code'])

                    if code == 'Brak' or code == 'brak' then
                        return exports['since-notifications']:sendNotification('error', 'Błędny kod.')
                    end

                    if code == playerCodeData['playerCode'] then
                        return exports['since-notifications']:sendNotification('error', 'Nowy kod nie może być taki sam jak stary.')
                    end

                    triggerServerEvent('promocodeAction', resourceRoot, 'change', code)
                end

                local isIn = isMouseInPosition(sx/2 + 165/zoom, sy/2 + 40/zoom, 118/zoom, 40/zoom)
                if isIn then
                    if playerCodeData['playerUsePromo'] == 1 then
                        return
                    end

                    local code = exports['since-gui']:getEditboxText(uiElements['edit_codeuse'])

                    if code == 'Brak' or code == 'brak' then
                        return exports['since-notifications']:sendNotification('error', 'Błędny kod.')
                    end

                    if code == playerCodeData['playerCode'] then
                        return exports['since-notifications']:sendNotification('error', 'Nie możesz użyć swojego kodu polecającego.')
                    end

                    triggerServerEvent('promocodeAction', resourceRoot, 'use', code)
                end

                local offset = 0
                for i = 1, 3 do
                    if playerCodeData['playerRewards'] and playerCodeData['playerRewards'][i] ~= 1 then
                        if playerCodeData['playerUses'] < codeRewards[i].uses then
                            return
                        end
                        
                        local textWidth = dxGetTextWidth(codeRewards[i].name, 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) + 10/zoom
                        local isIn = isMouseInPosition(sx/2 + 440/zoom - textWidth - 5/zoom, sy/2 + 84/zoom + 19/zoom + offset, textWidth + 10/zoom, 22/zoom)
                   

                        if isIn then
                            triggerServerEvent('promocodeAction', resourceRoot, 'reward', i)
                        end
                    end

                    offset = offset + 43/zoom
                end
            end
        end,

    },

    {

        name = 'Statystyki prac',
        desc = 'Statystyki prac dorywczych (Użyj scrolla by zobaczyć więcej)',
        icon = 'data/jobsstat.png',

        toRender = function(alpha)
            local stats = getElementData(localPlayer, 'player:jobStats')

            local function formatTime(time)
                local time = time and time*60 or 0
                if time <= 0 then
                    return "0 godz. 0 min."
                else
                    hours = string.format("%02.f", math.floor(time/3600))
                    mins = string.format("%02.f", math.floor(time/60 - (hours*60)))
                    secs = string.format("%02.f", math.floor(time - hours*3600 - mins *60))
                    return ""..hours.." godz. "..mins.." min."
                end
            end

            local offsetX = 0
            local offsetY = 0
            local spacingX = 325/zoom
            local spacingY = 110/zoom

            for i, v in ipairs(jobs) do
                if i >= scroll.jobs.k and i <= scroll.jobs.n then 
                    dxDrawImage(sx/2 - 204/zoom + offsetX, sy/2 - 188/zoom + offsetY, 24/zoom, 24/zoom, 'data/jobicon.png', 0, 0, 0, tocolor(46, 117, 111, 200*alpha))
                    dxDrawImage(sx/2 - 210/zoom + offsetX, sy/2 - 189/zoom + offsetY, 260/zoom, 28/zoom, 'data/gridjob.png', 0, 0, 0, tocolor(46, 117, 111, 200*alpha))
                    dxDrawText(v.name, sx/2 - 175/zoom + offsetX, sy/2 - 175/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'left', 'center')

                    if v.tp then
                        local isIn = isMouseInPosition(sx/2 - 8/zoom + offsetX, sy/2 - 185/zoom + offsetY, 110/zoom, 20/zoom)
                        dxDrawText('Teleportuj do pracy', sx/2 + 100/zoom + offsetX, sy/2 - 175/zoom + offsetY, nil, nil, isIn and tocolor(46, 117, 111, (isIn and 255 or 200)*alpha) or tocolor(255, 255, 255, (isIn and 255 or 200)*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'right', 'center')
                    end

                    if v.name == 'Górnik' then
                        local wegiel = tonumber(cache.playerData.coal) or 0
                        dxDrawText('➥ Wykopany węgiel: #dba33b'..string.format('%.2f', tonumber(wegiel))..' kg#ffffff', sx/2 - 200/zoom + offsetX, sy/2 - 155/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                    elseif v.name == 'Spedycja lotnicza' then
                        local stat = stats[v.elementData and v.elementData or string.lower(v.name)] or {}
                        dxDrawText('➥ Zarobiona gotówka: #2E756F$ '..addCommas((stat.earned or 0))..'#ffffff\n➥ Przepracowany czas: #75b6ff'..formatTime((stat.time or 0))..'#ffffff\n➥ Aktualny poziom: #2E756F'..addCommas((stat.level or 0))..' ('..addCommas(stat.levelExp or 0)..' exp)', sx/2 - 200/zoom + offsetX, sy/2 - 155/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)   

                    elseif v.name == 'Rybak' then
                        local stat = stats[v.elementData and v.elementData or string.lower(v.name)] or {}
                        dxDrawText('➥ Wyłowione ryby: #2E756F'..addCommas((stat.points or 0)), sx/2 - 200/zoom + offsetX, sy/2 - 155/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)   

                    elseif v.name == 'eTransporter' then
                        local stat = stats[v.elementData and v.elementData or string.lower(v.name)] or {}
                        dxDrawText('➥ Zarobiona gotówka: #2E756F$ '..addCommas((stat.earned or 0))..'#ffffff\n➥ Punkty ulepszeń: #2E756F'..addCommas((stat.points or 0))..' pkt.', sx/2 - 200/zoom + offsetX, sy/2 - 155/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                    else
                        local stat = stats[v.elementData and v.elementData or string.lower(v.name)] or {}
                        dxDrawText('➥ Zarobiona gotówka: #2E756F$ '..addCommas((stat.earned or 0))..'#ffffff\n➥ Przepracowany czas: #75b6ff'..formatTime((stat.time or 0))..'#ffffff\n➥ Punkty ulepszeń: #2E756F'..addCommas((stat.points or 0))..' pkt.', sx/2 - 200/zoom + offsetX, sy/2 - 155/zoom + offsetY, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)

                    end

                    offsetX = offsetX + spacingX
                    if i % 2 == 0 then
                        offsetX = 0
                        offsetY = offsetY + spacingY
                    end
                end
            end
        end,

        onOpen = function()

        end,

        onClose = function()

        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                local offsetX = 0
                local offsetY = 0
                local spacingX = 325/zoom
                local spacingY = 110/zoom

                for i, v in ipairs(jobs) do
                    if i >= scroll.jobs.k and i <= scroll.jobs.n then 

                        if v.tp then
                            local isIn = isMouseInPosition(sx/2 - 8/zoom + offsetX, sy/2 - 185/zoom + offsetY, 110/zoom, 20/zoom)
                            
                            if isIn then
                                triggerServerEvent('onTeleportJob', resourceRoot, v.tp)
                            end
                        end

                        offsetX = offsetX + spacingX
                        if i % 2 == 0 then
                            offsetX = 0
                            offsetY = offsetY + spacingY
                        end
                    end
                end
            end
        end,

    },

    {

        name = 'Znajomi',
        desc = 'Lista twoich znajomych',
        icon = 'data/friends.png',

        toRender = function(alpha)
            dxDrawImage(sx/2 - 211/zoom, sy/2 - 182/zoom, 670/zoom, 33/zoom, 'data/infobg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('UID', sx/2 - 178/zoom, sy/2 - 165.5/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
            dxDrawText('Nazwa gracza', sx/2 - 79/zoom, sy/2 - 165.5/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
            dxDrawText('Status', sx/2 + 192/zoom, sy/2 - 165.5/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
            
            local offset = 0
            for i, v in ipairs(friendList) do
                if i >= scroll.friends.k and i <= scroll.friends.n then
                    local friend = findPlayerBySID(v.uid)

                    dxDrawText(v.uid, sx/2 - 178/zoom, sy/2 - 128/zoom + offset, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'center')
                    dxDrawText(v.login, sx/2 - 79/zoom, sy/2 - 128/zoom + offset, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'center')
                    --dxDrawImage(sx/2 - 15/zoom, sy/2 - 136/zoom, 15/zoom, 19/zoom, 'data/bin_icon.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
                    dxDrawText(friend and '#2E756FOnline#ffffff ('..getElementData(friend, 'id')..')' or '#ff7d7dOffline', sx/2 + 192/zoom, sy/2 - 128/zoom + offset, nil, nil, tocolor(46, 117, 111, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'center', false, false, false, true)

                    offset = offset + 32/zoom
                end
            end

            if #friendList > 0 then
                drawScrollbar(friendList, sx/2 + 449/zoom, sy/2 - 140/zoom, 6/zoom, 370/zoom, scroll.friends.m, scroll.friends.k, 255*alpha)
            end

            local isIn = isMouseInPosition(sx/2 + 337/zoom, sy/2 - 235/zoom, 116/zoom, 20/zoom)
            dxDrawImage(sx/2 + 337/zoom, sy/2 - 235/zoom, 116/zoom, 20/zoom, 'data/add_button.png', 0, 0, 0, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), true)
            dxDrawText('Dodaj znajomego', sx/2 + 395/zoom, sy/2 - 225/zoom, nil, nil, tocolor(255, 255, 255, (isIn and 200 or 255)*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7/zoom), 'center', 'center', false, false, true)
        end,

        onOpen = function()
            triggerServerEvent('getFriendsInfo', resourceRoot, localPlayer)

            uiElements['edit_friends'] = exports['since-gui']:createEditbox('Wprowadź Nick/ID gracza..', sx/2 + 100/zoom, sy/2 - 241/zoom, 359/zoom, 32/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 10/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                image = textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = '.*[_].*',
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })
        end,

        onClose = function()
            if (uiElements['edit_friends']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_friends'])
            end
        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                if isMouseInPosition(sx/2 + 337/zoom, sy/2 - 235/zoom, 116/zoom, 20/zoom) then
                    local friendTarget = exports['since-gui']:getEditboxText(uiElements['edit_friends'])

                    if #(tostring(friendTarget)) > 0 then
                        triggerServerEvent('sendFriendRequest', resourceRoot, friendTarget)
                    end
                end
            end
        end,

    },

    {

        name = 'Sklep',
        desc = 'Tutaj zakupisz tuningi do swojego pojazdu czy też dodatki do konta',
        icon = 'data/shop_icon.png',

        toRender = function(alpha)
            dxDrawImage(sx/2 - 210/zoom, sy/2 - 150/zoom, 670/zoom, 2/zoom, 'data/shop_line.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            
            local offset = 0
            for i, v in ipairs(shopCategory) do
                local isIn = isMouseInPosition(sx/2 - 211/zoom + offset, sy/2 - 192/zoom, 118/zoom, 30/zoom)
                dxDrawImage(sx/2 - 210/zoom + offset, sy/2 - 192/zoom, 118/zoom, 30/zoom, selectedShopCategory == v.typeC and 'data/shop_button_sel.png' or 'data/shop_button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 175*alpha or 225*alpha))
                dxDrawText(v.name, sx/2 - 150/zoom + offset, sy/2 - 177/zoom, nil, nil, tocolor(255, 255, 255, isIn and 175*alpha or 225*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center')
                
                offset = offset + 118/zoom + 6/zoom
            end

            local offset = 0
            for i,v in ipairs(shopItems[selectedShopCategory]) do
                local isIn = isMouseInPosition(sx/2 - 210/zoom, sy/2 - 140/zoom + offset, 650/zoom, 51/zoom)
                local selected = selectedShopItem == v.itemToken and 1 or 0.8
                local alpha2 = selectedShopItem ~= v.itemToken and (isIn and 1 or 0.6) or 1
                local alphaitem = (alpha2 * selected)*alpha

                if selectedShopCategory == 'diamond' then
                    dxDrawImage(sx/2 - 210/zoom, sy/2 - 140/zoom + offset, 650/zoom, 51/zoom, 'data/shopitem_bg.png', 0, 0, 0, tocolor(95, 195, 255, 255*alphaitem))
                    dxDrawImage(sx/2 - 195/zoom, sy/2 - 132/zoom + offset, 36/zoom, 36/zoom, 'data/diamond.png', 0, 0, 0, tocolor(95, 195, 255, 255*alphaitem))
                    dxDrawText(v.name, sx/2 - 145/zoom, sy/2 - 112/zoom + offset, nil, nil, tocolor(95, 195, 255, 255*alphaitem), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom')
                elseif selectedShopCategory == 'boxs' then
                    dxDrawImage(sx/2 - 210/zoom, sy/2 - 140/zoom + offset, 650/zoom, 51/zoom, 'data/shopitem_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alphaitem))
                    dxDrawImage(sx/2 - 195/zoom, sy/2 - 132/zoom + offset, 36/zoom, 36/zoom, ':since-inventory/data/'..boxIcons[v.itemToken]..'.png', 0, 0, 0, tocolor(255, 255, 255, 255*alphaitem))
                    dxDrawText(v.name, sx/2 - 145/zoom, sy/2 - 112/zoom + offset, nil, nil, tocolor(46, 117, 111, 255*alphaitem), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
                else
                    dxDrawImage(sx/2 - 210/zoom, sy/2 - 140/zoom + offset, 650/zoom, 51/zoom, 'data/shopitem_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alphaitem))
                    dxDrawImage(sx/2 - 195/zoom, sy/2 - 132/zoom + offset, 36/zoom, 36/zoom, 'data/'..v.icon..'.png', 0, 0, 0, tocolor(255, 255, 255, 255*alphaitem))
                    dxDrawText(v.name, sx/2 - 145/zoom, sy/2 - 112/zoom + offset, nil, nil, tocolor(46, 117, 111, 255*alphaitem), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom', false, false, false, true)
                end

                dxDrawText(v.desc, sx/2 - 145/zoom, sy/2 - 112/zoom + offset, nil, nil, tocolor(255, 255, 255, 255*alphaitem), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')

                dxDrawText('Cena usługi', sx/2 + 422/zoom, sy/2 - 112/zoom + offset, nil, nil, tocolor(255, 255, 255, 255*alphaitem), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'bottom')
                dxDrawText('#FFB800'..addCommas(v.cost)..'#ffffff Punktów Premium', sx/2 + 422/zoom, sy/2 - 112/zoom + offset, nil, nil, tocolor(255, 255, 255, 255*alphaitem), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'right', 'top', false, false, false, true)
                
                offset = offset + 51/zoom + 2

                if selectedShopItem then
                    if v.itemToken == selectedShopItem then
                        if selectedShopCategory == 'diamond' then
                            dxDrawText('Wybrano: #ffffff'..v.name..' #FFB800(Na '..v.days..' dni)', sx/2 - 210/zoom, sy/2 + 212/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
                        else
                            dxDrawText('Wybrano: #ffffff'..v.name..'', sx/2 - 210/zoom, sy/2 + 212/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
                        end
                    end
                end
            end

            if not selectedShopItem then
                dxDrawText('Wybierz usługę aby wyświetlić szczegóły', sx/2 - 210/zoom, sy/2 + 212/zoom, nil, nil, tocolor(255, 125, 125, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom')
            end
            
            dxDrawImage(sx/2 - 210/zoom, sy/2 + 178/zoom, 670/zoom, 2/zoom, 'data/shop_line.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

            local isIn = isMouseInPosition(sx/2 + 295/zoom, sy/2 + 200/zoom, 154/zoom, 30/zoom)
            dxDrawImage(sx/2 + 295/zoom, sy/2 + 200/zoom, 148/zoom, 30/zoom, 'data/shop_button_cart.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha))
            dxDrawText('Zakup', sx/2 + 368/zoom, sy/2 + 216/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center')

            dxDrawText('Posiadane punkty premium: #FFB800'..(getElementData(localPlayer, 'player:pp') or 0)..' PP', sx/2 - 210/zoom, sy/2 + 212/zoom, nil, nil, tocolor(255, 255, 255, 225*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'top', false, false, false, true)
        end,

        onOpen = function()
            selectedShopItem = nil
            selectedShopCategory = 'diamond'
        end,

        onClose = function()

        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                local offset = 0
                for i, v in ipairs(shopCategory) do
                    local isIn = isMouseInPosition(sx/2 - 211/zoom + offset, sy/2 - 192/zoom, 118/zoom, 30/zoom)

                    if isIn then
                        selectedShopCategory = v.typeC
                        selectedShopItem = nil
                    end

                    offset = offset + 118/zoom + 6/zoom
                end

                local offset = 0
                for i,v in ipairs(shopItems[selectedShopCategory]) do
                    local isIn = isMouseInPosition(sx/2 - 210/zoom, sy/2 - 140/zoom + offset, 650/zoom, 51/zoom)

                    if isIn then
                        selectedShopItem = v.itemToken
                    end

                    offset = offset + 51/zoom + 2
                end

                local isIn = isMouseInPosition(sx/2 + 295/zoom, sy/2 + 200/zoom, 154/zoom, 30/zoom)
                if isIn then
                    local itemData = getShopItemByToken(selectedShopCategory, selectedShopItem)
                    if itemData then
                        if tonumber(getElementData(localPlayer, 'player:pp') or 0) >= itemData.cost then
                            if selectedShopCategory == 'diamond' then
                                triggerServerEvent('buyDiamond', resourceRoot, localPlayer, itemData.cost, itemData.days)
                            elseif selectedShopCategory == 'boxs' then
                                triggerServerEvent('buyBox', resourceRoot, localPlayer, itemData.cost, itemData.name, itemData.itemToken)
                            else
                                triggerServerEvent('buyDashboardItem', resourceRoot, localPlayer, itemData.cost, itemData.itemToken, itemData.name)
                            end
                        else
                            outputChatBox("#ff0000✘ #ffffffNie posiadasz tylu punktów premium!", 255, 255, 255, true)
                        end
                    end
                end
            end
        end,

    },

    {

        name = 'Ustawienia',
        desc = 'Ulepsz wizualnie rozgrywkę lub połącz swoje konto z discordem',
        icon = 'data/settings.png',

        toRender = function(alpha)
            dxDrawImage(sx/2 - 213/zoom, sy/2 - 190/zoom, 674/zoom, 424/zoom, 'data/vehsbg.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText('Ustawienia', sx/2 - 197/zoom, sy/2 - 149/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Synchronizacja z discordem', sx/2 - 197/zoom, sy/2 + 97/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawText('Aby zsynchronizować swoje konto skopiuj kod synchronizacji poniżej, następnie napisz do\nnaszego bota /polacz w wiadomości prywatnej bądź na kanale do tego przeznaczonym. Po tym\ngdy zobaczysz panel z możliwością wpisania tekstu wklej tam swój kod synchronizacji.', sx/2 - 197/zoom, sy/2 + 97/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
            
            local offset = 0
            for i,v in ipairs(settings) do
                if i >= scroll.settings.k and i <= scroll.settings.n then 
                    local isIn = isMouseInPosition(sx/2 - 196/zoom, sy/2 - 142/zoom + offset, 628/zoom, 43/zoom)
                    local state = getSettingsState(v.data)
                    dxDrawImage(sx/2 - 196/zoom, sy/2 - 142/zoom + offset, 628/zoom, 43/zoom, 'data/shaderlist_bg.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha))
                    
                    if v.data == 'passive' then
                        local srp = getElementData(localPlayer, 'player:srp') or 0
                        local srp = tonumber(srp) >= 250 and true or false

                        if srp then
                            dxDrawText(v.name, sx/2 - 186/zoom, sy/2 - 120/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)
                            dxDrawText(state and 'Uruchomiony' or 'Zatrzymany', sx/2 + 423/zoom, sy/2 - 120/zoom + offset, nil, nil, state and tocolor(100, 255, 100, isIn and 200*alpha or 255*alpha) or tocolor(255, 100, 100, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'center')
                        else
                            dxDrawText(v.name, sx/2 - 186/zoom, sy/2 - 120/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)
                            dxDrawText('Tryb pasywny możesz wyłączyć po zdobyciu 250 SRP', sx/2 + 423/zoom, sy/2 - 120/zoom + offset, nil, nil, tocolor(175, 175, 175, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'center')
                        end

                    else
                        dxDrawText(v.name, sx/2 - 186/zoom, sy/2 - 120/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)
                        dxDrawText(state and 'Uruchomiony' or 'Zatrzymany', sx/2 + 423/zoom, sy/2 - 120/zoom + offset, nil, nil, state and tocolor(100, 255, 100, isIn and 200*alpha or 255*alpha) or tocolor(255, 100, 100, isIn and 200*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'center')
                    end

                    offset = offset + 45/zoom
                end
            end

            drawScrollbar(settings, sx/2 + 442/zoom, sy/2 - 142/zoom, 6/zoom, 178/zoom, scroll.settings.m, scroll.settings.k, 255*alpha)
                
            local isIn = isMouseInPosition(sx/2 - 196/zoom, sy/2 + 176/zoom, 272/zoom, 42/zoom)
            dxDrawImage(sx/2 - 196/zoom, sy/2 + 176/zoom, 272/zoom, 42/zoom, 'data/copy_button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200*alpha or 255*alpha))
            local discordCode = getElementData(localPlayer, 'player:disordCode') or 'Błąd'
            dxDrawText('Twój kod: #2E756F'.. (isIn and discordCode or string.sub(discordCode, 1, 5)..'..'), sx/2 - 60/zoom, sy/2 + 197/zoom, nil, nil, tocolor(255, 255, 255, isIn and 175*alpha or 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center', false, false, false, true)

            local isDiscord = getElementData(localPlayer, 'player:discord')
            dxDrawImage(sx/2 + 85/zoom, sy/2 + 176/zoom, 360/zoom, 42/zoom, 'data/info_button.png', 0, 0, 0, isDiscord and tocolor(155, 255, 155, 255*alpha) or tocolor(255, 155, 155, 255*alpha))
            dxDrawText(isDiscord and 'Konto pomyślnie zsynchronizowane' or 'Konto nie zostało zsynchronizowane', sx/2 + 265/zoom, sy/2 + 197/zoom, nil, nil, isDiscord and tocolor(46, 117, 111, 255*alpha) or tocolor(255, 125, 125, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
        
            if isIn then
	            local cx, cy = getCursorPosition ( )
	            local cx, cy = ( cx * sx ), ( cy * sy )

                if isIn and getKeyState('mouse1') then
                    dxDrawText('Skopiowano kod', cx + 15/zoom + 1, cy + 15/zoom + 1, nil, nil, tocolor(0, 0, 0, 55*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
                    dxDrawText('Skopiowano kod', cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(46, 117, 111, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')

                    setClipboard(discordCode)
                else
                    dxDrawText('Kliknij aby skopiować do schowka', cx + 15/zoom + 1, cy + 15/zoom + 1, nil, nil, tocolor(0, 0, 0, 55*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
                    dxDrawText('Kliknij aby skopiować do schowka', cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top')
                end
            end
        end,

        onOpen = function()
            scroll.settings = {k = 1, n = 4, m = 4}    
        end,

        onClose = function()

        end,

        onClick = function(btn, state)
            if (btn == 'left' and state == 'down') then
                local offset = 0
                for i,v in ipairs(settings) do
                    if i >= scroll.settings.k and i <= scroll.settings.n then 
                        local isIn = isMouseInPosition(sx/2 - 196/zoom, sy/2 - 142/zoom + offset, 628/zoom, 43/zoom)

                        if isIn then
                            if v.data == 'passive' then
                                local srp = getElementData(localPlayer, 'player:srp') or 0
                                local srp = tonumber(srp) >= 250 and true or false
            
                                if srp then
                                    if getElementData(localPlayer, 'player:blockPassive') then
                                        return exports['since-notifications']:sendNotification('error', 'Odczekaj chwilę (15 sek.) przed ponownym przełączeniem trybu pasywnego!')
                                    end

                                    setPlayerSetting(v, not getSettingsState(v.data))
                                else
                                    setPlayerSetting(v, false)
                                    return exports['since-notifications']:sendNotification('error', 'Nie posiadasz 250 SRP aby móc wyłączyć tryb pasywny!')
                                end
                            else
                                setPlayerSetting(v, not getSettingsState(v.data))
                            end
                        end

                        offset = offset + 45/zoom
                    end
                end
            end
        end,

    },

}

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

function findVehicleByID(id)
    for i,v in ipairs(getElementsByType('vehicle')) do
        if getElementData(v, 'vehicle:id') == id then
            return v
        end
    end

    return false
end

function scrollDownVehicles()
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if tabs[activeTab].name ~= 'Pojazdy' then return end
    if scroll.vehicles.n == scroll.vehicles.m then return end
    scroll.vehicles.k = scroll.vehicles.k-1
    scroll.vehicles.n = scroll.vehicles.n-1
end

function scrollUpVehicles()
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if tabs[activeTab].name ~= 'Pojazdy' then return end
    if scroll.vehicles.n >= #vehiclesList then return end
    scroll.vehicles.k = scroll.vehicles.k+1
    scroll.vehicles.n = scroll.vehicles.n+1
end

function scrollDownSettings()
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if tabs[activeTab].name ~= 'Ustawienia' then return end
    if scroll.settings.n == scroll.settings.m then return end
    scroll.settings.k = scroll.settings.k-1
    scroll.settings.n = scroll.settings.n-1
end

function scrollUpSettings()
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if tabs[activeTab].name ~= 'Ustawienia' then return end
    if scroll.settings.n >= #settings then return end
    scroll.settings.k = scroll.settings.k+1
    scroll.settings.n = scroll.settings.n+1
end

function scrollDownJobs()
    if tabs[activeTab].name ~= 'Statystyki prac' then return end
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if scroll.jobs.n == scroll.jobs.m then return end
    scroll.jobs.k = scroll.jobs.k-2
    scroll.jobs.n = scroll.jobs.n-2
end

function scrollUpJobs()
    if tabs[activeTab].name ~= 'Statystyki prac' then return end
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if scroll.jobs.n >= #jobs then return end
    scroll.jobs.k = scroll.jobs.k+2
    scroll.jobs.n = scroll.jobs.n+2
end


function scrollDownFriends()
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if tabs[activeTab].name ~= 'Znajomi' then return end
    if scroll.friends.n == scroll.friends.m then return end
    scroll.friends.k = scroll.friends.k-1
    scroll.friends.n = scroll.friends.n-1
end

function scrollUpFriends()
    if isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if tabs[activeTab].name ~= 'Znajomi' then return end
    if scroll.friends.n >= #friendList then return end
    scroll.friends.k = scroll.friends.k+1
    scroll.friends.n = scroll.friends.n+1
end

function scrollDownPages()
    if not isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if scroll.pages.n == scroll.pages.m then return end
    scroll.pages.k = scroll.pages.k-1
    scroll.pages.n = scroll.pages.n-1
end

function scrollUpPages()
    if not isMouseInPosition(sx/2-471/zoom, sy/2-250/zoom, 248/zoom, 500/zoom) then return end
    if scroll.pages.n >= #tabs then return end
    scroll.pages.k = scroll.pages.k+1
    scroll.pages.n = scroll.pages.n+1
end

function scrollDownEvent()
    if tabs[activeTab].name ~= 'Summer event' then return end
    if not isMouseInPosition(sx/2 - 211/zoom, sy/2 - 187/zoom, 670/zoom, 418/zoom) then return end
    if summereventSelectedOption then return end
    if scroll.event.n == scroll.event.m then return end
    scroll.event.k = scroll.event.k-1
    scroll.event.n = scroll.event.n-1
end

function scrollUpEvent()
    if tabs[activeTab].name ~= 'Summer event' then return end
    if not isMouseInPosition(sx/2 - 211/zoom, sy/2 - 187/zoom, 670/zoom, 418/zoom) then return end
    if summereventSelectedOption then return end
    if scroll.event.n >= #summerEventRewards then return end
    scroll.event.k = scroll.event.k+1
    scroll.event.n = scroll.event.n+1
end

function toggleScrolls(bool)
    if bool then
        bindKey("mouse_wheel_down", "both", scrollUpSettings)
        bindKey("mouse_wheel_up", "both", scrollDownSettings)
        bindKey("mouse_wheel_down", "both", scrollUpVehicles)
        bindKey("mouse_wheel_up", "both", scrollDownVehicles)
        bindKey("mouse_wheel_down", "both", scrollUpJobs)
        bindKey("mouse_wheel_up", "both", scrollDownJobs)
        bindKey("mouse_wheel_down", "both", scrollUpFriends)
        bindKey("mouse_wheel_up", "both", scrollDownFriends)
        bindKey("mouse_wheel_down", "both", scrollUpPages)
        bindKey("mouse_wheel_up", "both", scrollDownPages)
        bindKey("mouse_wheel_down", "both", scrollUpEvent)
        bindKey("mouse_wheel_up", "both", scrollDownEvent)
    else
        unbindKey("mouse_wheel_down", "both", scrollUpSettings)
        unbindKey("mouse_wheel_down", "both", scrollUpVehicles)
        unbindKey("mouse_wheel_up", "both", scrollDownVehicles)
        unbindKey("mouse_wheel_down", "both", scrollUpJobs)
        unbindKey("mouse_wheel_up", "both", scrollDownJobs)
        unbindKey("mouse_wheel_down", "both", scrollUpFriends)
        unbindKey("mouse_wheel_up", "both", scrollDownFriends)
        unbindKey("mouse_wheel_down", "both", scrollUpPages)
        unbindKey("mouse_wheel_up", "both", scrollDownPages)
        unbindKey("mouse_wheel_down", "both", scrollUpEvent)
        unbindKey("mouse_wheel_up", "both", scrollDownEvent)
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if summereventSlider then
        exports['since-scrollbar']:destroyScroll(summereventSlider) 
    end
end)

function getDailyQuestTimeToEnd()
    local time = getRealTime()
    local hour = time.hour
    local minute = time.minute
    local endHour = 23 - hour
    local endMinute = 60 - minute
    return endHour, endMinute
end

getResourceName(getThisResource(), true, 774177532); if true then return end