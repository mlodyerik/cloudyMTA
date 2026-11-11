

--local cub = createColCuboid(2285.0373046875, 2425.5203125, 3010.1547851563, 12, 8.25, 4.25)
--local cub2 = createColCuboid(2285.0373046875, 2451, 3010.1547851563, 12, 8.25, 4.25)
local col = createColCuboid(606.80, -583.46, 15.62, 25.32, 23.42, 9.40)
setElementDimension(col, 291)

--createBlip(630.68, -571.79, 16.34, 30, 2, 255, 255, 255, 255, 0, 300)

	function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function checkJail(plr)
	local x = exports["since-db"]:query("SELECT * FROM `since-jail` WHERE Serial=?", getPlayerSerial(plr))
	if x and #x > 0 then
		return true
	else
		return false
	end
end


function u(e)
getElementData(e, "player:sid")
end

local cele = { -- x,y,z,int,dim
	{1565.57, -1636.73, 84.51, 0, 291},
	{1570.30, -1636.29, 84.51, 0, 291},
	{1574.58, -1636.53, 84.51, 0, 291},
}

local x,y,z = 1564.13, -1631.84, 84.51
local function wypusc(plr)
setElementDimension(plr,291)
setElementInterior(plr,0)
setElementPosition(plr,x,y,z)
removeElementData(plr, "player:jail")
exports['since-notifications']:sendNotification(plr, 'success', 'Twój czas upłynął. Zostajesz wypuszczony z więzienia')
end

function getPlayerName2(plr)
if not plr then return end
return getPlayerName(plr):gsub("#%x%x%x%x%x%x","")
end

local function sprawdz(plr)
if not plr then return end
if not getElementData(plr,"player:sid") then return end
local x = exports['since-db']:query("SELECT * FROM `since-jail` WHERE Serial=?",getPlayerSerial(plr))
if not x or #x < 1 then return end
local x2=exports['since-db']:query("SELECT Termin FROM `since-jail` WHERE Serial=? and Termin < NOW()",getPlayerSerial(plr))
if x2 and #x2 > 0 then
exports['since-db']:query("DELETE FROM `since-jail` WHERE Serial=?", getPlayerSerial(plr))
wypusc(plr)
return end
if (not getElementData(plr, "player:jail")) then
	setElementData(plr, "player:jail", true)
end
if (isElementWithinColShape(plr, col)) then return end
	removePedFromVehicle(plr)

	setTimer(function()
		setElementPosition(plr,cele[x[1].Cela][1],cele[x[1].Cela][2],cele[x[1].Cela][3])
		setElementDimension(plr, 291)
	end, 100, 1)
end

local function message(plr)
	if not plr then
		return false
	end

	if not getElementData(plr, "player:sid") then
		return false
	end

	local x = exports["since-db"]:query("SELECT * FROM `since-jail` WHERE Serial=?", getPlayerSerial(plr))
	if x and #x > 0 then
		outputChatBox("Pozostały czas: "..x[1].Termin, plr)
	end
end

setTimer(function()
	for i,v in ipairs(getElementsByType("player")) do
		message(v)
	end
end, 60000, 0)

--[[local sphere  = createColSphere(618.01, -552.91, 18.09,13)

function spheres ( thePlayer )
   if getElementType ( thePlayer ) == "player" then 
		if not getElementData(thePlayer,"player:sid") then return end
		local x = exports['since-db']:query("SELECT * FROM `since-jail` WHERE Serial=?",getPlayerSerial(thePlayer))
		if not x or #x < 1 then return end
		setElementPosition(thePlayer,cele[x[1].Cela][1],cele[x[1].Cela][2],cele[x[1].Cela][3])
		setElementDimension(thePlayer, 0)		

   end
end
addEventHandler ( "onColShapeLeave", sphere, spheres )]]--


local function sprawdzczas(plr)
if not plr then return end
if not getElementData(plr,"player:sid") then return end
local x = exports['since-db']:query("SELECT * FROM `since-jail` WHERE Serial=?",getPlayerSerial(plr))
if not x or #x < 1 then return end
local x2=exports['since-db']:query("SELECT Termin FROM `since-jail` WHERE Serial=? and Termin < NOW()",getPlayerSerial(plr))
if x2 and #x2 > 0 then
exports['since-db']:query("DELETE FROM `since-jail` WHERE Serial=?", getPlayerSerial(plr))
wypusc(plr)
return end
exports['since-notifications']:sendNotification(plr, 'info', "Zostałeś aresztowany.\nPowód: "..x[1].Powod.."\nCzas: "..x[1].Termin.."")
end

addCommandHandler('check.jail', function(player, command, cel)
	if getElementData(player, 'player:faction') == 'SAPD' then
		if not cel then
			exports['since-notifications']:sendNotification(player, 'error', 'Poprawne użycie: /'..command..' <nick/ID>')
			return
		end
		local target = exports['since-core']:findPlayer(player, cel)
		if not target then
			exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!')
			return
		end
		if not getElementData(target, 'player:jail') then
			exports['since-notifications']:sendNotification(player, 'error', 'Podany gracz nie znajduje się w więzieniu!')
			return
		end
		local check = exports['since-db']:query('select * from `since-jail` where Serial=?', getPlayerSerial(target))
		if check and #check > 0 then
			outputChatBox('ⓘ#ffffff Pozostały czas odsiadki gracza #cccccc'..getPlayerName(target)..'#ffffff: #cccccc'..check[1].Termin, player, 255, 255, 0, true)
		end
	else
		exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś na służbie!')
	end
end)


function uwiez(plr,cmd,cel,ile,typ, ...)
	if getElementData(plr, "player:faction")=="SAPD" then
		if not cel or not ile or not typ or not ... then
			exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie:\n/areszt <gracz/ID> <czas> <m/h> <powód>')
		return
	end
	local target=exports["since-core"]:findPlayer(plr,cel)
	if not target then
		exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza')
		return
	end
	local powod = table.concat({...}, " ")
    x1,x2,x3 = getElementPosition(plr)
    y1,y2,y3 = getElementPosition(target)
    dystans = getDistanceBetweenPoints3D(x1,x2,x3,y1,y2,y3)
    if dystans > 20.0 then 	exports['since-notifications']:sendNotification(plr, 'error', 'Podany gracz jest za daleko') return end
	local cela=math.random(1, #cele)
	if typ=="m" or typ=="h" then
		if typ=="m"then
			exports["since-db"]:query("INSERT INTO `since-jail` (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? minute,??,?)", getPlayerSerial(target), ile, cela, powod)
			exports['since-notifications']:sendNotification(plr, 'success', "Pomyślnie aresztowano gracza: "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").."\nPowód: "..powod.." Czas: "..ile.." minut/e/y")
			exports['since-notifications']:sendNotification(target, 'info', "Zostałeś aresztowany przez funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."\nPowód: "..powod.." Czas: "..ile.." minut/e/y")
			local desc = "[Więzienie] Gracz: "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").." został uwięziony przez Funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..". Powód uwięzienia: "..powod..", Czas: "..ile.." min"
			triggerEvent("admin:addText", resourceRoot, RGBToHex(0,0,255)..desc..RGBToHex(255,255,255),math.random(0,99))
			triggerEvent("admin:logs", root, desc)
			outputServerLog(desc)
			sprawdz(plr)
			setElementData(target, "player:jail", true)
		end
		if typ=="h" then
			exports["since-db"]:query("INSERT INTO `since-jail` (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? hour,??,?)", getPlayerSerial(target), ile, cela, powod)
			exports['since-notifications']:sendNotification(plr, 'success', "Pomyślnie aresztowano gracza: "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").."\nPowód: "..powod.." Czas: "..ile.." godzin/e/y")
			exports['since-notifications']:sendNotification(target, 'info', "Zostałeś aresztowany przez funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."\nPowód: "..powod.." Czas: "..ile.." godzin/e/y")
			local desc = "[Więzienie] Gracz: "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").." został uwięziony przez Funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..". Powód uwięzienia: "..powod..", Czas: "..ile.." h"
			triggerEvent("admin:addText", resourceRoot, RGBToHex(0,0,255)..desc..RGBToHex(255,255,255),math.random(0,99))
			triggerEvent("admin:logs", root, desc)
			outputServerLog(desc)
			sprawdz(plr)
			setElementData(target, "player:jail", true)
	end
end
	sprawdz(plr)
	cela=math.random(1, #cele)
	sprawdzczas(plr)
	end
end
addCommandHandler("areszt", uwiez)

function getPlayerFromSID(sid)
	local player = false

	for _,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "player:sid") == sid then
			player = v
			break
		end
	end

	return player
end

function aresztSID(plr, cmd, sid, ile, typ, ...)
	if getElementData(plr, "player:faction")=="SAPD" then
		if not sid or not ile or not typ or not ... then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie:\n/areszt.sid <SID> <czas> <m/h> <powód>')
		end

		if not tonumber(sid) then
			return exports['since-notifications']:sendNotification(plr, 'error', 'SID musi być liczbą')
		end

		local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=? LIMIT 1", sid)

		if not result or #result < 1 then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza w bazie danych')
		end

		local reason = table.concat({...}, " ")

		if not reason or #reason < 1 then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Musisz podać powód')
		end

		if typ ~= "m" and typ ~= "h" then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie:\n/areszt.sid <SID> <czas> <m/h> <powód>')
		end

		local player = getPlayerFromSID(result[1].uid)

		if typ == "m" then
			exports["since-db"]:query("INSERT INTO `since-jail` (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? minute,??,?)", result[1].serial, ile, math.random(1, #cele), reason)
			exports['since-notifications']:sendNotification(plr, 'success', "Pomyślnie aresztowano gracza: "..result[1].nick:gsub("#%x%x%x%x%x%x","").."\nPowód: "..reason.." Czas: "..ile.." minut/e/y")
			
			local desc = "[Więzienie] Gracz: "..result[1].nick:gsub("#%x%x%x%x%x%x","").." został uwięziony przez Funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..". Powód uwięzienia: "..reason..", Czas: "..ile.." min"
			outputServerLog(desc)
			
			if player then
				exports['since-notifications']:sendNotification(player, 'info', "Zostałeś aresztowany przez funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."\nPowód: "..reason.." Czas: "..ile.." minut/e/y")
				sprawdz(player)
				setElementData(player, "player:jail", true)
			end
		elseif typ == "h" then
			exports["since-db"]:query("INSERT INTO `since-jail` (Serial,Termin,Cela,Powod) VALUES (?,NOW() + INTERVAL ?? hour,??,?)", result[1].serial, ile, math.random(1, #cele), reason)
			exports['since-notifications']:sendNotification(plr, 'success', "Pomyślnie aresztowano gracza: "..result[1].nick:gsub("#%x%x%x%x%x%x","").."\nPowód: "..reason.." Czas: "..ile.." godzin/e/y")
			
			local desc = "[Więzienie] Gracz: "..result[1].nick:gsub("#%x%x%x%x%x%x","").." został uwięziony przez Funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..". Powód uwięzienia: "..reason..", Czas: "..ile.." h"
			outputServerLog(desc)
			
			if player then
				exports['since-notifications']:sendNotification(player, 'info', "Zostałeś aresztowany przez funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."\nPowód: "..reason.." Czas: "..ile.." godzin/e/y")
				sprawdz(player)
				setElementData(player, "player:jail", true)
			end
		end
	end
end
addCommandHandler("areszt.sid", aresztSID)

function wypuscSID(plr, cmd, sid)
	if getElementData(plr, "player:faction") == "SAPD" then
		if not sid then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie:\n/wypusc.sid <SID>')
		end

		if not tonumber(sid) then
			return exports['since-notifications']:sendNotification(plr, 'error', 'SID musi być liczbą')
		end

		local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=? LIMIT 1", sid)

		if not result or #result < 1 then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza w bazie danych')
		end

		local player = getPlayerFromSID(result[1].uid)

		local x = exports["since-db"]:query("SELECT * FROM `since-jail` WHERE Serial=? and Termin > NOW()", result[1].serial)
		if not x or #x < 1 then
			return exports['since-notifications']:sendNotification(plr, 'error', 'Podany gracz nie jest w więzieniu')
		end

		exports['since-db']:query("DELETE FROM `since-jail` WHERE Serial=?", result[1].serial)
		exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie wypuszczono gracza '..result[1].nick:gsub("#%x%x%x%x%x%x",""))
		local desc = "[Więzienie] Gracz: "..result[1].nick:gsub("#%x%x%x%x%x%x","").." został wypuszczony przez Funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..""
		outputServerLog(desc)
		triggerEvent("admin:addText", resourceRoot, RGBToHex(0,0,255)..desc..RGBToHex(255,255,255),math.random(0,99))
		triggerEvent("admin:logs", root, desc)

		if player then
			exports['since-notifications']:sendNotification(player, 'success', 'Zostałeś wypuszczony z więzienia przez '..getPlayerName(plr):gsub("#%x%x%x%x%x%x",""))
			sprawdz(player)
			wypusc(player)
		end
	end
end
addCommandHandler("wypusc.sid", wypuscSID)

function unaj(plr,cmd,cel)
if getElementData(plr, "player:faction")=="SAPD" then
	if not cel then
			exports['since-notifications']:sendNotification(plr, 'error', 'Poprwane użycie:\n/wypusc <gracz/ID>')
		return
	end
	local target=exports["since-core"]:findPlayer(plr,cel)
	if not target then
		exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza')
		return
	end
	local jebnijsie=exports['since-db']:query("SELECT Termin FROM `since-jail` WHERE Serial=? and Termin > NOW()",getPlayerSerial(target))
	if jebnijsie and #jebnijsie <= 0 then outputChatBox("(ⓘ) Ten gracz nie jest w więzieniu! ("..getPlayerName(target):gsub("#%x%x%x%x%x%x","")..")", plr,255,255,255, true) return end
	exports['since-db']:query("DELETE FROM `since-jail` WHERE Serial=?", getPlayerSerial(target))
	--outputChatBox("#06B200(✔) #FFFFFFPomyślnie wypuszczono gracza: #06B200"..getPlayerName(target):gsub("#%x%x%x%x%x%x","").." #FFFFFFz więzienia.", plr, 255, 255, 255, true)
	exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie wypuszczono gracza '..getPlayerName(target):gsub("#%x%x%x%x%x%x",""))
	local desc = "[Więzienie] Gracz: "..getPlayerName(target):gsub("#%x%x%x%x%x%x","").." został wypuszczony przez Funkcjonariusza: "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..""
	triggerEvent("admin:addText", resourceRoot, RGBToHex(0,0,255)..desc..RGBToHex(255,255,255),math.random(0,99))
	triggerEvent("admin:logs", root, desc)
	outputServerLog(desc)
	sprawdz(target)
	wypusc(target)
end
end
addCommandHandler("wypusc", unaj)

setTimer(function()
	for _,p in pairs(getElementsByType("player")) do
		sprawdz(p)
	end
end,10000,0)

function spawn()
local x=exports['since-db']:query("SELECT Termin FROM `since-jail` WHERE Serial=? and Termin > NOW()", getPlayerSerial(source))
if x and #x <= 0 then return end
sprawdzczas(source)
end
addEventHandler("onPlayerSpawn", getRootElement(), spawn)
