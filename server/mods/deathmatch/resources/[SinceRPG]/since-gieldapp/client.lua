local scrollbars = {}
local selectedItem = 0
local loaded = false

--if getElementData(localPlayer, 'player:sid') ~= 1 then return end

local marker = createMarker(1469.29, -1775.22, 18, 'cylinder', 1.5, 125, 255, 125, 100)
setElementData(marker, 'marker:title', 'Giełda wPLN')
setElementData(marker, 'marker:desc', 'Kupuj i sprzedawaj wPLN!')

local exchange = {}

function isScreenElementInPosition(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function renderUI()
    if not isElementWithinMarker(localPlayer, marker) then
        toggleUI(false)
        return
    end
    
	dxDrawImage(sx/2 - 207/zoom, sy/2 - 237/zoom, 420/zoom, 474/zoom, 'data/background.png')
	dxDrawImage(sx/2 - 207/zoom, sy/2 - 180/zoom, 420/zoom, 2/zoom, 'data/line.png')
	dxDrawImage(sx/2 - 207/zoom, sy/2 + 131/zoom, 420/zoom, 2/zoom, 'data/line.png')
	dxDrawText('Giełda wPLN', sx/2, sy/2 - 208/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'center', 'bottom')
	dxDrawText('Sprzedawaj i kupuj wPLN!', sx/2 + 2/zoom, sy/2 - 208/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')

    local isIn = isMouseInPosition(sx/2 - 60/zoom, sy/2 + 195/zoom, 120/zoom, 28/zoom)
	dxDrawImage(sx/2 - 60/zoom, sy/2 + 195/zoom, 120/zoom, 28/zoom, 'data/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 200))
	dxDrawText('Wystaw ofertę', sx/2, sy/2 + 209/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'center', 'center')

	dxDrawText('Aby zakupić wPLN wybierz ilość suwakiem i kliknij zakup', sx/2, sy/2 - 148/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'bottom')
        
    dxDrawText('Aby włączyć kursor kliknij F3', sx/2 + 1, sy/2 + 250/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
    dxDrawText('Aby włączyć kursor kliknij F3', sx/2, sy/2 + 250/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')

    if renderData then
        dxSetRenderTarget(renderData.rt, true)
            dxSetBlendMode('modulate_add')
                local offset = 0
                local scrollPos = exports['since-renders']:getScrollPosition(renderID)

                for i, v in ipairs(exchange) do
                    if isScreenElementInPosition(sx/2 - 193/zoom, sy/2 - 140/zoom - offset + scrollPos, 391/zoom, 256/zoom, sx/2 - 193/zoom, sy/2 - 140/zoom, 390/zoom, 256/zoom) then
                        dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 50/zoom, 'data/selection.png')
                        dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 50/zoom, 'data/selection.png', 0, 0, 0, tocolor(255, 255, 255, 155))

                        if isMouseInRender(5/zoom, 7/zoom + offset, 380/zoom, 50/zoom, renderData, renderID) then
                            dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 50/zoom, 'data/selection.png', 0, 0, 0, tocolor(255, 255, 255, 55))
                        end

                        dxDrawText('Sprzedający', 15/zoom, 31/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom')
                        dxDrawText(v.player, 15/zoom, 31/zoom + offset, nil, nil, tocolor(125, 200, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'top')

                        dxDrawText('Cena', 110/zoom, 31/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom')
                        dxDrawText('$ '..v.price, 110/zoom, 31/zoom + offset, nil, nil, tocolor(125, 255, 125, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'top')

                        dxDrawText('Ilość', 200/zoom, 31/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom')
                        dxDrawText(v.value..' wPLN', 200/zoom, 31/zoom + offset, nil, nil, tocolor(125, 255, 125, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'top')

                        local isIn = isMouseInRender(280/zoom, 17/zoom + offset, 90/zoom, 28/zoom, renderData, renderID)
                        dxDrawImage(280/zoom, 17/zoom + offset, 90/zoom, 28/zoom, 'data/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 175))
                        
                        if v.uid == getElementData(localPlayer, 'player:sid') then
                            dxDrawText('Usuń ofertę', 326/zoom, 31/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'center', 'center')
                        else
                            dxDrawText('Zakup wPLN', 326/zoom, 31/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 255 or 175), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'center', 'center')
                        end
                    end

                    offset = offset + 54/zoom
                end
            dxSetBlendMode('blend')
        dxSetRenderTarget()
    end
end

function onClick(btn, state)
    if (btn == 'left' and state == 'down') then
        local offset = 0 
        for i, v in ipairs(exchange) do
            if isMouseInRender(280/zoom, 17/zoom + offset, 90/zoom, 28/zoom, renderData, renderID) then
                if v.uid == getElementData(localPlayer, 'player:sid') then
                    triggerServerEvent('onPlayerExchangeUse', resourceRoot, 'delete', v.id)
                else
                    triggerServerEvent('onPlayerExchangeUse', resourceRoot, 'buy', v.id, v.player, v.value, v.price, v.uid)
                end
            end

            offset = offset + 54/zoom
        end
       

        if isMouseInPosition(sx/2 - 60/zoom, sy/2 + 195/zoom, 120/zoom, 28/zoom) then
            local cost = exports['since-gui']:getEditboxText(uiElements['edit_cost'])
            local value = exports['since-gui']:getEditboxText(uiElements['edit_value'])

            if not tonumber(cost) or not tonumber(value) then
                return exports['since-notifications']:sendNotification('error', 'Wprowadź poprawne dane.')
            end

            if tonumber(cost) < 0 or tonumber(value) < 0 then
                return exports['since-notifications']:sendNotification('error', 'Wprowadź poprawne dane.')
            end

            if #cost < 0 or #value < 0 then
                return exports['since-notifications']:sendNotification('error', 'Wprowadź poprawne dane.')
            end

            triggerServerEvent('onPlayerExchangeUse', resourceRoot, 'add', tonumber(value), tonumber(cost))
        end
    end
end

addEvent('returnUserExchangeData', true)
addEventHandler('returnUserExchangeData', resourceRoot, function(tbl)
    if not tbl then
        return
    end

    exchange = tbl
end)

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)

    if visible then
        triggerServerEvent('returnUserExchangeData', resourceRoot)

        setTimer(function()
            renderID, renderData = exports['since-renders']:createTarget({
                x = sx/2 - 193/zoom,
                y = sy/2 - 140/zoom,
                w = 390/zoom,
                h = 256/zoom,
                alpha = true,
                max_scroll = getMaxOffset((#exchange > 0 and #exchange or 1), 54.3/zoom, 5, 256/zoom),
                scrollSpeed = 20,
                noDrag = true,
                        
                scrollData = {
                    visible = true,
                    x = sx/2 - 193/zoom + 394/zoom,
                    w = 5/zoom,
                    color = {100, 100, 100},
                }
            })
    
            uiElements.textures.editbox = dxCreateTexture('data/editbox.png')
            uiElements['edit_cost'] = exports['since-gui']:createEditbox('Cena...', sx/2 - 125/zoom - 12/zoom, sy/2 + 144/zoom, 125/zoom, 40/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 12/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                image = uiElements.textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = false,
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })
    
            uiElements['edit_value'] = exports['since-gui']:createEditbox('Ilość wPLN...', sx/2 + 12/zoom, sy/2 + 144/zoom, 125/zoom, 40/zoom, {155, 155, 155}, {
                alignX = 'left',
                paddingX = 12/zoom,
                caretColor = {255, 255, 255, 100},
                caretWidth = 1,
                font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                image = uiElements.textures.editbox,
                placeholderColor = {155, 155, 155},
                specialCharacters = false,
                passworded = false,
                caretHeight = 18/zoom,
                textColor = {255, 255, 255, 200},
            })
        end, 100, 1)
    else
        if uiElements.textures then
            for key, value in pairs(uiElements.textures) do
                if isElement(value) then
                    destroyElement(value)
                end
            end
        end

        if uiElements.edit_cost then
            exports['since-gui']:destroyUIElement(uiElements.edit_cost)
        end

        if uiElements.edit_value then
            exports['since-gui']:destroyUIElement(uiElements.edit_value)
        end

        if renderID then
            exports['since-renders']:destroyTarget(renderID)
            renderData = nil
            renderID = nil
        end

        loaded = false
        exchange = {}
        uiElements = {}
        uiElements.textures = {}
    end
end

addEventHandler('onClientMarkerHit', marker, function(el, md)
    if el == localPlayer and md then
        toggleUI(true)
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    toggleUI(false)
end)

