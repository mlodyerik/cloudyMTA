addEvent('returnSoundList', true)
addEventHandler('returnSoundList', resourceRoot, function()
    if client then
        local playerUID = getElementData(client, 'player:sid')
        
        if playerUID then
            local result = exports['since-db']:query('SELECT * FROM `since-stereo` WHERE uid = ?', playerUID)

            if #result > 0 then
                triggerClientEvent(client, 'returnSoundList', resourceRoot, result)
            else
                triggerClientEvent(client, 'returnSoundList', resourceRoot, {})
            end
        end
    end
end)

addEvent('addSong', true)
addEventHandler('addSong', resourceRoot, function(link, name)
    if client then
        exports['since-db']:query('INSERT INTO `since-stereo` (uid, link, name) VALUES (?, ?, ?)', getElementData(client, 'player:sid'), link, name)
    end
end)

addEvent('deleteSong', true)
addEventHandler('deleteSong', resourceRoot, function(link, name)
    if client then
        exports['since-db']:query('DELETE FROM `since-stereo` WHERE link = ? AND name = ? AND uid = ?', link, name, getElementData(client, 'player:sid'))
    end
end)