--if getElementData(localPlayer, 'player:sid') ~= 1 then return end

sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.8
cache = {

    word = nil,
    price = nil,
    typeO = nil,

    alphaAnimation = 0,

}

function addCommas(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function renderUI()
	dxDrawImage(sx - 354/zoom, sy/2 - 58/zoom, 325/zoom, 116/zoom, 'data/background.png', 0, 0, 0, tocolor(255, 255, 255, 255*cache.alphaAnimation), false)
    
	dxDrawImage(sx - 246/zoom, sy/2 - 52/zoom, 21/zoom, 21/zoom, 'data/keyboard_icon.png', 0, 0, 0, tocolor(255, 255, 255, 255*cache.alphaAnimation), false)
	dxDrawText('Szybkie palce', sx - 220/zoom, sy/2 - 40.5/zoom, nil, nil, tocolor(46, 117, 111, 255*cache.alphaAnimation), 1, exports['since-fonts']:getFont('Inter-Bold', 9/zoom), 'left', 'center')
    
	dxDrawText('Przepisz podany poniżej tekst', sx - 354/zoom + (325/zoom / 2), sy/2 - 31/zoom, nil, nil, tocolor(255, 255, 255, 255*cache.alphaAnimation), 1, exports['since-fonts']:getFont('Inter-Medium', 7/zoom), 'center', 'top')
    
	dxDrawImage(sx - 241/zoom, sy/2 - 10/zoom, 100/zoom, 24/zoom, 'data/text_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255*cache.alphaAnimation), false)
	dxDrawText(cache.word, sx - 241/zoom + 50/zoom, sy/2 + 1/zoom, nil, nil, tocolor(46, 117, 111, 255*cache.alphaAnimation), 1, exports['since-fonts']:getFont('Inter-SemiBold', 11/zoom), 'center', 'center')

	dxDrawText('Aby udzielić odpowiedzi i zgarnąć '..(cache.typeO == 1 and '#2E756F' or '#47b3ff')..''..addCommas(cache.price)..' '..(cache.typeO == 1 and '$' or 'SRP')..'#ffffff wpisz\n#2E756F/odp '..cache.word, sx - 354/zoom + (325/zoom / 2), sy/2 + 26/zoom, nil, nil, tocolor(255, 255, 255, 255*cache.alphaAnimation), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'center', 'top', false, false, false, true)
end

addEvent('onServerSendData:words', true)
addEventHandler('onServerSendData:words', resourceRoot, function(type, word, price, typeO)
    if type == 'create' then
        cache.word = word
        cache.price = price
        cache.typeO = typeO

        addEventHandler('onClientRender', root, renderUI)
    
        animate(cache.alphaAnimation, 1, 1, 500, function(value)
            cache.alphaAnimation = value
        end)
    else
        animate(cache.alphaAnimation, 0, 1, 500, function(value)
            cache.alphaAnimation = value
        end, function()
            cache.word = nil
            cache.price = nil
            cache.typeO = nil

            removeEventHandler('onClientRender', root, renderUI)
        end)
    end
end)