local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local object = false
zoom = zoom * 0.9

local main = {
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

        { -- bb
            take = {161.34, -169.88, 1},
            spawn = {159.05, -165.02, 1.31, 0.0, 0.0, 89.5},
            ret = {158.07, -174.57, 1.58},
            teleport = {156.30, -169.86, 1.58},
            previewObject = {147.55, -161.57, -8.57},
            matrix = {142.76, -153.57, -8, 147.28, -162.34, -9.74},
            veh = {147.18, -161.71, -10.01, 0.0, 0.0, 0.5},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,}
        },
        
        { -- ls
            take = {1004.27, -1431.50, 12.7},
            spawn = {996.47, -1434.95, 13.27, 0.0, 0.0, 181.3},
            ret = {982.30, -1434.82, 13.55},
            teleport = {1004.24, -1434.42, 13.55},
            previewObject = {996.43, -1434.91, 5.55},
            matrix = {990.87, -1427.92, 6.38, 996.21, -1436.02, 4.38},
            veh = {996.09, -1435.21, 4.11, 0.0, 0.0, 0.6},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,}
        },

        {   -- lv
            take = {1965.28, 2142.17, 10.82-0.5},
            spawn = {1958.57, 2144.56, 10.55, 0.0, 0.0, 0.2},
            ret = {1950.59, 2144.45, 10.82},
            teleport = {1965.35, 2148.70, 10.82},
            previewObject = {1962.22, 2148.26, 2.82}, 
            matrix = {1957.61, 2153.86, 3.15, 1961.65, 2147.04, 1.65},
            veh = {1961.87, 2147.29, 1.24, 359.6, 360.0, 360.0},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,}
        },

        { -- sf
            take = {-2636.34, 1354.34, 7.13-1},
            spawn = {-2631.50, 1358.34, 7.11, -0.00, 0.00, 270},
            ret = {-2631.56, 1350.64, 7.12},
            teleport = {-2632.67, 1354.25, 7.11},
            previewObject = {1962.22, 2148.26, 2.82}, 
            matrix = {1957.61, 2153.86, 3.15, 1961.65, 2147.04, 1.65},
            veh = {-2631.04, 1350.43, 7.11, -0.00, 0.00, 0},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,}
        },

        {   -- ls samoloty
            take = {1902.19, -2235.13, 13.15},
            spawn = {1922.49, -2256.23, 14.47, 0.5, 360.0, 180.4},
            ret = {1991.46, -2315.86, 13.55},
            teleport = {1902.18, -2238.36, 13.55},
            previewObject = nil,
            matrix = {1931.90, -2279.93, 21.05, 1922.87, -2257.72, 14.63},
            veh = {1922.49, -2256.23, 14.47, 0.5, 360.0, 180.4},
            types = {['Plane']=true,['Helicopter']=true,},
            withoutMaterials = true,
        },

        {   -- fc lodzie
            take = {-466.49, 1156.37, 1.05-0.5},
            spawn = {-470.90, 1160.86, -0.47, 2.5, 0.0, 178.8},
            ret = {-460.63, 1157.80, -0.55},
            teleport = {-466.45, 1158.97, 1.05},
            previewObject = nil,
            matrix = {-475.88, 1146.68, 6.81, -471.43, 1159.95, 0.93},
            veh = {-470.90, 1160.86, -0.47, 2.5, 0.0, 178.8},
            types = {['Boat']=true,},
            withoutMaterials = true,
        },

        {   -- lv salon sport
            take = {1384.18, 735.97, 10.82-0.5},
            spawn = {1380.97, 755.60, 10.55, 0.0, 0.0, 90.2},
            ret = {1382.02, 732.00, 10.82, -0.00, 0.00, 10.49},
            teleport = {1381.87, 735.96, 10.82},
            previewObject = {1384.19, 739.67, 1.82},
            matrix = {1379.90, 745.21, 2.77, 1383.63, 738.71, 0.65},
            veh = {1383.70, 738.65, 0.38, 0.0, 0.0, 359.9},
            types = {['Automobile']=true,['Bike']=true,['BMX']=true,['Quad']=true,['Monster Truck']=true,}

        },
        
        
    },
    
    ['actual'] = false,

    ['points'] = {

        ['oddawanieBB'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {158.18, -174.64, 1.58},
            lookingAt = {151.89, -174.64, 1.58},
            color = {46, 117, 111},
            color2 = {46, 117, 111},
        },

        ['odbieranieBB'] = {
            ground = dxCreateTexture('data/images/spawnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {158.18, -165.14, 1.58},
            lookingAt = {151.89, -165.14, 1.58},
            color = {255, 255, 125},
            color2 = {255, 255, 125},
        },

        ['oddawanieLS'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {982.20, -1434.52, 13.55},
            lookingAt = {982.20, -1439.02, 13.55},
            color = {46, 117, 111},
            color2 = {46, 117, 111},
        },

        ['odbieranieLS'] = {
            ground = dxCreateTexture('data/images/spawnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {996.41, -1434.52, 13.55},
            lookingAt = {996.41, -1439.02, 13.55},
            color = {255, 255, 125},
            color2 = {255, 255, 125},
        },

        ['oddawanieLV'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {1950.46, 2145.62, 10.82},
            lookingAt = {1950.46, 2150.31, 10.82},
            color = {46, 117, 111},
            color2 = {46, 117, 111},
        },

        ['odbieranieLV'] = {
            ground = dxCreateTexture('data/images/spawnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {1958.49, 2145.62, 10.82},
            lookingAt = {1958.49, 2148.18, 10.82},
            color = {255, 255, 125},
            color2 = {255, 255, 125},
        },

        ['oddawanieSF'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {-2631.56, 1350.64, 7.12},
            lookingAt = {-2631, 1350.64, 7.11},
            color = {46, 117, 111},
            color2 = {46, 117, 111},
        },

        ['odbieranieSF'] = {
            ground = dxCreateTexture('data/images/spawnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {-2631.56, 1358, 7.11},
            lookingAt = {-2631, 1358, 7.11},
            color = {255, 255, 125},
            color2 = {255, 255, 125},
        },

        ['odbieranieLVSPORToddawanieLVSPORT'] = {
            ground = dxCreateTexture('data/images/returnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {1382.57, 732.1, 10.82, -0.00, 0.00, 0},
            lookingAt = {1376.16, 732.1, 10.82, -0.00, 0.00, 0},
            color = {46, 117, 111},
            color2 = {46, 117, 111},
        },
        
        ['odbieranieLVSPORT'] = {
            ground = dxCreateTexture('data/images/spawnpoint.png','argb',false,'clamp'),
            borderline = dxCreateTexture('data/images/borderline.png','argb',false,'clamp'),
            groundPos = {1382.57, 755.57, 10.82, -0.00, 0.00, 178.51},
            lookingAt = {1374.97, 755.57, 10.83, -0.00, 0.00, 268.91},
            color = {255, 255, 125},
            color2 = {255, 255, 125},
        },
    },

    ['vehicles'] = {},
    ['savedVehicles'] = {},
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

    main['vehicles'] = main['category']==2 and getVehicles(main['savedOrg'], uiElements['edit_parking']) or getVehicles(main['savedVehicles'], uiElements['edit_parking'])

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

            dxDrawImage(sx - 468/zoom, sy/2 - 122/zoom + x, 18/zoom, 18/zoom, main.textures.time)
            dxDrawText(v.loadedData.driver, sx - 442/zoom, sy/2 - 113/zoom + x, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'center')

            if v.loadedData.driver ~= 'Brak' then
                local textWidth = dxGetTextWidth( v.loadedData.driver, 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom) )
                dxDrawText('('..v.lastDrive..')', sx - 442/zoom + textWidth + 4/zoom, sy/2 - 113/zoom + x, nil, nil, tocolor(148, 255, 139, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'center')
            end
            
            dxDrawImage(sx - 468/zoom, sy/2 - 96/zoom + x, 18/zoom, 18/zoom, main.textures.tank)
            dxDrawText(math.floor(v.fuelData.count)..'%', sx - 442/zoom, sy/2 - 86/zoom + x, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')

            --dxDrawImage(sx - 320/zoom, sy/2 - 99/zoom, 20/zoom, 20/zoom, 'data/tank.png')
            --dxDrawText('204 km', sx - 408/zoom, sy/2 - 88.5/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'left', 'center')
                
            dxDrawImage(sx - 396/zoom, sy/2 - 96/zoom + x, 18/zoom, 18/zoom, main.textures.mileage)
            dxDrawText(string.format("%.2f", v.loadedData.mileage)..' km', sx - 370/zoom, sy/2 - 86/zoom + x, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')

            local isIn = isMouseInPosition(sx - 167/zoom, sy/2 - 128/zoom + x, 88/zoom, 30/zoom)
            dxDrawImage(sx - 167/zoom, sy/2 - 128/zoom + x, 88/zoom, 30/zoom, selectedVehicle == i and main.textures.button_selected or main.textures.button, 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
            dxDrawText(selectedVehicle == i and 'Wyjmij' or 'Wybierz', sx - 122/zoom + 1, sy/2 - 113/zoom + x + 1, nil, nil, tocolor(0, 0, 0, isIn and 65 or 100), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
            dxDrawText(selectedVehicle == i and 'Wyjmij' or 'Wybierz', sx - 122/zoom, sy/2 - 113/zoom + x, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')

            x = x + 98/zoom
        end
    end

    local x, y, z = getElementPosition(localPlayer)
    local zoneName = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)

    dxDrawText('Przechowalnia pojazdów', sx - 278/zoom + 1, sy/2 - 268/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Black', 16/zoom), 'center', 'bottom')
    dxDrawText(zoneName, sx - 278/zoom + 1, sy/2 - 269/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
    dxDrawText('Przechowalnia pojazdów', sx - 278/zoom, sy/2 - 268/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Black', 16/zoom), 'center', 'bottom')
    dxDrawText(zoneName, sx - 278/zoom, sy/2 - 269/zoom, nil, nil, tocolor(148, 255, 139, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')

    local textWidth = dxGetTextWidth( 'Pojazdy prywatne', 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom) ) + 26/zoom
    local textWidth2 = dxGetTextWidth( 'Pojazdy organizacyjne', 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom) ) + 26/zoom

    dxDrawRoundedRectangle(sx - 278/zoom - textWidth/2-textWidth2/2-5/zoom, sy/2 + 264/zoom, textWidth, 28/zoom, 14/zoom, main['category']==1 and  tocolor(46, 117, 111, 85)or tocolor(255, 255, 255, 85))
    dxDrawText('Pojazdy prywatne', sx - 278/zoom-textWidth2/2-5/zoom, sy/2 + 278/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')

    dxDrawRoundedRectangle(sx - 278/zoom - textWidth2/2+textWidth/2+5/zoom, sy/2 + 264/zoom, textWidth2, 28/zoom, 14/zoom, main['category']==2 and tocolor(46, 117, 111, 85) or tocolor(255, 255, 255, 85))
    dxDrawText('Pojazdy organizacyjne', sx - 278/zoom+textWidth/2+5/zoom, sy/2 + 278/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
   
    dxDrawText('Użyj strzałek, aby zmienić zakladkę', sx - 278/zoom, sy/2 + 300/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'top')
   

    drawScrollbar(main['vehicles'], sx - 55/zoom, sy/2-320/zoom/2, 3/zoom, 391/zoom, m, k, 255)

    if getKeyState('arrow_l') then
        if not keyBlockL then
            keyBlockL = true
            main['category'] = math.max(main['category'] - 1, 1)
            selectedVehicle = nil
        end
    else
        if keyBlockL then
            keyBlockL = nil
        end
    end

    if getKeyState('arrow_r') then
        if not keyBlockR then
            keyBlockR = true
            main['category'] = math.min(main['category'] + 1, 2)
            selectedVehicle = nil
        end
    else
        if keyBlockR then
            keyBlockR = nil
        end
    end
end

addEvent('since-przecho:getVehicle', true)
addEventHandler('since-przecho:getVehicle', root, function (data, orgData)

    if #data > 0 or #orgData > 0 then
        main['savedVehicles'] = data
        main['savedOrg'] = orgData
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
        return exports['since-notifications']:sendNotification('error', 'Nie posiadasz żadnych pojazdów w przechowalni.')
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

                    triggerServerEvent('since-przecho:tryTakeVehicle',resourceRoot,v.id,main['positions'][main['actual']].spawn)
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
    v.marker = createMarker(v.take[1], v.take[2], v.take[3], "cylinder", 1.5, 125, 255, 125, 150)
    v.oddaj = createMarker(v.ret[1], v.ret[2], v.ret[3], "cylinder", v.withoutMaterials and 6 or 2, 125, 255, 125, 150)
    setElementData(v.marker,'marker:title','Przechowalnia')
    setElementData(v.marker,'marker:desc','Odbior pojazdow')
    setElementData(v.marker,'marker:icon','parking')

    if not v.withoutMaterials then
        setElementData(v.oddaj,'marker:visible',true)
    else
        setElementData(v.oddaj,'marker:title','Przechowalnia')
        setElementData(v.oddaj,'marker:desc','Oddawanie pojazdów')
        setElementData(v.oddaj,'marker:icon','parking')
    end

    setElementData(v.marker,'marker:parkingid',i)
    v.blip = createBlip(v.take[1], v.take[2], v.take[3], 35, 2, 255, 255, 255, 255, 0, 450)

    addEventHandler('onClientMarkerHit', v.oddaj, function(plr)
        if (plr ~= localPlayer) then return end
        local veh = getPedOccupiedVehicle(plr)
        if not veh then return end
        if not getElementData(veh,'vehicle:id') then return end
        triggerServerEvent('since-przecho:tryReturnVehicle', resourceRoot)
        setWorldSpecialPropertyEnabled("aircars", false)
        setWorldSpecialPropertyEnabled("hovercars", false)
    end)

    addEventHandler('onClientMarkerHit', v.marker, function(plr)
        if (plr ~= localPlayer) then return end
        if getElementData(plr, 'player:job') then
            return exports['since-notifications']:sendNotification('error', 'Nie możesz korzystać z przechowalni podczas wykonywania pracy.')
        end
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
        triggerServerEvent('since-przecho:getVehicle', resourceRoot, nil, markerData.types)

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
getResourceName(getThisResource(), true, 455708301); if true then return end