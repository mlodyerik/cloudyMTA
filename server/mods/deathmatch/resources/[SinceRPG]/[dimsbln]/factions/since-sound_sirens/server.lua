
--[[
    Author: EnoNeK
    For: SinceRPG
]]

local sounds, sounds_pog = {}, {}

addEvent("enonek-sound_sirens:toggle", true)
addEventHandler("enonek-sound_sirens:toggle", resourceRoot, function(vehicle, path, range, type, pogstate)
    if (type == "pog") then
        if (pogstate) then
            if (not sounds_pog[vehicle]) then
                if getPedOccupiedVehicle(client) ~= vehicle then
                    return
                end
                triggerClientEvent(root, "enonek-sound_sirens:sound", resourceRoot, vehicle, path, range, true, type)
                sounds_pog[vehicle] = true
            end
        else
            if (sounds_pog[vehicle]) then
                triggerClientEvent(root, "enonek-sound_sirens:sound", resourceRoot, vehicle, path, range, false, type)
                sounds_pog[vehicle] = nil
            end
        end
    else
        if (sounds[vehicle]) then
            triggerClientEvent(root, "enonek-sound_sirens:sound", resourceRoot, vehicle, path, range, false)
            sounds[vehicle] = nil
        else
            if getPedOccupiedVehicle(client) ~= vehicle then
                return
            end
            triggerClientEvent(root, "enonek-sound_sirens:sound", resourceRoot, vehicle, path, range, true)
            sounds[vehicle] = true
        end
    end
end)