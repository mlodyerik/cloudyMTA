local organization = false
local activeTab = 1
local currentUiRender = false
local canPerformAction = true

function setActiveTab(tab)
    activeTab = tab
end

function havePermission()
    if getElementData(localPlayer, 'player:sid') == 1 or getElementData(localPlayer, 'player:sid') == 182 or getElementData(localPlayer, 'player:sid') == 3 or getElementData(localPlayer, 'player:sid') == 4 then
        return true
    else
        return false
    end
end

local function getNextLevelExp(level)
    return math.floor(100 * ((level + 1) ^ 2))
end

local function numberWithCommas(n)
    local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)','%1,'):reverse()) .. right
end

local function numberWithSpaces(n)
    local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)','%1 '):reverse()) .. right
end

local function drawTab(text, smallText, icon, x, y, w, h, active, last)
    dxDrawImage(x, y, w, h, 'data/item' .. (last and '-last' or '') .. (active and '-active' or '') .. '.png')

    local textW = dxGetTextWidth(text, 1, uiElements.interFontNormal)
    local smallTextW = dxGetTextWidth(smallText, 1, uiElements.interFontSmall)
    textW = textW > smallTextW and textW or smallTextW

    local textX = x + w/2 - textW/2 + 23/zoom
    
    dxDrawText(text, textX, y + h/2 + 2, nil, nil, white, 1, uiElements.interFontNormal, 'left', 'bottom')
    dxDrawText(smallText, textX, y + h/2 + 2, nil, nil, 0xAAFFFFFF, 1, uiElements.interFontSmall, 'left', 'top')

    dxDrawImage(textX - 48/zoom, y + 25/zoom, 40/zoom, 40/zoom, 'data/'..icon..'.png')
end

uiRender = {
    default = {
        render = function(organization)
            local h = dxGetFontHeight(1, uiElements.interFontBold)

            dxDrawImage(sx/2 - 600/zoom, sy/2 - 350/zoom, 1200/zoom, 700/zoom, 'data/background.png')
            dxDrawImage(sx/2 - 600/zoom, sy/2 - 350/zoom, 1200/zoom, 90/zoom, 'data/top.png')
            dxDrawText('Organizacja', sx/2 - 580/zoom, sy/2 - 338/zoom, nil, nil, white, 1, uiElements.interFontBold)
            dxDrawText(organization.name, sx/2 - 580/zoom, sy/2 - 338/zoom + h, nil, nil, 0xff68D65E, 1, uiElements.interFont)

            drawTab('Dashboard', 'Twoja organizacja', 'dashboard', sx/2 - 350/zoom, sy/2 - 350/zoom, 240/zoom, 90/zoom, activeTab == 1)
            drawTab('Logi', 'Lista działań', 'logs', sx/2 - 107/zoom, sy/2 - 350/zoom, 200/zoom, 90/zoom, activeTab == 2)
            drawTab('Zarządzanie', 'Ustawienia', 'settings', sx/2 + 96/zoom, sy/2 - 350/zoom, 215/zoom, 90/zoom, activeTab == 3)
            drawTab('Pojazdy', 'Pojazdy organizacyjne', 'vehicle', sx/2 + 314/zoom, sy/2 - 350/zoom, 285/zoom, 90/zoom, activeTab == 4, true)
        end,
        click = function(organization, button, state)
            if button ~= 'left' or state ~= 'down' then return end
            if isMouseInPosition(sx/2 - 350/zoom, sy/2 - 350/zoom, 240/zoom, 90/zoom) then
                activeTab = 1
                setUIRender('dashboard')
            elseif isMouseInPosition(sx/2 - 107/zoom, sy/2 - 350/zoom, 200/zoom, 90/zoom) then
                activeTab = 2
                setUIRender('logs')
            elseif isMouseInPosition(sx/2 + 96/zoom, sy/2 - 350/zoom, 215/zoom, 90/zoom) then
                activeTab = 3
                setUIRender('settings')
            elseif isMouseInPosition(sx/2 + 314/zoom, sy/2 - 350/zoom, 285/zoom, 90/zoom) then
                activeTab = 4
                setUIRender('vehicles')
            end
        end
    },
    dashboard = {
        render = function(organization)
            dxDrawImage(sx/2 - 570/zoom, sy/2 - 220/zoom, 350/zoom, 240/zoom, 'data/level-bg.png')
            dxDrawImage(sx/2 - 445/zoom, sy/2 - 190/zoom, 100/zoom, 110/zoom, 'data/level-shield.png')
            dxDrawText(organization.level, sx/2 - 395/zoom, sy/2 - 135/zoom, nil, nil, white, 1, uiElements.interExtraBold, 'center', 'bottom')
            dxDrawText('POZIOM', sx/2 - 395/zoom, sy/2 - 135/zoom, nil, nil, white, 1, uiElements.interSemiBold, 'center', 'top')
            dxDrawText(organization.exp .. ' / ' .. getNextLevelExp(organization.level) .. ' EXP', sx/2 - 395/zoom, sy/2 - 35/zoom, nil, nil, white, 1, uiElements.interRegular, 'center', 'bottom')
            dxDrawText('NASTĘPNY POZIOM', sx/2 - 395/zoom, sy/2 - 35/zoom, nil, nil, 0xFF7CF072, 1, uiElements.interFontSmallBold, 'center', 'top')

            dxDrawImage(sx/2 - 200/zoom, sy/2 - 220/zoom, 450/zoom, 240/zoom, 'data/money-bg.png')
            dxDrawText('Saldo konta organizacyjnego', sx/2 + 25/zoom, sy/2 - 110/zoom, nil, nil, 0xDDFFFFFF, 1, uiElements.interFont, 'center', 'bottom')
            dxDrawText('#68D65E$ #ffffff' .. numberWithSpaces(organization.money), sx/2 + 25/zoom, sy/2 - 110/zoom, nil, nil, white, 1, uiElements.moneyFont, 'center', 'top', false, false, false, true)

            dxDrawImage(sx/2 + 270/zoom, sy/2 - 220/zoom, 300/zoom, 240/zoom, 'data/logs-bg.png')
            dxDrawImage(sx/2 + 390/zoom, sy/2 - 195/zoom, 60/zoom, 60/zoom, 'data/actions.png')
            dxDrawText('Akcje', sx/2 + 420/zoom, sy/2 - 92/zoom, nil, nil, 0xFFFFFFFF, 1, uiElements.interFont, 'center', 'bottom')
            dxDrawText('Lista dostępnych akcji \
twojej organizacji', sx/2 + 420/zoom, sy/2 - 92/zoom, nil, nil, 0xDDFFFFFF, 1, uiElements.interFontSmall, 'center', 'top')
            dxDrawImage(sx/2 + 355/zoom, sy/2 - 30/zoom, 130/zoom, 30/zoom, 'data/small-button.png')
            dxDrawText('Przejdź', sx/2 + 420/zoom, sy/2 - 15/zoom, nil, nil, white, 0.9, uiElements.interFontSmall, 'center', 'center')
            
            dxDrawImage(sx/2 - 570/zoom, sy/2 + 60/zoom, 1140/zoom, 3/zoom, 'data/hr.png')
            
            dxDrawText('Członkowie organizacji', sx/2 - 580/zoom, sy/2 + 110/zoom, nil, nil, white, 1, uiElements.interFontBold, 'left', 'bottom')
            dxDrawText('Łączna ilość członków organizacji: #68D65E' .. #organization.members .. ' / 50', sx/2 - 580/zoom, sy/2 + 106/zoom, nil, nil, 0xCCFFFFFF, 0.9, uiElements.interFont, 'left', 'top', false, false, false, true)
        
            dxDrawText('Typ organizacji', sx/2 + 580/zoom, sy/2 + 110/zoom, nil, nil, white, 1, uiElements.interFontBold, 'right', 'bottom')
            local orgType = organization.gang and {'Przestępcza', 0xFFFF8E8E} or {'Cywilna', 0xFF7CF072}
            dxDrawText(orgType[1], sx/2 + 580/zoom, sy/2 + 106/zoom, nil, nil, orgType[2], 0.9, uiElements.interFont, 'right', 'top', false, false, false, true)
        

            local w = math.min(1160/zoom, uiElements.w)
            dxDrawImageSection(sx/2 - 580/zoom, sy/2 + 150/zoom, w, 170/zoom, uiElements.targetX or 0, 0, w, 170/zoom, uiElements.target)

            if uiElements.catchX then
                local cx, cy = getCursorPosition()
                cx, cy = cx * sx, cy * sy
                uiElements.targetX = math.min(math.max(0, uiElements.catchX - cx + (sx/2 - 580/zoom)), uiElements.w - 1160/zoom)
            end
        end,
        click = function(organization, button, state)
            if button ~= 'left' then return end
            if state == 'down' then
                if isMouseInPosition(sx/2 + 355/zoom, sy/2 - 30/zoom, 130/zoom, 30/zoom) then
                    activeTab = 0
                    setUIRender('actions')
                end

                local w = math.min(1160/zoom, uiElements.w)
                if uiElements.w > 1160/zoom and isMouseInPosition(sx/2 - 580/zoom, sy/2 + 150/zoom, w, 170/zoom) then
                    local cx, cy = getCursorPosition()
                    cx, cy = cx * sx, cy * sy
                    uiElements.catchX = cx - (sx/2 - 580/zoom) + (uiElements.targetX or 0)
                end
            else
                uiElements.catchX = false
            end
        end,
        init = function(organization)
            local w = #organization.members * 180/zoom

            uiElements.target = dxCreateRenderTarget(math.floor(w), math.floor(170/zoom), true)
            uiElements.w = w
        end,
        destroy = function(organization)
            if uiElements.target then
                if isElement(uiElements.target) then
                    destroyElement(uiElements.target)
                end
                uiElements.target = false
            end
        end,
        update = function(organization)
            dxSetRenderTarget(uiElements.target, true)
            local x = 0
            for _,member in pairs(organization.members) do
                local rank = getRank(member.rank)
                dxSetBlendMode('overwrite')
                dxDrawImage(x, 0, 170/zoom, 170/zoom, 'data/user-item.png', 0, 0, 0, rank.color)
                dxSetBlendMode('blend')

                dxDrawText(member.nick, x + 85/zoom, 135/zoom, nil, nil, white, 0.8, uiElements.interExtraBold, 'center', 'bottom')
                dxDrawText(rank.name, x + 85/zoom, 135/zoom, nil, nil, rank.textColor, 1, uiElements.interFontSmallBold, 'center', 'top')
                dxDrawImage(x + 40/zoom, 20/zoom, 90/zoom, 90/zoom, exports['since-avatars']:getPlayerCircleAvatar(member.sid))

                x = x + 180/zoom
            end

            dxSetBlendMode('blend')
            dxSetRenderTarget()
        end,
        onScroll = function(scroll)
            if isMouseInPosition(sx/2 - 580/zoom, sy/2 + 150/zoom, 1160/zoom, 170/zoom) then
                uiElements.targetX = math.min(math.max(0, (uiElements.targetX or 0) + scroll * 25), uiElements.w - 1160/zoom)
                uiElements.targetX = math.max(uiElements.targetX, 0)
            end
        end
    },
    logs = {
        render = function(organization)
            dxDrawText('Lista działań organizacji', sx/2 - 577/zoom, sy/2 - 243/zoom, nil, nil, white, 1, uiElements.interRegular)

            local y = 0
            for k,v in pairs(organization.logs) do
                if k >= (uiElements.logsScroll or 1) and k <= (uiElements.logsScroll or 1) + 8 then                    
                    if v.member then
                        dxDrawImage(sx/2 - 577/zoom, sy/2 - 205/zoom + y, 1154/zoom, 56/zoom, 'data/log.png')
                        dxDrawText(v.title, sx/2 - 577/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontSmallBold, 'left', 'bottom', false, false, false, true)
                        dxDrawText(v.subTitle, sx/2 - 577/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 0.9, uiElements.interFontSmall, 'left', 'top', false, false, false, true)
                        dxDrawText('Osoba', sx/2 - 277/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontSmallBold, 'left', 'bottom')
                        dxDrawText(v.member, sx/2 - 277/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 0.9, uiElements.interFontSmall, 'left', 'top')
                        dxDrawText('Data i godzina działania', sx/2 - 77/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontSmallBold, 'left', 'bottom')
                        dxDrawText(v.date:gsub('-', '.'), sx/2 - 77/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 0.9, uiElements.interFontSmall, 'left', 'top')
                        dxDrawText('Informacje dodatkowe', sx/2 + 247/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontSmallBold, 'left', 'bottom')
                        dxDrawText(v.description or 'Brak', sx/2 + 247/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 0.9, uiElements.interFontSmall, 'left', 'top')

                        y = y + 56/zoom + 2
                    end
                end
            end

            drawScrollbar(organization.logs, sx/2 + 585/zoom, sy/2 - 205/zoom, 4/zoom, 525/zoom, 9, (uiElements.logsScroll or 1), 155)
        end,
        onScroll = function(scroll)
            uiElements.logsScroll = math.min(math.max((uiElements.logsScroll or 1) + scroll, 1), #organization.logs - 8)
        end
    },
    actions = {
        render = function(organization)
            dxDrawText('Dostępne akcje dla organizacji', sx/2 - 577/zoom, sy/2 - 243/zoom, nil, nil, white, 1, uiElements.interRegular)
            
            local function drawOption(x, y, w, h, color, icon, text, smallText)
                dxDrawImage(x, y, w, h, 'data/user-item.png', 0, 0, 0, color)
                dxDrawImage(x + w * 0.36, y + h * 0.15, w * 0.3, h * 0.3, uiElements.icons[icon])
                dxDrawText(text, x + w/2, y + h * 0.7, nil, nil, color, 1, uiElements.interSemiBold, 'center', 'bottom')
                dxDrawText(smallText, x + w * 0.05, y + h * 0.7, x + w * 0.95, y + h * 0.7, 0xFFFFFFFF, 0.8, uiElements.interFontSmall, 'center', 'top', false, true)
            end

            drawOption(sx/2 - 577/zoom, sy/2 - 185/zoom, 190/zoom, 190/zoom, 0xFF40bcff, 'map', 'Artefakt', 'Rozpocznij szukanie artefaktu')

            if organization.gang and not organization.garage then
                drawOption(sx/2 - 577/zoom + 200/zoom, sy/2 - 185/zoom, 190/zoom, 190/zoom, 0xFF40bcff, 'garage', 'Wykup dziuple', '40,000,000 $')
            end
        end,
        click = function(organization, button, state)
            if isMouseInPosition(sx/2 - 577/zoom, sy/2 - 185/zoom, 190/zoom, 190/zoom) then
                showModal({
                    title = 'Szukanie artefaktu',
                    message = 'Czy chcesz rozpocząć szukanie artefaktu',
                    confirm = 'Rozpocznij',
                    cancel = 'Anuluj',
                    id = 'startArtifact'
                })
            end

            if organization.gang and not organization.garage then
                if isMouseInPosition(sx/2 - 577/zoom + 200/zoom, sy/2 - 185/zoom, 190/zoom, 190/zoom) then
                    showModal({
                        title = 'Wykup dziuple',
                        message = 'Czy chcesz wykupić dziuple za 40,000,000 $?',
                        confirm = 'Wykup',
                        cancel = 'Anuluj',
                        id = 'buyGarage'
                    })
                end
            end
        end,

        init = function(organization)
        end,

        destroy = function(organization)
        end,

        update = function(organization)
        end,

        onScroll = function(scroll)
        end
    },
    settings = {
        render = function(organization)
            dxDrawText('Zarządzanie członkami organizacji', sx/2 - 577/zoom, sy/2 - 243/zoom, nil, nil, white, 1, uiElements.interRegular)
            
            local w = math.min(1160/zoom, uiElements.w)
            dxDrawImageSection(sx/2 - 580/zoom, sy/2 - 200/zoom, w, 270/zoom, uiElements.targetX or 0, 0, w, 270/zoom, uiElements.target)
            
            if uiElements.catchX then
                local cx, cy = getCursorPosition()
                cx, cy = cx * sx, cy * sy
                uiElements.targetX = math.min(math.max(0, uiElements.catchX - cx + (sx/2 - 580/zoom)), uiElements.w - 1160/zoom)
            end

            dxDrawText('Zarządzanie organizacją', sx/2 - 577/zoom, sy/2 + 93/zoom, nil, nil, white, 1, uiElements.interRegular)
            
            local function drawOption(x, y, w, h, color, icon, text, smallText)
                dxDrawImage(x, y, w, h, 'data/user-item.png', 0, 0, 0, color)
                dxDrawImage(x + w * 0.3, y + h * 0.15, w * 0.4, h * 0.4, uiElements.icons[icon])
                dxDrawText(text, x + w/2, y + h * 0.7, nil, nil, color, 1, uiElements.interSemiBold, 'center', 'bottom')
                dxDrawText(smallText, x + w * 0.05, y + h * 0.7, x + w * 0.95, y + h * 0.7, 0xFFFFFFFF, 0.8, uiElements.interFontSmall, 'center', 'top', false, true)
            end

            drawOption(sx/2 - 577/zoom, sy/2 + 133/zoom, 190/zoom, 190/zoom, 0xFF40bcff, 'map', 'Spawn organizacji', 'Ustaw spawn organizacji w tym miejscu')
            drawOption(sx/2 - 375/zoom, sy/2 + 133/zoom, 190/zoom, 190/zoom, 0xFFFF8E8E, 'trash-big', 'Usuń organizację', 'Permanentnie usuwa organizację')
            drawOption(sx/2 - 173/zoom, sy/2 + 133/zoom, 190/zoom, 190/zoom, 0xFF74FF71, 'add', 'Dodaj członka', 'Dodaj gracza do organizacji')
        end,
        click = function(organization, button, state)
            if not canPerformAction then return end
            if button ~= 'left' then return end
            if state == 'down' then
                if isMouseInPosition(sx/2 - 577/zoom, sy/2 + 133/zoom, 190/zoom, 190/zoom) then
                    showModal({
                        title = 'Spawn organizacji',
                        message = 'Czy na pewno chcesz ustawić spawn organizacji w tym miejscu?',
                        confirm = 'Ustaw',
                        cancel = 'Anuluj',
                        id = 'setSpawn'
                    })
                elseif isMouseInPosition(sx/2 - 375/zoom, sy/2 + 133/zoom, 190/zoom, 190/zoom) then
                    showModal({
                        title = 'Usuń organizację',
                        message = 'Czy na pewno chcesz usunąć organizację? Operacja jest nieodwracalna!',
                        confirm = 'Usuń',
                        cancel = 'Anuluj',
                        id = 'removeOrganization'
                    })
                elseif isMouseInPosition(sx/2 - 173/zoom, sy/2 + 133/zoom, 190/zoom, 190/zoom) then
                    local nick = showModal({
                        title = 'Dodaj członka',
                        message = 'Podaj UID gracza, którego chcesz dodać do organizacji',
                        input = 'UID',
                        confirm = 'Dodaj',
                        cancel = 'Anuluj',
                        id = 'addMember'
                    })
                    if nick then
                        triggerServerEvent('since:organizations:addMember', resourceRoot, organization.id, nick)
                    end
                end

                local w = math.min(1160/zoom, uiElements.w)
                if uiElements.w > 1160/zoom and isMouseInPosition(sx/2 - 580/zoom, sy/2 - 200/zoom, w, 270/zoom) then
                    local cx, cy = getCursorPosition()
                    cx, cy = cx * sx, cy * sy
                    uiElements.catchX = cx - (sx/2 - 580/zoom) + (uiElements.targetX or 0)
                end

                local x = 0
                for k,v in pairs(organization.members) do
                    local rank = getRank(v.rank)
                    local canDoOptions = false
                    if organization.isOwner and v.sid ~= getElementData(localPlayer, 'player:sid') then
                        canDoOptions = true
                    end
                    
                    if organization.myRank == 3 and v.rank < 3 then
                        canDoOptions = true
                    end

                    if canDoOptions then
                        if isMouseInPosition(sx/2 - 580/zoom + x + 45/zoom - (uiElements.targetX or 0), sy/2 - 200/zoom + 210/zoom, 40/zoom, 40/zoom) then
                            triggerServerEvent('since:organizations:rankDown', resourceRoot, organization.id, v.sid)
                            canPerformAction = false
                            uiElements.catchX = false
                            break
                        elseif isMouseInPosition(sx/2 - 580/zoom + x + 95/zoom - (uiElements.targetX or 0), sy/2 - 200/zoom + 210/zoom, 40/zoom, 40/zoom) then
                            triggerServerEvent('since:organizations:rankUp', resourceRoot, organization.id, v.sid)
                            canPerformAction = false
                            uiElements.catchX = false
                            break
                        elseif isMouseInPosition(sx/2 - 580/zoom + x + 145/zoom - (uiElements.targetX or 0), sy/2 - 200/zoom + 210/zoom, 40/zoom, 40/zoom) then
                            triggerServerEvent('since:organizations:removeMember', resourceRoot, organization.id, v.sid)
                            canPerformAction = false
                            uiElements.catchX = false
                            break
                        end
                    end

                    x = x + 240/zoom
                end 
            else
                uiElements.catchX = false
            end
        end,
        init = function(organization)
            local w = #organization.members * 240/zoom

            uiElements.target = dxCreateRenderTarget(math.floor(w), math.floor(270/zoom), true)
            uiElements.w = w
        end,
        destroy = function(organization)
            if uiElements.target then
                if isElement(uiElements.target) then
                    destroyElement(uiElements.target)
                end
                uiElements.target = false
            end
        end,
        update = function(organization)
            dxSetRenderTarget(uiElements.target, true)
            local x = 0
            for _, member in pairs(organization.members) do
                local rank = getRank(member.rank)
                local canDoOptions = false
                
                if organization.isOwner and member.sid ~= getElementData(localPlayer, 'player:sid') then
                    canDoOptions = true
                end

                if organization.myRank == 3 and member.rank < 3 then
                    canDoOptions = true
                end

                dxSetBlendMode('overwrite')
                dxDrawImage(x, 0, 230/zoom, 270/zoom, 'data/user-big-item.png', 0, 0, 0, rank.color)
                dxSetBlendMode('blend')

                local oy = canDoOptions and 0 or 30/zoom
                dxDrawText(member.nick, x + 115/zoom, 175/zoom + oy, nil, nil, white, 0.8, uiElements.interExtraBold, 'center', 'bottom')
                dxDrawText(rank.name, x + 115/zoom, 175/zoom + oy, nil, nil, rank.textColor, 1, uiElements.interFontSmallBold, 'center', 'top')
                dxDrawImage(x + 55/zoom, 20/zoom + oy, 120/zoom, 120/zoom, exports['since-avatars']:getPlayerCircleAvatar(member.sid))

                if canDoOptions then
                    local function drawIcon(x, y, w, h, icon)
                        dxDrawImage(x, y, w, h, 'data/user-action.png')
                        dxDrawImage(x + w * 0.15, y + h * 0.15, w * 0.7, h * 0.7, uiElements.icons[icon])
                    end

                    drawIcon(x + 45/zoom, 210/zoom, 40/zoom, 40/zoom, 'rank-down')
                    drawIcon(x + 95/zoom, 210/zoom, 40/zoom, 40/zoom, 'rank-up')
                    drawIcon(x + 145/zoom, 210/zoom, 40/zoom, 40/zoom, 'remove')
                end

                x = x + 240/zoom
            end

            dxSetBlendMode('blend')
            dxSetRenderTarget()
        end,
        onScroll = function(scroll)
            if isMouseInPosition(sx/2 - 580/zoom, sy/2 + 150/zoom, 1160/zoom, 170/zoom) then
                uiElements.targetX = math.min(math.max(0, (uiElements.targetX or 0) + scroll * 25), uiElements.w - 1160/zoom)
                uiElements.targetX = math.max(uiElements.targetX, 0)
            end
        end
    },
    vehicles = {
        render = function(organization)
            dxDrawText('Lista pojazdów organizacji', sx/2 - 577/zoom, sy/2 - 243/zoom, nil, nil, white, 1, uiElements.interRegular)

            local y = 0
            for k,v in pairs(organization.vehicles) do
                if k >= (uiElements.vehiclesScroll or 1) and k <= (uiElements.vehiclesScroll or 1) + 8 then
                    local owner = false
                    for _,m in pairs(organization.members) do
                        if m.sid == v.owner then
                            owner = m
                            break
                        end
                    end
                    
                    if owner then
                        local rank = getRank(owner.rank)

                        dxDrawImage(sx/2 - 577/zoom, sy/2 - 205/zoom + y, 1154/zoom, 56/zoom, 'data/log.png')
                        local txt = ''..exports['since-vehiclenames']:getVehicleName(v.model)..' ('..v.id..')'
                        local textWidth = dxGetTextWidth(txt, 1, uiElements.interFontBold)
                        dxDrawText(txt, sx/2 - 577/zoom + 15/zoom, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontBold, 'left', 'center')
                        dxDrawText('Właściciel', sx/2 - 557/zoom + 15/zoom + textWidth, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontSmallBold, 'left', 'bottom')
                        dxDrawText(owner.nick, sx/2 - 557/zoom + 15/zoom + textWidth, sy/2 - 205/zoom + y + 28/zoom, nil, nil, rank.textColor, 0.9, uiElements.interFontSmall, 'left', 'top')

                        local function findVehicleByUID(uid)
                            for i,v in ipairs(getElementsByType('vehicle')) do
                                if getElementData(v, 'vehicle:id') == uid then
                                    local x, y, z = getElementPosition(v)
                                    local zone = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)

                                    return zone
                                end
                            end
                        end

                        dxDrawText('Lokalizacja', sx/2 - 377/zoom + 15/zoom + textWidth, sy/2 - 205/zoom + y + 28/zoom, nil, nil, white, 1, uiElements.interFontSmallBold, 'left', 'bottom')

                        if findVehicleByUID(v.id) then
                            location = findVehicleByUID(v.id)
                        elseif v.state == 2 then
                            location = 'Parking policyjny'
                        else
                            location = 'Przechowalnia'
                        end

                        dxDrawText(location, sx/2 - 377/zoom + 15/zoom + textWidth, sy/2 - 205/zoom + y + 28/zoom, nil, nil, tocolor(255,255,255,225), 0.9, uiElements.interFontSmall, 'left', 'top')

                        y = y + 56/zoom + 2
                    end
                end
            end

            drawScrollbar(organization.vehicles, sx/2 + 585/zoom, sy/2 - 205/zoom, 4/zoom, 525/zoom, 9, (uiElements.vehiclesScroll or 1), 155)
        end,
        onScroll = function(scroll)
            uiElements.vehiclesScroll = math.min(math.max((uiElements.vehiclesScroll or 1) + scroll, 1), #organization.vehicles - 8)
        end
    },
}

addEvent('onModalConfirm', true)
addEventHandler('onModalConfirm', resourceRoot, function(id, nick)
    if id == 'setSpawn' then
        triggerServerEvent('since:organizations:setSpawn', resourceRoot, organization.id)
    elseif id == 'removeOrganization' then
        triggerServerEvent('since:organizations:removeOrganization', resourceRoot, organization.id)
        destroyUI()
    elseif id == 'addMember' then
        triggerServerEvent('since:organizations:addMember', resourceRoot, organization.id, nick)
    elseif id == 'startArtifact' then
        triggerServerEvent('since:organizations:startArtifact', resourceRoot, organization.id)
    elseif id == 'buyGarage' then
        if organization.garage then 
            return outputChatBox("✘#FFFFFF Twoja organizacja posiada już wykupioną dziuple", 255, 0, 0, true)
        end 

        triggerServerEvent('since:organizations:buyGarage', resourceRoot, organization)
    end
end)

addEvent('since:organizations:result', true)
addEventHandler('since:organizations:result', resourceRoot, function(result)
    showNotification(result.message, result.status and 'success' or 'error')
    canPerformAction = true
    if result.data then
        setRenderData(result.data)
    end
end)

function setRenderData(data)
    organization = data

    setUIRender(currentUiRender)
end

function setUIRender(name)
    if uiRender.current and uiRender[uiRender.current] and uiRender[uiRender.current].destroy then
        uiRender[uiRender.current].destroy(organization)
    end
    uiRender.current = name
    if uiRender[name] and uiRender[name].init then
        uiRender[name].init(organization)
    end
    if uiRender[name] and uiRender[name].update then
        uiRender[name].update(organization)
    end

    currentUiRender = name
end

addEventHandler('onClientRestore', root, function()
    if not isEventHandlerAdded('onClientRender', root, renderUI) then return end
    if uiRender.current and uiRender[uiRender.current] and uiRender[uiRender.current].update then
        uiRender[uiRender.current].update(organization)
    end
end)

bindKey('mouse_wheel_up', 'down', function()
    if uiRender.current and uiRender[uiRender.current] and uiRender[uiRender.current].onScroll then
        uiRender[uiRender.current].onScroll(-1)
    end
end)

bindKey('mouse_wheel_down', 'down', function()
    if uiRender.current and uiRender[uiRender.current] and uiRender[uiRender.current].onScroll then
        uiRender[uiRender.current].onScroll(1)
    end
end)

function renderOrganizationUI()
    uiRender['default'].render(organization)
    if uiRender.current and uiRender[uiRender.current] and uiRender[uiRender.current].render then
        uiRender[uiRender.current].render(organization)
    end
end

function clickOrganizationUI(button, state)
    uiRender['default'].click(organization, button, state)
    if uiRender.current and uiRender[uiRender.current] and uiRender[uiRender.current].click then
        uiRender[uiRender.current].click(organization, button, state)
    end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

getResourceName(getThisResource(), true, 167014450); if true then return end