local fuelData = {

    toTank = 0,
    benzCost = math.random(650, 1250),
    lpgCost = math.random(400, 600),
    --benzCost = 0,
    --lpgCost = 0,
    tankSpeed = 0.01,
    selected = 'PB',

}
fuelData.benzCost = 0
fuelData.lpgCost = 0

function renderUI()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh and getElementData(veh, 'vehicle:id') then
        local fuel = getElementData(veh, 'vehicle:fuel') or {}

        exports['since-blur']:dxDrawBlur(sx/2 - 276/zoom, sy - 310/zoom, 553/zoom, 146/zoom, textures.mask)
        dxDrawImage(sx/2 - 276/zoom, sy - 310/zoom, 553/zoom, 146/zoom, 'data/bg.png')
        dxDrawImage(sx/2 - 92/zoom, sy - 377/zoom, 184/zoom, 64/zoom, 'data/logo.png')
        dxDrawImage(sx/2 - 263/zoom, sy - 213/zoom, 527/zoom, 33/zoom, 'data/progressbar.png', 0, 0, 0, tocolor(255, 255, 255, 55))

        if fuelData.selected == 'PB' then
            dxDrawImageSection(sx/2 - 263/zoom, sy - 213/zoom, 527/zoom * (fuel.count + fuelData.toTank or 100) / fuel.tank, 33/zoom, 0, 0, 527 * (fuel.count + fuelData.toTank or 100) / fuel.tank, 33, 'data/progressbar.png', 0, 0, 0, tocolor(255, 255, 255, 200))
            dxDrawText((math.floor(fuel.count + fuelData.toTank) or 100)..' / '..(fuel.tank or 100)..' L (Dotankowano: '..math.floor(fuelData.toTank)..' L - $ '..addCommas(math.floor(fuelData.toTank * fuelData.benzCost))..')', sx/2 + 1, sy - 195/zoom + 1, nil, nil, tocolor(0, 0, 0, 100), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'center', 'center')
            dxDrawText((math.floor(fuel.count + fuelData.toTank) or 100)..' / '..(fuel.tank or 100)..' L (Dotankowano: '..math.floor(fuelData.toTank)..' L - $ '..addCommas(math.floor(fuelData.toTank * fuelData.benzCost))..')', sx/2, sy - 195/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'center', 'center')
            dxDrawText('Aby tankować pojazd trzymaj spację\nAby zapłacić $ '..addCommas(math.floor(fuelData.toTank * fuelData.benzCost))..' za paliwo kliknij Enter', sx/2 + 1, sy - 135/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'top', false, false, false, true)
            dxDrawText('Aby tankować pojazd trzymaj spację\nAby zapłacić #88ff82$ '..addCommas(math.floor(fuelData.toTank * fuelData.benzCost))..'#ffffff za paliwo kliknij #82b2ffEnter', sx/2, sy - 135/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'top', false, false, false, true)
        else
            dxDrawImageSection(sx/2 - 263/zoom, sy - 213/zoom, 527/zoom * (fuel.countLPG + fuelData.toTank or 100) / 100, 33/zoom, 0, 0, 527 * (fuel.countLPG + fuelData.toTank or 100) / 100, 33, 'data/progressbar.png', 0, 0, 0, tocolor(255, 255, 255, 200))
            dxDrawText((math.floor(fuel.countLPG + fuelData.toTank) or 100)..' / '..(100)..' L (Dotankowano: '..math.floor(fuelData.toTank)..' L - $ '..addCommas(math.floor(fuelData.toTank * fuelData.lpgCost))..')', sx/2 + 1, sy - 195/zoom + 1, nil, nil, tocolor(0, 0, 0, 100), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'center', 'center')
            dxDrawText((math.floor(fuel.countLPG + fuelData.toTank) or 100)..' / '..(100)..' L (Dotankowano: '..math.floor(fuelData.toTank)..' L - $ '..addCommas(math.floor(fuelData.toTank * fuelData.lpgCost))..')', sx/2, sy - 195/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'center', 'center')
            dxDrawText('Aby tankować pojazd trzymaj spację\nAby zapłacić $ '..addCommas(math.floor(fuelData.toTank * fuelData.lpgCost))..' za paliwo kliknij Enter', sx/2 + 1, sy - 135/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'top', false, false, false, true)
            dxDrawText('Aby tankować pojazd trzymaj spację\nAby zapłacić #88ff82$ '..addCommas(math.floor(fuelData.toTank * fuelData.lpgCost))..'#ffffff za paliwo kliknij #82b2ffEnter', sx/2, sy - 135/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'top', false, false, false, true)
        end

        dxDrawText('Tankowanie', sx/2 + 1, sy - 135/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
        dxDrawText('Tankowanie', sx/2, sy - 135/zoom, nil, nil, tocolor(125, 255, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')

        local isIn = isMouseInPosition(sx/2 - 262/zoom, sy - 296/zoom, 260/zoom, 72/zoom)
        local alpha = isIn and 200 or 255
        dxDrawImage(sx/2 - 262/zoom, sy - 296/zoom, 260/zoom, 72/zoom, fuelData.selected == 'LPG' and 'data/select_selected.png' or 'data/select.png', 0, 0, 0, tocolor(255, 255, 255, fuelData.selected ~= 'LPG' and alpha or 255))
        dxDrawText('LPG', sx/2 - 132/zoom, sy - 255/zoom, nil, nil, tocolor(255, 255, 255, fuelData.selected ~= 'LPG' and alpha or 255), 1, exports['since-fonts']:getFont('Inter-Black', 15/zoom), 'center', 'bottom')
        dxDrawText('$ '..fuelData.lpgCost..' / litr', sx/2 - 132/zoom, sy - 255/zoom, nil, nil, tocolor(127, 255, 116, fuelData.selected ~= 'LPG' and alpha or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
        
        local isIn = isMouseInPosition(sx/2 + 2/zoom, sy - 296/zoom, 260/zoom, 72/zoom)
        local alpha = isIn and 200 or 255
        dxDrawImage(sx/2 + 2/zoom, sy - 296/zoom, 260/zoom, 72/zoom, fuelData.selected == 'PB' and 'data/select_selected.png' or 'data/select.png', 0, 0, 0, tocolor(255, 255, 255, fuelData.selected ~= 'PB' and alpha or 255))
        dxDrawText('Benzyna', sx/2 + 132/zoom, sy - 255/zoom, nil, nil, tocolor(255, 255, 255, fuelData.selected ~= 'PB' and alpha or 255), 1, exports['since-fonts']:getFont('Inter-Black', 15/zoom), 'center', 'bottom')
        dxDrawText('$ '..fuelData.benzCost..' / litr', sx/2 + 132/zoom, sy - 255/zoom, nil, nil, tocolor(127, 255, 116, fuelData.selected ~= 'PB' and alpha or 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')

        if getKeyState( 'space' ) == true then
            fuelData.tankSpeed = math.min(fuelData.tankSpeed + 0.0002, 0.3)
            if fuelData.selected == 'PB' then
                fuelData.toTank = math.min(fuelData.toTank + fuelData.tankSpeed, (fuel.tank or 100) - fuel.count)
            else
                fuelData.toTank = math.min(fuelData.toTank + fuelData.tankSpeed, (100) - fuel.countLPG)
            end
        elseif getKeyState( 'space' ) == false then
            fuelData.tankSpeed = 0.01
        end
    end
end

function onClick(btn,state)
    if (btn == 'left' and state == 'down') then
        local isIn = isMouseInPosition(sx/2 + 2/zoom, sy - 296/zoom, 260/zoom, 72/zoom)
        if isIn then
            fuelData.selected = 'PB'
            fuelData.toTank = 0
            fuelData.tankSpeed = 0
        end
        
        local isIn = isMouseInPosition(sx/2 - 262/zoom, sy - 296/zoom, 260/zoom, 72/zoom)
        if isIn then
            fuelData.selected = 'LPG'
            fuelData.toTank = 0
            fuelData.tankSpeed = 0
        end
    end
end

function payForTank(btn, press)
    if btn == 'enter' and press then
        local veh = getPedOccupiedVehicle(localPlayer)
        local vehData = getElementData(veh, 'vehicle:upgrades')

        if veh and getElementData(veh, 'vehicle:id') then
            local fuel = getElementData(veh, 'vehicle:fuel')
            local money = getPlayerMoney(localPlayer)

            if fuelData.selected == 'PB' then
                if money < fuelData.toTank * fuelData.benzCost then
                    return exports['since-notifications']:sendNotification(localPlayer, 'error', 'Nie posiadasz wystarczającej ilości gotówki!')
                end

                triggerServerEvent('payForTank', resourceRoot, 'PB', fuelData.toTank * fuelData.benzCost, fuel.count + fuelData.toTank)
            elseif fuelData.selected == 'LPG' then
                if not vehData['lpg'] then
                    return
                end
                
                if money < fuelData.toTank * fuelData.lpgCost then
                    return exports['since-notifications']:sendNotification(localPlayer, 'error', 'Nie posiadasz wystarczającej ilości gotówki!')
                end

                triggerServerEvent('payForTank', resourceRoot, 'LPG', fuelData.toTank * fuelData.lpgCost, fuel.countLPG + fuelData.toTank)
            end
    
            toggleUI(false)
        end
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
    eventCallback('onClientKey', root, payForTank)
    showCursor(visible, false)

    local data = getElementData(localPlayer, 'player:data') or {}

    if data['visualRank'] == 'Sponsor' then
        fuelData.benzCost = 0
        fuelData.lpgCost = 0
    end

    fuelData.toTank = 0
    fuelData.tankSpeed = 0
    fuelData.selected = 'PB'

    setTimer(function()
        setElementData(localPlayer, 'player:blockVehicle', visible)
    end, 100, 1)
end
setElementData(localPlayer, 'player:blockVehicle', false)

function startScript()
    for i,v in ipairs(blips) do
        createBlip(v[1], v[2], v[3], 56, 2, 255, 255, 255, 255, 0, 450)
    end
    for i, v in ipairs(positions) do
        local markerTank = createMarker(v[1], v[2], v[3] - 1, 'cylinder', 3, 125, 255, 125, 0)
        
        setElementData(markerTank, 'marker:id', i)
        setElementData(markerTank, 'marker:title', 'SinceTank')
        setElementData(markerTank, 'marker:desc', 'Zatankuj swój pojazd')
        setElementData(markerTank, 'marker:icon', 'tank')

        addEventHandler('onClientMarkerHit', markerTank, function(el, md)
            if el ~= localPlayer or not md then return end

            local veh = getPedOccupiedVehicle(el)
            local upgrades = getElementData(veh, 'vehicle:upgrades') or {}

            if veh then
                if upgrades['electric'] then
                    return exports['since-notifications']:sendNotification('error', 'Ten pojazd jest elektryczny!')
                end

                toggleUI(true)
            end
        end)

        addEventHandler('onClientMarkerLeave', markerTank, function(el, md)
            if el ~= localPlayer or not md then return end

            toggleUI(false)
        end)
    end
end
addEventHandler('onClientResourceStart', resourceRoot, startScript)
getResourceName(getThisResource(), true, 564629854); if true then return end