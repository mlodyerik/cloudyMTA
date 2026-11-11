function cmd_admins(plr)
	local owners = {}
	local rconi = {}
	local admin = {}
	local supports = {}

	for i,v in ipairs(getElementsByType("player")) do
    local adminer = getElementData(v,"player:id")

	if (getElementData(v,"player:admin") == 4) and not getElementData(v, 'player:vanish') then
		local t = {}
		local login=getElementData(v,"player:admin")

		if (login) then
			t="#c9c9c9("..getElementData(v,"id")..")#ffffff "..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
			table.insert(owners,t)
		end
	end

	  if (getElementData(v,"player:admin") == 3) and not getElementData(v, 'player:vanish') then
		local t
		local login=getElementData(v,"player:admin")

		if (login) then
			t="#c9c9c9("..getElementData(v,"id")..")#ffffff "..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
			table.insert(rconi,t)
		end
	end

	if (getElementData(v,"player:admin") == 2) and not getElementData(v, 'player:vanish') then
	    local t
		local login=getElementData(v,"player:admin")

		if (login) then
			t="#c9c9c9("..getElementData(v,"id")..")#ffffff "..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
			table.insert(admin,t)
		end
	end

	if (getElementData(v,"player:admin") == 1) and not getElementData(v, 'player:vanish') then
		local t
		local login=getElementData(v,"player:admin")

		    if (login) then
				t="#c9c9c9("..getElementData(v,"id")..")#ffffff "..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
				table.insert(supports,t)
		    end
		end
    end
  outputChatBox(" ", 136, 0, 0, true)
  outputChatBox(" ", 136, 0, 0, true)

	outputChatBox("Ownerzy:", 255, 175, 0, true)
	if (#owners>0) then
	  outputChatBox("- " .. table.concat(owners,", "), 255, 255, 255, true)
	else
	  outputChatBox("#c9c9c9- Offline", 255, 255, 255, true)
	end

	outputChatBox("Administrator RCON:", 155, 0, 0)
	if (#rconi>0) then
	  outputChatBox("- " .. table.concat(rconi,", "), 255, 255, 255, true)
	else
	  outputChatBox("#c9c9c9- Offline", 255, 255, 255, true)
	end

	outputChatBox("Administrator:", 255, 0, 0)
	if (#admin>0) then
	  outputChatBox("- " .. table.concat(admin,", "), 255, 255, 255, true)
	else
	  outputChatBox("#c9c9c9- Offline", 255, 255, 255, true)
	end

	outputChatBox("Moderator:", 66, 206, 245)
	if (#supports>0) then
	  outputChatBox("- " .. table.concat(supports,", "), 255, 255, 255, true)
	else
	  outputChatBox("#c9c9c9- Offline", 255, 255, 255, true)
	end
  outputChatBox(" ", 136, 0, 0, true)
  outputChatBox("- Łączna ilość administracji online: #ffe600"..(#owners+#rconi+#admin+#supports), 245, 245, 245, true)
  outputChatBox(" ", 136, 0, 0, true)

end
addCommandHandler("admins", cmd_admins, false, false)
addCommandHandler("ekipa", cmd_admins, false, false)
addCommandHandler("admini", cmd_admins, false, false)
getResourceName(getThisResource(), true, 833305078); if true then return end