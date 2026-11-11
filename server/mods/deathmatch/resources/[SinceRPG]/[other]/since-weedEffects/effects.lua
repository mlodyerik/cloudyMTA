local sx, sy = guiGetScreenSize()
local effect = {}

function renderColors()
    if not effect.tick then
        effect.tick = getTickCount()
    end
    if effect.tick > getTickCount() then
        return
    end
    effect.tick = getTickCount() + 500
    setColorFilter(math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), 255)
    setGameSpeed(math.random(5, 15)/10)
end

function renderScreen()
    if not effect.screen then
        effect.screen = dxCreateScreenSource(sx, sy)
    end
    dxUpdateScreenSource(effect.screen)
    dxDrawImage(0,0,sx,sy,effect.screen, 180,0,0,tocolor(255,255,255,155))
end

effects = {
    [1] = {
        name = 'Marihuana',
        time = 60000,
        onStart = function()
            setCameraGoggleEffect('nightvision', false)
            setGameSpeed(1.1)
        end,
        onEnd = function()
            setCameraGoggleEffect('normal')
            setGameSpeed(1)
        end,
    },
    [2] = {
        name = 'Sativa',
        time = 40000,
        onStart = function()
            setCameraGoggleEffect('thermalvision', false)
            setGameSpeed(0.75)
        end,
        onEnd = function()
            setCameraGoggleEffect('normal')
            setGameSpeed(1)
        end,
    },
    [3] = {
        name = 'Indica',
        time = 20000,
        onStart = function()
            addEventHandler('onClientRender', root, renderColors)
        end,
        onEnd = function()
            removeEventHandler('onClientRender', root, renderColors)
            effect.tick = nil
            setGameSpeed(1)
            resetColorFilter()
        end,
    },
    [4] = {
        name = 'Lemon Haze',
        time = 30000,
        onStart = function()
            addEventHandler('onClientRender', root, renderScreen)
        end,
        onEnd = function()
            removeEventHandler('onClientRender', root, renderScreen)
            if effect.screen then
                if isElement(effect.screen) then
                    destroyElement(effect.screen)
                end
                effect.screen = nil
            end
        end,
    },
}