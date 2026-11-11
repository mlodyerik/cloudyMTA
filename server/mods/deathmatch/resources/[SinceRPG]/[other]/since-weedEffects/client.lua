
local sx, sy = guiGetScreenSize()
local sxh, syh = sx/2, sy/2
local zoom = (sx < 2048 and math.min(2.2, 2048/sx) or 1)

local interface = {}

addEventHandler('onClientResourceStop', resourceRoot, function()
    if interface.weedId and effects[interface.weedId] then
        effects[interface.weedId].onEnd()
    end
end)

function renderInterface()
    local alpha = interface.alpha

    dxDrawImage(sxh - 296/zoom, sy - 143/zoom, 582/zoom, 82/zoom, interface.textures['backgroundGlow'], 0, 0, 0, tocolor(255, 255, 255, alpha), true)
    dxDrawImage(sxh - 268/zoom, sy - 120/zoom, 536/zoom, 36/zoom, interface.textures['background'], 0, 0, 0, tocolor(255, 255, 255, alpha), true)

    local tick = math.max(interface.timeTick-getTickCount(), 0)
    local progress = tick/interface.timeToEnd

    dxDrawImageSection(sxh - 268/zoom, sy - 120/zoom, 536/zoom*progress, 36/zoom, 0, 0, 536*progress, 36, interface.textures['bar'], 0, 0, 0, tocolor(255, 255, 255, alpha), true)

    local time = formatTickToTime(tick)
    dxDrawText('Pozostało '..time, sxh+1, sy - 102/zoom+1, nil, nil, tocolor(0, 0, 0, 155*(alpha/255)), 1, interface.fonts[1], 'center', 'center', false, false, true, false, false)
    dxDrawText('Pozostało '..time, sxh, sy - 102/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, interface.fonts[1], 'center', 'center', false, false, true, false, false)

    dxDrawText('Aktywny narkotyk: '..interface.weedName, sxh+1, sy - 130/zoom+1, nil, nil, tocolor(0, 0, 0, 155*(alpha/255)), 1, interface.fonts[2], 'center', 'bottom', false, false, true, true)
    dxDrawText('Aktywny narkotyk: #87FF7C'..interface.weedName, sxh, sy - 130/zoom, nil, nil, tocolor(255, 255, 255, alpha), 1, interface.fonts[2], 'center', 'bottom', false, false, true, true)

    if progress <= 0 then
        endWeedEffect()
    end
end

function useWeed(name)
    if interface.block or interface.animating or not name or not effects[name] then return false end
    interface.block = true
    interface.animating = true
    loadInterface()
    interface.timeToEnd = effects[name].time or 60000
    interface.weedName = effects[name].name or 'Nieznany'
    interface.weedId = name
    interface.timeTick = getTickCount() + interface.timeToEnd
    addEventHandler('onClientRender', root, renderInterface)

    if interface.weedId and effects[interface.weedId].onStart then
        effects[interface.weedId].onStart()
    end

    animate(0, 255, 'Linear', 300, function(a)
        interface.alpha = a
    end, function()
        interface.animating = nil
    end)
    
    return true
end

function endWeedEffect()
    if not interface.block or interface.animating then return end
    interface.animating = true
    if interface.weedId and effects[interface.weedId].onEnd then
        effects[interface.weedId].onEnd()
    end
    animate(255, 0, 'Linear', 300, function(a)
        interface.alpha = a
    end, function()
        removeEventHandler('onClientRender', root, renderInterface)
        destroyInterface()
    end)
end

function loadInterface()
    if not isEventHandlerAdded('onClientRender', root, renderAnimations) then
        addEventHandler('onClientRender', root, renderAnimations)
    end
    interface.textures = {}
    interface.fonts = {
        [1] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
    }
    interface.alpha = 0
    for i,v in ipairs({'background', 'backgroundGlow', 'bar'}) do
        if not interface.textures[v] then
            if not fileExists('files/images/'..v..'.png') then
                outputDebugString('Failed to load interface texture: '..v..'.png')
            else
                interface.textures[v] = dxCreateTexture('files/images/'..v..'.png')
            end
        end
    end
end

function destroyInterface()
    if isEventHandlerAdded('onClientRender', root, renderAnimations) then
        removeEventHandler('onClientRender', root, renderAnimations)
    end
    for i,v in pairs(interface.textures or {}) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    interface.fonts = nil
    interface.textures = nil
    interface.alpha = nil
    interface.timeTick = nil
    interface.timeToEnd = nil
    interface.weedName = nil
    interface.weedId = nil
    interface.animating = nil
    interface.block = nil
end

--useWeed('haze')