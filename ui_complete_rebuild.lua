-- cloudyMTA COMPLETE UI REBUILD
-- Funkcje pomocnicze dla nowych interfejsów

-- Rysowanie zaokrąglonych prostokątów
function dxDrawRoundedRectangle(x, y, w, h, radius, color, postGUI)
    -- Główny prostokąt
    dxDrawRectangle(x + radius, y, w - radius * 2, h, color, postGUI)
    dxDrawRectangle(x, y + radius, w, h - radius * 2, color, postGUI)
    
    -- Rogi (symulacja zaokrąglenia)
    dxDrawRectangle(x, y, radius, radius, color, postGUI)
    dxDrawRectangle(x + w - radius, y, radius, radius, color, postGUI)
    dxDrawRectangle(x, y + h - radius, radius, radius, color, postGUI)
    dxDrawRectangle(x + w - radius, y + h - radius, radius, radius, color, postGUI)
end

-- Rysowanie obramowania zaokrąglonego prostokąta
function dxDrawRectangleBorder(x, y, w, h, color, thickness, radius, postGUI)
    thickness = thickness or 2
    -- Górna krawędź
    dxDrawRectangle(x + radius, y, w - radius * 2, thickness, color, postGUI)
    -- Dolna krawędź
    dxDrawRectangle(x + radius, y + h - thickness, w - radius * 2, thickness, color, postGUI)
    -- Lewa krawędź
    dxDrawRectangle(x, y + radius, thickness, h - radius * 2, color, postGUI)
    -- Prawa krawędź
    dxDrawRectangle(x + w - thickness, y + radius, thickness, h - radius * 2, color, postGUI)
end

-- Rysowanie okręgu/koła
function dxDrawCircle(x, y, radius, startAngle, stopAngle, color, colorInner, segments, postGUI)
    segments = segments or 32
    local angleStep = (stopAngle - startAngle) / segments
    
    for i = 0, segments - 1 do
        local angle1 = math.rad(startAngle + i * angleStep)
        local angle2 = math.rad(startAngle + (i + 1) * angleStep)
        
        local x1 = x + math.cos(angle1) * radius
        local y1 = y + math.sin(angle1) * radius
        local x2 = x + math.cos(angle2) * radius
        local y2 = y + math.sin(angle2) * radius
        
        dxDrawLine(x1, y1, x2, y2, color or tocolor(255, 255, 255), 2, postGUI)
    end
end

-- cloudyMTA Paleta Kolorów
cloudyMTA = cloudyMTA or {}
cloudyMTA.colors = {
    primary = {46, 117, 111},       -- #2E756F
    accent = {67, 143, 135},        -- #438F87
    background = {16, 23, 25},      -- #101719
    panel = {25, 36, 38},           -- #192426
    text = {241, 245, 244},         -- #F1F5F4
    textSec = {145, 163, 160},      -- #91A3A0
}

function cloudyMTA.getColor(name, alpha)
    local c = cloudyMTA.colors[name] or cloudyMTA.colors.text
    return tocolor(c[1], c[2], c[3], alpha or 255)
end

