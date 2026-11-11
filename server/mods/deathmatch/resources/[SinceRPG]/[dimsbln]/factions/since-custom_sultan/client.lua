  

--[[
    Author: EnoNeK
    For: SinceRPG
]]
getResourceName(getThisResource(), true, 948241732);-- if true then return end

if (getPlayerSerial(localPlayer) ~= "78DEDA95B4493235A7A6308AF200DC03") then
    return false
end

local key = "tZFqJFbz7UvbdYjVPDPTVz" -- FROM enonek-kodowanie_aut

local function decode(path)
    local file = fileOpen(path)
    if (file) then
        local data = fileRead(file, fileGetSize(file))
        fileClose(file)
        local data = teaDecode(data, key)
        local txt = string.gsub(path, "assets/", "")
        outputConsole("* Zdekodowano pojazd "..txt)
        return data
    end
    return false
end

local function onStart()
    for i,v in ipairs(getElementsByType("vehicle")) do
        if (getElementData(v, "vehicle:custom_model")) then
            local r, g, b, r2, g2, b2 = getVehicleColor(v)
            local handling = getVehicleHandling(v)

            local request = engineRequestModel("vehicle", getElementModel(v))
            local name = getElementData(v, "vehicle:custom_model")
            local dff = decode("assets/"..name..".dffe")
            local txd = decode("assets/"..name..".txde")
            engineImportTXD(engineLoadTXD(txd), request)
            engineReplaceModel(engineLoadDFF(dff), request)
            setElementModel(v, request)
            setVehicleColor(v, r, g, b, r2, g2, b2)
            triggerServerEvent("enonek-custom_sultan:setHandling", resourceRoot, v, handling)

            setVehicleSirens(v, 1, 0.302, 2.320, -0.012, 0, 96, 255, 255, 255)
            setVehicleSirens(v, 2, -0.395, 2.320, 0.000, 255, 0, 0, 255, 255)
            setVehicleSirens(v, 3, -0.775, -2.700, 0.031, 255, 0, 0, 255, 255)
            setVehicleSirens(v, 4, 0.768, -2.700, 0.031, 255, 0, 0, 255, 255)
            setVehicleSirens(v, 5, 0.522, -0.405, 0.900, 0, 96, 255, 255, 255)
            setVehicleSirens(v, 6, -0.479, -0.424, 0.900, 255, 0, 0, 255, 255)
        end
    end
end
onStart()
