LAST_TICK_ROBBERY = false

addEvent("enonek-sapdnapad:info", true)
addEventHandler("enonek-sapdnapad:info", resourceRoot, function()
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "player:faction") == "SAPD" then
			outputChatBox("#00ff00✔ #ffffffGracz #a9a9a9"..getPlayerName(client):gsub ("#%x%x%x%x%x%x", "").." #ffffffrozpoczął napad na komende SAPD!", v, 255, 255, 255, true)
		end
	end
	LAST_TICK_ROBBERY = getTickCount()
end)

addEvent("enonek-sapdnapad:gettick", true)
addEventHandler("enonek-sapdnapad:gettick", resourceRoot, function()
	if LAST_TICK_ROBBERY then
		if getTickCount() - LAST_TICK_ROBBERY < 900000 then
			triggerClientEvent(client, "enonek-sapdnapad:settick", resourceRoot, false)
			return false
		end
		triggerClientEvent(client, "enonek-sapdnapad:settick", resourceRoot, true)
	else
		triggerClientEvent(client, "enonek-sapdnapad:settick", resourceRoot, true)
	end
end)

addEvent("enonek-sapdnapad:end", true)
addEventHandler("enonek-sapdnapad:end", resourceRoot, function()
	for i,v in ipairs(getElementsByType("player")) do
		if (getElementData(v, "player:jail")) then
			setElementPosition(v, 634.64, -566.45, 16.34)
			removeElementData(v,"player:jail")
			local result = exports["since-db"]:query("DELETE FROM `since-jail` WHERE serial=? LIMIT 1", getPlayerSerial(v))
			outputChatBox("#00ff00✔ #ffffffZostałeś uwolniony!", v, 255, 255, 255, true)
		end
	end
end)


local cuboid = createColCuboid(606.80, -583.46, 15.62, 25.32, 23.42, 9.40)

addEventHandler("onColShapeLeave", cuboid, function(el)
    if getElementType(el) == "player" then

    	if getElementData(el, "player:napad:sapd") then
    		guiSetInputMode("allow_binds")
    		removeEventHandler("onClientCharacter", root, onCharacter)
    		removeEventHandler("onClientRender", root, render)
    		setElementData(el, "player:napad:sapd", false)
    		outputChatBox("wyszedles poza strefe wiezienia, napad zostal przerwany", el, 255, 255, 255, true)
    	end
    end
end)