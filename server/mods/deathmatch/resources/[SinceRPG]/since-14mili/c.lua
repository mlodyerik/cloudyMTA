local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local cuboids = {

    startCuboid = createColCuboid(1456.73, -2710.30, 12.56, 5.90, 13.84, 4.89),
    endCuboid = createColCuboid(1600.98, -2710.30, 12.56, 5.58, 13.68, 6.39),
    safeCuboid = createColCuboid(1450.84, -2711.56, 12.56, 160.86, 17.00, 6.89),

}

local data = {

    time = nil,
    information = {1454.77, -2703.66, 15.05},

}

function create3DText()
    local x, y, z = unpack(data.information)
    local text = createElement("text")
    setElementPosition(text, x, y, z)
    setElementData(text, "name", "Tor 1/4 mili\n#7dff7dWykręć jak najlepszy czas!")

    local blip = createBlip(x, y, z, 53, 2, 255, 255, 255, 255, 0, 500)
end
addEventHandler("onClientResourceStart", resourceRoot, create3DText)

function convertTimer(miliseconds)
    local seconds = math.floor(miliseconds / 1000)
    local miliseconds = math.floor(miliseconds % 1000) / 10

    return string.format("%02d:%02d", seconds, miliseconds)
end

function drawTimer()
    if not data.time then
        return
    end

    local time = getTickCount() - data.time
    local time = convertTimer(time)

    dxDrawText("Czas: " .. time, sx / 2 + 1, sy - 100/zoom + 1, nil, nil, tocolor(0, 0, 0, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "center", "center", false, false, false, false, false)
    dxDrawText("Czas: #7dff7d" .. time, sx / 2, sy - 100/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom), "center", "center", false, false, false, true, false)
end

function startCounting(element,md)
    if not md or element ~= localPlayer or getElementType(element) ~= "player" then
        return
    end

    local vehicle = getPedOccupiedVehicle(element)

    if not vehicle then
        return
    end

    if not getElementData(vehicle, "vehicle:id") then
        return
    end

    if getVehicleOccupant(vehicle) ~= localPlayer then
        return
    end

    if data.time ~= nil then
        return
    end

    data.time = getTickCount()
    setElementVelocity(vehicle, 0, 0, 0)

    addEventHandler("onClientRender", root, drawTimer)
end
addEventHandler("onClientColShapeHit", cuboids.startCuboid, startCounting)

function exitSafeCuboid(element,md)
    if not md or element ~= localPlayer or getElementType(element) ~= "player" then
        return
    end

    local vehicle = getPedOccupiedVehicle(element)

    if not vehicle then
        return
    end

    if not data.time then
        return
    end

    data.time = nil
    removeEventHandler("onClientRender", root, drawTimer)
end
addEventHandler("onClientColShapeLeave", cuboids.safeCuboid, exitSafeCuboid)

function endCounting(element,md)
    if not md or element ~= localPlayer or getElementType(element) ~= "player" then
        return
    end

    local vehicle = getPedOccupiedVehicle(element)

    if not vehicle then
        return
    end

    if not data.time then
        return
    end

    local time = getTickCount() - data.time
    
    setElementVelocity(vehicle, 0, 0, 0)

    triggerServerEvent("sentRecord:1/4", resourceRoot, time, vehicle)
    
    data.time = nil
    removeEventHandler("onClientRender", root, drawTimer)
end
addEventHandler("onClientColShapeHit", cuboids.endCuboid, endCounting)
