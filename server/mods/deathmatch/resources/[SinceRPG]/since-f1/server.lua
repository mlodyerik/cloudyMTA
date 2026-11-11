addEvent('getPlayerRecords', true)
addEventHandler('getPlayerRecords', resourceRoot, function()
    local records = exports['since-db']:query("SELECT * FROM `since-players-records` ORDER BY `date` DESC LIMIT 7")
    triggerClientEvent(client, 'onPlayersStatsReceive', resourceRoot, records)
end)


addEventHandler('onPlayerJoin',root,function ()
	local players = getElementsByType('player')
	
    -- check if today's record exists
    local today = exports['since-db']:query("SELECT * FROM `since-players-records` WHERE `date` = CURDATE()")

    -- if not, create it
    if #today == 0 then
        exports['since-db']:query("INSERT INTO `since-players-records` (`date`, `players`) VALUES (CURDATE(), ?)", #players)
    end

    -- if exists, update the record
    if #today > 0 then
        -- if actual players count is higher than the record, update it
        if #players > today[1].players then
            exports['since-db']:query("UPDATE `since-players-records` SET `players` = ? WHERE `date` = CURDATE()", #players)
        end
    end
end)