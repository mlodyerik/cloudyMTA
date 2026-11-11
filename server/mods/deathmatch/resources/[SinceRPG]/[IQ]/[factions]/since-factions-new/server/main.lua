function isPlayerInFaction(player, faction)
    local rows = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid=? AND faction=?', getElementData(player, 'player:sid'), faction)

    return (#rows > 0)
end

function getFactionRank(player, faction)
    local rows = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid=? AND faction=?', getElementData(player, 'player:sid'), faction)

    return rows[1].rank
end