local k = 1
local n = 5
local m = 5

local k1 = 1
local n1 = 5
local m1 = 5

function renderOffer()
    exports['since-blur']:dxDrawBlur(sx/2 - 266/zoom, sy/2 - 104/zoom, 531/zoom, 208/zoom, textures.maskOffer)
	dxDrawImage(sx/2 - 266/zoom, sy/2 - 104/zoom, 531/zoom, 208/zoom, 'data/offer/bg.png')
	dxDrawText('Otrzymujesz ofertę', sx/2, sy/2 - 65/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Otrzymano ofertę handlu od #7dff7d'..getPlayerName(data.offerData.from), sx/2, sy/2 - 65/zoom, nil, nil, tocolor(225, 225, 225, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)
    
    local isIn = isMouseInPosition(sx/2 - 256/zoom, sy/2 + 56/zoom, 251/zoom, 35/zoom)
	dxDrawImage(sx/2 - 256/zoom, sy/2 + 56/zoom, 251/zoom, 35/zoom, 'data/offer/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Odrzuć ofertę', sx/2 - 130/zoom, sy/2 + 72/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

    local isIn = isMouseInPosition(sx/2 + 5/zoom, sy/2 + 55/zoom, 251/zoom, 35/zoom)
	dxDrawImage(sx/2 + 5/zoom, sy/2 + 55/zoom, 251/zoom, 35/zoom, 'data/offer/button_buy.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Przyjmij ofertę', sx/2 + 130/zoom, sy/2 + 72/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

	dxDrawText('Czy chcesz zakupic pojazd #7db5ff'..exports['since-vehiclenames']:getVehicleName(data.offerData.vehicle.model)..' (ID: '..data.offerData.vehicle.id..')#ffffff za kwotę #7dff7d$ '..addCommas(data.offerData.cost)..'#ffffff?', sx/2, sy/2 - 15/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center', false, false, false, true)
    
    local timeout = interpolateBetween(1, 0, 0, 0, 0, 0, math.min(1, (getTickCount() - data.tick) / 10000), 'Linear')
    dxDrawRectangle(sx / 2 - 255/zoom, sy / 2 + 42/zoom, 510/zoom * timeout, 3, tocolor(125, 255, 125, 155))
    dxDrawRectangle(sx / 2 - 255/zoom, sy / 2 + 42/zoom, 510/zoom, 3, tocolor(125, 255, 125, 100))

    local r, g = getRGColorFromPercentage(timeout*100)
	dxDrawText('Pozostały czas na zaakceptowanie: '..RGBToHex(r, g, 0)..' ' .. string.format("%.2f", timeout*10) .. ' sek.', sx/2, sy/2 + 35, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'center', 'bottom', false, false, false, true)

    if timeout == 0 then
        removeEventHandler('onClientRender', root, renderOffer)
        removeEventHandler('onClientClick', root, offerClick)
        
        triggerServerEvent('sendPlayerInfo', resourceRoot, data.offerData.from, 1)
        exports['since-notifications']:sendNotification('error', 'Nie zaakceptowano oferty gracza #f2ff42'..getPlayerName(data.offerData.from)..'#ffffff na czas.')

        data.offerData = {}
        showCursor(false)
        setElementData(localPlayer, 'player:offerGUI', false)
    end
end

function offerClick(btn, state)
    if btn == 'left' and state == 'down' then
        if isMouseInPosition(sx/2 - 256/zoom, sy/2 + 56/zoom, 251/zoom, 35/zoom) then
            removeEventHandler('onClientRender', root, renderOffer)
            removeEventHandler('onClientClick', root, offerClick)
            
            triggerServerEvent('sendPlayerInfo', resourceRoot, data.offerData.from, 2)

            data.offerData = {}
            showCursor(false)
            setElementData(localPlayer, 'player:offerGUI', false)
        end

        if isMouseInPosition(sx/2 + 5/zoom, sy/2 + 55/zoom, 251/zoom, 35/zoom) then
            removeEventHandler('onClientRender', root, renderOffer)
            removeEventHandler('onClientClick', root, offerClick)
            
            triggerServerEvent('acceptGieldaOffer', resourceRoot, localPlayer, data.offerData)

            data.offerData = {}
            showCursor(false)
            setElementData(localPlayer, 'player:offerGUI', false)
        end
    end
end

addEvent('showPlayerGieldaOffer',true)
addEventHandler('showPlayerGieldaOffer', root, function(tbl)
    if getElementData(localPlayer, 'player:offerGUI') then 
        return 
    end

    data.offerData = {}
    data.offerData = tbl

    if data.actualWindow ~= nil then
        toggleUI(false)
    end

    data.tick = getTickCount()
    
    showCursor(true)
    addEventHandler('onClientRender', root, renderOffer)
    addEventHandler('onClientClick', root, offerClick)
    setElementData(localPlayer, 'player:offerGUI', true)
end)

function renderSelling()
    exports['since-blur']:dxDrawBlur(sx/2 - 250/zoom, sy/2 - 316/zoom, 497/zoom, 632/zoom, textures.maskSelling)
	dxDrawImage(sx/2 - 250/zoom, sy/2 - 316/zoom, 497/zoom, 632/zoom, 'data/selling/bg.png')
	dxDrawText('Sprzedaż pojazdu', sx/2, sy/2 - 270/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Wybierz pojazd i wpisz kwote', sx/2, sy/2 - 270/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
    
    local isIn = isMouseInPosition(sx/2 - 151/zoom, sy/2 + 265/zoom, 299/zoom, 35/zoom)
	dxDrawImage(sx/2 - 151/zoom, sy/2 + 265/zoom, 299/zoom, 35/zoom, 'data/selling/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Anuluj transakcje', sx/2, sy/2 + 282/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

    local isIn = isMouseInPosition(sx/2 + 43/zoom, sy/2 + 199/zoom, 167/zoom, 44/zoom)
	dxDrawImage(sx/2 + 43/zoom, sy/2 + 199/zoom, 167/zoom, 44/zoom, 'data/selling/button_offer.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Wyślij ofertę', sx/2 + 126/zoom, sy/2 + 221/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')


    local offset = 0
    for i, v in ipairs(data.vehicles) do
        if i >= k and i <= n then 
            if (not v.loadedData) then
                v.loadedData = loadstring(v.data)()
            end

            if (not v.fuelData) then
                v.fuelData = loadstring(v.fuel)()
            end

            dxDrawImage(sx/2 - 214/zoom, sy/2 - 235/zoom + offset, 427/zoom, 80/zoom, data.selectedVehicle == i and 'data/selling/list_bg_selected.png' or 'data/selling/list_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawText(exports['since-vehiclenames']:getVehicleName(v.model), sx/2 - 196/zoom, sy/2 - 196/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            dxDrawImage(sx/2 - 195/zoom, sy/2 - 191/zoom + offset, 18/zoom, 18/zoom, 'data/selling/tank.png')
            dxDrawText(math.floor(v.fuelData.count)..'%', sx/2 - 170/zoom, sy/2 - 181/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')
            dxDrawImage(sx/2 - 124/zoom, sy/2 - 192/zoom + offset, 20/zoom, 20/zoom, 'data/selling/mileage.png')
            dxDrawText(string.format("%.2f", v.loadedData.mileage)..' km', sx/2 - 98/zoom, sy/2 - 181/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')

            local textWidth = dxGetTextWidth(exports['since-vehiclenames']:getVehicleName(v.model), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom) )
            local textWidth2 = dxGetTextWidth(v.id, 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom) ) + 15/zoom
            dxDrawRoundedRectangle(sx/2 - 200/zoom + 10/zoom + textWidth, sy/2 - 217/zoom + offset, textWidth2, 20/zoom, 10/zoom, tocolor(148, 255, 139, 100))
            dxDrawText(v.id, sx/2 - 200/zoom + 11/zoom + textWidth + textWidth2/2, sy/2 - 206/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'center', 'center')

            local isIn = isMouseInPosition(sx/2 + 105/zoom, sy/2 - 210/zoom + offset, 88/zoom, 30/zoom)
            dxDrawImage(sx/2 + 105/zoom, sy/2 - 210/zoom + offset, 88/zoom, 30/zoom, data.selectedVehicle == i and 'data/selling/button_selected.png' or 'data/selling/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
            dxDrawText(data.selectedVehicle == i and 'Wybrano' or 'Wybierz', sx/2 + 149/zoom + 1, sy/2 - 195/zoom + offset + 1, nil, nil, tocolor(0, 0, 0, isIn and 55 or 75), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
            dxDrawText(data.selectedVehicle == i and 'Wybrano' or 'Wybierz', sx/2 + 149/zoom, sy/2 - 195/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 175 or 225), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
            
            offset = offset + 80/zoom + 3
        end
    end

    if #data.vehicles > 5 then
        drawScrollbar(data.vehicles, sx/2 + 220/zoom, sy/2 - 235/zoom, 2, 410/zoom, m, k, 155)
    end
end

function renderChoose()
    exports['since-blur']:dxDrawBlur(sx/2 - 165/zoom, sy/2 - 162/zoom, 329/zoom, 324/zoom, textures.maskChoose)
	dxDrawImage(sx/2 - 165/zoom, sy/2 - 162/zoom, 329/zoom, 324/zoom, 'data/choose/bg.png')
	dxDrawText('Sprzedaż pojazdu', sx/2, sy/2 - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Wybierz gracza z listy', sx/2, sy/2 - 114/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'center', 'top')

    local isIn = isMouseInPosition(sx/2 - 150/zoom, sy/2 + 111/zoom, 300/zoom, 35/zoom)
	dxDrawImage(sx/2 - 150/zoom, sy/2 + 111/zoom, 300/zoom, 35/zoom, 'data/choose/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Anuluj', sx/2, sy/2 + 128/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

    local offset = 0
    for i, v in ipairs(players) do
        if i >= k1 and i <= n1 then 
            dxDrawImage(sx/2 - 151/zoom, sy/2 - 83/zoom + offset, 301/zoom, 34/zoom, 'data/choose/list.png')
            dxDrawText(getPlayerName(v), sx/2 - 141/zoom, sy/2 - 66/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')

            local isIn = isMouseInPosition(sx/2 + 124/zoom, sy/2 - 76/zoom + offset, 20/zoom, 20/zoom)
            dxDrawImage(sx/2 + 124/zoom, sy/2 - 76/zoom + offset, 20/zoom, 20/zoom, 'data/choose/button_add.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 155))
            dxDrawImage(sx/2 + 128/zoom, sy/2 - 72/zoom + offset, 12/zoom, 12/zoom, 'data/choose/add.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 225 or 185))

            offset = offset + 34/zoom + 2
        end
    end
    
    if #players <= 0 then
        dxDrawText('Brak graczy w strefie handlu', sx/2, sy/2, nil, nil, tocolor(255, 255, 255, 155), 1, exports['since-fonts']:getFont('Inter-Regular', 11/zoom), 'center', 'center')
    elseif #players > 5 then
        drawScrollbar(players, sx/2 + 156/zoom, sy/2 - 83/zoom, 2, 177/zoom, m1, k1, 155)
    end
end

function click(btn, state)
    if btn == 'left' and state == 'down' then
        if isMouseInPosition(sx/2 - 150/zoom, sy/2 + 111/zoom, 300/zoom, 35/zoom) and data.actualWindow == 1 then
            toggleUI(false)
        end

        if isMouseInPosition(sx/2 - 151/zoom, sy/2 + 265/zoom, 299/zoom, 35/zoom) and data.actualWindow == 2 then
            toggleUI(false)
        end

        if isMouseInPosition(sx/2 + 43/zoom, sy/2 + 199/zoom, 167/zoom, 44/zoom) and data.actualWindow == 2 then
            local vehCost = exports['since-gui']:getEditboxText(data.uiElements['edit_vehcost'])
            local vehCost = tonumber(vehCost)

            if not vehCost or vehCost < 0 then
                return exports['since-notifications']:sendNotification('error', 'Kwota jest zbyt niska bądź nie została podana')
            end

            if tonumber(vehCost) then
                if not data.selectedVehicle then
                    return exports['since-notifications']:sendNotification('error', 'Nie wybrano pojazdu')
                end

                if not findPlayer(localPlayer, data.selectedPlayer) then
                    toggleUI(false)
                    return exports['since-notifications']:sendNotification('error', 'Wybrany gracz opuścił serwer')
                end

                toggleUI(false)
                triggerServerEvent('sendPlayerGieldaTransaction', resourceRoot, localPlayer, data.selectedPlayer, data.vehicles[data.selectedVehicle], vehCost)
                exports['since-notifications']:sendNotification('success', 'Oferta sprzedaży została wysłana do gracza '..getPlayerName(data.selectedPlayer))
            else
                exports['since-notifications']:sendNotification('error', 'Podana kwota nie jest prawidłowa')
            end
        end

        local offset = 0
        for i, v in ipairs(players) do
            if i >= k1 and i <= n1 then 
                if isMouseInPosition(sx/2 + 124/zoom, sy/2 - 76/zoom + offset, 20/zoom, 20/zoom) and data.actualWindow == 1 then
                    data.selectedPlayer = v
                    removeEventHandler('onClientRender', root, renderChoose)
                    data.actualWindow = 2
                    addEventHandler('onClientRender', root, renderSelling)

                    triggerServerEvent('getPlayerVehicles', resourceRoot, localPlayer)

                    data.uiElements['edit_vehcost'] = exports['since-gui']:createEditbox('Wprowadź kwotę..', sx/2 - 215/zoom, sy/2 + 197/zoom, 253/zoom, 48/zoom, {155, 155, 155}, {
                        alignX = 'left',
                        paddingX = 45/zoom,
                        caretColor = {255, 255, 255, 100},
                        caretWidth = 1,
                        font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
                        image = textures.editbox,
                        placeholderColor = {155, 155, 155},
                        specialCharacters = '.*[_].*',
                        passworded = false,
                        caretHeight = 18/zoom,
                        icon = textures.iconMoney,
                        iconPadding = 13/zoom,
                        textColor = {255, 255, 255, 200},
                    })
                end
                offset = offset + 34/zoom + 2
            end
        end

        local offset = 0
        for i, v in ipairs(data.vehicles) do
            if i >= k and i <= n then 
                
                if isMouseInPosition(sx/2 + 105/zoom, sy/2 - 210/zoom + offset, 88/zoom, 30/zoom) and data.actualWindow == 2 then
                    local vehicleDataCustom = loadstring(v.data)()

                    if vehicleDataCustom['non_transferable'] then
                        exports['since-notifications']:sendNotification('error', 'Nie możesz sprzedać tego pojazdu.')
                    else
                        data.selectedVehicle = i
                    end
                end

                offset = offset + 80/zoom + 3
            end
        end
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderChoose)
    eventCallback('onClientClick', root, click)
    showCursor(visible)

    if visible then
        data.selectedPlayer = nil
        data.selectedVehicle = nil
        data.actualWindow = 1
        players = getShapePlayers(getElementData(source, 'marker:shape'))
    elseif visible == false then
        if data.actualWindow == 2 then
            removeEventHandler('onClientRender', root, renderSelling)

            if (data.uiElements['edit_vehcost']) then
                exports['since-gui']:destroyUIElement(data.uiElements['edit_vehcost'])
            end
        end
        data.actualWindow = nil
        guiSetInputEnabled(false)
        setElementData(localPlayer, 'player:tradeGUI', false)
    end
end

function getElementsWithinMarker(marker)
	if (not isElement(marker) or getElementType(marker) ~= "marker") then
		return false
	end
	local markerColShape = getElementColShape(marker)
	local elements = getElementsWithinColShape(markerColShape)
    
	return elements
end

function startScript()
    for i, v in ipairs(tradePoints) do
        table.insert(octagons, {unpack(v)})

        local marker = createMarker(v[1], v[2], v[3], 'cylinder', 1.2, 255, 255, 255, 0)
        local marker2 = createMarker(v[1], v[2], v[3] - 0.8, 'cylinder', 4, 255, 255, 255, 0)
        local shape = createColSphere(v[1], v[2], v[3] - 0.5, v[8] or 2.5)
        setElementData(marker, 'marker:visible', true)
        setElementData(marker2, 'marker:down', true)
        setElementData(marker, 'marker:shape', shape)
        setElementData(marker2, 'marker:title', '#7dff7dPunkt sprzedaży')
        setElementData(marker2, 'marker:desc', 'Sprzedaz pojazdu')
        setElementData(marker2, 'marker:icon', false)

        addEventHandler('onClientMarkerHit', marker, function(el, md)
            if el ~= localPlayer or not md then 
                return 
            end
            
            if getPedOccupiedVehicle(localPlayer) then
                return
            end

            toggleUI(true)
            setElementData(localPlayer, 'player:tradeGUI', true)
        end)

        addEventHandler('onClientMarkerLeave', marker, function(el, md)
            if el ~= localPlayer then 
                return 
            end

            toggleUI(false)
        end)
    end

    setElementData(localPlayer, 'player:tradeGUI', false)
    setElementData(localPlayer, 'player:offerGUI', false)
end
addEventHandler("onClientResourceStart", resourceRoot, startScript)

setDevelopmentMode( true )

bindKey("mouse_wheel_down", "both", function()
    if data.actualWindow == 2 then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if data.actualWindow == 2 then
        scrollDown()
    end
end)

function scrollDown()
    if n == m then return end
    k = k-1
    n = n-1
end

function scrollUp()
    if n >= #data.vehicles then return end
    k = k+1
    n = n+1
end

bindKey("mouse_wheel_down", "both", function()
    if data.actualWindow == 1 then
        scrollUp2()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if data.actualWindow == 1 then
        scrollDown2()
    end
end)

function scrollDown2()
    if n1 == m1 then return end
    k1 = k1-1
    n1 = n1-1
end

function scrollUp2()
    if n1 >= #players then return end
    k1 = k1+1
    n1 = n1+1
end

addEvent('getPlayerVehicles',true)
addEventHandler('getPlayerVehicles', root, function(tbl)
    data.vehicles = tbl
end)

function findPlayer(player, target)
    local online = false

    for i, v in ipairs(getElementsByType('player')) do
        if v == target then
            online = true
            break
        end
    end

    return online
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end
getResourceName(getThisResource(), true, 364443741); if true then return end