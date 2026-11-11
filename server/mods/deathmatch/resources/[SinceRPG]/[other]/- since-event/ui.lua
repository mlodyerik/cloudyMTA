local eventUiY = 350/zoom
local background = dxCreateTexture('data/background.png', 'argb', true, 'clamp')
local eventText = false
local fontHeight = 0

function renderEventUI()
    if not eventText then return end

	-- dxDrawImage(sx - 600/zoom, eventUiY, 590/zoom, 135/zoom + #eventText * fontHeight, background)
	-- dxDrawText('Event fabularny', sx - 30/zoom, eventUiY + 50/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Bold', 23/zoom), 'right', 'bottom')
	-- dxDrawText('Wielkanoc', sx - 30/zoom, eventUiY + 50/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, getFigmaFont('Inter-Medium', 16/zoom), 'right', 'top')
	-- dxDrawText('Aktualny cel', sx - 30/zoom, eventUiY + 120/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Bold', 23/zoom), 'right', 'bottom')
	
    -- for k, v in ipairs(eventText) do
    --     dxDrawText(v, sx - 30/zoom, eventUiY + 120/zoom + (k-1) * fontHeight, nil, nil, tocolor(103, 213, 94, 255), 1, getFigmaFont('Inter-Medium', 16/zoom), 'right', 'top')
    -- end
end

function setEventText(text)
    if not text then
        eventText = false
        toggleEventUI(false)
        return
    end
    
    eventText = wordWrap(text, 500/zoom, 1, getFigmaFont('Inter-Medium', 16/zoom), false)
    fontHeight = dxGetFontHeight(1, getFigmaFont('Inter-Medium', 16/zoom))
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