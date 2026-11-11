function createPlayerTrees()
    for i,v in pairs(Config.positions.trees) do
        local x, y, z = unpack(v)
        local tree = createObject(655, x, y, z - 1)
        setElementData(tree, "tree:object", true)
        setElementData(tree, "tree:health", 100)
    
        createBlipAttachedTo(tree, 0, 2, 255, 0, 255, 255, 0, 99999.0, localPlayer)
    
        local marker = createMarker(x + 1, y + 1, z, "cylinder", 1.5, 255, 255, 255, 150)
        setElementData(marker, "marker:title", "Drzewo")
        setElementData(marker, "marker:desc", "Zetnij drzewo")
    end
end