local vapes = {}
local timeouts = {}

function tryTakePuff(player)
    if (not isElement(player) or not isElement(vapes[player])) then
        return
    end

    if (timeouts[player] and getTickCount() - timeouts[player] < 5000) then
        return
    end

    timeouts[player] = getTickCount()
    
    
    for i,v in pairs(getElementsByType('player')) do
        triggerClientEvent(v, 'tryTakePuff', resourceRoot, player)
    end

    setPedAnimation(player, 'FOOD', 'EAT_Burger', 1, false, false)
end

addCommandHandler('jebacmatkehexa', function (player)
    if (vapes[player]) then
        destroyElement(vapes[player])
        vapes[player] = nil
    end

    local object = createObject(1870, 0, 0, 0)
    setElementCollisionsEnabled(object, false)
    setElementDoubleSided(object, true)
    exports['since-pattach']:attach(object, player, 23, -0.01, -0.03, 0.28, 0, 90, -5)
    vapes[player] = object

    bindKey(player, 'e', 'down', tryTakePuff)
end)