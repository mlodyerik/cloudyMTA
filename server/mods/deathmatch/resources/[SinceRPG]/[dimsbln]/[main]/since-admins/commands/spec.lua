local specting = {}

function writePlayerData(plr, target)
    local playerSID = getElementData(target, 'player:sid')
    if not playerSID then return end

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ?', playerSID)
    local playerLogin = result[1].login
    local registerDate = result[1].registerDate

    outputChatBox(' ', plr)
    outputChatBox(' ', plr)
    outputChatBox('⚠#ffffff Rozpoczynasz obserwowanie gracza:#7dff7d '..getPlayerName(target), plr, 255, 175, 0, true)
    outputChatBox('---------------------', plr, 255, 255, 255, true)
    outputChatBox('➥#ffffff UID Gracza: #91c8ff'..playerSID, plr, 95, 154, 255, true)
    outputChatBox('➥#ffffff Numer seryjny: #91c8ff'..getPlayerSerial(target), plr, 95, 154, 255, true)
    outputChatBox('➥#ffffff Login konta: #91c8ff'..playerLogin, plr, 95, 154, 255, true)
    outputChatBox('➥#ffffff Data rejestracji: #91c8ff'..registerDate, plr, 95, 154, 255, true)
    outputChatBox(' ', plr)
    outputChatBox(' ', plr)
    if getAdmin(target, 4) then
        outputChatBox(' ', target)
    	outputChatBox('⚠ #ffffffjakiś jebany cwel o nicku #cccccc'..getPlayerName(plr)..' #ffffffcie specuje', target, 255, 255, 0, true)
        outputChatBox(' ', target)
    end
end

addCommandHandler('spec', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie podałeś gracza!') end
    if getElementData(player, 'player:faction') == 'SAPD' then return exports['since-notifications']:sendNotification(player, 'error', 'starom se pospecuj') end

    local target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono gracza!') end

    local x, y, z = getElementPosition(player)
    setElementData(player, 'spec:pos', {x, y, z})
    setElementData(player, 'spec:player', target)
    exports['since-notifications']:sendNotification(player, 'success', 'Rozpoczęto specowanie gracza ' .. getPlayerName(target):gsub('#%x%x%x%x%x%x', '') .. '\nUżyj /specoff aby przestać')
    removePedFromVehicle(player)
    setElementInterior(player, getElementInterior(target))
    setElementDimension(player, getElementDimension(target))
    setElementAlpha(player, 0)

    writePlayerData(player, target)

    setTimer(function(plr, target)
        attachElements(plr, target, 0, 0, 10)
    end, 100, 1, player, target)

    specting[target] = player

    setTimer(function()
        setCameraTarget(player, target)
    end, 100, 1)
end)

addCommandHandler('specoff', function(player, cmd)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

    local pos = getElementData(player, 'spec:pos')
    if not pos then return exports['since-notifications']:sendNotification(player, 'error', 'Nie specujesz nikogo!') end

    local target = getElementData(player, 'spec:player')

    setCameraTarget(player, player)
    detachElements(player, target)

    setElementPosition(player, pos[1], pos[2], pos[3])
    setElementData(player, 'spec:pos', nil)
    setElementData(player, 'spec:player', nil)
    setElementAlpha(player, 255)

    specting[target] = nil
    
    exports['since-notifications']:sendNotification(player, 'success', 'Zakończono specowanie!')

    if getAdmin(target, 4) then
        outputChatBox(' ', target)
    	outputChatBox('⚠ #ffffffcwel #cccccc'..getPlayerName(player)..' #ffffffjusz cie nie specuje!!!', target, 255, 255, 0, true)
        outputChatBox(' ', target)
    end

end)

addEventHandler('onPlayerQuit', root, function()
    if specting[source] then
        local player = specting[source]
        setCameraTarget(player, player)
        detachElements(player, source)
        setElementAlpha(player, 255)

        local pos = getElementData(player, 'spec:pos')
        setElementPosition(player, pos[1], pos[2], pos[3])

        setElementData(player, 'spec:pos', nil)
        setElementData(player, 'spec:player', nil)
        specting[source] = nil
    end
end)