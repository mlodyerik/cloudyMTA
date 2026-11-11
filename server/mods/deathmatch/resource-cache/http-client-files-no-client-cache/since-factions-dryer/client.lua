sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local options = {
    ['vehicle'] = {
        ['SARA'] = {
            {'Spuść/Zaciągnij ręczny', 'reczny'},
            {'Zatankuj pojazd', 'tank'},
        },

        ['SAPD'] = {
            {'Wystaw mandat', 'mandat'},
            {'Spuść/Zaciągnij ręczny', 'reczny'},
        },
    },
}

local SPEED_LIMIT = 90

local aviable_options = {}

function render()
    if isPedAiming(localPlayer) and vehicle and isElement(vehicle) then
        dxDrawImage(sx/2 - 216/zoom, sy/2 + 342/zoom, 431/zoom, 178/zoom, 'data/bg.png')
        local vx, vy, vz = getElementVelocity(vehicle)
        local speed = ((vx^2 + vy^2 + vz^2)^(0.5))*180
        dxDrawText('Informacje o pojeździe', sx/2, sy/2 + 347/zoom, nil, nil, tocolor(35, 229, 82, 216), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'top')
        dxDrawText('Model: #FFA800'..vehname, sx/2 - 212/zoom, sy/2 + 375/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, false, true, false)
        dxDrawText('ID: #FFA800'..vehid, sx/2 - 212/zoom, sy/2 + 400/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, false, true, false)
        dxDrawText('Tablica rejestracyjna: #FFA800'..plate, sx/2 - 212/zoom, sy/2 + 424/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, false, true, false)
        dxDrawText('Ostatni kierowca: #FFA800'..data.driver, sx/2 - 212/zoom, sy/2 + 448/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'left', 'top', false, false, false, true, false)
        dxDrawText(math.floor(speed), sx/2 + 154/zoom, sy/2 + 371/zoom, nil, nil, tocolor(207, 207, 207, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 32/zoom), 'center', 'top', false, false, false, true, false)
        dxDrawText('km/h', sx/2 + 156.5/zoom, sy/2 + 419/zoom, nil, nil, tocolor(35, 229, 82, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 18/zoom), 'center', 'top', false, false, false, true, false)
        dxDrawText('Akcja: #74B3ED'..aviable_options[selected][1], sx/2, sy/2 + 481/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), 'center', 'top', false, false, false, true, false)
        dxDrawText('(użyj scrolla w celu zmiany akcji)', sx/2 + -1/zoom, sy/2 + 507/zoom, nil, nil, tocolor(255, 58, 58, 175), 1, exports['since-fonts']:getFont('Inter-Bold', 8/zoom), 'center', 'top')
    end
end

function up()
    if selected == 1 then
        selected = #aviable_options
    else
        selected = selected - 1
    end
end

function down()
    if selected == #aviable_options then
        selected = 1
    else
        selected = selected + 1
    end
end

local cooldown = {}

function click()
    if aviable_options[selected][2] == 'mandat' then
        if vehicle and isElement(vehicle) then
            if cooldown[vehicle] then
                if getTickCount() - cooldown[vehicle] < 20000 then
                    return false
                end
            end
            local vx, vy, vz = getElementVelocity(vehicle)
            local speed = ((vx^2 + vy^2 + vz^2)^(0.5))*180
            if speed > SPEED_LIMIT then
                local driver = getVehicleOccupant(vehicle)
                if driver and isElement(driver) then
                    setCameraTarget(driver)
                    setTimer(function()
                        --dxUpdateScreenSource(screen)
                        setCameraTarget(localPlayer)
                    end, 10, 1)
                    if not isEventHandlerAdded("onClientRender", root, render) then
                        addEventHandler("onClientRender", root, render)
                    end
                    if isTimer(timer) then
                        killTimer(timer)
                    end
                    timer = setTimer(function()
                        if isEventHandlerAdded("onClientRender", root, render) then
                            removeEventHandler("onClientRender", root, render)
                        end
                    end, 2500, 1)
                end
                triggerServerEvent("fdryer:action", resourceRoot, aviable_options[selected][2], vehicle, math.floor(speed))
                cooldown[vehicle] = getTickCount()
            end
        end
    end

    if aviable_options[selected][2] == "reczny" then
        local vx, vy, vz = getElementVelocity(vehicle)
        local speed = ((vx^2 + vy^2 + vz^2)^(0.5))*180

        if speed > 5 then
            return
        end

        triggerServerEvent("fdryer:action", resourceRoot, aviable_options[selected][2], vehicle, math.floor(speed))
    end

    if aviable_options[selected][2] == 'tank' then
        local vx, vy, vz = getElementVelocity(vehicle)
        local speed = ((vx^2 + vy^2 + vz^2)^(0.5))*180

        if speed > 5 then
            return
        end

        triggerServerEvent("fdryer:action", resourceRoot, aviable_options[selected][2], vehicle, math.floor(speed))
    end    
end

addEventHandler("onClientPlayerTarget", localPlayer, function(element)
    if element and isElement(element) and isPedAiming(localPlayer) and getPedWeapon(localPlayer) == 22 then
        duty = getElementData(localPlayer, "player:faction")
        if duty then
            if getElementType(element) == 'vehicle' then
                if options[getElementType(element)][duty] then
                    aviable_options = {}
                    selected = 1
                    for i,v in ipairs(options[getElementType(element)][duty]) do
                        table.insert(aviable_options, v)
                    end
                    vehicle = element
                    vehmodel = getElementData(element, 'vehicleID') or getElementModel(element)
                    vehname = exports['since-vehiclenames']:getVehicleName(vehmodel) or 'Błąd'
                    vehid = getElementData(element, 'vehicle:id') or 'Zrespiony'
                    plate = getVehiclePlateText(element)
                    data = getElementData(element, 'vehicle:data') or {}
                    if not isEventHandlerAdded("onClientRender", root, render) then
                        addEventHandler("onClientRender", root, render)
                        bindKey("mouse_wheel_up", "down", up)
                        bindKey("mouse_wheel_down", "down", down)
                        bindKey("mouse1", "down", click)
                    end
                end
            end
        end
    else
        if isEventHandlerAdded("onClientRender", root, render) then
            removeEventHandler("onClientRender", root, render)
            unbindKey("mouse_wheel_up", "down", up)
            unbindKey("mouse_wheel_down", "down", down)
            unbindKey("mouse1", "down", click)
        end
    end
end)

function isPedAiming (thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end

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
getResourceName(getThisResource(), true, 946632806); if true then return end