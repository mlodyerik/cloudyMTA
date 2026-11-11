  

local activeTab = 1
local toggled = false
local alpha = 0

function renderUI()
    -- cloudyMTA new design - dark background with teal accents
    exports['since-blur']:dxDrawBlur(sx/2 - 471/zoom, sy/2 - 250/zoom, 942/zoom, 500/zoom, textures['mask'], 255*alpha)
	-- Dark background panel (#192426)
	dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 250/zoom, 942/zoom, 500/zoom, tocolor(25, 36, 38, 255*alpha))

    -- Vertical divider line
    dxDrawRectangle(sx / 2 - 224/zoom, sy / 2 - 250/zoom, 1, 500/zoom, tocolor(67, 143, 135, 65*alpha))
    -- Horizontal divider line under logo
    dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 135/zoom - 1, 247/zoom, 1, tocolor(67, 143, 135, 65*alpha))
    
    -- cloudyMTA logo - centered in left panel
    dxDrawImage(sx/2 - 455/zoom, sy/2 - 235/zoom, 218/zoom, 82/zoom, 'data/cloudyMTA_logo.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    -- Teal header accent bar
    dxDrawRectangle(sx/2 - 223/zoom, sy/2 - 250/zoom, 694/zoom, 3/zoom, tocolor(46, 117, 111, 255*alpha))
    
    local offset = 0
    for k, v in ipairs(tabs) do
        local isMouse = isMouseInPosition(sx/2 - 471/zoom, sy/2 - 135/zoom + offset, 247/zoom, 45/zoom) and 15*alpha or 0
        local tabColor = (activeTab == k and tocolor(46, 117, 111, 25*alpha + isMouse) or tocolor(145, 163, 160, 25*alpha + isMouse))
        local iconColor = (activeTab == k and tocolor(255, 255, 255, 225*alpha + isMouse) or tocolor(255, 255, 255, 175*alpha + isMouse))

        dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 135/zoom + offset, 247/zoom, 45/zoom, tabColor)
        dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 89/zoom - 1 + offset, 247/zoom, 1, tocolor(255, 255, 255, 65*alpha))
        dxDrawImage(sx/2 - 459/zoom, sy/2 - 126/zoom + offset, 26/zoom, 26/zoom, v.icon, 0, 0, 0, iconColor)
        dxDrawText(v.name, sx/2 - 422/zoom, sy/2 - 113/zoom + offset, nil, nil, iconColor, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'center', false, false, false, true)

        offset = offset + 45/zoom + 1
    end

    for k, v in pairs(tabs) do
        if k == activeTab then
            v.toRender(alpha)

            dxDrawImage(sx/2 - 211/zoom, sy/2 - 239/zoom, 26/zoom, 26/zoom, v.icon, 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText(v.name, sx/2 - 178/zoom, sy/2 - 222/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 12/zoom), 'left', 'bottom')
	        dxDrawText(v.desc, sx/2 - 178/zoom, sy/2 - 224/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'top')
        end
    end
end

function changeTab(k, v)
    activeTab = k
end

function onClick(btn,state)
    if (btn == 'left' and state == 'down') then
        local offset = 0
        for k, v in pairs(tabs) do
            local isMouse = isMouseInPosition(sx/2 - 471/zoom, sy/2 - 135/zoom + offset, 247/zoom, 45/zoom)

            if isMouse then
                if v.onOpen and v.onClose then
                    for kk, vv in pairs(tabs) do
                        if kk == activeTab then
                            vv.onClose()
                        end
                    end

                    v.onOpen()
                end

                changeTab(k, v)
            end

            offset = offset + 45/zoom + 1
        end
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    if visible == false then
        animate(1, 0, 'InOutQuad', 150, function (c)
            alpha = c
        end, function()
            eventCallback('onClientRender', root, renderUI)
            eventCallback('onClientClick', root, onClick)
            showCursor(visible, false)
        end)

        for k, v in pairs(tabs) do
            if v.onClose then
                v.onClose()
            end
        end
    else
        eventCallback('onClientRender', root, renderUI)
        eventCallback('onClientClick', root, onClick)
        showCursor(visible, false)

        animate(alpha, 1, 'InOutQuad', 150, function (c)
            alpha = c
        end)

        for k, v in pairs(tabs) do
            if k == activeTab and v.onOpen and v.onClose then
                v.onOpen()
            end
        end
    end
end

local tick = getTickCount()

bindKey('F1', 'down', function()
    if not getElementData(localPlayer,'player:spawn') then return end
    if not toggled then
        if getTickCount() - tick < 500 then return end
    end

    toggled = not toggled
    toggleUI(toggled)
    tick = getTickCount()
end)

bindKey("mouse_wheel_down", "both", function()
    if activeTab == 2 then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if activeTab == 2 then
        scrollDown()
    end
end)

function scrollDown()
    if commandsScroll.n == commandsScroll.m then return end
    commandsScroll.k = commandsScroll.k-1
    commandsScroll.n = commandsScroll.n-1
end

function scrollUp()
    if commandsScroll.n >= #commands then return end
    commandsScroll.k = commandsScroll.k+1
    commandsScroll.n = commandsScroll.n+1
end

getResourceName(getThisResource(), true, 901474852); if true then return end