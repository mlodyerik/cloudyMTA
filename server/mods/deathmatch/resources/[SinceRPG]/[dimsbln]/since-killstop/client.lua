sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

top = {}
top.users = {}
top.clientKills = 0

showing = true

-- function checkIfPlayerIsTop1(player)
--     if (top.users[1].uid == getElementData(player, 'player:sid')) then
--         return true
--     end
--     return false
-- end

function renderGui()
    if not (getElementData(localPlayer, 'player:strefa')) then return end
    if not showing then return end
    dxDrawImage(sx-280/zoom, sy/2-420/zoom/2, 266/zoom, 440/zoom, "data/background.png")
    dxDrawImage(sx-280/zoom, sy/2-294/zoom/2, 266/zoom, 1/zoom, "data/line.png")
    dxDrawText('Top #9', sx-280/zoom + 12/zoom, sy/2-420/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'center')
    dxDrawText('Topka kili SinceRPG', sx-280/zoom + 12/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom)), nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center')

    dxDrawText('Aktualnie posiadasz\n#68D65E ' ..top.clientKills .. '#ffffff Zabójstw', sx-140/zoom, sy/2+470/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom)), nil, nil, tocolor(255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center', false, false, false, true )
    dxDrawText('Kliknij #68D65EP#FFFFFF aby schować', sx-140/zoom, sy/2+400/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom)), nil, nil, tocolor(255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center', false, false, false, true )
    local offset = 0
    for i,v in ipairs(top.users) do
        dxDrawImage(sx-280/zoom + 12/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom)) + 25/zoom + offset, 35/zoom, 35/zoom, exports['since-avatars']:getPlayerAvatar(v.uid))
        if (v.username == 'tworix') then
            dxDrawText(v.username..'#F9A825(Krul)', sx-280/zoom + 12/zoom + 40/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) + 37/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center', false, false, false, true )
        elseif (i == 1) then
            dxDrawText('#F9A825' ..v.username, sx-280/zoom + 12/zoom + 40/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) + 37/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center', false, false, false, true )
        else
            dxDrawText(v.username, sx-280/zoom + 12/zoom + 40/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) + 37/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center')
        end
        dxDrawText('Kile: #68D65E'..v.total, sx-280/zoom + 12/zoom + 40/zoom, sy/2-420/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom)) + 52/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center', false, false, false, true )
        offset = offset + 40/zoom
    end

end

bindKey('P', 'down', function()
    showing = not showing
end)

setTimer(function()
    triggerServerEvent('getPlayers', resourceRoot)
    triggerServerEvent('getClientKilss', resourceRoot, localPlayer)
    iprint('Top updated')
end, 60*1000, 0)

addEvent("kills.top.result", true)
addEventHandler("kills.top.result", resourceRoot, function(result)
    top.users = result
end)

addEvent("onClientKills", true)
addEventHandler("onClientKills", resourceRoot, function(result)
    top.clientKills = (result[1] and result[1].total or 0)
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    triggerServerEvent('getPlayers', resourceRoot)
    triggerServerEvent('getClientKilss', resourceRoot, localPlayer)
end)

addEventHandler('onClientRender', root, renderGui)