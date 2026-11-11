--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

addEvent("enonek-firehose:synchronize", true)
addEventHandler("enonek-firehose:synchronize", resourceRoot, function(owner, x, y, z)
    triggerClientEvent(root, "enonek-firehose:client", resourceRoot, owner, x, y, z)
end)

addEvent("enonek-firehose:synchronize:linia", true)
addEventHandler("enonek-firehose:synchronize:linia", resourceRoot, function(owner)
    triggerClientEvent(root, "enonek-firehose:synchronizeclient:linia", resourceRoot, owner)
end)

addEvent("enonek-firehose:synchronize:water", true)
addEventHandler("enonek-firehose:synchronize:water", resourceRoot, function(owner, state)
    triggerClientEvent(root, "enonek-firehose:synchronizeclient:water", resourceRoot, owner, state)
end)