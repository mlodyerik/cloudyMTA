local data = {}

function revivePlayer(plr, cmd, target)
    if not target then
        return exports['since-notifications']:sendNotification(plr, 'info', 'Użyj: ' .. cmd .. ' [ID/Nick]')
    end

    if not data[plr] then
        data[plr] = {

            doingRevive = false,
            cooldown = false

        }
    end

    local target = exports['since-core']:findPlayer(plr, target)

    if not target then
        return exports['since-notifications']:sendNotification(plr, 'info', 'Nie znaleziono gracza o podanym ID/Nicku.')
    end

    local x, y, z = getElementPosition(plr)
    local tx, ty, tz = getElementPosition(target)
    local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

    if distance > 2 then
        return exports['since-notifications']:sendNotification(plr, 'info', 'Gracz jest zbyt daleko.')
    end

    if not isPedDead(target) then
        return
    end

    if isPedDead(plr) then
        return
    end

    if data[plr].doingRevive then
        return exports['since-notifications']:sendNotification(plr, 'info', 'Już podnosisz gracza.')
    end

    if data[plr].cooldown then
        return exports['since-notifications']:sendNotification(plr, 'info', 'Poczekaj chwilę przed kolejnym podniesieniem gracza.')
    end

    data[plr].doingRevive = true
    data[plr].cooldown = true

    setTimer(function(plr)
        data[plr].cooldown = false
    end, 60000, 1, plr)

    triggerClientEvent(plr, 'onPlayerRevive', resourceRoot, target)

    local x, y, z = getElementPosition(target)
    local _, _, rz = getElementRotation(target)

    setElementPosition(plr, x, y, z)
    setElementRotation(plr, 0, 0, rz)
    setElementFrozen(plr, true)

    setPedAnimation(plr, "COP_AMBIENT", "Copbrowse_nod", -1, true, false )
end
addCommandHandler('podnies', revivePlayer)
addCommandHandler('revive', revivePlayer)

addEvent('onPlayerRevive', true)
addEventHandler('onPlayerRevive', resourceRoot, function(target)
    if not isElement(target) then
        return
    end

    if getElementData(target, 'player:bw') then
        setElementData(target, 'player:bw', 0)
    end

    setPedAnimation(client, false)
    setElementFrozen(client, false)

    data[client].doingRevive = nil

    exports['since-notifications']:sendNotification(client, 'info', 'Podnosisz gracza ' .. getPlayerName(target))
    exports['since-notifications']:sendNotification(target, 'info', 'Zostałeś podniesiony przez gracza ' .. getPlayerName(client))
end)

addEventHandler('onPlayerQuit', root, function()
    if data[source] then
        data[source] = nil
    end
end)