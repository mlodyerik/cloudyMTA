addCommandHandler( "commands", 
   function(player)
    if not getElementData(player, 'player:admin') then
        return
    end

    if getElementData(player, 'player:admin') ~= 4 then
        return
    end
    
      local commandsList = {} --table to store commands
		
      --store/sort commands in the table where key is resource and value is table with commands
      for _, subtable in pairs( getCommandHandlers() ) do
	 local commandName = subtable[1]
	 local theResource = subtable[2]
			
         if not commandsList[theResource] then
	    commandsList[theResource] = {}
	 end
			
	 table.insert( commandsList[theResource], commandName )
      end
		
      --create file to store commands
    if not fileExists("commands.txt") then
        fileCreate("commands.txt")
    end

    local file = fileOpen("commands.txt")
      
      --write sorted information to the file
      for theResource, commands in pairs( commandsList ) do
	  local resourceName = getResourceInfo( theResource, "name" ) or getResourceName( theResource ) --try to get full name, if no full name - use short name
	  fileWrite( file, resourceName.."\n" ) --write resource name
			
	  --write list of commands
	  for _, command in pairs( commands ) do
	     fileWrite( file, "  "..command.."\n" )
	  end
      end
      
      --close the file
        fileClose( file )
      
      outputChatBox("Commands file created.", player, 0, 255, 0)
  end
)