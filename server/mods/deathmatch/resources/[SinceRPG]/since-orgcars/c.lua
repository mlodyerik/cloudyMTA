local markers = {
    {1475.21, -1785.47, 18.73}, -- urząd LS
    {2454.85, 2357.2, 12.16}, -- urząd LV
}

for i,v in ipairs(markers) do
	local marker = createMarker(v[1], v[2], v[3]-1, 'cylinder', 1.5, 125, 255, 125, 100)
    setElementData(marker, 'marker:title', 'Organizacje')
    setElementData(marker, 'marker:desc', 'Przepisywanie pojazdów')
    setElementData(marker, 'marker:icon', 'skin')
end

local data = {
    vehicles = {},
}

local k, n, m = 1, 5, 5

local mask = dxCreateTexture('files/images/mask.png')

function render()
    exports['since-blur']:dxDrawBlur(sx/2 - 250/zoom, sy/2 - 316/zoom, 497/zoom, 632/zoom, mask)
	dxDrawImage(sx/2 - 250/zoom, sy/2 - 316/zoom, 497/zoom, 632/zoom, 'files/images/bg.png')
	dxDrawText('Przepisywanie pojazdów', sx/2, sy/2 - 270/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
	dxDrawText('Przepisz pojazd na organizację', sx/2, sy/2 - 270/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
    
    local isIn = isMouseIn(sx/2 - 151/zoom, sy/2 + 265/zoom, 299/zoom, 35/zoom)
	dxDrawImage(sx/2 - 151/zoom, sy/2 + 265/zoom, 299/zoom, 35/zoom, 'files/images/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
	dxDrawText('Zamknij panel', sx/2, sy/2 + 282/zoom, nil, nil, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

    local isIn = isMouseIn(sx/2 - (167/zoom)/2, sy/2 + 199/zoom, 167/zoom, 44/zoom)
	dxDrawImage(sx/2 - (167/zoom)/2, sy/2 + 199/zoom, 167/zoom, 44/zoom, 'files/images/button_offer.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 215 or 255))
    local text = 'Wybierz pojazd'
    if data.selectedVehicle then
        if tonumber(data.vehicles[data.selectedVehicle].organization) and tonumber(data.vehicles[data.selectedVehicle].organization) > 0 then
            text = 'Odpisz'
        else
            text = 'Przepisz'
        end
    end
	dxDrawText(text, sx/2 - (167/zoom)/2, sy/2 + 199/zoom, sx/2 - (167/zoom)/2+167/zoom, sy/2 + 199/zoom+44/zoom, tocolor(255, 255, 255, isIn and 185 or 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'center')

    local offset = 0
    for i, v in ipairs(data.vehicles) do
        if i >= k and i <= n then 

            dxDrawImage(sx/2 - 214/zoom, sy/2 - 235/zoom + offset, 427/zoom, 80/zoom, data.selectedVehicle == i and 'files/images/list_bg_selected.png' or 'files/images/list_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawText(exports['since-vehiclenames']:getVehicleName(v.model), sx/2 - 196/zoom, sy/2 - 196/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'left', 'bottom')
            local t, r, g, b = 'Pojazd nie przepisany na organizację', 255, 125, 125
            if tonumber(v.organization) and tonumber(v.organization) > 0 then
                t, r, g, b = 'Pojazd przepisany na organizację', 125, 255, 125
            end
            dxDrawText(t:gsub("#%x%x%x%x%x%x", ""), sx/2 - 196/zoom, sy/2 - 182/zoom + offset, nil, nil, tocolor(0, 0, 0, 25), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')
            dxDrawText(t:gsub("#%x%x%x%x%x%x", ""), sx/2 - 196/zoom, sy/2 - 180/zoom + offset, nil, nil, tocolor(0, 0, 0, 25), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')
            dxDrawText(t:gsub("#%x%x%x%x%x%x", ""), sx/2 - 194/zoom, sy/2 - 182/zoom + offset, nil, nil, tocolor(0, 0, 0, 25), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')
            dxDrawText(t:gsub("#%x%x%x%x%x%x", ""), sx/2 - 194/zoom, sy/2 - 180/zoom + offset, nil, nil, tocolor(0, 0, 0, 25), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')
            dxDrawText(t, sx/2 - 195/zoom, sy/2 - 181/zoom + offset, nil, nil, tocolor(r, g, b, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'center')

            local textWidth = dxGetTextWidth(exports['since-vehiclenames']:getVehicleName(v.model), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom) )
            local textWidth2 = dxGetTextWidth(v.id, 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom) ) + 15/zoom
            dxDrawRoundedRectangle(sx/2 - 200/zoom + 10/zoom + textWidth, sy/2 - 217/zoom + offset, textWidth2, 20/zoom, 10/zoom, tocolor(148, 255, 139, 100))
            dxDrawText(v.id, sx/2 - 200/zoom + 11/zoom + textWidth + textWidth2/2, sy/2 - 206/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'center')

            local isIn = isMouseIn(sx/2 + 105/zoom, sy/2 - 210/zoom + offset, 88/zoom, 30/zoom)
            dxDrawImage(sx/2 + 105/zoom, sy/2 - 210/zoom + offset, 88/zoom, 30/zoom, data.selectedVehicle == i and 'files/images/button_selected.png' or 'files/images/button.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
            dxDrawText(data.selectedVehicle == i and 'Wybrano' or 'Wybierz', sx/2 + 149/zoom + 1, sy/2 - 195/zoom + offset + 1, nil, nil, tocolor(0, 0, 0, isIn and 55 or 75), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
            dxDrawText(data.selectedVehicle == i and 'Wybrano' or 'Wybierz', sx/2 + 149/zoom, sy/2 - 195/zoom + offset, nil, nil, tocolor(255, 255, 255, isIn and 175 or 225), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'center', 'center')
            
            offset = offset + 80/zoom + 3
        end
    end

    if #data.vehicles > 5 then
        drawScrollbar(data.vehicles, sx/2 + 220/zoom, sy/2 - 235/zoom, 2, 410/zoom, m, k, 155)
    end
end

local block = getTickCount()
function click(btn, state)
    if btn == 'left' and state == 'down' and isEventHandlerAdded('onClientRender', root, render) and block < getTickCount() then
        block = getTickCount()+500
        if isMouseIn(sx/2 - 151/zoom, sy/2 + 265/zoom, 299/zoom, 35/zoom) then
            removeEventHandler('onClientRender', root, render)
            removeEventHandler('onClientClick', root, click)
            showCursor(false)
            return
        elseif isMouseIn(sx/2 - (167/zoom)/2, sy/2 + 199/zoom, 167/zoom, 44/zoom) and data.selectedVehicle then
            local org = getElementData(localPlayer, 'player:organization')
            if not org or not data.vehicles[data.selectedVehicle] then return end
            local orgData = tonumber(data.vehicles[data.selectedVehicle].organization) and tonumber(data.vehicles[data.selectedVehicle].organization) > 0 and true or false
            triggerServerEvent(orgData and 'since-orgcars:getVehicleOutOrg' or 'since-orgcars:giveVehicleOnOrg', resourceRoot, data.vehicles[data.selectedVehicle].id, org.id)
        end

        local offset = 0
        for i, v in ipairs(data.vehicles) do
            if i >= k and i <= n then 
                if isMouseIn(sx/2 + 105/zoom, sy/2 - 210/zoom + offset, 88/zoom, 30/zoom) then
                    data.selectedVehicle = i
                end
                offset = offset + 80/zoom + 3
            end
        end
    end
end

function scrollDown()
    if isEventHandlerAdded('onClientRender', root, render) then
        scrollUp2()
    end
end

function scrollUp()
    if isEventHandlerAdded('onClientRender', root, render) then
        scrollDown2()
    end
end

function scrollDown2()
    if n == m then return end
    k = k-1
    n = n-1
end

function scrollUp2()
    if n >= #data.vehicles then return end
    k = k+1
    n = n+1
end

addEvent('since-orgcars:getVehicles', true)
addEventHandler('since-orgcars:getVehicles', resourceRoot, function(tbl)
    if not isEventHandlerAdded('onClientRender', root, render) then
        return
    end
    data.vehicles = {}
    data.vehicles = #tbl > 1 and table.sort(tbl, function(a, b) return a.id < b.id end) or tbl
end)

addEventHandler('onClientMarkerHit', resourceRoot, function(el, md)
    if el ~= localPlayer or not md or isEventHandlerAdded('onClientRender', root, render) or not getElementData(localPlayer, 'player:organization') then return end
    k, n, m = 1, 5, 5
    data.selectedVehicle = nil
    data.vehicles = {}
    addEventHandler('onClientRender', root, render)
    addEventHandler('onClientClick', root, click)
    bindKey("mouse_wheel_down", "both", scrollDown)
    bindKey("mouse_wheel_up", "both", scrollUp)
    triggerServerEvent('since-orgcars:getVehicles', resourceRoot)
    showCursor(true)
end)

addEventHandler('onClientMarkerLeave', resourceRoot, function(el, md)
    if el ~= localPlayer or not md or not isEventHandlerAdded('onClientRender', root, render) then return end
    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientClick', root, click)
    showCursor(false)
    unbindKey("mouse_wheel_down", "both", scrollDown)
    unbindKey("mouse_wheel_up", "both", scrollUp)
end)


getResourceName(getThisResource(), true, 92706068); if true then return end