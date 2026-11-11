function renderTopMenu()
    dxDrawImage(sx/2-454/zoom/2, 30/zoom, 454/zoom, 83/zoom, "data/images/bg.png", 0, 0, 0, tocolor(241, 245, 244, 200))
    dxDrawText("Praca dorywcza Drwal!", sx/2, 30/zoom + 20/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), "center", "center")
    dxDrawText("Udaj się do celu sciąć drzewa", sx/2, 30/zoom + 20/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)), nil, nil, tocolor(145, 163, 160), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "center", "center")
    dxDrawText("Ścięte drzewa: #68D65E"..Job.info.trees.."/"..Job.info.maxTrees.."", sx/2, 30/zoom + 20/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom)) + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom)), nil, nil, tocolor(170, 170, 170), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), "center", "center", false, false, false, true)
end

addEvent('onClientStartJob', true)
addEventHandler('onClientStartJob', root, function()
    Job.info.trees = 0
    Job.info.maxTrees = 10
    addEventHandler("onClientRender", root, renderTopMenu)
    createPlayerTrees()
end)