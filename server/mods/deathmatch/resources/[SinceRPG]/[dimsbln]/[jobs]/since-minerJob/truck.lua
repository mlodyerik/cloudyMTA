local text = [[Aby wywieźć węgiel wybierz poniżej ilość którą chcesz sprzedać
w skupie a następnie wypożycz ciężarówkę. Po wypożyczeniu 
ciężarówki na mapie pojawi się punkt, do którego należy
zawieźć surowiec.]]

local scrollbar = nil
local wywozMarker = nil
local wywozData = nil

function renderWywozUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 199/zoom, sy/2 - 225/zoom, 398/zoom, 450/zoom, mask)
	dxDrawImage(sx/2 - 199/zoom, sy/2 - 225/zoom, 398/zoom, 450/zoom, 'data/bg.png')
	dxDrawImage(sx/2 - 184/zoom, sy/2 - 164/zoom, 368/zoom, 2/zoom, 'data/line.png')

    local isIn = isMouseInPosition(sx/2 - 186/zoom, sy/2 + 135/zoom, 372/zoom, 35/zoom)
	dxDrawImage(sx/2 - 186/zoom, sy/2 + 135/zoom, 372/zoom, 35/zoom, 'data/button_wywoz.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
	dxDrawText('Wynajmij ciężarówkę i wywieź surowiec', sx/2, sy/2 + 152/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')
    
    local isIn = isMouseInPosition(sx/2 - 186/zoom, sy/2 + 176/zoom, 372/zoom, 35/zoom)
	dxDrawImage(sx/2 - 186/zoom, sy/2 + 176/zoom, 372/zoom, 35/zoom, 'data/button_close.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
	dxDrawText('Zamknij panel', sx/2, sy/2 + 193/zoom, nil, nil, tocolor(255, 255, 255, isIn and 200 or 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'center', 'center')

	dxDrawText('Wywóz surowca', sx/2, sy/2 - 130/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
	dxDrawText(text, sx/2, sy/2 - 130/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top')

	dxDrawText('Wynajem ciężarówki', sx/2, sy/2 - 7/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
	dxDrawText('Koszt wynajęcia ciężarówki: #68EB5D$ 5 000', sx/2, sy/2 - 7/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top', false, false, false, true)
	dxDrawText('Magazyn górniczy', sx/2, sy/2 - 191/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'bottom')
	dxDrawText('Wywóz surowców do skupu', sx/2, sy/2 - 191/zoom, nil, nil, tocolor(128, 241, 118, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top')
	dxDrawText('Wybierz ilość węgla, którą chcesz sprzedać', sx/2, sy/2 + 62/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'bottom')
    
    local value = (magazineCoal * exports['since-scrollbar']:getScrollProgress(scrollbar))/100
	dxDrawText('Wybrana ilość: #68EB5D'..string.format('%.2f', value)..' kg / '..magazineCoal..' kg', sx/2, sy/2 + 90/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)
end

function createWywoz()
    wywozMarker = createMarker(wywozPos[1], wywozPos[2], wywozPos[3], 'cylinder', 3, 125, 255, 125, 55)
    setElementData(wywozMarker, 'marker:title', 'Skup węgla')
    setElementData(wywozMarker, 'marker:desc', 'Sprzedaj swój węgiel')
    setElementData(wywozMarker, 'marker:icon', 'default')
    createBlipAttachedTo(wywozMarker, 41, 2, 255, 255, 255, 255, 0, 999999)

    addEventHandler('onClientMarkerHit', wywozMarker, function(el, md)
        if el ~= localPlayer or not md then
            return
        end

        destroyElement(wywozMarker)
        wywozMarker = nil

        triggerServerEvent('endWywoz', resourceRoot)
    end)
end

function onClickTruck(btn, state)
    if (btn == 'left' and state == 'down') then
        if isMouseInPosition(sx/2 - 186/zoom, sy/2 + 176/zoom, 372/zoom, 35/zoom) then
            toggleUI(false)
        end

        if isMouseInPosition(sx/2 - 186/zoom, sy/2 + 135/zoom, 372/zoom, 35/zoom) then
            local value = (magazineCoal * exports['since-scrollbar']:getScrollProgress(scrollbar))/100

            if value < 50 then
                return exports['since-notifications']:sendNotification('error', 'Minimalna ilość węgla, którą możesz wywozić to 50 kg')
            end

            if getPlayerMoney(localPlayer) < 5000 then
                return exports['since-notifications']:sendNotification('error', 'Nie posiadasz pieniędzy na wypożyczenie ciężarówki')
            end

            triggerServerEvent('createWywoz', resourceRoot, wywozData.resp, string.format('%.2f', value))
            createWywoz()
            toggleUI(false)
        end
    end
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    triggerServerEvent('getCoal', resourceRoot)
    eventCallback('onClientRender', root, renderWywozUI)
    eventCallback('onClientClick', root, onClickTruck)
    showCursor(visible)

    if visible then
        scrollbar = exports['since-scrollbar']:createScrollbar(sx/2 - 184/zoom, sy/2 + 72/zoom, 368/zoom, 8/zoom, {255, 255, 255}, true, 0)
    else
        if scrollbar then
            exports['since-scrollbar']:destroyScroll(scrollbar)
        end
    end
end

addEvent('endWywoz', true)
addEventHandler('endWywoz', root, function()
    if wywozMarker then destroyElement(wywozMarker) end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if scrollbar then
        exports['since-scrollbar']:destroyScroll(scrollbar)
    end

    if wywozMarker then destroyElement(wywozMarker) end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    for i, v in ipairs(wywozy) do
        local marker = createMarker(v.pos[1], v.pos[2], v.pos[3] - 0.5, 'cylinder', 2, 125, 255, 125, 55)
        setElementData(marker, 'marker:title', 'Magazyn górniczy')
        setElementData(marker, 'marker:desc', 'Wywóz węgla do skupu')
        setElementData(marker, 'marker:icon', 'default')
        setElementData(marker, 'marker:miner', v)

        addEventHandler('onClientMarkerHit', marker, function(el, md)
            if el ~= localPlayer or not md then
                return
            end

            wywozData = getElementData(source, 'marker:miner')
            toggleUI(true)
        end)

        addEventHandler('onClientMarkerLeave', marker, function(el, md)
            if el ~= localPlayer or not md then
                return
            end

            toggleUI(false)
        end)
    end
end)
getResourceName(getThisResource(), true, 940128129); if true then return end