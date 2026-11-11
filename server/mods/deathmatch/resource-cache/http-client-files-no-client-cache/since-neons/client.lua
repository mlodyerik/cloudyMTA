local vehicles = {}
local toggled = true

-- Funkcja sprawdzająca, czy pojazd ma neony
function findNeon(veh)
    for i = 1, #vehicles do
        if vehicles[i].vehicle == veh then
            return true
        end
    end
    return false
end

-- Dodawanie pojazdu z neonami
function addNeonVehicle(source)
    if getElementData(source, "vehicle:upgrades")['neon'] and not findNeon(source) and toggled then
        local vehData = getElementData(source, 'vehicle:upgrades') or {}
        vehicles[#vehicles + 1] = {
            vehicle = source,
            neonRGB = vehData['neonrgb'],
        }

        if #vehicles == 1 then
            addEventHandler("onClientPreRender", root, renderNeons)
        end
    end
end

-- Usuwanie pojazdu z neonami
function removeNeonVehicle(source)
    for i = 1, #vehicles do
        local v = vehicles[i]
        if v and source == v.vehicle then
            table.remove(vehicles, i)
            break
        end
    end

    if #vehicles == 0 then
        removeEventHandler("onClientPreRender", root, renderNeons)
    end
end

-- Dodawanie neonów podczas streamowania pojazdów
addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == 'vehicle' and getElementData(source, "vehicle:id") and not findNeon(source) and toggled then
        addNeonVehicle(source)
    end
end)

-- Usuwanie neonów podczas streamowania pojazdów
addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == 'vehicle' then
        removeNeonVehicle(source)
    end
end)

-- Wstępne dodawanie neonów do pojazdów
setTimer(function()
    for i, v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "vehicle:id") and not findNeon(v) and isElementStreamedIn(v) and toggled then
            addNeonVehicle(v)
        end
    end
end, 1000, 1)

-- Cache'owane tekstury neonów
local textures = {

    [1] = dxCreateTexture("neons/default.png"),
    [2] = dxCreateTexture("neons/hyperbeast.png"),
    [3] = dxCreateTexture("neons/quein.png"), -- wygrana z eventu | Nick: QuEiN UID: 4715
    [4] = dxCreateTexture("neons/dawidpers.png"), -- wygrana z eventu | Nick: dawidpers UID: 934

}

-- Zwalnianie zasobów po zakończeniu zasobu
addEventHandler("onResourceStop", resourceRoot, function()
    for i, v in ipairs(textures) do
        if isElement(textures[i]) then
            destroyElement(textures[i])
        end
    end
end)

local frequency = 3

-- Generowanie wartości RGB z sinusoidy
function getRGBFromSin(curtime)
    local base_value = curtime * frequency

    local sin_r = math.sin(base_value)
    local sin_g = math.sin(base_value + 2)
    local sin_b = math.sin(base_value + 4)

    local r = math.floor(sin_r * 127 + 128)
    local g = math.floor(sin_g * 127 + 128)
    local b = math.floor(sin_b * 127 + 128)

    return r, g, b
end

addEventHandler('onClientElementDataChange', root, function(dataName, oldValue, newValue)
    if dataName == 'vehicle:upgrades' then
        for i, v in ipairs(vehicles) do
            if v.vehicle == source then
                local vehData = getElementData(source, 'vehicle:upgrades') or {}
                
                if oldValue['neon'] ~= newValue['neon'] then
                    if newValue['neon'] and not findNeon(source) and isElementStreamedIn(source) and toggled then
                        addNeonVehicle(source)
                    elseif not newValue['neon'] then
                        removeNeonVehicle(source)
                    end
                end

                if oldValue['neonrgb'] ~= newValue['neonrgb'] then
                    v.neonRGB = newValue['neonrgb']
                end
            else
                if newValue['neon'] and not findNeon(source) and isElementStreamedIn(source) and toggled then
                    addNeonVehicle(source)
                end
            end
        end
    end
end)

-- Renderowanie neonów
function renderNeons()
    if #vehicles == 0 or not toggled then
        return
    end

    local rootx, rooty, rootz = getCameraMatrix()
    local curtime = getTickCount() / 1000
    local cr, cg, cb = getRGBFromSin(curtime)

    for i = 1, #vehicles do
        local v = vehicles[i]
        if isElement(v.vehicle) and isElementStreamedIn(v.vehicle) and isVehicleOnGround(v.vehicle) and isElementOnScreen(v.vehicle) then
            local x, y, z = getElementPosition(v.vehicle)
            local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)

            -- Warunki widoczności i odległości
            if distance <= 20 and isLineOfSightClear(rootx, rooty, rootz, x, y, z, true, false, false) then
                local vehicleFront = v.vehicle.matrix.forward * 3.1
                local x1, y1, z1 = x + vehicleFront.x, y + vehicleFront.y, z + vehicleFront.z
                local x2, y2, z2 = x - vehicleFront.x, y - vehicleFront.y, z - vehicleFront.z

                local r, g, b
                if v.neonRGB then
                    r, g, b = cr, cg, cb
                else
                    r, g, b = getVehicleHeadLightColor(v.vehicle)
                end

                -- Rysowanie neonu tylko jeśli pozycje są prawidłowe
                local g1 = getGroundPosition(x1, y1, z1)
                local g2 = getGroundPosition(x2, y2, z2)

                if g1 and g2 then
                    local upgrades = getElementData(v.vehicle, 'vehicle:upgrades') or {}
                    dxDrawMaterialLine3D(x1, y1, g1 + 0.05, x2, y2, g2 + 0.05, upgrades['neonType'] and textures[upgrades['neonType']] or textures[1], 3.5, upgrades['neonType'] and tocolor(255, 255, 255, 100) or tocolor(r, g, b, 100), 'postfx', x1 + 0.01, y1 + 0.01, g1 - 1.5)
                end
            end
        end
    end
end

-- Funkcja do sprawdzania, czy event handler jest dodany
function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

-- Funkcja do włączania/wyłączania neonów
function toggleNeons(toggle)
    if toggle and not isEventHandlerAdded("onClientPreRender", root, renderNeons) then
        addEventHandler("onClientPreRender", root, renderNeons)
    elseif not toggle then
        vehicles = {}
        removeEventHandler("onClientPreRender", root, renderNeons)
    end

    toggled = toggle
end
