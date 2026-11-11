local SERVER_SIDE = not localPlayer

function showNotification(plr, msg)
    if SERVER_SIDE then
        outputChatBox(msg, plr)
    else
        outputChatBox(plr)
    end
end
getResourceName(getThisResource(), true, 849052308); if true then return end