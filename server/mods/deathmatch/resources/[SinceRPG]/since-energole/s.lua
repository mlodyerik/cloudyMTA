  

local energy = {}

addEvent("energetyk.s", true)
addEventHandler("energetyk.s", root, function(...)
    if (not arg) then
        return
    end
    local plr = client
    if arg[1] == "end" then
        setElementData(plr, "player:energydrink", nil)
        triggerClientEvent(plr, "energetyk.c", plr, "doubleCheck")
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for i,v in ipairs(getElementsByType("player")) do
        if getElementData(v, "player:energydrink") then
            setElementData(v, "player:energydrink", nil)
        end
    end
end)