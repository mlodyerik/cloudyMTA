  

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
        
        dxDrawImage(0, 0, sx - 300/zoom, sy, 'data/background.png')
        -- exports['since-blur']:dxDrawBlur(0, 0, sx, sy)
        -- dxDrawImage(0, 0, sx, sy, 'data/background.png')
        
        dxDrawImage(0, 0, 1085/zoom, 854/zoom, 'data/glow.png')
        dxDrawImage(66/zoom + 514/zoom/2 - 374/zoom/2, sy/2-410/zoom, 374/zoom, 98/zoom, 'data/logo.png')
        
        -- cloudyMTA branding colors
        local cloudyColor = {46, 117, 111} -- #2E756F
        
        local avatar = exports['since-avatars']:getPlayerCircleAvatar(findPlayerInTable(savedNick), textures.mask)
        dxDrawImage(66/zoom + 514/zoom/2 - 147/zoom/2, sy/2-310/zoom, 147/zoom, 147/zoom, avatar and avatar or noAv, 0, 0, 0, avatar and tocolor(255, 255, 255) or tocolor(255, 255, 255, 255))
        dxDrawImage(66/zoom + 514/zoom/2 - 147/zoom/2, sy/2-310/zoom, 150/zoom, 150/zoom, textures.border)

        if findPlayerInTable(savedNick) then
            dxDrawText('Zaloguj się jako '..savedNick, 66/zoom + 514/zoom/2 + 1, sy/2-135/zoom + 1, nil, nil, tocolor(0, 0, 0, 175), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
            dxDrawText('Zaloguj się jako #2E756F'..savedNick, 66/zoom + 514/zoom/2, sy/2-135/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center', false, false, false, true)    
        end
    
        -- dxDrawImage(66/zoom + 514/zoom/2 - 356/zoom, sy - 103/zoom, 712/zoom, 103/zoom, 'data/green_shadow.png')
        -- dxDrawText('Na serwerze znajduje się '..#getElementsByType('player')..' graczy', 66/zoom + 514/zoom/2 + 1, sy - 25/zoom + 1, nil, nil, tocolor(0, 0, 0, 175), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
        -- dxDrawText('Na serwerze znajduje się #438F87'..#getElementsByType('player')..'#ffffff graczy', 66/zoom + 514/zoom/2, sy - 25/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center', false, false, false, true)
    
        local loginIn = isMouseInPosition(66/zoom, sy/2 - 99/zoom + 235/zoom, 245/zoom, 52/zoom)
        dxDrawImage(66/zoom, sy/2 - 99/zoom + 235/zoom, 245/zoom, 52/zoom, 'data/login_button.png', 0, 0, 0, tocolor(255, 255, 255, loginIn and 175 or 255))
        dxDrawText('Wejdź do gry', 66/zoom + 245/zoom/2, sy/2 - 99/zoom + 235/zoom + 52/zoom/2, nil, nil, tocolor(255, 255, 255, loginIn and 175 or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center')
    
        local registerIn = isMouseInPosition(66/zoom + 245/zoom + 25/zoom, sy/2 - 99/zoom + 235/zoom, 245/zoom, 52/zoom)
        dxDrawImage(66/zoom + 245/zoom + 25/zoom, sy/2 - 99/zoom + 235/zoom, 245/zoom, 52/zoom, 'data/register_button.png', 0, 0, 0, tocolor(255, 255, 255, registerIn and 175 or 255))
        dxDrawText('Stwórz konto', 66/zoom + 245/zoom + 25/zoom + 245/zoom/2, sy/2 - 99/zoom + 235/zoom + 52/zoom/2, nil, nil, tocolor(255, 255, 255, registerIn and 175 or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center')
    
        dxDrawImage(66/zoom + 4/zoom, sy/2 - 99/zoom + 4/zoom, 66/zoom, 66/zoom, 'data/editbox_icon.png')
        dxDrawImage(66/zoom + 4/zoom + 66/zoom/2 - 30/zoom/2, sy/2 - 80/zoom, 30/zoom, 36/zoom, 'data/username.png')
        dxDrawImage(66/zoom + 4/zoom, sy/2 - 19/zoom + 4/zoom, 66/zoom, 66/zoom, 'data/editbox_icon.png')
        dxDrawImage(66/zoom + 4/zoom + 66/zoom/2 - 30/zoom/2, sy/2 + 3/zoom, 30/zoom, 30/zoom, 'data/password.png')
        
    
        dxDrawText('Zapomniałeś hasła?', 66/zoom + 514/zoom/2, sy/2 + 243/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
        dxDrawText('Utwórz ticket na naszym discordzie i poczekaj aż ktoś się tym zajmie!', 66/zoom + 514/zoom/2, sy/2 + 244/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Regular', 11/zoom), 'center', 'top')
    
        local copyIn = isMouseInPosition(66/zoom + 514/zoom/2 - 66/zoom, sy/2 + 275/zoom, 132/zoom, 32/zoom)
        dxDrawImage(66/zoom + 514/zoom/2 - 66/zoom, sy/2 + 275/zoom, 132/zoom, 32/zoom, 'data/button_copy.png', 0, 0, 0, tocolor(255, 255, 255, copyIn and 175 or 255))
        dxDrawText('Skopiuj link', 66/zoom + 514/zoom/2, sy/2 + 292/zoom, nil, nil, tocolor(255, 255, 255, copyIn and 175 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')
    elseif data.loginWindow == 'spawn' then
	    dxDrawImage(0, 0, sx, sy, 'data/shadow.png')
        --dxDrawImage(sx / 2 - 356/zoom, sy - 103/zoom, 712/zoom, 103/zoom, 'data/green_shadow.png', 0, 0, 0, tocolor(255, 255, 255, 200))
	    dxDrawText('Wybór spawnu', 10/zoom, sy - 40/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'left', 'bottom')
	    dxDrawText('Wybierz miejsce gdzie chcesz się zrespić', 10/zoom, sy - 40/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom), 'left', 'top')

	    dxDrawText('Wybrana lokalizacja', sx/2, sy - 65/zoom, nil, nil, tocolor(46, 117, 111, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'center', 'center')
	    dxDrawText(spawns[data.selectedSpawn].name, sx/2, sy - 27/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), 'center', 'center')

        local textWidth = dxGetTextWidth(spawns[data.selectedSpawn].name, 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom))/2 + 15/zoom
        local inRight = isMouseInPosition(sx/2 + textWidth, sy - 35/zoom, 21/zoom, 19/zoom) or (getKeyState('arrow_r') == true)
        local inLeft = isMouseInPosition(sx/2 - textWidth - 22/zoom, sy - 35/zoom, 21/zoom, 19/zoom)or (getKeyState('arrow_l') == true)
	    dxDrawImage(sx/2 + textWidth, sy - 35/zoom, 21/zoom, 19/zoom, 'data/arrowr.png', 0, 0, 0, inRight and tocolor(67, 143, 135, 255) or tocolor(255, 255, 255))
	    dxDrawImage(sx/2 - textWidth - 22/zoom, sy - 35/zoom, 21/zoom, 19/zoom, 'data/arrowl.png', 0, 0, 0, inLeft and tocolor(67, 143, 135, 255) or tocolor(255, 255, 255))

	    dxDrawText('Klawiszologia', sx - 10/zoom, sy - 40/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'right', 'bottom')
	    dxDrawText('Użyj #438F87strzałek lub kursora#ffffff aby zmieniać spawn następnie zatwiedź #438F87enterem', sx - 10/zoom, sy - 40/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
    end
end

local countDown = getTickCount()
function onClick(btn,state)
    if (btn == 'left' and state == 'down' and countDown < getTickCount()) then
        countDown = getTickCount() + 300

        if isMouseInPosition(66/zoom, sy/2 - 99/zoom + 235/zoom, 245/zoom, 52/zoom) and data.loginWindow == 'login' then
            local text = exports['since-gui']:getEditboxText(uiElements['edit_login'])
            local text2 = exports['since-gui']:getEditboxText(uiElements['edit_password'])
            if getElementData(localPlayer, 'player:sid') then return end
            triggerServerEvent('auth:login', resourceRoot, text, text2)
            if exports['since-gui']:isCheckboxChecked(uiElements['checkbox']) then
                saveData(text, text2)
            end 
        elseif isMouseInPosition(66/zoom + 245/zoom + 25/zoom, sy/2 - 99/zoom + 235/zoom, 245/zoom, 52/zoom) and data.loginWindow == 'login' then
            local text = exports['since-gui']:getEditboxText(uiElements['edit_login'])
            local text2 = exports['since-gui']:getEditboxText(uiElements['edit_password'])
            if getElementData(localPlayer, 'player:sid') then return end
            triggerServerEvent('auth:register', resourceRoot, text, text2)
        elseif isMouseInPosition(66/zoom + 514/zoom/2 - 66/zoom, sy/2 + 275/zoom, 132/zoom, 32/zoom) and data.loginWindow == 'login' then
            setClipboard(data.discordLink)
            exports['since-notifications']:sendNotification('success', 'Link skopiowany do schowka')
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
        uiElements['edit_password'] = exports['since-gui']:createEditbox('Wprowadź hasło...', 66/zoom, sy/2 - 19/zoom, 514/zoom, 74/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 85/zoom,
            caretColor = {255, 255, 255, 55},
            caretWidth = 2,
            font = exports['since-fonts']:getFont('Inter-Regular', 13/zoom),
            image = textures['editbox'],
            placeholderColor = {255, 255, 255},
            specialCharacters = '.*[_].*',
            passworded = true
        })

        uiElements['edit_login'] = exports['since-gui']:createEditbox('Wprowadź login...', 66/zoom, sy/2 - 99/zoom, 514/zoom, 74/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 85/zoom,
            caretColor = {255, 255, 255, 55},
            caretWidth = 2,
            font = exports['since-fonts']:getFont('Inter-Regular', 13/zoom),
            image = textures['editbox'],
            placeholderColor = {255, 255, 255},
            specialCharacters = '.*[_].*',
            passworded = false
        })

        uiElements['checkbox'] = exports['since-gui']:createCheckbox('Zapamiętaj mnie', 66/zoom, sy/2 + 65/zoom, 64/zoom, 64/zoom, {255, 255, 255, 255}, {
            gap = 2/zoom,
            font = exports['since-fonts']:getFont('Inter-Medium', 14/zoom),
            textColor = {255, 255, 255, 200},
            hoverColor = {255, 255, 255, 155},
            textHoverColor = {255, 255, 255, 155},
            image = textures['checkbox'],
            activeImage = textures['checkbox_active']
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