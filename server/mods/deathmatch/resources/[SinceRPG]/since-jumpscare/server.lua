addCommandHandler('jumpscare', function(plr, cmd, target, type)
    if getElementData(plr, 'player:sid') == 7697 or getElementData(plr, 'player:sid') == 4 then else
        return
    end

    if not target then
        return outputChatBox('Użyj: /jumpscare [Nick/ID] [Typ]', plr, 255, 0, 0)
    end

    local target = exports['since-core']:findPlayer(plr, target)

    if not target then
        return outputChatBox('Nie znaleziono gracza', plr, 255, 0, 0)
    end
    
    if getElementData(plr, 'player:sid') == 7697 or getElementData(target, 'player:sid') == 4 then
    else
        if getElementData(target, 'player:sid') == 7697 or getElementData(target, 'player:sid') == 4 then
            target = plr
        end
    end

    triggerClientEvent(target, 'showJumpscare', resourceRoot, type)
end)