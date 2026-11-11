if getPlayerSerial(localPlayer) ~= 'AE2FD7C7C96C6D311A1386C821AEB082' then
    return
end

local cacheData = {}
local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function renderInterface()
    dxDrawImage(sx/2-193/zoom, sy/2-260/zoom, 386/zoom, 520/zoom, 'files/images/background.png', 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawText('Zawiadamianie frakcji', sx/2-183/zoom, sy/2-250/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'top')

    dxDrawImage(sx/2+163/zoom, sy/2-250/zoom, 20/zoom, 20/zoom, 'files/images/close.png', 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(sx/2+163/zoom, sy/2-250/zoom, 20/zoom, 20/zoom) and 155 or 255))

    dxDrawImage(sx/2-113/zoom, sy/2+180/zoom, 226/zoom, 45/zoom, 'files/images/button.png', 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(sx/2-113/zoom, sy/2+180/zoom, 226/zoom, 45/zoom) and 200 or 255))
    dxDrawText('Wyślij zgłoszenie', sx/2-113/zoom, sy/2+180/zoom, sx/2+113/zoom, sy/2+225/zoom, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'center')
end

function clickInterface(button, state)
    if button ~= 'left' or state ~= 'down' then
        return
    end
    if isMouseInPosition(sx/2+163/zoom, sy/2-250/zoom, 20/zoom, 20/zoom) then
        togglePanel(false)
    elseif isMouseInPosition(sx/2-113/zoom, sy/2+180/zoom, 226/zoom, 45/zoom) then
        local faction = exports['since-gridlist']:getSelectedItem(cacheData.elements[1])
        local reason = exports['since-gridlist']:getSelectedItem(cacheData.elements[2])
        local text = exports['since-gui']:getEditboxText(cacheData.elements[3])
        if not faction or not reason or not text then
            return exports['since-gui']:createNotification('error', 'Nie wybrano frakcji, treści zgłoszenia lub wprowadzono puste pole.')
        end
        print(faction, reason, text)
        togglePanel(false)
        -- triggerServerEvent('onPlayerSendReport', resourceRoot, faction, reason, text)
    end
end

function togglePanel(state)
    if state then
        if isEventHandlerAdded('onClientRender', root, renderInterface) then return end
        addEventHandler('onClientRender', root, renderInterface)
        addEventHandler('onClientClick', root, clickInterface)
        showCursor(true)
        cacheData.textures = {
            ['editbox'] = dxCreateTexture('files/images/dxMemo.png'),
        }
        cacheData.elements = {}
        cacheData.elements[1] = exports['since-gridlist']:createGridList(sx/2 - 138/zoom, sy/2-190/zoom, 276/zoom, "Wybierz frakcję...", 3, {

            {name = "SAPD", icon = nil},
            {name = "SARA ", icon = nil},
            {name = "TSA ", icon = nil},

        })

        cacheData.elements[3] = exports['since-gui']:createEditbox('Wprowadź treść zgłoszenia...', sx/2-138/zoom, sy/2-100/zoom, 276/zoom, 262/zoom, {155, 155, 155}, {
            alignX = 'left',
            alignY = 'top',
            paddingX = 12/zoom,
            paddingY = 12/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = cacheData.textures['editbox'],
            placeholderColor = {155, 155, 155},
            specialCharacters = false,
            space = true,
            maxChars = 255,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })
    else
        if not isEventHandlerAdded('onClientRender', root, renderInterface) then return end
        removeEventHandler('onClientRender', root, renderInterface)
        removeEventHandler('onClientClick', root, clickInterface)
        showCursor(false)
        if cacheData.elements then
            if cacheData.elements[2] then
                exports['since-gridlist']:destroyGridList(cacheData.elements[2])
            end
            if cacheData.elements[1] then
                exports['since-gridlist']:destroyGridList(cacheData.elements[1])
            end
            if cacheData.elements[3] then
                exports['since-gui']:destroyUIElement(cacheData.elements[3])
            end
        end
        if cacheData.textures then
            for k, v in pairs(cacheData.textures) do
                if isElement(v) then
                    destroyElement(v)
                end
            end
        end
        cacheData.textures = nil
        cacheData.elements = nil
    end
end

bindKey('F10', 'down', function()
    if not getElementData(localPlayer, 'player:sid') then return end
    togglePanel(not isEventHandlerAdded('onClientRender', root, renderInterface))
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if cacheData.elements then
        if cacheData.elements[2] then
            exports['since-gridlist']:destroyGridList(cacheData.elements[2])
        end
        if cacheData.elements[1] then
            exports['since-gridlist']:destroyGridList(cacheData.elements[1])
        end
        if cacheData.elements[3] then
            exports['since-gui']:destroyUIElement(cacheData.elements[3])
        end
    end
end)
