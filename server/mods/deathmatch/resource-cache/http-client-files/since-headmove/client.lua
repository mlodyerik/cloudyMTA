-- Author: Nando (https://github.com/Fernando-A-Rocha)
-- Moves nearby player heads according to their camera's rotation (the direction the player is looking)
local UPDATE_INTERVAL = 20 -- miliseconds

setTimer(function()
    local x, y, z = getElementPosition(localPlayer)
    local players = getElementsWithinRange(x, y, z, 100, "player")
    
    for _, player in pairs(players) do
        local rot = getPedCameraRotation(player)
        local x, y, z = getElementPosition(player)
        local vx = x + math.sin(math.rad(rot)) * 10
        local vy = y + math.cos(math.rad(rot)) * 10

        if player ~= localPlayer then
            setPedAimTarget(player, vx, vy, z)
        end

        setPedLookAt(player, vx, vy, z, UPDATE_INTERVAL, 0)
    end
end, UPDATE_INTERVAL, 0)
