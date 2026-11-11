local sx, sy = guiGetScreenSize()
local zoom = 1920 / sx

local cache = {}
cache.alpha = 0
cache.progress = 0
cache.progressChange = 0
cache.fonts = {}
local blackwhite = exports['since-3dinteraction']

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function renderBW()
    if(getElementData(localPlayer, "player:bw") < 1)then
        destroyBW()
        triggerLatentServerEvent("spawn.player", resourceRoot)

        if isTimer(cache.timer) then
            killTimer(cache.timer)
        end

        return
    end

    cache.alpha = math.min(1, cache.alpha + 0.01)
    cache.progress = (getElementData(localPlayer, "player:bw") or 0)

    if cache.progressChange > cache.progress then
        cache.progressChange = cache.progressChange - 0.1
    elseif cache.progressChange < cache.progress then
        cache.progressChange = cache.progressChange + 0.1
    end

    cache.progressChange = cache.progressChange / 1

    blackwhite:drawBWRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 100 * cache.alpha), false)
    dxDrawImage(sx - 626/zoom, sy/2 - 540/zoom, 626/zoom, sy, 'data/background.png', 0, 0, 0, tocolor(255, 255, 255, 255 * cache.alpha))
	dxDrawText('Zaliczyłeś zgona', sx - 30/zoom, sy/2 - 40/zoom, nil, nil, tocolor(46, 117, 111, 255 * cache.alpha), 1, cache.fonts[1], 'right', 'bottom')
	dxDrawText('Odrodzisz się za: #7DFF7D'..(getElementData(localPlayer, 'player:bw') or 0)..' sek.', sx - 30/zoom, sy/2 - 40/zoom, nil, nil, tocolor(255, 255, 255, 255 * cache.alpha), 1, cache.fonts[2], 'right', 'top', false, false, false, true)
	dxDrawImage(sx - 322/zoom, sy/2 - 2/zoom, 292/zoom, 6/zoom, 'data/progress.png', 0, 0, 0, tocolor(255, 255, 255, 100 * cache.alpha))
    dxDrawImageSection(sx - 322/zoom, sy/2 - 2/zoom, 292/zoom * (cache.progressChange or 0) / 15, 6/zoom, 0, 0, 292 * (cache.progressChange or 0) / 15, 6, 'data/progress.png', 0, 0, 0, tocolor(46, 117, 111, 255 * cache.alpha))
	
    if cache.killer then
        dxDrawText('Zostałeś zabity przez', sx - 30/zoom, sy/2 + 45/zoom, nil, nil, tocolor(255, 255, 255, 255 * cache.alpha), 1, cache.fonts[1], 'right', 'bottom')
        dxDrawText(cache.killer, sx - 30/zoom, sy/2 + 45/zoom, nil, nil, tocolor(255, 170, 86, 255 * cache.alpha), 1, cache.fonts[2], 'right', 'top')
    end
end

function createBW(killer)
    if killer and getElementType(killer) == 'player' then
        cache.killer = killer and getPlayerName(killer)
    else
        cache.killer = false
    end

    cache.tick = getTickCount()
    cache.time = 60
    cache.progress = 0
    cache.progressChange = 15
    cache.alpha = 0

    cache.fonts = {

        dxCreateFont("fonts/Inter-BlackItalic.ttf", 17/zoom),
        dxCreateFont("fonts/Inter-MediumItalic.ttf", 13/zoom)

    }

    cache.timer = setTimer(function()
        if getElementData(localPlayer, "player:bw") then
            setElementData(localPlayer, "player:bw", (getElementData(localPlayer,"player:bw") or 10) - 1)
        end
    end, 1000, 0)
    triggerLatentServerEvent("kills.top", resourceRoot, cache.killer)
    addEventHandler("onClientRender", root, renderBW)
    showChat(false)
end

function destroyBW()
    removeEventHandler("onClientRender", root, renderBW)

    for i, v in pairs(cache.fonts) do
        destroyElement(v)
    end
    cache.fonts = {}

    showChat(true)
end
addEvent('destroyBW', true)
addEventHandler('destroyBW', resourceRoot, destroyBW)

addEventHandler("onClientPlayerWasted", localPlayer, function(killer)
    if getElementData(localPlayer, 'player:arena') then
        return false
    end

	setElementData(localPlayer, "player:bw", 15)
    createBW(killer)
end)