addEvent('attachSpectate', true)
addEventHandler('attachSpectate', resourceRoot, function(type, player)
    if getElementData(localPlayer, 'player:admin') then

        print('ok')
        if type == 'attach' then
            setCameraTarget(localPlayer, player)
            attachElements(localPlayer, player, 0, 0, 2)
        elseif type == 'detach' then
            setCameraTarget(localPlayer, localPlayer)
            detachElements(localPlayer, player)
        end
    end
end)