  

local pointsMarkers={
	{"SAPD", 1, 2053.49, -1907.30, 13.70, 0, 0},
	--{"SAFD", 2, 852.02, 1922.91, 14.66, 0, 0},
	{"SARA", 3, 1765.53, -1714.32, 16.56, 0, 0},
	--{"TSA", 4, -2026.85, -114.92, 1035, 3, 0},
}

for i,v in ipairs(pointsMarkers) do
	local marker=createMarker(v[3], v[4], v[5]-1, "cylinder", 1.2, 255, 0, 0,255)
	setElementData(marker,"marker:id",tonumber(v[2]))
	setElementInterior(marker, v[6])
	setElementDimension(marker, v[7])
	setElementData(marker,"marker:faction",v[1])
	setElementData(marker,"marker:icon",'skin')
	setElementData(marker,"marker:title",'Panel lidera')
	setElementData(marker,"marker:desc",'Zarządzanie frakcją\n'..v[1])
end

addEvent("lider:editUser", true)
addEventHandler("lider:editUser", resourceRoot, function(text,rank,faction)
	local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", text)
	if not result1 or #result1 < 0 then outputChatBox("* Podany użytkownik nie istnieje w bazie danych.", client, 255, 0, 0) return end 
    local result2=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=? AND uid=? LIMIT 1;", faction, text) -- pobieramy tylko JEDEN rekord
	if not result2 or #result2 < 0 then outputChatBox("*Podany użytkownik nie znajduje się w tej frakcji!",client,255,0,0) return end
	local query1=exports["since-db"]:query("UPDATE `since-factions` SET `rank`=? WHERE `uid`=? AND `faction`=?", rank, text, faction)
	if query1 then
	local resulted=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=?", faction)
		triggerClientEvent(client,"lider:refresh",resourceRoot,resulted)
		outputChatBox('ⓘ#ffffff Zaktualizowałeś rangę graczowi #cccccc'..result1[1].nick..'#ffffff. Poprzednia ranga: #cccccc'..exports['since-factions']:getRankData(faction, result2[1].rank)..'#ffffff.', client, 255, 255, 0, true)
	end
end)
addEvent("lider:addUser", true)
addEventHandler("lider:addUser", resourceRoot, function(text,faction)
	local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", text)
	if not result1 or #result1 < 0 then outputChatBox("* Podany użytkownik nie istnieje w bazie danych.", client, 255, 0, 0) return end
	local result2=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE uid=? and faction=?", text, faction)
	if result2 and #result2 > 0 then outputChatBox("* Podany użytkownik już znajduje się w tej frakcji.", client, 255, 0, 0) return end
	local result3=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE uid=?", text)
	if result3 and #result3 > 0 then outputChatBox("* Podany użytkownik już znajduje się w innej frakcji.", client, 255, 0, 0) return end
	outputDebugString("Faction: "..faction)
	outputDebugString("Text: "..text)
	local query1=exports["since-db"]:query("INSERT `since-factions` (uid,faction,rank,nick,added,added_by) VALUES (?,?,1,?,NOW(),?)", text, faction, result1[1].nick, getPlayerName(client))
	if query1 then
	local resulted=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=?", faction)
		triggerClientEvent(client,"lider:refresh",resourceRoot,resulted)
		outputChatBox('#00ff00✔ #ffffffDodałeś(aś) gracza #cccccc'..result1[1].nick..' #ffffffdo frakcji #cccccc'..faction..'#ffffff.', client, 255, 255, 255, true)
	end
end)
addEvent("lider:deleteUser", true)
addEventHandler("lider:deleteUser", resourceRoot, function(text,faction)
	local result1=exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", text)
	if not result1 or #result1 < 0 then outputChatBox("* Podany użytkownik nie istnieje w bazie danych.", client, 255, 0, 0) return end 
    local result2=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=? AND uid=? LIMIT 1;", faction, text) -- pobieramy tylko JEDEN rekord
	if not result2 or #result2 < 0 then outputChatBox("* Podany użytkownik nie znajduje się w tej frakcji!",client,255,0,0) return end
	local query1=exports["since-db"]:query("DELETE FROM `since-factions` WHERE uid=? AND faction=?",text, faction)
	if query1 then
	local resulted=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=?", faction)
	triggerClientEvent(client,"lider:refresh",resourceRoot,resulted)
	outputChatBox('#00ff00✔ #ffffffUsunąłeś(aś) gracza #cccccc'..result1[1].nick..' #ffffff(UID: #cccccc'..text..'#ffffff) z frakcji.', client, 255, 255, 255, true)
	end
end)

addEventHandler("onMarkerHit", resourceRoot, function(el,md)
	if not md or getElementType(el) ~= "player" then return end
	local code=getElementData(source,"marker:faction")
	if not code then return end
	local uid=getElementData(el,"player:sid")
	if not uid then return end
	if not getElementData(el, "player:faction") then outputChatBox('#ff0000❌ #ffffffNie możesz otworzyć panelu nie będąc na służbie!', el, 255, 255, 255, true) return end
	if getElementData(el, "player:faction") ~= code then outputChatBox('#ff0000❌ #ffffffNie posiadasz uprawnień!', el, 255, 255, 255, true) return end
    local result=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=? AND uid=? LIMIT 1;", code, uid) -- pobieramy tylko JEDEN rekord
	if result and #result > 0 then
		if result[1].rank < exports['since-factions']:getMaxRank(code)-1 then outputChatBox('#ff0000❌ #ffffffNie posiadasz uprawnień!', el, 255, 255, 255, true) return end
	local resulted=exports["since-db"]:query("SELECT * FROM `since-factions` WHERE faction=?", code)
		triggerClientEvent(el, "lider:showGUI", resourceRoot,code, resulted)
	end
end)

function convertMinutesToHours(minutes)
    local hours = math.floor(minutes / 60)
    local minutes = minutes - (hours * 60)

    if hours == 0 and minutes == 0 then
        return '0 minut'
    elseif hours == 0 then
        return minutes..' minut'
    elseif minutes == 0 then
        return hours..' godzin'
    else
        return hours..' godzin i '..minutes..' minut'
    end
end