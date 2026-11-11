  

local angle = 260
local rotSpeed = 0.25
local music = nil
local reloadTick = getTickCount()
local savedNick = nil
local playersData = {}

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;

    return x+dx, y+dy;
end

function loadPlayersData(tbl)
    playersData = tbl
end
addEvent('loadPlayersData', true)
addEventHandler('loadPlayersData', root, loadPlayersData)

function findPlayerInTable(nick)
    for i, v in ipairs(playersData) do
        if v.login == nick then
            return v.uid
        end
    end

    return false
end

local noAv = exports['since-avatars']:drawNoAvatar()

function renderUI()
    angle = (angle - rotSpeed) % 360
    local cx, cy, cz, lx, ly, lz = getCameraMatrix(localPlayer)
    local c1, c2, c3, c4, c5 = spawns[data.selectedSpawn].camera[1], spawns[data.selectedSpawn].camera[2], spawns[data.selectedSpawn].pos[1], spawns[data.selectedSpawn].pos[2], spawns[data.selectedSpawn].pos[3]
    local camx, camy = getPointFromDistanceRotation(c3, c4, 115, angle)
    smoothMoveCamera(camx, camy, c5 + 35, c3, c4, c5)
    
    if data.loginWindow == 'login' then
        savedNick = exports['since-gui']:getEditboxText(uiElements['edit_login'])
        
        -- cloudyMTA - NOWY EKRAN LOGOWANIA
        -- Ciemne tło #101719
        dxDrawRectangle(0, 0, sx, sy, tocolor(16, 23, 25, 255))
        
        -- Gradient overlay dla głębi
        dxDrawRectangle(0, 0, sx, sy/2, tocolor(25, 36, 38, 80))
        
        -- Główne logo cloudyMTA (oryginalne PNG)
        local logoW, logoH = 500/zoom, 141/zoom
        dxDrawImage(sx/2 - logoW/2, sy/2 - 350/zoom, logoW, logoH, 'data/logo.png')
        
        -- Subtelny efekt glow pod logo
        dxDrawRectangle(sx/2 - 250/zoom, sy/2 - 240/zoom, 500/zoom, 2/zoom, tocolor(46, 117, 111, 150))
        
        -- cloudyMTA paleta kolorów
        local cloudyPrimary = {46, 117, 111}    -- #2E756F
        local cloudyAccent = {67, 143, 135}     -- #438F87
        local cloudyBg = {16, 23, 25}           -- #101719
        local cloudyPanel = {25, 36, 38}        -- #192426
        local cloudyText = {241, 245, 244}      -- #F1F5F4
        local cloudyTextSec = {145, 163, 160}   -- #91A3A0
        
        -- Avatar użytkownika (jeśli istnieje)
        if findPlayerInTable(savedNick) then
            local avatar = exports['since-avatars']:getPlayerCircleAvatar(findPlayerInTable(savedNick), textures.mask)
            local avSize = 120/zoom
            dxDrawImage(sx/2 - avSize/2, sy/2 - 200/zoom, avSize, avSize, avatar and avatar or noAv)
            -- Turkusowa ramka avatara
            dxDrawCircle(sx/2, sy/2 - 140/zoom, avSize/2 + 2/zoom, 0, 360, tocolor(46, 117, 111, 200), tocolor(46, 117, 111, 200), 2)
            
            -- Powitanie
            dxDrawText('Witaj ponownie!', sx/2, sy/2 - 60/zoom, nil, nil, tocolor(67, 143, 135, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')
            dxDrawText(savedNick, sx/2, sy/2 - 40/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'center', 'center')
        end
    
        -- dxDrawImage(66/zoom + 514/zoom/2 - 356/zoom, sy - 103/zoom, 712/zoom, 103/zoom, 'data/green_shadow.png')
        -- dxDrawText('Na serwerze znajduje się '..#getElementsByType('player')..' graczy', 66/zoom + 514/zoom/2 + 1, sy - 25/zoom + 1, nil, nil, tocolor(0, 0, 0, 175), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
        -- dxDrawText('Na serwerze znajduje się #438F87'..#getElementsByType('player')..'#ffffff graczy', 66/zoom + 514/zoom/2, sy - 25/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center', false, false, false, true)
    
        -- NOWE PRZYCISKI cloudyMTA - nowoczesne, minimalistyczne
        local btnW, btnH = 280/zoom, 55/zoom
        local btnGap = 15/zoom
        
        -- Przycisk ZALOGUJ (turkusowy, primary)
        local loginIn = isMouseInPosition(sx/2 - btnW - btnGap/2, sy/2 + 120/zoom, btnW, btnH)
        local loginColor = loginIn and tocolor(67, 143, 135, 255) or tocolor(46, 117, 111, 255)
        dxDrawRoundedRectangle(sx/2 - btnW - btnGap/2, sy/2 + 120/zoom, btnW, btnH, 8/zoom, loginColor)
        dxDrawText('ZALOGUJ SIĘ', sx/2 - btnW/2 - btnGap/2, sy/2 + 120/zoom + btnH/2, nil, nil, tocolor(241, 245, 244, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
        
        -- Przycisk REJESTRACJA (przezroczysty z obramowaniem)
        local registerIn = isMouseInPosition(sx/2 + btnGap/2, sy/2 + 120/zoom, btnW, btnH)
        local regBorder = registerIn and tocolor(67, 143, 135, 255) or tocolor(46, 117, 111, 255)
        local regBg = registerIn and tocolor(46, 117, 111, 40) or tocolor(25, 36, 38, 180)
        dxDrawRoundedRectangle(sx/2 + btnGap/2, sy/2 + 120/zoom, btnW, btnH, 8/zoom, regBg)
        dxDrawRectangleBorder(sx/2 + btnGap/2, sy/2 + 120/zoom, btnW, btnH, regBorder, 2/zoom, 8/zoom)
        dxDrawText('STWÓRZ KONTO', sx/2 + btnW/2 + btnGap/2, sy/2 + 120/zoom + btnH/2, nil, nil, tocolor(241, 245, 244, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
        
        -- Ikony pól (subtelne, turkusowe)
        
        -- Informacja o Discord (subtelna, na dole)
        dxDrawText('Zapomniałeś hasła?', sx/2, sy - 80/zoom, nil, nil, tocolor(67, 143, 135, 180), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')
        dxDrawText('discord.gg/cloudymta', sx/2, sy - 60/zoom, nil, nil, tocolor(46, 117, 111, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
        
        -- Licznik graczy (subtelny)
        local playerCount = #getElementsByType('player')
        dxDrawText('Graczy online: '..playerCount, sx/2, sy - 30/zoom, nil, nil, tocolor(67, 143, 135, 150), 1, exports['since-fonts']:getFont('Inter-Regular', 11/zoom), 'center', 'center')
    elseif data.loginWindow == 'spawn' then
	    dxDrawImage(0, 0, sx, sy, 'data/shadow.png')
        --dxDrawImage(sx / 2 - 356/zoom, sy - 103/zoom, 712/zoom, 103/zoom, 'data/green_shadow.png', 0, 0, 0, tocolor(241, 245, 244, 200))
	    dxDrawText('Wybór spawnu', 10/zoom, sy - 40/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'left', 'bottom')
	    dxDrawText('Wybierz miejsce gdzie chcesz się zrespić', 10/zoom, sy - 40/zoom, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom), 'left', 'top')

	    dxDrawText('Wybrana lokalizacja', sx/2, sy - 65/zoom, nil, nil, tocolor(46, 117, 111, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'center', 'center')
	    dxDrawText(spawns[data.selectedSpawn].name, sx/2, sy - 27/zoom, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), 'center', 'center')

        local textWidth = dxGetTextWidth(spawns[data.selectedSpawn].name, 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom))/2 + 15/zoom
        local inRight = isMouseInPosition(sx/2 + textWidth, sy - 35/zoom, 21/zoom, 19/zoom) or (getKeyState('arrow_r') == true)
        local inLeft = isMouseInPosition(sx/2 - textWidth - 22/zoom, sy - 35/zoom, 21/zoom, 19/zoom)or (getKeyState('arrow_l') == true)
	    dxDrawImage(sx/2 + textWidth, sy - 35/zoom, 21/zoom, 19/zoom, 'data/arrowr.png', 0, 0, 0, inRight and tocolor(67, 143, 135, 255) or tocolor(255, 255, 255))
	    dxDrawImage(sx/2 - textWidth - 22/zoom, sy - 35/zoom, 21/zoom, 19/zoom, 'data/arrowl.png', 0, 0, 0, inLeft and tocolor(67, 143, 135, 255) or tocolor(255, 255, 255))

	    dxDrawText('Klawiszologia', sx - 10/zoom, sy - 40/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'right', 'bottom')
	    dxDrawText('Użyj #438F87strzałek lub kursora#ffffff aby zmieniać spawn następnie zatwiedź #438F87enterem', sx - 10/zoom, sy - 40/zoom, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
    end
end

local countDown = getTickCount()
function onClick(btn,state)
    if (btn == 'left' and state == 'down' and countDown < getTickCount()) then
        countDown = getTickCount() + 300

        if isMouseInPosition(sx/2 - btnW - btnGap/2, sy/2 + 120/zoom, btnW, btnH) and data.loginWindow == 'login' then
            local text = exports['since-gui']:getEditboxText(uiElements['edit_login'])
            local text2 = exports['since-gui']:getEditboxText(uiElements['edit_password'])
            if getElementData(localPlayer, 'player:sid') then return end
            triggerServerEvent('auth:login', resourceRoot, text, text2)
            if exports['since-gui']:isCheckboxChecked(uiElements['checkbox']) then
                saveData(text, text2)
            end 
        elseif isMouseInPosition(sx/2 + btnGap/2, sy/2 + 120/zoom, btnW, btnH) and data.loginWindow == 'login' then
            local text = exports['since-gui']:getEditboxText(uiElements['edit_login'])
            local text2 = exports['since-gui']:getEditboxText(uiElements['edit_password'])
            if getElementData(localPlayer, 'player:sid') then return end
            triggerServerEvent('auth:register', resourceRoot, text, text2)
        elseif isMouseInPosition(sx/2 + (dxGetTextWidth(spawns[data.selectedSpawn].name, 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom))/2 + 15/zoom), sy - 35/zoom, 21/zoom, 19/zoom) and data.loginWindow == 'spawn' then
            data.selectedSpawn = math.min(data.selectedSpawn + 1, #spawns)
        elseif isMouseInPosition(sx/2 - (dxGetTextWidth(spawns[data.selectedSpawn].name, 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom))/2 + 15/zoom) - 22/zoom, sy - 35/zoom, 21/zoom, 19/zoom) and data.loginWindow == 'spawn' then
            data.selectedSpawn = math.max(data.selectedSpawn - 1, 1)
        end
    end
end

local tickBlocking = getTickCount()
function onKey(button, press)
    if button == 'arrow_l' and press and data.loginWindow == 'spawn' then
        data.selectedSpawn = math.max(data.selectedSpawn - 1, 1)
    end

    if button == 'arrow_r' and press and data.loginWindow == 'spawn' then
        data.selectedSpawn = math.min(data.selectedSpawn + 1, #spawns)
    end

    if button == 'enter' and press and data.loginWindow == 'spawn' then
        if tickBlocking > getTickCount() then return end
        tickBlocking = getTickCount()+500
        local pos = {spawns[data.selectedSpawn].pos[1], spawns[data.selectedSpawn].pos[2], spawns[data.selectedSpawn].pos[3]}
        toggleUI(false)
        stopSmoothMoveCamera()

        setElementData(localPlayer,'player:spawn', pos)
        triggerServerEvent("core-spawnPlayer", resourceRoot, pos)
        showChat(true)
        showCursor(false)
        setPlayerHudComponentVisible('crosshair', true)
        setCameraTarget(localPlayer, localPlayer)

        fadeCamera(false, 0.1, 0, 0, 0)
        setTimer(fadeCameraDelayed, 1500, 1)

        stopSoundSlowly( music )

        setTimer(function()
            for i, v in pairs(textures) do
                if isElement(v) then
                    destroyElement(v)
                end
            end
        end, 1000, 1)
    end
end

function stopSoundSlowly( sound_element )
	if not isElement( sound_element ) then return false end

	local sound_timer_quant = getSoundVolume( sound_element )

	setTimer( function( )
		if not isElement( sound_element ) then return end
		local sound_volume = getSoundVolume( sound_element )
		sound_volume = ( ( sound_volume * 10 ) - ( 0.001 * 10 ) ) / 10
		setSoundVolume( sound_element, sound_volume - 0.001 )
		if sound_volume > 0 then return end
		stopSound( sound_element )
	end, 100, sound_timer_quant * 1000 )
end

function fadeCameraDelayed()
    if (isElement(localPlayer)) then
        fadeCamera(true, 0.1)
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
    eventCallback('onClientKey', root, onKey)
    showCursor(true)
    setCameraTarget(localPlayer)
    fadeCamera(true)
    setPlayerHudComponentVisible('all', false)
    setPlayerHudComponentVisible('crosshair', true)
    showChat(false)

    if visible and data.loginWindow == 'login' then
        music = playSound( 'data/music.mp3', true )
        setSoundVolume( music, 0.12 )
        
        -- NOWE POLA - cloudyMTA design
        local fieldW = 580/zoom
        local fieldH = 60/zoom
        
        uiElements['edit_password'] = exports['since-gui']:createEditbox('Hasło', sx/2 - fieldW/2, sy/2 + 20/zoom, fieldW, fieldH, {241, 245, 244}, {
            alignX = 'left',
            paddingX = 20/zoom,
            caretColor = {46, 117, 111, 200},
            caretWidth = 2,
            font = exports['since-fonts']:getFont('Inter-Regular', 14/zoom),
            backgroundColor = {25, 36, 38, 230},
            borderColor = {46, 117, 111, 150},
            borderWidth = 2,
            placeholderColor = {145, 163, 160, 200},
            passworded = true,
            radius = 8
        })

        uiElements['edit_login'] = exports['since-gui']:createEditbox('Login lub email', sx/2 - fieldW/2, sy/2 - 50/zoom, fieldW, fieldH, {241, 245, 244}, {
            alignX = 'left',
            paddingX = 20/zoom,
            caretColor = {46, 117, 111, 200},
            caretWidth = 2,
            font = exports['since-fonts']:getFont('Inter-Regular', 14/zoom),
            backgroundColor = {25, 36, 38, 230},
            borderColor = {46, 117, 111, 150},
            borderWidth = 2,
            placeholderColor = {145, 163, 160, 200},
            radius = 8
        })

        uiElements['checkbox'] = exports['since-gui']:createCheckbox('Zapamiętaj mnie', sx/2 - fieldW/2, sy/2 + 200/zoom, 24/zoom, 24/zoom, {46, 117, 111, 255}, {
            gap = 12/zoom,
            font = exports['since-fonts']:getFont('Inter-Medium', 13/zoom),
            textColor = {145, 163, 160, 200},
            hoverColor = {67, 143, 135, 255},
            textHoverColor = {241, 245, 244, 255},
            checkColor = {46, 117, 111, 255},
            backgroundColor = {25, 36, 38, 180}
        })

        local data = loadAccountData()
        if (data) then
            exports['since-gui']:setEditboxText(uiElements['edit_login'], data.login)
            exports['since-gui']:setEditboxText(uiElements['edit_password'], data.password)
            exports['since-gui']:setCheckBoxChecked(uiElements['checkbox'], true)
        end
    else
        if (uiElements['edit_password']) then
            exports['since-gui']:destroyUIElement(uiElements['edit_password'])
        end

        if (uiElements['edit_login']) then
            exports['since-gui']:destroyUIElement(uiElements['edit_login'])
        end

        if (uiElements['checkbox']) then
            exports['since-gui']:destroyUIElement(uiElements['checkbox'])
        end
    end
end

function changeWindow(window)
    data.loginWindow = window

    if window == 'spawn' then
        if (uiElements['edit_password']) then
            exports['since-gui']:destroyUIElement(uiElements['edit_password'])
        end

        if (uiElements['edit_login']) then
            exports['since-gui']:destroyUIElement(uiElements['edit_login'])
        end

        if (uiElements['checkbox']) then
            exports['since-gui']:destroyUIElement(uiElements['checkbox'])
        end
    end
end
addEvent('changeLoginWindow', true)
addEventHandler('changeLoginWindow', root, changeWindow)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:sid') then
        return
    end

    toggleUI(false)
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    if getElementData(localPlayer, 'player:sid') then
        return
    end

    toggleUI(true)
end)
getResourceName(getThisResource(), true, 648095817); if true then return end