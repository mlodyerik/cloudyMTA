function globalMessage(plr, cmd, ...)
	if getElementData(plr, "player:faction") == "SAPD" then
		local x, y, z = getElementPosition(plr)
		local players = getElementsWithinRange(x, y, z, 50, 'player')
		local wiadomosc = table.concat({...}, " ")

		for i,v in pairs(players) do
			local id = getElementData(plr, "id")
			local name = getPlayerName(plr):gsub("#%x%x%x%x%x%x","")
			outputChatBox("#71BDFF*MEGAFON*#ffffff "..name..": #C0C0C0"..wiadomosc:gsub("#%x%x%x%x%x%x","").."#ffffff #71BDFF*MEGAFON*#ffffff", v, 255, 255, 255, true)
		end
	end
end
addCommandHandler("megafon", globalMessage)

addEventHandler("onResourceStart", root, function() 
	local players = getElementsByType('player')
	for _,v in pairs(players) do
		bindKey(v, "m", "down", "chatbox", "megafon")
	end
end)