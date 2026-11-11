local markers = {
    {1471.57, -1785.50, 18.73}, -- urząd LS
    {2458.46, 2357.2, 12.16}, -- urząd LV
}

for i,v in ipairs(markers) do
	local marker = createMarker(v[1], v[2], v[3]-1, 'cylinder', 1.5, 125, 255, 125, 100)
    setElementData(marker, 'marker:title', 'Organizacje')
    setElementData(marker, 'marker:desc', 'Załóż organizacje')
    setElementData(marker, 'marker:icon', 'skin')
end

local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local zoom = zoom * 1.15
local uiElements = {}
local canProcessAction = true

addEvent('since:organizations:create', true)
addEventHandler('since:organizations:create', resourceRoot, function(result)
    showNotification(result.message, result.status and 'success' or 'error')
    if result.status then
        destroyUI()
    end

    canProcessAction = true
end)

function renderUI()
    dxDrawImage(sx/2 - 220/zoom, sy/2 - 250/zoom, 440/zoom, 500/zoom, 'data/bg.png')

    local isin = isMouseInPosition(sx/2 + 175/zoom, sy/2 - 230/zoom, 25/zoom, 25/zoom)
    dxDrawImage(sx/2 + 175/zoom, sy/2 - 230/zoom, 25/zoom, 25/zoom, 'data/close.png', 0, 0, 0, tocolor(255, 255, 255, isin and 200 or 255))
    
    local isin = isMouseInPosition(sx/2 - 205/zoom, sy/2 + 195/zoom, 200/zoom, 40/zoom)
    dxDrawImage(sx/2 - 205/zoom, sy/2 + 195/zoom, 200/zoom, 40/zoom, 'data/button_create.png', 0, 0, 0, tocolor(255, 255, 255, isin and 200 or 255))
    dxDrawText('Stwórz organizacje', sx/2 - 205/zoom + 100/zoom, sy/2 + 195/zoom + 20/zoom, nil, nil, tocolor(255, 255, 255, isin and 200 or 255), 1, uiElements.interFont, 'center', 'center', false, false, false, true)
    
    local isin = isMouseInPosition(sx/2 + 5/zoom, sy/2 + 195/zoom, 200/zoom, 40/zoom)
    dxDrawImage(sx/2 + 5/zoom, sy/2 + 195/zoom, 200/zoom, 40/zoom, 'data/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isin and 200 or 255))
    dxDrawText('Zamknij', sx/2 + 5/zoom + 100/zoom, sy/2 + 195/zoom + 20/zoom, nil, nil, tocolor(255, 255, 255, isin and 200 or 255), 1, uiElements.interFont, 'center', 'center', false, false, false, true)

    local h = dxGetFontHeight(1, uiElements.interFontBold)
    dxDrawText('Tworzenie organizacji', sx/2 - 205/zoom, sy/2 - 235/zoom, nil, nil, white, 1, uiElements.interFontBold)
    dxDrawText('Stwórz swoją organizację', sx/2 - 205/zoom, sy/2 - 235/zoom + h, nil, nil, 0xFF80F177, 1, uiElements.interFont)

    dxDrawText('Wymagania', sx/2, sy/2 + 65/zoom, nil, nil, 0xFF80F177, 1, uiElements.interFontBold, 'center')
    dxDrawText('- 2150 #FFA722SRP#ffffff \
- #68D65E$ #ffffff1 250 000 \
- Minimalny łączny czas gry 24 godziny', sx/2, sy/2 + 65/zoom + h, nil, nil, white, 1, uiElements.interFont, 'center', 'top', false, false, false, true)
end

function clickUI(button, state)
    if not canProcessAction then return end
    if button ~= 'left' or state ~= 'down' then return end

    if isMouseInPosition(sx/2 + 175/zoom, sy/2 - 230/zoom, 25/zoom, 25/zoom) or isMouseInPosition(sx/2 + 5/zoom, sy/2 + 195/zoom, 200/zoom, 40/zoom) then
        destroyUI()
        return
    end

    if isMouseInPosition(sx/2 - 205/zoom, sy/2 + 195/zoom, 200/zoom, 40/zoom) then
        local color = exports['since-gui']:getEditboxText(uiElements.color)
        local name = exports['since-gui']:getEditboxText(uiElements.name)
        local tag = exports['since-gui']:getEditboxText(uiElements.tag)

        local colorPattern = '^%d%d?%d?%s*,%s*%d%d?%d?%s*,%s*%d%d?%d?%s*$'
        if not color:match(colorPattern) then return showNotification('Podany kolor jest nieprawidłowy!', 'error') end

        local r, g, b = unpack(split(color, ','))
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if tonumber(r) > 255 or tonumber(g) > 255 or tonumber(b) > 255 then return showNotification('Podany kolor jest nieprawidłowy!', 'error') end
        if #name < 3 then return showNotification('Nazwa organizacji jest za krótka!', 'error') end
        if #tag ~= 3 then return showNotification('TAG organizacji musi mieć 3 znaki!', 'error') end

        triggerServerEvent('since:organizations:create', resourceRoot, name, tag, {r=r, g=g, b=b})
        canProcessAction = false
    end
end

function createUI()
    if isEventHandlerAdded('onClientRender', root, renderUI) then 
        return 
    end

    uiElements.interFont = exports['since-fonts']:getFont('Inter-Medium', 14/zoom)
    uiElements.interFontBold = exports['since-fonts']:getFont('Inter-Bold', 18/zoom)

    uiElements.color = exports['since-gui']:createEditbox('Kolor (R, G, B)...', sx/2 - 130/zoom, sy/2 - 150/zoom, 260/zoom, 60/zoom, {255, 255, 255}, {
        font = uiElements.interFont,
        image = dxCreateTexture('data/editbox.png'),
        icon = dxCreateTexture('data/color.png'),
        iconPadding = 15/zoom,
        alignX = 'left',
        paddingX = 60/zoom,
        placeholderColor = {255, 255, 255, 200},
    })

    uiElements.name = exports['since-gui']:createEditbox('Nazwa organizacji...', sx/2 - 130/zoom, sy/2 - 85/zoom, 260/zoom, 60/zoom, {255, 255, 255}, {
        font = uiElements.interFont,
        image = dxCreateTexture('data/editbox.png'),
        icon = dxCreateTexture('data/group.png'),
        iconPadding = 15/zoom,
        alignX = 'left',
        paddingX = 60/zoom,
        maxChars = 32,
        placeholderColor = {255, 255, 255, 200},
        space = true,
    })

    uiElements.tag = exports['since-gui']:createEditbox('TAG organizacji...', sx/2 - 130/zoom, sy/2 - 20/zoom, 260/zoom, 60/zoom, {255, 255, 255}, {
        font = uiElements.interFont,
        image = dxCreateTexture('data/editbox.png'),
        icon = dxCreateTexture('data/tag.png'),
        iconPadding = 15/zoom,
        alignX = 'left',
        paddingX = 60/zoom,
        maxChars = 3,
        placeholderColor = {255, 255, 255, 200},
    })

    addEventHandler('onClientRender', root, renderUI)
    addEventHandler('onClientClick', root, clickUI)
    showCursor(true)
end

function destroyUI()
    if not isEventHandlerAdded('onClientRender', root, renderUI) then 
        return 
    end

    if not uiElements.color then return end
    
    exports['since-gui']:destroyUIElement(uiElements.color)
    exports['since-gui']:destroyUIElement(uiElements.name)
    exports['since-gui']:destroyUIElement(uiElements.tag)

    removeEventHandler('onClientRender', root, renderUI)
    removeEventHandler('onClientClick', root, clickUI)
    showCursor(false)
end

addEventHandler('onClientResourceStop', resourceRoot, destroyUI)
addEventHandler('onClientMarkerHit', resourceRoot, function(el, md)
    if el ~= localPlayer or not md then return end
    createUI()
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
getResourceName(getThisResource(), true, 841553429); if true then return end