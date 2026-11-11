addEvent("enonek-drift:getRecords", true)
addEventHandler("enonek-drift:getRecords", resourceRoot, function()
    local result = exports["since-db"]:query("SELECT * FROM `since-drift` ORDER BY pkt DESC LIMIT 10")
    local result2 = exports["since-db"]:query("SELECT pkt FROM `since-drift` WHERE sid=?", getElementData(client, "player:sid"))
	triggerClientEvent(client, "enonek-drift:loadRecords", resourceRoot, result, result2)
end)

local function isMyPositionFirst(player, id)
    local result = exports["since-db"]:query("SELECT * FROM `since-drift` ORDER BY pkt DESC LIMIT 10")
    if (result and #result > 0) then
        if (tonumber(result[1].sid) == tonumber(id)) then
            return true
        else
            return false
        end
    else
        return true
    end
end

addEvent("enonek-drift:update", true)
addEventHandler("enonek-drift:update", resourceRoot, function(score)
    local sid = getElementData(client, "player:sid")
    local result = exports["since-db"]:query("SELECT * FROM `since-drift` WHERE sid=?", sid)
    local client_name = getPlayerName(client):gsub("#%x%x%x%x%x%x", "")
    local isEarlyFirst = isMyPositionFirst(client, sid)
    if result and #result > 0 then
        if tonumber(result[1].pkt) < tonumber(score) then
            exports["since-db"]:query("UPDATE `since-drift` SET pkt=? WHERE sid=?", score, sid)
        end
    else
        exports["since-db"]:query("INSERT INTO `since-drift` SET sid=?, pkt=?, login=?", sid, score, client_name)
    end

    if not isEarlyFirst then
        if isMyPositionFirst(client, sid) then
            outputChatBox("#fae100* #FFFFFFWskakujesz na pierwsze miejsce w rankingu drifterskim z #d4d4d4"..score.." #ffffffpunktami!", client, _, _, _, true)
        end
    end
end)