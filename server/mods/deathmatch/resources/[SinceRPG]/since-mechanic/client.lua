local selectedCount = 0
local k = 1
local n = 10
local m = 10
local costTable = nil

function renderUI()
	local x, y, z = getElementPosition(localPlayer)
	local zoneName = getZoneName(x, y, z, true)..', '..getZoneName(x, y, z, false)
    exports['since-blur']:dxDrawBlur(sx/2 - 298/zoom, sy/2 - 218/zoom, 595/zoom, 436/zoom, textures.mask)
	dxDrawImage(sx/2 - 298/zoom, sy/2 - 218/zoom, 595/zoom, 436/zoom, 'data/bg.png')

	local isIn = isMouseInPosition(sx/2 + 262/zoom, sy/2 - 200/zoom, 20/zoom, 20/zoom)
	dxDrawImage(sx/2 + 262/zoom, sy/2 - 200/zoom, 20/zoom, 20/zoom, 'data/close.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 185 or 255))
	dxDrawText('Mechanik samochodowy', sx/2 - 284/zoom, sy/2 - 185/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom')
	dxDrawText(zoneName, sx/2 - 284/zoom, sy/2 - 185/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'top')

	if #data.toFix == 0 then
		dxDrawText('⚠ #ffffffPojazd jest sprawny', sx/2, sy/2, nil, nil, tocolor(255, 200, 0, 255), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom), 'center', 'bottom', false, false, false, true)
		dxDrawText('Twój pojazd jest w pełni sprawny!', sx/2, sy/2, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
	else
		dxDrawText('NAZWA CZĘŚCI', sx/2 - 251/zoom, sy/2 - 137/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 10/zoom), 'left', 'top')
		dxDrawText('STAN CZĘŚCI', sx/2 - 84/zoom, sy/2 - 137/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 10/zoom), 'left', 'top')
		dxDrawText('KOSZT NAPRAWY', sx/2 + 120/zoom, sy/2 - 137/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 10/zoom), 'left', 'top')
	
		local offset = 0
		for i, v in ipairs(data.toFix) do
			if i >= k and i <= n then 
				local isIn = isMouseInPosition(sx/2 - 258/zoom, sy/2 - 115/zoom + offset, 516/zoom, 24/zoom) and 0.5 or 1
				dxDrawImage(sx/2 - 258/zoom, sy/2 - 115/zoom + offset, 516/zoom, 24/zoom, 'data/selected.png', 0, 0, 0, data.selectedParts[i] and tocolor(241, 245, 244, 225) or tocolor(255, 255, 255, 100*isIn))
	
				dxDrawText(data.selectedParts[i] and '#5cfa6c● #ffffff'..v[1] or '#b4b4b4● #ffffff'..v[1], sx/2 - 251/zoom, sy/2 - 104/zoom + offset, nil, nil, data.selectedParts[i] and tocolor(241, 245, 244, 225) or tocolor(255, 255, 255, 155*isIn), 1, exports['since-fonts']:getFont('Inter-Medium', 9.333/zoom), 'left', 'center', false, false, false, true)
		   
				local r, g, b = unpack(getColorNumer(v[69]))
				dxDrawText('⛊ #ffffff'..v[69]..' %', sx/2 - 84/zoom, sy/2 - 104/zoom + offset, nil, nil, data.selectedParts[i] and tocolor(r, g, b, 225) or tocolor(r, g, b, 155*isIn), 1, exports['since-fonts']:getFont('Inter-Medium', 9.333/zoom), 'left', 'center', false, false, false, true)
				dxDrawText('$#ffffff '..addCommas(costTable[i]), sx/2 + 120/zoom, sy/2 - 104/zoom + offset, nil, nil, data.selectedParts[i] and tocolor(46, 117, 111, 225) or tocolor(46, 117, 111, 155*isIn), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9.333/zoom), 'left', 'center', false, false, false, true)
	
				offset = offset + 24/zoom + 1
			end
		end

		local isIn = isMouseInPosition(sx/2 - 257/zoom, sy/2 + 164/zoom, 121/zoom, 30/zoom)
		dxDrawImage(sx/2 - 257/zoom, sy/2 + 164/zoom, 121/zoom, 30/zoom, 'data/button_fix.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 190 or 255))
		dxDrawText('Napraw pojazd', sx/2 - 196/zoom, sy/2 + 179/zoom, nil, nil, tocolor(255, 255, 255, isIn and 190 or 225), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center')
		
		local isIn = isMouseInPosition(sx/2 - 131/zoom, sy/2 + 164/zoom, 145/zoom, 30/zoom)
		dxDrawImage(sx/2 - 131/zoom, sy/2 + 164/zoom, 145/zoom, 30/zoom, 'data/button_selectall.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 190 or 255))
		dxDrawText(selectedCount == #data.toFix and 'Odznacz wszystko' or 'Zaznacz wszystko', sx/2 - 58/zoom, sy/2 + 179/zoom, nil, nil, tocolor(255, 255, 255, isIn and 190 or 225), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom), 'center', 'center')
	
		dxDrawText('Podsumowanie kosztów', sx/2 + 258/zoom, sy/2 + 175/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'right', 'bottom')
		dxDrawText('Do zapłaty #5cfa6c$ '..addCommas(data.cost), sx/2 + 258/zoom, sy/2 + 175/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'right', 'top', false, false, false, true)	
		
		drawScrollbar(data.toFix, sx/2 + 263/zoom, sy/2 - 115/zoom, 2, 247/zoom, m, k, 255)
	end
end


function onClick(btn, state)
    if (btn == 'left' and state == 'down') then
		if isMouseInPosition(sx/2 + 262/zoom, sy/2 - 200/zoom, 20/zoom, 20/zoom) then
			toggleUI(false)
		end

		if isMouseInPosition(sx/2 - 131/zoom, sy/2 + 164/zoom, 145/zoom, 30/zoom) and #data.toFix > 0 then
			for i, v in ipairs(data.toFix) do
				data.selectedParts[i] = not data.selectedParts[i]
				
				if (data.selectedParts[i]) then
					data.cost = data.cost + costTable[i]
					selectedCount = selectedCount + 1
				else
					selectedCount = selectedCount - 1
					data.cost = data.cost - costTable[i]
				end
			end
		end

		if isMouseInPosition(sx/2 - 257/zoom, sy/2 + 164/zoom, 121/zoom, 30/zoom) and #data.toFix > 0 then
			local function getElementsOnSelected()
				local count = 0

				for i = 1, #carParts do
					if data.selectedParts[i] then
						count = count + 1
					end
				end

				return count
			end
			
			if (getElementsOnSelected() == 0) then
				exports['since-notifications']:sendNotification('error', 'Aby naprawic pojazd musisz zaznaczyc przynajmniej 1 część')
			else
				local tbl = {}
				local cost = 0
				for i,v in pairs(data.toFix) do
					if data.selectedParts[i] then
						table.insert(tbl, v[2])
						cost = cost + costTable[i]
					end
				end

				if #tbl > 0 then
					triggerServerEvent("fixMechVehicle", resourceRoot, localPlayer, getPedOccupiedVehicle(localPlayer), tbl, cost)
				end
			end
		end

        local offset = 0
    	for i, v in ipairs(data.toFix) do
			if i >= k and i <= n then 
				if isMouseInPosition(sx/2 - 258/zoom, sy/2 - 115/zoom + offset, 516/zoom, 24/zoom) then
					data.selectedParts[i] = not data.selectedParts[i]

					if (data.selectedParts[i]) then
						selectedCount = selectedCount + 1
						data.cost = data.cost + costTable[i]
					else
						selectedCount = selectedCount - 1
						data.cost = data.cost - costTable[i]
					end
				end

				offset = offset + 24/zoom + 1
			end
        end
    end
end

function refreshUI()
	data.toFix = getTable()
    k = 1
    n = 10
    m = 10
    data.cost = 0
    data.selectedParts = {}
	selectedCount = 0
end

addEvent('updateMechanicGUI', true)
addEventHandler('updateMechanicGUI', root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		if getElementData(veh, 'vehicle:rank') then
			costTable = partCostFaction
		else
			costTable = partCostFaction
			--costTable = partCost
		end
	end
	
    refreshUI()
end)

function toggleUI(visible)
	if visible then
		refreshUI()

		if #data.toFix == 0 then
			return exports['since-notifications']:sendNotification('info', 'Twój pojazd jest sprawny')
		end
	end

	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local playerData = getElementData(localPlayer, 'player:data') or {}
		
		if getElementData(veh, 'vehicle:rank') then
			costTable = partCostFaction
		elseif playerData['visualRank'] == 'Sponsor' then
			costTable = partCostSponsor
		else
			costTable = partCostFaction
			--costTable = partCost
		end
	end

	data.toFix = getTable()
	data.toggle = visible
    local eventCallback = visible and addEventHandler or removeEventHandler


	showCursor(visible, false)
    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
end

bindKey("mouse_wheel_down", "both", function()
    if data.toggle then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if data.toggle then
        scrollDown()
    end
end)

function scrollDown()
    if n == m then return end
    k = k-1
    n = n-1
end

function scrollUp()
    if n >= #data.toFix then return end
    k = k+1
    n = n+1
end

function startScript()
	for i, v in pairs(blips) do
		createBlip(v[1], v[2], v[3],27,2,255,255,255,255,0,450)
	end
	for i, v in pairs(positions) do
		local marker = createMarker(v[1], v[2], v[3] - 1, "cylinder", 5, 125, 255, 125, 150)
		setElementData(marker,'marker:title', 'Mechanik')
		setElementData(marker,'marker:desc', 'Naprawa pojazdow')
		setElementData(marker,'marker:icon', 'repair')

		local function getPlayersOnDuty()
			local count = 0
			local players = getElementsByType('player')

			for i, v in ipairs(players) do
				if getElementData(v, 'player:job') == 'mechanik' then
					count = count + 1
				end
			end

			return count
		end

		addEventHandler('onClientMarkerHit', marker, function(plr)
			if (plr ~= localPlayer) then return end
			if not getPedOccupiedVehicle(localPlayer) then
				return
			end

			if not getElementData(localPlayer, 'player:faction') then
				if getPlayersOnDuty() > 0 then
					exports['since-notifications']:sendNotification('error', 'Nie możesz korzystać z automatycznego mechanika, ponieważ ktoś pracuje jako mechanik.')
					return
				end
			end

			toggleUI(true)
		end)

		addEventHandler('onClientMarkerLeave', marker, function(plr)
			if (plr ~= localPlayer) then return end
			if not getPedOccupiedVehicle(localPlayer) then
				return
			end

			toggleUI(false)
		end)
	end
end
addEventHandler('onClientResourceStart', resourceRoot, startScript)
getResourceName(getThisResource(), true, 119072965); if true then return end