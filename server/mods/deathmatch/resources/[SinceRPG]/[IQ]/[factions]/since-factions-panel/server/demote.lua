function canDemote(player, target)
    local factionData = exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction'))

    if (not factionData) then return false end

    local rank = getElementData(player, 'player:rank')

    if (not rank) then return false end

    local targetRank = target.rank

    if (targetRank == 1) then
        return false
    end

    return true
end

function demote(player, target)
    exports['since-db']:query('UPDATE `since-factions` SET rank = ? WHERE uid = ?', target.rank - 1, target.uid)
end