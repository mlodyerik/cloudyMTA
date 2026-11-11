local modalOptions = false

-- 
-- title: string
-- message: string
-- input: string
-- confirm: string
-- cancel: string
-- id: string
-- 
function showModal(data)
    hideModal()
    
    local wrapped = wordWrap(data.message or '', 310/zoom, 0.9, uiElements.interFontNormal, false)
    modalOptions = data
    modalOptions.wrapped = wrapped

    if data.input then
        local h = dxGetFontHeight(1, uiElements.interFontBoldNormal)
        local smallH = dxGetFontHeight(0.9, uiElements.interFontNormal)
        local y = sy/2 - 130/zoom + h + #wrapped * smallH

        uiElements.input = exports['since-gui']:createEditbox(data.input, sx/2 - 155/zoom, y + 10/zoom, 310/zoom, 60/zoom, {255, 255, 255}, {
            font = uiElements.interFontNormal,
            image = dxCreateTexture('data/editbox.png'),
            alignX = 'left',
            maxChars = 32,
            space = true,
            paddingX = 15/zoom,
            placeholderColor = {255, 255, 255, 200},
        })
    end
end

function hideModal()
    modalOptions = false

    if uiElements.input then 
        exports['since-gui']:destroyUIElement(uiElements.input)
        uiElements.input = false
    end
end

function isModalVisible()
    return modalOptions ~= false
end

addEventHandler("onClientRender", root, function()
    if not isModalVisible() then return end
    if not uiElements.interFontBoldNormal then return end
    
    local my = not modalOptions.input and 45/zoom or 0
    local h = dxGetFontHeight(1, uiElements.interFontBoldNormal)
    local smallH = dxGetFontHeight(0.9, uiElements.interFontNormal)
    local wrapped = modalOptions.wrapped
    local y = sy/2 - 130/zoom + h + #wrapped * smallH

    local bgh = 210/zoom + #wrapped * smallH + (uiElements.input and 70/zoom or 0)

    dxDrawImage(sx/2 - 600/zoom, sy/2 - 350/zoom, 1200/zoom, 700/zoom, 'data/background.png', 0, 0, 0, 0x77000000)
    dxDrawImage(sx/2 - 175/zoom, sy/2 - 150/zoom + my, 350/zoom, bgh, 'data/modal.png')

    dxDrawText(modalOptions.title, sx/2 - 155/zoom, sy/2 - 130/zoom + my, nil, nil, 0xFFFFFFFF, 1, uiElements.interFontBoldNormal)
    if modalOptions.message then
        dxDrawText(modalOptions.message, sx/2 - 155/zoom, sy/2 - 130/zoom + h + my, sx/2 + 155/zoom, sy/2 - 10/zoom + h + my, 0xCCFFFFFF, 0.9, uiElements.interFontNormal, 'left', 'top', false, true)
    end

    local oy = 0
    if uiElements.input then
        oy = 70/zoom
    end

    local isIn = isMouseInPosition(sx/2 - 155/zoom, y + 10/zoom + oy + my, 310/zoom, 60/zoom)
    dxDrawImage(sx/2 - 155/zoom, y + 10/zoom + oy + my, 310/zoom, 60/zoom, 'data/confirm.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
    dxDrawText(modalOptions.confirm, sx/2 - 155/zoom, y + 10/zoom + oy + my, sx/2 + 155/zoom, y + 70/zoom + oy + my, tocolor(255, 255, 255, isIn and 200 or 255), 1, uiElements.interFontNormal, 'center', 'center')

    local isIn = isMouseInPosition(sx/2 - 155/zoom, y + 80/zoom + oy + my, 310/zoom, 60/zoom)
    dxDrawImage(sx/2 - 155/zoom, y + 80/zoom + oy + my, 310/zoom, 60/zoom, 'data/cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
    dxDrawText(modalOptions.cancel, sx/2 - 155/zoom, y + 80/zoom + oy + my, sx/2 + 155/zoom, y + 140/zoom + oy + my, tocolor(255, 255, 255, isIn and 200 or 255), 1, uiElements.interFontNormal, 'center', 'center')
end, true, 'low')

addEvent('onModalConfirm', true)
addEvent('onModalCancel', true)

addEventHandler('onClientClick', root, function(button, state)
    if button ~= 'left' or state ~= 'down' then return end
    if not isModalVisible() then return end

    local my = not modalOptions.input and 45/zoom or 0
    local h = dxGetFontHeight(1, uiElements.interFontBoldNormal)
    local smallH = dxGetFontHeight(0.9, uiElements.interFontNormal)
    local wrapped = wordWrap(modalOptions.message or '', 300, 0.9, uiElements.interFontNormal, false)
    local y = sy/2 - 130/zoom + h + #wrapped * smallH

    local oy = 0
    if uiElements.input then
        oy = 70/zoom
    end

    if isMouseInPosition(sx/2 - 155/zoom, y + 10/zoom + oy + my, 310/zoom, 60/zoom) then
        if modalOptions.input then
            local text = exports['since-gui']:getEditboxText(uiElements.input)

            if text == '' then
                return
            end

            triggerEvent('onModalConfirm', resourceRoot, modalOptions.id, text)
        else
            triggerEvent('onModalConfirm', resourceRoot, modalOptions.id)
        end

        hideModal()
    elseif isMouseInPosition(sx/2 - 155/zoom, y + 80/zoom + oy + my, 310/zoom, 60/zoom) then
        triggerEvent('onModalCancel', resourceRoot)
        hideModal()
    end
end)

-- addEventHandler('onClientResourceStart', resourceRoot, function()
--     setTimer(function()
--         showModal({
--             title = 'Usuwanie organizacji',
--             message = 'Czy na pewno chcesz usunąć organizację?',
--             -- input = 'Nazwa',
--             confirm = 'Usuń',
--             cancel = 'Anuluj'
--         })
--     end, 100, 1)
-- end, true, 'low')
getResourceName(getThisResource(), true, 177046395); if true then return end