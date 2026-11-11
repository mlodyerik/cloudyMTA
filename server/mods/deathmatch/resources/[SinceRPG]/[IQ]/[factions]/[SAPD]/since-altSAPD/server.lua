--[[
    Author: EnoNeK
    For: cloudyMTA
]]

addEvent("enonek-altSAPD:pullup", true)
addEventHandler("enonek-altSAPD:pullup", resourceRoot, function(vehicle, speed)
    if not getElementData(client, 'player:faction') then return end
    
    if getVehicleOccupant(vehicle) then
        local plr = getVehicleOccupant(vehicle)
        outputChatBox("#fffb00* #ffffffFunkcjonariusz #0000cd"..getPlayerName(client):gsub("#%x%x%x%x%x%x", "").." #ffffffnakazał Ci się zatrzymać! #fffb00*", plr, 255, 255, 255, true)
        outputChatBox("#fffb00* #ffffffNakazałeś zatrzymać się graczowi #a9a9a9"..getPlayerName(plr):gsub("#%x%x%x%x%x%x", "").." #fffb00*", client, 255, 255, 255, true)
        outputChatBox("#fffb00* #ffffffZanotowana prędkość to #ff0000"..math.floor(speed).." #ffffffkm/h", plr, 255, 255, 255, true)
        outputChatBox("#fffb00* #ffffffZanotowana prędkość to #ff0000"..math.floor(speed).." #ffffffkm/h", client, 255, 255, 255, true)
    end 
end)