local function renderCard(x, y, title, value)
    local w = dxGetTextWidth((#title > #value) and title or value, 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)) + 20/zoom
    local h = dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom)) + 13/zoom

    dxDrawImage(x, y, w, h, 'data/images/element-bg.png')
    dxDrawText(title, x + 10/zoom, y + 16/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center')
    dxDrawText(value, x + 10/zoom, y + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)), nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')

    return w
end

local function formatTime(minutes)
    local hours = math.floor(minutes / 60)
    local minutes = minutes - hours * 60

    return hours.."h "..minutes.."m"
end

local function addCommas(n)
    return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):gsub(",(%-?)$", "%1"):reverse()
end

Panel.pages.renderInformationPage = function()
    local x, y = sx/2-942/zoom/2 + 249/zoom, sy/2-500/zoom/2 + 47/zoom
    local padding = 10/zoom

    if (getElementData(localPlayer, "player:faction") == "SAPD") then
        local w = renderCard(x + padding, y + padding, "Frakcja", exports['since-factions-new']:getFactionData(getElementData(localPlayer, 'player:faction')).fullName)
        local w2 = renderCard(x + padding + w + 10/zoom, y + padding, "Ilość członków", ""..(Panel.data.mainData and #Panel.data.mainData or 0).."")
        local w3 = renderCard(x + padding + w + w2 + 20/zoom, y + padding, "Łączny przepracowany czas", formatTime((Panel.data.minutes or 0)))
        local w4 = renderCard(x + padding, y + padding + 50/zoom + padding, "Liczba łącznych aresztów", ""..(#(Panel.data.jail or {}) or 0).."")
        local w5 = renderCard(x + padding + w4 + 10/zoom, y + padding + 50/zoom + padding, "Łączna kwota mandatów", "$"..addCommas(Panel.data.mandates or 0))
    elseif (getElementData(localPlayer, "player:faction") == "SARA") then
        local w = renderCard(x + padding, y + padding, "Frakcja", exports['since-factions-new']:getFactionData(getElementData(localPlayer, 'player:faction')).fullName)
        local w2 = renderCard(x + padding + w + 10/zoom, y + padding, "Ilość członków", ""..(Panel.data.mainData and #Panel.data.mainData or 0).."")
        local w3 = renderCard(x + padding + w + w2 + 20/zoom, y + padding, "Ilość pojazdów na parkingu", ""..(#(Panel.data.policeParking or {}) or 0).."")
        local w4 = renderCard(x + padding, y + padding + 50/zoom + padding, "Łączna kwota pojazdów na parkingu", "$"..addCommas(Panel.data.parkingMoney or 0))
    end
end