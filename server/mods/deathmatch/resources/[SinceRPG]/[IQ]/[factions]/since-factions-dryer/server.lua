  

--[[
    Author: EnoNeK
    For: cloudyMTA
]]

local SPEED_LIMIT = 90
local ILE_ZA_1KM = 5000

function kropki(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return formatted 
end

addEvent("fdryer:action", true)
addEventHandler("fdryer:action", resourceRoot, function(action, element, speed)
    if element and isElement(element) and action and getElementData(client, "player:faction") then
        if action == 'mandat' then
            local driver = getVehicleOccupant(element)
            if driver and isElement(driver) then
                local price = ((speed-SPEED_LIMIT)*ILE_ZA_1KM)
                outputChatBox("#fccf03* #ffffffFunkcjonariusz #0000cd"..getPlayerName(client):gsub("#%x%x%x%x%x%x", "").." #ffffffwystawił Ci mandat za przekroczenie prędkości o #ff0000"..(speed-SPEED_LIMIT).." #ffffffkm/h", driver, _, _, _, true)
                outputChatBox("#fccf03* #ffffffKwota mandatu #59eb05"..kropki(price).." #ffffff$!", driver, _, _, _, true)

                outputChatBox("#fccf03* #ffffffWystawiłeś mandat graczowi #a9a9a9"..getPlayerName(driver):gsub("#%x%x%x%x%x%x", "").." #ffffffza przekroczenie prędkości o #ff0000"..(speed-SPEED_LIMIT).." #ffffffkm/h", client, _, _, _, true)
                outputChatBox("#fccf03* #ffffffKwota mandatu #59eb05"..kropki(price).." #ffffff$!", client, _, _, _, true)
                outputChatBox("#fccf03* #ffffffOtrzymujesz #59eb05"..kropki(price*0.15).." #ffffff$!", client, _, _, _, true)

                if getPlayerMoney(driver) >= price then
                    takePlayerMoney(driver, price)
                else
                    takePlayerMoney(driver, getPlayerMoney(driver))
                end

                givePlayerMoney(client, math.floor(price*0.15))
            end
        elseif action == 'reczny' then
            if speed <= 5 then
                setElementFrozen(element, not isElementFrozen(element))

                local state = isElementFrozen(element) and "zaciągnięty" or "spuszczony"
                outputChatBox("#fccf03* #ffffffRęczny został "..state, client, _, _, _, true)
            end
        elseif action == 'tank' then
            if speed <= 5 then

                local fuelData = getElementData(element, 'vehicle:fuel') or {}
                fuelData['count'] = fuelData['tank']
                fuelData['countLPG'] = 100
                setElementData(element, 'vehicle:fuel', fuelData)

                outputChatBox('#fccf03* #ffffffZatankowałeś(aś) pojazd.', client, _, _, _, true)
            end
        end
    end
end)

local cooldown = {}

function dryer(plr)
    if cooldown[plr] then
        if getTickCount() - cooldown[plr] < 1000 then
            return false
        end
    end
    if getElementData(plr, "player:faction") == "SAPD" or getElementData(plr, 'player:faction') == 'SARA' then
        if getPedWeapon(plr, 2) ~= 22 then
            outputChatBox("#00ff00✔ #ffffffWyciągnąłeś/aś suszarkę!", plr, _, _, _, true)
            giveWeapon(plr, 22, 99999)
            cooldown[plr] = getTickCount()
        else
            outputChatBox("#ff0000✖ #ffffffSchowałeś/aś suszarkę!", plr, _, _, _, true)
            takeWeapon(plr, 22)
            cooldown[plr] = getTickCount()
        end
    end
end

function paralizator(plr)
    if cooldown[plr] then
        if getTickCount() - cooldown[plr] < 1000 then
            return false
        end
    end

    if getElementData(plr, "player:faction") == "SAPD" then
        if getPedWeapon(plr, 2) ~= 23 then
            outputChatBox("#00ff00✔ #ffffffWyciągnąłeś/aś paralizator!", plr, _, _, _, true)
            giveWeapon(plr, 23, 99999)
            cooldown[plr] = getTickCount()
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function() 
    for i,v in ipairs(getElementsByType("player")) do
        bindKey(v, ".", "down", dryer)
        bindKey(v, ",", "down", paralizator)
    end
end)
    
addEventHandler("onPlayerSpawn", getRootElement(), function()
    bindKey(source, ".", "down", dryer)
    bindKey(source, ",", "down", paralizator)
end)