addEvent("since-mdt:mandat", true)
addEventHandler("since-mdt:mandat", resourceRoot, function(id, table2, total)
	if id and table2 then
		local target = exports["since-core"]:findPlayer(client, id)
		if not target then
			outputChatBox("#ff0000✘ #ffffffNie znaleziono gracza o podanym ID!", client, 255, 255, 255, true)
			return false
		end

		local x, y, z = getElementPosition(client)
		local x2, y2, z2 = getElementPosition(target)
		local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		if distance > 50 then
			outputChatBox("#ff0000✘ #ffffffPodany gracz znajduję się za daleko Ciebie!", client, 255, 255, 255, true)
			return false
		end

		local money = getPlayerMoney(target)
		if tonumber(money) < tonumber(total) then
			outputChatBox("#ff0000✘ #ffffffGracz nie posiada pieniędzy na opłatę mandatu!", client, 255, 255, 255, true)
			return false
		end

		outputChatBox("#00ff00✔ #ffffffFunkcjonariusz #a9a9a9"..removeHex(getPlayerName(client)).." #ffffffukarał Cię za następujące wykroczenia", target, 255, 255, 255, true)
		outputChatBox("#00ff00✔ #ffffffPomyślnie ukarałeś gracza #a9a9a9"..removeHex(getPlayerName(target)).." #ffffffza wybrane przez Ciebie wykroczenia!", client, 255, 255, 255, true)
		local string = ""
		for i,v in ipairs(table2) do
			outputChatBox("#dede10⊚ #ffffff"..v.name.." #a9a9a9"..przecinek(v.price).." #ffffffPLN", target, 255, 255, 255, true)
			string = string..","..v.name
		end
		exports["since-db"]:query("INSERT INTO `since-mdt` SET sid=?, type=?, text=?, date=NOW(), przez=?, total=?", getElementData(target, "player:sid"), "Mandat", string, removeHex(getPlayerName(client)), total)
		takePlayerMoney(target, total)
	end
end)

addEvent("since-mdt:upomnienie", true)
addEventHandler("since-mdt:upomnienie", resourceRoot, function(id, table)
	if id and table then
		local target = exports["since-core"]:findPlayer(client, id)
		if not target then
			outputChatBox("#ff0000✘ #ffffffNie znaleziono gracza o podanym ID!", client, 255, 255, 255, true)
			return false
		end

		local x, y, z = getElementPosition(client)
		local x2, y2, z2 = getElementPosition(target)
		local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		if distance > 50 then
			outputChatBox("#ff0000✘ #ffffffPodany gracz znajduję się za daleko Ciebie!", client, 255, 255, 255, true)
			return false
		end

		outputChatBox("#00ff00✔ #ffffffFunkcjonariusz #a9a9a9"..removeHex(getPlayerName(client)).." #ffffffnadał Ci upomnienia za następujące wykroczenia", target, 255, 255, 255, true)
		outputChatBox("#00ff00✔ #ffffffPomyślnie nadałeś upomnienia graczowi #a9a9a9"..removeHex(getPlayerName(target)).." #ffffffza wybrane przez Ciebie upomnienia!", client, 255, 255, 255, true)
		for i,v in ipairs(table) do
			outputChatBox("#dede10⊚ #ffffff"..v.name.." #a9a9a90 #ffffffPLN", target, 255, 255, 255, true)
		end
	end
end)

addEvent("since-mdt:wpis", true)
addEventHandler("since-mdt:wpis", resourceRoot, function(sid, text)
	if sid and text then
		exports["since-db"]:query("INSERT INTO `since-mdt` SET sid=?, type=?, text=?, date=NOW(), przez=?", sid, "Wpis", text, removeHex(getPlayerName(client)))
		outputChatBox("#00ff00✔ #ffffffPomyślnie dodano wpis do bazy danych!", client, 255, 255, 255, true)
	end
end)

addEvent("since-mdt:wpis:delete", true)
addEventHandler("since-mdt:wpis:delete", resourceRoot, function(sid, text, date)
	if sid and text and date then
		exports["since-db"]:query("DELETE FROM `since-mdt` WHERE sid=? AND text=? AND date=? LIMIT 1", sid, text, date)
		outputChatBox("#00ff00✔ #ffffffPomyślnie usunięto wpis z bazy danych!", client, 255, 255, 255, true)
	end
end)

addEvent("since-mdt:search", true)
addEventHandler("since-mdt:search", resourceRoot, function(login)
	if login then
		local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE login=?", login)
		if result and #result > 0 then
			local result2 = exports["since-db"]:query("SELECT * FROM `since-mdt` WHERE sid=? AND type=?", result[1].uid, "Mandat")
			local result3 = exports["since-db"]:query("SELECT * FROM `since-mdt` WHERE sid=? AND type=?", result[1].uid, "Wyrok")
			local result4 = exports["since-db"]:query("SELECT * FROM `since-mdt` WHERE sid=? AND type=?", result[1].uid, "Wpis")
			triggerClientEvent(client, "since-mdt:search:set", resourceRoot, result, result2, result3, result4)
		end
	end
end)

function przecinek(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return formatted 
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end