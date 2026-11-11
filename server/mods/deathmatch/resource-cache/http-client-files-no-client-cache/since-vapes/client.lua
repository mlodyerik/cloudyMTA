local txd = engineLoadTXD("ijust.txd")
local dff = engineLoadDFF("ijust.dff")
engineImportTXD(txd, 1870)
engineReplaceModel(dff, 1870, true)

addEvent("tryTakePuff", true)
addEventHandler("tryTakePuff", resourceRoot, function(player)
    local boneX, boneY, boneZ = getPedBonePosition(player, 8)
    local x, y, z = getElementPosition(player)

    local options = {
        x = boneX + 0.1,
        y = boneY + 0.1,
        z = boneZ,
        density = 1,
        endSize = 0,
        startSize = 1,
    }

    local emitter = exports['since-particles']:createEmitter(options)

    if (localPlayer == player) then
        setGameSpeed(2)
    end

    setTimer(function()
        exports['since-particles']:destroyEmitter(emitter)
        
        if (localPlayer == player) then
            setGameSpeed(1)
        end
    end, 3000, 1)
end)