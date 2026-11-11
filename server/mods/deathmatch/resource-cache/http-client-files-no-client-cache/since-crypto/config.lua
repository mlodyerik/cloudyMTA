cryptoPrices = {

    ['bitcoin'] = {175000, 345000},
    ['ethereum'] = {85000, 165000},
    ['litecoin'] = {65000, 120000}

}

powerSupply = {

    { name = 'SilentiumPC Elementum 450W', power = 450, cost = 200000 },
    { name = 'SilentiumPC Elementum 550W', power = 550, cost = 340000 },
    { name = 'SilentiumPC Elementum 850W', power = 850, cost = 480000 },
    { name = 'SilentiumPC Elementum 1200W', power = 1200, cost = 720000 },
    { name = 'SilentiumPC Elementum 1600W', power = 1600, cost = 1000000 },

}

graphicsCard = {

    { name = 'Radeon RX 560', power = 350, cost = 400000 },
    { name = 'GeForce GTX 1060', power = 500, cost = 630000 },
    { name = 'GeForce RTX 2060', power = 700, cost = 950000 },
    { name = 'GeForce RTX 3060', power = 1000, cost = 1450000 },
    { name = 'GeForce RTX 4060', power = 1500, cost = 2000000 },

}

boosts = {

    { name = 'Automatyczne uruchomienie', desc = 'Po wejściu na serwer koparka automatycznie się uruchamia', data = 'autoTurner', cost = 500000 },
    { name = 'Lepszy drop', desc = 'Większe wartości wydobywane podczas kopania', data = 'betterDrop', cost = 320000 },
    { name = 'Wentylatory', desc = 'Zmniejsza temperatury zwiększając wydajnośc koparki', data = 'betterVents', cost = 500000 },
    { name = 'Dwie karty graficzne', desc = 'Zwiększa liczbe slotów na karty graficzne podnosząc wydajność', data = 'twoCards', cost = 10000000 },
    
}

cost = 1200000
srp = 500
markerPositions = {
    ['enter'] = {2110.70, -2055.02, 13.55},
}

function formatNumber(n)
    n = tonumber(n)
    if not n then return '0' end
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end
