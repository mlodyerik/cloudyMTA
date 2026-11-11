function getPlayerBankMoney(player)
    local uid;

    if (getElementType(player) == "player") then
        uid = getElementData(player, "player:sid");
    else
        uid = player;
    end

    if (uid) then
        local query = exports['since-db']:query("SELECT `bankMoney` FROM `since-users` WHERE `uid` = ?", uid);

        if (query) then
            return query[1].bankMoney;
        end
    end

    return false;
end