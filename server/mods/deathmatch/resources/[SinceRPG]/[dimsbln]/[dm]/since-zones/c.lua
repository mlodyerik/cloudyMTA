local sx, sy = guiGetScreenSize()
local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1 
local elements = {}
local renderTargets = {}
local main = {}
main['anims'] = {
    tick = getTickCount(),
    state = 'up',
    anim = 0,
}

local texts = {
    {'Data przejęcia strefy', function(v)
        return v.takenDate and convertDate(v.takenDate) or 'Brak'
    end},
    {'Strefa podlega organizacji', function(v)
        return v.takenByOrganizationName or 'Brak'
    end},
    {'Godzinny zarobek', function(v)
        return v.hourlyIncome and v.takenByOrganizationLevel and formatNumber(v.hourlyIncome + (32550 * v.takenByOrganizationLevel))..' $' or v.hourlyIncome and formatNumber(v.hourlyIncome)..' $' or 'Brak' 
    end},
    {'Łączny zarobek ze strefy', function(v)
        return v.moneyEarned and formatNumber(v.moneyEarned)..' $' or 'Brak'
    end},
    {'POZIOM', function(v)
        return v.takenByOrganizationLevel or 1
    end},
    {'Strefa przejęta przez gracza', function(v)
        return v.takenByPlayer or 'Brak'
    end},
    {'Pozostały czas do przejęcia', function(v)
        return formatTime(v.timeToCapture or 0)
    end},
    {'Strefa przejmowana przez', function(v)
        return v.isTaken and getPlayerName(v.isTaken) or 'Brak'
    end}
}

function loadRenderTarget(element)
    if not renderTargets[element] then
        renderTargets[element] = dxCreateRenderTarget(512, 512, true)
    end
    local data = getElementData(element, 'zone:data')
    if not data then return end
    local x,y,z = getElementPosition(element)
    dxSetRenderTarget(renderTargets[element], true)
        dxSetBlendMode('modulate_add')
        dxDrawImage(0, 101, 512, 310, 'files/images/bg.png', 0, 0, 0, tocolor(255,255,255,255))
        dxDrawImage(447, 116, 50, 50, 'files/images/levelFrame.png', 0, 0, 0, tocolor(255,255,255,255))
        dxDrawText(texts[5][2](data), 447+25, 116+36, nil, nil, tocolor(94,171,214,255), 1, exports['since-fonts']:getFont('Inter-Black', 19), 'center', 'bottom')
        dxDrawText(texts[5][1], 447+25, 116+34, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 6), 'center', 'top')

        dxDrawText('Strefa organizacji', 437, 116+25, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Bold', 13), 'right', 'bottom')
        dxDrawText(texts[2][2](data), 437, 116+25, nil, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Medium', 10), 'right', 'top')

        dxDrawText('Statystyki strefy', 256, 195, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 14), 'center', 'bottom')
        dxDrawImage(15, 202, 482, 120, 'files/images/lines.png', 0, 0, 0, tocolor(255,255,255,255))
        
        local offset = 0
        for i=1,4 do
            dxDrawImage(14, 208+offset, 484, 26, 'files/images/bar.png', 0, 0, 0, tocolor(255,255,255,255))
            dxDrawText(texts[i][1], 21, 221+offset, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'left', 'center')
            dxDrawText(texts[i][2](data), 491, 221+offset, nil, nil, tocolor(104,214,94,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'right', 'center')
            offset = offset + 27
        end

        if data.isTaken then
            dxDrawText(texts[7][1], 256, 350, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Bold', 12), 'center', 'bottom')
            dxDrawText(texts[7][2](data), 256, 350, nil, nil, tocolor(84,193,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'center', 'top')  
            dxDrawText(texts[8][1]..' #54C1FF'..texts[8][2](data), 256, 390, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'center', 'center', false, false, false, true)
        else
            dxDrawText(texts[6][1], 256, 350, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Bold', 12), 'center', 'bottom')
            dxDrawText(texts[6][2](data), 256, 350, nil, nil, tocolor(84,193,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'center', 'top')
            dxDrawText('Aby zacząć przejmować strefę kliknij #54C1FFE', 256, 390, nil, nil, tocolor(255,255,255,255), 1, exports['since-fonts']:getFont('Inter-Medium', 11), 'center', 'center', false, false, false, true)
        end

        dxSetBlendMode('blend')
    dxSetRenderTarget()
end


function preRender()
    local px,py,pz = getElementPosition(localPlayer)
    for element, _ in pairs(elements) do
        if renderTargets[element] then
            local x,y,z = getElementPosition(element)
            dxDrawMaterialLine3D(x,y,z+0.1 + 2.5 + main['anims'].anim, x,y,z+0.1 + main['anims'].anim, renderTargets[element], 2.5, tocolor(255,255,255,255), false, px,py,pz)
        end
    end
end

function render()
	local elements = getElementsByType('object', resourceRoot, true)
	if (#elements > 0) then
		local px,py,pz = getElementPosition(localPlayer)
		local count = 0
		for i, v in ipairs(elements) do
			local x,y,z = getElementPosition(v)
			if (getDistanceBetweenPoints3D(px,py,pz, x,y,z) < 100) then
				count = count + 1
				local r,g,b = unpack((getElementData(v, 'zone:data') and getElementData(v, 'zone:data')['color'] or {255,255,255}))
				local z1, z2 = z-0.2+main['anims'].anim, 7+main['anims'].anim
				dxDrawOctagon3D(x,y,z1-0.25, z2, 2, tocolor(r,g,b,155))
			end
		end
		if (count > 0) then
			if main['anims'].state == 'up' then
				local progress = (getTickCount() - main['anims'].tick)/1555
				main['anims'].anim = interpolateBetween(0, 0, 0, 0.1, 0, 0, progress, 'InOutQuad')
				if progress >= 1 then
					main['anims'].state = 'down'
					main['anims'].tick = getTickCount()
				end
			elseif main['anims'].state == 'down' then
				local progress = (getTickCount() - main['anims'].tick)/1555
				main['anims'].anim = interpolateBetween(0.1, 0, 0, 0, 0, 0, progress, 'InOutQuad')
				if progress >= 1 then
					main['anims'].state = 'up'
					main['anims'].tick = getTickCount()
				end
			end
		end
	end
end

function checkIfPlayerCanInteract(object)
    local player = localPlayer
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then return false end
    if isPedDead(player) then return false end
	if isPedInVehicle(player) then return false end
    if getElementData(player, 'player:admin') then return false end
	if getElementData(player, 'player:job') then return false end
	if not getElementData(player, 'player:organization') then return false end
	if getElementData(player, 'player:faction') then return false end
	if getElementData(player, 'temp:bw:ghost') then return false end
    local px,py,pz = getElementPosition(player)
    local ox,oy,oz = getElementPosition(object)
    if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 7 then return false end
    return true
end

local tick = getTickCount()
function clickKey()
    local object = getNearestElement(localPlayer, 'object', 10)
    if object and isElement(object) then
        local data = getElementData(object, 'zone:data')
        local organization = getElementData(localPlayer, 'player:organization')
        if not organization then return end
        if not data or data.takenByOrganization == organization.id or data.isTaken then return end
        if checkIfPlayerCanInteract(object) then
            if tick > getTickCount() then return end
            tick = getTickCount() + 500
            triggerServerEvent('zonesEvent', resourceRoot, object)
        end
    end
end

function switchState(state)
    if state then
        loadEvent('onClientPreRender', root, preRender)
        loadEvent('onClientRender', root, render)
        if not main['binded'] then
            bindKey('e', 'down', clickKey)
            main['binded'] = true
        end
    else
        removeEvent('onClientPreRender', root, preRender)
        removeEvent('onClientRender', root, render)
        if main['binded'] then
            unbindKey('e', 'down', clickKey)
            main['binded'] = nil
        end
    end
end

addEventHandler('onClientElementDataChange', resourceRoot, function(key)
    if key == 'zone:data' and isElementStreamedIn(source) then
        loadRenderTarget(source)
    end
end)

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    elements[source] = true
    loadRenderTarget(source)
    switchState(true)
end)

addEventHandler('onClientElementStreamOut', resourceRoot, function()
    elements[source] = nil
    if getElementsCount(elements) == 0 then
        switchState(false)
    end
end)

addEventHandler('onClientElementDestroy', resourceRoot, function()
    elements[source] = nil
    if getElementsCount(elements) == 0 then
        switchState(false)
    end
end)

addEvent('event', true)
addEventHandler('event', resourceRoot, function()
    for i,v in ipairs(getElementsByType('object', resourceRoot)) do
        if isElementStreamedIn(v) then
            elements[v] = true
            switchState(true)
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    setTimer(function()
        for i,v in ipairs(getElementsByType('object', resourceRoot)) do
            if isElementStreamedIn(v) then
                elements[v] = true
                switchState(true)
            end
        end
        if getElementsCount(elements) == 0 then
            switchState(false)
        end
    end, 500, 1)
end)

addEventHandler('onClientRestore', root, function()
    if getElementsCount(elements) > 0 then
        for element,_ in pairs(elements) do
            loadRenderTarget(element)
        end
    end
end)

function formatTime(time)
	time = time or 0
	if time <= 0 then
		return '00:00'
	else
		hours = string.format('%02.f', math.floor(time/60))
		mins = string.format('%02.f', math.floor(time - (hours*60)))
		return ''..hours..':'..mins
	end
end