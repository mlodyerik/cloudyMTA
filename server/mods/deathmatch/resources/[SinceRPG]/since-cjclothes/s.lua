function getClothes(plr)
    if not getElementData(plr,"player:sid") then return {} end
	local result=exports['since-db']:query("SELECT * FROM `since-clothes` WHERE uid=?", getElementData(plr,"player:sid"))
	local clothes = {}
	if #result > 0 then
		for i,v in ipairs(result) do
			table.insert(clothes,{v.ids,v.texture,v.model,v.name})
		end
	end
	return clothes
end

addEvent("since-cjclothes:get", true)
addEventHandler("since-cjclothes:get", resourceRoot, function()
    triggerClientEvent(client, "since-cjclothes:get", resourceRoot, getClothes(client))
end)

addEvent("since-cjclothes:try", true)
addEventHandler("since-cjclothes:try", resourceRoot, function(data)
    setPedStat(client, data[1], data[2])
end)


addEvent("buy:setPlayerStat", true)
addEventHandler("buy:setPlayerStat", resourceRoot, function(b,c)
	setPlayerStat ( client,b,c )
	if b == 21 then
		exports['since-db']:query("UPDATE `since-users` SET fat=? WHERE uid=?",c,getElementData(client,"player:sid"))
	end
	if b == 23 then
		exports['since-db']:query("UPDATE `since-users` SET miesnie=? WHERE uid=?",c,getElementData(client,"player:sid"))
	end	
end)

addEvent("buy:clothes", true)
addEventHandler("buy:clothes", resourceRoot, function(ids,text,model,name,cena)
	local result=exports['since-db']:query("SELECT * FROM `since-clothes` WHERE uid=?", getElementData(client,"player:sid"))
	for i,v in ipairs(result) do
		if v.ids == ids and v.texture == text and v.model == model then
			addPedClothes ( client, text,model, ids )
			local lista = {}
			for i = 0,16 do 
				local texture, model = getPedClothes ( client, i )
				if texture and model then
					table.insert(lista,{i,texture,model})
				end
			end
			local json = toJSON(lista)
			exports['since-db']:query("UPDATE `since-users` SET clothes=? WHERE uid=?",json,getElementData(client,"player:sid"))
			local lista = {}
			return
		end
	end

    if not text then
        removePedClothes(client, ids)
        local lista = {}
        for i = 0,16 do 
            local texture, model = getPedClothes ( client, i )
            if texture and model then
                table.insert(lista,{i,texture,model})
            end
        end
        local json = toJSON(lista)
        exports['since-db']:query("UPDATE `since-users` SET clothes=? WHERE uid=?",json,getElementData(client,"player:sid"))
        return
    end
	
	local result1=exports['since-db']:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(client,"player:sid"))
	if result1 and #result1 > 0 then	
		if getPlayerMoney(client) >= tonumber(cena) then	
			exports['since-db']:query("INSERT INTO `since-clothes` (ids,texture,model,name,uid) VALUES (?,?,?,?,?)",ids,text,model,name, getElementData(client,"player:sid"))	
			triggerClientEvent( client, "since-cjclothes:get", resourceRoot, getClothes(client))
			addPedClothes ( client, text,model, ids )
			local lista = {}
			for i = 0,16 do 
				local texture, model = getPedClothes ( client, i )
				if texture and model then
					table.insert(lista,{i,texture,model})
				end
			end
			local json = toJSON(lista)
			exports['since-db']:query("UPDATE `since-users` SET clothes=? WHERE uid=?",json,getElementData(client,"player:sid"))
            takePlayerMoney(client, tonumber(cena))
		else
			outputChatBox("Nie stać cie na to.", client)
		end
	end
	
end)