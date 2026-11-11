sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function formatMinutes(minutes)
    local hours = math.floor(minutes/60)
    local minutes = minutes - (hours*60)
    return string.format('%02d:%02d', hours, minutes)
end

function render()
    dxDrawText('Duty frakcji '..getFactionData(getElementData(localPlayer, 'player:faction')).colors.hex..''..getElementData(localPlayer, 'player:faction'), sx/2, 30/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom), 'center', 'center', false, false, false, true)
    dxDrawText(getFactionData(getElementData(localPlayer, 'player:faction')).ranks[getElementData(localPlayer, 'player:rank')], sx/2, 30/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom)), nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center', false, false, false, true)
    dxDrawText('Przepracowany czas: '..formatMinutes(getElementData(localPlayer, 'player:factionTime')), sx/2, 30/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom)) + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)), nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center', false, false, false, true)
end

addEvent('onClientStartFaction', true)
addEventHandler('onClientStartFaction', resourceRoot, function()
    addEventHandler('onClientRender', root, render)
end)

addEvent('onClientStopFaction', true)
addEventHandler('onClientStopFaction', resourceRoot, function()
    removeEventHandler('onClientRender', root, render)
end)