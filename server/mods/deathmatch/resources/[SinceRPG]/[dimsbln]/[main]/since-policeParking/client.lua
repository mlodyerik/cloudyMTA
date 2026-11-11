sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local object = false
zoom = zoom * 0.9

main = {
    ['textures'] = {},
    ['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Light', 14/zoom),
        [3] = exports['since-fonts']:getFont('Inter-Bold', 11/zoom),
        [4] = exports['since-fonts']:getFont('Inter-Regular', 9/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Bold', 9/zoom),
        [6] = exports['since-fonts']:getFont('Inter-Regular', 8/zoom)
    },
    ['positions'] = {

        { -- ls
            take = {1612.91, -1559.41, 14.17},
            spawn = {1617.96, -1553.07, 13.25, 0, 0, 0},
            ret = {1607.86, -1554.23, 12.5},
            teleport = {1612.63, -1554.38, 13.58},
            previewObject = {147.55, -161.57, -8.57},
            matrix = {142.76, -153.57, -8, 147.28, -162.34, -9.74},
            veh = {147.18, -161.71, -10.01, 0.0, 0.0, 0.5},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,['Plane']=true,['Helicopter']=true,['Boat']=true}
        },

        { -- lv
            take = {2316.01, 1801.43, 10.82},
            spawn = {2325.51, 1783.61, 10.54, 359.9, 0.0, 180.0},
            ret = {2310.40, 1794.81, 10.82},
            teleport = {2315.97, 1797.66, 10.82},
            previewObject = {147.55, -161.57, -8.57},
            matrix = {142.76, -153.57, -8, 147.28, -162.34, -9.74},
            veh = {147.18, -161.71, -10.01, 0.0, 0.0, 0.5},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,['Plane']=true,['Helicopter']=true,['Boat']=true}
        },

        { -- bb
            take = {213.18, -183.48, 1.58},
            spawn = {203.31, -175.14, 1.36, 0, 0, 0},
            ret = {196.25, -177.93, 1.58},
            teleport = {212.95, -178.18, 1.58},
            previewObject = {147.55, -161.57, -8.57},
            matrix = {142.76, -153.57, -8, 147.28, -162.34, -9.74},
            veh = {147.18, -161.71, -10.01, 0.0, 0.0, 0.5},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,['Plane']=true,['Helicopter']=true,['Boat']=true}
        },
        
    },

    ['actual'] = false,

    ['points'] = {

        ['oddawanieLS'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {1607.86, -1554.23, 13.5},
            lookingAt = {1607.86, -1550.53, 13.5},
            color = {255, 200, 0},
            color2 = {255, 200, 0},
        },

        ['oddawanieLV'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {2310.42, 1795.78, 10.82},
            lookingAt = {2310.42, 1781.78, 10.82},
            color = {255, 200, 0},
            color2 = {255, 200, 0},
        },

        ['oddawanieBB'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {196.15, -177.93, 1.58},
            lookingAt = {196.32, -165.83, 1.58},
            color = {255, 200, 0},
            color2 = {255, 200, 0},
        },

    },

    ['vehicles'] = {},
    ['savedVehicles'] = {},
    ['nickTable'] = {},
    ['category'] = 1,
}

local k = 1
local n = 4
local m = 4

local selectedVehicle = nil
local uiElements = {}

local keyBlockR = nil
local keyBlockL = nil

function render()
    exports['since-blur']:dxDrawBlur(sx - 500/zoom, sy/2 - 235/zoom, 454/zoom, 486/zoom, main.textures['mask'])
	dxDrawImage(sx - 500/zoom, sy/2 - 235/zoom, 454/zoom, 486/zoom, main.textures.background)

    local isIn = isMouseInPosition(sx - 82/zoom, sy/2 - 211/zoom, 20/zoom, 20/zoom)
	dxDrawImage(sx - 82/zoom, sy/2 - 211/zoom, 20/zoom, 20/zoom, main.textures.close, 0, 0, 0, tocolor(255, 255, 255, isIn and 185 or 255))

    main['vehicles'] = getVehicles(main['savedVehicles'], uiElements['edit_parking'])

    local x = 0
    for i, v in pairs(main['vehicles']) do
        if i >= k and i <= n then 
            if (not v.loadedData) then
                v.loadedData = loadstring(v.data)()
            end

            if (not v.fuelData) then
                v.fuelData = loadstring(v.fuel)()
            end
                
            dxDrawImage(sx - 485/zoom, sy/2 - 161/zoom + x, 423/zoom, 96/zoom, selectedVehicle == i and main.textures.list_bg_selected or main.textures.list_bg)
            dxDrawText(exports['since-vehiclenames']:getVehicleName(v.model), sx - 468/zoom, sy/2 - 128/zoom + x, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')

            local textWidth = dxGetTextWidth( exports['since-vehiclenames']:getVehicleName(v.model), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom) )
            local textWidth2 = dxGetTextWidth( v.id, 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom) ) + 15/zoom
            dxDrawRoundedRectangle(sx - 468/zoom + 10/zoom + textWidth, sy/2 - 149/zoom + x, textWidth2, 20/zoom, 10/zoom, tocolor(148, 255, 139, 100))
            dxDrawText(v.id, sx - 468/zoom + 10/zoom + 1 + textWidth + textWidth2/2, sy/2 - 138/zoom + x - 1, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')

            dxDrawImage(sx - 468/zoom, sy/2 - 122/zoom + x, 18/zoom, 18/zoom, main.textures['returning/money'])
            dxDrawText('Koszt wykupu: #7DFF7D$ '..formatNumber(v.cost), sx - 442/zoom, sy/2 - 113/zoom + x, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center', false, false, false, true)

            dxDrawText('Zobacz więcej informacji', sx - 468/zoom, sy/2 - 86/zoom + x, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center')
            local textWidth = dxGetTextWidth( 'Zobacz więcej informacji', 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom) )

            local isIn = isMouseInPosition(sx - 468/zoom, sy/2 - 98/zoom + x, textWidth, 22/zoom)

            if isIn then
                local cx, cy = getCursorPosition()
                local cx, cy = (cx * sx), (cy * sy)

                dxDrawRoundedRectangle(cx + 10/zoom, cy + 10/zoom, 200/zoom, 88/zoom, 4/zoom, tocolor(65, 65, 65, 245), true)

                dxDrawText('Data: #7DFF7D'..v.date, cx + 15/zoom, cy + 15/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, true, true)
                
                local uid = tonumber(v.byWho)
                if main['nickTable'][uid] then
                    dxDrawText('Pracownik: #7DFF7D'..main['nickTable'][uid], cx + 15/zoom, cy + 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, true, true)
                else
                    dxDrawText('Pracownik: #7DFF7DBłąd', cx + 15/zoom, cy + 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, true, true)
                end

                local reason = v.reason or 'brak'
                reason = reason:sub(1,1):upper()..reason:sub(2)
                dxDrawText('Powód: #7DFF7D'..reason, cx + 15/zoom, cy + 55/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, true, true)

                if (not v.loadedData) then
                    v.loadedData = loadstring(v.data)()
                end

                local lastDriver = v.loadedData.driver or 'Brak'
                dxDrawText('Ostatni kierowca: #7DFF7D'..lastDriver, cx + 15/zoom, cy + 75/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, true, true)
            end

            local isIn = isMouseInPosition(sx - 167/zoom, sy/2 - 128/zoom + x, 88/zoom, 30/zoom)
            dxDrawImage(sx - 167/zoom, sy/2 - 128/zoom + x, 88/zoom, 30/zoom, selectedVehicle == i and main.textures.button_selected or main.textures.button, 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
            dxDrawText(selectedVehicle == i and 'Wykup' or 'Wybierz', sx - 122/zoom + 1, sy/2 - 113/zoom + x + 1, nil, nil, tocolor(0, 0, 0, isIn and 65 or 100), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
            dxDrawText(selectedVehicle == i and 'Wykup' or 'Wybierz', sx - 122/zoom, sy/2 - 113/zoom + x, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')

            x = x + 98/zoom
        end
    end

    local x, y, z = getElementPosition(localPlayer)
    local zoneName = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)

    dxDrawText('Parking policyjny', sx - 278/zoom + 1, sy/2 - 268/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Black', 16/zoom), 'center', 'bottom')
    dxDrawText(zoneName, sx - 278/zoom + 1, sy/2 - 269/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
    dxDrawText('Parking policyjny', sx - 278/zoom, sy/2 - 268/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Black', 16/zoom), 'center', 'bottom')
    dxDrawText(zoneName, sx - 278/zoom, sy/2 - 269/zoom, nil, nil, tocolor(148, 255, 139, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')

    drawScrollbar(main['vehicles'], sx - 55/zoom, sy/2-320/zoom/2, 3/zoom, 391/zoom, m, k, 255)
end

addEvent('since-policeparking:getVehicle', true)
addEventHandler('since-policeparking:getVehicle', root, function (data, nicknames)
    main['nickTable'] = nicknames
    if #data > 0 then
        main['savedVehicles'] = data
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        showCursor(true)
        uiElements['edit_parking'] = exports['since-gui']:createEditbox('Wprowadź model lub ID pojazdu...', sx - 485/zoom, sy/2 - 218/zoom, 265/zoom, 36/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 35/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
            image = main.textures.editbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
			caretHeight = 18/zoom,
			icon = main.textures.search,
			iconPadding = 9/zoom,
			textColor = {255, 255, 255, 200},
        })

        local markerData = main.positions[getElementData(localPlayer, 'player:parkingMarker')]

        if markerData.previewObject then
            object = createObject(1910, unpack(markerData.previewObject))
        end

        setElementDimension(object, getElementData(localPlayer, 'player:sid'))
        setElementData(localPlayer, 'player:hudof', true)
        setElementDimension(localPlayer, getElementData(localPlayer, 'player:sid'))
        local markerData = main.positions[getElementData(localPlayer, 'player:parkingMarker')]
        setCameraMatrix(unpack(markerData.matrix))
        showChat(false)
    else
        return exports['since-notifications']:sendNotification('error', 'Nie posiadasz żadnych pojazdów na parkingu policyjnym.')
    end
end)

local previewVehicle = nil

function createPreviewVehicle(data)
    local markerData = main.positions[getElementData(localPlayer, 'player:parkingMarker')]
    if previewVehicle and isElement(previewVehicle) then
        destroyElement(previewVehicle)
    end

    local position = loadstring((data.position and #data.position > 3) and data.position or "return {}")()
    local color = loadstring((data.color and #data.color > 3) and data.color or "return {}")()
    local headlight = loadstring((data.headlight and #data.headlight > 3) and data.headlight or "return {}")()
    local upgrades = loadstring((data.upgrades and #data.upgrades > 3) and data.upgrades or "return {}")()
    local fuel = loadstring((data.fuel and #data.fuel > 3) and data.fuel or "return {}")()
    local wheelTuning = loadstring((data.wheelTuning and #data.wheelTuning > 3) and data.wheelTuning or "return {}")()
    local data2 = loadstring((data.data and #data.data > 3) and data.data or "return {}")()
    local damages = loadstring((data.damages and #data.damages > 3) and data.damages or "return {}")()
    local variant = loadstring((data.variant and #data.variant > 2) and data.variant or "return {}")()

    local baseModel, isCustom = exports['since-custommodels']:checkModelID(data.model, 'vehicle')
    if isCustom then
        previewVehicle = createVehicle(baseModel, unpack(markerData.veh))
        setElementData(previewVehicle, 'baseID', baseModel)
        setElementData(previewVehicle, 'vehicleID', data.model)
    else
        previewVehicle = createVehicle(data.model,unpack(markerData.veh))
    end
    setElementDimension(previewVehicle, getElementData(localPlayer, 'player:sid'))
    setVehicleColor(previewVehicle, color[1], color[2], color[3], color[4], color[5], color[6], color[7], color[8], color[9], color[10], color[11], color[12])
    setVehicleHeadLightColor(previewVehicle, headlight[1], headlight[2], headlight[3])

    setTimer(function()
        for i = 0, 6 do if damages[i + 1] then setVehiclePanelState(previewVehicle, i, damages[i + 1]) end end
        for i = 0, 1 do if damages[i + 8] then setVehicleLightState(previewVehicle, i, damages[i + 8]) end end
        for i = 0, 5 do if damages[i + 10] then setVehicleDoorState(previewVehicle, i, damages[i + 10]) end end
        setElementHealth(previewVehicle, damages[16] and damages[16] or 1000)
    
        if not variant[1] or variant[1] == 255 then
            variant[1] = 0
        end
        if not variant[2] or variant[2] == 255 then
            variant[2] = 0
        end
    
        setVehicleVariant(previewVehicle, variant[1] or 0, variant[2] or 0)
    
        setElementData(previewVehicle, 'vehicle:upgrades', upgrades)
        setElementData(previewVehicle, 'vehicle:data', data2)
        setElementData(previewVehicle, 'vehicle:wheelTuning', wheelTuning)

        for i,v in ipairs(split(data["tuning"], ",")) do 
            addVehicleUpgrade(previewVehicle, v) 
        end
    end, 100, 1)

    setTimer(function()
        if previewVehicle and isElement(previewVehicle) then
            setElementFrozen(previewVehicle, true)
        end
    end, 1000, 1)
end

function destroyPreviewVehicle()
    if previewVehicle and isElement(previewVehicle) then
        destroyElement(previewVehicle)
    end
end
                    
function click(btn,state)
    if (btn == 'left' and state == 'down') then

        if isMouseInPosition(sx - 82/zoom, sy/2 - 211/zoom, 20/zoom, 20/zoom) then
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, click)
            showCursor(false)
            for i,v in pairs(main['textures']) do
                if (isElement(v)) then
                    destroyElement(v)
                end
            end
            main['actual'] = false
            main['vehicles'] = {}
            main['savedVehicles'] = {}

            if (uiElements['edit_parking']) then
                exports['since-gui']:destroyUIElement(uiElements['edit_parking'])
            end

            if isElement(object) then
                destroyElement(object)
                object = nil
            end

            local markerData = main.positions[getElementData(localPlayer, 'player:parkingMarker')]
            local pos = markerData.teleport
            setElementPosition(localPlayer, pos[1], pos[2], pos[3])
            
            setElementDimension(localPlayer, 0)
            setCameraTarget(localPlayer, localPlayer)
            setElementData(localPlayer, 'player:hudof', false)
            destroyPreviewVehicle()
            showChat(true)
            return
        end

        local x = 0
        for i,v in ipairs(main['vehicles']) do
            if i >= k and i <= n then 
                if isMouseInPosition(sx - 167/zoom, sy/2 - 128/zoom + x, 88/zoom, 30/zoom) and selectedVehicle ~= i then
                    selectedVehicle = i
                    createPreviewVehicle(v)
                elseif isMouseInPosition(sx - 167/zoom, sy/2 - 128/zoom + x, 88/zoom, 30/zoom) and selectedVehicle == i then
                    removeEventHandler('onClientRender', root, render)
                    removeEventHandler('onClientClick', root, click)
                    showCursor(false)
                    for i,v in pairs(main['textures']) do
                        if (isElement(v)) then
                            destroyElement(v)
                        end
                    end

                    triggerServerEvent('since-policeparking:tryTakeVehicle',resourceRoot,v.id,main['positions'][main['actual']].spawn, v.cost)
                    main['actual'] = false
                    main['vehicles'] = {}
                    main['savedVehicles'] = {}

                    if (uiElements['edit_parking']) then
                        exports['since-gui']:destroyUIElement(uiElements['edit_parking'])
                    end

                    if isElement(object) then
                        destroyElement(object)
                        object = nil
                    end

                    local markerData = main.positions[getElementData(localPlayer, 'player:parkingMarker')]
                    local pos = markerData.teleport
                    setElementPosition(localPlayer, pos[1], pos[2], pos[3])

                    setElementDimension(localPlayer, 0)
                    setCameraTarget(localPlayer, localPlayer)
                    setElementData(localPlayer, 'player:hudof', false)
                    destroyPreviewVehicle()
                    showChat(true)
                end
                x = x + 98/zoom
            end
        end
    end
end

for i,v in pairs(main['positions']) do
    v.marker = createMarker(v.take[1], v.take[2], v.take[3]-1, "cylinder", 1.5, 125, 255, 125, 150)
    v.oddaj = createMarker(v.ret[1], v.ret[2], v.ret[3], "cylinder", v.withoutMaterials and 6 or 2, 125, 255, 125, 150)
    setElementData(v.marker,'marker:title','Parking policyjny')
    setElementData(v.marker,'marker:desc','Odbior pojazdow')
    setElementData(v.marker,'marker:icon','parking')

    if not v.withoutMaterials then
        setElementData(v.oddaj,'marker:visible',true)
    else
        setElementData(v.oddaj,'marker:title','Parking policyjny')
        setElementData(v.oddaj,'marker:desc','Oddawanie pojazdów')
        setElementData(v.oddaj,'marker:icon','parking')
    end

    setElementData(v.marker,'marker:parkingid',i)
    v.blip = createBlip(v.take[1], v.take[2], v.take[3], 8, 2, 255, 255, 255, 255, 0, 450)

    addEventHandler('onClientMarkerHit', v.oddaj, function(plr)
        if (plr ~= localPlayer) then return end
        local veh = getPedOccupiedVehicle(plr)
        if not veh then return end
        if getElementModel(veh) == 578 and findVehicleAttachedToElement(veh) and getElementData(plr, 'player:faction') then
            if getElementData(veh, "vehicle:faction") == 'SARA' or getElementData(veh, "vehicle:faction") == 'SAPD' then
                if getVehicleOccupant(veh) ~= plr then
                    return
                end

                turnPanel(true)
            end
        end
    end)

    addEventHandler('onClientMarkerHit', v.marker, function(plr)
        if (plr ~= localPlayer) then return end
        if getPedOccupiedVehicle(localPlayer) then
            return
        end

        local c = {
            ['avatar'] = true,
            ['background'] = true,
            ['button'] = true,
            ['button_selected'] = true,
            ['close'] = true,
            ['editbox'] = true,
            ['left'] = true,
            ['right'] = true,
            ['list_bg'] = true,
            ['list_bg_selected'] = true,
            ['mask'] = true,
            ['search'] = true,
            ['tank'] = true,
            ['time'] = true,
            ['mileage'] = true,
            ['returning/money'] = true,
        }

        for i,v in pairs(c) do
            main['textures'][i] = dxCreateTexture('data/'..i..'.png','argb',false,'clamp')
        end

        local markerData = main.positions[getElementData(source, 'marker:parkingid')]

        main['actual'] = i
        main['vehicles'] = {}
        main['savedVehicles'] = {}
        selectedVehicle = nil
        main['category'] = 1
        triggerServerEvent('since-policeparking:getVehicle', resourceRoot, nil, markerData.types)

        setElementData(localPlayer, 'player:parkingMarker', getElementData(source, 'marker:parkingid'))
    end)
end

local size = 2.5

addEventHandler('onClientRender',root,function ()
    local px, py, pz = getElementPosition(localPlayer)
    for i,v in pairs(main['points']) do
        local x,y,z = unpack(v.groundPos)

        local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

        if dist < 50 then
            local px, py, pz = unpack(v.lookingAt)
            local z = getGroundPosition(x, y, z + 0.5) + 0.01
            local angle = findRotation(px, py, x, y) + 90
            local alphaIcon = interpolateBetween(255, 0, 0, 175, 0, 0, (getTickCount() % 4500) / 4500, 'SineCurve')
            local alphaBorderLine = interpolateBetween(255, 0, 0, 50, 0, 0, (getTickCount() % 4500) / 4500, 'SineCurve')
            local r, g, b = unpack(v.color)
            
            local fx, fy = x + math.cos(math.rad(angle)) * size, y + math.sin(math.rad(angle)) * size
            local bx, by = x - math.cos(math.rad(angle)) * size, y - math.sin(math.rad(angle)) * size
            local materialSize = size * 1.4
            dxDrawMaterialLine3D(fx, fy, z, bx, by, z, v.ground, materialSize, tocolor(r, g, b, alphaIcon), false, x, y, z + 1)
            
            local r, g, b = unpack(v.color2)
            local borderLineSize = interpolateBetween(3.9, 0, 0, 4.1, 0, 0, (getTickCount() % 4500) / 4500, 'SineCurve')
            local fx, fy = x + math.cos(math.rad(angle)) * borderLineSize, y + math.sin(math.rad(angle)) * borderLineSize
            local bx, by = x - math.cos(math.rad(angle)) * borderLineSize, y - math.sin(math.rad(angle)) * borderLineSize
            local borderLineSizeMaterial = borderLineSize * 1.4
            dxDrawMaterialLine3D(fx, fy, z, bx, by, z, v.borderline, borderLineSizeMaterial, tocolor(r, g, b, alphaBorderLine), false, x, y, z + 1)
        end
    end
end)


bindKey("mouse_wheel_down", "both", function()
    if main['actual'] then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if main['actual'] then
        scrollDown()
    end
end)

function scrollDown()
    if n == m then return end
    k = k-1
    n = n-1
end

function scrollUp()
    if n >= #main['vehicles'] then return end
    k = k+1
    n = n+1
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, aa = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (aa==0) then 
				break 
	  		end 
		end 
	return formatted 
end

getResourceName(getThisResource(), true, 455708301); if true then return end