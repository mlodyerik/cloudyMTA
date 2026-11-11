local colors = {
    [1] = {255,215,0},
    [2] = {66,164,255},
}

function render()
    local playerData = getElementData(localPlayer, 'player:settings') or {}

    if playerData['showAnnouncements'] then 
        return 
    end

    if not getElementData(localPlayer, 'player:spawn') then 
        return 
    end

    local anim = main['anim'][1]
    local r,g,b = unpack(colors[main['data'].color])

    exports['since-blur']:dxDrawBlur(sx/2-380/zoom, 20/zoom, 760/zoom, 100/zoom, main['textures']['bg_mask'], anim)
    dxDrawImage(sx/2-380/zoom, 20/zoom, 760/zoom, 100/zoom, main['textures']['bg2'], 0,0,0, tocolor(255,255,255,anim))
    dxDrawImage(sx/2-380/zoom, 20/zoom, 760/zoom, 100/zoom, main['textures']['bg'], 0,0,0, tocolor(r,g,b,(anim/255)*200))

    dxDrawImage(sx/2-370/zoom, 30/zoom, 80/zoom, 80/zoom, main['data'].avatar, 0,0,0, tocolor(255,255,255,anim))
    dxDrawImage(sx/2-370/zoom, 30/zoom, 80/zoom, 80/zoom, main['textures']['avatar_frame'], 0,0,0, tocolor(r,g,b,anim))

    local textWidth = dxGetTextWidth(main['data'].nick, 1, main['fonts'][1])
    dxDrawText(main['data'].nick, sx/2-283/zoom, 30/zoom, nil, nil, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'top')

    local textWidth2 = dxGetTextWidth(main['data'].id, 1, main['fonts'][2]) - 6/zoom
    dxDrawRoundedRectangle(sx/2-283/zoom+5/zoom+textWidth, 33/zoom, textWidth2+30/zoom, 20/zoom, 10/zoom, tocolor(r, g, b, (anim/255)*100))

    dxDrawText(main['data'].id, sx/2-283/zoom+5/zoom+textWidth, 36/zoom, sx/2-283/zoom+5/zoom+textWidth+textWidth2+30/zoom, 30/zoom+20/zoom, tocolor(255,255,255,anim), 1, main['fonts'][2], 'center', 'center')

    for i=1,#main['data'].text do
        dxDrawText(main['data'].text[i], sx/2-278/zoom, 65/zoom+((i-1)*(17/zoom)), nil, nil, tocolor(255,255,255,anim), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')
    end

    dxDrawText(main['data'].color==2 and 'Ogłoszenie Diamond' or 'Ogłoszenie Premium', sx/2+370/zoom, 110/zoom, nil, nil, tocolor(125,125,125,anim), 1, main['fonts'][3], 'right', 'bottom')
end

function createTextures()
    main['anim'] = {0,0}
    main['textures'] = {}
    for i,v in ipairs({'bg','bg2','bg_mask','avatar_frame'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Black', 10/zoom),
		[3] = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
	}
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
end

function turnPanel(state, info)
    if main['block'] then return end
    if state then
        main['block'] = true
        createTextures()
        main['data'] = info
        main['data'].avatar = exports['since-avatars']:getPlayerCircleAvatar(info.sid)
        main['data'].text = wordWrap(info.text, 650/zoom, 1, main['fonts'][3], false)
        addEventHandler('onClientRender', root, render)
        animate(0, 255, 2, 500, function(value)
            main['anim'][1] = value
        end, function()
            main['block'] = nil
        end)
    else
        main['block'] = true
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            destroyTextures()
            main['block'] = nil
        end)
    end
end

addEvent('since-ads:loadAd', true)
addEventHandler('since-ads:loadAd', resourceRoot, function(info)
    if not info then return end
    turnPanel(true, info)
    setTimer(function()
        turnPanel(false)
   end, 8000, 1)
end)
getResourceName(getThisResource(), true, 742599273); if true then return end