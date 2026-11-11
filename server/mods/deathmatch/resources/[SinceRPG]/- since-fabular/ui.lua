local eventUiY = 250/zoom
local background = dxCreateTexture('data/background.png', 'argb', true, 'clamp')
local eventText = false
local fontHeight = 0

function renderEventUI()
    if not eventText then return end

    dxDrawImage(sx - 500/zoom, eventUiY - 48/zoom, 590/zoom, 70/zoom + #eventText * fontHeight, background, 0, 0, 0, tocolor(0, 0, 0, 255))

	dxDrawText('Wydarzenie fabularne', sx - 20/zoom, eventUiY, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
	
    for k, v in ipairs(eventText) do
        dxDrawText(v, sx - 20/zoom, eventUiY + (k-1) * fontHeight, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
    end
end

function setEventText(text)
    if not text then
        eventText = false
        toggleEventUI(false)
        return
    end
    
    eventText = wordWrap(text, 500/zoom, 1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom), false)
    fontHeight = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Regular', 12/zoom))
    toggleEventUI(true)
end

function toggleEventUI(visible)
    if isUiVisible == visible then return end
    
    local eventCallback = visible and addEventHandler or removeEventHandler
    isUiVisible = visible

    eventCallback('onClientRender', root, renderEventUI)
end

function setEventUiHidden(hidden)
    isUiHidden = hidden
end