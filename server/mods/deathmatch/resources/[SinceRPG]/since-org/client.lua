-- temp
sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
uiElements = {}

local canProcessAction = true

addEvent('since:organizations:getData', true)
addEventHandler('since:organizations:getData', resourceRoot, function(result)
    if not result.status then
        showNotification(result.message, 'error')
    else
        setRenderData(result.data)
        createUI()
    end
end)

function renderUI()
    renderOrganizationUI()
end

function clickUI(button, state)
    if not canProcessAction then return end

    clickOrganizationUI(button, state)
end

function createUI()
    uiElements.open = true

    uiElements.interFont = exports['since-fonts']:getFont('Inter-Medium', 16/zoom)
    uiElements.interFontBold = exports['since-fonts']:getFont('Inter-Bold', 22/zoom)
    uiElements.interFontBoldNormal = exports['since-fonts']:getFont('Inter-Bold', 16/zoom)
    uiElements.interFontNormal = exports['since-fonts']:getFont('Inter-Medium', 16/zoom)
    uiElements.interFontSmall = exports['since-fonts']:getFont('Inter-Regular', 13/zoom)
    uiElements.interExtraBold = exports['since-fonts']:getFont('Inter-ExtraBold', 18/zoom)
    uiElements.interSemiBold = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom)
    uiElements.interRegular = exports['since-fonts']:getFont('Inter-Medium', 18/zoom)
    uiElements.interFontSmallBold = exports['since-fonts']:getFont('Inter-Bold', 13/zoom)
    uiElements.moneyFont = exports['since-fonts']:getFont('Inter-Bold', 30/zoom)

    uiElements.icons = {
        ['rank-up'] = dxCreateTexture('data/rank-up.png', 'argb', true, 'clamp'),
        ['rank-down'] = dxCreateTexture('data/rank-down.png', 'argb', true, 'clamp'),
        ['remove'] = dxCreateTexture('data/remove.png', 'argb', true, 'clamp'),
        ['map'] = dxCreateTexture('data/map.png', 'argb', true, 'clamp'),
        ['garage'] = dxCreateTexture('data/garage.png', 'argb', true, 'clamp'),
        ['add'] = dxCreateTexture('data/add.png', 'argb', true, 'clamp'),
        ['trash-big'] = dxCreateTexture('data/trash-big.png', 'argb', true, 'clamp'),
    }

    addEventHandler('onClientRender', root, renderUI)
    addEventHandler('onClientClick', root, clickUI)
    showCursor(true)
    setUIRender('dashboard')
    setActiveTab(1)
    guiSetInputEnabled(false)
end

function openUI()
    triggerServerEvent('since:organizations:getData', resourceRoot)
end

setElementData(localPlayer, "org_request", nil)

function destroyUI()
    if not uiElements.open then return end
    
    removeEventHandler('onClientRender', root, renderUI)
    removeEventHandler('onClientClick', root, clickUI)
    showCursor(false)

    if uiElements.input then exports['since-gui']:destroyUIElement(uiElements.input) end

    for k, v in pairs(uiElements) do
        if isElement(v) then
            -- if font then dont destroy
            if k == 'interFont' or k == 'interFontBold' or k == 'interFontBoldNormal' or k == 'interFontNormal' or k == 'interFontSmall' or k == 'interExtraBold' or k == 'interSemiBold' or k == 'interRegular' or k == 'interFontSmallBold' or k == 'moneyFont' then
                -- dont destroy
            else
                destroyElement(v)
            end
        end
    end

    guiSetInputEnabled(false)
end

local toggle = false

bindKey('F4', 'down', function()
    if not getElementData(localPlayer, 'player:organization') then
        return
    end

    toggle = not toggle
    if toggle then openUI() else destroyUI() end
end)
getResourceName(getThisResource(), true, 502392907); if true then return end