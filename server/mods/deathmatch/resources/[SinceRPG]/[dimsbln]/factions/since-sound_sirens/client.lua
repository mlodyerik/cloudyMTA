

--[[
    Author: EnoNeK
    For: cloudyMTA
]]

--[[if (getElementData(localPlayer, "player:sid") == 25) then

else
    return false
end]]

local settings = {
    ["SAFD"] = {
        [407] = {
            ["1"] = {"assets/SAFD/GBA1.mp3", 400},
            ["2"] = {"assets/SAFD/GBA2.mp3", 400},
            ["3"] = {"assets/SAFD/GBA3.mp3", 400},
            ["lalt"] = {"assets/SAFD/pog1.mp3", 400},
        },
        [426] = {
            ["1"] = {"assets/SAFD/SLOP1.mp3", 400},
            ["2"] = {"assets/SAFD/SLOP2.mp3", 400},
            ["lalt"] = {"assets/SAFD/pog2.mp3", 400},
        },
        [490] = {
            ["1"] = {"assets/SAFD/SLOP1.mp3", 400},
            ["2"] = {"assets/SAFD/SLOP2.mp3", 400},
            ["lalt"] = {"assets/SAFD/pog2.mp3", 400},
        },
        [579] = {
            ["1"] = {"assets/SAFD/SLOP1.mp3", 400},
            ["2"] = {"assets/SAFD/SLOP2.mp3", 400},
            ["lalt"] = {"assets/SAFD/pog2.mp3", 400},
        },
        [560] = {
            ["1"] = {"assets/SAFD/SLOP1.mp3", 400},
            ["2"] = {"assets/SAFD/SLOP2.mp3", 400},
            ["lalt"] = {"assets/SAFD/pog2.mp3", 400},
        },
        [416] = {
            ["1"] = {"assets/SAMD/SAMD1.mp3", 400},
            ["2"] = {"assets/SAMD/SAMD2.mp3", 400},
            ["3"] = {"assets/SAMD/SAMD3.mp3", 400},
            ["lalt"] = {"assets/SAMD/Poganiacz.mp3", 400},
        },
        [544] = {
            ["1"] = {"assets/SAMD/SAMD1.mp3", 400},
            ["2"] = {"assets/SAMD/SAMD2.mp3", 400},
            ["3"] = {"assets/SAMD/SAMD3.mp3", 400},
            ["lalt"] = {"assets/SAMD/Poganiacz.mp3", 400},
        },
        [482] = {
            ["1"] = {"assets/SAMD/SAMD1.mp3", 400},
            ["2"] = {"assets/SAMD/SAMD2.mp3", 400},
            ["3"] = {"assets/SAMD/SAMD3.mp3", 400},
            ["lalt"] = {"assets/SAMD/Poganiacz.mp3", 400},
        },
    },

    ["SAPD"] = {
        [597] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [596] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [599] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [541] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [560] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [598] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [579] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [490] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [415] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [411] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [480] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [429] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [427] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [562] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
        [405] = {
            ["1"] = {"assets/SAPD/SAPD1.mp3", 400},
            ["2"] = {"assets/SAPD/SAPD2.mp3", 400},
            ["3"] = {"assets/SAPD/SAPD3.mp3", 400},
            ["lctrl"] = {"assets/SAPD/Poganiacz.mp3", 400},
        },
    },
}

function toggle(key, keyState)
    local v = settings[VEH_FACTION][VEH_MODEL][key]
    if (key ~= "lalt" and key ~= "lctrl") then
        if (keyState == "down") then
            if (tick and getTickCount() - tick < 500) then
                return false
            end
            triggerServerEvent("enonek-sound_sirens:toggle", resourceRoot, VEH, v[1], v[2])
            tick = getTickCount()
        end
    else
        if (keyState == "down") then
            if (key == "lctrl" and getKeyState("lalt")) then
                return false
            end
            pogd = true
        elseif (keyState == "up") then
            if (not pogd) then
                return false
            end
            pogd = nil
        end
        triggerServerEvent("enonek-sound_sirens:toggle", resourceRoot, VEH, v[1], v[2], "pog", pogd)
    end
end

addEventHandler("onClientVehicleEnter", root, function(ped, seat)
    if (ped == localPlayer and seat == 0) then
        VEH_FACTION = getElementData(source, "vehicle:faction") or false
        if (not VEH_FACTION) then
            VEH_FACTION = getElementData(source, "vehicle:police") and "SAPD" or false
        end

        if (VEH_FACTION and settings[VEH_FACTION]) then
            VEH_MODEL = getElementModel(source)
            if (settings[VEH_FACTION][VEH_MODEL]) then
                VEH = source
                for i,v in pairs(settings[VEH_FACTION][VEH_MODEL]) do
                    bindKey(i, "both", toggle)
                end
            end
        end
    end
end)

addEventHandler("onClientVehicleExit", root, function(ped, seat)
    if (ped == localPlayer and seat == 0) then
        VEH_FACTION = getElementData(source, "vehicle:faction") or false
        if (not VEH_FACTION) then
            VEH_FACTION = getElementData(source, "vehicle:police") and "SAPD" or false
        end

        if (VEH_FACTION and settings[VEH_FACTION]) then
            local VEH_MODEL = getElementModel(source)
            if (settings[VEH_FACTION][VEH_MODEL]) then
                for i,v in pairs(settings[VEH_FACTION][VEH_MODEL]) do
                    unbindKey(i, "both", toggle)
                end
                VEH_FACTION, VEH_MODEL, VEH = nil, nil, nil
            end
        end
    end
end)

local sounds, sounds_pog = {}, {}

addEvent("enonek-sound_sirens:sound", true)
addEventHandler("enonek-sound_sirens:sound", resourceRoot, function(vehicle, path, range, state, type)
    if (type == "pog") then
        if (state) then
            local sound = playSound3D(path, 0, 0, 0, true)
            setSoundMaxDistance(sound, range)
            attachElements(sound, vehicle)
            sounds_pog[vehicle] = sound
        else
            if (sounds_pog[vehicle]) then
                destroyElement(sounds_pog[vehicle])
            end
            sounds_pog[vehicle] = nil
        end
    else
        if (state) then
            local sound = playSound3D(path, 0, 0, 0, true)
            setSoundMaxDistance(sound, range)
            attachElements(sound, vehicle)
            sounds[vehicle] = sound
        else
            if (sounds[vehicle]) then
                destroyElement(sounds[vehicle])
            end
            sounds[vehicle] = nil
        end
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if (getElementType(source) == "vehicle") then
        if (sounds[source]) then
            destroyElement(sounds[source])
        end
        if (sounds_pog[source]) then
            destroyElement(sounds_pog[source])
        end
        sounds[source] = nil
        sounds_pog[source] = nil
    end
end)
getResourceName(getThisResource(), true, 732091780); if true then return end