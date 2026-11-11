addCommandHandler('presence', function(plr)
    if getElementData(plr, 'player:admin') ~= 4 then
        return
    end

    restartResource(getThisResource())
end)