reports = {}

function getFactionPlayers(faction)
    local players = {}

    for i, v in ipairs(getElementsByType('player')) do
        if (getElementData(v, 'player:faction') == faction) then
            table.insert(players, v)
        end
    end

    return players
end

function getPlayerReport(player)
    for i, v in pairs(reports) do
        if (v.player == player) then
            return v
        end
    end

    return false
end

addEvent('since-factions-reports:sendReport', true)
addEventHandler('since-factions-reports:sendReport', resourceRoot, function (faction, text)
    local player = client

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    if (not faction or not text) then
        return
    end

    if (getPlayerReport(player) and getPlayerReport(player).faction == faction) then
        return exports['since-notifications']:sendNotification(player, 'error', 'Już wysłałeś zgłoszenie do tej frakcji.')
    end

    if (not getPlayerReport(player)) then
        table.insert(reports, {
            faction = faction,
            text = text,
            player = player
        })
    end

    exports['since-notifications']:sendNotification(player, 'success', 'Zgłoszenie zostało wysłane do frakcji '..faction..'.')

    triggerClientEvent(player, 'since-factions-reports:closeReport', resourceRoot)

    for i,v in pairs(getFactionPlayers(faction)) do
        outputChatBox('  ', v)
        outputChatBox('  ', v)
        outputChatBox("ⓘ#ffffff Pojawiło się nowe zgłoszenie od gracza: #40acff"..getPlayerName(player):gsub("#%x%x%x%x%x%x","")..".", v, 100, 175, 255, true)
        outputChatBox("ⓘ#ffffff Treść zgłoszenia: #40acff"..text, v, 100, 175, 255, true)
        outputChatBox("ⓘ#ffffff Panel zgłoszeń: #40acff/112", v, 100, 175, 255, true)
        outputChatBox('  ', v)
        outputChatBox('  ', v)
    end
end)

addEventHandler('onPlayerQuit', root, function ()
    local player = source

    if (not isElement(player) or getElementType(player) ~= 'player') then
        return
    end

    for i, v in pairs(reports) do
        if (v.player == player) then
            table.remove(reports, i)
        end
    end
end)