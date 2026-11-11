addEventHandler("onPlayerQuit", getRootElement(), function(type)
    if not getElementData(source, "player:spawn") then
        return 
    end

    local x, y, z = getElementPosition(source)
    triggerClientEvent(root, "addQuitMessage", resourceRoot, getPlayerName(source):gsub("#%x%x%x%x%x%x", ""), getElementData(source, "player:sid"), {x, y, z}, type)
end)