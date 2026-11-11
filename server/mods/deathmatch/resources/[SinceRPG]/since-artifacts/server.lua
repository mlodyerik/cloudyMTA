function sendMessageToOrganizationMembers(organization, message)
    for _, player in pairs(getElementsByType('player')) do
        local org = getElementData(player, 'player:organization')
        if org and org.id == organization then
            outputChatBox(' ', player, 255, 255, 255, true)
            outputChatBox(message, player, 255, 255, 255, true)
            outputChatBox(' ', player, 255, 255, 255, true)
        end
    end
end

function startArtifact(plr)
    triggerClientEvent(plr, 'artifactStart', resourceRoot)
end

addEvent('artifactAddMoney', true)
addEventHandler('artifactAddMoney', resourceRoot, function()
    if client then
        local organization = getElementData(client, 'player:organization')

        if not organization then
            return
        end

        local orgData = organization

        local defaultMoney = math.random(500000, 1200000)
        local money = defaultMoney + math.floor(math.random(100000, 200000) * (orgData.level))
        local playerMoney = math.random(1200000, 2400000)
        local uid = getElementData(client, 'player:sid')

        sendMessageToOrganizationMembers(organization.id, '#ffc800★#ffffff Członek organizacji #bfbfbf'..getPlayerName(client)..'#ffffff odnalazł artefakt wart #2E756F$ '..addCommas(money)..'#ffffff')
        exports['since-db']:query('UPDATE `since-orgs` SET `money` = `money` + ? WHERE `uid` = ?', money, orgData.id)
        exports['since-db']:query('UPDATE `since-users` SET `money` = `money` + ? WHERE `uid` = ?', playerMoney, uid)
        exports['since-notifications']:sendNotification(client, 'success', 'Za odnaleziony artefakt otrzymujesz $ '..addCommas(playerMoney))
        exports['since-notifications']:sendNotification(client, 'info', 'Na konto organizacji wpłyneło $ '..addCommas(money))
        exports['since-db']:query("INSERT INTO `since-orgs-logs` (org,member,title,subTitle,description) VALUES (?,?,?,?,?)", orgData.id, getPlayerName(client), 'Odnalezienie artefaktu', '#2E756F$#ffffff '..addCommas(money)..'', 'Brak')
    end
end)

function addCommas(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1 '):reverse()) .. right
end