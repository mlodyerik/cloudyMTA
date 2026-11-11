local startTick = nil
local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local timerState = false
local time = nil

addEvent('onPlayerStartDuty', true)
addEventHandler('onPlayerStartDuty', root, function(faction)
    startTick = getTickCount()
end)

addEvent('onPlayerStopDuty', true)
addEventHandler('onPlayerStopDuty', root, function(faction)
    startTick = nil
end)

addEvent('changeTimerState', true)
addEventHandler('changeTimerState', resourceRoot, function(state)
    timerState = state
end)

addEventHandler('onClientRender', root, function()
    local faction = getElementData(localPlayer, 'player:faction')

    if not faction then 
        return 
    end

    if not startTick then 
        startTick = getTickCount()
    end

    tick = getTickCount()
    time = tick - startTick
    minutes = math.floor(time/1000/60)
    seconds = math.floor(time/1000 - minutes*60)

    local factionRank = getElementData(localPlayer, 'player:rank') or 'Brak danych'
    local factionRank = data.ranks[faction][factionRank]
    local color = data.colors[faction]
    local time = string.format('%02d:%02d', minutes, seconds)
    
    dxDrawText('Służba '..faction, sx / 2 + 1, 25/zoom + 1, nil, nil, tocolor(0, 0, 0, 75), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'bottom')
    dxDrawText('Służba '..color..''..faction, sx / 2, 25/zoom, nil, nil, tocolor(255, 255, 255, 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'bottom', false, false, false, true)
    dxDrawText(factionRank, sx / 2 + 1, 26/zoom + 1, nil, nil, tocolor(0, 0, 0, 75), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'top')
    dxDrawText(color..''..factionRank, sx / 2, 26/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'top', false, false, false, true)

    dxDrawLine(sx / 2 - 50/zoom, 50/zoom, sx / 2 + 50/zoom, 50/zoom, tocolor(255, 255, 255, 100), 1)

    dxDrawText('Czas na służbie', sx / 2 + 1, 70/zoom + 1, nil, nil, tocolor(0, 0, 0, 75), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'bottom')
    dxDrawText('Czas na służbie', sx / 2, 70/zoom, nil, nil, tocolor(255, 255, 255, 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'bottom', false, false, false, true)
    dxDrawText(time, sx / 2 + 1, 70/zoom + 1, nil, nil, tocolor(0, 0, 0, 75), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'top')
    dxDrawText(time, sx / 2, 70/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'top', false, false, false, true)

    if not timerState then 
        return 
    end

    dxDrawText('PRZERWA', sx / 2 + 1, 92/zoom + 1, nil, nil, tocolor(0, 0, 0, 75), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'top')
    dxDrawText('PRZERWA', sx / 2, 92/zoom, nil, nil, tocolor(255, 55, 55, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'top', false, false, false, true)
end)
getResourceName(getThisResource(), true, 879131661); if true then return end