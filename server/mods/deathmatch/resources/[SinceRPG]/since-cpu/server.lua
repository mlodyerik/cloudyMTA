local playerTimers = {}
function sendStats(player)
	if isElement(player) then
		local columns, rows = getPerformanceStats("Lua timing")
		triggerClientEvent(player, "receiveServerStat", player, columns, rows)
		playerTimers[player] = setTimer(sendStats, 1000, 1, player)
	end
end

addEvent("getServerStat", true)
addEventHandler("getServerStat", resourceRoot, function()
	sendStats(client)
end)

addEvent("destroyServerStat", true)
addEventHandler("destroyServerStat", resourceRoot, function()
	if isTimer(playerTimers[client]) then
		killTimer(playerTimers[client])
		playerTimers[client] = nil
	end
end)

function removeDatas()
	local count = {

		players = 0,
		vehicles = 0,
		markers = 0,
		objects = 0

	}

    for i,v in pairs(getElementsByType("player")) do 
        local data = getAllElementData (v)
        for ks, vs in pairs (data) do  
            if vs == false then 
                removeElementData (v, ks) 
				count.players = count.players + 1
            end
        end
    end

    for i,v in pairs(getElementsByType("vehicle")) do 
        local data = getAllElementData (v)
        for ks, vs in pairs (data) do  
            if vs == false then 
                removeElementData (v, ks) 
				count.vehicles = count.vehicles + 1
            end
        end
    end

    for i,v in pairs(getElementsByType("marker")) do 
        local data = getAllElementData (v)
        for ks, vs in pairs (data) do  
            if vs == false then 
                removeElementData (v, ks) 
				count.markers = count.markers + 1
            end
        end
    end

    for i,v in pairs(getElementsByType("object")) do 
        local data = getAllElementData (v)
        for ks, vs in pairs (data) do  
            if vs == false then 
                removeElementData (v, ks) 
				count.objects = count.objects + 1
            end
        end
    end

	local totalDatas = count.players + count.vehicles + count.markers + count.objects

	print('[since-cpu]: Usunięto '..totalDatas..' elementdat z pamięci | Gracze: '..count.players..' | Pojazdy: '..count.vehicles..' | Markery: '..count.markers..' | Obiekty: '..count.objects..'')
end
setTimer(removeDatas, 60000, 0)

addEventHandler("onResourceStart", resourceRoot, function()
    removeDatas()
end)