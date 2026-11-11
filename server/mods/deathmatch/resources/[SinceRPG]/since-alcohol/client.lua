local shakeLevel = 10
local timer = nil

setCameraShakeLevel(0)

function drinkAlcohol()
    shakeLevel = shakeLevel + 10
    setCameraShakeLevel(shakeLevel)

    if shakeLevel == 50 then
        triggerServerEvent('onPlayerAlcohol', resourceRoot, 'death')
    end
end

timer = setTimer(function()
    if shakeLevel > 0 then
        shakeLevel = shakeLevel - 10

        setCameraShakeLevel(shakeLevel)

        if shakeLevel == 0 then
            triggerServerEvent('onPlayerAlcohol', resourceRoot, 'stopAnimation')
            setCameraShakeLevel(0)
            shakeLevel = 0
        end
    end
end, 10000, 0)