addEvent('levelwedka', true)
addEventHandler('levelwedka', resourceRoot, function(token, amount)
    exports['since-inventory']:addPlayerItemProgress(client, token, amount)
end)