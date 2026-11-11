local main = {
    ['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
        [3] = exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom),
    },
    ['pos'] = nil,
    ['textures'] = nil,
    ['elements'] = {},
}

function getVehicleFromDFT(dft)
    local veh = getElementData(dft, "vehicle:loaded:laweta")

    if veh then
        return veh
    end
end

function render2()
    local veh = getVehicleFromDFT(getPedOccupiedVehicle(localPlayer))
    if not isPedInVehicle(localPlayer) or not veh or getDistanceBetweenPoints3D(main['pos'][1], main['pos'][2], main['pos'][3], getElementPosition(getPedOccupiedVehicle(localPlayer))) > 7 then
        turnPanel(false)
        return
    end
    
    exports['since-blur']:dxDrawBlur(sx/2-390/2/zoom, sy/2-304/2/zoom, 390/zoom, 304/zoom, main['textures']['bg_mask'])
    dxDrawImage(sx/2-390/2/zoom, sy/2-304/2/zoom, 390/zoom, 304/zoom, main['textures']['bg'], 0, 0, 0, tocolor(255, 255, 255, 255), false)

    local isIn = isMouseInPosition(sx/2+155/zoom, sy/2-304/2/zoom+20/zoom, 20/zoom, 20/zoom)
    dxDrawImage(sx/2+155/zoom, sy/2-304/2/zoom+20/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0, 0, 0, tocolor(255, 255, 255, isIn and 195 or 255), false)

    dxDrawText('Parking policyjny', sx/2, sy/2 - 118/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][1], 'center', 'bottom')
	dxDrawText('Oddawanie pojazdów', sx/2, sy/2 - 118/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, main['fonts'][2], 'center', 'top')
    
    local mileage = getElementData(veh, 'vehicle:data') and getElementData(veh, 'vehicle:data').mileage or 0
    local model = getElementData(veh, 'vehicle:model')

    dxDrawText('Informacje o pojeździe', sx/2, sy/2-75/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, main['fonts'][3], 'center', 'center')
    dxDrawText('Model', sx/2, sy/2-58/zoom, nil, nil, tocolor(183, 183, 183, 255), 1, main['fonts'][4], 'center', 'center')
    dxDrawText(exports['since-vehiclenames']:getVehicleName(model), sx/2, sy/2-40/zoom, nil, nil, tocolor(183, 183, 183, 255), 1, main['fonts'][1], 'center', 'center')
    dxDrawText('Przebieg', sx/2, sy/2-20/zoom, nil, nil, tocolor(183, 183, 183, 255), 1, main['fonts'][4], 'center', 'center')
    dxDrawText(formatNumber(math.floor(mileage))..' km', sx/2, sy/2, nil, nil, tocolor(183, 183, 183, 255), 1, main['fonts'][1], 'center', 'center')
    dxDrawText('Pamiętaj, aby przestrzegać się taryfikatora. Nadawanie wyższych kwot będzie karane!', sx/2-190/zoom, sy/2+27/zoom, sx/2+190/zoom, nil, tocolor(183, 183, 183, 255), 1, main['fonts'][4], 'center', 'center', false, true)

    local isIn = isMouseInPosition(sx/2+70/zoom, sy/2+48/zoom, 115/zoom, 44/zoom)
    dxDrawImage(sx/2+70/zoom, sy/2+48/zoom, 115/zoom, 44/zoom, main['textures']['button'], 0, 0, 0, tocolor(255, 255, 255, isIn and 195 or 255), false)
    dxDrawText('Oddaj pojazd', sx/2+70/zoom, sy/2+48/zoom, sx/2+70/zoom+115/zoom, sy/2+48/zoom+44/zoom, tocolor(255, 255, 255, isIn and 195 or 255), 1, main['fonts'][2], 'center', 'center')
end

function click2(button, state)
    if not main['pos'] then return end
    if button == 'left' and state == 'down' then
        if isMouseInPosition(sx/2+155/zoom, sy/2-304/2/zoom+20/zoom, 20/zoom, 20/zoom) then
            turnPanel(false)
            showCursor(false)
        elseif isMouseInPosition(sx/2+70/zoom, sy/2+48/zoom, 115/zoom, 44/zoom) then
            local vehicle = getVehicleFromDFT(getPedOccupiedVehicle(localPlayer))
            local money = exports['since-gui']:getEditboxText(main['elements'][1])
            local reason = exports['since-gui']:getEditboxText(main['elements'][2])
            if vehicle and #money > 0 and #reason > 0 then
                money = tonumber(money)
                if money then
                    triggerServerEvent('since-policeparking:returnVehicle', resourceRoot, vehicle, money, reason)
                else
                    outputChatBox('❌ #FFFFFFMusisz podać kwotę!', 255, 55, 55, true)
                end
            else
                outputChatBox('❌ #FFFFFFMusisz podać kwotę i powód zarekwirowania pojazdu!', 255, 55, 55, true)
            end
        end
    end
end

function findVehicleAttachedToElement(veh)
    if not veh then return end
    local attached = getAttachedElements(veh)
    for i,v in ipairs(attached) do
        if getElementType(v) == 'vehicle' then
            return v
        end
    end
end

function turnPanel(state)
    if state then
        if isEventHandlerAdded("onClientRender", root, render2) then return end
        main['textures'] = {}
        for i,v in ipairs({'bg','bg_mask','button','editbox1','editbox2','money','mail','close'}) do
            if fileExists("data/returning/"..v..".png") then
                main['textures'][v] = dxCreateTexture("data/returning/"..v..".png")
            end
        end
        addEventHandler("onClientRender", root, render2)
        addEventHandler("onClientClick", root, click2)

        main['elements'][1] = exports['since-gui']:createEditbox('Wprowadź kwotę...', sx/2-185/zoom, sy/2+48/zoom, 250/zoom, 44/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 45/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = main['textures']['editbox1'],
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
			caretHeight = 18/zoom,
			icon = main['textures']['money'],
			iconPadding = 11/zoom,
			textColor = {255, 255, 255, 200},
        })

        main['elements'][2] = exports['since-gui']:createEditbox('Wprowadź powód zarekwirowania pojazdu...', sx/2-185/zoom, sy/2+100/zoom, 370/zoom, 44/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 45/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
            image = main['textures']['editbox1'],
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
			caretHeight = 18/zoom,
			icon = main['textures']['mail'],
			iconPadding = 11/zoom,
            space = true,
			textColor = {255, 255, 255, 200},
            maxChars = 40,
        })

        showCursor(true)
        local veh = getPedOccupiedVehicle(localPlayer)
        if not veh then return end
        setElementFrozen(veh, true)
        main['pos'] = {getElementPosition(veh)}
    else
        if not isEventHandlerAdded("onClientRender", root, render2) then return end
        if main['elements'] then
            for i,v in ipairs(main['elements']) do
                exports['since-gui']:destroyUIElement(v)
            end
        end

        removeEventHandler("onClientClick", root, click2)
        removeEventHandler("onClientRender", root, render2)
        showCursor(false)
        for i,v in pairs(main['textures']) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        main['textures'] = nil
        main['pos'] = nil
        local veh = getPedOccupiedVehicle(localPlayer)
        if not veh then return end
        setElementFrozen(veh, false)
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if main['elements'] then
        for i,v in ipairs(main['elements']) do
            exports['since-gui']:destroyUIElement(v)
        end
    end
end)

showCursor(false)