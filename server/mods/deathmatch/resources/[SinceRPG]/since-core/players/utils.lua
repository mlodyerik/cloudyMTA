function spawnPlr(player, pos)
    if not pos then pos = {0,0,0} end
    if not player then return end

    local x,y,z = unpack(pos)
    fadeCamera(player, true)
    spawnPlayer(player, x, y, z)
    setCameraTarget(player, player)
    setPlayerHudComponentVisible(player, 'all', false)
    setPlayerHudComponentVisible(player, 'crosshair', true)
    toggleControl(player, 'fire', false)

    loadPlayerData(player)

    if (exports['since-classes']:isPlayerChoosedClass(player)) then
        setElementData(player, 'player:class', exports['since-classes']:isPlayerChoosedClass(player))
    end
end

function givePlayerBankMoney(plr, amount)
    if plr and isElement(plr) and amount and tonumber(amount) then
        local uid = getElementData(plr, 'player:sid')
        if not uid then 
            return 
        end
        givePlayerMoney(plr, amount)
        --exports['since-db']:query('UPDATE `since-users` SET bankMoney=bankMoney+? WHERE uid=? LIMIT 1', amount, uid)
        return true
    end
end

function takePlayerBankMoney(plr, amount)
    if plr and isElement(plr) and amount and tonumber(amount) then
        local uid = getElementData(plr, 'player:sid')
        if not uid then return end
        local money = getPlayerMoney(plr)
        if money < amount then
            return false
        else
            takePlayerMoney(plr, amount)
            return true
        end

        --[[local db = exports['since-db']:query('SELECT bankMoney FROM `since-users` WHERE uid=? LIMIT 1', uid)
        if db[1] and db[1].bankMoney >= amount then
            exports['since-db']:query('UPDATE `since-users` SET bankMoney=bankMoney-? WHERE uid=? LIMIT 1', amount, uid)
            return true
        else
            return false
        end]]
    end
end

function getPlayerBankMoney(plr)
    if plr and isElement(plr) then
        local uid = getElementData(plr, 'player:sid')
        if not uid then 
            return 
        end
        return getPlayerMoney(plr)
        --[[local db = exports['since-db']:query('SELECT bankMoney FROM `since-users` WHERE uid=? LIMIT 1', uid)
        return (db[1] and db[1].bankMoney or 0)]]
    end
end

addEventHandler("onPlayerCommand", root, function(command)
    if command == "register" then cancelEvent() return end
    if command == "msg" then cancelEvent() return end
    if command == "Toggle" then return end
    if command == "Next" then  return end
    if command == "Previous" then  return end
    if command == "say" then  return end
end)