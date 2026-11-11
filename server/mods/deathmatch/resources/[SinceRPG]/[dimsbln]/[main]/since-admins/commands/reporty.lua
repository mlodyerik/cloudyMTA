addCommandHandler("reporty", function(plr,cmd,id)
	if not getAdmin(plr) then
		return
	end

	if not id then return outputChatBox("ⓘ#ffffff /reporty <id/nick>", plr, 255, 255, 0, true) end

    local target = exports["since-core"]:findPlayer(plr, id)

    if not target then return end
	
    local result = exports['since-db']:query('SELECT * FROM `since-admins` WHERE serial = ?', getPlayerSerial(target))

    if #result > 0 then
        outputChatBox("ⓘ#ffffff Wykonane reporty: "..result[1].reporty, target, 255, 255, 0, true)
    end
end)

function getNameFromSerial(serial)
    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE serial = ?', serial)

    if #result > 0 then
        return result[1].nick
    end

    return false
end

function getPlayerFromSerial(serial)
    for i,v in ipairs(getElementsByType('player')) do
        if getPlayerSerial(v) == serial then
            return v
        end
    end

    return false
end

addCommandHandler("reporty.all", function(plr,cmd)
	if not getAdmin(plr) then
		return
	end

    local result = exports['since-db']:query('SELECT * FROM `since-admins` ORDER BY `reporty` DESC')
    
    if #result > 0 then
        for i,v in ipairs(result) do
            local playerNick = getNameFromSerial(v.serial)
            outputChatBox(i..". "..playerNick.." #ffffff: "..v.reporty, plr, 255, 255, 0, true)
        end
    end
end)

local reportCost = 550000

addCommandHandler('wyplata.all', function(plr, cmd)
	if getAdmin(plr, 4) or getAdmin(plr, 3) then
		local result = exports['since-db']:query('SELECT * FROM `since-admins` ORDER BY `reporty` DESC')

		if #result > 0 then
			for i, v in ipairs(result) do
				local value = v.reporty * reportCost
				exports['since-db']:query('UPDATE `since-users` SET `bankMoney` = `bankMoney` + ? WHERE `serial` = ?', value, v.serial)
				exports['since-db']:query('UPDATE `since-admins` SET `reporty` = ? WHERE `serial` = ?', 0, v.serial)

				local player = getPlayerFromSerial(v.serial)
				if player then
					outputChatBox('ⓘ #ffffffOtrzymałeś(aś) wypłatę w wysokości #2E756F$ '..addCommas(value)..' #ffffffza wykonane reporty. #bababa(pieniądze trafiły na konto bankowe)', player, 255, 255, 0, true)
				end
			end
		end
	end
end)

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

addCommandHandler('statystyki.hasj.reports', function (plr)
    if not getAdmin(plr, 4) then
        return
    end

    local result = exports['since-db']:query('SELECT * FROM `since-admins` ORDER BY `reporty` DESC')

    if #result > 0 then
        for i, v in ipairs(result) do
            local playerNick = getNameFromSerial(v.serial)
            outputChatBox(i..". "..playerNick.." #ffffff: "..addCommas(v.reporty * reportCost), plr, 255, 255, 0, true)
        end
    end
end)