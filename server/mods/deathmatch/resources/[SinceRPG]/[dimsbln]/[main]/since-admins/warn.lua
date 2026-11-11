local reason = ''
local admin = ''

local function renderUI()
	dxDrawImage(0, 0, sx, sy, 'data/overlay.png', 0, 0, 0, tocolor(241, 245, 244, 200), true)

	dxDrawText('OTRZYMAŁEŚ OSTRZEŻENIE!', sx/2 + 3, sy/2 - 47/zoom + 3, nil, nil, tocolor(0, 0, 0, 100), 1, getFigmaFont('Inter-Black', 54/zoom), 'center', 'bottom', false, false, true, true)
	dxDrawText('Powód: ' .. reason .. '\nAdministrator: ' .. admin, sx/2 + 2, sy/2 + 36/zoom + 2, nil, nil, tocolor(0, 0, 0, 100), 1, getFigmaFont('Inter-Bold', 23.333/zoom), 'center', 'center', false, false, true, true)
	dxDrawText('Nie stosowanie się do ostrzeżeń może skutkować kickiem lub banem!', sx/2 + 2, sy/2 + 113/zoom + 2, nil, nil, tocolor(0, 0, 0, 100), 1, getFigmaFont('Inter-Bold', 16.666/zoom), 'center', 'top', false, false, true, true)

	dxDrawText('OTRZYMAŁEŚ OSTRZEŻENIE!', sx/2, sy/2 - 47/zoom, nil, nil, tocolor(255, 50, 50, 225), 1, getFigmaFont('Inter-Black', 54/zoom), 'center', 'bottom', false, false, true, true)
	dxDrawText('Powód: #ff5c5c' .. reason .. '#ffffff\nAdministrator: #ff5c5c' .. admin, sx/2, sy/2 + 36/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, getFigmaFont('Inter-Bold', 23.333/zoom), 'center', 'center', false, false, true, true)
	dxDrawText('Nie stosowanie się do ostrzeżeń może skutkować kickiem lub banem!', sx/2, sy/2 + 113/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, getFigmaFont('Inter-Bold', 16.666/zoom), 'center', 'top', false, false, true, true)

	dxDrawImage(sx/2 - 594/zoom + 2, sy/2 - 54/zoom + 2, 1187/zoom, 5/zoom, 'data/bar.png', 0, 0, 0, tocolor(0, 0, 0), true)
	dxDrawImage(sx/2 - 594/zoom, sy/2 - 54/zoom, 1187/zoom, 5/zoom, 'data/bar.png', 0, 0, 0, tocolor(255, 50, 50), true)
end

local function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI, true, 'low-99999')
end

function showWarn(adminText, reasonText)
    reason = reasonText
    admin = adminText

    toggleUI(true)
    playSound('data/warn.mp3')

    setTimer(toggleUI, 10000, 1, false)
end

addEvent('onClientShowWarn', true)
addEventHandler('onClientShowWarn', resourceRoot, showWarn)
getResourceName(getThisResource(), true, 537985620); if true then return end