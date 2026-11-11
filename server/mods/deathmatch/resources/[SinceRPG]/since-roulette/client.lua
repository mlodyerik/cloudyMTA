local positions = {
    {1966.39, 1029.56, 992.47, -0.00, 0.00, 268.03},
    {1966.15, 1021.19, 992.47, -0.00, 0.00, 337.28},
    {1966.46, 1014.21, 992.47, -0.00, 0.00, 187.82},
    {1966.57, 1005.98, 992.47, -0.00, 0.00, 346.05},
    {1969.54, 1006.28, 992.47, -0.00, 0.00, 102.61},
    {1969.59, 1014.13, 992.47, -0.00, 0.00, 91.33},
    {1969.54, 1021.83, 992.47, -0.00, 0.00, 155.25},
    {1969.47, 1029.81, 992.47, -0.00, 0.00, 4.85}
}

local sx, sy = guiGetScreenSize()
local sxh, syh, zoom = sx/2, sy/2, (sx < 2048 and math.min(2.2, 2048/sx) or 1)
local interface, roulette = {}, {}
roulette.position = 0
roulette.startPosition = 0
roulette.boxNumbers = {}
roulette.tick = getTickCount()
roulette.breakTime = 20
roulette.bets = { red = {}, green = {}, black = {} }
roulette.lastWins = {}

function renderInterface()
    dxDrawImage(sxh-441/zoom, syh-245/zoom, 882/zoom, 490/zoom, interface.textures.bg, 0, 0, 0, tocolor(255, 255, 255, 255))

    if (roulette.tick > getTickCount()) then
        local time = roulette.tick - getTickCount() 
        local seconds = (time % 60000) / 1000
        local seconds = string.format('%.2f', seconds)
        dxDrawText('Losowanie za', sxh, syh-238/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, interface.fonts[3], 'center', 'top', false, false, false, false, false)
        dxDrawText(seconds..'s', sxh, syh-216/zoom, nil, nil, tocolor(55, 255, 5, 255), 1, interface.fonts[4], 'center', 'top', false, false, false, false, false)
    else
        dxDrawText('Losowanie za', sxh, syh-238/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, interface.fonts[3], 'center', 'top', false, false, false, false, false)
        dxDrawText('0.00s', sxh, syh-216/zoom, nil, nil, tocolor(55, 255, 5, 255), 1, interface.fonts[4], 'center', 'top', false, false, false, false, false)
    end

    dxDrawImage(sxh-393/zoom, syh-193/zoom, 786/zoom, 98/zoom, interface.textures.selector, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sxh-380/zoom, syh-181/zoom, 760/zoom, 74/zoom, interface.rt, 0, 0, 0, tocolor(255, 255, 255, 255))

    local offset = -((#roulette.lastWins-1)*28/zoom+(#roulette.lastWins-1)*5/zoom)/2-(28/zoom)/2
    for i, v in ipairs(roulette.lastWins) do
        dxDrawImage(sxh+offset, syh-87/zoom, 28/zoom, 28/zoom, interface.textures[v[1]], 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText(v[2], sxh+offset, syh-87/zoom, sxh+offset+28/zoom, syh-87/zoom+28/zoom, tocolor(255, 255, 255, 255), 1, interface.fonts[2], 'center', 'center', false, false, false, false, false)
        offset = offset + 28/zoom + 5/zoom
    end

    dxDrawImage(sxh-168/zoom, syh-50/zoom, 336/zoom, 32/zoom, interface.textures.editbox, 0, 0, 0, tocolor(255, 255, 255, 255))

    local isIn = isMouseIn(sxh+65/zoom, syh-45/zoom, 48/zoom, 22/zoom) and 0.75 or 1
    dxDrawImage(sxh+65/zoom, syh-45/zoom, 48/zoom, 22/zoom, interface.textures.clearButton, 0, 0, 0, tocolor(255, 255, 255, 255 * isIn))
    dxDrawText('CLEAR', sxh+65/zoom, syh-45/zoom, sxh+65/zoom+48/zoom, syh-45/zoom+22/zoom, tocolor(255, 255, 255, 255 * isIn), 1, interface.fonts[7], 'center', 'center', false, false, false, false, false)

    local isIn = isMouseIn(sxh+116/zoom, syh-45/zoom, 22/zoom, 22/zoom) and 0.75 or 1
    dxDrawImage(sxh+116/zoom, syh-45/zoom, 22/zoom, 22/zoom, interface.textures.clearButton, 0, 0, 0, tocolor(255, 255, 255, 255 * isIn))
    dxDrawText('1/2', sxh+117/zoom, syh-45/zoom, sxh+117/zoom+22/zoom, syh-45/zoom+22/zoom, tocolor(255, 255, 255, 255 * isIn), 1, interface.fonts[7], 'center', 'center', false, false, false, false, false)

    local isIn = isMouseIn(sxh+141/zoom, syh-45/zoom, 22/zoom, 22/zoom) and 0.75 or 1
    dxDrawImage(sxh+141/zoom, syh-45/zoom, 22/zoom, 22/zoom, interface.textures.clearButton, 0, 0, 0, tocolor(255, 255, 255, 255 * isIn))
    dxDrawText('X2', sxh+142/zoom, syh-45/zoom, sxh+142/zoom+22/zoom, syh-45/zoom+22/zoom, tocolor(255, 255, 255, 255 * isIn), 1, interface.fonts[7], 'center', 'center', false, false, false, false, false)

    local isIn = isMouseIn(sxh-393/zoom, syh+8/zoom, 246/zoom, 46/zoom) and 0.75 or 1
    dxDrawImage(sxh-393/zoom, syh+8/zoom, 246/zoom, 46/zoom, interface.textures.redTable, 0, 0, 0, tocolor(255, 255, 255, 255 * isIn))
    dxDrawText('X2', sxh-270/zoom, syh+25/zoom, nil, nil, tocolor(255, 255, 255, 255 * isIn), 1, interface.fonts[5], 'center', 'center', false, false, false, false, false)
    dxDrawText('Postaw beta', sxh-270/zoom, syh+43/zoom, nil, nil, tocolor(255, 255, 255, 175 * isIn), 1, interface.fonts[6], 'center', 'center', false, false, false, false, false)
    dxDrawImage(sxh-393/zoom, syh+54/zoom, 246/zoom, 160/zoom, interface.textures.rows, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sxh-393/zoom, syh+54/zoom, 246/zoom, 160/zoom, interface.bets.red.rt, 0, 0, 0, tocolor(255, 255, 255, 255))

    local isIn = isMouseIn(sxh-123/zoom, syh+8/zoom, 246/zoom, 46/zoom) and 0.75 or 1
    dxDrawImage(sxh-123/zoom, syh+8/zoom, 246/zoom, 46/zoom, interface.textures.greenTable, 0, 0, 0, tocolor(255, 255, 255, 255 * isIn))
    dxDrawText('X14', sxh, syh+25/zoom, nil, nil, tocolor(255, 255, 255, 255 * isIn), 1, interface.fonts[5], 'center', 'center', false, false, false, false, false)
    dxDrawText('Postaw beta', sxh, syh+43/zoom, nil, nil, tocolor(255, 255, 255, 175 * isIn), 1, interface.fonts[6], 'center', 'center', false, false, false, false, false)
    dxDrawImage(sxh-123/zoom, syh+54/zoom, 246/zoom, 160/zoom, interface.textures.rows, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sxh-123/zoom, syh+54/zoom, 246/zoom, 160/zoom, interface.bets.green.rt, 0, 0, 0, tocolor(255, 255, 255, 255))

    local isIn = isMouseIn(sxh+147/zoom, syh+8/zoom, 246/zoom, 46/zoom) and 0.75 or 1
    dxDrawImage(sxh+147/zoom, syh+8/zoom, 246/zoom, 46/zoom, interface.textures.blackTable, 0, 0, 0, tocolor(255, 255, 255, 255 * isIn))
    dxDrawText('X2', sxh+270/zoom, syh+25/zoom, nil, nil, tocolor(255, 255, 255, 255 * isIn), 1, interface.fonts[5], 'center', 'center', false, false, false, false, false)
    dxDrawText('Postaw beta', sxh+270/zoom, syh+43/zoom, nil, nil, tocolor(255, 255, 255, 175 * isIn), 1, interface.fonts[6], 'center', 'center', false, false, false, false, false)
    dxDrawImage(sxh+147/zoom, syh+54/zoom, 246/zoom, 160/zoom, interface.textures.rows, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sxh+147/zoom, syh+54/zoom, 246/zoom, 160/zoom, interface.bets.black.rt, 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawText('$ #FFFFFF'..formatNumber(interface.money), sxh, syh+222/zoom, nil, nil, tocolor(55, 255, 5, 255), 1, interface.fonts[4], 'center', 'top', false, false, false, true, false)

    if interface.lastReload then
        if (interface.lastReload < getTickCount()) then
            reloadRenderTarget()
            interface.lastReload = getTickCount()+10
        end
    else
        interface.lastReload = getTickCount()+10
    end

    if interface.marker then
        local x, y, z = getElementPosition(interface.marker)
        local px, py, pz = getPedBonePosition(localPlayer, 6)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if (distance > 3) then
            destroyInterface()
        end
    end
end

function click(button, state)
    if (button ~= 'left' or state ~= 'down') then
        return false
    end
    if isMouseIn(sxh+65/zoom, syh-45/zoom, 48/zoom, 22/zoom) then
        local text = exports['since-gui']:getEditboxText(interface.editbox)
        if (#text == 0) then return false end
        exports['since-gui']:setEditboxText(interface.editbox, '')
    elseif isMouseIn(sxh+116/zoom, syh-45/zoom, 22/zoom, 22/zoom) then
        local text = exports['since-gui']:getEditboxText(interface.editbox)
        if (#text == 0) then return false end
        if (not tonumber(text)) then return false end
        if (tonumber(text) < 0) then return false end
        exports['since-gui']:setEditboxText(interface.editbox, tostring(math.floor(tonumber(text)/2)))
    elseif isMouseIn(sxh+141/zoom, syh-45/zoom, 22/zoom, 22/zoom) then
        local text = exports['since-gui']:getEditboxText(interface.editbox)
        if (#text == 0) then return false end
        if (not tonumber(text)) then return false end
        if (tonumber(text) < 0) then return false end
        exports['since-gui']:setEditboxText(interface.editbox, tostring(math.floor(tonumber(text)*2)))

    elseif isMouseIn(sxh-393/zoom, syh+8/zoom, 246/zoom, 46/zoom) then
        local text = exports['since-gui']:getEditboxText(interface.editbox)
        if (#text == 0) then return false end
        if (not tonumber(text)) then return false end
        if (tonumber(text) < 0) then return false end
        if interface.money < tonumber(text) then return false end
        if roulette.state then return false end
        triggerServerEvent('onPlayerRouletteBet', resourceRoot, 'red', tonumber(text))

    elseif isMouseIn(sxh-123/zoom, syh+8/zoom, 246/zoom, 46/zoom) then
        local text = exports['since-gui']:getEditboxText(interface.editbox)
        if (#text == 0) then return false end
        if (not tonumber(text)) then return false end
        if (tonumber(text) < 0) then return false end
        if roulette.state then return false end
        triggerServerEvent('onPlayerRouletteBet', resourceRoot, 'green', tonumber(text))

    elseif isMouseIn(sxh+147/zoom, syh+8/zoom, 246/zoom, 46/zoom) then
        local text = exports['since-gui']:getEditboxText(interface.editbox)
        if (#text == 0) then return false end
        if (not tonumber(text)) then return false end
        if (tonumber(text) < 0) then return false end
        if roulette.state then return false end
        triggerServerEvent('onPlayerRouletteBet', resourceRoot, 'black', tonumber(text))

    end
end

local id = 1
for k=1, 5 do
    for i=1, 14 do
        roulette.boxNumbers[id] = i == 14 and 'green' or i % 2 == 0 and 'black' or 'red'
        id = id + 1
    end
end

function reloadRenderTarget()
    dxSetRenderTarget(interface.rt, true)
        local offset = -roulette.position
        dxSetBlendMode('blend')
        local id = 1
        for k=1, 5 do
            for i=1, 14 do
                local texture = i == 14 and 'green' or i % 2 == 0 and 'black' or 'red'
                dxDrawImage(offset, 0, 74, 74, interface.textures[texture], 0, 0, 0, tocolor(255, 255, 255, 255))
                dxDrawText(i, offset, 0, offset+74, 74, tocolor(255, 255, 255, 255), 1, interface.fonts[1], 'center', 'center')
                offset = offset + 86
                id = id + 1
            end
        end
    dxSetRenderTarget()
end

function reloadBets()
    for i,v in pairs(interface.bets) do
        local offset = 0
        dxSetRenderTarget(v.rt, true)
            dxSetBlendMode('blend')
            dxSetBlendMode('overwrite')
            for k=1,4 do 
                local v = roulette.bets[i][k]
                if v then
                    local avatar = exports['since-avatars']:getPlayerAvatar(v[3], interface.textures.avatarMask)
                    dxDrawImage(9, 9 + offset, 30, 30, avatar, 0, 0, 0, tocolor(255, 255, 255, 255))
                    dxDrawText(v[2], 9 + 40, 24 + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8), 'left', 'bottom')
                    local activity = getPlayerActivity(v[1])
                    dxDrawText(activity[1]..activity[2], 9 + 40, 24 + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 7), 'left', 'top', false, false, false, true)
                    if v[6] then
                        dxDrawText('$ #FFFFFF'..formatNumber(v[4]), 209 + 30, 24 + offset, nil, nil, tocolor(55, 255, 5, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8), 'right', 'bottom', false, false, false, true, false)
                        if (v[6] == 'win') then
                            dxDrawText('+$ '..formatNumber(v[5]), 209 + 30, 24 + offset, nil, nil, tocolor(55, 255, 5, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8), 'right', 'top', false, false, false, true, false)
                        elseif (v[6] == 'lose') then
                            dxDrawText('-$ '..formatNumber(v[4]), 209 + 30, 24 + offset, nil, nil, tocolor(255, 55, 5, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8), 'right', 'top', false, false, false, true, false)
                        end
                    else
                        dxDrawText('$ #FFFFFF'..formatNumber(v[4]), 209 + 30, 24 + offset, nil, nil, tocolor(55, 255, 5, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 8), 'right', 'center', false, false, false, true, false)
                    end
                    offset = offset + 35
                end
            end
            dxSetBlendMode('blend')
        dxSetRenderTarget()
    end
end

function getPlayerActivity(player)
    local activity = 'Premium'
    local color = '#FFD700'
    if (not isElement(player)) then 
        return activity, color 
    end
    local admin = getElementData(player, 'player:admin')
    if admin then
        activity = exports['since-admins']:getRankName(admin)
        color = exports['since-admins']:getRankHex(admin)
    end
    return {color, activity}
end

function createInterface(marker)
    if isEventHandlerAdded('onClientRender', root, renderInterface) then
        return false
    end
    interface.textures = {}
    for i,v in ipairs({'bg', 'black', 'blackTable', 'clearButton', 'editbox', 'green', 'greenTable', 'red', 'redTable', 'moneyIcon', 'selector', 'xButton', 'rows', 'freeEditbox', 'avatarMask', 'mask'}) do
        if not interface.textures[v] and fileExists('assets/images/'..v..'.png') then
            interface.textures[v] = dxCreateTexture('assets/images/'..v..'.png')
        end
    end
    interface.fonts = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 27/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
        [3] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [4] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
        [5] = exports['since-fonts']:getFont('Inter-ExtraBold', 19/zoom),
        [6] = exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom),
        [7] = exports['since-fonts']:getFont('Inter-Bold', 8/zoom),
    }
    interface.rt = dxCreateRenderTarget(760, 74, true)
    interface.editbox = exports['since-gui']:createEditbox('Wprowadz kwote', sxh-168/zoom, syh-50/zoom, 230/zoom, 32/zoom, {255, 255, 255}, {
        alignX = 'left',
        paddingX = 30/zoom,
        caretColor = {255, 255, 255, 100},
        caretWidth = 1,
        font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
        image = interface.textures.freeEditbox,
        icon = interface.textures.moneyIcon,
        iconPadding = 8/zoom,
        placeholderColor = {155, 155, 155},
        specialCharacters = '.*[_].*',
        passworded = false,
        caretHeight = 18/zoom,
        textColor = {255, 255, 255, 255},
    })
    interface.money = 0
    interface.bets = {
        red = {
            rt = dxCreateRenderTarget(246, 160, true),
        },
        green = {
            rt = dxCreateRenderTarget(246, 160, true),
        },
        black = {
            rt = dxCreateRenderTarget(246, 160, true),
        }
    }
    reloadBets()
    triggerServerEvent('loadCasinoStats', resourceRoot)
    addEventHandler("onClientRender", root, renderInterface)    
    addEventHandler('onClientClick', root, click)
    interface.marker = marker

end

function destroyInterface()
    removeEventHandler('onClientRender', root, renderInterface)
    removeEventHandler('onClientClick', root, click)
    if interface.editbox then
        exports['since-gui']:destroyUIElement(interface.editbox)
    end
    for i,v in pairs(interface.textures) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    for i,v in pairs(interface.bets) do
        if isElement(v.rt) then
            destroyElement(v.rt)
        end
    end
    interface = {}
end

addEvent('loadCasinoStats', true)
addEventHandler('loadCasinoStats', resourceRoot, function(money)
    interface.money = money
end)

addEvent('onRouletteStart', true)
addEventHandler('onRouletteStart', resourceRoot, function(win, color)
    roulette.state = true
    animateRoulette((win-5) * 86)
end)

addEvent('onRouletteEnd', true)
addEventHandler('onRouletteEnd', resourceRoot, function()
    reloadRoulette()
    roulette.state = false
end)

addEvent('reloadRouletteBets', true)
addEventHandler('reloadRouletteBets', resourceRoot, function(table)
    if not isEventHandlerAdded('onClientRender', root, renderInterface) then return end
    roulette.bets = table
    reloadBets()
end)

addEvent('reloadRouletteLastWins', true)
addEventHandler('reloadRouletteLastWins', resourceRoot, function(table)
    if not isEventHandlerAdded('onClientRender', root, renderInterface) then return end
    roulette.lastWins = table
end)

function animateRoulette( roulettePosition )
    animate(roulette.position, roulette.startPosition + roulettePosition, 3, 7500, function(value)
        roulette.position = value
    end)
end

function reloadRoulette()
    animate(roulette.position, roulette.startPosition, 3, 500, function(value)
        roulette.position = value
    end)
    for i,v in pairs(roulette.bets) do roulette.bets[i] = {} end
    roulette.tick = getTickCount() + (roulette.breakTime * 1000)
end 

for i,v in ipairs(positions) do
    local marker = createMarker(v[1], v[2], v[3]-1, 'cylinder', 2, 55,255, 55, 55)
    setElementData(marker, 'marker:title', 'Ruletka')
	setElementData(marker, 'marker:desc', 'Pomnóz swoje pieniadze')
	setElementData(marker, 'marker:icon', 'default')
    setElementInterior(marker, 10)
    setElementDimension(marker, 0)
    local cuboid = createColSphere(v[1], v[2], v[3], 2)
    setElementInterior(cuboid, 10)
    setElementDimension(cuboid, 0)
    addEventHandler('onClientColShapeHit', cuboid, function(element, matchingDimension)
        if (element ~= localPlayer or not matchingDimension) then
            return false
        end
        createInterface(marker)
    end)
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if interface.editbox then
        exports['since-gui']:destroyUIElement(interface.editbox)
    end
end)