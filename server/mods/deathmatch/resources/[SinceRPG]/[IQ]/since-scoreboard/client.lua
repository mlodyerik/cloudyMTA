local sx,sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

Scoreboard = {}
Scoreboard.textures = {}
Scoreboard.sorts = {
    {
        name = "Wszyscy",
        value = "all",
        icon = "all"
    },
    {
        name = "Administracja",
        value = "administrations",
        icon = "administrations"
    },
    {
        name = "Frakcje",
        value = "factions",
        icon = "factions"
    },
    {
        name = "Diamond",
        value = "diamond",
        icon = "diamond"
    }
}
Scoreboard.sort = 'all'
Scoreboard.elements = {}
Scoreboard.alpha = 0
Scoreboard.visible = false
Scoreboard.animation = false
Scoreboard.scroll = {
    k = 1,
    n = 10,
    m = 10
}

Scoreboard.pos = sy/2-500/zoom
Scoreboard.status = {
    tick = getTickCount(),
    alpha = 1,
    show = true
}
Scoreboard.avatars = {}

function Scoreboard.render()
    dxDrawImage(sx/2-700/zoom/2, Scoreboard.pos, 700/zoom, 650/zoom, Scoreboard.textures['background'], 0, 0, 0, tocolor(255, 255, 255, 255 * Scoreboard.alpha))
    dxDrawImage(sx/2-700/zoom/2, Scoreboard.pos, 700/zoom, 100/zoom, Scoreboard.textures['header'], 0, 0, 0, tocolor(255, 255, 255, 255 * Scoreboard.alpha))
    dxDrawImage(sx/2-700/zoom/2 - 15/zoom, Scoreboard.pos - 5/zoom, 143/zoom, 114/zoom, Scoreboard.textures['logo'], 0, 0, 0, tocolor(255, 255, 255, 255 * Scoreboard.alpha))

    dxDrawText('Since#5ECD5ARPG', sx/2-700/zoom/2 + 100/zoom, Scoreboard.pos + 100/zoom/2 - dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom))/2 + 3/zoom, nil, nil, tocolor(255, 255, 255, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'center', false, false, false, true)
    dxDrawText('Graczy online '..formatPlayers(#getElementsByType('player')), sx/2-700/zoom/2 + 100/zoom, Scoreboard.pos + 100/zoom/2 + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 16/zoom))/2 - 3/zoom, nil, nil, tocolor(180, 180, 180, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center', false, false, false, true)

    dxDrawImage(sx/2-700/zoom/2 + 250/zoom, Scoreboard.pos + 100/zoom/2 - 48/zoom/2, 181/zoom, 48/zoom, Scoreboard.textures['sorts'], 0, 0, 0, tocolor(255, 255, 255, 255 * Scoreboard.alpha))

    local offset = 0

    for i, v in ipairs(Scoreboard.sorts) do
        local color = (v.value ~= Scoreboard.sort) and (isMouseInPosition(sx/2-700/zoom/2 + 250/zoom + offset, Scoreboard.pos + 100/zoom/2 - 48/zoom/2, 40/zoom, 40/zoom) and tocolor(255, 255, 255, 255 * Scoreboard.alpha) or tocolor(255, 255, 255, 150 * Scoreboard.alpha)) or tocolor(255, 255, 255, 255 * Scoreboard.alpha)
        dxDrawImage(sx/2-700/zoom/2 + 250/zoom + 4/zoom + offset, Scoreboard.pos + 100/zoom/2 - 48/zoom/2 + 4/zoom, 40/zoom, 40/zoom, (v.value == Scoreboard.sort) and Scoreboard.textures['sort-active'] or Scoreboard.textures['sort-bg'], 0, 0, 0, color)
        local color = (v.value == Scoreboard.sort and tocolor(255, 255, 255, 255 * Scoreboard.alpha) or tocolor(99, 99, 99, 255 * Scoreboard.alpha))
        dxDrawImage(sx/2-700/zoom/2 + 250/zoom + 4/zoom + offset + 40/zoom/2 - 22/zoom/2, Scoreboard.pos + 100/zoom/2 - 48/zoom/2 + 4/zoom + 40/zoom/2 - 22/zoom/2, 22/zoom, 22/zoom, Scoreboard.textures[v.icon], 0, 0, 0, color)

        if (isMouseInPosition(sx/2-700/zoom/2 + 250/zoom + 4/zoom + offset, Scoreboard.pos + 100/zoom/2 - 48/zoom/2 + 4/zoom, 40/zoom, 40/zoom)) then
            local cx, cy = getCursorPosition()
            local cx, cy = (cx * sx), (cy * sy)

            dxDrawText(v.name, cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(145, 163, 160, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'top', false, false, true)
        end

        offset = offset + 40/zoom + 4/zoom
    end

    dxDrawImage(sx/2-700/zoom/2, Scoreboard.pos + 100/zoom, 700/zoom, 30/zoom, Scoreboard.textures['sort-bar'], 0, 0, 0, tocolor(255, 255, 255, 255 * Scoreboard.alpha))
    dxDrawText('ID', sx/2-700/zoom/2 + 15/zoom, Scoreboard.pos + 100/zoom + 16/zoom, nil, nil, tocolor(167, 167, 167, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center')
    dxDrawText('GRACZ', sx/2-700/zoom/2 + 15/zoom + 80/zoom, Scoreboard.pos + 100/zoom + 16/zoom, nil, nil, tocolor(167, 167, 167, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center')
    dxDrawText('ORGANIZACJA', sx/2-700/zoom/2 + 15/zoom + 300/zoom, Scoreboard.pos + 100/zoom + 16/zoom, nil, nil, tocolor(167, 167, 167, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
    dxDrawText('SRP', sx/2-700/zoom/2 + 15/zoom + 440/zoom, Scoreboard.pos + 100/zoom + 16/zoom, nil, nil, tocolor(167, 167, 167, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
    dxDrawText('FRAKCJA', sx/2-700/zoom/2 + 15/zoom + 540/zoom, Scoreboard.pos + 100/zoom + 16/zoom, nil, nil, tocolor(167, 167, 167, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
    dxDrawText('PING', sx/2-700/zoom/2 + 15/zoom + 640/zoom, Scoreboard.pos + 100/zoom + 16/zoom, nil, nil, tocolor(167, 167, 167, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')

    local x = 0
    for i,v in pairs(getPlayersBySort(Scoreboard.sort, Scoreboard.elements[1])) do
        if not isElement(v) then
            table.remove(getPlayersBySort(Scoreboard.sort, Scoreboard.elements[1]), i)
        end
        
        if i >= Scoreboard.scroll.k and i <= Scoreboard.scroll.n and isElement(v) then 
            x = x + 1
            local offset = 50/zoom * (x-1)

            if (not Scoreboard.avatars[v] and exports['since-avatars']:getPlayerCircleAvatar(getElementData(v, 'player:sid'))) then
                Scoreboard.avatars[v] = exports['since-avatars']:getPlayerCircleAvatar(getElementData(v, 'player:sid'))
            end
            
            dxDrawText(getElementData(v, 'id'), sx/2-700/zoom/2 + 15/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset, nil, nil, (checkIsFriend(v) and tocolor(244, 84, 255, 255 * Scoreboard.alpha) or tocolor(255, 255, 255, 255 * Scoreboard.alpha)), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center')
            
            local name = getPlayerName(v)

            local data = getElementData(v, 'player:data') or {}

            if data['rainbownick'] then
                name = rainbowColorizeString(name, 4)
            end

            local nickname = (getElementData(v, 'player:spawn') and name or 'Gracz#'..string.format('%03d', (getElementData(v, 'id') or 0)))

            dxDrawImage(sx/2-700/zoom/2 + 15/zoom + 80/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset - 40/zoom/2, 40/zoom, 40/zoom, (Scoreboard.avatars[v] and Scoreboard.avatars[v] or exports['since-avatars']:drawNoAvatar()), 0, 0, 0, tocolor(255, 255, 255, 255 * Scoreboard.alpha))

            local borderColor = tocolor(255, 255, 255, 255 * Scoreboard.alpha)

            if (getElementData(v, 'player:admin')) then
                local rankName = exports['since-admins']:getRankName(getElementData(v, 'player:admin'))
                local rgb = exports['since-admins']:getRankRGB(getElementData(v, 'player:admin'))
                borderColor = tocolor(rgb[1], rgb[2], rgb[3], 255 * Scoreboard.alpha)
            else
                if (getElementData(v, 'player:diamond')) then
                    borderColor = tocolor(46, 140, 255, 255 * Scoreboard.alpha)
                end
            end

            dxDrawImage(sx/2-700/zoom/2 + 15/zoom + 78/zoom, Scoreboard.pos + 100/zoom + 54/zoom + offset - 40/zoom/2, 42/zoom, 42/zoom, Scoreboard.textures['border'], 0, 0, 0, borderColor)

            dxDrawText(name, sx/2-700/zoom/2 + 15/zoom + 80/zoom + 50/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset - 5/zoom - 1/zoom, nil, nil, tocolor(255, 255, 255, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center', false, false, false, true)
            if (Scoreboard.status.show) then
                dxDrawText(getPlayerStatus(v), sx/2-700/zoom/2 + 15/zoom + 80/zoom + 50/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset + 10/zoom - 1/zoom, nil, nil, tocolor(145, 163, 160, (255 * Scoreboard.alpha) * Scoreboard.status.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'center', false, false, false, true)
            else
                if (getElementData(v, 'player:admin')) then
                    local rankName = exports['since-admins']:getRankName(getElementData(v, 'player:admin'))
                    local rgb = exports['since-admins']:getRankRGB(getElementData(v, 'player:admin'))
                    dxDrawText(rankName, sx/2-700/zoom/2 + 15/zoom + 80/zoom + 50/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset + 10/zoom - 1/zoom, nil, nil, tocolor(rgb[1], rgb[2], rgb[3], (255 * Scoreboard.alpha) * Scoreboard.status.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')
                else
                    if (getElementData(v, 'player:diamond')) then
                        dxDrawText('Diamond', sx/2-700/zoom/2 + 15/zoom + 80/zoom + 50/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset + 10/zoom - 1/zoom, nil, nil, tocolor(46, 140, 255, (255 * Scoreboard.alpha) * Scoreboard.status.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')
                    else
                        dxDrawText('Premium', sx/2-700/zoom/2 + 15/zoom + 80/zoom + 50/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset + 10/zoom - 1/zoom, nil, nil, tocolor(145, 163, 160, (255 * Scoreboard.alpha) * Scoreboard.status.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')
                    end
                end
            end

            dxDrawText((getElementData(v, 'player:organization') and getElementData(v, 'player:organization').name or "Brak"), sx/2-700/zoom/2 + 15/zoom + 300/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset, nil, nil, tocolor(255, 255, 255, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

            dxDrawText(getElementData(v, 'player:srp') or 0, sx/2-700/zoom/2 + 15/zoom + 440/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset, nil, nil, tocolor(255, 255, 255, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

            dxDrawText((getElementData(v, 'player:faction') and getElementData(v, 'player:faction') or "Brak"), sx/2-700/zoom/2 + 15/zoom + 540/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset, nil, nil, tocolor(255, 255, 255, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

            dxDrawText(getPlayerPing(v), sx/2-700/zoom/2 + 15/zoom + 640/zoom, Scoreboard.pos + 100/zoom + 55/zoom + offset, nil, nil, tocolor(255, 255, 255, 255 * Scoreboard.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

            if Scoreboard.status.tick + 5000 < getTickCount() then
                Scoreboard.status.tick = getTickCount()
        
                animate(Scoreboard.status.alpha, 0, 'InOutQuad', 250, function (c)
                    Scoreboard.status.alpha = c
                end, function ()
                    Scoreboard.status.show = not Scoreboard.status.show
        
                    animate(Scoreboard.status.alpha, 1, 'InOutQuad', 250, function (c)
                        Scoreboard.status.alpha = c
                    end)
                end)
            end
        end
    end
end

function Scoreboard.click(button, state)
    if (button == 'left' and state == 'down') then
        local offset = 0

        for i, v in ipairs(Scoreboard.sorts) do
            if (isMouseInPosition(sx/2-700/zoom/2 + 250/zoom + offset, Scoreboard.pos + 100/zoom/2 - 48/zoom/2, 40/zoom, 40/zoom)) then
                Scoreboard.sort = v.value
                Scoreboard.scroll = {
                    k = 1,
                    n = 10,
                    m = 10
                }
            end

            offset = offset + 40/zoom + 4/zoom
        end
    end
end

bindKey('tab', 'down', function()
    if not getElementData(localPlayer, 'player:spawn') then return end
    if (Scoreboard.animation) then return end

    Scoreboard.visible = not Scoreboard.visible

    if (Scoreboard.visible) then
        local c = {
            ['background'] = dxCreateTexture('data/images/background.png', 'argb', false, 'clamp'),
            ['header'] = dxCreateTexture('data/images/header.png', 'argb', false, 'clamp'),
            ['logo'] = dxCreateTexture('data/images/logo.png', 'argb', false, 'clamp'),
            ['sorts'] = dxCreateTexture('data/images/sorts.png', 'argb', false, 'clamp'),
            ['sort-bg'] = dxCreateTexture('data/images/sort-bg.png', 'argb', false, 'clamp'),
            ['sort-active'] = dxCreateTexture('data/images/sort-active.png', 'argb', false, 'clamp'),
            ['all'] = dxCreateTexture('data/images/all.png', 'argb', false, 'clamp'),
            ['administrations'] = dxCreateTexture('data/images/administrations.png', 'argb', false, 'clamp'),
            ['factions'] = dxCreateTexture('data/images/factions.png', 'argb', false, 'clamp'),
            ['diamond'] = dxCreateTexture('data/images/diamond.png', 'argb', false, 'clamp'),
            ['editbox'] = dxCreateTexture('data/images/editbox.png', 'argb', false, 'clamp'),
            ['sort-bar'] = dxCreateTexture('data/images/sort-bar.png', 'argb', false, 'clamp'),
            ['border'] = dxCreateTexture('data/images/border.png', 'argb', false, 'clamp')
        }

        for i, v in pairs(c) do
            Scoreboard.textures[i] = v
        end

        Scoreboard.scroll = {
            k = 1,
            n = 10,
            m = 10
        }

        addEventHandler('onClientRender', root, Scoreboard.render)
        addEventHandler('onClientClick', root, Scoreboard.click)
        Scoreboard.elements[1] = exports['since-gui']:createEditbox('Podaj nick/ID gracza', sx/2 + 90/zoom, sy/2-500/zoom, 250/zoom, 40/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 15/zoom,
            caretColor = {255, 255, 255, 50},
            caretWidth = 2,
            font = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
            image = Scoreboard.textures['editbox'],
            placeholderColor = {198, 198, 198},
            specialCharacters = '.*[@!#$%^&*()?<>].*',
        })

        exports['since-gui']:setElementAlpha(Scoreboard.elements[1], 0)
        exports['since-gui']:interpolateToPosition(Scoreboard.elements[1], sx/2 + 90/zoom, sy/2-295/zoom, 300, 'InOutQuad')
        exports['since-gui']:fadeElement(Scoreboard.elements[1], 1, 300, 'InOutQuad')

        Scoreboard.animation = true
        animate(sy/2-500/zoom, sy/2 - 325/zoom, 'InOutQuad', 300, function (c)
            Scoreboard.pos = c
        end)
        animate(Scoreboard.alpha, 1, 'InOutQuad', 300, function (c)
            Scoreboard.alpha = c
        end, function ()
            Scoreboard.animation = false
        end)
    else
        Scoreboard.animation = true

        animate(sy/2 - 325/zoom, sy/2, 'InOutQuad', 300, function (c)
            Scoreboard.pos = c
        end)

        animate(Scoreboard.alpha, 0, 'InOutQuad', 300, function (c)
            Scoreboard.alpha = c
        end, function ()
            Scoreboard.animation = false
            removeEventHandler('onClientRender', root, Scoreboard.render)
            removeEventHandler('onClientClick', root, Scoreboard.click)

            for i, v in ipairs(Scoreboard.elements) do
                if (v) then
                    exports['since-gui']:destroyUIElement(v)
                end
            end

            Scoreboard.elements = {}

            for i, v in pairs(Scoreboard.textures) do
                if (v) then
                    destroyElement(v)
                end
            end
        end)

        exports['since-gui']:fadeElement(Scoreboard.elements[1], 0, 300, 'InOutQuad')
        exports['since-gui']:interpolateToPosition(Scoreboard.elements[1], sx/2 + 90/zoom, sy/2, 300, 'InOutQuad')
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function ()
    for i, v in ipairs(Scoreboard.elements) do
        if (v) then
            exports['since-gui']:destroyUIElement(v)
        end
    end

    Scoreboard.elements = {}

    for i, v in pairs(Scoreboard.textures) do
        if (v) then
            destroyElement(v)
        end
    end
end)