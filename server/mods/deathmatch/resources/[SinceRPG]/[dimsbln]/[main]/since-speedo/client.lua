local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 1
sy = sy - 25/zoom

local main = {
    ['textures'] = {['mask_speedo'] = dxCreateTexture('data/images/mask_speedo.png'), ['mask_rpm'] = dxCreateTexture('data/images/mask_rpm.png')},
    ['fonts'] = {
        [1] = dxCreateFont('data/fonts/Inter-BlackItalic.ttf',15/zoom),
        [2] = dxCreateFont('data/fonts/Inter-BlackItalic.ttf',23/zoom),
        [3] = dxCreateFont('data/fonts/Inter-MediumItalic.ttf',11/zoom),
        [4] = dxCreateFont('data/fonts/Inter-BlackItalic.ttf',36/zoom),
        [5] = dxCreateFont('data/fonts/Inter-MediumItalic.ttf',13/zoom),
        [6] = dxCreateFont('data/fonts/Inter-MediumItalic.ttf',10/zoom),
    },
    ['patterns'] = {},
    ['showPatern'] = {
        tick = nil, 
        data = nil
    },
    ['maxPatterns'] = 6,
    ['speedometer'] = {},
}

local alpha = 0.5

function loadPaterns()
    for i=1, main.maxPatterns do
        if fileExists('data/images/patterns/'..i..'.png') then
            local shader = dxCreateShader("data/fx/mask.fx")
            local texture = dxCreateTexture('data/images/patterns/'..i..'.png')
            dxSetShaderValue(shader, "sPicTexture", texture) 
            dxSetShaderValue(shader, "sMaskTexture", main['textures']['mask_speedo'])
            destroyElement(texture)
            main['patterns'][i] = shader
        end
    end
end
loadPaterns()

local data = {

    mileage = 0,
    fuel = 0,

}

function getPointFromCircleRotation(x, y, radius, rotation)
    local rad = math.rad(rotation)
    local nx = x + math.cos(rad) * radius
    local ny = y + math.sin(rad) * radius
    return nx, ny
end


local frequency = 2
function formatNumber(number)
	tbl = {}
	 
    for i = 1, number do
		local curtime = getTickCount() / (1000) 
		r = math.floor(math.sin(curtime * frequency + i) * 127 + 128)
		g = math.floor(math.sin(curtime * frequency + i+2) * 127 + 128)
		b = math.floor(math.sin(curtime * frequency + i+4) * 127 + 128)	
		
        tbl[i] = {r,g,b}

    end
	
    return tbl
end

local cache = {

    player = {

        hideHUD = false,
        hudOff = false,

    },

    vehicle = {

        vehicleElement = false,
        vehicleID = false,
        vehicleData = false,
        vehicleUpgrades = false,
        vehicleModel = false,
        vehicleFuel = false,
        vehicleMileage = false,
        vehicleDeluxomode = false

    }

}

function preloadCache(theKey, oldValue, newValue)
    if getElementType(source) == 'player' and source == localPlayer then
        if theKey == 'player:settings' then
            cache['player']['hideHUD'] = newValue['hideHUD']
        elseif theKey == 'player:hudof' then
            cache['player']['hudOff'] = newValue
        end
    end

    if getElementType(source) == 'vehicle' and source == getPedOccupiedVehicle(localPlayer) then
        if theKey == 'vehicle:id' then
            cache['vehicle']['vehicleID'] = newValue
        elseif theKey == 'vehicle:data' then
            cache['vehicle']['vehicleData'] = newValue
        elseif theKey == 'vehicle:upgrades' then
            cache['vehicle']['vehicleUpgrades'] = newValue
        elseif theKey == 'vehicle:model' then
            cache['vehicle']['vehicleModel'] = newValue
        elseif theKey == 'vehicle:fuel' then
            cache['vehicle']['vehicleFuel'] = newValue
        elseif theKey == 'vehicle:deluxomode' then
            cache['vehicle']['vehicleDeluxomode'] = newValue
        end
    end
end
addEventHandler('onClientElementDataChange', root, preloadCache)

function manualPreloadCache(vehicle)
    if not vehicle then 
        return 
    end

    local vehicleID = getElementData(vehicle, 'vehicle:id')
    local vehicleData = getElementData(vehicle, 'vehicle:data') or {}
    local vehicleUpgrades = getElementData(vehicle, 'vehicle:upgrades') or {}
    local vehicleModel = getElementData(vehicle, 'vehicle:model') or getElementModel(vehicle)
    local vehicleFuel = getElementData(vehicle, 'vehicle:fuel') or {}
    local vehicleDeluxomode = getElementData(vehicle, 'vehicle:deluxomode')

    cache['vehicle']['vehicleID'] = vehicleID
    cache['vehicle']['vehicleData'] = vehicleData
    cache['vehicle']['vehicleUpgrades'] = vehicleUpgrades 
    cache['vehicle']['vehicleModel'] = vehicleModel
    cache['vehicle']['vehicleFuel'] = vehicleFuel
    cache['vehicle']['vehicleDeluxomode'] = vehicleDeluxomode

    local playerSettings = getElementData(localPlayer, 'player:settings') or {}
    local playerHudOff = getElementData(localPlayer, 'player:hudof')

    cache['player']['hideHUD'] = playerSettings['hideHUD']
    cache['player']['hudOff'] = playerHudOff
end

function render()
    local veh = getPedOccupiedVehicle(localPlayer)
    
    if not veh then 
        return 
    end

    if cache.player.hudOff then 
        return 
    end

    if cache.player.hideHUD then 
        return 
    end
    
    local upgrades = cache.vehicle.vehicleUpgrades
    local fuelData = cache.vehicle.vehicleFuel
    local sxx, syy, szz = getElementVelocity(veh)
    local predkosc = (sxx^2 + syy^2 + szz^2)^(0.5)
    local kmh = predkosc * 158

    local r, g, b = getVehicleHeadLightColor(veh)
    
    if not cache.vehicle.vehicleID then
        data.fuel = 100
        bak = 100
    else
        data.fuel = fuelData.count
        bak = fuelData.tank
    end

    
    local borsuk_to_idiota = math.ceil(((sxx^2+syy^2+szz^2)^(0.5)) * 188)

    if upgrades['sport'] then
        borsuk_to_idiota = math.min(borsuk_to_idiota, 423)
    else
        borsuk_to_idiota = math.min(borsuk_to_idiota, 299)
    end

    local mileage = string.format("%.2f", data.mileage)

    if getVehicleOverrideLights(veh) == 2 then
        alpha = math.min(alpha + 0.02, 1) 
    else
        alpha = math.max(alpha - 0.02, 0.5)
    end

    local pattern = main['showPatern'].data and main['showPatern'].tick > getTickCount() and main['showPatern'].data or upgrades and upgrades['motyw'] or nil

    if pattern then
        dxDrawImage(sx-530/zoom,sy-259/zoom,460/zoom,257/zoom,main['textures']['mask_speedo'],0,0,0,tocolor(255, 255, 255, 255*alpha))

        if main['patterns'][pattern] then
            dxDrawImage(sx-530/zoom,sy-259/zoom,460/zoom,257/zoom,main['patterns'][pattern],0,0,0,tocolor(255, 255, 255, 255*alpha))
        end
    else
        dxDrawImage(sx-530/zoom,sy-259/zoom,460/zoom,257/zoom,main['textures']['jaramcie'],0,0,0,tocolor(r, g, b, 255*alpha))
    end


    if upgrades and upgrades['licznikrgb'] then
        local curtime = getTickCount() / 1000
        local cr,cg,cb = math.floor(math.sin(curtime * 2 + 0) * 127 + 128), math.floor(math.sin(curtime * 2 + 2) * 127 + 128), math.floor(math.sin(curtime * 2 + 4) * 127 + 128)
        dxDrawImage(sx-550/zoom,sy-280/zoom,500/zoom,250/zoom,main['textures']['speedo_bg_rgb'],0,0,0,tocolor(255, 255, 255, 255*alpha))
        --dxCircle(sx-300/zoom, sy-30/zoom, 470/zoom, 470/zoom, tocolor(cr,cg,cb, 55*alpha), 180, 179.9, 6/zoom, 1)

        if upgrades['sport'] then
            dxCircle(sx-300/zoom, sy-30/zoom, 470/zoom, 470/zoom, tocolor(cr,cg,cb, 200*alpha), 180, 180*borsuk_to_idiota/425, 6/zoom, 1)
        else
            dxCircle(sx-300/zoom, sy-30/zoom, 470/zoom, 470/zoom, tocolor(cr,cg,cb, 200*alpha), 180, 180*borsuk_to_idiota/300, 6/zoom, 1)
        end
    else
        dxDrawImage(sx-550/zoom,sy-280/zoom,500/zoom,250/zoom,main['textures']['speedo_bg'],0,0,0,tocolor(r, g, b, 255*alpha))
        --dxCircle(sx-300/zoom, sy-30/zoom, 470/zoom, 470/zoom, tocolor(r, g, b, 55*alpha), 180, 179.9, 6/zoom, 1)
        dxCircle(sx-300/zoom, sy-30/zoom, 470/zoom, 470/zoom, tocolor(r, g, b, 200*alpha), 180, 180*borsuk_to_idiota/300, 6/zoom, 1)
    end

    if upgrades['electric'] then
        dxDrawImage(sx-47/zoom,sy-50/zoom,20/zoom,20/zoom,main['textures']['battery'], 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    else
        dxDrawImage(sx-47/zoom,sy-50/zoom,20/zoom,20/zoom,main['textures']['fuel_icon'], 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    end
    
    local nitro = getVehicleUpgradeOnSlot(veh, 8)

    if nitro == 1010 or nitro == 1009 or nitro == 1008 then
        local nitroCount = getVehicleNitroLevel(veh)

        dxDrawImage(sx-565/zoom,sy-109 /zoom,20/zoom,20/zoom,main['textures']['nitro'], -35, 0, 0, tocolor(67, 143, 135, 255*alpha))
        dxCircle(sx-300/zoom, sy-32/zoom, 530/zoom, 530/zoom, tocolor(67, 143, 135, 55*alpha), 200, 95, 6/zoom, 1)
        dxCircle(sx-300/zoom, sy-32/zoom, 530/zoom, 530/zoom, tocolor(67, 143, 135, 175*alpha), 200, 95 * nitroCount, 6/zoom, 1)
    end

    dxCircle(sx-300/zoom, sy-32/zoom, 530/zoom, 530/zoom, tocolor(255, 255, 255, 55*alpha), 300, 55*100/100, 6/zoom, 1)
    dxCircle(sx-300/zoom, sy-32/zoom, 530/zoom, 530/zoom, tocolor(255, 255, 255, 175*alpha), 300, 55*data.fuel/bak, 6/zoom, 1)

    if upgrades['sport'] then
        for i = 12, 24 do
            local speed = i - 12
            local x, y = getPointFromCircleRotation(sx-300/zoom, sy-32/zoom, 200/zoom, (i + 1) * 14.2)
    
            dxDrawText(speed * 30, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 55*alpha), 1, main['fonts'][5], 'center', 'center', false, false, false, false, false)
            dxDrawText(speed * 30, x, y, x, y, tocolor(r, g, b, 175*alpha), 1, main['fonts'][5], 'center', 'center', false, false, false, false, false)
        end
    else
        for i = 12, 24 do
            local speed = i - 12
            local x, y = getPointFromCircleRotation(sx-300/zoom, sy-32/zoom, 200/zoom, (i + 1) * 14.2)
    
            dxDrawText(speed * 20, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 55*alpha), 1, main['fonts'][5], 'center', 'center', false, false, false, false, false)
            dxDrawText(speed * 20, x, y, x, y, tocolor(r, g, b, 175*alpha), 1, main['fonts'][5], 'center', 'center', false, false, false, false, false)
        end
    end
   
    dxDrawText(math.floor(kmh), sx - 356/zoom, sy - 154/zoom + 2, (sx - 346/zoom) + (108/zoom), (sy - 144/zoom) + (69/zoom) + 2, tocolor(0, 0, 0, 200*alpha), 1, main['fonts'][4], 'center', 'center')
    dxDrawText('km/h', sx - 356/zoom, sy - 96/zoom + 2, (sx - 346/zoom) + (108/zoom), (sy - 86/zoom) + (20/zoom) + 2, tocolor(0, 0, 0, 200*alpha), 1, main['fonts'][5], 'center', 'center')
    dxDrawText(mileage..' km', sx - 356/zoom, sy - 250/zoom + 2, (sx - 346/zoom) + (108/zoom), (sy - 86/zoom) + (20/zoom) + 2, tocolor(0, 0, 0, 200*alpha), 1, main['fonts'][5], 'center', 'center')

    dxDrawText(math.floor(kmh), sx - 356/zoom, sy - 154/zoom, (sx - 346/zoom) + (108/zoom), (sy - 144/zoom) + (69/zoom), tocolor(r, g, b, 255*alpha), 1, main['fonts'][4], 'center', 'center')
    dxDrawText('km/h', sx - 356/zoom, sy - 96/zoom, (sx - 346/zoom) + (108/zoom), (sy - 86/zoom) + (20/zoom), tocolor(255, 255, 255, 205*alpha), 1, main['fonts'][5], 'center', 'center')
    dxDrawText(mileage..' km', sx - 356/zoom, sy - 250/zoom, (sx - 346/zoom) + (108/zoom), (sy - 86/zoom) + (20/zoom), tocolor(255, 255, 255, 205*alpha), 1, main['fonts'][5], 'center', 'center')

    if upgrades['sport'] then
        local model = cache.vehicle.vehicleModel or getElementModel(veh)
        local vehicleName = exports['since-vehiclenames']:getVehicleName(model)
        dxDrawText(vehicleName..' Sport', sx - 356/zoom, sy + 5/zoom + 2, (sx - 346/zoom) + (108/zoom), (sy - 86/zoom) + (20/zoom) + 2, tocolor(0, 0, 0, 200*alpha), 1, main['fonts'][6], 'center', 'center')
        dxDrawText(vehicleName..' #52ffb7Sport', sx - 356/zoom, sy + 5/zoom, (sx - 346/zoom) + (108/zoom), (sy - 86/zoom) + (20/zoom), tocolor(255, 255, 255, 205*alpha), 1, main['fonts'][6], 'center', 'center', false, false, false, true)
    end

    if upgrades and upgrades['deluxomode'] then
        local deluxoState = cache.vehicle.vehicleDeluxomode or false

        if deluxoState then
            dxDrawText('DeluxoMode: ON', sx - 356/zoom, sy - 170/zoom + 2, (sx - 346/zoom) + (108/zoom), nil, tocolor(0, 0, 0, 200*alpha), 1, main['fonts'][6], 'center', 'bottom')
            dxDrawText('DeluxoMode: #2E756FON', sx - 356/zoom, sy - 170/zoom, (sx - 346/zoom) + (108/zoom), nil, tocolor(255, 255, 255, 205*alpha), 1, main['fonts'][6], 'center', 'bottom', false, false, false, true)
        else
            dxDrawText('DeluxoMode: OFF', sx - 356/zoom, sy - 170/zoom + 2, (sx - 346/zoom) + (108/zoom), nil, tocolor(0, 0, 0, 200*alpha), 1, main['fonts'][6], 'center', 'bottom')
            dxDrawText('DeluxoMode: #ff7d7dOFF', sx - 356/zoom, sy - 170/zoom, (sx - 346/zoom) + (108/zoom), nil, tocolor(255, 255, 255, 205*alpha), 1, main['fonts'][6], 'center', 'bottom', false, false, false, true)
        end
    end

    if upgrades and upgrades['lpg'] then
        local offset = 0
        local fuelLPG = (fuelData and fuelData.countLPG or 0)

        if fuelLPG >= 90 then    
            dots = 5
        elseif fuelLPG >= 75 then
            dots = 4
        elseif fuelLPG >= 50 then
            dots = 3
        elseif fuelLPG >= 25 then
            dots = 2
        elseif fuelLPG >= 10 then
            dots = 1
        elseif fuelLPG < 10 then
            dots = 0
        end

        for i = 1, 5 do
            offset = offset + 25/zoom
            dxDrawImage(sx - 380/zoom + offset, sy-60/zoom, 12/zoom, 12/zoom, main['textures']['lpg_bg'])
        end
        
        local offset = 0
        for i = 1, dots do
            offset = offset + 25/zoom
            dxDrawImage(sx - 380/zoom + offset, sy-60/zoom, 12/zoom, 12/zoom, main['textures']['lpg_active'])
        end
    end

    if main['showPatern'].tick and main['showPatern'].data and main['showPatern'].tick < getTickCount()-500 then
        main['showPatern'].tick = nil
        main['showPatern'].data = nil
    end
end

function reloadSpeedoData(veh)
    if not veh then veh = getPedOccupiedVehicle(localPlayer) or false end
    if not veh then return end

    local fuelData = cache.vehicle.vehicleFuel
    local vehicleData = cache.vehicle.vehicleData
    local vehicleID = cache.vehicle.vehicleID

    if not vehicleID then
        data.fuel = 100
    else
        data.fuel = fuelData.count
    end

    if not vehicleID then
        data.mileage = 0
    else
        data.mileage = vehicleData.mileage
    end
end
setTimer(reloadSpeedoData, 3000, 0)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function createTextures()
    destroyTextures()
    local c = {
        ['speedo_bg'] = true,
        ['rpm_bg'] = true,
        ['jaramcie'] = true,
        ['jaramcie2'] = true,
        ['fuel_icon'] = true,
        ['fuel_bg'] = true,
        ['lpg_bg'] = true,
        ['lpg_active'] = true,
        ['mask_speedo'] = true,
        ['mask_rpm'] = true,
        ['speedo_bg_rgb'] = true,
        ['rpm_bg_rgb'] = true,
        ['nitro'] = true,
        ['battery'] = true,
    }

    for i,v in pairs(c) do
        main['textures'][i] = dxCreateTexture('data/images/'..i..'.png','argb',false,'clamp')
    end

    if getPedOccupiedVehicle(localPlayer) then
        reloadSpeedoData(getPedOccupiedVehicle(localPlayer))
        manualPreloadCache(getPedOccupiedVehicle(localPlayer))
    end
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if (isElement(v)) then
            destroyElement(v)
        end
    end
end

function toggleSpeedo(bool)
    if bool then
        if not isEventHandlerAdded('onClientRender',root,render) then
            addEventHandler('onClientRender',root,render)
        end
        
        createTextures()
    else
        destroyTextures()
        removeEventHandler('onClientRender',root,render)
    end
end

addEventHandler('onClientPlayerVehicleEnter', root, function()
    if (source == localPlayer) then
        toggleSpeedo(true)
        manualPreloadCache(getPedOccupiedVehicle(localPlayer))
    end
end)

addEventHandler('onClientPlayerVehicleExit', root, function()
    if (source == localPlayer) then
        toggleSpeedo(false)

        cache = {

            player = {

                hideHUD = false,
                hudOff = false,

            },
        
            vehicle = {
        
                vehicleElement = false,
                vehicleID = false,
                vehicleData = false,
                vehicleUpgrades = false,
                vehicleModel = false,
                vehicleFuel = false,
                vehicleMileage = false,
                vehicleDeluxomode = false
        
            }

        }
    end
end)

addEventHandler('onClientResourceStart',resourceRoot,function ()
    if getPedOccupiedVehicle(localPlayer) then
        toggleSpeedo(true)

        manualPreloadCache(getPedOccupiedVehicle(localPlayer))
    end
end)

setWorldSpecialPropertyEnabled("extraairresistance", false)

local blockNitro = {}

function setActiveNitro(veh, state)
	if veh then
		setVehicleNitroActivated(veh, state)
	end
end

function impulseNitro()
	local veh = getPedOccupiedVehicle(localPlayer)

    if not veh then 
        return
    end

    if not blockNitro[veh] then blockNitro[veh] = false end

    if isVehicleNitroActivated(veh) then
        setVehicleNitroActivated(veh, false)
    end

	if veh and getVehicleController(veh) == localPlayer then
		if getElementData(veh, "vehicle:toggleNitro") then
			if (getElementData(veh, "vehicle:nitroCount") or 0) == 0 or 1 > (getElementData(veh, "vehicle:nitroCount") or 0) then
				blockNitro[veh] = true
			elseif (getElementData(veh, "vehicle:nitroCount") or 0) >= 99 then
				blockNitro[veh] = false
			end
            
			if blockNitro[veh] == false then
				if getKeyState("lalt") == true then
					setActiveNitro(veh, true)
					setElementData(veh, "vehicle:nitroCount", (getElementData(veh, "vehicle:nitroCount") or 0)-0.15)
				else
					setActiveNitro(veh, false)
					if (getElementData(veh, "vehicle:nitroCount") or 0) >= 100 then

					else
						setElementData(veh, "vehicle:nitroCount", (getElementData(veh, "vehicle:nitroCount") or 0)+0.025)
					end
				end
			else
				if (getElementData(veh, "vehicle:nitroCount") or 0) >= 100 then

				else
					setElementData(veh, "vehicle:nitroCount", (getElementData(veh, "vehicle:nitroCount") or 0)+0.025)
				end
			end
		end
	end
end
bindKey("lalt", "both", impulseNitro)

function showSpeedoPatern(id)
    main['showPatern'].tick = getTickCount()+500  
    main['showPatern'].data = id
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    destroyTextures()

    for i,v in pairs(main['patterns']) do
        if (isElement(v)) then
            destroyElement(v)
        end
    end
end)
getResourceName(getThisResource(), true, 354887763); if true then return end