addEvent('payForTank', true)
addEventHandler('payForTank', resourceRoot, function(type, cost, fuelCount)
    local money = getPlayerMoney(client)
    local cost = math.floor(tonumber(cost))
    if money < cost then
        return exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej ilości gotówki!')
    end

    takePlayerMoney(client, cost)
    exports['since-notifications']:sendNotification(client, 'success', 'Zapłaciłeś#7dff7d $ '..comma_value(cost)..'#ffffff za tankowanie pojazdu')

    local fuelData = getElementData(getPedOccupiedVehicle(client), 'vehicle:fuel')
    if type == 'PB' then
        fuelData.count = fuelCount
        setElementData(getPedOccupiedVehicle(client), 'vehicle:fuel', fuelData)
    else
        fuelData.countLPG = fuelCount
        setElementData(getPedOccupiedVehicle(client), 'vehicle:fuel', fuelData)
    end
end)

function comma_value(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

addEventHandler('onVehicleStartExit', root, function(plr, seat)
    if getElementData(plr, 'player:blockVehicle') then
        cancelEvent()
    end
end)