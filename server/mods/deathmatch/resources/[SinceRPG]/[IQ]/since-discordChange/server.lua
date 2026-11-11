-- addEventHandler('onPlayerJoin', root, function )

    function onPlayerJoin(player)
        local rows = exports['since-db']:query('SELECT * FROM `since-discord` WHERE serial=? LIMIT 1', getPlayerSerial(player))
    
        if (#rows == 0) then
            outputChatBox('    ', player)
            outputChatBox('    ', player)
            outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', player, 255, 0, 0, true)
            outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', player, 255, 0, 0, true)
            outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', player, 255, 0, 0, true)
            outputChatBox('#68D65E★#ffffff Dołącz na nowy serwer discord oraz połącz konto z grą, aby odebrać Elegy z wyjątkowym PJ. ★', player, 255, 0, 0, true)
            outputChatBox('    ', player)
            outputChatBox('    ', player)
    
            triggerClientEvent(player, 'toggleDiscordInformation', resourceRoot)
            return
        end
    
        local row = rows[1]
    
        if (row.reward == 0) then
            outputChatBox('    ', player)
            outputChatBox('    ', player)
            outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', player, 255, 0, 0, true)
            outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', player, 255, 0, 0, true)
            outputChatBox('#68D65E★#ffffff Nowy Discord: #68D65Ehttps://discord.gg/JSXJVnXyzV ★', player, 255, 0, 0, true)
            outputChatBox('#68D65E★#ffffff Dołącz, by odebrać Elegy z wyjątkowym PJ, tylko dla członków nowego serwera. ★', player, 255, 0, 0, true)
            outputChatBox('    ', player)
            outputChatBox('    ', player)
    
            triggerClientEvent(player, 'toggleDiscordInformation', resourceRoot)
        end
    end
    
    -- onPlayerJoin(getPlayerFromName('Grzesiu'))
    
    -- addEventHandler('onPlayerJoin', root, onPlayerJoin)
    
    -- addEventHandler('onResourceStart', resourceRoot, function()
    --     for i, player in ipairs(getElementsByType('player')) do
    --         onPlayerJoin(player)
    --     end
    -- end)
    
    addEvent('checkDiscordInformation', true)
    addEventHandler('checkDiscordInformation', resourceRoot, function()
    
        onPlayerJoin(client)
    end)