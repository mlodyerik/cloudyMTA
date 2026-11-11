sx, sy = guiGetScreenSize()
zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1
local score = 0
local failDrift = false
local fps = getFPSLimit()
local vehicle = false
local red = tocolor(255,55,55)
local orange = tocolor(255, 255, 255)
local isDriftToggle = false

local allowedType = {
	["Automobile"] = true,
	["Quad"] = true,
	["Monster Truck"] = true
}

local function convertNumber ( number )
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if ( k==0 ) then
			break
		end
	end
	return formatted
end

local function driftEnd(endscore)
	if failDrift then
		return false
	end
	if endscore > 1000 then
		triggerServerEvent("enonek-drift:update", resourceRoot, endscore)
	end
end

local function calculateAngle ()
	if not allowedType[getVehicleType(vehicle)] then return 0,0 end
	if not isVehicleOnGround(vehicle) then return 0,0 end
	if failDrift then return 0,0 end
	
	local vx,vy,vz = getElementVelocity(vehicle)
	local rx,ry,rz = getElementRotation(vehicle)
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	local speed = (vx^2 + vy^2 + vz^2)^(0.5)
	local modV = math.sqrt(vx*vx + vy*vy)
	local cosX = (sn*vx + cs*vy)/modV
	
	if modV <= 0.2 then return 0,0 end
	if cosX > 0.966 or cosX < 0 then return 0,0 end
	
	return math.deg(math.acos(cosX))*0.5,speed
end

local function updateFPS(msSinceLastFrame)
    fps = (1 / msSinceLastFrame) * 1000
end

local function resetFail()
	failDrift = false
	showScore=false
end

local function onCollide(attacker)
	if attacker or failDrift then return end
	failDrift = true
	driftEnd(0,0)
	setTimer(resetFail,2000,1)
end

local tick_int, scale = getTickCount(), 1.5

function calculateMultipler()
	if score >= 10000 and score < 20000 then
		return 2
	elseif score >= 20000 and score < 30000 then
		return 3
	elseif score >= 30000 and score < 40000 then
		return 4
	elseif score >= 40000 and score < 75000 then
		return 5
	elseif score > 75000 then
		return 5
	else
		return 1
	end
end

function getText()
	if score < 10000 then
		return 'Słabiutko Ci to idzie!'
	elseif score >= 10000 and score < 20000 then
		return 'Coraz lepiej..'
	elseif score >= 20000 and score < 30000 then
		return 'Dobry drifter z Ciebie!'
	elseif score >= 30000 and score < 40000 then
		return 'Prawie jak Ken Block!'
	elseif score >= 40000 and score < 50000 then
		return 'Najlepszy drifter w mieście!'
	elseif score >= 50000 then
		return 'Ikona driftu!'
	end
end

local function drawMeter()
	if not getPedOccupiedVehicle(localPlayer) then return false end

	if not getElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:toggleDriftmode') then 
		return false
	end
	
	if getPedOccupiedVehicle(localPlayer) ~= vehicle or not vehicle then
		removeEventHandler("onClientRender", root, drawMeter)
		removeEventHandler("onClientPreRender", root, updateFPS)
		vehicle = nil
		return false
	end
	
	local angle, speed = calculateAngle()

	if isTimer (resetTimer) and angle ~= 0 then
		killTimer(resetTimer)
		showScore = true
	end

	if angle == 0 then
		if not isTimer(resetTimer) then
			resetTimer = setTimer (function()
				if score == 0 then return end
				driftEnd(score)
				score = 0
				showScore = false
			end,2000,1)
		end
	end

	local gameSpeed = getGameSpeed()
	local fpsMultiplier = 100/fps
	local angleScore = angle/2
	local speedScore = speed*3
	local driftScore = angleScore*speedScore
	local addScore = math.floor(driftScore*1)
	local gameSpeedFixedScore = math.floor(gameSpeed*addScore)
	score = score + math.floor(fpsMultiplier*gameSpeedFixedScore) * calculateMultipler()

	if showScore then
		local color = (failDrift and red or orange)
		local scoreMultipler = calculateMultipler()
		local scoreText = getText()
		dxDrawText(score, sx/2 + 1 - 15/zoom, sy/2 - 325/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-Black', 32/zoom), "center", "bottom", false, false, false, false, false)
		dxDrawText(score, sx/2 - 15/zoom, sy/2 - 325/zoom, nil, nil, color, 1, exports['since-fonts']:getFont('Inter-Black', 32/zoom), "center", "bottom", false, false, false, false, false)

		local textWidth = dxGetTextWidth(score, 1, exports['since-fonts']:getFont('Inter-Black', 32/zoom))
		
		if failDrift then
			dxDrawCircle(sx/2 + textWidth/2 + 5/zoom, sy/2 - 352/zoom, 20/zoom, 0, 360, tocolor(255, 155, 155, 0), tocolor(255, 155, 155, 125), 128)
			dxDrawText('x'..scoreMultipler, sx/2 + textWidth/2 + 5/zoom + 1, sy/2 - 352/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Black', 12/zoom), "center", "center", false, false, false, false, false)
			dxDrawText('x'..scoreMultipler, sx/2 + textWidth/2 + 5/zoom, sy/2 - 352/zoom, nil, nil, tocolor(255, 155, 155, 255), 1, exports['since-fonts']:getFont('Inter-Black', 12/zoom), "center", "center", false, false, false, false, false)
			dxDrawText('Tracisz punkty przez kolizje!', sx/2 + 1, sy/2 - 325/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "center", "top", false, false, false, false, false)
			dxDrawText('Tracisz punkty przez kolizje!', sx/2, sy/2 - 325/zoom, nil, nil, tocolor(255, 155, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "center", "top", false, false, false, false, false)
		else
			dxDrawCircle(sx/2 + textWidth/2 + 5/zoom, sy/2 - 352/zoom, 20/zoom, 0, 360, tocolor(155, 255, 155, 0), tocolor(155, 255, 155, 125), 128)
			dxDrawText('x'..scoreMultipler, sx/2 + textWidth/2 + 5/zoom + 1, sy/2 - 352/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Black', 12/zoom), "center", "center", false, false, false, false, false)
			dxDrawText('x'..scoreMultipler, sx/2 + textWidth/2 + 5/zoom, sy/2 - 352/zoom, nil, nil, tocolor(155, 255, 155, 255), 1, exports['since-fonts']:getFont('Inter-Black', 12/zoom), "center", "center", false, false, false, false, false)
			dxDrawText(scoreText, sx/2 + 1, sy/2 - 325/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "center", "top", false, false, false, false, false)
			dxDrawText(scoreText, sx/2, sy/2 - 325/zoom, nil, nil, tocolor(155, 255, 155), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "center", "top", false, false, false, false, false)
		end
	end
end

local function onVehicleEnter(ped, seat)
	if ped == localPlayer and seat == 0 and allowedType[getVehicleType(source)] then
		vehicle = source
		addEventHandler("onClientVehicleDamage", source, onCollide)
		addEventHandler("onClientRender", root, drawMeter)
		addEventHandler("onClientPreRender", root, updateFPS)
	end
end

local function onVehicleExit(ped, seat)
	if ped == localPlayer and seat == 0 then
		if isEventHandlerAdded("onClientRender", root, drawMeter) then
			removeEventHandler("onClientVehicleDamage", vehicle, onCollide)
			removeEventHandler("onClientRender", root, drawMeter)
			removeEventHandler("onClientPreRender", root, updateFPS)
			vehicle = nil
		end
	end
end
addEventHandler("onClientVehicleEnter", root, onVehicleEnter)
addEventHandler("onClientVehicleExit", root, onVehicleExit)

function addComma(number)
	number = tostring(number)
	return number:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local gifts = {

	[1] = '300 wPLN',
	[2] = '250 wPLN',
	[3] = '100 wPLN + Car Box',
	[4] = '100 wPLN',

}

function render()
	exports['since-blur']:dxDrawBlur(sx/2 - 920/zoom/2, sy/2 - 580/zoom/2, 920/zoom, 580/zoom, textures[2])
    dxDrawImage(sx/2 - 920/zoom/2, sy/2 - 580/zoom/2, 920/zoom, 580/zoom, textures[1], 0, 0, 0, tocolor(255, 255, 255), false)
    dxDrawText("TOP 10 Drifterów", sx/2, sy/2 - 260/zoom, center, center, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), "center", "center", false, false, false, false)
	
    if not loaded then
        dxDrawText("Trwa wczytywanie danych..", sx/2, sy/2, center, center, white, 1/zoom, exports['since-fonts']:getFont('Inter-SemiBold', 16/zoom), "center", "center", false, false, false, false)
    else
        dxDrawText("Lista najlepszych drifterów", sx/2 - 400/zoom, sy/2 - 185/zoom, left, center, tocolor(155, 255, 155), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), "left", "center", false, false, false, false)
        for i = 1, 10 do
            local v = loaded[i]
			if not v then
				dxDrawText(i..". #b8b8b8Brak danych", sx/2 - 400/zoom, sy/2 - 155/zoom + ((i-1)*33/zoom), left, center, tocolor(255, 255, 255, 100), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), "left", "center", false, false, false, true)
			else
            	dxDrawText(i..". "..v.login..": #9bff9b"..addComma(v.pkt)..' pkt.', sx/2 - 400/zoom, sy/2 - 155/zoom + ((i-1)*33/zoom), left, center, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), "left", "center", false, false, false, true)
			end
        end

		dxDrawText("Lista nagród", sx/2 + 400/zoom, sy/2 - 185/zoom, left, center, tocolor(255, 175, 0), 1, exports['since-fonts']:getFont('Inter-Bold', 17/zoom), "right", "center", false, false, false, false)
		for i = 1, 10 do
			if gifts[i] then
				dxDrawText(i..". "..gifts[i], sx/2 + 400/zoom, sy/2 - 155/zoom + ((i-1)*33/zoom), left, center, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), "right", "center", false, false, false, true)
			else
				dxDrawText(i..". #b8b8b8Brak nagrody", sx/2 + 400/zoom, sy/2 - 155/zoom + ((i-1)*33/zoom), left, center, tocolor(255, 255, 255, 100), 1, exports['since-fonts']:getFont('Inter-Medium', 14/zoom), "right", "center", false, false, false, true)
			end
		end

        dxDrawText("Liczba twoich punktów driftu: #9bff9b"..addComma(mypkt or 0)..' pkt.', sx/2, sy/2 + 260/zoom, center, center, tocolor(212, 212, 212), 1, exports['since-fonts']:getFont('Inter-Medium', 15/zoom), "center", "center", false, false, false, true)
    end
end

addEvent("enonek-drift:loadRecords", true)
addEventHandler("enonek-drift:loadRecords", resourceRoot, function(table, table2)
    loaded = table
	if table2 and #table2 > 0 then
		mypkt = table2[1].pkt
	else
		mypkt = 0
	end
end)

local last = false

function toggle()
    if isEventHandlerAdded("onClientRender", root, render) then
        removeEventHandler("onClientRender", root, render)
        for i,v in ipairs(textures) do
            if isElement(v) then
                destroyElement(v)
            end
        end

        textures = {}
    else
        if last then
            if getTickCount() - last < 5000 then
				outputChatBox("#ff0000✘ #ffffffOdczekaj chwilę przed ponownym użyciem panelu!", _, _, _, true)
                return false
            end
        end
        loaded = false
        setTimer(function()
            triggerServerEvent("enonek-drift:getRecords", resourceRoot)
        end, 400, 1)
        textures = {
            [1] = dxCreateTexture("assets/bg.png"),
            [2] = dxCreateTexture("assets/mask.png"),
        }
        addEventHandler("onClientRender", root, render)
        last = getTickCount()
    end
end
bindKey("F9", "down", toggle)

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