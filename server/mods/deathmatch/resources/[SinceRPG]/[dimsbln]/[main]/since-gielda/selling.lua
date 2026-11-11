local markerData = nil
local rt = dxCreateRenderTarget(500, 300, true)

function renedrSellingUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 165/zoom, sy/2 - 162/zoom, 329/zoom, 324/zoom, textures.maskCars)
	dxDrawImage(sx/2 - 165/zoom, sy/2 - 162/zoom, 329/zoom, 324/zoom, 'data/cars/bg.png')
	dxDrawText('Wystawianie pojazdu', sx/2, sy/2 - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Giełda', sx/2, sy/2 - 114/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')

    local isIn = isMouseInPosition(sx/2 - 125/zoom, sy/2 + 57/zoom, 249/zoom, 39/zoom)
	dxDrawImage(sx/2 - 125/zoom, sy/2 + 57/zoom, 249/zoom, 39/zoom, 'data/cars/button_buy.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Wystaw', sx/2, sy/2 + 77/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')
    
    local isIn = isMouseInPosition(sx/2 - 125/zoom, sy/2 + 102/zoom, 249/zoom, 39/zoom)
	dxDrawImage(sx/2 - 125/zoom, sy/2 + 102/zoom, 249/zoom, 39/zoom, 'data/cars/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Anuluj', sx/2, sy/2 + 122/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')
end

function clickSelling(btn, state)
    if btn == 'left' and state == 'down' then
        if isMouseInPosition(sx/2 - 125/zoom, sy/2 + 102/zoom, 249/zoom, 39/zoom) then
            toggleSellingUI(false)
        elseif isMouseInPosition(sx/2 - 125/zoom, sy/2 + 57/zoom, 249/zoom, 39/zoom) then
            local veh = getPedOccupiedVehicle(localPlayer)
            if getElementHealth(veh) < 900 then
                return exports['since-notifications']:sendNotification('error', 'Aby wystawić pojazd napraw go!')
            end

            local vehicleData = getElementData(veh, 'vehicle:data') or {}

            if vehicleData['non_transferable'] then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz wystawić tego pojazdu na giełdę.')
            end

            local vehicleCost = tonumber(exports['since-gui']:getEditboxText(data.uiElements['edit_veh']))

            if not tonumber(vehicleCost) then
                return exports['since-notifications']:sendNotification('error', 'Cena nie jest poprawna')
            end

            if tonumber(vehicleCost) < 0 then
                return
            end

            if markerData.costs.min <= vehicleCost and vehicleCost <= markerData.costs.max then
                local nego = exports['since-gui']:isCheckboxChecked(data.uiElements['check_nego'])
                local offline = exports['since-gui']:isCheckboxChecked(data.uiElements['check_offline'])
                local result = setVehicleInfo(localPlayer, veh, vehicleCost, nego, offline, true)

                if result then
                    toggleSellingUI(false)
                    return exports['since-notifications']:sendNotification('success', 'Wystawiono pojazd #73beff'..result.name..'#ffffff za cenę #7aff73$ '..vehicleCost)
                else
                    return exports['since-notifications']:sendNotification('error', 'Wystąpił błąd podczas wystawiania pojazdu na giełdę')
                end
            else
                return exports['since-notifications']:sendNotification('error', 'Cena pojazdu powinna wynosić od #7aff73$ '..markerData.costs.min..'#ffffff do #7aff73$ '..markerData.costs.max)
            end
        end
    end
end

function toggleSellingUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    if visible then
        data.uiElements['check_nego'] = exports['since-gui']:createCheckbox('Cena podlega negocjacji', sx/2 - 127/zoom, sy/2 - 10/zoom, 18/zoom, 18/zoom, {255, 255, 255, 255}, {
            gap = 6/zoom,
            font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
            textColor = {255, 255, 255, 200},
            hoverColor = {255, 255, 255, 155},
            textHoverColor = {255, 255, 255, 155},
            image = textures.checkbox,
            activeImage = textures.checkbox_active
        })

        data.uiElements['check_offline'] = exports['since-gui']:createCheckbox('Możliwość zakupu offline', sx/2 - 127/zoom, sy/2 + 15/zoom, 18/zoom, 18/zoom, {255, 255, 255, 255}, {
            gap = 6/zoom,
            font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
            textColor = {255, 255, 255, 200},
            hoverColor = {255, 255, 255, 155},
            textHoverColor = {255, 255, 255, 155},
            image = textures.checkbox,
            activeImage = textures.checkbox_active
        })

        data.uiElements['edit_veh'] = exports['since-gui']:createEditbox('Wprowadź kwotę..', sx/2 - 127/zoom, sy/2 - 78/zoom, 253/zoom, 48/zoom, {155, 155, 155}, {
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
    elseif visible == false then
        if data.uiElements['check_nego'] then
            exports['since-gui']:destroyUIElement(data.uiElements['check_nego'])
            data.uiElements['check_nego'] = nil
        end

        if data.uiElements['check_offline'] then
            exports['since-gui']:destroyUIElement(data.uiElements['check_offline'])
            data.uiElements['check_offline'] = nil
        end

        if data.uiElements['edit_veh'] then
            exports['since-gui']:destroyUIElement(data.uiElements['edit_veh'])
            data.uiElements['edit_veh'] = nil
        end

        guiSetInputEnabled(false)
    end

    showCursor(visible)
    eventCallback('onClientRender', root, renedrSellingUI)
    eventCallback('onClientClick', root, clickSelling)
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    toggleSellingUI(false)
end)

function setVehicleInfo(plr, veh, cost, nego, offline, new)
    vehicleDodatki = {}
    vehicleUpgrades = getElementData(veh, "vehicle:upgrades")
    vehicleData = getElementData(veh, "vehicle:data")

    if vehicleUpgrades['lpg'] then
        table.insert(vehicleDodatki, 'Instalacja LPG')
    end

    if vehicleUpgrades['mk1'] then
        table.insert(vehicleDodatki, 'Moduł MK1')
    end

    if vehicleUpgrades['mk2'] then
        table.insert(vehicleDodatki, 'Moduł MK2')
    end

    if vehicleUpgrades['mk3'] then
        table.insert(vehicleDodatki, 'Moduł MK3')
    end

    if vehicleUpgrades['mk4'] then
        table.insert(vehicleDodatki, 'Moduł MK4')
    end

    if vehicleUpgrades['mk5'] then
        table.insert(vehicleDodatki, 'Moduł MK5')
    end

    if vehicleUpgrades['mk6'] then
        table.insert(vehicleDodatki, 'Moduł MK6')
    end

    if vehicleUpgrades['ecu'] then
        table.insert(vehicleDodatki, 'Moduł ECU')
    end

    if vehicleUpgrades['mk2137'] then
        table.insert(vehicleDodatki, 'Papieski boost')
    end

    if vehicleUpgrades['jumpmode'] then
        table.insert(vehicleDodatki, 'Jumpmode')
    end

    if vehicleUpgrades['gz'] then
        table.insert(vehicleDodatki, 'Gwintowane zawieszenie')
    end
    
    if vehicleUpgrades['neon'] then
        table.insert(vehicleDodatki, 'Neony')
    end

    if vehicleUpgrades['abs'] then
        table.insert(vehicleDodatki, 'System ABS')
    end

    if vehicleUpgrades['turbo'] then
        table.insert(vehicleDodatki, 'Turbo')
    end

    if vehicleUpgrades['nitro'] then
        table.insert(vehicleDodatki, 'Nitro')
    end

    if vehicleUpgrades['deluxomode'] then
        table.insert(vehicleDodatki, 'Deluxomode')
    end

    if vehicleUpgrades['hovermode'] then
        table.insert(vehicleDodatki, 'Hovermode')
    end

    if vehicleUpgrades['licznikrgb'] then
        table.insert(vehicleDodatki, 'Licznik RGB')
    end

    if vehicleUpgrades['rgblights'] then
        table.insert(vehicleDodatki, 'Lampy RGB')
    end

    if vehicleUpgrades['neonrgb'] then
        table.insert(vehicleDodatki, 'Neony RGB')
    end

    if vehicleUpgrades['rgbsmoke'] then
        table.insert(vehicleDodatki, 'Dym RGB')
    end

    if vehicleUpgrades['chiptuning'] then
        table.insert(vehicleDodatki, 'Chiptuning')
    end

    if vehicleUpgrades['twinturbo'] then
        table.insert(vehicleDodatki, 'TwinTurbo')
    end

    vehicleTuning = getVehicleUpgrades(veh)

    for i,v in ipairs(vehicleTuning) do
        if v == 1086 then
            table.insert(vehicleDodatki, 'Stereo')
            table.remove(vehicleTuning, i)
        end
    end
    
    if #vehicleDodatki > 0 then
        vehicleDodatki = table.concat(vehicleDodatki,", ")
    else
        vehicleDodatki = "Brak"
    end

    if #vehicleTuning > 0 then
        vehicleTuning = table.concat(vehicleTuning,", ")
    else
        vehicleTuning = "Brak"
    end

    --local sellData = getElementData(veh, "vehicle:gielda")

    if new then
        setElementData(veh, "vehicle:gielda", {price=cost, nick=getPlayerName(plr):gsub("#%x%x%x%x%x%x", ""), vehicleID=getElementData(veh, "vehicle:id"), nego = nego, offline = offline, dodatki=vehicleDodatki, wizu=vehicleTuning, sid=getElementData(plr, "player:sid"), player = plr})
    end

    setVehicleGieldaInfo(veh)

    if getElementData(veh, 'vehicle:gielda') then
        return {name = exports['since-vehiclenames']:getVehicleName(getElementData(veh, 'vehicleID') or getElementModel(veh))}
    else
        return false
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    for i,v in ipairs(getElementsByType('vehicle')) do
        local info = getElementData(v, 'vehicle:gielda')
        if info then
            setVehicleInfo(info.player, v, info.price, info.nego, info.offline)
        end
    end
end)

local avatars = {}

function setVehicleGieldaInfo(veh)
    if not isElement(veh) then return end
    if not getElementData(veh, 'vehicle:gielda') then return end

    local x, y, z = getElementPosition(veh)
    local gieldaInfo = getElementData(veh, "vehicle:gielda")
    dxSetRenderTarget(rt, true)
    dxSetBlendMode('modulate_add')
        dxDrawImage(0, 0, 500, 300, 'data/cars/rtBg.png')

        local vehicleData = getElementData(veh, 'vehicle:data')
        local vehicleUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
        local vehicleID = 'ID: '..getElementData(veh, 'vehicle:id')
        local vehicleModel = getElementData(veh, 'vehicleID') or getElementModel(veh)
        local textWidth = dxGetTextWidth(vehicleID, 1, exports['since-fonts']:getFont('Inter-Black', 18)) + 10
        dxDrawRoundedRectangle(15, 30, textWidth, 44, 5, tocolor(90, 145, 225, 125))
        dxDrawText(vehicleID, 15, 52,  17 + textWidth, nil, tocolor(125, 175, 255, 255), 1, exports['since-fonts']:getFont('Inter-Black', 16), "center", "center")

        local name = exports['since-vehiclenames']:getVehicleName(vehicleModel)
        local carName = vehicleUpgrades['sport'] and name..' Sport' or name
        local engine = string.format("%.1f", vehicleData.engine)

        dxDrawText(carName..' #7dafff'..engine..' dm3', 25 + textWidth, 55, nil, nil, tocolor(255, 255, 255, 255), 1, #name > 15 and exports['since-fonts']:getFont('Inter-ExtraBold', 10) or exports['since-fonts']:getFont('Inter-ExtraBold', 12), "left", "bottom", false, false, false, true)

        local price = gieldaInfo.price
        dxDrawText('$ '..addCommas(price), 25 + textWidth, 55, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10), "left", "top")
        
        if gieldaInfo.nego then
            local textWidth2 = dxGetTextWidth('$ '..addCommas(price), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10))
            dxDrawText('(Do negocjacji)', 30 + textWidth + textWidth2, 55, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 10), "left", "top")
        end
        
        local nick = gieldaInfo.nick
        local playerOnline = findPlayerOnline(gieldaInfo.sid)
        
        if gieldaInfo.sid then
            dxDrawImage(500 - 60, 30, 44, 44, exports['since-avatars']:getPlayerAvatar(gieldaInfo.sid))
        end
        
        dxDrawText(nick, 500 - 67, 55, nil, nil, tocolor(255,255,255), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 10), "right", "bottom", false, false, false, true)
        dxDrawText(playerOnline and '● #ffffffDostępny' or '● #ffffffNiedostępny', 500 - 67, 55, nil, nil, playerOnline and tocolor(125,255,125) or tocolor(255, 125, 125), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9), "right", "top", false, false, false, true)

        dxDrawRectangle(15, 96, 470, 1, tocolor(255, 255, 255, 100))
        
        dxDrawText('Tuning wizualny', 15, 125, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11), "left", "bottom")
        dxDrawText(gieldaInfo.wizu, 15, 125, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9), "left", "top")
        
        dxDrawText('Dodatki', 15, 165, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11), "left", "bottom")
        dxDrawText(gieldaInfo.dodatki, 15, 165, 470, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9), "left", "top", false, true)

        --dxDrawText('Kolory', 15, 220, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11), "left", "bottom")
        local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor(veh, true)
        local hr, hg, hb = getVehicleHeadLightColor(veh)
        local brakesColor = vehicleUpgrades['brakesColor'] or {255, 255, 255}
        local tintColor = vehicleUpgrades['tintcolor'] or {0, 0, 0}
        local tintLevel = getElementData(veh, 'vehicle:carTint') or 0

        if tintColor[1] == 0 and tintColor[2] == 0 and tintColor[3] == 0 then
            tintText = 'Szyby: #2E756F'..tintLevel..' %#ffffff'
        else
            tintText = 'Szyby: '..RGBToHex(tintColor[1], tintColor[2], tintColor[3])..'██#ffffff'
        end
      

        dxDrawText('Karoseria: '..RGBToHex(r1, g1, b1)..'██#ffffff / '..RGBToHex(r2, g2, b2)..'██#ffffff, Felgi: '..RGBToHex(r3, g3, b3)..'██#ffffff, Ranty: '..RGBToHex(r4, g4, b4)..'██#ffffff, Światła: '..RGBToHex(hr, hg, hb)..'██#ffffff, Tarcze hamulcowe: '..RGBToHex(brakesColor[1], brakesColor[2], brakesColor[3])..'██#ffffff, '..tintText, 15, 230, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7), "left", "top", false, false, false, true)

        if gieldaInfo.offline and playerOnline then
            dxDrawText('Zakup offline jest niedostępny', 250, 265, nil, nil, tocolor(255, 125, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10), "center", "bottom", false, false, false, true)
            dxDrawText('Aby móc skorzystać z tej opcji sprzedający musi być offline', 250, 265, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9), "center", "top", false, false, false, true)
        else
            if gieldaInfo.offline then
                dxDrawText('Zakup offline jest dostępny', 250, 265, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10), "center", "bottom", false, false, false, true)
                dxDrawText('Zakup offline dostępny, kliknij #7dafffK#ffffff aby zakupic pojazd!', 250, 265, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9), "center", "top", false, false, false, true)
            else
                dxDrawText('Zakup offline jest niedostępny', 250, 265, nil, nil, tocolor(255, 125, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10), "center", "bottom", false, false, false, true)
                dxDrawText('Napisz prywatną wiadomośc do właściciela pojazdu gdy będzie dostępny', 250, 265, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9), "center", "top", false, false, false, true)
            end
        end
        
        dxSetBlendMode('blend')
    dxSetRenderTarget()
end

function handleRestore( didClearRenderTargets )
    local veh = getNearestGieldaCar()
    if not veh then 
        return 
    end

    if getElementData(veh, 'vehicle:gielda') then
        setVehicleGieldaInfo(veh)
    end
end
addEventHandler("onClientRestore",root,handleRestore)

local save = nil

function getGieldaShape()
    local x, y, z = getElementPosition(localPlayer)
    local shapes = getElementsByType('colshape', resourceRoot)

    for i,v in ipairs(shapes) do
        if isElementWithinColShape(localPlayer, v) then
            return v
        end
    end

    return false
end

addEventHandler("onClientRender", root, function()
    local veh = getNearestGieldaCar()

    if not getGieldaShape() then
        return
    end
    
    if not veh then 
        return 
    end

    if save ~= veh then
        save = veh
        setVehicleGieldaInfo(veh)
    end

    local _, _, _, bx, by, bz = getElementBoundingBox(veh)
    local x, y, z = getPositionFromElementOffset(veh, 0, by + 0.1, 1.1)
    local lx, ly, lz = getPositionFromElementOffset(veh, 0, 5, 0)
    dxDrawMaterialLine3D(x, y, z + 0.35, x, y, z-0.75, rt, 2, tocolor(255,255,255,255), false, lx, ly, lz)
end)

function findPlayerOnline(sid)
    for i,v in ipairs(getElementsByType("player")) do
        if sid == getElementData(v, "player:sid") then
            return true
        end
    end

    return false
end

function findPlayerOnlineAndGetHim(sid)
    for i,v in ipairs(getElementsByType("player")) do
        if sid == getElementData(v, "player:sid") then
            return v
        end
    end

    return false
end

stages = 0

bindKey("K", "down", function()
    local veh = getNearestGieldaCar()

    if not veh then 
        return
    end

    if not getElementData(veh, 'vehicle:gielda').offline then
        return 
    end

    if getElementData(veh, 'vehicle:owner') == getElementData(localPlayer, 'player:sid') then
        return 
    end

    local playerOnline = findPlayerOnline(getElementData(veh, 'vehicle:gielda').sid)
    if getElementData(veh, 'vehicle:gielda').offline and playerOnline then
        return
    end
    
    stages = stages + 1

    if stages == 1 then
        exports["since-notifications"]:sendNotification("info", "Kliknij klawisz ponownie aby zakupić pojazd")
        setTimer(function()
            stages = 0
        end, 1000, 1)
    elseif stages >= 2 then
        triggerServerEvent("buyGieldaOfflineCar", resourceRoot, veh)
    end
end)

function getNearestGieldaCar()
    local x, y, z = getElementPosition(localPlayer)
    local nearest = {false, math.huge}
    for k,v in pairs(getElementsWithinRange(x, y, z, 5, "vehicle")) do
        if getElementData(v, "vehicle:gielda") then
            local dist = getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(v)))
            if dist < nearest[2] then
                nearest = {v, dist}
            end
        end
    end

    return nearest[1]
end

function startScript()
    local count = 0
    for i,v in ipairs(positions) do
        if (not v.marker) then
            count = count + 1
            local x, y, z = unpack(v.selling)
            local sellingMarker = createMarker(x, y, z - 1, 'cylinder', 4, 125, 255, 125)
            setElementData(sellingMarker, 'marker:title', 'Giełda')
            setElementData(sellingMarker, 'marker:desc', 'Wystawianie pojazdu\n#ffcc4d($ '..addCommas(v.costs[1])..' - $ '..addCommas(v.costs[2])..')')
            setElementData(sellingMarker, 'marker:icon', 'salon')
            setElementData(sellingMarker, 'marker:gieldaData', {

                costs = {min = v.costs[1], max = v.costs[2]},
                name = v.name,

            })

            for i, v in ipairs(getElementsByType('vehicle')) do
                if getElementData(v, 'vehicle:gielda') then
                    setVehicleGieldaInfo(v)
                end
            end
        
            addEventHandler('onClientMarkerHit', sellingMarker, function(el, md)
                if el ~= localPlayer or not md then return end

                local veh = getPedOccupiedVehicle(localPlayer)
                markerData = getElementData(source, 'marker:gieldaData')

                if veh then
                    if getElementData(veh, 'vehicle:owner') and getElementData(veh, 'vehicle:owner') == getElementData(localPlayer, 'player:sid') then
                        toggleSellingUI(true)
                    else
                        return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem tego pojazdu')
                    end
                end
            end)

            addEventHandler('onClientMarkerLeave', sellingMarker, function(el, md)
                if el ~= localPlayer or not md then return end

                toggleSellingUI(false)
            end)

            v.marker = sellingMarker
        end
    end

    if (count < #positions) then
        setTimer(startScript, 2000, 1)
    end
end

setTimer(startScript, 2000, 1)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

addEventHandler('onClientColShapeLeave', resourceRoot, function(el, md)
    if el ~= localPlayer or not md then return end
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh then
        setElementData(veh, 'vehicle:gielda', nil)
    end
end)
getResourceName(getThisResource(), true, 106288582); if true then return end