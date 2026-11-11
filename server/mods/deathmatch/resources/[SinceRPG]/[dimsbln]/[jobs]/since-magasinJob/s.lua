local serials = {
    ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,
    ['C217ED9FE6899B85C066837D5D16A4D1'] = true,
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

function triggeringBan(player, info)
    local nick, serial, ip, versionNumber = getPlayerName(player), getPlayerSerial(player), getPlayerIP(player)
    writeOnDiscord('Antycheat', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)
    exports['since-logs']:sendDiscordLog('antycheat', 'AC', 'Gracz `'..nick..'` (SERIAL: `'..serial..'` - IP: `'..ip..'`) został zbanowany - '..info)

    if serials[serial] then
      return
    end
    
    local text = ''..getPlayerName(player)..' ('..(getElementData(player, 'id') or 0)..') został zbanowany przez AntyCheat.'
    triggerClientEvent(root, 'createAdminNotification', root, text, {255, 100, 100}, 7500)
    
    banPlayer(player, true, false, true, root, 'Nie posiadasz dostępu do serwera.')

    if isElement(player) then
        kickPlayer(player, 'Nie posiadasz dostępu do serwera.')
    end
end

local checkList = {}

local packs = {}

addEvent("giveMoneyMagasin", true)
addEventHandler("giveMoneyMagasin", resourceRoot, function(money, srp)
    if not checkList[client] then
        checkList[client] = 0
    end

    checkList[client] = checkList[client] + 1

    if checkList[client] >= 5 then triggeringBan(client, 'since-magasinJob zbyt szybkie wywołanie triggera') return end

    if money > 1000000 then triggeringBan(client, 'since-magasinJob próba nadania dużej ilości gotówki za kurs') return end

    if srp and srp > 50 then triggeringBan(client, 'since-magasinJob próba nadania dużej ilości srp za kurs') return end

    givePlayerMoney(client, money)
    if srp and srp > 0 then
        setElementData(client, 'player:srp', getElementData(client, 'player:srp')+srp)
    end
end)

setTimer(function()
    for i,v in pairs(checkList) do
        checkList[i] = nil
    end
end, 10000, 0)

addEventHandler('onPlayerQuit', root, function()
    if checkList[source] then
        checkList[source] = nil
    end
end)

addEvent("magasin.s", true)
addEventHandler("magasin.s", resourceRoot, function(state)
    local plr = client
    if state == 'pick' then
        if packs[plr] then 
            triggerClientEvent(plr, 'magasin.c', resourceRoot, 'unfreeze')
            return
        end
        local int, dim = getElementInterior(plr), getElementDimension(plr)
        local object = createObject(1271, 0, 0, 0)
        setElementInterior(object, int)
        setElementDimension(object, dim)
        setElementCollisionsEnabled(object, false)
        setObjectScale(object, 0.7)

        setPedAnimation(plr, "CARRY", "liftup", 5000, false, false, false, false)
        --exports['bone_attach']:attachElementToBone(object, plr, 11, -0.2, 0.2, 0.2, 280, 80, 90)

        exports["since-pattach"]:attach(object, plr, 23, -0.07, -0.3, 0.35, 0, 100, 80)

        setTimer(function()
            triggerClientEvent(plr, "magasin.c", resourceRoot, "picked")
            setPedAnimation(plr, "carry", "crry_prtial", 1, false, true)
        end, 1000, 1)
        packs[plr] = object

    elseif state == 'put' then
        if packs[plr] then 
            setPedAnimation(plr, "CARRY", "putdwn", 5000, false, false, false, false)
            setTimer(function()
                if isElement(packs[plr]) then
                    --exports['bone_attach']:detachElementFromBone(packs[plr])
                    destroyElement(packs[plr])
                end
                packs[plr] = nil
                triggerClientEvent(plr, "magasin.c", resourceRoot, "putted")
                setTimer(function() setPedAnimation(plr) end,100,1)
            end, 1000, 1)
        end

    elseif state == 'destroy' then
        if packs[plr] then 
            if isElement(packs[plr]) then
                --exports['bone_attach']:detachElementFromBone(packs[plr])
                destroyElement(packs[plr])
            end
            packs[plr] = nil
        end
        setPedAnimation(plr, "CARRY", "liftup", 5000, false, false, false, false)
        setTimer(function() setPedAnimation(plr) end,100,1)
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if packs[source] then 
        if isElement(packs[source]) then
            --exports['bone_attach']:detachElementFromBone(packs[source])
            destroyElement(packs[source])
        end
        packs[source] = nil
    end
end)
