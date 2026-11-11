local serials = {
    ['AE2FD7C7C96C6D311A1386C821AEB082'] = true,
    ['C217ED9FE6899B85C066837D5D16A4D1'] = true,
}

local cannels = {
    ['Antycheat'] = 'https://canary.discord.com/api/webhooks/1321458265158057984/9kq1JtrpjCz7mCmZtjWkfX6K5_EMKn0fAzzQkUiZYuoiLnBcf0dOsU6ipBvWb51ZFtic',
}

local players = {}
  
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

function createOpening(player, lootbox, eqName)
    if (exports['since-inventory']:isPlayerHaveItem(player, eqName) and not players[player]) then
        players[player] = true
        local items = {}

        for i = 1, 100 do
            local item = getItemByRarityNumber(boxList[lootbox].items, boxList[lootbox].items[math.random(1, #boxList[lootbox].items)].chance)

            items[i] = {
                name = item.name,
                value = type(item.value) == 'table' and math.random(item.value.min, item.value.max) or item.value,
                item = item,
            }
        end

        local rnd = math.random(40, 50)

        exports['since-inventory']:addPlayerItem(player, eqName, -1)
        triggerClientEvent(player, 'createOpening', resourceRoot, lootbox, items, rnd)

        setTimer(function (player)
            local itemName, itemValue = items[rnd+5].name, items[rnd+5].value

            local sid = getElementData(player, 'player:sid')
            if not sid then 
                return 
            end
        
            if not checkList[player] then
                checkList[player] = 0
            end
        
            checkList[player] = checkList[player] + 1
        
            if checkList[player] >= 5 then triggeringBan(player, 'since-lootbox zbyt szybkie wywołanie triggera') return end
        
            writeOnDiscord('Antycheat', 'Gracz `'..getPlayerName(player)..'` (SID: `'..sid..'`) wylosował nagrodę z lootboxa. Nagroda: `'..itemName..'` - Ilość: `'..itemValue..'`')

            -- local file = fileOpen('lootbox.txt')
            -- local data = fileRead(file, fileGetSize(file))

            -- fileWrite(file, data..'\n'..getPlayerName(player)..' ('..sid..') wylosował nagrodę z lootboxa. Nagroda: '..itemName..' - Ilość: '..itemValue)
            -- fileClose(file)
        
            if itemName == 'SRP' then
                if itemValue > limitToBan[itemName] then triggeringBan(player, 'since-lootbox przekroczy limit configu') return end
                giveReputation(player, itemValue)
                text = itemValue..' SRP'
            elseif itemName == 'Pojazd' then
                addVehicle(player, itemValue)
                text = 'Pojazd '..exports['since-vehiclenames']:getVehicleName(itemValue)
            elseif itemName == 'Punkty Premium' then
                if itemValue > limitToBan[itemName] then triggeringBan(player, 'since-lootbox przekroczy limit configu') return end
                givePremiumPoints(player, itemValue)
                text = itemValue..' PP'
            elseif itemName == 'Gotówka' then
                if itemValue > limitToBan[itemName] then triggeringBan(player, 'since-lootbox przekroczy limit configu') return end
                givePlayerMoney(player, itemValue)
                text = formatNumber(itemValue)..' $'
            elseif itemName == 'wPLN' then
                if itemValue > limitToBan[itemName] then triggeringBan(player, 'since-lootbox przekroczy limit configu') return end
                local result = exports['since-db']:query('UPDATE `since-users` SET `wPLN` = `wPLN` + ? WHERE `uid` = ?', itemValue, sid)
                text = formatNumber(itemValue)..' wPLN'
            elseif itemName == 'Diamond Box' then
                if itemValue > limitToBan[itemName] then triggeringBan(player, 'since-lootbox przekroczy limit configu') return end
                exports['since-inventory']:addPlayerItem(player, 'diamond-box', tonumber(itemValue))
                text = itemValue..'x Diamond Box'
            elseif itemName == 'Legendary Box' then
                if itemValue > limitToBan[itemName] then triggeringBan(player, 'since-lootbox przekroczy limit configu') return end
                exports['since-inventory']:addPlayerItem(player, 'legendary-box', tonumber(itemValue))
                text = itemValue..'x Legendary Box'
            end
        
            exports['since-notifications']:sendNotification(player, 'success', 'Wylosowałeś '..text)
            setTimer(function (player)
                players[player] = nil
            end, 5000, 1, player)
        end, 8000, 1, player)
    end
end

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

function giveReputation(plr, value)
    local sid = getElementData(plr, 'player:sid')

    if not sid then 
        return
    end

    local srp = getElementData(plr, 'player:srp') or 0
    setElementData(plr, 'player:srp', srp + value)
end

function givePremiumPoints(plr, value)
    local sid = getElementData(plr, 'player:sid')

    if not sid then 
        return
    end

    local premiumPoints = getElementData(plr, 'player:pp') or 0
    setElementData(plr, 'player:pp', premiumPoints + value)
end

function addVehicle(plr, model)
    local sid = getElementData(plr, 'player:sid')

    if not sid then 
        return
    end

    local clr = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
    local hclr = {255, 255, 255}
    local wheelTuning = {

        vinylRim = 0,
        vinylWounds = 0,
        wheelTilt = 0,
        innerSize = 0.8,
        wheelResize = 1,

    }

    local vehData = {

        driver = 'Brak',
        mileage = 0,
        engine = 1.8,


    }

    local fuel = {

        count = 50,
        tank = 50,

    }

    local variant = {0, 0}

    local upgrades = {}

    exports['since-db']:query('INSERT INTO `since-vehicles` (`model`, `fuel`, `upgrades`, `data`, `color`, `headlight`, `wheelTuning`, `owner`, `state`, `variant`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)', model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(vehData), serpent.dump(clr), serpent.dump(hclr), serpent.dump(wheelTuning), sid, serpent.dump(variant))
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end