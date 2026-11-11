function addPlayerFisherLevel(amount)
    local usedItems = getElementData(localPlayer, 'usedItems') or {}
    local find = false

    for k,v in pairs(usedItems) do
        if (v.name == 'wedka') then
            find = v.token
            break
        end
    end

    if find then
        triggerServerEvent('levelwedka', resourceRoot, find, amount)
        return true
    endp

    return false
end
