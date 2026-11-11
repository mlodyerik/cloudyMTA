local function dxDrawToolTip(x, y, w, h, text)
    if (isMouseInPosition(x, y, w, h)) then
        local cx, cy = getCursorPosition()
        cx = cx * sx
        cy = cy * sy

        dxDrawRectangle(cx + 10/zoom, cy + 10/zoom, dxGetTextWidth(text, 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom)) + 10/zoom, 20/zoom, tocolor(0, 0, 0, 100), true)
        dxDrawText(text, cx + 15/zoom, cy + 20/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, true)
    end
end

Reports.renderList = function ()
    dxDrawImage(sx/2-611/zoom/2, sy/2-310/zoom/2, 611/zoom, 310/zoom, "data/images/list-background.png")
    dxDrawText('Zawiadamianie frakcji', sx/2-611/zoom/2 + 15/zoom, sy/2-310/zoom/2 + 20/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'center')

    
    local offset = 0
    for i, v in pairs(Reports.list) do
        if i >= k and i <= n then
            dxDrawImage(sx/2-590/zoom/2 - 3/zoom, sy/2-120/zoom + offset, 590/zoom, 48/zoom, "data/images/element-bg.png")
            dxDrawText('Osoba zgłaszająca: #80F177'..getPlayerName(v.player), sx/2-590/zoom/2 + 8/zoom, sy/2-120/zoom + 15/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center', false, false, false, true)
            dxDrawText('Treść zgłoszenia: #80F177'..v.text, sx/2-590/zoom/2 + 8/zoom, sy/2-120/zoom + 35/zoom + offset, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)

            dxDrawImage(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom, "data/images/accept.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom) and 255 or 150)))
            dxDrawToolTip(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom, 'Zaakceptuj zgłoszenie')
            dxDrawImage(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom, "data/images/no.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom) and 255 or 150)))
            dxDrawToolTip(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom, 'Odrzuć zgłoszenie')

            offset = offset + 48/zoom + 5/zoom
        end
    end

    dxDrawScrollbar(Reports.list, sx/2-590/zoom/2 + 590/zoom + 2/zoom, sy/2-120/zoom, 3/zoom, 260/zoom, m, k, 255)
end

Reports.onClickList = function ()
    local offset = 0

    for i, v in pairs(Reports.list) do
        if i >= k and i <= n then
            if (isMouseInPosition(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom)) then
                triggerServerEvent('since-factions-reports:acceptReport', resourceRoot, i)
            end

            if (isMouseInPosition(sx/2-590/zoom/2 - 3/zoom + 590/zoom - 30/zoom - 8/zoom - 30/zoom - 8/zoom, sy/2-120/zoom + offset + 48/zoom/2 - 30/zoom/2, 30/zoom, 30/zoom)) then
                triggerServerEvent('since-factions-reports:rejectReport', resourceRoot, i)
            end

            offset = offset + 48/zoom + 5/zoom
        end
    end
end