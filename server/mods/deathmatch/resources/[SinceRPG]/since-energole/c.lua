  

local sx, sy = guiGetScreenSize()
local zoom = 1 
if sx < 2048 then
	zoom = math.min(2.2, 2048/sx)
end 

local energy = {}
energy.fonts = {}
energy.imgParts = {
    "bar",
    "bar_bg",
}
energy.img = {}
energy.time = 10 --w sek.
energy.speed = 1.25 --moc energola

energy.tick = getTickCount()

energy.alpha = 0
energy.animInfo = nil
energy.render = (function()
    local time, x = math.max(math.min((energy.tick-getTickCount())/1000, energy.time), 0), math.max(((energy.tick-getTickCount())/1000)/energy.time, 0)
    
    if (energy.animInfo == "open") then
        time, x = 10, 1
    end

    dxDrawImageSection(sx/2-50/zoom, 10/zoom, 100/zoom, 100/zoom, 0, 0, 512, 512, energy.img["bar_bg"], 0, 0, 0, tocolor(255,255,255,155*energy.alpha))
    dxDrawImageSection(sx/2-50/zoom, 10/zoom, 100/zoom, 100/zoom*x, 0, 0, 512, 512*x, energy.img["bar"], 0, 0, 0, tocolor(255,255,255,225*energy.alpha))
    dxDrawText(string.format("%.2f", time).." sek.", sx/2, 120/zoom, _, _, tocolor(67, 143, 135, 245*energy.alpha), 1, energy.fonts[1], "center", "top")
end)

energy.turnEffect = (function(state)
    if state then
        if isPedInVehicle(localPlayer) then
            if (getGameSpeed() ~= 1) then
                setGameSpeed(1)
            end
        else
            if (getGameSpeed() ~= energy.speed) then
                setGameSpeed(energy.speed)
            end
        end
    else
        setGameSpeed(1)
    end
end)

energy.timer = nil
energy.turnTimerCheckingState = (function(state)
    if state then
        energy.timer = setTimer(function()
            if getElementData(localPlayer, "player:energydrink") then
                if isPedInVehicle(localPlayer) then
                    if (getGameSpeed() ~= 1) then
                        setGameSpeed(1)
                    end
                else
                    if getElementData(localPlayer, "player:job") then
                        if (getGameSpeed() ~= 1) then
                            setGameSpeed(1)
                        end
                    else
                        if (getGameSpeed() ~= energy.speed) then
                            setGameSpeed(energy.speed)
                        end
                    end
                end
            end
        end, 200, 0)
    else
        if energy.timer and isTimer(energy.timer) then
            killTimer(energy.timer)
        end
    end
end)

energy.stop = (function()
    if (isEventHandlerAdded("onClientRender", root, energy.render)) then
        energy.turnEffect(false)
        energy.turnTimerCheckingState(false)
        energy.animInfo = "close"
        createAnimation(1, 0, 'InOutQuad', 1000, function(value)
            energy.alpha= value
        end, function()
            for i,v in pairs(energy.img) do
                if isElement(v) then
                    destroyElement(v)
                end
            end
            removeEventHandler("onClientRender", root, energy.render)
            triggerServerEvent("energetyk.s", resourceRoot, "end")
            energy.animInfo = nil
        end)
    end
end)

addEvent("energetyk.c", true)
addEventHandler("energetyk.c", root, function(info)
    if info then
        if (info=="doubleCheck") then
            if (getGameSpeed() ~= 1) then
                setGameSpeed(1)
            end
        end
    else
        if (not isEventHandlerAdded("onClientRender", root, energy.render)) then
            for i,v in ipairs(energy.imgParts) do
                if fileExists("files/images/"..v..".png") then
                    energy.img[v] = dxCreateTexture("files/images/"..v..".png", "argb", true, "clamp")
                end
            end
            energy.fonts[1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom)
            energy.animInfo = "open"
            addEventHandler("onClientRender", root, energy.render)
            createAnimation(0, 1, 'InOutQuad', 2000, function(value)
                energy.alpha = value
            end, function()
                energy.animInfo = nil
                energy.turnEffect(true)
                energy.turnTimerCheckingState(true)
                energy.tick = getTickCount() + (energy.time*1000)
                setTimer(function()
                    energy.stop()
                end, energy.time * 1000, 1)
            end)
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(plr, seal)
    if (plr ~= localPlayer) then
        return
    end
    if getElementData(localPlayer, "player:energydrink") then
        if getGameSpeed() ~= 1 then
            setGameSpeed(1)
        end
    end
end)

addEventHandler("onClientVehicleExit", root, function(plr, seal)
    if (plr ~= localPlayer) then
        return
    end
    if getElementData(localPlayer, "player:energydrink") then
        if (getGameSpeed() ~= energy.speed) then
            setGameSpeed(energy.speed)
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if (source ~= localPlayer) then
        return
    end
    if (not getElementData(localPlayer, "player:energydrink")) then
        return
    end
    if (data == "player:job") then
        if new then
            if (getGameSpeed() ~= 1) then
                setGameSpeed(1)
            end
        else
            if (getGameSpeed() ~= energy.speed) then
                setGameSpeed(energy.speed)
            end
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    if (isEventHandlerAdded("onClientRender", root, energy.render)) then
        for i,v in pairs(energy.img) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        removeEventHandler("onClientRender", root, energy.render)
    end
end)

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

--Animacje \/

local anims, animID = { }, 0
local rendering = false

local function renderAnimations( )
    local now = getTickCount( )
    for k,v in ipairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if now >= v.start+v.duration then
            table.remove(anims, k)
            if type(v.onEnd) == "function" then
                v.onEnd( )
            end
			if #anims == 0 then
				rendering = false
				removeEventHandler("onClientRender", root, renderAnimations)
			end
        end
    end
end

function createAnimation(f, t, easing, duration, onChange, onEnd)
	if #anims == 0 and not rendering then
		addEventHandler("onClientRender", root, renderAnimations)
		rendering = true
	end
    assert(type(f) == "number", "Bad argument @ 'createAnimation' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'createAnimation' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'createAnimation' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'createAnimation' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'createAnimation' [expected function at argument 5, got "..type(onChange).."]")
    animID = animID+1
	table.insert(anims, {id=animID, from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return animID
end

function finishAnimation(anim)
	for k, v in ipairs(anims) do
		if v.id == anim then
			v.onChange(v.to)
			if v.onEnd then v.onEnd() end
			v.start = 0
			return true
		end
	end
end

function deleteAnimation(anim)
	for k, v in ipairs(anims) do
		if v.id == anim then
			table.remove(anims, k)
			break
		end
	end
end

getResourceName(getThisResource(), true, 517771812); if true then return end