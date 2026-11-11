  

function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	attachElements(client, vehicle, x, y, z, rotX, rotY, rotZ)
	setPedWeaponSlot(client, slot)
    setElementData(client, "user:glue", true)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer",resourceRoot,gluePlayer)

function ungluePlayer()
	detachElements(client)
    removeElementData(client, "user:glue")
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer",resourceRoot,ungluePlayer)