function startDuty(plr, faction)
    if isInFaction(plr, faction) then
        startDutyTimer(plr)
        setElementData(plr, 'player:faction', faction)
        setElementData(plr, 'player:rank', getFactionRank(plr, faction))
        setElementData(plr, 'player:skinSave', getElementModel(plr))
        triggerClientEvent(plr, 'onPlayerStartDuty', plr, faction)
        exports['since-notifications']:sendNotification(plr, 'success', 'Rozpoczynasz służbę frakcji '..faction)
        reloadLastActivity(plr, faction)
        return true
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie jesteś zatrudniony w tej frakcji!')
        return false
    end
end

function stopDuty(plr, faction)
    if getElementData(plr, 'player:faction') == faction then
        takeAllWeapons(plr)
        stopDutyTimer(plr)
        setElementData(plr, 'player:faction', nil)
        setElementData(plr, 'player:rank', nil)
        setElementModel(plr, getElementData(plr, 'player:skinSave') or 0)
        setElementData(plr, 'player:skinSave', nil)
        setElementData(plr, 'player:factionPause', nil)
        triggerClientEvent(plr, 'onPlayerStopDuty', plr, faction)
        local factionWorkTime = convertMinutesToHours(getElementData(plr, 'player:workinjob') or 0)

        exports['since-notifications']:sendNotification(plr, 'success', 'Kończysz służbę frakcji '..faction)
        exports['since-notifications']:sendNotification(plr, 'info', 'Przepracowany czas: '..factionWorkTime..'')
        reloadLastActivity(plr, faction)
        return true
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Posiadasz aktywną służbę w innej frakcji!')
        return false
    end
end

local factions = {

    ['SAPD'] = 'since-factionSAPD',
    ['SAFD'] = 'since-factionSAFD',
    ['SARA'] = 'since-factionSARA',
    ['TSA'] = 'since-factionTAXI',

}

local canTeleport = {

    ['SAPD'] = false,
    ['SAFD'] = false,
    ['SARA'] = false,
    ['TSA'] = false,

}

local factionTeleports = {

    ['SAPD'] = {1543.68, -1675.58, 13.56, -0.00, 0.00, 7.86},
    ['SAFD'] = {860.16, 1914.01, 10.82, -0.00, 0.00, 7.86},
    ['SARA'] = {-50.03, -290.69, 5.45, -0.00, 0.00, 7.86},
    ['TSA'] = {2200.64, 1389.45, 10.82, -0.00, 0.00, 85.25},

}

addCommandHandler('baza', function(plr)
    local faction = getElementData(plr, 'player:faction')

    if faction then
        if canTeleport[faction] then
            local x, y, z, rx, ry, rz = unpack(factionTeleports[faction])
            setElementPosition(plr, x, y, z)
            setElementRotation(plr, rx, ry, rz)
            setElementDimension(plr, 0)
            setElementInterior(plr, 0)
            exports['since-notifications']:sendNotification(plr, 'success', 'Zostałeś przeniesiony na bazę frakcji '..faction)
        end
    end
end)

function restartFaction(factionName)
    if factions[factionName] then
        local resource = getResourceFromName(factions[factionName])
        if resource then
            restartResource(resource)

            for i, v in ipairs(getElementsByType('player')) do
                if getElementData(v, 'player:faction') == factionName then
                    outputChatBox('⚠ #ffffffTwoja frakcja została przeładowana', v, 255, 175, 0, true)
                    outputChatBox('⚠ #ffffffUżyj komendy #5de381/baza#ffffff aby udać się na bazę frakcji - masz na to 10 sekund.', v, 255, 175, 0, true)
                end
            end

            canTeleport[factionName] = true

            setTimer(function(factionName)
                canTeleport[factionName] = false
            end, 10000, 1, factionName)
            return true
        end
    end
end

addEventHandler('onPlayerElementDataChange', root, function(dataName, oldValue, newValue)
    if dataName == 'player:faction' then
        if newValue == false then
            stopDuty(source, oldValue)
        end
    end
end)

function reloadLastActivity(plr, faction)
    if not getElementData(plr,"player:sid") then return end
    exports['since-db']:query('UPDATE `since-factions` set last_activity=NOW() WHERE faction=? AND uid=? LIMIT 1;', faction, getElementData(plr,"player:sid"))
end

addCommandHandler('sprawdz.minuty', function(plr, cmd, uid)
    if getElementData(plr, 'player:sid') == 3 then
    	if getElementData(plr, 'player:faction') then
    		local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', uid)
    		if #result > 0 then
    			outputChatBox('ⓘ#ffffff Przepracowany czas gracza #cccccc'..result[1].nick..'#ffffff: #cccccc'..convertMinutesToHours(result[1].factionTime), plr, 255, 255, 0, true)
    		else
    			exports['since-notifications']:sendNotification(plr, 'error', 'Nie ma takiego gracza o podanym UID')
    		end
    	end
    end
end)

addCommandHandler('minuty', function(player)
    if not getElementData(player, 'player:faction') then
        return
    end
    local checkFaction = getElementData(player, 'player:faction') or '---'
    local factionWorkTime = convertMinutesToHours(getElementData(player, 'player:workinjob') or 0)
    outputChatBox('ⓘ#ffffff Pełnisz służbę we frakcji #cccccc'..checkFaction, player, 255, 255, 0, true)
    outputChatBox('ⓘ#ffffff Posiadasz przepracowane #cccccc'..factionWorkTime, player, 255, 255, 0, true)
end)

function convertMinutesToHours(minutes)
    local hours = math.floor(minutes / 60)
    local minutes = minutes - (hours * 60)

    if hours == 0 and minutes == 0 then
        return '0 minut'
    elseif hours == 0 then
        return minutes..' minut'
    elseif minutes == 0 then
        return hours..' godzin'
    else
        return hours..' godzin i '..minutes..' minut'
    end
end