-- local loadedVehicles = {}

-- addEventHandler('interface:load', root, function(name)
--     if name == 'factions-parking' then
--         exports['since-ui']:setInterfaceVisible(name, true)
--         exports['since-ui']:triggerInterfaceEvent(name, 'play-animation', true)
--         exports['since-ui']:setInterfaceData(name, 'vehicles', loadedVehicles[getElementData(localPlayer, 'player:faction')])
--     end
-- end)

-- addEventHandler('onClientResourceStop', resourceRoot, function()
--     exports['since-ui']:destroyInterfaceElement('factions-parking')
-- end)

-- addEvent('since-factions-parking:show', true)
-- addEventHandler('since-factions-parking:show', resourceRoot, function(faction)
--     local vehicles = exports['since-factions-new']:getFactionData(faction).vehicles
--     local newVehicles = {}

--     for i,v in pairs(vehicles) do
--         table.insert(newVehicles, {
--             modelName = getVehicleNameFromModel(v.model),
--             model = v.model,
--             rank = v.rank,
--             visualRank = exports['since-factions-new']:getFactionData(faction).ranks[v.rank]
--         })
--     end

--     loadedVehicles[faction] = newVehicles
--     exports['since-ui']:loadInterfaceElementFromFile('factions-parking', 'since-factions-parking/data/html/index.html')
-- end)

-- addEvent('since-factions-parking:hide', true)
-- addEventHandler('since-factions-parking:hide', resourceRoot, function()
--     exports['since-ui']:triggerInterfaceEvent('factions-parking', 'play-animation', false)

--     setTimer(function()
--         exports['since-ui']:setInterfaceVisible('factions-parking', false)
--         exports['since-ui']:destroyInterfaceElement('factions-parking')
--     end, 500, 1)
-- end)

-- addEvent('since-factions-parking:showSpecialData', true)
-- addEventHandler('since-factions-parking:showSpecialData', resourceRoot, function()
--     local factionVehicles = exports['since-factions-new']:getFactionData(getElementData(localPlayer, 'player:faction')).vehicles
--     local vehicle = getPedOccupiedVehicle(localPlayer)

--     for i,v in pairs(factionVehicles) do
--         if v.model == getElementModel(vehicle) then
--             if v.specialData then
--                 v.specialData(vehicle)
--             end
--         end
--     end
-- end)

local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local savedData = {}

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRectangle(x, y, w, height, tocolor(148, 255, 139,alpha*0.2))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 0 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end
		
        dxDrawRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), tocolor(148, 255, 139, alpha))
    else
        dxDrawRectangle(x, y, w, height, tocolor(148, 255, 139,alpha))
	end
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local k = 1
local n = 6
local m = 6

function render()
    dxDrawImage(sx - 440/zoom - 20/zoom, sy/2-460/zoom/2, 445/zoom, 460/zoom, 'data/images/bg.png')
    dxDrawImage(sx - 440/zoom - 20/zoom + 15/zoom, sy/2-460/zoom/2 + 17/zoom, 34/zoom, 34/zoom, 'data/images/icon.png')

    dxDrawText('Parking wirtualny', sx - 440/zoom - 20/zoom + 15/zoom + 34/zoom + 10/zoom, sy/2-460/zoom/2 + 24/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
    dxDrawText('Frakcja '..getElementData(localPlayer, 'player:faction')..'', sx - 440/zoom - 20/zoom + 15/zoom + 34/zoom + 10/zoom, sy/2-460/zoom/2 + 24/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom)), nil, nil, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'left', 'center')

    dxDrawImage(sx - 440/zoom - 20/zoom + 15/zoom, sy/2-460/zoom/2 + 70/zoom, 440/zoom, 2/zoom, 'data/images/line.png')
    
    
    local x = 0
    for i, v in pairs(savedData) do
        if i >= k and i <= n then

            dxDrawImage(sx - 440/zoom - 20/zoom + 440/zoom/2 - 420/zoom/2, sy/2-460/zoom/2 + 70/zoom + x, 420/zoom, 60/zoom, 'data/images/list-bg.png')
            dxDrawText(getVehicleNameFromModel(v.model), sx - 440/zoom - 20/zoom + 440/zoom/2 - 420/zoom/2 + 13/zoom, sy/2-460/zoom/2 + 70/zoom + x + 20/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
            dxDrawText('Dostepny od rangi: #68D65E'..exports['since-factions-new']:getFactionData(getElementData(localPlayer, 'player:faction')).ranks[v.rank], sx - 440/zoom - 20/zoom + 440/zoom/2 - 420/zoom/2 + 13/zoom, sy/2-460/zoom/2 + 70/zoom + x + 20/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom)), nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center', false, false, false, true)
            
            dxDrawImage(sx - 440/zoom - 20/zoom + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 70/zoom + x + 60/zoom/2 - 33/zoom/2, 88/zoom, 33/zoom, 'data/images/button.png', 0, 0, 0, tocolor(255, 255, 255, (isMouseInPosition(sx - 440/zoom - 20/zoom + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 70/zoom + x + 60/zoom/2 - 33/zoom/2, 88/zoom, 33/zoom) and 255 or 200)))
            dxDrawText('Wybierz', sx - 440/zoom + 88/zoom/2 - 20/zoom + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 70/zoom + x + 60/zoom/2 - 33/zoom/2 + 33/zoom/2, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')

            x = x + 60/zoom + 4/zoom
        end
    end

    drawScrollbar(savedData, sx - 440/zoom - 20/zoom + 440/zoom - 3/zoom, sy/2-460/zoom/2 + 70/zoom, 3/zoom, 375/zoom, m, k, 255)
end

function wheelUp()
    if k > 1 then
        k = k - 1
        n = n - 1
    end
end

function wheelDown()
    if n < #savedData then
        k = k + 1
        n = n + 1
    end
end

function click(button, state)
    if button == 'left' and state == 'down' then
        local x = 0
        for i, v in pairs(savedData) do
            if i >= k and i <= n then
                if isMouseInPosition(sx - 440/zoom - 20/zoom + 440/zoom/2 - 420/zoom/2 + 420/zoom - 88/zoom - 13/zoom, sy/2-460/zoom/2 + 70/zoom + x + 60/zoom/2 - 33/zoom/2, 88/zoom, 33/zoom) then
                    triggerServerEvent('since-factions-parking:tryGetVehicle', resourceRoot, v.model)
                    return
                end

                x = x + 60/zoom + 4/zoom
            end
        end
    end
end

addEvent('since-factions-parking:show', true)
addEventHandler('since-factions-parking:show', resourceRoot, function (faction)
    addEventHandler('onClientRender', root, render)
    addEventHandler('onClientClick', root, click)
    showCursor(true, false)

    savedData = exports['since-factions-new']:getFactionData(faction).vehicles

    bindKey('mouse_wheel_up', 'down', wheelUp)
    bindKey('mouse_wheel_down', 'down', wheelDown)
end)

addEvent('since-factions-parking:hide', true)
addEventHandler('since-factions-parking:hide', resourceRoot, function ()
    removeEventHandler('onClientRender', root, render)
    removeEventHandler('onClientClick', root, click)
    showCursor(false)
    unbindKey('mouse_wheel_up', 'down', wheelUp)
    unbindKey('mouse_wheel_down', 'down', wheelDown)
end)