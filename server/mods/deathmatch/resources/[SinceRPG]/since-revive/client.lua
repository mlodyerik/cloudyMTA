local core = {

    cache = {

        target = nil,
        time = 0,

    }

}

local sx, sy = guiGetScreenSize()
local zoom = 1920 / sx

core.convertTime = function(time)
    -- convert to seconds, miliseconds

    local minutes = math.floor(time / 60)
    local seconds = time - minutes * 60
    local miliseconds = math.floor((time - math.floor(time)) * 100)

    return string.format('%02d:%02d', seconds, miliseconds)
end

core.renderProgress = function()
    if not core.cache.target then
        core.cache.target = nil
        core.cache.time = nil
        return removeEventHandler('onClientRender', root, core.renderProgress)
    end

    if not core.cache.target or not isElement(core.cache.target) then
        core.cache.target = nil
        core.cache.time = nil
        return removeEventHandler('onClientRender', root, core.renderProgress)
    end

    local progress = (getTickCount() - core.cache.time) / 10000

    if progress >= 1 then
        removeEventHandler('onClientRender', root, core.renderProgress)
        triggerServerEvent('onPlayerRevive', resourceRoot, core.cache.target)
        return 
    end

    dxDrawCircle(sx / 2, sy - 150/zoom, 65, 0, 360, tocolor(45, 45, 45), tocolor(45, 45, 45), 128)
    dxDrawCircle(sx / 2, sy - 150/zoom, 65, 0, 360, tocolor(46, 117, 111, 55), tocolor(0, 0, 0, 0), 128)
    dxDrawCircle(sx / 2, sy - 150/zoom, 65, 0, 360 * progress, tocolor(46, 117, 111, 200), tocolor(0, 0, 0, 0), 128)
    dxDrawCircle(sx / 2, sy - 150/zoom, 55, 0, 360, tocolor(45, 45, 45), tocolor(45, 45, 45), 128)

    local leftTime = core.convertTime(10 - progress * 10)

    dxDrawText(leftTime, sx / 2, sy - 145/zoom, sx / 2, sy - 145/zoom, tocolor(46, 117, 111), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom')
    dxDrawText('Pozostało', sx / 2, sy - 145/zoom, sx / 2, sy - 145/zoom, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')
    dxDrawText('Podnosisz gracza '..getPlayerName(core.cache.target), sx / 2 + 1, sy - 75/zoom + 1, nil, nil, tocolor(0, 0, 0), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top', false, false, false, true)
    dxDrawText('Podnosisz gracza #2E756F'..getPlayerName(core.cache.target), sx / 2, sy - 75/zoom, nil, nil, tocolor(255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top', false, false, false, true)
end

addEvent('onPlayerRevive', true)
addEventHandler('onPlayerRevive', resourceRoot, function(target)
    core.cache.target = target
    core.cache.time = getTickCount()

    addEventHandler('onClientRender', root, core.renderProgress)
end)

addEventHandler('onClientPlayerWasted', localPlayer, function()
    if core.cache.target then
        core.cache.target = nil
        core.cache.time = nil

        removeEventHandler('onClientRender', root, core.renderProgress)
    end
end)