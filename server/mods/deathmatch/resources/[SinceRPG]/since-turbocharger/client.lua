local data = {

    vehicleTank = 0,
    vehicleCount = 0

}

local tick = getTickCount()
local timeout = 2000

-- Funkcja do kalkulacji czasu tankowania
function calculateTankTime(vehicle)
    if not vehicle then 
        return "N/D" -- Brak pojazdu, brak kalkulacji
    end

    local fuelData = getElementData(vehicle, 'vehicle:fuel') or {}
    if not data.vehicleTank or not data.vehicleCount then
        return "N/D" -- Brak danych o paliwie, brak kalkulacji
    end

    local tankSpeed = 0.025 * data.vehicleTank / 150 -- Stała prędkość tankowania

    -- Oblicz pozostałą ilość do zatankowania
    local fuelNeeded = data.vehicleTank - data.vehicleCount

    -- Jeśli zbiornik jest pełny, nie trzeba tankować
    if fuelNeeded <= 0 then
        return "Bateria naładowana"
    end

    -- Oblicz czas potrzebny do pełnego tankowania (w sekundach)
    local timeToFull = fuelNeeded / tankSpeed

    -- Zamień czas na minuty i sekundy
    local minutes = math.floor(timeToFull / 60)
    local seconds = math.floor(timeToFull % 60)

    -- Zwróć sformatowany czas
    return string.format("%02d.%02d", minutes, seconds)..' sek.'
end

function checkIfCan(vehicle)
    if not vehicle then 
        return false
    end

    local fuelData = getElementData(vehicle, 'vehicle:fuel') or {}

    if not data.vehicleTank or not data.vehicleCount then
        return 'Bateria naładowana'
    end

    -- if engine is on 
    if getVehicleEngineState(vehicle) then
        return 'Wyłącz silnik'
    end

    -- if handbrake is on
    if not isElementFrozen(vehicle) then
        return 'Zaciągnij hamulec ręczny'
    end

    return true
end


-- Funkcja do rysowania interfejsu użytkownika
function renderUI()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then 
        return 
    end
    
    dxDrawImage(sx/2 - 165/zoom, sy - 299/zoom, 330/zoom, 195/zoom, 'data/background.png')

    local canDoThis = checkIfCan(vehicle)

    if canDoThis ~= true then
        dxDrawText('Nie możesz ładować pojazdu!', sx/2, sy - 210/zoom, nil, nil, tocolor(255, 155, 155, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'bottom', false, false, false, true)
        dxDrawText(canDoThis, sx/2, sy - 210/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 11/zoom), 'center', 'top', false, false, false, true)
        return
    end

    -- Rysowanie tła UI
    dxDrawText('Ładowanie pojazdu', sx/2, sy - 260/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'bottom')
    
    -- Obliczanie czasu tankowania
    local tankTime = calculateTankTime(vehicle)
    
    -- Wyświetlanie szacowanego czasu tankowania
    if tankTime == 'Bateria naładowana' then
        dxDrawText('Bateria jest naładowana', sx/2, sy - 260/zoom, nil, nil, tocolor(125, 255, 125, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'center', 'top', false, false, false, true)
    else
        dxDrawText('Szacowany czas oczekiwania: #7dff7d'..tankTime, sx/2, sy - 260/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'center', 'top', false, false, false, true)
    end

    local percent = math.floor((getElementData(vehicle, 'vehicle:fuel').count / getElementData(vehicle, 'vehicle:fuel').tank) * 100)
    dxDrawText('Aktualny stan naładowania baterii\n#7dff7d'..percent..'%', sx/2, sy - 115/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Regular', 10/zoom), 'center', 'bottom', false, false, false, true)
    
    -- Pobieranie danych o paliwie
    local fuelData = getElementData(vehicle, 'vehicle:fuel') or {}
    local tankSpeed = 0.025 * data.vehicleTank / 150

    -- Zwiększanie poziomu paliwa w czasie rzeczywistym
    data.vehicleCount = math.min(data.vehicleCount + tankSpeed, data.vehicleTank)
    fuelData.count = data.vehicleCount

    if getTickCount() - tick > timeout then
        tick = getTickCount()
        triggerServerEvent('setBatteryVariable', resourceRoot, fuelData)
    end
    
    -- Rysowanie baterii i wypełnienia
    local imageHeight = 71 / zoom
    local fuelHeight = imageHeight * (data.vehicleCount / data.vehicleTank)

    local imageWidth = 53 / zoom

    -- Rysowanie pełnego obrazu baterii
    dxDrawImage(
        sx/2 - 26/zoom,            -- x
        sy - 234/zoom,             -- y
        imageWidth,                -- szerokość
        imageHeight,               -- wysokość
        'data/battery.png',        -- ścieżka do pełnej tekstury baterii
        0,                         -- rotacja
        0,                         -- punkty obrotu
        0,                         -- punkty obrotu
        tocolor(255, 255, 255, 100) -- biały kolor (bez przezroczystości)
    )

    -- Rysowanie wypełnienia baterii od dołu do góry
    dxDrawImageSection(
        sx/2 - 26/zoom,                       -- x
        sy - 234/zoom + imageHeight - fuelHeight, -- y (przesunięcie od dołu w górę)
        imageWidth,                           -- szerokość
        fuelHeight,                           -- wysokość (sekcja od dołu)
        0,                                    -- x sekcji obrazu
        71 - fuelHeight,                      -- y sekcji obrazu (od dolnej krawędzi obrazu)
        53,                                   -- szerokość sekcji obrazu
        fuelHeight,                           -- wysokość sekcji obrazu
        'data/battery.png',                   -- ścieżka do obrazu
        0,                                    -- rotacja
        0,                                    -- punkty obrotu
        0,                                    -- punkty obrotu
        tocolor(125, 255, 125, 255)           -- kolor wypełnienia
    )
end

-- Funkcja do włączania/wyłączania interfejsu UI
function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    local vehicleFuelData = getElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:fuel') or {}
    data.vehicleCount = vehicleFuelData.count
    data.vehicleTank = vehicleFuelData.tank

    eventCallback('onClientRender', root, renderUI)
end
addEvent('toggleBatteryUI', true)
addEventHandler('toggleBatteryUI', resourceRoot, toggleUI)