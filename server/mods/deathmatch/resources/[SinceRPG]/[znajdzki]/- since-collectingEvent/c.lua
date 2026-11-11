local main = {}
local boardPositions = {
    {1491.50, -1721.33, 13.53, -0.00, 0.00, 0}
}

function reloadRenderTarget(object)
    if not isElement(object) then return end
    if not main['renderTargets'][object] then
        main['renderTargets'][object] = dxCreateRenderTarget(512, 324, true)
    end
    if not main['shaders'][object] then
        main['shaders'][object] = dxCreateShader('files/shaders/shader.fx')
    end
    if not main['avatarMask'] then
        main['avatarMask'] = dxCreateTexture('files/images/avatar_mask.png')
    end
    dxSetRenderTarget(main['renderTargets'][object], true)
        dxDrawImage(0, 0, 512, 324, 'files/images/bg.png', 0, 0, 0, tocolor(255, 255, 255, 255))

        local data = main['data'][2]
        local avatar = data and exports['since-avatars']:getPlayerCircleAvatar(data.uid) or exports['since-avatars']:drawNoAvatar()
        local nick = data and data.nick or 'Brak'
        local time = data and convertDate(data.collectingEventDate) or 'Brak informacji'
        dxDrawImage(50, 60, 88, 88, avatar, 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(15, 25, 158, 158, 'files/images/top2_avatar.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(6+158/2, 138, 18, 18, 'files/images/top2.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText(nick, 15+158/2, 170, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13), 'center', 'center')
        dxDrawText(time, 15+158/2, 190, nil, nil, tocolor(255, 175, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'center')

        local data = main['data'][1] 
        local avatar = data and exports['since-avatars']:getPlayerCircleAvatar(data.uid) or exports['since-avatars']:drawNoAvatar()
        local nick = data and data.nick or 'Brak'
        local time = data and convertDate(data.collectingEventDate) or 'Brak informacji'
        dxDrawImage(256-65, 30, 130, 130, avatar, 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(256-101, 5, 202, 192, 'files/images/top1_avatar.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(256-12, 148, 24, 24, 'files/images/top1.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText(nick, 256, 190, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15), 'center', 'center')
        dxDrawText(time, 256, 212, nil, nil, tocolor(255, 175, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'center')

        local data = main['data'][3]
        local avatar = data and exports['since-avatars']:getPlayerCircleAvatar(data.uid) or exports['since-avatars']:drawNoAvatar()
        local nick = data and data.nick or 'Brak'
        local time = data and convertDate(data.collectingEventDate) or 'Brak informacji'
        dxDrawImage(512-138, 60, 88, 88, avatar, 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(512-15-158, 25, 158, 158, 'files/images/top3_avatar.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(512-24-158/2, 138, 18, 18, 'files/images/top3.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText(nick, 512-15-158/2, 170, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 13), 'center', 'center')
        dxDrawText(time, 512-15-158/2, 190, nil, nil, tocolor(255, 175, 0, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'center')

        dxDrawImage(47, 229, 418, 3, 'files/images/line.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        local textWidth = dxGetTextWidth('Event halloweenowy', 1, exports['since-fonts']:getFont('Inter-ExtraBold', 15))
        dxDrawText('Event halloweenowy', 256, 253, nil, nil, tocolor(255, 175, 0, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15), 'center', 'center')
        --dxDrawImage(238+textWidth/2+7, 244, 18, 18, 'files/images/egg_icon.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText('Zbierz wszystkie '..#positions..' dyń i otrzymaj unikatowe nagrody!', 256, 280, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'center')
        dxDrawText('W puli nagród znajdziesz: #68D65EwPLN#FFFFFF, #FFC700Unikalne pojazdy#ffffff oraz #FFC700Gotówkę#ffffff', 256, 305, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'center', false, false, false, true)

    --    dxDrawRectangle(0, 0, 512, 324, tocolor(0, 0, 0, 155))
    --    dxDrawText('Start 20:00', 256-1, 162-1, nil, nil, tocolor(0, 0, 0, 155), 1, exports['since-fonts']:getFont('Inter-Black', 55), 'center', 'center')
    --    dxDrawText('Start 20:00', 256, 162, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Black', 55), 'center', 'center')

    dxSetRenderTarget()
    dxSetShaderValue(main['shaders'][object], "sPicTexture", main['renderTargets'][object])
    engineApplyShaderToWorldTexture(main['shaders'][object], "nf_blackbrd", object)
    if main['avatarMask'] then
        if isElement(main['avatarMask']) then
            destroyElement(main['avatarMask'])
        end
        main['avatarMask'] = nil
    end
end

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if getElementType(source) == 'object' and getElementModel(source) == 3077 then
        createBoard(source)
    end
end)

addEventHandler('onClientElementStreamOut', resourceRoot, function()
    if getElementType(source) == 'object' and getElementModel(source) == 3077 then
        destroyBoard(source)
    end
end)

addEventHandler('onClientRestore', root, function()
    triggerServerEvent('event', resourceRoot, 'loadData')
end)

function createBoard(object)
    if not isElement(object) then return end
    if not main['renderTargets'][object] then
        main['renderTargets'][object] = dxCreateRenderTarget(512, 324, true)
    end
    if not main['shaders'][object] then
        main['shaders'][object] = dxCreateShader('files/shaders/shader.fx')
    end
    reloadRenderTarget(object)
    main['rendering'][object] = true
end

function destroyBoard(object)
    if not isElement(object) then return end
    if main['renderTargets'][object] then
        if isElement(main['renderTargets'][object]) then
            destroyElement(main['renderTargets'][object])
        end
        main['renderTargets'][object] = nil
    end
    if main['shaders'][object] then
        if isElement(main['shaders'][object]) then
            destroyElement(main['shaders'][object])
        end
        main['shaders'][object] = nil
    end
    main['rendering'][object] = nil
end

addEvent('event', true)
addEventHandler('event', resourceRoot, function(action, data)
    if action == 'loadData' then
        main['data'] = data or {}
        for i,object in ipairs(getElementsByType('object', resourceRoot)) do
            if getElementModel(object) == 3077 and isElementStreamedIn(object) and main['rendering'][object] then
                reloadRenderTarget(object)
            end
        end
    end
end)

local blips = {}
function show()
    if getElementData(localPlayer, 'player:admin') ~= 4 then return end
    if #blips > 0 then
        for i,v in ipairs(blips) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        blips = {}
        return
    end
    local tbl = {}
    for i,v in ipairs(positions) do
        local x,y,z = unpack(v)
        table.insert(blips, createBlip(x,y,z, 41, 2, 255, 0, 0, 255, 0, 99999))
    end
end
addCommandHandler('znajdzki.show', show)

function loadScript()
    engineReplaceModel(engineLoadDFF('files/models/jajko.dff', 1279), 1279)
    main['renderTargets'] = {}
    main['shaders'] = {}
    main['data'] = {}
    main['rendering'] = {}
    for i,v in ipairs(boardPositions) do
        local x, y, z, rx, ry, rz = v[1], v[2], v[3]-1, v[4], v[5], v[6]
        local object = createObject(3077, x, y, z, rx, ry, rz)
    end
    triggerServerEvent('event', resourceRoot, 'loadData')
    setTimer(function()
        triggerServerEvent('event', resourceRoot, 'loadData')
    end, 60000, 0)
end
addEventHandler('onClientResourceStart', resourceRoot, loadScript)