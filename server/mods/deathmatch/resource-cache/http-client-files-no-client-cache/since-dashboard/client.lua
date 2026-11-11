local toggled = false
local alpha = 0

function renderUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 471/zoom, sy/2 - 250/zoom, 942/zoom, 500/zoom, textures['mask'], 255*alpha)
	dxDrawImage(sx/2 - 471/zoom, sy/2 - 250/zoom, 942/zoom, 500/zoom, 'data/background.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))

    dxDrawRectangle(sx / 2 - 224/zoom, sy / 2 - 250/zoom, 1, 500/zoom, tocolor(200, 200, 200, 65*alpha))
    dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 150/zoom - 1, 247/zoom, 1, tocolor(255, 255, 255, 65*alpha))

    local rankColor = exports['since-core']:getRankColor(getElementData(localPlayer, 'player:admin'), getElementData(localPlayer, 'player:diamond'))
    local rankName = exports['since-core']:getRankName(getElementData(localPlayer, 'player:admin'), getElementData(localPlayer, 'player:diamond'))
    
    dxDrawImage(sx/2 - 460/zoom, sy/2 - 232/zoom, 64/zoom, 64/zoom, exports['since-avatars']:getPlayerAvatar(getElementData(localPlayer,'player:sid')), 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    dxDrawText(getPlayerName(localPlayer), sx/2 - 390/zoom, sy/2 - 206/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), 'left', 'bottom')
    local textWidth = dxGetTextWidth(getPlayerName(localPlayer), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom))
    local idText = (getElementData(localPlayer, 'id') or 0)
    local idWidth = dxGetTextWidth(idText, 1, exports['since-fonts']:getFont('Inter-ExtraBold', 12/zoom)) + 4/zoom
    dxDrawRoundedRectangle(sx/2 - 388/zoom + textWidth, sy/2 - 228/zoom, idWidth, 21/zoom, 4, tocolor(125, 255, 125, 75*alpha))
    dxDrawText(idText, sx/2 - 385/zoom + textWidth, sy/2 - 208/zoom, nil, nil, tocolor(125, 255, 125, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 12/zoom), 'left', 'bottom')


    dxDrawText(rankName, sx/2 - 390/zoom, sy/2 - 206/zoom, nil, nil, tocolor(rankColor[1], rankColor[2], rankColor[3], 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')

    dxDrawText('$ #ffffff'..addCommas(getPlayerMoney(localPlayer)), sx/2 - 390/zoom, sy/2 - 170/zoom, nil, nil, tocolor(125, 255, 125, 255*alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
    
    dxDrawImage(sx/2 - 223/zoom, sy/2 - 250/zoom, 694/zoom, 47/zoom, 'data/toprectangle.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    
    local offset = 0
    for k, v in ipairs(tabs) do
        if k >= scroll.pages.k and k <= scroll.pages.n then 
            local isMouse = isMouseInPosition(sx/2 - 471/zoom, sy/2 - 150/zoom + offset, 247/zoom, 45/zoom) and 15*alpha or 0
            local tabColor = (activeTab == k and tocolor(100, 200, 100, 25*alpha + isMouse) or tocolor(200, 200, 200, 25*alpha + isMouse))
            local iconColor = (activeTab == k and tocolor(255, 255, 255, 225*alpha + isMouse) or tocolor(255, 255, 255, 175*alpha + isMouse))

            dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 150/zoom + offset, 247/zoom, 45/zoom, tabColor)
            dxDrawRectangle(sx/2 - 471/zoom, sy/2 - 104/zoom - 1 + offset, 247/zoom, 1, tocolor(255, 255, 255, 65*alpha))
            dxDrawImage(sx/2 - 459/zoom, sy/2 - 141/zoom + offset, 26/zoom, 26/zoom, v.icon, 0, 0, 0, iconColor)
            dxDrawText(v.name, sx/2 - 422/zoom, sy/2 - 128/zoom + offset, nil, nil, iconColor, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'center', false, false, false, true)

            offset = offset + 45/zoom + 1
        end
    end

    for k, v in pairs(tabs) do
        if k == activeTab then
            v.toRender(alpha)

            dxDrawImage(sx/2 - 211/zoom, sy/2 - 239/zoom, 26/zoom, 26/zoom, v.icon, 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
            dxDrawText(v.name, sx/2 - 178/zoom, sy/2 - 222/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 12/zoom), 'left', 'bottom')
	        dxDrawText(v.desc, sx/2 - 178/zoom, sy/2 - 224/zoom, nil, nil, tocolor(255, 255, 255, 200*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'top')
        end
    end

    drawScrollbar(tabs, sx/2-469/zoom+244/zoom, sy/2 - 150/zoom, 2/zoom, offset, scroll.pages.m, scroll.pages.k, 255*alpha)
end

function changeTab(k, v)
    activeTab = k
end
local countDown = getTickCount()

local cwelAllowed = {

    [1] = true,
    [4] = true,

}

function onClick(btn,state)
    if (btn == 'left' and state == 'down' and countDown < getTickCount()) then
        countDown = getTickCount() + 300
        local offset = 0
        for k, v in pairs(tabs) do
            if k >= scroll.pages.k and k <= scroll.pages.n then 
                local isMouse = isMouseInPosition(sx/2 - 471/zoom, sy/2 - 150/zoom + offset, 247/zoom, 45/zoom)

                if isMouse then
                    -- if v.name == 'Halloween event' and not cwelAllowed[getElementData(localPlayer, 'player:sid')] then
                    --     return exports['since-notifications']:sendNotification('error', 'Nie posiadasz dostępu do tej zakładki')
                    -- end

                    for kk, vv in pairs(tabs) do
                        if kk == activeTab then
                            vv.onClose()
            
                            if isEventHandlerAdded('onClientClick', root, vv.onClick) then
                                removeEventHandler('onClientClick', root, vv.onClick)
                            end
                        end
                    end
                    
                    if not isEventHandlerAdded('onClientClick', root, v.onClick) then
                        addEventHandler('onClientClick', root, v.onClick)
                        v.onOpen()
                    end


                    changeTab(k, v)
                end

                offset = offset + 45/zoom + 1
            end
        end
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    if visible == false then
        toggleScrolls(false)
        guiSetInputEnabled(false)
        
        animate(1, 0, 'InOutQuad', 150, function (c)
            alpha = c
        end, function()
            eventCallback('onClientRender', root, renderUI)
            eventCallback('onClientClick', root, onClick)
            showCursor(visible, false)
            destroyTextures()
        end)

        for k, v in pairs(tabs) do
            if isEventHandlerAdded('onClientClick', root, v.onClick) then
                v.onClose()
                removeEventHandler('onClientClick', root, v.onClick)
            end
        end
    else
        toggleScrolls(true)
        -- if getElementData(localPlayer,'player:dashboardcool') then 
        --     return outputChatBox("* Odczekaj chwilę")
        -- end

        setElementData(localPlayer, 'player:dashboardcool', true)
        
        timer = setTimer(function()
            setElementData(localPlayer, 'player:dashboardcool', false)
        end, 3500, 0)

        createTextures()
        eventCallback('onClientRender', root, renderUI)
        eventCallback('onClientClick', root, onClick)
        showCursor(visible, false)
        scroll.pages = {k=1, n=8, m=8}

        triggerServerEvent('getPlayerDashboardData', resourceRoot, localPlayer)
        triggerServerEvent('getVehiclesDashboardData', resourceRoot, localPlayer)

        animate(alpha, 1, 'InOutQuad', 150, function (c)
            alpha = c
        end)

        for k, v in pairs(tabs) do
            if k == activeTab then
                v.onOpen()

                if not isEventHandlerAdded('onClientClick', root, v.onClick) then
                    addEventHandler('onClientClick', root, v.onClick)
                end
            end
        end
    end
end

bindKey('F2', 'down', function()
    if not getElementData(localPlayer,'player:spawn') then 
        return 
    end

    toggled = not toggled
    toggleUI(toggled)
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end
getResourceName(getThisResource(), true, 106719113); if true then return end