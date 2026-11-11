--[[
    cloudyMTA Color System
    Centralna paleta kolorystyczna dla całego serwera
]]

cloudyMTA = cloudyMTA or {}
cloudyMTA.colors = {
    -- Główny akcent
    primary = {46, 117, 111},           -- #2E756F (Turkusowa zieleń)
    primaryHex = "#2E756F",
    
    -- Ciemne tło
    background = {16, 23, 25},          -- #101719 (Bardzo ciemny grafit)
    backgroundHex = "#101719",
    
    -- Panele i karty
    panel = {25, 36, 38},               -- #192426 (Grafitowo-zielony)
    panelHex = "#192426",
    
    -- Jaśniejszy akcent
    accent = {67, 143, 135},            -- #438F87 (Jasny turkus)
    accentHex = "#438F87",
    
    -- Tekst główny
    text = {241, 245, 244},             -- #F1F5F4 (Jasna biel)
    textHex = "#F1F5F4",
    
    -- Tekst dodatkowy
    textSecondary = {145, 163, 160},    -- #91A3A0 (Stonowana szarość)
    textSecondaryHex = "#91A3A0",
}

-- Funkcje pomocnicze
function cloudyMTA.getColor(name, alpha)
    local color = cloudyMTA.colors[name]
    if not color then return {255, 255, 255} end
    
    if type(alpha) == "number" then
        return {color[1], color[2], color[3], alpha}
    end
    return color
end

function cloudyMTA.getColorHex(name)
    return cloudyMTA.colors[name .. "Hex"] or "#FFFFFF"
end

function cloudyMTA.toColor(name, alpha)
    local c = cloudyMTA.getColor(name, alpha or 255)
    return tocolor(c[1], c[2], c[3], c[4] or 255)
end

-- Eksport funkcji dla innych zasobów
function getCloudyColor(name, alpha)
    return cloudyMTA.getColor(name, alpha)
end

function getCloudyColorHex(name)
    return cloudyMTA.getColorHex(name)
end

function getCloudyToColor(name, alpha)
    return cloudyMTA.toColor(name, alpha)
end

-- Kompatybilność wsteczna - kolorystyka dla różnych elementów UI
cloudyMTA.ui = {
    success = {67, 143, 135},       -- Akcent dla sukcesu
    error = {229, 82, 82},          -- Czerwony dla błędów
    warning = {229, 151, 35},       -- Pomarańczowy dla ostrzeżeń
    info = {46, 117, 111},          -- Główny kolor dla informacji
}

return cloudyMTA
