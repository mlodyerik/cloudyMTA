roulette = {}

roulette.lastBets = {
    {
        number = 3,
        color = 'red'
    },
    {
        number = 11,
        color = 'black'
    },
    {
        number = 3,
        color = 'red'
    },
    {
        number = 11,
        color = 'black'
    },
    {
        number = 3,
        color = 'red'
    },
    {
        number = 11,
        color = 'black'
    },
}

function roulette.render()
    dxDrawImage(sx/2-882/zoom/2, sy/2-490/zoom/2, 882/zoom, 490/zoom, Casino.textures['bg'])
    dxDrawText("Losowanie za", sx/2, sy/2-490/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'center', 'center')
    dxDrawText("13,64s", sx/2, sy/2-490/zoom/2 + 25/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom)), nil, nil, tocolor(55, 255, 5), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'center', 'center')

    dxDrawImage(sx/2-785/zoom/2, sy/2-490/zoom/2 + 75/zoom, 785/zoom, 98/zoom, Casino.textures['roulette-bg'])
    -- dxDrawRectangle(sx/2-230/zoom/2, sy/2-490/zoom/2 + 75/zoom + 98/zoom + 10/zoom, 230/zoom, 40/zoom, tocolor(0, 0, 0, 255))

    local offset = 0
    local x = sx/2

    for i = 1, 6 do
        if (roulette.lastBets[i]) then
            dxDrawImage(x + offset, sy/2-490/zoom/2 + 75/zoom + 98/zoom + 10/zoom, 40/zoom, 40/zoom, Casino.textures[roulette.lastBets[i].color])

            offset = offset + 45/zoom
        end
    end

    -- x = x - offset/2 + iffs
end

addEvent('onClientOpenRoulette', true)
addEventHandler('onClientOpenRoulette', resourceRoot, function (bankMoney)
    Casino.CreateTextures({
        ['bg'] = 'data/images/bg.png',
        ['roulette-bg'] = 'data/images/roulette-bg.png',
        ['red'] = 'data/images/red.png',
        ['black'] = 'data/images/black.png',
        ['green'] = 'data/images/green.png',
    })

    addEventHandler('onClientRender', root, roulette.render)
end)