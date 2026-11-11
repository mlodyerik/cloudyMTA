Reports.renderReport = function ()
    dxDrawImage(sx/2-386/zoom/2, sy/2-520/zoom/2, 386/zoom, 520/zoom, "data/images/report-background.png")
    dxDrawText('Zawiadamianie frakcji', sx/2-386/zoom/2 + 15/zoom, sy/2-520/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'center')

    dxDrawImage(sx/2-386/zoom/2 + 386/zoom - 20/zoom - 15/zoom, sy/2-520/zoom/2 + 15/zoom, 20/zoom, 20/zoom, "data/images/close.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-386/zoom/2 + 386/zoom - 20/zoom - 15/zoom, sy/2-520/zoom/2 + 15/zoom, 20/zoom, 20/zoom) and 255 or 150)))

    dxDrawImage(sx/2-226/zoom/2, sy/2+200/zoom, 226/zoom, 45/zoom, "data/images/confirm_button.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-226/zoom/2, sy/2+200/zoom, 226/zoom, 45/zoom) and 255 or 150)))
    dxDrawText('Wyślij zgłoszenie', sx/2-226/zoom/2 + 226/zoom/2, sy/2+200/zoom + 45/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
end

Reports.onClickReport = function ()
    if (isMouseInPosition(sx/2-226/zoom/2, sy/2+200/zoom, 226/zoom, 45/zoom)) then
        local faction = exports['since-gridlist']:getSelectedItem(Reports.elements[1])
        local text = exports['since-memo']:dxGetMemoText('report')
       
        if (faction == "Brak") then
            return exports['since-notifications']:sendNotification('error', 'Nie wybrałeś frakcji.')
        end

        if (text == "") then
            return exports['since-notifications']:sendNotification('error', 'Nie wprowadziłeś treści zgłoszenia.')
        end

        if (#text < 10) then
            return exports['since-notifications']:sendNotification('error', 'Treść zgłoszenia musi zawierać minimum 10 znaków.')
        end

        triggerServerEvent('since-factions-reports:sendReport', resourceRoot, faction, text)
    end
end