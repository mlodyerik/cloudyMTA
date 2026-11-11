  

local sx, sy = guiGetScreenSize()
local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1 

local data = {

    currentVehicle = nil,
    vehicleActual = nil,

}

function formatDate(string)
    -- display: 2021-07-01 12:00

    local year, month, day, hour, minute = string:match("(%d+)-(%d+)-(%d+) (%d+):(%d+)")
    return day..'-'..month..'-'..year..' '..hour..':'..minute
    
end

function renderUI()
    if not data.currentVehicle then
        toggleUI(false)
        return
    end

    dxDrawImage(sx/2 - 260/zoom, sy/2 - 168/zoom, 520/zoom, 336/zoom, 'files/images/bg.png')
	dxDrawText('Przedłużanie przeglądu', sx/2 - 1/zoom, sy/2 - 131/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
	dxDrawText('Przegląd', sx/2, sy/2 - 129/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
    
	dxDrawText('Informacje dot. aktualnego przeglądu', sx/2 - 1/zoom, sy/2 - 43/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
	dxDrawText((data.vehicleActual or 'Brak przeglądu'), sx/2 - 1/zoom, sy/2 - 43/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)

    dxDrawText('Koszt', sx/2 - 1/zoom, sy/2 + 10/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
    dxDrawText('Przedłużenie przeglądu o 7 dni wynosi #60FF63$#ffffff '..addCommas(cost), sx/2 - 1/zoom, sy/2 + 10/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)
    
    local isIn = isMouseInPosition(sx/2 - 127/zoom, sy/2 + 79/zoom, 254/zoom, 50/zoom)
	dxDrawImage(sx/2 - 127/zoom, sy/2 + 79/zoom, 254/zoom, 50/zoom, 'files/images/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
	dxDrawText('Przedłuż przegląd', sx/2, sy/2 + 104/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'center')

	dxDrawImage(sx/2 - 184/zoom, sy/2 - 100/zoom, 368/zoom, 2/zoom, 'files/images/line.png')
end

function onClick(btn,state)
    if (btn=="left" and state=="up") then
        if isEventHandlerAdded("onClientRender", root, renderUI) then
            if isMouseInPosition(sx/2 - 127/zoom, sy/2 + 79/zoom, 254/zoom, 50/zoom) then
                local vehicle = data.currentVehicle

                if vehicle then
                    triggerServerEvent('getData', resourceRoot, 'set', vehicle)
                end
            end
        end
   end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
    showCursor(visible, false)
end

addEvent("getData", true)
addEventHandler("getData", resourceRoot, function(eType, ...)
    local args = {...}

    if eType == 'get' then
        data.vehicleActual = args[1]
    elseif eType == 'markerHit' then
        data.currentVehicle = args[1]

        triggerServerEvent('getData', resourceRoot, 'get', data.currentVehicle)

        toggleUI(true)
    elseif eType == 'markerLeave' then
        data.currentVehicle = nil
        data.vehicleActual = nil

        toggleUI(false)
    end
end)