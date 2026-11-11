local data = {

    targetVehicle = nil,
    jobInfo = {

        location = nil,
        time = 0,
        tick = 0,

    },
    toFix = {},
    selectedParts = {},
    cost = 0,
    selectedCount = 0
    

}

function renderUI()
    if data.jobInfo.tick + 60000 <= getTickCount() then
        data.jobInfo.time = data.jobInfo.time + 1
        data.jobInfo.tick = getTickCount()
    end
    
    dxDrawText('Mechanik '..data.jobInfo.location, sx/2 + 1, 40/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom', false, false, false, true)
    dxDrawText('Mechanik #5c9dff'..data.jobInfo.location, sx/2, 40/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom', false, false, false, true)
    dxDrawText('Przepracowany czas: '..convertTime(data.jobInfo.time), sx/2 + 1, 40/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)
    dxDrawText('Przepracowany czas: #2E756F'..convertTime(data.jobInfo.time), sx/2, 40/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)

    local multiplier = exports["since-jobs"]:getJobMultiplier('mechanik')
    if multiplier > 1 then
        dxDrawText('Aktywna premia +'..(multiplier*100)..'% do zarobku', sx/2 + 1, 58/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top', false, false, false, true)
        dxDrawText('Aktywna premia #f5bc42+'..(multiplier*100)..'% do zarobku', sx/2, 58/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top', false, false, false, true)    
    end
end

local k = 1
local n = 6
local m = 6

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

local pos, camerapos, count, AFK = false, false, 0, false
local function isAFK()
    if (getElementData(localPlayer, "player:job") == 'mechanik') then
        if pos and camerapos then
            local cx, cy, cz, lx, ly, lz = getCameraMatrix(localPlayer)
            local x, y, z = getElementPosition(localPlayer)

            if (x == pos[1] and y == pos[2] and z == pos[3] and cx == camerapos[1] and cy == camerapos[2] and cz == camerapos[3] and lx == camerapos[4] and ly == camerapos[5] and lz == camerapos[6]) then
                count = count + 1
                if (count >= 60 and not AFK) then
                    AFK = true
                    outputChatBox('↻ #FFFFFFPrzechodzisz w tryb afk, za 5 minut praca zostanie zakończona.', 125, 255, 125, true)

                    if count >= 300 then
                        local location = getElementData(localPlayer, "player:jobLocation")

                        if location then
                            triggerServerEvent('toggleJob', resourceRoot, location, false)
                        end
                    end
                end
            else
                if AFK then
                    AFK = false
                    outputChatBox('↻ #FFFFFFWznawiasz tryb gry..', 125, 255, 125, true)
                end
                pos, camerapos, count = false, false, 0
            end
        else
            local cx, cy, cz, lx, ly, lz = getCameraMatrix(localPlayer)
            local x, y, z = getElementPosition(localPlayer)
            pos, camerapos = {x, y, z}, {cx, cy, cz, lx, ly, lz}
        end
    end
end
setTimer(isAFK, 1000, 0)

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(155, 155, 155, alpha*0.2))

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
        
        dxDrawRoundedRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), w/2, tocolor(155, 155, 155, alpha * 0.9))
    else
        dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(155, 155, 155, alpha * 0.9))
    end
end

function renderMechanic()
	dxDrawImage(sx/2 - 271/zoom, sy/2 - 247/zoom, 542/zoom, 494/zoom, 'data/background.png')

    local isIn = isMouseIn(sx/2 - 159/zoom, sy/2 + 196/zoom, 154/zoom, 33/zoom)
	dxDrawImage(sx/2 - 159/zoom, sy/2 + 196/zoom, 154/zoom, 33/zoom, 'data/button_offer.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 200))
	dxDrawText('Napraw', sx/2 - 82/zoom, sy/2 + 212.5/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')

    local isIn = isMouseIn(sx/2 + 5/zoom, sy/2 + 196/zoom, 154/zoom, 33/zoom)
	dxDrawImage(sx/2 + 5/zoom, sy/2 + 196/zoom, 154/zoom, 33/zoom, 'data/button_cancel.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 200))
	dxDrawText('Anuluj', sx/2 + 82/zoom, sy/2 + 212.5/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')

    local model = getElementData(data.targetVehicle, 'vehicle:model')
	dxDrawText('Mechanik', sx/2, sy/2 - 203/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'bottom')
	dxDrawText('Naprawiasz pojazd #2E756F'..exports['since-vehiclenames']:getVehicleName(model), sx/2, sy/2 - 203/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top', false, false, false, true)
    
    
    if #data.toFix == 0 then
        dxDrawText('Pojazd jest sprawny', sx/2, sy/2, nil, nil, tocolor(255, 125, 125, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
        dxDrawText('Brak części do naprawy', sx/2, sy/2, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 10/zoom), 'center', 'top')
        return
    end
    
    dxDrawImage(sx/2 - 251/zoom, sy/2 - 168/zoom, 504/zoom, 301/zoom, 'data/list_bg.png')
	dxDrawImage(sx/2 - 251/zoom, sy/2 - 168/zoom, 504/zoom, 30/zoom, 'data/list_top.png')
	dxDrawText('Nazwa części', sx/2 - 235/zoom, sy/2 - 145/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom')
	dxDrawText('Kwota naprawy', sx/2 - 54/zoom, sy/2 - 145/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'bottom')

    local offset = 0
    for i, v in ipairs(data.toFix) do
        if i >= k and i <= n then
            local alpha = data.selectedParts[i] and 1 or (isMouseIn(sx/2 - 258/zoom, sy/2 - 115/zoom + offset, 516/zoom, 24/zoom) and 0.35 or 0.65)
            dxDrawImage(sx/2 - 244/zoom, sy/2 - 131/zoom + offset, 470/zoom, 34/zoom, 'data/item_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
            dxDrawText(v[1], sx/2 - 235/zoom, sy/2 - 106/zoom + offset, nil, nil, tocolor(255, 255, 255, 255 * alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom')
            dxDrawText('$ #ffffff'..convertNumber(partCost[i] or 0), sx/2 - 54/zoom, sy/2 - 106/zoom + offset, nil, nil, tocolor(46, 117, 111, 255 * alpha), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'left', 'bottom', false, false, false, true)
        
            offset = offset + 34/zoom + 4/zoom
        end
    end

    drawScrollbar(data.toFix, sx/2 + 236/zoom, sy/2 - 131/zoom, 6/zoom, offset - 5/zoom, m, k, 255)

	dxDrawText('Koszta naprawy', sx/2, sy/2 + 159/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'bottom')
	dxDrawText('$ #ffffff'..convertNumber(data.cost), sx/2, sy/2 + 159/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Black', 13/zoom), 'center', 'top', false, false, false, true)

    local isIn = isMouseIn(sx/2 - 251/zoom, sy/2 + 103/zoom, 136/zoom, 30/zoom)
	dxDrawImage(sx/2 - 251/zoom, sy/2 + 103/zoom, 136/zoom, 30/zoom, 'data/button_select.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 255 or 200))
	dxDrawText(data.selectedCount == #data.toFix and 'Odznacz wszystko' or 'Zaznacz wszystko', sx/2 - 183/zoom, sy/2 + 118/zoom, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center')
end

function toggleUI(bool, thevehicle)
    if bool then
        data.targetVehicle = thevehicle
        data.selectedParts = {}
        data.cost = 0
        data.selectedCount = 0
        data.toFix = getTable(thevehicle)
        addEventHandler('onClientRender', root, renderMechanic)
        addEventHandler('onClientClick', root, onClick)
    else
        removeEventHandler('onClientRender', root, renderMechanic)
        removeEventHandler('onClientClick', root, onClick)
    end

    showCursor(bool)
end
addEvent('toggleRepairUI', true)
addEventHandler('toggleRepairUI', resourceRoot, toggleUI)

function onClick(btn, state)
    if (btn == 'left' and state == 'down') then
        if isMouseIn(sx/2 + 5/zoom, sy/2 + 196/zoom, 154/zoom, 33/zoom) then
            toggleUI(false)
        end

        if isMouseIn(sx/2 - 159/zoom, sy/2 + 196/zoom, 154/zoom, 33/zoom) then
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
				local fixedtbl = {}
				local cost = 0
				for i,v in pairs(data.toFix) do
					if data.selectedParts[i] then
						table.insert(fixedtbl, v[2])
						cost = cost + partCost[i]
					end
				end

				if #fixedtbl > 0 then
					triggerServerEvent("fixMechVehicle", resourceRoot, data.targetVehicle, fixedtbl, cost)
				end
			end

            toggleUI(false)
        end

        if isMouseIn(sx/2 - 251/zoom, sy/2 + 103/zoom, 136/zoom, 30/zoom) then
            for i, v in ipairs(data.toFix) do
                data.selectedParts[i] = not data.selectedParts[i]
				
				if (data.selectedParts[i]) then
					data.cost = data.cost + partCost[i]
					data.selectedCount = data.selectedCount + 1
				else
					data.selectedCount = data.selectedCount - 1
					data.cost = data.cost - partCost[i]
				end
            end
        end

        local offset = 0
        for i, v in ipairs(data.toFix) do
            if i >= k and i <= n then
                if isMouseIn(sx/2 - 244/zoom, sy/2 - 131/zoom + offset, 470/zoom, 34/zoom) then
                    data.selectedParts[i] = not data.selectedParts[i]
				
                    if (data.selectedParts[i]) then
                        data.cost = data.cost + partCost[i]
                        data.selectedCount = data.selectedCount + 1
                    else
                        data.selectedCount = data.selectedCount - 1
                        data.cost = data.cost - partCost[i]
                    end
                end

                offset = offset + 34/zoom + 4/zoom
            end
        end
    end
end

addEvent('toggleJob', true)
addEventHandler('toggleJob', resourceRoot, function(location, bool)
    if bool then
        data.jobInfo.location = location
        data.jobInfo.time = 0
        data.jobInfo.tick = getTickCount()
        addEventHandler('onClientRender', root, renderUI)
    else
        data.jobInfo.location = false
        removeEventHandler('onClientRender', root, renderUI)
    end
end)

bindKey("mouse_wheel_down", "both", function()
    if isEventHandlerAdded('onClientRender', root, renderMechanic) then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if isEventHandlerAdded('onClientRender', root, renderMechanic) then
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