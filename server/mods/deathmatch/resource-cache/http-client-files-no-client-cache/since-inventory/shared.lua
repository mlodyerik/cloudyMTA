local serverSide = not localPlayer
classes = {
    ['gray'] = {name = "Podstawowa",color = {155,155,155}},
    ['normal'] = {name = "Zwykła", color = {24, 161, 29}},
    ['rare'] = {name = "Rzadka", color = {23, 189, 255}},
    ['epic'] = {name = "Epicka", color = {155, 52, 235}},
    ['legendary'] = {name = "Legendarna", color = {235, 169, 2}},
    ['unique'] = {name = "Unikatowa", color = {0, 255, 155}},
    ['illegal'] = {name = "Nielegalna", color = {200, 0, 0}}
}

function getInventoryMaxWeight(player)
    player = player or localPlayer
    if not player then return end
    local capacity = 100 + (getElementData(player, 'player:srp')/24)
    return capacity
end

function getPlayerInventory(player)
    player = player or localPlayer
    if not player then return end

    local inventory = getElementData(player, "player:inventory")
    if not inventory then
        inventory = {}
        if serverSide then
            setElementData(player, "player:inventory", inventory)
        else
            triggerServerEvent('getPlayerInventory', resourceRoot)
        end
    end

    return inventory
end

if serverSide then
    addEvent('getPlayerInventory', true)
    addEventHandler('getPlayerInventory', resourceRoot, function()
        local player = client
        local inventory = getElementData(player, "player:inventory")
        if (not inventory) then
            inventory = {}
            setElementData(player, "player:inventory", inventory)
        end
    end)
    addEvent('setPlayerInventory', true)
    addEventHandler('setPlayerInventory', resourceRoot, function(inventory)
        setPlayerInventory(client, inventory)
    end)
end

function setPlayerInventory(...)
    local args = {...}
    local player, inventory;
    if serverSide then
        player, inventory = args[1], args[2]
    else
        player, inventory = localPlayer, args[1]
    end

    if not player or not inventory then return end

    if localPlayer then
        triggerServerEvent('setPlayerInventory', resourceRoot, inventory)
        return false
    end

    setElementData(player, "player:inventory", inventory)
end

function isPlayerHaveItem(...)
    local args = {...}
    local player, item;

    if serverSide then
        player, item = args[1], args[2]
    else
        player, item = localPlayer, args[1]
    end

    local inventory = getPlayerInventory(player)
    for k,v in ipairs(inventory) do
        if v.name == item then
            return true
        end
    end

    return false
end

function getSaveInventory(player)
    player = player or localPlayer
    if not player then return end

    local inventory = getPlayerInventory(player)
    local saveInventory = {}
    for k,v in ipairs(inventory) do
        local itemData = getItemInfo(v.name)
        if not itemData.isTemp then
            table.insert(saveInventory, v)
        end
    end
    return saveInventory
end

function addPlayerItemProgress(...)
    local args = {...}
    local player, token, amount;
    if serverSide then
        player, token, amount = args[1], args[2], args[3]
    else
        player, token, amount = localPlayer, args[1], args[2]
    end

    local inventory = getPlayerInventory(player)

    for i,v in pairs(inventory) do
        if (v.token == token) then
            v.progress = v.progress + amount
            if (v.progress > 100) then
                if (v.class == 'unique') then
                    v.progress = 100
                else
                    v.progress = 0

                    if (v.class == 'gray') then
                        v.class = 'normal'
                    elseif (v.class == 'normal') then
                        v.class = 'rare'
                    elseif (v.class == 'rare') then
                        v.class = 'legendary'
                    elseif (v.class == 'legendary') then
                        v.class = 'epic'
                    elseif (v.class == 'epic') then
                        v.class = 'unique'
                    end

                    if v.name == 'wedka' then
                        if localPlayer then
                            exports['since-notifications']:sendNotification('success', 'Level twojej wędki wzrósł! ('..classes[v.class].name..')')
                        else
                            exports['since-notifications']:sendNotification(player, 'success', 'Level twojej wędki wzrósł! ('..classes[v.class].name..')')
                        end
                    end
                end
            end

            setElementData(player,'player:inventory',inventory)
            break
        end
    end
end

function addPlayerItem(...)
    local args = {...}
    local player, item, amount;
    if serverSide then
        player, item, amount = args[1], args[2], args[3]
    else
        player, item, amount = localPlayer, args[1], args[2]
    end

    if not player or not item or not amount then return end

    local inventory = getPlayerInventory(player)
    
    -- find item by name
    local itemData = getItemInfo(item)
    if not itemData then return end

    local added = false
    local unique = itemData.unique or itemData.progress
    if not unique then
        for k,v in ipairs(inventory) do
            if v.name == item then
                v.amount = v.amount + amount

                if v.amount <= 0 then
                    table.remove(inventory, k)
                end

                added = true
            end
        end
    end

    -- if item not found, add it
    if not added and amount > 0 then
        if unique then
            for i = 1, amount do
                table.insert(inventory, {
                    name = item,
                    amount = 1,
                    progress = 0,
                    class = itemData.class,
                    token = generateToken()
                })
            end
        else
            table.insert(inventory, {
                name = item,
                amount = amount,
                progress = 0,
                class = itemData.class,
                token = generateToken()
            })
        end
    end

    -- if amount <= 0, remove item
    if amount <= 0 and not added then
        if unique then error("USE removeItemByToken(token) TO REMOVE UNIQUE ITEM") end

        for k,v in ipairs(inventory) do
            if v.name == item then
                table.remove(inventory, k)
            end
        end
    end

    if serverSide then
        setPlayerInventory(player, inventory)
    else
        setPlayerInventory(inventory)
    end
end

if (not localPlayer) then
    addEvent('takeItem', true)
    addEventHandler('takeItem', resourceRoot, function(item)
        addPlayerItem(item, -1)
    end)
end

function removeItemByToken(...)
    local args = {...}
    local player, token, amount;
    if serverSide then
        player, token, amount = args[1], args[2], args[3]
    else
        player, token, amount = localPlayer, args[1], args[2]
    end
    amount = amount or 1

    local inventory = getPlayerInventory(player)
    for k,v in ipairs(inventory) do
        if v.token == token then
            v.amount = v.amount - amount

            if v.amount <= 0 then
                table.remove(inventory, k)
            end
            break
        end
    end

    if serverSide then
        setPlayerInventory(player, inventory)
    else
        setPlayerInventory(inventory)
    end
end

function getItemDataByToken(...)
    local args = {...}
    local player, token;
    if serverSide then
        player, token = args[1], args[2]
    else
        player, token = localPlayer, args[1]
    end

    local inventory = getPlayerInventory(player)
    for k,v in ipairs(inventory) do
        if v.token == token then
            return v
        end
    end
end

function getItemByToken(...)
    local args = {...}
    local player, token;
    if serverSide then
        player, token = args[1], args[2]
    else
        player, token = localPlayer, args[1]
    end

    local inventory = getPlayerInventory(player)
    for k,v in ipairs(inventory) do
        if v.token == token then
            return v.name
        end
    end
end

function addPlayerItemWithData(...)
    local args = {...}
    local player, item, amount, data;
    if serverSide then
        player, item, amount, data = args[1], args[2], args[3], args[4]
    else
        player, item, amount, data = localPlayer, args[1], args[2], args[3]
    end

    if not player or not item or not amount then return end

    local inventory = getPlayerInventory(player)
    
    -- find item by name
    local itemData = getItemInfo(item)
    if not itemData then return end

    local added = false
    local unique = itemData.unique or itemData.progress
    if not unique then
        for k,v in ipairs(inventory) do
            if v.name == item then
                v.amount = v.amount + amount

                if v.amount <= 0 then
                    table.remove(inventory, k)
                end

                added = true
            end
        end
    end

    -- if item not found, add it
    if not added and amount > 0 then
        if unique then
            for i = 1, amount do
                table.insert(inventory, {
                    name = item,
                    amount = 1,
                    progress = data.progress or 0,
                    class = data.class,
                    token = amount == 1 and data.token or generateToken(),
                    data = data
                })
            end
        else
            table.insert(inventory, {
                name = item,
                amount = amount,
                progress = data.progress or 0,
                class = data.class,
                token = data.token or generateToken(),
                data = data
            })
        end
    end

    -- if amount <= 0, remove item
    if amount <= 0 and not added then
        if unique then error("USE removeItemByToken(token) TO REMOVE UNIQUE ITEM") end

        for k,v in ipairs(inventory) do
            if v.name == item then
                table.remove(inventory, k)
            end
        end
    end

    if serverSide then
        setPlayerInventory(player, inventory)
    else
        setPlayerInventory(inventory)
    end
end

-- setTimer(function()
--     if not serverSide then
--         addPlayerItem("fishing-rod-legendary", 5)
--     end

--     if not serverSide then
--         local inventory = getPlayerInventory()
--         for k,v in ipairs(inventory) do
--             if v.token then
--                 addPlayerItemProgress(v.token, math.random(1, 100))
--             end
--         end
--     end
-- end,1000,1)
getResourceName(getThisResource(), true, 88351716); if true then return end