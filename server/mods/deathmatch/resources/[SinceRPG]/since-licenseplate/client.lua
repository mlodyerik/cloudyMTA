-- if getElementData(localPlayer, 'player:sid') ~= 1 then return end

local renderID, renderData
local selectedVehicle 

local vehicles = {}

local loaded = false
local tick = getTickCount()
local renderUpdateMS = 500

local markers = {
    {1493.60, -1774.92, 18.73}, -- urząd LS
    {2451.33, 2357.2, 12.16}, -- urząd LV
}

for i,v in ipairs(markers) do
	local marker = createMarker(v[1], v[2], v[3]-1, 'cylinder', 1.5, 125, 255, 125, 100)
	setElementData(marker, 'marker:title', 'Tablice rejestracyjne')
	setElementData(marker, 'marker:desc', 'Zmiana tablicy rejestracyjnej')
	setElementData(marker, 'marker:icon', 'licenseplate')
    v.marker = marker
end

function isScreenElementInPosition(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function getLicensePlateFromID(id)
    local plate = 'SF ' .. string.rep('0', 8 - #tostring(id)) .. id
    return plate
end

function isPlayerOnMarker(player)
    for i,v in ipairs(markers) do
        if isElement(player) and isElement(v.marker) and isElementWithinMarker(player, v.marker) then
            return true
        end
    end
    return false
end

function renderUI()
    if (not isPlayerOnMarker(localPlayer)) then
        toggleUI(false)
        return
    end
	dxDrawImage(sx/2 - 207/zoom, sy/2 - 237/zoom, 420/zoom, 474/zoom, 'data/background.png')
	dxDrawImage(sx/2 - 207/zoom, sy/2 - 180/zoom, 420/zoom, 2/zoom, 'data/line.png')
	dxDrawImage(sx/2 - 207/zoom, sy/2 + 131/zoom, 420/zoom, 2/zoom, 'data/line.png')
	dxDrawText('Zmiana tablicy rejestracyjnej', sx/2, sy/2 - 208/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'center', 'bottom')
	dxDrawText('Koszt zmiany: $ 45 000', sx/2 + 2/zoom, sy/2 - 208/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')

    local isIn = isMouseInPosition(sx/2 - 60/zoom, sy/2 + 195/zoom, 120/zoom, 28/zoom)
	dxDrawImage(sx/2 - 60/zoom, sy/2 + 195/zoom, 120/zoom, 28/zoom, 'data/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 200))
	dxDrawText('Zmień tablicę', sx/2, sy/2 + 209/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'center', 'center')

	dxDrawText('ID', sx/2 - 178/zoom, sy/2 - 148/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'bottom')
	dxDrawText('Pojazd', sx/2 - 99/zoom, sy/2 - 148/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'bottom')
	dxDrawText('Tablica', sx/2 + 75/zoom, sy/2 - 148/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'bottom')

    if not loaded then
        local dots = math.floor(getTickCount()/250)%4
        local text = 'Ładowanie listy pojazdów'

        for i = 1, dots do
            text = text..'.'
        end

        dxDrawText(text, sx/2, sy/2, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
    end
        
    dxDrawText('Aby włączyć kursor kliknij F3', sx/2 + 1, sy/2 + 250/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
    dxDrawText('Aby włączyć kursor kliknij F3', sx/2, sy/2 + 250/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')

    if renderData then
        dxSetRenderTarget(renderData.rt, true)
            dxSetBlendMode('modulate_add')
                if loaded then
                local offset = 0
                local scrollPos = exports['since-renders']:getScrollPosition(renderID)

                for i, vehicle in ipairs(vehicles) do
                    if isScreenElementInPosition(sx/2 - 193/zoom, sy/2 - 140/zoom - offset + scrollPos, 391/zoom, 256/zoom, sx/2 - 193/zoom, sy/2 - 140/zoom, 390/zoom, 256/zoom) then
                        dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 21/zoom, 'data/selection.png')
                        dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 21/zoom, 'data/selection.png')

                        if isMouseInRender(5/zoom, 7/zoom + offset, 380/zoom, 21/zoom, renderData, renderID) then
                            dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 21/zoom, 'data/selection.png', 0, 0, 0, tocolor(255, 255, 255, 155))
                        end

                        if selectedVehicle == vehicle.id then
                            dxDrawImage(5/zoom, 7/zoom + offset, 380/zoom, 21/zoom, 'data/selection.png', 0, 0, 0, tocolor(255, 255, 255, 255))
                        end

                        dxDrawText(vehicle.id, 15/zoom, 17.5/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8/zoom), 'left', 'center')
                        dxDrawText(exports['since-vehiclenames']:getVehicleName(vehicle.model), 93.5/zoom, 17.5/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8/zoom), 'left', 'center')
                        dxDrawText(#vehicle.licenseplate > 1 and vehicle.licenseplate or getLicensePlateFromID(vehicle.id), 268/zoom, 17.5/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8/zoom), 'left', 'center')
                    end

                    offset = offset + 24/zoom
                end
            end
            dxSetBlendMode('blend')
        dxSetRenderTarget()
    end
end

function onClick(btn, state)
    if (btn == 'left' and state == 'down') then
        if isMouseInPosition(sx/2 - 60/zoom, sy/2 + 195/zoom, 120/zoom, 28/zoom) then
                local plate = exports['since-gui']:getEditboxText(uiElements['edit_plate'])

                if not plate or #plate < 1 then
                    return exports['since-notifications']:sendNotification('error', 'Wprowadź poprawną tablicę rejestracyjną.')
                end

                if not selectedVehicle then
                    return exports['since-notifications']:sendNotification('error', 'Wybierz pojazd, którego tablicę chcesz zmienić.')
                end

                if #plate > 8 then
                    return exports['since-notifications']:sendNotification('error', 'Tablica rejestracyjna nie może być dłuższa niż 8 znaków.')
                end

                if getPlayerMoney() < 45000 then
                    return exports['since-notifications']:sendNotification('error', 'Nie posiadasz wystarczającej ilości gotówki.')
                end

                triggerServerEvent('changeLicensePlate', resourceRoot, selectedVehicle, plate)
                toggleUI(false)
            return
        end

        local offset = 0

        for i, vehicle in ipairs(vehicles) do
            if isMouseInRender(5/zoom, 7/zoom + offset, 380/zoom, 21/zoom, renderData, renderID) then
                selectedVehicle = vehicle.id
            end
            
            offset = offset + 24/zoom
        end
    end
end

addEvent('returnUserVehicles', true)
addEventHandler('returnUserVehicles', resourceRoot, function(tbl)
    if not tbl then
        return
    end

    vehicles = tbl
end)

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)

    if visible then
        triggerServerEvent('returnUserVehicles', resourceRoot)

        setTimer(function()
            if #vehicles > 0 and loaded == false then

                renderID, renderData = exports['since-renders']:createTarget({
                    x = sx/2 - 193/zoom,
                    y = sy/2 - 140/zoom,
                    w = 390/zoom,
                    h = 256/zoom,
                    alpha = true,
                    max_scroll = getMaxOffset(math.min(#vehicles, 500/zoom), 24.3/zoom, 7, 256/zoom),
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
                uiElements.textures.editbox_icon = dxCreateTexture('data/edit_icon.png')
                uiElements['edit_plate'] = exports['since-gui']:createEditbox('Wprowadź tekst...', sx/2 - 134/zoom, sy/2 + 148/zoom, 268/zoom, 40/zoom, {155, 155, 155}, {
                    alignX = 'left',
                    paddingX = 40/zoom,
                    caretColor = {255, 255, 255, 100},
                    caretWidth = 1,
                    font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                    image = uiElements.textures.editbox,
                    placeholderColor = {155, 155, 155},
                    specialCharacters = false,
                    passworded = false,
                    caretHeight = 18/zoom,
                    icon = uiElements.textures.editbox_icon,
                    iconPadding = 8/zoom,
                    textColor = {255, 255, 255, 200},
                })

                loaded = true
            end
        end, 2500, 5)
    else
        if uiElements.textures then
            for key, value in pairs(uiElements.textures) do
                if isElement(value) then
                    destroyElement(value)
                end
            end
        end

        if uiElements.edit_plate then
            exports['since-gui']:destroyUIElement(uiElements.edit_plate)
        end

        if renderID then
            exports['since-renders']:destroyTarget(renderID)
            renderData = nil
            renderID = nil
        end

        loaded = false
        vehicles = {}
        uiElements = {}
        uiElements.textures = {}
        showCursor(false)
    end
end

addEventHandler('onClientMarkerHit', resourceRoot, function(el, md)
    if el == localPlayer and md then
        toggleUI(true)
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    toggleUI(false)
end)

