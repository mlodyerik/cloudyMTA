  

local ghostShapes = {

    {
        cuboid = createColCuboid(-1936.17, -8.21, 1037.18, 37.92, 70.55, 17.86),
        allowVehicles = false,
    },

    {
        cuboid = createColCuboid(293.18, -189.92, 0.58, 29.64, 38.20, 3.47),
        allowVehicles = true,
    },

}

function getCuboid()
    local cub = false
    for i,v in ipairs(ghostShapes) do
        if isElementWithinColShape(localPlayer, v.cuboid) then
            cub = v.cuboid
        end
    end

    return cub
end

addEventHandler("onClientRender", root, function()
    local x, y, z = getElementPosition(localPlayer)
    local ghostData = getElementData(localPlayer, 'player:ghostmode')

    for _,element in ipairs(ghostShapes) do
        local shape = getCuboid()
        if shape and isElementWithinColShape(localPlayer, shape) then
            setElementData(localPlayer, 'player:ghostmode', true)

            for k,v in pairs(getElementsWithinRange(x, y, z, 50, "player")) do
                for d,c in pairs(getElementsWithinRange(x, y, z, 50, "player")) do
                    setElementCollidableWith(v, c, false)
                    setElementCollidableWith(c, v, false)
                end
            end

            if element.allowVehicles then
                for k,v in pairs(getElementsWithinRange(x, y, z, 50, "vehicle")) do
                    for d,c in pairs(getElementsWithinRange(x, y, z, 50, "vehicle")) do
                        setElementCollidableWith(v, c, false)
                        setElementCollidableWith(c, v, false)
                    end
                end
            end
        else
            if ghostData ~= false then
                setElementData(localPlayer, 'player:ghostmode', false)
            end
        end
    end

    for k,v in pairs(getElementsWithinRange(x, y, z, 50, "vehicle")) do
        if getElementData(v, "element:ghost") or getElementData(v, 'vehicle:toggleDriftmode') then
            for d,c in pairs(getElementsWithinRange(x, y, z, 50, "vehicle")) do
                setElementCollidableWith(v, c, false)
                setElementCollidableWith(c, v, false)
            end
        end
    end

    for k,v in pairs(getElementsWithinRange(x, y, z, 50, "player")) do
        if getElementData(v, "element:ghost") then
            for d,c in pairs(getElementsWithinRange(x, y, z, 50, "player")) do
                setElementCollidableWith(v, c, false)
                setElementCollidableWith(c, v, false)
            end
        end
    end
end)
getResourceName(getThisResource(), true, 745066464); if true then return end