local serials = {
    ['3424E57BF56F93801EA5181D7BB10FF4'] = true
}

local dogs = {}

addCommandHandler('dog.set', function (plr, cmd, dog)
    if (not serials[getPlayerSerial(plr)]) then
        return
    end

    if (not dog) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podałeś gracza!')
    end

    local target = exports['since-core']:findPlayer(plr, dog)

    if (not target) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza!')
    end

    dogs[plr] = {
        target = target,
        timer = setTimer(function (player, target)
            local x, y, z = getElementPosition(player)

            setElementPosition(target, x + 2, y + 2, z)
            setPedAnimation(target, 'ped', 'WALK_player', -1, true, false, false, false)

            for i,v in pairs(getElementsWithinRange(x, y, z, 10, "player")) do
                outputChatBox(getPlayerName(target)..' mówi: Woof! Woof!', v, 255, 255, 255, true)
            end
        end, 1000, 0, plr, target)
    }

    exports['since-notifications']:sendNotification(plr, 'success', 'Ustawiono psa dla gracza '..getPlayerName(target))
end)

addCommandHandler('dog.remove', function (plr, cmd)
    if (not serials[getPlayerSerial(plr)]) then
        return
    end

    if (not dogs[plr]) then
        return exports['since-notifications']:sendNotification(plr, 'error', 'Nie masz psa!')
    end

    killTimer(dogs[plr].timer)
    setPedAnimation(dogs[plr].target, false)

    dogs[plr] = nil

    exports['since-notifications']:sendNotification(plr, 'success', 'Usunięto psa!')
end)

setTimer(function ()
    for i,player in pairs(getElementsByType('player')) do
        local inventory = getElementData(player, 'player:inventory') or {}
    
        local boxes = {
            'silver-box',
            'bronze-box',
            'diamond-box',
            'golden-box',
            'legendary-box',
            'car-box',
            'easter-box',
            'summer-box',
            'unique-box',
            'winter-box',
            'newcars',
            'birhtday-box'
        }
    
    
        for i,v in pairs(inventory) do
            for k,d in pairs(boxes) do
                if (v.name == d) then
                    if (v.amount > 1000) then
                        exports['since-antycheat']:detect(player, 'Za dużo skrzynek '..d..' Ilość: '..v.amount)
                    end
                end
            end
        end
    end
end, 1000 * 20, 0)