local cache = {

    kilometers = 0,
    kmCost = 7500,
    money = 0,
    doinCurse = false,

}

function addComma(number)
    local number = tostring(number)
    return number:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
end

function isVehicleTaxi(veh)
    if veh and getElementData(veh, 'vehicle:faction') == 'TSA' then
        return true
    else
        return false
    end

    return false
end

function renderUI()
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if not vehicle then 
        return 
    end

    if not isVehicleTaxi(vehicle) then
        return
    end

    local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {

        kilometers = 0,
        money = 0,
        passager = false

    }

    if vehicleData.driver == localPlayer then
        dxDrawText('Kliknij B aby otworzyć panel zgłoszeń TAXI', sx/2 + 1, sy - 15/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'bottom')
        dxDrawText('Kliknij #7dff7dB#ffffff aby otworzyć panel zgłoszeń #ffff00TAXI', sx/2, sy - 15/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'bottom', false, false, false, true)

        if not vehicleData.passager then
            return
        end

        dxDrawImage(sx/2 - 288/zoom, sy - 186/zoom, 578/zoom, 144/zoom, 'data/background.png')
        dxDrawText('Taksometr', sx/2, sy - 150/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), 'center', 'bottom')
        
        dxDrawText('Przebyty dystans', sx/2 + 278/zoom, sy - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'top')
        local kilometers = string.format('%.2f', vehicleData.kilometers or 0)
        dxDrawText(kilometers..' km', sx/2 + 278/zoom, sy - 114/zoom, nil, nil, tocolor(125, 255, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'right', 'bottom')
        
        if vehicleData.passager then
            dxDrawText('Kliknij #7dff7dK#ffffff aby '..(vehicleData.doinCurse and '#ff7d7dzakończyć' or '#5EABD6rozpocząć')..' kurs', sx/2 + 278/zoom, sy - 98/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'top', false, false, false, true)
        end
        
        dxDrawText('Klient: '..(vehicleData.passager and '#fff836'..getPlayerName(vehicleData.passager) or '#ff7d7dBrak klienta,'), sx/2 - 278/zoom, sy - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
        dxDrawText('Stawka za kilometr: #5EABD6'..addComma(cache.kmCost or 0)..'$ / km', sx/2 - 278/zoom, sy - 96/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
        dxDrawText('Naliczone opłaty: #7dff7d'..addComma(vehicleData.money or 0)..'$', sx/2 - 278/zoom, sy - 78/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
    elseif vehicleData.passager == localPlayer and vehicleData.doinCurse then
        dxDrawImage(sx/2 - 288/zoom, sy - 186/zoom, 578/zoom, 144/zoom, 'data/background.png')
        dxDrawText('Taksometr', sx/2, sy - 150/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), 'center', 'bottom')
    
        dxDrawText('Przebyty dystans', sx/2 + 278/zoom, sy - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'right', 'top')
        local kilometers = string.format('%.2f', vehicleData.kilometers or 0)
        dxDrawText(kilometers..' km', sx/2 + 278/zoom, sy - 114/zoom, nil, nil, tocolor(125, 255, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'right', 'bottom')
    
        dxDrawText('Kierowca: '..(vehicleData.driver and '#fff836'..getPlayerName(vehicleData.driver) or '#ff7d7dBrak kierowcy,'), sx/2 - 278/zoom, sy - 114/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
        dxDrawText('Stawka za kilometr: #5EABD6'..addComma(cache.kmCost or 0)..'$ / km', sx/2 - 278/zoom, sy - 96/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
        dxDrawText('Naliczone opłaty: #7dff7d'..addComma(vehicleData.money or 0)..'$', sx/2 - 278/zoom, sy - 78/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom', false, false, false, true)
    end
end

local time = getTickCount()

function startCounting()
    local veh = getPedOccupiedVehicle(localPlayer)

    if not veh then return end

    if not isVehicleTaxi(veh) then
        return
    end

	if getTickCount() - time > 50 then
		time = getTickCount()
		local vehicleData = getElementData(veh,'vehicle:taxi')
		local vx,vy,vz = getElementVelocity(veh)
		local spd=((vx^2 + vy^2 + vz^2)^(0.5)/2)

		if spd > 0 then
			vehicleData.kilometers = vehicleData.kilometers + (spd) / 75
            vehicleData.money = math.floor(vehicleData.kilometers * cache.kmCost)

            setElementData(veh, 'vehicle:taxi', vehicleData)
		end
	end
end

bindKey('k', 'down', function()
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if not vehicle then return end

    if not isVehicleTaxi(vehicle) then
        return
    end

    local vehicleData = getElementData(vehicle, 'vehicle:taxi')

    if not vehicleData then return end

    if not vehicleData.passager then 
        return 
    end

    if vehicleData.driver ~= localPlayer then
        return
    end

    local doinCurse = not vehicleData.doinCurse

    if doinCurse then
        local vehicleData = getElementData(vehicle, 'vehicle:taxi') or {}

        vehicleData.kilometers = 0
        vehicleData.money = 0
        vehicleData.doinCurse = true

        setElementData(vehicle, 'vehicle:taxi', vehicleData)

        addEventHandler('onClientRender', root, startCounting)

        triggerServerEvent('onTaxiRequest', resourceRoot, 'startCourse', { localPlayer, vehicleData.passager })
    else
        removeEventHandler('onClientRender', root, startCounting)

        triggerServerEvent('onTaxiRequest', resourceRoot, 'endCourse', { vehicleData.passager, vehicle, true })

        vehicleData.kilometers = 0
        vehicleData.money = 0
        vehicleData.doinCurse = false

        setElementData(vehicle, 'vehicle:taxi', vehicleData)
    end
end)

addEvent('stopCounting', true)  
addEventHandler('stopCounting', root, function()
    removeEventHandler('onClientRender', root, startCounting)
end)

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
end

toggleUI(true)