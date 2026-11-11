addEvent('onPlayerAlcohol', true)
addEventHandler('onPlayerAlcohol', resourceRoot, function(type)
    if type == 'stopAnimation' then
        setPedWalkingStyle(client, 0)
    elseif type == 'death' then
        setElementHealth(client, 0)
        setElementData(client, 'player:drinking', {stage = 0, state = false})
        exports['since-notifications']:sendNotification(client, 'error', 'Zaliczyłeś zgona')
    end
end)