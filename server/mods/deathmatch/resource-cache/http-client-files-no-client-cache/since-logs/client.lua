function sendDiscordLog(channel, username, message)
    if not channel then
        return outputDebugString('[since-logs]: Nie znaleziono webhooka dla kanału - '..tostring(channel), 3, 255, 55, 55)
    end

    if not username then
        return outputDebugString('[since-logs]: Nie podano nazwy użytkownika', 3, 255, 55, 55)
    end

    if not message then
        return outputDebugString('[since-logs]: Nie podano treści wiadomości', 3, 255, 55, 55)
    end
    
    triggerServerEvent('sendDiscordLog', resourceRoot, channel, username, message)
end