  

addEvent("zetony:server", true)
addEventHandler("zetony:server", resourceRoot, function(status,kwota,inne)
	if status == "bank" then
		local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(client,"player:sid"))		
		local result=exports["since-db"]:query("SELECT * FROM `since-casino` WHERE sid=?", getElementData(client,"player:sid"))
		if result and #result > 0 then			
			local d = getElementData(client,"client:coin") or false
			if d == false then return end
			if tonumber(d) > tonumber(kwota) or tonumber(d) == tonumber(kwota) then
				local d2 = d-kwota
				setElementData(client,"client:coin",d2)
				
				local d3 = result1[1].bankMoney+kwota
				exports["since-db"]:query("UPDATE `since-casino` SET zetony=? WHERE sid=?",d2,getElementData(client,"player:sid"))			
				exports["since-db"]:query("UPDATE `since-users` SET bankMoney=? WHERE uid=?",d3,getElementData(client,"player:sid"))
				local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(client,"player:sid"))	
				triggerClientEvent( client, "zeton:client", resourceRoot,result1[1].bankMoney)
				exports['since-logs']:sendDiscordLog('kasyno', 'Kasyno żetony', 'Gracz **'..getPlayerName(client)..'** sprzedał **'..formatNumber(kwota)..'** żetonów.')

			else
				outputChatBox ( "Posiadasz za mało żetonów.", client, 255, 255, 255, true )
			end
		end
	elseif status == "zeton" then
		local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(client,"player:sid"))
		
		local result=exports["since-db"]:query("SELECT * FROM `since-casino` WHERE sid=?", getElementData(client,"player:sid"))
		if result and #result > 0 then				
			local d = getElementData(client,"client:coin") or false
			if d == false then return end
			if tonumber(result1[1].bankMoney) > tonumber(kwota) or tonumber(result1[1].bankMoney) == tonumber(kwota) then	
				local d2 = d+kwota
				setElementData(client,"client:coin",d2)		
				local d3 = result1[1].bankMoney-kwota
				exports["since-db"]:query("UPDATE `since-casino` SET zetony=? WHERE sid=?",d2,getElementData(client,"player:sid"))	
				exports["since-db"]:query("UPDATE `since-users` SET bankMoney=? WHERE uid=?",d3,getElementData(client,"player:sid"))	
				local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(client,"player:sid"))	
				triggerClientEvent( client, "zeton:client", resourceRoot,result1[1].bankMoney)
				exports['since-logs']:sendDiscordLog('kasyno', 'Kasyno żetony', 'Gracz **'..getPlayerName(client)..'** zakupił **'..formatNumber(kwota)..'** żetonów.')
				
			else
				outputChatBox ( "Posiadasz za mało pieniędzy w bankomacie.", client, 255, 255, 255, true )
			end
		end
	elseif status == "bank_out" then
		local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(client,"player:sid"))	
		triggerClientEvent( client, "zeton:client", resourceRoot,result1[1].bankMoney)
	-- elseif status == "save" then
	-- 	exports["since-db"]:query("UPDATE `since-casino` SET zetony=? WHERE sid=?",kwota,getElementData(client,"player:sid"))
	end
end)

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end