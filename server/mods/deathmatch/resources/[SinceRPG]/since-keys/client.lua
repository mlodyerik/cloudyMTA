local data = {

    keys = {},
    uiElements = {}

}

local k = 1
local n = 4
local m = 4

function getVehicleKeys(veh)
    local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}

    if vehicleUpgrades['keys'] then
        return tonumber(vehicleUpgrades['keys'])
    else
        return 1
    end
end

function renderKeys()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh then
        local numberofkeys = getVehicleKeys(veh)
        dxDrawImage(sx/2 - 165/zoom, sy/2 - 162/zoom, 329/zoom, 324/zoom, 'data/bg.png')
        dxDrawText('Udostępnianie kluczy', sx/2, sy/2 - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
        dxDrawText('Wykorzystane klucze: '..#data.keys..' / '..numberofkeys, sx/2, sy/2 - 114/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'center', 'top')

        local isIn = isMouseInPosition(sx/2 - 150/zoom, sy/2 + 111/zoom, 300/zoom, 35/zoom)
        dxDrawImage(sx/2 - 150/zoom, sy/2 + 111/zoom, 300/zoom, 35/zoom, 'data/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
        dxDrawText('Anuluj', sx/2, sy/2 + 128/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

        local offset = 0
        for i, v in ipairs(data.keys) do
            if i >= k and i <= n then 
                dxDrawImage(sx/2 - 151/zoom, sy/2 - 83/zoom + offset, 301/zoom, 34/zoom, 'data/list.png')
                dxDrawText(v.name, sx/2 - 141/zoom, sy/2 - 66/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')
                local textWidth = dxGetTextWidth(v.name, 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom))
                local textWidth2 = dxGetTextWidth('UID: '..v.uid..'', 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom))

                dxDrawRoundedRectangle(sx/2 - 141/zoom + textWidth + 5/zoom, sy/2 - 76/zoom + offset, 25/zoom + textWidth2, 20/zoom, 10/zoom, tocolor(155, 155, 155, 155))
                dxDrawText('UID: '..v.uid..'', sx/2 - 141/zoom + textWidth + 5/zoom + (25/zoom)/2 + (textWidth2/2), sy/2 - 66/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')

                local isIn = isMouseInPosition(sx/2 + 44/zoom, sy/2 - 76/zoom + offset, 100/zoom, 20/zoom)

                if isIn then
                    dxDrawRoundedRectangle(sx/2 + 44/zoom, sy/2 - 76/zoom + offset, 100/zoom, 20/zoom, 10/zoom, tocolor(200, 75, 75, 175))
                    dxDrawText('Zabierz klucz', sx/2 + 44/zoom + 51/zoom, sy/2 - 66/zoom + offset, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')
                else
                    dxDrawRoundedRectangle(sx/2 + 44/zoom, sy/2 - 76/zoom + offset, 100/zoom, 20/zoom, 10/zoom, tocolor(155, 55, 55, 100))
                    dxDrawText('Zabierz klucz', sx/2 + 44/zoom + 51/zoom, sy/2 - 66/zoom + offset, nil, nil, tocolor(255, 255, 255, 155), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')
                end
                
                offset = offset + 34/zoom + 2
            end
        end

        local isIn = isMouseInPosition(sx/2 + 55/zoom, sy/2 + 70/zoom, 94/zoom, 35/zoom)
        dxDrawRoundedRectangle(sx/2 + 55/zoom, sy/2 + 70/zoom, 94/zoom, 35/zoom, 4/zoom, tocolor(125, 185, 255, isIn and 175 or 125))
        dxDrawText('Udostępnij', sx/2 + 55/zoom + (94/zoom)/2, sy/2 + 87/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
    else
        toggleUI(false)
    end
end

function click(btn, state)
    if btn == 'left' and state == 'down' then
        if isMouseInPosition(sx/2 - 150/zoom, sy/2 + 111/zoom, 300/zoom, 35/zoom) then
            toggleUI(false)
        end

        if isMouseInPosition(sx/2 + 55/zoom, sy/2 + 70/zoom, 94/zoom, 35/zoom) then
            local editText = exports['since-gui']:getEditboxText(data.uiElements['editbox'])
            
            if tonumber(editText) then
                triggerServerEvent('manageKeys', resourceRoot, 'add', {editText})
            else
                return exports['since-notifications']:sendNotification('error', 'Podaj UID.')
            end
        end

        local offset = 0
        for i, v in ipairs(data.keys) do
            if i >= k and i <= n then 
                if isMouseInPosition(sx/2 + 44/zoom, sy/2 - 76/zoom + offset, 100/zoom, 20/zoom) then
                    triggerServerEvent('manageKeys', resourceRoot, 'delete', {v.uid, v.name})
                end

                offset = offset + 34/zoom + 2
            end
        end
    end
end

function scrollDown()
    if n == m then return end
    k = k-1
    n = n-1
end

function scrollUp()
    if n >= #data.keys then return end
    k = k+1
    n = n+1
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    if not visible then
        if data.uiElements['editbox'] then
            exports['since-gui']:destroyUIElement(data.uiElements['editbox'])
            data.uiElements['editbox'] = nil
        end

        if data.uiElements['edittex'] then
            destroyElement(data.uiElements['edittex'])
            data.uiElements['edittex'] = nil
        end

        unbindKey("mouse_wheel_down", "both", scrollUp)
        unbindKey("mouse_wheel_up", "both", scrollDown)
        guiSetInputEnabled(false)
        showCursor(false)
    else
        data.uiElements['edittex'] = dxCreateTexture(':since-gielda/data/selling/editbox.png')
        data.uiElements['editbox'] = exports['since-gui']:createEditbox('Wprowadź UID..', sx/2 - 150/zoom, sy/2 + 70/zoom, 200/zoom, 35/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 10/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = data.uiElements['edittex'],
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
            caretHeight = 18/zoom,
            textColor = {255, 255, 255, 200},
        })

        bindKey("mouse_wheel_down", "both", scrollUp)
        bindKey("mouse_wheel_up", "both", scrollDown)
        showCursor(true)
    end
    

    eventCallback('onClientRender', root, renderKeys)
    eventCallback('onClientClick', root, click)
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    toggleUI(false)
end)

addEvent('getKeysInfo', true)
addEventHandler('getKeysInfo', resourceRoot, function(result)
    data.keys = result

    if isEventHandlerAdded('onClientRender', root, renderKeys) then
        return
    end
    
    toggleUI(true)
end)