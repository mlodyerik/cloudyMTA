addEvent("enonek-antyafk:toggle", true)
addEventHandler("enonek-antyafk:toggle", resourceRoot, function(state)
    if state then
        if getElementData(client, "player:faction") then
            exports['since-factions']:stopDutyTimer(client)
            removeElementData(client, "player:faction")
            removeElementData(client, "player:rank")
            --if getElementData(client, "last:nick") then
            --    setPlayerName(client, getElementData(client, "last:nick"))
            --end
            setElementData(client, "player:s2", true)
        end
    else
        local result = exports["since-db"]:query("SELECT * FROM `since-factions` WHERE uid=?", getElementData(client, "player:sid"))
        if result and #result > 0 then
            exports['since-factions']:startDutyTimer(client)
		    setElementData(client, "player:faction", result[1].faction)
		    local rank = exports['since-factions']:getFactionRank(client, result[1].faction)
		    setElementData(client,"player:rank",rank)
		    setPedStat(client,78,1000)
		    setPedStat(client,70,1000)
		    --setElementData(client,"last:nick",getPlayerName(client):gsub("#%x%x%x%x%x%x",""))
		    exports['since-db']:query('UPDATE `since-factions` set last_activity=NOW() WHERE faction=? AND uid=? LIMIT 1;', result[1].faction, getElementData(client,"player:sid"))
            setElementData(client, "player:s2", false)
        end
    end
end)