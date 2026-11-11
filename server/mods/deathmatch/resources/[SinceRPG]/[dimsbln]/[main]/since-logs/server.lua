function sendDiscordLog(channel, username, message)
    if not config.channels[channel] then
        return outputDebugString('[since-logs]: Nie znaleziono webhooka dla kanału - '..tostring(channel), 3, 255, 55, 55)
    end

    if not username then
        return outputDebugString('[since-logs]: Nie podano nazwy użytkownika', 3, 255, 55, 55)
    end

    if not message then
        return outputDebugString('[since-logs]: Nie podano treści wiadomości', 3, 255, 55, 55)
    end

    if string.len(message) > 2000 then
        return outputDebugString('[since-logs]: Wiadomość jest zbyt długa', 3, 255, 55, 55)
    end

    if string.len(username) < 2 then
        username = username..'_'
    end

    local sendOptions = {
        queueName = "discord_logs",
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
            username = username,
            content = message:gsub("#%x%x%x%x%x%x",""),
        },
    }

    local webhookURL = tostring(config.channels[channel])
    fetchRemote(webhookURL, sendOptions, function() end)
end
addEvent('sendDiscordLog', true)
addEventHandler('sendDiscordLog', resourceRoot, sendDiscordLog)