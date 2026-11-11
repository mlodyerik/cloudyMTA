  

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

function globalMessage(plr, cmd, ...)
	local frakcja = getElementData(plr, 'player:faction')

	if not frakcja then
		return
	end


	local msg = table.concat ( { ... }, " " )
	for i,v in pairs(getElementsByType("player")) do
		local pfrakcje=getElementData(v,'player:faction')
		if frakcja == getElementData(v, "player:faction") then
			if frakcja == "SAFD" then
				outputChatBox("#cc400e"..getElementData(plr,"player:faction").."#ffffff> "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#FFFFFF: "..msg:gsub("#%x%x%x%x%x%x",""), v, 255, 64, 74, true)
			elseif frakcja == "SAPD" then
				outputChatBox("#0000CD"..getElementData(plr,"player:faction").."#ffffff> "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#FFFFFF: "..msg:gsub("#%x%x%x%x%x%x",""), v, 255, 64, 74, true)
			elseif frakcja == "SAMD" then
				outputChatBox("#00cccc"..getElementData(plr,"player:faction").."#ffffff> "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#FFFFFF: "..msg:gsub("#%x%x%x%x%x%x",""), v, 255, 64, 74, true)
			elseif frakcja == "SARA" then
				outputChatBox("#543E32"..getElementData(plr,"player:faction").."#ffffff> "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#FFFFFF: "..msg:gsub("#%x%x%x%x%x%x",""), v, 255, 64, 74, true)
			elseif frakcja == "TSA" then
				outputChatBox("#ffea00"..getElementData(plr,"player:faction").."#ffffff> "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."#FFFFFF: "..msg:gsub("#%x%x%x%x%x%x",""), v, 255, 64, 74, true)
			end
		end
	end

	--local log = "**"..frakcja..">** "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."["..getElementData(plr, "player:sid").."]: "..msg
		--local desc = string.format"(Krótkofalówka) ("..getElementData(plr,"id")..") "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."("..getElementData(plr,"player:faction").."): "..msg:gsub("#%x%x%x%x%x%x","")..""
		--triggerEvent("admin:addText", resourceRoot, desc:gsub("#%x%x%x%x%x%x",""))
	        --triggerEvent("admin:addText", resourceRoot, RGBToHex(0,0,255)..desc..RGBToHex(255,255,255),math.random(0,99))
		--outputServerLog(desc)
end
addCommandHandler("Krótkofalówka", globalMessage)


function globalMessage(plr, cmd, ...)
	local frakcja=getElementData(plr,'player:faction')
	if not frakcja then
		return
	end
	local msg = table.concat ( { ... }, " " )
	for i,v in pairs(getElementsByType("player")) do
		if getElementData(v, "player:faction") and getElementData(v, "player:faction") ~= false and getElementData(v, "player:faction") ~= "TSA" then
			if frakcja == "SAFD" then
				outputChatBox("#ffffffSłużby> [#cc400e"..getElementData(plr,"player:faction").."#ffffff] "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..msg:gsub("#%x%x%x%x%x%x",""), v, 0, 0, 255, true)
			elseif frakcja == "SAPD" then
				outputChatBox("#ffffffSłużby> [#0000CD"..getElementData(plr,"player:faction").."#ffffff] "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..msg:gsub("#%x%x%x%x%x%x",""), v, 0, 0, 255, true)
			elseif frakcja == "SAMD" then
				outputChatBox("#ffffffSłużby> [#00cccc"..getElementData(plr,"player:faction").."#ffffff] "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..msg:gsub("#%x%x%x%x%x%x",""), v, 0, 0, 255, true)
			elseif frakcja == "SARA" then
				outputChatBox("#ffffffSłużby> [#543E32"..getElementData(plr,"player:faction").."#ffffff] "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..msg:gsub("#%x%x%x%x%x%x",""), v, 0, 0, 255, true)
			end
		end
	end

	--local log = "**SŁUŻBY> ["..frakcja.."] **"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."["..getElementData(plr, "player:sid").."]: "..msg:gsub("#%x%x%x%x%x%x","")
	--exports["enonek-discord"]:sendDiscordMessage("https://discord.com/api/webhooks/924354821543305217/hClZjJIL9exMCF-GAONgDy6Qzx72UmOge2fVXZl86J5d_hX-80QX_iSIIl5SVmaohhci", "SinceRPG - logi", log)
		--local desc = string.format"(Służby) ("..getElementData(plr,"id")..") "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","")..": "..msg:gsub("#%x%x%x%x%x%x","")..""
		--triggerEvent("admin:addText", resourceRoot, desc:gsub("#%x%x%x%x%x%x",""))
	        --triggerEvent("admin:addText", resourceRoot, RGBToHex(0,0,255)..desc..RGBToHex(255,255,255),math.random(0,99))
		--outputServerLog(desc)
end
addCommandHandler("Służby", globalMessage)

addEventHandler("onResourceStart", root, function() 
local players=getElementsByType('player')
for _, p in pairs(players) do
bindKey(p, "y", "down", "chatbox", "Krótkofalówka")
bindKey(p, "u", "down", "chatbox", "Służby")
end
end)

addEventHandler( "onPlayerSpawn", getRootElement(),
    function (_)
	bindKey(source, "y", "down", "chatbox", "Krótkofalówka")
	bindKey(source, "u", "down", "chatbox", "Służby")
    end
)






