local elementData = {
    data = {
        -- gracze
        ['id'] = true,
        ['player:sid'] = true,
        ['player:srp'] = true,
        ['player:organization'] = true,
        ['player:faction'] = true,
        ['player:license'] = true,
        ['player:greenzone'] = true,
        ['player:workinjob'] = true,
        ['player:admin'] = true,
        ['player:pp'] = true,
        ['interior:location'] = true,
        ['player:inventory'] = true,
  
        -- pojazdy
        ['vehicle:owner'] = true,
        ['vehicle:id'] = true,
        ['vehicle:upgrades'] = true,
        ['vehicle:tuning'] = true,
        ['vehicle:rent'] = true,
        ['vehicle:model'] = true,
        ['vehicleID'] = true,
        ['baseID'] = true,
    },
}

local blockedCommands = {
    ['painellua'] = true,
}

local cannels = {
    ['Antycheat'] = 'https://discord.com/api/webhooks/1184150164399726672/GARga1qgnFtIVpNO37sue3Xrx9b3HTed4dY-5uK-ywHa5QwX7FDiJJ-hNnRj44euNeXO',
}

function writeOnDiscord(cannel, text)
    if cannels[cannel] then
        sendOptions = {
            queueName = "antycheatWebhook",
            connectionAttempts = 3,
            connectTimeout = 5000,
            formFields = {
                username = cannel,
                content = text:gsub("#%x%x%x%x%x%x",""),
            },
        }
        fetchRemote(cannels[cannel], sendOptions, function() end)
    end
end

function detectChangeElementData(name, oldValue)
    if (elementData.data[name]) then 
        if (client) then
            setElementData(source, name, oldValue)
            exports['since-antycheat']:detect(client, 'Próba zmiany elementData '..name..' ze strony clienta.')
        end
    end
end
addEventHandler('onElementDataChange', root, detectChangeElementData)

addEventHandler('onPlayerCommand', root, function(cmd)
    if blockedCommands[cmd] then
        kickPlayer(source, 'Nie posiadasz dostępu do serwera.')
    end
end)

addEventHandler("onPlayerTriggerEventThreshold", root, function()
    exports['since-antycheat']:detect(source, 'Próba wywołania zbyt wielu eventów.')
end)

-- addEventHandler('onPlayerTriggerInvalidEvent', root, function(eventName, isAdded, isRemote)
--     exports['since-antycheat']:detect(source, 'Próba wywołania nieprawidłowego eventu.')
-- end)

-- for i, v in ipairs(getBans()) do
--     if serials[getBanSerial(v)] then
--         removeBan(v)
--     end
-- end

setServerConfigSetting('player_triggered_event_interval', 100, true)
setServerConfigSetting('max_player_triggered_events_per_interval', 100, true)