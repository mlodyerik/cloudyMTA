local savedData = {}
local panelState = false
local current = 'cars'
local sortsName = {
    ['cars'] = 'Samochody',
    ['planes'] = 'Samoloty',
    ['trucks'] = 'Ciężarówki',
}
local allowedSorts = {}

function renderPanel()
    dxDrawText('Aby '..(panelState and 'zamknąć' or 'włączyć')..' panel pracy LSM naciśnij F6', sx/2 + 1, sy - 40/zoom + 1, nil, nil, tocolor(0, 0, 0), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'center')
    dxDrawText('Aby #68D65E'..(panelState and 'zamknąć' or 'włączyć')..'#ffffff panel pracy LSM naciśnij #68D65EF6', sx/2, sy - 40/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'center', false, false, false, true)

    if (panelState) then
        dxDrawImage(sx/2-490/zoom/2, sy/2-420/zoom/2, 490/zoom, 420/zoom, "data/images/bg.png")
        dxDrawText('Panel zgloszen LSM', sx/2-490/zoom/2 + 15/zoom, sy/2-420/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'center')
        dxDrawText('Since Los Santos Mechs', sx/2-490/zoom/2 + 15/zoom, sy/2-420/zoom/2 + 23/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom)), nil, nil, tocolor(104, 214, 94), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'left', 'center')
        dxDrawImage(sx/2-490/zoom/2, sy/2-145/zoom, 490/zoom, 2/zoom, "data/images/line.png")

        local offset = 0
        for i,v in pairs(savedData.vehicles[current]) do
            dxDrawImage(sx/2-451/zoom/2, sy/2-420/zoom/2 + 85/zoom + offset, 451/zoom, 48/zoom, "data/images/list_bg.png")

            dxDrawText(exports['since-vehiclenames']:getVehicleName(v.model)..' #b4b4bd('..math.round(getDistanceFromPosition(v.position[1], v.position[2], v.position[3])/1000, 2, "floor")..'km)', sx/2-451/zoom/2 + 10/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 48/zoom/2 + 3/zoom - dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom))/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center', false, false, false, true)
            dxDrawText(getZoneName(v.position[1], v.position[2], v.position[3])..', Zarobek: #00FF00$'..addCommas(v.money), sx/2-451/zoom/2 + 10/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 48/zoom/2 + 3/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom))/2 - 3/zoom, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)

            local isSelected = (savedData.actual and savedData.actual.type == current and savedData.actual.current == i)
            local buttonW = dxGetTextWidth((isSelected and 'AKTUALNE' or 'JEDZ'), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom)) + 20/zoom
            
            dxDrawImage(sx/2-451/zoom/2 + 451/zoom - buttonW - 10/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 48/zoom/2 - 26/zoom/2, buttonW, 26/zoom, "data/images/button.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-451/zoom/2 + 451/zoom - buttonW - 10/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 48/zoom/2 - 26/zoom/2, buttonW, 26/zoom) and 255 or 150)))
            dxDrawText((isSelected and 'AKTUALNE' or 'JEDZ'), sx/2-451/zoom/2 + 451/zoom - buttonW - 10/zoom + buttonW/2, sy/2-420/zoom/2 + 85/zoom + offset + 48/zoom/2 - 26/zoom/2 + 26/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')

            offset = offset + 48/zoom + 5/zoom
        end

        dxDrawImage(sx/2-197/zoom/2, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom, 197/zoom, 36/zoom, "data/images/type.png")
        dxDrawText(sortsName[current], sx/2, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'center')
        
        if (#allowedSorts > 1) then
            dxDrawImage(sx/2-197/zoom/2 + 5/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2 - 28/zoom/2, 28/zoom, 28/zoom, "data/images/arrow.png", 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-197/zoom/2 + 5/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2 - 28/zoom/2, 28/zoom, 28/zoom) and 255 or 150)))
            dxDrawImage(sx/2-197/zoom/2 - 5/zoom + 197/zoom - 28/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2 - 28/zoom/2, 28/zoom, 28/zoom, "data/images/arrow.png", 180, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx/2-197/zoom/2 - 5/zoom + 197/zoom - 28/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2 - 28/zoom/2, 28/zoom, 28/zoom) and 255 or 150)))       
        end
    end
end

function clickPanel(button, state)
    if (button == 'left' and state == 'down' and panelState) then
        local offset = 0
        for i,v in pairs(savedData.vehicles[current]) do
            if (isMouseInPosition(sx/2-451/zoom/2 + 451/zoom - 56/zoom - 10/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 48/zoom/2 - 26/zoom/2, 56/zoom, 26/zoom)) then
                triggerServerEvent('onJobVehicleStart', resourceRoot, i, current)
                break
            end

            offset = offset + 48/zoom + 5/zoom
        end

        if (isMouseInPosition(sx/2-197/zoom/2 + 5/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2 - 28/zoom/2, 28/zoom, 28/zoom)) then
            local index = table.find(allowedSorts, current)
            if (index) then
                current = allowedSorts[index - 1] or allowedSorts[#allowedSorts]
            end
        end

        if (isMouseInPosition(sx/2-197/zoom/2 - 5/zoom + 197/zoom - 28/zoom, sy/2-420/zoom/2 + 85/zoom + offset + 13/zoom + 36/zoom/2 - 28/zoom/2, 28/zoom, 28/zoom)) then
            local index = table.find(allowedSorts, current)
            if (index) then
                current = allowedSorts[index + 1] or allowedSorts[1]
            end
        end
    end
end

function togglePanel()
    if (isFixing()) then
        return
    end

    panelState = not panelState
    showCursor(panelState, false)
end

function getJobData()
    return savedData
end

addEvent('onClientStartLSMJob', true)
addEventHandler('onClientStartLSMJob', resourceRoot, function (data)
    panelState = false
    addEventHandler('onClientRender', root, renderPanel)
    addEventHandler('onClientClick', root, clickPanel)
    savedData = data
    current = 'cars'
    allowedSorts = getAllowedSorts()
    timer = setTimer(function()
        exports["since-jobs"]:addPlayerJobTime('lsm', 1)
    end, 60000, 0)

    bindKey('f6', 'down', togglePanel)
end)

addEvent('onClientFinishLSMJob', true)
addEventHandler('onClientFinishLSMJob', resourceRoot, function ()
    panelState = false
    removeEventHandler('onClientRender', root, renderPanel)
    removeEventHandler('onClientClick', root, clickPanel)

    unbindKey('f6', 'down', togglePanel)
    showCursor(false)

    if (isTimer(timer)) then
        killTimer(timer)
    end
end)

addEvent('onClientUpdateLSMJob', true)
addEventHandler('onClientUpdateLSMJob', resourceRoot, function (data)
    savedData = data
end)