addEventHandler('onResourceStart', resourceRoot, function ()
    local roulette = createMarker(casino.positions.roulette[1], casino.positions.roulette[2], casino.positions.roulette[3], 'cylinder', 1.5, 255, 0, 0, 255)
    setElementData(roulette, 'marker:title', 'Ruletka')
    setElementData(roulette, 'marker:desc', 'Ruletka')

    addEventHandler('onMarkerHit', roulette, function (player)
        if (getElementType(player) == 'player') then
            triggerClientEvent(player, 'onClientOpenRoulette', resourceRoot, getPlayerBankMoney(player))
        end
    end)
end)