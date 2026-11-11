local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function render()
    local pulseAlpha = 255 * (math.abs(getTickCount() % 2000 - 1000) / 1000)
    dxDrawText('NOWY DISCORD!', sx/2, 20/zoom, nil, nil, tocolor(255, 50, 50, pulseAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), 'center', 'center', false, false, true)
    dxDrawText('Dołącz, by odebrać Elegy z wyjątkowym PJ, tylko dla członków nowego serwera.\nINFORMACJA ZNIKNIE PO DOŁACZENIU NA NOWEGO DISCORDA I ZROBIENIU RC\n\nABY SKOPIOWAĆ LINK DO NOWEGO DISCORDA KLIKNIJ F4', sx/2, 20/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom))/2, nil, nil, tocolor(255, 0, 0, pulseAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), 'center', 'top', false, false, true)
end

addEvent('toggleDiscordInformation', true)
addEventHandler('toggleDiscordInformation', resourceRoot, function()
    addEventHandler("onClientRender", root, render)

    bindKey("f4", "down", function()
        setClipboard("https://discord.gg/JSXJVnXyzV")
        exports['since-notifications']:sendNotification('success', 'Link do nowego discorda został skopiowany do schowka.')
    end)

    outputChatBox('    ')
    outputChatBox('    ')
    outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', 255, 0, 0, true)
    outputChatBox('#68D65E★#ffffff Dołącz, by odebrać Elegy z wyjątkowym PJ, tylko dla członków nowego serwera. ★', 255, 0, 0, true)
    outputChatBox('    ')
    outputChatBox('    ')
end)

triggerServerEvent('checkDiscordInformation', resourceRoot)