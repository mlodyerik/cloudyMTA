  

local ogloszenia = {}

setTimer(function()
	local ads = {}
	for i,v in pairs(ogloszenia) do
		v.del = i
		table.insert(ads, v)
	end
	if ads[1] then
		triggerClientEvent(root, "since-ads:loadAd", resourceRoot, ads[1])
        outputConsole(ads[1].nick..' ('..ads[1].id..'): '..ads[1].text, root)
		table.remove(ogloszenia, ads[1].del)
	end
end, 10000, 0)

addCommandHandler("ogloszenie", function(plr, cmd, ...)
    if (not getElementData(plr,"player:sid")) then 
        return 
    end
    if (getElementData(plr,"player:mute")) then 
        exports['since-notifications']:sendNotification(plr,'error', 'Nie możesz wysłać ogłoszenia, masz mute', 5000)
        return 
    end
    for k,v in pairs(ogloszenia) do
        if (v.player == plr) then
            exports['since-notifications']:sendNotification(plr,'error', 'Twoje zgłoszenie jest już na liście, nie możesz wysłać kolejnego!', 5000)
            return
        end
    end

    local tresc = table.concat({...}, " " )
    if not ... then 
        exports['since-notifications']:sendNotification(plr,'error', 'Poprawne użycie: /ogloszenie (treść)', 5000)
        return 
    end
    
	if string.len(tresc) < 3 then 
        exports['since-notifications']:sendNotification(plr,'error', 'Twoje ogłoszenie musi zawierać minimum 3 znaki', 5000)
        return 
    end

	table.insert(ogloszenia, {
        nick = getPlayerName(plr):gsub("#%x%x%x%x%x%x", ""), 
        text = tresc:gsub("#%x%x%x%x%x%x", ""), 
        sid = getElementData(plr, "player:sid"), 
        id = getElementData(plr, "id"), 
        player = plr,
        color = getElementData(plr, 'player:diamond') and 2 or 1
    })

    exports['since-notifications']:sendNotification(plr,'success', 'Twoje ogłoszenie zostało dodane do kolejki', 5000)
end)

addCommandHandler("ogloszenia", function(plr, cmd)
    if not getElementData(plr,"player:sid") then 
        return 
    end
    if ogloszenia and #ogloszenia > 0 then
        outputChatBox("⩥ #ffffffLista ogłoszeń:", plr, 55, 255, 55, true )
	    for i,v in pairs(ogloszenia) do
            outputChatBox(i..".#ffffff "..v.nick.."#ffffff: "..v.text, plr, 55, 255, 55, true )
	    end
    else
        outputChatBox("◾#ffffffBrak ogłoszeń w kolejce.", plr, 255, 55, 55, true )
    end
end)

-- local rows = exports['since-db']:query('SELECT * FROM `since-ban`')

-- for i,v in pairs(rows) do
--     if (not v.reason:lower():find('cheaty') and not v.reason:lower():find('cheating')) then
--         exports['since-db']:query('DELETE FROM `since-ban` WHERE `serial` = ?', v.serial)
--         outputDebugString('Usunięto bana z powodu: '..v.reason)
--     end
-- end