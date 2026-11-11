local sx, sy = guiGetScreenSize()
local zoom = sx / 1920  
local isDiscord = false

function isMouseIn(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local cursorx, cursory = mx * sx, my * sy

        if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
            return true
        end
    end

    return false
end

function renderInfo()
    if getElementData(localPlayer, 'player:spawn') then
        if isDiscord then
            dxDrawText('Discord', sx / 2 + 1, 35/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
            dxDrawText('Discord', sx / 2, 35/zoom, nil, nil, tocolor(143, 186, 235, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')

            dxDrawText('Twoje konto wymaga połączenia z naszym serwerem discord', sx / 2 + 1, 35/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
            dxDrawText('Twoje konto wymaga połączenia z naszym serwerem discord', sx / 2, 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
            
            local textWidth = dxGetTextWidth('Skopiuj link do discorda', 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom))
            local isIn = isMouseIn(sx / 2 - textWidth / 2 - 10/zoom, 60/zoom, textWidth + 20/zoom, 20/zoom)

            dxDrawRectangle(sx / 2 - textWidth / 2 - 10/zoom, 60/zoom, textWidth + 20/zoom, 20/zoom, tocolor(143, 186, 235, isIn and 155 or 75))
            
            dxDrawText('F3 - Kursor', sx / 2, 85/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7/zoom), 'center', 'top')
            
            if isIn and getKeyState('mouse1') then
                dxDrawText('Skopiowano', sx / 2, 70/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'center', 'center')
                setClipboard('https://discord.gg/QMJNMVFKDP')
            else
                dxDrawText('Skopiuj link do discorda', sx / 2, 70/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'center', 'center')
            end
        end
    end
end

function reloadDiscordPresence()
    setDiscordRichPresenceState('» '..getPlayerName(localPlayer)..' [ID: '..getElementData(localPlayer, 'id')..']')

    local x, y, z = getElementPosition(localPlayer)
    local location = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)

    setDiscordRichPresenceDetails('» '..location)

    setDiscordRichPresenceButton(1, "Dołącz do gry", "mtasa://146.59.4.27:20236")
    setDiscordRichPresenceButton(2, "Dołącz na discorda", "https://discord.gg/sincerpg-play-with-us-1143611641393586356")

    setDiscordRichPresenceAsset("logo", "SinceRPG")
    setDiscordRichPresenceSmallAsset("my_small_logo", "SinceRPG")
    setDiscordRichPresencePartySize(1, #getElementsByType('player'))
end

function reloadPresenceTimer()
    if getElementData(localPlayer, 'player:spawn') then
        reloadDiscordPresence()
        
        isDiscord = getElementData(localPlayer, 'player:discord')

        if not isDiscord then
            addEventHandler('onClientRender', root, renderInfo)
        end
    else
        setDiscordRichPresenceState('')
        setDiscordRichPresenceDetails('Loguje się...')

        setDiscordRichPresenceButton(1, "Dołącz do gry", "mtasa://146.59.4.27:20236")
        setDiscordRichPresenceButton(2, "Dołącz na discorda", "https://discord.gg/sincerpg-play-with-us-1143611641393586356")
        
        setDiscordRichPresenceAsset("logo", "SinceRPG")
        setDiscordRichPresenceSmallAsset("my_small_logo", "SinceRPG")
        setDiscordRichPresencePartySize(1, #getElementsByType('player'))
    end
end
setTimer(reloadPresenceTimer, 10000, 0)

addEventHandler('onClientResourceStart', resourceRoot, function()
    presenceID = "1170836523961303081"
    createID = setDiscordApplicationID(presenceID)
    reloadDiscordPresence()
end)