local data = {

    items = {},
    animPos = 0,
    tickCount = getTickCount(),

}

local maskRT = nil
local maskShader = nil

function renderUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 522/zoom, sy/2 - 111/zoom, 1044/zoom, 222/zoom, textures.mask)
	dxDrawImage(sx/2 - 522/zoom, sy/2 - 111/zoom, 1044/zoom, 222/zoom, 'data/bg.png')
	dxDrawText('Otwierania boxa', sx/2, sy/2 - 81/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'bottom')

    local color = boxList[data.actualBox].color
    local colorToHex = RGBTOHEX(color[1], color[2], color[3])
	dxDrawText('Otwierasz '..colorToHex..''..data.actualBox, sx/2, sy/2 - 81/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)

    local items = boxList[data.actualBox].items
    local w, h = 80/zoom, 80/zoom
    
    dxDrawText('Możliwe nagrody', sx/2 , sy/2 + 145/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom', false, false, false, true)
    dxDrawText('Możliwe nagrody', sx/2, sy/2 + 145/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), 'center', 'bottom', false, false, false, true)

    local offset = 0
    for i, item in ipairs(items) do
        local color = RGBTOHEX(getColorFromPercent(item.rareLevel))

        local values = item.value

        if type(values) == 'table' then
            values = formatNumber(values.min)..' - '..formatNumber(values.max)
        else
            values = exports['since-vehiclenames']:getVehicleName(values)
        end

        local chance = string.format('%.2f', item.chance)

        local text = i..'. '..item.name..' ('..values..')\n'..color..''..getRareName(item.rareLevel)..''..color..''..' ('..chance..'%)'

        dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), sx/2  + 1, sy/2 + 145/zoom + offset  + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)
        dxDrawText(text, sx/2, sy/2 + 145/zoom + offset, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'top', false, false, false, true)

        offset = offset + 40/zoom
    end

    if data.tick then
        dxDrawText('Panel zamknie się za '..(string.format('%.2f', (data.tick-getTickCount())/1000))..' sek.', sx/2 + 1, sy/2 - 125/zoom + 1, nil, nil, tocolor(0, 0, 0, 125), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'bottom', false, false, false, true)
        dxDrawText('Panel zamknie się za '..(string.format('%.2f', (data.tick-getTickCount())/1000))..' sek.', sx/2, sy/2 - 125/zoom, nil, nil, tocolor(241, 245, 244, 200), 1, exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom), 'center', 'bottom', false, false, false, true)
    end

    if data.tickCount < getTickCount() then
        refreshRoll()
        data.tickCount = getTickCount() + 10
    end

    dxDrawImage(sx/2 - 502/zoom, sy/2 - 50/zoom, 1004/zoom, 140/zoom, maskShader)
    dxDrawImage(sx/2 - 502/zoom, sy/2 - 63/zoom, 1004/zoom, 166/zoom, 'data/lines.png')
end

function refreshRoll()
    dxSetRenderTarget(maskRT, true)
        dxSetBlendMode( 'add' )
            dxDrawImageSection(0, 0, 1004, 140, 140 + data.animPos, 0, 1004, 140, renderTarget)
        dxSetBlendMode( 'blend' )
    dxSetRenderTarget()
end

function createOpening(caseType, items, rnd)
    if data.block then return end
    if not caseType then return end
    if isEventHandlerAdded('onClientRender', root, renderUI) then return end
    if not boxList[caseType] then return end

    if not renderTarget then
        renderTarget = dxCreateRenderTarget(10000, 140, true)
    end

    if not maskRT then
        maskRT = dxCreateRenderTarget(1004, 140, true)
        maskShader = dxCreateShader('data/shader.fx')
        dxSetShaderValue(maskShader, "sPicTexture", maskRT)
        dxSetShaderValue(maskShader, "sMaskTexture", textures.rollMask)
    end
    
    data.block = true
    data.actualBox = caseType
    data.animPos = 0
    data.items = items
    dxSetRenderTarget(renderTarget, true)
    dxSetBlendMode('blend')
    local offset = 0

    for i, v in pairs(data.items) do
        local desc = v.value

        if v.name == 'Pojazd' then
            desc = exports['since-vehiclenames']:getVehicleName(desc)
        elseif v.name == 'Gotówka' then
            desc = '$ ' .. formatNumber(desc)
        end

        local r, g, b = getColorFromPercent(v.item.rareLevel)

        dxDrawImage(offset, 0, 140, 140, 'data/item_bg.png', 0, 0, 0, tocolor(r, g, b, 255))
        dxDrawImage(offset + 40, 40, 60, 60, v.item.icon, 0, 0, 0, tocolor(r, g, b, 160))
        dxDrawText(v.item.name, offset + 70, 70, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', string.len(v.item.name) > 9 and 10 or 14), 'center', 'bottom', false, false, false, true)
        dxDrawText(desc, offset + 70, 70, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 9), 'center', 'top', false, false, false, true)

        offset = offset + 140 + 2
    end
    dxSetBlendMode('blend')
    dxSetRenderTarget()

    addEventHandler('onClientRender', root, renderUI)
    
    animate(0, rnd*142, 'OutQuad', 8000, function(value)
        data.animPos = value
    end, function()
        -- triggerServerEvent('giveLootBoxReward', resourceRoot, data.items[rnd+5].name, data.items[rnd+5].value)

        data.tick = getTickCount() + 5000

        setTimer(function()
            removeEventHandler('onClientRender', root, renderUI)
            data.tick = nil

            if isElement(maskRT) then
                destroyElement(maskRT)
            end
            maskRT = nil

            if isElement(renderTarget) then
                destroyElement(renderTarget)
            end
            renderTarget = nil

            if isElement(maskShader) then
                destroyElement(maskShader)
            end
            maskShader = nil
            data.block = nil
        end, 5000, 1)
    end)

    return true
end

addEvent('createOpening', true)
addEventHandler('createOpening', resourceRoot, createOpening)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if isElement(renderTarget) then
        destroyElement(renderTarget)
    end

    if isElement(maskShader) then
        destroyElement(maskShader)
    end

    if isElement(maskRT) then
        destroyElement(maskRT)
    end

    for k,v in pairs(textures) do
        if isElement(v) then
            destroyElement(v)
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    exports['since-inventory']:loadBoxDescription()
end)
getResourceName(getThisResource(), true, 283667289); if true then return end