local sx, sy = guiGetScreenSize()
local zoom = 1920/sx


local positions = { --pozycje z pedami do napadów
	{position = {2392.08, -1910.54, 13.55, 0}, skin = 209, dim = 0},
	{position = {2116.86, -1804.15, 13.55, 90}, skin = 155, dim = 0},
	{position = {802.14, -1610.98, 13.59, 180}, skin = 209, dim = 0},
    {position = {1202.27, -912.39, 43.27, 99.9}, skin = 155, dim = 0},

}

local czas = 90 --czas oczekiwania na koniec napadu
local wyplata = {600000000, 800000000}

ped = {}

for i,v in ipairs(positions) do
    local ped = createPed(v.skin, unpack(v.position))
    createBlipAttachedTo(ped, 29, 2, 255, 255, 255, 255, 0, 450)
    setElementData(ped, "ped:napad", true)
    setElementFrozen(ped, true)
    --setElementInterior(ped, 10)
    setElementDimension(ped, v.dim)

    addEventHandler("onClientPedDamage", ped, cancelEvent)
end

local px, py = 0, 0
option1 = false

local checkboxs = {}

local hp, shield = 100, 100
local opx, opy = false, false

local os = "y"

local tick, sec = getTickCount(), 25

function render()
    dxDrawImage(sx/2 - 1653/zoom/2, sy/2 - 1006/zoom/2, 1653/zoom, 1006/zoom, textures[1], 0, 0, 0, white, false)

    for i=1,5 do
        dxDrawImage(sx/2 + 20/zoom + ((i-1)*50/zoom), sy/2 - 350/zoom, 40/zoom, 40/zoom, textures[7], 0, 0, 0, white, false)
        if checkboxs[i] then
            if checkboxs[i].state then
                dxDrawImage(sx/2 + 30/zoom + ((i-1)*50/zoom), sy/2 - 340/zoom, 21/zoom, 20/zoom, textures[8], 0, 0, 0, tocolor(80, 174, 54), false)
            else
                dxDrawImage(sx/2 + 30/zoom + ((i-1)*50/zoom), sy/2 - 340/zoom, 21/zoom, 20/zoom, textures[8], 0, 0, 0, tocolor(208, 75, 61), false)
            end
        end
    end

    if getTickCount() - tick >= 1000 then
        if sec == 0 then
        	exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
            myTick = getTickCount()
            setCursorAlpha(255)
            showCursor(false)
            removeEventHandler("onClientRender", root, render)
            removeEventHandler("onClientClick", root, click)
            destroydx()
        end
        sec = sec - 1
        tick = getTickCount()
    end

    dxDrawImage(sx/2 - 180/zoom, sy/2 - 355/zoom, 52/zoom, 52/zoom, textures[6], 0, 0, 0, white, false)
    dxDrawText("00:"..string.format("%02d", sec), sx/2 - 115/zoom, sy/2 - 330/zoom, left, center, tocolor(242, 207, 29), 1, fonts[1], "left", "center", false, false, false, false)

    dxDrawImage(sx/2 - 325/zoom, sy/2 + 200/zoom, 39/zoom, 52/zoom, textures[4], 0, 0, 0, white, false)
    dxDrawText(hp, sx/2 - 260/zoom, sy/2 + 225/zoom, left, center, tocolor(242, 207, 29), 1, fonts[1], "left", "center", false, false, false, false)
    dxDrawImage(sx/2 - 100/zoom, sy/2 + 200/zoom, 38/zoom, 52/zoom, textures[4], 0, 0, 0, white, false)
    dxDrawText(shield, sx/2 - 35/zoom, sy/2 + 225/zoom, left, center, tocolor(242, 207, 29), 1, fonts[1], "left", "center", false, false, false, false)

    if os == "x" then
        if px/zoom >= 1080/zoom then
            opx = true
        elseif px/zoom <= 0/zoom then
            opx = false
        end

        if opx then
            px = px - 3
        else
            px = px + 3
        end

        if opx then
            dxDrawImage(sx/2 - 700/zoom + px/zoom, sy/2 - 50/zoom, 51/zoom, 46/zoom, textures[3], 0, 0, 0, white, false)
        else
            dxDrawImage(sx/2 - 700/zoom + px/zoom, sy/2 - 50/zoom, 51/zoom, 46/zoom, textures[3], 180, 0, 0, white, false)
        end
    else
        if py/zoom >= 615/zoom then
            opy = true
        elseif py/zoom <= 0/zoom then
            opy = false
        end

        if opy then
            py = py - 3
        else
            py = py + 3
        end

        if opy then
            dxDrawImage(sx/2, sy/2 - 380/zoom + py/zoom, 51/zoom, 46/zoom, textures[3], 90, 0, 0, white, false)
        else
            dxDrawImage(sx/2, sy/2 - 380/zoom + py/zoom, 51/zoom, 46/zoom, textures[3], -90, 0, 0, white, false)
        end
    end

    if isCursorShowing() then
        local cx, cy = getCursorPosition()
        dxDrawImage(cx*sx, cy*sy, 60/zoom, 60/zoom, textures[2], 0, 0, 0, white, false)
    end
end 
--addEventHandler("onClientRender", root, render)

local m, s = 0, 0

function renderStarting()
    if getTickCount() - tickTT >= 1000 then
        if m <= 0 and s <= 0 then
            triggerServerEvent("enonek-napad:end", resourceRoot)
            destroydx()
            removeEventHandler("onClientRender", root, renderStarting)
            return false
        end
        if s <= 0 then
            s = 60
            m = m - 1
        end

        s = s - 1
        tickTT = getTickCount()
    end
    dxDrawImage(sx/2 - 200/zoom, sy/2 + 443/zoom, 400/zoom, 74/zoom, 'files/bg2.png')
    dxDrawText('Do końca napadu pozostało', sx/2, sy/2 + 448/zoom, nil, nil, tocolor(185, 185, 185, 219), 1, fonts[3], 'center', 'top')
    dxDrawText(string.format('%02d', m)..':'..string.format('%02d', s), sx/2, sy/2 + 480/zoom, nil, nil, tocolor(46, 117, 111, 242), 1, fonts[4], 'center', 'top')
end

function wasted()
	if isEventHandlerAdded("onClientRender", root, renderStarting) then
		removeEventHandler("onClientRender", root, renderStarting)
        destroydx()
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, wasted)

addEvent("enonek-napad:end:client", true)
addEventHandler("enonek-napad:end:client", resourceRoot, function()
    if isEventHandlerAdded("onClientRender", root, renderStarting) then
		removeEventHandler("onClientRender", root, renderStarting)
        destroydx()
	end
end)

function randomSpawn()
    local random = math.random(1, 2)
    if random == 1 then
        os = "x"
    else
        os = "y"
    end
    px, py = 0, 0
end

function start()
    removeEventHandler("onClientRender", root, render)
    removeEventHandler("onClientClick", root, click)
    myTick = getTickCount()
    setCursorAlpha(255)
    showCursor(false)
    m, s = 1, 59
    tickTT = getTickCount()
    addEventHandler("onClientRender", root, renderStarting)
    triggerServerEvent("enonek-napady:insert:cooldown", resourceRoot)
    triggerServerEvent('napad:sapd:info', resourceRoot)
end

function click(b, s)
    if b == "left" and s == "down" then
        if os == "x" then
            if shield == 0 then
                if isMouseIn((sx/2 - 700/zoom + px/zoom) - 51/zoom/2, sy/2 - 50/zoom - 46/zoom/2, 51/zoom, 46/zoom) then
                    if hp == 50 then
                        if #checkboxs >= 4 then
                            count = 0
                            for i,v in ipairs(checkboxs) do
                                if v.state then
                                    count = count + 1
                                end
                            end
                            if count < 3 then
                                removeEventHandler("onClientRender", root, render)
                                destroydx()
                                removeEventHandler("onClientClick", root, click)
                                exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
                                myTick = getTickCount()
                                setCursorAlpha(255)
                                showCursor(false)
                            else
                                start()
                            end
                        else
                            table.insert(checkboxs, {state=true})
                            hp, shield = 100, 100
                            randomSpawn()
                        end
                    else
                        hp = hp - 50
                    end
                else
                    if #checkboxs >= 4 then
                        count = 0
                        for i,v in ipairs(checkboxs) do
                            if v.state then
                                count = count + 1
                            end
                        end
                        if count < 3 then
                            removeEventHandler("onClientRender", root, render)
                            destroydx()
                            removeEventHandler("onClientClick", root, click)
                            exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
                            myTick = getTickCount()
                            setCursorAlpha(255)
                            showCursor(false)
                        else
                            start()
                        end
                    else
                        table.insert(checkboxs, {state=false})
                    end
                end
            else
                if isMouseIn((sx/2 - 700/zoom + px/zoom) - 51/zoom/2, sy/2 - 50/zoom - 46/zoom/2, 51/zoom, 46/zoom) then
                    shield = shield - 50
                else
                    if #checkboxs >= 4 then
                        count = 0
                        for i,v in ipairs(checkboxs) do
                            if v.state then
                                count = count + 1
                            end
                        end
                        if count < 3 then
                            removeEventHandler("onClientRender", root, render)
                            destroydx()
                            removeEventHandler("onClientClick", root, click)
                            exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
                            myTick = getTickCount()
                            setCursorAlpha(255)
                            showCursor(false)
                        else
                            start()
                        end
                    else
                        table.insert(checkboxs, {state=false})
                    end
                end
            end
        else
            if shield == 0 then
                if isMouseIn(sx/2 - 51/zoom/2, (sy/2 - 380/zoom + py/zoom) - 46/zoom/2, 51/zoom, 46/zoom) then
                    if hp == 50 then
                        if #checkboxs >= 4 then
                            count = 0
                            for i,v in ipairs(checkboxs) do
                                if v.state then
                                    count = count + 1
                                end
                            end
                            if count < 3 then
                                removeEventHandler("onClientRender", root, render)
                                destroydx()
                                removeEventHandler("onClientClick", root, click)
                                exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
                                myTick = getTickCount()
                                setCursorAlpha(255)
                                showCursor(false)
                            else
                                start()
                            end
                        else
                            table.insert(checkboxs, {state=true})
                            hp, shield = 100, 100
                            randomSpawn()
                        end
                    else
                        hp = hp - 50
                    end
                else
                    if #checkboxs >= 4 then
                        count = 0
                        for i,v in ipairs(checkboxs) do
                            if v.state then
                                count = count + 1
                            end
                        end
                        if count < 3 then
                            removeEventHandler("onClientRender", root, render)
                            destroydx()
                            removeEventHandler("onClientClick", root, click)
                            exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
                            myTick = getTickCount()
                            setCursorAlpha(255)
                            showCursor(false)
                        else
                            start()
                        end
                    else
                        table.insert(checkboxs, {state=false})
                    end
                end
            else
                if isMouseIn(sx/2 - 51/zoom/2, (sy/2 - 380/zoom + py/zoom) - 46/zoom/2, 51/zoom, 46/zoom) then
                    shield = shield - 50
                else
                    if #checkboxs >= 4 then
                        count = 0
                        for i,v in ipairs(checkboxs) do
                            if v.state then
                                count = count + 1
                            end
                        end
                        if count < 3 then
                            removeEventHandler("onClientRender", root, render)
                            destroydx()
                            removeEventHandler("onClientClick", root, click)
                            exports['since-notifications']:sendNotification('error', 'Niestety, nie udało Ci się.. Spróbuj ponownie za 30 sekund')
                            myTick = getTickCount()
                            setCursorAlpha(255)
                            showCursor(false)
                        else
                            start()
                        end
                    else
                        table.insert(checkboxs, {state=false})
                    end
                end
            end
        end
    end
end
--addEventHandler("onClientClick", root, click)

function destroydx()
    for i,v in ipairs(textures) do
        if isElement(v) then
            destroyElement(v)
        end
    end

    textures = {}
    fonts = {}
end


addEvent("enonek-napad:set:cooldown", true)
addEventHandler("enonek-napad:set:cooldown", resourceRoot, function(state)
    if state then
        if isEventHandlerAdded("onClientRender", root, render) then
            return false
        end
        px, py = 0, 0
        checkboxs = {}
        hp, shield = 100, 100
        opx, opy = false, false
        tick, sec = getTickCount(), 25
        randomSpawn()
        textures = {
            [1] = dxCreateTexture("files/bg.png"),
            [2] = dxCreateTexture("files/crosshair.png"),
            [3] = dxCreateTexture("files/ped.png"),
        
            [4] = dxCreateTexture("files/hp.png"),
            [5] = dxCreateTexture("files/shield.png"),
            [6] = dxCreateTexture("files/clock.png"),
            [7] = dxCreateTexture("files/box.png"),
            [8] = dxCreateTexture("files/x.png"),
        
        }
        
        fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Medium', 13/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Medium', 19/zoom),
            [3] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom),
            [4] = exports['since-fonts']:getFont('Inter-Medium', 14/zoom),
        }
        addEventHandler("onClientRender", root, render)
        addEventHandler("onClientClick", root, click)
        showCursor(true)
        setCursorAlpha(0)
    else
        exports['since-notifications']:sendNotification('error', 'Napady można wykonywać co 5 minut')
    end
end)


local function renders()
	local target = getPedTarget(localPlayer)

	if getPedWeapon(localPlayer) == 0 then
        return false
    end

	if target and isElement(target) and getElementType(target) == "ped" then
		if getElementData(target, "ped:napad") and isPedAiming(localPlayer) then
			if getElementInterior(localPlayer) == getElementInterior(target) and getElementDimension(localPlayer) == getElementDimension(target) then
                if myTick then
                    if getTickCount() - myTick < 30000 then
                        return false
                    end
                end

                if tempTick then
                    if getTickCount() - tempTick < 5000 then
                        return false
                    end
                end

				if not isEventHandlerAdded("onClientRender", root, render) then
                    triggerServerEvent("enonek-napad:get:cooldown", resourceRoot)
                    tempTick = getTickCount()
                end
			end
		end
	end
end
addEvent("enonek-napady:toggleRend", true)
addEventHandler("enonek-napady:toggleRend", resourceRoot, function(state)
    if (state) then
        addEventHandler("onClientRender", root, renders)
    else
        removeEventHandler("onClientRender", root, renders)
    end
end)

function isPedAiming(thePedToCheck)
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


function isMouseIn( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end
getResourceName(getThisResource(), true, 858780364); if true then return end
