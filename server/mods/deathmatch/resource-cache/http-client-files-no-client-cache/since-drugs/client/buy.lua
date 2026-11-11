function renderBuyGui()
    dxDrawImage(sx/2-300/zoom/2, sy/2-280/zoom/2, 300/zoom, 280/zoom, drugs.textures['bg'])
    dxDrawText('Wytwórnia narkotyków', sx/2-300/zoom/2 + 15/zoom, sy/2-280/zoom/2 + 25/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), 'left', 'center')
end

addEvent('onClientOpenDrugsWindowBuy', true)
addEventHandler('onClientOpenDrugsWindowBuy', resourceRoot, function ()
    createTextures({
        ['bg'] = 'data/images/buy/bg.png'
    })

    addEventHandler('onClientRender', root, renderBuyGui)
    showCursor(true)
end)